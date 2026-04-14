<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

<script>
	function fnSaveScrImpAnal() {
		if (confirm("${CM00001}")) {
			var url = "saveScrImpAnal.do?scrId=${scrId}";
			ajaxSubmit(document.scrImpAnalFrm, url,"saveFrame");			
		}
	}
	
	function fnCallBack(){
		var url = "viewScrImpAnal.do";
		var data = "scrID=${scrId}";
		var target = "scrImpAnalFrm";
		ajaxPage(url, data, target);
	}
</script>
<form name="scrImpAnalFrm" id="scrImpAnalFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="scrId" name="scrId" value="${scrId}"/>
	<div class="floatC" style="overflow:auto;overflow-x:hidden;">
		<div class="floatR mgR10 mgB10">
			<span class="btn_pack small icon"><span class="save"></span><input value="Save" type="submit" onclick="fnSaveScrImpAnal()"></span>
		</div>
		<table class="tbl_blue01 mgT10 cb_module" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="15%">
				<col width="85%">
			</colgroup>
			<tr>
				<th class="alignL pdL10 viewline">아키텍처 분석</th>
				<td class="alignL last"><textarea class="edit" name="arcAnalInfo" style="width:100%;height:50px;">${scrInfo.ARCAnalInfo}</textarea></td>		
			</tr>
			<tr>
				<th class="alignL pdL10 viewline">변경영향 검토결과</th>
				<td class="alignL last"><textarea class="edit" name="impRewResult" style="width:100%;height:50px;">${scrInfo.ImpRewResult}</textarea></td>		
			</tr>
			<tr>
				<th class="alignL pdL10 viewline">형상관리 검토결과</th>
				<td class="alignL last"><textarea class="edit" name="cmRewResult" style="width:100%;height:50px;">${scrInfo.CMRewResult}</textarea></td>		
			</tr>
			<tr>
				<th class="alignL pdL10 viewline">이슈사항</th>
				<td class="alignL last"><textarea class="edit" name="impIssue" style="width:100%;height:50px;">${scrInfo.ImpIssue}</textarea></td>		
			</tr>
		</table>
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>