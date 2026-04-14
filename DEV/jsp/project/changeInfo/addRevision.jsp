<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="${menu.LN00003}"/> 


<script type="text/javascript">
	
	function fnSaveRevision() {
		var description = $("#Description").val();
		if(description == ""){ alert("${WM00034}"); return;}
		if(confirm("${CM00001}")){
			var url = "saveRevision.do";
			ajaxSubmit(document.revFrm, url);
		}
	}
	
	function fnCallBack(){
		opener.urlReload();
		self.close();
	}
	
</script>
</head>
<body>
<div id="revDiv" style="padding: 0 6px 6px 6px;">
<form name="revFrm" id="revFrm" method="post" action="#" onsubmit="return false;">	
	<input type="hidden" id="documentID" name="documentID" value="${documentID}" >
	<input type="hidden" id="objectType" name="objectType" value="${objectType}" >
	<input type="hidden" id="changeSetID" name="changeSetID" value="${changeSetID}" >
	<input type="hidden" id="docCategory" name="docCategory" value="${docCategory}" >
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 6px 0 6px 0"><img src="${root}${HTML_IMG_DIR}/img_revision.png">&nbsp;&nbsp;Revison&nbsp;${menu.LN00128}</h3>
	</div>
	<div id="crDiv" class="hidden" style="width:100%;">
		<table class="tbl_brd mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">	
			<colgroup> 
				<col width="98%">		
			</colgroup>
			<tr>
				<td class="sline tit last alignL pdR10">  
		   			<textarea id="Description" name="Description" style="width:100%;height:180px;"></textarea>
				</td>
			</tr>
		</table>
		<div class="alignBTN">
			<span id="viewSave" class="btn_pack medium icon"><span class="save"></span>
			<input value="Save" type="submit" onclick="fnSaveRevision()"></span>&nbsp;
		</div>
	</div>
</form>
</div>
<div style="display:none;">
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</div>
</body>
</html>
