<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/jquery.timepicker.css"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_1" arguments="${menu.LN00274}"/> <!-- 도메인 입력 체크 -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_2" arguments="${menu.LN00185}"/> <!-- 시스템 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_3" arguments="${menu.LN00119}"/> <!-- 역할 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="Transfer Reason"/> <!-- 이관사유 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00149" var="WM00149" arguments="${menu.LN00004}"/> <!-- 담당자를 변경 해주십시오  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00018" var="WM00018"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00026" var="WM00026"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00015" var="WM00015" arguments="${menu.LN00222}"/>

<script type="text/javascript">	
	var srType = "${srType}";
	var esType = "${esType}";
	let today = new Date();
	today = today.getFullYear() +
	'-' + ( (today.getMonth()+1) <= 9 ? "0" + (today.getMonth()+1) : (today.getMonth()+1) )+
	'-' + ( (today.getDate()) <= 9 ? "0" + (today.getDate()) : (today.getDate()) );
	
	var searchData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&esType=${esType}&customerNo=${srInfoMap.ClientID}";
	
	jQuery(document).ready(function() {
		$("input.datePicker").each(generateDatePicker);
		jQuery("#comment").focus();
		
		fnSelect('category', searchData+"&level=1&srType=${srType}" , 'getESMSRCategory', '${srInfoMap.Category}', 'Select', 'esm_SQL');
		fnSelect('srType', searchData + "&notInSRTypeList='REQ','ICM','WRK'", 'getSRTypeList', 'Select' , 'Select', 'esm_SQL');
		
		if('${srInfoMap.Category}' != ''){
			fnGetSubCategory('${srInfoMap.Category}','${srType}');
		}
		
		// 요청자 팝업 setting
  		fnCheckRequest();
		
		// category change event
  		$("#srType").on("change", function(){
  			var srType = $("#srType").val();
  			fnSelect('category', searchData+"&level=1&srType=" + srType , 'getESMSRCategory', '', 'Select', 'esm_SQL');
  			fnGetSubCategory('',srType);
  			
  			$("#actionParamter").val("");
  			$("#resultParameter").val("");
 			
  			$("#startSortNum").val("01");
 			$("#docCategory").val("SR");
 			
  		});
		
  		// category change event
  		$("#category").on("change", function(){
  			var category = $("#category").val();
  			var srType = $("#srType").val();
  			fnGetSubCategory(category,srType);
  		});
  		
  		getDicData("BTN", "LN0011").then(data => fnSetButton("attach", "attach",  data.LABEL_NM, "tertiary"));
  		getDicData("BTN", "LN0010").then(data => fnSetButton("temp-save", "",  data.LABEL_NM, "secondary"));
  		getDicData("BTN", "LN0026").then(data => fnSetButton("save", "", data.LABEL_NM));
	});
	
	function getCurrentTime() {
	    const now = new Date();
	    const hours = String(now.getHours()).padStart(2, '0');
	    const minutes = String(now.getMinutes()).padStart(2, '0');
	    return hours + ':' + minutes;
	}
	
	function fnSaveSR(sendParam){
		if(!confirm("${CM00001}")){ return;}
		if(!fnCheckValidation()){return;}
		
		if(sendParam != 'Y'){
			$("#activityStatus").val("01");
		}
		
		var startSortNum = $("#startSortNum").val();
		if(startSortNum === '' || startSortNum === null || startSortNum === undefined ){
			$("#startSortNum").val("01");
		}
		
		const editableDivs = document.querySelectorAll('div[contenteditable="true"]');
	    editableDivs.forEach(div => {
	        const divId = div.id;

	        if (divId) { 
	            const hiddenInput = document.createElement("input");
	            hiddenInput.type = "hidden";
	            hiddenInput.name = divId;
	            hiddenInput.value = div.innerHTML;
	            document.srFrm.appendChild(hiddenInput);
	        }
	    });
	    
	    
		var srType = $("#srType").val();
		var url  = "changeESP.do";
		var target = "saveFrame";
		
		ajaxSubmit(document.srFrm, url, target);
	}
	
	// [요청자 팝업]
	function fnCheckRequest(){
		$("#searchRequestBtn").attr('style', 'display: done');
		$("#ReqUserNM").attr("disabled",false);
	}
	function searchPopupWf(avg){
		var searchValue = $("#ReqUserNM").val();
		if(searchValue == ""){
			alert("${WM00034_3}");
			return;
		}
		var url = avg + "&searchValue=" + encodeURIComponent($('#ReqUserNM').val()) 
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		window.open(url,'_blank','width=340, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSearchNameWf(avg1,avg2,avg3,avg4,avg5,avg6,avg7,avg8,avg9){
		$("#ReqUserNM").val(avg2+"("+avg3+"/"+avg9+")");
		$("#requestUserID").val(avg1);
		$("#requestTeamID").val(avg4);
	}
	
	function fnCheckValidation(){
		var isCheck = true;		
		var srType = $("#srType").val();
		var subject = $("#subject").val();
		var requestUser = $("#requestUserID").val();
		var msg = "";
		getDicData("ERRTP", "LN0008").then(data => msg = data.LABEL_NM);
		
		if(srType == ""){ alert("${menu.LN00011} " + msg); isCheck = false; return isCheck;}
		
		var category = $("#category").val();
		var subCategory = $("#subCategory").val();
		if(category == ""){ alert("${menu.LN00272} " + msg); isCheck = false; return isCheck;}
		if(subCategory == ""){ alert("${menu.LN00273} " + msg); isCheck = false; return isCheck;}
		var description = $("#description").text();
		if(description == ""){ alert("${menu.LN00003} " + msg); isCheck = false; return isCheck;}
		
		if(requestUser == "" || requestUser == null ){ alert("${menu.LN00025} " + msg); isCheck = false; return isCheck;}
		if(subject == ""){ alert("${menu.LN00002} " + msg); isCheck = false; return isCheck;}
		
		
		return isCheck;
	}
	
	function fnGetSubCategory(category,srType){
		if(category == ''){
			$("#subCategory option").not("[value='']").remove();
		} else {
			fnSelect('subCategory', searchData + "&srType=" + srType + "&parentID="+category+"&level=2", 'getESMSRCategory', '${srInfoMap.SubCategory}', 'Select', 'esm_SQL');
		}
	}
	
	function fnCheckSelf(){
		var checkObj = document.all("self");
		if( checkObj.checked == true){ 
			$("#receiptUserID").val("${sessionScope.loginInfo.sessionUserId}");
		} else {
			$("#receiptUserID").val("");
		}
	}

	function fnCallBack(srID,srType,isPopup){
		opener.fnOutCallBack(srID,srType,isPopup);
		self.close();
	}
	
	function fnAlertSRCmp(){
		alert("${WM00026}");
		self.close();
	}
</script>
</head>

<body>
<div style="padding:10px; height:100%; overflow:auto;" id="mainLayer">
<form name="srFrm" id="srFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<input type="hidden" id="srID" name="srID" value="${srInfoMap.SRID}">
	<input type="hidden" id="srCode" name="srCode" value="${srInfoMap.SRCode}">
	<input type="hidden" id="roleType" name="roleType" value="${roleType}">
	<input type="hidden" id="startEventCode" name="startEventCode" value="${startEventCode}">
	<input type="hidden" id="startSortNum" name="startSortNum" value="${startSortNum}">
	<input type="hidden" id="customerNo" name="customerNo" value="${srInfoMap.ClientID}">
	<input type="hidden" id="procRoleTP" name="procRoleTP" value="${srInfoMap.ProcRoleTP}">
	<input type="hidden" id="receiptUserID" name="receiptUserID" value="${srInfoMap.ReceiptUserID}">
	<input type="hidden" id="receiptTeamID" name="receiptTeamID" value="${srInfoMap.ReceiptTeamID}">
	<input type="hidden" id="speCode" name="speCode" value="${srInfoMap.Status}">
	<input type="hidden" id="activityStatus" name="activityStatus" value="05">
	<input type="hidden" id="prevSRCategory" name="prevSRCategory" value="${srInfoMap.Category}">
	<input type="hidden" id="prevSRType" name="prevSRType" value="${srInfoMap.SRType}">
	<input type="hidden" id="docCategory" name="docCategory" value="">
	<input type="hidden" id="actionParameter" name="actionParameter" value="">
	<input type="hidden" id="resultParameter" name="resultParameter" value="">
	<input type="hidden" id="defCategory" name="defCategory" value=""/>
	<input type="hidden" id="isPopup" name="isPopup" value="${isPopup}"/>
	
	<div class="page-title btn-wrap">${menu.ZLN0166}</div>
	<div class="btn-wrap pdB15 pdT10">
		<div class="btns">
			<button id="save" onclick="fnSaveSR('Y')"></button>			
			<button id="temp-save" onclick="fnSaveSR()"></button>
		</div>
	</div>
	
	<table class="form-column-2 new-form" style="table-layout:fixed; margin-bottom:20px;" width="100%" cellpadding="0" cellspacing="0"> 
		<colgroup>
			<col width="150px">
			<col width="calc(50% - 150px)">
			<col width="150px">
			<col width="calc(50% - 150px)">
		</colgroup>	
		<tr>
			<!-- sr type -->
			<th class="alignL pdL10">${menu.LN00011}<font color="red">&nbsp;*</font></th>
			<td class="sline tit last" colspan="3" >
				<select id="srType" Name="srType" style="width:250px">
	       			<option value=''>${menu.ZLN0057}</option>
	     	  	</select>
			</td>
		</tr>
		<tr>
			<!-- 요청자 -->
			<th class="alignL pdL10" style="height:15px;">
			    ${menu.LN00025}<font color="red">&nbsp;*</font>
		    </th>
		  	<td class="sline tit last" >
				<input type="text" class="text" id="ReqUserNM" name="ReqUserNM" value="${srInfoMap.ReqUserNM}" style="width:250px;" disabled/>
				<input type="hidden" id="requestUserID" name="requestUserID" value="${srInfoMap.RequestUserID}" />
				<input type="hidden" id="requestTeamID" name="requestTeamID" value="${srInfoMap.RequestTeamID}" />
				<input type="image" class="image" id="searchRequestBtn" name="searchRequestBtn" style="display:none;" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="searchPopupWf('searchPluralNamePop.do?objId=resultID&objName=resultName&UserLevel=ALL')" value="${menu.LN00047}">
			</td>
		</tr>
		<tr>
			<!-- 서비스 -->
			<th class="alignL pdL10">${srInfoMap.SRArea1NM}</th>
			<td class="sline tit last" >
				${srInfoMap.SRArea1Name}
				<input type="hidden" id="srArea1" name="srArea1" value="${srInfoMap.SRArea1}" style="ime-mode:active;width:250px;" />
			</td>
	   		<!-- 파트 -->
			<th class="alignL pdL10">${srInfoMap.SRArea2NM}</th>
			<td class="sline tit last">
				${srInfoMap.SRArea2Name}
				<input type="hidden" id="srArea2" name="srArea2" value="${srInfoMap.SRArea2}" style="ime-mode:active;width:250px;" />
			</td>
		</tr>
		<tr>
			<!-- 의뢰유형 -->
			<th class="alignL pdL10">${menu.LN00272}<font color="red">&nbsp;*</font></th>
			<td class="sline tit last"><select id="category" name="category" class="sel"  style="width:90%;"></select></td>
			<!-- 서브 의뢰유형 -->
			<th class="alignL pdL10">${menu.LN00273}<font color="red">&nbsp;*</font></th>
			<td class="sline tit last"><select id="subCategory" name="subCategory" class="sel" style="width:90%;"></select></td>
		</tr>
		<tr>
			<!-- 첨부문서 -->
			<th class="alignL pdL10">${menu.LN00111}</th>
			<td class="alignL pdL5 last btns" colspan="3">
				<button id="attach" onclick="doAttachFileV4()"></button>
				<div class="tmp_file_wrapper mgT15" style="display:none;">
					<table id="tmp_file_items" name="tmp_file_items" width="100%">
						<colgroup>
							<col width="40px">
							<col width="">
							<col width="70px">
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
	
	<!-- 내부요청/작업 & 배포 & 문제 : TODO -->
	<!--  sr Type 별 내용 -->
	<table id="attr_table" class="form-column-2 new-form" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="150px">
			<col width="calc(50% - 150px)">
			<col width="150px">
			<col width="calc(50% - 150px)">
		</colgroup>
		
		<tr>
			<th class="alignL pdL10">${menu.LN00002}<font color="red">&nbsp;*</font></th><!-- 제목 -->
			<td class="sline tit last" colspan="3">
				<input type="text" class="text" id="subject" name="subject" value="${srInfoMap.Subject}" style="ime-mode:active; " />
			</td>
		</tr>		
		<tr>
			<th class="alignL pdL10">${menu.LN00003 }<font color="red">&nbsp;*</font></th><!-- 내용 -->
			<td class="sline tit last" colspan="3">
				<div id="description" contenteditable="true" style="width:100%;height:200px; border:1px solid #ddd; border-radius:6px; padding:10px; overflow:scroll;">${description }</div>					
			</td>
		</tr>
		
		<!-- 완료요청일 -->
		<tr>
			<th class="alignL pdL10">${menu.LN00222}<font color="red">&nbsp;*</font></th>
			<td class="sline tit last" >
				<input type="text" id="reqdueDate" name="reqdueDate" class="text datePicker stext" size="8" value="${fn:substring(srInfoMap.ReqDueDate, 0, 10)}"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
			</td>
		</tr>
		
		
	</table>
	
	
	</form>
</div>
<!-- END :: DETAIL -->
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>

<script>
	//************** addFilePop V4 설정 START ************************//
	
	function doAttachFileV4(){
		var url="addFilePopV4.do";
		var data="scrnType=SR&fltpCode=SRDOC";
		openPopup(url+"?"+data,490,450, "Attach File");
	} 
	
	var fileIDMapV4 = new Map();
	var fileNameMapV4 = new Map();
	var fileSizeMapV4 = new Map();
	
	function fnAttacthFileHtmlV4(fileID, fileName, fileSize){ 
		fileID = fileID.replace("u","");
		fileIDMapV4.set(fileID,fileID,fileSize);
		fileNameMapV4.set(fileID,fileName);
		fileSizeMapV4.set(fileID,fileSize);
	}
	
	// addFilePopV4에서 파일 삭제시, fileMap에서 해당파일 제거 
	function fnDeleteFileMapV4(fileID){ 
		fileID = fileID.replace("u","");		
		fileIDMapV4.delete(String(fileID));
		fileNameMapV4.delete(String(fileID));
		fileSizeMapV4.delete(String(fileID));
		if(fileIDMapV4.size === 0) $(".tmp_file_wrapper").attr('style', 'display: none');
	}
	
	function fnDisplayTempFileV4(){				
		display_scripts = document.querySelector("#tmp_file_items").children.namedItem("file-list").innerHTML;
		fileIDMapV4.forEach(function(fileID) {
			  display_scripts += '<tr id="'+fileID+'"  class="" name="'+fileID+'">'+
			  '<td class="delete"><svg xmlns="http://www.w3.org/2000/svg" onclick="fnDeleteFileHtmlV4('+fileID+')" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"/></svg></td>'+
			  '<td>'+ fileNameMapV4.get(fileID)+'</td>'+
			  '<td class="alignR">'+ getFileSize(fileSizeMapV4.get(fileID))+'</td>'+
			  '</tr>';
		});
		document.querySelector("#tmp_file_items").children.namedItem("file-list").innerHTML = display_scripts;		
		$(".tmp_file_wrapper").attr('style', 'display: block');
	
		fileIDMapV4 = new Map();
		fileNameMapV4 = new Map();
		fileSizeMapV4 = new Map();
	}
	 
	//  dhtmlx v 4.0 delete file  
	function fnDeleteFileHtmlV4(fileID){
		var fileName = document.getElementById(fileID).innerText;		
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
