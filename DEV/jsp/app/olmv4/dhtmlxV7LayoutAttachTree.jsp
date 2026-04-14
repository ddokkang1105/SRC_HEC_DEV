<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
<head>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />

<link rel="stylesheet" href="${root}cmm/js/dhtmlx/dhtmlxLayout/codebase/ver7.1.8/layout.css?v=7.1.8">

	
	<body>
		<script>
	$(document).ready(function(){
			fnLayoutLoad();
	});
	
	var scrpt = new Object();
	scrpt.treeTop="<div id='schTreeArea'>";
	scrpt.treeTop=scrpt.treeTop+"<input type='text' class='tree_search' id='schTreeText' style='width:80px;ime-mode:active;' placeholder='Search' value='' text=''/>&nbsp;&nbsp;";
	scrpt.treeTop=scrpt.treeTop+"<a onclick='searchTreeText(\"1\")'><img src='${root}cmm/common/images/btn_icon_search.png'></a>"; 
	scrpt.treeTop=scrpt.treeTop+"<a onclick='searchTreeText(\"2\")'><img src='${root}cmm/common/images/icon_arrow_left.png'></a>|<a onclick='searchTreeText(\"3\")'><img src='${root}cmm/common/images/icon_arrow_right.png'></a>&nbsp;";
	scrpt.treeTop=scrpt.treeTop+"<a onclick='fnRefreshTree(null,true)'><img src='${root}cmm/common/images/img_refresh.png'></a>";
	scrpt.treeTop=scrpt.treeTop+"</div>";scrpt.cntnTop="";
	
	var layout;
	function fnLayoutLoad(){		
		layout = new dhx.Layout("layout", {
			
			type: "line",					
			cols: [
				{
					type: "line",		
					rows: [
						{
							id: "leftbarheader",
							height: "45px",
						},
						{
							id: "leftbar",
							//width: "240px"
						}
					]
					,collapsable: true,
					width: "240px",
					resizable: true,
					
				},
		        {
		            id: "С3",
		            html: "CONTENT",
		        },
			]
		});
		
		fnTreeLoad();
		
	}
	
	var tree;
	function fnTreeLoad(){
		var d=fnSetMenuTreeDataV7();
		tree = new dhx.Tree("tree");
		fnLoadDhtmlxTreeJsonV7(tree, d.key, d.cols, d.data, "PAL0101"); 
	}
	
	function fnSetMenuTreeDataV7(data){
		if(data == 'undefined' || data == null){data = "";}
		var result = new Object();
		result.title = "${title}";
		result.key = "menu_SQL.menuTreeList";
		result.header = "TREE_ID,PRE_TREE_ID,TREE_NM";
		// result.cols = "value|id|parent";
		result.cols = "TREE_ID|PRE_TREE_ID|TREE_NM";
		result.data = data ;
		return result;
	}
	
	function fnLoadDhtmlxTreeJsonV7(tree, key, cols, value, select, noMsg, callbackFnc) {
		var msg = "${WM00018}";
		var data = "menuId="+key;
		data += "&cols=" + cols;
		data += "&SelectMenuId=" + select;
		data += "&" + value;
		
		try{if(key==null || key == ""){fnLog("ERROR fnLoadDhtmlxTreeJson() data: " + data);
		fnLog("ERROR fnLoadDhtmlxTreeJson() callstack : " + showCallStack());}} catch(e) {}if(callbackFnc == undefined || callbackFnc == null){ callbackFnc="";}
		ajaxTreeLoadV7("<c:url value='/jsonDhtmlxTreeListV7.do'/>", data, tree, false, noMsg, msg, callbackFnc);
	
	}
	
	function ajaxTreeLoadV7(url, data, target, debug, noMsg, msg, callback) {
		$.ajax({
			url: url,type: 'post',data: data
			,error: function(xhr, status, error) {('#loading').fadeOut(150);var errUrl = "errorPage.do";var errMsg = "status::"+status+"///error::"+error;var callback = "";var width = "300px";var height = "300px";var callBack = function(){};fnOpenLayerPopup(errUrl,errMsg,callBack,width,height);}
			,beforeSend: function(x) {$('#loading').fadeIn();if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}	}
			,success: function(result){
				$('#loading').fadeOut(3000);if(debug){alert(result);}	if(result == 'error' || result == ""){if(noMsg != 'Y'){alert(msg);}
				}else{
					result = eval(result);
					target.data.parse(result);
					layout.getCell("leftbarheader").attachHTML(scrpt.treeTop);
					layout.getCell("leftbar").attach(target);
				}
				if(callback== null || callback==""){}
				else{ eval(callback);}
			}
		});
	}
	
	function searchTreeText(type){
		var schText=$("#schTreeText").val();
		if(schText==""){alert("${WM00045}"); return false;}
		if(type=="1"){
			tree.findItem(schText,false,true);
		}else if(type=="2"){
			tree.findItem(schText,true,false);
		}else if(type=="3"){
			tree.findItem(schText,false,false);
		}
	}

	
</script>
		<div class="dhx_sample-container__widget" id="layout"></div>
	</body>
	</html>