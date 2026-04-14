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
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&category=TEAMROLETP";
		fnSelect('roleType', data, 'getDictionary', '', 'Select');
	});
	
	function fnOpenOrgTree() { 
		var roleTypeCode = $("#roleType").val();
		var roleTypeName= $("#roleType option:selected").text();
		opener.fnGoOrgTreePop(roleTypeCode,roleTypeName);
		self.close();
	}

</script>
	
<body>
	<form name="mdListFrm" id="mdListFrm" action="#" method="post" onsubmit="return false;">
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;${menu.LN00127}</p>
	</div>
	<div id="objectInfoDiv"  style="width:100%;overflow:auto;overflow-x:hidden;">
		<table class="tbl_preview mgT10"  width="80%" border="0" cellpadding="0" cellspacing="0"  >
			<tr>
				<th width="30%" style="word-break:break-all">Team Role Type</th>
				<td width="70%" align="left" class="last">
					<select id="roleType" name="roleType" class="sel" style="width:250px;margin-left=5px;"></select>
				</td>
			</tr>
		</table>
		<div class="alignBTN mgR10">	
		<span class="btn_pack medium icon"><span class="next"></span>
			<input value="Next" type="button" onclick="fnOpenOrgTree()"></span>
		</div>
	</div>
	
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
	</form>
</body>
</html>