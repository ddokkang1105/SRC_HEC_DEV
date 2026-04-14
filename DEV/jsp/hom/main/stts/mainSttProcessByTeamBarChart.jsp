<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="${root}cmm/js/dhtmlx/dhtmlxV7/chart/chart.css?v=7.1.8">
<script type="text/javascript" src="${root}cmm/js/dhtmlx/dhtmlxV7/chart/dataset.js?v=7.1.8"></script>
<style>
    .dhx_chart{font-size: 11px;font-family:'Malgun Gothic' !important; color:'#ffffff';padding:0;border:0px;}
    .dhx_chart canvas{ left:0px;}    
    .dhx_axis_item_x{color:#ffffff !important;}
    .dhx_canvas_text{color:#ffffff !important;}
    .dhx_chart_legend_item{color:#ffffff !important;}
</style>

<script type="text/javascript">
	var p_chart2;
	$(document).ready(function(){
		fnChartLoad2();
	});

	var chart2;
		
	function fnChartLoad2(){
		var config = {
				type: "bar",
				  css: "process-class",
				scales: {
					"bottom" : {
						text: "TeamName"
					},
					"left" : {
						maxTicks: 10,
						max: 160,
						min: 0
					}
				},
				series: [
					{
						id: "중요",
						value: "중요",
						color: "#ffc000",
						fill: "#ffc000",
						stacked: true,
						teamCode : "TeamCode"
					},
					{
						id: "일반",
						value: "일반",
						color: "#5E83BA",
						fill: "#5E83BA",
						stacked: true,
						teamCode : "TeamCode"
					}
				]
				,
			    legend: {
			        series: ["중요", "일반"],
			        halign: "left",
			        valign: "top"
			    } 
				
			};

			chart2 = new dhx.Chart("chartArea2", config);
			chart2.data.parse(${processTeamData});
			chart2.events.on("serieClick", function (id, value, label, itemID, teamCode) {
			    fnGoDimTree(teamCode, true);
			});
	}
	
</script>
<style>
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
<div id="chartArea2" style="width:1500px;height:258px;"></div>
