<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="${menu.LN00222}"/>
<script type="text/javascript">	
	jQuery(document).ready(function() {
		$("input.datePicker").each(generateDatePicker);
	});
	
	function fnSaveItspDueDate(){
		if(!confirm("${CM00001}")){ return;}
		var dueDate = $("#dueDate").val();
		if(dueDate == ""){alert("${WM00025}"); return;}
		
		var url  = "editSRDueDuate.do";
		var target = "saveFrame";
		
		ajaxSubmit(document.itspFrm, url, target);
	}
	
	function fnCallBack(){
		opener.fnCallBackSR();
		self.close();
	}

	
</script>
</head>

<body>
<div style="padding: 0 6px 6px 6px; height:200px; overflow:scroll;overflow-y;overflow-x:hidden;">
<form name="itspFrm" id="itspFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="srID" name="srID" value="${srInfoMap.SRID}">
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3><img src="${root}${HTML_IMG_DIR}/icon_edit.png"></img>&nbsp;Request ITS&nbsp;${menu.LN00221}</h3>
	</div>
	<table class="tbl_brd mgT5 mgB5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0"> 
		<colgroup>
			<col width="20%">
			<col>
		</colgroup>		
		<tr>
			<th class="alignL pdL10">${menu.LN00221}</th>
			<td class="sline tit last" >
				<font><input type="text" id="dueDate" name="dueDate" value="${srInfoMap.DueDate}" class="text datePicker stext" size="12"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				</font>
			</td>			
		</tr>
	</table>
	<div class="alignBTN">
		<span id="viewSave" class="btn_pack medium icon"><span class="save"></span><input value="Confirm" type="submit" onclick="fnSaveItspDueDate()"></span>&nbsp;&nbsp;
	</div>
</form>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>
</body>
</html>
