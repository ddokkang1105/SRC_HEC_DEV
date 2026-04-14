<%@ page language ="java"
	contentType="text/html; charset=UTF-8" 
	import="java.text.SimpleDateFormat"
%>

<%--
/* ------------------------------------------------------------------------
 * @source  : runERPSystem.jsp
 * @desc    : DAESANG 용 ERP System Link Popup
 * ------------------------------------------------------------------------
 * VER  DATE         AUTHOR             DESCRIPTION
 * ---  -----------  -----------------  -----------------------------------
 * 1.0  2019.09.17   SMARTFACTORY       Initial
 * ------------------------------------------------------------------------ */
--%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<html>
<head>
<title>DAESANG Popup</title>
<jsp:include page="/WEB-INF/jsp/template/uiInc.jsp" flush="true"/>
<style type="text/css">body,html {overflow-y:hidden}</style>
<script src="${pageContext.request.contextPath}/cmm/js/jquery/jquery.js" type="text/javascript"></script>

<body topmargin="0" leftmargin="0">
<form id="thisForm" method="post" action="" target="Frame">
	<input type="hidden" id="userid" name="userid" value="${userid}"/>
	<input type="hidden" id="systemType" name="systemType" value="BPA"/>
	<input type="hidden" id="TCode" name="TCode" value="${TCode}"/>
	<input type="hidden" id="Technique" name="Technique" value="SSD"/>
</form>

<script type="text/javascript">
	var ssoYN = "N";
	var url = "${url}";
	//var ssoUrl = "${ssoUrl}";

	$(document).ready(function(){
			
		$("#thisForm").attr('action',url);
		$("#thisForm").submit();	
		self.close();
		
	});
</script>
USER&nbsp;ID&nbsp;BEFORE&nbsp;ENCRYPT&nbsp;:&nbsp;${beforeID}<br/>
USER&nbsp;ID&nbsp;DATA&nbsp;ADD&nbsp;:&nbsp;${loginid}<br/>
TCode&nbsp;:&nbsp;${TCode}
<div id="fileDownLoading" class="file_down_off">
	<img src="${root}${HTML_IMG_DIR}/loading_circle.gif"/>
</div>

</body>
</html>
