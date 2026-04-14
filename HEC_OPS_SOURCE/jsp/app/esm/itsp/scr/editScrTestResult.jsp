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
	function fnSaveScrTestResult() {
		if (confirm("${CM00001}")) {
			if( document.all("testSvrYN").checked == true){ $("#testSvrYN").val("Y"); }else{ $("#testSvrYN").val("N"); }
			if( document.all("cwTestYN").checked == true){ $("#cwTestYN").val("Y"); }else{ $("#cwTestYN").val("N"); }
			if( document.all("cwTestPass").checked == true){ $("#cwTestPass").val("Y"); }else{ $("#cwTestPass").val("N"); }
			
			var url = "saveScrTestResult.do?scrId=${scrId}";
			ajaxSubmit(document.scrTestFrm, url,"saveFrame");			
		}
	}
	
	function fnCallBack(){
		var url = "viewScrTestResult.do";
		var data = "scrID=${scrId}";
		var target = "scrTestFrm";
		ajaxPage(url, data, target);
	}
</script>
<form name="scrTestFrm" id="scrTestFrm" action="#" method="post" onsubmit="return false;">
		<div class="floatC" style="overflow:auto;overflow-x:hidden;">
			<div class="floatR mgR10 mgB10">
				<span class="btn_pack small icon"><span class="save"></span><input value="Save" type="submit" onclick="fnSaveScrTestResult()"></span>
			</div>
			<table class="tbl_blue01 mgT10 cb_module" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th class="alignL pdL10 viewline">테스트서버유무</th>
					<td class="alignC"><input type="checkbox" id="testSvrYN" name="testSvrYN" value="${scrInfo.TestSvrYN}" <c:if test="${scrInfo.TestSvrYN == 'Y'}">checked</c:if>></td>
					<td colspan=2 class="last"></td>
				</tr>
				<tr>
					<th class="alignL pdL10 viewline">동료테스트수행여부</th>
					<td class="alignC"><input type="checkbox" id="cwTestYN" name="cwTestYN" value="${scrInfo.CoworkerTestYN}" <c:if test="${scrInfo.CoworkerTestYN == 'Y'}">checked</c:if>></td>
					<th class="alignL pdL10">동료테스트합격여부</th>
					<td class="alignC last"><input type="checkbox" id="cwTestPass" name="cwTestPass" value="${scrInfo.CoworkerTestPass}" <c:if test="${scrInfo.CoworkerTestPass == 'Y'}">checked</c:if>></td>
				</tr>
				<tr>
					<th class="alignL pdL10 viewline">동료테스트결과</th>
					<td colspan=3 class="last"><textarea class="edit" name="cwTestResult" style="width:100%;height:50px;background: #fff;">${scrInfo.CoworkerTestResult}</textarea></td>
				</tr>
				<tr>
					<th class="alignL pdL10 viewline">통합테스트결과</th>
					<td colspan=3 class="last"><textarea class="edit" name="integTestResult" style="width:100%;height:50px;background: #fff;">${scrInfo.IntegTestResult}</textarea></td>
				</tr>
				<tr>
					<th class="alignL pdL10 viewline">현업테스트결과</th>
					<td colspan=3 class="last"><textarea class="edit" name="finTestResult" style="width:100%;height:50px;background: #fff;">${scrInfo.FinTestResult}</textarea></td>
				</tr>
				<tr>
					<th class="alignL pdL10 viewline">형상관리항목등록여부</th>
					<td class="alignC"><input type="checkbox" id="" name="" value=""  <c:if test="${scrInfo.CMYN == '1'}">checked</c:if>></td>
					<td colspan=2 class="last"></td>
				</tr>
				<tr>
					<th class="alignL pdL10 viewline">형상관리항목</th>
					<td colspan=3 class="last"><textarea class="edit" name="arcAnalInfo" style="width:100%;height:50px;background: #fff;"></textarea></td>
				</tr>
			</table>
		</div>
	</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>