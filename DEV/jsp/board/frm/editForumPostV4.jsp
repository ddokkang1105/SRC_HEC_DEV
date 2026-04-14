<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<c:url value="/" var="root"/>

<link rel="stylesheet" href="${root}cmm/common/css/materialdesignicons.min.css"/>
 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002" />

<script type="text/javascript">
	var sessionAuthLev="${sessionScope.loginInfo.sessionAuthLev}";
	var sessionUserId="${sessionScope.loginInfo.sessionUserId}";
	var RegUserId = ""; // fetch 후 세팅
	var NEW = "${NEW}";
	
	// 게시글에 이미 첨부되어있던 파일들 정보
	var fileObjArray = [];
	var previousAddedFileNames = new Set();

    // FileRealName만 추출하여 Set으로 반환
    function extractFileRealNamesToSet(arr) {
        if (!arr || arr.length === 0) return new Set();
        return new Set(arr.map(item => item.FileRealName || item.FILEREALNAME));
    }
    
    function removeBySeqInPlace(arr, seqValue) {	
        const index = arr.findIndex(item => (item.Seq || item.SEQ) == seqValue);
        if (index !== -1) {
          arr.splice(index, 1);
        }
        return arr;
    }

	window.scrnType = "BRD"; var scrnType = "BRD";
	window.docCategory = "BRD"; var docCategory = "BRD";
	var mgtId = "";
	var boardId = "";
	
	var itemClassCode = "";
	var documentId = "";
	var projectId = "";
	var changeSetId ="";
	var uploadToken = ""; // fetch 후 세팅
</script>


<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<%@ include file="/WEB-INF/jsp/template/fileAttachWindow.jsp"%>

<script type="text/javascript">

