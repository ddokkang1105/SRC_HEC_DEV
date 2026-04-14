<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root"/>

<script type="text/javascript">
	var sessionAuthLev="${sessionScope.loginInfo.sessionAuthLev}";
	var sessionUserId="${sessionScope.loginInfo.sessionUserId}";
	var RegUserId = ""; // fetch 후 세팅
	var NEW = "${boardDTO.NEW}";

	function getFileSize(x) {
	  var s = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
	  var e = Math.floor(Math.log(x) / Math.log(1024));
	  if (x === 0) return "0"
	  else return (x / Math.pow(1024, e)).toFixed(1) + " " + s[e];
	};

	var fileObjArray = [];
	var previousAddedFileNames = new Set();

	var screenType = "${boardDTO.screenType}";
	window.scrnType = "BRD"; var scrnType = "BRD";
	window.docCategory = "BRD"; var docCategory = "BRD";
	window.mgtId = "${boardDTO.boardMgtID}"; var mgtId = "${boardDTO.boardMgtID}";
	window.boardId = "${boardDTO.boardID}"; var boardId = "${boardDTO.boardID}";
	var itemClassCode = "";
	window.documentId = "${boardDTO.boardID}"; var documentId = "${boardDTO.boardID}";
	var projectId = "";
	var changeSetId ="";
	var uploadToken = ""; // fetch 후 세팅
</script>

<!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<%@ include file="/WEB-INF/jsp/template/fileAttachWindow.jsp"%>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>

<style>
.new-form .tmp_file_wrapper td { padding: 8px 10px; }
.new-form input[type=checkbox]+label {
    box-sizing: border-box; color: #222; display: inline-block;
    line-height: 20px; min-height: 20px; padding-left: 22px;
    position: relative; vertical-align: top; margin-right: 16px; padding-right: 0
}
.new-form input[type=checkbox]+label:before {
    content: ""; display: inline-block; width: 16px; height: 16px;
    left: 0; position: absolute; top: 2px;
    border: 1px solid #ddd; box-sizing: border-box;
}
</style>

<script type="text/javascript">
var fileSize = "0";
var templProjectID = "${boardDTO.templProjectID}";
var projectType = "${boardDTO.projectType}";
var ClosingDT = "";

