<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
String reportType = request.getParameter("reportType") == null ? "1" : request.getParameter("reportType");
%> 
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript">
	var dhtmlxChart;
	var noticType;	
	var menuIndex = "1 2 3 4";
	
	$(document).ready(function(){
		reportType =  "<%=reportType%>";		
		if( reportType == null || reportType == "") reportType = "1";
		$('#reportType').val(reportType);
		
		setSubFrame(reportType);	
	});	
	function setSubFrame(avg){
		$('#reportType').val(avg);
		var target = "subFrame";
		var data = "reportType="+avg + "&languageID=" + $("#languageID").val();
		
		//var url = "visitLogStatistics.do";
		var url = "visitLogStatisticsByDay.do?haederL1=OJ00001";
		
		
		if(avg == "2") { // 프로세스 변경관리
			url = "newChangeSetStatistics.do";
			data = data + "&ItemTypeCode=OJ00001";
		}
		
		if(avg == "3") { // 프로그램 변경관리
			url = "newChangeSetStatistics.do";
			data = data + "&ItemTypeCode=OJ00004";
		}
		
		if(avg == "4") {
			url = "admin/newItemStatistics.do";
		}
		
		/*
		if(avg == "2") {
			url = "dimensionStatistics.do";
		}
		*/
		
		
		ajaxPage(url, data, target);

		//TAB 변경
		setSubTab(menuIndex, avg);
	}
</script>
</head>
<body>

<form name="subFrm" id="subFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="reportType" name="reportType" value=""></input>
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}">
</form>
	<div class="SubinfoTabs">
		<ul>
			<!-- <li id="pli1" class="on" onclick="setSubFrame('1')"><a><span>Item </span></a></li>
			<li id="pli2" onclick="setSubFrame('2')"><a><span>Dimension</span></a></li> --> 
			
			<li id="pli1" class="on" onclick="setSubFrame('1')"><a><span>Visit Log Statistics</span></a></li>
			<li id="pli2" onclick="setSubFrame('2')"><a><span>Process ChangeSet</span></a></li>
			<li id="pli3" onclick="setSubFrame('3')"><a><span>Program ChangeSet</span></a></li>
			<li id="pli4" onclick="setSubFrame('4')"><a><span>Process Statistics</span></a></li>
		</ul>
	</div>
	
	<div id="subFrame" name="subFrame" width="100%" height="70%"></div>

</body>
</html>