<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_1" arguments="${menu.LN00033}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_2" arguments="${menu.LN00032}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_3" arguments="referenceModel"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>

<script>

	$(document).ready(function(){	
		var data = "&ItemTypeCode=${ItemTypeCode}";
		fnSelect('MTCTypeCode', '', 'MTCTypeCode', '', 'Select');
		fnSelect('ModelTypeCode', data, 'getMDLTypeCode', '', 'Select'); 
	});
		
	// 트리 오픈
	function openE2eTreeListPop(){
		
		var newModelName = $("#newModelName").val(); 
		var MTCTypeCode = $("#MTCTypeCode").val();
		var ModelTypeCode = $("#ModelTypeCode").val();
		var ItemTypeCode = "${ItemTypeCode}"; 
		if(newModelName==""){ alert("${WM00034}"); return; }
		if(MTCTypeCode==""){ alert("${WM00041_1}"); return; }
		if(ModelTypeCode==""){ alert("${WM00041_2}"); return; }
		var arcFilter = "${arcFilter}"; 
		opener.openE2eTreeListPop(newModelName, MTCTypeCode, ModelTypeCode, ItemTypeCode, arcFilter);
		self.close();
	}
</script>
	
<body>
	<form name="mdListFrm" id="mdListFrm" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="ItemID" name="ItemID" value="${ItemID}" >
		<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" >
		<input type="hidden" id="loginID" name="loginID" value="${sessionScope.loginInfo.sessionUserId}">
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;${menu.LN00167}</p>
	</div>
	<div id="objectInfoDiv"  style="width:100%;overflow:auto;overflow-x:hidden;">
		<table class="tbl_preview mgT10"  width="80%" border="0" cellpadding="0" cellspacing="0"  >
			<tr>
				<th width="30%" style="word-break:break-all">${menu.LN00028}</th>
				<td width="70%" align="left" class="last">
					<input type="text" id="newModelName" name="newModelName" value=""  class="text"  style="width:250px;margin-left=5px;">	
				</td>
			</tr>
			<tr>
				<th width="30%" style="word-break:break-all">${menu.LN00033}</th>
				<td width="70%" align="left"  class="last">
					<select id="MTCTypeCode" name="MTCTypeCode" class="sel" style="width:250px;margin-left=5px;"></select>
				</td>
			</tr>
			<tr>
				<th width="30%" style="word-break:break-all">${menu.LN00032}</th>
				<td width="70%" align="left" class="last">
					<select id="ModelTypeCode" name="ModelTypeCode" class="sel" style="width:250px;margin-left=5px;"></select>
				</td>
			</tr>
		</table>
	</div>	
	<div  class="alignBTN" id="divUpdateModel" >
			<span class="btn_pack medium icon"><span class="next"></span>
				<input value="Next" type="submit" onclick="openE2eTreeListPop()"></span>
	</div>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
	</form>
</body>
</html>