<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%-- <script src="${root}cmm/js/tinymce_v7/tinymce.min.js" type="text/javascript"></script> --%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
 
<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/jquery.timepicker.css">

<script type="text/javascript">
	var chkReadOnly = false;
</script>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00002}"/> <!-- 제목 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="${menu.LN00003}"/> <!-- 개요 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00222}"/> <!-- 완료요청일 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00015" var="WM00015" arguments="${menu.LN00222}"/>
<script type="text/javascript">
	let today = new Date();
	const clientID = '${sessionScope.loginInfo.sessionClientId}';
	
	today = today.getFullYear() +
	'-' + ( (today.getMonth()+1) <= 9 ? "0" + (today.getMonth()+1) : (today.getMonth()+1) )+
	'-' + ( (today.getDate()) <= 9 ? "0" + (today.getDate()) : (today.getDate()) );
	
	var fileSize = "${itemFiles.size()}";
	var scrnType = "${scrnType}";
	var srType = "${srType}";
	
	jQuery(document).ready(function() {
		$("input.datePicker").each(generateDatePicker);
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}";
		
		fnSetButton("save", "", "서비스 요청");
		
		// enc 예외
		if(clientID !== "0000000008"){
			fnSetButton("save-remote", "", "원격 서비스 요청");
		}
		
  		fnSetButton("attach", "attach", "Attach", "tertiary");
  		
  		// 고객완료 희망일
  		document.querySelector("#reqdueDate").value = today;
	});
	
	function fnCheckValidation(){
		var isCheck = true;
		var reqdueDate = document.querySelector("#reqdueDate");
		var subject = document.querySelector("#subject");
		var description = tinyMCE.get('description').getContent();
		
		if(subject.value.length > 200){alert("제목의 글자수는 200자를 넘을 수 없습니다."); subject.focus(); isCheck = false; return isCheck;}
		if(reqdueDate.value == ""){alert("${WM00034_1}"); reqdueDate.focus(); isCheck = false; return isCheck;}
		if(reqdueDate.value < today) {alert("${WM00015}"); reqdueDate.focus(); isCheck = false; return isCheck;}
		if(subject.value.trim() == ""){ alert("${WM00034_2}"); subject.focus(); isCheck = false; return isCheck;}
		if(description == "" ){ alert("${WM00034_3}"); tinyMCE.get('description').focus(); isCheck = false; return isCheck;}
		
		return isCheck;
	}
	
	function fnSaveSR(type){		
		if(!confirm("${CM00001}")){ return;}
		if(!fnCheckValidation()){return;}
		
		$('#loading').fadeIn(150);
		var url  = "createESP.do";
		$("#resultParameter").val("${startSortNum}");
		$("#actionParameter").val("resultParameter");
		
		// ENC 예외
		if(clientID == "0000000008"){
			$("#defCategory").val("RDT100");
		}
		
		if(type == "remote"){
			var subject = "[원격 서비스를 요청 합니다.] " + $("#subject").val();
			var description = "[원격 서비스를 요청 합니다.] " + tinyMCE.get('description').getContent();
			
			$("#subject").val(subject);
			tinyMCE.get('description').setContent(description);
		}
		ajaxSubmit(document.srFrm, url,"saveFrame");
	}

	function doCallBackMove(){}
	
	/*** SR Callback function start ***/
	function fnGoDetail(srID){
		setTab(1);
		var url = "esrInfoMgt.do";
		var data = "esType=${esType}&srType=${srType}&scrnType=${scrnType}&srMode=${srMode}"
				+ "&pageNum=${pageNum}&category=${category}&searchSrCode=${searchSrCode}&itemProposal=${itemProposal}"
				+ "&srArea1=${srArea1}&srArea2=${srArea2}&subject=${subject}&srStatus=${srStatus}&srArea1ListSQL=${srArea1ListSQL}"
				+ "&srID=" + srID; 
		var target = "mainLayer";
		
		ajaxPage(url, data, target);
	}
	/*** SR Callback function end ***/

</script>
</head>

<style>
	a:hover{
		text-decoration:underline;
	}
	input[type=text]::-ms-clear{
		display: done;
	}
	font:before {
		content:"";
	}
/*  	.new-form .tox-tinymce { height:300px!important; } */
</style>

