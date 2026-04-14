<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@page import="com.rathontech2018.sso.sp.agent.web.WebAgent"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>:: 현업 인증 페이지 ::</title>
</head>
<body>
<%
	/* 대상 시스템 custom session을 생성하는 예제 부분 - 시작 */
	String userName = (String)session.getAttribute("RathonSSO_USER_ID");	
	session.setAttribute("redirect_custom_authn_test_user_id", "리다렉트_테스트유저ID_" + userName);
	/* 대상 시스템 custom session을 생성하는 예제 부분 - 끝 */
	
	
	/* custom session operator - 시작 */
	WebAgent agent = new WebAgent();
	agent.doPostCustomAuthentication(request, response);
	/* custom session operator - 끝 */
%>
</body>
</html>