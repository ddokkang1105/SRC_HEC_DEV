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
var menuIndex = "1 2";	

	$(document).ready(function(){
		setSubFrame(1); // 초기 Process 통계 화면 표시
	});
	
	// [Menu] Click
	function setSubFrame(avg){
		clickSubMenu(avg); // 클릭한 변경
		var target = "help_content";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		var url = "CustomerGroupList.do";
		
		if(avg == "2") {
			url = "CustomerList.do";
		}
		ajaxPage(url, data, target);
	}
	
	// [set link color]
	function clickSubMenu(avg) {
		var realMenuIndex = menuIndex.split(' ');
		var menuName = "menuUserInfo";
		for(var i = 0 ; i < realMenuIndex.length; i++){
			if (realMenuIndex[i] == avg) {
				$("#"+menuName+realMenuIndex[i]).addClass("on");
			} else {
				$("#"+menuName+realMenuIndex[i]).removeClass("on");
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
                 <li class="helptitle"><img src="${root}${HTML_IMG_DIR}/icon_user.png">&nbsp;Customer</li>
                  <!-- 고객 그룹 -->
                 <li class="helpstitle"><a id="menuUserInfo1" onclick="setSubFrame(1);"><img src="${root}${HTML_IMG_DIR}/csr_minus.png">&nbsp;Customer</a></li>
                 
            	 <!-- 파트너 -->
                 <li class="helpstitle line"><a id="menuUserInfo2" onclick="setSubFrame(2);"><img src="${root}${HTML_IMG_DIR}/csr_minus.png">&nbsp;Partner</a></li>
                 
             </ul>
    	</div>
	</div>
	<div id="carcontent">
       <div id="help_content" class="pdT10 pdL10 pdR10" ></div>
	</div>
</body>
</html>


