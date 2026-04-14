<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
	
	$(document).ready(function(){
		fnSetButton("excel", "", "Excel", "secondary");
		
		fnSearch();
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function doExcel() {
		const now = new Date();
		const formattedDateTime = now.getFullYear() 
		                        + String(now.getMonth() + 1).padStart(2, '0') 
		                        + String(now.getDate()).padStart(2, '0') 
		                        + String(now.getHours()).padStart(2, '0') 
		                        + String(now.getMinutes()).padStart(2, '0');
		
		const fileName = "IndividualMHWorkList_" + formattedDateTime;
		fnGridExcelDownLoad(grid, "Y", fileName);
	}
	
	
</script>

<div id="srListDiv" class="pdL10 pdR10" >
	<div class="page-title pdL10">티켓/상태별 작업시간 상세 조회 </div>
	<ul class="btn-wrap pdB10 pdL10" >
		<li class="count">Total  <span id="TOT_CNT"></span> <span class="pdL20">처리자 : ${memberName}</span></li>
		<li class="floatR">
			<div class="btn-wrap justify-right pdT10">
			<div class="btns">
				<button id="excel" onclick="doExcel()"></button>
			</div>
		</div>
		
		</li>
	</ul>
	<div class="pdL10 pdR10" style="width:99%; height:430px;" id="grid"></div>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>
<script type="text/javascript">
	
	var grid = new dhx.Grid("grid", {
	    columns: [
	    	{ width: 50, id: "RowNum", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center"},
	    	{ width: 120, id: "TBL_NM", header: [{ text: "프로세스" , align: "center" }], align: "center" },
	        { width: 150, id: "ID", header: [{ text: "${menu.LN00396}" , align: "center" }], align: "center" },
	        { width: 314, id: "TITLE", header: [{ text: "${menu.LN00002}" , align: "center" }], align: "left" },
	        { hidden:true, width: 314, id: "Description", header: [{ text: "내용" , align: "center" }], align: "left" },
	        { width: 150, id: "PROCESS_STEP_NM", header: [{ text: "프로세스 단계" , align: "center" }], align: "center" },     
	        { width: 120, id: "WORK_DATE", header: [{ text: "처리일자" , align: "center" }], align: "center" },
	        { width: 150, id: "WORK_TIME_MM", header: [{ text: "처리시간(시간내+시간외)" , align: "center" }],format: "#.00", align: "center" },
	    ],
	    
	    autoWidth: true,
	   // autoHeight: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: false
	  
	});

	function fnSearch(){ 
		$('#loading').fadeIn(150);
		var selectType = $("#selectType").val();
		
		var sqlID = "zDLM_SQL.selectIndividualMHWorkList"; // viewIndividualMHWorkList
		var customerNo = "${customerNo}";
		var startDate= "${startDate}"; 
		var endDate= "${endDate}"; 
		var memberID = "${memberID}";
		
		var param = "sqlID="+sqlID+"&startDate="+startDate+"&endDate="+endDate+"&customerNo="+customerNo+"&memberID="+memberID
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&myCSR=Y&userID="+memberID
					+ "&srArea2=${srArea2}";
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
	
	function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
		$("#TOT_CNT").html(grid.data.getLength());
		$('#loading').fadeOut(150);
		
	}
	
	

</script>

