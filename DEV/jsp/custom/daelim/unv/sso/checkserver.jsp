<%@page import="org.apache.commons.httpclient.MultiThreadedHttpConnectionManager"%>
<%@page import="org.apache.commons.httpclient.methods.PostMethod"%>
<%@page import="org.apache.commons.httpclient.HttpClient"%>
<%
	String AUTHORIZATION_URL = session.getAttribute("AUTHORIZATION_URL") == null ? "http://sso.daelim.ac.kr/" : session.getAttribute("AUTHORIZATION_URL").toString();
	String AUTHORIZATION_SSL_URL = session.getAttribute("AUTHORIZATION_SSL_URL") == null ? "https://sso.daelim.ac.kr/" : session.getAttribute("AUTHORIZATION_SSL_URL").toString();
	
	String SSID = session.getAttribute("SSID") == null ? "145" : session.getAttribute("SSID").toString();
	System.out.println("SSO AUTHORIZATION_URL :::: " + AUTHORIZATION_URL);
	//out.println("SSO AUTHORIZATION_URL :::: " + AUTHORIZATION_URL);
	/*
		예외 처리
		-> 인증서버 url에 값이 없다면 index 및 business 페이지로 send
	*/
	String SERVICE_BUSINESS_PAGE = session.getAttribute("SERVICE_BUSINESS_PAGE") == null ? "/index.jsp" : session.getAttribute("SERVICE_BUSINESS_PAGE").toString();
	if(AUTHORIZATION_URL.length() < 5){
		response.sendRedirect(SERVICE_BUSINESS_PAGE);
		return;
	}
	/*
		예외 처리
	*/
	
	String sendUrl = "http://sso.daelim.ac.kr/LoginServlet" + "?method=checkLogin" + "&ssid=" + SSID;
	System.out.println("SSO sendUrl :::: " + sendUrl);
	//out.println("SSO sendUrl :::: " + sendUrl);
	try{
		/*
			인증서버에 해당 Web-Agent의 인증방식 및 통합로그인 정보를 요청하기 위해 httpclient를 사용하여 전달 
		*/
	    int conTimeOut = 5000;
		int soTimeOut = 5000;
		MultiThreadedHttpConnectionManager connectionManager = new MultiThreadedHttpConnectionManager();
		HttpClient client = new HttpClient(connectionManager);
		client.setConnectionTimeout(conTimeOut);
		client.setTimeout(soTimeOut);
		connectionManager.setMaxTotalConnections(5000);
		PostMethod post = new PostMethod(sendUrl);
		int httpResult = client.executeMethod(post);
		
		// sResult는 httpclient를 통하여 결과를 받는 변수
		String sResult = post.getResponseBodyAsString().trim();
		post.releaseConnection();
		
		/*
			인증서버에 해당 Web-Agent의 인증방식 및 통합로그인 정보를 요청하기 위해 httpclient를 사용하여 전달 
		*/
		
		if(sResult != null){
			// 인증서버로 부터 받은 결과를 파싱
			String[] data = sResult.split(":");
			session.setAttribute("authMethod", data[0]);
			session.setAttribute("USEISIGNPAGE", data[1]);
			session.setAttribute("checkServer", "Y");
		}else{
			// sResult 값이 없는 경우는 네트워크 통신에 문제가 있거나 서버에서 예외가 발생한 경우이다.
			session.setAttribute("checkServer", "N");
			session.setAttribute("USEISIGNPAGE", "N");
			session.setAttribute("Exception", "Y");
			String SERVICE_LOGIN_PAGE = session.getAttribute("SERVICE_LOGIN_PAGE") == null ? "" : session.getAttribute("SERVICE_LOGIN_PAGE").toString();
			response.sendRedirect(SERVICE_LOGIN_PAGE);
			return;
		}
	}catch (Exception e){
		System.out.println("SSO Exception :::: " + e.getMessage());
		/*
			예외처리
			-> httpclient 도중 통신에 문제가 발생하였을 때 로그인 페이지로 send
		*/
		session.setAttribute("checkServer", "N");
		session.setAttribute("USEISIGNPAGE", "N");
		session.setAttribute("Exception", "Y");
		String SERVICE_LOGIN_PAGE = session.getAttribute("SERVICE_LOGIN_PAGE") == null ? "" : session.getAttribute("SERVICE_LOGIN_PAGE").toString();
		System.out.println("SSO SERVICE_LOGIN_PAGE :::: " + SERVICE_LOGIN_PAGE);
		response.sendRedirect(SERVICE_LOGIN_PAGE);
		return;
		/*
			예외처리
		*/
	}
	System.out.println("SSO checkServer :::: " + session.getAttribute("SSID") + ", " + session.getAttribute("LOGIN_ID"));
	sendUrl = AUTHORIZATION_SSL_URL + "isignplus/index.jsp";
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	</head>
<body>
<form name="sendForm" method="post">
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
