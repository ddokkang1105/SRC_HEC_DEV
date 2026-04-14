<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% 

String arcCode = request.getParameter("arcCode") == null ? "" : request.getParameter("arcCode");
String menuStyle = request.getParameter("menuStyle") == null ? "" : request.getParameter("menuStyle");
String menuIcon = request.getParameter("menuIcon") == null ? "" : request.getParameter("menuIcon");
String nodeID = request.getParameter("nodeID") == null ? "" : request.getParameter("nodeID");
String menuVar = request.getParameter("menuVar") == null ? "" : request.getParameter("menuVar");
String arcVar = request.getParameter("arcVar") == null ? "" : request.getParameter("arcVar");
String arcUrl = request.getParameter("arcUrl") == null ? "" : request.getParameter("arcUrl");

%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><c:if test="${!empty htmlTitle}">${htmlTitle}</c:if></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>
<script type="text/javascript">
jQuery(document).ready(function() {
	
	var srcUrl = "<%=arcUrl%>?arcCode=<%=arcCode%>&menuStyle=<%=menuStyle%>&menuIcon=<%=menuIcon%><%=menuVar%><%=arcVar%>&nodeID=<%=nodeID%>";
	
	$('#main').attr('src',srcUrl);


});
</script>
</head><body>
<iframe name="main" id="main" width="100%" height="100%" frameborder="0" scrolling="no" marginwidth="0" marginheight="0"></iframe>
</body>
</html>
