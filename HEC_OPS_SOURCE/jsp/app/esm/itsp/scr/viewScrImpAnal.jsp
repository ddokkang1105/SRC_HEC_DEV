<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script>
	function fnEditScrImpAnal(){
		var url = "editScrImpAnal.do";
		var data = "scrId=${scrId}"
		var target = "viewScrDiv";
		ajaxPage(url, data, target);
	}
</script>
<div id="viewScrDiv">
	<form name="scrImpAnalFrm" id="scrImpAnalFrm" action="#" method="post" onsubmit="return false;">
		<div class="floatC" style="overflow:auto;overflow-x:hidden;">
			<c:if test="${scrUserID eq sessionScope.loginInfo.sessionUserId && scrStatus eq 'EDT'}">
			<div class="floatR mgR10 mgB10">
				<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="submit" onclick="fnEditScrImpAnal()"></span>
			</div>
			</c:if>
			<table class="tbl_blue01 mgT10 cb_module" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
				<colgroup>
					<col width="15%">
					<col width="85%">
				</colgroup>
				<tr>
					<th class="alignL pdL10 viewline">아키텍처 분석</th>
					<td class="alignL last"><textarea style="width:100%;height:50px;background: #fff;" readOnly="true">${scrInfo.ARCAnalInfo}</textarea></td>		
				</tr>
				<tr>
					<th class="alignL pdL10 viewline">변경영향 검토결과</th>
					<td class="alignL last"><textarea style="width:100%;height:50px;background: #fff;" readOnly="true">${scrInfo.ImpRewResult}</textarea></td>		
				</tr>
				<tr>
					<th class="alignL pdL10 viewline">형상관리 검토결과</th>
					<td class="alignL last"><textarea style="width:100%;height:50px;background: #fff;" readOnly="true">${scrInfo.CMRewResult}</textarea></td>		
				</tr>
				<tr>
					<th class="alignL pdL10 viewline">이슈사항</th>
					<td class="alignL last"><textarea style="width:100%;height:50px;background: #fff;" readOnly="true">${scrInfo.ImpIssue}</textarea></td>		
				</tr>
			</table>
		</div>
	</form>
</div>