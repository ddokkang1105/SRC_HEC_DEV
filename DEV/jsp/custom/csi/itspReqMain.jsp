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
var pmenuIndex = "1 2 3 4 5 6 7 8 9"; // 각 menu index (submenu 포함)
var maxIndex = "${maxIndex}";
var startBoardIndex = "${startBoardIndex+1}";
var scrnType = "${scrnType}";
var mainType = "${mainType}";
var srMode = "${srMode}";	

	$(document).ready(function(){
		if(mainType == "REG"){
			setSubFrame(1, 'srcreate');	clickOpenClose(1);
		}else if(mainType == "srDsk"){
			setSubFrame(3); clickOpenClose(1);
		}else if(mainType =="mySRDtl") {
			setSubFrame(1, 'srview');	 clickOpenClose(1);
		}else if(mainType =="SRDtl") {
			setSubFrame(4, 'srview');	clickOpenClose(1);
		}else if(mainType == "SRDtlView"){ // from eMail
			setSubFrame(4,'SRDtlView'); clickOpenClose(1);
		}else{
			clickOpenClose(1);
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
		$("#mainLayer").innerHTML = $("#grdGridArea").attr("style","width:"+(setWindowWidth()-avg)+"px;");
		$("#mainLayer").innerHTML = p_gridArea.setSizes();
	}
	
	// [Menu] Click
	function setSubFrame(avg, avg2){
		clickSubMenu(avg); // 클릭한 변경
		
		var target = "mainLayer";
		var url = "";
		var data = "scrnType=${scrnType}&sysCode=${sysCode}&proposal=${proposal}&itemProposal=${itemProposal}&multiComp=${multiComp}&srStatus=${srStatus}&srArea1ListSQL=${srArea1ListSQL}";
		var srMode = "${srMode}";	
		/* My SR */
		if(avg == "1") {
			url =  "itspList.do";			
			if(avg2 == "srcreate"){
				data = data + "&srType=${srType}&pageNum=1&srMode="+srMode;					
			}else if(avg2 == "srview"){
				data = data + "&srID=${srID}&srType=${srType}&pageNum=1&mainType="+mainType;  
			}else  {
				data = data + "&srType=${srType}&srMode=mySR&pageNum=1";    
			}
		} 
				
		/* Final Test */
		if(avg == "2") {		
		url = "scrList.do";
		data =  data + "&pageNum=1&srMode=${srMode}&finTestor=${sessionScope.loginInfo.sessionUserId}";

		}
		/* 담당자 정보 */
		if(avg == "3") {
			url = "srAreaInfo.do";
			data = "ParentID=${projectID}&srType=${srType}";
		}
		
		/* 조회 및 등록 */
		if(avg == "4") {
			url = "itspList.do";
			var srMode = "${srMode}";
			 if(avg2 == "srview" || avg2 == "SRDtlView"){
					data = data + "&srID=${srID}&srType=${srType}&itemProposal=${itemProposal}&pageNum=1&mainType="+mainType; 
			}else  {
				data = data + "&srType=${srType}&pageNum=1";
			}
		} 
		

		if(avg == "5") { // 상신 : AREQ
			url = "wfInstanceList.do"; 
			data =  data + "&wfMode=AREQ&screenType=MyPg&wfStepID=AREQ";
		}
		
		if(avg == "6") { // 결재할 문서 CurAprv
			url = "wfInstanceList.do"; 
			data =  data + "&wfMode=CurAprv&screenType=MyPg";
		}
		
		if(avg == "7") { // 결재 예정 ToDoAprv
			url = "wfInstanceList.do"; 
			data =  data + "&wfMode=ToDoAprv&screenType=MyPg";
		}
		
		if(avg == "8") { // 승인완료 Cls
			url = "wfInstanceList.do"; 
			data =  data + "&wfMode=Cls&screenType=MyPg";
		}
		
		if(avg == "9") { // 참조 Ref + 관리조직 참조
			url = "wfInstanceList.do"; 
			data =  data + "&wfMode=RefMgt&screenType=MyPg";
		 }
		
		ajaxPage(url, data, target);
	}
	
	/* TODO ::::: Board (공지사항 (공통) 포함 ) */
	function setBrdFrame(noticType, avg, url, boardTypeCD) {
		//clickSubMenu(avg); // 클릭한 변경
		var target = "mainLayer";		
		var data = "s_itemID=${projectID}&noticType="+noticType+"&boardTypeCD="+boardTypeCD+"&url="+url+"&scrnType=${scrnType}";
		var url = "boardList.do";
		ajaxPage(url, data, target);
	}
	
	/* Report */
	function setRptFrame(curIndex, url) {
		clickSubMenu(curIndex); // 클릭한 변경
		var target = "mainLayer";
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
			//clickSubMenu(avg);
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
	             <li class="helpstitle plus1"><a onclick="clickOpenClose(1);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_chorder.png"><span class="fontchange">&nbsp;My Service</span></a></li>
                 <li class="helpstitle line minus1" style="display:none;"><a class="on" onclick="clickOpenClose(1);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_chorder.png"><span class="fontchange">&nbsp;My Service</span></a></li>
             	 	<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng1" onclick="setSubFrame(1);">&nbsp;My&nbsp;${menu.LN00286}</a></li>
<!--              	 	<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng2" onclick="setSubFrame(2);">&nbsp;개발 Test</a></li> -->
             		<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng3" onclick="setSubFrame(3);">&nbsp;Service Desk</a></li>
             		<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng4" onclick="setSubFrame(4);">&nbsp;${menu.LN00286}&nbsp;${menu.LN00047}</a></li>
             	
<%--              	 <li class="helpstitle line plus2"><a onclick="clickOpenClose(2);"><img src="${root}${HTML_IMG_DIR}/icon_stor_01.png"><span class="fontchange">&nbsp;${menu.LN00242}</span></a></li> --%>
<%-- 	                 <li class="helpstitle line minus2" style="display:none;"><a class="on" onclick="clickOpenClose(2);"><img src="${root}${HTML_IMG_DIR}/icon_stor_01.png"><span class="fontchange">&nbsp;${menu.LN00242}</span></a></li> --%>
<%-- 	             	 <li class="hlepsub line smenu2" style="display:none;"><a id="menuCng6" onclick="setSubFrame(6);">&nbsp;${menu.LN00243}</a></li> --%>
<%-- 	             	 <li class="hlepsub line smenu2" style="display:none;"><a id="menuCng5" onclick="setSubFrame(5);">&nbsp;${menu.LN00211}</a></li> --%>
<%-- 	             	 <li class="hlepsub line smenu2" style="display:none;"><a id="menuCng7" onclick="setSubFrame(7);">&nbsp;${menu.LN00244}</a></li> --%>
<%-- 	             	 <li class="hlepsub line smenu2" style="display:none;"><a id="menuCng8" onclick="setSubFrame(8);">&nbsp;${menu.LN00118}</a></li> --%>
<%-- 	             	 <li class="hlepsub line smenu2" style="display:none;"><a id="menuCng9" onclick="setSubFrame(9);">&nbsp;${menu.LN00245}</a></li>  --%>
             </ul>
    	</div>
	</div>
	<div id="foldcontent" class="unfoldcontent"><div id="mainLayer" class="pdL20 pdR20" ></div></div>
</body>
</html>


