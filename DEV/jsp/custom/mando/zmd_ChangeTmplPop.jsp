<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
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

<%@ include file="/WEB-INF/jsp/template/aesJsInc.jsp" %>
<script>

	$(document).ready(function(){	
		var data = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&dimTypeId=100001";
		fnSelect('s_dimValueID', data, 'getDimTypeValueId', '${defTempl}', 'Select');
		fnSelect('s_languageID','','langType','${defLanguageID}','Select');
	});
	
	
	function changeTempl(){
		var url = "changeTmpl.do";
		var target = "blankFrame";

		if(confirm("${CM00001}")){				
		    
			ajaxSubmitNoAdd(document.changeTmplFrm, url, target);
		}
	}
	
	function callbackSave(langID,langNm,tmplCd){
		opener.fnSetLanguage(langID,langNm,tmplCd);
		self.close();
	}
		
</script>
</head>
<body>
	<form name="changeTmplFrm" id="changeTmplFrm" action="#" method="post" onsubmit="return false;">	
	<input type="hidden" id="userId" name="userId" value="${sessionScope.loginInfo.sessionUserId}">
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;Change Region</p>
	</div>
	<div id="objectInfoDiv"  style="width:100%;overflow:auto;overflow-x:hidden;">
		<table class="tbl_preview mgT10"  width="80%" border="0" cellpadding="0" cellspacing="0"  >
			<tr>
				<th width="30%" style="word-break:break-all">Langauge</th>
				<td width="70%" align="left" class="last">					
	   				<select id="s_languageID" name="s_languageID" style="width:120px;"><option value="">Select</option></select>	   		
				</td>
			</tr>
			<tr>
				<th width="30%" style="word-break:break-all">Region</th>
				<td width="70%" align="left" class="last">					
	   				<select id="s_dimValueID" name="s_dimValueID" style="width:120px;"><option value="">Select</option></select>	   		
				</td>
			</tr>
		</table>
	</div>	
	<div  class="alignBTN" id="divUpdateModel" >
			<span class="btn_pack medium icon mgR10"><span class="save"></span>
				<input value="Save" type="submit" onclick="changeTempl()"></span>
	</div>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
	</form>
</body>
</html>