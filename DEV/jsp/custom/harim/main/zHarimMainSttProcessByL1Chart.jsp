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
	function findL4CountByItemName(data, itemName) {
	    // 주어진 배열을 순회하면서 "ItemName"이 주어진 itemName과 일치하는 객체를 찾습니다.
	    for (var i = 0; i < data.length; i++) {
	        if (data[i].ItemName === itemName) {
	            // 객체를 찾으면 해당 객체의 "L4Count" 값을 반환합니다.
	            return data[i].L4Count;
	        }
	    }
	    return undefined;
	}
	var processTeamData =${processTeamData};
	
	var p_chart3;
		fnChartLoad();

	var chart3;
	
	function tooltipTemplate2(p) {
		var total = (findL4CountByItemName(processTeamData,p[1]));
	    return p[0] + " ("+(p[0]/total*100).toFixed(0)+"%)";
	}
	
	function fnChartLoad(){
		var config = {
				type: "bar",
				css: "process-class",
				scales: {
					"bottom" : {
						text: "ItemName"
					},
					"left" : {
						maxTicks: 10,
						max: 300,
						min: 0
					}
				},
				series: [
					{
						id: "그룹공통",
						value: "그룹공통",
						color: "#ab8ed7",
						fill: "#ab8ed7",
						stacked: true,
						itemID : "L4itemID",
						tooltipTemplate: tooltipTemplate2
					},
					{
						id: "업종공통(가금)",
						value: "업종공통(가금)",
						color: "#81C4E8",
						fill: "#81C4E8",
						stacked: true,
						itemID : "L4itemID",
						tooltipTemplate: tooltipTemplate2
					},
					{
						id: "업종공통(축산)",
						value: "업종공통(축산)",
						color: "#5E83BA",
						fill: "#5E83BA",
						stacked: true,
						itemID : "L4itemID",
						tooltipTemplate: tooltipTemplate2
					},
					{
						id: "사별특화",
						value: "사별특화",
						color: "#73bbbf",
						fill: "#73bbbf",
						stacked: true,
						itemID : "L4itemID",
						tooltipTemplate: tooltipTemplate2
					},
					{
						id: "선택안함",
						value: "선택안함",
						color: "#d8d8d8",
						fill: "#d8d8d8",
						stacked: true,
						itemID : "L4itemID",
						tooltipTemplate: tooltipTemplate2
					}
				]
				,
			    legend: {
			        series: ["그룹공통","업종공통(가금)","업종공통(축산)","사별특화","선택안함"],
			        halign: "left",
			        valign: "top"
			    } 
				
			};

			chart3 = new dhx.Chart("chartArea2", config);
			chart3.data.parse(${processTeamData});
			chart3.events.on("serieClick", function (id, label, value, itemID) {
	 			fnGoTreeItem(itemID, true);
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
<div id="chartArea2" style="width:600px;height:258px;"></div>
