
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
		<li class="manualtitle">:: 화면구성   :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_main02.png""></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;대 메뉴  : 사용자 그룹 별/ 프로젝트 별 메뉴</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;중 메뉴  :  프로세스 분류체계 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;프로세스 구조도 : 프로세스 계층 구조 리스트</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;프로세스 항목 계층 별 상세 메뉴 리스트 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;상세 메뉴 별 콘텐트 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num06.png">&nbsp;공통 메뉴 : 게시판, 첨부 문서검색, 검색, 의견 게시판 </li>
		
		<li class="manualtitle">:: 개요 조회   :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_main03.png""></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;항목 공통 기본 정보 : ID, 명칭, 관련 조직/담당자 정보 등 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;항목 개별 속성 : 항목 유형 및 항목 계층 별 할당된 속성 리스트 조회 </li>
			
		<li class="manualtitle">:: 개요 편집   :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_main04.png""></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;[Edit] 버튼 클릭 후 정보 수정</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;개요정보 편집 후 [Save] 버튼 클릭</li>
		
		<li class="manualtitle">:: Report   :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_main05.png""></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;[Report] 버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;[doc] 버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;옵션 선택 후 [Save]버튼 클릭<br>
			<span> - 모델 그래픽만 출력(속성 제외)</span><br>
			<span> - 워드 파일 사이즈 선택</span><br></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;Word Report Sample	</li>
		
		<li class="manualtitle">:: Search   :: </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_search01.png"></li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;고급 검색</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;계층, ID, 담당조직/담당자, 속성 별, Dimension 별 조회</li>					
	</c:when>
	
	<c:when test="${sessionScope.loginInfo.sessionCurrLangType ne '1042'}">					
		<li class="manualtitle">:: 화면구성   :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_main02.png""></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;대 메뉴  : 사용자 그룹 별/ 프로젝트 별 메뉴</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;중 메뉴  :  프로세스 분류체계 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;프로세스 구조도 : 프로세스 계층 구조 리스트</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num04.png">&nbsp;프로세스 항목 계층 별 상세 메뉴 리스트 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num05.png">&nbsp;상세 메뉴 별 콘텐트 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num06.png">&nbsp;공통 메뉴 : 게시판, 첨부 문서검색, 검색, 의견 게시판 </li>
		
		<li class="manualtitle">:: 개요 조회   :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_main03.png""></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;항목 공통 기본 정보 : ID, 명칭, 관련 조직/담당자 정보 등 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;항목 개별 속성 : 항목 유형 및 항목 계층 별 할당된 속성 리스트 조회 </li>
			
		<li class="manualtitle">:: 개요 편집   :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_main04.png""></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;[Edit] 버튼 클릭 후 정보 수정</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;개요정보 편집 후 [Save] 버튼 클릭</li>
		
		<li class="manualtitle">:: Report   :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_main05.png""></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;[Report] 버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;[doc] 버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;옵션 선택 후 [Save]버튼 클릭<br>
			<span> - 모델 그래픽만 출력(속성 제외)</span><br>
			<span> - 워드 파일 사이즈 선택</span><br></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num04.png">&nbsp;Word Report Sample	</li>
		
		<li class="manualtitle">:: Search   :: </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_search01.png"></li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;고급 검색</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;계층, ID, 담당조직/담당자, 속성 별, Dimension 별 조회</li>
	</c:when>					

	</c:choose>			

</div>
</body>
</html>