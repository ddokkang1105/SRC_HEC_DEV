<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>  
 <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript">
	var menuIndex = "1 2 3";
	$(function(){
		setpmFrame('allocateUsers','','1');
	});
	function setpmFrame(avg,oj, avg2){
		var url = avg+".do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&s_itemID=${s_itemID}"
				+"&userType=2"
				+"&width="+ugFrame.offsetWidth
				+"&option=${option}"
				+"&getAuth=${sessionScope.loginInfo.sessionLogintype}"
				+"&currPage=${currPage}";
		var target="ugFrame";
		ajaxPage(url,data,target);
		//tab Change
		setSubTab(menuIndex, avg2, "pliug");
	}	
</script>
</head>
<body>
<input type="hidden" id="currPage" name="currPage" value="${currPage}">
<div class="SubinfoTabs">
	<ul>
		<li id="pliug1" class="on"><a href="javascript:setpmFrame('allocateUsers','','1');"><span>Allocate Users</span> </a></li>
		<li id="pliug2"><a href="javascript:setpmFrame('userGroupAccessRight','','2');"><span>Access Right</span></a></li>		
		<li id="pliug3"><a href="javascript:setpmFrame('userGroupProject','','3');"><span>${menu.LN00131}</span></a></li>
	</ul>
</div>
<div id="ugFrame"></div>

<!-- 
	<iframe width="100%" height="95%" frameborder="0" style="border: 0" name="pmFrame" id="pmFrame" scrolling='no' src="ObjectInfoMain.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${id}&width=1024&option=${option}&getAuth=${sessionScope.loginInfo.sessionLogintype}"></iframe>
 -->
</body>
</html>