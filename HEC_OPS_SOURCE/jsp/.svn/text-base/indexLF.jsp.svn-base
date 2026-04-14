<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="false"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%String type = request.getParameter("type") == null ? "" : request.getParameter("type");%> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/style.css"/>
<script src="${pageContext.request.contextPath}/cmm/js/jquery/jquery.js" type="text/javascript"></script>
<style type="text/css">html,body {overflow-y:hidden;width:100%;height:100%}</style>
<script type="text/javascript">
//var a = "${olmI}";var b = encodeURIComponent("${olmP}");var c = "${olmLng}";
var type="<%=type%>";
var atchUrl = "<%=GlobalVal.BASE_ATCH_URL%>";
var lgnUrl="${pageContext.request.contextPath}/lf/loginlfForm.do";
jQuery(document).ready(function() {
	var logSso1Check = "${logSso1Check}";
	if(logSso1Check == "1"){
		var submitForm = document.mainForm;
		submitForm.target="main";
		submitForm.action=lgnUrl;
		submitForm.submit();
	}else{
		alert("Identification failed"); return;
	}
	
});
function fnLoginForm() {main.location = lgnUrl;}
</script>
</head><body>
	<form name="mainForm" action="#" method=post target='main'>
	<input type="hidden" id="loginid" name="loginid" value="${olmI}"/>
	<input type="hidden" id="pwd" name="pwd" value="${olmP}"/> 
	<input type="hidden" id="lng" name="lng" value="${olmLng}"/>
	<input type="hidden" id="p1" name="p1" value="${p1}"/>	
	<input type="hidden" id="p2" name="p2" value="${p2}"/>	
	<input type="hidden" id="p3" name="p3" value="${p3}"/>	
	<input type="hidden" id="p4" name="p4" value="${p4}"/>	
	<input type="hidden" id="p5" name="p5" value="${p5}"/>	
	</form>
	<iframe name="main" id="main" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
</body></html>