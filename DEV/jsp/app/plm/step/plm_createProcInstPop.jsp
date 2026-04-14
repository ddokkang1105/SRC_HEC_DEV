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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="${menu.LN00125}"/>
 
<script type="text/javascript">
	function fnCreateProjectCharter() {
		if(confirm("${CM00001}")){			
			var modelList = $("#modelList").val();
			if(modelList == ""){alert("${WM00034}"); return;}
			var url = "plm_newProcInst.do";
			ajaxSubmit(document.procInstFrm, url);
		}
	}
	
	function fnCallBackSubmit() {
		opener.doSearchList();
		self.close();
	}
</script>
</head><body>
<form name="procInstFrm" id="procInstFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="p_itemID" name="p_itemID"  value="${p_itemID}" />
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;Create Process Instance</p>
	</div>
	
	<div id="objectInfoDiv" style="margin:0px 10px;" >
	<table style="table-layout: fixed;" width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_blue01 mgT10">
		<colgroup>
			<col width="30%">
			<col>
		</colgroup>
		<tr>
			<th>${menu.LN00131}</th>
			<td class="alignL last">
				<select id="pjtList" name="pjtList" class="sel">
			    		<option value=''>Select</option>
	           	   		<c:forEach var="i" items="${pjtList}">
	                   		<option value="${i.ProjectID}">${i.Name}</option>
	           	    	</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<th>${menu.LN00125}</th>
			<td class="alignL last">
				<select id="modelList" name="modelList" class="sel">
			    		<option value=''>Select</option>
	           	   		<c:forEach var="i" items="${modelList}">
	                   		<option value="${i.ModelID}">${i.Name}</option>
	           	    	</c:forEach>
				</select>
			</td>
		</tr>
	</table>
	<div class="alignBTN mgB5 mgR10">
		<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnCreateProjectCharter()" type="button"></span>
	</div>
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none;width:0px;height:0px;"></iframe>
</body></html>