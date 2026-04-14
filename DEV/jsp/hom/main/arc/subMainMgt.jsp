<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>


<script type="text/javascript">

	$(document).ready(function(){
		var url = "${pageUrl}.do";
        var target = "subMianContent";
        var data = "defMenuItemID=${defMenuItemID}&arcCode=${arcCode}&scrnUrl=${scrnUrl}";
        ajaxPage(url, data, target);
	});
	

</script>
</head>

<body id="subMain">	
     <div id="subMianContent">     	
     </div>
</body>
</html>


