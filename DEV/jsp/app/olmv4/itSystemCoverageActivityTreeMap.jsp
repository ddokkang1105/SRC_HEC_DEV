<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagIncV7.jsp"%>

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
<script>
$(document).ready(function(){
	
 	var data =  "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}";
	fnSelect('L1ItemID', data, 'getLevel1Name', '', 'Select', 'analysis_SQL');	
});

</script>
</head>
 
<body>
	<div class="title-section mgL20">IT System coverage of activity treemap chart</div>
	<div class="child_search01 mgL20 mgT10" >
        <select id="L1ItemID" name="L1ItemID" style="width:250px" OnChange="fnGetProcessTreeMapData(this.value);"></select>
   </div>
    <div id="gridDiv" class=mgL20 style="width:1200px; border: 1px solid #ccc;">
    <div id="chart" class="chart" style="padding: 20px; width: 96%; height: 500px;"></div>
    </div>
</body>

<script>
  function tooltipTemplate(p) {
	    return p[1] + "-" + p[0];
	}
  
 // var processTreeMapListData = ${processTreeMapListData};
  
  var config = {
		    type: "treeMap",
		    css: "dhx_widget--bg_white dhx_widget--bordered",
		    series: [
		        {
		            text: "PItemName", 
		            value: "SysCount", 
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
		            { greater: 200, color: "#D1B2FF" },
		            { from: 150, to: 200, color: "#73b4ed" },
		            { from: 100, to: 150, color: "#CEF76E" },
		            { from: 90, to: 100, color: "#C4BFFF" },
		            { from: 80, to: 90, color: "#FFFF36" },
		            { from: 70, to: 80, color: "#3892A5" },
		            { from: 60, to: 70, color: "#8E89FF" },
		            { from: 50, to: 60, color: "#3892A3" },
		            { from: 40, to: 50, color: "#0690ba" },
		            { from: 30, to: 40, color: "#85f2bf" },
		            { from: 20, to: 30, color: "#94c9f7" },
		            { from: 10, to: 20, color: "#2a54c7" },
		            { from: 5, to:10, color: "#4fc930" },
		            { less: 5, color: "#67BF99" },
		        ],
		        halign: "right", //  "right" (by default) | "left" | "center"
		        valign: "top", // "top" (by default) | "bottom" | "middle"
		        direction: "row", // "row" (by default) | "column"
		        size: 50,
		    },
		    //data: processTreeMapListData
		};

		var chart = new dhx.Chart("chart", config);
		
		//chart.data.parse(processTreeMapListData);
		
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
		
		function fnGetProcessTreeMapData(L1ItemID) {
			var url = "getProcessTreeMapData.do";
			var data = "&L1ItemID="+L1ItemID;
			var debug = false;
			var callback = "";
			var noMsg ="";var msg="";
			
			//console.log("url :"+url+", data :"+data);
			$.ajax({
				url: url,type: 'post',data: data
				,error: function(xhr, status, error) {('#loading').fadeOut(150);var errUrl = "errorPage.do";var errMsg = "status::"+status+"///error::"+error;var callback = "";var width = "300px";var height = "300px";var callBack = function(){};fnOpenLayerPopup(errUrl,errMsg,callBack,width,height);}
				,beforeSend: function(x) {$('#loading').fadeIn();if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}	}
				,success: function(result){
					$('#loading').fadeOut();if(debug){alert(result);}	if(result == 'error' || result == ""){if(noMsg != 'Y'){alert(msg);}
					}else{
						//console.log("result :"+result);
						result = eval(result);
						//if(result != ""){
							fnLoadTreeMap(result);
						//}
					}
					if(callback== null || callback==""){}
					else{ eval(callback);}
				}
			});
		}
		
		function fnLoadTreeMap(result){
			chart.data.parse(result);
		}
  
</script>
</html>