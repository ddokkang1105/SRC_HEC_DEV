<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><c:if test="${!empty htmlTitle}">${htmlTitle}</c:if></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />

<%@ include file="/WEB-INF/jsp/template/tagIncV7.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<%-- <script type="text/javascript" src="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.js?v=7.1.8"></script> --%>
<%-- <link rel="stylesheet" href="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.css?v=7.1.8"> --%>

<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/mainHome.css" />

<script type="text/javascript">
// 	jQuery(document).ready(function() {
		var projectID = "${projectID}";
		var screenMode = "${screenMode}";
		var mainMenu = "${mainMenu}";
		var refPjtID = "${refPjtID}";
		var csrEditable = "${csrEditable}";
		var listEditable = "";
		if(csrEditable == "Y"){ listEditable="Y"; }

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
                            html: '<input type="text" id="clickedURL" style="width:800px;display:none;"><div class="noform" id="mainLayer"></div><iframe width="100%" frameborder="0" scrolling="no" style="display:none;border: 0;overflow:auto; padding:0 0 17px 0;" name="digramFrame" id="digramFrame"></iframe>'
                        }
                    ]
                }
            ]
        });


	var data = [
	         { 
	             id: "csrDetail", 
	             value: "개요",
	             html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_project.png'/><span class='mgL15'>${menu.LN00035}(Form)</span></div>"
	         },
// 	         { 
// 	             id: "diagramViewer", 
// 	             value: "모델",
// 	             html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_project.png'/><span class='mgL15'>모델(Tab)</span></div>"
// 	         },
//              {
// 	             id: "selectPjtMember",
// 	             value: "selectPjtMember",
// 	             html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_role.png'/><span class='mgL15'>${menu.LN00288}(Data View)</span></div>"
// 	         },
	         { 
	             id: "changeInfo", 
	             value: "changeInfo",
	             html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_cs_all.png'/><span class='mgL15'>${menu.LN00082}(Grid)</span></div>",
	         },
// 	         { 
//                  id: "terms", 
//                  value: "Terms",
//                  html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sch.png'/><span class='mgL15'>표준용어(List)</span></div>",
//              },
             { 
                 id: "board", 
                 value: "board",
                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sch.png'/><span class='mgL15'>게시판(Combo Box)</span></div>",
             },
             { 
                 id: "tree", 
                 value: "Tree",
                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sch.png'/><span class='mgL15'>Tree</span></div>",
             },
             { 
                 id: "treeGrid", 
                 value: "TreeGrid",
                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sch.png'/><span class='mgL15'>TreeGrid</span></div>",
             },
             {
            	 id : "chart",
            	 value : "chart",
            	 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sch.png'/><span class='mgL15'>Chart</span></div>",
            	 items : [
            		 { 
                         id: "chart1", 
                         value: "Bar Chart",
                         html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sch.png'/><span class='mgL15'>Bar Chart</span></div>",
                     },
                     { 
                         id: "chart2", 
                         value: "Pie Chart",
                         html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sch.png'/><span class='mgL15'>Pie Chart</span></div>",
                     },
                     { 
                         id: "chart3", 
                         value: "Line Chart",
                         html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sch.png'/><span class='mgL15'>Line Chart</span></div>",
                     },
                     { 
                         id: "chart4", 
                         value: "ScatterChart",
                         html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sch.png'/><span class='mgL15'>Scatter Chart</span></div>",
                     },
                     { 
                         id: "dhtmlxChartTreeMap", 
                         value: "dhtmlxChartTreeMap",
                         html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sch.png'/><span class='mgL15'>Chart TreeMap</span></div>",
                     },
                     { 
                         id: "itSystemCoverageActivityTreeMap", 
                         value: "itSystemCoverageActivityTreeMap",
                         html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sch.png'/><span class='mgL15'>Chart IT System Coverage of Activity TreeMap</span></div>",
                     },
            	 ]
             },
             { 
                 id: "srDashboard", 
                 value: "srDashboard",
                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sch.png'/><span class='mgL15'>srDashboard</span></div>",
             },
             { 
                 id: "srStatistics", 
                 value: "srStatistics",
                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sch.png'/><span class='mgL15'>srStatistics</span></div>",
             },
             { 
                 id: "restApiGrid", 
                 value: "restApiGrid",
                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sch.png'/><span class='mgL15'>restApiGrid</span></div>",
             },
             { 
                 id: "ArcMenu", 
                 value: "ArcMenu",
                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sch.png'/><span class='mgL15'>Arc - Menu(7.3 적용)</span></div>",
             }
            /*  ,
             { 
                 id: "dhtmlxDiagramFlowChart", 
                 value: "dhtmlxDiagramFlowChart",
                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sch.png'/><span class='mgL15'>Dhtmlx Diagram FlowChart</span></div>",
             } */
             
            ,{ 
                 id: "roleMindMap", 
                 value: "roleMindMap",
                 html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sch.png'/><span class='mgL15'>Role MindMap</span></div>",
             }
            ,{ 
                id: "initiativeMindMap", 
                value: "initiativeMindMap",
                html: "<div><img src='cmm/js/dhtmlx/dhtmlxSidebar/codebase/images/icon_sidebar_sch.png'/><span class='mgL15'>initiative MindMap</span></div>",
            } 
	 ];
	var sidebar = new dhx.Sidebar("sidebar", {
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
	
	sidebar.events.on("openMenu", function(id){
	});
	
	function setPage(id,varFilter){
		var data = "";
		var url = "";
		var target = "mainLayer";
		if(id != "toggle"){
			$("#mainLayer").css("background","#fff");
		}
		mainLayerSize();
		
		if(id == "diagramViewer"){
			url = "newDiagramViewer.do";
			data = "languageID=1042&s_itemID=100647&pop=&width=1643&getAuth=editor&userID=1&option=PAL0101&MenuID=&fromModelYN=&changeSetID=&showTOJ=&tLink=Y&accMode=&varFilter=MOD1&browserType=";
			var browserType="";
			//if($.browser.msie){browserType="IE";}
			var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
			if(IS_IE11){browserType="IE11";}
			var src = url +"?" + data+"&browserType="+browserType;
			var idx = (window.location.href).lastIndexOf('/');
			$("#clickedURL").val((window.location.href).substring(0,idx)+"/"+src);
			document.getElementById('digramFrame').contentWindow.location.href= src; // firefox 호환성  location.href에서 변경
			$("#digramFrame").css("display", "block");
			$("#mainLayer").attr("style", "display:none;");
		}else if(id == "dhtmlxDiagramFlowChart"){
			url = "dhtmlxDiagramFlowChart.do";
			data = "";		
			var src = url +"?" + data;
			var idx = (window.location.href).lastIndexOf('/');
			$("#clickedURL").val((window.location.href).substring(0,idx)+"/"+src);
			document.getElementById('digramFrame').contentWindow.location.href= src; // firefox 호환성  location.href에서 변경
			$("#digramFrame").css("display", "block");
			$("#mainLayer").attr("style", "display:none;");
		}else if(id == "dhtmlxChartTreeMap"){
			url = "dhtmlxChartTreeMap.do";
			data = "";			
			var src = url +"?" + data;
			var idx = (window.location.href).lastIndexOf('/');
			$("#clickedURL").val((window.location.href).substring(0,idx)+"/"+src);
			document.getElementById('digramFrame').contentWindow.location.href= src; // firefox 호환성  location.href에서 변경
			$("#digramFrame").css("display", "block");
			$("#mainLayer").attr("style", "display:none;");
		}else if(id == "itSystemCoverageActivityTreeMap"){
			url = "itSystemCoverageActivityTreeMap.do";
			data = "";			
			var src = url +"?" + data;
			var idx = (window.location.href).lastIndexOf('/');
			$("#clickedURL").val((window.location.href).substring(0,idx)+"/"+src);
			document.getElementById('digramFrame').contentWindow.location.href= src; // firefox 호환성  location.href에서 변경
			$("#digramFrame").css("display", "block");
			$("#mainLayer").attr("style", "display:none;");
		}
// 		else if(id == "dhtmlxDiagramMindMap"){
// 			url = "dhtmlxDiagramMindMap.do";
// 			data = "";			
// 			var src = url +"?" + data;
// 			var idx = (window.location.href).lastIndexOf('/');
// 			$("#clickedURL").val((window.location.href).substring(0,idx)+"/"+src);
// 			document.getElementById('digramFrame').contentWindow.location.href= src; // firefox 호환성  location.href에서 변경
// 			$("#digramFrame").css("display", "block");
// 			$("#mainLayer").attr("style", "display:none;");
// 		}
		
		/*
		else if(id == "tree"){
				url = "itemMgtV7.do";
				data = "arcCode=PAL0101";
				var browserType="";
				//if($.browser.msie){browserType="IE";}
				var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
				if(IS_IE11){browserType="IE11";}
				var src = url +"?" + data;
				var idx = (window.location.href).lastIndexOf('/');
				$("#clickedURL").val((window.location.href).substring(0,idx)+"/"+src);
				document.getElementById('digramFrame').contentWindow.location.href= src; // firefox 호환성  location.href에서 변경
				$("#digramFrame").css("display", "block");
				$("#mainLayer").attr("style", "display:none;");
		} */ 
		else {
			$("#digramFrame").css("display", "none");
			$("#mainLayer").css("display","block");
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
					sidebar.data.update("toggle", {html: "<div><img src='${root}${HTML_IMG_DIR}/icon_fold.png'/><span class='title'>${getMap.ProjectName}</span></div>"});
					sidebar.data.update("user", {html: "<div>" 
														+ "<li style='margin:0 auto;text-align:center;'><img src='<%=GlobalVal.EMP_PHOTO_URL%>${memPhoto}' style='width:50px;height:50px;'/></li>" 
														+ "<li style='margin:0 auto;text-align:center;'>${sessionScope.loginInfo.sessionUserNm}</li>"
														+ "<li style='margin:0 auto;text-align:center;'>${sessionScope.loginInfo.sessionTeamName}</li>" 
														+ "</div>"	 });
					$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width -200);
				}
				return;
			}else if(id == "csrDetail") {
		   		url = "csrInfoMgt.do";
				data = "ProjectID=" + projectID+ "&screenMode=" + screenMode + "&mainMenu=" + mainMenu + "&refPjtID="+refPjtID
				+ "&screenType=${screenType}&srID=${srID}&fromSR=${fromSR}"
				+ "&quickCheckOut=${quickCheckOut}&itemID=${itemID}";
			}else if(id == "getViewSR"){
				var srID = "${getMap.SRID}";
				if(srID == ""){
					return;
				}else{
					url = "processItsp.do";
					data = "srID=${getMap.SRID}&srType=ITSP&isPop=Y&isPopup=Y";
				}
			}else if(id == "selectPjtMember"){
				 url = "selectPjtMemberV4.do";
				data = "projectID=${projectID}&screenMode="+screenMode+"&listEditable="+listEditable+"&screenType=csrDtl&parentID=${refPjtID}&authorID=${getMap.AuthorID}";
			}else if(id == "documentGridList"){
				url = "documentGridList.do";
				data = "projectID=${projectID}&DocCategory=PJT&screenType=csrDtl&isPublic=N&screenMode="+screenMode+"&csrEditable="+csrEditable+"&isMember=${isMember}";
			}else if(id == "changeInfo"){
				url = "changeInfoListV4.do";
				data = "csrStatus=${getMap.Status}&screenType=CSR&csrID=${projectID}&screenMode=${screenMode}&mainMenu=${mainMenu}&s_itemID=${s_itemID}" 
						+ "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}&isFromPjt=Y&isMember=${isMember}&closingOption=${getMap.ClosingOption}";
			}else if(id == "issueInfo"){
				var url = "issueSearchList.do";
				var data = "ProjectID=${projectID}&screenMode=${screenMode}&mainMenu=${mainMenu}&s_itemID=${s_itemID}" 
						+ "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}"
						+ "&Creator=${getMap.Creator}&ParentID=${getMap.ParentID}&issueMode=PjtMgt&screenType=csrDtl";
			}else if(id == "approveInfo"){
				url = "wfInstanceList.do";
				data ="projectID=${projectID}&screenType=csrDtl&filter=csr";
			}else if(id == "getCrMstList") {
				url = "crList.do";
				data = "crMode=CSR&csrID=${projectID}&projectID=${s_itemID}&closingOption=${getMap.ClosingOption}";	
			}else if(id == "schedule"){
				url = "goSchdlList.do";	
				data = "screenType=pjtInfoMgt&parentID="+projectID;
			}else if(id == "terms"){
				url="standardTermsSchV4.do"
			}else if(id == "board"){
				url = "boardListV4.do";
				data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&screenType=Admin&BoardMgtID=4&url=forumMgt&boardTypeCD=MN124";
			}
			else if(id == "srDashboard"){
				url = "srDashboardV4.do";
			}else if(id == "restApiGrid"){
				url = "restApiGridList.do";
				data = "screenType=Admin";
			}else if(id == "tree"){
				url = "dhtmlxV7LayoutAttachTree.do";	data = "screenType=Admin";
			}else if(id == "treeGrid"){
				url = "dhtmlxV7TreeGrid.do";	data = "dimTypeID=1001&selectedDimClass=CL01005";
			}else if(id == "chart1"){
				url = "dhtmlxV7BarChart.do";	data = "";
			}else if(id == "chart2"){
				url = "dhtmlxV7PieChart.do";	data = "";
			}else if(id == "chart3"){
				url = "dhtmlxV7LineChart.do";	data = "";
			}else if(id == "chart4"){
				url = "dhtmlxV7ScatterChart.do";	data = "";
			}else if(id == "srStatistics"){
				url = "srStatisticsV4.do";
				data = "&url=app/esm/itsp/itspMgt&multiComp=Y&srType=ITSP";
			}else if(id == "ArcMenu"){
				url = "arcMenuV4.do";
				data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&ArcCode=AR000000";
			}else if(id == "roleMindMap") {
				url = "roleMindMap.do";
				data = "&s_itemID=738866";
			}else if(id == "initiativeMindMap") {
				url = "initiativeMindMap.do";
				data = "&s_itemID=739373";
			}
			
			if(varFilter != null && varFilter != '') {
				data += varFilter;
			}
			ajaxPage(url, data, target);
		}
		
	}
	
	function mainLayerSize() {
		$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width-200);
		$("#digramFrame").innerWidth(document.body.getBoundingClientRect().width-200);
		$("#mainLayer").innerHeight($( window ).height() - 53);
		$("#digramFrame").innerHeight($( window ).height() - 53);
		
		$( window ).resize( function() {
				if($(".dhx_sidebar ").width() == 43){	// minimize
			    		$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width -44);
			    		$("#digramFrame").innerWidth(document.body.getBoundingClientRect().width -44);
				} else {
			    		$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width -200);
			    		$("#digramFrame").innerWidth(document.body.getBoundingClientRect().width -200);
				}
			$("#mainLayer").innerHeight($( window ).height() - 53);
			$("#digramFrame").innerHeight($( window ).height() - 53);
	    });
	}
	
	
	$(document).ready(function(){
		
		setPage("csrDetail");
		mainLayerSize();
		var scrnType = "${scrnType}";
		
		if(scrnType != "") {
			if("${srID}" != '' && "${srID}" != null){setPage(scrnType,"&srID=${srID}");}
			else {setPage(scrnType);}
		}	   
		
// 		if(!"${getMap.SRID}") sidebar.data.remove("getViewSR");
// 		if("${getMap.CurWFInstanceID}" == "" || "${getMap.Status}" == "CSR" || "${getMap.Status}" == "WTR") sidebar.data.remove("approveInfo");
// 		if("${CRCNT}" == "0") sidebar.data.remove("getCrMstList");
		sidebar.data.remove("issueInfo");
	});
	
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
	            html: "<span class='title' style='font-weight:bold'>${getMap.ProjectName}</span>"
	        }
	    ]
	});

	toolbar.events.on("click", function (id) {
	    if (id === "toggle") {
	        sidebar.toggle();
	        
			if(sidebar.config.collapsed){
				sidebar.data.update("toggle", {html: "<div><img src='${root}${HTML_IMG_DIR}/icon_unfold.png'/></div>"});
				$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width -44);
			}
			else {
				sidebar.data.update("toggle", {html: "<div><img src='${root}${HTML_IMG_DIR}/icon_fold.png'/></div>"});
				$("#mainLayer").innerWidth(document.body.getBoundingClientRect().width -200);
			}
	    }
	});

	layout.cell("toolbar").attach(toolbar);
</script>

<style>
	#mainMenu{
		overflow-x: hidden;
    overflow-y: hidden !important;
	}
	.dhx_sidebar{
		float:left;
	}
	#mainLayer{
		height:99%;
		float:left;
		overflow-y: auto;
		overflow-x: auto;
		background:#fff;
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
</head>

<body id="mainMenu">
	<div class="dhx_sample-container__widget" id="sidebar"></div>
</body>

</html>
