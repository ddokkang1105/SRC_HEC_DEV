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
	let customerNo = '${sessionScope.loginInfo.sessionClientId}';
	
	$(document).ready(function(){
		
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:400px;");
		
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 480)+"px;");
		};
		
		// 버튼 셋팅
		fnSetButton("search-btn", "search", "Search");
		getDicData("BTN", "LN0003").then(data => fnSetButton("clear", "clear", data.LABEL_NM,"secondary"));
		fnSetButton("excel", "", "Excel", "secondary");
		
		// 관계사 셋팅
		setCompany();
		
		// 기간 설정 ( default : 전주 )
		$("input.datePicker").each(generateDatePicker);
		settingPeriod('LastWeek');
	
	});
	
	// 관계사 setting
	function setCompany(){
		// if (regionManager === "Y") selectData += "&myWorkspace=Y";
		selectData += "&sqlID=esm_SQL.getESPCustomerListByLvl&sqlGridList=N&custLvl=G";
		
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
			
			// service part 다중 선택
			var customerNo = "${sessionScope.loginInfo.sessionClientId}";
			var clientIDs = [customerNo];
			if(customerNo === "0000000040") clientIDs.push("0000000073"); // BSL VN
			if(customerNo === "0000000064") clientIDs.push("0000000072"); // TVL KEPZ
			if(customerNo === "0000000030") clientIDs.push("0000000073"); // YBL VN
			if(customerNo === "0000000067") clientIDs.push("0000000073"); // YHL VN
			if(customerNo === "0000000029") clientIDs.push("0000000073"); // YNL VN
			
			clientIDs = JSON.stringify(clientIDs).replace(/"/g, "'").replace(/^\[|\]$/g, '');
			
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

	 // 삭제 버튼 클릭 (delegated) - itemID 숫자 전용
	    $(document).on("click", "#" + containerId + " .removeItem", function() {
	        const $span = $(this).closest("span");
	        const val = `'` + $span.data("val") + `'`;
	        
	     	// hidden 값 기준으로 배열 재생성
	        let currentValues = $("#" + hiddenId).val();
	        let accumulated = currentValues ? currentValues.split(",").map(v => v.trim()).filter(v => v !== "") : [];

	     	// 제거
	        accumulated = accumulated.filter(v => v !== String(val));

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
	
	// title 셋팅
	getArcName("${arcCode}", ".page-title");
	
	// 화면 크기 조정
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
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
			{ width:250, id: "CustGRName", header: [{ text: "${menu.ZLN0078}",align: "center" }], align: "center" },
			{ width:250, id: "CustomerName", header: [{ text: "${menu.LN00014}",align: "center" }], align: "center" },
	        { id: "TicketCount", header: [{ text: "${menu.ZLN0219}",align: "center" }], type:"number", align: "center" },
	        { id: "TotalCompleted", header: [{ text: "${menu.ZLN0220}",align: "center" }], type:"number", align: "center" },
	        { hidden:true, width: 120, id: "ClientID", header: [{ text: "clientID" , align: "center" }], align: "center" },
	    ],
	    
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: true,
	    footer: false,
	    spans: [],
	  
	});


	layout.getCell("a").attach(grid);
	
	// 통계 검색
	function fnCallSearch(){
		fnSearch();
		var initJson ="[{}]";
	}
	
	// 통계 검색
	function fnSearch(){ 		
		var REG_STR_DT = $("#regStartDate").val();
		var REG_END_DT = $("#regEndDate").val();
		
		if (!REG_STR_DT || !REG_END_DT) {
			getDicData("ERRTP", "LN0001").then(data => alert(data.LABEL_NM));
		    return false;
		}

		var sqlID = "esmReport_SQL.getCustomerPerformReportList";
		var param = "sqlID="+sqlID
					+"&type=srArea"
					+ "&regStartDate=" + REG_STR_DT
					+ "&regEndDate=" + REG_END_DT
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&userID=${sessionScope.loginInfo.sessionUserId}";
		
		var clientIDs = getClientIds();
		if(clientIDs === "" || clientIDs === null || clientIDs === undefined){
			const allCodes = dataset.map(item => "'" + item.code + "'");
			param += "&custGRNos="+allCodes.join(',');
		} else {
			param += "&custGRNos="+clientIDs;
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
		mergeCustGRNameCells();
		$("#TOT_CNT").html(grid.data.getLength());
	}
	
	function mergeCustGRNameCells() {
	    var items = grid.data.serialize(); 
	    var spans = [];

	    var prevGroup  = null;
	    var startIndex = 0;
	    var rowSpan    = 0;

	    for (var i = 0; i < items.length; i++) {
	        var row      = items[i];
	        var curGroup = row.CustGRName; 

	        if (prevGroup === null) {
	            // 첫 행
	            prevGroup  = curGroup;
	            startIndex = i;
	            rowSpan    = 1;
	        } else if (curGroup === prevGroup) {
	            // 같은 그룹 계속
	            rowSpan++;
	        } else {
	            // 그룹이 바뀜 → 직전 그룹 span 등록
	            if (rowSpan > 1) {
	                spans.push({
	                    row: items[startIndex].id,  // 이 구간 첫 행의 id
	                    column: "CustGRName",
	                    rowspan: rowSpan,
	                    colspan: 1
	                });
	            }
	            // 새 그룹 시작
	            prevGroup  = curGroup;
	            startIndex = i;
	            rowSpan    = 1;
	        }
	    }

	    // 마지막 그룹 처리
	    if (rowSpan > 1) {
	        spans.push({
	            row: items[startIndex].id,
	            column: "CustGRName",
	            rowspan: rowSpan,
	            colspan: 1
	        });
	    }
	    // 기존 span 초기화 후 새로 적용
	    grid.config.spans = spans;
	    grid.paint();     // 다시 그리기
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
	}
	
	// excel grid
	
	
	function fnReloadExcelGrid(newGridData){
		excelGrid.data.parse(newGridData);
	}
	
	/* var excelGrid = new dhx.Grid("excelGrid", {
	    columns: [	        
	        
	    	{ width:250, id: "CustGRName", header: [{ text: "${menu.ZLN0078}",align: "center" }], align: "center" },
			{ width:250, id: "CustomerName", header: [{ text: "${menu.LN00014}",align: "center" }], align: "center" },
	        { id: "TicketCount", header: [{ text: "${menu.ZLN0219}",align: "center" }], type:"number", align: "center" },
	        { id: "TotalCompleted", header: [{ text: "${menu.ZLN0220}",align: "center" }], type:"number", align: "center" }
	    ],
	    
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: true,
	    footer: false
	}); */
	
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
</table>

<div class="btn-wrap justify-center pdT10">
	<div class="btns">
		<button id="search-btn" onclick="fnCallSearch();"></button>
		<button id="clear" onclick="fnSearchClear();"></button>
		<button id="excel" onclick="fnGridExcelDownLoad()"></button>
	</div>
</div>
	
<ul class="btn-wrap pdT10 pdB10" >
	<li class="count">Total  <span id="TOT_CNT"></span></li>
</ul>

<div style="width:100%; " id="layout"></div>

<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>


