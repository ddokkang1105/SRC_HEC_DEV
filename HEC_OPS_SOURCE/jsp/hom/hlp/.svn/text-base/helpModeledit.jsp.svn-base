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
		<li class="manualtitle">:: 오브젝트(심볼) 추가  :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model10.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;팔레트에서 심볼 선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;심볼 Drag</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;명칭 변경(F2 or 마우스 클릭)</li>
        
        <li class="manualtitle">:: 연결선 추가  :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model11.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;연결선(꺽인 선)</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;연결선(직선)</li>
        
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;팔레트에서 연결선 선택 후 소스 심볼 경계선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;타겟 심볼 경계선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;연결선 선택 → F2 → 연결선 정보 입력</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num06.png">&nbsp;연결선 위치 조정 연결선 선택  → 마우스 drag</li>

        <li class="manualtitle">:: 오브젝트 링크 편집 :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model12.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;심볼 선택 → 마우스 우측버튼 → 링크 편집 선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;연결시킬 오브젝트 검색 및 선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;연결된 오브젝트 명 확인 및 링크 열기</li>        
        
        <li class="manualtitle">:: 오브젝트 속성 편집 :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model13.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;심볼 선택 → 마우스 우측버튼 → 속성 편집 선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;속성 편집 및 저장</li>        
                
        <li class="manualtitle">:: 항목상세정보 :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model14.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;심볼 선택 → 마우스 우측버튼 → 항목상세정보 선택 </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;개요와 연관항목 정보 확인</li>         
        
        <li class="manualtitle">:: 오브젝트 심볼변경 :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model15.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;심볼 선택 → 마우스 우측버튼  → 심볼변경 선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;변경할 심볼을 선택 </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp; [Add]버튼 클릭</li>         
        
        <li class="manualtitle">:: 모델 저장 및 릴리즈 :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model16.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;임시저장 : 모델 편집 메뉴에서만 변경된 모델이 조회되며, 모델 조회 화면에서는 변경 이 전 버전의 모델만 조회
                <Br>신규 생성되거나 업데이트된 오브젝트가 DB에 반영되지 않음</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;릴리즈 : 모든 사용자 및 조회화면에서 변경된 내용이 조회되고 변경된 오브젝트 값이 DB에 업데이트됨</li>                 
        <!--  //모델편집 -->
      </c:when>
      
      <c:when test="${sessionScope.loginInfo.sessionCurrLangType ne '1042'}">	
		<li class="manualtitle">:: 오브젝트(심볼) 추가  :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_model10.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;팔레트에서 심볼 선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;심볼 Drag</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;명칭 변경(F2 or 마우스 클릭)</li>
        
        <li class="manualtitle">:: 연결선 추가  :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_model11.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;연결선(꺽인 선)</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;연결선(직선)</li>
        
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;팔레트에서 연결선 선택 후 소스 심볼 경계선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num04.png">&nbsp;타겟 심볼 경계선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num05.png">&nbsp;연결선 선택 → F2 → 연결선 정보 입력</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num06.png">&nbsp;연결선 위치 조정 연결선 선택  → 마우스 drag</li>

        <li class="manualtitle">:: 오브젝트 링크 편집 :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_model12.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;심볼 선택 → 마우스 우측버튼 → 링크 편집 선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;연결시킬 오브젝트 검색 및 선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;연결된 오브젝트 명 확인 및 링크 열기</li>        
        
        <li class="manualtitle">:: 오브젝트 속성 편집 :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_model13.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;심볼 선택 → 마우스 우측버튼 → 속성 편집 선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;속성 편집 및 저장</li>        
                
        <li class="manualtitle">:: 항목상세정보 :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_model14.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;심볼 선택 → 마우스 우측버튼 → 항목상세정보 선택 </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;개요와 연관항목 정보 확인</li>         
        
        <li class="manualtitle">:: 오브젝트 심볼변경 :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_model15.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;심볼 선택 → 마우스 우측버튼  → 심볼변경 선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;변경할 심볼을 선택 </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp; [Add]버튼 클릭</li>         
        
        <li class="manualtitle">:: 모델 저장 및 릴리즈 :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_model16.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;임시저장 : 모델 편집 메뉴에서만 변경된 모델이 조회되며, 모델 조회 화면에서는 변경 이 전 버전의 모델만 조회
                <Br>신규 생성되거나 업데이트된 오브젝트가 DB에 반영되지 않음</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;릴리즈 : 모든 사용자 및 조회화면에서 변경된 내용이 조회되고 변경된 오브젝트 값이 DB에 업데이트됨</li>                 
        <!--  //모델편집 -->
      </c:when>
      
      </c:choose>
    </div>
</body>
</html>