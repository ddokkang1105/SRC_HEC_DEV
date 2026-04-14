<%@page import="org.apache.commons.httpclient.HttpClient"%>
<%@page import="org.apache.commons.httpclient.methods.PostMethod"%>
<%@page import="org.apache.commons.httpclient.NameValuePair"%>

<%
	/*
		예외 처리
		-> isToken이 Y가 아니라면 index 및 business 페이지로 send
	*/
	String isToken = request.getParameter("isToken") == null ? "" : request.getParameter("isToken");
	String SERVICE_BUSINESS_PAGE = session.getAttribute("SERVICE_BUSINESS_PAGE") == null ? "/index.jsp" : session.getAttribute("SERVICE_BUSINESS_PAGE").toString();
	if(false == isToken.equals("Y")) response.sendRedirect(SERVICE_BUSINESS_PAGE);
	/*
		예외 처리
	*/
	
	String secureToken = request.getParameter("secureToken") == null ? "" : request.getParameter("secureToken");
	String secureSessionId = request.getParameter("secureSessionId") == null ? "" : request.getParameter("secureSessionId");
	
	String AUTHORIZATION_URL = session.getAttribute("AUTHORIZATION_URL") == null ? "" : session.getAttribute("AUTHORIZATION_URL").toString();
	String SSID = session.getAttribute("SSID") == null ? "" : session.getAttribute("SSID").toString();
	String REQUEST_DATA = session.getAttribute("REQUEST_DATA") == null ? "" : session.getAttribute("REQUEST_DATA").toString();
	
	String sendUrl = "";
	String newToken = "";
	
	String httpresponse = null;
	PostMethod getMethod = null;
	try {
		/*
			인증서버에 secureToken 검증 및 사용자 정보를 요청하기 위해 httpclient를 사용하여 전달 
		*/
		
		getMethod = new PostMethod(AUTHORIZATION_URL+"authorization");
		NameValuePair[] nvp = {
			new NameValuePair("secureToken", secureToken), 
			new NameValuePair("secureSessionId", secureSessionId), 
			new NameValuePair("REQUEST_DATA", REQUEST_DATA),
			new NameValuePair("ssid", SSID),
			new NameValuePair("clientIP", request.getRemoteAddr())};
		getMethod.setQueryString(nvp);
		HttpClient httpclient = new HttpClient();
		httpclient.executeMethod(getMethod);
		
		// httpresponse는 httpclient를 통하여 결과를 받는 변수
		httpresponse = getMethod.getResponseBodyAsString();
		getMethod.releaseConnection();
		
		/*
		인증서버에 secureToken 검증 및 사용자 정보를 요청하기 위해 httpclient를 사용하여 전달 
		*/
		
	} catch (Exception e) {
		/*
			예외처리
			-> httpclient 도중 통신에 문제가 발생하였을 때 로그인 페이지로 send
		*/
		
	  	session.setAttribute("checkServer", "N");
		session.setAttribute("USEISIGNPAGE", "N");
		session.setAttribute("Exception", "Y");
		String SERVICE_LOGIN_PAGE = session.getAttribute("SERVICE_LOGIN_PAGE") == null ? "" : session.getAttribute("SERVICE_LOGIN_PAGE").toString();
		response.sendRedirect(SERVICE_LOGIN_PAGE);
		return;
		
		/*
			예외처리
		*/
	}
	
	// 인증서버로 부터 받은 결과를 파싱
	String[] nameValuePairs = httpresponse.split("&");
	for (int i = 0; i < nameValuePairs.length; i++) {
		// 1차 파싱된 결과를 다시 name과 value로 파싱
		String[] nameValuePair = nameValuePairs[i].split("=", 2);
		
		if (nameValuePair.length == 2) {
			if (nameValuePair[0].equals("secureToken")) {
				newToken = nameValuePair[1];
			} else {
				session.setAttribute(nameValuePair[0], nameValuePair[1]);
			}
		}
	}
    
	// SUCCESS_CODE => 1(인증 성공), 2(인증 실패), 3(권한)
	String SUCCESS_CODE = session.getAttribute("SUCCESS_CODE") == null ? "" : session.getAttribute("SUCCESS_CODE").toString();
	if (true == SUCCESS_CODE.equals("1")) {
		// session timeout 설정
		String timeOut = session.getAttribute("timeOut") == null ? "5" : session.getAttribute("timeOut").toString();
		session.setMaxInactiveInterval(Integer.parseInt(timeOut)*60);
		
		sendUrl = AUTHORIZATION_URL + "LoginServlet";
	} else {
		if(true == SUCCESS_CODE.equals("3")){
			// 권한이 없을 때 권한 페이지로 send
			String SERVICE_ROLE_PAGE = session.getAttribute("SERVICE_ROLE_PAGE") == null ? "" : session.getAttribute("SERVICE_ROLE_PAGE").toString();
			response.sendRedirect(SERVICE_ROLE_PAGE);
			return;
		}else{
			// 검증이 실패했을 때 로그아웃 페이지로 send
			String SERVICE_LOGOUT_PAGE = session.getAttribute("SERVICE_LOGOUT_PAGE") == null ? "" : session.getAttribute("SERVICE_LOGOUT_PAGE").toString();
			response.sendRedirect(SERVICE_LOGOUT_PAGE);
			return;
		}
	}
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	</head>
<body>
<form name="sendForm" method="post">
	<input type="hidden" name="secureToken" value="<%=newToken%>" />
	<input type="hidden" name="secureSessionId" value="<%=secureSessionId%>" />
	<input type="hidden" name="method" value="updateSecureToken" />
	<input type="hidden" name="ssid" value="<%=SSID%>" />
</form>

<script>
	var sendUrl = "<%=sendUrl%>";
	var sendForm = document.sendForm;
	sendForm.action = sendUrl;
	sendForm.submit();
</script>
</body>
</html>