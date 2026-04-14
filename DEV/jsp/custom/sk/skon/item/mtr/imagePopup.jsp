<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<c:url value="/" var="root"/>

<%
    String token = (String) session.getAttribute("imagePopupToken");
    if (token == null) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN);
        return;
    }

    session.removeAttribute("imagePopupToken");
%>

<!DOCTYPE html> 
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<!-- dhtmlx7  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<style>
    body {
        margin: 0;
        padding: 0;
        height: 100%;
        font-family: Arial, sans-serif;
        background-color: #fff;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
    }

    img {
        width: 1536px;
        height: 864px;
        display: block;
        margin-bottom: 10px;
    }

    #close {
        text-align: center;
    }

    .btn_pack.medium.icon {
        cursor: pointer;
    }
</style>

<script type="text/javascript">
    function selfClose() {
        self.close();
    }
</script>

</head>

<body>
  <img src="<%= request.getContextPath() %>/cmm/sf/images/btn_icon_search.gif"><br> <!-- SK 이미지명 맞춰서 수정 -->
  <span id="close" class="btn_pack medium icon"><span class="close"></span><input value="Close" type="submit" onclick="selfClose()" /></span>
</body>
</html>
