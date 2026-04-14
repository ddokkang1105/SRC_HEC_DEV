<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>


<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="Comment"/> <!-- 승인코멘트  -->

<script type="text/javascript">	
	jQuery(document).ready(function() {
		$("input.datePicker").each(generateDatePicker);
		jQuery("#approvalComment").focus();
	});
	
	function fnSaveSRApproval(){
		if(!confirm("${CM00001}")){ return;}
		if(!fnCheckValidation()){return;}		
		
		var url  = "saveSRApproval.do";
		var target = "saveFrame";
		
		ajaxSubmit(document.srFrm, url, target);
	}
	
	function fnCheckValidation(){
		var isCheck = true;		
		var procLogReason = $("#approvalComment").val();		
		if(procLogReason == ""){ alert("${WM00034_2}"); isCheck = false; return isCheck;}
		
		return isCheck;
	}

	function fnCallBack(){
		opener.fnGoSRList();
		self.close();
	}
	
	function fnRejectSR(){
		if(!confirm("${CM00001}")){ return;}
		var url = "updateSRStatus.do";
		var data = "srID=${srInfoMap.SRID}&status=HOLD";
		var target = "saveFrame";
		ajaxPage(url, data, target);
	}
		
</script>
</head>

<body>
<div style="padding: 0 6px 6px 6px; height:400px; overflow:scroll;overflow-y;overflow-x:hidden;">
<form name="srFrm" id="srFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<input type="hidden" id="srID" name="srID" value="${srInfoMap.SRID}">
	<input type="hidden" id="srCode" name="srCode" value="${srInfoMap.SRCode}">
	<input type="hidden" id="subject" name="subject" value="${srInfoMap.Subject}">
	<input type="hidden" id="srType" name="srType" value="${srInfoMap.SRType}">
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>&nbsp;Approve SR</h3>
	</div>
	<table class="tbl_brd mgT5 mgB5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0"> 
		<colgroup>
			<col width="20%">
			<col>
			<col width="20%">
			<col>
		</colgroup>		
		<tr>
			<!-- 도메인 -->
			<th class="alignL pdL10"> ${menu.LN00274}</th>
			<td class="sline tit last" >${srInfoMap.SRArea1Name}</td>
			<!-- 시스템 -->
			 <th class="alignL pdL10"> ${menu.LN00185}</th>
			<td class="sline tit last">${srInfoMap.SRArea2Name}</td>
		</tr>
		<tr>
			<th class="alignL pdL10">${menu.LN00025}</th>
			<td class="sline tit last">${srInfoMap.ReqUserNM}(${srInfoMap.ReqTeamNM})</td>
			<th class="alignL pdL10">SR&nbsp;${menu.LN00004}&nbsp;</th>
			<td class="sline tit last" >${receiptName}(${receiptTeamName})
				<input type="hidden" name="receiptUserID" id="receiptUserID" value="${receiptUserID}" >
				<input type="hidden" name="receiptTeamID" id="receiptTeamID" value="${receiptTeamID}" >
			</td>
		</tr>
		<tr>
			<th class="alignL pdL10">Comment</th>
			<td class="sline tit pdR10 last" colspan="3" style="height:120px;">
				<textarea class="textgrow" id="approvalComment" name="approvalComment" style="width:100%;height:120px;"></textarea>		
			</td>
		</tr>
	</table>
	<div class="alignBTN">
		<span id="viewSave" class="btn_pack medium icon"><span class="confirm"></span><input value="Reject" type="submit" onclick="fnRejectSR()"></span>&nbsp;&nbsp;
		<span id="viewSave" class="btn_pack medium icon"><span class="confirm"></span><input value="Approve" type="submit" onclick="fnSaveSRApproval()"></span>&nbsp;&nbsp;
	</div>
	</form>
</div>
<!-- END :: DETAIL -->
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>
</body>
</html>