// URL 파라미터 세팅
const urlParams = new URLSearchParams(window.location.search);
var emailCode = urlParams.get('emailCode') || "";
var category = urlParams.get('category') || "";
var boardTitle = "";
var isMyCop = urlParams.get('isMyCop') || "";
var dueDateMgt = urlParams.get('dueDateMgt') || "";
var showAuthorInfo = urlParams.get('showAuthorInfo') || "";
var showItemVersionInfo = urlParams.get('showItemVersionInfo') || "";

	$(document).ready(function() {
        
        // Hidden input들에 URL 파라미터 매핑
        const paramKeys = ['noticType', 's_itemID', 'boardID', 'BoardMgtID', 'itemID', 'pageNum', 'searchType', 'searchValue', 'scStartDt', 'scEndDt', 'screenType', 'listType', 'mailRcvListSQL', 'showItemInfo'];
        paramKeys.forEach(function(key) {
            if(document.getElementById(key) && urlParams.has(key) && urlParams.get(key) != null) {
                document.getElementById(key).value = urlParams.get(key);
            }
        });

        mgtId = document.getElementById('BoardMgtID').value;
        boardId = document.getElementById('boardID').value;

        // API로 데이터 조회
        loadForumPostData();
				
		$("#send").click(function(e) {
			if(confirm("${CM00001}")){
				saveDetail();
			}
		});
		
		$('#back').click(function(e){
			doReturn();
		});
	});
	
    function loadForumPostData() {
        var bId = document.getElementById('boardID') ? document.getElementById('boardID').value : '${forumDTO.boardID}';
        var bMgtId = document.getElementById('BoardMgtID') ? document.getElementById('BoardMgtID').value : '${forumDTO.boardMgtID}';
        var iId = document.getElementById('itemID') ? document.getElementById('itemID').value : '${forumDTO.itemID}';
        var bIds = document.getElementById('boardIds') ? document.getElementById('boardIds').value : '${forumDTO.boardIds}';
        var eCode = '${forumDTO.emailCode}';
        var bTitle = '${forumDTO.boardTitle}';

        var queryString = "?boardID=" + bId 
                        + "&BoardMgtID=" + bMgtId 
                        + "&ItemID=" + iId 
                        + "&boardIds=" + bIds 
                        + "&emailCode=" + eCode 
                        + "&boardTitle=" + encodeURIComponent(bTitle);
        // remove trailing undefined params
        queryString = queryString.replace(/undefined/g, "");

        fetch('getEditForumPostData.do' + queryString, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => {
            if (!response.ok) { throw new Error('Network response was not ok'); }
            return response.json();
        })
        .then(data => {
            if (data.action === "redirect") {
                if(data.message) alert(data.message);
                doReturn();
                return;
            }

            if (data.action === "error") {
                alert(data.message);
                return;
            }

            if (data.action === "success") {
                
                // 1. 게시판 기본 정보 바인딩
                if (data.forumInfo) {
                    document.getElementById('subject').value = data.forumInfo.Subject || '';
                    document.getElementById('Content').value = data.forumInfo.Content || '';
                    
                    // TinyMCE 에디터가 있다면 내용 세팅
                    if(typeof tinyMCE !== 'undefined' && tinyMCE.activeEditor) {
                        tinyMCE.activeEditor.setContent(data.forumInfo.Content || '');
                    }
                    
                    // 작성자
                    if(document.getElementById('authorInfoText')) {
                        document.getElementById('authorInfoText').innerHTML = (data.forumInfo.WriteUserNM || '') + "/" + (data.forumInfo.TeamName || '') + '<input type="hidden" name="ItemMgtUserID" id="ItemMgtUserID" value="' + (data.forumInfo.RegUserID || '') + '" />';
                    }
                    RegUserId = data.forumInfo.RegUserID;
                    
                    // 검토기한/완료일, 수신자
                    if(document.getElementById('dueDateText')) {
                        document.getElementById('dueDateText').innerText = data.forumInfo.SC_END_DT || '';
                    }
                    if(document.getElementById('sharerNamesText')) {
                        document.getElementById('sharerNamesText').innerText = data.forumInfo.sharerNames || '';
                    }
                    
                    if(!category) category = data.forumInfo.CategoryCode;
                }

                // 2. 타이틀 바인딩
                if (data.boardTitle) {
                    boardTitle = data.boardTitle;
                    if(document.getElementById('pageTitleText')) {
                        document.getElementById('pageTitleText').innerText = data.boardTitle + " > Edit";
                    }
                }

                // 3. 첨부파일 리스트 바인딩
                if (data.itemFiles && data.itemFiles.length > 0) {
                    try {
                        fileObjArray = data.itemFiles;
                        previousAddedFileNames = extractFileRealNamesToSet(fileObjArray);

                        let fileHtml = "";
                        for(var i=0; i<data.itemFiles.length; i++) {
                            var file = data.itemFiles[i];
                            var fileName = file.FileRealName || file.FileName || file.FILEREALNAME || file.FILENAME || "No Name";
                            var boardID = file.BoardID || file.BOARDID || "";
                            var seq = file.Seq || file.SEQ || "";

                            let ext = fileName.split('.').pop().toLowerCase();
                            let iconClass = "log";
                            if (ext.includes("doc")) iconClass = "doc";
                            else if (ext.includes("xls")) iconClass = "xls";
                            else if (ext.includes("pdf")) iconClass = "pdf";
                            else if (ext.includes("hwp")) iconClass = "hwp";
                            else if (ext.includes("ppt")) iconClass = "ppt";

                            fileHtml += '<li class="flex icon_color_inherit justify-between mm align-center" id="divDownFile' + seq + '">';
                            fileHtml += '<span>';
                            fileHtml += '   <span class="btn_pack small icon mgR25">';
                            fileHtml += '       <span class="' + iconClass + '"></span>';
                            fileHtml += '   </span>';
                            fileHtml += '   <span style="line-height:24px; cursor:pointer;" onclick="fileNameClick(\'' + seq + '\');">' + fileName + '</span>';
                            fileHtml += '</span>';
                            fileHtml += '<i class="mdi mdi-window-close" style="cursor:pointer;" onclick="fnDeleteItemFile(\'' + boardID + '\',\'' + seq + '\')"></i>';
                            fileHtml += '</li>';
                        }
                        var fileArea = document.getElementById('fileListArea');

                        if(fileArea) {
                            fileArea.innerHTML = fileHtml;
                            fileArea.style.display = "block";
                            fileArea.style.visibility = "visible";
                        }
                    } catch(e) {
                        console.error("Rendering error:", e);
                    }
                }                
                // 4. 카테고리 여부에 따른 UI 처리
                if(data.CategoryYN === 'Y') {
                    var dataParam = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&BoardMgtID=" + urlParams.get('BoardMgtID') + "&projectType=${projectType}&templProjectID=${templProjectID}";
                    fnSelect('category', dataParam, 'getBoardMgtCategory', category, 'Select');
                    setTimeout(function() {
                        $("#category option[value='BRDSTS101']").remove();
                        $("#category option[value='BRDSTS102']").remove();
                    }, 300); 
                } else {
                    if(document.getElementById('categoryArea')) document.getElementById('categoryArea').style.display = 'none';
                }
                
                if(document.getElementById('uploadToken')) {
                    var token = data.uploadToken || '';
                    document.getElementById('uploadToken').value = token;
                    window.uploadToken = token;
                }
            }
        })
        .catch(error => {
            console.error('Fetch error:', error);
            alert("데이터 조회 중 오류가 발생했습니다.");
        });
    }

	function saveDetail() {
		var date = new Date();
		var str = date.getFullYear() + '-' + (date.getMonth() + 1) + '-'
				+ date.getDate() + ' ' + date.getHours()
				+ ':' + date.getMinutes() + ':'
				+ date.getSeconds() + '.'
				+ date.getMilliseconds();
		$('#date').attr('value',str);
		$('#isNew').attr('value','1');
		$('#deleteSeq').attr('value',document.getElementById("deleteSeq").value);
		
		var url  = "updateForumPost.do";
		ajaxSubmit(document.editforumFrm, url);
	}
	
	function doReturn(){ 
		var listType = urlParams.get("listType") || "1";
		var url = "viewForumPost.do";

        var pNum = urlParams.get("pageNum") || '${forumDTO.pageNum}'; if(pNum === '') pNum = '1';
        var nType = urlParams.get("noticType") || '${forumDTO.noticType}';
        var iId = urlParams.get("itemID") || '${forumDTO.itemID}';
        var sItemId = urlParams.get("s_itemID") || '${forumDTO.s_itemID}';
        var sd = urlParams.get("scStartDt") || '${forumDTO.scStartDt}';
        var ed = urlParams.get("scEndDt") || '${forumDTO.scEndDt}';
        var st = urlParams.get("searchType") || '${forumDTO.searchType}';
        var sv = urlParams.get("searchValue") || '${forumDTO.searchValue}';
        var mSQL = urlParams.get("mailRcvListSQL") || '${forumDTO.mailRcvListSQL}';
        var scrType = urlParams.get("screenType") || '${forumDTO.screenType}';
        var srId = urlParams.get("srID") || '${forumDTO.srID}';
        var srTy = urlParams.get("srType") || '${forumDTO.srType}';
        var bIds = urlParams.get("boardIds") || '${forumDTO.boardIds}';
        var sItemInfo = urlParams.get("showItemInfo") || '${forumDTO.showItemInfo}';
        var myB = urlParams.get("myBoard") || '${forumDTO.myBoard}';

		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&pageNum=" + pNum
                    + "&noticType=" + nType
                    + "&BoardMgtID=" + mgtId 
                    + "&boardID=" + boardId 
                    + "&isMyCop=" + isMyCop
					+ "&s_itemID=" + sItemId
                    + "&ItemID=" + iId
                    + "&scStartDt=" + sd
                    + "&scEndDt=" + ed
					+ "&searchType=" + st
                    + "&searchValue=" + sv
					+ "&mailRcvListSQL=" + mSQL
					+ "&emailCode=" + emailCode
					+ "&screenType=" + scrType
                    + "&listType=" + listType
					+ "&srID=" + srId
                    + "&srType=" + srTy
                    + "&boardIds=" + bIds
                    + "&showItemInfo=" + sItemInfo
                    + "&scrnType=" + scrnType
					+ "&boardTitle="+encodeURIComponent(boardTitle)
                    + "&myBoard=" + myB
					+ "&dueDateMgt=" + dueDateMgt
                    + "&showAuthorInfo=" + showAuthorInfo
                    + "&showItemVersionInfo=" + showItemVersionInfo;

		if(listType == 1){data = data + "&s_itemID="+$('#s_itemID').val();}			
		var target = "help_content";
		ajaxPage(url, data, target); 
	}

	function doAttachFile(){
		var browserType="";
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url="addFilePop.do";
		var data="scrnType=BRD&browserType="+browserType+"&mgtId="+$("#BoardMgtID").val()+"&id="+$('#BoardID').val();
		if(browserType=="IE"){fnOpenLayerPopup(url,data,"",400,400);}
		else{openPopup(url+"?"+data,490,360, "Attach File");}
	}
	
	function fnDeleteItemFile(BoardID, seq){
		
        fileObjArray = removeBySeqInPlace(fileObjArray, seq);
        previousAddedFileNames = extractFileRealNamesToSet(fileObjArray);
		
		var url = "boardFileDelete.do";
		var data = "&delType=1&BoardID="+BoardID+"&Seq="+seq;
		ajaxPage(url, data, "blankFrame");
		
		$('#divDownFile'+seq).remove();	
	}
	
	//************** addFilePop V4 설정 START ************************//
	function doAttachFileV4(){
		var url="addFilePopV4.do";
		var data="scrnType=BRD&mgtId="+$("#BoardMgtID").val()+"&id="+$('#boardID').val()+"&uploadToken="+uploadToken;
		openPopup(url+"?"+data,480,450, "Attach File");
	}
	
	function openDhxVaultModal(){		
		// dhtmlx 윈도우로 vault 띄우기
		newFileWindow.show();
	}
	
	var fileIDMapV4 = new Map();
	var fileNameMapV4 = new Map();
	function fnAttacthFileHtmlV4(fileID, fileName){ 
		fileID = fileID.replace("u","");
		fileIDMapV4.set(fileID,fileID);
		fileNameMapV4.set(fileID,fileName);
	}
	
	function fnDeleteFileMapV4(fileID){ 
		fileID = fileID.replace("u","");		
		fileIDMapV4.delete(String(fileID));
		fileNameMapV4.delete(String(fileID));
	}
	
	function fnDisplayTempFileV4(){
		document.getElementById("tmp_file_items").style.display = "block";
		let display_scripts = $("#tmp_file_items").html();
		
		let fileFormat = "";
		fileIDMapV4.forEach(function(fileID) {
            if(!document.getElementById(fileID)) {
                let fileName = fileNameMapV4.get(fileID) || "No Name";
                fileFormat = fileName.split(".")[1];
                if(fileFormat) {
                    fileFormat = fileFormat.toLowerCase();
                } else {
                    fileFormat = "";
                }
                
                let iconClass = "log";
                switch (true) {
                    case fileFormat.includes("do") : iconClass = "doc"; break;
                    case fileFormat.includes("xl") : iconClass = "xls"; break;
                    case fileFormat.includes("pdf") : iconClass = "pdf"; break;
                    case fileFormat.includes("hw") : iconClass = "hwp"; break;
                    case fileFormat.includes("pp") : iconClass = "ppt"; break;
                    default : iconClass = "log"
                }
                  display_scripts += '<li id="' + fileID + '" class="flex icon_color_inherit justify-between mm align-center" name="' + fileID + '">';
                  display_scripts += '<span><span class="btn_pack small icon mgR25">';
                  display_scripts += '<span class="' + iconClass + '"></span></span>';
                  display_scripts += '<span style="line-height:24px;">' + fileName + '</span></span>';
                  display_scripts += '<i class="mdi mdi-window-close" style="cursor:pointer;" onclick="fnDeleteFileHtmlV4(\'' + fileID + '\', true)"></i>';
                  display_scripts += '</li>';
            }
		});
		
		document.querySelector("#tmp_file_items").innerHTML = display_scripts;

		fileIDMapV4 = new Map();
		fileNameMapV4 = new Map();
	}
	
	function fnDeleteFileHtmlV4(fileID, doDeleteFromVault){			
		var fileNameElem = document.getElementById(fileID);
        var fileName = fileNameElem ? fileNameElem.innerText : "";

		fileIDMapV4.delete(String(fileID));
		fileNameMapV4.delete(String(fileID));
		
		if(fileName != "" && fileName != null && fileName != undefined){
			$("#"+fileID).remove();
			
			if (doDeleteFromVault){
				if(typeof vault !== 'undefined' && vault !== null){
					try {
						var vaultFileId = "u" + fileID;
						var vaultFile = vault.data.getItem(vaultFileId);
						
						if(vaultFile){
							vault.data.remove(vaultFileId);
						}
					} catch(e) {
						console.error("Vault에서 파일 삭제 중 오류:", e);
					}
				}
			}
		}
	}
	//************** addFilePop V4 설정 END ************************//

	function FileDownload(checkboxName, isAll){
		var seq = new Array();
		var j =0;
		var checkObj = document.all(checkboxName);
		
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = true;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = true;
			}
		}
		
		if (checkObj.length == undefined) {
			if (checkObj.checked) {
				seq[0] = checkObj.value;
				j++;
			}
		};
		for (var i = 0; i < checkObj.length; i++) {
			if (checkObj[i].checked) {
				seq[j] = checkObj[i].value;
				j++;
			}
		}
		if(j==0){
			alert("${WM00049}");
			return;
		}
		j =0;
		var url  = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.editforumFrm, url,"saveFrame");
		
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = false;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = false;
			}
		}
	}
	function fileNameClick(avg1){
		var seq = new Array();
		seq[0] = avg1;
		var url  = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.editforumFrm, url,"saveFrame");
	}

