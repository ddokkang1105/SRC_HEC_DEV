<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<body>
<div id="user_manual">
	<c:choose>
	<c:when test="${sessionScope.loginInfo.sessionCurrLangType eq '1042'}">
	    <li class="manualtitle">:: Search   :: </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_search01.png"></li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;고급 검색</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;계층, ID, 담당조직/담당자, 속성 별, Dimension 별 조회</li>
	</c:when> 
	
	<c:when test="${sessionScope.loginInfo.sessionCurrLangType ne '1042'}">
	    <li class="manualtitle">:: Search   :: </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_search01.png"></li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;고급 검색</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;계층, ID, 담당조직/담당자, 속성 별, Dimension 별 조회</li>
	</c:when> 
	</c:choose>
</div>
</body>
</html>