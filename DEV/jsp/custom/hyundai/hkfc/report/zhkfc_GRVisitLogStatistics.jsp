<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>

<style>
	.edit {
		background: #4CAF50;
		color: #FFF
	}
	.my_сustom_сlass {
		background: greenyellow;
	}
	.grid__cell_status-item {
	    background: rgba(0,0,0,.05);
	    color: #8792a7;
	    text-align: center;
	    height: 20px;
	    width: 70px;
	    border-radius: 100px;
    }
    .mod {
    	color: #0ab169;
    }
    .cls {
    	color:#ff5252;
    }
    .dhx_demo-exam-grid__controls__icon {
	    color: #fff;
	    width: 16px;
	    height: 16px;
	    font-size: 16px;
	    line-height: 16px;
	}
</style>

<script type="text/javascript">
	var gridData = ${GRVisitLogStatisticsListData};
	var statusCSS;
	
	$(document).ready(function() {
		$("input.datePicker").each(generateDatePicker); // calendar
		// 초기 표시 화면 크기 조정 
		$("#grid_container").attr("style","height:"+(setWindowHeight() * 0.85 )+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grid_container").attr("style","height:"+(setWindowHeight() * 0.85)+"px;");
		};
		
		fnGridList(gridData, ${totalCnt});
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid;
	function fnGridList(resultdata, totalCnt){
		$("#TOT_CNT").html(totalCnt);
		grid = new dhx.Grid("grid_container", {
			columns: [
				{ width: 120, id: "VisitDate", header: [{ text: "날짜", align: "center"}], align: "center"},
				{ width: 60, id: "VisitCNT1", header: [{ text: "경영관리사업부", colspan: 2, align: "center"},{ text: "방문", align: "center"}], align: "center"},
				{ width: 80, id: "GRMemberCNT1", header: ["", { text: "총원", align: "center"}], align: "center"},
				{ width: 60, id: "VisitCNT2", header: [{ text: "구매실", colspan: 2, align: "center"},{ text: "방문", align: "center"}], align: "center"},
				{ width: 80, id: "GRMemberCNT2", header: ["", { text: "총원", align: "center"}], align: "center"},
				{ width: 60, id: "VisitCNT3", header: [{ text: "기획실", colspan: 2, align: "center"},{ text: "방문", align: "center"}], align: "center"},
				{ width: 80, id: "GRMemberCNT3", header: ["", { text: "총원", align: "center"}], align: "center"},
				{ width: 60, id: "VisitCNT4", header: [{ text: "생산개발센터", colspan: 2, align: "center"},{ text: "방문", align: "center"}], align: "center"},
				{ width: 80, id: "GRMemberCNT4", header: ["", { text: "총원", align: "center"}], align: "center"},
				{ width: 60, id: "VisitCNT5", header: [{ text: "생산공장", colspan: 2, align: "center"},{ text: "방문", align: "center"}], align: "center"},
				{ width: 80, id: "GRMemberCNT5", header: ["", { text: "총원", align: "center"}], align: "center"},
				{ width: 60, id: "VisitCNT6", header: [{ text: "영업실", colspan: 2, align: "center"},{ text: "방문", align: "center"}], align: "center"},
				{ width: 80, id: "GRMemberCNT6", header: ["", { text: "총원", align: "center"}], align: "center"},
				{ width: 60, id: "VisitCNT7", header: [{ text: "품질사업부", colspan: 2, align: "center"},{ text: "방문", align: "center"}], align: "center"},
				{ width: 80, id: "GRMemberCNT7", header: ["", { text: "총원", align: "center"}], align: "center"},
				{ width: 60, id: "VisitCNT8", header: [{ text: "R&D사업부", colspan: 2, align: "center"},{ text: "방문", align: "center"}], align: "center"},
				{ width: 80, id: "GRMemberCNT8", header: ["", { text: "총원", align: "center"}], align: "center"},
				{ width: 60, id: "VisitCNT", header: [{ text: "합계", colspan: 2, align: "center"},{ text: "방문", align: "center"}], align: "center"},
				{ width: 80, id: "TotalGRMemberCNT", header: ["", { text: "총원", align: "center"}], align: "center"},
			],
			autoWidth: true,
			data: resultdata,
			selection: "row",
			resizable: true,
			
		});
		

		
		var pagination = new dhx.Pagination("pagination", {
		    data: grid.data,
		    pageSize: 20,
		});
	} 
	
	layout.getCell("a").attach(grid);
	
	function exportXlsx() {
	    grid.export.xlsx({
	        url: "//export.dhtmlx.com/excel"
	    });
	};
	
	function fnSearchList(){
		var url = "zhkfc_GRVisitLogStatistics.do";
		//ajaxSubmitNoAdd(document.GRProcessStatisticsFrm, url, "help_content");
		var target = "help_content";
		 
		ajaxPage(url, "&startDate="+$("#startDate").val()+"&endDate="+$("#endDate").val(), target);
	}

</script>

<body>
<form name="changeInfoLstFrm" id="changeInfoLstFrm" method="post" action="#" onsubmit="return false;">
	 <div class="child_search01" >
     	<li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="pdL55 floatL">
        		<input type="text" id="startDate" name="startDate" value="${startDate}"	class="input_off datePicker" size="8"
					style="text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				
				~
				<input type="text" id="endDate" name="endDate" value="${endDate}"	class="input_off datePicker" size="8"
					style="text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
				
		</li>
		<li class="floatL">
			<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="fnSearchList()" value="Search" style="cursor:pointer;">
		</li>
		<li class="floatR pdR10">	
			<span class="floatR btn_pack small icon"><span class="down"></span><input value="Down" type="button" id="excel" onClick="exportXlsx()"></span>
		</li>	
    </div>
    <div style="width: 100%;" id="layout"></div>
	<div style="width: 100%;" id="grid_container"><div id="pagination"></div></div>
	
	
</form>
</body>
<!-- START :: FRAME --> 		
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>

