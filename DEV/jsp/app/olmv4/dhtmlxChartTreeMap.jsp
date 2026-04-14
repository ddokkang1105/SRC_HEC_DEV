<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<html>
<head>

<style>
html, body {
	height:100%;
	padding:0;
	margin:0;
	overflow:hidden;
}
</style>
  
</head>
 
<body>
    <div id="chart" class="chart" style="padding: 20px; width: 1000px; height: 500px"></div>
</body>

<script>
  function tooltipTemplate(p) {
	    return p[1] + "-" + p[0];
	}
  
  var processTreeMapListData = ${processTreeMapListData};
  
  var config = {
		    type: "treeMap",
		    css: "dhx_widget--bg_white dhx_widget--bordered",
		    series: [
		        {
		            text: "name", 
		            value: "value", 
		            stroke: "#eeeeee", 
		            strokeWidth: 1,
		            // tooltipTemplate: item => `${item[1]} - ${item[0]}`,  
		            tooltipTemplate : tooltipTemplate
		        }
		    ],
		    legend: {
		        type: "range", // each tile will have the color depending on the value of the tile. The legend shows value ranges.
		        treeSeries: [
		          	// setting the color for each value range, related tiles and legend
		            { greater: 150, color: "#237396" },
		            { from: 100, to: 150, color: "#2780A8" },
		            { from: 50, to: 100, color: "#3892A3" },
		            { from: 30, to: 50, color: "#4DA3A0" },
		            { less: 30, color: "#67BF99" },
		        ],
		        halign: "right", //  "right" (by default) | "left" | "center"
		        valign: "top", // "top" (by default) | "bottom" | "middle"
		        direction: "row", // "row" (by default) | "column"
		        size: 30,
		    },
		    data: processTreeMapListData
		};

		var chart = new dhx.Chart("chart", config);
		
		var events = [
		    "toggleSeries",
		    "resize",
		    "serieClick"
		];

		var eventsContainer = document.querySelector(".chart");
		var counter = 1;

		events.forEach(function (event) {
		    chart.events.on(event, function (arguments, avg) {
		    	if(event == "serieClick"){
		    		console.log("arguments :"+JSON.stringify(arguments)+", avg :"+JSON.stringify(avg));
		    	}
		    });
		  
		});
  
</script>
</html>