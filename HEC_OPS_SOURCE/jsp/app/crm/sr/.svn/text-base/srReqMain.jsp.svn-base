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
a{
	cursor:pointer;
}
</style>
<script type="text/javascript">
var pmenuIndex = "1 2 3 4"; // 각 menu index (submenu 포함)
var maxIndex = "${maxIndex}";
var startBoardIndex = "${startBoardIndex+1}";
var screenType = "${screenType}";
var mainType = "${mainType}";
var srMode = "${srMode}";	

	$(document).ready(function(){
		if(mainType == "REG"){
			setSubFrame(1, 'srcreate');	
		}else if(mainType == "srDsk"){
			setSubFrame(3);
		}else if(mainType == "srFAQ"){
			setSubFrame(2);
		}else if(mainType =="mySRDtl") {
			setSubFrame(1, 'srview');	
		}else if(mainType =="SRDtl") {
			setSubFrame(4, 'srview');	
		}else if(mainType == "SRDtlView"){ // from eMail
			setSubFrame(4,'SRDtlView');
		}else{		
			setSubFrame(1);	
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
		$("#help_content").innerHTML = $("#grdGridArea").attr("style","width:"+(setWindowWidth()-avg)+"px;");
		$("#help_content").innerHTML = p_gridArea.setSizes();
	}
	
	// [Menu] Click
	function setSubFrame(avg, avg2){
		clickSubMenu(avg); // 클릭한 변경
		
		var target = "help_content";
		var url = "";
		var data = "screenType=${screenType}&sysCode=${sysCode}&proposal=${proposal}";
		var srMode = "${srMode}";	
		/* My SR */
		if(avg == "1") {
			url =  "srList.do";			
			if(avg2 == "srcreate"){
			data = data + "&srType=${srType}&pageNum=1&srMode="+srMode;					
			}else if(avg2 == "srview"){
				data = data + "&srID=${srID}&srType=${srType}&pageNum=1&mainType="+mainType;  
			}else  {
				data = data + "&srType=${srType}&srMode=mySR&pageNum=1";    
			}
		} 
		/* Team SR 
		if(avg == "3") {
			url =  "srList.do";
			data = data + "&srType=${srType}&srMode=myTeam&pageNum=1";                  
		}
			
		/* FAQ */
		if(avg == "2") {
		  var 	url =  "boardList.do";
		  var 	data = data + "&BoardMgtID=4&boardTypeCD=MN007&url=boardList&&myBoard=Y";

		}
		/* 담당자 정보 */
		if(avg == "3") {
			url = "srAreaInfo.do";
			data = "ParentID=${projectId}&srType=${srType}";
		}
		
		/* 조회 및 등록 */
		if(avg == "4") {
			url = "srList.do";
			var srMode = "${srMode}";
			 if(avg2 == "srview" || avg2 == "SRDtlView"){
					data = data + "&srID=${srID}&srType=${srType}&pageNum=1&mainType="+mainType; 
			}else  {
				data = data + "&srType=${srType}&pageNum=1";
			}
		} 
	
		ajaxPage(url, data, target);
	}
	
	/* TODO ::::: Board (공지사항 (공통) 포함 ) */
	function setBrdFrame(noticType, avg, url, boardTypeCD) {
		//clickSubMenu(avg); // 클릭한 변경
		var target = "help_content";		
		var data = "s_itemID=${projectId}&noticType="+noticType+"&boardTypeCD="+boardTypeCD+"&url="+url+"&screenType=${screenType}";
		var url = "boardList.do";
		ajaxPage(url, data, target);
	}
	
	/* Report */
	function setRptFrame(curIndex, url) {
		clickSubMenu(curIndex); // 클릭한 변경
		var target = "help_content";
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
		if ( avg == 5 || $(".smenu" + avg).css("display") == "none" ||  $(".plus"+ avg).css("display") != "none") {
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
		if (avg == 1 || avg == 2 || avg == 3 || avg == 4) { 
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
	    		 <span style="font-size:14px;"> <img src="${root}${HTML_IMG_DIR}/icon_pjt.png">&nbsp;${menu.LN00286}	 
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
                 <!-- My SR -->
                 <li class="helpstitle"><a id="menuCng1" onclick="setSubFrame(1);"><img src="${root}${HTML_IMG_DIR}/csr_minus.png"><span class="fontchange">&nbsp;My&nbsp;${menu.LN00286}</span></a></li>
                 <!-- FAQ -->
                 <li class="helpstitle"><a id="menuCng2" onclick="setSubFrame(2);"><img src="${root}${HTML_IMG_DIR}/csr_minus.png"><span class="fontchange">&nbsp;${menu.LN00215}</span></a></li>
                  <!-- Service desk -->
		         <li class="helpstitle"><a id="menuCng3" onclick="setSubFrame(3);"><img src="${root}${HTML_IMG_DIR}/csr_minus.png"><span class="fontchange">&nbsp;Service Desk</span></a></li> 
 				 <!-- 조회 및 등록 -->
	             <li class="helpstitle line"><a id="menuCng4" onclick="setSubFrame(4);"><img src="${root}${HTML_IMG_DIR}/csr_minus.png"><span class="fontchange">&nbsp;${menu.LN00286}&nbsp;${menu.LN00047}</span></a></li> 
             </ul>
    	</div>
	</div>
	<div id="foldcontent" class="unfoldcontent"><div id="help_content" class="pdT10 pdL10 pdR10" ></div></div>
</body>
</html>


