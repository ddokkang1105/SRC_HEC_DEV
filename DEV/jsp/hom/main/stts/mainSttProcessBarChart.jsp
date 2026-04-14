<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet"
	href="${root}cmm/js/dhtmlx/dhtmlxV7/chart/chart.css?v=7.1.8">
<script type="text/javascript"
	src="${root}cmm/js/dhtmlx/dhtmlxV7/chart/dataset.js?v=7.1.8"></script>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<style>
.dhx_chart {
	font-size: 11px;
	font-family: 'Malgun Gothic' !important;
	color: '#ffffff';
	padding: 0;
	border: 0px;
}

.dhx_chart canvas {
	left: 0px;
}

.dhx_axis_item_x {
	color: #ffffff !important;
}

.dhx_canvas_text {
	color: #ffffff !important;
}

.dhx_chart_legend_item {
	color: #ffffff !important;
}
</style>

<script type="text/javascript">
	var p_chart;
	$(document).ready(function(){
		fnChartLoad();
	});
	
	var chart;		
	function fnChartLoad(){
		var config = {
				type: "bar",
				  css: "process-class",
				scales: {
					"bottom" : {
						text: "label"
					},
					"left" : {
						maxTicks: 10,
						max: 160,
						min: 0,
						textTemplate: function (cost) {
							return cost
						}
					}
				},
				series: [
					{
						id: "label",
						value: "value",
						color: "#B6B6B4",
						fill: "#B6B6B4",
						itemID : "ItemID",
						//showText: true,
						//showTextRotate: -90,
						//showTextTemplate: function (sum) { return sum; }
					}
				]
				/* ,
				legend: {
					series: ["label"],
					halign: "right",
					valign: "top"
				} */
			};

			chart = new dhx.Chart("chartArea", config);
			chart.data.parse(${processData});
			chart.events.on("serieClick", function (id, value, label, itemID) {
			   // alert("id:"+id+", value :"+value+",label :"+label+",itemID :"+itemID);
			    // parent.fnRefreshTree(itemID, true);
			    fnGoTreeItem(itemID, true);
			});
	}
	
	
</script>
<style>
#chartArea {
	width: 94%;
	height: 100%;
	margin: 0 auto;
}

.process-class .dhx_chart-graph_area {
	stroke: #c8d4e4;
	stroke-width: 1px;
}

.process-class .grid-line {
	stroke: #fff;
	stroke-width: 0px;
}

.process-class .main-scale {
	stroke: #c8d4e4;
	stroke-width: 1px;
}
</style>

<div id="chartArea" style="width: 100%; height: 230px;"></div>
</td>
