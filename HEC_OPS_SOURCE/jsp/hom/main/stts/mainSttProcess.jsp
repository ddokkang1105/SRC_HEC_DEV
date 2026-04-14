<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    .dhx_chart{font-size: 11px;font-family:'Malgun Gothic' !important;padding:0;border:0px;}
    .dhx_chart canvas{ left:0px;;}
</style>

<script type="text/javascript">
	var p_chart;
	$(document).ready(function(){
		doCallChart("CL01004","chartArea1","pSum");
		doCallChart("CL01005","chartArea2","mSum");
		doCallChart("CL01006","chartArea3","tSum");
	});
	function setChartData(avg){
		var result = new Object();
		result.key = "main_SQL.processStt";
		result.data = "ClassCode="+avg;
		result.cols = "label|value";		
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
	function doCallChart(data, containerNm,totCntr){	
		var d = setChartData(data);
		var config = setChartConfig();
		p_chart = fnNewInitChart(config, containerNm);		
		fnLoadDhtmlxChartJson(p_chart, containerNm, d.key, d.cols, d.data, false,"Y");
	}
</script>
<style type="text/css">
.tbl_process, .tbl_process th, .tbl_process td{border:0;margin:0 auto;background:#fff;}
.tbl_process{width:100%;font-family:'Malgun Gothic' !important;font-size:12px;text-align:center}
.tbl_process th{padding:6px 0;border-top:0px solid #ddd;border-right:1px solid #ddd;background-color:#f5f5f5;color:#555;font-size:12px;font-weight:bold}
.tbl_process td{padding:5px 0;border-top:1px solid #ddd;border-right:1px solid #ddd;text-align:center;}
.tbl_process td.noline{border-left:0px}
.tbl_process th.noline{border-left:0px}

</style>
<center>
	<div id="chartDiv" class="hidden" style="width:100%;height:233px;" >
		<table width="100%" cellpadding="0" cellspacing="0" class="tbl_process">
			<colgroup>
			  <col width="33%">
			  <col>
			  <col width="33%">
			 </colgroup>
			<tr>
			  <th class="noline">Process(<span id="pSum">${classCL4}</span>)</th>
			  <th>Sub Process(<span id="tSum">${classCL5}</span>)</th>
			  <th>Activity(<span id="tSum">${classCL6}</span>)</th>
			 </tr>		
			<tr>
				<td  class="noline"><div id="chartArea1" align="center" style="width:100%;display:block;height:190px;"></div></td>
				<td><div id="chartArea2" style="width:100%;display:block;height:190px;"></div></td>
				<td><div id="chartArea3" class="chartArea" style="width:100%;display:block;height:190px;"></div></td>
			</tr>
		</table>
	</div>
</center>