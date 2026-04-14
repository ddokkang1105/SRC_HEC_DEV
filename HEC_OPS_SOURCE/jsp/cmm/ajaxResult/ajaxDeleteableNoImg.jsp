<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>
<script>
$(document).ready(function(){
	$("img.imgBoxScreen").each(function() {
		$(this).css("width", 15);
		$(this).css("height", 15);
		$(this).css({"cursor":"hand"});
	});
	$("img.imgBoxScreen").click(function() {
		document.location = this.src;
		//window.open(this.src, "_blank");
		return false;
	});
	$(".btn").css({"cursor":"hand"});

});
</script>
<div><c:forEach var="result" items="${resultMap}" varStatus="status">
	<div id="file${result.ATTFILE_ID}_${result.SEQ}">
		<img alt="${result.FILE_NAME}" src="${root}dsFileDown.do?seq=${result.SEQ}" class="imgBoxScreen"/>
		<div style="width:0px;height:0px;font-size:0px;float:left;" id="OK" class="ok"></div>
		<font style="font-size:11;font-family:돋음; ">${result.FILE_NAME}</font>
		<input type="hidden" id="ff" name="ff" value="${result.FILE_NAME}"/>
		<input type="hidden" id="tmpFile" name="tmpFile"  value="${result.ATTFILE_ID}"/>
		<c:if test="${RST != '[Y]'}">
		<img id="IMG" src="${root}${HTML_IMG_DIR}/icon_del.gif" onclick="fnFileDelete('${result.ATTFILE_ID}', '${result.SEQ}');" alt="파일삭제" class="btn"/>
		</c:if>
	</div>
</c:forEach><c:if test="${empty resultMap}"><img alt="이미지없음" src="${root}${HTML_IMG_DIR}/img02_no_img.gif" class="imgBoxScreen"/>
<font style="font-size:11;font-family:돋음; ">이미지가 없습니다.</font></c:if></div>