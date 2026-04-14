<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="false"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%String type = request.getParameter("type") == null ? "" : request.getParameter("type");%> 
<%String isSys = request.getParameter("isSys") == null ? "" : request.getParameter("isSys");%> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico" />
<%-- <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/style.css"/> --%>
<script src="${pageContext.request.contextPath}/cmm/js/jquery/jquery.js" type="text/javascript"></script>
<style type="text/css">html,body {overflow-y:hidden;width:100%;height:100%;margin:0;}</style>
<script type="text/javascript">
var a = "${olmI}";
var b = encodeURIComponent("${olmP}");
var c = "${olmLng}";
var type="<%=type%>";
var loginIdx = "${loginIdx}";
var lgnUrl="${pageContext.request.contextPath}/login/login"+type+"Form.do?loginid="+a+"&pwd="+b+"&lng="+c+"&loginIdx="+loginIdx+"&isSys=<%=isSys%>";
jQuery(document).ready(function() {$('#main').attr('src',lgnUrl);});function fnLoginForm() {main.location = lgnUrl;}
</script>
</head><body><iframe name="main" id="main" width="100%" height="100%" frameborder="0" scrolling="no" allowfullscreen="true" webkitallowfullscreen="true" mozallowfullscreen="true"></iframe></body></html>