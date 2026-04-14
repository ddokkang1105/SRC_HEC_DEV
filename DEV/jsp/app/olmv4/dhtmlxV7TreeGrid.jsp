<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
<head>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/dhtmlxV7/treegrid/treegrid.css?v=7.1.8">

<script>
	$(document).ready(function(){
		fnTreeGridLoad();
	});
	
	function fnTreeGridLoad(){
		var d=fnSetMenuTreeGridDataV7();
		fnLoadDhtmlxTreeGridJsonV7(d.key, d.cols, d.data); 
	}
	
	function fnSetMenuTreeGridDataV7(data){
		if(data == 'undefined' || data == null){data = "";}
		var result = new Object();
		result.title = "${title}";
		result.key = "menu_SQL.menuTreeList";
		result.header = "TREE_ID,PRE_TREE_ID,TREE_NM";
		result.cols = "TREE_ID|PRE_TREE_ID|TREE_NM${dimcols}";
		result.data = data ;
		return result;
	}
	
	function fnLoadDhtmlxTreeGridJsonV7(key, cols, value, select, noMsg, callbackFnc) {
		var msg = "${WM00018}";
		var data = "menuId="+key;
		data += "&cols=" + cols;
		data += "&SelectMenuId=" + select;
		data += "&" + value;
		data += "&cxnTypeCode=CN00001&rootClassCode=CL01001&dimTypeID=1001&selectedDimClass=CL01005&maxTreeLevel=4&reportCode=RP00037";
		console.log("data :"+data);
		try{if(key==null || key == ""){fnLog("ERROR fnLoadDhtmlxTreeJson() data: " + data);
		fnLog("ERROR fnLoadDhtmlxTreeJson() callstack : " + showCallStack());}} catch(e) {}if(callbackFnc == undefined || callbackFnc == null){ callbackFnc="";}
		ajaxTreeGridLoadV7("<c:url value='/getDhtmlV7ItemTreeListByDim.do'/>", data, "", false, noMsg, msg, callbackFnc);
	}
	
	function ajaxTreeGridLoadV7(url, data, target, debug, noMsg, msg, callback) {
		$.ajax({
			url: url,type: 'post',data: data
			,error: function(xhr, status, error) {('#loading').fadeOut(150);var errUrl = "errorPage.do";var errMsg = "status::"+status+"///error::"+error;var callback = "";var width = "300px";var height = "300px";var callBack = function(){};fnOpenLayerPopup(errUrl,errMsg,callBack,width,height);}
			,beforeSend: function(x) {$('#loading').fadeIn();if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}	}
			,success: function(result){
				$('#loading').fadeOut(3000);if(debug){alert(result);}	if(result == 'error' || result == ""){if(noMsg != 'Y'){alert(msg);}
				}else{
					//console.log("result :"+result);
					result = eval(result);
					if(result != ""){
						fnTreeGridList(result);
					}
				}
				if(callback== null || callback==""){}
				else{ eval(callback);}
			}
		});
	}
	
	function fnTreeGridList(resultdata){
		var treeGrid = new dhx.TreeGrid("treegrid_container", {
			columns: [
				{ width: 300, id: "value",  header: [{ text: "명칭" }], htmlEnable: true },
				{  hidden: true, width: 250, id: "parent",  type: "string",  header: [{ text: "PREE TREE ID"}] },
				{  hidden: true, width: 250, id: "id",         type: "string",  header: [{ text: "TREE ID" }] },
				${treegridHeader}
			], 
			autoWidth: true,
			data: resultdata
		});
	}
	
</script>

<body>
	<div class="mgL20 mgT20" style="width:100%;height:100%;">
	<div id="treegrid_container" style="width:1200px; height:600px"></div>
	</div>
</body>
</html>