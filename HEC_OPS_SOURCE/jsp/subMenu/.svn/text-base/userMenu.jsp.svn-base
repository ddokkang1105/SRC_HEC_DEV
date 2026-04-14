<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript">
	
	var menuIndex = "1 2 3 4 5 6";
	
	$(function(){
		setpmFrame('UserGroup','','1');
	});
	
	function setpmFrame(avg,oj, avg2){		
		var url = avg+".do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&memberID=${s_itemID}"
				+"&userType=1"
				+"&width="+ugFrame.offsetWidth
				+"&option=${option}"
				+"&getAuth=${sessionScope.loginInfo.sessionLogintype}"
				+"&currPage=${currPage}"
				+"&authorID=${s_itemID}";
		var target="ugFrame";

		ajaxPage(url,data,target);
		//alert(22);
		var realMenuIndex = menuIndex.split(' ');
		
		for(var i = 0 ; i < realMenuIndex.length; i++){
			if(realMenuIndex[i] == avg2){
				$("#pliug"+realMenuIndex[i]).addClass("on");
			}else{
				$("#pliug"+realMenuIndex[i]).removeClass("on");
			}
		}
	}
	var SubinfoTabsNum = 1; /* 처음 선택된 tab메뉴 ID값*/
	$(function(){
		$('.UnderSubinfoTabs ul li').mouseover(function(){
			$(this).addClass('on');
		}).mouseout(function(){
			if($(this).attr('id').replace('pliug', '') != SubinfoTabsNum) {
				$(this).removeClass('on');
			}
			$('#tempDiv').html('SubinfoTabsNum : ' + SubinfoTabsNum);
		}).click(function(){
			SubinfoTabsNum = $(this).attr('id').replace('pliug', '');
		});
	});
	
	function fnSetIsDefault(templCode, memberID, isDefault){		
		var url = "setAccessRightIsDefault.do";
		var data = "templCode="+templCode+"&memberID="+memberID+"&isDefault="+isDefault;
		var target = "ugFrame"; 
		
		ajaxPage(url,data,target);
	}
	
	function fnCallBack(){
		setpmFrame('userAccessRight','','2');
	}
	
</script>
</head>
<body>
<input type="hidden" id="currPage" name="currPage" value="${currPage}">
<div class="SubinfoTabs">
	<ul>
<!-- 
	1. jsp/adm/user/sub/UserGroup
	2. jsp/adm/userProject/sub/userGroupAccessRight
 -->
		<li id="pliug1" class="on"><a href="javascript:setpmFrame('UserGroup','','1');"><span>User Group</span> </a></li>
<!-- 
		<li id="pliug2"><a href="javascript:setpmFrame('userAdminOrganization','','2');"><span>Organization</span></a></li>		
 -->		
		<li id="pliug2"><a href="javascript:setpmFrame('userAccessRight','','2');"><span>Access Right</span></a></li>
		<li id="pliug3"><a href="javascript:setpmFrame('userProject','','3');"><span>${menu.LN00131}</span></a></li>
		<li id="pliug4"><a href="javascript:setpmFrame('ownerItemList','','4');"><span>${menu.LN00190}</span></a></li>		
		<li id="pliug5"><a href="javascript:setpmFrame('userDimList','','5');"><span>${menu.LN00088}</span></a></li>		
		<li id="pliug6"><a href="javascript:setpmFrame('myRoleList','','6');"><span>${menu.LN00119}</span></a></li>		
	</ul>
</div>
<div id="ugFrame"></div>

<!-- 
	<iframe width="100%" height="95%" frameborder="0" style="border: 0" name="pmFrame" id="pmFrame" scrolling='no' src="ObjectInfoMain.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${id}&width=1024&option=${option}&getAuth=${sessionScope.loginInfo.sessionLogintype}"></iframe>
 -->
 </body></html>
