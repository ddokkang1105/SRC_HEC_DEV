<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<c:set value='<%= request.getParameter("retfnc") %>' var="retfnc"/>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta>
<!--[if gte IE 8]><meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8"></meta><![endif]-->
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7; charset=utf-8"></meta>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00098" var="WM00098"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00044" var="CM00044"/>

<script>function closeLoading(){$("#resultDiv").html('');$("#loading").fadeOut(50);}</script>
<c:if test="${!empty htmlTitle}"><script>parent.document.title="${htmlTitle}";</script></c:if>
<script type="text/javascript">
var defaultLang = <%=GlobalVal.DEFAULT_LANGUAGE%>;var defaultLangCode = "<%=GlobalVal.DEFAULT_LANG_CODE%>";var atchUrl = "<%=GlobalVal.BASE_ATCH_URL%>";
</script>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/menuOnloader.jsp"%>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<script type="text/javascript" src="${root}cmm/js/xbolt/lovCssHelper.js"></script>
<%@ include file="/WEB-INF/jsp/cmm/ui/dhtmlxJsInc.jsp"%>

<link rel="stylesheet" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/reference/animsition.css" />
<link rel="stylesheet" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/reference/bootstrap-extend.min.css" />
<link rel="stylesheet" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/reference/bootstrap-select.min.css" />
<link rel="stylesheet" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/reference/bootstrap.min.css" />
<link rel="stylesheet" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/reference/flag-icon.css" />
<link rel="stylesheet" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/reference/introjs.css" />
<link rel="stylesheet" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/reference/jquery-jvectormap.css" />
<link rel="stylesheet" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/reference/site.css" />
<link rel="stylesheet" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/reference/v1.css" />
<link rel="stylesheet" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/reference/web-icons.min.css" />
<link rel="stylesheet" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/reference/modals.min.css" />
<link rel="stylesheet" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/custom/style.css" />

