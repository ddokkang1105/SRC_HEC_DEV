<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<title>::: OLM ::: </title>
</head>

<%
	String olmLoginid = request.getParameter("olmLoginid") == null ? "" : request.getParameter("olmLoginid");
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

	<script type="text/javascript">
		// 밑에 form 데이터를 파라미터로 /custom/ls/indexLS.do 로 보내기
		window.onload = function() {
			document.getElementById("autoForm").submit();
		};
	</script>

<body>
<form id="autoForm" name="autoForm" action="/custom/ls/indexLS.do" method="post">
	<input name="olmLoginid" id="olmLoginid" type="hidden" value="<%=olmLoginid%>">
	<input name="languageID" id="languageID" type="hidden" value="<%=languageID%>">
	<input name="scrnType" id="scrnType" type="hidden" value="<%=scrnType%>">
	<input name="keyId" id="keyId" type="hidden" value="<%=keyId%>">
	<input name="object" id="object" type="hidden" value="<%=object%>">
	<input name="linkType" id="linkType" type="hidden" value="<%=linkType%>">
	<input name="linkID" id="linkID" type="hidden" value="<%=linkID%>">
	<input name="iType" id="iType" type="hidden" value="<%=iType%>">
	<input name="aType" id="aType" type="hidden" value="<%=aType%>">
	<input name="option" id="option" type="hidden" value="<%=option%>">
	<input name="type" id="type" type="hidden" value="<%=type%>">
	<input name="changeSetID" id="changeSetID" type="hidden" value="<%=changeSetID%>">
	<input name="projectType" id="projectType" type="hidden" value="<%=projectType%>">

	<input name="mainType" id="mainType" type="hidden" value="<%=mainType%>">
	<input name="srID" id="srID" type="hidden" value="<%=srID%>">
	<input name="mainType" id="mainType" type="hidden" value="<%=mainType%>">

</form>

</body>

</html>
