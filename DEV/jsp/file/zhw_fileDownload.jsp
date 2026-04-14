<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="false"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<% 
	String fileID = request.getParameter("fileID") == null ? "" : request.getParameter("fileID");
	String userID = request.getParameter("userID") == null ? "" : request.getParameter("userID");
	String teamID = request.getParameter("teamID") == null ? "" : request.getParameter("teamID"); 
	String languageID = request.getParameter("languageID") == null ? "" : request.getParameter("languageID");
%> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<jsp:include page="/WEB-INF/jsp/template/uiInc.jsp" flush="true"/>

<style type="text/css">body,html {overflow-y:hidden}</style>
<c:if test="${!empty htmlTitle}"><script>parent.document.title="${htmlTitle}";</script></c:if>
<script src="${pageContext.request.contextPath}/cmm/js/jquery/jquery.js" type="text/javascript"></script>

<script type="text/javascript">
	function ajaxPage(url, data, target, preHtml, debug, debugTarget) {
		$.ajax({
			url: url,type: 'post',data: data,async: true,error: function(xhr, status, error) {alert(status+"||"+error);$('#loading').fadeOut(150); },beforeSend: function(x) {$('#loading').fadeIn(150);if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}}
			,success: function(data){$('#loading').fadeOut(10);if(debug){if(debugTarget==null){	alert(data);}else {	$("#debugMod").val(data);$("#debugMod").show();}} $("#" + target).hide();if(preHtml!=null){data=preHtml+data;}$("#" + target).html(data);$("#" + target).fadeIn(10);}
		});
	}
	
	jQuery(document).ready(function() {
		setWindowHeight();		
		var url  = "fileDownload.do?seq=${fileID}";
		ajaxSubmit(document.fileFrm, url,"blankFrame");
	});
	
	function setWindowHeight(){
		var size = window.innerHeight;
		var height = 0;
		if( size == null || size == undefined){
			height = document.body.clientHeight;
		}else{height=window.innerHeight;}
		$('#main').height(height-200);
	}
	
</script>
</head>
<body>
<div id="divResult"></div>
<form name="fileFrm" id="fileFrm" action="#" method="post" onsubmit="return false;"> </form>
<iframe name="main" id="main" width="100%" height="100%" frameborder="0" scrolling="yes" marginwidth="0" marginheight="0"></iframe>
</body>
</html>
