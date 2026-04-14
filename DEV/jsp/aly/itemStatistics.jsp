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
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		// 검색 버튼 클릭
		$("#search").change(function(){
			var url = "itemStatistics.do";
			var data ="NextFromId=" + $('#search option:selected').val() 
					+ "&LevelName=" + $('#search option:selected').text()
					+ "&languageID=" + $("#languageID").val();
			var target = "subFrame";
			
			ajaxPage(url, data, target);
			
		});
		
		//GRID
		gridInit();	
		doSearchList();
		
	});


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
		  result.title = "${title}";
		  result.key = "analysis_SQL.itemSumList";
		  
		  result.header = "Process hierarcy,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,Activity,#cspan,#cspan,#cspan";
		  result.attachHeader1 = "L1 Name,L2 Name,L2,L3,L4,C4,#cspan,#cspan,#cspan,V4,#cspan,#cspan,#cspan,L5,#cspan,#cspan,#cspan,#cspan";
		  result.attachHeader2 = "#rspan,#rspan,#rspan,#rspan,#rspan,Total,ERP,Legacy,Man,Total,ERP,Legacy,Man,Total,ERP,Legacy,Man";
		  
		  result.cols = "L1Name|L2Name|L2|L3|L4|C4Total|C4ERP|C4Legacy|C4Man|V4Total|V4ERP|V4Legacy|V4Man|L5Total|L5ERP|L5Legacy|L5Man";
		  
		  result.widths = "100,*,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63";
		  result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		  result.aligns = "left,left,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center";
		  result.data = "scStartDt="     + $("#SC_STR_DT").val()
		           + "&scEndDt="      + $("#SC_END_DT").val()
		           + "&language="     + $("#languageID").val();
		  return result;
	}
	//조회
	function doSearchList(){
		p_gridArea.enableRowspan();
		p_gridArea.enableColSpan(true);
		p_gridArea.loadXML("${root}upload/statisticsGrid.xml");
		
		//CHART
		showChart();
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
		
	//===============================================================================
	// BEGIN ::: CHART	
	function setChartConfig() {
		var result = new Object();
		result.view = "BAR";
		result.value = "#value#";
		result.label = "#label#";	
		return result;		
	}
	
	function showChart() {	
		var chartNum = "${ChartList.size()}";
		for (var i = 0; i < chartNum; i++) {
			var chartValue = $('#jsonData' + i).val();
			var config = setChartConfig();
			var container = "chartAreaBAR" + i;
			var data = 'chartValue=' + "'" + chartValue + "'";
			
			p_chart = fnNewInitChart(config, container);
			fnLoadDhtmlxChartJson2(p_chart, container, data);
			
		}
		
		
	}
	
	// END ::: CHART	
	//===============================================================================	
</script>

<!-- BEGIN :: SEARCH -->
	<div class="child_search">
		<li class="mgL10">
			<select name="search" id="search">
				<option value="0" <c:if test="${selectedValue == '0'}">selected</c:if>>All Item</option>
				<c:forEach var="L1Name" items="${L1NameList}" varStatus="status">
					<option value="${L1Name.NextFromId}" <c:if test="${selectedValue == L1Name.NextFromId}">selected</c:if>>${L1Name.LevelName}</option>
				</c:forEach>		
			</select>	
		</li>
		<li class="mgL10">
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</li>
	</div>
<!-- END :: SEARCH -->	
		
<form name="rptForm" id="rptForm" action="" method="post" >
		
		<input type="hidden" id="languageID" name="languageID" value="${languageID}">
		
		<!-- BIGIN :: LIST_GRID -->
		<div id="gridDiv" class="mgB10">
			<div id="grdGridArea" style="height:250px; width:100%"></div>
		</div>
		<!-- END :: LIST_GRID -->				
		<!-- BIGIN :: CHART -->
		<div id="chartDiv" style="width:100%;height:250px;overflow-x:hidden;overflow-y:auto;">
		
		<c:set value="0" var="L1NameNum" />
		<c:forEach var="L1Name" items="${displayChartList}" varStatus="status">
			<b>${L1Name.LevelName}</b>
			<div id="chartAreaBAR${L1NameNum}" style="display:block;width:900px;height:180px;margin:20px;border:1px solid #A4BED4;"></div>
			<c:set var="L1NameNum" value="${L1NameNum+1}"/>
		</c:forEach>
		<c:set value='0' var='jsonDataNum' />
		<c:forEach var="chartList" items="${ChartList}" varStatus="status">
			<input type='hidden' id='jsonData${jsonDataNum}' value='${chartList.jsonData}'></input>
			<c:set var='jsonDataNum' value='${jsonDataNum+1}'/>
		</c:forEach>
		</div>
		
		<!-- END :: CHART -->
</form>