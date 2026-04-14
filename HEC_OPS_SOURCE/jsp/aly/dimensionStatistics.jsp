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
			var url = "dimensionStatistics.do";
			var data ="NextFromId=" + $('#search option:selected').val() 
					+ "&LevelName=" + $('#search option:selected').text();
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
		
		var dimTypeNum = "${dimTypeList.size()}";
		var header = "";
		var attachHeader1 = "";
		var attachHeader2 = "";
		var cols = "";
		var widths = "";
		var sorting = "";
		var aligns = "";
		var dimTypeName = "";
		
		for (var i = 0; i < dimTypeNum; i++) {
			if (i == 0) {
				header = "DimType," + $('#dimTypeName' + i).val() + ",#cspan";
				attachHeader1 = "#rspan," + $('#dimValueName' + i).val() + "(" + $('#dimValueID' + i).val() + ")" + ",#cspan";
				attachHeader2 = "Process,Count,Ratio";
				cols = "Process|Count" + i + "|Ratio"  + i ;
				widths = "100,60,60";
				sorting = "str,str,str"
				aligns = "left,center,center";
				dimTypeName = $('#dimTypeName' + i).val();
			} else {
				if (dimTypeName == $('#dimTypeName' + i).val()) {
					header = header + ",#cspan,#cspan";
					
				} else {
					dimTypeName = $('#dimTypeName' + i).val();
					header = header + "," + dimTypeName + ",#cspan";
					
				}
				attachHeader1 = attachHeader1 + "," + $('#dimValueName' + i).val() + "(" + $('#dimValueID' + i).val() + ")" + ",#cspan";
				attachHeader2 = attachHeader2 + ",Count,Ratio";
				cols = cols + "|Count" + i + "|Ratio"  + i ;
				widths = widths + ",60,60";
				sorting = sorting + ",str,str";
				aligns = aligns + ",center,center";
			}
		}
		
		result.title = "${title}";
		result.header = header;
		result.attachHeader1 = attachHeader1;
		result.attachHeader2 = attachHeader2;
		result.cols = cols;
		result.widths = widths;
		result.sorting = sorting;
		result.aligns = aligns;
		
		return result;
	}
	//조회
	function doSearchList(){
		// Chart
		showChart();
		
		p_gridArea.enableRowspan();
		p_gridArea.enableColSpan(true);
		p_gridArea.loadXML("${root}upload/dimensionStatisticsGrid.xml");
		
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
	function setChartConfig(dimValueName) {
		var result = new Object();
		result.view = "BAR2";
		result.value = "#value0#";
		result.label = "#label#";
		result.text = dimValueName;
		return result;		
	}
	
	function showChart() {	
		var chartNum = "${ChartList.size()}";
		for (var i = 0; i < chartNum; i++) {
			var chartValue = $('#jsonData' + i).val();
			var dimValueName = $('#dimValueNameDp' + i).val();
			var config = setChartConfig(dimValueName);
			var container = "chartAreaBAR" + i;
			var data = 'chartValue=' + "'" + chartValue + "'";
			p_chart = fnNewInitChart(config, container);
			var textArray = config.text.split(",");
			var colorArray = [ "#58dccd","#a7ee70", "#36abee", "#58dccd","#a7ee70", "#36abee"];
			for (var j = 1; j < textArray.length; j++) {
				p_chart.addSeries({
					value:"#value"+ j +"#", color:colorArray[j], label:"#value"+ j +"#"
				});
			}
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
				<option value="0" selected>Dimension Process</option>	
			</select>	
		</li>
		<li class="mgL10">
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</li>
</div>

<!-- END :: SEARCH -->	
	
<form name="rptForm" id="rptForm" action="" method="post" >
		
		<!-- BIGIN :: LIST_GRID -->
		<c:set value='0' var='dimTypeNum' />
		<c:forEach var="dimTypeList" items="${dimTypeList}" varStatus="status">
			<input type='hidden' id='dimTypeName${dimTypeNum}' value='${dimTypeList.DimTypeName}'></input>
			<input type='hidden' id='dimValueName${dimTypeNum}' value='${dimTypeList.DimValueName}'></input>
			<input type='hidden' id='dimValueID${dimTypeNum}' value='${dimTypeList.DimValueID}'></input>
			
			<c:set var='dimTypeNum' value='${dimTypeNum+1}'/>
		</c:forEach>
		
		<div id="gridDiv" class="mgB10">
			<div id="grdGridArea" style="height:250px; width:100%"></div>
		</div>
		<!-- END :: LIST_GRID -->				
		<!-- BIGIN :: CHART -->
		<div id="chartDiv" style="width:100%;height:250px;overflow-x:hidden;overflow-y:auto;">
			<c:set value="0" var="dimValueNum" />
			<c:forEach var="dimtype" items="${displayChartList}" varStatus="status">
				<b>${dimtype.dimTypeName}</b>
				<div id="chartAreaBAR${dimValueNum}" style="display:block;width:85%;height:180px;margin:20px;border:1px solid #A4BED4;"></div>
				<input type='hidden' id='dimValueNameDp${dimValueNum}' value='${dimtype.dimValueName}'></input>
			<c:set var="dimValueNum" value="${dimValueNum+1}"/>
			</c:forEach>
			
			<c:set value='0' var='jsonDataNum' />
			<c:forEach var="chartList" items="${ChartList}" varStatus="status">
				<input type='hidden' id='jsonData${jsonDataNum}' value='${chartList.jsonData}'></input>
			<c:set var='jsonDataNum' value='${jsonDataNum+1}'/>
			</c:forEach>
		</div>
		
		
		</div>
		
		<!-- END :: CHART -->
</form>