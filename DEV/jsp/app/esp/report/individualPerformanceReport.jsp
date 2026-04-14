<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<%-- <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%> --%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.js?v=7.1.8"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.css?v=7.1.8">

<script>
	let dataset = [];
	var inProgress = false;
	const regionManager = '${regionManager}';
	const userTimeZone = '${sessionScope.loginInfo.sessionUserTimeZone}';

	var lastSearch_regStartDate;
	var lastSearch_regEndDate;
	
	var selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&esType=${esType}&companyIDs=${companyIDs}";
	
	
	$(document).ready(function(){

		$("input.datePicker").each(generateDatePicker);
		settingPeriod('LastWeek');
		
		// 초기 표시 화면 크기 조정 
		$("#layout01").attr("style","height:280px;");
		$("#layout02").attr("style","height:280px;");
		
		// 버튼 셋팅
		fnSetButton("search-btn", "search", "Search");
		fnSetButton("excel1", "", "Excel", "secondary");
		fnSetButton("excel2", "", "Excel", "secondary");
		getDicData("BTN", "LN0003").then(data => fnSetButton("clear", "clear", data.LABEL_NM,"secondary"));
		
		// 관계사 셋팅
		setCompany();
		
		combobox.events.on("change", function(value) {
			var customerNo = getCustomerId();
			if(customerNo) $("#teamName").prop("disabled", false);
			else $("#teamName").prop("disabled", true);
		});
		
	});
	
	// 관계사 setting
	function setCompany(){
		
		if (regionManager === "Y") selectData += "&myWorkspace=Y";
		selectData += "&sqlID=esm_SQL.getESPCustomerList&sqlGridList=N";
		
		combobox = new dhx.Combobox("comboBox", {
		    placeholder: "Select",
		    multiselection: true,
		    selectAllButton: true,
		  	newOptions: true
		});
		
		fetch("jsonDhtmlxListV7.do", {
		    method: "POST",
		    body: new URLSearchParams(selectData),
		    headers: {
		        "Content-Type": "application/x-www-form-urlencoded" 
		    }
		})
		.then(response => {
		    if (!response.ok) {
		    	throw new Error('서버 오류가 발생했습니다.'); 
		    }
		    return response.json();  // JSON 응답으로 처리
		})
		.then(result => {
			
			dataset = result.map(item => ({
			  id: item.id,     
			  value: item.NAME,
			  code: item.CODE
			}));
			
			combobox.data.parse(dataset);
			
			const targetCode = "${sessionScope.loginInfo.sessionClientId}";
	        const matchingItem = dataset.find(item => item.code === targetCode);

	        if (matchingItem) {
	            combobox.setValue([matchingItem.id]); 
	        }
	        
			// 지역관리자 아닌 경우 고정
			if (regionManager === "N") {
			        
			    combobox.disable();
			}
			
		});
	}

	function getClientIds() {
	    let selectedIds = combobox.getValue();

	    if (typeof selectedIds === "string") {
        	selectedIds = selectedIds.split(",");
	    } else if (!Array.isArray(selectedIds)) {
	        selectedIds = selectedIds ? [selectedIds] : [];
	    }

	    // serialize로 데이터 가져오기
	    const allItems = combobox.data.serialize();
	    
	    // 선택된 item 추출
	    const selectedItems = selectedIds.map(id =>
	        allItems.find(item => String(item.id) === String(id))
	    );
		
	    // code 추출
	    const selectedCodes = selectedItems
	        .filter(item => item && item.code)
	        .map(item => `'` + item.code + `'`);

	    return selectedCodes.length > 0 ? selectedCodes.join(', ') : "";
	}
	
	function getCustomerId() {
	    let selectedIds = combobox.getValue();
	    if (typeof selectedIds === "string") {
        	selectedIds = selectedIds.split(",");
	    } else if (!Array.isArray(selectedIds)) {
	        selectedIds = selectedIds ? [selectedIds] : [];
	    }
		
	    if (selectedIds.length !== 1) {
	        return false;
	    }

	    const allItems = combobox.data.serialize();
	    const item = allItems.find(obj => String(obj.id) === String(selectedIds[0]));

	    if (item && item.code) {
	        return item.code;
	    } else {
		    return ""; 
	    }

	}
	
	
	// title 셋팅
	getArcName("${arcCode}", ".page-title");
	
	$("input[name='periodStatus']").on("change", function () {
	    settingPeriod($(this).val());
	});
	
	function settingPeriod(value){
	    var today = new Date();
	    var startDate, endDate;

	    var day = today.getDay();

	    var weekStartDay = (userTimeZone === "Asia/Dhaka") ? 6 : 1; // 6:토요일 , 1:월요일
		// 한국,베트남 : 월요일부터 시작 / 방글라데시 : 토요일부터 시작
	    var diffToStart = (day - weekStartDay + 7) % 7;
	    var thisWeekStart = new Date(today);
	    thisWeekStart.setDate(today.getDate() - diffToStart);

	    var thisWeekEnd = new Date(thisWeekStart);
	    thisWeekEnd.setDate(thisWeekStart.getDate() + 6);
	    
	    if (value === "LastWeek") {
	        var lastWeekStart = new Date(thisWeekStart);
	        lastWeekStart.setDate(thisWeekStart.getDate() - 7);
	        var lastWeekEnd = new Date(lastWeekStart);
	        lastWeekEnd.setDate(lastWeekStart.getDate() + 6);

	        startDate = formatDate(lastWeekStart);
	        endDate = formatDate(lastWeekEnd);

	    } else if (value === "ThisWeek") {
	        startDate = formatDate(thisWeekStart);
	        endDate = formatDate(thisWeekEnd);

	    } else if (value === "ThisMonth") {
	        // 이번 달 1일
	        var firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
	        // 이번 달 마지막날
	        var lastDay = new Date(today.getFullYear(), today.getMonth() + 1, 0);

	        startDate = formatDate(firstDay);
	        endDate = formatDate(lastDay);
	    }

	    // 날짜 세팅
	    $("#regStartDate").val(startDate);
	    $("#regEndDate").val(endDate);
	}
	
	function formatDate(date) {
	    var y = date.getFullYear();
	    var m = ("0" + (date.getMonth() + 1)).slice(-2);
	    var d = ("0" + date.getDate()).slice(-2);
	    return y + "-" + m + "-" + d;
	}
	
	function fnSearchClear(){
		combobox.clear();
		$("#teamID").val('');
		$("#teamName").val('');
		$("#receiptUserNM").val('');
		$("#receiptUserID").val('');
	}	
	
	// 화면 크기 조정
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	// 상세 페이지 이동
	function doDetail(data){
// 		const isPopup = document.querySelector("#popup").checked;
		var srCode = data.SRCode;
		var srID = data.SRID;
		var status = data.Status;
		var srType = data.SRType;
		var esType = data.ESType;
		var receiptUserID = data.ReceiptUserID;
		if(receiptUserID == undefined) receiptUserID = "";
		
		var url = "esrInfoMgt.do";
		
		var data = "&srCode="+srCode + "&srID="+srID + "&status=" +status + "&srType=" +srType + "&receiptUserID=" + receiptUserID + "&esType=" + esType + "&isPopup=true";
		
		// 검색조건
		data += "&searchSrType="+$("#srType").val();
		data += "&searchStatus="+$("#srStatus").val();
		data += "&inProgress="+$("#inProgress").val();
		data += "&stSRCompDT="+$("#stSRCompDT").val();
		data += "&endSRCompDT="+$("#endSRCompDT").val();
		data += "&searchSrCode="+$("#srCode").val();
		data += "&subject="+$("#subject").val();
		data += "&regStartDate="+$("#regStartDate").val();
		data += "&regEndDate="+$("#regEndDate").val();
		data += "&customerNo="+$("#customerNo").val();
		data += "&srAreaSearch="+$("#srAreaSearch").val();
		data += "&srArea1="+$("#srArea1").val();
		data += "&srArea2="+$("#srArea2").val();
		data += "&requestUser="+$("#requestUser").val();
		data += "&requestUserID="+$("#requestUserID").val()	
		data += "&returnMenuId=${arcCode}";
		
		window.open(url+"?"+data,srID,"width=1400 height=800 resizable=yes");

// 		isPopup ? window.open(url+"?"+data,srID,"width=1400 height=800 resizable=yes") : ajaxPage(url, data, "srListDiv");
	}
	

	// 엑셀다운 (그리드01)
	function doExcelDetailGrid01() {
		const now = new Date();
		const formattedDateTime = now.getFullYear() 
		                        + String(now.getMonth() + 1).padStart(2, '0') 
		                        + String(now.getDate()).padStart(2, '0') 
		                        + String(now.getHours()).padStart(2, '0') 
		                        + String(now.getMinutes()).padStart(2, '0');
		
		const fileName1 = "IndividualPerformanceOverview_" + formattedDateTime;
		fnGridExcelDownLoad(grid01, "", fileName1);
	}
	
	// 엑셀다운 (그리드02)
	function doExcelDetailGrid02() {
		const now = new Date();
		const formattedDateTime = now.getFullYear() 
		                        + String(now.getMonth() + 1).padStart(2, '0') 
		                        + String(now.getDate()).padStart(2, '0') 
		                        + String(now.getHours()).padStart(2, '0') 
		                        + String(now.getMinutes()).padStart(2, '0');
		
		const fileName2 = "IndividualPerformanceDetail_" + formattedDateTime;
		fnGridExcelDownLoad(grid02, "", fileName2);
	}

	// 조회결과 셋팅
	var layout01 = new dhx.Layout("layout01", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	// 조회 결과
	var grid01 = new dhx.Grid("grid01", {
	    columns: [
	    	// 추후 클릭 대응용 담당자 ID
	    	{ hidden:true, id: "ManagerID", header: [{ text: "담당자ID", align: "center" }], align: "center" },
	    	// 추후 클릭 대응용 담당자 ClientID
	    	{ hidden:true, id: "ManagerClientID", header: [{ text: "담당자ClientID", align: "center" }], align: "center" },
	    	// 대상법인
	        { width: 80, id: "CompanyName", header: [{ text: "${menu.ZLN0226}", align: "center" }], align: "center" },
	        // 부서
	        { id: "TeamName", header: [{ text: "${menu.LN00104}", align: "center" }], align: "center" },
	        // 담당자명
	        { id: "ManagerName", header: [{ text: "${menu.LN00004}", align: "center" }], align: "center" },
	        // 접수건수
	        { id: "AssignedTotalCount", header: [{ text: "${menu.ZLN0219}", align: "center" }], type:"number", align: "center" },
	        // 완료합계
	        { id: "CompletedTotalCount", header: [{ text: "${menu.ZLN0220}",align: "center" }], type:"number", align: "center" },
	        // 정상완료
	        { id: "CompletedOnTimeCount", header: [{ text: "${menu.ZLN0221}",align: "center" }], type:"number", align: "center" },
	        // 정상완료율
	        { id: "OnTimePercentage", header: [{ text: "${menu.ZLN0222}(%)",align: "center" }], type:"number", align: "center", format: "#.00" },
	        // 지연완료
	        { id: "DelayedCompletedCount", header: [{ text: "${menu.ZLN0223}",align: "center" }], type:"number", align: "center" },
	        // 미완료
	        { id: "IncompletedCount", header: [{ text: "${menu.ZLN0224}",align: "center" }], type:"number", align: "center"},
	    ],	
	    
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: true,
	    footer: false
	  
	});
	


	layout01.getCell("a").attach(grid01);
	
	
	// 통계 검색
	function fnCallSearchGrid01(){
		fnGetGrid01Data();
		var initJson ="[{}]";
		fnReloadGrid02(initJson);
	}
	
	// Search 버튼 클릭 시 실행되는 Grid01에 주입할 데이터 호출하는 함수
	function fnGetGrid01Data(){ 		
		var teamID = $("#teamID").val();

		var regStartDate = $("#regStartDate").val();
		var regEndDate = $("#regEndDate").val();
		
		lastSearch_regStartDate = $("#regStartDate").val();
		lastSearch_regEndDate = $("#regEndDate").val();

		var sqlID = "esmReport_SQL.getindividualPerformanceReportGrid01Data";
		var param = "sqlID="+sqlID
					+"&receiptTeamID="+teamID
					+"&receiptUserID="+""
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&regStartDate="+regStartDate
					+ "&regEndDate="+regEndDate
					+ "&userID=${sessionScope.loginInfo.sessionUserId}";
		
		var clientIDs = getClientIds();
		
		if(clientIDs === "" || clientIDs === null || clientIDs === undefined){
			const allCodes = dataset.map(item => "'" + item.code + "'");
			param += "&clientIDs="+allCodes.join(',');
		} else {
			param += "&clientIDs="+clientIDs;
		}
					
		if(inProgress) {
			getDicData("ERRTP", "LN0002").then(data => alert(data.LABEL_NM));
		} else {
			
			inProgress = true;
			$('#loading').fadeIn(150);
			
			fetch("zDlm_jsonDhtmlxListV7.do", {
			    method: "POST",
			    body: new URLSearchParams(param),
			    headers: {
			        "Content-Type": "application/x-www-form-urlencoded" 
			    }
			})
			.then(response => {
			    if (!response.ok) {
			    	throw new Error('서버 오류가 발생했습니다.'); 
			    }
			    return response.json();  // JSON 응답으로 처리
			})
			.then(result => {
			    fnReloadGrid01(result);  // 응답을 처리하는 함수 호출
			})
			.catch(error => {
				getDicData("ERRTP", "ZLN0002").then(data => alert(data.LABEL_NM));
				console.error(error);
			})
			.finally(() => {
				inProgress = false;
			    $('#loading').fadeOut(150);  // 로딩 화면 숨기기
			});
			
		}
	}
	
	function fnReloadGrid01(newGridData){
		grid01.data.parse(newGridData);
		$("#TOT_CNT").html(grid01.data.getLength());
	}
	
	// 조회 결과 클릭
	grid01.events.on("cellClick", function(row,column,e){
		const managerID = row.ManagerID;	
		const customerNo = row.ManagerClientID;
		const teamID = $("#teamID").val();
		fnGetGrid02Data(managerID, customerNo, lastSearch_regStartDate, lastSearch_regEndDate);
			
	}); 
	
	
	//------------- 그리드 2 상세 ---------------------------------------------------------------------------------------------------------------------------------
	
	var layout02 = new dhx.Layout("layout02", {
	    rows: [
	        {
	            id: "b",
	        },
	    ]
	});
	
	var grid02 = new dhx.Grid("grid02", {
	    columns: [
	    	// 티켓ID
	    	{ width: 120, id: "SRCode", header: [{ text: "${menu.LN00396}" , align: "center" }], align: "center" },
	    	// 요청법인
	        { width: 80, id: "ClientName", header: [{ text: "${menu.ZLN0225}" , align: "center" }], align: "center" },
	        // 서비스
	        { width: 120, id: "SRArea1", header: [{ text: "${menu.ZLN0188}" , align: "center" }], align: "center" },
	        // 파트
	        { width: 120, id: "SRArea2", header: [{ text: "${menu.ZLN0079}" , align: "center" }], align: "center" },
			// 의뢰유형
	        { width: 120,  id: "Category", header: [{ text: " ${menu.LN00272}" , align: "center" }], align: "center" },
	        // 서브의뢰유형
	        { width: 120,  id: "Subcategory", header: [{ text: " ${menu.LN00273}" , align: "center" }], align: "center" },
	        // 티켓 제목
	        { id: "Title", header: [{ text: "${menu.LN00002}" , align: "center" }], align: "left" },
	        // 요청일
	        { width: 90, id: "RegDT", header: [{ text: "${menu.LN00093}" , align: "center" }], align: "center" },
	        // 요청자
	        { width: 180, id: "RegUserName", header: [{ text: "${menu.LN00025}" , align: "center" }], align: "center" },
	        // 접수일
	        { width: 120, id: "ReceiptDate", header: [{ text: "${menu.LN00077}" , align: "center" }], align: "center" }, 
	        // 담당자
	        { width: 120, id: "ReceiptUserName", header: [{ text: "${menu.LN00004}" , align: "center" }], align: "center" }, 
	        // 완료예정일
	        { width: 90, id: "DueDate", header: [{ text: "${menu.LN00221}" , align: "center" }], align: "center" },
	        // 처리완료일
	        { width: 90, id: "CompletionDT", header: [{ text: "${menu.LN00223}" , align: "center" }], align: "center" },
	        // 지연일수
	        { width: 90, id: "DelayedDays", header: [{ text: "${menu.ZLN0090}" , align: "center" }], type:"number", align: "center" },
	        // Man*Hour
	        { width: 90, id: "TotalBusinessHours", header: [{ text: "Man*Hour" , align: "center" }], type:"number",  align: "center", format: "#.00"},
	        
	    ],
	    
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: true,
	    footer: false
	  
	});


	layout02.getCell("b").attach(grid02);
	
 	grid02.events.on("cellClick", function (row,column,e) {
 		doDetail(row);
 	});

	
	function fnGetGrid02Data(managerID, customerNo, regStartDate, regEndDate){
		var sqlID = "esmReport_SQL.getindividualPerformanceReportGrid02Data";
		var param = "sqlID="+sqlID
					+ "&managerID="+managerID
					+ "&clientID="+customerNo
					+ "&regStartDate="+regStartDate
					+ "&regEndDate="+regEndDate				
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&sessionUserID=${sessionScope.loginInfo.sessionUserId}"

					
		if(inProgress) {
			getDicData("ERRTP", "LN0002").then(data => alert(data.LABEL_NM));
		} else {
			inProgress = true;
			$('#loading').fadeIn(150);
			
			fetch("zDlm_jsonDhtmlxListV7.do", {
			    method: "POST",
			    body: new URLSearchParams(param),
			    headers: {
			        "Content-Type": "application/x-www-form-urlencoded" 
			    }
			})
			.then(response => {
			    if (!response.ok) {
			        throw new Error('서버 오류가 발생했습니다.'); 
			    }
			    return response.json();  // JSON 응답으로 처리
			})
			.then(result => {
				const grid02Section = document.getElementById("grid02Section");
				grid02Section.style.display = "block";
	        	fnReloadGrid02(result);  // 정상 응답 처리
			})
			.catch(error => {
				getDicData("ERRTP", "ZLN0002").then(data => alert(data.LABEL_NM));
			})
			.finally(() => {
				inProgress = false;
			    $('#loading').fadeOut(150);  // 로딩 화면 숨기기
			});
		}
	}
	
	function fnReloadGrid02(newGridData){
		grid02.data.parse(newGridData);
	}
	
//------------- 엑셀 그리드 ---------------------------------------------------------------------------------------------------------------------------------
	
	var layout03 = new dhx.Layout("layout03", {
	    rows: [
	        {
	            id: "c",
	        },
	    ]
	});
	
	var excelGrid = new dhx.Grid("excelGrid", {
	    columns: [
	    	// 티켓ID
	    	{ width: 120, id: "SRCode", header: [{ text: "${menu.LN00396}" , align: "center" }], align: "center" },
	    	// 요청법인
	        { width: 80, id: "ClientName", header: [{ text: "${menu.ZLN0225}" , align: "center" }], align: "center" },
	        // 서비스
	        { width: 120, id: "SRArea1", header: [{ text: "${menu.ZLN0188}" , align: "center" }], align: "center" },
	        // 파트
	        { width: 120, id: "SRArea2", header: [{ text: "${menu.ZLN0079}" , align: "center" }], align: "center" },
			// 의뢰유형
	        { width: 120,  id: "Category", header: [{ text: " ${menu.LN00272}" , align: "center" }], align: "center" },
	        // 서브의뢰유형
	        { width: 120,  id: "Subcategory", header: [{ text: " ${menu.LN00273}" , align: "center" }], align: "center" },
	        // 티켓 제목
	        { id: "Title", header: [{ text: "${menu.LN00002}" , align: "center" }], align: "left" },
	        // 요청일
	        { width: 90, id: "RegDT", header: [{ text: "${menu.LN00093}" , align: "center" }], align: "center" },
	        // 요청자
	        { width: 180, id: "RegUserName", header: [{ text: "${menu.LN00025}" , align: "center" }], align: "center" },
	        // 접수일
	        { width: 120, id: "ReceiptDate", header: [{ text: "${menu.LN00077}" , align: "center" }], align: "center" }, 
	        // 담당자
	        { width: 120, id: "ReceiptUserName", header: [{ text: "${menu.LN00004}" , align: "center" }], align: "center" }, 
	        // 완료예정일
	        { width: 90, id: "ReqDueDate", header: [{ text: "${menu.LN00221}" , align: "center" }], align: "center" },
	        // 처리완료일
	        { width: 90, id: "CompletionDT", header: [{ text: "${menu.LN00223}" , align: "center" }], align: "center" },
	        // 지연일수
	        { width: 90, id: "DelayedDays", header: [{ text: "${menu.ZLN0090}" , align: "center" }], type:"number", align: "center" },
	        // Man*Hour
	        { width: 90, id: "TotalBusinessHours", header: [{ text: "Man*Hour" , align: "center" }], type:"number",  align: "center" },
	        
	    ],
	    
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: false,
	    footer: false
	  
	});


	layout03.getCell("c").attach(excelGrid);
	
	function fnGetPrintExcelGrid(){
		var teamID = $("#teamID").val();

		var regStartDate = lastSearch_regStartDate;
		var regEndDate = lastSearch_regEndDate;
		
	
		var sqlID = "esmReport_SQL.getindividualPerformanceReportGrid02Data";
		var param = "sqlID="+sqlID
					+ "&regStartDate="+regStartDate
					+ "&regEndDate="+regEndDate		
					+ "&receiptTeamID="+teamID
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&sessionUserID=${sessionScope.loginInfo.sessionUserId}"
					
					
		var clientIDs = getClientIds();
		
		if(clientIDs === "" || clientIDs === null || clientIDs === undefined){
			const allCodes = dataset.map(item => "'" + item.code + "'");
			param += "&clientIDs="+allCodes.join(',');
		} else {
			param += "&clientIDs="+clientIDs;
		}

					
		if(inProgress) {
			getDicData("ERRTP", "LN0002").then(data => alert(data.LABEL_NM));
		} else {
			inProgress = true;
			$('#loading').fadeIn(150);
			
			fetch("zDlm_jsonDhtmlxListV7.do", {
			    method: "POST",
			    body: new URLSearchParams(param),
			    headers: {
			        "Content-Type": "application/x-www-form-urlencoded" 
			    }
			})
			.then(response => {
			    if (!response.ok) {
			        throw new Error('서버 오류가 발생했습니다.'); 
			    }
			    return response.json();  // JSON 응답으로 처리
			})
			.then(result => {
				fnReloadExcelGrid(result);  // 정상 응답 처리
			})
			.catch(error => {
				getDicData("ERRTP", "ZLN0002").then(data => alert(data.LABEL_NM));
			})
			.finally(() => {
				inProgress = false;
			    $('#loading').fadeOut(150);  // 로딩 화면 숨기기
				const now = new Date();
				const formattedDateTime = now.getFullYear() 
				                        + String(now.getMonth() + 1).padStart(2, '0') 
				                        + String(now.getDate()).padStart(2, '0') 
				                        + String(now.getHours()).padStart(2, '0') 
				                        + String(now.getMinutes()).padStart(2, '0');
				
				const fileName3 = "IndividualPerformance_" + formattedDateTime;
				fnGridExcelDownLoad(excelGrid, "", fileName3);
			});
		}
	}
	
	function fnReloadExcelGrid(newGridData){
		excelGrid.data.parse(newGridData);
	}
	
	
	// =============================================
	
	
	
	
	
	// 팝업 화면 위치
	function setPopupPosition(popupWidth,popupHeight){
		var screenLeft = window.screenLeft !== undefined ? window.screenLeft : screen.left;
		var screenTop = window.screenTop !== undefined ? window.screenTop : screen.top;

		var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth;
		var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight;

		var left = screenLeft + (width - popupWidth) / 2;
		var top = screenTop + (height - popupHeight) / 2;
		
		return [left,top];
	}
	
	// 부서 검색
	function searchPopup(url){
		//const customerSelect = document.getElementById("customerNo").value;
		var customerNo = getCustomerId();
		var searchValue = $("#teamName").val();
		
		var [left, top] = setPopupPosition(800, 630);
		url += "?viewOption=ALL&languageID=${sessionScope.loginInfo.sessionCurrLangType}&clientID=" + customerNo + '&searchValue=' + searchValue;
		if(customerNo) window.open(url ,'',`width=800, height=630, left=` + left + `, top=` + top + `, scrollbars=yes, resizable=0`);
	}
	function setSearchTeam(teamID,teamName){$('#teamID').val(teamID);$('#teamName').val(teamName);}
	
	document.getElementById('teamName').addEventListener('keydown', function(event) {
       if (event.key === 'Enter') {
           event.preventDefault(); // 기본 Enter 동작 방지 (필요시)
           searchPopup('searchTeamPop.do');
       }
	});
	
	function searchMemberCallback(avg1,avg2,avg3,avg4,avg5,avg6){
		$("#receiptUserNM").val(avg2+"("+avg3+"/"+avg4+")");
		$("#receiptUserID").val(avg1);
	}
	
	document.getElementById("searchTeamBtn").addEventListener("click", function() {
		searchPopup('searchTeamPop.do');
	})
	
	
	// 페이징
	var pagination = new dhx.Pagination("pagination", {
	    data: grid02.data,
	    pageSize : 30
	});

	function changePageSize(e) {
		pagination.setPageSize(parseInt(e));
	}
	
</script>

<div id="srListDiv" class="pdL10 pdR10">
<div class="page-title"></div>
<table border="0" cellpadding="0" cellspacing="0" width="100%" class="form-column-4 new-form" id="search">
	<tr>
		<!-- 티켓 접수 법인 -->
       	<th class="alignL">${menu.ZLN0211}</th>
       	<td class="alignL">
       		<div id="comboBox" style="width: 60%; display:inline-block;"></div>
	       	<input type="hidden" id="customerNo" name="customerNo" value="${sessionScope.loginInfo.sessionClientId}" />
       	</td>
		<!-- 요청일 -->
		<th class="alignL">${menu.LN00093}</th>     
        <td>     
			<font><input type="text" id="regStartDate" name="regStartDate" value="${regStartDate}"	class="input_off datePicker stext" size="8"
				onchange="this.value = makeDateType(this.value);"	maxlength="15" >
			</font>
			-
			<font><input type="text" id="regEndDate" name="regEndDate" value="${regEndDate}"	class="input_off datePicker stext" size="8"
				onchange="this.value = makeDateType(this.value);"	maxlength="15">
			</font>
        </td>
        <th></th>
        <td style="padding-top:6px;">
        	<input type="radio" value="LastWeek" id="LastWeek" name="periodStatus" checked />
			<label style="font-size:11px;" for="LastWeek">${menu.ZLN0216 }</label>
			
			<input type="radio" value="ThisWeek" id="ThisWeek" name="periodStatus" />
			<label style="font-size:11px;" for="ThisWeek">${menu.ZLN0217 }</label>
			
			<input type="radio" value="ThisMonth" id="ThisMonth" name="periodStatus" />
			<label style="font-size:11px;" for="ThisMonth">${menu.ZLN0218 }</label>
        </td>
    </tr>
    <tr>
       	<th class="alignL">${menu.ZLN0129}</th>
       	<td class="alignL">
			<input type="text" class="text" style="width:60%; " autocomplete="off" id="teamName" name="teamName" />
			<input type="hidden" class="text" readonly="readonly" id="teamID" name="teamID" value="" />
			<img id="searchTeamBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" />
       	</td>
   	</tr>
</table>

<div class="btn-wrap justify-center pdT10">
	<div class="btns">
		<button id="search-btn" onclick="fnCallSearchGrid01();"></button>
		<button id="clear" onclick="fnSearchClear();"></button>
		<button id="excel1" onclick="fnGetPrintExcelGrid()"></button>
	</div>
</div>
	
<div class="btn-wrap pdT10 pdB5 justify-between" style="width: 100%">
	<div class="count">
		Total
		<span id="TOT_CNT"></span>
	</div>
</div>

<div style="width:100%; " id="layout01"></div>
<div id="grid02Section" style="display: none; margin-top: 8px;">
		<div class="title-wrap" style="display: flex; justify-content: space-between; align-items: center; padding-bottom: 10px;">
			<div class="">${menu.LN00108}</div>
            <div class="btns">
                <button id="excel2" onclick="doExcelDetailGrid02()"></button>
            </div>
		</div>
	
	<div id="layout02" style="width:100%;height:100%; "></div>
	<div class="align-center flex">
		<select id="pageRow" onchange="changePageSize(this.value)">
			<option value=10>10</option>
			<option value=20>20</option>
			<option value=30 selected>30</option>
			<option value=40>40</option>
			<option value=50>50</option>
			<option value=100>100</option>
		</select>
		<div id="pagination" style="position: relative;margin: 0 auto;"></div>
	</div>
</div>

<div style="width:100%; display:none; " id="layout3"></div>

<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>


