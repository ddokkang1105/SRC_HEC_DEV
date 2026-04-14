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
		<li class="manualtitle">:: 하위항목 생성  :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_item01.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;하위항목 메뉴 선택</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;[Add] 버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;정보 입력 : ID, 명칭, 항목계층, 관리조직, 작성자(작성자/관리조직 기본값은 로그인 사용자  및 소속조직) 입력 
		</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;[Save]버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;트리 정보 Refresh</li>
		
		<li class="manualtitle">:: 항목 이동  :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_item02.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;하위항목 메뉴 선택</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;이동할 항목 선택</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;[Move] 버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;선택한 항목을 이동시킬 항목 선택</li>
		  
		<li class="manualtitle">:: 복수항목 속성 편집 :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_item03.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;하위항목 메뉴 선택</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;속성 편집할 항목 선택</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;[Attribute] 버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;편집할 속성 선택(복수 개 선택 가능)</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;속성 별 정보 입력 후 저장</li>
		 
		<li class="manualtitle">:: Governance 편집 :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_item04.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;하위항목 메뉴 선택</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;편집할 항목 선택</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;[Gov] 버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;변경할 항목(담당자/관리조직/법인) 선택 (옵션 선택 : 하위항목 포함 여부)</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;정보 입력 및 저장</li>
	</c:when>
	
	<c:when test="${sessionScope.loginInfo.sessionCurrLangType ne '1042'}">
		<li class="manualtitle">:: 하위항목 생성  :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_item01.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;하위항목 메뉴 선택</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;[Add] 버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;정보 입력 : ID, 명칭, 항목계층, 관리조직, 작성자(작성자/관리조직 기본값은 로그인 사용자  및 소속조직) 입력 
		</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num04.png">&nbsp;[Save]버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num05.png">&nbsp;트리 정보 Refresh</li>
		
		<li class="manualtitle">:: 항목 이동  :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_item02.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;하위항목 메뉴 선택</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;이동할 항목 선택</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;[Move] 버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num04.png">&nbsp;선택한 항목을 이동시킬 항목 선택</li>
		  
		<li class="manualtitle">:: 복수항목 속성 편집 :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_item03.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;하위항목 메뉴 선택</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;속성 편집할 항목 선택</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;[Attribute] 버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num04.png">&nbsp;편집할 속성 선택(복수 개 선택 가능)</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num05.png">&nbsp;속성 별 정보 입력 후 저장</li>
		 
		<li class="manualtitle">:: Governance 편집 :: </li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_item04.png"></li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;하위항목 메뉴 선택</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;편집할 항목 선택</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;[Gov] 버튼 클릭</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num04.png">&nbsp;변경할 항목(담당자/관리조직/법인) 선택 (옵션 선택 : 하위항목 포함 여부)</li>
		<li><img src="${root}${HTML_IMG_DIR}/help/en/num05.png">&nbsp;정보 입력 및 저장</li>
	</c:when>
	</c:choose>	

</div>
</body>
</html>