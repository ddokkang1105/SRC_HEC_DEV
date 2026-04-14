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
var pmenuIndex = "${pmenuIndex}"; // 각 menu index (submenu 포함)
var maxIndex = "${maxIndex}";
var bmenuIndex = "1 2 3 4 5 6"; // submenu가 존재하는 menu 화면 표시 처리를 위한 index

	$(document).ready(function(){
		setSubFrame(0); // 프로젝트 Main화면
	});
	
	// [Menu] Click
	function setSubFrame(avg){
		clickSubMenu(avg); // 클릭한 변경
		
		var target = "help_content";
		var url = "";
		var data = "s_itemID=${projectId}";
		
		/* 프로젝트 Main */
		if(avg == "0") {
			url = "mainSttProject.do";
		}
		
		/* Change Management --> Change order */
		if(avg == "2") {
			url = "csrList.do";
			data = data + "&mainMenu=1";
		}
		/* Change Management --> Change set */
		if(avg == "3") {
			url = "changeInfoList.do";
			data = data + "&mainMenu=0&isMine=N";
		}
		/* Change Management --> Task */
		if(avg == "4") {
			url = "taskSearchList.do";
			data = data + "&isMainMenu=mainV3&parentID=${projectId}";
		}
		/* Change Management --> Issue */
		if(avg == "5") {
			url = "issueSearchList.do";
			data = "ParentID=${projectId}&issueMode=PjtMgt";
		}
		
		/* Documents */
		if(avg == "6") {
			clickOpenClose(4); // submenu가 존재하는 menu닫는 처리			
			url = "documentGridList.do";
			data = "screenType=mainV3&pageNum=1&parentID=${projectId}";
		}
		
		/* Schdule */
		if(avg == "7") {
			clickOpenClose(4); // submenu가 존재하는 menu닫는 처리
			url = "goSchdlList.do";	
			data = "screenType=mainV3&pageNum=1&parentID=${projectId}";
		}
		
		/* Member */
		if(avg == "8") {
			clickOpenClose(4); // submenu가 존재하는 menu닫는 처리
			url = "selectPjtMember.do";
			data = "projectId=${projectId}&listEditable=N&screenMode=E&isPjtMgt=Y";
		}
		
		/* Project Info */
		if(avg == "9") {
			clickOpenClose(4); // submenu가 존재하는 menu닫는 처리
			url = "projectGroupInfoview.do";
			data = "screenMode=V&s_itemID=${projectId}&isPjtMgt=Y";
		}
		
		ajaxPage(url, data, target);
	}
	
	/* TODO ::::: Board (공지사항 (공통) 포함 ) */
	function setBrdFrame(noticType, avg, url, boardTypeCD) {
		clickSubMenu(avg); // 클릭한 변경
		var target = "help_content";		
		var data = "s_itemID=${projectId}&noticType="+noticType+"&boardTypeCD="+boardTypeCD+"&url="+url+"&screenType=mainV3";
		var url = "boardList.do";
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
		if ( avg == 4 || $(".smenu" + avg).css("display") == "none") {
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
		if (avg == 1 || avg == 2 || avg == 3) { 
			clickSubMenu(maxIndex);
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
</style>
<input id="chkSearch" type="hidden" value="false"></input>
<body id="mainMenu">
	<div id="carframe">
		<div>
        	<ul class="help_menu">
                 <li class="helptitle2"><img src="${root}${HTML_IMG_DIR}/icon_pjt.png">&nbsp;${projectName}</li>
                 
                 <!-- 1.Board -->
                 <li class="helpstitle plus1"><a href="#" onclick="clickOpenClose(1);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_brd.png"><span class="fontchange">&nbsp;Board</span></a></li>
                 <li class="helpstitle line minus1" style="display:none;"><a href="#" class="on" onclick="clickOpenClose(1);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_brd.png"><span class="fontchange">&nbsp;Board</span></a></li>
                 	<li class="hlepsub line smenu1" style="display:none;"><a href="#" id="menuCng1" onclick="setBrdFrame(1,1,'boardList','MN123');">&nbsp;${menu.LN00001}</a></li>
                 	<c:forEach var="list" items="${boardList}" varStatus="status">
						<li style="display:none;" 
						<c:choose>
							<c:when test="${status.last}">class="hlepsub smenu1" </c:when>
							<c:otherwise>class="hlepsub line smenu1"</c:otherwise>
						</c:choose>
						><a href="#" id="menuCng${startBoardIndex + status.count}" onclick="setBrdFrame('${list.BoardMgtID}','${startBoardIndex + status.count}','${list.URL}','${list.BoardTypeCD}');">&nbsp;${list.BoardMgtName}</a>
						</li>
					</c:forEach>
                 
                <!-- 2.Change Management -->
                 <li class="helpstitle plus2"><a href="#" onclick="clickOpenClose(2);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_chorder.png"><span class="fontchange">&nbsp;Change Management</span></a></li>
                 <li class="helpstitle line minus2" style="display:none;"><a href="#" class="on" onclick="clickOpenClose(2);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_chorder.png"><span class="fontchange">&nbsp;Change Management</span></a></li> 
             	 	<li class="hlepsub line smenu2" style="display:none;"><a href="#" id="menuCng2" onclick="setSubFrame(2);">&nbsp;Change order</a></li>
             	 	<li class="hlepsub line smenu2" style="display:none;"><a href="#" id="menuCng3" onclick="setSubFrame(3);">&nbsp;Change Set</a></li>
             	 	<li class="hlepsub line smenu2" style="display:none;"><a href="#" id="menuCng4" onclick="setSubFrame(4);">&nbsp;Task</a></li>
             	 	<li class="hlepsub smenu2" style="display:none;"><a href="#" id="menuCng5" onclick="setSubFrame(5);">&nbsp;Issue</a></li>
            	 
                 <!-- 3.Documents -->
                 <li class="helpstitle"><a href="#" id="menuCng6" onclick="setSubFrame(6);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_chset.png"><span class="fontchange">&nbsp;Documents</span></a></li>
                 
                 <!-- 4.Schdule -->
                 <li class="helpstitle"><a href="#" id="menuCng7" onclick="setSubFrame(7);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_sche.png"><span class="fontchange">&nbsp;Schedule</span></a></li> 

				 <!-- 5.Report -->
				 <li class="helpstitle plus3"><a href="#" onclick="clickOpenClose(3);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_rpt.png"><span class="fontchange">&nbsp;Report</span></a></li>
                 <li class="helpstitle line minus3" style="display:none;"><a href="#" class="on" onclick="clickOpenClose(3);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_rpt.png"><span class="fontchange">&nbsp;Report</span></a></li> 
	             	<c:forEach var="list" items="${reportList}" varStatus="status">
						<li style="display:none;" 
						<c:choose>
							<c:when test="${status.last}">class="hlepsub smenu3" </c:when>
							<c:otherwise>class="hlepsub line smenu3"</c:otherwise>
						</c:choose>
						><a href="#" id="menuCng${startReportIndex + status.count}" onclick="setRptFrame('${startReportIndex + status.count}','${list.ReportURL}');">&nbsp;${list.Name}</a>
						</li>
					</c:forEach>
				 
				 <!-- 6.Member  -->
	             <li class="helpstitle"><a href="#" id="menuCng8" onclick="setSubFrame(8);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_mem.png"><span class="fontchange">&nbsp;Member</span></a></li> 
				
				 <!-- 7.Project Info  -->
	             <li class="helpstitle line"><a href="#" id="menuCng9" onclick="setSubFrame(9);"><img src="${root}${HTML_IMG_DIR}/icon_csr.png"><span class="fontchange">&nbsp;Project Info</span></a></li> 
				
             </ul>
    	</div>
	</div>
	<div id="carcontent">
       <div id="help_content" class="pdT10 pdL10 pdR10" ></div>
	</div>
</body>
</html>


