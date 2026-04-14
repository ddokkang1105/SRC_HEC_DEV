<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="false"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/style.css"/>
<script src="${pageContext.request.contextPath}/cmm/js/jquery/jquery.js" type="text/javascript"></script>
<script src="${root}cmm/js/xbolt/ajaxHelper.js" type="text/javascript"></script>
<style type="text/css">html,body {overflow-y:hidden;width:100%;height:100%}</style>
<script type="text/javascript">
jQuery(document).ready(function() {
	document.popForm.action = "/olmLinkSSOPop.do";
	document.popForm.submit();
});
</script>
</head><body>
	<form id="popForm" name="popForm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="keyId" name="keyId" value="${keyId}"/>
	<input type="hidden" id="object" name="object" value="${object}"/> 
	<input type="hidden" id="linkType" name="linkType" value="${linkType}"/>
	<input type="hidden" id="linkID" name="linkID" value="${linkID}" />
	<input type="hidden" id="iType" name="iType" value="${iType}" />
	<input type="hidden" id="aType" name="aType" value="${aType}" />
	<input type="hidden" id="languageID" name="languageID" value="${languageID}" />
	<input type="hidden" id="loginID" name="loginID" value="guest" />
	</form>
</body></html>