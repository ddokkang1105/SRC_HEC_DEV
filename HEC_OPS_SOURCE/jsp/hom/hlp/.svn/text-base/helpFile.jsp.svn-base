<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<body>
<div id="user_manual">
	<c:choose>
	<c:when test="${sessionScope.loginInfo.sessionCurrLangType eq '1042'}">
		<li class="manualtitle">:: 파일 다운로드   :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_file01.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;왼쪽 트리에서 선택한 항목에 첨부된 파일</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;Save All : 전체 파일 다운로드<br>
		<span>Download : 선택한 파일 다운로드</span></li>
		
		<li class="manualtitle">:: 파일 업로드   :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_file02.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;파일관리(<img src="${root}${HTML_IMG_DIR}/help/ko/sc_file.png">) 아이콘 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;신규파일 업로드 시 [Upload]버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;파일삭제하실 경우 [Del]버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;업로드할 파일의 문서유형 선택 후 [Add file]버튼 클릭하여 파일 첨부</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;[Save]버튼 클릭 </li>
	</c:when>
	
	<c:when test="${sessionScope.loginInfo.sessionCurrLangType ne '1042'}">
		<li class="manualtitle">:: 파일 다운로드   :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_file01.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;왼쪽 트리에서 선택한 항목에 첨부된 파일</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;Save All : 전체 파일 다운로드<br>
		<span>Download : 선택한 파일 다운로드</span></li>
		
		<li class="manualtitle">:: 파일 업로드   :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_file02.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;파일관리(<img src="${root}${HTML_IMG_DIR}/help/en/sc_file.png">) 아이콘 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;신규파일 업로드 시 [Upload]버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;파일삭제하실 경우 [Del]버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num04.png">&nbsp;업로드할 파일의 문서유형 선택 후 [Add file]버튼 클릭하여 파일 첨부</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num05.png">&nbsp;[Save]버튼 클릭 </li>
	</c:when>
	</c:choose>	
</div>
</body>
</html>