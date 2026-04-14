<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
	<script src="<c:url value='/cmm/js/tagfree/js/tse.js'/>" type="text/javascript" language="javascript"></script>
	<input type = "hidden" name="${cntrNm}"  id="${cntrNm}" value="${contents}">
	<script type="text/javascript">
		var hidVal = "${contents}";
		var path = "${root}cmm/js/tagfree";								
		//alert(hidVal.val()+"|||"+path);
		xfe = new XFE();//필수
		xfe.setBasePath(path);//필수
		xfe.height = "${height}px";
		xfe.initialize();//필수
		xfe.SetHtmlValue(hidVal);
	</script>
</body>
</html>