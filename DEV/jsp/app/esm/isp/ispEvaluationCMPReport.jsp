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
	var gridData = ${ispEvaluationCMPListData};
	
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
		grid.export.xlsx({
	        url: "//export.dhtmlx.com/excel"
	    });
	}
	
	function doSearch(){
		var url = "ispEvaluationCMPReport.do";
		var data = "";
		var target = "ispEvaluationCMPList";
		
		/* 검색 조건 설정 */
		if($("#srArea1").val() != '' & $("#srArea1").val() != null){
			data = data +"&srArea1="+ $("#srArea1").val();
		}
		if($("#startDate").val() != '' & $("#startDate").val() != null){
			data = data +"&startDate="+$("#startDate").val();
		}
		if($("#endDate").val() != '' & $("#endDate").val() != null){
			data = data +"&endDate="+$("#endDate").val()
		}
		
		ajaxPage(url, data, target);
	}
	
</script>
<style>
	.dhx_grid-header-cell-text_content {
		font-size:12.1px;
	}
</style>

<!-- BEGIN :: SEARCH -->
<form name="ispEvaluationCMPList" id="ispEvaluationCMPList" action="#" method="post" onsubmit="return false;">
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 3px 0 3px 0"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;&nbsp;만족도 평가완료 리포트</h3>
	</div>
	<div class="child_search">
		<li class="floatL">
       		<span style="font-weight:bold;">From</span>
       		<input type="text" id="startDate" name="startDate" value="${startDate}"	class="input_off datePicker" size="8"
				style="text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
			
			<span style="font-weight:bold;">To</span>
			<input type="text" id="endDate" name="endDate" value="${endDate}"	class="input_off datePicker" size="8"
				style="text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
			
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
	<div id="pagination"></div>	
	
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
		    	{ width: 150, id: 'SRCode', align:'center' ,header: [{ text: 'SR No.', align:'center'},{ content: "inputFilter" }] },
		    	{ id: 'Subject', align:'center' ,header: [{ text: '${menu.LN00002}', align:'center' },{ content: "inputFilter" }]},
		    	{ width: 150, id: 'RequestUserNM', align:'center' ,header: [{ text: '${menu.LN00025}', align:'center'},{ content: "inputFilter" }]},
		    	{ width: 120, id: 'SRArea1NM', align:'center' ,header: [{ text: 'ValueChain', align:'center'},{ content: "selectFilter" }]},
		    	{ width: 150, id: 'ReceiptUserNM', align:'center' ,header: [{ text: '${menu.LN00004}', align:'center'},{ content: "inputFilter" }]},
		    	{ width: 120, id: 'RegDT', align:'center' ,header: [{ text: '${menu.LN00093}', align:'center'}]},
		    	{ width: 120, id: 'CompletionDT', align:'center' ,header: [{ text: '${menu.LN00223}', align:'center'}]},
		    	{ width: 90, id: 'Total', align:'center' ,header: [{ text: '평가 점수', align:'center'}]},
		    	{ width: 90, id: 'Result', align:'center' ,header: [{ text: '${menu.LN00182}', align:'center'},{ content: "selectFilter" }], htmlEnable: true,
		    		template: function (i) {
		    			if(i == "05") return "매우 만족"
		    			else if(i == "04") return "만족"
		    			else if(i == "03") return "양호"
		    			else if(i == "02") return "보통"
		    			else return "불만족"
		    	}},
		    	{ width: 80, id: 'SRID', align:'center' ,header: [{ text: '항목별 점수', align:'center' }], htmlEnable: true,
	            	template: function () {
	            	return '<span class="btn_pack medium icon"><span class="list"></span><input value="" type="submit" style="padding-left:15px;"></span>';
	            }},
		    ],
		    eventHandlers: {
		        onclick: {
		            "icon": function (e, data) {
		            	fnEvaluation(data.row.SRID);
		            }
		        }
		    },
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: true,
		    data: gridData
		});
		layout.getCell("a").attach(grid);
		$("#TOT_CNT").html(grid.data.getLength());
		grid.events.on("filterChange", function(row,column,e, item){
			$("#TOT_CNT").html(grid.data.getLength());
		});
		
		
		
		var pagination = new dhx.Pagination("pagination", {
		    data: grid.data,
		    pageSize: 20,
		});
	}
	
	function fnEvaluation(srId){
		var url = "viewEvSheet.do?srID=" + srId + "&screenType=V&srType=ISP&status=ISP008";
		var w = 600;
		var h = 780;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
</script>