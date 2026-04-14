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
				type: "pie3D",
				series: [
					{
						value: "value",
						color: "color",
						text: "label",
						stroke: "#FFFFFF",
						strokeWidth: 2
					}
				],
				legend: {
					values: {
						id: "value",
						text: "label",
						color: "color"
					},
					halign: "center",
					valign: "top"
				}
			};

			var chart = new dhx.Chart("chart", config);
			chart.data.parse(${processData});
	}
	
	/* 	
	var pieData = [
	    {id: "Jan", value: 44.33, color: "#394E79", month: "Jan"},
	    {id: "Feb", value: 22.12, color: "#5E83BA", month: "Feb"},
	    {id: "Mar", value: 53.21, color: "#C2D2E9", month: "Mar"},
	    {id: "Apr", value: 34.25, color: "#9A8BA5", month: "Apr"},
	    {id: "May", value: 24.65, color: "#E3C5D5", month: "May"}
	]; */
	
</script>

<body>
	<div class="mgL20 mgT20" style="width:100%;height:100%;">
		<section class="dhx_sample-container">
			<div style="width:800px; height:500px" id="chart"></div>
		</section>
	</div>
</body>
</html>