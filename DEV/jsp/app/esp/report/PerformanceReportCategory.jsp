<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.js?v=7.1.8"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.css?v=7.1.8">

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>

<script>
	let dataset = [];
	var inProgress = false; // main
	var inProgress2 = false; // detail
	const regionManager = '${regionManager}';
	var selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&esType=${esType}&companyIDs=${companyIDs}";
	const userTimeZone = '${sessionScope.loginInfo.sessionUserTimeZone}';
	let srType = '';
	let combobox; 
	
	$(document).ready(function(){
		
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:400px;");
		$("#layout2").attr("style","height:"+(setWindowHeight() - 480)+"px;");
		
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout2").attr("style","height:"+(setWindowHeight() - 480)+"px;");
		};
		
		// 버튼 셋팅
		fnSetButton("search-btn", "search", "Search");
		getDicData("BTN", "LN0003").then(data => fnSetButton("clear", "clear", data.LABEL_NM,"secondary"));
		fnSetButton("excel1", "", "Excel", "secondary");
		fnSetButton("excel2", "", "Excel", "secondary");
		
		// 관계사 셋팅
		setCompany();
		
		// 기간 설정 ( default : 전주 )
		$("input.datePicker").each(generateDatePicker);
		settingPeriod('LastWeek');
		
		// process 다중 선택
		fnSelect('srType', selectData, 'getSRTypeList', "" , 'Select', 'esm_SQL');
		
		setupAccumulatedSelect({
		    selectId: "srType",
		    nextSelectId: ["category","subCategory"],
		    containerId: "selectedProcessType",
		    nextContainerID: ["selectedCategory","selectedSubCategory"],
		    hiddenId: "srTypes",
		    nextHiddenId: ["categories","subCagtegories"],
		    callback: [fnGetCategory,fnGetSubCategory]
		});

		// 2단계: category → subCategory
		setupAccumulatedSelect({
		    selectId: "category",
		    nextSelectId: ["subCategory"],
		    containerId: "selectedCategory",
		    nextContainerID: ["selectedSubCategory"],
		    hiddenId: "categories",
		    nextHiddenId: ["subCagtegories"],
		    callback: [fnGetSubCategory]
		});
		
		// 3단계: subCategory
		setupAccumulatedSelect({
		    selectId: "subCategory",
		    nextSelectId: [],
		    containerId: "selectedSubCategory",
		    nextContainerID : [],
		    hiddenId: "subCagtegories",
		    nextHiddenId: [],
		    callback: []
		});
		
	});
	
	// 다중선택
	function setupAccumulatedSelect(config) {
	    const {
	        selectId,
	        nextSelectId,
	        containerId,
	        nextContainerID,
	        hiddenId,
	        nextHiddenId,
	        callback
	    } = config;

	    // 초기 상태: 다음 select 비활성화
	    if (nextSelectId) nextSelectId.forEach(id => $("#" + id).prop("disabled", true));

	    // 선택 시
	    $("#" + selectId).on("change", function() {
	        const selectedOption = $(this).find("option:selected");
	        const val = `'` + selectedOption.val() + `'`;
	        const originVal = selectedOption.val();
	        const text = selectedOption.text();
	        
	        if (!originVal) return;

	        // 현재 hidden 값 가져오기
	        let currentValues = $("#" + hiddenId).val();
	        let accumulated = currentValues ? currentValues.split(",") : [];

	        if (!accumulated.includes(val)) {
	        	
	        	
	            accumulated.push(val);

	            const $span = $('<span data-val="' + originVal + '" style="margin-right:8px; color:#0761CF;">' +
	                            text +
	                            ' <button type="button" class="removeItem" style="margin-left:4px;">×</button>' +
	                            '</span>');

	            $("#" + containerId).append($span);
	            $("#" + hiddenId).val(accumulated.join(","));
	            
	            if (accumulated.length === 1) {
	            	$("#" + selectId).val(originVal).trigger("change");
	                if (nextSelectId) $("#" + nextSelectId[0]).prop("disabled", false);
	                if (callback.length > 0) callback[0](originVal);
	            } else {
	                if (nextSelectId) nextSelectId.forEach(id => $("#" + id).prop("disabled", true));
	                if(nextContainerID) nextContainerID.forEach(id => $("#" + id).text(''));
	                if(nextHiddenId) nextHiddenId.forEach(id => $("#" + id).val(''));
	                if (callback.length > 0) callback.forEach(call => call(''));
	            }
	        }
	    });

	 // 삭제 버튼 클릭 (delegated)
	    $(document).on("click", "#" + containerId + " .removeItem", function() {
	        const $span = $(this).closest("span");
	        const val = `'` + $span.data("val") + `'`;
			
	     	// hidden 값 기준으로 배열 재생성
	        let currentValues = $("#" + hiddenId).val();
	        let accumulated = currentValues ? currentValues.split(",") : [];

	     	// 제거
	        accumulated = accumulated.filter(v => v !== val);

	        $("#" + hiddenId).val(accumulated.join(","));
	        $span.remove();
	        if (accumulated.length === 1) {
	        	$("#" + selectId).val(accumulated[0].replace(/'/g, "")).trigger("change");
	            if (nextSelectId) $("#" + nextSelectId).prop("disabled", false);
	            if (callback.length > 0) callback[0](accumulated[0].replace(/'/g, ""));
	        } else {
	        	if(nextSelectId) nextSelectId.forEach(id => $("#" + id).prop("disabled", true));
	            if(nextContainerID) nextContainerID.forEach(id => $("#" + id).text(''));
	            if(nextHiddenId) nextHiddenId.forEach(id => $("#" + id).val(''));
	            if (callback.length > 0) callback.forEach(call => call(''));
	        }
	    });
	}
	
	
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
	
	// title 셋팅
	getArcName("${arcCode}", ".page-title");
	
	// 화면 크기 조정
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	// 엑셀다운 (상세)
	function doExcelDetail() {
		const now = new Date();
		const formattedDateTime = now.getFullYear() 
		                        + String(now.getMonth() + 1).padStart(2, '0') 
		                        + String(now.getDate()).padStart(2, '0') 
		                        + String(now.getHours()).padStart(2, '0') 
		                        + String(now.getMinutes()).padStart(2, '0');
		
		const fileName2 = "performanceRepotCategoryDetail_" + formattedDateTime;
		fnGridExcelDownLoad(grid2, "", fileName2);
	
	}
	
	// 엑셀다운 (상세)
	function doExcel() {
		const now = new Date();
		const formattedDateTime = now.getFullYear() 
		                        + String(now.getMonth() + 1).padStart(2, '0') 
		                        + String(now.getDate()).padStart(2, '0') 
		                        + String(now.getHours()).padStart(2, '0') 
		                        + String(now.getMinutes()).padStart(2, '0');
		
		const fileName2 = "performanceRepotCategory_" + formattedDateTime;
		fnGridExcelDownLoad(excelGrid, "", fileName2);
	
	}
	
	
	// 조회결과 셋팅
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	// 조회 결과
	var grid = new dhx.Grid("grid", {
	    columns: [
	    	{ id: "CompanyName", header: [{ text: "${menu.LN00014}",align: "center" }], align: "center" },
	        { id: "ProcessName", header: [{ text: "${menu.LN00011}",align: "center" }], align: "center" },
	        { id: "CategoryNM", header: [{ text: "${menu.LN00272 }", align: "center" }], align: "center" },
	        { id: "SubCategoryNM", header: [{ text: "${menu.LN00273 }", align: "center" }], align: "center" },
	        { id: "TicketReceived", header: [{ text: "${menu.ZLN0219}",align: "center" }], type:"number", align: "center" },
	        { id: "TotalCompleted", header: [{ text: "${menu.ZLN0220}",align: "center" }], type:"number", align: "center" },
	        { id: "CompletedSuccessfully", header: [{ text: "${menu.ZLN0221}",align: "center" }], type:"number", align: "center" },
	        { id: "SuccessRate", header: [{ text: "${menu.ZLN0222}(%)",align: "center" }], type:"number", align: "center", format: "#.00" },
	        { id: "CompletedDelay", header: [{ text: "${menu.ZLN0223}",align: "center" }], type:"number", align: "center" },
	        { id: "Incomplete", header: [{ text: "${menu.ZLN0224}",align: "center" }], type:"number", align: "center" },
	        { hidden:true, width: 120, id: "SRType", header: [{ text: "srType" , align: "center" }], align: "center" },
	        { hidden:true, width: 120, id: "Category", header: [{ text: "category" , align: "center" }], align: "center" },
	        { hidden:true, width: 120, id: "SubCategory", header: [{ text: "subCategory" , align: "center" }], align: "center" },
	        { hidden:true, width: 120, id: "ClientID", header: [{ text: "clientID" , align: "center" }], align: "center" },
	    ],
	    
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: true,
	    footer: false
	  
	});


	layout.getCell("a").attach(grid);
	
	// 통계 검색
	function fnCallSearch(){
		fnSearch();
		var initJson ="[{}]";
		fnReloadGrid2(initJson);
	}
	
	// 통계 검색
	function fnSearch(){ 		
		
		var REG_STR_DT = $("#regStartDate").val();
		var REG_END_DT = $("#regEndDate").val();
		var srType = $("#srTypes").val();
		var categories = $("#categories").val();
		var subCategories = $("#subCategories").val();
		
		if (!REG_STR_DT || !REG_END_DT) {
			getDicData("ERRTP", "LN0001").then(data => alert(data.LABEL_NM));
		    return false;
		}

		var sqlID = "esmReport_SQL.getPerformReportList";
		var param = "sqlID="+sqlID
					+"&type=category"
					+ "&regStartDate=" + REG_STR_DT
					+ "&regEndDate=" + REG_END_DT
					+ "&srTypes=" + srType
					+ "&categories=" + (categories || '')
					+ "&subCategories=" + (subCategories || '')
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
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
				$("#detailBox").hide(); // 상세 hide
			    fnReloadGrid(result);  // 응답을 처리하는 함수 호출
			    fnSearchDetail('','','','',true);
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
	
	function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
		$("#TOT_CNT").html(grid.data.getLength());
	}
	
	grid.events.on("cellClick", function(row,column,e){
		
		var srType = row.SRType;
		var category = row.Category;
		var subCategory = row.SubCategory;
		var clientID = row.ClientID;
		$("#detailBox").show(); // 상세 open
		fnSearchDetail(srType,category,subCategory,clientID);
			
	});
	
	//------------- 그리드 2 상세 ---------------------------------------------------------------------------------------------------------------------------------
	
	var layout2 = new dhx.Layout("layout2", {
	    rows: [
	        {
	            id: "b",
	        },
	    ]
	});
	
	var grid2 = new dhx.Grid("grid2", {
	    columns: [
	    	{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center", template: function (text, row, col) { return row.RNUM;}},
	        { width: 120, id: "SRCode", header: [{ text: "${menu.LN00396}" , align: "center" }], align: "center" },
	        { width: 120, id: "CompanyName", header: [{ text: "${menu.ZLN0225}" , align: "center" }], align: "center" },
	        { width: 120, id: "SRArea2Name", header: [{ text: "${menu.ZLN0188}" , align: "center" }], align: "center" },
	        { width: 120, id: "SRArea1Name", header: [{ text: "${menu.ZLN0079}" , align: "center" }], align: "center" },
	        { width: 120,  id: "CategoryNM", header: [{ text: " ${menu.LN00272}" , align: "center" }], align: "center" },
	        { width: 120,  id: "SubCategoryNM", header: [{ text: " ${menu.LN00272}" , align: "center" }], align: "center" },
	        { id: "Subject", header: [{ text: "${menu.LN00002}" , align: "center" }], align: "left" },
	        { width: 90, id: "RegDate", header: [{ text: "${menu.LN00093}" , align: "center" }], align: "center", template: function(value) { return value && typeof value === 'string' && value.includes(' ') ? value.split(' ')[0] : null; }  },
	        { width: 180, id: "ReqUserNM", header: [{ text: "${menu.LN00025}" , align: "center" }], align: "center" },
	        { width: 120, id: "RCPT_DATE", header: [{ text: "${menu.LN00077}" , align: "center" }], align: "center", template: function(value) { return value && typeof value === 'string' && value.includes(' ') ? value.split(' ')[0] : null; }  }, 
	        { width: 120, id: "ReceiptName", header: [{ text: "${menu.LN00004}" , align: "center" }], align: "center" }, 
	        { width: 90, id: "DueDate", header: [{ text: "${menu.LN00221}" , align: "center" }], align: "center", template: function(value) { return value && typeof value === 'string' && value.includes(' ') ? value.split(' ')[0] : null; }  },
	        { width: 120, id: "SRCompletionDT", header: [{ text: "${menu.LN00223}" , align: "center" }], align: "center",template: function(value) { return value && typeof value === 'string' && value.includes(' ') ? value.split(' ')[0] : null; } },
	        { width: 90, id: "delayDay", header: [{ text: "${menu.ZLN0090}" , align: "center" }], type:"number", align: "center",  template: function (text, row, col) {return (text > 0) ? text : "0";}},
	        { hidden:true, width: 120, id: "SRType", header: [{ text: "srType" , align: "center" }], align: "center" },
	        { hidden:true, width: 120, id: "ESType", header: [{ text: "esType" , align: "center" }], align: "center" },
	        { hidden:true, width: 120, id: "SRID", header: [{ text: "srID" , align: "center" }], align: "center" },
	        { hidden:true, width: 120, id: "Status", header: [{ text: "status" , align: "center" }], align: "center" },
	        { hidden:true, width: 120, id: "ReceiptUserID", header: [{ text: "receiptUserID" , align: "center" }], align: "center" },
	    ],
	    
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: true,
	    footer: false
	});


	layout2.getCell("b").attach(grid2);
	
	grid2.events.on("cellClick", function (row,column,e) {
 		doDetail(row);
 	});
	
	// 상세 페이지 이동
	function doDetail(data){
		var srCode = data.SRCode;
		var srID = data.SRID;
		var status = data.Status;
		var srType = data.SRType;
		var esType = data.ESType;
		var receiptUserID = data.ReceiptUserID;
		if(receiptUserID == undefined) receiptUserID = "";
		
		var url = "esrInfoMgt.do";
		var data = "&srCode="+srCode + "&srID="+srID + "&status=" +status + "&srType=" +srType + "&receiptUserID=" + receiptUserID + "&esType=" + esType + "&isPopup=true";
		
		window.open(url+"?"+data,srID,"width=1400 height=800 resizable=yes");

	}
	
	
	function fnSearchDetail(srType, category, subCategory, clientID, excel){
		
		var REG_STR_DT = $("#regStartDate").val();
		var REG_END_DT = $("#regEndDate").val();
		
		if (!REG_STR_DT || !REG_END_DT) {
			getDicData("ERRTP", "LN0001").then(data => alert(data.LABEL_NM));
		    return false;
		}
		
		var sqlID = "esmReport_SQL.getOpenTicketDetailList";
		var param = "sqlID="+sqlID
					+ "&regStartDate=" + REG_STR_DT
					+ "&regEndDate=" + REG_END_DT
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&userID=${sessionScope.loginInfo.sessionUserId}";
		
					
		if(excel){
			var srType = $("#srTypes").val();
			var categories = $("#subCategories").val();
			var subCategories = $("#subCategories").val();
			var clientIDs = getClientIds();
			if(clientIDs === "" || clientIDs === null || clientIDs === undefined){
				const allCodes = dataset.map(item => "'" + item.code + "'");
				param += "&clientIDs="+allCodes.join(',');
			} else {
				param += "&clientIDs="+clientIDs;
			}
			
			param += "&srTypes=" + srType;
			param += "&categories=" + (categories || '');
			param += "&subCategories=" + (subCategories || '');
			
		} else {
			param += "&srType="+srType;
			param += "&clientID="+clientID;
			param += "&category="+category;
			param += "&subCategory="+subCategory;
		}		
					
		if(inProgress2) {
			getDicData("ERRTP", "LN0002").then(data => alert(data.LABEL_NM));
		} else {
			inProgress2 = true;
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
				if(excel) fnReloadExcelGrid(result);
	        	else fnReloadGrid2(result);  // 정상 응답 처리
			})
			.catch(error => {
				getDicData("ERRTP", "ZLN0002").then(data => alert(data.LABEL_NM));
			})
			.finally(() => {
				inProgress2 = false;
			    $('#loading').fadeOut(150);  // 로딩 화면 숨기기
			});
		}
	}
	
	function fnReloadGrid2(newGridData){
		grid2.data.parse(newGridData);
	}
	
	// 페이징
	var pagination = new dhx.Pagination("pagination", {
	    data: grid2.data,
	    pageSize : 30
	});

	function changePageSize(e) {
		pagination.setPageSize(parseInt(e));
	}
	
	// category 설정
	function fnGetCategory(srType){
		if(srType == ''){
			$("#category option").not("[value='']").remove();
		} else {
			fnSelect('category', selectData +"&srType=" + srType +"&level=1&customerNo=" + $("#customerNo").val(), 'getESPSRCategory', '${category}', 'Select','esm_SQL');
		}
	}
	
	// subCategory 설정
	function fnGetSubCategory(parentID){
		subCategory = null;
		if(parentID == ''  || parentID === undefined){
			$("#subCategory option").not("[value='']").remove();
		} else {
			var data = selectData + "&parentID="+parentID + "&customerNo=" + $("#customerNo").val() + "&srType=" + $("#srType").val();
			fnSelect('subCategory', data, 'getESMSRCategory', '${subCategory}', 'Select', 'esm_SQL');
		}
	}
	
	// ==========================================
	// 기간 선택 라디오 버튼 이벤트
	// ==========================================
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

	// yyyy-MM-dd 포맷 함수
	function formatDate(date) {
	    var y = date.getFullYear();
	    var m = ("0" + (date.getMonth() + 1)).slice(-2);
	    var d = ("0" + date.getDate()).slice(-2);
	    return y + "-" + m + "-" + d;
	}
	
	function fnSearchClear(){
		
		combobox.clear();
		var nextSelectId = ["category","subCategory"];
	    var nextContainerID = ["selectedProcessType","selectedCategory","selectedSubCategory"];
	    var nextHiddenId = ["srTypes","categories","subCagtegories"];
	    var callback = [fnGetCategory,fnGetSubCategory];
		
		fnSelect('srType', selectData, 'getSRTypeList', "" , 'Select', 'esm_SQL');
		if (nextSelectId) nextSelectId.forEach(id => $("#" + id).prop("disabled", true));
	    if(nextContainerID) nextContainerID.forEach(id => $("#" + id).text(''));
	    if(nextHiddenId) nextHiddenId.forEach(id => $("#" + id).val(''));
	    if(callback.length > 0) callback.forEach(call => call(''));
	}
	
	function fnReloadExcelGrid(newGridData){
		excelGrid.data.parse(newGridData);
	}
	
	var layout3 = new dhx.Layout("layout3", {
	    rows: [
	        {
	            id: "b",
	        },
	    ]
	});
	
	var excelGrid = new dhx.Grid("excelGrid", {
	    columns: [
	    	{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center", template: function (text, row, col) { return row.RNUM;}},
	        { width: 120, id: "SRCode", header: [{ text: "${menu.LN00396}" , align: "center" }], align: "center" },
	        { width: 120, id: "CompanyName", header: [{ text: "${menu.ZLN0225}" , align: "center" }], align: "center" },
	        { width: 120, id: "SRArea2Name", header: [{ text: "${menu.ZLN0188}" , align: "center" }], align: "center" },
	        { width: 120, id: "SRArea1Name", header: [{ text: "${menu.ZLN0079}" , align: "center" }], align: "center" },
	        { width: 120,  id: "CategoryNM", header: [{ text: " ${menu.LN00272}" , align: "center" }], align: "center" },
	        { width: 120,  id: "SubCategoryNM", header: [{ text: " ${menu.LN00272}" , align: "center" }], align: "center" },
	        { id: "Subject", header: [{ text: "${menu.LN00002}" , align: "center" }], align: "left" },
	        { width: 90, id: "RegDate", header: [{ text: "${menu.LN00093}" , align: "center" }], align: "center", template: function(value) { return value && typeof value === 'string' && value.includes(' ') ? value.split(' ')[0] : null; }  },
	        { width: 180, id: "ReqUserNM", header: [{ text: "${menu.LN00025}" , align: "center" }], align: "center" },
	        { width: 120, id: "RCPT_DATE", header: [{ text: "${menu.LN00077}" , align: "center" }], align: "center", template: function(value) { return value && typeof value === 'string' && value.includes(' ') ? value.split(' ')[0] : null; }  }, 
	        { width: 120, id: "ReceiptName", header: [{ text: "${menu.LN00004}" , align: "center" }], align: "center" }, 
	        { width: 90, id: "DueDate", header: [{ text: "${menu.LN00221}" , align: "center" }], align: "center", template: function(value) { return value && typeof value === 'string' && value.includes(' ') ? value.split(' ')[0] : null; }  },
	        { width: 120, id: "SRCompletionDT", header: [{ text: "${menu.LN00223}" , align: "center" }], align: "center",template: function(value) { return value && typeof value === 'string' && value.includes(' ') ? value.split(' ')[0] : null; } },
	        { width: 90, id: "delayDay", header: [{ text: "${menu.ZLN0090}" , align: "center" }], align: "center", type:"number",  template: function (text, row, col) {return (text > 0) ? text : "0";}},
	        { hidden:true, width: 120, id: "SRType", header: [{ text: "srType" , align: "center" }], align: "center" },
	        { hidden:true, width: 120, id: "ESType", header: [{ text: "esType" , align: "center" }], align: "center" },
	        { hidden:true, width: 120, id: "SRID", header: [{ text: "srID" , align: "center" }], align: "center" },
	        { hidden:true, width: 120, id: "Status", header: [{ text: "status" , align: "center" }], align: "center" },
	        { hidden:true, width: 120, id: "ReceiptUserID", header: [{ text: "receiptUserID" , align: "center" }], align: "center" },
	    ],
	    
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: true,
	    footer: false
	});


	layout3.getCell("b").attach(excelGrid);
	
</script>

<div id="srListDiv" class="pdL10 pdR10">
<div class="page-title"></div>
<table border="0" cellpadding="0" cellspacing="0" width="100%" class="form-column-4 new-form" id="search">
	<tr>
       	<th class="alignL">${menu.ZLN0211}</th>
       	<td class="alignL">
	       	<div id="comboBox" style="width: 60%; display:inline-block;"></div>
	       	<input type="hidden" id="customerNo" name="customerNo" value="${sessionScope.loginInfo.sessionClientId}" />
       	</td>
       	<!-- 요청일-->
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
       	<th class="alignL">${menu.LN00011}</th>
       	<td class="alignL">
       		<select id="srType" Name="srType" style="width: 60%;display: inline-block;" >
	       		<option value=''></option>
	       	</select>
       	</td>
       	<th class="alignL">${menu.LN00272}</th>
       	<td class="alignL">
       		<select id="category" Name="category" style="width: 60%;display: inline-block;">
	       		<option value=''></option>
	       	</select>
       	</td>
       	<th class="alignL">${menu.LN00273}</th>
       	<td class="alignL">
       		<select id="subCategory" Name="subCategory" style="width: 60%;display: inline-block;">
	       		<option value=''></option>
	       	</select>
       	</td>
    </tr>
    <tr>
    	<!-- 선택된 srType -->
    	<th></th>
    	<td class="alignL">
    		<p id="selectedProcessType"></p>
    		<input type="hidden" name="srTypes" id="srTypes" />
    	</td>
    	<!-- 선택된 Category -->
    	<th></th>
    	<td class="alignL">
    		<p id="selectedCategory"></p>
    		<input type="hidden" name="categories" id="categories" />
    	</td>
    	<!-- 선택된 SubCategory -->
    	<th></th>
    	<td class="alignL">
    		<p id="selectedSubCategory"></p>
    		<input type="hidden" name="subCagtegories" id="subCagtegories" />
    	</td>
    </tr>
</table>

<div class="btn-wrap justify-center pdT10">
	<div class="btns">
		<button id="search-btn" onclick="fnCallSearch();"></button>
		<button id="clear" onclick="fnSearchClear();"></button>
		<button id="excel1" onclick="doExcel()"></button>
	</div>
</div>
	
<ul class="btn-wrap pdT10 pdB10" >
	<li class="count">Total  <span id="TOT_CNT"></span></li>
</ul>

<div style="width:100%; " id="layout"></div>


<div id="detailBox" style="display:none;">
	<div class="title-wrap" style="display: flex; justify-content: space-between; align-items: center; margin-top: 20px; padding-bottom: 10px;">
		<div class="page-title">${menu.LN00108}</div>
		<div class="btns">
			<button id="excel2" onclick="doExcelDetail()"></button>
		</div>
	</div>
	
	<div id="layout2" style="width:100%;height:100%;"></div>
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


