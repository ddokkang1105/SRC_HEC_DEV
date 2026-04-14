<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<script>
	var isMainMenu = "${isMainMenu}";
	var gridData = ${ispStatisticsListData};	
	
	$(document).ready(function(){
		
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 190)+"px; width:69%;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 190)+"px; width:69%;");
		};
		
		$("#excel").click(function(){ fnGridExcelDownLoad(); });
		
		fnGridList(gridData);
		
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	//===============================================================================
	
	function doSearch(){
		p_gridArea.clearAll(true);
		
		var url = "ispDashboard.do";
		var data = "";
		var target = "mainLayer";
		
		/* 검색 조건 설정 */
		// value chain
		if($("#srArea1").val() != '' & $("#srArea1").val() != null){
			data = data +"&srArea1="+ $("#srArea1").val();
		}
		// year
		if($("#year").val() != '' & $("#year").val() != null){
			data = data +"&year="+ $("#year").val();
		}
		// month
		if($("#month").val() != '' & $("#month").val() != null){
			data = data +"&month="+ $("#month").val();
		}
		ajaxPage(url, data, target);
	}
	
	// BEGIN ::: CHART
	var p_chart1;
	var p_chart2;
	$(document).ready(function(){
		doCallChart("Reason","chartArea1");
		doCallChart("ITSMIF","chartArea2");
	});
	function setChartData(avg){
		var result = new Object();
		if(avg == "Reason"){
			result.key = "esm_SQL.getSRCountBySRReason";
		} else {
			result.key = "esm_SQL.getSRCountBYITSMIF";
		}
		result.data = "srArea1=${srArea1}&year=${year}&month=${month}&languageID=${languageID}"
		result.cols = "label|value|code";
		
		return result;
	}
	

	function setChartConfig(){
		var result = new Object();
		result.view = "PIE2";
		result.value = "#value#";
		result.label = "#label#";	
		result.color = "#color#";
		result.code = "#code#";
		return result;		
	}
	
	function doCallChart(data, containerNm){	
		var d = setChartData(data);
		var config = setChartConfig();
		if(containerNm == "chartArea1") {
			p_chart1 = fnNewDashBoardChart(config, containerNm);
			fnLoadDhtmlxChartJson3(p_chart1, containerNm, d.key, d.cols, d.data, false,"Y");
		}
		if(containerNm == "chartArea2") {
			p_chart2 = fnNewDashBoardChart(config, containerNm);
			fnLoadDhtmlxChartJson3(p_chart2, containerNm, d.key, d.cols, d.data, false,"Y");
		}
		
		setTimeout(function() {
		    p_chart1.data.parse(
		    		p_chart1.data.getRawData().map(e => {
		            let data = Object.assign(e, {color : "#fff6f6"});
		            // 컬러 재정의
		            if(e.code == "01") data = Object.assign(e, {color : "#89b9ad"});
		            else if(e.code == "02") data = Object.assign(e, {color : "#c7dca7"});
		            else if(e.code == "03") data = Object.assign(e, {color : "#aedefc"});
		            else if(e.code == "04") data = Object.assign(e, {color : "#f875aa"});
		            else if(e.code == "05") data = Object.assign(e, {color : "#ffdfdf"});
		            
		            return data;
		        })
		    );
		}, 500);
		
		setTimeout(function() {
		    p_chart2.data.parse(
		    		p_chart2.data.getRawData().map(e => {
		            let data = Object.assign(e, {color : "#fff6f6"});
		            // 라벨 재정의
		            if(e.code == "Y") data = Object.assign(e, {label : "IT 지원 이슈", color : "#f875aa"});
		            else if(e.code == "N") data = Object.assign(e, {label : "IT 미지원 이슈", color : "#ffdfdf"});
		            
		            return data;
		        })
		    );
		}, 500);
	}
	
	function fnNewDashBoardChart(config, container) {
		var chart;
		
		chart = new dhx.Chart(container, {
		    type: "pie",
		    series: [
		        {
		            value: "value",
		            text: "label",
		            stroke: "#FFFFFF",
		            color : "color"
		        }
		    ],
		    legend: {
		        values: {
		            text: "label",
		            color: "color"
		        },
		        direction: "column"
		    }
		});
		
		return chart;
	};
	// END ::: CHART
	//===============================================================================
</script>

<style>
.chartP {
	text-align:center;
	margin-bottom:20px;
	font-weight:bold;
	font-size:15px;
	}
	
.point {
	background: #F7F7F7;
}
</style>
<div class="floatL mgT10 mgB12">
	<h3><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Value Chain별 이슈현황</h3>
</div>
<!-- BEGIN :: SEARCH -->
<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
	<colgroup>
	    <col width="7%">
	    <col width="18%">
	    <col width="7%">
	    <col width="18%">
	    <col width="7%">
	    <col width="18%">
	    <col width="7%">
	    <col width="18%">
    </colgroup>
	<tr>
		<!-- 도메인 -->
       	<th>${menu.LN00274}</th>
       	<td>
       		<select id="srArea1" Name="srArea1" style="width:150px;">
       			<option value=''>Select</option>
	        	<c:forEach var="i" items="${srArea1List}">
	            	<option value="${i.CODE}" <c:if test="${i.CODE == srArea1}">selected="selected"</c:if>>${i.NAME}</option>
	            </c:forEach>
       		</select>
       	</td>
       	<!-- Year -->
		<th>Year</th>
		<td>
			<select id="year" Name="year" style="width:150px;">
				<option value="">select</option>
				<c:forEach var="i" items="${yearList}">
	            	<option value="${i.year}" <c:if test="${i.year == year}">selected="selected"</c:if>>${i.year}</option>
	            </c:forEach>
        </select>
		</td>

		<!-- Month -->
		<th>Month</th>
		<td>
			<select id="month" Name="month" style="width:150px;">
				 <option value="">select</option>
				 <c:forEach var="i" items="${monthList}">
					<option value="${i}" <c:if test="${i == month}">selected="selected"</c:if>>${i}</option> 
				</c:forEach>
		</select>
		</td>
		
	</tr>
</table>

<li class="mgT5 alignR">
	<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" onclick="javascript:doSearch();" />
	<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
</li>
		
<form name="rptForm" id="rptForm" action="" method="post" >
	<!-- grid -->
	<div id="layout" class="mgT5 floatL"></div>
	
	<!-- chart -->
	<div id="chartDiv" class="hidden mgT5 floatL" style="width:30%;" >
		<div>
			<p class="chartP">이슈별 원인현황</p>
			<div id="chartArea1" class="mgB20" style="width:100%;display:block;height:250px;"></div>
		</div>
		<div>
			<p class="chartP">IT지원 이슈현황</p>
			<div id="chartArea2" class="mgB20" style="width:100%;display:block;height:250px;"></div>
		</div>		
	</div>
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
		    	${ispHeaderConfig}
		    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: true,
		    data: gridData
		});
		
		layout.getCell("a").attach(grid);
		
		var total = grid.data.getLength();	
		for(var i=0; i < total; i++){
			var rowId = grid.data.getId(i);
			if(i<1) grid.addRowCss(rowId, "point");
			
			grid.addCellCss(rowId, "Name", "point");
			grid.addCellCss(rowId, "total", "point");
			grid.addCellCss(rowId, "cmp", "point");
			grid.addCellCss(rowId, "progress", "point");
		}
	}
</script>

