<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>
<div id="user_manual">
	<c:choose>
	<c:when test="${sessionScope.loginInfo.sessionCurrLangType eq '1042'}">
	    <li class="manualtitle"> :: 사용자 그룹 리스트 :: </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_user01.png"></li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;사용자 그룹별 대 메뉴 [관리자] 선택</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;사용자 메뉴 선택</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;사용자 그룹 선택</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;사용자 그룹 리스트에서 해당 그룹을 클릭</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;사용자 그룹 상세 조회 및 편집</li>
	    
	     <li class="manualtitle"> :: 사용자 그룹 상세정보 :: </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_user02.png"></li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;사용자 그룹 정보 변경 후 [Save] 버튼 클릭<br>
	            <span>- 그룹명/대표 이메일/권한/소속 법인</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;사용자 그룹에 소속된 사용자 리스트</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;[Assign] 버튼 클릭<br>
	            <span>- 선택한 사용자 리스트를 사용자 그룹에 할당</span></li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_user03.png"></li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;조회권한 할당<br>
	            <span>- 대 메뉴에 대한 조회 권한 할당</span></li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;변경관리 프로젝트 할당<br>
	            <span>- CAR 생성 시 참조할 수 있는 변경관리 프로젝트 할당</span></li>
	
	    <li class="manualtitle"> :: 사용자 그룹 생성 :: </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_user04.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;[Add ]버튼 클릭<br>
		        <span>- 사용자 그룹 생성</span></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;사용자 그룹 정보 입력<br>
	            <span>-  ID/명칭/대표 이 메일/소속 법인/권한 선택</span></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;[Save] 버튼 클릭</li>
		
	  <li class="manualtitle"> ::  사용자 리스트 조회 및 편집 :: </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_user05.png"></li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;사용자 선택</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;사용자 정보 리스트에서 해당 사용자를 클릭</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;사용자 상세정보 조회 및 편집</li>	
	    
	  <li class="manualtitle"> ::  사용자 그룹 할당, 조회권한 설정, 변경관리 단위 지정 :: </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_user06.png"></li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;사용자 상세 정보<br>
	            <span>-  ID/ 명칭/ 사번/ 이메일/ 소속 법인/조직/ 권한</span>    </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;사용자 그룹 할당<br>
	            <span>- 사용자 그룹의 권한을 상속받음</span></li>            
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;[Assign] 버튼 클릭</li> 	
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;기본설정된 password로 변경</li>    
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_user07.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;조회 권한<br>
		        <span>- 조회 가능한 대 메뉴 할당</span>    </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;변경관리 단위<br>
		        <span>- CAR 생성 시 사용 가능한 변경 프로젝트 리스트</span></li>            
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;검색 조건<br>
		<span>-  항목유형(예: 프로세스, 시스템)<br></span>
		<span>- 항목계층</span></li>   
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;현 사용자 관리 항목 리스트</li>  
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;관리담당 수정</li>    
	     <li><img src="${root}${HTML_IMG_DIR}/help/ko/num06.png">&nbsp;변경 관리 담당자 검색 및 선택</li>    
	</c:when>
	
	<c:when test="${sessionScope.loginInfo.sessionCurrLangType ne '1042'}">
	    <li class="manualtitle"> :: 사용자 그룹 리스트 :: </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_user01.png"></li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;사용자 그룹별 대 메뉴 [관리자] 선택</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;사용자 메뉴 선택</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;사용자 그룹 선택</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num04.png">&nbsp;사용자 그룹 리스트에서 해당 그룹을 클릭</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num05.png">&nbsp;사용자 그룹 상세 조회 및 편집</li>
	    
	     <li class="manualtitle"> :: 사용자 그룹 상세정보 :: </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_user02.png"></li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;사용자 그룹 정보 변경 후 [Save] 버튼 클릭<br>
	            <span>- 그룹명/대표 이메일/권한/소속 법인</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;사용자 그룹에 소속된 사용자 리스트</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;[Assign] 버튼 클릭<br>
	            <span>- 선택한 사용자 리스트를 사용자 그룹에 할당</span></li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_user03.png"></li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num04.png">&nbsp;조회권한 할당<br>
	            <span>- 대 메뉴에 대한 조회 권한 할당</span></li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num05.png">&nbsp;변경관리 프로젝트 할당<br>
	            <span>- CAR 생성 시 참조할 수 있는 변경관리 프로젝트 할당</span></li>
	
	    <li class="manualtitle"> :: 사용자 그룹 생성 :: </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_user04.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;[Add ]버튼 클릭<br>
		        <span>- 사용자 그룹 생성</span></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;사용자 그룹 정보 입력<br>
	            <span>-  ID/명칭/대표 이 메일/소속 법인/권한 선택</span></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;[Save] 버튼 클릭</li>
		
	  <li class="manualtitle"> ::  사용자 리스트 조회 및 편집 :: </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_user05.png"></li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;사용자 선택</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;사용자 정보 리스트에서 해당 사용자를 클릭</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;사용자 상세정보 조회 및 편집</li>	
	    
	  <li class="manualtitle"> ::  사용자 그룹 할당, 조회권한 설정, 변경관리 단위 지정 :: </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_user06.png"></li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;사용자 상세 정보<br>
	            <span>-  ID/ 명칭/ 사번/ 이메일/ 소속 법인/조직/ 권한</span>    </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;사용자 그룹 할당<br>
	            <span>- 사용자 그룹의 권한을 상속받음</span></li>            
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;[Assign] 버튼 클릭</li> 	
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num04.png">&nbsp;기본설정된 password로 변경</li>    
		<li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_user07.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;조회 권한<br>
		        <span>- 조회 가능한 대 메뉴 할당</span>    </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;변경관리 단위<br>
		        <span>- CAR 생성 시 사용 가능한 변경 프로젝트 리스트</span></li>            
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;검색 조건<br>
		<span>-  항목유형(예: 프로세스, 시스템)<br></span>
		<span>- 항목계층</span></li>   
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num04.png">&nbsp;현 사용자 관리 항목 리스트</li>  
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num05.png">&nbsp;관리담당 수정</li>    
	     <li><img src="${root}${HTML_IMG_DIR}/help/en/num06.png">&nbsp;변경 관리 담당자 검색 및 선택</li>    
	</c:when>
	</c:choose>
</div>
</body>
</html>