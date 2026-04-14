<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/> 
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00114" var="WM00114"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>

<!-- 2. Script -->
<script type="text/javascript">
	$(document).ready(function() {	
	
	});
	
	function fnSaveCategory(){ 
		var url = "/daelim/plant/zdaelim_assignJob.do";
		ajaxSubmit(document.jobAssignFrm, url, "saveFrame");
	}
	
	function fnCallBack(){
		opener.urlReload();
		self.close();
	}
	
</script>
<body>
<div id="jobAssignPopDIV" style="padding: 0 6px 6px 6px">
<form name="jobAssignFrm" id="jobAssignFrm" method="post" action="#" onsubmit="return false;">
	<input type="hidden" id="selectedTreeItemID" name="selectedTreeItemID" value="${selectedTreeItemID}" >
	<input type="hidden" id="assignCNT" name="assignCNT" value="${assignCNT}" >
	<input type="hidden" id="assignDefaultCNT" name="assignDefaultCNT" value="${assignDefaultCNT}" >
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 6px 0 6px 6px">
			<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;Select Category
		</h3>
	</div>
	<table class="tbl_brd mgT5 mgB5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
		    <col width="75%">
		 	<col width="25%">
		</colgroup>		
		<tr>
		  <th class="alignC pdL10">직무</th> 
		  <th class="alignC pdL10">Category</th> 
		</tr>
		<c:forEach var="list" items="${assignItemList}" varStatus="cnt">
			<tr style="height:26px;">
				<td class="sline tit last alignL" >${list.assignItemName}</td>
				<td class="sline tit last alignC" >	
					<input type="hidden" id="itemID_${cnt.index}" name="itemID_${cnt.index}" value="${list.itemID}" size="70px;" >			
					<select id="toIdentifier_${index}" name="toIdentifier_${cnt.index}" style="width:180px;">
					<c:forEach var="toItem" items="${list.toItemList}" varStatus="status">
						<option value="${toItem.Identifier}">${toItem.ToItemName} </option>
					</c:forEach>	
					</select>
				</td>
			</tr>
		</c:forEach>
		
		<c:forEach var="list2" items="${assignItemDefaultList}" varStatus="status">
			<tr style="height:26px;">
				<td class="sline tit last alignL" >${list2.assignItemDefaultName}</td>
				<td class="sline tit last alignC" >
					<input type="hidden" id="dfItemID_${status.index}" name="dfItemID_${status.index}" value="${list2.itemID}" size="70px;" >
					<input type="hidden" id="dfToIdentifier_${status.index}" name="dfToIdentifier_${status.index}" value="${list2.toIdentifier}">
					${list2.toItemName}
				</td>
			</tr>
		</c:forEach>
	</table>
	<div class="alignBTN">
		<span id="viewSave" class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="fnSaveCategory()"></span>
	</div>
	</form>
	</div>
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>
</body>