jQuery(document).ready(function() {
	$("input.datePicker").each(generateDatePicker);
	fetchBoardData();
});	function fetchBoardData() {
	    var url = "boardDetailData.do?BoardID=" + boardId + "&BoardMgtID=" + mgtId;
	    fetch(url).then(res => res.json()).then(data => {
	        var res = data.resultMap || {};
	        
	        // 데이터 바인딩
	        $("#Subject").val(res.Subject || "");
	        $("#boardMgtNameTitle").text(data.boardMgtName || "");
	        RegUserId = res.RegUserID;
	        $("#RegUserID").val(res.RegUserID || "");
	        
	        // 공지사항 처리
	        if(res.ClosingDT) {
	            $("#noticeYN").prop("checked", true).val("Y");
	            $("#closingDT").val(res.ClosingDT);
	            $("#closingCalDp").show();
	        }

	        // 좋아요/작성정보 등
	        $("#TD_WRITE_USER_NM").text(res.WriteUserNM || "");
	        $("#TD_REG_DT").text(res.ModDT || "");
	        
	        // [중요] 전역 변수 업데이트
	        window.uploadToken = data.uploadToken;
	        $("#uploadToken").val(data.uploadToken);

	        // 셀렉트 박스
	        var sData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&BoardMgtID=" + mgtId;
	        fnSelect('project', sData, 'getPjtMbrRl', res.ProjectID, 'Select');
	        if(data.CategoryYN === 'Y') {
	            $("#categoryRow").show();
	            fnSelect('category', sData, 'getBoardMgtCategory', res.Category, 'Select');
	        }

	        // 에디터
	        setTimeout(() => {
	            if(typeof tinyMCE !== 'undefined' && tinyMCE.get('Content')) {
	                tinyMCE.get('Content').setContent(res.Content || "");
	            }
	        }, 500);

	        // 첨부파일
	        fileObjArray = data.itemFiles || [];
	        renderFiles(fileObjArray);

			$("#boardDiv").removeClass("hidden");
	    });
	}

	function renderFiles(files) {
	    var fileList = $("#file-list");
	    fileList.empty(); 

	    if (!Array.isArray(files) || files.length === 0) {
	        $("#tmp_file_wrapper").hide();
	        return;
	    }

	    var html = "";
	    for (var i = 0; i < files.length; i++) {
	        var f = files[i];
	        if (!f) continue;

	        var seq = f.Seq || f.SEQ || "";
	        var boardID = f.BoardID || f.BOARDID || "";
	        var fileName = f.FileRealName || f.FILEREALNAME || f.FileName || f.FILENAME || "Unknown File";
	        var fSize = f.FileSize || f.FILESIZE || 0;
	        var fileSizeStr = (typeof getFileSize === "function" && fSize > 0) ? getFileSize(fSize) : "";

	        html += '<tr id="' + seq + '" name="' + seq + '">';
	        html += '    <td class="delete flex">';
	        html += '        <svg xmlns="http://www.w3.org/2000/svg" onclick="fnDeleteItemFile(\'' + boardID + '\',\'' + seq + '\')" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"/></svg>';
	        html += '    </td>';
	        html += '    <td name="fileName" onclick="fileNameClick(\'' + seq + '\')" style="cursor:pointer;">' + fileName + '</td>';
	        html += '    <td class="alignR">' + fileSizeStr + '</td>';
	        html += '</tr>';
	    }

	    fileList.html(html);
	    $("#tmp_file_wrapper").show();
	}	function doSave(){
		if(!confirm("${CM00001}")){ return;}
		var url  = "saveBoard.do";
		ajaxSubmit(document.boardFrm, url,"blankFrame");
	}

	function fnGoList(){
		var url = "boardList.do";
		var data = "BoardMgtID=" + mgtId + "&pageNum=${boardDTO.currPage}&screenType=${boardDTO.screenType}";
		ajaxPage(url, data, "help_content");
	}

	function openDhxVaultModal(){ if(typeof newFileWindow !== 'undefined') newFileWindow.show(); }

	function fnDeleteItemFile(BoardID, seq){
		$("#"+seq).remove();
		var url = "boardFileDelete.do";
		var data = "&delType=1&BoardID="+BoardID+"&Seq="+seq;
		ajaxPage(url, data, "blankFrame");		
		if(document.querySelector("#tmp_file_items").children.namedItem("file-list").children.length === 0) document.querySelector("#tmp_file_wrapper").style.display = "none";
	}

	// Vault 관련 콜백 함수들 (기존 구조 복구)
	var fileIDMapV4 = new Map();
	var fileNameMapV4 = new Map();
	var fileSizeMapV4 = new Map();
	function fnAttacthFileHtmlV4(fileID, fileName, fileSize){ 
		fileID = fileID.replace("u","");
		fileIDMapV4.set(fileID,fileID); fileNameMapV4.set(fileID,fileName); fileSizeMapV4.set(fileID,fileSize);
	}
	function fnDeleteFileMapV4(fileID){ 
		fileID = fileID.replace("u",""); 
		fileIDMapV4.delete(String(fileID)); fileNameMapV4.delete(String(fileID)); fileSizeMapV4.delete(String(fileID)); 
	}
	function fnDisplayTempFileV4(){
		let display_scripts = "";
		fileIDMapV4.forEach(function(fileID) {
			if(!document.getElementById(fileID)) {
				display_scripts += '<tr id="'+fileID+'" class="" name="'+fileID+'"><td class="delete flex"><svg xmlns="http://www.w3.org/2000/svg" onclick="fnDeleteFileHtmlV4('+fileID+', true)" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"/></svg></td><td name="fileName">'+ fileNameMapV4.get(fileID)+'</td><td class="alignR">'+ getFileSize(fileSizeMapV4.get(fileID))+'</td></tr>';
			}
		});
		document.querySelector("#tmp_file_items").children.namedItem("file-list").insertAdjacentHTML("beforeend",display_scripts);
		document.querySelector("#tmp_file_wrapper").style.display = "block";
	}
	function fnDeleteFileHtmlV4(fileID, doDeleteFromVault){
		var fileName = document.getElementById(fileID)?.children.namedItem("fileName").innerHTML;
		fileIDMapV4.delete(String(fileID)); fileNameMapV4.delete(String(fileID)); fileSizeMapV4.delete(String(fileID));
		if(fileName != "" && fileName != null && fileName != undefined){
			$("#"+fileID).remove();
			if (doDeleteFromVault && typeof vault !== 'undefined' && vault !== null){ try { var vaultFileId = "u" + fileID; var vaultFile = vault.data.getItem(vaultFileId); if(vaultFile) vault.data.remove(vaultFileId); } catch(e) {} }
		}
		if(document.querySelector("#tmp_file_items").children.namedItem("file-list").children.length === 0) document.querySelector("#tmp_file_wrapper").style.display = "none";
	}
	function fileNameClick(seq){ ajaxSubmitNoAdd(document.boardFrm, "fileDownload.do?scrnType=BRD&seq="+seq,"blankFrame"); }
	function fnCheckNoticeYN(){
		if($("#noticeYN").is(":checked")){ $("#closingCalDp").show(); $("#noticeYN").val("Y"); }
		else { $("#closingDT").val(""); $("#closingCalDp").hide(); $("#noticeYN").val("N"); }
	}
