<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>



<script>

var selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&esType=${esType}&myCSR=${myCSR}&myWorkspace=${myWorkspace}";

// == [Document Ready Section] ====================================================================
	
	$(document).ready(function(){
		
		// 초기 표시 화면 크기 조정 
		$("#SRTypeTablelayout").attr("style","height:"+(setWindowHeight() - 160)+"px; width:100%;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 160)+"px; width:100%;");
		};
		
		$("#excel").click(function(){ fnGridExcelDownLoad(); });
		
		// 그리드 헤더 구성 >  그리드 UI 생성 및 attach >  데이터 호출 > 데이터 주입
		loadGrid('','','',true);
		$("input.datePicker").each(generateDatePicker);
		getDicData("BTN", "LN0001").then(data => fnSetButton("search-btn", "search", data.LABEL_NM));
        fnSelect('customerNo', selectData, 'getESPCustomerList', '${customerNo}', 'Select', 'esm_SQL');
	});
		

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	

	async function generateGridUI(srTypeArray, srNameArray) {
		const headerConfig = await getGridHeaderConfig(srTypeArray, srNameArray);
		grid = new dhx.Grid("grid_container", {
			columns: headerConfig,
			autoWidth: true,
			autoHeight: true,
			resizable: true,
			selection: "row",
			tooltip: true,
		});
		SRTypeTablelayout.getCell("a").attach(grid);
	};
	
	async function getGridHeaderConfig(srTypeArray, srNameArray) {
		const overviewGridHeaderConfigTemplate = [
            { width: 150, id: 'ServiceName', align: 'center', header: [{ text: 'SERVICE', align: 'center', rowspan: 2 }] },
            { width: 180, id: 'PartName', align: 'center', header: [{ text: 'PART', align: 'center', rowspan: 2 }] },
            { id: 'Total', header: [{ text: 'All SR Types', align: 'center', colspan: 3 }, { text: 'Total', align: 'center' }], align: 'center', type: 'number' },
            { id: 'Processing', header: [{ text: '', align: 'center' }, { text: '${menu.LN00121}', align: 'center' }], align: 'center', type: 'number' },
            { id: 'Completed', header: [{ text: '', align: 'center' }, { text: '${menu.LN00118}', align: 'center' }], align: 'center', type: 'number' },
		];

		srTypeArray.forEach((srType, index) => {
		    const srName = srNameArray[index];
		    const Total = srType + 'Total'
		    const Processing = srType + 'Processing'
		    const Completed = srType + 'Completed'
		    overviewGridHeaderConfigTemplate.push(
		        { id: Total, header: [{ text: srName, align: 'center', colspan: 3 }, { text: 'Total', align: 'center' }], align: 'center', type: 'number' },
		        { id: Processing, header: [{ text: '', align: 'center' }, { text: '${menu.LN00121}', align: 'center' }], align: 'center', type: 'number' },
		        { id: Completed, header: [{ text: '', align: 'center' }, { text: '${menu.LN00118}', align: 'center' }], align: 'center', type: 'number' }
		    );
		});
		return overviewGridHeaderConfigTemplate;
	}
	
	
</script>

<style>

	.page-container {
		padding: 20px 35px;
	}
	
	.title-text {
		font-size: 16px;
	}

	.date-input-container {
		display: flex;
		align-items: center;
		gap: 10px;
		position:relative;
	}
	
	.filter-container {
		display: flex;
		gap: 25px;
		width: 100%;
	}
	
	.align-end {
		align-items: end;
	}
	
	

</style>
<div class='page-container new-form'>
<div class="mgB16">
	<h1 class='title-text'>
	<%-- <img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp; --%>
	Ticket Overview By Service/Part</h1>
