<%@ page language ="java"
	contentType="text/html; charset=UTF-8" 
	import="java.text.SimpleDateFormat"
%>

<%--
/* ------------------------------------------------------------------------
 * @source  : olmLinkERPPopup.jsp
 * @desc    : Mnado ERP 프로그램 연결
 * ------------------------------------------------------------------------
 * SAP Test Environment
 * Copyright(c) 2016 SMARTFACTORY,  All rights reserved.
 * ------------------------------------------------------------------------
 * VER  DATE         AUTHOR             DESCRIPTION
 * ---  -----------  -----------------  -----------------------------------
 * 1.0  2017.03.20   SMARTFACTORY                Initial
 * ------------------------------------------------------------------------ */
--%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<html>
<head>
<title>Mando Popup</title>
<jsp:include page="/WEB-INF/jsp/template/uiInc.jsp" flush="true"/>
<style type="text/css">body,html {overflow-y:hidden}</style>
<script src="${pageContext.request.contextPath}/cmm/js/jquery/jquery.js" type="text/javascript"></script>

<body topmargin="0" leftmargin="0">
<form id="thisForm" method="post" action="" target="Frame">
	<input type="hidden" id="${parameter}" name="${parameter}" value="${pm_value}"/>
</form>
<form id="ssoForm" method="get" action="" target="Frame">
</form>

<iframe name="Frame" id="Frame" style="width:100%;height:100%;" frameborder="0"></iframe>

<script type="text/javascript">
	var ssoYN = "${ssoYN}";
	var url = "${url}";
	var ssoUrl = "${ssoUrl}";

	$(document).ready(function(){
		
		if(ssoYN == "Y") {
			$('#fileDownLoading').removeClass('file_down_off');
			$('#fileDownLoading').addClass('file_down_on');
			var iframe = $("#Frame");

			iframe.css('display','none');
			$("#ssoForm").attr('action',ssoUrl);
			$("#ssoForm").submit();
			setTimeout(function(){
				$('#fileDownLoading').addClass('file_down_off');
				$('#fileDownLoading').removeClass('file_down_on');
				$("#Frame").css('display','block');
				$("#thisForm").attr('action',url);
				$("#thisForm").submit();
			},1000);
		}
		else {
			$("#thisForm").attr('action',url);
			$("#thisForm").submit();
		}
		
	});
</script>

<div id="fileDownLoading" class="file_down_off">
	<img src="${root}${HTML_IMG_DIR}/loading_circle.gif"/>
</div>

</body>
</html>
