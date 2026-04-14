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
<style type="text/css">
* html body{ /*IE6 hack*/
padding: 0 0 0 200px; /*Set value to (0 0 0 WidthOfFrameDiv)*/
}
* html #carcontent{ /*IE6 hack*/
width: 100%; 
}
#mainLayer{
    background: none;
    height: auto;
}
</style>
<script type="text/javascript">
var pmenuIndex = "1 2 3 4 5 6 7"; // 각 menu index (submenu 포함)
var maxIndex = "${maxIndex}";
var startBoardIndex = "${startBoardIndex+1}";
var scrnType = "${scrnType}";
var mainType = "${mainType}";
var srMode = "${srMode}";	
var srType = "${srType}";	
var esType = "${esType}";
var srID = "${srID}";
	$(document).ready(function(){
		var focusMenu = "${focusMenu}";
		var menuIndex = 1;
		if(focusMenu != ""){
			menuIndex = parseInt(focusMenu);
			if(menuIndex <= 3){
				clickOpenClose(1);				
			}else {
				clickOpenClose(2);				
			}
			setSubFrame(menuIndex);
		}else{
			if(mainType =="mySRDtl" || mainType =="SRDtl") {
				clickOpenClose(1);
				setSubFrame(1, 'srview');	
			}else{
				clickOpenClose(1);
				setSubFrame(menuIndex);
			}
		} 

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
		$("#mainLayer").innerHTML = $("#grdGridArea").attr("style","width:"+(setWindowWidth()-avg)+"px;");
		$("#mainLayer").innerHTML = p_gridArea.setSizes();
	}
	
	// [Menu] Click
	function setSubFrame(avg, avg2){
		clickSubMenu(avg); // 클릭한 변경
		var target = "mainLayer";
		var url = "espList.do";
		var multiComp = "${multiComp}";
		var data = "scrnType=${scrnType}&srType=${srType}&esType=${esType}&sysCode=${sysCode}&multiComp="+multiComp+"&srArea1ListSQL=${srArea1ListSQL}&reqDateLimit=${reqDateLimit}&defCategory=${defCategory}&defSrarea=${defSrarea}";		
		if(avg == "1") {
			data = data + "&srStatus=ALL&srType=ACM";
		} else if(avg == "2") {
			//data =  data + "&srStatus=COMPL&srMode=${srMode}";
			data = data + "&srStatus=ALL&srType=DCM";
		} else if(avg == "3") {
			data = data + "&srStatus=ALL&srType=INC";
		} else if(avg == "4") {
			// mySR
			data = data + "&srStatus=ALL&srMode=mySR";
		} else if(avg == "5") {
			// myRole 
			data = data + "&srStatus=ALL&srMode=myRole";
		} else if(avg == "6") {
			// myPJT
			data = data + "&srStatus=ALL&srMode=myPJT";
		} else if(avg == "7") {
			// myCMP
			data = data + "&srStatus=ALL&srMode=myClient";
		}
		
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
		} else {
			$(".smenu" + avg).css("display", "none");
			$(".plus" + avg).css("display", "block");
			$(".minus" + avg).css("display", "none");
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
	
	function fnClickSingleMenu(avg) {
		if ( avg == 4 || $(".smenu" + avg).css("display") == "none" ||  $(".plus"+ avg).css("display") != "none") {
			$(".smenu" + avg).css("display", "block");
			$(".plus" + avg).css("display", "none");
			$(".minus" + avg).css("display", "block");
			setOtherArea(avg); // 그외 내용을 닫아줌
		} else {
			$(".smenu" + avg).css("display", "none");
			$(".plus" + avg).css("display", "block");
			$(".minus" + avg).css("display", "none");
		}
		
		$("#menuCng201").removeClass("on");
		$("#menuCng202").removeClass("on");
		
		setSubFrame(avg);
		$("#menuCng"+avg).addClass("on");
	}
	
</script>
</head>
<body id="mainMenu">
	<input id="chkSearch" type="hidden" value="false"></input>
	<div>
    	<ul class="help_menu">
    		 <li class="helptitle2" id="title1">
	    		 <span style="font-size:14px;"> <img src="${root}${HTML_IMG_DIR}/icon_pjt.png">&nbsp;ITSM 
	    		 <img id="btnFold" class="floatR mgT5 mgR5" src="${root}${HTML_IMG_DIR}/btn_layout_previous.png">
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
	            <li class="helpstitle plus1"><a onclick="clickOpenClose(1);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_chorder.png"><span class="fontchange">&nbsp;변경관리</span></a></li>
                <li class="helpstitle line minus1" style="display:none;"><a class="on" onclick="clickOpenClose(1);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_chorder.png"><span class="fontchange">&nbsp;변경관리</span></a></li>
            	 	<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng1" onclick="setSubFrame(1);">AP 변경</a></li>
            	 	<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng2" onclick="setSubFrame(2);">데이타 변경</a></li>
            	 	<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng3" onclick="setSubFrame(3);">인프라 변경</a></li>
            	 <li class="helpstitle plus2"><a onclick="clickOpenClose(2);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_chorder.png"><span class="fontchange">&nbsp;My List</span></a></li>
            	 <li class="helpstitle line minus2" style="display:none;"><a class="on" onclick="clickOpenClose(2);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_chorder.png"><span class="fontchange">&nbsp;My List</span></a></li>	
            	 	<li class="hlepsub line smenu2" style="display:none;"><a id="menuCng4" onclick="setSubFrame(4);">My SR</a></li>
            	 	<li class="hlepsub line smenu2" style="display:none;"><a id="menuCng5" onclick="setSubFrame(5);">My Role</a></li>
            	 	<li class="hlepsub line smenu2" style="display:none;"><a id="menuCng6" onclick="setSubFrame(6);">My Project</a></li>
            	 	<li class="hlepsub line smenu2" style="display:none;"><a id="menuCng7" onclick="setSubFrame(7);">My Company</a></li>
            	
	        </ul>
	   	</div>
	</div>
	<div id="foldcontent" class="unfoldcontent"><div id="mainLayer" class="pdL20 pdR20" ></div></div>
</body>
</html>


