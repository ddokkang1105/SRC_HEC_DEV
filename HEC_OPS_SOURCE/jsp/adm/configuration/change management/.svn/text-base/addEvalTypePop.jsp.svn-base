<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<script type="text/javascript">
	//var chkReadOnly = true;
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00116" var="WM00116" arguments="${menu.LN00015}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00015}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="Name"/>
 
<script type="text/javascript">
	$(document).ready(function(){
		document.getElementById('editArea').style.height = (setWindowHeight() - 40)+"px";			
		window.onresize = function() {
			document.getElementById('editArea').style.height = (setWindowHeight() - 40)+"px";	
		};
		$("#evTypeCode").focus();
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function fnSaveEvalType(){
		var evTypeCode = $("#evTypeCode").val();
		var name = $("#name").val();
		
		if(evTypeCode == "") {alert("${WM00034_1}"); $("#evTypeCode").focus(); return;}
		if(name == "") {alert("${WM00034_2}"); $("#name").focus(); return;}
		
		if(confirm("${CM00001}")){
			ajaxSubmit(document.emailFrm, "saveEvalType.do");
		}
	}
	
	function selfClose(){
		opener.fnCallBack();
		self.close();
	}
	
	function fnDuplicatedID(){
		alert("${WM00116}");
		$("#evTypeCode").val("");
		$("#evTypeCode").focus();
	}
</script>
</head><body>
<form name="emailFrm" id="emailFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="viewType" name="viewType" value="N" />
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Evaluation Type ${menu.LN00128}</p>
	</div>
	
	<div id="editArea" style="margin:5px 10px;">
		<table class="tbl_blue01">
			<colgroup>
				<col width="20%">
				<col>
			</colgroup>
		<tr>
			<th class="viewline alignC">${menu.LN00015}</th>
			<td class="alignL last"><input type="text" id="evTypeCode" name="evTypeCode" value="" class="text"></td>
		</tr>
		<tr>
			<th class="viewline alignC">${menu.LN00028}</th>
			<td class="alignL last"><input type="text" id="name" name="name" value="" class="text"></td>
		</tr>
		<tr>
			<th class="viewline alignC">${menu.LN00035}</th>
			<td class="alignL last"><input type="text" id="description" name="description" value="" class="text"></td>
		</tr>
		</table>
		<div class="alignBTN mgB5 mgR10">
			<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnSaveEvalType()" type="submit"></span>
		</div>
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none;width:0px;height:0px;"></iframe>
</body></html>