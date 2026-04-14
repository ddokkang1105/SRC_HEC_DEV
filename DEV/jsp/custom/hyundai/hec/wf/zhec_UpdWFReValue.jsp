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
 <form id="thisForm" enctype="multipart/form-data" method="post" action="">
 <input type="hidden" id="ApprovalStatus" name="ApprovalStatus" value="DRAFT"/>
 <input type="hidden" id="ApprovalType" name="ApprovalType" value="drafter"/>
 <input type="hidden" id="InterfaceID" name="InterfaceID" value="11"/>
 <input type="hidden" id="CompanyCode" name="CompanyCode" value="H139"/>
 <input type="hidden" id="DocID" name="DocID" value="${IgyDocId}"/>
 <input type="hidden" id="InterfacePID" name="InterfacePID" value="1"/>
 <input type="hidden" id="LangType" name="LangType" value="ko-KR"/>
</form>

<script type="text/javascript">
	var url = "${url}?wsdl";

	$(document).ready(function(){
		$("#thisForm").attr('action',url);
		$("#thisForm").submit();
	});
</script>

</body>
</html>
