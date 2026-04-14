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
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<!-- <link href="https://cdnjs.cloudflare.com/ajax/libs/MaterialDesign-Webfont/4.4.95/css/materialdesignicons.css?v=6.4.3" media="all" rel="stylesheet" type="text/css">  -->

<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/mainHome.css" />
<script type="text/javascript">
var curWFMode = "CurAprv";
var mlvl = "${sessionScope.loginInfo.sessionMlvl}";
var viewData = [
                { 
                     id: "toggle",
     				css: "toggle-button",
     				html: "<div class='title'><img src='${root}cmm/common/images/menu/icon_fold.png'/><span class='title'>My Page</span></div>",
                 },            
                 { 
                     id: "user",
     				html: "<div>" 
   					+ "<li style='text-align:center;'><img src='<%=GlobalVal.EMP_PHOTO_URL%>${memPhoto}' style='width:50px;height:50px;'/></li>"  
     				+ "<li style='text-align:center;'>${sessionScope.loginInfo.sessionUserNm}</li>"
     				+ "<li style='text-align:center;'>${sessionScope.loginInfo.sessionTeamName}</li>" 
     				+ "</div>"	            
     	            ,
                 },
                 {
                	 id:     "sepId",        
               	    type:   "separator"
            	 },
                 { 
                     id: "sr", 
                     value: "문의/서비스",                
                     html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sr.png'/><span class='mgL15'>${menu.LN00333}</span></div>",
     	           
             		items: [
                         {
                             id: "srNew",
                             value: "신규", 
             				count: "${srNewCnt}",
             				html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_new.png'/><span class='mgL10'>${menu.LN00339}</span></div>"

                         },
                         {
                             id: "srIng",
                             value: "진행중", 
             				count: "${srIngCnt}",
             				html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_ing.png'/><span class='mgL10'>${menu.LN00121}</span></div>"
                         },
                         {
                             id: "srAll",
                             value: "ALL",
                             html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_all.png'/><span class='mgL10'>ALL</span></div>"
                         },
                         {
                             id: "srReq",
                             value: "요청",
                             html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_plus.png'/><span class='mgL10'>${menu.LN00286}</span></div>"
                                 
                         },
                         {
                        	 id: "srDesk",
             	                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sd.png'/><span class='mgL10'>Service Desk</span></div>"
                         }
                     ]
                 },
                 {
                     id: "item",
                     value: "Subscription",
                     html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_contents.png'/><span class='mgL15'>${menu.LN00347}</span></div>",
           			items: [
                         {
                             id: "itemAll",
                             value: "All",
             				 count: "${itemTreeCnt}",
                             html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sub.png'/><span class='mgL10'>All</span></div>"
                                 
                         },
                         {
                             id: "itemMod",
                             value: "Editing", 
             				 count: "${itemTreeModeCnt}",
                             html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_edit.png'/><span class='mgL10'>${menu.LN00350}</span></div>"
                                 
                         }
                     ]
                 },
                 {
                     id: "workflow",
                     value: "결재함",                
                     html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_wf.png'/><span class='mgL15'>${menu.LN00242}</span></div>",
             		items: [
                               {
                                   id: "curAprv",
                                   value: "결재할문서",
                                   html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_pay.png'/><span class='mgL10'>${menu.LN00243}</span></div>"
                               },
                               {
                                   id: "areq",
                                   value: "결재 상신",
                                   html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_pay2.png'/><span class='mgL10'>${menu.LN00211}</span></div>"
                               },
                               {
                                   id: "todoAprv",
                                   value: "결재예정문서",
                                   html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_pay3.png'/><span class='mgL10'>${menu.LN00244}</span></div>"
                               },
                               {
                                   id: "refMgt",
                                   value: "참조",
                                   html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_pay4.png'/><span class='mgL10'>${menu.LN00245}</span></div>"
                               },
                               {
                                   id: "cls",
                                   value: "완료",
                                   html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_pay5.png'/><span class='mgL10'>${menu.LN00118}</span></div>"
                               }
                            ]
                         
                 },
                 {
                     id: "setting",
                     value: "Infomation",
                     html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_setting.png'/><span class='mgL15'>Infomation</span></div>",
                     items: [
	                    	 {
	                             id: "info",
	                             value: "Information",
	                             html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_info.png'/><span class='mgL10'>Personal Data</span></div>"
	                         },
	                         {
	                             id: "office",
	                             value: "Out of office-b",
	                             html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_of.png'/><span class='mgL10'>Out of office</span></div>"
	                         },
	                         {
	                             id: "role",
	                             value: "Role",
	                             html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_role.png'/><span class='mgL10'>Role</span></div>"
	                                 
	                         },
	                         {
	                             id: "dimension",
	                             value: "Dimension",
	                             html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_di.png'/><span class='mgL10'>Dimension</span></div>"
	                                 
	                         },
	                         
	                         {
	                             id: "reqUserAuth",
	                             value: "ReqUserAuth",
	                             html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_setting.png'/><span class='mgL10'>Request Authorization</span></div>",
	                         }
                         ]
                 }
         ];
         
    	var sidebar = new dhx.Sidebar("sidebar", {
    		css: "dhx_widget--border_right"
    	});
    	
    	sidebar.data.parse(viewData);

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
    	
    	
    	sidebar.events.on("click", function(id){
    		setPage(id);
    	});

   	function setPage(id,varFilter){
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
				sidebar.data.update("toggle", {html: "<div><img src='${root}cmm/common/images/menu/icon_unfold.png'/></div>"});
				sidebar.data.update("user", {html: "<div><img style='width:96%;height:100%' src='${root}cmm/common/images/menu/sidebar_photo.png'/></div>"});
				$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width -44);
				$("#mainFrame").innerWidth(document.body.getBoundingClientRect().width -44);
			}
			else {
				sidebar.data.update("toggle", {html: "<div><img src='${root}cmm/common/images/menu/icon_fold.png'/><span class='title'>My Page</span></div>"});
				sidebar.data.update("user", {html: "<div>" 
													+ "<li style='margin:0 auto;text-align:center;'><img src= '<%=GlobalVal.EMP_PHOTO_URL%>${memPhoto}' style='width:60px;height:60px;'/></li>" 
													+ "<li style='margin:0 auto;text-align:center;'>${sessionScope.loginInfo.sessionUserNm}</li>"
													+ "<li style='margin:0 auto;text-align:center;'>${sessionScope.loginInfo.sessionTeamName}</li>" 
													+ "</div>"	 });
				$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width -200);
				$("#mainFrame").innerWidth(document.body.getBoundingClientRect().width -200);
			}
			return;
		}else if(id == "user") {
       		parent.goMenu('mySpaceV34.do?srType=${srType}&noticeType=4', '', true, layout_2E);
			return;
		}else if(id == "srNew"){
			url = "esrListMgt.do";
			data =  "srMode=mySR&searchStatus=NEW&srStatus=ING&pageNum=1&srType=${srType}&scrnType=srRqst";
		}else if(id == "srIng"){
			url =  "esrListMgt.do";
			data = "srMode=mySR&srStatus=ING&pageNum=1&srType=${srType}&scrnType=srRqst&mainType=mySRDtl&multiComp=${multiComp}";
		}else if(id == "srTeamIng"){
			url =  "esrListMgt.do";
			data = "srMode=myTeam&srStatus=ING&pageNum=1&srType=${srType}&scrnType=srRqst&mainType=mySRDtl";		
		}else if(id == "srReq") {
			url =  "esrListMgt.do";
			data =  "srMode=mySR&pageNum=1&srType=${srType}&scrnType=srRqst&mainType=mySRDtl&srStatus=ALL";
		}else if(id == "srAll"){
			url =  "esrListMgt.do";
			data =  "srMode=mySR&pageNum=1&srType=${srType}&scrnType=srRqst&mainType=mySRDtl&srStatus=ALL&multiComp=${multiComp}";
		}else if(id == "srDesk"){
			url = "srAreaInfo.do";
			data = "srType=${srType}";
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
			url = "myItemList.do";
			data = "status=ING&assignmentType=SUBSCR";
		}else if(id == "itemAll"){
			url = "myItemList.do";
			data = "assignmentType=SUBSCR";
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
		}else if(id == "role"){
			url = "myRoleList.do";
			data = "s_itemID=${sessionScope.loginInfo.sessionUserId}&scrnType=mySpace";
		}else if(id == "dimension"){
			url = "userDimList.do";
			data = "ownerType=user&uesrType=1&languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${sessionScope.loginInfo.sessionUserId}&scrnType=mySpace";
		}else if(id =="user") {
			url = "mySpace.do";
			target = "mainMenu";
		}else if(id =="itemLast") {
			url = "rcntViewedItemList.do";
		}else if(id == "reqUserAuth") { // Member Agent
			url = "reqUserAuth.do"; 
			data +=  "&sysUserID=1";
			target = "returnFrame";
		}else {		
			var tempItem = sidebar.data.getItem(id);
			url = tempItem.varFilter;
			data = "";
		}
		
		if(varFilter != null && varFilter != '') {
			data += varFilter;
		}

		if(id == "srDesk"){		
			$("#mainFrame").attr("style", "display:block;");
			$("#mainLayer").attr("style", "display:none;");
			
			$("#mainFrame").innerWidth(document.body.getBoundingClientRect().width -200);
			$("#mainFrame").innerHeight($( window ).height());
			
			$('#mainFrame').attr('src',url+"?"+data);
		}else{
			
			$("#mainFrame").attr("style", "display:none;");
			$("#mainLayer").attr("style", "display:block;");
			$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width -200);
			$("#mainLayer").css("background","#fff");
			
			ajaxPage(url, data, target);
		}
	}
	
	$(document).ready(function(){
		fnSidebarInit();	
		
		$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width -200);
		$("#mainLayer").innerHeight($( window ).height());
		
		$("#mainFrame").innerWidth(document.body.getBoundingClientRect().width -200);
		$("#mainFrame").innerHeight($( window ).height());
		
		setDivSize();
		
		$( window ).resize( function() {
				if($(".dhx_sidebar ").width() == 43){	// minimize
			    		$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width -44);
			    		$("#mainFrame").innerWidth(document.body.getBoundingClientRect().width -44);
				} else {
			    		$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width -200);
			    		$("#mainFrame").innerWidth(document.body.getBoundingClientRect().width -200);
				}
			$("#mainLayer").innerHeight($( window ).height());
			 setDivSize();
        });
        
		var scrnType = "${scrnType}";
		
		if(scrnType != "") {
			if("${srID}" != '' && "${srID}" != null){setPage(scrnType,"&srID=${srID}");}
			else {setPage(scrnType);}
		}
		
		setSchdlFrame();
		fnClickedTab(1);
        setWFAprvFrame();
        setModItemList();
        setLastViewedItemList();

	});
	
	function setDivSize(){
        $("#boardDiv > div:nth-child(2)").innerHeight($("#boardDiv").height()-$("#boardDiv > div:nth-child(1)").height());
        $("#csListDiv > div:nth-child(2)").innerHeight($("#csListDiv").height()-$("#csListDiv > div:nth-child(1)").height());
        $("#schdlDiv > div:nth-child(2)").innerHeight($("#schdlDiv").height()-$("#schdlDiv > div:nth-child(1)").height());
        $("#pjtListDiv > div:nth-child(2)").innerHeight($("#pjtListDiv").height()-$("#pjtListDiv > 0div:nth-child(1)").height());
        $("#esrListDiv > div:nth-child(2)").innerHeight($("#esrListDiv").height()-$("#esrListDiv > div:nth-child(1)").height());
        $("#cntDiv > div:nth-child(2)").innerHeight($("#cntDiv").height()-$("#cntDiv > div:nth-child(1)").height());
	}
	
	function fnSidebarInit(){
		
	}
	
	function setLastViewedItemList(){ 
        var url = "olmMySpaceLastViewed.do";
        var target = "itemLastViewed";
        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
        ajaxPage(url, data, target);
    }
		
	function setModItemList(){ 
        var url = "olmMySpaceItemList.do";
        var target = "itemFrame";
        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
        ajaxPage(url, data, target);
    }

    function setSchdlFrame(){
        var url = "olmMainSchdlList.do";   
        var target = "schdlFrame";
        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&listSize=10&mySchdl=Y";
        ajaxPage(url, data, target);
    }
    
    function setWFAprvFrame(){ 
    	var url = "mainWFInstList.do";
        var target = "subWFFrame";
        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&wfMode=CurAprv&screenType=MyPg&listSize=5";
        ajaxPage(url, data, target);
    } 
    	    
    function fnGoSRDetail(SRID,requestUserID,receiptUserID,status,srType){    	
    	var sessionUserID = "${sessionScope.loginInfo.sessionUserId}";
    	var url = ""; 
    	var mainType = "SRDtl";
    	var screenType = "srRqst";
    	var url = "ispMgt.do";
    	
    	if(srType != "ISP"){
    		setPage("srIng","&srID="+SRID);
    	} else if(srType == "ISP"){
	    	if(sessionUserID == requestUserID){
	    	  scrnType ="mySRDtl" ;
	    	}
	        var data = "screenType=" + screenType + "&srID="+SRID+"&srType="+srType+"&scrnType="+scrnType;
	        var target = "mainMenu";
	        
	        ajaxPage(url, data, target);
    	}
    }
    
    function fnClickedTab(avg) {
        var url = "olmMainEsrList.do";
        var target = "esrFrame";
        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&listSize=20&scrnType=mySpace&srType=${srType}";
      	var srMode = "";
        
        if(avg == 1){ // 결재 할 문서
        	data = data + "&srMode=mySR";
        	srMode = "srIng";
        } else if(avg == 2){ // 결재 상신
        	data = data + "&srMode=myTeam";
        	srMode = "srTeamIng";
        }
        
        var realMenuIndex = "1 2".split(' ');
		for ( var i = 0; i < realMenuIndex.length; i++) {
			if (realMenuIndex[i] == avg) {
				$("#pliugt" + realMenuIndex[i]).addClass("on");
			} else {
				$("#pliugt" + realMenuIndex[i]).removeClass("on");
			}
		}
        ajaxPage(url, data, target);
		
		$("#srOnTab").val(srMode);
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
    		}else if($("#wfOnTab").val() == "ToDoAprv"){
    			setPage('todooAprv');
    		}else if($("#wfOnTab").val() == "RefMgt"){
    			setPage('refMgt');
    		}else if($("#wfOnTab").val() == "MyWIP"){
    			setPage('areq');
    		}
       	} else if(onTab == "CngSet") {
	    	parent.clickMainMenu('CHANGESET', 'CHANGESET','','','','','.do?', '');
       	} else if(onTab == "csrList") {
			parent.goMenu("csrList.do?mainMenu=1&memberId=${sessionScope.loginInfo.sessionUserId}");
		}
       	
    }
    
    function goMyPage(avg) {
    	var url = "myPage.do";
    	var data = "mainType="+avg;
    	var target = "mainLayer";
    	
    	ajaxPage(url, data, target);
    }
    
    function fnGoMore(id, onTab){
    	var focusMenu ="";

       	if(onTab == "ESR"){
       		if($("#srOnTab").val() == "srIng"){
       			setPage('srIng');
    		}else if($("#srOnTab").val() == "srTeamIng"){
    			setPage('srTeamIng');
    		}
       	} 
       	
       	if(onTab == "LAST"){
       		setPage("itemLast");
       	}
       	
    }

    function fnWFListReload() {
    	setWFAprvFrame();
    }
    
    function doSearchList() {
    	fnWFListReload();
	}
