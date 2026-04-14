<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">

	$(document).ready(function() {
		initSaveSymbolAttr();
		
		var myCP;
		myCP = dhtmlXColorPicker(["fontColor","strokeColor","fillColor","labelBackgroundColor"]);
		myCP.setColor([0,0,0]);
	});
	
	function initSaveSymbolAttr() {
		$("#editSymTypeAttrDp").attr('style', 'display: block');	
		$("#saveBtn").attr('style', 'display: block');	

		$("#mdpID").val('${mdpID}');
		$("#attrTypeCode").val('${attrTypeCode}');
		$("#displayType").val('${displayType}');
		$("#x").val('${x}');
		$("#y").val('${y}');
		$("#width").val('${width}');
		$("#height").val('${height}');
		$("#fontSize").val('${fontSize}');
		$("#fontColor").val('${fontColor}');
		$("#fontFamily").val('${fontFamily}');
		$("#fontStyle").val('${fontStyle}');
		$("#strokeWidth").val('${strokeWidth}');
		$("#strokeColor").val('${strokeColor}');
		$("#fillColor").val('${fillColor}');
		$("#labelBackgroundColor").val('${labelBackgroundColor}');
		$("#scrnMode").val('${scrnMode}');
		$("#newYN").val('${newYN}');
		if('${html}' == "1"){
		    $("#html").attr("checked", true);
			$("#html").val("1");
		} else {
		    $("#html").attr("checked", false);
			$("#html").val("");
		}
 
	}
	
	function CheckBox(){
		var html = document.getElementsByName("html");
		if(html[0].checked == true){
			$("#html").val("1");
		}else{
			$("#html").val("");
		}
	}

	function fnCallBack(){
		opener.urlReload();
		self.close();
	}
	
	function fnSaveSymbolAttrDp(){
		if(confirm("${CM00001}")){			
			var url = "admin/saveSymbolAttrDp.do";
			var target = "sFrame";		
			ajaxSubmitNoAdd(document.allocSymTypeAttrDpForm, url, target);
		}
	}
	
</script>

</head>
<body>
<div class="child_search_head">
	<c:if test="${newYN eq 'Y'}">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${Name} > Add Model Display</p>
	</c:if>
	<c:if test="${newYN eq 'N' || ''}">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${Name} > Edit Model Display</p>
	</c:if>
</div>
<form name="allocSymTypeAttrDpForm" id="allocSymTypeAttrDpForm" action="*" method="post" onsubmit="return false;">
	<input type="hidden" id="symTypeCode" name="symTypeCode" value="${symTypeCode}">
	<input type="hidden" id="DisplayType" name="DisplayType" />
	<input type="hidden" id="newYN" name="newYN" >
	<input type="hidden" id="mdpID" name="mdpID" >
	<c:if test="${Category ne 'MDL'}">
	<div class="SubinfoTabs mgL1 mgT20">
		<ul>
			<li id="pliug1" class="on"><a><span>Symbol Display</span></a></li>
		</ul>
	</div>
	</c:if>
		
	<div id="editSymTypeAttrDp" name="editSymTypeAttrDp" class="mgT5 mgL10 mgR10" style="display:none">
	<table id="modSortNum" class="tbl_blue01" width="100%"   cellpadding="0" cellspacing="0">
		<tr>
			<th class="viewtop">Category</th>
			<td class="viewtop">
				<input type="text" class="text" id="Category" name="Category" style="border:0px;background-color:#ffffff;" value="${Category}" readonly=true/>
			</td>
			<th class="viewtop">Attribute Type</th>
			<td class="viewtop"><input type="text" class="text" id="attrTypeCode" name="attrTypeCode"  /></td>
			<th class="viewtop">Display Type</th>
			<td class="viewtop">
				<select id="displayType" name="displayType" class="sel">
					<option value="">Select</option>
					<option value="ID">ID</option>
					<option value="Image">Image</option>
					<option value="Text">Text</option>
					<option value="Animation">Animation</option>
					<option value="MOT">MOT</option>
				</select>
			</td>
			<th class="viewtop">HTML</th>
			<td class="viewtop last"><input type="checkbox" name="html" id="html" onclick="CheckBox()" /></td>
		</tr>
		<tr>
			<th>X</th>
			<td><input type="number" class="text" id="x" name="x" /></td>
			<th>Y</th>
			<td><input type="number" class="text" id="y" name="y" /></td>
			<th>Width</th>
			<td><input type="number" class="text" id="width" name="width" /></td>
			<th>Height</th>
			<td class="last"><input type="number" class="text" id="height" name="height" /></td>
		</tr>
		<tr>
			<th>Font Size</th>
			<td><input type="number" class="text" id="fontSize" name="fontSize" /></td>
			<th>Font Color</th>
			<td><input type="text" class="text" id="fontColor" name="fontColor" /></td>
			<th>Font Style</th>
			<td><input type="number" class="text" id="fontStyle" name="fontStyle" /></td>
			<th>Font Family</th>
			<td class="last"><input type="text" class="text" id="fontFamily" name="fontFamily" /></td>
		</tr>
		<tr>
			<th>StrokeWidth</th>
			<td><input type="number" class="text" id="strokeWidth" name="strokeWidth" /></td>
			<th>StrokeColor</th>
			<td><input type="text" class="text" id="strokeColor" name="strokeColor" /></td>
			<th>FillColor</th>
			<td><input type="text" class="text" id="fillColor" name="fillColor" /></td>
			<th>LabelBackgroundColor</th>
			<td class="last"><input type="text" class="text" id="labelBackgroundColor" name="labelBackgroundColor" /></td>
		</tr>
		<tr>
			<th>ScrnMode</th>
			<td>
				<select id="scrnMode" name="scrnMode" class="sel">
					<option value="C">C</option>
					<option value="E">E</option>
					<option value="V">V</option>
					<option value="I">I</option>
				</select>
			</td>
			<td colspan=6 class="last"></td>
		</tr>
	</table>
	</div>	
	<div class="alignBTN pdR10" id="saveBtn" style="display: none;">

		<button class="cmm-btn2 mgR10 floatR " style="height: 30px;" onclick="fnSaveSymbolAttrDp()"  value="save">Save</button>
	</div>
	<div class="schContainer" id="schContainer">
		<iframe name="sFrame" id="sFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
</form>
</body>
</html>