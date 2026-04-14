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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="${menu.LN00015}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="Value"/>

<title>${menu.LN00096}</title>
</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>

<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용
	var regexp = /^[A-Za-z0-9+]*$/; //code명 정규식 (숫자/영문)
	
	$(document).ready(function() {
		
	});

function SaveNewLov(){	
	var LovID = $('#LovID').val();
	if(confirm("${CM00001}")){		
		if(LovID == ""){alert("${WM00034}"); return false;}
		else if($("#LovValue").val() == ""){alert("${WM00034_2}"); return false;}
		else if(!regexp.test(LovID)){alert('코드명은 영문과 숫자만 가능합니다.'); return false;};
		
		var url = "saveListOfValue.do";
		var data = 	"&LovID=" + $("#LovID").val() + 
					"&LovValue="+ replaceText($("#LovValue").val())+ 
					"&languageID=${languageID}" + 
					"&TypeCode="+ $("#TypeCode").val();									
		var target="LovFrame";
		ajaxPage(url, data, target);
	}	
}

function replaceText(avg) {
	var text = "<and>";
	return avg.replace(/&/gi, text);
}
	
//[save] 이벤트 후 처리
function selfClose() {
	//var opener = window.dialogArguments;
	opener.urlReload("${languageID}");
	self.close();
}
	
</script>
<body>
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00005}</p>
	</div>	
	<form name="LovList" id="LovList" method="post" action="saveListOfValue.do" onsubmit="return false;">
		<input type="hidden" id="TypeCode" name="TypeCode" value="${TypeCode}">
		
		<div class="mgT5 mgL5 mgR5">
		<table id="newLAttrLov" class="tbl_blue01" width="100%;">
			<colgroup>
				<col width="25%">
				<col>
			</colgroup>
			
			<!-- LovCode -->
			<tr>	
				<th>${menu.LN00015}</th>
				<td class="last">
					<input type="text" class="text" id="LovID" name="LovID" value="" style="width:100%">	
				</td>
			</tr>
			<tr>
				<th>Value</th>
				<td class="last">
					<input type="text" class="text" id="LovValue" name="LovValue">
				</td>
			</tr>
		</table>
		</div>
		<div class="alignBTN mgR10">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				&nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="SaveNewLov();"></span>
			</c:if>
		</div>
	</form>
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="LovFrame" id="LovFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>

</body>
</html>