</script>
</head>
<style>
	#mainMenu{
		overflow-x: hidden;
	}
	.dhx_sidebar{
		float:left;
	}
	#mainLayer{
		height:99%;
		float:left;
		overflow-y: auto;
		overflow-x: auto;
		padding:0 20px;
	}
	#mainWrapper{
		width: 94%;
	    height: 96%;
	    top: 2%;
	    min-width: 1250px;
	    display: inline-block;
 	    margin: auto 3%;
	}
		
	#mainFrame{
		height:99%;
		float:left;
		overflow-y: auto;
		overflow-x: auto;
		padding:0 20px;
	}
		
	.dhx_tooltip {
		display:block;
	}
	
	.dhx_widget {
	    font-weight: 400;
	    font-size: 14px;
	    line-height: 20px;
	    color: rgba(0,0,0,.7);
	}

	.dhx_tooltip {
	    pointer-events: none;
	    border-radius: 2px;
	    background-color: #333;
	    box-shadow: 0 2px 5px rgb(0 0 0 / 30%);
	    padding: 6px 12px;
	    transition: opacity .01s ease,transform .01s ease;
	    opacity: 1;
	    z-index: 999;
	    border:none;
	}
	
	.dhx_tooltip--right {
	    margin: 0 0 0 8px;
	}
	
	.dhx_tooltip__text {
	    font-size: 12px;
	}