<body>
	<form name="srFrm" id="srFrm" enctype="multipart/form-data" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<input type="hidden" id="scrnType" name="scrnType" value="${scrnType}">
	<input type="hidden" id="srMode" name="srMode" value="${srMode}">
	<input type="hidden" id="esType" name="esType" value="${esType}">
	<input type="hidden" id="srType" name="srType" value="${srType}">
	<input type="hidden" id="requestUserID" name="requestUserID" value="${sessionScope.loginInfo.sessionUserId}" />
	<input type="hidden" id="actorID" name="actorID" value="${sessionScope.loginInfo.sessionUserId}" />
	<input type="hidden" id="actorTeamID" name="actorTeamID" value="${sessionScope.loginInfo.sessionTeamId}" />
	<input type="hidden" id="sysCode" name="sysCode" value="${sysCode}" />
	<input type="hidden" id="proposal" name="proposal" value="${proposal}" />
	<input type="hidden" id="itemIDs" name="itemIDs" value="" />
	<input type="hidden" id="varFilter" name="varFilter" value="${varFilter }" />
	<input type="hidden" id="itemTypeCode" name="itemTypeCode" value="${itemTypeCode}" />
	<input type="hidden" id="projectID" name="projectID" value="${ProjectID}" />
	<input type="hidden" id="category" name="category" value="${category}" />
	<input type="hidden" id="defCategory" name="defCategory" value="${defCategory}" />
	<input type="hidden" id="defSrarea" name="defSrarea" value="${defSrarea}" />
	<input type="hidden" class="text" id="rootItemID" name="rootItemID" value="${itemID}"/>
	<input type="hidden" id="activityStatus" name="activityStatus" value="05"/>
	<input type="hidden" id="startSortNum" name="startSortNum" value="${startSortNum}">
	<input type="hidden" id="resultParameter" name="resultParameter" value="${resultParameter}">
	<input type="hidden" id="actionParameter" name="actionParameter" value="${actionParameter}">
	<input type="hidden" id="customerNo" name="customerNo" value="${sessionScope.loginInfo.sessionClientId}" />
	
	
	<div class="page-title btn-wrap">${menu.LN00280}</div>
	<div class="btn-wrap pdB15 pdT10">
		<div class="btns">
			<c:if test="${sessionScope.loginInfo.sessionClientId ne '0000000008'}">
				<button id="save-remote" onclick="fnSaveSR('remote')"></button>
			</c:if>
			<button id="save" onclick="fnSaveSR('')"></button>
		</div>
	</div>
	
	<table class="form-column-2 new-form" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0"> 
		<colgroup>
			<col width="150px">
			<col width="calc(50% - 150px)">
			<col width="150px">
			<col width="calc(50% - 150px)">
		</colgroup>	
		<tr>
		    <th class="alignL pdL10" style="height:15px;">${menu.LN00025}</th>
		  	<td class="sline tit last" >
		  		${sessionScope.loginInfo.sessionUserNm}(${sessionScope.loginInfo.sessionTeamName}/${sessionScope.loginInfo.sessionCompanyNm})
				<input type="hidden" id="requestUserID" name="requestUserID" value="${sessionScope.loginInfo.sessionUserId}" />
			</td>
			<th class="alignL pdL10">${menu.LN00222}<font color="red">&nbsp;*</font></th>			
			<td class="sline tit last">	
				<input type="text" id="reqdueDate" name="reqdueDate" value="" class="input_off datePicker stext" size="8"
						style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
		    </td>
		</tr>
		<tr>
			<th class="alignL pdL10">${menu.LN00002}<font color="red">&nbsp;*</font></th><!-- 제목 -->
			<td colspan="3" class="sline tit last" >
				<input type="text" class="text" id="subject" name="subject" value="" style="ime-mode:active;" />
			</td>
		</tr>
		<tr>
			<th class="alignL pdL10">${menu.LN00003 }<font color="red">&nbsp;*</font></th><!-- 내용 -->
			<td class="sline tit last" colspan="3">
				<div style="height:277px;">
					<textarea  class="tinymceText" id="description" name="description"></textarea>
				</div>
				<span style="display:inline-block; color:#0761CF;" class="mgT5">
					<font color="red">&nbsp;* </font>요청내용에 사이즈(가로 600PX)가 큰 이미지를 붙여 넣을 경우 결재 화면에서 깨져 보일 수 있으니 이미지는 작은 사이즈를 사용 해 주시기 바랍니다.
				</span>					
			</td>
		</tr>
		<tr>
			<!-- 첨부문서 -->
			<th class="alignL pdL10">${menu.LN00111}</th>
			<td class="alignL pdL5 last btns">
				<button id="attach" onclick="doAttachFileV4()"></button>
				<div class="tmp_file_wrapper mgT15" style="display:none;">
					<table id="tmp_file_items" name="tmp_file_items" width="100%">
						<colgroup>
							<col width="40px">
							<col width="">
							<col width="80px">
						</colgroup>
						<thead>
							<tr class="header-row">
								<th></th>
								<th class="pdL10">Name</th>
								<th class="alignC">Size</th>
							</tr>
						</thead>
						<tbody name="file-list"></tbody>
					</table>
				</div>
			</td>
		</tr>
	</table>	
	<div class="alignR pdL10">${menu.LN00291}</div>

