<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/jquery.timepicker.css"/>
<script src="${root}/cmm/js/jquery/jquery.js" type="text/javascript"></script>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="${menu.LN00222}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00065" var="CM00065" arguments="${menu.LN00221} 변경"/>
<script type="text/javascript">	
	jQuery(document).ready(function() {
		$("input.datePicker").each(generateDatePicker);
		$('#dueDateTime').timepicker({
            timeFormat: 'H:i:s',
        });
	});
	
	function fnSaveItspDueDate(){
		if(!confirm("${CM00065}")){ return;}
		var dueDate = $("#dueDate").val();
		var dueDateTime = $("#dueDateTime").val();
		var srID = "${srID}";
		if(dueDate == ""){alert("${WM00025}"); return;}
		
		var url  = "confirmSRDueDate.do";
		var target = "saveFrame";
		var data = "srID="+srID+"&dueDate="+dueDate+"&dueDateTime="+dueDateTime;
		
		ajaxPage(url, data, target);
	}
	
	function fnCallBack(){
		self.close();
	}

	
</script>
</head>

<body>
<div style="padding: 0 6px 6px 6px;">
<form name="itspFrm" id="itspFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="srID" name="srID" value="${srInfoMap.SRID}">
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3><img src="${root}${HTML_IMG_DIR}/icon_edit.png"></img>&nbsp;Request due date change</h3>
	</div>
	<table class="tbl_brd mgT5 mgB5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0"> 
		<colgroup>
			<col width="20%">
			<col width="80%">		
		</colgroup>	
		<tr>
			<th class="alignL pdL10">SR No.</th>
			<td class="sline tit last" >${srInfo.SRCode}</td>	
		</tr>	
		<tr>
			<th class="alignL pdL10">${menu.LN00002}</th>
			<td class="sline tit last" >${srInfo.Subject}</td>				
		</tr>	
		<tr>
			<th class="alignL pdL10">${menu.LN00221}</th>
			<td class="sline tit last" >
				<input type="text" id="dueDate" name="dueDate" value="${srInfo.DueDate}" class="text datePicker stext" size="12"
					style="width:70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
				<input type="text" id="dueDateTime" name="dueDateTime" value="${srInfo.DueDateTime}" class="input_off text" size="8" style="width:70px; text-align: center;" maxlength="10">
			</td>			
		</tr>
	</table>
	<div class="alignBTN">
		<span id="viewSave" class="btn_pack medium icon"><span class="confirm"></span><input value="Request" type="submit" onclick="fnSaveItspDueDate();"></span>&nbsp;&nbsp;
	</div>
</form>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>
</body>
</html>
