<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><c:if test="${!empty htmlTitle}">${htmlTitle}</c:if></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>
<script type="text/javascript">
	jQuery(document).ready(function() {
		var screenType = "${screenType}";
		var srID = "${srID}";	
		var srType = "${srType}";
		var isPopup = "${isPopup}";
		var srcUrl = "processSR.do?screenType="+screenType+"&srID="+srID+"&srType="+srType+"&isPopup="+isPopup;
		$('#main').attr('src',srcUrl);
	});
</script>
</head>
<body>
<iframe name="main" id="main" width="100%" height="710px" frameborder="0" scrolling="yes" marginwidth="0" marginheight="0"></iframe>
</body>
</html>
