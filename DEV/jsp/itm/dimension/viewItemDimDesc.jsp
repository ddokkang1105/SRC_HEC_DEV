<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<c:url value="/" var="root" />
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message	code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001"	var="CM00001" />

<script type="text/javascript">
	function fnSubmit() {
		if (confirm("${CM00001}")) {
			var url = "saveItemDim.do";
			ajaxSubmit(document.testCommentFrm, url);
		}
	}

	/**
	 * @function fnCallBack
	 * @description DHTMLX(parent)와 레거시(opener)를 모두 지원하는 심플 분기 처리
	 */
	function fnCallBack() {

		// 1. 일반 팝업 환경 체크
		if (opener && !opener.closed) {
			if (typeof opener.assignClose === "function") opener.assignClose();
			self.close();
		}

		// 2. openUrlWithDhxModal 환경 체크
		else {
			if (typeof onSaveItemDimDescComplete === 'function') {
				onSaveItemDimDescComplete();
			}
		}
	}

</script>
</head>
<body>
	<div id="testCommentDiv" style="padding: 10px;">
		<form name="testCommentFrm" id="testCommentFrm" method="post" action="#" onsubmit="return false;">
			<input type="hidden" id="itemID" name="itemID" value="${s_itemID}" />
			<input type="hidden" id="dimValueId" name="dimValueId" value="${dimValueId}" />
			<input type="hidden" id="dimTypeId" name="dimTypeId" value="${dimTypeId}" />

			<div class="cop_hdtitle mgB10">
				<h3><img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;Description</h3>
			</div>
			<table class="tbl_blue01" style="table-layout: fixed;" width="100%" 	border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td class="last"><textarea id="description" name="description" style="width: 99%; height: 180px;resize: none;" <c:if test="${sessionScope.loginInfo.sessionUserId ne authorID}">readonly</c:if>>${dimInfo.Description}</textarea></td>
				</tr>
			</table>
			<div class="alignBTN">
			<c:if test="${sessionScope.loginInfo.sessionUserId eq authorID}">
				<span id="viewSave" class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit"	onclick="fnSubmit()"></span>
			</c:if>
			</div>
		</form>
		<div style="display: none;">
			<iframe id="saveFrame" name="saveFrame" style="width: 0px; height: 0px; display: none;"></iframe>
		</div>
	</div>
</body>
</html>