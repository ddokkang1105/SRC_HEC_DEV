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
var menuIndex = "1 2 3 4 5 6 8 9 10 11 12 13 14 15 51 52 53 54";
var bmenuIndex = "1 2 3 4";
	
	$(document).ready(function(){
		clickOpenClose(1);
		//setSubFrame(1); // process report
		
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
		clickSubMenu(avg); // 클릭한 메뉴 color 변경
		
		var target = "help_content";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&projectID=${projectId}";
		var url = "";
		
		if(avg == "1") {  // ITEM --> Process
			url = "newItemStatistics.do";
			data = data + "&isMainMenu=Y";
		}		
		if(avg == "2") {
			//url = "visitLogStatistics.do";
			url = "visitLogStatisticsByDay.do?haederL1=OJ00001";
		}
		if(avg == "3") { // Change --> Change Set
			url = "changeSetStatistics.do";
			data = data + "&isMainMenu=Y";
		}
		if(avg == "4") {  // Change --> Task
			url = "taskStatistics.do";
			data = data + "&isMainMenu=Y";
		}
		if(avg == "5") { // process Deleted List
			url = "itemDeletedList.do";
		}
		if(avg == "6") { // Model Object
			url = "modelObjectSearch.do";
		}
		if(avg == "8") {  // Change --> Task(Plan/Actual)
			//data = data + "&isMainMenu=Y";
			url = "taskPAresult.do";
		}
		if(avg == "9") {  // Change --> Task Monitoring
			url = "taskMonitoringList.do";
			data = data + "&isMainMenu=Y";
		}
		if(avg == "10") {  // Change --> Task SearchList
			url = "taskSearchList.do";
			data = data + "&isMainMenu=Y";
		}
		if(avg == "11"){
			url = "connectionList.do";
			data = data + "&DeletedYN=Y";
		}
		if(avg == "12"){
			url = "tranAttrList.do";
		}
		if(avg == "13"){
			url = "itemAuthorLogMgt.do";
		}
		if(avg == "14"){
			url = "teamItemMappingList.do?reportCode=RP00040";
		}
		if(avg == "15"){
			url = "teamChangeLogMgt.do";
		}
		if(avg == "99") {  // SR Dashboard
			url = "srDashboard.do";//"srMonitoring.do";//
		}
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
		var realMenuIndex = menuIndex.split(' ');
		var menuName = "menuStt";
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
		if ($(".smenu" + avg).css("display") == "none") {
			$(".smenu" + avg).css("display", "block");
			$(".plus" + avg).css("display", "none");
			$(".minus" + avg).css("display", "block");
			setOtherArea(avg); // 그외 내용을 닫아줌
		} else {
			$(".smenu" + avg).css("display", "none");
			$(".plus" + avg).css("display", "block");
			$(".minus" + avg).css("display", "none");
		}
	}
	function setOtherArea(avg) {
		var indexArray = bmenuIndex.split(' ');
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
a{
	cursor:pointer;
}
#carcontent{
	border-left:0px solid #fff;
}
</style>
<input id="chkSearch" type="hidden" value="false"></input>
<body id="mainMenu">
	
		<div>
			<ul class="help_menu">
	        	<li class="helptitle2" id="title1">
	            	<span style="font-size:14px;"><img src="${root}${HTML_IMG_DIR}/icon_statistics.png">&nbsp;${menu.LN00041}</font>	
	                 <img id="btnFold" class="floatR mgT5" src="${root}${HTML_IMG_DIR}/btn_layout_previous.png">
	            </li>
	    		<li id="title2">
		    		<img id="btnUnfold" name="btnUnfold" class="mgT5" src="${root}${HTML_IMG_DIR}/btn_layout_next.png"> 
	    		</li>
	    	</ul>	
	    </div>
    	 	 
		<div id="foldframe" class="foldframe">
			<div>
        		<ul class="help_menu">
	                 <!-- 관리자 통계 Menu -->
	                 <c:if test="${screenMode == ''}">
		                 <!-- 1.ITEM 통계 -->
		                 <li class="helpstitle plus1"><a onclick="clickOpenClose(1);"><img src="${root}${HTML_IMG_DIR}/csr_right.png"><span class="fontchange">&nbsp;ITEM</span></a></li>
		                 <li class="helpstitle line minus1" style="display:none;"><a class="on" onclick="clickOpenClose(1);"><img src="${root}${HTML_IMG_DIR}/csr_minus.png"><span class="fontchange">&nbsp;ITEM</span></a></li>
		                 	<li class="hlepsub line smenu1" style="display:none;"><a id="menuStt1" onclick="setSubFrame(1);">Process</a></li>
		            		<li class="hlepsub line smenu1" style="display:none;"><a id="menuStt5" onclick="setSubFrame(5);">Deleted List(Item)</a></li>
		            		<li class="hlepsub line smenu1" style="display:none;"><a id="menuStt11" onclick="setSubFrame(11);">Deleted List(Connection)</a></li>
		            		<li class="hlepsub smenu1" style="display:none;"><a id="menuStt12" onclick="setSubFrame(12);">Translation</a></li>
		            	 <!-- 2.Change 통계 -->
		                 <li class="helpstitle plus4"><a onclick="clickOpenClose(4);"><img src="${root}${HTML_IMG_DIR}/csr_right.png"><span class="fontchange">&nbsp;Change</span></a></li>
		                 <li class="helpstitle line minus4" style="display:none;"><a class="on" onclick="clickOpenClose(4);"><img src="${root}${HTML_IMG_DIR}/csr_minus.png"><span class="fontchange">&nbsp;Change</span></a></li> 
		             	 	
		             	 	<li class="hlepsub line smenu4" style="display:none;"><a id="menuStt3" onclick="setSubFrame(3);" >Change Set</a></li>
		             	 	<li class="hlepsub line smenu4" style="display:none;"><a id="menuStt8" onclick="setSubFrame(8);" >Task(Plan/Actual)</a></li>
		             	 	<li class="hlepsub smenu4" style="display:none;"><a id="menuStt4" onclick="setSubFrame(4);" >Task</a></li>
		            			
		            	 <!-- 3.Model 통계 -->
		            	  <li class="helpstitle plus2" ><a onclick="clickOpenClose(2);"><img src="${root}${HTML_IMG_DIR}/csr_right.png"><span class="fontchange">&nbsp;Model</span></a></li>
		            	 <li class="helpstitle line minus2" style="display:none;"><a class="on" onclick="clickOpenClose(2);"><img src="${root}${HTML_IMG_DIR}/csr_minus.png"><span class="fontchange">&nbsp;MODEL</span></a></li>
		                 	<li class="hlepsub smenu2" style="display:none;"><a id="menuStt6" onclick="setSubFrame(6);">Model Object</a></li>
		                 		
		            	 <!-- 4.Visit 통계 -->
		            	 <li class="helpstitle plus3" ><a onclick="clickOpenClose(3);"><img src="${root}${HTML_IMG_DIR}/csr_right.png"><span class="fontchange">&nbsp;User/Team</span></a></li>
		                 <li class="helpstitle line minus3" style="display:none;"><a class="on" onclick="clickOpenClose(3);"><img src="${root}${HTML_IMG_DIR}/csr_minus.png"><span class="fontchange">&nbsp;User/Team</span></a></li>
		                 	<!-- <li class="hlepsub line smenu3" style="display:none;"><a id="menuStt2" onclick="setSubFrame(2);">Visit Log</a></li> -->
		                 	<li class="hlepsub line smenu3" style="display:none;"><a id="menuStt2" onclick="setSubFrame(2);">Daily Visit Log by Item Type</a></li>
		                 	<li class="hlepsub line smenu3" style="display:none;"><a id="menuStt13" onclick="setSubFrame(13);">Item Owner Log</a></li>
		                 	<li class="hlepsub line smenu3" style="display:none;"><a id="menuStt14" onclick="setSubFrame(14);">${reportNameMap.RP00040}</a></li>
		                 	<li class="hlepsub smenu3" style="display:none;"><a id="menuStt15" onclick="setSubFrame(15);">Team Change Log</a></li>
		                 	
		                <!-- 5. Additional -->
						<li class="helpstitle line plus5"><a onclick="clickOpenClose(5);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_rpt.png"><span class="fontchange">&nbsp;Additional</span></a></li>
                 		<li class="helpstitle line minus5" style="display:none;"><a class="on" onclick="clickOpenClose(5);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_rpt.png"><span class="fontchange">&nbsp;Additional</span></a></li> 
		             	<c:forEach var="list" items="${reportList}" varStatus="status">
							<li style="display:none;" 
							<c:choose>
								<c:when test="${status.last}">class="hlepsub line smenu5" </c:when>
								<c:otherwise>class="hlepsub line smenu5"</c:otherwise>
							</c:choose>
							><a id="menuStt${status.count+50}" onclick="setRptFrame('${status.count+50}','${list.ReportURL}?${list.VarFilter}&reportCode=${list.ReportCode}');">&nbsp;${list.Name}</a>
							</li>
						</c:forEach>
		                 
	             	 </c:if>
	             	 
	             	 <!-- 일반 사용자 통계 Menu -->
	             	 <c:if test="${screenMode == 'view'}">
		                 <!-- 1.ITEM 통계 -->
		         	     <li class="helpstitle plus1"><a onclick="clickOpenClose(1);"><img src="${root}${HTML_IMG_DIR}/csr_right.png"><span class="fontchange">&nbsp;개발진척</span></a></li>
		                 <li class="helpstitle line minus1" style="display:none;"><a class="on" onclick="clickOpenClose(1);"><img src="${root}${HTML_IMG_DIR}/csr_minus.png"><span class="fontchange">&nbsp;개발진척</span></a></li>
						 <li class="hlepsub smenu1" style="display:none;"><a id="menuStt8" onclick="setSubFrame(8);" >Plan/Actual</a></li>
						 <li class="hlepsub smenu1" style="display:none;"><a id="menuStt9" onclick="setSubFrame(9);" >Task Monitoring</a></li>
  					 	 <li class="hlepsub smenu1" style="display:none;"><a id="menuStt10" onclick="setSubFrame(10);" >T<!-- 4.Visit 통계 -->ask List</a></li>
  					 <!-- 2.Change 통계-->
		                 <li class="helpstitle line plus4"><a onclick="clickOpenClose(4);"><img src="${root}${HTML_IMG_DIR}/csr_right.png"><span class="fontchange">&nbsp;ETC</span></a></li>
		                 <li class="helpstitle line minus4" style="display:none;"><a class="on" onclick="clickOpenClose(4);"><img src="${root}${HTML_IMG_DIR}/csr_minus.png"><span class="fontchange">&nbsp;ETC</span></a></li> 
		             		<li class="hlepsub line smenu4" style="display:none;"><a id="menuStt1" onclick="setSubFrame(1);">Process</a></li>
		             		<li class="hlepsub line smenu4" style="display:none;"><a id="menuStt3" onclick="setSubFrame(3);" >Change Set</a></li>
		                    <li class="hlepsub line smenu4" style="display:none;"><a id="menuStt4" onclick="setSubFrame(4);" >Task</a></li>	 
	             	 </c:if>
	        	 </ul>
    		</div>
		</div>

    <div id="foldcontent" class="unfoldcontent"><div id="help_content" class="pdT10 pdL10 pdR10" ></div></div>
</body>
</html>