</form>
<!-- END :: DETAIL -->
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>

<script>
	const fileIDMapV4 = new Map();
	const fileNameMapV4 = new Map();
	const fileSizeMapV4 = new Map();
	const duplMap = new Map();
	
	//************** addFilePop V4 설정 START ************************//
	function getKeyByValue(map, searchValue) {
	  for (let [key, value] of map.entries()) {
	    if (value === searchValue)
	      return key;
	  }
	}
	
	function doAttachFileV4(){
		var url="addFilePopV4.do";
		var data="scrnType=SR&fltpCode=SRDOC";
		openPopup(url+"?"+data,490,450, "Attach File");
	} 
	
	function fnAttacthFileHtmlV4(fileID, fileName, fileSize){
		const id = getKeyByValue(fileNameMapV4, fileName);
		
		fileID = fileID.replace("u","");
		if(!id) {
			fileIDMapV4.set(fileID,fileID,fileSize);
			fileNameMapV4.set(fileID,fileName);
			fileSizeMapV4.set(fileID,fileSize);
		} else {
			duplMap.set(fileID,fileName);
		}
	}
	
	// addFilePopV4에서 파일 삭제시, fileMap에서 해당파일 제거 
	function fnDeleteFileMapV4(fileID, fileName){ 
		fileID = fileID.replace("u","");
		
		if(!getKeyByValue(duplMap, fileName)) {			
			fetch("/removeFile.do?fileName="+fileName);

			fileIDMapV4.delete(String(getKeyByValue(fileNameMapV4, fileName)));
			fileNameMapV4.delete(String(getKeyByValue(fileNameMapV4, fileName)));
			fileSizeMapV4.delete(String(getKeyByValue(fileNameMapV4, fileName)));
		}
	}
	
	function fnDisplayTempFileV4(){
		display_scripts = document.querySelector("#tmp_file_items").children.namedItem("file-list").innerHTML;
		fileIDMapV4.forEach(function(fileID) {
			if(!document.getElementById(fileID)) {
				display_scripts += '<tr id="'+fileID+'"  class="" name="'+fileID+'">'+
				'<td class="delete"><svg xmlns="http://www.w3.org/2000/svg" onclick="fnDeleteFileHtmlV4('+fileID+')" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"/></svg></td>'+
				'<td name="fileName">'+ fileNameMapV4.get(fileID)+'</td>'+
				'<td class="alignR">'+ getFileSize(fileSizeMapV4.get(fileID))+'</td>'+
				'</tr>';
			}
			  
		});
		document.querySelector("#tmp_file_items").children.namedItem("file-list").innerHTML = display_scripts;		
		$(".tmp_file_wrapper").attr('style', 'display: block');
	}
	 
	//  dhtmlx v 4.0 delete file  
	function fnDeleteFileHtmlV4(fileID){
		const duplKey = getKeyByValue(duplMap, fileNameMapV4.get(String(fileID)));
		if(duplKey) {
			duplMap.delete(duplKey);
		}
		var fileName = document.getElementById(fileID).children.namedItem("fileName").innerHTML;
		fileIDMapV4.delete(String(fileID));
		fileNameMapV4.delete(String(fileID));
		fileSizeMapV4.delete(String(fileID));
		
		if(fileName != "" && fileName != null && fileName != undefined){
			$("#"+fileID).remove();
			var url  = "removeFile.do";
			var data = "fileName="+fileName;	
			ajaxPage(url,data,"blankFrame");
		}

		if(document.querySelector("#tmp_file_items").children.namedItem("file-list").children.length === 0) $(".tmp_file_wrapper").attr('style', 'display: none');
	}
	//************** addFilePop V4 설정 END ************************//
	
	/* 첨부문서 다운로드 */
	function FileDownload(checkboxName, isAll){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var seq = new Array();
		var j =0;
		var checkObj = document.all(checkboxName);
		
		// 모두 체크 처리를 해준다.
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = true;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = true;
			}
		}

		// 하나의 파일만 체크 되었을 경우
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
		var url  = "fileDownload.do?seq="+seq+"&scrnType=BRD";
		//alert(url);
		ajaxSubmitNoAdd(document.boardFrm, url,"blankFrame");
		// 모두 체크 해제
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
		var url  = "fileDownload.do?seq="+seq+"&scrnType=BRD";
		ajaxSubmitNoAdd(document.boardFrm, url,"blankFrame");
	}	
	
</script>

</body>
</html>
