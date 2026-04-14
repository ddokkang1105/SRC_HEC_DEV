<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
	var p_gridArea;				//그리드 전역변수
	var p_chart;
	var grid_skin = "dhx_brd";
        
	$(document).ready(function(){
		$("input.datePicker").each(generateDatePicker);
		$('.searchList').click(function(){	doSearchList();});
		$('.chart').click(function(){doCallChart($(this).val());});	
		$("#excel").click(function(){doExcel();});
		//GRID
		gridInit();	
		doSearchList();
	});


	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridInit(){		
		var d = setGridData();		
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		/*
		p_gridArea.attachEvent("onRowSelect", function(id,ind){
						gridOnRowSelect(id,ind);
		});
		*/
	}
	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "analysis_SQL.itemSumList";
		result.header = "번호,Item,날짜,Total,신규,수정,삭제";
		result.cols = "Name|Date|NumTotal|NumNew|NumChanged|NumDeleted";
		result.widths = "50,*,200,100,100,100,100";
		result.sorting = "str,str,str,int,int,int,int";
		result.aligns = "center,center,center,right,right,right,right";
		result.data = "scStartDt="     + $("#SC_STR_DT").val()
			        + "&scEndDt="     	+ $("#SC_END_DT").val()
			        + "&language="     + parent.fnCallLanguage();
		return result;
	}
	//조회
	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);		
		//CHART
		doCallChart("BAR");
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
	function setChartData(){
		var result = new Object();
		result.key = "analysis_SQL.itemSumList";
		result.data = "scStartDt="     + $("#SC_STR_DT").val()
		        + "&scEndDt="     	+ $("#SC_END_DT").val()
		        + "&language="     + parent.fnCallLanguage();
		result.cols = "label|value";		
		return result;
	}
	function setChartConfig(avg){
		var result = new Object();
		result.view = avg;
		result.value = "#value#";
		result.label = "#label#";	
		return result;		
	}
	//Call Chart
	function doCallChart(avg){	
		var containerNm = "chartArea"+avg;
		$(".chartArea").hide(); //Hide the chart
		$('#'+containerNm).attr("style", "display:block;height:180px;margin:20px;border:1px solid #A4BED4;");

		var d = setChartData();
		var config = setChartConfig(avg);
		p_chart = fnNewInitChart(config, containerNm);
		
		fnLoadDhtmlxChartJson(p_chart, containerNm, d.key, d.cols, d.data, false);
	}	
	// END ::: CHART	
	//===============================================================================	
</script>
<form name="rptForm" id="rptForm" action="" method="post" >
		<!-- BEGIN :: SEARCH -->
		<div class="child_search">
			<li>
				<font color="#fe7f14"></font>&nbsp;${menu.LN00013}
				<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
				<fmt:formatDate value="<%=xbolt.cmm.framework.util.DateUtil.getDateAdd(new java.util.Date(),2,-6 )%>" pattern="yyyy-MM-dd" var="beforeYmd"/>
				 <input type="text" id="SC_STR_DT" name="SC_STR_DT" value="${beforeYmd}"	class="input_off datePicker" size="8"
						style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
				~
				 <input type="text" id=SC_END_DT	name="SC_END_DT" value="${thisYmd}"	class="input_off datePicker" size="8"
						style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
				<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" value="검색" />
				&nbsp;&nbsp;
				<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
				&nbsp;&nbsp;
				<input type="image" class="image chart" src="${root}${HTML_IMG_DIR}/icon_bar.png" value="BAR" />
				<input type="image" class="image chart" src="${root}${HTML_IMG_DIR}/icon_pie.png" value="PIE" />
				<!-- input type="image" class="image chart" src="${root}${HTML_IMG_DIR}/icon_chart.png" value="" / -->
			</li>
		</div>
		<!-- END :: SEARCH -->		
		<!-- BIGIN :: LIST_GRID -->
		<div id="gridDiv" class="mgB10">
			<div id="grdGridArea" style="height:200px; width:100%"></div>
		</div>
		<!-- END :: LIST_GRID -->				
		<!-- BIGIN :: CHART -->
		<div id="chartAreaBAR" class="chartArea" style="width:100%;display:block;frameborder:0;"></div>
		<div id="chartAreaPIE" class="chartArea" style="width:100%;dispaly:none;frameborder:0;"></div>
		<!-- END :: CHART -->
</form>