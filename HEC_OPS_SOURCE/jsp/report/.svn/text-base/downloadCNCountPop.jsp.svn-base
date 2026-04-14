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

<script>

	$(document).ready(function(){	
		var data = "&itemTypeCode=${itemTypeCode}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&option=${itemTypeCode}";
		fnSelect('CNType', data, 'getCNType');
		fnSelect('itemClass', data, 'classCodeOption');
		
		var CNTypeCode = $("#CNType").val();
		fnGetAttrTypeCode(CNTypeCode);
		
	});
	
	function fnGetAttrTypeCode(CNTypeCode){
		var data = "&itemTypeCode="+CNTypeCode+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('attrType', data, 'getAttrType');
	}
	
	function fnGoNext(){
		var CNTypeCode = $("#CNType").val();
		var itemClassCode = $("#itemClass").val();
		var attrTypeCode = $("#attrType").val();
		var treeItemTypeCode = "${itemTypeCode}";
		opener.fnDownloadCNCount(CNTypeCode, itemClassCode, attrTypeCode,treeItemTypeCode);
		self.close();
	}

</script>
	
<body>	
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;Select Connection Type And Attribute Type</p>
	</div>
	<div id="objectInfoDiv"  style="width:100%;overflow:auto;overflow-x:hidden;">
		<table class="tbl_preview mgT10"  width="80%" border="0" cellpadding="0" cellspacing="0"  >
			<tr>
				<th width="30%" style="word-break:break-all">Connection Type</th>
				<td width="70%" align="left" class="last">
					<select id="CNType" name="CNType" class="sel" OnChange="fnGetAttrTypeCode(this.value);" style="width:250px;margin-left=5px;"></select>	
				</td>
			</tr>
			<tr>
				<th width="30%" style="word-break:break-all">Item Class</th>
				<td width="70%" align="left" class="last">
					<select id="itemClass" name="itemClass" class="sel" style="width:250px;margin-left=5px;"></select>	
				</td>
			</tr>
			<tr>
				<th width="30%" style="word-break:break-all">Attribute</th>
				<td width="70%" align="left" class="last">
					<select id="attrType" name="attrType" class="sel" style="width:250px;margin-left=5px;"></select>	
				</td>
			</tr>
		</table>
	</div>	
	<div  class="alignBTN mgR10">
		<span class="btn_pack medium icon"><span class="next"></span>
				<input value="Next" type="submit" onclick="fnGoNext()"></span>
	</div>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
</html>