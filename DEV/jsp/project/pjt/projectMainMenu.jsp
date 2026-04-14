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
var menuIndex = "1 2 3 4 5 6 7 8 9";	

	$(document).ready(function(){
		setSubFrame(1); // 프로젝트 개요 화면
	});
	
	// [Menu] Click
	function setSubFrame(avg){
		clickSubMenu(avg); // 클릭한 변경
		var target = "help_content";
		var url = "";
		var data = "s_itemID=${s_itemID}";
		
		/* 프로젝트 개요 */
		if(avg == "1") {
			data =  data + "&pjtMode=R";
			url = "viewProjectInfo.do";
		}
		
		/* Change order */
		if(avg == "2") {
			url = "csrList.do";
			data = data + "&mainMenu=0";
		}
		/* Change set */
		if(avg == "3") {
			url = "changeInfoList.do";
			data = data + "&mainMenu=0&isMine=N";
		}
		/* Issue */
		if(avg == "4") {
			url = "issueSearchList.do";
			data = "ParentID=${s_itemID}&issueMode=PjtMgt";
		}
		/* Schdule */
		if(avg == "5") {
			
		}
		/* Board */
		if(avg == "6") {
			
		}
		/* Member */
		if(avg == "7") {
			url = "selectPjtMember.do";
			data = "projectID=${s_itemID}&listEditable=N&isNew=N&isPjtMgt=Y";
		}
		/* Report */
		if(avg == "8") {
			
		}
		/* Configuration */
		if(avg == "9") {
			
		}
		
		ajaxPage(url, data, target);
	}
	

	
	// [set link color]
	function clickSubMenu(avg) {
		var realMenuIndex = menuIndex.split(' ');
		var menuName = "menuCng";
		for(var i = 0 ; i < realMenuIndex.length; i++){
			if (realMenuIndex[i] == avg) {
				$("#"+menuName+realMenuIndex[i]).addClass("on");
			} else {
				$("#"+menuName+realMenuIndex[i]).removeClass("on");
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
        	<ul class="pjt_menu">
                 <li class="pjttitle"><img src="${root}${HTML_IMG_DIR}/icon_pjt.png">&nbsp;${projectName}</li>
                 
                 <!-- 개요 -->
                 <li class="pjtstitle"><a href="#" id="menuCng1" onclick="setSubFrame(1);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_overview.png">&nbsp;${menu.LN00035}</a></li>
                 
            	 <!-- Change order -->
                 <li class="pjtstitle"><a href="#" id="menuCng2" onclick="setSubFrame(2);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_chorder.png">&nbsp;Change order</a></li>
                 
                 <!-- Change set -->
                 <li class="pjtstitle"><a href="#" id="menuCng3" onclick="setSubFrame(3);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_chset.png">&nbsp;Change set</a></li>
                 
                 <!-- Issue -->
                 <li class="pjtstitle"><a href="#" id="menuCng4" onclick="setSubFrame(4);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_issue.png">&nbsp;Issue</a></li> 

                 <!-- Schdule  -->
	             <li class="pjtstitle"><a href="#" id="menuCng5" onclick="setSubFrame(5);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_sche.png" >&nbsp;Schedule</a></li> 
				
				 <!-- Board  -->
	             <li class="pjtstitle"><a href="#" id="menuCng6" onclick="setSubFrame(6);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_brd.png" >&nbsp;Board</a></li> 
				
				 <!-- Member  -->
	             <li class="pjtstitle"><a href="#" id="menuCng7" onclick="setSubFrame(7);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_mem.png" >&nbsp;Worker</a></li> 
				
				 <!-- Report -->
	             <li class="pjtstitle"><a href="#" id="menuCng8" onclick="setSubFrame(8);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_rpt.png" >&nbsp;Report</a></li> 
				
				<!-- Configuration -->
	            <li class="pjtstitle line"><a href="#" id="menuCng9" onclick="setSubFrame(9);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_cfg.png" >&nbsp;Configuration</a></li>              	 	         
             </ul>
    	</div>
	</div>
	<div id="carcontent">
       <div id="help_content" class="pdT10 pdL10 pdR10" ></div>
	</div>
</body>
</html>


