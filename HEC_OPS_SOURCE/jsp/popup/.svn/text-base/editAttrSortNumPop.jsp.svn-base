<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root" />

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

<title>Edit SortNum</title>

<!-- 2. Script -->
<script type="text/javascript">

$(document).ready(function(){
	document.getElementById('sortNumArea').style.height = (setWindowHeight() - 80)+"px";	
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

function saveAttrribute() { 
	if(confirm("${CM00001}")){	
		// 화면에서 선택한 sortnum을 각 AttrTypeCode별로 셋팅
		<c:forEach var="i" items="${allocatedAttrList}">
			var selectId = "${i.AttrTypeCode}";
			var selectedValue = $("#" + selectId).val();
			$("#hid" + selectId).val(selectedValue);
		</c:forEach>
		
		var url = "saveAttrSortNum.do";
		ajaxSubmit(document.attrSortNumFrm, url, "blankFrame");
	}
}

// [save] 이벤트 후 처리
function selfClose() {
	//var opener = window.dialogArguments;
	opener.objReload();
	self.close();
}

</script>

<div class="child_search_head">
	<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Edit SortNum</p>
</div>

<form name="attrSortNumFrm" id="attrSortNumFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="itemTypeCode" name="itemTypeCode" value="${itemTypeCode}" />
	<c:forEach var="i" items="${allocatedAttrList}">
		<input type="hidden" id="hid${i.AttrTypeCode}" name="hid${i.AttrTypeCode}" value="" />
	</c:forEach>
	
	<div id="sortNumArea" style="overflow:auto;margin:5px;overflow-x:hidden;">
		<table width="98%" cellpadding="0" cellspacing="0" border="0" class="tbl_blue01">
			<colgroup>
				<col width="20%">
				<col width="20%">
				<col width="8%">
			</colgroup>
			<tr>
				<th class="last viewtop">AttrTypeCode</th>
				<th class="viewtop last">Name</th>
				<th class="viewtop last" >SortNum</th>
			</tr>
			
			<c:forEach var="list" items="${allocatedAttrList}" varStatus="status">
				<tr>
					<td class="last">${list.AttrTypeCode}</td>
					<td class="alignL last">${list.Name}</td>
					<td class="last">
						<select id="${list.AttrTypeCode}" name="${list.AttrTypeCode}" class="sel">
							<c:forEach var="i" items="${sortNumList}" varStatus="status">
								<option value="${i.Value}" <c:if test="${list.GSortNum == i.Value}">selected="selected"</c:if>>${i.Name}</option>						
							</c:forEach>
						</select>
					</td>
				</tr>
			</c:forEach>
		</table>
	</div>
	<div class="alignBTN">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<span class="btn_pack medium icon mgR10"><span class="save"></span><input value="Save" type="submit" onclick="saveAttrribute()"></span>
		</c:if>
	</div>

</form>
<!-- START :: FRAME -->
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
</div>
