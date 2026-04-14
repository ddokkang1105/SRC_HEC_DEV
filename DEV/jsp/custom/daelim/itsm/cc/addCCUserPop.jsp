<%@page import="java.sql.PreparedStatement"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%-- <%@ include file="/WEB-INF/jsp/template/autoCompText.jsp"%> --%>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00065" var="WM00065"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="Object"/>

<title>Add CC User</title>
</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>

<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용

	$(document).ready(function() {
		fnSelect('getLanguageID', '', 'langType', '${LanguageID}','Select');
	});
	
	
// 	function setSearchName(memberID,memberName){$('#objName').val(memberID);$('#MemberID').val(memberName);}

	
	// [Add] click
	function saveCCUserAdd() { 	
		if(confirm("${CM00001}")){		//if(confirm("저장하시겠습니까?"))
			var url = "saveCCUser.do";
			ajaxSubmit(document.CCUserFrm, url, "blankFrame");
		}
	}
	// [save] 이벤트 후 처리
	function selfClose() {
		//var opener = window.dialogArguments;
		opener.doOTSearchList();
		self.close();
	}
	
</script>
<body>
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00005}</p>
	</div>
	<form name="CCUserFrm" id="CCUserFrm" action="#" method="post" onsubmit="return false;">
		 <input type="hidden" id="LanguageID" name="LanguageID" value="${LanguageID}"> 
		 <input type="hidden" id="MemberID" name="MemberID" value="${memberID}" />
		 
		  <div class="mgT5 mgL5 mgR5">
		<table id="newObject" class="tbl_blue01" width="100%;">
			<colgroup>
				<col width="25%">
				<col>
			</colgroup>
		
			<!-- 이름 -->		
			<tr>
				<th class="viewtop">이름</th>
				<td  class="last viewtop">
					<select id="objName" name="objName" class="sel">
						<option value="">select</option>
							<c:forEach var="user" items="${ccUserList}">
				            	<option value="${user.MemberID}">${user.Name}</option>
				            </c:forEach>
			        	</select>
				</td>
			</tr>
			
			<!-- 상태 -->
			<tr>
				<th>상태</th>
				<td  class="last">
					<select id="objStatus" name="objStatus" class="sel">
			            <option value="22">교육</option>
			            <option value="13">상담후 작업</option>
			            <option value="3">상담 대기중</option>
			            <option value="21">원격 연결</option>
			            <option value="23">휴가</option>
			            <option value="24">식사</option>
			            <option value="27">로그아웃</option>
		        	</select>
        		</td>
			</tr>
			
			<!-- 사용유무 -->	
			<tr>
				<th>사용유무</th>
				<td  class="last">
					<select id="objUseYN" name="objUseYN" class="sel">
				            <option value="Y">Y</option>
				            <option value="N">N</option>
			        </select>
        		</td>
			</tr>
			
			<!-- isManager -->	
<!-- 			<tr> -->
<!-- 				<th>isManager</th>  -->
<!-- 				<td  class="last"> -->
<!-- 					  <input type="checkbox" id="objisManager" name="objisManager" value="1" /> -->
<!--         		</td> -->
<!-- 			</tr> -->
			
		</table>
</div>
		<div class="alignBTN">
			<button class="cmm-btn2 mgR5" style="height: 30px;" onclick="saveCCUserAdd()" value="Save">Save</button>
		</div>

	</form>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display: none" frameborder="0"></iframe>
	

<!-- <script defer> 
	if("${memberID}" == ""){
		autoCompMbrNM("objName",setSearchName);
	}
</script> -->


</body>
</html>