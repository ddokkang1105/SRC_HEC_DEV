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

<script type="text/javascript" src="${root}cmm/js/dhtmlx/dhtmlxSidebar/codebase/suite.js?v=6.4.3"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/dhtmlxSidebar/codebase/suite.css?v=6.4.3">
<!-- <link href="https://cdnjs.cloudflare.com/ajax/libs/MaterialDesign-Webfont/4.4.95/css/materialdesignicons.css?v=6.4.3" media="all" rel="stylesheet" type="text/css">  -->

<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/mainHome.css" />
<script type="text/javascript">
var curWFMode = "CurAprv";
var mlvl = "${sessionScope.loginInfo.sessionMlvl}";
var data = [
            { 
                 id: "toggle",
 				css: "toggle-button",
 			//	icon: "mdi mdi-backburger",   
 				html: "<div><img src='${root}${HTML_IMG_DIR}/btn_layout_previous.png'/></div>",
             },            
             { 
                 id: "user",
 			//	css: "toggle-button",
 			//	icon: "mdi mdi-backburger",   
 				html: "<div>" 
 				+ "<li style='margin:0 auto;text-align:center;'><img src='${root}${HTML_IMG_DIR}/sidebar_photo.png'/></li>" 
 				+ "<li style='margin:0 auto;text-align:center;'>${sessionScope.loginInfo.sessionUserNm}</li>"
 				+ "<li style='margin:0 auto;text-align:center;'>${sessionScope.loginInfo.sessionTeamName}</li>" 
 				+ "</div>"	            
 	            ,
             },
             { 
                 id: "sr", 
                 value: "문의/서비스",                
                 icon: "mdi mdi-comment-multiple-outline",
                 html: "<div><img src='${root}${HTML_IMG_DIR}/icon_sidebar_sr.png'/><span class='mgL15'>문의/서비스</span></div>",
 	           
         		items: [
                     {
                         id: "srNew",
                         value: "신규", 
         				count: "${srNewCnt}"

                     },
                     {
                         id: "srIng",
                         value: "진행중", 
         				count: "${srIngCnt}"
                     },
                     {
                    	 id: "srDesk",
                    	 value: "Service Desk"               
                    	 
                     },
                     {
                         id: "srAll",
                         value: "ALL"
                     }
                 ]
             },
             {
                 id: "project",
                 value: "프로젝트",
                 icon: "mdi mdi-folder-multiple-image",
                 html: "<div><img src='${root}${HTML_IMG_DIR}/icon_sidebar_project.png'/><span class='mgL15'>프로젝트</span></div>",
         		items: [
                     {
                         id: "ownerPjt",
                         value: "관리 프로젝트", 
         				count: "${ownerPjtCnt}"
                     },
                     {
                         id: "workPjt",
                         value: "참여 프로젝트", 
         				count: "${workerPjtCnt}"
                     }
                 ]
             },
             {
                 id: "csr",
                 value: "변경과제",
                 icon: "mdi mdi-folder-multiple-image",
                 html: "<div><img src='${root}${HTML_IMG_DIR}/icon_sidebar_project.png'/><span class='mgL15'>변경과제</span></div>",
         		items: [
                     {
                         id: "ownerCsr",
                         value: "관리 과제", 
         				count: "${ownerCsrCnt}"
                     },
                     {
                         id: "workCsr",
                         value: "진행 중", 
         				count: "${workerCsrCnt}"
                     }
                 ]
             },
             {
                 id: "item",
                 value: "관리 항목",
                 icon: "mdi mdi-folder-multiple-image",
                 html: "<div><img src='${root}${HTML_IMG_DIR}/icon_sidebar_contents.png'/><span class='mgL15'>관리 항목</span></div>",
         		items: [
                     {
                         id: "itemMod",
                         value: "편집중", 
         				count: "${itemTreeModeCnt}"
                     },
                     {
                         id: "itemAll",
                         value: "전체", 
         				count: "${itemTreeCnt}"
                     }
                 ]
             },
             {
                 id: "schedule",
                 value: "일정",
                 icon: "mdi mdi-folder-multiple-image",
                 html: "<div><img src='${root}${HTML_IMG_DIR}/icon_sidebar_contents.png'/><span class='mgL15'>일정</span></div>",
         		items: [
                     {
                         id: "schdlToday",
                         value: "Today"
                     },
                     {
                         id: "schdlWeek",
                         value: "Week"
                     }
                 ]
             },
             {
                 id: "workflow",
                 value: "결재함",                
                 icon: "mdi mdi-square-edit-outline",
                 html: "<div><img src='${root}${HTML_IMG_DIR}/icon_sidebar_wf.png'/><span class='mgL15'>결재함</span></div>",
         		items: [
                           {
                               id: "curAprv",
                               value: "결재할문서"
                           },
                           {
                               id: "areq",
                               value: "결재 상신"
                           },
                           {
                               id: "todoAprv",
                               value: "결재예정문서"
                           },
                           {
                               id: "refMgt",
                               value: "참조"
                           },
                           {
                               id: "cls",
                               value: "완료",
                           }
                        ]
                     
             },
             //{ type:'separator' },
             {
                 id: "report",
                 value: "리포트",
                 icon: "mdi mdi-settings",
                 html: "<div><img src='${root}${HTML_IMG_DIR}/icon_sidebar_report.png'/><span class='mgL15'>리포트</span></div>",
                 items:[${reportText}]
             },
             {
                 id: "setting",
                 value: "설정",
                 icon: "mdi mdi-settings",
                 html: "<div><img src='${root}${HTML_IMG_DIR}/icon_sidebar_setting.png'/><span class='mgL15'>설정</span></div>",
                 items: [
                         {
                             id: "info",
                             value: "Information"
                         },
                         {
                             id: "office",
                             value: "Out of office"
                         }
                     ]
             }
     ];
	var sidebar = new dhx.Sidebar("sidebar", {
		css: "dhx_widget--border_right"
	});
	
	
	sidebar.data.parse(data);		
	

	var events = [
					"click",
					"openMenu",
					"beforeHide",
					"afterHide",
					"beforeCollapse",
					"afterCollapse",
					"beforeExpand",
					"afterExpand"
				];

	var eventsContainer = document.querySelector(".dhx_sample-container__sidebar")
	var counter = 1;
	
	sidebar.data.update("toggle", {icon: "mdi mdi-menu"});
	
	sidebar.events.on("click", function(id){
		setPage(id);
	});
	
	function setPage(id){
		var data = "";
		var url = "";
		var target = "mainLayer";
		if(id != "toggle"){
			$("#mainLayer").css("background","#fff");
		}
		
		if(id === "toggle"){
			var toggleItem = sidebar.data.getItem("toggle");
			var userInfo = document.querySelector(".user-info_item");

			sidebar.toggle();

			if(sidebar.config.collapsed){
				//toggleItem.icon = "mdi mdi-menu";
				sidebar.data.update("toggle", {html: "<div><img src='${root}${HTML_IMG_DIR}/icon_unfold.png'/></div>"});
				sidebar.data.update("user", {html: "<div><img style='width:96%;height:100%' src='${root}${HTML_IMG_DIR}/sidebar_photo.png'/></div>"});
// 				$("#foldcontent").removeClass('unfoldcontent');
// 				$("#foldcontent").addClass('foldcontent');	
				$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width -44);
			}
			else {
				//toggleItem.icon = "mdi mdi-backburger";
				sidebar.data.update("toggle", {html: "<div><img src='${root}${HTML_IMG_DIR}btn_layout_previous.png'/></div>"});
				sidebar.data.update("user", {html: "<div>" 
													+ "<li style='margin:0 auto;text-align:center;'><img src='${root}${HTML_IMG_DIR}/sidebar_photo.png'/></li>" 
													+ "<li style='margin:0 auto;text-align:center;'>${sessionScope.loginInfo.sessionUserNm}</li>"
													+ "<li style='margin:0 auto;text-align:center;'>${sessionScope.loginInfo.sessionTeamName}</li>" 
													+ "</div>"	 });
				
// 				$("#foldcontent").removeClass('foldcontent');
// 				$("#foldcontent").addClass('unfoldcontent');
				$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width -200);
			}
			return;
		}else if(id == "user") {
       		parent.goMenu('mySpace.do?srType=ITSP&noticeType=4', '', true, layout_2E);
			return;
		}else if(id == "srNew"){
			url = "itspList.do";
			data =  "srMode=mySR&srStatus=SPE001&pageNum=1&srType=ITSP&scrnType=srRcv";
		}else if(id == "srIng"){
			url =  "itspList.do";
			data = "srMode=mySR&srStatus=ING&pageNum=1&srType=ITSP&scrnType=srRcv";		
		}else if(id == "srAll"){
			url =  "itspList.do";
			data =  "srMode=mySR&pageNum=1&srType=ITSP&scrnType=srRcv";
		}else if(id == "srDesk"){
			url = "srAreaInfo.do";
			data = "srType=ITSP";
		}else if(id == "ownerPjt"){		
			url = "myProjectList.do";
			data = "isNew=N&pjtMode=R&screenType=myPJT&;mainVersion=mainV5";
		}else if(id == "workerPjt"){
			url = "myProjectList.do";
			data = "isNew=N&pjtMode=R&screenType=myPJT&;mainVersion=mainV5";
		}else if(id == "ownerCsr"){
			url = "csrList.do";
			data = "&mainMenu=1&memberId=${sessionScope.loginInfo.sessionUserId}"; 
		}else if(id == "workCsr"){
			url = "csrList.do";
			data = "&mainMenu=1&memberId=${sessionScope.loginInfo.sessionUserId}&csrStatus=ING"; 
		}else if(id == "itemMod"){
			url = "ownerItemList.do";
			data = "ownerType=itemManager&status=ING&option=MYSPACE";
		}else if(id == "itemAll"){
			url = "ownerItemList.do";
			data = "ownerType=itemManager&option=MYSPACE";
		}else if(id == "schdlToday"){
			url = "goSchdlList.do"; 
			data =  data + "&schdlType=today&screenType=MyPg&wfStepID=AREQ";
		}else if(id == "schdlWeek"){
			url = "goSchdlList.do"; 
			data =  data + "&schdlType=week&screenType=MyPg&wfStepID=AREQ";
		}else if(id == "curAprv"){
			url = "wfInstanceList.do"; 
			data =  data + "&wfMode=CurAprv&screenType=MyPg";
		}else if(id == "areq"){
			url = "wfInstanceList.do"; 
			data =  data + "&wfMode=AREQ&screenType=MyPg&wfStepID=AREQ";
		}else if(id == "todoAprv"){
			url = "wfInstanceList.do"; 
			data =  data + "&wfMode=ToDoAprv&screenType=MyPg";
		}else if(id == "refMgt"){
			url = "wfInstanceList.do"; 
			data =  data + "&wfMode=RefMgt&screenType=MyPg";
		}else if(id == "cls"){
			url = "wfInstanceList.do"; 
			data =  data + "&wfMode=Cls&screenType=MyPg";
		}else if(id == "info") { // Info
			url = "viewMyInfo.do"; 
			data =  data + "";
		}else if(id == "office") { // Member Agent
			url = "mbrAgentCfg.do"; 
			data =  data + "";
		}else {		
			var tempItem = sidebar.data.getItem(id);
			url = tempItem.varFilter;
			data = "";
		}
		
		ajaxPage(url, data, target);
	}
	
	$(document).ready(function(){
		fnSidebarInit();	
		
		$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width -200);
		$("#mainLayer").innerHeight(document.body.clientHeight);
		
		setSchdlFrame();
		fnClickedTab(1);
		//setCSFrame();
        setESRFrame();
        setModItemList();
        setPjtList();

        $("#boardDiv #subWFFrame").innerHeight($("#boardDiv").height()-$("#boardDiv .tabs").height());
        $("#csListDiv #esrFrame").innerHeight($("#csListDiv").height()-$("#csListDiv .secTit").height());
        $("#schdlDiv #schdlFrame").innerHeight($("#schdlDiv").height()-$("#schdlDiv .secTit").height());
        $("#modListDiv #modList").innerHeight($("#modListDiv").height()-$("#modListDiv .secTit").height());
        $("#pjtListDiv #pjtList").innerHeight($("#pjtListDiv").height()-$("#pjtListDiv .secTit").height());
        $("#esrListDiv #pjtFrame").innerHeight($("#esrListDiv").height()-$("#esrListDiv .secTit").height());
        $("#esrListDiv #itemFrame").innerHeight($("#esrListDiv").height()-$("#esrListDiv .secTit").height());
        $("#cntDiv .cntFrame").innerHeight($("#cntDiv").height()-$("#cntDiv .secTit").height());
	});
	
	function fnSidebarInit(){
		
	}
		
	function setModItemList(){ 
        var url = "olmMySpaceModList.do";
        var target = "itemFrame";
        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
        ajaxPage(url, data, target);
    }
	function setPjtList(){ 
        var url = "olmMySpacePjtList.do";
        var target = "pjtFrame";
        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
        ajaxPage(url, data, target);
    }
	
	function setCSFrame(){ 
        var url = "olmMainChangeSetList.do";
        var target = "csFrame";
        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
        ajaxPage(url, data, target);
    }
    
    function setSchdlFrame(){
        var url = "olmMainSchdlList.do";   
        var target = "schdlFrame";
        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&listSize=10&mySchdl=Y";
        ajaxPage(url, data, target);
    }
    
    function setESRFrame(){ 
        var url = "olmMainEsrList.do";
        var target = "esrFrame";
        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&listSize=20&srMode=mySR";
        ajaxPage(url, data, target);
    } 
    	    
    function fnGoSRDetail(SRID,requestUserID,receiptUserID,status,srType){    	
    	var sessionUserID = "${sessionScope.loginInfo.sessionUserId}";
    	var url = ""; 
    	var mainType = "SRDtl";
    	var screenType = "srRqst";
    	var url = "ispMgt.do";
    	
    	if(srType == "ITSP"){
    		if(sessionUserID == receiptUserID && status != 'CLS' && status != 'CMP' ){
        		url = "myPage.do"; //MyPage / 서비스요청  
        		screenType = "srRcv" ;
        		mainType ="mySRDtl" ;
        	}else{
        		url = "itspMgt.do"; // 1.서비스요청/나의 서비스 요청/ 2.Service Desk
        	}
    	} else if(srType == "ISP"){
    		url = "ispMgt.do";
    	}
    	
    	if(sessionUserID == requestUserID){
    	  mainType ="mySRDtl" ;
    	}
    	
        var data = "screenType=" + screenType + "&srID="+SRID+"&srType="+srType+"&mainType="+mainType;
        var target = "mainMenu";
        
        $('#mainMenu').css('background-image', 'url(${root}${HTML_IMG_DIR}/blank.png)');
       
        ajaxPage(url, data, target);
    }
    
    function fnClickedTab(avg) {
        $("#wfType").val(avg);
        var url = "mainWFInstList.do";
        var target = "subWFFrame";
        var wfMode = "";
        
        if(avg == 1){ // 결재 할 문서
        	wfMode="CurAprv";
        } else if(avg == 2){ // 결재 상신
        	wfMode = "AREQ";
        }
        curWFMode = wfMode;
        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&wfMode="+wfMode+"&screenType=MyPg&listSize=5";
        ajaxPage(url, data, target);
        
        var realMenuIndex = "1 2".split(' ');
		for ( var i = 0; i < realMenuIndex.length; i++) {
			if (realMenuIndex[i] == avg) {
				$("#pliugt" + realMenuIndex[i]).addClass("on");
			} else {
				$("#pliugt" + realMenuIndex[i]).removeClass("on");
			}
		}
		
		 $("#wfOnTab").val(wfMode);
    }
    
    function fnGoWFDetail(projectID,wfID,stepInstID,actorID,stepSeq,wfInstanceID,lastSeq,documentID,docCategory){		
		//var screenMode = "V";
		var mainMenu = "${mainMenu}";
		var url = "wfDocMgt.do?";
		var data = "projectID="+projectID+"&pageNum=1&isPop=Y&isMulti=N&actionType=view"
					+"&stepInstID="+stepInstID
					+"&actorID="+actorID
					+"&stepSeq="+stepSeq
					+"&wfInstanceID="+wfInstanceID
					+"&wfID="+wfID
					+"&documentID="+documentID
					+"&srID="+documentID
					+"&lastSeq="+lastSeq
					+"&docCategory="+docCategory
					+"&wfMode="+curWFMode;
				
		var w = 1200;
		var h = 650; 
		itmInfoPopup(url+data,w,h);
	}
    
    function fnGoMore(id, onTab){
    	var focusMenu ="";

       	if(onTab == "SCHDL"){
       		parent.goMenu('goSchdlListMgt.do?refPGID='+id, '', true, layout_2E);
       	} else if(onTab == "ESR"){
       		parent.goMenu('ispMgt.do?srType=ISP&focusMenu=4', '', true, layout_2E);
       	} else if(onTab == "WF"){
       		if($("#wfOnTab").val() == "CurAprv"){
       			setPage('curAprv');
    		}else if($("#wfOnTab").val() == "AREQ"){
    			setPage('areq');
    		}
       	} else if(onTab == "CngSet") {
	    	parent.clickMainMenu('CHANGESET', 'CHANGESET','','','','','.do?', '');
       	} else if(onTab == "csrList") {
			parent.goMenu("csrList.do?mainMenu=1&memberId=${sessionScope.loginInfo.sessionUserId}");
		}
       	
    }