</script>

<div class="pdB15 mgT10" style="width: 70%; margin: 0 auto;">
	<form name="editforumFrm" id="editforumFrm" enctype="multipart/form-data" action="editForumPost.do" method="post" onsubmit="return false;">
        <input type="hidden" id="uploadToken" name="uploadToken" value="" >
		<input type="hidden" id="noticType" name="noticType" value="${forumDTO.noticType}">
		<input type="hidden" id="s_itemID" name="s_itemID" value="${forumDTO.s_itemID}" />	
		<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}">
		<input type="hidden" id="boardID" name="boardID" value="${forumDTO.boardID}">
		<input type="hidden" id="BoardMgtID" name="BoardMgtID" value="${forumDTO.boardMgtID}">
		<input type="hidden" id="userId" name="userId" value="${sessionScope.loginInfo.sessionUserId}">
		<input type="hidden" id="itemID" name="itemID" value="${forumDTO.itemID}">
		<input type="hidden" id="deleteSeq" name="deleteSeq">
		<input type="hidden" id="pageNum" name="pageNum" value="${empty forumDTO.pageNum ? '1' : forumDTO.pageNum}">
		<input type="hidden" id="projectID" name="projectID" value="${forumDTO.projectID}" />
		<input type="hidden" id="searchType" name="searchType" value="${forumDTO.searchType}" />
		<input type="hidden" id="searchValue" name="searchValue" value="${forumDTO.searchValue}" />
		<input type="hidden" id="scStartDt" name="scStartDt" value="${forumDTO.scStartDt}" />
		<input type="hidden" id="scEndDt" name="scEndDt" value="${forumDTO.scEndDt}" />	
		<input type="hidden" id="screenType" name="screenType" value="${forumDTO.screenType}" />	
		<input type="hidden" id="listType" name="listType" value="${empty forumDTO.listType ? '1' : forumDTO.listType}" />	
		<input type="hidden" id="mailRcvListSQL" name="mailRcvListSQL" value="${forumDTO.mailRcvListSQL}" />	
		<input type="hidden" id="showItemInfo" name="showItemInfo" value="${forumDTO.showItemInfo}" />	
		<input type="hidden" id="boardIds" name="boardIds" value="${forumDTO.boardIds}" />
		<div class="align-center flex justify-between pdT20 pdB10"  style="border-bottom: 1px solid #dfdfdf;">
			<p style="font-size: 13px;color: #8d8d8d;" id="pageTitleText">Edit</p>
		</div>
		<ul>
			<li class="flex align-center pdT15 pdB5">
				<div class="align-center flex" style="flex: 2 1 0;">
					<h3 class="tx">${menu.LN00002 }</h3>
					<span class="wrap_sbj">
						<input type="text" name="subject" id="subject" value="">
					</span>
				</div>
			</li>

			<li class="align-center flex pdT15 pdB15" id="categoryArea" style="width:30%; display:none;">
				<h3 class="tx">${menu.LN00042}</h3>
				<select id="category" name="category" class="form-sel" style="flex: 1 1 0;"></select>
			</li>
			
			<li class="align-center flex pdT15 pdB15">
				<h3 class="tx">${menu.LN00004}</h3>
			    <span class="wrap_sbj" id="authorInfoText"></span>
			</li>
			
            <li class="align-center flex pdT15 pdB15" id="sharerArea" style="display:none;">
                <h3 class="tx" id="sharerTitle">${menu.LN00245}</h3>
                <span class="wrap_sbj" id="sharerNamesText"></span>
            </li>
			
			<li class="align-center flex pdT15 pdB15" id="dueDateArea" style="display:none;">
			    <h3 class="tx" id="dueDateTitle">${menu.LN00389}</h3>
				<span class="wrap_sbj" id="dueDateText"></span>
			</li>
			
			<li class="flex pdT5 pdB5">
				<h3 class="tx mgT12">${menu.LN00111 }</h3>
				<div style="width:calc(100% - 100px);">
					<button class="cmm-btn" onclick="openDhxVaultModal()">Attach</button>
					<ul id="fileListArea" name="fileListArea" class="file_box mgB5 mgT10 tmp_file_items">
					</ul>
                    <ul id="tmp_file_items" name="tmp_file_items" class="file_box mgB5 mgT10 tmp_file_items">
                    </ul>
				</div>
			</li>
			<li class="flex pdT10 pdB10">
				<div style="width:100%;height:350px;">
					<textarea class="tinymceText" id="Content" name="Content" ></textarea>
				</div>
			</li>
		</ul>
		<div class="alignR">
			<input name="date" id="date" type="hidden"/>
			<button class="cmm-btn mgT10 mgR5" id="back" style="color: #333333;">Cancel</button>
			<button class="btn-4265EE cmm-btn mgT10" id="send">Submit</button>
		</div>
	</form>
</div>

<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>