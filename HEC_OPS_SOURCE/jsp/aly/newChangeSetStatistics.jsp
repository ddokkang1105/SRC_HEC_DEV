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
		$("input.datePicker").each(generateDatePicker);
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		// 검색 버튼 클릭
		$('.searchList').click(function(){
			var url = "newChangeSetStatistics.do";
			var data ="scStartDt=" + $("#SC_STR_DT").val() 
			        + "&scEndDt=" + $("#SC_END_DT").val() 
			        + "&languageID=" + $("#languageID").val()
					+ "&ItemTypeCode=${itemTypeCode}"
					+ "&subMenuName=${subMenuName}";
			var target = "help_content";
			ajaxPage(url, data, target);
		});
		
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
		var widths = "";
		var sorting = "";
		var aligns = "";
		var cspan = "";
		var aCnt = "${cnt}";
		
		for (var i = 0; i < aCnt; i++) {
			widths = widths + ",120";
			sorting = sorting + ",str";
			aligns = aligns + ",center";
			
			if (i != aCnt - 1) {
				cspan = cspan + ",#cspan";
			}
			
		}
		
		result.title = "";
		result.key = "";
		result.header = "${menu.LN00022},${menu.LN00052}" + cspan;
		result.attachHeader1 = "#rspan" + "${header1}";
		result.attachHeader2 = "#rspan" + "${header2}";
		//result.cols = "Module" + "${cols}";
		result.widths = "*" + widths;
		result.sorting = "str" + sorting;
		result.aligns = "center" + aligns;
		result.data = "";
		return result;
	}
	
	//조회
	function doSearchList(){
		p_gridArea.enableRowspan();
		p_gridArea.enableColSpan(true);
		p_gridArea.loadXML("${root}" + "${xmlFilName}");
		
	}
	

	// END ::: GRID	
	//===============================================================================
		
		
	//===============================================================================
	// BEGIN ::: EXCEL
	function doExcel() {		
		p_gridArea.toExcel("${root}excelGenerate");
	}

	// END ::: EXCEL
	//===============================================================================
		
</script>

<div class="msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;${subMenuName} ChangeSet</div>

<div class="child_search">
	<li class="pdL55">
		${menu.LN00013}
		<font> <input type="text" id="SC_STR_DT" name="SC_STR_DT" value="${beforeYmd}"	class="input_off datePicker text" size="8"
				style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
		</font>
		~
		<font> <input type="text" id=SC_END_DT	name="SC_END_DT" value="${thisYmd}"	class="input_off datePicker text" size="8"
				style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
		</font>
	</li>
	<li>
		<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" />
	</li>
	<li class="floatR pdR20">
		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
	</li>
</div>
	
<form name="rptForm" id="rptForm" action="" method="post" >
	<input type="hidden" id="languageID" name="languageID" value="${languageID}">
	
	<!-- BIGIN :: LIST_GRID -->
	<c:set value='0' var='itemTypeNum' />
	<c:forEach var="itemTypeCodeList" items="${itemTypeCodeList}" varStatus="status">
		<input type='hidden' id='ItemTypeCode${itemTypeNum}' value='${itemTypeCodeList.ItemTypeCode}'></input>
		<input type='hidden' id='ItemTypeName${itemTypeNum}' value='${itemTypeCodeList.ItemTypeName}'></input>
		<c:set var='itemTypeNum' value='${itemTypeNum+1}'/>
	</c:forEach>
	
	<div id="gridDiv" class="mgB10 mgT5">
		<div id="grdGridArea" style="height:250px; width:100%"></div>
	</div>			
</form>