<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 1. Include JSP -->
<link rel="STYLESHEET" type="text/css" href="dhtmlxchart.css">
<script>
	var p_gridArea;				//그리드 전역변수
	var p_chart;
	var grid_skin = "dhx_brd";
	
	$(document).ready(function(){
		$("input.datePicker").each(generateDatePicker);
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 100)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 100)+"px;");
		};
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		$("#btnSearch").click(function(){
			doSearchOption();
		})
		
		gridInit();	
		doSearchList();
		
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	

	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridInit(){		
		var d = setGridData();		
		
		p_gridArea = fnNewInitGridMultirowHeader("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		
	}
	
	function setGridData(){
		
		var result = new Object();
		var widths = "";
		var sorting = "";
		var aligns = "";
		var processCspan = "";
		
		var processCnt = "${processCnt}";
		
		for (var i = 0; i < processCnt; i++) {
			widths = widths + ",60";
			sorting = sorting + ",str";
			aligns = aligns + ",center";
			if (i != processCnt - 1) {
				processCspan = processCspan + ",#cspan";
			}
		}
		
		for (var i = 0; i < 8; i++) {
			widths = widths + ",60";
			sorting = sorting + ",str";
			aligns = aligns + ",center";
		}
		
		result.title = "";
		result.key = "";
		result.header = "Date,Region,No. of Visitors,Process" + processCspan + ",E2E,GWTP,${menu.LN00295},${menu.LN00299},${menu.LN00294},${menu.LN00300},${menu.LN00301}";
		result.attachHeader1 = "#rspan,#rspan,#rspan" + "${processRows}" + ",#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan";
		result.cols = "Date|Region|Total" + "${processCols}" + "E2E|GWTP|${menu.LN00295}|${menu.LN00299}|${menu.LN00294}|${menu.LN00300}|${menu.LN00301}";
		result.widths = "80,60" + widths;
		result.sorting = "str,str" + sorting;
		result.aligns = "center,center" + aligns;
		result.data = "";
		return result;
	}
	
	//조회
	function doSearchList(){
		p_gridArea.enableRowspan(true);
		p_gridArea.enableColSpan(true);
		p_gridArea.loadXML("${root}upload/${xmlFilName}.xml");
		
	}
	
	function doSearchOption() {
		var url = "/mdVisitLogRep.do";
		var startDT = $("#STR_DT").val();
		var endDT = $("#END_DT").val();
				
		if(startDT == "" || endDT == "") {
			alert("No search date is entered.");
			return false;
		} 
		if(startDT.replace(/-/gi,"")*1 > endDT.replace(/-/gi,"")*1) {
			alert("Start date is later than end date.");
			return false;
		}
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&startDT="+startDT+"&endDT="+endDT;
		ajaxPage(url, data, "help_content");
	}
	
	// END ::: GRID	
	//===============================================================================
		
		
	//===============================================================================
	// BEGIN ::: EXCEL && PDF
	function doExcel() {		
		p_gridArea.toExcel("${root}excelGenerate");
	}
	function doPdf() {		
		p_gridArea.toPDF("${root}pdfGenerate");
	}	
	// END ::: EXCEL && PDF
	//===============================================================================
		
</script>
		
<form name="rptForm" id="rptForm" action="" method="post" onsubmit="return false;">
	<div class="floatL msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Visit Log Statistics</div>

	<div style="padding-bottom:5px;">
		<div style="text-align:left;width:90%;float:left;">Period

	 		<input type="text" id="STR_DT" name="STR_DT" value="${startDT}"	class="input_off datePicker stext" size="8"
				style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
			
				~
			<input type="text" id="END_DT" name="END_DT" value="${endDT}" class="input_off datePicker stext" size="8"
				style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
			
			<input id="btnSearch" type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" style="cursor:pointer;">
		</div>
	
		<div style="text-align:right;width:10%;display:inline-block;">
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</div>
	</div>
	
	<div id="gridDiv" class="mgB10 mgT5">
		<div id="grdGridArea" style="width:100%;scroll:auto;"></div>
	</div>	
</form>
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>