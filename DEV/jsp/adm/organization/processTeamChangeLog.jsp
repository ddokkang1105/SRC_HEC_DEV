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

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>

<title>${menu.LN00096}</title>
</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>

<!-- 2. Script  -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용

	function editProcessLog(){		
		if(confirm("${CM00001}")){			
			var url = "updateTeamChangeLog.do";
			var data = "&items=" + $("#items").val() + "&userID=" + $("#userID").val() 
						+ "&languageID=" + $("#languageID").val()
						+ "&comment=" + $("#comment").val();
			ajaxPage(url,data,"blankFrame");
		}
	}

	function fnCallBack() {
		alert("${WM00067}");
		opener.doSearchList();
		self.close();
	}
	
</script>
<body>
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Edit Action result</p>
	</div>
	<form name="ProcessLogPopList" id="ProcessLogPopList" action="editProcessLog.do" method="post">
		 <input type="hidden" id="items" name="items" value="${items}"/>
		 <input type="hidden" id="userID" name="userID" value="${sessionScope.loginInfo.sessionUserId}"/>
		 <input type="hidden" id="languageID" name="languageID" value="${languageID}"/>
		  <div class="mgT5 mgL5 mgR5">		 
			<table id="newObject" class="tbl_blue01" width="100%;">	
				<colgroup>
					<col width="25%">
					<col>
				</colgroup>					
				<tr>
					<th>Comment</th>
					<td class="last">
						<textarea id="comment" name="comment" style="width:98%; height:110px; border:1px solid #ccc; resize:none;"></textarea>
					</td>
				</tr>
			</table>
		</div>
		<div class="alignBTN">
			&nbsp;<span class="btn_pack medium icon"><span class="save"></span><input
				value="Save" type="button" onclick="editProcessLog()"></span>
		</div>
		
	</form>
	
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none;height:0px;" frameborder="0" scrolling='no'></iframe>
	</div>
	
</body>
</html>