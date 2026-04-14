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
        <li class="manualtitle">:: 모델 리스트 조회 :: </li>  
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model06.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;모델 리스트</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;모델 복사, 생성, 삭제, 리스트 다운로드</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;모델 편집, 모델 속성 편집</li>
        
        <li class="manualtitle">:: 모델 생성 및 초기화 :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model07.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;프로세스 리스트 엑셀 템플릿</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;프로세스 모델 초기화</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;프로세스 모델 완성</li>
        
        <li class="manualtitle">:: 모델 신규 생성  :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model08.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;[Add]버튼 클릭</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;모델명 입력</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;모델 카테고리 선택<br>
            <span> -  Base : 현행 모델</span><br>
            <span> - TEMP : 임시 모델</span><br>
            <span> - TOBE : 미래모델</span><br>
            <span> -  Version : 백업 모델(Read only)    </span></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;모델 유형 선택<br>
            <span> - Process Flow chart : 단위 프로세스(L4) 흐름도</span><br>
            <span>  - Structure model : 프로세스 구조도(L2 or L3)</span><br>
            <span>  - E2E Scenario map </span>           </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;[Save]버튼을 클릭하여 저장<br></li>
        
        <li class="manualtitle">:: 모델 복사  :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model09.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;복사 대상 모델 선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;[Copy]버튼 클릭</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;신규 생성 모델 명 입력 및 모델 카테고리 선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;[Copy]버튼 클릭하여 복사</li>
        <!--  //모델관리 -->
	</c:when>
	
	<c:when test="${sessionScope.loginInfo.sessionCurrLangType ne '1042'}">
        <li class="manualtitle">:: 모델 리스트 조회 :: </li>  
        <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_model06.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;모델 리스트</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;모델 복사, 생성, 삭제, 리스트 다운로드</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;모델 편집, 모델 속성 편집</li>
        
        <li class="manualtitle">:: 모델 생성 및 초기화 :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model07.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;프로세스 리스트 엑셀 템플릿</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;프로세스 모델 초기화</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;프로세스 모델 완성</li>
        
        <li class="manualtitle">:: 모델 신규 생성  :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_model08.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;[Add]버튼 클릭</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;모델명 입력</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;모델 카테고리 선택<br>
            <span> -  Base : 현행 모델</span><br>
            <span> - TEMP : 임시 모델</span><br>
            <span> - TOBE : 미래모델</span><br>
            <span> -  Version : 백업 모델(Read only)    </span></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;모델 유형 선택<br>
            <span> - Process Flow chart : 단위 프로세스(L4) 흐름도</span><br>
            <span>  - Structure model : 프로세스 구조도(L2 or L3)</span><br>
            <span>  - E2E Scenario map </span>           </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num05.png">&nbsp;[Save]버튼을 클릭하여 저장<br></li>
        
        <li class="manualtitle">:: 모델 복사  :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_model09.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;복사 대상 모델 선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;[Copy]버튼 클릭</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;신규 생성 모델 명 입력 및 모델 카테고리 선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num04.png">&nbsp;[Copy]버튼 클릭하여 복사</li>
        <!--  //모델관리 -->
	</c:when>
	</c:choose>        
</div>
</body>
</html>