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
	        <!--  모델조회 -->
	        <li class="manualtitle"> :: 모델조회 화면 구성 ::</li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model01.png"></li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;모델 조회 화면 조정 아이콘</li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;모델링 오브젝트 속성 </li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;미니맵</li>
	        
	        <li class="manualtitle"> :: 모델 인쇄 페이지 셋업/인쇄 및 이미지 파일로 저장 :: </li>
	        <li class="pdT20"><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model02.png""></li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;인쇄 페이지 사이즈 설정</li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;인쇄 미리 보기 </li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;이미지 파일로 저장</li>
	        
	        <li class="manualtitle"> :: 모델 이미지 사이즈 조절, 새 창에서 보기, 모델편집 이동 :: </li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model03.png""></li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;실제크기</li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;확대 </li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;축소</li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;새 창에서 보기 </li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;모델 편집 창으로 이동</li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num06.png">&nbsp;오브젝트 속성 보이기/감추기</li>
	        
	        <li class="manualtitle"> :: 오브젝트 속성 편집 :: </li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model04.png""></li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;속성조회<br>
	            <span> - 선택된 심볼의 상세</span><br>
	            <span> - 속성 조회</span><br></li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;속성편집 </li>
	        
	        <li class="manualtitle">:: 오브젝트 상세정보 조회 :: </li>       
	        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model05.png"></li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;심볼 선택 → 마우스 우 클릭</li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;항목 상세 정보 Pop up </li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;모델 리스트 관리 </li>
	        <!--  //모델조회 -->
	    </c:when>
	    
	    <c:when test="${sessionScope.loginInfo.sessionCurrLangType ne '1042'}">
	        <!--  모델조회 -->
	        <li class="manualtitle"> :: 모델조회 화면 구성 ::</li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_model01.png"></li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;모델 조회 화면 조정 아이콘</li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;모델링 오브젝트 속성 </li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;미니맵</li>
	        
	        <li class="manualtitle"> :: 모델 인쇄 페이지 셋업/인쇄 및 이미지 파일로 저장 :: </li>
	        <li class="pdT20"><img src="${root}${HTML_IMG_DIR}/help/en/img_help_model02.png""></li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;인쇄 페이지 사이즈 설정</li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;인쇄 미리 보기 </li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;이미지 파일로 저장</li>
	        
	        <li class="manualtitle"> :: 모델 이미지 사이즈 조절, 새 창에서 보기, 모델편집 이동 :: </li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_model03.png""></li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;실제크기</li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;확대 </li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;축소</li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/en/num04.png">&nbsp;새 창에서 보기 </li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/en/num05.png">&nbsp;모델 편집 창으로 이동</li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/en/num06.png">&nbsp;오브젝트 속성 보이기/감추기</li>
	        
	        <li class="manualtitle"> :: 오브젝트 속성 편집 :: </li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_model04.png"></li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;속성조회<br>
	            <span> - 선택된 심볼의 상세</span><br>
	            <span> - 속성 조회</span><br></li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;속성편집 </li>
	        
	        <li class="manualtitle">:: 오브젝트 상세정보 조회 :: </li>       
	        <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_model05.png"></li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;심볼 선택 → 마우스 우 클릭</li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;항목 상세 정보 Pop up </li>
	        <li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;모델 리스트 관리 </li>
	        <!--  //모델조회 -->
	    </c:when>
	 	</c:choose>  
    </div>
</body>
</html>