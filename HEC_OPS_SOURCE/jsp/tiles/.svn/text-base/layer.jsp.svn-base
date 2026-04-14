<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<c:set value='<%= request.getParameter("retfnc") %>' var="retfnc"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00098" var="WM00098"/>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta>
<!--[if gte IE 8]><meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8"></meta><![endif]-->
<script>function closeLoading(){$("#resultDiv").html('');$("#loading").fadeOut(50);}</script>
<c:if test="${!empty htmlTitle}"><script>parent.document.title="${htmlTitle}";</script></c:if>

<!-- 1. Include JSP -->
<tiles:insertAttribute name="tagInc"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/menuOnloader.jsp"%>
<link rel="stylesheet" type="text/css" href="${root}${HTML_CSS_DIR}/language.css" />
<script type="text/javascript" src="${root}cmm/js/xbolt/lovCssHelper.js"></script>

</head>
<body>
<tiles:insertAttribute name="body"/>
<div id="blankDiv"></div>
</body>
</html>