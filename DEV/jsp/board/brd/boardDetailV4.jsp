<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root"/>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>

<script type="text/javascript">
    var sessionAuthLev="${sessionScope.loginInfo.sessionAuthLev}";
    var sessionUserId="${sessionScope.loginInfo.sessionUserId}";
    var NEW = "${boardDTO.NEW}";
    var screenType = "${boardDTO.screenType}";
    var templProjectID = "${boardDTO.templProjectID}";
    var projectType = "${boardDTO.projectType}";
    var projectCategory = "${boardDTO.projectCategory}";

    jQuery(document).ready(function() {
        fnGetBoardDetail();
    });

    function fnGetBoardDetail() {
        var url = "boardDetailData.do";
        var data = "BoardID=${boardDTO.boardID}&BoardMgtID=${boardDTO.boardMgtID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";

        fetch(url + "?" + data, {
            method: 'GET'
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            fnSetBoardDetail(data);
        })
        .catch(error => {
            console.error("Error fetching board details: " + error);
        });
    }

    function fnSetBoardDetail(data) {
        var resultMap = data.resultMap || {};
        var itemFiles = data.itemFiles || [];

        // 화면 텍스트 업데이트
        $("#boardMgtName_span").text(data.boardMgtName);
        $("#Subject_td").html(resultMap.Subject);
        $("#ProjectName_td").text(resultMap.ProjectName || "");
        $("#TD_WRITE_USER_NM").text(resultMap.WriteUserNM || "");
        $("#TD_REG_DT").text(resultMap.ModDT || "");
        $("#Content_div").html(resultMap.Content || "");

        // 폼 필드 업데이트
        $("#BoardID").val(resultMap.BoardID);
        $("#BoardMgtID").val(resultMap.BoardMgtID);
        $("#RegUserID").val(resultMap.RegUserID);
        $("#likeInfo").val(resultMap.LikeInfo);
        $("#category_val").val(resultMap.category);
        $("#project_val").val(resultMap.ProjectID);

        // 카테고리 및 공지사항(Notice)
        var showRow = false;
        var rowHtml = "";
        
        var hasCategory = (data.CategoryYN === 'Y' && resultMap.CategoryNM && resultMap.CategoryNM !== "");
        var hasNotice = (resultMap.ClosingDT && resultMap.ClosingDT !== "");

        if (hasCategory && hasNotice) {
            // Case 1: Both Category and Notice
            rowHtml += '<th style="height:20px;">${menu.LN00033}</th>';
            rowHtml += '<td class="sline tit last">' + resultMap.CategoryNM + '</td>';
            rowHtml += '<th class="sline">Notice</th>';
            rowHtml += '<td class="alignL pdL10 last">~ ' + resultMap.ClosingDT + '</td>';
            showRow = true;
        } else if (hasCategory) {
            // Case 2: Category only
            rowHtml += '<th style="height:20px;">${menu.LN00033}</th>';
            rowHtml += '<td class="sline tit last" colspan="3">' + resultMap.CategoryNM + '</td>';
            showRow = true;
        } else if (hasNotice) {
            // Case 3: Notice only
            rowHtml += '<th class="sline">Notice</th>';
            rowHtml += '<td class="alignL pdL10 last" colspan="3">~ ' + resultMap.ClosingDT + '</td>';
            showRow = true;
        }
        
        if(showRow) {
            $("#category_notice_tr").html(rowHtml).show();
        } else {
            $("#category_notice_tr").hide();
        }

        // 첨부파일 렌더링
        if (itemFiles && itemFiles.length > 0) {
            var fileHtml = "";
            var checkHtml = "";
            itemFiles.forEach(function(file) {
                checkHtml += '<div id="divDownFile'+file.Seq+'" class="mm">';
                checkHtml += '<input type="checkbox" name="attachFileCheck" value="'+file.Seq+'" class="mgL2 mgR2"> ';
                checkHtml += '<span style="cursor:pointer;" onclick="fileNameClick(\''+file.Seq+'\');">'+file.FileRealName+'</span><br></div>';
            });
            $("#tmp_file_items").html(checkHtml);
            $("#divFileImg").show();
        } else {
            $("#divFileImg").hide();
        }

        // 권한 처리 및 버튼 렌더링
        var chkReadOnly = (sessionUserId == resultMap.RegUserID || sessionAuthLev == 1 || NEW == 'Y') ? false : true;

        var btnHtml = "";
        // 좋아요 버튼 렌더링
        if (NEW == 'N' && data.LikeYN == 'Y') {
            var likeInfo = resultMap.LikeInfo || "N";
            var likeIconUrl = "${root}${HTML_IMG_DIR}/Like" + likeInfo + ".png";
            btnHtml += '<span id="saveLike" style="float:left;">';
            btnHtml += '<img src="'+likeIconUrl+'" onclick="doLike(\''+likeInfo+'\')" style="width:25px;height:25px;cursor:pointer;"></span>';
            btnHtml += '<span style="float:left;padding-top:5px;">('+data.likeCNT+')</span>&nbsp;&nbsp;';
        }

        // Edit 버튼
        if (sessionUserId == resultMap.RegUserID) {
            btnHtml += '<span id="viewEdit" class="btn_pack medium icon"><span class="edit"></span><input value="Edit" type="button" onclick="doEdit()"></span>&nbsp;';
        }

        // Delete 버튼
        if (sessionAuthLev == 1 && NEW == 'N') {
            btnHtml += '<span id="viewDel" class="btn_pack medium icon"><span class="delete"></span><input value="Delete" type="button" onclick="doDelete()"></span>&nbsp;';
        }

        // List 버튼
        btnHtml += '<span id="viewList" class="btn_pack medium icon"><span class="list"></span><input value="List" type="button" onclick="fnGoList();"></span>';

        $("#btn_area").html(btnHtml);

        // 카테고리 및 프로젝트 Select 박스 바인딩
        var selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&BoardMgtID=${boardDTO.boardMgtID}&projectType=${projectType}&templProjectID=${templProjectID}";
        fnSelect('project', selectData, 'getPjtMbrRl', templProjectID, 'Select');
        fnSelect('category', selectData, 'getBoardMgtCategory', resultMap.Category, 'Select');

        // 화면 노출
        $("#boardDiv").removeClass("hidden");
    }

    function doLike(likeInfo){
        if(likeInfo == 'N'){ if(!confirm("${CM00001}")){ return;} }
        else if(likeInfo == 'Y') { if(!confirm("Do you really cancel Like ?")){ return;} }

        var url  = "saveBoardLike.do";
        ajaxSubmit(document.boardFrm, url, "blankFrame");
    }

    function doDelete(){
        if(confirm("${CM00002}")){
            var url = "deleteBoard.do";
            ajaxSubmit(document.boardFrm, url,"blankFrame");
        }
    }

    var back = "&scStartDt=${boardDTO.scStartDt}&searchKey=${boardDTO.searchKey}&searchValue=${boardDTO.searchValue}&scEndDt=${boardDTO.scEndDt}&projectCategory="+projectCategory;

    function fnGoList(){
        if(screenType == "Admin"){
            goList(false, screenType, "${boardDTO.projectID}","${boardDTO.category}","${boardDTO.categoryIndex}","${boardDTO.categoryCnt}",back);
        }else{
            var url = "boardList.do";
            var data = "pageNum=${boardDTO.pageNum}&url="+encodeURIComponent("${boardDTO.url}")+"&screenType="+encodeURIComponent("${boardDTO.screenType}")+"&s_itemID="+encodeURIComponent("${boardDTO.projectID}")+"&defBoardMgtID="+encodeURIComponent("${boardDTO.defBoardMgtID}")+"&category="+encodeURIComponent("${boardDTO.category}")+back+"&categoryIndex="+encodeURIComponent("${boardDTO.categoryIndex}")+"&categpryCnt=${boardDTO.categoryCnt}&projectIDs="+ encodeURIComponent("${boardDTO.projectIDs}");
            if(screenType != "cust"){
                data = data + "&boardMgtID="+encodeURIComponent("${boardDTO.boardMgtID}");
            }
            ajaxPage(url, data, "help_content");
        }
    }

    function doEdit(){
		var url = "boardListInfoMgt.do";
        var data = "NEW=N&boardID="+$("#BoardID").val()+"&boardMgtID="+$("#BoardMgtID").val()+"&url=/board/brd/editBoardV4&screenType=${boardDTO.screenType}&pageNum=${boardDTO.currPage}&projectID=${boardDTO.projectID}&category=${boardDTO.category}&categoryIndex=${boardDTO.categoryIndex}"+back+"&categpryCnt=${boardDTO.categoryCnt}&templProjectID=${boardDTO.templProjectID}&fileTokenYN=Y";
        ajaxPage(url, data, "help_content");
    }

    function FileDownload(checkboxName, isAll){
        var seq = new Array();
        var j =0;
        var checkObj = document.all(checkboxName);
        if (isAll == 'Y') {
            if (checkObj.length == undefined) { checkObj.checked = true; }
            for (var i = 0; i < checkObj.length; i++) { checkObj[i].checked = true; }
        }

        if (checkObj.length == undefined) {
            if (checkObj.checked) { seq[0] = checkObj.value; j++; }
        } else {
            for (var i = 0; i < checkObj.length; i++) {
                if (checkObj[i].checked) { seq[j] = checkObj[i].value; j++; }
            }
        }

        if(j==0){ alert("${WM00049}"); return; }

        var url  = "fileDownload.do?seq="+seq+"&scrnType=BRD";
        ajaxSubmitNoAdd(document.boardFrm, url,"blankFrame");

        if (isAll == 'Y') {
            if (checkObj.length == undefined) { checkObj.checked = false; }
            for (var i = 0; i < checkObj.length; i++) { checkObj[i].checked = false; }
        }
    }

    function fileNameClick(avg1){
        var seq = new Array();
        seq[0] = avg1;
        var url  = "fileDownload.do?seq="+seq+"&scrnType=BRD";
        ajaxSubmitNoAdd(document.boardFrm, url,"blankFrame");
    }
