<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00069" var="WM00069"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>

<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
    <title>SF OLM Batch Image</title>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript" src="./modeling/mxgraph_v3.4/js/jquery-1.4.2.min.js"></script>
	<script type="text/javascript">
	$( document ).ready(function() {
		$("#blankForm0").submit();
	    
	});
	function removeIframe(idx,idx2) {
		setTimeout(
			    function() 
			    { 
				    $("#blankForm"+idx2).submit();
			   		$("#blankForm"+idx).remove();
			   		if(idx2 == ${maxCount}){
				   		alert("완료되었습니다.");
				   		$("#message").html("Model Image Exprot 실행 되었습니다. <br> 화면을 종료해주세요.");
				   	}
			    },  5000);
	}
	</script>
	<input type="hidden" id="nowCount" name="nowCount" value="0"/>
	
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
	<div id="message">
		Model Image Exprot 실행 ...
	</div>
<c:forEach var="model" items="${result}" varStatus="status">
	<form name="blankForm${status.index}" id="blankForm${status.index}" action="/batchGetMdlImage.do" target="blankFrame" method="post">
		<input type="hidden" name="modelID" value="${model.ModelID}"/>
		<input type="hidden" name="s_itemID" value="${model.ItemID}"/>
		<input type="hidden" name="languageID" value="${languageID}"/>
	</form>
</div>
</c:forEach>
</body>
</html>