<script type="text/javascript">
	var olm={};	olm.pages={};olm.url={};var baseLayout;var cntnLayout;var menuTreeLayout;var treeImgPath="";var topMenuCnt={};var currItemId="";var mainLayout;var tmplCode="";var isTempLoad={};
	var homeUrl;var varFilter="";
	var projectName = "${projectName}";
	window.onload=setInit;
	jQuery(document).ready(function() {	
		var lang_style="width:"+"${tmpTextMaxLng}"+"px;"; var cmpny_style="width:"+"${cmpnyTextMaxLng}"+"px";
		//fnChangeLangComboStyle(lang_style);
		fnChangeCmpnyComboStyle(cmpny_style);
				
		 $('.logo').click(function(){ 	        	
		//	clickMainMenu("HOME", "HOME", "", "", "", "", homeUrl);
	        $("#cmbTempl").val("${templCode}");changeTempl("${templCode}","${templText}","${mainURL}","","","${tmplFilter}");
	        $('.navbar-left li a').removeClass('nav-link-select');
	     });
		 		 
        $('.home').click(function(){ 
        	var layerTypeHmBtn = $("#layerTypeHmBtn").val();
			var layerTextHmBtn = $("#layerTextHmBtn").val();
			var mainUrlHmBtn = $("#mainUrlHmBtn").val();
			var mainScnTextHmBtn =  $("#mainScnTextHmBtn").val();
			var mainUrlFilterHmBtn = $("#mainUrlFilterHmBtn").val();
			var tmplFilterHmBtn = $("#tmplFilterHmBtn").val();
			var tmplProjectID = $("#tmplProjectID").val();
          		
       		$("#cmbTempl").val($("#layerTypeHmBtn").val());
       		changeTempl(layerTypeHmBtn,layerTextHmBtn,mainUrlHmBtn,mainScnTextHmBtn,mainUrlFilterHmBtn,tmplFilterHmBtn,tmplProjectID); 
        });
        
    	$('.navbar-left li a').click(function(){
    		$('.navbar-left li a').removeClass('nav-link-select');
    		$(this).addClass('nav-link-select');
    	});
        
		$('.help').click(function(){
			var meunNm=$(this).attr('alt');
			var title=$(this).attr('title');
			clickMainMenu(meunNm, title);
			setTopIcon(meunNm);
			setClearTopMenuStyle();
		});
		
		$('.myPage').click(function(){
			var meunNm=$(this).attr('alt');
			var title=$(this).attr('title');			
			clickMainMenu(meunNm, title);
			setTopIcon(meunNm);
			setClearTopMenuStyle();
		});
		
		$('.serviceRequest').click(function(){
			var meunNm=$(this).attr('alt');
			var title=$(this).attr('title');
			clickMainMenu(meunNm, title);
			setTopIcon(meunNm);
			
			var layerTypeHmBtn ="SRM";
			var layerTextHmBtn = "Service Request";
			var mainUrlHmBtn = "mainHomLayer_v2";
			var mainScnTextHmBtn = "MAIN";
			var mainUrlFilterHmBtn = "";
			
		    $("#layerTypeHmBtn").val(layerTypeHmBtn);
			$("#layerTextHmBtn").val(layerTextHmBtn);
			$("#mainUrlHmBtn").val(mainUrlHmBtn);
			$("#mainScnTextHmBtn").val(mainScnTextHmBtn);
			$("#mainUrlFilterHmBtn").val(mainUrlFilterHmBtn); 
			
			$("#cmbTempl").val($("#layerTypeHmBtn").val());
			fnSetServiceRequest(layerTypeHmBtn,layerTextHmBtn,mainUrlHmBtn,mainScnTextHmBtn,mainUrlFilterHmBtn); 
		});
		
		$('.logout').click(function(){logout();});
		$('.topIcon').click(function(){var meunNm = $(this).attr('alt');var title = $(this).attr('title');clickMainMenu(meunNm, title);setTopIcon(meunNm);setClearTopMenuStyle();});
		setInitOneLayout(layout_2E);
	});
	
	function fnSetServiceRequest(layerType,layerText, mainUrl, mainScnText, mainUrlFilter) { 
	 	if(layerType==null||layerType==undefined){
			layerType="${templCode}";
		}else{
			$("#layerTypeHmBtn").val(layerType);
			$("#layerTextHmBtn").val(layerText);
			$("#mainUrlHmBtn").val(mainUrl);
			$("#mainScnTextHmBtn").val(mainScnText);
			$("#mainUrlFilterHmBtn").val(mainUrlFilter);
			layerType = $("#layerTypeHmBtn").val();
		} 

		//if(layerText==null||layerText== undefined){layerText="${templText}";}
		//$("#cmbTemplate").html(layerText);
		tmplCode=layerType;
		ajaxSubmitNoAdd(document.langFrm, "templateSetting.do?templCode="+tmplCode, "blankFrame");
		setTopIcon("");
	    setInitMenu(false,true);
		var menuIcon=""; var defDimValueID=""; var menuStyle=""; var scndMenuStyle=""; mainUrl+=".do?"+mainUrlFilter;
		clickMainMenu("TMPL_CHG_URL", mainScnText, menuIcon, defDimValueID, menuStyle, scndMenuStyle, mainUrl);
	}
	
	function setInit(){
		if(window.attachEvent){window.attachEvent("onresize",resizeLayout);}else{window.addEventListener("resize",resizeLayout, false);}var t;function resizeLayout(){window.clearTimeout(t);t=window.setTimeout(function(){setScreenResize();},200);}
		changeTempl('${templCode}','${templText}','${mainURL}','${mainScnText}','${mainUrlFilter}','${tmplFilter}','${projectID}');
		homeUrl = "${mainURL}"+".do?"+"${mainUrlFilter}";
		
        var ntcCnt=parseInt('${ntcCnt}');var cookieId="sfolmLdNtc_"+"${BoardID}";var isNtc=getCookie(cookieId);if(isNtc==undefined){isNtc=false;}/*isNtc = false;*/
        if(isNtc==false&&ntcCnt>0){var url="boardAlarmPop.do";	var data="";fnOpenLayerPopup(url,data,"",600,300);/*openPopup(url,400,400,"new");*/}
	}	
	
	function setScreenResize(h){if(h == null || h == undefined) h = 115; var clientHeight=document.body.clientHeight;document.getElementById("container").style.height = (clientHeight - (h)) + 20 + "px";if( baseLayout==null){if(cntnLayout!=null && cntnLayout!=undefined){cntnLayout.setSizes();}}else{var minWidth=lMinWidth+rMinWidth;var wWidth=document.body.clientWidth;if(minWidth>wWidth){baseLayout.items[0].setWidth(lMinWidth);} baseLayout.setSizes();}}
	function setInitMenu(isLeft, isMain){if(isMain){$("#menusection").attr("style","display:block;");}else{$("#menusection").attr("style","display:none;");}setScreenResize();}
	function changeLanguage(langType,langText) {if(langText==null||langText==undefined){langText="${sessionScope.loginInfo.sessionCurrLangNm}";}$("#cmbLanguage").html(langText);ajaxSubmitNoAdd(document.langFrm, "languageSetting.do?LANGUAGE="+langType+"&NAME="+langText, "blankFrame");}
	function doReturnLanguage(){location.href="mainpage.do?loginIdx=${loginIdx}&screenType=${screenType}&srID=${srID}&mainType=${mainType}&sysCode=${sysCode}&status=${status}";}
	
	function changeTempl(layerType,layerText, mainUrl, mainScnText, mainUrlFilter, tmplFilter, tmplProjectID, tmplType) { 
		if(layerType==null||layerType==undefined){
			layerType="${templCode}";
		}else{
			$("#layerTypeHmBtn").val(layerType);
			$("#layerTextHmBtn").val(layerText);
			$("#mainUrlHmBtn").val(mainUrl);
			$("#mainScnTextHmBtn").val(mainScnText);
			$("#mainUrlFilterHmBtn").val(mainUrlFilter);
			$("#tmplFilterHmBtn").val(tmplFilter);
			$("#tmplProjectID").val(tmplProjectID);
			layerType = $("#layerTypeHmBtn").val();
		}

		if(layerText==null||layerText== undefined){layerText="${templText}";}$("#cmbTemplate").html(layerText);
		tmplCode=layerType;
// 		ajaxSubmitNoAdd(document.langFrm, "templateSetting.do?templCode="+tmplCode, "blankFrame");
		ajaxPageSyn("templateSetting.do","templCode="+tmplCode,"blankFrame");
		setTopIcon("");
		if(layerType == "TMPL999"){setInitMenu(false,false);}else{setInitMenu(false,true);}
		var menuIcon=""; var defDimValueID=""; var menuStyle=""; var scndMenuStyle=""; mainUrl+=".do?"+mainUrlFilter;
		var mainType = $("#mainType").val();
		
		if(mainType == "mySRDtl"){
			clickMainMenu("MYPAGE","MYPAGE", "", "", "", "", "", "", "mySRDtl");
		}else if(mainType == "SRDtlView"){
			clickMainMenu("SRREQ","SRREQ", "", "", "", "", "srMgt.do?srType=ITSP&screenType=srRqst&mainType=${mainType}&srID=${srID}");
		}else{
			clickMainMenu("TMPL_CHG_URL", mainScnText, menuIcon, defDimValueID, menuStyle, scndMenuStyle, mainUrl,"","", tmplFilter, tmplProjectID, tmplType);
		}
	}

	function changePjt(projectID){
		ajaxSubmitNoAdd(document.pjtFrm, "projectSetting.do?projectID="+projectID, "blankFrame");
	}
	function changePjtTxt(projectTxt){
		$("#pjtTemplate").html(projectTxt);
	}
	
	function changeTempl2(layerType,layerText, mainUrl, mainScnText, mainUrlFilter, tmplFilter, tmplProjectID, tmplType) { 
		var url = "setDaelimTemplate.do?";
		url = url + "dTempleCode=" + layerType + "&dTempleText=" + encodeURIComponent(layerText);
		parent.fnSetServiceRequest(url);
	}
	
	function openInNewTab(layerType,layerText, mainUrl, mainScnText, mainUrlFilter, tmplFilter, tmplProjectID, tmplType, mainType) {
		window.open("mainpage.do?loginIdx=${loginIdx}&s_templCode="+layerType,layerType);
	}
	
	function changeCmpny(cmpnyType){
		ajaxSubmitNoAdd(document.cmpnyFrm, "companySetting.do?cmpnyCode="+cmpnyType, "blankFrame");
	}
	function fnSetTemplate(val){
		alert(val);
	}
	function setTopIcon(menuNm) {$('.topIcon').each(function(){if($(this).attr('alt') == menuNm) {$(this).addClass('on');} else {$(this).removeClass('on');}});}	
	function fnCallLanguage(){return '${sessionScope.loginInfo.sessionCurrLangType}';}		
	function fnCallTreeInfo(){var treeInfo = new Object(); treeInfo.data=olm.menuTree.serializeTreeToJSON(); treeInfo.imgPath=treeImgPath; return treeInfo;}	
	function setInitControl(isSchText, isSchURL, menuName, menuIcon){		
		if(menuName == undefined){ menuName = "";}if(menuIcon == undefined || menuIcon == ""){ menuIcon = "icon_home.png";}else{ menuIcon = "root_" +menuIcon;}
		var fullText = "<img src='${root}${HTML_IMG_DIR}/"+menuIcon+"'>&nbsp;&nbsp;"+menuName;$("#menuFullTitle").val(fullText);
		//$("#cntnTitle").html("<span style=color:#333;font-size:12px;font-weight:bold;>&nbsp;&nbsp;"+fullText+"</span>");
		if(isSchText){if($('#schTreeText').length>0){$('#schTreeText').val('');}}		
		if(isSchURL){olm.url={};}		
	}	
	function logout() {
		var loginIdx = "${loginIdx}";
		if(loginIdx == "BASE"){
			ajaxSubmitNoAdd(document.menuFrm, "<c:url value='/login/logout.do'/>", "blankFrame");
		}else{
			top.window.open('about:blank','_self').close(); 
			top.window.opener=self;
			top.self.close(); 
		}
	}
	function fnLoginForm() {parent.fnLoginForm();}
	function setInitOneLayout(viewType){
		setLayoutUnload(false);
		cntnLayout = new dhtmlXLayoutObject("container",layout_1C);
		cntnLayout.items[0].hideHeader();
		mainLayout=cntnLayout.items[0];		
		//cntnLayout = new dhtmlXLayoutObject("container",viewType);cntnLayout.items[0].hideHeader();cntnLayout.items[1].hideHeader();		
		//if(viewType==layout_2E){/*$("#divCntnTop").show();*/cntnLayout.items[0].setHeight(30);cntnLayout.items[0].fixSize(false, true);/*cntnLayout.items[0].attachObject("divCntnTop");*/mainLayout=cntnLayout.items[1];}
		//else{/*$("#divCntnTop").hide();*/cntnLayout.items[1].setWidth(270);mainLayout=cntnLayout.items[0];cntnLayout.items[1].attachURL("<c:url value='/template/rightMenuInc.do'/>");}
	}	
	function setInitTwoLayout(){	
		var scrpt = fnSetScriptMasterDiv();
		if($("#schTreeArea").length>0){$("#schTreeArea").remove();}
		/*$("#divCntnTop").show();*/
		setLayoutUnload(true);
		baseLayout=new dhtmlXLayoutObject("container",layout_2U,dhx_skin_skyblue);baseLayout.skinParams.dhx_skyblue.cpanel_height = 44;baseLayout.setAutoSize("b","a;b");baseLayout.attachEvent("onPanelResizeFinish",function(){setLayoutResize();});baseLayout.items[0].setWidth(250);baseLayout.items[0].setText(scrpt.treeTop);baseLayout.items[1].hideHeader();	
		olm.menuTree = baseLayout.items[0].attachTree(0);olm.menuTree.setSkin(dhx_skin_skyblue);olm.menuTree.setImagePath("${root}cmm/js/dhtmlx/dhtmlxTree/codebase/imgs/"+treeImgPath+"/");olm.menuTree.attachEvent("onClick",function(id){olm.getMenuUrl(id); return true;});olm.menuTree.enableDragAndDrop(false);olm.menuTree.enableSmartXMLParsing(true);	olm.menuTree.setOnLoadingEnd(setUnfoldTreeMaster);
		
		cntnLayout = baseLayout.items[1];
		mainLayout=baseLayout.items[1];
		
		//cntnLayout = new dhtmlXLayoutObject(baseLayout.items[1], layout_2E);cntnLayout.items[0].setHeight(30);cntnLayout.items[0].fixSize(false, true);cntnLayout.items[0].hideHeader();cntnLayout.items[1].hideHeader();/*cntnLayout.items[0].attachObject("divCntnTop");*/
		//mainLayout=cntnLayout.items[1];
		//if($('#schTreeText').length>0){('#schTreeText').keypress(function(onkey){if(onkey.keyCode == 13){searchTreeText('1');}});}	
	}		
	function setLayoutUnload(isBase){if(isBase){if(typeof(baseLayout) != "undefined"){try{baseLayout.unload();}catch(e){}baseLayout = null;}}if(typeof(cntnLayout) != "undefined"){try{cntnLayout.unload();}catch(e){}cntnLayout = null;}if(typeof(mainLayout) != "undefined"){try{mainLayout.unload();}catch(e){}mainLayout = null;}}
	function setLayoutResize(){var minWidth=lMinWidth+rMinWidth;var lWidth=baseLayout.items[0].getWidth();var rWidth=baseLayout.items[1].getWidth();var wWidth=document.body.clientWidth;if(lWidth<lMinWidth){baseLayout.items[0].setWidth(lMinWidth);}if(wWidth >= minWidth && rWidth < rMinWidth){baseLayout.items[1].setWidth(rMinWidth);}}	
	olm.getMenuUrl=function(id){var ids = id.split("_");currItemId=ids[0];$('#MENU_ID').val(currItemId);document.menuFrm.action = "menuURL.do";document.menuFrm.target="blankFrame";document.menuFrm.submit();};
	var menuOption = "";	
	
	function creatMenuTab(id, menuURL, level){
		var fullId = "";var text = "";var url = menuURL;
		if(url == 'null' || url == ''){url = "setTabMenu.do?option="+menuOption+"&url="+menuURL+"&level="+level;if(id!="null" && id!=""){url=url+"&id="+id;}
		}olm.create_tab(id, fullId, text, url, true);
	}	
	olm.create_tab=function(id,fullId,text,url,isInclude){
		if(id == ""){id=menuOption;}fullId=id;var cntnTitle=""; if(olm.menuTree==null){cntnTitle=text;}else{cntnTitle=text||olm.menuTree.getItemText(id);}var fullText=$("#menuFullTitle").val();fullText=fullText + "&nbsp;>&nbsp;" + cntnTitle;
		//$("#cntnTitle").html("<span style=color:#333;font-size:12px;font-weight:bold;>&nbsp;&nbsp;"+fullText+"</span>");  /*제목 요기*/	
		if(!olm.url[fullId]){olm.url[fullId]=fullId+"^"+url;mainLayout.attachURL(url);}else{olm.url[fullId]=fullId+"^"+url;mainLayout.attachURL(url);}
		var ifr =mainLayout.getFrame();ifr.scrolling="no";
		getTreeSubItems();
	};			
	function getTreeSubItems(subItems){
		var itemId = "";if( subItems == 'undefined' || subItems == null){if( olm.menuTree != null){subItems = olm.menuTree.getSubItems(olm.menuTree.getSelectedItemId());}else{subItems = "";}}
		if( olm.menuTree != null){itemId = olm.menuTree.getSelectedItemId();}var url = "setSessionParameter.do";var target = "blankDiv";var data = "subItems="+subItems+"&ItemId="+itemId;ajaxPage(url, data, target);
	}	
	 function clickMainMenu(menuType, menuName, menuIcon, defDimValueID, menuStyle, scndMenuStyle, menuUrl, boardMgtID, mainType, tmplFilter, projectID, tmplType, refreshYN, s_itemID, scrnMode, visitLogYN){ 
		//alert("menuType : "+menuType+", menuName :"+menuName+"&tmplFilter="+tmplFilter);
		 var url="";var isChangeLayout=true;var layerType=layout_2E ;varFilter = tmplFilter;
		if(varFilter == undefined){varFilter = "";}
		if(mainType == undefined){mainType = "";}		
		if(defDimValueID == undefined){defDimValueID = "";}
		if(menuStyle == undefined || menuStyle ==""){menuStyle = "csh_grayprocess";}
		if(scndMenuStyle==undefined || scndMenuStyle==""){treeImgPath = menuStyle;}else{treeImgPath=scndMenuStyle;}
		$("#MENU_SELECT").val(menuType);		
		getTreeSubItems('');
		setTopIcon(menuType);
		if(boardMgtID == undefined || boardMgtID == ""){boardMgtID="";}
		if(projectID == undefined || projectID == ""){projectID="";}
		if( menuType == undefined || menuType == ""){alert("${CM00044}");
		}else if(menuType == "HOME"){ url = menuUrl+".do?languageID=${sessionScope.loginInfo.sessionCurrLangType}";name = "HOME";
		}else if(menuType == "BOARD"){changeCheck=false; url ="boardMgt.do"; if($("#cmbTempl").val()=="LY004"){url="boardAdminMgt.do";} url = url+"?boardMgtID="+boardMgtID;name = "게시판";
		}else if(menuType == "MYPAGE"){url = "myPage.do?noticType=4&srID=${srID}&mainType=" +mainType+"&myPageTmplFilter=${myPageTmplFilter}"; name = "MYPAGE";
		}else if(menuType == "HELP"){url = "mainHelpMainMenu.do?noticType=1";name = "HELP";
		}else if(menuType == "ServiceRequest"){url = "mainHomLayer_v2.do";name = "ServiceRequest";
		}else if(menuType == "TMPL_CHG_URL" || menuUrl!=".do?"){
			if(menuUrl != undefined){
				if(tmplType == "popUp"){fnGoProjectPop(menuUrl);return;
				}else{	url = menuUrl+"&arcCode="+menuType+"&menuStyle="+menuStyle+"&tmplFilter="+tmplFilter
							+"&ProjectID="+projectID+"&ProjectName="+projectName
							+"&gloProjectID="+$("#gloProjectID").val()+"&focusedItemID=${focusedItemID}"; 
				}
			}else{ url = menuUrl; }
		}else{ getCategory(menuType, defDimValueID);}	
		$("#gloProjectID").val('');
		if(url!=undefined && url.length > 0){goMenu(url, menuName, isChangeLayout, layerType, menuType);setInitControl(false, true, menuName, menuIcon);
		} else{setInitControl(true, true, menuName, menuIcon);}	
		
		if(visitLogYN == "Y"){
			fnSetVisitLog(menuType);
		}
	}
	function setUnfoldTreeMaster(){
		//varFilter="unfold=true";//unfold 테스트시 해당라인 주석 제거
		if(varFilter == undefined || varFilter == ""){return false;}var unfold = varFilter.match("unfold=true");if(unfold==null || unfold ==  undefined){return false;}
		if(olm.menuTree!=null){olm.menuTree.closeAllItems(0);var ch = olm.menuTree.hasChildren(0);for(var i=0; i<ch; i++){var lev1 = olm.menuTree.getChildItemIdByIndex(0,i);olm.menuTree.openItem(lev1);}}}
	function goMenu(url, name, isChangeLayout, layerType, menuType){if( isChangeLayout){setInitOneLayout(layerType);}setDisplayTopMenu(menuType);if(url=="null"){menuOption=$("#MENU_SELECT").val();creatMenuTab("",url,1);}else if( url.length > 0){ olm.create_tab(100, "", name, url, false);} }
	function getCategory(avg, defDimValueID){setInitTwoLayout();menuOption = avg;olm.menuTree.getSelectedItemId();olm.menuTree.deleteChildItems(0);var layerTypeHmBtn = $("#layerTypeHmBtn").val();var tmplProjectID = $("#tmplProjectID").val();var projectID = "";if(layerTypeHmBtn=="TMPL003"){projectID=tmplProjectID;}var data="projectID="+projectID;if(defDimValueID != ""){data="DefDimValueID="+defDimValueID+"&projectID="+projectID;}var d=fnSetMenuTreeData(data);fnLoadDhtmlxTreeJson(olm.menuTree, d.key, d.cols, d.data, avg);}
	function setDisplayTopMenu(menuType) {
	    var selectedId = "slidemenu0" + tmplCode;
	    $('.topSlideMenu').each(function() {
	        var menuId = $(this).attr('id');
	        classNm = $("#" + menuId).attr("classNm");
	        if (menuId == selectedId) {
	            $("#" + menuId).attr("style", "display:block");
// 	            $("#" + menuId).addClass(classNm);
	            var background = $("#" + menuId).css('background-color');
	            if (background != "") {
	                $("#menuRight").attr("style", "background:" + background + ";");
	            }
	            if (!isTempLoad[tmplCode]) {
	                jqueryslidemenu.buildmenu(menuId, arrowimages);
	                isTempLoad[tmplCode] = true;
	            }
	        } else {
	            $("#" + menuId).attr("style", "display:none;visibility:hidden;");
	            $("#" + menuId).removeClass(classNm);
	        }
	    });
	}	
	function setClearTopMenuStyle(){$('.topMenuBG').each(function(){$(this).removeClass('topMenuBG');$(this).attr("style","color:#FFFFFF;");});}
	function searchTreeText(type){var schText=$("#schTreeText").val();if(schText==""){alert("${WM00045}"); return false;}
		if(type=="1"){olm.menuTree.findItem(schText,0,1);}else if(type=="2"){olm.menuTree.findItem(schText);}else if(type=="3"){olm.menuTree.findItem(schText,1);}
	}	
	//function fnRefreshTree(itemId){var d = fnSetMenuTreeData();var noMsg = "";if(itemId == null || itemId == 'undefined' || itemId == "null"){itemId = olm.menuTree.getSelectedItemId();}currItemId = itemId;olm.menuTree.deleteChildItems(0);fnLoadDhtmlxTreeJson(olm.menuTree, d.key, d.cols, d.data, menuOption,noMsg);olm.menuTree.setOnLoadingEnd(setLoadingEndTree);}	
	//function fnRefreshTreeOnly(itemId){var d = fnSetMenuTreeData();var noMsg = "";if(itemId == null || itemId == 'undefined' || itemId == "null"){itemId = olm.menuTree.getSelectedItemId();}currItemId = itemId;olm.menuTree.deleteChildItems(0);fnLoadDhtmlxTreeJson(olm.menuTree, d.key, d.cols, d.data, menuOption,noMsg);}
	function fnRefreshTree(itemId,isReload){var d = fnSetMenuTreeData();var noMsg = "";if(isReload == null || isReload == 'undefined' || isReload == "null"){isReload=false;}if(itemId == null || itemId == 'undefined' || itemId == "null"){itemId = olm.menuTree.getSelectedItemId();}currItemId = itemId;olm.menuTree.deleteChildItems(0);fnLoadDhtmlxTreeJson(olm.menuTree, d.key, d.cols, d.data, menuOption,noMsg);
		if(isReload){olm.menuTree.setOnLoadingEnd(setLoadingEndTree);}
	}
	function setLoadingEndTree(prtItemId){if(prtItemId == null || prtItemId == 'undefined'){ prtItemId = 1;}olm.menuTree.openItem(prtItemId);if(currItemId == null || currItemId == 'undefined'){return false;}else{olm.menuTree.selectItem(currItemId,true,false);}}	

	function fnChangePwd(){
		var url = "openchangePwdPop.do?userID=${sessionScope.loginInfo.sessionUserId}";
		var w = 500;
		var h = 300;
		itmInfoPopup(url,w,h);
	}	
	
	function fnGoProjectPop(url){
		//var url = "goProjectPop.do";
		var option = "dialogWidth:450px; dialogHeight:600px; scroll:yes";
	    window.showModalDialog(url, self, option);
	}

	function fnHideTopMenu() {
		var tempSrc = $("#hideMenu").attr("src");
		if($("#hideMenu").hasClass("show")) {
			$("#topsection").hide();
			$("#hideMenu").attr("class","hide");
			$("#hideMenu").attr("title","hide");
			$("#hideMenu").attr("src",tempSrc.replace("icon_hide","icon_show"));
			setScreenResize(75);
		}
		else {
			$("#topsection").show();
			$("#hideMenu").attr("class","show");
			$("#hideMenu").attr("title","show");
			$("#hideMenu").attr("src",tempSrc.replace("icon_show","icon_hide"));
			setScreenResize(115);
		}
	}
	
	function fnSetVisitLog(arcCode){
		var url = "setVisitLog.do";
		var target = "blankDiv";
		var data = "ActionType=ARCMN&MenuID="+arcCode;
		ajaxPage(url, data, target);
	}
	    
