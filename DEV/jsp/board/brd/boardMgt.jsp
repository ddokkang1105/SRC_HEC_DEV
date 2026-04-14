<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%
String BoardMgtID = request.getParameter("BoardMgtID") == null ? "1" : request.getParameter("BoardMgtID");
%>   
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00003" var="CM00003"/>

<script type="text/javascript">
	var BoardMgtID;	
	var menuIndex = "1 2 3";
	
	$(document).ready(function(){
		notictType =  "<%=BoardMgtID%>";		
		if( BoardMgtID == null || BoardMgtID == "" || BoardMgtID == "3"){ BoardMgtID = "1";}
		else if( BoardMgtID == "4"){ BoardMgtID = "3";}	
		setSubFrame(BoardMgtID);	
	});	
	function setSubFrame(avg){
		fnInitValues();
		$('#BoardMgtID').val(avg);
		var url = "boardAdminList.do";
		var target = "help_content";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&BoardMgtID="+avg;
		ajaxPage(url, data, target);
		
		//tab Change
		setSubTab(menuIndex, avg, "pli");
	}	
	function fnInitValues(){
		$('#BoardMgtID').val("");
		$('#BoardID').val("");		
		$('#BoardMgtID').val("");
	}
	function goList(isConfirm){
		if(isConfirm){if(confirm("${CM00003}")) fnChangeList();} else{fnChangeList();}
	}	
	function fnChangeList(){
		var url = "boardList.do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&BoardMgtID="+$('#BoardMgtID').val()+"&pageNum="+$("#currPage").val();	
		var target = "help_content";
		ajaxPage(url, data, target);
	}
	function goDetail(isNew,boardMgtID, boardID){
		var url = "boardDetail.do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&NEW="+isNew+"&BoardID="+boardID+"&BoardMgtID="+boardMgtID+"&BoardMgtID="+$('#BoardMgtID').val();
		var target = "help_content";
		ajaxPage(url, data, target);		
	}
</script>
</head>
<body>
<form name="subFrm" id="subFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="BoardMgtID" name="BoardMgtID" value=""/>
	<input type="hidden" id="BoardID" name="BoardID" value=""/>
	<input type="hidden" id="currPage" name="currPage" value=""></input>
</form>
<div class="pdL10 pdR10">
	<div class="SubinfoTabs" >
		<ul>
			<li id="pli1" onclick="setSubFrame('1')"><a><span>· ${menu.LN00001}</span></a></li>
			<!--<li id="pli2" onclick="setSubFrame('2')"><a><span>FAQ</span></a></li>-->
			<li id="pli3" onclick="setSubFrame('3')"><a><span>· ${menu.LN00029}</span></a></li>
		</ul>
	</div>	
	<div id="subFrame" name="subFrame" width="100%" height="100%"></div>
	</div>
</body>
</html>