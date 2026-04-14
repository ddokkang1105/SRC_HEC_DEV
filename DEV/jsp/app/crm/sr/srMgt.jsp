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
</style>
<script type="text/javascript">
var pmenuIndex = "1 2 3 4 "; // 각 menu index (submenu 포함)
var maxIndex = "${maxIndex}";
var startBoardIndex = "${startBoardIndex+1}";
	$(document).ready(function(){
		setSubFrame(1);

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
		$("#help_content").innerHTML = $("#grdGridArea").attr("style","width:"+(setWindowWidth()-avg)+"px;");
		$("#help_content").innerHTML = p_gridArea.setSizes();
	}
	
	// [Menu] Click
	function setSubFrame(avg){
		clickSubMenu(avg); // 클릭한 변경
		
		var target = "help_content";
		var url = "";
		var data = "screenType=${screenType}&srType=${srType}&sysCode=${sysCode}&proposal=${proposal}";
		var multiComp = "${multiComp}";
		/* SR New*/
		if(avg == "1") {
			if(multiComp == "Y") url = "srListByCompany.do"; else url = "srList.do";
		//	data = data + "&srType=${srType}&pageNum=1&srMode=${srMode}";
		//	data =  data + "&srStatus=REQ&pageNum=1&srMode=${srMode}";
			data = data + "&srStatus=ING&pageNum=1&srMode=${srMode}";
		}
		/* SR  Processing 
		if(avg == "2") {
			url =  "srList.do";
		//	data = data + "&srType=${srType}&srMode=mySR&pageNum=1";
			data = data + "&srStatus=ING&pageNum=1&srMode=${srMode}";
		}*/
		/* SR  Closed */
		if(avg == "2") {
			if(multiComp == "Y") url = "srListByCompany.do"; else url = "srList.do";
		//	data = data + "&srType=${srType}&srMode=mySR&pageNum=1";
			data =  data + "&srStatus=CMPL&pageNum=1&srMode=${srMode}";
		}
		
		/* SR  All */
		if(avg == "3") {
			if(multiComp == "Y") url = "srListByCompany.do"; else url = "srList.do";
		//	data = data + "&srType=${srType}&srMode=mySR&pageNum=1";
			data =  data + "&pageNum=1&srMode=${srMode}";
		}
		/* CR  List */
		if(avg == "4") {
			url = "crList.do"; 
			data =  data + "&crMode=${crMode}";
		}

		ajaxPage(url, data, target);
	}
	
	/* TODO ::::: Board (공지사항 (공통) 포함 ) */
	function setBrdFrame(noticType, avg, url, boardTypeCD) {
		//clickSubMenu(avg); // 클릭한 변경
		var target = "help_content";		
		var data = "s_itemID=${projectID}&noticType="+noticType+"&boardTypeCD="+boardTypeCD+"&url="+url+"&screenType=${screenType}";
		var url = "boardList.do";
		ajaxPage(url, data, target);
	}
	
	/* Report */
	function setRptFrame(curIndex, url) {
		clickSubMenu(curIndex); // 클릭한 변경
		var target = "help_content";
		var data = "s_itemID=${projectID}";
		
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
		
		// board, change Management, Report 이외의 menu remove [on]
		if (avg == 1 || avg == 2 || avg == 3 || avg == 4 ) { 
			clickSubMenu(avg);
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
<body id="mainMenu">
	<input id="chkSearch" type="hidden" value="false"></input>
	<div>
    	<ul class="help_menu">
    		 <li class="helptitle2" id="title1">
	    		 <span style="font-size:14px;"> <img src="${root}${HTML_IMG_DIR}/icon_pjt.png">&nbsp;${menu.LN00286}</font>		 
	    		 <img id="btnFold" class="floatR mgT5" src="${root}${HTML_IMG_DIR}/btn_layout_previous.png">
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
	        	<!--SR 신규/진행 중  -->
	            <li class="helpstitle"><a id="menuCng1" onclick="setSubFrame(1);"><img src="${root}${HTML_IMG_DIR}/csr_minus.png"><span class="fontchange">&nbsp;Processing</span></a></li>
	            <!-- SR Closed 중 -->
	            <li class="helpstitle"><a id="menuCng2" onclick="setSubFrame(2);"><img src="${root}${HTML_IMG_DIR}/csr_minus.png"><span class="fontchange">&nbsp;Closed</span></a></li>
	     		<!-- SR All -->
	            <li class="helpstitle"><a id="menuCng3" onclick="setSubFrame(3);"><img src="${root}${HTML_IMG_DIR}/csr_minus.png"><span class="fontchange">&nbsp;All</span></a></li>
	            <!-- CR List   -->
	         	<li class="helpstitle line"><a id="menuCng4" onclick="setSubFrame(4);"><img src="${root}${HTML_IMG_DIR}/csr_minus.png"><span class="fontchange">&nbsp;CR List</span></a></li> 
	        </ul>
	   	</div>
	</div>
	<div id="foldcontent" class="unfoldcontent"><div id="help_content" class="pdT10 pdL10 pdR10" ></div></div>
</body>
</html>


