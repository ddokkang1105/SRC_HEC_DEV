<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00015" var="CM00015" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00052" var="CM00052" />

<script type="text/javascript">

	function fnSubmitApproval(){	
		var wfStepInstStatus = "${wfStepInstStatus}";
		let msg = ""
		
		if(wfStepInstStatus == "2"){msg = "${CM00015}";
		}else{ msg = "${CM00052}"; }
		
		function afterConfirmCallback () {
			var url = "submitStepApproval.do";
			ajaxSubmit(document.apprCommentFrm, url);
		}	
		showDhxConfirm(msg, afterConfirmCallback, "No", "Yes")
	}
	
	// Submit CallBack
	function fnCallBackSubmit(url, data) {	
		
		if(url != null && url != "" && url != undefined)
			opener.fnProcessCallBackSubmit(url, data);
		else
			opener.fnCallBack();
		
		self.opener = self;
		window.close();
	}
	
</script>
</head>
<body>
<div id="apprCommentDiv" style="padding: 0 6px 6px 6px; height:400px;"> 
<form name="apprCommentFrm" id="apprCommentFrm" method="post" action="#" onsubmit="return false;">
	<input type="hidden" id="projectID" name="projectID"  value="${projectID}" />	
	<input type="hidden" id="wfInstanceID" name="wfInstanceID" value="${wfInstanceID}" />
	<input type="hidden" id="stepInstID" name="stepInstID" value="${stepInstID}" />
	<input type="hidden" id="actorID" name="actorID" value="${actorID}" />
	<input type="hidden" id="lastSeq" name="lastSeq" value="${lastSeq}" />
	<input type="hidden" id="stepSeq" name="stepSeq" value="${stepSeq}" />
	<input type="hidden" id="srID" name="srID" value="${srID}" />
	<input type="hidden" id="wfStepInstStatus" name="wfStepInstStatus" value="${wfStepInstStatus}" />
	<input type="hidden" id="svcCompl" name="svcCompl" value="${svcCompl}" />
	<input type="hidden" id="documentID" name="documentID" value="${documentID}" />
	<input type="hidden" id="docNo" name="docNo" value="${docNo}" />
	<input type="hidden" id="aprvOption" name="aprvOption" value="${getPJTMap.AprvOption}" />
	<div class="cop_hdtitle mgB10" style="border-bottom:1px solid #ccc">
		<ul>
			<li>
				<h3>
					<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;Comment
				</h3>
			</li>
		</ul>	
	</div>
	<table class="tbl_blue01" style="table-layout:fixed;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td class="last line">
			<textarea id="comment" name="comment" style="width:99%;height:150px;">${srInfoMap.Comment}</textarea>
			</td>	
		</tr>						
	</table>
	<div class="alignBTN">
		<span id="viewSave" class="btn_pack medium icon"><span class="confirm"></span><input value="Confirm" type="submit" onclick="fnSubmitApproval()"></span>
	</div>
	</form>	
	<div style="display:none;"><iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe></div>
</div>
</body>
</html>