<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import = "java.util.Map" %>
<c:url value="/" var="root"/>

<script>
var url = "${root}index.do";
<%
	if( session == null) {
		%> 
		window.location.href=url;
		<%
		Object loginInfo = session.getAttribute("loginInfo");
		if( loginInfo == null) {
			%> 
			window.location.href=url;
			<%
		}
	}
%> 
</script>