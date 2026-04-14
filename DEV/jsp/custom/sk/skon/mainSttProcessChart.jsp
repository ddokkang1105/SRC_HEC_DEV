<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    .dhx_chart{font-size: 11px;font-family:'Malgun Gothic' !important; color:'#ffffff';padding:0;border:0px;}
    .dhx_chart canvas{ left:0px;}    
    .dhx_axis_item_x{color:#ffffff !important;}
    .dhx_canvas_text{color:#ffffff !important;}
    .dhx_chart_legend_item{color:#ffffff !important;}
</style>
<%@ include file="/WEB-INF/jsp/cmm/ui/dhtmlxJsInc.jsp"%>
<script type="text/javascript">
	var p_chart;
	$(document).ready(function(){
		doCallChart("'CL01005','CL01005A','CL01006A','CL01006B'","chartArea2","OJ00001","PIE");
		doCallChart("CL16004","chartArea3","OJ00016","PIE");
	});
	function setChartData(avg, itemTypeCode){
		var result = new Object();
		if(itemTypeCode == "OJ00001") result.key = "zSK_SQL2.processStt";
		if(itemTypeCode == "OJ00016") result.key = "zSK_SQL2.techStt";
		result.data = "ClassCode="+avg+"&defaultLang=${defaultLang}";
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
	
	function doCallChart(data, containerNm,itemTypeCode,view){	
		var d = "";
		var config = setChartConfig(view);
		if(view == "BAR3"){
			d = setBarChartData(data);
		 	config = setBarChartConfig();
		}else{
			d = setChartData(data,itemTypeCode);
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
	  <td>Tech Std</td>
	</tr>		
	<tr>
		<td><div id="chartArea2" style="width:100%;height:200px;"></div></td>
		<td><div id="chartArea3" style="width:100%;height:200px;"></div></td>
	</tr>
</table>