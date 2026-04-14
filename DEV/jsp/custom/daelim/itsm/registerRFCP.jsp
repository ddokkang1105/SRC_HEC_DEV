<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/jquery.timepicker.css"/>
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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_1" arguments="${srAreaLabelNM1}/${srAreaLabelNM2}"/> <!-- 도메인 입력 체크 -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_2" arguments="${srAreaLabelNM2}"/> <!-- 시스템 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_3" arguments="${menu.LN00272}"/> <!-- 카테고리 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_4" arguments="${menu.LN00273}"/> <!-- 하위 카테고리 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00002}"/> <!-- 제목 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00003}"/> <!-- 개요 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="${menu.LN00072}"/> <!-- 사용자 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_4" arguments="${menu.LN00025}"/> <!-- 요청자 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_5" arguments="${menu.LN00222}"/> <!-- 완료요청일 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_6" arguments="요청 목적 및 사유"/> <!-- 요청 목적 및 사유 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_7" arguments="긴급사유"/> <!-- 요청 목적 및 사유 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00014" var="WM00014" arguments="${menu.LN00222}" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00015" var="WM00015" arguments="${menu.LN00222}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00007" var="WM00007" />
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
		$('input[name="srType"][value="ACM"]').prop('checked', true);
		companySRException();
		
  		// 02. change event
  		$("#customerNo").on("change", function(){
  			fnSelectSetting("Y");
  			companySRException();
  		});
  		
  		$("#category").on("change", function(){
  			var category = $("#category").val();
  			fnGetSubCategory(category);
  		});
  		
  		// 03. 긴급여부 [긴급] 일 경우 긴급사유 출력
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
  		
  		// 04. srType 체크
  		$("input[name='srType']").on("change", function(){
  			srType = $("input[name='srType']:checked").val();
  			var labelText = $("label[for='"+srType+"']").text();
  			$(".rfcpTitle").text(labelText);
  			fnSelectSetting("Y");
  			
  			if(srType == "ACM"){
  				$(".SRAT0003").show();
  				$("input[id='SRLV0301']").prop("checked",true);
  			} else {
  				$("#SRAT0003").val('');
  				$("input[name='SRAT0003']").prop("checked",false);
  				$(".SRAT0003").hide();
  			}

  			if(srType == "ICM" || srType == "SCM" || srType == "DPL"){
  				$("#cateTr").hide();
  				if(srType == "ICM"){
  					$("#defCategory").val("IDT000");
  					setICMDesc();
  				}
  				if(srType == "DPL"){
  					$("#defCategory").val("RCP990");
  					setICMDesc();
  				}
  				if(srType == "SCM") {
  					$("#defCategory").val("SDT000");
  					setSCMDesc();
  				}
  			} else {
  				$("#defCategory").val("");
  				$("#cateTr").show();
  			}
  			
  			// asis 조건 유지 : 데이터변경일 경우 요청자 default값 제거
  			if(srType == "DCM"){
  				$("#ReqUserNM").val("");
  				$("#requestUserID").val("");
  			} else {
  				$("#ReqUserNM").val("${sessionScope.loginInfo.sessionUserNm}");
  				$("#requestUserID").val("${sessionScope.loginInfo.sessionUserId}");
  			}
  			
  			fnSRAreaLoad();
  			
  		});
		
  		// 요청자 팝업 setting
  		fnCheckRequest();
  		
  		// 요청자 팝업 enter
  		document.getElementById('ReqUserNM').addEventListener('keydown', function(event) {
	        if (event.key === 'Enter') {
	            event.preventDefault(); // 기본 Enter 동작 방지 (필요시)
	            searchPopupWf(); // 함수 호출
	        }
    	});
	    
  		// button setting
  		fnSetButton("temp-save", "", "임시저장", "secondary");
  		fnSetButton("save", "", "등록");
  		fnSetButton("attach", "attach", "Attach", "tertiary");
  		
  		// button setting2
  		fnSetButton("temp-save2", "", "임시저장", "secondary");
  		fnSetButton("save2", "", "등록");
		
  		// srArea setting
  		fnSRAreaLoad();
  		
  		// 고객완료 희망일
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
			fnSelect('subCategory', selectData + "&srType=" + srType + "&parentID="+parentID + "&customerNo=" + $("#customerNo").val(), 'getESPSRCategory', '${subCategory}', 'Select', 'esm_SQL');
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
	
	function companySRException(){
		var customerNo = $("#customerNo").val();
		srType = $("input[name='srType']:checked").val();
		
		/*
		if(customerNo == "0000000008"){
			$("#etcSR").hide();
			$("#encSR").show();
			if(srType == "ICM"){
				$('input[name="srType"][value="ICM"]').prop('checked', false);
				$('input[name="srType"][value="DPL"]').prop('checked', true);
				$("#defCategory").val("RCP990");
			}
		} else {
			$("#encSR").hide();
			$("#etcSR").show();
			if(srType == "DPL"){
				$('input[name="srType"][value="DPL"]').prop('checked', false);
				$('input[name="srType"][value="ICM"]').prop('checked', true);
				$("#defCategory").val("IDT000");
			}
		}
		*/
		
		fnSelectSetting();
	}
	
	/*** SR Select function end ***/
	
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
		
		if(subject.value.length > 200){alert("제목의 글자수는 200자를 넘을 수 없습니다."); subject.focus(); subject.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		if(requestUser.value == "" || requestUser == null ){ alert("${WM00034_4}"); requestUser.focus(); requestUser.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		if(reqdueDate.value == ""){alert("${WM00034_5}"); reqdueDate.focus(); reqdueDate.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		if(reqdueDate.value < today) {alert("${WM00015}"); reqdueDate.focus(); reqdueDate.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		if(subject.value.trim() == ""){ alert("${WM00034_1}"); subject.focus(); subject.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		if(description == "" ){ alert("${WM00034_2}"); tinyMCE.get('description').focus(); document.querySelector("#tinymce").scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
		
		if(temp === undefined || temp === '' || temp === null){
			if(srType !== "ICM" && srType !== "SCM" && srType !== "DPL"){
				if(category.value == ""){ alert("${WM00025_3}"); category.focus(); category.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
				if(subCategory.value == ""){ alert("${WM00025_4}"); subCategory.focus(); subCategory.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
			}
			
			if(srArea1.value == ""){ alert("${WM00025_1}"); srAreaSearch.focus(); srAreaSearch.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
			if(srAreaSearch.value == ""){ alert("${WM00025_1}"); srAreaSearch.focus(); srAreaSearch.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
			
			
	  		var SRAT0002 = $("input[name='SRAT0002']:checked").val();
	  		if(SRAT0002 == "02") {
	  			var SRAT0076 = document.querySelector("#SRAT0076");
	  			if(SRAT0076.value == "" ){ alert("${WM00034_7}"); SRAT0076.focus(); SRAT0076.scrollIntoView({ behavior: 'smooth', block: 'center' }); isCheck = false; return isCheck;}
	  		} 
		} else {
			if(category == "" && subCategory == "" ){
  				if(srType == "ICM"){
  					$("#defCategory").val("IDT000");
  				}
  				if(srType == "DPL"){
  					$("#defCategory").val("RCP990");
  				}
  				if(srType == "SCM") {
  					$("#defCategory").val("SDT000");
  				} else {
					$("#defCategory").val($("#category option:eq(1)").val());
  				}
			}
		}
		
	 
		return isCheck;
	}
	
	/*** SR Button function start ***/
	// [Register]
	function fnSaveSR(sendParam){		
		if(!confirm("${CM00001}")){ return;}
		
		// 임시저장
		if(sendParam != "Y"){
			$("#activityStatus").val("01");
			$("#isPublic").val("0");
			if(!fnCheckValidation('Y')){return;}
		} else {
			if(!fnCheckValidation()){return;}
		}
		
		var url  = "createESP.do";
		$('#loading').fadeIn(150);
		ajaxSubmit(document.srFrm, url,"saveFrame");
	}
	
	// [요청자 팝업]
	function fnCheckRequest(){
		$("#searchRequestBtn").attr('style', 'display: done');
		//$("#ReqUserNM").val("");
		//$("#requestUserID").val("");
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
	
	function searchMemberCallback(avg1,avg2,avg3,avg4){
		$("#ReqUserNM").val(avg2+"("+avg3+"/"+avg4+")");
		$("#requestUserID").val(avg1);
	}
	
	function searchSrArea(){
		let srType = $('input[name=srType]:checked').val();
		if(srType === "DPL") {
			srType = srType + "&clientID=0000000008"; 	
		}
		window.open('searchSrAreaPop.do?srType=' + srType + '&roleFilter=${roleFilter}&myCSR=${myCSR}','window','width=1000, height=500, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSrArea(clientID, srArea1, srArea2, srArea2Name){
		
		var customerNo = $("#customerNo").val();
		
		$("#customerNo").val(clientID);
		if(clientID !== customerNo){
			companySRException();
		}
		
		$("#srArea1").val(srArea1);
		$("#srArea2").val(srArea2);
		$("#srAreaSearch").val(srArea2Name);
		
		// scm 예외처리
		setSCMDesc();
		// icm 예외처리
		setICMDesc();
	}
	
	/*** SR Button function end ***/
	
	/*** SR Callback function start ***/
	function fnGoDetail(srID){ 
		setTab(1);
		var srType = $("input[name='srType']:checked").val();
		var url = "esrInfoMgt.do";
		var data = "esType=${esType}&srType=" + srType + "&scrnType=${scrnType}&srMode=${srMode}"
				+ "&pageNum=${pageNum}&category=${category}&searchSrCode=${searchSrCode}&itemProposal=${itemProposal}"
				+ "&srArea1=${srArea1}&srArea2=${srArea2}&subject=${subject}&srStatus=${srStatus}&srArea1ListSQL=${srArea1ListSQL}"
				+ "&srID=" + srID; 
		var target = "mainLayer";
		
		ajaxPage(url, data, target);
	}
	/*** SR Callback function end ***/
	
	// srArea setting
	let srAreaData = [];
	function fnSRAreaLoad() {
		let srType = $('input[name=srType]:checked').val();
		if(srType === "DPL") {
			srType = srType + "&clientID=0000000008"; 	
		}
		
		fetch("/olmapi/srArea/?languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&myCSR=${myCSR}&srType=" + srType)
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
				
				// scm 예외처리
				setSCMDesc();
				// icm 예외처리
				setICMDesc();

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
				companySRException();
				fnSelectSetting();
			}
			
			// scm 예외처리
			setSCMDesc();
			// icm 예외처리
			setICMDesc();
			
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
	
	.rfcpTitle {display:contents;}
	
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
	<input type="hidden" id="resultParameter" name="resultParameter" value="${resultParameter}">
	<input type="hidden" id="activityStatus" name="activityStatus" value="05"/>
	<input type="hidden" id="isPublic" name="isPublic" value=""/>
	<input type="hidden" id="receiveAssigned" name="receiveAssigned" value="Y">
	<input type="hidden" id="defCategory" name="defCategory" value=""/>

	<div class="page-title"><span class="rfcpTitle page-title">AP</span> ${menu.LN00092}</div>
	
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
			<th class="alignL pdL10">프로세스 유형</th>
			<td>
			<input type="radio" name="srType" id="ACM" value="ACM" checked /><label for="ACM" id="ACM_lb">AP</label>
			<input type="radio" name="srType" id="DCM" value="DCM"><label for="DCM" id="DCM_lb">데이터</label>
			<!-- <span id="etcSR" style="display:none;"> -->
				<input type="radio" name="srType" id="ICM" value="ICM"><label for="ICM" id="ICM_lb">Infra</label>
			<!-- </span>
			<span id="encSR" style="display:none;"> -->
				<input type="radio" name="srType" id="DPL" value="DPL"><label for="DPL" id="DPL_lb">배포</label>
			<!-- </span> -->
				<input type="radio" name="srType" id="SCM" value="SCM"><label for="SCM" id="SCM_lb">보안</label>
			</td>
		</tr>
		<tr>
		   <th class="alignL pdL10">${menu.LN00025}<font color="red">&nbsp;*</font></th>
		  	<td class="sline tit last" >
				<input type="text" class="text" id="ReqUserNM" name="ReqUserNM" value="${sessionScope.loginInfo.sessionUserNm}" style="width:250px;"  autocomplete="off" />
				<input type="hidden" id="requestUserID" name="requestUserID" value="${sessionScope.loginInfo.sessionUserId}" />
				<img id="searchRequestBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" />
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
				<img id="srAreaBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" />
				<input type="hidden" id="srArea1" name="srArea1" />
				<input type="hidden" id="srArea2" name="srArea2" />
				<ul class="autocomplete"></ul>
			</td>
		</tr>
		<tr id="cateTr">
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
		<tr class="SRAT0003">
			<!-- 개발 여부 -->
			<th class="alignL pdL10">개발 여부<font color="red">&nbsp;*</font></th>
			<td class="sline tit last" >
				<input type="radio" name="SRAT0003" id="SRLV0301" value="01" checked><label for="SRLV0301">아니오</label>
				<input type="radio" name="SRAT0003" id="SRLV0302" value="02"><label for="SRLV0302">예</label>
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
	
	function setICMDesc(){
		//인프라
		
		//IDC_SVC_214 OS신청 및 폐기
		var icmDefMsg3 = "";
			icmDefMsg3 += "● 기입 항목 (OS 설치 요청)<br />";
			icmDefMsg3 += "요청 일자 :<br />"; 
			icmDefMsg3 += "Hostname :<br />";
			icmDefMsg3 += "OS 종류 및 버전 :<br />"; 
			icmDefMsg3 += "CPU (기본 4Core) :<br />";
			icmDefMsg3 += "Mem (기본 4GB) :<br />";
			icmDefMsg3 += "Disk (기본 100GB) :<br /><br />";
			icmDefMsg3 += "● 기입 항목 (OS 폐기 요청)<br />";
			icmDefMsg3 += "요청 일자 :<br />"; 
			icmDefMsg3 += "Hostname :<br />";
			icmDefMsg3 += "IP Address :<br />";
			icmDefMsg3 += "동작 서비스명 : <br />";
			icmDefMsg3 += "폐기 사유 :<br />";	
		
		//IDC_SVC_287 Azure > 보안 
		var icmDefMsg4 = "";
			icmDefMsg4 += "● 기입 항목 (방화벽)<br />";
			icmDefMsg4 += "신청 목적 :<br />";
			icmDefMsg4 += "NAT_IP :<br />";
			icmDefMsg4 += "출발지_IP :<br />";
			icmDefMsg4 += "목적지_IP :<br />";
			icmDefMsg4 += "PORT :    (TCP / UDP)<br />";
			icmDefMsg4 += "요청사항 : 허용 / 차단<br />";
			icmDefMsg4 += "사용기간 : 임시 (기간 :    ~    ) / 영구<br /><br />";
			icmDefMsg4 += "- 방화벽 정책 신청은 자세히 부탁 드립니다. (NAT_IP는 해당사항이 있는 경우만 작성 부탁드립니다)<br />";
			icmDefMsg4 += "- 접수 내역이 미비할 경우 티켓 접수가 되지 않습니다.<br />";
			icmDefMsg4 += "- 외부 허용 대상을 전체(Any)로 요청할 경우 반드시 사유를 기입해야 합니다.<br />";
			icmDefMsg4 += "- 서비스 전체(Any) 허용은 원칙적으로 불허합니다.<br />";
		
		//IDC_SVC_217 서버 > 모니터링 등록 및 삭제 
		var icmDefMsg5 = "";
			icmDefMsg5 += "<br /><작성안내>";
			icmDefMsg5 += "<br />* 제목양식은 이렇게 써주세요";
			icmDefMsg5 += "<br />   -> APPMON/WEBMON 관제 등록/변경/삭제 요청 (\"서비스명\", \"URL\")";
			icmDefMsg5 += "<br />   -> 관제 모니터링 담당자 SMS 등록/변경/삭제 요청 (\"서비스명\", \"변경담당자\")";
			icmDefMsg5 += "<br />** APPMON,WEBMON 현행상황은 ECM내 문서를 참조바랍니다"; 
			icmDefMsg5 += "<br />   (ECM > 10.점검프로세스 강화 > webmon_appmon_drmmon_list_현행화중.xlsx)";
			icmDefMsg5 += "<br />*** 아래 양식과 다른 작업요청일 경우 내용 지우고 신청해주세요";
			icmDefMsg5 += "<br />";
			icmDefMsg5 += "<br />[APPMON/WEBMON]";
			icmDefMsg5 += "<br />구분 : APPMON/WEBMON 등록/변경/삭제 요청";
			icmDefMsg5 += "<br />서비스명 :"; 
			icmDefMsg5 += "<br />URL :"; 
			icmDefMsg5 += "<br />관제명 :      (예시 : [APP]서비스명_서버명_포트)";
			icmDefMsg5 += "<br />알람발생시 연락처 :     (담당자이름, 연락처)";
			icmDefMsg5 += "<br />적용일시 :"; 
			icmDefMsg5 += "<br />비고 : ";
			icmDefMsg5 += "<br />";
			icmDefMsg5 += "<br />[SMS 수신자]";
			icmDefMsg5 += "<br />구분 : SMS 알람 수신자 등록/변경/삭제 요청";
			icmDefMsg5 += "<br />서비스명 :"; 
			icmDefMsg5 += "<br />담당자 :    (변경시 기존담당자->변경담당자 로 표기)";
			icmDefMsg5 += "<br />적용일시 :"; 
			icmDefMsg5 += "<br />비고 : ";
		
		//IDC_SVC_212 서버 > 백업 및 복구신청
		var icmDefMsg6 = "";
			icmDefMsg6 += "<br /><작성안내>";
			icmDefMsg6 += "<br />* 제목양식은 이렇게 써주세요";
			icmDefMsg6 += "<br />   -> 데이터백업/복구 등록/변경/삭제 요청 (\"서버명\",TINA,NETBACKUP)";
			icmDefMsg6 += "<br />** 아래 양식과 다른 작업요청일 경우 내용 지우고 신청해주세요";
			icmDefMsg6 += "<br />";
			icmDefMsg6 += "<br />[데이터백업]";
			icmDefMsg6 += "<br />구분 : 데이터백업 등록/변경/삭제 요청";
			icmDefMsg6 += "<br />서비스명 :"; 
			icmDefMsg6 += "<br />운영형태 :   (운영/시험/개발)";
			icmDefMsg6 += "<br />서버정보 :  (호스트명,IP)";
			icmDefMsg6 += "<br />백업경로 :  (변경시 기존경로->변경경로 로 표기)";
			icmDefMsg6 += "<br />백업스케쥴 :"; 
			icmDefMsg6 += "<br />적용일시 :"; 
			icmDefMsg6 += "<br />비고 : ";
			icmDefMsg6 += "<br />";
			icmDefMsg6 += "<br />[데이터복구]";
			icmDefMsg6 += "<br />서비스명 : ";
			icmDefMsg6 += "<br />운영형태 :   (운영/시험/개발)";
			icmDefMsg6 += "<br />서버정보 :  (호스트명,IP)";
			icmDefMsg6 += "<br />백업대상경로 :";  
			icmDefMsg6 += "<br />복구시점 :  ";
			icmDefMsg6 += "<br />비고 :"; 
		
		//IDC_SVC_215 서버 > 스토리지(SAN,NAS)
		var icmDefMsg7 = "";
			icmDefMsg7 += "<br /><작성안내>";
			icmDefMsg7 += "<br />* 제목양식은 이렇게 써주세요";
			icmDefMsg7 += "<br />   -> 스토리지(NAS,SAN) 볼륨 생성/증설 요청 (\"서비스명\",\"서버명\")";
			icmDefMsg7 += "<br />   -> 스토리지 디스크 교체 (\"스토리지명\",\"디스크스펙\")";
			icmDefMsg7 += "<br />** 아래 양식과 다른 작업요청일 경우 내용 지우고 신청해주세요";
			icmDefMsg7 += "<br />";
			icmDefMsg7 += "<br />[NAS,SAN 디스크 볼륨]";
			icmDefMsg7 += "<br />구분 : 디스크 볼륨 생성/증설/연결 요청";
			icmDefMsg7 += "<br />목적(사유) :"; 
			icmDefMsg7 += "<br />서비스명 :"; 
			icmDefMsg7 += "<br />운영형태 :   (운영/시험/개발)";
			icmDefMsg7 += "<br />볼륨정보 :    (NAS IP:/볼륨명)";
			icmDefMsg7 += "<br />볼륨연결서버 :    (호스트명,IP)";
			icmDefMsg7 += "<br />볼륨연결폴더 :";  
			icmDefMsg7 += "<br />볼륨용량 :    (증설시 기존->변경 으로 표기)";
			icmDefMsg7 += "<br />적용일시 :"; 
			icmDefMsg7 += "<br />비고 : ";
			icmDefMsg7 += "<br />";
			icmDefMsg7 += "<br />[스토리지 디스크 교체]";
			icmDefMsg7 += "<br />* 스토리지 관리자 작성";
			icmDefMsg7 += "<br />스토리지 모델명 :";
			icmDefMsg7 += "<br />디스크 정보 :    (20bay, 1-1 slot, 111GB, SAS 등)";
			icmDefMsg7 += "<br />작업일시 :";
			icmDefMsg7 += "<br />비고 :";

		//IDC_SVC_211 서버 > DNS
		var icmDefMsg8 = "";
			icmDefMsg8 += "<br />* 제목양식은 이렇게 써주세요";
			icmDefMsg8 += "<br />   -> DNS 도메인 추가/변경/삭제 요청 (\"서비스명\", \"도메인명\")";
			icmDefMsg8 += "<br />** 아래 양식과 다른 작업요청일 경우 내용 지우고 신청해주세요";
			icmDefMsg8 += "<br />";
			icmDefMsg8 += "<br />[DNS 도메인]";
			icmDefMsg8 += "<br />구분 : DNS 도메인 추가/변경/삭제 요청";
			icmDefMsg8 += "<br />목적(사유) :"; 
			icmDefMsg8 += "<br />서비스명 :"; 
			icmDefMsg8 += "<br />운영형태 :   (운영/시험/개발)";
			icmDefMsg8 += "<br />도메인명(URL) :"; 
			icmDefMsg8 += "<br />레코드 :    (A, CNAME, TXT 등)";
			icmDefMsg8 += "<br />IP :    (내부/외부), (변경시 기존IP->변경IP 로 표기)";
			icmDefMsg8 += "<br />적용일시 :"; 
			icmDefMsg8 += "<br />보조영역 :   (필요시 기입)";
			icmDefMsg8 += "<br />전달자 :   (필요시 기입)";
			icmDefMsg8 += "<br />비고 :"; 
			
		//IDC_SVC_292 Azure > NSG
		var icmDefMsg9 = "";
			icmDefMsg9 += "<br />기입 항목(NSG)";
			icmDefMsg9 += "<br />신청목적 : ";
			icmDefMsg9 += "<br />출발지 IP주소/CIDR범위 : ex) 10.10.10.0/24, 10.10.11.2/32";
			icmDefMsg9 += "<br />목적지 IP주소/CIDR범위 : ";
			icmDefMsg9 += "<br />서비스 : ex) TCP443, UDP161";
			icmDefMsg9 += "<br />허용/거부 : ";

		//IDC_SVC_293  Azure > 자원 신규생성/업그레이드(DL이앤씨 구독)
		var icmDefMsg10 = "";
			icmDefMsg10 += "<br />※ 서비스(프로젝트)명 :"; 
			icmDefMsg10 += "<br />※ 요청 내용 : 1.증설 / 2.신규 VM / 3.신규 리소스";
			icmDefMsg10 += "<br />";
			icmDefMsg10 += "<br />";
			icmDefMsg10 += "<br />● Cloud VM 업그레이드 요청";
			icmDefMsg10 += "<br />Hostname :";
			icmDefMsg10 += "<br />IP :"; 
			icmDefMsg10 += "<br />동작 서비스명 :";
			icmDefMsg10 += "<br />현재 CPU/Mem :";
			icmDefMsg10 += "<br />현재 Disk :";
			icmDefMsg10 += "<br />희망 CPU/Mem :"; 
			icmDefMsg10 += "<br />희망 Disk :";
			icmDefMsg10 += "<br />증설 사유(필요시 데이터 첨부) :";  
			icmDefMsg10 += "<br />";
			icmDefMsg10 += "<br />● 신규 Cloud VM 요청";
			icmDefMsg10 += "<br />리소스 종류 :";
			icmDefMsg10 += "<br />동작 서비스명 :"; 
			icmDefMsg10 += "<br />OS(세부버전까지) :"; 
			icmDefMsg10 += "<br />운영형태(운영/시험/개발) :"; 
			icmDefMsg10 += "<br />희망 CPU/Mem :"; 
			icmDefMsg10 += "<br />희망 Disk :"; 
			icmDefMsg10 += "<br />";
			icmDefMsg10 += "<br />● 신규 Cloud 인프라 요청";
			icmDefMsg10 += "<br />리소스 종류 :";
			icmDefMsg10 += "<br />동작 서비스명 :"; 
			icmDefMsg10 += "<br />희망 CPU/Mem :"; 
			icmDefMsg10 += "<br />희망 Disk :";
			icmDefMsg10 += "<br />희망 Spec(기타) :";
			
			// IDC_SVC_293  Azure > 자원 신규생성/업그레이드(DL이앤씨 구독) 고정문구 내용 추가
			if( $('#srArea2').val() == '105208' ) { 
				tinyMCE.get('description').setContent(icmDefMsg10);
			}
			// IDC_SVC_292 Azure > NSG 고정문구 내용 추가
			if( $('#srArea2').val() == '102912' ) { 
				tinyMCE.get('description').setContent(icmDefMsg9);
			}
			// IDC_SVC_211 서버 > DNS 고정문구 내용 추가
			if( $('#srArea2').val() == '102875' ) { 
				tinyMCE.get('description').setContent(icmDefMsg8);
			}
			// IDC_SVC_215 서버 > 스토리지(SAN,NAS) 고정문구 내용 추가
			if( $('#srArea2').val() == '102879' ) { 
				tinyMCE.get('description').setContent(icmDefMsg7);
			}
			// IDC_SVC_212 서버 > 백업 및 복구신청 고정문구 내용 추가
			if( $('#srArea2').val() == '102876' ) { 
				tinyMCE.get('description').setContent(icmDefMsg6);
			}
			// //IDC_SVC_217 서버 > 모니터링 등록 및 삭제  고정문구 내용 추가
			if( $('#srArea2').val() == '102881' ) { 
				tinyMCE.get('description').setContent(icmDefMsg5);
			}
			//IDC_SVC_287 Azure > 보안  고정문구 내용 추가
			if( $('#srArea2').val() == '102919' ) { 
				tinyMCE.get('description').setContent(icmDefMsg4);
			}
			//IDC_SVC_214 OS신청 및 폐기 고정문구 내용 추가
			if( $('#srArea2').val() == '102878' ) { 
				tinyMCE.get('description').setContent(icmDefMsg3);
			}
	}
	
	
	// 보안변경 (SCM) 예외처리
	function setSCMDesc() {
		
		var defMsg = "<작성안내>";
			defMsg += "<br />* 제목양식은 이렇게 써주세요";
			defMsg += "<br />   -> 서버접근제어 권한 부여/연장/해제 요청 (\"이름\", \"서비스명/서버명(1대만)\")";
			defMsg += "<br />** 하기의 내용이 작성되면 첨부파일은 꼭 필요하진 않습니다";
			defMsg += "<br />";
			defMsg += "<br />구분 : 서버접근제어 접근권한 부여 요청";
			defMsg += "<br />부서 :"; 
			defMsg += "<br />사번 :"; 
			defMsg += "<br />이름 :"; 
			defMsg += "<br />직급 :"; 
			defMsg += "<br />연락처(핸드폰) : (기존사용자는 생략가능)"; 
			defMsg += "<br />메일 주소 : (기존사용자는 생략가능)"; 
			defMsg += "<br />사용 목적 :"; 
			defMsg += "<br />사용 기간(최대 1년) :"; 
			defMsg += "<br />서버 IP / 서버명 / 장비구문 / 접속방법(프로토콜) / 사용하는계정명 : ";
			defMsg += "<br />  예시) 192.168.1.1 / 서버명 / Linux / SSH, SFTP / webadmin01, webadmin02";
			defMsg += "<br />  예시) 192.168.1.2 / 서버명 / Windows / WIN / daelim\\svcadmin01, daelim\\svcadmin02"; 
			defMsg += "<br />비고 :"; 
		
		var defMsg2 = "";
			defMsg2 += "<<DB 접근제어 신청>><br />";
			defMsg2 += "구분 : (신규/해지/권한추가/잠김해제/비밀번호초기화/유효기간연장/ID변경)<br />";
			defMsg2 += "회사 : (DL이앤씨/(주)대림/DL케미칼/DL건설/DL(주)/DL모터스/대림FNC/DL에너지) 등<br />";
			defMsg2 += "이름 : <br />ID : <br />직위 (사원/대리/과장/차장/부장)(운영/개발)(외부소속사이름) : <br />";
			defMsg2 += "접속DB (IP/DB명) : <br />";
			defMsg2 += "DB계정 : (타계정 권한 요청시 본계정의 담당자가 요청해야함)<br />";
			defMsg2 += "시스템명 : (APP시스템명)<br />";
			defMsg2 += "H.P번호 : <br />";
			defMsg2 += "Mail : <br />";
			defMsg2 += "PC IP : <br />";
			defMsg2 += "사용기간 : (최대:당해 연도 12월 31일)<br />";
			defMsg2 += "요청사유 : <br />";
			defMsg2 += "* 개발 인원은 운영DB 접속불가, 필요한 경우 부서장 승인 문서 첨부";
			
		var defMsg4 = "";
			defMsg4 += "● 기입 항목 (방화벽)<br />";
			defMsg4 += "신청 목적 :<br />";
			defMsg4 += "NAT_IP :<br />";
			defMsg4 += "출발지_IP :<br />";
			defMsg4 += "목적지_IP :<br />";
			defMsg4 += "PORT :    (TCP / UDP)<br />";
			defMsg4 += "요청사항 : 허용 / 차단<br />";
			defMsg4 += "사용기간 : 임시 (기간 :    ~    ) / 영구<br /><br />";
			defMsg4 += "- 방화벽 정책 신청은 자세히 부탁 드립니다. (NAT_IP는 해당사항이 있는 경우만 작성 부탁드립니다)<br />";
			defMsg4 += "- 접수 내역이 미비할 경우 티켓 접수가 되지 않습니다.<br />";
			defMsg4 += "- 외부 허용 대상을 전체(Any)로 요청할 경우 반드시 사유를 기입해야 합니다.<br />";
			defMsg4 += "- 서비스 전체(Any) 허용은 원칙적으로 불허합니다.<br />";
								
		var	defMsg5 = "";
		    defMsg5 += "● 기입 항목 (웹방화벽)<br />";
			defMsg5 += "신청 목적 :<br />";
			defMsg5 += "도메인(URL) :<br /><br />";
			defMsg5 += "- 웹방화벽에 인증서 갱신 및 등록하기 위해 인증서 파일 필요 (파일 첨부)<br />";
			
		var	defMsg6 = "";
			defMsg6 += "● 기입 항목 (방화벽)<br />";
			defMsg6 += "신청 목적 :<br />";
			defMsg6 += "NAT_IP :<br />";
			defMsg6 += "출발지_IP :<br />";
			defMsg6 += "목적지_IP :<br />";
			defMsg6 += "PORT : (TCP / UDP)<br />";
			defMsg6 += "요청사항 : 허용 / 차단<br />";
			defMsg6 += "사용기간 : 임시 (기간 : ~ ) / 영구<br />";
			defMsg6 += "PORT : (TCP / UDP)<br /><br />";
			defMsg6 += "- 방화벽 정책 신청은 자세히 부탁 드립니다. (NAT_IP는 해당사항이 있는 경우만 작성 부탁드립니다)<br />";
			defMsg6 += "- 접수 내역이 미비할 경우 티켓 접수가 되지 않습니다.<br />";
			defMsg6 += "- 외부 허용 대상을 전체(Any)로 요청할 경우 반드시 사유를 기입해야 합니다.<br />";
			defMsg6 += "- 서비스 전체(Any) 허용은 원칙적으로 불허합니다.<br />";

		// 서버접근제어 고정문구 내용 추가
		if( $('#srArea2').val() == '102880' ) { 
			tinyMCE.get('description').setContent(defMsg);
		}
		
		// DB접근제어(MS SQL), DB접근제어(Oracle) 고정문구 내용 추가
		if( $('#srArea2').val() == '102908' || $('#srArea2').val() == '102909' ) {  
			tinyMCE.get('description').setContent(defMsg2);
		}
		
		// 보안변경 > 방화벽  고정문구 내용 추가  
		if( $('#srArea2').val() == '102895' ) { 
			tinyMCE.get('description').setContent(defMsg4);
		}
		
		// 보안변경 > 웹방화벽  고정문구 내용 추가 
		if( $('#srArea2').val() == '102896' ) { 
			tinyMCE.get('description').setContent(defMsg5);
		}
		
		// IDC_SVC_294 보안정책(DL이앤씨 전용)  고정문구 내용 추가 
		if( $('#srArea2').val() == '105246' ) { 
			tinyMCE.get('description').setContent(defMsg6);
		}
	}
	
</script>
</body>
</html>
