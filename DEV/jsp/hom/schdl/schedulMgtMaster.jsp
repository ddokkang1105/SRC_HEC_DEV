<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<html>
<script type="text/javascript">
	$(document).ready(function(){		
		var url = "schedulMgt.do?projectID=${projectID}&screenType=${screenType}&pageNum=${pageNum}";
		$('#subBFrame').attr('src',url);
	});
	
</script>
<body>
<form name="schdlListFrm" id="schdlListFrm" action="" method="post" >
<div style="height:800px;">
<iframe name="subBFrame" id="subBFrame" height="100%"  width="100%"  frameborder="0" scrolling="no" marginwidth="0" marginheight="0"></iframe>
</div>
</form>
</body>
</html>