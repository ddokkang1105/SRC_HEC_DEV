<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<c:url value="/" var="root"/>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico" />
<c:if test="${!empty htmlTitle}"><script>parent.document.title="${htmlTitle}";</script></c:if>
<script src="${pageContext.request.contextPath}/cmm/js/jquery/jquery.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/cmm/js/tripledes.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/cmm/js/mode-ecb.js" type="text/javascript"></script>

<script type="text/javascript">
$(document).ready(function(){ 
	$("#testMD").submit();
});
</script>
</head>
<body>	
<form id="testMD" name="testMD" action="/indexMD.do" method="post">
<input type="hidden" name="PM_SABUN" value="${sabun}"/>
</form>
</body>
</html>