<%@ page import="xbolt.custom.ls.cmm.SSOAuth" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
	String id_Token = (String) request.getAttribute("id_Token") == null ? "" : (String) request.getAttribute("id_Token");
	
	if (id_Token.equals("")) {
		
		SSOAuth auth = new SSOAuth(request, response);
		auth.ssoLogin(); 
	} 
		
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/style.css"/>
<script src="${pageContext.request.contextPath}/cmm/js/jquery/jquery.js" type="text/javascript"></script>
<style type="text/css">html,body {overflow-y:hidden;width:100%;height:100%}</style>
<script type="text/javascript">
var lgnUrl="${pageContext.request.contextPath}/custom/ls/loginlsForm.do";

jQuery(document).ready(function() {
	var olmI = '${olmI}';	// 사번
	var submitForm = document.mainForm;
		
	if(olmI == ""){
		alert("Your ID does not exist in our system. Please contact System Administrator(LSCNS).");
	}
	
	submitForm.action=lgnUrl;
	submitForm.target="main";
	submitForm.submit();
});
</script>
</head>
<body>
	<form name="mainForm" action="#" method=post target='main'>
		<input type="hidden" id="loginid" name="loginid" value="${olmI}"/>
		<input type="hidden" id="pwd" name="pwd" value="${olmP}"/> 
		<input type="hidden" id="lng" name="lng" value="${olmLng}"/>
		<input type="hidden" id="loginIdx" name="loginIdx" value="${loginIdx}"/>
		<input type="hidden" id="screenType" name="screenType" value="${screenType}"/>	
		<input type="hidden" id="mainType" name="mainType" value="${mainType}"/>	
		<input type="hidden" id="srID" name="srID" value="${srID}"/>
		<input type="hidden" id="sysCode" name="sysCode" value="${sysCode}"/>	
		<input type="hidden" id="proposal" name="proposal" value="${proposal}"/>
		<input type="hidden" id="status" name="status" value="${status}"/>		
	</form>
	<iframe name="main" id="main" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
	
</body>
</html>

