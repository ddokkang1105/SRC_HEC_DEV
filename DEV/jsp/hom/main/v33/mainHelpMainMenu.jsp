<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>


<script type="text/javascript">
var menuIndex = "1 2 3 4 5 6";
var menuSubIndex = "1 2 3 4 5 6 7 8";

	$(document).ready(function(){
		goHelpDetail(1);
		
		// [search] line 설정
		if ("${sessionScope.loginInfo.sessionAuthLev}" == "1") {
			$("#searchMenu").removeClass('line');
		} else {
			$("#searchMenu").addClass('line');
		}
	});
	
	// [변경 요청]화면 이동 이벤트
	function goHelpDetail(avg1, avg2) {
		clickSubMenu(avg1, avg2); // 클릭한 메뉴 color 변경
		var url = "goHelpDetail.do";
		var data = "viewCheck=" + avg1 + "&subItem=" + avg2;
		var target = "help_content";
		ajaxPage(url, data, target);
	}
	
	// [set link color]
	function clickSubMenu(avg1, avg2) {
		var realMenuIndex = menuIndex.split(' ');
		var menuName = "menuCng";
		var realMenuSubIndex = menuSubIndex.split(' ');
		var menuSubName = "menuSub";
		
		for(var i = 0 ; i < realMenuIndex.length; i++){
			if (realMenuIndex[i] == avg1) {
				if (avg1 != 2 || avg1 != 1) {
					$("#"+menuName+realMenuIndex[i]).addClass("on");
				}
			} else {
				$("#"+menuName+realMenuIndex[i]).removeClass("on");
			}
		}
		
		for(var i = 0 ; i < realMenuSubIndex.length; i++){
			if (realMenuSubIndex[i] == avg2) {
				$("#"+menuSubName+realMenuSubIndex[i]).addClass("on");
			} else {
				$("#"+menuSubName+realMenuSubIndex[i]).removeClass("on");
			}
		}
	}

</script>
</head>
<style type="text/css">
* html body{ /*IE6 hack*/
padding: 0 0 0 200px; /*Set value to (0 0 0 WidthOfFrameDiv)*/
}
* html #carcontent{ /*IE6 hack*/
width: 100%; 
}
a{
	cursor:pointer;
}
</style>
<input id="chkSearch" type="hidden" value="false"></input>
<body id="mainMenu">
	<div id="carframe">
	 	<div>
	        <ul class="help_menu">
	            <li class="helptitle"><img src="${root}${HTML_IMG_DIR}/icon_csr.png"> Help</li>
			    <li class="helpstitle line"><a><img src="${root}${HTML_IMG_DIR}/csr_minus.png" >&nbsp;User Manual</a></li>
			    
			    <li class="hlepsub line"><a id="menuCng1" onclick="goHelpDetail(1);" class="on">Item Master Data</a></li>
				    <li class="subitem line"><a id="menuSub1" onclick="goHelpDetail(1, 1);">- Overview</a></li>
				    <li class="subitem line"><a id="menuSub2" onclick="goHelpDetail(1, 2);" >- Sub items</a><li>
				    <li class="subitem line"><a id="menuSub3" onclick="goHelpDetail(1, 3);" >- Mapping</a><li>
			    
			    <li class="hlepsub line"><a id="menuCng2" onclick="goHelpDetail(2);" >Modeling</a><li>
				    <li class="subitem line"><a id="menuSub4" onclick="goHelpDetail(2, 4);" >- View</a></li>
				    <li class="subitem line"><a id="menuSub5" onclick="goHelpDetail(2, 5);" >- Edit</a></li>
				    <li class="subitem line"><a id="menuSub6" onclick="goHelpDetail(2, 6);" >- Management</a></li>
			    	<li class="subitem line"><a id="menuSub7" onclick="goHelpDetail(2, 7);" >- Occurrence</a><li>
				    <li class="subitem line"><a id="menuSub8" onclick="goHelpDetail(2, 8);" >- Report</a></li>
				    
				<li class="hlepsub line"><a id="menuCng3" onclick="goHelpDetail(3);" >File</a><li>
				<li class="hlepsub line"><a id="menuCng4" onclick="goHelpDetail(4);" >Dimension</a><li>
				<!-- <li id="searchMenu" class="hlepsub"><a id="menuCng7" onclick="goHelpDetail(7);" >Search</a><li> -->
				<c:if test="${sessionScope.loginInfo.sessionAuthLev eq '1'}">
	            	<li class="helpstitle line"><a><img src="${root}${HTML_IMG_DIR}/csr_minus.png" >&nbsp;Admin Manual</a></li>
	            	<li class="hlepsub line"><a id="menuCng5" onclick="goHelpDetail(5);" >User Management</a><li>
	                <li class="hlepsub line"><a id="menuCng6" onclick="goHelpDetail(6);" >Configuration</a><li>
	            </c:if>
            </ul>
    	</div>
	</div>
	<div id="carcontent">
       <div id="help_content" class="pdT10 pdL10 pdR10" ></div>
	</div>
</body>
</html>


