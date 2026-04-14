<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00066" var="CM00066" arguments="Start Date"/>
<title>Search user</title>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

	<script type="text/javascript">
		$(document).ready(function() {	
			$("input.datePicker").each(generateDatePicker);	
		});	
	
		$(window).load(function(){
			$("#startTime").focus();
		});
	
		function fnUpdateProcInstStartTime(){
			if (confirm("${CM00066}")) {
				ajaxSubmit(document.procInstStartTimefrm, "updateProcInstStartTime.do","saveDFrame");	
			}
		}
	
	
		function fnCallback(){
			window.opener.goProcInstanceInfoEdit('V');
			self.close();
		}
	
	
	</script>

</head>

<body>
    <!-- BEGIN :: BOARD_ADMIN_FORM -->
    <form name="procInstStartTimefrm" id="procInstStartTimefrm" action="#" method="post" onsubmit="return false;">
	    <input type="hidden" id="procInstNo" name="procInstNo" value="${procInstNo}" />
	    <div id="procInstStartTimeDiv" style="width:100%;height:100%;">
			<div class="child_search_head">
		    	<p><img src="${root}${HTML_IMG_DIR}/user.png">&nbsp;Start Date Update</p>
			</div>
	        <div class="child_search_form">
				<div class="child_search mgT5">
			    	<ul>
			        	<li class="floatL mgL15">
			        		
			        			<input type="text" id="startTime" name="startTime" value="${startTime}" class="datePicker stext"
							style="width: 80px;text-align: center;" onchange="this.value = makeDateType(this.value);" maxlength="10">
							
						</li>
						<li class="floatR mgR15">
							&nbsp;<span class="btn_pack small icon"><span class="save"></span><input value="Save" type="submit" onclick="fnUpdateProcInstStartTime();"></span>
						</li>
					</ul>
				</div>
			</div>
	    </div>
    </form>
    <iframe name="saveDFrame" id="saveDFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
</html>