</style>
<body id="mainMenu">
	<section class="dhx_sample-container">
		<div class="dhx_sample-container__widget" id="sidebar"></div>
	</section>
	<iframe name="mainFrame" id="mainFrame" style="display:none;" width="99%" height="99%" frameborder="0" scrolling="no" marginwidth="0" marginheight="0"></iframe>
	<div class="noform" id="mainLayer">
		<form name="mainLayerFrm" id="mainLayerFrm" method="post" action="#" onsubmit="return false;">
			<input id="wfType" type="hidden" value=""/>
			<input type="hidden" id="srOnTab" name="srOnTab" value=""/>
			<div id="mainWrapper">
				<div id="leftDiv">
					<div id="cntDiv">
						<div class="secTit" style=" height:26%;"><ul><li class="titNM">My Item</li></ul></div>
						<div class="cntFrame">
							<div class="sec" style="background:#4265EE">
								<ul class="tit">
									<li>${menu.LN00145}</li>
									<li class="img"><img src="${root}cmm/common/images/menu/tit_myItem.png"></li>
								</ul>
								<ul class="con">
									<li class="bd" onClick="goMyPage('myItem')"><p>${itemCnt}</p>${menu.LN00347}</li>
									<li class="" onClick="goMyPage('myCSItem')"><p>${itemModeCnt}</p>${menu.LN00344}</li>
								</ul>
							</div>
							<div class="sec" style="background:#4087FB">
								<ul class="tit">
									<li>${menu.LN00333}</li>
									<li class="img"><img src="${root}cmm/common/images/menu/tit_sr.png"></li>
								</ul>
								<ul class="con">
									<li class="bd" onClick="setPage('srNew')"><p>${srNewCnt}</p>${menu.LN00339}</li>
									<li class="" onClick="setPage('srIng')"><p>${srIngCnt}</p>${menu.LN00121}</li>
								</ul>
							</div>
							<div class="sec" style="background:#1BB4F8">
								<ul class="tit">
									<li>${menu.LN00242}</li>
									<li class="img"><img src="${root}cmm/common/images/menu/tit_wf.png"></li>
								</ul>
								<ul class="con">
									<li class="bd" onClick="setPage('todoAprv')"><p>${wfToDoAprvCnt}</p>${menu.LN00244}</li>
									<li class="" onClick="setPage('refMgt')"><p>${wfRefMgtCnt}</p>${menu.LN00245}</li>
								</ul>
							</div>
						</div>
					</div>
					
					<div id="csListDiv" style="height:44.6%;">
						<div class="tabs">
							<ul>
								<li id="pliugt1" class="on titNM" onclick="javascript:fnClickedTab('1');">${menu.LN00333}</li>
								<li id="pliugt2" class="titNM" onclick="javascript:fnClickedTab('2');">${menu.LN00104}${menu.LN00333}</li>
							</ul>
							<ul class="morebtn" onClick="fnGoMore('', 'ESR');">
								<li>more</li>
							</ul>
						</div>
						<div id="esrFrame" class="postInfo"></div>	
					</div>
										
					<div id="itemListDiv">
						<div class="secTit">
							<ul>
								<li class="titNM">Recently viewed</li>
							</ul>
							<ul class="morebtn" onClick="fnGoMore('','LAST')">
								<li>more</li>
							</ul>
						</div>
						<div id="itemLastViewed" class="postInfo"></div>	
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
								<li class="on titNM">${menu.LN00243}</li>
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
								<li class="titNM">${menu.LN00347}</li>
							</ul>
							<ul class="morebtn" onClick="setPage('itemAll')">
								<li>more</li>
							</ul>
						</div>
						<div id="itemFrame" class="postInfo"></div>	
					</div>
				</div>
		
			</div>
		</form>
		</div>
		 <iframe name="returnFrame" id="returnFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
</html>