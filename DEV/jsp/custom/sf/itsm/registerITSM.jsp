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
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js}"></script>
<link rel="stylesheet"href="${root}cmm/js/dhtmlx/suite.css">
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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_6" arguments="${menu.ZLN0134}"/> <!-- 완료요청일 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00015" var="WM00015" arguments="${menu.LN00222}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_7" arguments="${menu.ZLN0124 }"/> <!-- 요청 목적 및 사유 체크  -->
<script type="text/javascript">
	let today = new Date();
	let clientID = '${sessionScope.loginInfo.sessionClientId}';
	
	today = today.getFullYear() +
	'-' + ( (today.getMonth()+1) <= 9 ? "0" + (today.getMonth()+1) : (today.getMonth()+1) )+
	'-' + ( (today.getDate()) <= 9 ? "0" + (today.getDate()) : (today.getDate()) );
	
	var fileSize = "${itemFiles.size()}";
	var scrnType = "${scrnType}";
	let srType = $("#srType").val();
	if(srType === "" || srType === null || srType === undefined) srType = '${srType}';
	
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
  		getDicData("BTN", "LN0010").then(data => fnSetButton("temp-save", "", data.LABEL_NM, "secondary"));
  		getDicData("BTN", "LN0011").then(data => fnSetButton("attach", "attach", data.LABEL_NM, "tertiary"));

  		// button setting2
  		getDicData("BTN", "LN0009").then(data => fnSetButton("save2", "", data.LABEL_NM));
  		getDicData("BTN", "LN0010").then(data => fnSetButton("temp-save2", "", data.LABEL_NM, "secondary"));
  		
  		getDicData("GUIDELN", "LN0001").then(data => document.querySelector("#srAreaSearch").placeholder = data.LABEL_NM);
  		  	
  		fnGetCategory(srType);
		fnSelectSetting("Y");
  		
  		$("#customerNo").on("change", function(){
  			fnSelectSetting("Y");
  		});
  		
  		$("#category").on("change", function(){
  			var category = $("#category").val();
  			fnGetSubCategory(category);
  		});
  		
  		// 고객완료 희망일
  		document.querySelector("#reqdueDate").value = today;
  		
  		fnSRAreaLoad();
  		
  		// 요청자 팝업 setting
  		fnCheckRequest();
  	
  		// 요청자 팝업 enter
  		document.getElementById('ReqUserNM').addEventListener('keydown', function(event) {
	        if (event.key === 'Enter') {
	            event.preventDefault(); // 기본 Enter 동작 방지 (필요시)
	            searchPopupWf(); // 함수 호출
	        }
    	});
	});
	
	/*** SR Select function start ***/
	function fnSelectSetting(all) {
		// 00. reset
		resetSelect(all);
		// 01. category setting
		fnGetCategory(srType);
		fnGetSubCategory('');
	}
	
	// Category setting ( * customerNo / category )
	function fnGetCategory(srType){
		if(srType == ''){
			$("#category option").not("[value='']").remove();
		} else {
			fnSelect('category', selectData +"&srType=" + srType +"&level=1&customerNo=" + clientID + "&procPathID=${procPathID}", 'getESPSRCategory', '${category}', 'Select','esm_SQL');
		}
	}
	
	// subCategory setting ( * customerNo / category )
	function fnGetSubCategory(parentID){
		
		if(parentID == ''){
			$("#subCategory option").not("[value='']").remove();
		} else {
			fnSelect('subCategory', selectData + "&srType=" + srType + "&parentID="+parentID + "&customerNo=" + clientID, 'getESPSRCategory', '${subCategory}', 'Select', 'esm_SQL');
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
	
	function fnCheckValidation(temp){
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
		var srType = document.querySelector("#srType");
		if("${startSortNum}" === "03") var SRAT0071= document.querySelector("#SRAT0071");
		
		if(subject.value.length > 200){alert("제목의 글자수는 200자를 넘을 수 없습니다."); subject.focus(); subject.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		if(requestUser.value == "" || requestUser == null ){ alert("${WM00034_4}"); requestUser.focus(); requestUser.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		if(reqdueDate.value == ""){alert("${WM00034_5}"); reqdueDate.focus(); reqdueDate.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		if(reqdueDate.value < today) {alert("${WM00015}"); reqdueDate.focus(); reqdueDate.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		if(subject.value.trim() == ""){ alert("${WM00034_1}"); subject.focus(); subject.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		if(srType.value == ""){alert("${WM00034_6}"); reqdueDate.focus(); reqdueDate.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		
		if(temp === undefined || temp === '' || temp === null){
			if(description == "" ){ alert("${WM00034_2}"); tinyMCE.get('description').focus(); document.querySelector("#tinymce").scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
			if(category.value == ""){ alert("${WM00025_3}"); category.focus(); category.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
			if(subCategory.value == ""){ alert("${WM00025_4}"); subCategory.focus(); subCategory.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
			if(srArea1.value == ""){ alert("${WM00025_1}"); srAreaSearch.focus(); srAreaSearch.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
			if(srAreaSearch.value == ""){ alert("${WM00025_1}"); srAreaSearch.focus(); srAreaSearch.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
			if("${startSortNum}" === "03" && SRAT0071.value == ""){ alert("${WM00034_7}"); SRAT0071.focus(); SRAT0071.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		} else {
			// 임시저장 시 category 없을 경우 
			if(category.value == "" && subCategory.value == "") $("#defCategory").val($("#category option:eq(1)").val());
		}
		
		
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
				+ "&srID=" + srID+"&returnMenuId=${returnMenuId}";
		var target = "mainLayer";
		
		ajaxPage(url, data, target);
	}
	/*** SR Callback function end ***/

		// [요청자 팝업]
	function fnCheckRequest(){
		$("#searchRequestBtn").attr('style', 'display: done');
	}
	
	document.getElementById("searchRequestBtn").addEventListener("click", function() {
		searchPopupWf();
	})
	
	document.getElementById("srAreaBtn").addEventListener("click", function() {
		searchSrArea();
	})
	
	function searchPopupWf(){
		window.open("searchMemberPop.do?myClient=${myClient}&notCompanyIDs=22&searchValue="+$("#ReqUserNM").val(),'searchMemberPop','width=900, height=700');
	}
	
	function searchMemberCallback(avg1,avg2,avg3,avg4,avg5,avg6){
		$("#ReqUserNM").val(avg2+"("+avg3+"/"+avg4+")");
		$("#requestUserID").val(avg1);
		clientID = avg6;
		$("#customerNo").val(clientID);
		fnSRAreaLoad();
	}
	
	function searchSrArea(){
		window.open('searchSrAreaPop.do?srType=' + srType + '&roleFilter=${roleFilter}&myCSR=${myCSR}&priorityClientID=' + $("#customerNo").val(),'window','width=1000, height=500, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSrArea(clientID, srArea1, srArea2, srArea2Name){
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
	<input type="hidden" id="srType" name="srType" value="${srType}" />
	
	<div class="page-title">${menu.LN00280}</div>
	<div class="btn-wrap pdB15 pdT10">
		<div class="btns">
			<button id="save" onclick="fnSaveSR('Y')"></button>
			<button id="temp-save" onclick="fnSaveSR()"></button>
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
				<input type="text" class="text" id="ReqUserNM" name="ReqUserNM" value="${sessionScope.loginInfo.sessionUserNm}" style="width:250px;"  autocomplete="off" />
				<input type="hidden" id="requestUserID" name="requestUserID" value="${sessionScope.loginInfo.sessionUserId}" />
				<img id="searchRequestBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" />
			</td>
		</tr>
		<tr>
			<th class="alignL pdL10">${menu.LN00222}<font color="red">&nbsp;*</font></th>			
			<td class="sline tit last">	
				<font><input type="text" id="reqdueDate" name="reqdueDate" value="" class="input_off datePicker stext" size="8"
						style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</font>
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
		<c:if test="${startSortNum eq '03'}">
		<tr>
			<th class="alignL pdL10">${menu.ZLN0124}<font color="red">&nbsp;*</font>
			</th>
			<td style="height:200px;" class="tit last" colspan="3">
				<textarea  class="edit" id="SRAT0071" name="SRAT0071" style="height:200px;  padding:10px; resize:none;"></textarea>
			</td>
		</tr>
		</c:if>
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
			<button id="temp-save2" onclick="fnSaveSR()"></button>
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
	
</script>

</body>
</html>
