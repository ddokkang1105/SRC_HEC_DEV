<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagIncV7.jsp"%>
<html>

<script type="text/javascript">
$(document).ready(function(){
	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&classCode=${rootClassCode}&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}";
	fnSelect('rootItemID', data, 'getTreeRootItemList', '${rootItemID}', 'Select');
	fnSelect('dimTypeID', data, 'getDimTypeId', '${dimTypeID}', 'Select');

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
	result.key = "report_SQL.itemTreeListByDim";
	result.header = "TREE_ID,PRE_TREE_ID,TREE_NM";
	result.cols = "TREE_ID|PRE_TREE_ID|TREE_NM${dimcols}";
	result.data = data ;
	return result;
}


function fnLoadDhtmlxTreeGridJsonV7(key, cols, value, select, noMsg, callbackFnc) {
	var msg = "${WM00018}";
	var cxnTypeCode = "${cxnTypeCode}";
	var rootClassCode = "${rootClassCode}";
	var rootItemID = "${rootItemID}";
	var dimTypeID = "${dimTypeID}";
	var selectedDimClass = "${selectedDimClass}";
	var maxTreeLevel = "${maxTreeLevel}";
	var reportCode = "${reportCode}";

	var data = "menuId="+key;
		data += "&cols=" + cols;
		data += "&SelectMenuId=" + select;
		data += "&" + value;
		data += "&cxnTypeCode=" + cxnTypeCode + "&rootClassCode=" + rootClassCode + "&dimTypeID=" + dimTypeID 
			 + "&selectedDimClass=" + selectedDimClass + "&maxTreeLevel=" + maxTreeLevel + "&reportCode=" + reportCode + "&rootItemID=" + rootItemID;
	
	try{if(key==null || key == ""){fnLog("ERROR fnLoadDhtmlxTreeJson() data: " + data);
	fnLog("ERROR fnLoadDhtmlxTreeJson() callstack : " + showCallStack());}} catch(e) {}if(callbackFnc == undefined || callbackFnc == null){ callbackFnc="";}
	ajaxTreeGridLoadV7("<c:url value='/getItemTreeListByDim.do'/>", data, "", false, noMsg, msg, callbackFnc);
}

function ajaxTreeGridLoadV7(url, data, target, debug, noMsg, msg, callback) {
	$.ajax({
		url: url
		,type: 'post'
		,data: data
		,error: function(xhr, status, error) {$('#loading').fadeOut(150);var errUrl = "errorPage.do";var errMsg = "status::"+status+"///error::"+error;var callback = "";var width = "300px";var height = "300px";var callBack = function(){};fnOpenLayerPopup(errUrl,errMsg,callBack,width,height);}
		,beforeSend: function(x) {$('#loading').fadeIn();if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}	}
		,success: function(result){
			$('#loading').fadeOut(3000);
			if(debug){alert(result);}	
			if(result == 'error' || result == ""){
				if(noMsg != 'Y'){alert(msg);}
			}else{
				result = JSON.parse(result);
				if(result != ""){
					fnTreeGridList(result);
				}
			}
			if(callback== null || callback=="" || callback == undefined){} 
			else if (typeof callback === "function") {
		        callback(); 
		    }
		}
	});
}

var treeGrid;

function fnTreeGridList(resultdata){
	treeGrid = new dhx.Grid("treegrid_container", {
		type : "tree",
		columns: [
			{ width: 300, id: "value",  header: [{ text: "명칭" , align: "center" }], align: "left", htmlEnable: true },
			{  hidden: true, width: 250, id: "parent",  type: "string",  header: [{ text: "PREE TREE ID"}] },
			{  hidden: true, width: 250, id: "id",      type: "string",  header: [{ text: "TREE ID" }] },
			${treegridHeader}
		], 
		autoWidth: true,
		selection: "row",
		resizable: true,
		data: resultdata
	});
}

function fnRowSelect(row){
	var itemID = row.id;
	fnOpenItemPop(itemID);
}	

function fnOpenItemPop(avg){
	var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop";
	var w = 1200;
	var h = 900; 
	itmInfoPopup(url,w,h,avg);
}

function fnSearchProchSum(){
	var url = "itemTreeListByDim.do";
	var target = "itemTreeListByDimDiv";		
	var data = "reportCode=${reportCode}&rootItemID="+$("#rootItemID").val()+"&dimTypeID="+$("#dimTypeID").val()+"&maxTreeLevel=${maxTreeLevel}"+"&cxnTypeCode=${cxnTypeCode}"+"&rootClassCode=${rootClassCode}&selectedDimClass=${selectedDimClass}";
	ajaxPage(url, data, target);
}


</script>
<div id="itemTreeListByDimDiv">
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 3px 0 3px 0"><img src="${root}${HTML_IMG_DIR}/img_process.png">&nbsp;&nbsp;${title}</h3>
	</div>
	<div style="height:10px"></div>
	<div class="child_search" id="pertinentSearch">
		<ul>
			<li>&nbsp;&nbsp;L1&nbsp;&nbsp;
				<select id="rootItemID" name="rootItemID" style="width:120px;"></select>
			</li>
		   <li>&nbsp;&nbsp;Dimension Type&nbsp;&nbsp;
				<select id="dimTypeID" name="dimTypeID" style="width:120px;"></select>  <!-- OnChange="fnChangeDimValue(this.value); -->
			</li>
			<li><input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="fnSearchProchSum()"/></li>
			<li class="floatR pdR20" >
				<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excelPrc" OnClick="fnGridExcelDownLoad(treeGrid);"></span>	
			</li>			
		</ul>
	</div>
	<div id="gridDiv" class="mgB10 mgT5">
		<div id="treegrid_container" style="width:1200px; height:600px"></div>
	</div>
</div>
