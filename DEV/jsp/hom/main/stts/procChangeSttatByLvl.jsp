<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<link rel="STYLESHEET" type="text/css" href="dhtmlxchart.css">
<link rel="stylesheet" href="${root}cmm/common/css/materialdesignicons.min.css"/>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 110)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 110)+"px;");
		};
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		// 검색 버튼 클릭
		$('.searchList').click(function(){
			var url = "procChangeSttatByLvl.do";
			var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";	
			/* [classCode] 조건 선택값 */
			if ($("#classCode").val() != "") {
				data = data + "&ClassCode=" + $("#classCode").val();
			}
			if ("${showClsFilter}" != "") {
				data = data + "&showClsFilter=" + "Y";
			}

			var target = "help_content";
			ajaxPage(url, data, target);
		});
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	var layout = new dhx.Layout("grdGridArea", {
		rows: [
	    	{
	        	id: "a",
	    	},
		]
	});
	
	var gridData = ${gridData};
	var L1NameList = ${level1NameList};
	var columns = [
	    { width: 65, id: "Progress", header: [{ text: "진행상태", align: "center" }], align: "center" , mark: function (cell, data) { return "column--color-gray"; }}
	];
	for (var i = 0; i < L1NameList.length; i++) {
	    var L1Name = L1NameList[i];
	    columns.push(
	        { id: L1Name.NAME, header: [{ text: L1Name.NAME, align: "center" , colspan: 2 }], align: "right" },
	        { id: "P"+L1Name.ItemID, header: [{ text: L1Name.NAME, align: "center" }], align: "right" }
	    );
	}
	columns.push({ width: 65, id: "Total", header: [{ text: "TOTAL", align: "center" } ], align: "right"});
	
	var grid = new dhx.Grid("grid", {
	    columns: columns,
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    headerRowHeight: 40,
	    rowHeight: 41,
	    data: gridData
	});
	layout.getCell("a").attach(grid);
		
	// END ::: GRID	
	//===============================================================================
		
		
	//===============================================================================
	// BEGIN ::: EXCEL
/* 	function doExcel() {		
	    grid.export.xlsx({
	    	 url: "https://export.dhtmlx.com/excel"
	    });
	} */

	// END ::: EXCEL
	//===============================================================================
	
	// [Process Update] Click
/* 	function processUpdate() {
		var url = "procChangeSttatByLvl.do";
		var data = "eventMode=prcUpdate&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		var target = "help_content";
		ajaxPage(url, data, target);
	} */
</script>
<style>
	.column--color-gray {
		background: #F7F7F7;      	
	}
</style>
<div class="pdL10 pdR10">
	<c:if test="${showClsFilter == 'Y'}">
	<div class="cop_hdtitle" style="width:100%;">
		<h3 style="padding: 6px 0; border-bottom: 1px solid #ccc;">
			<img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Sub 프로세스 설계작업 현황
		</h3>
	</div>
	<div class="child_search01">
		<li class="pdL20">
			<select id="classCode" style="width:120px">
				<option value=''>Select</option>
				<option value="CL01005" <c:if test="${ClassCode == 'CL01005'}">selected="selected"</c:if>>L4</option>
				<option value="CL01006" <c:if test="${ClassCode == 'CL01006'}">selected="selected"</c:if>>L5</option>
			</select>
		</li>
		<li>
			<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" />
		</li>
		<!--
		<li class="floatR">
			<button class="cmm-btn mgR5" style="height: 30px;" onclick="processUpdate();">
				<span class="mdi mdi-pencil mgR5 mgL_5" style="color:#494848;"></span>Update
			</button>
			<button class="cmm-btn mgR5" style="height:30px;" id="excel">
				<span class="mdi mdi-file-excel mgR5 mgL_5" style="color:#009345;"></span>Down
			</button>
		</li>
		-->
	</div>
	</c:if>

	<form name="itemStatisticsForm" id="itemStatisticsForm" action="" method="post" >	
		<div id="gridDiv" class="mgB10 mgT5">
			<div id="grdGridArea" style="width:100%"></div>
		</div>	
	</form>
</div>