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
<script type="text/javascript">
	var chkReadOnly = true;
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
 
<script type="text/javascript">
	$(document).ready(function(){
		document.getElementById('editArea').style.height = (setWindowHeight() - 40)+"px";			
		window.onresize = function() {
			document.getElementById('editArea').style.height = (setWindowHeight() - 40)+"px";	
		};
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function fnSaveEmailForm(){
		if(confirm("${CM00001}")){
			ajaxSubmit(document.emailFrm, "saveEmailForm.do");
		}
	}
	
	function selfClose(){
		self.close();
	}
</script>
</head><body>
<form name="emailFrm" id="emailFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="emailCode" name="emailCode" value="${emailForm.EmailCode}" />
	<input type="hidden" id="viewType" name="viewType" value="EF" />
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Email Form ${menu.LN00103}</p>
	</div>
	
	<div id="editArea" style="margin:5px 10px;">
		<table class="tbl_blue01">
			<colgroup>
				<col width="12%">
				<col>
			</colgroup>
		<tr>
			<th class="viewline alignC">${menu.LN00015}</th>
			<td class="alignL last">${emailForm.EmailCode}</td>
		</tr>
		<tr>
			<th class="viewline alignC">Form</th>
			<td class="alignL last">
				<textarea class="tinymceText" style="width:100%;height:400px;" readonly="readonly">
				<div class="mceNonEditable">${emailForm.HTMLForm}</div></textarea>
			</td>
		</tr>
		</table>
		
		 <c:if test="${fn:length(emailForm) > 0 and sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<div class="alignBTN mgB5 mgR10">
<!-- 				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnSaveEmailFormC()" type="submit"></span> -->
			</div>
		</c:if>
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none;width:0px;height:0px;"></iframe>
</body></html>