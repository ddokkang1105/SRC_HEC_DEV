<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="java.util.*,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
</head>
<body>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%
/*String t_code = String.valueOf(request.getAttribute("t_code"));
String SAPshortCutPath = String.valueOf(request.getAttribute("SAPshortCutPath"));
Runtime rt=Runtime.getRuntime();

//String shortCutPath = "C:\\Program Files (x86)\\SAP\\FrontEnd\\SAPgui\\sapshcut.exe";
String cmd[]={"cmd.exe", "/C", SAPshortCutPath + " -command="+t_code};
rt.exec(cmd);*/
%>
<script>	
jQuery(document).ready(function() {	
	window.open('${sapUrl}','_self');   
});
</script>
</body>
</html>