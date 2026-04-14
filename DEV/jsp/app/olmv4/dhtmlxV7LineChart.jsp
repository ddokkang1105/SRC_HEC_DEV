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
				type:"area",
				scales: {
					"bottom" : {
						text: "label"
					},
					"left" : {
						maxTicks: 20,
						max: 2000,
						min: 0
					}
				},
				series: [
					{
						id: "Manual",
						value: "Manual",
						color: "#81C4E8",
						strokeWidth: 2
					},
					{
						id: "System",
						value: "System",
						color: "#74A2E7",
						strokeWidth: 3
					},
					{
						id: "totalCnt",
						value: "totalCnt",
						color: "#74A2E7",
						strokeWidth: 3
					}
				],
				legend: {
					series: ["Manual", "System", "totalCnt"],
					halign: "right",
					valign: "top"
				}
			};

			var chart = new dhx.Chart("chart", config);
			chart.data.parse(${processData});
	}
		
</script>

<body>
	<div class="mgL20 mgT20" style="width:100%;height:100%;">
		<section class="dhx_sample-container">
			<div style="width:800px; height:500px" id="chart"></div>
		</section>
	</div>
</body>
</html>