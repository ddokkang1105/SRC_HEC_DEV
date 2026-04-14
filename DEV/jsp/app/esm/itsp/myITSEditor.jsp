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

var data = [
           { 
                id: "toggle",
				css: "toggle-button",
				html: "<div><img src='${root}cmm/common/images/menu/icon_fold.png'/><span class='title'>IT Service</span></div>",
            },
            { 
                id: "user",
				html: "<div>" 
				+ "<li style='text-align:center;'><img src='<%=GlobalVal.EMP_PHOTO_URL%>${memPhoto}' style='width:50px;height:50px;'/></li>" 
				+ "<li style='text-align:center;'>${sessionScope.loginInfo.sessionUserNm}</li>"
				+ "<li style='text-align:center;'>${sessionScope.loginInfo.sessionTeamName}</li>" 
				+ "</div>"	
            },
            {
	           	 id:     "sepId1",        
	          	 type:   "separator"
	       	 },
            {
	       		id: "sr", 
                value: "Service Request",
                html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sr.png'/><span class='mgL15'>Service Request</span></div>",
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
                id: "scr",
                value: "System Change Request",
                html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_contents.png'/><span class='mgL15'>Development Mgt.</span></div>",
                items: [
                    {
                        id: "scrIng",
                        value: "진행 중",
                        count: "${scrIngCnt}",
                        html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_ing.png'/><span class='mgL10'>${menu.LN00121}</span></div>"
                    },
                    {
                        id: "scrApr",
                        value: "승인 완료",
                        count: "${scrAprelCnt}",
                        html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_pay5.png'/><span class='mgL10'>${menu.LN00107} ${menu.LN00118}</span></div>"
                    },
                    {
                        id: "scrAll",
                        value: "ALL",
                        html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_all.png'/><span class='mgL10'>ALL</span></div>"
                    }
                ]
            },
            {
                id: "cts",
                value: "Change & Transport System",
                html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_contents.png'/><span class='mgL15'>CTR Mgt.</span></div>",
                items: [
                    {
                        id: "ctsIng",
                        value: "진행 중",
                        count: "${ctsIngCnt}",
                        html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_ing.png'/><span class='mgL10'>${menu.LN00121}</span></div>"
                    },
                    {
                        id: "ctsApr",
                        value: "처리 대기",
                        count: "${ctsApreqCnt}",
                        html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_pay3.png'/><span class='mgL10'>${menu.LN00195}</span></div>"
                    },
                    {
                        id: "ctsAll",
                        value: "ALL",
                        html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_all.png'/><span class='mgL10'>ALL</span></div>"
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
//             {
//                 id: "report",
//                 value: "리포트",              
//                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_report.png'/><span class='mgL15'>${menu.LN00287}</span></div>",
//                 items:[
// 	                	{
// 	                        id: "srStatistics",
// 	                        value: "SR 처리현황 통계"
// 	                    },
// 	                    {
// 	                        id: "srMonitoring",
// 	                        value: "SR 모니터링"
// 	                    },
// 	                    {
// 	                        id: "srDashboard",
// 	                        value: "SR Dashboard"
// 	                    }
//                 	]
//             },
            {
	           	 id:     "sepId2",        
	          	 type:   "separator"
	       	 },
             {
                 id: "project",
                 value: "프로젝트",
                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_project.png'/><span class='mgL15'>${menu.LN00131}</span></div>",
         		items: [
                     {
                         id: "ownerPjt",
                         value: "관리 프로젝트", 
                         count: "${ownerPjtCnt}",
     	                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_man.png'/><span class='mgL10'>${menu.LN00340}</span></div>"

                     },
                     {
                         id: "workPjt",
                         value: "참여 프로젝트", 
         				count: "${workerPjtCnt}",
     	                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_join.png'/><span class='mgL10'>${menu.LN00341}</span></div>"
                     }
                 ]
             },
             {
                 id: "csr",
                 value: "변경과제",
                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_csr.png'/><span class='mgL15'>${menu.LN00191}</span></div>",
         		items: [
                     {
                         id: "ownerCsr",
                         value: "관리 과제", 
                         count: "${ownerCsrCnt}",
     	                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_man.png'/><span class='mgL10'>${menu.LN00342}</span></div>"

                     },
                     {
                         id: "workCsr",
                         value: "참여 과제", 
         				count: "${workerCsrCnt}",
     	                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_scr_ing.png'/><span class='mgL10'>${menu.LN00343}</span></div>"
                     }
                 ]
             },
             {
                 id: "item",
                 value: "Contents",
                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_contents.png'/><span class='mgL15'>${menu.LN00145}</span></div>",
         		items: [
         			{
                        id: "itemNew",
                        value: "신규", 
        				count: "${itemNewCnt}",
                       html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_cs_new.png'/><span class='mgL10'>${menu.LN00339}</span></div>"
                           
                    },{
                        id: "itemMod",
                        value: "수정 중", 
        				count: "${itemModCnt}",
                           html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_edit.png'/><span class='mgL10'>${menu.LN00344}</span></div>"
                    },{
                        id: "itemAprv",
                        value: "승인 중", 
        				count: "${itemAprvCnt}",
                       html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_check.png'/><span class='mgL10'>${menu.LN00345}</span></div>"
                           
                    },{
                        id: "itemAll",
                        value: "All", 
        				count: "${itemTreeCnt}",
                       html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_cs_all.png'/><span class='mgL10'>${menu.LN00346}</span></div>"                	

                    },
                    {
                        id: "itemSub",
                        value: "구독", 
        				count: "${itemSubCnt}",
                       html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sub.png'/><span class='mgL10'>${menu.LN00347}</span></div>"
                           
                    }
                 ]
             },
             {
                 id: "schedule",
                 value: "일정",
                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sch.png'/><span class='mgL15'>${menu.LN00110}</span></div>",
         		items: [
                     {
                         id: "schdlToday",
                         value: "Today",
                         html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_today.png'/><span class='mgL10'>Today</span></div>"
                     },
                     {
                         id: "schdlWeek",
                         value: "Week",
                         html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_week.png'/><span class='mgL10'>Week</span></div>"
                     }
                 ]
             },
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
	
	
	sidebar.events.on("click", function(id){
		setPage(id);
	});
	
	function setPage(id,varFilter){
		var data = "${varFilter}";
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
				sidebar.data.update("toggle", {html: "<div><img src='${root}cmm/common/images/menu/icon_fold.png'/><span class='title'>IT Service</span></div>"});
				sidebar.data.update("user", {html: "<div>" 
					+ "<li style='margin:0 auto;text-align:center;'><img src='<%=GlobalVal.EMP_PHOTO_URL%>${memPhoto}' style='width:50px;height:50px;'/></li>" 
					+ "<li style='margin:0 auto;text-align:center;'>${sessionScope.loginInfo.sessionUserNm}</li>"
					+ "<li style='margin:0 auto;text-align:center;'>${sessionScope.loginInfo.sessionTeamName}</li>" 
					+ "</div>"	 });
				$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width -200);
				$("#mainFrame").innerWidth(document.body.getBoundingClientRect().width -200);
			}
			return;
		}else if(id == "user") {
       		parent.goMenu('myITS.do', '', true, layout_2E);
			return;
		}
		else if(id == "srNew"){
			url = "itspList.do";
			data +=  "&srMode=mySR&srStatus=SPE001&pageNum=1&srType=ITSP&scrnType=srRcv";
		}else if(id == "srIng"  || id == "mySRDtl"){
			url =  "itspList.do";
			data += "&srMode=mySR&srStatus=ING&pageNum=1&srType=ITSP&scrnType=srRcv&mainType=mySRDtl";	
			if(varFilter != null && varFilter.includes("srID")) data += varFilter;
		}else if(id == "srAll"){
			url =  "itspList.do";
			data +=  "&srMode=mySR&srStatus=ALL&pageNum=1&srType=ITSP&scrnType=srRcv";
		}else if(id == "srReq") {
			url =  "itspMgt.do";
			data +=  "&srMode=mySR&pageNum=1&srType=ITSP&scrnType=srRqst";			
		}
		else if(id == "srDesk"){		
			url = "srAreaInfo.do";
			data = "srType=ITSP";
		}
		else if(id == "scrIng"){
			url =  "scrList.do";
			data = "pageNum=1&scrMode=ING&mySCR=Y";
		}else if(id == "scrApr"){
			url =  "scrList.do";
			data = "pageNum=1&scrMode=ING&mySCR=Y&scrStatus=APREL";
		}else if(id == "scrAll"){
			url =  "scrList.do";
			data = "pageNum=1&mySCR=Y";
		}
		else if(id == "ctsIng"){
			url =  "ctrList.do";
			data = "pageNum=1&myCTR=Y&ctrMode=ING";
		}else if(id == "ctsApr"){
			url =  "ctrList.do";
			data = "pageNum=1&myCTR=Y&ctrMode=INPRG";
		}else if(id == "ctsAll"){
			url =  "ctrList.do";
			data = "pageNum=1&myCTR=Y";
		}
		else if(id == "curAprv"){
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
		}
		else if(id == "srStatistics"){
			url = "srStatistics.do";
			data = data + "&srType=ITSP";
		}else if(id == "srMonitoring"){
			url = "srMonitoring.do";
			data = data + "&screenType=srRcv";
		}else if(id == "srDashboard"){
			url = "srDashboard.do";
		}
		else if(id == "ownerPjt"){		
			url = "myProjectList.do";
			data = "isNew=N&pjtMode=R&mainVersion=mainV5&authorID=${sessionScope.loginInfo.sessionUserId}&status=OPN&screenType=MYSPACE&mbrType=manager";
		}else if(id == "workPjt"){
			url = "myProjectList.do";
			data = "isNew=N&pjtMode=R&mainVersion=mainV5&status=OPN&screenType=MYSPACE&mbrType=worker";
		}
		else if(id == "ownerCsr"){
			url = "csrList.do";
			data = "&mainMenu=1&memberID=${sessionScope.loginInfo.sessionUserId}&screenType=MYSPACE&mbrType=manager";
		}else if(id == "workCsr"){
			url = "csrList.do";
			data = "&mainMenu=1&memberID=${sessionScope.loginInfo.sessionUserId}&screenType=MYSPACE&mbrType=worker"; 
		}
		else if(id == "itemMod"){
			url = "ownerItemList.do";
			data = "ownerType=editor&status=MOD1&option=MYSPACE";
		}else if(id == "itemAll"){
			url = "ownerItemList.do";
			data = "ownerType=editor&option=MYSPACE";
		}else if(id == "itemNew"){
			url = "ownerItemList.do";
			data = "ownerType=editor&status=NEW1&option=MYSPACE";
		}else if(id == "itemAprv"){
			url = "ownerItemList.do";
			data = "ownerType=editor&statusList='NEW2','MOD2'&option=MYSPACE";
		}else if(id == "itemSub"){
			url = "myItemList.do";
			data = "assignmentType=SUBSCR";
		}
		else if(id == "schdlToday"){
			url = "goSchdlList.do"; 
			data =  data + "&schdlType=today&screenType=MyPg&wfStepID=AREQ";
		}else if(id == "schdlWeek"){
			url = "goSchdlList.do"; 
			data =  data + "&schdlType=week&screenType=MyPg&wfStepID=AREQ";
		}

		
		if(id == "srDesk" || id == "srStatistics" || id == "srMonitoring" || id == "srDashboard"){		
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
		
		setSchdlFrame();
		fnClickedTab(1);
        setESRFrame();
        setSCRFrame();
        setCTRFrame();
	});
	
	 function setDivSize(){
        $("#boardDiv > div:nth-child(2)").innerHeight($("#boardDiv").height()-$("#boardDiv > div:nth-child(1)").height());
        $("#csListDiv > div:nth-child(2)").innerHeight($("#csListDiv").height()-$("#csListDiv > div:nth-child(1)").height());
        $("#schdlDiv > div:nth-child(2)").innerHeight($("#schdlDiv").height()-$("#schdlDiv > div:nth-child(1)").height());
        $("#cntDiv > div:nth-child(2)").innerHeight($("#cntDiv").height()-$("#cntDiv > div:nth-child(1)").height());
        $("#esrListDiv > div:nth-child(2)").innerHeight($("#esrListDiv").height()-$("#esrListDiv > div:nth-child(1)").height());
	 }
	
	function fnSidebarInit(){
		
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
	        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&listSize=10&srMode=mySR&scrnType=mySpace&srType=ITSP";
	        ajaxPage(url, data, target);
	    }
	    
	    function setSCRFrame(){ 
	        var url = "scrMainList.do";
	        var target = "scrFrame";
	        var data = "listSize=4&scrMode=ING&mySCR=Y";
	        ajaxPage(url, data, target);
	    }
	    
	    function setCTRFrame(){ 
	        var url = "mainCTRList.do";
	        var target = "ctrFrame";
	        var data = "listSize=4&myCTR=Y&ctrMode=ING";
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
	   	    	  mainType ="mySRDtl" ;
	   	    	}
	    		var data = "screenType=" + screenType + "&srID="+SRID+"&srType="+srType+"&mainType="+mainType;
	            var target = "mainMenu";
	            
	            ajaxPage(url, data, target);
	    	}
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
	       	} else if(onTab == "SCR"){
	       		focusMenu = "4";
	       		parent.goMenu('itspMgt.do?screenType=&srType=ITSP&focusMenu='+focusMenu, '', true, layout_2E);
	       	} else if(onTab == "CTS"){
	       		focusMenu = "7";
	       		parent.goMenu('itspMgt.do?screenType=&srType=ITSP&focusMenu='+focusMenu, '', true, layout_2E);
	       	} 
	    }
	    
		function fnSCRDetail(scrID, srID){				
			var screenMode = "V";
			var url = "viewRFCPSCRDetail.do";		
			var data = "srID="+srID+"&scrID="+scrID+"&screenMode="+screenMode; 
			var w = 1100;
			var h = 800;
			window.open(url+"?"+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
		}
		
		function fnGoctrDetail(ctrID){		
			var screenMode = "V";
			var mainMenu = "${mainMenu}";
			var url = "ctrDetail.do?ctrID="+ctrID+ "&screenMode=" + screenMode + "&mainMenu=" + mainMenu;
					
			var w = 850;
			var h = 800;
			window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
		}
		
		function fnWFListReload() {
		    var avg = $("#wfType").val();
			fnClickedTab(avg);
		}
		
		function doSearchList() {
			fnClickedTab(1);
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
	    color: rgba(0,0,0,0.7);
	}

	.dhx_tooltip {
	    pointer-events: none;
	    border-radius: 2px;
	    background-color: #333;
	    box-shadow: 0 2px 5px rgb(0,0,0,0.3);
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
<!-- 		<form name="mainLayerFrm" id="mainLayerFrm" method="post" action="#" onsubmit="return false;"> -->
			<input id="wfType" type="hidden" value=""/>
			<input type="hidden" id="wfOnTab" name="wfOnTab" value=""/>
			<div id="mainWrapper">
				<div id="leftDiv">
					<div id="cntDiv">
						<div class="secTit" style=" height:26%;"><ul><li class="titNM">My Service</li></ul></div>
						<div class="cntFrame">
							<div class="sec" style="background:#4265EE;;">
								<ul class="tit">
									<li>${menu.LN00333}</li>
									<li class="img"><img src="${root}cmm/common/images/menu/tit_sr.png"></li>
								</ul>
								<ul class="con">
									<li class="bd" onClick="setPage('srNew')"><p>${srNewCnt}</p>${menu.LN00339}</li>
									<li class="" onClick="setPage('srIng')"><p>${srIngCnt}</p>${menu.LN00121}</li>
								</ul>
							</div>
							<div class="sec" style="background:#4087FB">
								<ul class="tit">
									<li>${menu.LN00242}</li>
									<li class="img"><img src="${root}cmm/common/images/menu/tit_wf.png"></li>
								</ul>
								<ul class="con">
									<li class="bd" onClick="setPage('areq')"><p>${wfAREQCnt}</p>${menu.LN00211}</li>
									<li class="" onClick="setPage('curAprv')"><p>${wfCurAprvCnt}</p>${menu.LN00195}</li>
								</ul>
							</div>
							<div class="sec" style="background:#109CD7">
								<ul class="tit">
									<li>SCR</li>
									<li class="img"><img src="${root}cmm/common/images/menu/tit_myItem.png"></li>
								</ul>
								<ul class="con">
									<li class="bd" onClick="setPage('scrIng')"><p>${scrIngCnt }</p>${menu.LN00121}</li>
									<li class="" onClick="setPage('scrApr')"><p>${scrAprelCnt}</p>${menu.LN00107} ${menu.LN00118}</li>
								</ul>
							</div>
							<div class="sec" style="background:#1BB4F8">
								<ul class="tit">
									<li>CTS</li>
									<li class="img"><img src="${root}cmm/common/images/menu/tit_myItem.png"></li>
								</ul>
								<ul class="con">
									<li class="bd" onClick="setPage('ctsIng')"><p>${ctsIngCnt}</p>${menu.LN00121}</li>
									<li class="" onClick="setPage('ctsApr')"><p>${ctsApreqCnt}</p>${menu.LN00195}</li>
								</ul>
							</div>
						</div>
					</div>
					
					<div id="csListDiv" style="height:44%;">
						<div class="secTit">
							<ul>
								<li class="titNM">IT Service Request</li>
							</ul>
							<ul class="morebtn" onClick="setPage('srIng')">
								<li>more</li>
							</ul>
						</div>
						<div id="esrFrame" class="postInfo"></div>	
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
				</div>
				
				<div id="rightDiv">
	
					
					<div id="schdlDiv">
						<div class="secTit">
							<ul>
								<li class="titNM">${menu.LN00110}</li>
							</ul>
							<ul class="morebtn" onClick="javascript:fnGoMore('','SCHDL')">
								<li>more</li>
							</ul>
						</div>
						<div id="schdlFrame"></div>	
					</div>
					
					<div id="esrListDiv" style="height:32%;">
						<div class="secTit">
							<ul>
								<li class="titNM">SCR&nbsp;&nbsp;<span class="smtit">System Change Request</span></li>
							</ul>
							<ul class="morebtn" onClick="setPage('scrIng')">
								<li>more</li>
							</ul>
						</div>
						<div id="scrFrame" class="postInfo"></div>	
					</div>
					
					<div id="esrListDiv" style="height:32%;">
						<div class="secTit">
							<ul>
								<li class="titNM">CTS&nbsp;&nbsp;<span class="smtit">Change Transport System</span></li>
							</ul>
							<ul class="morebtn" onClick="setPage('ctsIng')">
								<li>more</li>
							</ul>
						</div>
						<div id="ctrFrame" class="postInfo"></div>	
					</div>
				</div>
		
			</div>
<!-- 		</form> -->
		</div>
	
</body>
</html>


