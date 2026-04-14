﻿<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<c:url value="/" var="root"/>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico" />
<c:if test="${!empty htmlTitle}"><script>parent.document.title="${htmlTitle}";</script></c:if>

<jsp:include page="/WEB-INF/jsp/template/uiInc.jsp" flush="true"/>
<script src="${root}cmm/js/jquery/jquery.js" type="text/javascript"></script>
<script src="${root}cmm/js/xbolt/common.js" type="text/javascript"></script>
<%@ include file="/WEB-INF/jsp/template/aesJsInc.jsp" %>
<script src="${root}cmm/js/xbolt/ajaxHelper.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/cmm/js/xbolt/cookieHelper.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/overlap.css" />

<script type="text/javascript">
	function fnLogOutMove(){
		parent.fnQuitSystem();
	}

</script>
</head>
<body style="  display: flex;  align-items: center;">	
<form id="dfForm" name="dfForm" action="" method="post">
	<input name="srID" id="srID"  value="${srID}" type="hidden">
	<input name="mainType" id="mainType"  value="${mainType}" type="hidden">
	<input name="wfInstanceID" id="wfInstanceID"  value="${wfInstanceID}" type="hidden">
</form>	
<div class="aspNetHidden">
<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="/wEPDwUJMzMxNTIwMDczZGSsPAGBi+AQmz2EXu8V0HkdPY7MTp7tlZSDkou32RXKmA==">
</div>

<div class="aspNetHidden">

	<input type="hidden" name="__VIEWSTATEGENERATOR" id="__VIEWSTATEGENERATOR" value="76FD14A6">
</div>
 <div class="overlap">
  <div class="overlap_wrap">
      <div class="overlap_tit">
 	        <p class="tit_01">동일계정으로 다른 PC에서 로그인하여 <span class="point_color">로그아웃</span>되었습니다.</p>
             <p class="tit_02">접속아이피:${activLoginIp}</p>
         </div>
         <div class="overlap_btn_wrap">
 	        <div class="overlap_btn_box">
     	        <a href="javascript:fnLogOutMove();" class="overlap_btn03">나가기</a>
             </div>
         </div>
         <div class="overlap_con_wrap">
 	        <div class="overlap_con_box">
     	        <div class="overlap_con_tit">
         	        <span class="overlap_con_txt01">정보보안 가이드</span>
                 </div>
                 <div class="overlap_con_txt02">
         	        본 화면과 같이 동일계정(본인)으로 다른 PC에 접속이 된 경우,<br>
      <strong>먼저 비밀번호를 변경 후</strong>, 신고 및 문의 바랍니다.
                 </div>
                  <div class="overlap_con_txt03">
         	        * 단, 발령으로 전배시 이전 사업장에 근무하는 경우 타사업장으로 표시됨<br>
      * 출장등의 사유로 타 사업장에서 접속할 경우 타사업장으로 표시됨
                 </div>
             </div>
         </div>
     </div>
 </div>
 <div style="display:none" id="divCFN_PreLoginInfo"></div>
<div id="resultLogin"></div>	
<iframe name="saveLgFrame" id="saveLgFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
</html>