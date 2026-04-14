<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00065" var="WM00065"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="${menu.LN00021}"/>

<title>${menu.LN00096}</title>
</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>

<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용
	
	// [Save] Click
	function saveAttrribute() { 
 		if(confirm("${CM00001}")){	
			var url = "zhdhi_saveBatchAttribute.do";
			ajaxSubmit(document.AttributeTypeList, url);
		}
	}

	// [save] 이벤트 후 처리
	function selfClose() {
		//var opener = window.dialogArguments;
		self.close();
		opener.urlReload();
	}

	function fnOnlyEnNum(obj){
		var regType = /^[A-Za-z0-9*]+$/;
        if(!regType.test(obj.value)) {
            obj.focus();
            $(obj).val( $(obj).val().replace(/[^A-Za-z0-9]/gi,"") );
            return false;
        }
    }
	
</script>
<body>
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00005}</p>
	</div>
	<form name="AttributeTypeList" id="AttributeTypeList" action="admin/saveAttributeType.do" method="post" onsubmit="return false;">
		<input type="hidden" id="itemID" name="itemID" value="${itemID}" />
		 <div class="mgT5 mgL5 mgR5">
		<table id="newObject" class="tbl_blue01" width="100%;">
			<colgroup>
				<col width="25%">
				<col>
			</colgroup>
			<!-- 변형 값 -->
			<tr>
				<th>${attrNameMap.ATPRD97 }</th>
				<td class="last">
					<textarea class="edit" id="ATPRD97" name="ATPRD97" style="width:99%;height:40px;resize:none;">${attrMap.ATPRD97 }</textarea>
				</td>
			</tr>
			<!-- 배치 유형 -->
			<tr>
				<th>${attrNameMap.ATPRD98 }</th>
				<td class="last">
				<!-- <select id="DataType" name="DataType" style="width:100%;"></select> -->
					<%-- <input type="text" class="text" id="ATPRD98" name="ATPRD98" value="${attrMap.ATPRD98 }" /> --%>
					<textarea class="edit" id="ATPRD98" name="ATPRD98" style="width:99%;height:20px;resize:none;">${attrMap.ATPRD98 }</textarea>
				</td>
			</tr>
			<!-- 비고 -->
			<tr>
				<th>${attrNameMap.ATPRD99 }</th>
				<td class="last">
					<%-- <input type="text" class="text" id="ATPRD99" name="ATPRD99" value="${attrMap.ATPRD99 }" /> --%>
					<textarea class="edit" id="ATPRD99" name="ATPRD99" style="width:99%;height:40px;resize:none;">${attrMap.ATPRD99 }</textarea>
				</td>
			</tr>
		</table>
	</div>

		<div class="alignBTN">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				&nbsp;<span class="btn_pack medium icon mgR10"><span class="save"></span><input value="Save" type="submit" onclick="saveAttrribute()"></span>
			</c:if>
		</div>

	</form>
	<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display: none" frameborder="0"></iframe>
</body>
</html>