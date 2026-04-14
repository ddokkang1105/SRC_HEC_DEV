<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:forEach var="result" items="${resultMap}" varStatus="status">
<li onclick="" style="cursor: pointer;" class="m${status.count}">
	<a href="javascript:getCategory('${result.CODE}');">
	<span>${result.NAME}<span class="i">
	</span></span>
	</a>
</li>
</c:forEach>
<c:if test="${resultMap==null}"><li>결과없음</li></c:if>
