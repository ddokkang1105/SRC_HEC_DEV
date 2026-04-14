<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%-- <c:url value="/" var="root"/> --%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<c:choose>
<c:when test="${isPopUp eq 'Y'}"><%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%></c:when>
<c:otherwise><script src="${root}cmm/js/tinymce_v7/tinymce.min.js" type="text/javascript"></script></c:otherwise>
</c:choose>

<script type="text/javascript">
	var chkReadOnly = false;
</script>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css" />
<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/jquery.timepicker.css"/>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_1" arguments="${srAreaLabelNM1}"/> <!-- 도메인 입력 체크 -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_2" arguments="${srAreaLabelNM2}"/> <!-- 시스템 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_3" arguments="${menu.LN00272}"/> <!-- 카테고리 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_4" arguments="${menu.LN00273}"/> <!-- 하위 카테고리 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00002}"/> <!-- 제목 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00003}"/> <!-- 개요 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="${menu.LN00072}"/> <!-- 사용자 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_4" arguments="${menu.LN00025}"/> <!-- 요청자 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_5" arguments="${menu.LN00222}"/> <!-- 완료요청일 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_7" arguments="처리내용"/> <!-- 요청 목적 및 사유 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_8" arguments="조치유형"/> <!-- 요청 목적 및 사유 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00014" var="WM00014" arguments="${menu.LN00222}" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00007" var="WM00007" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00015" var="WM00015" arguments="${menu.LN00222}"/>
<script type="text/javascript">
	let today = new Date();
	today = today.getFullYear() +
	'-' + ( (today.getMonth()+1) <= 9 ? "0" + (today.getMonth()+1) : (today.getMonth()+1) )+
	'-' + ( (today.getDate()) <= 9 ? "0" + (today.getDate()) : (today.getDate()) );
	var fileSize = "${itemFiles.size()}";
	var scrnType = "${scrnType}";
	var srType = "${srType}";
	var esType = "${esType}";
	
	// select list 용 parameter
	var selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&esType=${esType}";
	
	if("${startSortNum}" === "04") {
		var childWindow = document.getElementById('espMbrRcdListFrame').contentWindow;
	}
	
	jQuery(document).ready(function() {
		// 00. input type setting
		$("input.datePicker").each(generateDatePicker);
		$('#reqDueDateTime').timepicker({
            timeFormat: 'H:i',
        });
  		
		// 01. select option setting
		//fnSelect('company', '', 'getESPCustomerList', '${sessionScope.loginInfo.sessionClientId}', 'Select','esm_SQL');
		$("#customerNo").val('${sessionScope.loginInfo.sessionClientId}');
		fnSelectSetting("Y");
		
  		// 02. change event
  		$("#customerNo").on("change", function(){
  			fnSelectSetting("Y");
  		});
  		
  		$("#category").on("change", function(){
  			var category = $("#category").val();
  			fnGetSubCategory(category);
  		});
  		
  		// 04. 긴급여부 [긴급] 일 경우 긴급사유 출력
  		$(".SRAT0076").hide();
  		$("input[name='SRAT0002']").on("change", function(){
  			var SRAT0002 = $("input[name='SRAT0002']:checked").val();
  			if(SRAT0002 == "02") {
  				$(".SRAT0076").show();
  			} else {
  				$("#SRAT0076").val('');
  				$(".SRAT0076").hide();
  			}
  			
  		});
  		
  		// 05. 조치유형 - 2선 선택 시(RAF000101, RAF010104)조치완료예정일 입력
  		$(".SRAT0078").hide();
		$("#SRAT0098").on("change", function(){
  			var SRAT0098  = $("#SRAT0098").val();
  			if(SRAT0098 == "05" || 06 == "RAF010104") {
  				$(".SRAT0078").show();
  			} else {
  				$("#SRAT0078").val('');
  				$(".SRAT0078").hide();
  			}
  			
  		});
  		
  		
  		// 요청자 팝업 setting
  		fnCheckRequest();
  		
  		if("${requestUserID}" == "") {
  		// 요청자 팝업 enter
  	  		document.getElementById('ReqUserNM').addEventListener('keydown', function(event) {
  		        if (event.key === 'Enter') {
  		            event.preventDefault(); // 기본 Enter 동작 방지 (필요시)
  		            searchPopupWf(); // 함수 호출
  		        }
  	    	});
  		}
  		
	    
  		// button setting
  		fnSetButton("temp-save", "", "임시저장", "secondary");
  		fnSetButton("save", "", "서비스 요청 완료");
  		fnSetButton("attach", "attach", "Attach", "tertiary");
  		fnSetButton("temp-save2", "", "임시저장", "secondary");
  		fnSetButton("save2", "", "서비스 요청 완료");
  		
  		// srArea setting
  		fnSRAreaLoad();
  		
  		if("${startSortNum}" === "04") fnEspMbrRcdListFrame();
  		
  		if("${requestUserID}" !== "") $("#requestUserID").val("${requestUserID}");
  		
	  	// 콜센터에서 서비스 등록할 경우 고객완료희망일은 오늘로 설정 ==> 전체 고객완료희망일 오늘로 설정
		// if("${startSortNum}" === "02")
		document.querySelector("#reqdueDate").value = today;
	  	
	  	
	});
	
	/*** SR Select function start ***/
	function fnSelectSetting(all) {
		// 00. reset
		resetSelect(all);
		// 01. category setting
		fnSelect('category', selectData +"&srType=" + srType +"&level=1&customerNo="+ $("#customerNo").val(), 'getESPSRCategory', '${category}', 'Select','esm_SQL');
		fnGetSubCategory('');
	}
	
	// subCategory setting ( * customerNo / category )
	function fnGetSubCategory(parentID){
		if(parentID == ''){
			$("#subCategory option").not("[value='']").remove();
		} else {
			fnSelect('subCategory', selectData + "&srType=${srType}&parentID="+parentID + "&customerNo=" + $("#customerNo").val(), 'getESPSRCategory', '${subCategory}', 'Select', 'esm_SQL');
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
	/*** SR Select function end ***/
	
	function fnCheckValidation(temp){
		var isCheck = true;
		
		var requestUser = document.querySelector("#requestUserID");
		var ReqUserNM = document.querySelector("#ReqUserNM");
		var reqdueDate = document.querySelector("#reqdueDate");
		var subject = document.querySelector("#subject");
		var srArea1 = document.querySelector("#srArea1");
		var srArea2 = document.querySelector("#srArea2");
		var srAreaSearch = document.querySelector("#srAreaSearch");
		var category = document.querySelector("#category");
		var subCategory = document.querySelector("#subCategory");
		var description = tinyMCE.get('description').getContent();
		var SRAT0001= document.querySelector(".SRAT0001");
		var selCheck = document.querySelector(".selCheck");
		
		if(subject.value.length > 200){alert("제목의 글자수는 200자를 넘을 수 없습니다."); subject.focus(); subject.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		if(subject.value.trim() == ""){ alert("${WM00034_1}"); subject.focus(); subject.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		if(requestUser.value == "" || requestUser == null ){ alert("${WM00034_4}"); ReqUserNM.focus(); ReqUserNM.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		if(reqdueDate.value == ""){alert("${WM00034_5}"); reqdueDate.focus(); reqdueDate.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		if(reqdueDate.value < today) {alert("${WM00015}"); reqdueDate.focus(); reqdueDate.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		if(description == "" ){ alert("${WM00034_2}"); tinyMCE.get('description').focus(); document.querySelector("#tinymce").scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		
		if(temp === undefined || temp === '' || temp === null){
	 		if(srArea1.value == ""){ alert("${WM00025_1}"); srAreaSearch.focus(); srAreaSearch.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
	 		if(srAreaSearch.value == ""){ alert("${WM00025_1}"); srAreaSearch.focus(); srAreaSearch.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
			if(category.value == ""){ alert("${WM00025_3}"); category.focus(); category.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
	 		if(subCategory.value == ""){ alert("${WM00025_4}"); subCategory.focus(); subCategory.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
			if(SRAT0001.value == "" && "${startSortNum}" !== "02"){ alert("${WM00034_7}"); SRAT0001.focus(); SRAT0001.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
			if(selCheck.value == "" ){ alert("${WM00034_8}"); selCheck.focus(); selCheck.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		} else {
			// 임시저장 시 category 없을 경우 
			if(category.value == "" && subCategory.value == "") $("#defCategory").val($("#category option:eq(1)").val());
		}
	 
		return isCheck;
	}
	
	/*** SR Button function start ***/
	// [Register]
	function fnSaveSR(sendParam){		
		if(!confirm("${CM00001}")){ return;}
		
		$('#srMode').val('N');
		var url  = "createESP.do?scrnType=REQ";
		
		// 임시저장
		if(sendParam != "Y"){
			$("#resultParameter").val("${startSortNum}");
			$("#actionParameter").val("resultParameter");
			$("#activityStatus").val("01");
			$("#isPublic").val("0");
			if(!fnCheckValidation('Y')){return;}
			//요청자 / 제목
		} else {
			if(!fnCheckValidation()){return;}
			// 운영관리실적 체크
			if("${startSortNum}" === "04") {
				if(!childWindow.fnCheckValidation()) { return; }
			}
		}
		
		// 완료예정일
		if($("#SRAT0078").val() !== null || $("#SRAT0078").val() !== undefined || $("#SRAT0078").val() !== ''){
			var dueDate = $("#SRAT0078").val();
			$("#dueDate").val(dueDate);
		}
		
		$('#loading').fadeIn(150);
		ajaxSubmit(document.srFrm, url,"saveFrame");
	}
	
	
	// 운영실적 SAVE 
	 function callChildSaveMH(srID) {
		 if("${startSortNum}" === "04") {
			 childWindow.saveMH(srID,"REQ0004","WGRREQ101");
		 }
     }

	// [요청자 팝업]
	function fnCheckRequest(){
		$("#searchRequestBtn").attr('style', 'display: done');
		$("#ReqUserNM").val("");
		$("#requestUserID").val("");
	}
	
	function searchPopupWf(){
		window.open("searchMemberPop.do?myClient=${myClient}&notCompanyIDs=22&searchValue="+$("#ReqUserNM").val(),'searchMemberPop','width=900, height=700');
	}
	
	function searchMemberCallback(avg1,avg2,avg3,avg4){
		$("#ReqUserNM").val(avg2+"("+avg3+"/"+avg4+")");
		$("#requestUserID").val(avg1);
	}
	
	function searchSrArea(){
		//&roleFilter=${roleFilter} 기능 사용 중지
		window.open('searchSrAreaPop.do?srType=${srType}&myCSR=Y&isCallCenter=${isCallCenter}','window','width=1000, height=500, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSrArea(clientID, srArea1, srArea2, srArea2Name){
		
		var customerNo = $("#customerNo").val();
		
		$("#customerNo").val(clientID);
		if(clientID !== customerNo){
			fnSelectSetting();
		}
		
		$("#srArea1").val(srArea1);
		$("#srArea2").val(srArea2);
		$("#srAreaSearch").val(srArea2Name);
	}
	
	/*** SR Button function end ***/
	
	/*** SR Callback function start ***/
	function fnGoDetail(srID){ 
		if("${isPopUp}" === "Y") {
			// 콜센터에서 서비스 등록할 경우 CTI 함수 호출
			// 2024-12-26일에 서비스 완료 후에 상태 변경되지 않도록
// 			if("${startSortNum}" === "02") opener.window.top[0].parent.completeTask();
			
			self.close();
		} else {
			setTab(1);
			var url = "esrInfoMgt.do";
			var data = "esType=${esType}&srType=${srType}&scrnType=${scrnType}&srMode=${srMode}"
					+ "&pageNum=${pageNum}&category=${category}&searchSrCode=${searchSrCode}&itemProposal=${itemProposal}"
					+ "&srArea1=${srArea1}&srArea2=${srArea2}&subject=${subject}&srStatus=${srStatus}&srArea1ListSQL=${srArea1ListSQL}"
					+ "&srID=" + srID; 
			var target = "mainLayer";
			
			ajaxPage(url, data, target);
		}
		
	}
	/*** SR Callback function end ***/
	
	// 운영이관 실적
	function fnEspMbrRcdListFrame(){
		$("#espMbrRcdListFrame").attr("style", "display:block;width:100%; height:418px; border:none;");
		var data = "docCategory=SR&speCode=${startEventCode}";
	    var src = "espMbrRcdList.do?"+data;
	    document.getElementById('espMbrRcdListFrame').contentWindow.location.href= src;
	    
	}
	
</script>
</head>

<style>
	a:hover{
		text-decoration:underline;
	}
	input[type=text]::-ms-clear{
		display: done;
	}
	.autocomplete{
	    border: 1px solid #ddd;
	    display: none;
	    position: absolute;
	    width: 600px;
	    max-height: 200px;
	    background: #ffffff;
	    overflow: auto;
	    z-index: 2;
	    border-radius: 8px;
	    margin-top: 4px;
	    -webkit-box-shadow: 0 4px 10px 0 rgba(32, 33, 36, .1);
	    box-shadow: 0 4px 10px 0 rgba(32, 33, 36, .1);
   }
    .autocomplete.on {
    	display:block;
    }
    .autocomplete > div {
	    display: grid;
	    grid-template-columns: 150px 1fr 1fr;
	    background: #ffffff;
	    padding: 0 8px;
	    border-bottom: 1px solid #ddd;
    	cursor:pointer;
    }
    .autocomplete > div > span {
	    padding: 8px 0;
    }
	/* 현재 선택된 검색어 */
	.autocomplete > div.active, .autocomplete > div:hover {
    	background: #ddd;
	}
	mark {
		background: transparent;
	    color: #0761CF;
	    font-weight: bold;
	}
	
/* 	.new-form .tox-tinymce { height:300px!important; } */
</style>

<body <c:if test="${isPopUp eq 'Y'}">style="overflow:auto; background: #EEF1F7;"</c:if>>
	<form name="srFrm" id="srFrm" enctype="multipart/form-data" action="" method="post" onsubmit="return false;" <c:if test="${isPopUp eq 'Y'}">class="pdL20 pdR20 pdB20"</c:if>>
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<input type="hidden" id="scrnType" name="scrnType" value="${scrnType}">
	<input type="hidden" id="srMode" name="srMode" value="${srMode}">
	<input type="hidden" id="esType" name="esType" value="${esType}">
	<input type="hidden" id="srType" name="srType" value="${srType}">
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
			 <th class="alignL pdL10">${menu.LN00025}<font color="red">&nbsp;*</font></th>
		  	<td class="sline tit last" >
		  		<c:choose>
		  			<c:when test="${!empty requestUserID }">
		  				${requestUserName}(${requestTeamName})
		  			</c:when>
		  			<c:otherwise>
			  			<input type="text" class="text" id="ReqUserNM" name="ReqUserNM" value="${sessionScope.loginInfo.sessionUserNm}" style="width:250px;" autocomplete="off" />
						<input type="hidden" id="requestUserID" name="requestUserID" value="${sessionScope.loginInfo.sessionUserId}" />
						<img id="searchRequestBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" / onclick="searchPopupWf()">
		  			</c:otherwise>
		  		</c:choose>
				
			</td>
			<!-- 완료요청일 -->
			<th class="alignL pdL10">${menu.LN00222}<font color="red">&nbsp;*</font></th>
			<td class="sline tit last" >
				<input type="text" id="reqdueDate" name="reqdueDate" class="text datePicker stext" size="8"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
			</td>
		</tr>
		<tr>
			<!-- <th class="alignL pdL10">관계사<font color="red">&nbsp;*</font></th>
			<td>
				<select id="company" name="company" class="sel" style="width:250px;">
					<option value=''>Select</option>
				</select>
			</td> -->
			<input type="hidden" id="company" name="company" />
			
			<!-- SR Area -->
			<th class="alignL pdL10">${srAreaLabelNM1}/${srAreaLabelNM2}<font color="red">&nbsp;*</font></th>
			<td class="sline tit last" style="position:relative;">
				<input type="text" class="text" id="srAreaSearch" name="srAreaSearch" style="width:250px;" placeholder="검색어를 입력해주세요." autocomplete="off"/>
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
					<option value=''>Select</option>
				</select>
			</td>
			<th class="alignL pdL10">${menu.LN00273}<font color="red">&nbsp;*</font></th>
			<td class="sline tit last">
				<select id="subCategory" name="subCategory" class="sel" style="width:250px;">
					<option value=''>Select</option>
				</select>
			</td>
		</tr>
		
		<!-- SR ATTR -->
		<tr>
			<!-- 긴급여부 -->
			<th class="alignL pdL10">긴급여부<font color="red">&nbsp;*</font></th>
			<td class="sline tit last" >
				<input type="radio" name="SRAT0002" id="SRLV0201" value="01" checked><label for="SRLV0201">일반</label>
				<input type="radio" name="SRAT0002" id="SRLV0202" value="02"><label for="SRLV0202">긴급</label>
			</td>
			<!-- 긴급사유 -->
			<th class="alignL pdL10 SRAT0076">긴급사유<font color="red">&nbsp;*</font></th>
			<td class="sline tit last SRAT0076">
				<input type="text" class="text SRAT0076" id="SRAT0076" name="SRAT0076" value="" />
			</td>
		</tr>
		<tr>
			<!-- VIP 여부 -->
			<th class="alignL pdL10">VIP 여부<font color="red">&nbsp;*</font></th>
			<td class="sline tit last" >
				<input type="radio" name="SRAT0074" id="SRLV7401" value="01" checked><label for="SRLV7401">아니오</label>
				<input type="radio" name="SRAT0074" id="SRLV7402" value="02"><label for="SRLV7402">예</label>
			</td>
			<!-- 조치유형 -->
			<th class="alignL pdL10">조치유형<font color="red">&nbsp;*</font></th>
			<td class="sline tit last" >
			
			<c:choose>
				<c:when test="${startSortNum eq '04' }">
				<select id="SRAT0106" name="SRAT0106" class="sel selCheck" style="width: 250px; display: inline-block;">
					<option value="01">2선 단순</option>
					<option value="02">2선 서비스 처리</option>
				</select>
				</c:when>
				<c:otherwise>
				<select id="SRAT0098" name="SRAT0098" class="sel selCheck" style="width: 250px; display: inline-block;">
					<option value="03">1선 문의 응대</option>
					<option value="04">1선 처리</option>
					<option value="05">2선 확인문의 이관</option>
					<option value="06">2선이관</option>
				</select>
				</c:otherwise>
			</c:choose>
			</td>
		</tr>
		<tr class="SRAT0078">
			<th class="alignL pdL10">조치완료예정일<font color="red">&nbsp;*</font></th>
			<td class="sline tit last">
				<input type="text" id="SRAT0078" name="SRAT0078" class="text datePicker stext" size="8"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
			</td>
		</tr>
		<tr>
			<th class="alignL pdL10">${menu.LN00002}<font color="red">&nbsp;*</font></th><!-- 제목 -->
			<td class="sline tit last" colspan="3">
				<input type="text" class="text" id="subject" name="subject" value="" style="ime-mode:active; " />
			</td>
		</tr>		
		<tr>
			<th class="alignL pdL10">${menu.LN00003 }<font color="red">&nbsp;*</font></th><!-- 내용 -->
			<td class="sline tit last" colspan="3">
				<div style="height:277px;">
					<textarea  class="tinymceText" id="description" name="description" style="width:100%;height:300px;"></textarea>
				</div>
				<span style="display:inline-block; color:#0761CF;" class="mgT5">
					<font color="red">&nbsp;* </font>요청내용에 사이즈(가로 600PX)가 큰 이미지를 붙여 넣을 경우 결재 화면에서 깨져 보일 수 있으니 이미지는 작은 사이즈를 사용 해 주시기 바랍니다.
				</span>
			</td>
		</tr>
		<tr>
			<th class="alignL pdL10">처리내용
				<c:if test="${startSortNum ne '02'}"><font color="red">&nbsp;*</font></c:if>
			</th>
			<td style="height:200px;" class="tit last" colspan="3">
				<c:choose>
					<c:when test="${startSortNum eq '04'}">
					<textarea  class="SRAT0001 edit" id="SRAT0071" name="SRAT0071" style="height:200px;  padding:10px; resize:none;"></textarea>
					</c:when>
					<c:otherwise>
					<textarea  class="SRAT0001 edit" id="SRAT0001" name="SRAT0001" style="height:200px;  padding:10px; resize:none;"></textarea>
					</c:otherwise>					
				</c:choose>
			</td>
		</tr>	
		<tr>
			<!-- 첨부문서 -->
			<th class="alignL pdL10">${menu.LN00111}</th>
			<td class="alignL pdL5 last btns">
				<button id="attach" onclick="doAttachFileV4()" type="button"></button>
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
	
	<c:if test="${startSortNum eq '04' }">
		<iframe id="espMbrRcdListFrame"  style="width:100%; height:400px; border:none;display:none;"></iframe>
	</c:if>
	
	<div class="btn-wrap pdB15 pdT20">
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

	let srAreaData = [];
	function fnSRAreaLoad() {
		fetch("/olmapi/srArea/?languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&myCSR=Y")
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
				let customerNo = document.querySelector("#customerNo").value;
				if(customerNo === undefined || customerNo == '' || customerNo == null || customerNo != matchDataList[nowIndex].ClientID){
					document.querySelector("#customerNo").value = matchDataList[nowIndex].ClientID || "";
					fnSelectSetting();
				}
				
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
			let customerNo = document.querySelector("#customerNo").value;
			if(customerNo === undefined || customerNo == '' || customerNo == null || customerNo != srAreaData.filter(e => e.RNUM == parentIndex)[0].ClientID){
				document.querySelector("#customerNo").value = srAreaData.filter(e => e.RNUM == parentIndex)[0].ClientID;
				fnSelectSetting();
			}
			
		}
	    if(e.target.id !== "srAreaSearch" && autoComplete.classList.contains("on")) autoComplete.classList.remove("on");
	})
</script>
</body>
</html>