</script>

<div class="mgL10 mgR10">
	<form name="boardFrm" id="boardFrm" enctype="multipart/form-data" action="saveBoard.do" method="post" onsubmit="return false;">
		<input type="hidden" id="BoardMgtID" name="BoardMgtID" value="${boardDTO.boardMgtID}">
		<input type="hidden" id="BoardID" name="BoardID" value="${boardDTO.boardID}">
		<input type="hidden" id="uploadToken" name="uploadToken" value="">
		<input type="hidden" id="RegUserID" name="RegUserID" value="">
		
		<div class="cop_hdtitle">
			<h3 style="padding: 8px 0;"><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png">&nbsp;<span id="boardMgtNameTitle"></span>&nbsp;${menu.LN00108}</h3>
		</div>
		<div id="boardDiv" style="width:100%;height:500px;">
		<table class="form-column-8 new-form" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
			<colgroup><col width="12%"><col><col width="12%"><col></colgroup>		
			<tr>
				<th>${menu.LN00002}</th>
				<td class="sline tit last"><input type="text" class="text" id="Subject" name="Subject" value="" size="60"></td>
				<th>${menu.LN00131}</th>
				<td class="sline tit last"><select id="project" name="project" class="sel" style="width:250px;"></select></td>		
			</tr>			
			<c:if test="${boardDTO.NEW == 'N'}">
				<tr>
					<th>${menu.LN00212}</th><td id="TD_WRITE_USER_NM" class="pdL10"></td>
					<th>${menu.LN00070}</th><td id="TD_REG_DT" class="pdL10 last"></td>
				</tr>
			</c:if>
			<tr id="categoryRow" style="display:none;">
				<th>${menu.LN00033}</th>
				<td class="sline tit last" colspan="3"><select id="category" name="category" class="sel" style="width:250px;"></select></td>
			</tr>
			<tr>
				<th>Notice</th>
				<td class="pdL10 last" colspan="3">
					<span class="flex align-center">
						<input type="checkbox" name="noticeYN" value="" id="noticeYN" onclick="fnCheckNoticeYN();" />
						   <label for="noticeYN">Yes</label>
						<span id="closingCalDp" style="display:none;">
							<span style="position: relative;top: 2px;">&nbsp;&nbsp;Expiration date&nbsp;</span>
							<input type="text" id="closingDT" name="closingDT" class="input_off datePicker stext closingDT" size="8" style="width: 100px; text-align: left; padding-left: 5px;">
						</span>
					</span>
				</td>
			</tr>			<tr>
				<th>${menu.LN00111}</th>
				<td colspan="3">
					<div id="tmp_file_wrapper" class="tmp_file_wrapper btns" style="width:50%; display:none;">
						<table id="tmp_file_items" name="tmp_file_items" width="100%">
							<colgroup><col width="40px"><col width=""><col width="70px"></colgroup>
							<tbody id="file-list" name="file-list"></tbody>
						</table>
					</div>
				</td>
			</tr>
			</table>
			<table width="100%">
			<tr>
				<td colspan="4" style="height: 400px;" align="center" class="tit last">
					<textarea class="tinymceText" id="Content" name="Content" style="width:100%;height:400px"></textarea>
				</td>
			</tr>			
			</table>
		<div class="alignBTN">
			<span class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="button" onclick="openDhxVaultModal()"></span>&nbsp;&nbsp;
			<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="button" onclick="doSave()"></span>&nbsp;&nbsp;
			<span class="btn_pack medium icon"><span class="list"></span><input value="List" type="button" onclick="fnGoList()"></span>
		</div>
	</div>
	</form>
</div>
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none"></iframe>