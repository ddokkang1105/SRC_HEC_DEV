<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%
String noticType = request.getParameter("noticType") == null ? "1" : request.getParameter("noticType");
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
	var noticType;	
	var menuIndex = "1 2 3";
	
	$(document).ready(function(){
		notictType =  "<%=noticType%>";		
		if( noticType == null || noticType == "" || noticType == "3"){ noticType = "1";}
		else if( noticType == "4"){ noticType = "3";}	
		setSubFrame(noticType);	
	});	
	function setSubFrame(avg){
		if(avg==2){
			var url = "goSchdlListMgt.do";		
			var target = "subFrame";
			//var itemId = $('#itemId').val();
			var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
			ajaxPage(url, data, target);
		
		}else{
			fnInitValues();
			$('#noticType').val(avg);
			var url = "boardAdminList.do";
			var target = "subFrame";
			var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&noticType="+avg;
			ajaxPage(url, data, target);
			//tab Change
		}
		
		setSubTab(menuIndex, avg, "pli");
	}	
	function fnInitValues(){
		$('#BoardMgtID').val("");
		$('#BoardID').val("");		
		$('#noticType').val("");
	}
	function goList(isConfirm){
		if(isConfirm){if(confirm("${CM00003}")) fnChangeList();} else{fnChangeList();}
	}	
	function fnChangeList(){
		var url = "boardAdminList.do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&noticType="+$('#noticType').val()+"&pageNum="+$("#currPage").val();	
		var target = "subFrame";
		ajaxPage(url, data, target);
	}
	function goDetail(isNew,boardMgtID, boardID){
		var url = "boardAdminDetail.do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&NEW="+isNew+"&BoardID="+boardID+"&BoardMgtID="+boardMgtID+"&noticType="+$('#noticType').val();
		var target = "subFrame";
		ajaxPage(url, data, target);		
	}
	//스케쥴 상세화면 이동
	function goSchdlDetail(isNew,scheduleId){
		var url = "selectSchedulDetail.do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&NEW="+isNew+"&scheduleId="+scheduleId;
		var target = "subFrame";
		ajaxPage(url, data, target);		
	}
	
</script>
</head>
<body>
<form name="subFrm" id="subFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="noticType" name="noticType" value=""></input>
	<input type="hidden" id="BoardMgtID" name="BoardMgtID" value=""/>
	<input type="hidden" id="BoardID" name="BoardID" value=""/>
	<input type="hidden" id="currPage" name="currPage" value=""></input>
</form>
<div class="pdL10 pdR10">
	<div class="SubinfoTabs" >
		<ul>
			<li id="pli1" onclick="setSubFrame('1')"><a><span>${menu.LN00001}</span></a></li>
			<!--<li id="pli2" onclick="setSubFrame('2')"><a><span>FAQ</span></a></li>-->
			<li id="pli3" onclick="setSubFrame('3')"><a><span>${menu.LN00029}</span></a></li>
			<li id="pli2" onclick="setSubFrame('2')"><a><span>${menu.LN00090}</span></a></li>
		</ul>
	</div>	
	<div id="subFrame" name="subFrame" width="100%" height="100%"></div>
	</div>
</body>
</html>