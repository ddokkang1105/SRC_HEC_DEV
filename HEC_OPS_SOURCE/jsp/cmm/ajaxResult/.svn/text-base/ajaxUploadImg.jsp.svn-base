<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script>
$(document).ready(function(){
	$("img.imgBoxScreen").each(function() {
		$(this).css("width", 68);
		$(this).css("height", 58);
		$(this).css({"cursor":"hand"});
	});
	$("img.imgBoxScreen").click(function() {
		window.open(this.src, "_blank");
		return false;
	});
});
</script>
<div><c:forEach var="result" items="${resultMap}" varStatus="status">
	<div id="file${result.ATTFILE_ID}_${result.SEQ}"><img alt="${result.ORG_FILE_NAME}" src="/cmm/images/uploadImg/${result.SRC}" class="imgBoxScreen"/>
<%-- 	<img src="/images/grid/tab_close-on.gif" onclick="fnFileDelete('${result.ATTFILE_ID}', '${result.SEQ}');" alt="파일삭제" class="btn"/>--%>
</div>
</c:forEach><c:if test="${empty resultMap}"><img alt="이미지없음" src="/cmm/images/sub/img02_no_img.gif" class="imgBoxScreen"/></c:if></div>