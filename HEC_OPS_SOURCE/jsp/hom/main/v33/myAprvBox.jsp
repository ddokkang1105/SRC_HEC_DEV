<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>

<style type="text/css">
* html body{ /*IE6 hack*/
padding: 0 0 0 200px; /*Set value to (0 0 0 WidthOfFrameDiv)*/
}
* html #carcontent{ /*IE6 hack*/
width: 100%; 
}
</style>

<script type="text/javascript">
var useCR = "<%=GlobalVal.USE_COMP_CR%>";
var pmenuIndex = "${pmenuIndex}"; // 각 menu index (submenu 포함)
var maxIndex = "${maxIndex}";
var bmenuIndex = "1 2 3 4"; // submenu가 존재하는 menu 화면 표시 처리를 위한 index
var screenType = "${screenType}";
var mainType = "${mainType}";

	$(document).ready(function(){
		clickOpenClose(3);
		setSubFrame(13);
		
		$("#btnFold").click(function(){
			$("#foldframe").attr("style","display:none;");
			$("#foldframeTop").addClass('foldframeTop');
			//$("#foldcontent").addClass('foldcontent');
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
	
	function fnSetGridResizing(avg){
		$("#help_content").innerHTML = $("#grdGridArea").attr("style","width:"+(setWindowWidth()-avg)+"px;");
		$("#help_content").innerHTML = p_gridArea.setSizes();
	}
	
	function setWindowWidth(){
		var size = window.innerWidth;
		var width = 0;
		if( size == null || size == undefined){
			width = document.body.clientWidth;
		}else{
			width=window.innerWidth;
		}return width;
	} 
	
	// [Menu] Click
	function setSubFrame(avg, option){ 
		clickSubMenu(avg); // 클릭한 변경
		
		var target = "help_content";
		var url = "";
		var data = "";
		
		 if(avg == "13") { // 상신 : AREQ
			url = "wfInstanceList.do"; 
			data =  data + "&wfMode=AREQ&screenType=MyPg&wfStepID=AREQ";
		 }
		 if(avg == "17") { // 승인완료 Cls
			url = "wfInstanceList.do"; 
			data =  data + "&wfMode=Cls&screenType=MyPg";
		 }
		 
		 ajaxPage(url, data, target);
	}
	
	/* Report */
	function setRptFrame(curIndex, url) {
		clickSubMenu(curIndex); // 클릭한 변경
		var target = "help_content";
		var url = url;
		var data = "s_itemID=${projectId}";
		
		ajaxPage(url, data, target);
	}
	
	// [set link color]
	function clickSubMenu(avg) {
		var realMenuIndex = pmenuIndex.split(' ');
		var menuName = "menuCng";
		for(var i = 0 ; i < realMenuIndex.length; i++){
			if (realMenuIndex[i] == avg) {
				$("#"+menuName+realMenuIndex[i]).addClass("on");
			} else {
				$("#"+menuName+realMenuIndex[i]).removeClass("on");
			}
		}
	}
	
	// [+][-] button event
	function clickOpenClose(avg) {
		if ( avg == 0 || $(".smenu" + avg).css("display") == "none" ||  $(".plus"+ avg).css("display") != "none") {
			$(".smenu" + avg).css("display", "block");
			$(".plus" + avg).css("display", "none");
			$(".minus" + avg).css("display", "block");
			setOtherArea(avg); // 그외 내용을 닫아줌
		} else {
			$(".smenu" + avg).css("display", "none");
			$(".plus" + avg).css("display", "block");
			$(".minus" + avg).css("display", "none");
		}
		
		//  menu remove [on]
// 		if (avg == 1 || avg == 2 || avg == 3) { 
// 			clickSubMenu(avg);
// 		}
	}
		
	function setOtherArea(avg) {
		var indexArray = pmenuIndex.split(' ');
		for(var i = 0 ; i < indexArray.length; i++){
			var index = i + 1;
			if(index != avg){
				$(".smenu" + index).css("display", "none");
				$(".plus" + index).css("display", "block");
				$(".minus" + index).css("display", "none");
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
</style>
<input id="chkSearch" type="hidden" value="false"></input>
<body id="mainMenu">
	 <div>
	   	<ul class="help_menu">
	   		 <li class="helptitle2" id="title1">
	    		 <span style="font-size:14px;"> <img src="${root}${HTML_IMG_DIR}/icon_pjt.png">&nbsp;제/개정 결재함</font>		 
	    		 <img id="btnFold" class="floatR mgT8 mgR5" src="${root}${HTML_IMG_DIR}/btn_layout_previous.png">
	    		 </span> 	    		
	   		 </li>
	   		 <li id="title2">
	    		 <img id="btnUnfold" name="btnUnfold" class="mgT5" src="${root}${HTML_IMG_DIR}/btn_layout_next.png"> 
	   		 </li>
	   	</ul>
    </div>
    <div id="foldframe" class="foldframe">
    <div>
       	<ul class="help_menu">
            <c:if test="${approvalPath == 'OLM'}" >
            	<c:if test="${sessionScope.loginInfo.sessionLogintype ne 'viewer'}">
            	<li class="hlepsub smenu2" style="display:none;"><a id="menuCng5" onclick="setSubFrame(1);">&nbsp;${menu.LN00250}</a></li>
            	</c:if>
            	<!-- 3. Approval List  -->
            	<li class="helpstitle line plus3"><a onclick="clickOpenClose(3);"><img src="${root}${HTML_IMG_DIR}/icon_stor_01.png"><span class="fontchange">&nbsp;${menu.LN00242} </span></a></li>
                <li class="helpstitle line minus3" style="display:none;"><a class="on" onclick="clickOpenClose(3);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_chorder.png"><span class="fontchange">&nbsp;${menu.LN00242}</span></a></li>
            	 	<li class="hlepsub line smenu3" style="display:none;"><a id="menuCng13" onclick="setSubFrame(13);">&nbsp;${menu.LN00211}</a></li>
					<li class="hlepsub line smenu3" style="display:none;"><a id="menuCng17" onclick="setSubFrame(17);">&nbsp;${menu.LN00118}</a></li>
            </c:if>
			</ul>
    	</div>
	</div>
	<div id="foldcontent" class="unfoldcontent">
       <div id="help_content" class="pdL10 pdR10" ></div>
	</div>
</body>
</html>


