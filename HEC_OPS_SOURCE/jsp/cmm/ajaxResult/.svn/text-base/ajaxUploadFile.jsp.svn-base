<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>
<script>
jQuery(document).ready(function() {
	$("a.popup").click(function() {
		alert(this.href);
		//openPopup(this.href);
		return false;
	});
	$(".btn").each(function() {
		$(this).css({"cursor":"hand"});
	});
});

</script>
<c:forEach var="result" items="${resultMap}" varStatus="status">
<div id="file${result.ATTFILE_ID}_${result.SEQ}"><a href="${root}dsFileDown.do?seq=${result.SEQ}"><img src="${root}images/sub/${result.SRC}.gif"/> ${result.ORG_FILE_NAME}</a>
<c:if test="${result.DEL_YN == 'Y' }">
<img src="/cmm/images/grid/tab_close-on.gif" onclick="fnFileDelete('${result.ATTFILE_ID}', '${result.SEQ}');" alt="파일삭제" class="btn"/>
</c:if>
</div>
</c:forEach><c:if test="${empty resultMap}">첨부된 파일이 없습니다.</c:if>