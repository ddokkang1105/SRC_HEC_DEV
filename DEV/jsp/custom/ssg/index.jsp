<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<title>::: OLM ::: </title>
</head>
<%-- <c:redirect url = "http://paldev.emart.com/index.do"/> --%>

<%
	String olmLoginid = request.getParameter("olmLoginid ") == null ? "" : request.getParameter("olmLoginid");
	String languageID = request.getParameter("languageID") == null ? "1042" : request.getParameter("languageID");
	String scrnType = request.getParameter("scrnType") == null ? "" : request.getParameter("scrnType");
	String keyId = request.getParameter("keyId") == null ? "" : request.getParameter("keyId");
	String object = request.getParameter("object") == null ? "" : request.getParameter("object");
	String linkType = request.getParameter("linkType") == null ? "" : request.getParameter("linkType");
	String linkID = request.getParameter("linkID") == null ? "" : request.getParameter("linkID");
	String iType = request.getParameter("iType") == null ? "" : request.getParameter("iType");
	String aType = request.getParameter("aType") == null ? "" : request.getParameter("aType");
	String option = request.getParameter("option") == null ? "" : request.getParameter("option");
	String type = request.getParameter("type") == null ? "" : request.getParameter("type");
	String changeSetID = request.getParameter("changeSetID") == null ? "" : request.getParameter("changeSetID");
	String projectType = request.getParameter("projectType") == null ? "" : request.getParameter("projectType");	
	String arcCode = request.getParameter("arcCode") == null ? "" : request.getParameter("arcCode");
    	
	String wfInstanceID = request.getParameter("wfInstanceID") == null ? "" : request.getParameter("wfInstanceID");
	String srID = request.getParameter("srID") == null ? "" : request.getParameter("srID");
	String mainType = request.getParameter("mainType") == null ? "" : request.getParameter("mainType");

%>

<c:redirect url = "/indexSSG.jsp">
	<c:param name="olmLoginid" value="<%=olmLoginid%>" />
	<c:param name="languageID" value="<%=languageID%>" />
	<c:param name="scrnType" value="<%=scrnType%>" />
	<c:param name="keyId" value="<%=keyId%>" />
	<c:param name="object" value="<%=object%>" />
	<c:param name="linkType" value="<%=linkType%>" />
	<c:param name="linkID" value="<%=linkID%>" />
	<c:param name="iType" value="<%=iType%>" />
	<c:param name="aType" value="<%=aType%>" />
	<c:param name="type" value="<%=type%>" />
	<c:param name="changeSetID" value="<%=changeSetID%>" />
	<c:param name="projectType" value="<%=projectType%>" />
	<c:param name="wfInstanceID" value="<%=wfInstanceID%>" />
	<c:param name="srID" value="<%=srID%>" />
	<c:param name="mainType" value="<%=mainType%>" />
	<c:param name="arcCode" value="<%=arcCode%>" />
</c:redirect>

</html>
