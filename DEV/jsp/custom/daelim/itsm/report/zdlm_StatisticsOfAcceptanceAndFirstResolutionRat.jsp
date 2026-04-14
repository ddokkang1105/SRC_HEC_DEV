<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<%-- <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%> --%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
	var inProgress = false;
	
	$(document).ready(function(){
		
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:300px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:300px;");
		};
		
		fnSetButton("search-btn", "search", "Search");
		fnSetButton("excel", "", "Excel", "secondary");
		
		// 관계사
		var selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&esType=${esType}&myCSR=Y&notCompanyIDs=${notCompanyIDs}";
		//fnSelect('customerNo', selectData, 'getESPCustomerList', '${sessionScope.loginInfo.sessionClientId}', 'Select', 'esm_SQL');
		fnSelect('customerNo', selectData, 'getESPCustomerList', '${sessionScope.loginInfo.sessionClientId}', 'Select', 'esm_SQL');
		$("input.datePicker").each(generateDatePicker);
		
		// 날짜 셋팅
		setYearMonth();
		
		//fnSearch();
		
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	// 기본 조회날짜 셋팅
	function setYearMonth(){
		var date = new Date();
		var year = date.getFullYear()+1;
		var cYear = date.getFullYear();
		var cMonth = date.getMonth()+1;
		
		if(cMonth <10){
			cMonth = "0"+cMonth;
		}
		
		var yHtml = "";
		var mHtml = "";
		
		for(var i=0; i<10; i++ ){
			year = year-1;
			
			if(year==cYear){
				yHtml += "<option value='"+year+"' selected='selected'>"+year+" 년</option>";
			}
		}
		
		var month="";
		for(var i=0; i<12; i++ ){
			month = i+1;
			if(month<10){
				month = "0"+month;
			}
			
			if(month==cMonth){
				mHtml += "<option value='"+month+"' selected='selected'>"+month+" 월</option>";
			}else{
				mHtml += "<option value='"+month+"'>"+month+" 월 </option>";
			}
		}
		$("#searchYear").append(yHtml);
		$("#searchMonth").append(mHtml);
	}
	
	// 엑셀 다운로드
	function doExcel() {
		const now = new Date();
		const formattedDateTime = now.getFullYear() 
		                        + String(now.getMonth() + 1).padStart(2, '0') 
		                        + String(now.getDate()).padStart(2, '0') 
		                        + String(now.getHours()).padStart(2, '0') 
		                        + String(now.getMinutes()).padStart(2, '0');
		
		const fileName = "StatIncidentOpstacle_" + formattedDateTime;
		fnGridExcelDownLoad(grid, "", fileName);
	}
	
	
</script>

<style>
	.difi {
		border:1px solid #ddd;
		background : #fff;
		padding: 15px 15px;
		margin-bottom:15px;
	}
	
	.difi li {
		display: block;
		margin: 15px 0;
	}
	
	.difi li span {
		display:inline-block;
		width:150px;
	}
</style>

<div style="display:none;" id="excelGrid"></div>

<div id="srListDiv" class="pdL10 pdR10">
	<div class="page-title">관계사별 접수 및 1차 해결률 통계</div>
	
	<!-- BEGIN :: SEARCH -->
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="form-column-4 new-form" id="search">
		<tr>
	       	
	       	<th class="alignL">관계사</th>
	       	<td class="alignL">
	       		<select id="customerNo" Name="customerNo" style="width: 60%;display: inline-block;">
		       		<option value=''></option>
		       	</select>
	       	</td>
			
			<th class="alignL">조회년월</th>
			<td>     
				<select id="searchYear" style="width:100px;"></select>
				<select id="searchMonth" style="width:100px;"></select>
			</td>
		</tr>
	</table>
	
	<div class="btn-wrap justify-center pdT10">
		<div class="btns">
			<button id="search-btn" onclick="fnSearch();"></button>
			<button id="excel" onclick="doExcel()"></button>
		</div>
	</div>
	
	<ul class="btn-wrap pdT10 pdB10" >
		<li class="count">Total  <span id="TOT_CNT"></span></li>
	</ul>
			
	<div style="width:100%;" id="layout"></div>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	
	<div class="mgT10">
		<ul class="difi">
		 	<li>
		 		<span>* Call 접수</span>
		 		<b>:</b> 상담원이 전화, 메일, OC로 문의를 받아 이클릭에 입력한 티켓 (변경 및 장애 티켓이 하위로 생성된 티켓 제외)
		 	</li>
		 	
		 	<li>
		 		<span>* eClick 접수</span>
		 		<b>:</b> 현업이 이클릭 시스템에 입력하여 요청한 티켓 (변경 및 장애 티켓이 하위로 생성된 티켓 제외)
		 	</li>
		 	
		 	<li>
		 		<span>* 1차해결건</span>
		 		<b>:</b> 1차 접수건 중 상담원이 해결하여 완료한 티켓
		 	</li>
		 	
		 	<li>
		 		<span>* 1차 해결률 </span>
		 		<b>:</b> 1차 해결 건의 합 / 1차 접수된 티켓의 합
		 	</li>
		 	
		 	<li>
		 		<span>* 상담인원</span>
		 		<b>:</b> 해당 월의 1차 처리 인원
		 	</li>
		 	<li>
		 		<span>* 인당 처리 건수 </span>
		 		<b>:</b> 개인별 한달 처리건수의 평균 접수건 기준
		 	</li>
		 	<li>
		 		<span>* 인당 일일 처리 건수</span>
		 		<b>:</b> 해당월의 일일 처리건수 평균 (워킹데이,접수건 기준) 
		 	</li>
		</ul>
	</div>

</div>
<script type="text/javascript">
	
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid = new dhx.Grid("grdOTGridArea", {
	    columns: [
			{ width: 180, id: "conDate", header: [{ text: "구분", align: "center" }], align: "center" },
	        { width: 200, id: "callCnt", header: [{ text: "Call 접수", align: "center" }], align: "center" },
	        { width: 200, id: "eClickCnt", header: [{ text: "eClick 접수", align: "center" }], align: "center"},
	        { width: 200, id: "firstCompRate", header: [{ text: "1차 해결률(%)", align: "center" }], format: "#.00", align: "center" ,  },
	        { width: 200, id: "userCnt", header: [{ text: "상담인원", align: "center" }], align: "center" ,  },
	        { width: 200, id: "callPerUser", header: [{ text: "인당 처리 건수", align: "center" }], align: "center", },
	        { width: 200, id: "dayCnt", header: [{ text: "인당 일일 처리 건수", align: "center" }], align: "center"},
	        
	    ],
	    
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: false
	  
	});


	layout.getCell("a").attach(grid);
	
	function fnSearch(){ 	
		
		var today = new Date();	
        today.setMonth( $("#searchMonth option:selected").val());
		today.setMonth(today.getMonth()-6);
		
		var sYear = today.getFullYear();
		var sMonth = (today.getMonth()+1);	//선택월 기준 6개월 min
		
		var formattedMonth = sMonth.toString().padStart(2, '0');
		var startDate = sYear+"-"+formattedMonth;
		var endDate = $("#searchYear option:selected").val() + "-" + $("#searchMonth option:selected").val();
		
		var sqlID = "zDLM_SQL.getStatisticsOfAcceptanceAndFirstResolutionRat";
		var param = "sqlID="+sqlID+"&periodType=forMonth&startDate="+startDate+"&endDate="+endDate
					+"&customerNo="+$("#customerNo").val() 
					+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&userID=${sessionScope.loginInfo.sessionUserId}"
					+"&myCSR=Y";
		
		console.log(param);
		
		if(inProgress) {
			alert("목록을 불러오고 있습니다.");
		} else {
			inProgress = true;
			$('#loading').fadeIn(150);
			$.ajax({
				url:"zdlm_jsonDhtmlxListV7.do",
				type:"POST",
				data:param,
				success: function(result){
					fnReloadGrid(result);				
				},error:function(xhr,status,error){
					$('#loading').fadeOut(150);
					console.log("ERR :["+xhr.status+"]"+error);
				}
			});	
		}
	}
	
	function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
		$("#TOT_CNT").html(grid.data.getLength());
		inProgress = false;
		$('#loading').fadeOut(150);
	}
	

</script>

