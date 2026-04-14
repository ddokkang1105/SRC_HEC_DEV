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

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />


<script type="text/javascript">

	function fnSubmitApproval(){	
		
		var msg = "${CM00001}";
		
		if(confirm(msg)){			
			var url = "commitItem.do";
			ajaxSubmit(document.apprCommentFrm, url);
		}
	}
	
	// Submit CallBack
	function fnCallBackSubmit() {	
		opener.fnReload();
		self.close();
	}
	
</script>
</head>
<body>
<div id="apprCommentDiv" style="padding: 0 6px 6px 6px; height:400px;"> 
<form name="apprCommentFrm" id="apprCommentFrm" method="post" action="#" onsubmit="return false;">
	<input type="hidden" id="items" name="items" value="${items}" />
	<input type="hidden" id="cngts" name="cngts" value="${cngts}" />
	<input type="hidden" id="pjtIds" name="pjtIds" value="${pjtIds}" />
	<input type="hidden" id="srID" name="srID" value="${srID}" />
	<input type="hidden" id="speCode" name="speCode" value="${speCode}" />
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
			<textarea id="description" name="description" style="width:99%;height:150px;"></textarea>
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