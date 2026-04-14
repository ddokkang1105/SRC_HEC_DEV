<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="false"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%String type = request.getParameter("type") == null ? "" : request.getParameter("type");%> 
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
var type="<%=type%>";
var atchUrl = "<%=GlobalVal.BASE_ATCH_URL%>";
var lgnUrl="${pageContext.request.contextPath}/kdnvn/loginkdnvnForm.do";
jQuery(document).ready(function() {

	var olmI = "${olmI}";
	if(olmI == ""){
		alert("Identification failed");
	}
	var submitForm = document.mainForm;
	submitForm.target="main";
	submitForm.action=lgnUrl;
	submitForm.submit();
});
function fnLoginForm() {main.location = lgnUrl;}

</script>
</head><body>
	<form name="mainForm" action="#" method=post target='main' onSubmit="return false;" >
	<input type="hidden" id="loginid" name="loginid" value="${olmI}"/>
	<input type="hidden" id="pwd" name="pwd" value="${olmP}"/>
	<input type="hidden" id="lng" name="lng" value="${olmLng}"/>
	<input type="hidden" id="loginIdx" name="loginIdx" value="${loginIdx}"/>
	<input type="hidden" id="screenType" name="screenType" value="${screenType}"/>	
	<input type="hidden" id="mainType" name="mainType" value="${mainType}"/>	
	<input type="hidden" id="srID" name="srID" value="${srID}"/>
	<input type="hidden" id="pwdCheck" name="pwdCheck" value="${pwdCheck}" />
	</form>
	<iframe name="main" id="main" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
</body></html>