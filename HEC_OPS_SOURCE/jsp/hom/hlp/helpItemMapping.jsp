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
		<li class="manualtitle">:: Mapping List 조회   :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_mapping01.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;ITEM Mapping 메뉴 : 예)PI과제에 매핑된 프로세스 리스트</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;ITEM Mapping 리스트<br>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;ITEM Mapping 편집 메뉴<br>
		
		<li class="manualtitle">:: Mapping List 신규 생성 후 매핑   :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_mapping02.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;신규 매핑할 항목의 정보 입력 : 예)프로세스 ID, 명칭 등</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;생성 위치 지정</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;매핑 저장</li>
		
		<li class="manualtitle">:: Mapping List 기 생성된 ITEM 마스터 매핑   :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_mapping03.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;매핑 대상 항목 선택</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;매핑 저장</li>
	</c:when>
	
	<c:when test="${sessionScope.loginInfo.sessionCurrLangType ne '1042'}">
		<li class="manualtitle">:: Mapping List 조회   :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_mapping01.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;ITEM Mapping 메뉴 : 예)PI과제에 매핑된 프로세스 리스트</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;ITEM Mapping 리스트<br>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;ITEM Mapping 편집 메뉴<br>
		
		<li class="manualtitle">:: Mapping List 신규 생성 후 매핑   :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_mapping02.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;신규 매핑할 항목의 정보 입력 : 예)프로세스 ID, 명칭 등</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;생성 위치 지정</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;매핑 저장</li>
		
		<li class="manualtitle">:: Mapping List 기 생성된 ITEM 마스터 매핑   :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_mapping03.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;매핑 대상 항목 선택</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;매핑 저장</li>
	</c:when>
	</c:choose>	
</div>
</body>
</html>