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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="${menu.LN00033}"/> <!-- Category 입력 체크  -->

<script>

	$(document).ready(function(){	
		fnSelect('MTCTypeCode', '&copyMdl=Y', 'MTCTypeCode', '', 'Select');
	});
	
	function fnCopyModel(){
		var MTCTypeCode = $("#MTCTypeCode").val();
		if(MTCTypeCode == ""){alert("${WM00034}"); return;}
		if(confirm("${CM00001}")){			
			var url = "copyModel.do";
			var target = "blankFrame";	
		
			ajaxSubmitNoAdd(document.mdListFrm, url, target);
		}
	}
	
	function callbackSave(){
		self.close();
		opener.reloadList();		
	}

</script>
	
<body>
	<form name="mdListFrm" id="mdListFrm" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="Creator" name="Creator" value="${sessionScope.loginInfo.sessionUserId}" >	
		<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" >
		<input type="hidden" id="includeItemMaster" name="includeItemMaster" value="Y" >		
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;${menu.LN00154}</p>
	</div>
	<div id="objectInfoDiv"  style="width:100%;overflow:auto;overflow-x:hidden;">
		<table class="tbl_preview mgT10"  width="80%" border="0" cellpadding="0" cellspacing="0"  >
			<tr>
				<th width="30%" style="word-break:break-all">${menu.LN00028}</th>
				<td width="70%" align="left" class="last">
					<input type="text" id="ModelName" name="ModelName" value="${ModelName}"  class="text"  style="width:250px;margin-left=5px;">	
					<input type="hidden" id="ModelID" name="ModelID" value="${ModelID}"  class="text">	
				</td>
			</tr>
			<tr>
				<th width="30%" style="word-break:break-all">${menu.LN00033}</th>
				<td width="70%" align="left">
					<select id="MTCTypeCode" name="MTCTypeCode" class="sel" style="width:250px;margin-left=5px;"></select>
				</td>
			</tr>
		</table>
	</div>	
	<div  class="alignBTN mgR10" id="divUpdateModel" >
			<span class="btn_pack small icon"><span class="copy"></span>
				<input value="Copy" type="submit" onclick="fnCopyModel()"></span>
	</div>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
	</form>
</body>
</html>