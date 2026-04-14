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
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
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
   
	var pmenuIndex = "${pmenuIndex}"; // 각 menu index (submenu 포함)
	var maxIndex = "${maxIndex}";
	var bmenuIndex = "1 2 3 4"; // submenu가 존재하는 menu 화면 표시 처리를 위한 index
	var screenType = "${screenType}";
	var mainType = "${mainType}";
	var approvalPath = "${approvalPath}";
	var useCR = "${useCR}";
	var useTask = "${useTask}";
	var CSRStatus;
	var multiCompany = "${multiCompany}";

	$(document).ready(function(){
		clickOpenClose(1);
		if(mainType =="mySRDtl") {setSubFrame(10, "srView"); //SR Processing detail
		}else if(mainType == "myCSR"){ CSRStatus = "${status}"; setSubFrame(5);
		} else if(mainType == "myWF") { clickOpenClose(3); setSubFrame(14);}
		 else if(mainType == "myWF15") { clickOpenClose(3); setSubFrame(15);}
		 else if(mainType == "myWF16") { clickOpenClose(3); setSubFrame(16);}
		else { setSubFrame(10); }
		
		
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
	function setSubFrame(avg, option){ 
		clickSubMenu(avg); // 클릭한 변경
		
		var target = "help_content";
		var url = "";
		var data = "";
		
		/* 프로젝트 Main */
		if(avg == "0") {
			url = "myPageMain.do";
		}

		/* Communication */
		if(avg == "1") {
			  var 	url =  "boardList.do";
			  var 	data = data + "&BoardMgtID=4&boardTypeCD=MN007&url=boardList&myBoard=Y";
			//clickOpenClose(4);
		}
		
		/* Contents --> Author Item */
		if(avg == "2") {
			url = "ownerItemList.do";
			data = "ownerType=editor";
		}
		
		/* Contents --> Model */
		if(avg == "3") {
			url = "myPageMainModelList.do";
			data = data + "&mainMenu=1";
		}
		/* Contents --> Document */
		if(avg == "4") {
			url = "olmDocList.do";
			data = "screenType=mainV4&pageNum=1&myDoc=Y&isPublic=N";
		}
			
		/* Change Management  --> Order */
		if(avg == "5") {
			url = "csrList.do";
			data = "&mainMenu=1&memberId=${sessionScope.loginInfo.sessionUserId}&Status="+CSRStatus; 
		}
		
		/*  Change Management  --> Change set */
		if(avg == "6") {		
			url = "myChangeSet.do";
			data = data + "&isMainMenu=4&parentID=${projectId}";
		}
		
		/*  Change Management  --> Task  */ 
		if(avg == "7") {
			url = "editTaskResultList.do";
			data = "mainVersion=mainV4";
		}
		
		/*  Change Management  --> Issue */ 
		if(avg == "8") {
			url = "issueSearchList.do";
			data = "&issueMode=ARC&languageID=${sessionScope.loginInfo.sessionCurrLangType}"; 
		}
		
		/* My SR */
		if(avg == "10") {
			if(multiCompany == "Y"){ url = "itspListByComp.do"; }else{	url =  "itspList.do";	}
			
			if(option == "srView"){
				var srID = "${srID}"; 				
				data = data + "&srMode=mySR&srType=ITSP&scrnType=${scrnType}&sysCode=${sysCode}&proposal=${proposal}&itemProposal=${itemProposal}";
			}else {
				data = data + "&srType=ITSP&srMode=mySR&srStatus=ING&screenType=srRcv&pageNum=1"; 		
		    }
		//	alert(data);
		} 
		
		/* Change Management --> CrMstList */
		if(avg == "11") {
			url = "crList.do"; 
			data =  data + "&crMode=myCr&srType=ITSP&screenType=MyPg";
		}
	
		/* Change Management --> my Projet List */
		 if(avg == "12") {
			url = "myProjectList.do";
			data = "isNew=N&pjtMode=R&screenType=myPJT&;mainVersion=mainV5";
		 }
		
		if(avg == "13") { // 상신 : AREQ
			url = "wfInstanceList.do"; 
			data =  data + "&wfMode=AREQ&screenType=MyPg&wfStepID=AREQ";
		}
		
		if(avg == "14") { // 결재할 문서 CurAprv
			url = "wfInstanceList.do"; 
			data =  data + "&wfMode=CurAprv&screenType=MyPg";
		}
		
		if(avg == "15") { // 결재 예정 ToDoAprv
			url = "wfInstanceList.do"; 
			data =  data + "&wfMode=ToDoAprv&screenType=MyPg";
		}
		
		if(avg == "16") { // 참조 Ref + 관리조직 참조
			url = "wfInstanceList.do"; 
			data =  data + "&wfMode=RefMgt&screenType=MyPg";
		 }
		
		if(avg == "17") { // 승인완료 Cls
			url = "wfInstanceList.do"; 
			data =  data + "&wfMode=Cls&screenType=MyPg";
		}
		
		if(avg == "18") { // Info
			url = "viewMyInfo.do"; 
			data =  data + "";
		}
		
		if(avg == "19") { // Member Agent
			url = "mbrAgentCfg.do"; 
			data =  data + "";
		}
		
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
// 		if (avg == 1 || avg == 2 || avg == 3) { 
// 			clickSubMenu(avg);
// 		}
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
<style type="text/css">
* html body{ /*IE6 hack*/
padding: 0 0 0 200px; /*Set value to (0 0 0 WidthOfFrameDiv)*/
}
* html #foldcontent{ /*IE6 hack*/
width: 100%; 
}
</style>
<input id="chkSearch" type="hidden" value="false"></input>
<body id="mainMenu">
		<div>
	    	<ul class="help_menu">
	    		 <li class="helptitle2" id="title1">
		    		 <span style="font-size:14px;"> <img src="${root}${HTML_IMG_DIR}/icon_pjt.png">&nbsp;My Page</font>		 
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
        		<c:if test="${sessionScope.loginInfo.sessionLogintype ne 'viewer'}">
        		  <!-- 1.Change Management -->        		
                  <li class="helpstitle plus1"><a onclick="clickOpenClose(1);"><img src="${root}${HTML_IMG_DIR}/icon_brd_04.png"><span class="fontchange">&nbsp;To Do list</span></a></li>
                  <li class="helpstitle line minus1" style="display:none;"><a class="on" onclick="clickOpenClose(1);"><img src="${root}${HTML_IMG_DIR}/icon_brd_04.png"><span class="fontchange">&nbsp;To Do list</span></a></li>
             	 	<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng10" onclick="setSubFrame(10);">&nbsp;${menu.LN00286}(SR)</a></li>
             	 	<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng12" onclick="setSubFrame(12);">&nbsp;${menu.LN00131}</a></li>
             		<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng5" onclick="setSubFrame(5);">&nbsp;${menu.LN00191}</a></li>
             	 	<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng6" onclick="setSubFrame(6);">&nbsp;${menu.LN00082}</a></li>
             	 	<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng1" onclick="setSubFrame(1);">&nbsp;${menu.LN00215}</a></li>
             	 <c:if test="${useCR == 'Y'}" >
             		<li class="hlepsub line smenu1 " style="display:none;"><a id="menuCng11" onclick="setSubFrame(11);">&nbsp;IT&nbsp;${menu.LN00092}(CR)</a></li>
             	 </c:if>
             	 <c:if test="${useTask == 'Y'}" >
             	 	<li class="hlepsub smenu1 " style="display:none;"><a id="menuCng7" onclick="setSubFrame(7);">&nbsp;Project task</a></li>
				</c:if>
				
				   <!-- 2.Contents -->				              
               		<li class="helpstitle plus2"><a onclick="clickOpenClose(2);"><img src="${root}${HTML_IMG_DIR}/icon_brd_01.png"><span class="fontchange">&nbsp;Contents</span></a></li>
                    <li class="helpstitle line minus2" style="display:none;"><a class="on" onclick="clickOpenClose(2);"><img src="${root}${HTML_IMG_DIR}/icon_brd_01.png"><span class="fontchange">&nbsp;Contents</span></a></li> 
             	 	<li class="hlepsub line smenu2" style="display:none;"><a id="menuCng2" onclick="setSubFrame(2);">&nbsp;${menu.LN00190}</a></li>
             	 	<li class="hlepsub line smenu2" style="display:none;"><a id="menuCng3" onclick="setSubFrame(3);">&nbsp;${menu.LN00125}</a></li>
             	 	<li class="hlepsub line smenu2" style="display:none;"><a id="menuCng4" onclick="setSubFrame(4);">&nbsp;${menu.LN00134}</a></li>
             	</c:if>
             	
             	<c:if test="${sessionScope.loginInfo.sessionLogintype == 'viewer'}">
             	 <!-- 1.Change Management -->        		
                  <li class="helpstitle plus1"><a onclick="clickOpenClose(1);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_chorder.png"><span class="fontchange">&nbsp;To Do list</span></a></li>
                  <li class="helpstitle line minus1" style="display:none;"><a class="on" onclick="clickOpenClose(1);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_chorder.png"><span class="fontchange">&nbsp;My Item</span></a></li>
             	 	<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng10" onclick="setSubFrame(10);">&nbsp;${menu.LN00286}(SR)</a></li>             	 	
             	 	<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng1" onclick="setSubFrame(1);">&nbsp;${menu.LN00215}</a></li> 
             	 	<li class="hlepsub line smenu1" style="display:none;"><a id="menuCng6" onclick="setSubFrame(6);">&nbsp;Subscription</a></li>           	
             	</c:if>
             	
             	<c:if test="${approvalPath == 'OLM'}" >
	             	<!-- 3. Approval List  -->
	             	 <li class="helpstitle line plus3"><a onclick="clickOpenClose(3);"><img src="${root}${HTML_IMG_DIR}/icon_stor_01.png"><span class="fontchange">&nbsp;${menu.LN00242}</span></a></li>
	                 <li class="helpstitle line minus3" style="display:none;"><a class="on" onclick="clickOpenClose(3);"><img src="${root}${HTML_IMG_DIR}/icon_stor_01.png"><span class="fontchange">&nbsp;${menu.LN00242}</span></a></li>
	             	 <li class="hlepsub line smenu3" style="display:none;"><a id="menuCng14" onclick="setSubFrame(14);">&nbsp;${menu.LN00243}</a></li>
	             	 <li class="hlepsub line smenu3" style="display:none;"><a id="menuCng13" onclick="setSubFrame(13);">&nbsp;${menu.LN00211}</a></li>
	             	 <li class="hlepsub line smenu3" style="display:none;"><a id="menuCng15" onclick="setSubFrame(15);">&nbsp;${menu.LN00244}</a></li>
	             	 <li class="hlepsub line smenu3" style="display:none;"><a id="menuCng16" onclick="setSubFrame(16);">&nbsp;${menu.LN00245}</a></li>
	             	 <li class="hlepsub line smenu3" style="display:none;"><a id="menuCng17" onclick="setSubFrame(17);">&nbsp;${menu.LN00118}</a></li>
             	</c:if>
             	
             	 <c:if test="${sessionScope.loginInfo.sessionLogintype ne 'viewer'}">
	             	 <li class="helpstitle plus4"><a onclick="clickOpenClose(4);"><img src="${root}${HTML_IMG_DIR}/icon_brd_02.png"><span class="fontchange">&nbsp;${menu.LN00287}</span></a></li>
	                 <li class="helpstitle line minus4" style="display:none;"><a class="on" onclick="clickOpenClose(4);"><img src="${root}${HTML_IMG_DIR}/icon_brd_02.png"><span class="fontchange">&nbsp;${menu.LN00287}</span></a></li>
	             		<c:forEach var="list" items="${reportList}" varStatus="status">
							<li class="hlepsub line smenu4"><a id="menuCng${startReportIndex + status.count}" onclick="setRptFrame('${startReportIndex + status.count}','${list.ReportURL}?${list.VarFilter}&reportCode=${list.ReportCode}');">&nbsp;${list.ReportName}</a>
							</li>
						</c:forEach>   
				</c:if>          	 
             	 <li class="helpstitle plus5"><a onclick="clickOpenClose(5);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_setting.png"><span class="fontchange">&nbsp;Setting</span></a></li>
                 <li class="helpstitle line minus5" style="display:none;"><a class="on" onclick="clickOpenClose(5);"><img src="${root}${HTML_IMG_DIR}/icon_pjt_setting.png"><span class="fontchange">&nbsp;Setting</span></a></li>
             	 	<li class="hlepsub line smenu5" style="display:none;"><a id="menuCng18" onclick="setSubFrame(18);">&nbsp;Information</a></li>
             	 	<li class="hlepsub line smenu5" style="display:none;"><a id="menuCng19" onclick="setSubFrame(19);">&nbsp;Out of office </a></li>
             </ul>
    	</div>
	</div>
	<div id="foldcontent" class="unfoldcontent">
       <div id="help_content" class="pdT10 pdL10 pdR10" ></div>
	</div>
</body>
</html>


