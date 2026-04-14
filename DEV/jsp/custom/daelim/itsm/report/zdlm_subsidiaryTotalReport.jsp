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
		
		fnSetButton("search-btn", "search", "Search");
		fnSetButton("excel", "", "Excel", "secondary");
		
		$("input.datePicker").each(generateDatePicker);
		// 날짜 셋팅
		setDefaultDate();
		
		//fnSearch();
		
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	// 기본 조회날짜 셋팅
	function setDefaultDate(){
		var dateObject = setDefaultLocalDate(7);
		var sDate = dateObject["startDate"];
		var tDate = dateObject["endDate"];
		
		$("#startDate").val(sDate);
		$("#endDate").val(tDate);
	}
	
	
	// 엑셀 다운로드
	function doExcel() {
		const now = new Date();
		const formattedDateTime = now.getFullYear() 
		                        + String(now.getMonth() + 1).padStart(2, '0') 
		                        + String(now.getDate()).padStart(2, '0') 
		                        + String(now.getHours()).padStart(2, '0') 
		                        + String(now.getMinutes()).padStart(2, '0');
		
		const fileName = "subsidiary_" + formattedDateTime;
		fnGridExcelDownLoad(grid, "Y", fileName);
	}
	
	
</script>

<style>
	.difi {
		border:1px solid #ddd;
		background : #fff;
		padding: 20px 30px;
		margin-bottom:20px;
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
	<div class="page-title">관계사별 접수건 집계</div>
	
	<!-- BEGIN :: SEARCH -->
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="form-column-4 new-form" id="search">
		<tr>
	       	
	       	<c:set var="now" value="<%=new java.util.Date()%>" />
			<fmt:formatDate value="${now}" pattern="yyyy" var="nowYear"/>
			<fmt:formatDate value="${now}" pattern="MM"	var="nowMonth"/>
			
			<th class="alignL">등록일자</th>
			<td>     
				<input type="text" id="startDate" name="startDate" value=""	class="input_off datePicker stext" size="8"
					onchange="this.value = makeDateType(this.value);"	maxlength="15" >
				
				-
				<input type="text" id="endDate" name="endDate" value=""	class="input_off datePicker stext" size="8"
					onchange="this.value = makeDateType(this.value);"	maxlength="15">
				
			</td>
		</tr>
	</table>
	
	<div class="btn-wrap justify-center pdT10">
		<div class="btns">
			<button id="search-btn" onclick="fnSearch();"></button>
			<button id="excel" onclick="doExcel()"></button>
		</div>
	</div>
	
	<ul class="btn-wrap pdT20 pdB10" >
		<li class="count">Total  <span id="TOT_CNT"></span></li>
	</ul>
			
	<div style="width:100%; height:502px;" id="layout"></div>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	
	
	
	<div class="page-title mgT30">용어정의</div>
	<div>
		<ul class="difi">
		 	<li>
		 		<span>* 총등록건수</span>
		 		<b>:</b> 1차,2차 접수,2선에서 직접 접수한 변경,장애,문제 포함
		 	</li>
		 	
		 	<li>
		 		<span>* 1차 접수 건</span>
		 		<b>:</b> 상담원이 전화, 메일, OC로 문의를 받아 이클릭에 입력한 티켓 + 현업이 이클릭 시스템에 입력하여 요청한 티켓
		 	</li>
		 	
		 	<li>
		 		<span>* 1차 해결 건</span>
		 		<b>:</b> 1차 접수건 중 상담원이 해결하여 완료한 티켓
		 	</li>
		 	
		 	<li>
		 		<span>* 현업 등록건</span>
		 		<b>:</b> 현업 고객이 이클릭을 통해 등록한 건
		 	</li>
		 	
		 	<li>
		 		<span>* 1차 접수율 (%)</span>
		 		<b>:</b> 1차 접수건의 합/ 총 등록건 수
		 	</li>
		 	
		 	<li>
		 		<span>* 1차 해결율 (%)</span>
		 		<b>:</b> 1차 해결 건의 합  /1차 접수된 티켓의 합
		 	</li>
		 	<li>
		 		<span>* 2차 접수 건</span>
		 		<b>:</b> 2선으로 직접 접수된 서비스요청 + 변경, 장애,문제 등록건 (요청에서 생성된 변경 및 장애,문제 포함)
		 	</li>
		 	<li>
		 		<span>* 2차 접수율 (%)</span>
		 		<b>:</b> 2차 접수건 /총등록건수
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
	        { width: 180, id: "CORPNAME", header: [{ text: "관계사", align: "center" }], align: "center" , footer: [ { text: 'TOTAL', align: "center"  },] },
	        { width: 100, id: "TOTCNT", header: [{ text: "총등록건수", align: "center" }], format: "#", type: "number", align: "center" , footer: [{ content: "sum", align: "center" }] },
	        { width: 100, id: "FIRSTCNT", header: [{ text: "1차 접수건", align: "center" }],format: "#", type: "number", align: "center" , footer: [{ content: "sum", align: "center" }] },
	        { width:100, id: "FIRSTCOMPCNT", header: [{ text: "1차 해결건", align: "center" }],format: "#", type: "number", align: "center", footer: [{ content: "sum", align: "center" }]},
	        { width:100, id: "WKRREGCNT", header: [{ text: "현업등록건", align: "center" }],format: "#", type: "number", align: "center" , footer: [{ content: "sum", align: "center" }] },
	        { width:100, id: "FIRSTRCPTRATE", header: [{ text: "1차 접수율(%)", align: "center" }],format: "#.00", type: "number", align: "center", footer: [{ content: "sum", align: "center" }]},
	        { width: 100, id: "FIRSTCOMPRATE", header: [{ text: "1차 해결율(%)", align: "center" }],format: "#.00", type: "number", align: "center" , footer: [{ content: "sum", align: "center" }] },
	        { width: 100, id: "SECONDCNT", header: [{ text: "2차 접수건", align: "center" }],format: "#", type: "number", align: "center" , footer: [{ content: "sum", align: "center" }] },
	        { width: 100, id: "SECONDRCPTRATE", header: [{ text: "2차 접수율(%)", align: "center" }],format: "#.00", type: "number", align: "center" , footer: [{ content: "sum", align: "center" }]},
	    ],
	    
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: false
	  
	});


	layout.getCell("a").attach(grid);
	
	function fnSearch(){ 		
		var startDate= $("#startDate").val(); 
		var endDate= $("#endDate").val(); 
		
		if (!startDate || !endDate) {
		    alert("조회기간을 모두 입력해주세요.");
		    return false;
		}
		if (!checkDateYear(startDate, endDate, 365,"12개월")){
			return false;
		}
		
		var sqlID = "zDLM_SQL.getSubsidiaryTotal";
		var param = "sqlID="+sqlID+"&startDate="+startDate+"&endDate="+endDate + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&myCSR=Y&userID=${sessionScope.loginInfo.sessionUserId}";
		
		if(inProgress) {
			alert("목록을 불러오고 있습니다.");
		} else {
			inProgress = true;
			$('#loading').fadeIn(150);
			$.ajax({
				url:"jsonDhtmlxListV7.do",
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

