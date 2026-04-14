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
a{
	cursor:pointer;
}
</style>

<script type="text/javascript">
var pmenuIndex = "${pmenuIndex}"; // 각 menu index (submenu 포함)
var maxIndex = "${maxIndex}";

	$(document).ready(function(){
		clickOpenClose(2);
		setSubFrame(7);
	//	setBrdFrame('${boardMgtID}',9, '${url}', '${boardTypeCD}'); 
	
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
		if(avg == "undefined"){avg = 0;}
		var setWidth = setWindowWidth()-avg;
		$("#help_content").innerHTML = $("#grdGridArea").attr("style","width:"+setWidth+"px;");
		$("#help_content").innerHTML = p_gridArea.setSizes();
		try{
			if(typeof(p_subGridArea) != "undefined"){
				$("#help_content").innerHTML = $("#subGrdGridArea").css("width",setWidth+"px;");
				$("#help_content").innerHTML = p_subGridArea.setSizes();
			}			
		}catch(e){alert(e);}
		try{
			if(typeof(p_chart) != "undefined"){
				$("#help_content").innerHTML = $("#chartArea").css("width",setWidth+"px;");
				$("#help_content").innerHTML = p_chart.refresh();
			}
		}catch(e){alert(e);}
	}
	
	// [Menu] Click
	function setSubFrame(avg){
		clickSubMenu(avg); // 클릭한 변경
		
		var target = "help_content";
		var url = "";
		var data = "projectID=${projectID}";		
	
		if(avg == "1") {
	
			url = "myProjectList.do";
			data = data + "&screenType=PG&mainVersion=mainV5";
		}
		if(avg == "2") {
			url = "csrList.do";
			data = data + "&mainMenu=1&crMode=PG&screenType=PG";
		}
		/* Change Management --> Change set */
		if(avg == "3") {
			url = "changeInfoList.do";
			data = data + "&mainMenu=0&isMine=N&screenType=PG";
		}
		/* Change Management --> CrMstList */
		if(avg == "4") {
			url = "crList.do"; 
			data =  data + "&screenType=PG&srType=ITSP&crMode=PG";
		}
		/* Change Management --> Task */
		if(avg == "5") {
			url = "taskSearchList.do";
			data = data + "&isMainMenu=mainV3&parentID=${projectID}";
		} 
		
		/* Service Request 
		if(avg == "6") { // 신규
			url = "srList.do";
			data =  data + "&srStatus=REQ&screenType=srRcv&srMode=PG&srType=ITSP";
		} */
		
		if(avg == "7") { // 진행중
			url =  "itspList.do";
			data =  data + "&srType=${srType}&srStatus=ING&pageNum=1${srVarFilter}";
		}
		
		if(avg == "8") { // 완료
			url =  "itspList.do";
			data =  data + "&srType=${srType}&srStatus=COMPL&pageNum=1${srVarFilter}";
		}

		ajaxPage(url, data, target);
	}
	
	/* TODO ::::: Board (공지사항 (공통) 포함 ) */
	function setBrdFrame(BoardMgtID, avg, url, boardTypeCD) {
		clickSubMenu(avg); // 클릭한 변경
		var target = "help_content";		
		var data = "projectID=${projectID}&BoardMgtID="+BoardMgtID+"&boardTypeCD="+boardTypeCD+"&url="+url+"&screenType=PG";
		var url = "boardList.do";
		ajaxPage(url, data, target);
	}
	
	/* Report */
	function setRptFrame(curIndex, url, reportCode) {
		clickSubMenu(curIndex); // 클릭한 변경
		var target = "help_content";
		var data = "s_itemID=${projectID}&refPGID=${projectID}";
		
		ajaxPage(url, data, target);
		fnSetVisitLog(reportCode);
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
		if (avg == 1 || avg == 2 || avg == 3) { 
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
	    		 <span style="font-size:14px;"> <img src="${root}cmm/common/images/menu//icon_pjt.png">&nbsp;${projectName}</font>		 
	    		 <img id="btnFold" class="floatR mgT10 mgR15" src="${root}cmm/common/images/menu//btn_layout_previous.png">
	    		 </span> 	    		
	   		 </li>
	   		 <li id="title2">
	    		<img id="btnUnfold" name="btnUnfold" class="mgT10 mgL15" src="${root}cmm/common/images/menu//btn_layout_next.png"> 
	   		 </li>
	   	</ul>
    </div>
    <div id="foldframe" class="foldframe">
    	<div>
       		<ul class="help_menu">      
                 <!-- Service Request -->
                 <li class="helpstitle line plus2"><a onclick="clickOpenClose(2);"><img src="${root}cmm/common/images/menu//icon_pjt_chorder.png"><span class="fontchange">&nbsp;${menu.LN00286}</span></a></li>
                 <li class="helpstitle line minus2" style="display:none;"><a class="on" onclick="clickOpenClose(2);"><img src="${root}cmm/common/images/menu//icon_pjt_chorder.png"><span class="fontchange">&nbsp;${menu.LN00286}</span></a></li> 
             	 	<!--li class="hlepsub line smenu2" style="display:none;"><a id="menuCng6" onclick="setSubFrame(6);">&nbsp;New</a></li-->
             	 	<li class="hlepsub line smenu2" style="display:none;"><a id="menuCng7" onclick="setSubFrame(7);">&nbsp;Processing</a></li>
             	 	<li class="hlepsub line smenu2" style="display:none;"><a id="menuCng8" onclick="setSubFrame(8);">&nbsp;Closed</a></li>
             	 	
                 <!-- Change Management -->
                 <li class="helpstitle line plus1"><a onclick="clickOpenClose(1);"><img src="${root}cmm/common/images/menu//icon_pjt_chorder.png"><span class="fontchange">&nbsp;${menu.LN00165}</span></a></li>
                 <li class="helpstitle line minus1" style="display:none;"><a class="on" onclick="clickOpenClose(1);"><img src="${root}cmm/common/images/menu//icon_pjt_chorder.png"><span class="fontchange">&nbsp;${menu.LN00165}</span></a></li> 
             	 	<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng1" onclick="setSubFrame(1);">&nbsp;${menu.LN00131}</a></li>
             	 	<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng2" onclick="setSubFrame(2);">&nbsp;${menu.LN00191}</a></li>
             	 	<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng3" onclick="setSubFrame(3);">&nbsp;${menu.LN00082}</a></li>
             	 	<c:if test="${useCR == 'Y'}" >
             	 		<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng4" onclick="setSubFrame(4);">&nbsp;IT&nbsp${menu.LN00092}(CR)</a></li>
             	 	</c:if>
             	 	<c:if test="${useTask == 'Y'}" >
             		 <li class="hlepsub smenu1 " style="display:none;"><a id="menuCng5" onclick="setSubFrame(5);">&nbsp;Task</a></li> 
	 				</c:if>
	             <!-- Report -->
				 <li class="helpstitle line plus3"><a onclick="clickOpenClose(3);"><img src="${root}cmm/common/images/menu/icon_pjt_rpt.png"><span class="fontchange">&nbsp;${menu.LN00287}</span></a></li>
                 <li class="helpstitle line minus3" style="display:none;"><a class="on" onclick="clickOpenClose(3);"><img src="${root}cmm/common/images/menu//icon_pjt_rpt.png"><span class="fontchange">&nbsp;${menu.LN00287}</span></a></li> 
	             	<c:forEach var="list" items="${reportList}" varStatus="status">
						<li style="display:none;" 
						<c:choose>
							<c:when test="${status.last}">class="hlepsub smenu3" </c:when>
							<c:otherwise>class="hlepsub line smenu3"</c:otherwise>
						</c:choose>
						><a id="menuCng${startReportIndex + status.count}" onclick="setRptFrame('${startReportIndex + status.count}','${list.ReportURL}?${list.VarFilter}&reportCode=${list.ReportCode}','${list.ReportCode}');">&nbsp;${list.Name}</a>
						</li>
					</c:forEach>
				<!-- 1.Board -->
                 <c:forEach var="grpList" items="${boardGrpList}" varStatus="grpStatus">
	                 <li class="helpstitle line plus${grpStatus.count+3}"> 	                 
	                 	<a onclick="clickOpenClose(${grpStatus.count+3});"><img src="${root}cmm/common/images/menu/icon_pjt_brd.png"><span class="fontchange">&nbsp;${grpList.BoardGrpName}</span></a>
	                 </li>
	                 <li class="helpstitle line minus${grpStatus.count+3}"  style="display:none;" >	                 
	                 	<a class="on" onclick="clickOpenClose(${grpStatus.count+3});">
	                 	<img src="${root}cmm/common/images/menu/icon_pjt_brd.png"><span class="fontchange">&nbsp;${grpList.BoardGrpName }</span></a>
	                 </li>
                 	 <c:forEach var="list" items="${boardList}" varStatus="status">
                 		<c:if test= "${grpList.BoardGrpID == list.ParentID}" >
							<li style="display:none;"
							<c:choose>
							 <c:when test="${status.last}">							
							  class="hlepsub line smenu${grpStatus.count+3}" 
							 </c:when>
							 <c:otherwise>class="hlepsub line smenu${grpStatus.count+3}"</c:otherwise>
							</c:choose>
							> 
							<a id="menuCng${startBoardIndex + status.count}" onclick="setBrdFrame('${list.BoardMgtID}','${startBoardIndex + status.count}','${list.URL}','${list.BoardTypeCD}');">&nbsp;${list.BoardMgtName}</a>
							</li>
						</c:if>
					 </c:forEach>
                 </c:forEach>	
               </ul>
    	</div>
	</div>
	<div id="foldcontent" class="unfoldcontent">
       <div id="help_content" class="pdT10 pdL10 pdR10" ></div>
	</div>
</body>
</html>


