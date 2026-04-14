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

<style>
		.custom-class .dhx_chart-graph_area {
			fill:#444;
		}
		.custom-class .grid-line {
			stroke: white;
			stroke-width: 0.5;
		}
		.custom-class .chart.bar {
			/* fill: orange; */
		}
	</style>
		
<script>
	$(document).ready(function(){
		fnChartLoad();
	});
	var config = {
			type: "bar",
			css: "custom-class",
			scales: {
				"bottom" : {
					text: "label"
				},
				"left" : {
					maxTicks: 20,
					max: 2000,
					min: 0,
					textTemplate: function (cost) {
						return cost
					}
				}
			},
			series: [
				{
					id: "Manual",
					value: "Manual",
					color: "#FFC000",
					fill: "#FFC000",
					showText: true,
					showTextRotate: -90,
					showTextTemplate: function (sum) {
						return sum;
					}
				},
				{
					id: "System",
					value: "System",
					color: "#74A2E7",
					fill: "#74A2E7",
					showText: true,
					showTextRotate: -90,
					showTextTemplate: function (sum) {
						return sum;
					}
				}
			],
			legend: {
				series: ["Manual", "System"],
				halign: "right",
				valign: "top"
			}
		};

	var chart;
		
	function fnChartLoad(){
		console.log("loaddddd");
		var config = {
				type: "bar",
				css: "custom-class",
				scales: {
					"bottom" : {
						text: "label"
					},
					"left" : {
						maxTicks: 20,
						max: 2000,
						min: 0,
						textTemplate: function (cost) {
							return cost
						}
					}
				},
				series: [
					{
						id: "Manual",
						value: "Manual",
						color: "#FFC000",
						fill: "#FFC000",
						showText: true,
						showTextRotate: -90,
						showTextTemplate: function (sum) {
							return sum;
						}
					},
					{
						id: "System",
						value: "System",
						color: "#74A2E7",
						fill: "#74A2E7",
						showText: true,
						showTextRotate: -90,
						showTextTemplate: function (sum) {
							return sum;
						}
					}
				],
				legend: {
					series: ["Manual", "System"],
					halign: "right",
					valign: "top"
				}
			};

			chart = new dhx.Chart("chart", config);
			chart.data.parse(${processData});
	}
	
	setInterval(function(){fnReload()},10000);
	
	function fnReload(debug, noMsg, msg, callback){
		console.log("fnReload");
		var url = "getChartData.do";
		var data = "";
		$.ajax({
			url: url,type: 'post',data: data
			,error: function(xhr, status, error) {('#loading').fadeOut(150);var errUrl = "errorPage.do";var errMsg = "status::"+status+"///error::"+error;var callback = "";var width = "300px";var height = "300px";var callBack = function(){};fnOpenLayerPopup(errUrl,errMsg,callBack,width,height);}
			,beforeSend: function(x) {$('#loading').fadeIn();if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}	}
			,success: function(result){
				$('#loading').fadeOut(3000);if(debug){alert(result);}	if(result == 'error' || result == ""){if(noMsg != 'Y'){alert(msg);}
				}else{
					console.log("result :"+result);
					result = eval(result);
					chart.data.parse(result);
				}
				if(callback== null || callback==""){}
				else{ eval(callback);}
			}
		});
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