<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8"></meta>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
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

<script type="text/javascript">
   
	var pmenuIndex = "${pmenuIndex}"; // 각 menu index (submenu 포함)
	var maxIndex = "${maxIndex}";

	$(document).ready(function(){
		setSubFrame(1,"");
		
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
			fnSetGridResizing(220);
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
	function setSubFrame(avg, lovCode){ 
		clickSubMenu(avg); // 클릭한 변경		
		var target = "help_content";
		var url = "standardTermsSch.do";
		var data = "lovCode="+lovCode+"&csr=${csr}"+"&mgt=${mgt}&linkOption=${linkOption}&searchValue=${searchValue}"; 
		
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
<input id="chkSearch" type="hidden" value="false"></input>
<body id="mainMenu">
	<div>
    	<ul class="help_menu">
    		 <li class="helptitle2" id="title1">
	    		 <span style="font-size:14px;"><img src="${root}${HTML_IMG_DIR}/icon_pjt.png">&nbsp;${menu.LN00300} 		 
	    		 <img id="btnFold" class="floatR mgT10 mgR15" style="cursor:pointer;" src="${root}${HTML_IMG_DIR}/btn_layout_previous.png">
	    		 </span> 	    		
    		 </li>
    		 <li id="title2">
	    		 <img id="btnUnfold" name="btnUnfold" class="mgT10 mgL15" style="cursor:pointer;"  src="${root}${HTML_IMG_DIR}/btn_layout_next.png">
    		 </li>
    	</ul>
    </div>
	<div id="foldframe" class="foldframe" style="border-top:1px solid #ccc;">
		<div>
        	<ul class="help_menu">
       			<c:forEach var="at34List" items="${LOVAT34List}" varStatus="status">
   		 			<li class="hlepsub line smenu${status.count}" style="display:done;"><a id="menuCng${status.count}" onclick="setSubFrame('${status.count}','${at34List.CODE}');">&nbsp;${at34List.NAME}</a></li>
   		 		</c:forEach>        		 
             </ul>
    	</div>
	</div>
	<div id="foldcontent" name="foldcontent" class="unfoldcontent">
       <div id="help_content"></div>
	</div>
</body>
</html>


