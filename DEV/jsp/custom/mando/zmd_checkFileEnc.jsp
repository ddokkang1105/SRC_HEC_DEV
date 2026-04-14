<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<c:forEach var="list" items="${encFileList}" varStatus="status">
<li>${list.Identifier}&nbsp;${list.FileRealName}&nbsp;${list.FilePath}</li>
</c:forEach> 