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
<script src="${root}cmm/js/tinymce_v7/tinymce.min.js" type="text/javascript"></script>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
 
<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/jquery.timepicker.css">

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
	var chkReadOnly = false;
</script>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_1" arguments="${srAreaLabelNM1}/${srAreaLabelNM2}"/> <!-- 도메인 입력 체크 -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_2" arguments="${srAreaLabelNM2}"/> <!-- 시스템 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_3" arguments="${menu.LN00272}"/> <!-- 카테고리 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_4" arguments="${menu.LN00273}"/> <!-- 하위 카테고리 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00002}"/> <!-- 제목 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00003}"/> <!-- 개요 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_4" arguments="${menu.LN00025}"/> <!-- 요청자 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_5" arguments="${menu.LN00222}"/> <!-- 완료요청일 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00015" var="WM00015" arguments="${menu.LN00222}"/>
<script type="text/javascript">
	let today = new Date();
	const clientID = '${sessionScope.loginInfo.sessionClientId}';
	
	today = today.getFullYear() +
	'-' + ( (today.getMonth()+1) <= 9 ? "0" + (today.getMonth()+1) : (today.getMonth()+1) )+
	'-' + ( (today.getDate()) <= 9 ? "0" + (today.getDate()) : (today.getDate()) );
	
	var fileSize = "${itemFiles.size()}";
	var scrnType = "${scrnType}";
	const srType = '${srType}';
	
	// select list 용 parameter
	var selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&esType=${esType}";
	
	getDicData("GUIDELN", "ZLN0001").then(res => document.querySelector("#desc-guide").insertAdjacentText("beforeend", res.LABEL_NM))
	
	jQuery(document).ready(function() {
		$("#customerNo").val('${sessionScope.loginInfo.sessionClientId}');
		fnSelectSetting("Y");
		
		$("#ReqUserNM").val("${sessionScope.loginInfo.sessionUserNm}");
		$("#requestUserID").val("${sessionScope.loginInfo.sessionUserId}");
			
		$("input.datePicker").each(generateDatePicker);
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}";
  		
		// button setting  		
  		getDicData("BTN", "LN0009").then(data => fnSetButton("save", "", data.LABEL_NM));
  		//getDicData("BTN", "LN0010").then(data => fnSetButton("temp-save", "", data.LABEL_NM, "secondary"));
  		getDicData("BTN", "LN0011").then(data => fnSetButton("attach", "attach", data.LABEL_NM, "tertiary"));

  		// button setting2
  		getDicData("BTN", "LN0009").then(data => fnSetButton("save2", "", data.LABEL_NM));
  		//getDicData("BTN", "LN0010").then(data => fnSetButton("temp-save2", "", data.LABEL_NM, "secondary"));
  		
  		getDicData("GUIDELN", "LN0001").then(data => document.querySelector("#srAreaSearch").placeholder = data.LABEL_NM);
  		  	
  		$("#category").on("change", function(){
  			var category = $("#category").val();
  			fnGetSubCategory(category);
  		});
  		
  		$("#subCategory").on("change", function(){
  			setDesc();
  		});
  		
  		// 고객완료 희망일
  		document.querySelector("#reqdueDate").value = today;
  		
  		fnSRAreaLoad();
  		
	});
	
	/*** SR Select function start ***/
	function fnSelectSetting(all) {
		
		// 00. reset
		resetSelect(all);
		// 01. category setting
		fnSelect('category', selectData +"&srType=" + srType +"&level=1&customerNo=${sessionScope.loginInfo.sessionClientId}", 'getESPSRCategory', '${category}', 'Select','esm_SQL');
		fnGetSubCategory('');
	}
	
	// subCategory setting ( * customerNo / category )
	function fnGetSubCategory(parentID){
		
		if(parentID == ''){
			$("#subCategory option").not("[value='']").remove();
		} else {
			fnSelect('subCategory', selectData + "&srType=" + srType + "&parentID="+parentID + "&customerNo=${sessionScope.loginInfo.sessionClientId}", 'getESPSRCategory', '${subCategory}', 'Select', 'esm_SQL');
		}
	}
	
	// select option reset
	function resetSelect(all){
		
		$("#category").val("");
		$("#subCategory").val("");
		
		if(all == "Y"){
			$("#srAreaSearch").val("");
			$("#srArea1").val("");
			$("#srArea2").val("");
		}
		
		return;
	}
	
	function fnCheckValidation(){
		var isCheck = true;
		var requestUser = document.querySelector("#requestUserID");
		var reqdueDate = document.querySelector("#reqdueDate");
		var category = document.querySelector("#category");
		var subCategory = document.querySelector("#subCategory");
		var srArea1 = document.querySelector("#srArea1");
		var srArea2 = document.querySelector("#srArea2");
		var srAreaSearch = document.querySelector("#srAreaSearch");
		var subject = document.querySelector("#subject");
		var description = tinyMCE.get('description').getContent();
		
		if(subject.value.length > 200){alert("제목의 글자수는 200자를 넘을 수 없습니다."); subject.focus(); subject.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		if(requestUser.value == "" || requestUser == null ){ alert("${WM00034_4}"); requestUser.focus(); requestUser.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		if(reqdueDate.value == ""){alert("${WM00034_5}"); reqdueDate.focus(); reqdueDate.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		if(reqdueDate.value < today) {alert("${WM00015}"); reqdueDate.focus(); reqdueDate.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		if(subject.value.trim() == ""){ alert("${WM00034_1}"); subject.focus(); subject.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		if(description == "" ){ alert("${WM00034_2}"); tinyMCE.get('description').focus(); document.querySelector("#tinymce").scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		
		if(category.value == ""){ alert("${WM00025_3}"); category.focus(); category.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		if(subCategory.value == ""){ alert("${WM00025_4}"); subCategory.focus(); subCategory.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		
		if(srArea1.value == ""){ alert("${WM00025_1}"); srAreaSearch.focus(); srAreaSearch.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		if(srAreaSearch.value == ""){ alert("${WM00025_1}"); srAreaSearch.focus(); srAreaSearch.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		
		return isCheck;
	}
	
	function fnSaveSR(sendParam){
		// 임시저장
		if(sendParam != "Y"){
			$("#activityStatus").val("01");
			$("#isPublic").val("0");
			if(!fnCheckValidation('Y')){return;}
		} else {
			if(!fnCheckValidation()){return;}
		}
		if(!confirm("${CM00001}")){ return;}
		
		var url  = "createESP.do";
		$('#loading').fadeIn(150);
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

	document.getElementById("srAreaBtn").addEventListener("click", function() {
		searchSrArea();
	})
	
	function searchSrArea(){
		window.open('searchSrAreaPop.do?srType=' + srType + '&roleFilter=${roleFilter}&myCSR=${myCSR}&priorityClientID=' + $("#customerNo").val(),'window','width=1000, height=500, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSrArea(clientID, srArea1, srArea2, srArea2Name){
		
		//var customerNo = $("#customerNo").val();
		//$("#customerNo").val(clientID);
		
		$("#srArea1").val(srArea1);
		$("#srArea2").val(srArea2);
		$("#srAreaSearch").val(srArea2Name);
	}
	
	// srArea setting
	let srAreaData = [];
	function fnSRAreaLoad() {		
		fetch("/olmapi/srArea/?languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=" + srType + "&myCSR=Y&priorityClientID=" + $("#customerNo").val())
		.then((response) => response.json())
		.then(data => srAreaData = data);
	}
	
	const srAreaSearch = document.querySelector("#srAreaSearch");
	const autoComplete = document.querySelector(".autocomplete");
	
	let nowIndex = 0;
	let matchDataList, findIndex = [];
	srAreaSearch.addEventListener("keyup", function(event) {
	  // 검색어
		const value = srAreaSearch.value;

		switch (event.keyCode) {
		    // UP KEY
		    case 38:
		      	nowIndex = Math.max(nowIndex - 1, 0);
		      	break;

		    // DOWN KEY
		    case 40:
		    	nowIndex = Math.min(nowIndex + 1, matchDataList.length - 1);
		      	break;

		    // ENTER KEY
		    case 13:
		    	document.querySelector("#srAreaSearch").value = matchDataList[nowIndex].SRArea2Name || matchDataList[nowIndex].SRArea1Name || "";
				document.querySelector("#srArea1").value = matchDataList[nowIndex].SRArea1 || "";
				document.querySelector("#srArea2").value = matchDataList[nowIndex].SRArea2 || "";
				
				// customerNo 변경 감지 > category 재 셋팅
				/* let customerNo = document.querySelector("#customerNo").value;
				if(customerNo === undefined || customerNo == '' || customerNo == null || customerNo != matchDataList[nowIndex].ClientID){
					document.querySelector("#customerNo").value = matchDataList[nowIndex].ClientID || "";
					fnSelectSetting();
				} */
				
				// 초기화
				nowIndex = 0;
				matchDataList.length = 0;
				break;
	      
	    	default:
	    		// 자동완성 필터링
		    	matchDataList, findIndex = [];
				if(value) {
					//if(document.querySelector("#company").value == "") matchDataList = srAreaData.filter(e => e.SRArea2Name.includes(value));
					//else matchDataList = srAreaData.filter(e => e.ClientID === document.querySelector("#company").value).filter(e => e.SRArea2Name.includes(value));
					 matchDataList = srAreaData.filter(e => e.SRArea1Name.match(new RegExp(value, "i")) || e.SRArea2Name.match(new RegExp(value, "i")));
				} else {
					matchDataList = []
				}
				break;
		}
		
		// 리스트 보여주기
		showList(matchDataList, value, nowIndex);
	});

	const showList = (data, value, nowIndex) => {
		// 정규식으로 변환
		const regex = new RegExp(`(\\\(${value}\\))`, "g");
		data.length > 0 ? autoComplete.classList.add("on") : autoComplete.classList.remove("on");
		autoComplete.innerHTML = data.map((e, index) => `<div class='\${nowIndex === index ? "active" : ""}' data-index='\${e.RNUM}'><span>\${e.CompanyName}</span><span>\${e.SRArea1Name}</span><span>\${e.SRArea2Name.replace(regex, "<mark>$1</mark>")}</span></div>`).join("");
	};
	
	autoComplete.addEventListener("mouseover", function(e) {
		autoComplete.childNodes.forEach(child => child.classList.remove("active"))
	});
	
	// srArea 팝업 영역 외 클릭시 팝업 닫기
	document.addEventListener("click", function(e) {
		if(autoComplete.contains(e.target)) {
			let parentIndex = e.target.parentNode.getAttribute("data-index");
			document.querySelector("#srAreaSearch").value = srAreaData.filter(e => e.RNUM == parentIndex)[0].SRArea2Name || srAreaData.filter(e => e.RNUM == parentIndex)[0].SRArea1Name;
			document.querySelector("#srArea1").value = srAreaData.filter(e => e.RNUM == parentIndex)[0].SRArea1;
			document.querySelector("#srArea2").value = srAreaData.filter(e => e.RNUM == parentIndex)[0].SRArea2 || "";
			
			// customerNo 변경 감지 > category 재 셋팅
			/* let customerNo = document.querySelector("#customerNo").value;
			if(customerNo === undefined || customerNo == '' || customerNo == null || customerNo != srAreaData.filter(e => e.RNUM == parentIndex)[0].ClientID){
				document.querySelector("#customerNo").value = srAreaData.filter(e => e.RNUM == parentIndex)[0].ClientID;
				fnSelectSetting();
			} */
			
			
		}
	    if(e.target.id !== "srAreaSearch" && autoComplete.classList.contains("on")) autoComplete.classList.remove("on");
	})
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
	<input type="hidden" id="esType" name="srType" value="${srType}">
	<input type="hidden" id="srStatus" name="srStatus" value="${srStatus}">
	<input type="hidden" id="requestUserID" name="requestUserID" value="${sessionScope.loginInfo.sessionUserId}" />
	<input type="hidden" id="customerNo" name="customerNo" value="" />
	<input type="hidden" id="startEventCode" name="startEventCode" value="${startEventCode}">
	<input type="hidden" id="startSortNum" name="startSortNum" value="${startSortNum}">
	<input type="hidden" id="resultParameter" name="resultParameter" value="${resultParameter}">
	<input type="hidden" id="actionParameter" name="actionParameter" value="${actionParameter}">
	<input type="hidden" id="activityStatus" name="activityStatus" value="05"/>
	<input type="hidden" id="isPublic" name="isPublic" value=""/>
	<input type="hidden" id="procPathID" name="procPathID" value="${procPathID}">
	<input type="hidden" id="receiveAssigned" name="receiveAssigned" value="Y">
	<input type="hidden" id="dueDate" name="dueDate" value="" />
	<input type="hidden" id="defCategory" name="defCategory" value=""/>
	
	
	<div class="page-title">${menu.LN00280}</div>
	<div class="btn-wrap pdB15 pdT10">
		<div class="btns">
			<button id="save" onclick="fnSaveSR('Y')"></button>
			<!-- <button id="temp-save" onclick="fnSaveSR()"></button> -->
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
		</tr>
		<tr>
			<th class="alignL pdL10">${menu.LN00222}<font color="red">&nbsp;*</font></th>			
			<td class="sline tit last">	
				<input type="text" id="reqdueDate" name="reqdueDate" value="" class="input_off datePicker stext" size="8"
						style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
		    </td>
		</tr>
		<tr>
			<input type="hidden" id="company" name="company" />			
			<!-- SR Area -->
			<th class="alignL pdL10">${srAreaLabelNM1}/${srAreaLabelNM2}<font color="red">&nbsp;*</font></th>
			<td class="sline tit last" style="position:relative;">
				<input type="text" class="text" id="srAreaSearch" name="srAreaSearch" style="width:250px;" autocomplete="off"/>
				<img id="srAreaBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="searchSrArea()"/>
				<input type="hidden" id="srArea1" name="srArea1" />
				<input type="hidden" id="srArea2" name="srArea2" />
				<ul class="autocomplete"></ul>
			</td>
		</tr>
		<tr>
			<!-- 카테고리 -->
			<th class="alignL pdL10">${menu.LN00272}<font color="red">&nbsp;*</font></th>
			<td class="sline tit last">
				<select id="category" name="category" class="sel" style="width:250px;">
					<option value=''>${menu.ZLN0057}</option>
				</select>
			</td>
		</tr>
		<tr>
			<th class="alignL pdL10">${menu.LN00273}<font color="red">&nbsp;*</font></th>
			<td class="sline tit last">
				<select id="subCategory" name="subCategory" class="sel" style="width:250px;">
					<option value=''>${menu.ZLN0057}</option>
				</select>
			</td>
		</tr>
		<tr>
			<th class="alignL pdL10">${menu.LN00002}<font color="red">&nbsp;*</font></th><!-- 제목 -->
			<td colspan="3" class="sline tit last" >
				<input type="text" class="text" id="subject" name="subject" value="" style="ime-mode:active;" />
			</td>
		</tr>
		<tr>
			<th class="alignL pdL10">${menu.LN00003}<font color="red">&nbsp;*</font></th><!-- 내용 -->
			<td class="sline tit last" colspan="3">
				<div style="height:277px;">
					<textarea  class="tinymceText" id="description" name="description"></textarea>
				</div>
				<span style="display:inline-block; color:#0761CF;" class="mgT5" id="desc-guide">
					<font color="red">&nbsp;* </font>
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
								<th class="pdL10">${menu.LN00028}</th>
								<th class="alignC">${menu.ZLN0111}</th>
							</tr>
						</thead>
						<tbody name="file-list"></tbody>
					</table>
				</div>
			</td>
		</tr>
	</table>	
	<div class="alignR pdL10">${menu.LN00291}</div>
	
	<div class="btn-wrap pdB15 pdT10">
		<div class="btns">
			<button id="save2" onclick="fnSaveSR('Y')"></button>
			<!-- <button id="temp-save2" onclick="fnSaveSR()"></button> -->
		</div>
	</div>
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
	
	// 본문 템플릿 예외처리
	function setDesc() {
		
		const languageID = '${sessionScope.loginInfo.sessionCurrLangType}';
		
		if(languageID === "1042"){
			// INC - 장애/사고 신고 - IT 시스템 장애
			var defMsg = "1. 장애 인지 시점: <br />";
				defMsg += "2. 장애 내용: <br />";
				defMsg += "3. 에러 메시지 (화면캡처 등): <br />";
			
			// REQ - 소프트웨어 (Office, Adobe 등) - 지급
			var defMsg1 = "1. 대상(사용자): <br />"; 
				defMsg1 += "2. 목적: <br />";
				defMsg1 += "3. 기간: <br />";
			
			// REQ - 하드웨어 - 지급
			var defMsg2 = "1. 요청 품목(노트북, 모니터, 마우스 등): <br />"; 
				defMsg2 += "2. 요청 수량: <br />";
				defMsg2 += "3. 목적: <br />";
			
			// REQ - 하드웨어 - 단기대여 (3개월 이내)
			var defMsg3 = "1. 요청 품목(노트북, 모니터, 마우스 등): <br />"; 
				defMsg3 += "2. 요청 수량: <br />";
				defMsg3 += "3. 목적: <br />";
				defMsg3 += "4. 사용 기한: <br />";
			
			// REQ - 하드웨어 - 교체/수리
			var defMsg4 = "1. 요청 품목(노트북, 모니터, 마우스 등): <br />"; 
				defMsg4 += "2. 사유: <br />";
			
			// REQ - 하드웨어 - 반납
			var defMsg5 = "1. 반납 물품: <br />";
			
			// REQ - 네트워크 - 신규 가설 (랜케이블, Wi-Fi)
			var defMsg6 = "1. 가설 장소: <br />";
				defMsg6 += "2. 필요 인원수: <br />";
				
			// REQ - 어플리케이션 - 계정 신규 생성
			var defMsg7 = "1. 요청 대상자: (사번, 성명, 이메일, 부서) <br />";
				defMsg7 += "2. 대상 시스템: <br />";
				defMsg7 += "3. 요청 사유: <br />";
				defMsg7 += "4. 기타: <br /><br />";
				defMsg7 += "※ 요청 대상자가 외부업체 임직원이면 사번 대신 소속 회사명을 기입하시기 바랍니다. <br />";
				defMsg7 += "※ SAP 계정 신청 시 기존 SAP ID와 같은 권한이 필요한 경우, 해당 SAP ID를 기입하세요. <br />";
			
			// REQ - 어플리케이션 - 권한 설정
			var defMsg8 = "1. 요청 대상자: (사번, 성명, 이메일, 부서)<br />";
				defMsg8 += "2. 기존 권한:<br />";
				defMsg8 += "3. 변경 권한:<br />";
				defMsg8 += "4. 권한 부여 기간:<br />";
				defMsg8 += "5. 사유:<br />";
			
			// REQ - 어플리케이션 - 겸직 설정
			var defMsg9 = "1. 요청 대상자: (사번, 성명, 이메일, 부서) <br/>";
				defMsg9 += "2. 겸직 설정대상: (대상법인, 부서) <br/>";
				
			
			// REQ - 어플리케이션 - 원격 접속(VPN)
			var defMsg10 = "1. 요청 대상자(성명, 부서명, 연락처, 메일주소): <br />";
				defMsg10 += "※ 요청 대상자가 외부업체 임직원이면 사번 대신 소속 회사명을 기입하시기 바랍니다. <br />";
				defMsg10 += "2. 대상 시스템 (ex. 그룹웨어, S/4HANA, 파일서버, Confinas, Glostom, e-Accouting, 기타):<br />";
				defMsg10 += "3. 신청 유형(신규 / 해지):  <br />";
				defMsg10 += "4. 신청 사유: <br />";
				defMsg10 += "5. 신청 기간(최대 6개월 이내): <br /><br />";
				defMsg10 += "※ 신청 시 반드시 주의사항을 읽어보고 신청하시기 바랍니다. <br />";
				defMsg10 += "① 1인 1계정 사용이 원칙이며, 타인에게 공유해서는 안됨 (ID/PW 유출을 인지한 즉시 IT팀에 신고하여 사용 중지 요청) <br />";
				defMsg10 += "② 업무 목적으로만 사용하여야 하며, 사적 용도로 사용해서는 안됨 <br />";
				defMsg10 += "③ VPN 계정을 통해 내부 자료가 유출된 경우, 이에 대한 책임은 계정 소유자에게 있으며 정보보안 규정에 의거하여 조치함 <br />";
				defMsg10 += "④ 외부 협력사 계정은 3개월 이상 미사용시 해지 처리됨 <br />";
				defMsg10 += "⑤ 결재선: 신청자 > 부서장 전결 (부서장 부재 시에는 차석 / 부서장도 셀프 결재 필요) <br />";
			
			// REQ - 어플리케이션 - 데이터 변경
			var defMsg11 = "1. 변경 사유: <br />";
				defMsg11 += "2. 변경 항목 (변경 컬럼명, 항목 정의):<br />";
				defMsg11 += "3. 변경 내용: (기존값 → 변경값) :<br />";
				defMsg11 += "4. 변경 적용일시: <br />";
				defMsg11 += "5. 기타: <br />";
			
			// REQ - 정보보안 - 외부 저장소(USB/Cloud) 이용
			var defMsg12 = "1. 외부 저장소 종류:<br />"; 
				defMsg12 += "2. 요청 사유:<br />";
				defMsg12 += "3. 사용 시작일 및 종료일: <br />";
			
			// REQ - 정보보안 - 비인가 사이트 접속 허용
			var defMsg13 = "1. 예외 요청 대상: <br />";
				defMsg13 += "2. 예외 요청 사유: <br />";
				defMsg13 += "3. 예외 사용 시작일 및 종료일: <br />";
				
		} else {
			// 장애/사고 신고
			var defMsg = "1. Incident Detection Time: <br />";
				defMsg += "2. Incident Description: <br />";
				defMsg += "3. Error Message (Screenshot): <br />";
				
			// REQ - 소프트웨어 (Office, Adobe 등) - 지급
			var defMsg1 = "1. Recipient (User): <br />"; 
				defMsg1 += "2. Purpose: <br />";
				defMsg1 += "3. Usage Period: <br />";
					
			// REQ - 하드웨어 - 지급
			var defMsg2 = "1. Items (Laptop, Monitor, Mouse, etc.): <br />"; 
				defMsg2 += "2. Quantity: <br />";
				defMsg2 += "3. Purpose: <br />";
			
			// REQ - 하드웨어 - 단기대여 (3개월 이내)
			var defMsg3 = "1. Items (Laptop, Monitor, Mouse, etc.): <br />"; 
				defMsg3 += "2. Quantity: <br />";
				defMsg3 += "3. Purpose: <br />";
				defMsg3 += "4. Usage Period:: <br />";
			
			// REQ - 하드웨어 - 교체/수리
			var defMsg4 = "1. Items (Laptop, Monitor, Mouse, etc.): <br />"; 
				defMsg4 += "2. Reason: <br />";
			
			// REQ - 하드웨어 - 반납
			var defMsg5 = "1. Return Items: <br />";
			
			// REQ - 네트워크 - 신규 가설 (랜케이블, Wi-Fi)
			var defMsg6 = "1. Installation Place: <br />";
				defMsg6 += "2. Number of people needed: <br />";
				
			// REQ - 어플리케이션 - 계정 신규 생성
			var defMsg7 = "1. Requester (Employee ID, Name, Email, Department): <br />";
				defMsg7 += "2. Target System: <br />";
				defMsg7 += "3. Reason: <br />";
				defMsg7 += "4. Remarks: <br /><br />";
				defMsg7 += "※ If the requester is an external vendor employee, please provide the company name instead of Employee ID. <br />";
				defMsg7 += "※ When requesting an SAP account, enter the SAP ID of an existing user if the same access is required. <br />";
			
			// REQ - 어플리케이션 - 권한 설정
			var defMsg8 = "1. Requester (Employee ID, Name, Email, Department): <br />";
				defMsg8 += "2. Current Permissions:<br />";
				defMsg8 += "3. Requested Permissions: <br />";
				defMsg8 += "4. Usage Period:<br />";
				defMsg8 += "5. Reason:<br />";
			
			// REQ - 어플리케이션 - 겸직 설정
			var defMsg9 = "1. Requester(Employee ID, Name, Email, Department): <br/>";
				defMsg9 += "2. Concurrent Position Details(Affiliate, Department):<br/><br/>";
			
			// REQ - 어플리케이션 - 원격 접속(VPN)
			var defMsg10 = "1. Requester (Name, Department, H.P, Email): <br />";
				defMsg10 += "※ If the requester is an external vendor employee, please provide the company name instead of Employee ID.<br />";
				defMsg10 += "2. Target System (ex. Groupware, S/4HANA, File-Server, Confinas, Glostom, e-Accouting, etc.):<br />";
				defMsg10 += "3. Request Type (New/Revoke) :<br />";
				defMsg10 += "4. Purpose:<br />";
				defMsg10 += "5. Usage Period (Up to 6 months):<br /><br />";
				defMsg10 += "※ Please make sure to read the guidelines carefully before submitting your request.<br />";
				defMsg10 += "①Each individual is permitted to use only one account, and accounts must not be shared with others. (If you become aware of ID/PW exposure, immediately report it to the IT team and request suspension.) <br />";
				defMsg10 += "②Accounts must be used strictly for business purposes and not for personal use.<br />";
				defMsg10 += "③If internal data is leaked through the VPN account, the account owner will be held responsible, and actions will be taken in accordance with the information security policy.<br />";
				defMsg10 += "④Accounts issued to external partners will be terminated if unused for more than three 3 months.<br />";
				defMsg10 += "⑤Approval Line: Applicant → Department Head (If the Department Head is unavailable, the deputy may approve. / The Department Head must also approve his/her own request.)<br />";
			
			// REQ - 어플리케이션 - 데이터 변경
			var defMsg11 = "1. Reason: <br />";
				defMsg11 += "2. Target Item (Column Name, Definition):<br />";
				defMsg11 += "3. Change Details (Old Value → New Value):<br />";
				defMsg11 += "4. Effective Date & Time: <br />";
				defMsg11 += "5. Remarks: <br />";
			
			// REQ - 정보보안 - 외부 저장소(USB/Cloud) 이용
			var defMsg12 = "1. External Storage Type (USB, HDD, SSD, Cloud Service etc.):<br />"; 
				defMsg12 += "2. Reason:<br />";
				defMsg12 += "3. Usage Period: <br />";
			
			// REQ - 정보보안 - 비인가 사이트 접속 허용
			var defMsg13 = "1. Exception Target <br />";
				defMsg13 += "2. Reason for Exception: <br />";
				defMsg13 += "3. Usage Period: <br />";
			
		}
		
		if( $('#subCategory').val() == 'NCP001001' ) { 
			tinyMCE.get('description').setContent(defMsg);
		}
		else if( $('#subCategory').val() == 'REQ001001' ) { 
			tinyMCE.get('description').setContent(defMsg1);
		}
		else if( $('#subCategory').val() == 'REQ002001') {  
			tinyMCE.get('description').setContent(defMsg2);
		}
		else if( $('#subCategory').val() == 'REQ002002' ) { 
			tinyMCE.get('description').setContent(defMsg3);
		}
		else if( $('#subCategory').val() == 'REQ002003' ) { 
			tinyMCE.get('description').setContent(defMsg4);
		}
		else if( $('#subCategory').val() == 'REQ002004' ) { 
			tinyMCE.get('description').setContent(defMsg5);
		}
		else if( $('#subCategory').val() == 'REQ003001' ) { 
			tinyMCE.get('description').setContent(defMsg6);
		}
		else if( $('#subCategory').val() == 'REQ004001' ) { 
			tinyMCE.get('description').setContent(defMsg7);
		}
		else if( $('#subCategory').val() == 'REQ004003') {  
			tinyMCE.get('description').setContent(defMsg8);
		}
		else if( $('#subCategory').val() == 'REQ004004' ) { 
			tinyMCE.get('description').setContent(defMsg9);
		}
		else if( $('#subCategory').val() == 'REQ004005' ) { 
			tinyMCE.get('description').setContent(defMsg10);
		}
		else if( $('#subCategory').val() == 'REQ004006' ) { 
			tinyMCE.get('description').setContent(defMsg11);
		}
		else if( $('#subCategory').val() == 'REQ005001' ) { 
			tinyMCE.get('description').setContent(defMsg12);
		}
		else if( $('#subCategory').val() == 'REQ005002' ) { 
			tinyMCE.get('description').setContent(defMsg13);
		} else {
			tinyMCE.get('description').setContent(" ");
		}
	}
	
</script>

</body>
</html>
