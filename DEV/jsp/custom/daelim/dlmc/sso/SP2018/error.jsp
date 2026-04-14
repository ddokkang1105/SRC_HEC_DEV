<%@ page contentType="text/html; charset=utf-8" %>
<%@page import="com.rathontech2018.sso.sp.config.Env"%>
<%@page import="org.apache.commons.codec.binary.Base64"%>
<%@page import="java.net.URLDecoder"%>
<%
    String errorMSG = request.getParameter("errorMSG");
    errorMSG = URLDecoder.decode(new String(Base64.decodeBase64(errorMSG.getBytes())), Env.SPO_CHARACTER_ENCODING);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8"/>
</head>
<body>
errorMSG : ==><%=errorMSG%><==
</body>
</html>