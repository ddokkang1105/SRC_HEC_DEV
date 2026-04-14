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

<script type="text/javascript">
var menuIndex = "1 2 3 4 5 6 8 9 10 11 12 13 14 15 51 52 53 54 55 56 57";
var bmenuIndex = "1 2 3 4 5 6";
	
	$(document).ready(function(){
		clickOpenClose(1);
		
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
		let reportCode = "rpt";
		if(avg == "14"){
			reportCode = "RP00040";
			var src = "teamItemMappingList.do?reportCode="+reportCode;
			
			document.getElementById('rptFrame').contentWindow.location.href= src; 
			$("#rptFrame").attr("style", "display:block;border: 0;overflow:auto; padding:10 10 10px 10;");
			$("#help_content").attr("style", "display:none;");
		
		} else {
			var target = "help_content";
			var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&projectID=${projectID}";
			var url = "";
			
			if(avg == "1") {  // ITEM --> Process
				reportCode = "RP00018";
				url = "admin/newItemStatistics.do";
				data = data + "&isMainMenu=Y";
			}		
			if(avg == "2") {
				reportCode = "RP00041";
				url = "visitLogStatisticsByDay.do?haederL1=OJ00001";
			}
			if(avg == "3") { // Change --> Change Set
				reportCode = "RP00020";
				url = "changeSetStatistics.do";
				data = data + "&isMainMenu=Y";
			}
			if(avg == "4") {  // Change --> Task
				reportCode = "RP00021";
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
				reportCode="RP00023";
				url = "taskPAresult.do";
			}
			if(avg == "9") {  // Change --> Task Monitoring
				reportCode = "RP00024";
				url = "taskMonitoringList.do";
				data = data + "&isMainMenu=Y";
			}
			if(avg == "10") {  // Change --> Task SearchList
				reportCode="RP00025";
				url = "taskSearchList.do";
				data = data + "&isMainMenu=Y";
			}
			if(avg == "11"){
				reportCode = "RP00033";
				url = "connectionList.do";
				data = data + "&DeletedYN=Y";
			}
			if(avg == "12"){
				url = "tranAttrList.do";
			}
			if(avg == "13"){
				url = "itemAuthorLogMgt.do";
				reportCode = "RP00036";
			}
			/* if(avg == "14"){
				url = "teamItemMappingList.do?reportCode=RP00040";
			} */
			if(avg == "15"){
				url = "teamChangeLogMgt.do";
				reportCode = "RP00042";
			}
						
			if(avg == "99") {  // SR Dashboard
				url = "srDashboard.do";//"srMonitoring.do";//
				reportCode = "RP00030";
			}
			$("#rptFrame").attr("style", "display:none;border: 0;overflow:auto; padding:10 10 10px 10;");
			$("#help_content").attr("style", "block");
			
			ajaxPage(url, data, target);			
			
		}
		fnSetVisitLog(reportCode);
	}
	
	function fnSetVisitLog(reportCode){
		// insertVisitLog
		url = "setVisitLog.do";
		target = "blankFrame";
		data = "ActionType=RPT&MenuID="+reportCode;
		ajaxPage(url, data, target);
	}
	
	/* Report */
	function setRptFrame(curIndex, url,reportCode) {
		clickSubMenu(curIndex); // 클릭한 변경
		fnSetVisitLog(reportCode);
		if(reportCode == "ZHKFC09"){
			var src = url;				
			document.getElementById('rptFrame').contentWindow.location.href= src; 
			$("#rptFrame").attr("style", "display:block;border: 0;overflow:auto; padding:10 10 10px 10;");
			$("#help_content").attr("style", "display:none;");
	
		}else{
			$("#help_content").attr("style", "block");
			$("#rptFrame").attr("style", "display:none;border: 0;overflow:auto; padding:10 10 10px 10;");
			
			var target = "help_content";
			var data = "s_itemID=${projectID}";
			ajaxPage(url, data, target);
		}
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

.frame-container {
        padding: 10px; 
 }
    
</style>
<input id="chkSearch" type="hidden" value="false"></input>
<body id="mainMenu">
	
		<div>
			<ul class="help_menu">
	        	<li class="helptitle2" id="title1">
	            	<span style="font-size:15px;">&nbsp;통계</span>	
	                 <img id="btnFold" class="floatR mgT10 mgR15" src="${root}${HTML_IMG_DIR}/btn_layout_previous.png">
	            </li>
	    		<li id="title2">
		    		<img id="btnUnfold" name="btnUnfold" class="mgT10 mgL15" src="${root}${HTML_IMG_DIR}/btn_layout_next.png"> 
	    		</li>
	    	</ul>	
	    </div>
    	 	 
		<div id="foldframe" class="foldframe">
			
        		<ul class="help_menu">
	                 <!-- 관리자 통계 Menu -->
	                 <c:if test="${screenMode == ''}">
		                 <!-- 1.ITEM 통계 -->
		                 <li class="helpstitle line plus1"><a onclick="clickOpenClose(1);" class="hov"><img src="${root}cmm/common/images/menu/icon_sidebar_contents.png"><span class="fontchange">&nbsp;ITEM</span>
		                 <img id="btnFold" class="floatR mgT10 mgR5" src="${root}cmm/common/images/menu/sidebar_tap_open.png"></a></li>
		                 <li class="helpstitle line minus1" style="display:none;"><a class="on" onclick="clickOpenClose(1);"><img src="${root}cmm/common/images/menu/icon_sidebar_contents_g.png"><span class="fontchange">&nbsp;ITEM</span>
		                  <img id="btnFold" class="floatR mgT10 mgR5" src="${root}cmm/common/images/menu/sidebar_tap_close2.png"></a></li>
		                 	<li class="hlepsub line smenu1" style="display:none;"><a id="menuStt1" onclick="setSubFrame(1);">Process</a></li>
		            		<li class="hlepsub line smenu1" style="display:none;"><a id="menuStt5" onclick="setSubFrame(5);">Deleted List(Item)</a></li>
		            		<li class="hlepsub line smenu1" style="display:none;"><a id="menuStt11" onclick="setSubFrame(11);">Deleted List(Connection)</a></li>
		            		<li class="hlepsub smenu1" style="display:none;"><a id="menuStt12" onclick="setSubFrame(12);">Translation</a></li>
		            	 <!-- 2.Change 통계 -->
		                 <li class="helpstitle line plus4"><a onclick="clickOpenClose(4);"class="hov"><img src="${root}cmm/common/images/menu/icon_sidebar_cts.png"><span class="fontchange">&nbsp;Change</span>
		                 <img id="btnFold" class="floatR mgT10 mgR5" src="${root}cmm/common/images/menu/sidebar_tap_open.png"></a></li>
		                 <li class="helpstitle line minus4" style="display:none;"><a class="on" onclick="clickOpenClose(4);"><img src="${root}cmm/common/images/menu/icon_sidebar_cts_g.png"><span class="fontchange">&nbsp;Change</span>
		                 <img id="btnFold" class="floatR mgT10 mgR5" src="${root}cmm/common/images/menu/sidebar_tap_close2.png"></a></li> 
		             	 	
		             	 	<li class="hlepsub line smenu4" style="display:none;"><a id="menuStt3" onclick="setSubFrame(3);" >Change Set</a></li>
		             	 	<li class="hlepsub line smenu4" style="display:none;"><a id="menuStt8" onclick="setSubFrame(8);" >Task(Plan/Actual)</a></li>
		             	 	<!-- <li class="hlepsub smenu4" style="display:none;"><a id="menuStt4" onclick="setSubFrame(4);" >Task</a></li> -->
		            			
		            	 <!-- 3.Model 통계 -->
		            	  <li class="helpstitle line plus2" ><a onclick="clickOpenClose(2);"class="hov"><img src="${root}cmm/common/images/menu/icon_sidebar_model.png"><span class="fontchange">&nbsp;Model</span>
		            	  <img id="btnFold" class="floatR mgT10 mgR5" src="${root}cmm/common/images/menu/sidebar_tap_open.png"></a></li>
		            	 <li class="helpstitle line minus2" style="display:none;"><a class="on" onclick="clickOpenClose(2);"><img src="${root}cmm/common/images/menu/icon_sidebar_model_g.png"><span class="fontchange">&nbsp;Model</span>
		            	 <img id="btnFold" class="floatR mgT10 mgR5" src="${root}cmm/common/images/menu/sidebar_tap_close2.png"></a></li>
		                 	<li class="hlepsub smenu2" style="display:none;"><a id="menuStt6" onclick="setSubFrame(6);">Model Object</a></li>
		                 		
		            	 <!-- 4.Visit 통계 -->
		            	 <li class="helpstitle line plus3" ><a onclick="clickOpenClose(3);"class="hov"><img src="${root}cmm/common/images/menu/icon_sidebar_role.png"><span class="fontchange">&nbsp;User/Team</span>
		            	 <img id="btnFold" class="floatR mgT10 mgR5" src="${root}cmm/common/images/menu/sidebar_tap_open.png"></a></li>
		                 <li class="helpstitle line minus3" style="display:none;"><a class="on" onclick="clickOpenClose(3);"><img src="${root}cmm/common/images/menu/icon_sidebar_role_g.png"><span class="fontchange">&nbsp;User/Team</span>
		                 <img id="btnFold" class="floatR mgT10 mgR5" src="${root}cmm/common/images/menu/sidebar_tap_close2.png"></a></li>
		                 	<!-- <li class="hlepsub line smenu3" style="display:none;"><a id="menuStt2" onclick="setSubFrame(2);">Visit Log</a></li> -->
		                 	<li class="hlepsub line smenu3" style="display:none;"><a id="menuStt2" onclick="setSubFrame(2);">Daily Visit Log by Item Type</a></li>
		                 	<li class="hlepsub line smenu3" style="display:none;"><a id="menuStt13" onclick="setSubFrame(13);">Item Owner Log</a></li>
		                 	<li class="hlepsub line smenu3" style="display:none;"><a id="menuStt14" onclick="setSubFrame(14);">${reportNameMap.RP00040}</a></li>
		                 	<li class="hlepsub smenu3" style="display:none;"><a id="menuStt15" onclick="setSubFrame(15);">Team Change Log</a></li>
		                 	
		                <!-- 5. Additional -->
						<li class="helpstitle line plus5"><a onclick="clickOpenClose(5);"class="hov"><img src="${root}cmm/common/images/menu/icon_sidebar_contents.png"><span class="fontchange">&nbsp;Additional</span>
						<img id="btnFold" class="floatR mgT10 mgR5" src="${root}cmm/common/images/menu/sidebar_tap_open.png"></a></li>
                 		<li class="helpstitle line minus5" style="display:none;"><a class="on" onclick="clickOpenClose(5);"><img src="${root}cmm/common/images/menu/icon_sidebar_contents_g.png"><span class="fontchange">&nbsp;Additional</span>
                 		<img id="btnFold" class="floatR mgT10 mgR5" src="${root}cmm/common/images/menu/sidebar_tap_close2.png"></a></li> 
		             	<c:forEach var="list" items="${reportList}" varStatus="status">
							<li style="display:none;" 
							<c:choose>
								<c:when test="${status.last}">class="hlepsub line smenu5" </c:when>
								<c:otherwise>class="hlepsub line smenu5"</c:otherwise>
							</c:choose>
							><a id="menuStt${status.count+50}" onclick="setRptFrame('${status.count+50}','${list.ReportURL}?${list.VarFilter}&reportCode=${list.ReportCode}','${list.ReportCode}');">&nbsp;${list.Name}</a>
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

    <div id="foldcontent" class="unfoldcontent frame-container">
	    <div id="help_content"></div>	    
	    <iframe width="100%" height="96%" frameborder="0" scrolling="no" marginwidth="20" style="display:none;border: 0;overflow:auto;" name="rptFrame" id="rptFrame"></iframe>
    </div>
</body>
</html>