</script>
</head>
<body class="animsition dashboard">
<!-- Core  -->
<script src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/modernizr-2.6.2.js"></script>

<!-- Plugins -->
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/babel-external-helpers.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/jquery.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/tether.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/bootstrap.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/bootstrap-select.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/animsition.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/jquery.mousewheel.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/jquery-asScrollbar.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/jquery-asScrollable.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/jquery-asHoverScroll.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/switchery.min.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/intro.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/screenfull.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/jquery-slidePanel.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/skycons.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/jquery-asPieProgress.min.js"></script>

<!-- Scripts -->
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/State.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/Component.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/Plugin.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/Base.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/Config.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/colors.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/Menubar.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/GridMenu.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/Sidebar.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/PageAside.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/menu.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/tour.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/Site.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/v1.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/jvectormap.js"></script>
<script type="text/javascript" src="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/js/breakpoints.js"></script>

<!--[if lt IE 8]>
        <p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
<![endif]-->

<input type="hidden" id="menuFullTitle"></input>
<input type="hidden" id="TemplCode" name="TemplCode"></input>
<input type="hidden" id="layerTypeHmBtn" name="layerTypeHmBtn" >
<input type="hidden" id="layerTextHmBtn" name="layerTextHmBtn" >
<input type="hidden" id="mainUrlHmBtn" name="mainUrlHmBtn" >
<input type="hidden" id="mainScnTextHmBtn" name="mainScnTextHmBtn" >
<input type="hidden" id="mainUrlFilterHmBtn" name="mainUrlFilterHmBtn" >
<input type="hidden" id="tmplFilterHmBtn" name="tmplFilterHmBtn" >
<input type="hidden" id="tmplProjectID" name="tmplProjectID" >
<input type="hidden" id="mainType" name="mainType" value="${mainType}" >
<input type="hidden" id="screenType" name="screenType" value="${screenType}" >
<input type="hidden" id="sysCode" name="sysCode" value="${sysCode}" >
<input type="hidden" id="gloProjectID" name="gloProjectID" value="${gloProjectID}" >
<div id="maincontainer">

