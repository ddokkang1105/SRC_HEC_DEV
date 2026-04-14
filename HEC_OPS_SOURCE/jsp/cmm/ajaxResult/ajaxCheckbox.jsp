<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script>
jQuery(document).ready(function() {
	$(".radio").css({"border":"none"});
});
</script>
<div>
<input type="checkbox" name="${name}Checked" id="${name}Checked" title="전체" value="ALL" checked="checked" class="radio" onclick="selectAll('${name}');"/>전체선택&nbsp;&nbsp;
<c:forEach var="result" items="${resultMap}" varStatus="status">
<input type="checkbox" name="${name}" id="${name}_${status.index }" title="${result.NAME}" value="${result.CODE}" ${checkYn=='Y'?'checked="checked"':'' } class="radio"/> ${result.NAME}
</c:forEach>
</div>