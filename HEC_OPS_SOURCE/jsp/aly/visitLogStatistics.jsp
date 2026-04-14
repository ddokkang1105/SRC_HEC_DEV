<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<link rel="STYLESHEET" type="text/css" href="dhtmlxchart.css">
<script src="dhtmlxchart.js" type="text/javascript"></script>

<script>
	var p_gridArea;				//그리드 전역변수
	var p_chart;
	var grid_skin = "dhx_brd";
	
	$(document).ready(function(){
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
		var programCspan = "";
		
		var processCnt = "${processCnt}";
		var programCnt = "${programCnt}";
		
		for (var i = 0; i < processCnt; i++) {
			widths = widths + ",60";
			sorting = sorting + ",str";
			aligns = aligns + ",center";
			if (i != processCnt - 1) {
				processCspan = processCspan + ",#cspan";
			}
		}
		
		for (var i = 0; i < programCnt; i++) {
			widths = widths + ",60";
			sorting = sorting + ",str";
			aligns = aligns + ",center";
			if (i != programCnt - 1) {
				programCspan = programCspan + ",#cspan";
			}
		}
		
		result.title = "";
		result.key = "";
		/* result.header = "Date,접속자 수,Process" + processCspan + ",Program" + programCspan;
		result.attachHeader1 = "#rspan,#rspan" + "${processRows}" + "${programRows}";
		result.cols = "Date|Total" + "${processCols}" + "${programCols}"; */
		
		result.header = "Date,접속자 수,Process" + processCspan;
		result.attachHeader1 = "#rspan,#rspan" + "${processRows}";
		result.cols = "Date|Total" + "${processCols}";
		result.widths = "100,100" + widths;
		result.sorting = "str,str" + sorting;
		result.aligns = "center,center" + aligns;
		result.data = "";
		return result;
	}
	
	//조회
	function doSearchList(){
		p_gridArea.enableRowspan();
		p_gridArea.enableColSpan(true);
		p_gridArea.loadXML("${root}upload/visitLogStatisticsGrid.xml");
		
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
		
<form name="rptForm" id="rptForm" action="" method="post" >
	<div class="floatL msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Visit Log Statistics</div>
	<div class="alignBTN">
		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
	</div>
		
	<div id="gridDiv" class="mgB10 mgT5">
		<div id="grdGridArea" style="width:100%"></div>
	</div>	
</form>