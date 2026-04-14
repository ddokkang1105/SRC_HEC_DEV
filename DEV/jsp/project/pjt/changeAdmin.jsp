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
var menuIndex = "1 2 3 4 5 6 7";	

	$(document).ready(function(){
		var isHome = "${isHome}";
		if (isHome == "Y") {
			setSubFrame(4); // Issue 리스트 표시
		} else {
			setSubFrame(1); // 초기 프로젝트 리스트 표시
		}
		
		$("#btnFold").click(function(){
			$("#foldframe").attr("style","display:none;");
			$("#foldframeTop").addClass('foldframeTop');
			$("#foldcontent").removeClass('unfoldcontent');
			$("#foldcontent").addClass('foldcontent');	
			$("#title1").attr("style","display:none;");	
			$("#title2").attr("style","display:block;");
			fnSetGridResizing();
			
	     });
		$("#btnUnfold").click(function(){
			$("#foldframe").attr("style","display:block;");
			$("#foldframeTop").addClass('unfoldframeTop');
			$("#foldcontent").removeClass('foldcontent');
			$("#foldcontent").addClass('unfoldcontent');
			$("#title1").attr("style","display:block;");
			$("#title2").attr("style","display:none;");				
			fnSetGridResizing(230);
	     });
	});
	
	function setWindowWidth(){
		var size = window.innerWidth;
		var width = 0;
		if( size == null || size == undefined){
			width = document.body.clientWidth;
		}else{
			width=window.innerWidth;
		}return width;
	} 
	
	function fnSetGridResizing(avg){
		$("#help_content").innerHTML = $("#grdGridArea").attr("style","width:"+(setWindowWidth()-avg)+"px;");
		$("#help_content").innerHTML = p_gridArea.setSizes();
	}
	
	// [Menu] Click
	function setSubFrame(avg){
		clickSubMenu(avg); // 클릭한 변경
		var target = "help_content";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		var url = "projectGroupList.do";
		
		if(avg == "2") {
			url = "myProjectList.do";
			data = data + "&mainMenu=0&mainVersion=mainV5";
		}		
		if(avg == "3") {
			url = "csrList.do";
			data = data + "&mainMenu=1";
		}
		if(avg == "4") {
			url = "changeSetInfoListV4.do"; //changeSetInfoListV4.do
			data = "&mainMenu=0&isMine=N";
		}
		if(avg == "5") {
			url = "crList.do";
			data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		}
		if(avg == "6") {
			url = "taskSearchList.do";
			data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		}
		if(avg == "7") {
			url = "issueSearchList.do";
			data = "issueMode=Admin";		
		}
		ajaxPage(url, data, target);
	}
	

	
	// [set link color]
	function clickSubMenu(avg) {
		var realMenuIndex = menuIndex.split(' ');
		var menuName = "menuCng";
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
	<div>
		<ul class="help_menu">
		 <li class="helptitle2" id="title1">
	    		 <span><font style="font-size:14px;"> &nbsp;Change Management</font>		 
	    		 <img id="btnFold" class="floatR mgT10 mgR15" src="${root}${HTML_IMG_DIR}/btn_layout_previous.png">
	    		 </span> 	 
	        </li>
	    	<li id="title2">
		    	<img id="btnUnfold" name="btnUnfold" class="mgT10 mgL15" src="${root}${HTML_IMG_DIR}/btn_layout_next.png"> 
	    	</li>
	    </ul>	
	</div>

	<div id="foldframe" class="foldframe">
		<div>
        	<ul class="help_menu">
                 <!-- 프로젝트 그룹 -->
                 <li class="hlepsub"><a id="menuCng1" onclick="setSubFrame(1);">·&nbsp;${menu.LN00277}</a></li>
                 
                 <!-- 프로젝트 -->
                 <li class="hlepsub"><a id="menuCng2" onclick="setSubFrame(2);">·&nbsp;${menu.LN00131}</a></li>
                 
            	 <!-- CSR List -->
                 <li class="hlepsub"><a id="menuCng3" onclick="setSubFrame(3);">·&nbsp;${menu.LN00373}</a></li>
                 
                 <!-- Change set -->
                 <li class="hlepsub"><a id="menuCng4" onclick="setSubFrame(4);">·&nbsp;${menu.LN00374}</a></li> 
                 
                 <!--Change request  -->
	             <!-- li class="helpstitle"><a id="menuCng5" onclick="setSubFrame(5);"><img src="${root}${HTML_IMG_DIR}/csr_minus.png" >&nbsp;IT Change request</a></li--> 

                 <!--Task  -->
	             <!--li class="helpstitle line"><a id="menuCng6" onclick="setSubFrame(6);"><img src="${root}${HTML_IMG_DIR}/csr_minus.png" >&nbsp;Task</a></li--> 
           	 	         
             </ul>
    	</div>
	</div>
       <div id="foldcontent" class="unfoldcontent"><div id="help_content" class="pdT10 pdL10 pdR10" ></div></div>
</body>
</html>


