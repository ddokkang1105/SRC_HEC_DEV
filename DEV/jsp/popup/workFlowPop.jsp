<%@page import="java.sql.PreparedStatement"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00065" var="WM00065"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="Object"/>

<title>${menu.LN00096}</title>
</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>

<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용

	$(document).ready(function() {
		fnSelect('getLanguageID', '', 'langType', '${LanguageID}','Select');
	});
	
	// [Add] click
	function saveWorkFlow() { 	
		//if(confirm("저장하시겠습니까?")){
		if(confirm("${CM00001}")){		
			var url = "admin/saveWorkFlow.do";
			ajaxSubmit(document.WorkFlowFrm, url, "blankFrame");
		}
	}
	// [save] 이벤트 후 처리
	function selfClose() {
		//var opener = window.dialogArguments;
		opener.doOTSearchList();
		self.close();
	}
	
	function fnOnlyEnNum(obj){
		var regType = /^[A-Za-z0-9*]+$/;
        if(!regType.test(obj.value)) {
            obj.focus();
            $(obj).val( $(obj).val().replace(/[^A-Za-z0-9]/gi,"") );
            return false;
        }
    }
</script>
<body>
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00005}</p>
	</div>
	<form name="WorkFlowFrm" id="WorkFlowFrm" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />
		 <input type="hidden" id="LanguageID" name="LanguageID" value="${LanguageID}"> 
		  <div class="mgT5 mgL5 mgR5">
		<table id="newObject" class="tbl_blue01" width="100%;">
			<colgroup>
				<col width="25%">
				<col>
			</colgroup>
		
			<!-- ID -->		
			<tr>
				<th class="viewtop">${menu.LN00015}</th>
				<td  class="last viewtop">
					<input type="text" class="text" id="objWFID" name="objWFID" value="${Maxlovcode}"  onkeyup="fnOnlyEnNum(this);" onchange="fnOnlyEnNum(this);"/>
				</td>
			</tr>
			
			<!-- 명칭 -->
			<tr>
				<th>${menu.LN00028}</th>
				<td  class="last">
					<input type="text" class="text" id="objName" name="objName" />
				</td>
			</tr>
			
			<!-- 개요 -->	
			<tr>
				<th>${menu.LN00035}</th>
				<td  class="last">
					<input type="text" class="text" id="objDescription" name="objDescription">
				</td>
			</tr>
			
		</table>
</div>
		<div class="alignBTN">
			<button class="cmm-btn2 mgR5" style="height: 30px;" onclick="saveWorkFlow()" value="Save">Save</button>
		</div>

	</form>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display: none" frameborder="0"></iframe>
</body>
</html>