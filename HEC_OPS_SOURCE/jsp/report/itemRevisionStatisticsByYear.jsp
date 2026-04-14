<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00017" var="WM00017" />
<!-- 1. Include JSP -->
<link rel="STYLESHEET" type="text/css" href="dhtmlxchart.css">

<script>
	var p_gridArea;				//그리드 전역변수
	var p_chart;
	var grid_skin = "dhx_brd";
	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";	
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
		var quarterCspan = "";
		var programCspan = "";
		
		var quarterCnt = "${quarterCnt}";
		var programCnt = "${programCnt}";
		
		for (var i = 0; i < quarterCnt; i++) {
			widths = widths + ",60";
			sorting = sorting + ",str";
			aligns = aligns + ",center";
			if (i != quarterCnt - 1) {
				quarterCspan = quarterCspan + ",#cspan";
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
		
		result.header = "Year,Quarter" + quarterCspan;
		result.attachHeader1 = "#rspan" + "${quarterRows}";
		result.cols = "Date|" + "${quarterCols}";
		result.widths = "100" + widths;
		result.sorting = "str" + sorting;
		result.aligns = "center" + aligns;
		result.data = "";
		return result;
	}
	
	//조회
	function doSearchList(){
		p_gridArea.enableRowspan();
		p_gridArea.enableColSpan(true);
		p_gridArea.loadXML("${root}upload/itemRevisionStatisticsByYearGrid.xml");
		
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
	function fnSearchProchSum(){
		if($("#fromYear").val() > $("#toYear").val()){
			alert("${WM00017}"); return;
			return false;
		}
		var url = "itemRevisionStatisticsByYear.do";
		var target = "grdGridArea";		
		var data = "fromYear="+$("#fromYear").val()+"&toYear="+$("#toYear").val()+"&itemTypeCodeList=${itemTypeCodeList}";
		ajaxPage(url, data, target);
	}	
</script>
<div class="msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;${title}</div>
	
<div class="child_search">
	<li>&nbsp;&nbsp;From&nbsp;&nbsp;
		<select id="fromYear" name="fromYear">
			<option value="0" >select</option>
			<c:forEach var="i" begin="0" end="${curYear - minYear}">
				<c:set var="yearOption" value="${curYear - i}" />
				<option <c:if test="${ yearOption eq fromYear }"> selected="selected" </c:if> value="${yearOption}">${yearOption}</option>
			</c:forEach>
		</select>
		
	</li>
   <li>&nbsp;&nbsp;To&nbsp;&nbsp;
		<select id="toYear" name="toYear">
			<c:forEach var="i" begin="0" end="${curYear - minYear}">
			<c:set var="yearOption" value="${curYear - i}" />
			<option <c:if test="${ yearOption eq toYear }"> selected="selected" </c:if> value="${yearOption}">${yearOption}</option>
		</c:forEach>
		</select>
		
	</li>
	<li>
		<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="fnSearchProchSum()" />
	</li>
	<li class="floatR pdR20">
		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
	</li>
</div>
<form name="rptForm" id="rptForm" action="" method="post" >	
	<div id="gridDiv" class="mgB10 mgT5">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<!-- END :: LIST_GRID -->			
</form>