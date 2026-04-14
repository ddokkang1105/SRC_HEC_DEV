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

var layout = new dhx.Layout("demo_root", {
    type: "line",
    css: "dhx_layout-line",
    rows: [
        {
            id: "toolbar",
            gravity:false,
            css:"dhx_layout-cell--border_bottom"
        },
        {
            cols: [
                {
                    id: "sidebar",
                    width: "content",
                    gravity:false
                },
                {
                    id: "content",
                    gravity:false,
                    html: '<div class="noform" id="mainLayer"></div>'
                }
            ]
        }
    ]
});


var data = [
             { 
                 id: "projectInfo", 
                 value: "개요",
                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_project.png'/><span class='mgL15'>개요</span></div>"
             },
             {
                 id: "worker",
                 value: "Worker",
                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_role.png'/><span class='mgL15'>Worker</span></div>"
             },
             { 
            	 id: "csr",
                 value: "Task",
                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_csr.png'/><span class='mgL15'>${menu.LN00191}</span></div>"
             },
             { 
                 id: "cs", 
                 value: "ChangeSet",
                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_cs_all.png'/><span class='mgL15'>Change Set</span></div>",
             },
             { 
                 id: "document", 
                 value: "Document",
                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_contents.png'/><span class='mgL15'>Document</span></div>",
             },
             { 
                 id: "schedule", 
                 value: "Schedule",
                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sch.png'/><span class='mgL15'>${menu.LN00110}</span></div>",
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
	
	sidebar.data.update("toggle", {icon: "mdi mdi-menu"});
	
	sidebar.events.on("click", function(id){
		setPage(id);
	});
	
	sidebar.events.on("openMenu", function(id){
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
				sidebar.data.update("toggle", {html: "<div><img src='${root}${HTML_IMG_DIR}/icon_unfold.png'/></div>"});
				sidebar.data.update("user", {html: "<div><img style='width:96%;height:100%' src='${root}${HTML_IMG_DIR}/sidebar_photo.png'/></div>"});
				$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width -44);
			}
			else {
				sidebar.data.update("toggle", {html: "<div><img src='${root}${HTML_IMG_DIR}/icon_fold.png'/><span class='title'>${projectName}</span></div>"});
				sidebar.data.update("user", {html: "<div>" 
													+ "<li style='margin:0 auto;text-align:center;'><img src='<%=GlobalVal.EMP_PHOTO_URL%>${memPhoto}' style='width:50px;height:50px;'/></li>" 
													+ "<li style='margin:0 auto;text-align:center;'>${sessionScope.loginInfo.sessionUserNm}</li>"
													+ "<li style='margin:0 auto;text-align:center;'>${sessionScope.loginInfo.sessionTeamName}</li>" 
													+ "</div>"	 });
				$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width -180);
			}
			return;
		}else if(id == "projectInfo") {
       		url = "viewProjectInfo.do";
			data = "isNew=N&s_itemID=${projectID}&pjtMode=R&refID=${refID}&screenType=pjtInfoMgt";			
		}else if(id == "worker"){
			url = "selectPjtMember.do";
			data = "projectID=${projectID}&listEditable=N";
		}else if(id == "csr"){
			url = "csrList.do";
			data = "refPGID=${refPGID}&projectID=${projectID}&screenType=pjtInfoMgt";	
		}else if(id == "cs"){
			url = "changeInfoList.do";
			data = "mainMenu=0&isMine=N&screenType=PJT&projectID=${projectID}";
		}else if(id == "document"){
			url = "documentGridList.do";
			data = "screenType=pjtInfoMgt&parentID=${projectID}&isPublic=N";
		}else if(id == "schedule"){
			url = "goSchdlList.do";	
			data = "screenType=pjtInfoMgt&parentID=${projectID}";
		}

		if(varFilter != null && varFilter != '') {
			data += varFilter;
		}
		ajaxPage(url, data, target);
	}
	
	$(document).ready(function(){
		fnSidebarInit();	
		
		$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width -180);
		$("#mainLayer").innerHeight($( window ).height());
		setDivSize();
		
		$( window ).resize( function() {
				if($(".dhx_sidebar ").width() == 43){	// minimize
			    		$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width -24);
				} else {
			    		$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width -180);
				}
			$("#mainLayer").innerHeight($( window ).height());
			 setDivSize();
        });
        
		var scrnType = "${scrnType}";
		
		if(scrnType != "") {
			if("${srID}" != '' && "${srID}" != null){setPage(scrnType,"&srID=${srID}");}
			else {setPage(scrnType);}
		}
		
			/* setSchdlFrame();
			fnClickedTab(1);
	        setESRFrame();
	        setModItemList();
	        setPjtList(); */
        
	});
	
	 function setDivSize(){
        $("#boardDiv > div:nth-child(2)").innerHeight($("#boardDiv").height()-$("#boardDiv > div:nth-child(1)").height());
        $("#csListDiv > div:nth-child(2)").innerHeight($("#csListDiv").height()-$("#csListDiv > div:nth-child(1)").height());
        $("#schdlDiv > div:nth-child(2)").innerHeight($("#schdlDiv").height()-$("#schdlDiv > div:nth-child(1)").height());
        $("#esrListDiv > div:nth-child(2)").innerHeight($("#esrListDiv").height()-$("#esrListDiv > div:nth-child(1)").height());
        $("#cntDiv > div:nth-child(2)").innerHeight($("#cntDiv").height()-$("#cntDiv > div:nth-child(1)").height());
	 }
	 
	function fnSidebarInit(){
		fnSetFrame('projectInfo');
	}
	
	function fnSetFrame(id){
		var target = "mainLayer";
		if(id != "toggle"){
			$("#mainLayer").css("background","#fff");
		}
		if(id == "projectInfo") {
       		url = "viewProjectInfo.do";
			data = "isNew=N&s_itemID=${projectID}&pjtMode=R&refID=${refID}&screenType=pjtInfoMgt";			
		}else if(id == "worker"){
			url = "selectPjtTaskType.do";
			data = "projectID=${projectID}&listEditable=N";
		}
		
		ajaxPage(url, data, target);
	}

	layout.cell("sidebar").attach(sidebar);

	
	const toolbar = new dhx.Toolbar("toolbar", {
	    data: [
	        {
               	 id: "toggle",
				css: "toggle-button",
				html: "<div><img src='${root}${HTML_IMG_DIR}/icon_fold.png'/></div>",
	        },
	        {
	            type: "title",
	            html: "<span class='title' style='font-weight:bold'>${projectName}</span>"
	        }
	    ]
	});

	toolbar.events.on("click", function (id) {
	    if (id === "toggle") {
	        sidebar.toggle();
	        
			if(sidebar.config.collapsed){
				sidebar.data.update("toggle", {html: "<div><img src='${root}${HTML_IMG_DIR}/icon_unfold.png'/></div>"});
				$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width -24);
			}
			else {
				sidebar.data.update("toggle", {html: "<div><img src='${root}${HTML_IMG_DIR}/icon_fold.png'/></div>"});
				$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width -180);
			}
	    }
	});

	layout.cell("toolbar").attach(toolbar);
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
		padding:0 10px;
	}
	#mainWrapper{
		width: 94%;
	    height: 96%;
	    top: 2%;
	    min-width: 1250px;
	    display: inline-block;
 	    margin: auto 3%;
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
	<div class="dhx_sample-container__widget" id="sidebar"></div>
</body>
</html>