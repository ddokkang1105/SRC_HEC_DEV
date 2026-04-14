<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<link rel="STYLESHEET" type="text/css" href="dhtmlxchart.css">

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
		
		fnSelect('haederL1','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&category=OJ','getMasterL1List','${haederL1}','Select',"analysis_SQL","");
		
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
		var headerCspan = "";		
		var headerCnt = 0;
		var headerList = new Array();
		<c:forEach items="${headerList}" var="item" varStatus="status">
		headerList[ <c:out value="${status.index}" />] = {
				"cnt" : " <c:out value="${item.cnt}" />",
				"name" : " <c:out value="${item.headerL1name}" />",
				"headerL1code" : " <c:out value="${item.headerL1code}" />"
		};
		</c:forEach>
		for (var i = 0; i < headerList.length; i++) {			
			headerCnt = parseInt(headerList[i].cnt);
			
				headerCspan += ","+ headerList[i].name;
				for (var j = 0; j < headerCnt; j++) {
					widths = widths + ",100";
					sorting = sorting + ",str";
					aligns = aligns + ",center";
					if (j != headerCnt - 1) {
						headerCspan += ",#cspan";
					}
				}	
			
		}
		
		
		result.title = "";
		result.key = "";
		result.header = "Date,No. of Visitors" + headerCspan;
		result.attachHeader1 = "#rspan,#rspan" + "${headerRows}";
		result.cols = "Date|Total" + "${headerCols}";
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
		p_gridArea.loadXML("${root}upload/visitLogStatisticsByDayGrid.xml");
		
	}
	
	// END ::: GRID	
	//===============================================================================
	
	function fnSearchProchSum(){
		var url = "visitLogStatisticsByDay.do";
		var target = "grdGridArea";		
		var data = "haederL1="+$("#haederL1").val();
		ajaxPage(url, data, target);
	}		
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
<div class="msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Daily Visit Log by Item Type</div>
	
<div class="child_search">
	<ol>
		<li>&nbsp;&nbsp;${menu.LN00021}
			<select id="haederL1" name="haederL1" style="width:160px"></select>			
		</li>
		<li>
			<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="fnSearchProchSum()" />
		</li>
		<li class="floatR pdR20">
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</li>
	</ol>
</div>
<form name="rptForm" id="rptForm" action="" method="post" >	
	<div id="gridDiv" class="mgB10 mgT5">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<!-- END :: LIST_GRID -->			
</form>