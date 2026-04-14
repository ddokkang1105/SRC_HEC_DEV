<%@ page language ="java"
	contentType="text/html; charset=UTF-8" 
	import="java.text.SimpleDateFormat"
%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<html>
<head>
<title>YNCC WorkFlow</title>
<jsp:include page="/WEB-INF/jsp/template/uiInc.jsp" flush="true"/>
<style type="text/css">body,html {overflow-y:hidden}</style>
<script src="${pageContext.request.contextPath}/cmm/js/jquery/jquery.js" type="text/javascript"></script>
</head>

<script type="text/javascript">
	var url = "${docUrl}";
	var resultCode = "${resultCode}";

	$(document).ready(function(){
		if(resultCode == "S") {
			var $f = $("#thisForm");
		    $f.attr("action", url).attr("method", "post");
		    $f[0].submit();
		}
		else { 
			alert("${xmsgs}");
		}
	});
</script>

<body topmargin="0" leftmargin="0" style="align:center;">
<form id="thisForm" method="post" action=""></form>
</body>
</html>
