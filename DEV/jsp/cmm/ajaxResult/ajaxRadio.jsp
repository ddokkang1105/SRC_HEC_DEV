<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:forEach var="result" items="${resultMap}" varStatus="status">
<input type="radio" id="${result.AttrTypeCode}${result.CODE}" name="${result.AttrTypeCode}" value="${result.CODE}" <c:if test="${status.first }">checked</c:if> />
<label for="${result.AttrTypeCode}${result.CODE}">${result.NAME}</label>
</c:forEach>
