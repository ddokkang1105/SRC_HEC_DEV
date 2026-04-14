<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:forEach var="result" items="${resultMap}" varStatus="status">
<option value="${result.CODE}" <c:if test="${not empty result.ICON}"> data-image="${root}${HTML_IMG_DIR_ITEM}/${result.ICON}"</c:if>>${result.NAME}</option>
</c:forEach>
<c:if test="${resultMap==null}"><option value="">결과없음</option></c:if>
