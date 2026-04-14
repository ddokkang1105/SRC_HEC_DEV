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
		<li class="manualtitle"> :: Object Type :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_cfg01.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;Object Type 리스트 정보</li> 
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;Object type  상세정보 조회 및 편집</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;Object type 정보를 엑셀파일로 다운 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;[Add]버튼 클릭 후 Object type 정보 생성 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;기본정보 입력 후 [Save]버튼 클릭 </li>
		
		<li class="manualtitle"> :: Attribute Type :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_cfg02.png"></li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;Attribute Type 리스트 정보</li> 
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;Attribute type  상세정보 조회 및 편집</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;Attribute type 정보를 엑셀파일로 다운 </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;[Add]버튼 클릭 후 Attribute type 정보 생성 </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;기본정보 입력 후 [Save]버튼 클릭 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num06.png">&nbsp;항목유형 or 명칭으로 조건검색 </li>
		
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_cfg03.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;Attribute type 리스트 정보 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;항목유형이 LOV 인 경우 LOV 항목리스트를 확인</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;[Add]버튼 클릭 후 새로운 LOV생성 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;생성할 LOV 정보 입력 후 [Save]버튼 클릭</li>
		
		<li class="manualtitle"> :: Class Type :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_cfg04.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;Category와 Object로 조건 검색</li> 
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;Class Type 리스트 정보</li> 
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;Class type  상세정보 조회 및 편집</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;Class type 정보를 엑셀파일로 다운 </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;[Add]버튼 클릭 후 Class type 정보 생성 </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/ko/num06.png">&nbsp;기본정보 입력 후 [Save]버튼 클릭 </li>
		
		<li class="manualtitle"> :: File Type :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_cfg05.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;File Type 리스트 정보</li> 
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;File type  상세정보 조회 및 편집</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;File type 정보를 엑셀파일로 다운 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;[Add]버튼 클릭 후 File type 정보 생성 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;기본정보 입력 후 [Save]버튼 클릭 </li>
		
		<li class="manualtitle"> :: Report :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_cfg06.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;Report Type 리스트 정보</li> 
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;Report type  상세정보 조회 및 편집</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;Report type 정보를 엑셀파일로 다운 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;[Add]버튼 클릭 후 Report type 정보 생성 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;기본정보 입력 후 [Save]버튼 클릭 </li>
 	</c:when>
	
	<c:when test="${sessionScope.loginInfo.sessionCurrLangType ne '1042'}">
		<li class="manualtitle"> :: Object Type :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_cfg01.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;Object Type 리스트 정보</li> 
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;Object type  상세정보 조회 및 편집</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;Object type 정보를 엑셀파일로 다운 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num04.png">&nbsp;[Add]버튼 클릭 후 Object type 정보 생성 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num05.png">&nbsp;기본정보 입력 후 [Save]버튼 클릭 </li>
		
		<li class="manualtitle"> :: Attribute Type :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_cfg02.png"></li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;Attribute Type 리스트 정보</li> 
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;Attribute type  상세정보 조회 및 편집</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;Attribute type 정보를 엑셀파일로 다운 </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num04.png">&nbsp;[Add]버튼 클릭 후 Attribute type 정보 생성 </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num05.png">&nbsp;기본정보 입력 후 [Save]버튼 클릭 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num06.png">&nbsp;항목유형 or 명칭으로 조건검색 </li>
		
		<li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_cfg03.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;Attribute type 리스트 정보 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;항목유형이 LOV 인 경우 LOV 항목리스트를 확인</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;[Add]버튼 클릭 후 새로운 LOV생성 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num04.png">&nbsp;생성할 LOV 정보 입력 후 [Save]버튼 클릭</li>
		
		<li class="manualtitle"> :: Class Type :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_cfg04.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;Category와 Object로 조건 검색</li> 
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;Class Type 리스트 정보</li> 
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;Class type  상세정보 조회 및 편집</li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num04.png">&nbsp;Class type 정보를 엑셀파일로 다운 </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num05.png">&nbsp;[Add]버튼 클릭 후 Class type 정보 생성 </li>
	    <li><img src="${root}${HTML_IMG_DIR}/help/en/num06.png">&nbsp;기본정보 입력 후 [Save]버튼 클릭 </li>
		
		<li class="manualtitle"> :: File Type :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_cfg05.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;File Type 리스트 정보</li> 
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;File type  상세정보 조회 및 편집</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;File type 정보를 엑셀파일로 다운 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num04.png">&nbsp;[Add]버튼 클릭 후 File type 정보 생성 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num05.png">&nbsp;기본정보 입력 후 [Save]버튼 클릭 </li>
		
		<li class="manualtitle"> :: Report :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_cfg06.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;Report Type 리스트 정보</li> 
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;Report type  상세정보 조회 및 편집</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;Report type 정보를 엑셀파일로 다운 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num04.png">&nbsp;[Add]버튼 클릭 후 Report type 정보 생성 </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num05.png">&nbsp;기본정보 입력 후 [Save]버튼 클릭 </li>	
	</c:when>
	</c:choose>
 </div>
</body>
</html>
