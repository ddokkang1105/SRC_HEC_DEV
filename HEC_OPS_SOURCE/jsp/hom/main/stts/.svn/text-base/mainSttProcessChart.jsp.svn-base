<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    .dhx_chart{font-size: 11px;font-family:'Malgun Gothic' !important; color:'#ffffff';padding:0;border:0px;}
    .dhx_chart canvas{ left:0px;}    
    .dhx_axis_item_x{color:#ffffff !important;}
    .dhx_canvas_text{color:#ffffff !important;}
    .dhx_chart_legend_item{color:#ffffff !important;}
</style>

<script type="text/javascript">
	var p_chart;
	$(document).ready(function(){
		doCallChart("CL01005","chartArea2","mSum","PIE");
		doCallChart("CL01006","chartArea3","tSum","BAR3");
	});
	function setChartData(avg){
		var result = new Object();
		result.key = "main_SQL.processStt";
		result.data = "ClassCode="+avg;
		result.cols = "label|value";		
		return result;
	}
	
	function setBarChartData(avg){
		var result = new Object();
		result.key = "main_SQL.processSttBar";
		result.data = "classCode="+avg;
		result.cols = "label|Manual|System";		
		return result;
	}
	
	function setChartConfig(){
		var result = new Object();
		result.view = "PIE";
		result.value = "#value#";
		result.label = "#label#";	
		result.color = "#color#";		
		return result;		
	}
	
	function setBarChartConfig(){
		var result = new Object();
		result.view = "BAR3";
		result.value = "#Manual#";
		result.value2 = "#System#";
		result.label = "#label#";	
		result.color = "#color#"; 	
		return result;		
	}
	
	function doCallChart(data, containerNm,totCntr,view){	
		var d = "";
		var config = setChartConfig(view);
		if(view == "BAR3"){
			d = setBarChartData(data);
		 	config = setBarChartConfig();
		}else{
			d = setChartData(data);
			config = setChartConfig();
		}
		
		p_chart = fnNewInitChart(config, containerNm);		
		fnLoadDhtmlxChartJson(p_chart, containerNm, d.key, d.cols, d.data, false,"Y");
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
		<td><div id="chartArea2" style="width:100%;height:200px;"></div></td>
		<td><div id="chartArea3" style="width:100%;height:200px;"></div></td>
	</tr>
</table>