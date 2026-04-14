<%@ page contentType="text/html;charset=UTF-8" %><%@
taglib prefix="spring" uri="http://www.springframework.org/tags" %><%@
taglib prefix="q" uri="http://gqms.mando.com/tld/gqms" %><!DOCTYPE html>
<html>
	<head>
		<title>G-QMS</title>
		<meta http-equiv="content-type" content="text/html;charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
		<meta http-equiv="Expires" content="-1"> 			
		<meta http-equiv="Pragma" content="no-cache"> 			
		<meta http-equiv="Cache-Control" content="No-Cache">
		<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1"/>
		<meta name="apple-mobile-web-app-capable" content="yes">
		<link rel="shortcut icon" href="/img/favicon.ico" type="image/x-icon"/>
		<link rel="icon" href="/img/favicon.ico" type="image/x-icon"/>
		<%@ include file="/WEB-INF/jsp/cm/common-css.jsp" %>
		<%@ include file="/WEB-INF/jsp/cm/common-js.jsp" %>
		<script type="text/javascript">
		</script>
</head>
<body>
	<form name="form" action="https://eptest2.hlcompany.com/Workflow/Page/LinkOpenGqms.aspx" method="POST" enctype="application/x-www-form-urlencoded" accept-charset="UTF-8">
		<input type="hidden" name="callkey" value="${wfInfo.callkey}">
		<input type="hidden" name="model" value="${wfInfo.paramEnc}">
	</form>
	 <script>
		form.model.value = encodeURIComponent(form.model.value);
		form.submit();
	</script> 
</body>
</html>