</script>
</head>
<style>
	.dhx_sidebar{
		float:left;
	}
	
	#mainLayer{
		float:right;
	}
	#mainWrapper{
		width: 94%;
	    height: 96%;
	    top: 2%;
	}
</style>
<body id="mainMenu">
	<section class="dhx_sample-container">
		<div class="dhx_sample-container__widget" id="sidebar"></div>
	</section>
	
	<div class="noform" id="mainLayer" style="min-width:1164px;padding:5px 20px;">
		<form name="mainLayerFrm" id="mainLayerFrm" method="post" action="#" onsubmit="return false;">
			<input id="wfType" type="hidden" value=""/>
			<input type="hidden" id="wfOnTab" name="wfOnTab" value=""/>
			<div id="mainWrapper">
				<div id="leftDiv">
					<div id="cntDiv">
						<div class="secTit" style=" height:26%;"><ul><li class="titNM">My Item</li></ul></div>
						<div class="cntFrame">
							<div class="sec" style="background:#4265EE">
								<ul class="tit">
									<li>Contents</li>
									<li class="img"><img src="${root}${HTML_IMG_DIR}/tit_myItem.png"></li>
								</ul>
								<ul class="con">
									<li class="bd" onClick="setPage('itemAll')"><p>${itemCnt}</p>${menu.LN00190}</li>
									<li class="" onClick="setPage('itemMod')"><p>${itemModeCnt}</p>${menu.LN00194}</li>
								</ul>
							</div>
							<div class="sec" style="background:#4087FB">
								<ul class="tit">
									<li>문의</li>
									<li class="img"><img src="${root}${HTML_IMG_DIR}/tit_sr.png"></li>
								</ul>
								<ul class="con">
									<li class="bd" onClick="setPage('srNew')"><p>${srNewCnt}</p>신규문의</li>
									<li class="" onClick="setPage('srIng')"><p>${srIngCnt}</p>처리 중</li>
								</ul>
							</div>
							<div class="sec" style="background:#1BB4F8">
								<ul class="tit">
									<li>결재</li>
									<li class="img"><img src="${root}${HTML_IMG_DIR}/tit_wf.png"></li>
								</ul>
								<ul class="con">
									<li class="bd" onClick="setPage('areq')"><p>${wfAREQCnt}</p>결재상신</li>
									<li class="" onClick="setPage('curAprv')"><p>${wfCurAprvCnt}</p>대기</li>
								</ul>
							</div>
						</div>
					</div>
					
					<div id="csListDiv" style="height:44%;">
						<div class="secTit">
							<ul>
								<li class="titNM">${menu.LN00333}</li>
							</ul>
							<ul class="morebtn" onclick="setPage('srIng')">
								<li>more</li>
							</ul>
						</div>
						<div id="esrFrame" class="postInfo"></div>	
					</div>
										
					<div id="esrListDiv">
						<div class="secTit">
							<ul>
								<li class="titNM">프로젝트 / 과제</li>
							</ul>
							<ul class="morebtn" onClick="setPage('ownerCsr')">
								<li>more</li>
							</ul>
						</div>
						<div id="pjtFrame" class="postInfo"></div>	
					</div>
				</div>
				
				<div id="rightDiv">
	
					
					<div id="schdlDiv">
						<div class="secTit">
							<ul>
								<li class="titNM">${menu.LN00110}</li>
							</ul>
							<ul class="morebtn" onClick="setPage('schdlWeek')">
								<li>more</li>
							</ul>
						</div>
						<div id="schdlFrame"></div>	
					</div>
					
					
					<div id="boardDiv" style="height:32%;">
			 			<div class="tabs">
							<ul>
								<li id="pliugt1" class="on titNM" onclick="javascript:fnClickedTab('1');">${menu.LN00243}</li>
								<li id="pliugt2" class="titNM" onclick="javascript:fnClickedTab('2');">${menu.LN00211}</li>
							</ul>
							<ul class="morebtn" onClick="javascript:fnGoMore('', 'WF');">
								<li>more</li>
							</ul>
						</div>
						<div id="subWFFrame" class="tabFrame postInfo"></div>	
					</div>
					
					<div id="esrListDiv">
						<div class="secTit">
							<ul>
								<li class="titNM">수정 중</li>
							</ul>
							<ul class="morebtn" onClick="setPage('itemMod')">
								<li>more</li>
							</ul>
						</div>
						<div id="itemFrame" class="postInfo"></div>	
					</div>
				</div>
		
			</div>
		</form>
		</div>
	
</body>
</html>