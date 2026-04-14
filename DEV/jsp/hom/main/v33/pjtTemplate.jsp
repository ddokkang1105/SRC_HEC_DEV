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
* html #foldcontent{ /*IE6 hack*/
width: 100%; 
}
</style>
<script type="text/javascript">
var pmenuIndex = "${pmenuIndex}"; // 각 menu index (submenu 포함)
var maxIndex = "${maxIndex}";
var startBoardIndex = "${startBoardIndex+1}";
	$(document).ready(function(){
		clickOpenClose(11);
		setBrdFrame('${boardMgtID}',startBoardIndex, '${url}', '${boardTypeCD}'); 
		
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
		var data = "projectID=${projectID}";
		
		/* 프로젝트 Main */
		if(avg == "0") {
			url = "mainSttProject.do";
		}
		
		/* Change Management --> Change order */
		if(avg == "2") {
			url = "csrList.do";
			data = data + "&mainMenu=1&crMode=PJT&screenType=PJT";
		}
		/* Change Management --> Change set */
		if(avg == "3") {
			url = "changeInfoList.do";
			data = data + "&mainMenu=0&isMine=N&screenType=PJT";
		}
		/* Change Management --> Task */
		if(avg == "4") {
			url = "taskSearchList.do";
			data = data + "&isMainMenu=mainV3&parentID=${projectID}";
		}
		/* Change Management --> Change Request*/
		if(avg == "5") {
			url = "crList.do";
			data =  data + "&screenType=PJT&crMode=PJT";
		}
		
		/* Documents */
		if(avg == "6") {
			clickOpenClose(5); // submenu가 존재하는 menu닫는 처리			
			url = "documentGridList.do";
			data = "screenType=mainV3&pageNum=1&parentID=${projectID}&isPublic=N";
		}
		
		/* Schdule */
		if(avg == "7") {
			clickOpenClose(5); // submenu가 존재하는 menu닫는 처리
			url = "goSchdlList.do";	
			data = "screenType=mainV3&pageNum=1&parentID=${projectID}";
		}
		
		/* Project Info */
		if(avg == "8") {
			clickOpenClose(5); // submenu가 존재하는 menu닫는 처리
			url = "viewProjectInfo.do";
			data = "isNew=N&s_itemID=${projectID}&pjtMode=R&screenType=PJT";
		}
		
		if(avg == "9"){ // Service Request 신규			
			url =  "itspList.do";
			data =  data + "&srStatus=REQ&screenType=srRcv&srMode=PJT&srType=ITSP";
		}
		
		if(avg == "10"){
			url =  "itspList.do";
			data =  data + "&srStatus=ING&screenType=srRcv&srMode=PJT&srType=ITSP";
		}
		
		if(avg == "11"){
			url =  "itspList.do";
			data =  data + "&srStatus=COMPL&screenType=srRcv&srMode=PJT&srType=ITSP";
		}
		ajaxPage(url, data, target);
	}
	
	/* TODO ::::: Board (공지사항 (공통) 포함 ) */
	function setBrdFrame(BoardMgtID, avg, url, boardTypeCD) {
		clickSubMenu(avg); // 클릭한 변경
		var target = "help_content";		
		var data = "projectID=${projectID}&BoardMgtID="+BoardMgtID+"&boardTypeCD="+boardTypeCD+"&url="+url+"&screenType=PJT";
		var url = "boardList.do";
		ajaxPage(url, data, target);
	}
	
	/* Report */
	function setRptFrame(curIndex, url, reportCode) {
		clickSubMenu(curIndex); // 클릭한 변경
		var target = "help_content";
		var data = "s_itemID=${projectID}";
		
		ajaxPage(url, data, target);
		fnSetVisitLog(reportCode)
	}
	
	function fnSetVisitLog(reportCode){
		url = "setVisitLog.do";
		target = "help_content";
		data = "ActionType=RPT&MenuID="+reportCode;
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
		if (avg == 1 || avg == 2 || avg == 3 ) { 
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
	    		 <span style="font-size:14px;"> <img src="${root}${HTML_IMG_DIR}/icon_pjt.png">&nbsp;${projectName}</font>		 
	    		 <img id="btnFold" class="floatR mgT5" style="cursor:pointer;" src="${root}${HTML_IMG_DIR}/btn_layout_previous.png">
	    		 </span> 	    		
	   		 </li>
	   		 <li id="title2">
	    		 <img id="btnUnfold" name="btnUnfold" class="mgT5" style="cursor:pointer;"  src="${root}${HTML_IMG_DIR}/btn_layout_next.png"> 
	   		 </li>
	   	</ul>
    </div>
    <div id="foldframe" class="foldframe">
    	<div>
       		<ul class="help_menu">             
                 <!-- 1.Board -->
                 <c:forEach var="grpList" items="${boardGrpList}" varStatus="grpStatus">
	                 <li class="helpstitle plus${grpStatus.count+10}">
	                 	<a onclick="clickOpenClose(${grpStatus.count+10});"><img src="${root}${HTML_IMG_DIR}/icon_pjt_brd.png"><span class="fontchange">&nbsp;${grpList.BoardGrpName}</span></a></li>
	                 <li class="helpstitle line minus${grpStatus.count+10}" style="display:none;">
	                 	<a class="on" onclick="clickOpenClose(${grpStatus.count+10});"><img src="${root}${HTML_IMG_DIR}/icon_pjt_brd.png"><span class="fontchange">&nbsp;${grpList.BoardGrpName}</span></a></li>
	                 <c:forEach var="list" items="${boardMgtList}" varStatus="status">
	                 <c:if test= "${grpList.BoardGrpID == list.ParentID}" >
						<li style="display:none;"
						<c:choose>
							<c:when test="${(list.ParentIDCnt == status.count && boardGrpCnt > 1) || status.last}">class="hlepsub smenu${grpStatus.count+10}" </c:when>
							<c:otherwise>class="hlepsub line smenu${grpStatus.count+10}"</c:otherwise>
						</c:choose>
						><a id="menuCng${startBoardIndex + status.count}" onclick="setBrdFrame('${list.BoardMgtID}','${startBoardIndex + status.count}','${list.URL}','${list.BoardTypeCD}');">&nbsp;${list.BoardMgtName}</a>
						</li>
						</c:if>
					</c:forEach>
                 </c:forEach>
                  <!-- Service Request -->
                 <li class="helpstitle plus4"><a onclick="clickOpenClose(4);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_chorder.png"><span class="fontchange">&nbsp;${menu.LN00286}</span></a></li>
                 <li class="helpstitle line minus4" style="display:none;"><a class="on" onclick="clickOpenClose(4);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_chorder.png"><span class="fontchange">&nbsp;${menu.LN00286}</span></a></li> 
             	 	<!--li class="hlepsub line smenu4" style="display:none;"><a id="menuCng9" onclick="setSubFrame(9);">&nbsp;New</a></li-->
             	 	<li class="hlepsub line smenu4" style="display:none;"><a id="menuCng10" onclick="setSubFrame(10);">&nbsp;Processing</a></li>
             	 	<li class="hlepsub smenu4" style="display:none;"><a id="menuCng11" onclick="setSubFrame(11);">&nbsp;Closed</a></li>
             	 	
                 <!-- Change Management -->
                 <li class="helpstitle plus2"><a onclick="clickOpenClose(2);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_chorder.png"><span class="fontchange">&nbsp;${menu.LN00165}</span></a></li>
                 <li class="helpstitle line minus2" style="display:none;"><a class="on" onclick="clickOpenClose(2);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_chorder.png"><span class="fontchange">&nbsp;${menu.LN00165}</span></a></li> 
             	 	<li class="hlepsub line smenu2" style="display:none;"><a id="menuCng2" onclick="setSubFrame(2);">&nbsp;${menu.LN00191}</a></li>
             	 	<li class="hlepsub line smenu2" style="display:none;"><a id="menuCng3" onclick="setSubFrame(3);">&nbsp;${menu.LN00082}</a></li>
             	 	<c:if test="${useCR == 'Y'}" >
             	   		<li class="hlepsub line smenu2" style="display:none;"><a id="menuCng5" onclick="setSubFrame(5);">&nbsp;IT&nbsp${menu.LN00092}(CR)</a></li>
 		           	</c:if> 
 		           	<c:if test="${useTask == 'Y'}" >
            	 		<li class="hlepsub smenu2 " style="display:none;"><a id="menuCng4" onclick="setSubFrame(4);">&nbsp;Task</a></li>
            	    </c:if>
             	 
                 <!-- Documents -->
                 <li class="helpstitle"><a id="menuCng6" onclick="setSubFrame(6);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_chset.png"><span class="fontchange">&nbsp;${menu.LN00134}</span></a></li>
                 
                 <!-- Schdule -->
                 <li class="helpstitle"><a id="menuCng7" onclick="setSubFrame(7);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_sche.png"><span class="fontchange">&nbsp;${menu.LN00110}</span></a></li> 

				 <!-- Report -->
				 <li class="helpstitle plus3"><a onclick="clickOpenClose(3);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_rpt.png"><span class="fontchange">&nbsp;${menu.LN00287}</span></a></li>
                 <li class="helpstitle minus3" style="display:none;"><a class="on" onclick="clickOpenClose(3);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_rpt.png"><span class="fontchange">&nbsp;${menu.LN00287}</span></a></li> 
	             	<c:forEach var="list" items="${reportList}" varStatus="status">
						<li style="display:none;" 
						<c:choose>
							<c:when test="${status.last}">class="hlepsub smenu3" </c:when>
							<c:otherwise>class="hlepsub line smenu3"</c:otherwise>
						</c:choose>
						><a id="menuCng${startReportIndex + status.count}" onclick="setRptFrame('${startReportIndex + status.count}','${list.ReportURL}?${list.VarFilter}&reportCode=${list.ReportCode}','${list.ReportCode}');">&nbsp;${list.Name}</a>
						</li>
					</c:forEach>
				
				 <!-- Infomation  -->
	             <li class="helpstitle line"><a id="menuCng8" onclick="setSubFrame(8);"><img src="${root}${HTML_IMG_DIR}/icon_csr.png"><span class="fontchange">&nbsp;Information</span></a></li> 
             </ul>
    	</div>
	</div>
	<div id="foldcontent" class="unfoldcontent">
       <div id="help_content" class="pdT10 pdL10 pdR10" ></div>
	</div>
</body>
</html>