</script>

<style>
    strong,em{font-size:inherit;}
</style>

<!-- BEGIN :: DETAIL -->
<div class="mgL10 mgR10" >
    <form name="boardFrm" id="boardFrm" enctype="multipart/form-data" action="saveBoard.do" method="post" onsubmit="return false;">
        <input type="hidden" id="currPage" name="currPage" value="${boardDTO.currPage}">
        <input type="hidden" id="BoardMgtID" name="BoardMgtID" value="${boardDTO.boardMgtID}">
        <input type="hidden" id="BoardID" name="BoardID" value="${boardDTO.boardID}">
        <input type="hidden" id="screenType" name="screenType" value="${boardDTO.screenType}">
        <input type="hidden" id="defBoardMgtID" name="defBoardMgtID" value="${boardDTO.defBoardMgtID}" >
        <input type="hidden" id="likeInfo" name="likeInfo" value="" >
        <input type="hidden" id="RegUserID" name="RegUserID" value="" >

        <div class="cop_hdtitle">
            <h3 style="padding: 8px 0;"><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png">&nbsp;<span id="boardMgtName_span"></span>&nbsp;${menu.LN00108}</h3>
        </div>

        <div id="boardDiv" class="hidden" style="width:100%;">
        <table class="tbl_brd" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
            <colgroup>
                <col width="12%">
                <col>
                <col width="12%">
                <col>
            </colgroup>
            <tr>
                <th>${menu.LN00002}</th>
                <td class="sline tit last" id="Subject_td"></td>
                <th>${menu.LN00131}</th>
                <td class="sline tit last">
                    <input type="hidden" id="project_val" name="project" value=""><span id="ProjectName_td"></span>
                </td>
            </tr>
            <tr>
                <th class="sline" style="height:20px;">${menu.LN00212}</th>
                <td id="TD_WRITE_USER_NM" class="alignL pdL10 "></td>
                <th class="sline">${menu.LN00070}</th>
                <td class="alignL pdL10 last" style="width:25%;" id="TD_REG_DT"></td>
            </tr>

            <tr id="category_notice_tr" style="display:none;">
            </tr>

            <tr>
                <th style="height:53px;">${menu.LN00111}</th>
                <td colspan="3" style="height:53px;" class="alignL pdL5 last">
                    <div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
                        <div id="tmp_file_items" name="tmp_file_items" style="float:left; width: 80%;"></div>
                        <div class="floatR pdR20" id="divFileImg" style="display:none;">
                            <span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('attachFileCheck', 'Y')"></span><br>
                            <span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('attachFileCheck', 'N')"></span><br>
                        </div>
                    </div>
                </td>
            </tr>
        </table>

        <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
                  <td colspan="4" style="height: 400px;vertical-align:top;overflow:auto;border-left:1px solid #ddd;border-right:1px solid #ddd;border-bottom:1px solid #ddd;" class="tit last pdL10 pdR10">
                     <div id="Content_div" style="height:650px; overflow:auto; padding:5px;"></div>
                </td>
            </tr>
        </table>

        <!-- BEGIN :: Button -->
        <div class="alignBTN" id="btn_area"></div>
        <!-- END :: Button -->

    </div>
    </form>
</div>
<!-- END :: DETAIL -->
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>