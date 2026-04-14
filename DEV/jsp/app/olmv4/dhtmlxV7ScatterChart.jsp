<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
<head>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/dhtmlxV7/chart/chart.css?v=7.1.8">
<script type="text/javascript" src="${root}cmm/js/dhtmlx/dhtmlxV7/chart/dataset.js?v=7.1.8"></script>

<script>
	$(document).ready(function(){
		fnChartLoad();
	});
	
	function fnChartLoad(){
		var config = {
				scales: {
					bottom:{
						title: "value B",
						min: 0,
						max: 100,
						scalePadding: 25
					},
					left:{
						maxTicks: 10,
						title: "value A",
						max: 100
					}
				},
				series: [
					{
						id: "A_B",
						type: "scatter",
						value: "value A",
						valueY: "value B",
						color: "#81C4E8",
						pointType: "circle"
					},
					{
						id: "B_A",
						type: "scatter",
						value: "value B",
						valueY: "value A",
						color: "#74A2E7",
						pointType: "circle"
					}
				],
				legend: {
					series: ["A_B", "B_A"],
					halign: "right",
					valign: "top"
				}
			};
		
		var chart = new dhx.Chart("chart", config);
		chart.data.parse(scatterData);
	}

	var scatterData = [
	    {month: "01", "value A": 25, "value B": 50, "value C": 30},
	    {month: "02", "value A": 20, "value B": 52, "value C": 28},
	    {month: "03", "value A": 5, "value B": 33, "value C": 15},
	    {month: "04", "value A": 55, "value B": 30, "value C": 75},
	    {month: "05", "value A": 30, "value B": 11, "value C": 20},
	    {month: "06", "value A": 27, "value B": 14, "value C": 19},
	    {month: "07", "value A": 32, "value B": 31, "value C": 11},
	    {month: "08", "value A": 50, "value B": 22, "value C": 43},
	    {month: "09", "value A": 12, "value B": 19, "value C": 20},
	    {month: "10", "value A": 10, "value B": 24, "value C": 4},
	    {month: "11", "value A": 17, "value B": 40, "value C": 20},
	    {month: "12", "value A": 40, "value B": 60, "value C": 10}
	];
		
</script>

<body>
	<div class="mgL20 mgT20" style="width:100%;height:100%;">
		<section class="dhx_sample-container">
			<div style="width:800px; height:500px" id="chart"></div>
		</section>
	</div>
</body>
</html>