<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/ui/jqueryJsInc.jsp" %>
<%@ include file="/WEB-INF/jsp/cmm/ui/olmJsInc.jsp" %>
<html>
<head>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
	var isMainMenu = "${isMainMenu}";
	var gridData = ${evalListData};
	
	$(document).ready(function(){
		$("input.datePicker").each(generateDatePicker); // calendar
		// 초기 표시 화면 크기 조정
		$("#layout").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		};
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		fnGridList(gridData);
		
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function doExcel() {	
		fnGridExcelDownLoad();
	}
	
	function doSearch(){
		var url = "ispEvaluationReport.do";
		var data = "&mode=02";
		var target = "ispEvaluationList";
		
		/* 검색 조건 설정 */
		if($("#year").val() != '' & $("#year").val() != null){
			data = data +"&year="+$("#year").val()
		}
		// month
		if($("#month").val() != '' & $("#month").val() != null){
			data = data +"&month="+ $("#month").val();
		}
		ajaxPage(url, data, target);
	}

</script>
<style>
	.point {background: #F7F7F7;}
</style>

<form name="ispEvaluationList" id="ispEvaluationList" action="#" method="post" onsubmit="return false;">
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 3px 0 3px 0"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;&nbsp;만족도 조사 리포트 (ValueChain 별)</h3>
	</div>
	<div class="child_search">
		<li class="floatL">
       		<span style="font-weight:bold;" class="pdR10">Year</span>
       		<select id="year" Name="year" style="width:150px;">
       			<option value="">select</option>
				<c:forEach var="i" items="${yearList}">
	            	<option value="${i.year}" <c:if test="${i.year == year}">selected="selected"</c:if>>${i.year}</option>
	            </c:forEach>
        	</select>
        	<span style="font-weight:bold;" class="pdR10">Month</span>
			<select id="month" Name="month" style="width:150px;">
				<option value="">select</option>
				<c:forEach var="i" items="${monthList}">
					<option value="${i}" <c:if test="${i == month}">selected="selected"</c:if>>${i}</option>
				</c:forEach>
			</select>
        	<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearch()" value="Search" style="cursor:pointer;">
		</li>
	</div>
	
	<div class="countList">
		<li class="count">Total  <span id="TOT_CNT"></span></li>
		<li class="floatR pdR10">	
			<span class="floatR btn_pack small icon"><span class="down"></span><input value="Down" type="button" id="excel"></span>
		</li>	
	</div>
	
	
	<div style="width: 100%;" id="layout" class="mgT5"></div>
	
</form>



<script type="text/javascript">
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid;
	function fnGridList(resultdata){
		grid = new dhx.Grid("grid_container", {
			columns: [
		    	{ width: 150, id: 'Name', align:'center' ,header: [{ text: '', align:'center'}] } // Srarea1
		    	, { width: 100, id: 'cnt_5', align:'center' ,header: [{ text: '매우만족', align:'center'}] } // 매우만족
		    	, { width: 100, id: 'cnt_4', align:'center' ,header: [{ text: '만족', align:'center'}] } // 만족
		    	, { width: 100, id: 'cnt_3', align:'center' ,header: [{ text: '양호', align:'center'}] } // 양호
		    	, { width: 100, id: 'cnt_2', align:'center' ,header: [{ text: '보통', align:'center'}] } // 보통
		    	, { width: 100, id: 'cnt_1', align:'center' ,header: [{ text: '불만족', align:'center'}] } // 불만족
		    	, { width: 100, id: 'total', align:'center' ,header: [{ text: '총계', align:'center'}] } // 총계
		    	, { width: 100, id: 'avg', align:'center' ,header: [{ text: '평균점수', align:'center'}] } // 평균점수
		    	, { width: 100, id: 'result', align:'center' ,header: [{ text: '결과', align:'center'}] } // 결과
		    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    sortable: false,
		    tooltip: true,
		    data: gridData
		});
		
		var total = grid.data.getLength();
		layout.getCell("a").attach(grid);
		$("#TOT_CNT").html(total);
		grid.events.on("filterChange", function(row,column,e, item){
			$("#TOT_CNT").html(total);
		});	
		
		for(var i=0; i < total; i++){
			var rowId = grid.data.getId(i);
			grid.addCellCss(rowId, "Name", "point");
			grid.addCellCss(rowId, "total", "point");
			grid.addCellCss(rowId, "avg", "point");
			grid.addCellCss(rowId, "result", "point");
		}
	}
</script>
		