</div>
<div class="filter-container mgB20">
	<div>
		<h3 class="mgB10">Ticket ${menu.LN00013}</h3>
		<div class="date-input-container">
			
				<input type="text" id="regStartDate" name="regStartDate" value="${regStartDate}"
					style="min-width: 120px; text-align: left; padding-left: 5px;"
					class="input_off datePicker stext" size="8" onchange="this.value = makeDateType(this.value);"	maxlength="15" >
			
			~
			
				<input type="text" id="regEndDate" name="regEndDate" value="${regEndDate}"
					style="min-width: 120px; text-align: left; padding-left: 5px;"
					class="input_off datePicker stext" size="8" onchange="this.value = makeDateType(this.value);"	maxlength="15">
			
		</div>
	</div>
	<div>
		<h3 class="mgB10">${menu.ZLN0018}</h3>
			<select id="customerNo" Name="customerNo" style="width: 160px;">
				<option value=''></option>
			</select>
	</div>
	<div class="btn-wrap align-end ">
		<div class="btns">
			<button id="search-btn" class='primary' onclick="handleClickSearchBtn()"></button>
			<button id="see-all-btn" class='secondary' onclick="handleClickSeeAllBtn()">See All</button>
			<button id="excel" title="Excel" class='secondary' onclick="handleClickSeeAllBtn()" style="margin-left: auto;">Download List</button>
		</div>
	</div>
</div>


   
<form name="rptForm" id="rptForm" action="" method="post" >
	<div id="SRTypeTablelayout" class="mgT5 floatL"></div>
</form>
</div>


<script type="text/javascript">
	
//== [Grid Section] ====================================================================
	
	var grid;
	
	var SRTypeTablelayout = new dhx.Layout("SRTypeTablelayout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	
	function loadGrid (REG_STR_DT, REG_END_DT, CUSTOMER_NO, initTF) {
		$('#loading').fadeIn(150);
	    searchInProgress = true;
	    
	    async function fetchGridData(){
	    	try {
	            const validSrTypeObj = await $.ajax({
	                url: "getValidSrTypeCodeName.do",
	                type: "POST",
	                data: {
	                    languageID: "${sessionScope.loginInfo.sessionCurrLangType}",
	                },
	                dataType: "json",
	            });

	            const srTypeArray = validSrTypeObj.srTypeArray;
	            const srNameArray = validSrTypeObj.srNameArray;
	            
	            if (initTF) {
	                generateGridUI(srTypeArray, srNameArray);
	            }
	            
	            // SR Type에 해당하는 티켓 정보 가져오기
	            const response = await $.ajax({
	                url: "getOverviewGridDataBySRArea2.do",
	                type: "POST",
	                data: {
	                    languageID: "${sessionScope.loginInfo.sessionCurrLangType}",
	                    srTypeArray: srTypeArray,
	                    regStartDate: REG_STR_DT,
	                    regEndDate: REG_END_DT,
	                    customerNo: CUSTOMER_NO
	                },
	            });
	            injectGridData(response);
	    	} catch (e) {
	    		console.error(e);
	            getDicData("ERRTP", "LN0003").then(data => alert(data.LABEL_NM));
	    		
	    	}
	    	finally {
	            $('#loading').fadeOut(150);
	            searchInProgress = false;
	    	}
    	}
	    fetchGridData();
	}
		

	    
		

	
	

	// 검색 초기화
	function handleClickSeeAllBtn(){
		$("#regStartDate").val("");
		$("#regEndDate").val("");
		$("#customerNo").val("");

		getAndInjectGridData();
	}
	
	// 검색
	function handleClickSearchBtn(){
		var REG_STR_DT = $("#regStartDate").val();
		var REG_END_DT = $("#regEndDate").val();
        var CUSTOMER_NO = $("#customerNo").val();


		var searchInProgress = false;
		
		$('#loading').fadeIn(150);
	
		if(searchInProgress) {
		       getDicData("ERRTP", "LN0002").then(data => alert(data.LABEL_NM));
		} else {
			searchInProgress = true;
		try {
			loadGrid(REG_STR_DT, REG_END_DT, CUSTOMER_NO);
			}
			
			catch (e) {
				console.log(e);
			} finally {
				$('#loading').fadeOut(150);
				searchInProgress = false;
			}
		}
	}
	
	function injectGridData(gridData){
		grid.data.parse(gridData);
	}


</script>

