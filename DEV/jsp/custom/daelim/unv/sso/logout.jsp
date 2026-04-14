<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
	String AUTHORIZATION_URL = session.getAttribute("AUTHORIZATION_URL") == null ? "" : session.getAttribute("AUTHORIZATION_URL").toString();
	String SSID = session.getAttribute("SSID") == null ? "" : session.getAttribute("SSID").toString();
	String checkServer = session.getAttribute("checkServer") == null ? "" : session.getAttribute("checkServer").toString();
	String SUCCESS_CODE = session.getAttribute("SUCCESS_CODE") == null ? "" : session.getAttribute("SUCCESS_CODE").toString();
	String errMsg = session.getAttribute("errMsg") == null ? "" : session.getAttribute("errMsg").toString();
	
	/*
		예외 처리
		-> 인증서버의 상태가 N이거나 null or 빈상태일 때 index 및 business 페이지로 send
	*/
	if (checkServer.equals("") || true == checkServer.equals("N")) {
		String SERVICE_BUSINESS_PAGE = session.getAttribute("SERVICE_BUSINESS_PAGE") == null ? "/index.jsp" : session.getAttribute("SERVICE_BUSINESS_PAGE").toString();
		session.invalidate();
		response.sendRedirect(SERVICE_BUSINESS_PAGE);
		return;
	}
	/*
		예외 처리
	*/
	
	String domain = request.getServerName();
	domain = domain.substring(domain.indexOf("."));
	
	session.invalidate();
	String sendUrl = AUTHORIZATION_URL + "isignplus/logout.jsp";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<META HTTP-EQUIV="Content-Type"  CONTENT="text/html; charset=utf-8">
		<META HTTP-EQUIV="Pragma" CONTENT ="no-cache">
		<META HTTP-EQUIV="Cache-control" CONTENT="no-cache">
	</head>
<body>
<form name="sendForm" method="post">
	<input type="hidden" name="ssid" value="<%=SSID%>" />
	<input type="hidden" name="domain" value="<%=domain%>" />
</form>
<script>
	var SUCCESS_CODE = "<%=SUCCESS_CODE%>";
	if(SUCCESS_CODE == "2"){
		alert('errMsg : <%=errMsg%>');
	}
	
	var sendUrl = "<%=sendUrl%>";
	var sendForm = document.sendForm;
	sendForm.action = sendUrl;
	sendForm.submit();
</script>

</body>
</html>