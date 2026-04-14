<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:forEach var="result" items="${resultMap}" varStatus="status">
<input type="radio" id="${result.ID}" name="${result.ID}" value="${result.CODE}">&nbsp;<label for="${result.CODE}">${result.NAME}</label></input>
</c:forEach>
