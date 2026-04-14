<%@ page contentType = "text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<%@ page isErrorPage = "true" %>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>title</title>
</head>
<body>
	<div id="error">
		<div id="error_font_one">
			<strong class="error_title">${resultMap.ERROR_NM}</strong>
			<p>${resultMap.DESCRIPTION} </p>
        </div>
        <div id="error_font_two">
        	<table class="error_table">
        		<tr class="error_table_tr">
        			<td class="error_table_td_icon"><img src="${root}${HTML_IMG_DIR}/icon_error_email.jpg"> </td>
        			<td class="error_table_td_text1">e-mail</td>
        			<td class="error_table_td_text2">support@smartfactory.co.kr</td>
        		</tr>
        	</table>
		</div>
	</div>
</body>
</html>