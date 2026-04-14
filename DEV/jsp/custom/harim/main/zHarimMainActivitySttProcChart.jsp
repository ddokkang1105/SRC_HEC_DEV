<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<%-- <link rel="stylesheet" href="${root}cmm/js/dhtmlx/dhtmlxV7/chart/chart.css?v=7.1.8">
<script type="text/javascript" src="${root}cmm/js/dhtmlx/dhtmlxV7/chart/dataset.js?v=7.1.8"></script> --%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
	var p_chart;
	var processData =${processData};
	var activityData = ${activityData};
	function findValueByName(data, name) {
	    // 주어진 배열을 순회하면서 "name"이 주어진 name과 일치하는 객체를 찾습니다.
	    for (var i = 0; i < data.length; i++) {
	        if (data[i].name === name) {
	            // 객체를 찾으면 해당 객체의 "value" 값을 반환합니다.
	            return data[i].value;
	        }
	    }
	    return undefined;
	}
	
	$(document).ready(function(){
		fnPieChartLoad();
		fnBarChartLoad();
		
		// 화면 resize 시 차트 재 생성
		window.addEventListener('resize', function() {
			chart.destructor();
			chart2.destructor();
			fnPieChartLoad();
			fnBarChartLoad();
		});
	});
	var totalValue = 0;

	// 객체들의 value 속성 값을 모두 더함
	for (var i = 0; i < activityData.length; i++) {
	    totalValue += activityData[i].value;
	}
	
	function tooltipTemplate(p) {
		var total = (findValueByName(processData,p[1])); 
	    return p[0] + " ("+(p[0]/total*100).toFixed(0)+"%)";
	}
	
	function tooltipTemplate1(p) {
	    return (p[0]/totalValue*100).toFixed(0)+"%";
	}
	
	function setChartData(avg){
		var result = new Object();
		result.key = "main_SQL.processStt";
		result.data = "ClassCode="+avg;
		result.cols = "label|value";		
		return result;
	}
	
	function setBarChartData(avg){
		var result = new Object();
		result.key = "main_SQL.processSttBar";
		result.data = "classCode="+avg;
		result.cols = "label|Manual|System";		
		return result;
	}
	
	function setChartConfig(){
		var result = new Object();
		result.view = "PIE";
		result.value = "#value#";
		result.label = "#label#";	
		result.color = "#color#";		
		return result;		
	}
	
	function setBarChartConfig(){
		var result = new Object();
		result.view = "BAR3";
		result.value = "#Manual#";
		result.value2 = "#System#";
		result.label = "#label#";	
		result.color = "#color#"; 	
		return result;		
	}
	
	function doCallChart(data, containerNm,totCntr,view){	
		var d = "";
		var config = setChartConfig(view);
		if(view == "BAR3"){
			d = setBarChartData(data);
		 	config = setBarChartConfig();
		}else{
			d = setChartData(data);
			config = setChartConfig();
		}
		
		p_chart = fnNewInitChart(config, containerNm);		
		fnLoadDhtmlxChartJson(p_chart, containerNm, d.key, d.cols, d.data, false,"Y");
	}
	
	var chart;	
	function fnPieChartLoad(){ // SELECT COUNT(*) AS value, PlainText label, IA.ItemID AS ItemID
		var config = {
			type: "pie",
			css: "dhx_widget--bg_white dhx_widget",
			series: [
			    {
			    	value: "value",
			        text: "label2",
			        stroke: "#FFFFFF",
			        strokeWidth: 2,
			        tooltip: true,
			        tooltipTemplate: tooltipTemplate1
			    }
			 ]
			};

			chart = new dhx.Chart("activityChartArea1", config);
			chart.data.parse(${activityData});
	}
	
	var chart2;		
	function fnBarChartLoad(){
		var config = {
				type: "bar",
				 css: "dhx_widget",
				scales: {
					"bottom" : {
						text: "label"
					},
					"left" : {
						maxTicks: 10,
						max: 1500,
						min: 0
					}
				},
				series: [
					{
						id: "System",
						value: "System",
						color: "#81C4E8",
						fill: "#81C4E8",
						barWidth: 15,
						tooltipTemplate: tooltipTemplate
					},
					{
						id: "Manual",
						value: "Manual",
						color: "#5E83BA",
						fill: "#5E83BA",
						barWidth: 15,
						tooltipTemplate: tooltipTemplate
					}
				]
				,
			    legend: {
			        series: ["System", "Manual"],
			        halign: "right",
			        valign: "top"
			    } 
			};

			chart2 = new dhx.Chart("activityChartArea2", config);
			chart2.data.parse(${processData});
	}
	 
	
</script>

<style>
.tbl_process{
	width:94%;
 	 height: 100%;
	margin:0 auto;
}

#chartArea2{
	width:98%;
 	 height: 100%;
	margin:0 auto;
}
.process-class .dhx_chart-graph_area {
    stroke: #c8d4e4;
    stroke-width: 1px;
}
.process-class .grid-line {
	stroke: #fff;
	stroke-width:0px;
}
.process-class .main-scale{
 	stroke: #c8d4e4;
    stroke-width: 1px;
}


</style>

<table cellpadding="0" cellspacing="0" class="tbl_process chart2_table">
	<colgroup>
	  <col width="50%">
	  <col width="50%">
	 </colgroup>		
	<tr style="width:100%;">
		<td><div id="activityChartArea1" style="width:100%;height:100%;"></div></td>
		<td><div id="activityChartArea2" style="width:100%;height:100%;"></div></td>
	</tr>
</table>


