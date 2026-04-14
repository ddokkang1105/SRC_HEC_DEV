<%@ page language ="java"
	contentType="text/html; charset=UTF-8" 
	import="java.text.SimpleDateFormat"
%>

<%--
/* ------------------------------------------------------------------------
 * @source  : runLEPTransaction.jsp
 * @desc    : Daelim BP 연결 Popup
 * ------------------------------------------------------------------------
 * VER  DATE         AUTHOR             DESCRIPTION
 * ---  -----------  -----------------  -----------------------------------
 * 1.0  2018.01.18   SMARTFACTORY       Initial
 * ------------------------------------------------------------------------ */
--%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<html>
<head>
<title>Hway WorkFlow Popup</title>
<jsp:include page="/WEB-INF/jsp/template/uiInc.jsp" flush="true"/>
<style type="text/css">body,html {overflow-y:hidden}</style>
<script src="${pageContext.request.contextPath}/cmm/js/jquery/jquery.js" type="text/javascript"></script>

<body topmargin="0" leftmargin="0">
<form id="thisForm" method="post" action="">
</form>

<script type="text/javascript">
	var url = "${returnUrl}";
	var resultCode = "${resultCode}";

	$(document).ready(function(){
		
		if(resultCode == "S") {
			$("#thisForm").attr('action',url);
			$("#thisForm").submit();
		}
		else { 
			alert("${errMsg}");
		}
	});
</script>

</body>
</html>
