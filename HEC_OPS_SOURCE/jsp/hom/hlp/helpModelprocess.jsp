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
 		<li class="manualtitle">:: 모델비교 리포트   :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model17.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;[Report]버튼 클릭</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;Model comparison report [EXE] 버튼 클릭</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;비교할 두 Model ID 선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;[Report] 버튼 클릭</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;모델 비교 리스트 확인<br>
            <span>- NEW : 새로 생성된 아이템</span><br>
            <span>- Deleted : 삭제된 아이템</span><br>
            <span>- NoChange : 그대로인 아이템</span><bmmr></li>
            
        <li class="manualtitle">:: 모델검증 리포트   :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/img_help_model18.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num01.png">&nbsp;[Report]버튼 클릭</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num02.png">&nbsp;Validation check for items [EXE] 버튼 클릭</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num03.png">&nbsp;검증할 Model ID 선택 </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num04.png">&nbsp;[Report] 버튼 클릭</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/ko/num05.png">&nbsp;Outbound check/ Inbound check 리스트 확인</li>
	</c:when>
	
	<c:when test="${sessionScope.loginInfo.sessionCurrLangType ne '1042'}">
 		<li class="manualtitle">:: 모델비교 리포트   :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_model17.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;[Report]버튼 클릭</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;Model comparison report [EXE] 버튼 클릭</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;비교할 두 Model ID 선택</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num04.png">&nbsp;[Report] 버튼 클릭</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num05.png">&nbsp;모델 비교 리스트 확인<br>
            <span>- NEW : 새로 생성된 아이템</span><br>
            <span>- Deleted : 삭제된 아이템</span><br>
            <span>- NoChange : 그대로인 아이템</span><bmmr></li>
            
        <li class="manualtitle">:: 모델검증 리포트   :: </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/img_help_model18.png"></li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num01.png">&nbsp;[Report]버튼 클릭</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num02.png">&nbsp;Validation check for items [EXE] 버튼 클릭</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num03.png">&nbsp;검증할 Model ID 선택 </li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num04.png">&nbsp;[Report] 버튼 클릭</li>
        <li><img src="${root}${HTML_IMG_DIR}/help/en/num05.png">&nbsp;Outbound check/ Inbound check 리스트 확인</li>
	</c:when>
	</c:choose>        
</div>
</body>
</html>