<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<%--------------------------------------------------------------------------------
                              IMPORT / INCLUDE JAVASCRIPT, CSS
---------------------------------------------------------------------------------%>
<c:if test="${fromModelYN ne 'Y'}">
	<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/style.css"/>
</c:if>
<c:if test="${fromModelYN eq 'Y'}"><link rel="stylesheet" type="text/css" href="${root}cmm/common/css/style_model.css"/></c:if>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/common.css"/>
<!-- jquery js -->
<%@ include file="../cmm/ui/jqueryJsInc.jsp" %>
<!-- dhtmlx -->
<%-- <%@ include file="../cmm/ui/dhtmlxJsInc.jsp" %> --%>
<!-- XBOLT js -->
<%@ include file="../cmm/ui/olmJsInc.jsp" %>