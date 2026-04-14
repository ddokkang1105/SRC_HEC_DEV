<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<style>    
    .dhx_chart {
   	    background: transparent;
    }
    
   .dhx_chart .pie-value, .dhx_chart .donut-value {
        fill: #fff;
    }
    
    .scale-text.top-text, .scale-text.end-text, .scale-text.legend-text, .start-text.legend-text {
    	fill: #fff;
    }
</style>

<script type="text/javascript">
	var pie_chart, bar_chart;
	
	$(document).ready(function(){
		doCallChart("chartArea2","pie");
		doCallChart("chartArea3","bar");
	});
	
	function setPieChartData(avg){
		var result = new Object();
		result.chartId = "main_SQL.processStt";
		result.ClassCode = "CL01005";
		result.cols = "label|value";
		return result;
	}
	
	function setBarChartData(avg){
		var result = new Object();
		result.chartId = "main_SQL.processSttBar";
		result.classCode = "CL01006";
		result.cols = "label|Manual|System";
		return result;
	}
	
	function setPieChartConfig(){		
		pie_chart = new dhx.Chart("chartArea2",  {
		    type: "pie",
		    series: [
		        {
		            value: "value",
		            text: "label",
		            color : "color",
		            stroke: "#FFFFFF",
		            strokeWidth: 2,
		            // 차트 위에 비율 표시
		            valueTemplate: value => {
		                return ""
		            },
		            // 차트 위에 숫자 표시
// 		            showTextTemplate : value => {
// 		                return value
// 		            }
		        }
		    ]
		});
	}
	
	function setBarChartConfig(){
		bar_chart = new dhx.Chart("chartArea3",  {
		    type: "bar",
		    barWidth: 10,
		    scales: {
		        "bottom": {
		            text: "name"
		        },
		        "left": {
		        	maxTicks: 5, // 표시할 간격
		        }
		    },
		    series: [
		        {
		            id: "Manual",
		            value: "Manual",
		            color : "#ffc000"
		        },
		        {
		        	id: "System",
		            value: "System",
		            color : "#0070c0"
		        }
		    ],
		    legend: {
		        series: ["Manual", "System"],
		        halign: "right",
		        valign: "top"
		    }
		});
	}
	
	function doCallChart(containerNm, view){	
		var d = "";
		var config = "";
		if(view == "bar"){
		 	setBarChartConfig();
			d = setBarChartData();
		}else{
			setPieChartConfig();
			d = setPieChartData();
		}
		
		fetch("/jsonDhtmlxChartData.do", {
			method: "POST",
			headers: {
				"Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
			},
			body: new URLSearchParams(d)
		})
		.then(res => res.json())
		.then(res => {
			const data = res;
			if(view == "pie") pie_chart.data.parse(data);
			if(view == "bar") bar_chart.data.parse(data);
		});
	}
</script>
<style>
.tbl_process{
	width:94%;
 	 height: 100%;
	margin:0 auto;
}
</style>
<table cellpadding="0" cellspacing="0" class="tbl_process">
	<colgroup>
	  <col width="42%">
	  <col width="58%">
	 </colgroup>
	<tr>
	  <td>Process</td>
	  <td>Activity</td>
	</tr>		
	<tr>
		<td><div id="chartArea2" style="width:100%; height: 300px"></div></td>
		<td><div id="chartArea3" style="width:100%; height: 250px"></div></td>
	</tr>
</table>