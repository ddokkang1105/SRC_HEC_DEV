<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
java.util.Date date = new java.util.Date();
java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyyMMddHHmm");
String today = formatter.format(date);
response.setHeader("Content-Disposition", "attachment;filename=\"" + URLEncoder.encode(request.getAttribute("title").toString(), "UTF-8").replaceAll("\\+", " ") +"_"+today +".xls" +"\";");
%>
	<link href="<%=request.getRequestURL().substring(0,request.getRequestURL().indexOf("/",request.getRequestURL(
).indexOf("//")+2))%>/dev_xbolt/cmm/css/excel.css" rel="stylesheet" type="text/css" />

<style type="text/css">
.N {mso-number-format:0;}										/* 숫자 */
.x125 {mso-number-format:"\#\,\#\#0_ "; background-color:#FFFF99}       /* 숫자 (천단위 콤마) */
.x126 {mso-number-format:"\@";}                                         /* 텍스트 */

.T_C {mso-number-format:"\@";mso-style-parent:style0;white-space:normal;text-align:center;} /* 텍스트, 줄바꿈금지, 가운데정렬 */
.T_R {mso-number-format:"\@";mso-style-parent:style0;white-space:normal;text-align:right;} /* 텍스트, 줄바꿈금지, 가운데정렬 */
.T_L {mso-number-format:"\@";mso-style-parent:style0;white-space:normal;text-align:left;} /* 텍스트, 줄바꿈금지, 가운데정렬 */

.C_R {mso-number-format:"\#\,\#\#0_ "; text-align:right;}       /* 숫자 (천단위 콤마) */
.N_R {mso-number-format:"0"; text-align:right;}       /* 숫자 */

.D_R {mso-number-format:"yy\-mm\-dd h\:mm\:ss"; text-align:right;}	/* 날짜 */
} /* 날짜형식 */
</style>


</head>
<body>
	<script>
	alert(1);
	</script>
<div id="contents">
	<h2> &nbsp;&nbsp;&nbsp;${title}</h2>
	<table class="lost_list">
		<tr>
	<c:forEach var="head" items="${headers}"><th>&nbsp;${head}</th></c:forEach>
		</tr>
	<c:forEach var="result" items="${bodyList}" varStatus="status">
		<tr><td class="T_C">${result.RNUM}</td>
			<c:forEach var="col" items="${cols}" varStatus="index"><td class="${coltypes[col]}">${result[col]}</td></c:forEach>
		</tr>
	</c:forEach>
	</table>
</div>
</body>
</html>