<!-- BEGIN ::: TOP -->
<form name="menuFrm" id="menuFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="MENU_URL" name="MENU_URL"></input>
	<input type="hidden" id="MENU_ID" name="MENU_ID"></input>
	<input type="hidden" id="MENU_SELECT" name="MENU_SELECT"></input>
</form>	

<nav class="site-navbar navbar navbar-default navbar-fixed-top navbar-mega" role="navigation">
	<div class="navbar-header">
		<div class="navbar-brand navbar-brand-center site-gridmenu-toggle" data-toggle="gridmenu">
			<li alt="HOME" class="logo"><img src="${root}${HTML_IMG_DIR}/logo_black.png" width="180"></li>
		</div>
	</div>
	<div class="navbar-container container-fluid">
		<div class="row collapse navbar-collapse navbar-collapse-toolbar" id="site-navbar-collapse">
			<c:choose>
				<c:when test="${templCode == ''}">
					<div id="slidemenu01" class="slidemenu" style="display:block"></div>
				</c:when>
				<c:otherwise>
					<c:forEach var="templ" items="${templList}" varStatus="status">
						<div id="slidemenu0${templ.TemplCode}" class="topSlideMenu" classNm="${templ.Style}" 
							<c:if test="${status.first}">style="display:block"</c:if>
							<c:if test="${!status.first}">style="display:none;visibility:hidden;"</c:if>
						>
		                <c:forEach var="mainMenu" items="${mainMenuList}" varStatus="status" >
							<c:if test="${templ.TemplCode == mainMenu.TemplCode}">
								<c:choose>
									<c:when test="${mainMenu.CHILD_MENT_CNT > 0}">
										<div class="nav navbar-toolbar navbar-left navbar-toolbar-left">
											<a class="nav-link" data-toggle="dropdown" href="#" aria-expanded="false" data-animation="drop-down" role="button" alt="${mainMenu.MENU_NM}" id="${mainMenu.MENU_NM}">${mainMenu.MENU_NM}</a>
											<!--  <div class="dropdown-menu" role="menu">
												<c:forEach var="scnMenu" items="${scnMenuList}" varStatus="status" >
													<c:if test="${mainMenu.MENU_ID == scnMenu.PRNT_MENU_ID}">
														<c:if test="${scnMenu.DimTypeID != '0'}">
															<li>
																<a class="dropdown-item" href="javascript:void(0)" role="menuitem" alt="${scnMenu.MENU_NM}">${scnMenu.MENU_NM}</a>
																<c:forEach var="thdMenu" items="${thdMenuList}" varStatus="status" >
																	<c:if test="${scnMenu.MENU_ID == thdMenu.PRNT_MENU_ID}">
																		<li onclick="clickMainMenu('${thdMenu.PRNT_MENU_ID}','${mainMenu.MENU_NM}','${mainMenu.ICON}', '${thdMenu.DefDimValueID}','${mainMenu.STYLE}','${scnMenu.STYLE}','${thdMenu.URL}.do?${thdMenu.FILTER}','','','','','','','','','Y')">
																			<a href="#" alt="${thdMenu.MENU_NM}">${thdMenu.MENU_NM}</a>
																		</li>
																	</c:if>
																</c:forEach>
															</li>
														</c:if>
														<c:if test="${scnMenu.DimTypeID == '0'}">
															<li onclick="clickMainMenu('${scnMenu.MENU_ID}','${mainMenu.MENU_NM}&nbsp;::&nbsp;${scnMenu.MENU_NM}','${mainMenu.ICON}','','${mainMenu.STYLE}','${scnMenu.STYLE}','${scnMenu.URL}.do?${scnMenu.FILTER}','','','','','','','','','Y')">
																<a class="dropdown-item" href="javascript:void(0)" role="menuitem" alt="${scnMenu.MENU_NM}">${scnMenu.MENU_NM}</a>
															</li>
														</c:if>
													</c:if>
												</c:forEach>
											</div>	 -->
										</div>
									</c:when>
									<c:otherwise>
										<div class="nav navbar-toolbar navbar-left navbar-toolbar-left" >
											<li onclick="clickMainMenu('${mainMenu.MENU_ID}','${mainMenu.MENU_NM}','${mainMenu.ICON}','','${mainMenu.STYLE}','','${mainMenu.URL}.do?${mainMenu.FILTER}','','','','','','','','','Y')">
										    	<a class="nav-link" href="#" aria-expanded="false" role="button" alt="${mainMenu.MENU_NM}" id="${mainMenu.MENU_NM}">${mainMenu.MENU_NM}</a>
										    </li>
									   	</div>
									</c:otherwise>
								</c:choose>
							</c:if>
						</c:forEach>
		            </div>
				</c:forEach>
			</c:otherwise>
		</c:choose>
		
		<div class="nav navbar-toolbar navbar-right navbar-toolbar-right">
			<form name="langFrm" id="langFrm" action="#" method="post" onsubmit="return false;"></form>			
			<c:if test="${loginIdx == 'BASE'}" >
		    	<a style="cursor:pointer;" class="nav-link navbar-avatar" data-toggle="dropdown" OnClick="fnChangePwd();" alt="USER" title="USER" aria-expanded="false" data-animation="scale-up" role="button">
		        	<i class="icon wb-user" aria-hidden="true" style="margin-right:6px;"></i>${sessionScope.loginInfo.sessionUserNm} 님
		        </a>
			</c:if>
			<c:if test="${loginIdx != 'BASE'}" >
				<a style="cursor:pointer;" class="nav-link navbar-avatar" data-toggle="dropdown" alt="USER" title="USER" aria-expanded="false" data-animation="scale-up" role="button">
		   		 	<i class="icon wb-user" aria-hidden="true" style="margin-right:6px;"></i>${sessionScope.loginInfo.sessionUserNm} 님
		        </a>
			</c:if> 
		    <div class="dropdown-menu" role="menu" style="right:5px;">
		    	<c:if test="${sessionScope.loginInfo.sessionMlvl != 'VIEWER' }">
		        	<form name="templFrm" id="templFrm" action="#" method="post" onsubmit="return false;">
		            	<c:forEach var="templ" items="${templList}" varStatus="status" >							
							<li onclick="openInNewTab('${templ.TemplCode}','${templ.TemplText}','${templ.MainURL}','${templ.MainScnText}','${templ.URLFilter}','${templ.TmplFilter}','','${templ.TmplType}');" <c:if test="${templ.Invisible=='1'}" >style="display:none;"</c:if>>
								<a class="dropdown-item" role="menuitem" href="#" alt="${templ.TemplText}" id="${templ.TemplCode}"><i class="icon wb-link" aria-hidden="true"></i>${templ.TemplText}</a>
								<script type="text/javascript">isTempLoad['${templ.TemplCode}']=false;</script>
							</li>								
						</c:forEach>
		            </form>
		            <div class="dropdown-divider" role="presentation"></div>
		        </c:if>
		        <a class="dropdown-item logout" href="javascript:void(0)" role="menuitem"><i class="icon wb-power" aria-hidden="true"></i>Logout</a>
		    </div>
		</div>
		              
		<!-- div class="nav navbar-toolbar navbar-right navbar-toolbar-right">
			<a style="cursor:pointer;"" class="nav-link navbar-avatar" data-toggle="dropdown" aria-expanded="false" data-animation="scale-up" role="button">
		    	<span id="">Quick menu</span>	
		    </a>
			<div class="dropdown-menu" role="menu">
					<c:forEach var="topMenu" items="${topMenuList}" varStatus="status" >	
						<c:if test="${status.index < 4 }">						
						<li onclick="clickMainMenu('${topMenu.MenuID}','${topMenu.Name}','','','','','${topMenu.URL}.do?${topMenu.FILTER}')">
							<a class="dropdown-item" role="menuitem" href="#" alt="${topMenu.MenuID}" id="${topMenu.Name}"><i class="icon wb-link" aria-hidden="true"></i>${topMenu.Name}</a>
						</li>		
						</c:if>						
					</c:forEach>      	
			</div>
		</div> -->  
		<div class="nav navbar-toolbar navbar-right navbar-toolbar-right">
			<a style="cursor:pointer;"" class="nav-link navbar-avatar" data-toggle="dropdown" aria-expanded="false" data-animation="scale-up" role="button">
		    	<span id="pjtTemplate">${projectTxt}</span>	
		    </a>
			<div class="dropdown-menu" role="menu">
				<c:if test="${sessionScope.loginInfo.sessionMlvl != 'VIEWER' }">
					<form name="pjtFrm" id="pjtFrm" action="#" method="post" onsubmit="return false;">
						<c:forEach var="pjt" items="${pjtList}" varStatus="statusys" >							
							<li onclick="changePjt('${pjt.ProjectID}');" <c:if test="${pjt.Deactivated=='1'}" >style="display:none;"</c:if>>
								<a class="dropdown-item" role="menuitem" href="#" alt="${pjt.ProjectName}" id="${pjt.ProjectName}"><i class="icon wb-link" aria-hidden="true"></i>${pjt.ProjectCode} ${pjt.ProjectName}</a>
							</li>								
						</c:forEach>
				    </form>
				</c:if>		                	
			</div>
		</div>     
		</div>
	</div>
</nav>
	
	<!-- BEGIN ::: CONTENTS -->
	<div id="contentwrapper">		
		<div id="contentcolumn" class="nonecontentcolumn">		
			<div class="page" id="container" scrolling='no'>
				<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none;overflow:hidden;" frameborder="0"></iframe>
			 </div>
			<div id="divCntn" ></div>
		</div>
	</div>	
	<!-- END ::: CONTENTS -->
	
	
</div>	
<div id="blankDiv"></div>

    
<!-- Loader Sample --->
    <div style="padding: 20px; display: block;" id="iexcel_loading">
        <div id='iloding' name='iloding' style='padding: 10px; text-align: center;'>
            <div style='display: inline-block;'>
                <div class="loader-container">
                    <div class="loader-wrap">
                        <div class="loader vertical-align-middle loader-circle" data-type="default"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>setTimeout(function () { $("#iexcel_loading").hide();},1000);</script>
    
</body>
</html>