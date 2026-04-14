<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:url value="/" var="root" />


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<c:set value='<%=request.getParameter("retfnc")%>' var="retfnc" />
<%
String userIP = request.getHeader("X-FORWARDED-FOR");
if (userIP == null)
	userIP = request.getRemoteAddr();

SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
Date today = new Date();

String nowTime = format1.format(today);
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta>
<!--[if gte IE 8]><meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8"></meta><![endif]-->
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7; charset=utf-8"></meta>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00098" var="WM00098" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00044" var="CM00044" />

<script>function closeLoading(){$("#resultDiv").html('');$("#loading").fadeOut(50);}</script>
<c:if test="${!empty htmlTitle}">
	<script>parent.document.title="${htmlTitle}";</script>
</c:if>
<script type="text/javascript">
var defaultLang = <%=GlobalVal.DEFAULT_LANGUAGE%>;var defaultLangCode = "<%=GlobalVal.DEFAULT_LANG_CODE%>";var atchUrl = "<%=GlobalVal.BASE_ATCH_URL%>";
</script>
<!-- 1. Include JSP -->
<tiles:insertAttribute name="tagInc" />
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<%@ include file="/WEB-INF/jsp/template/autoCompText.jsp"%>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css" />
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<script type="text/javascript" src="${root}cmm/js/xbolt/lovCssHelper.js"></script>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<style>
#searchType {
	display: inline-block;
}

#searchType select {
	width: 100px;
	border: none;
	height: 26px;
	padding-left: 13px;
	background-position: 87%;
	background-size: 7px;
	-webkit-appearance: none;
	background-color: #f3f4f9;
	border-radius: 30px;
	position: relative;
	right: -17px;
}

#searchContents {
	background: #fff;
	position: relative;
	width: 0px;
	height: 30px;
	left: 52px;
}

#searchContents.open {
	width: 343px;
}

#searchContents #mainSearchValue {
	color: #444;
	position: relative;
	overflow: hidden;
	border: none;
	background: none;
	width: calc(100% - 35px);
	box-sizing: border-box;
	padding-left: 10px;
	height: inherit;
	text-overflow: ellipsis;
	font-size: 14px;
}

#searchContents #mainSearchValue::placeholder {
	color: #ccc;
}

#searchContents #mainSearchValue:-ms-input-placeholder {
	color: #ccc;
}

#searchContents #btnMainSearch {
	position: absolute;
	right: 8px;
	top: 2px;
	border: 0;
	background: none;
	cursor: pointer;
	width: 0;
}

#searchContents #close {
	position: absolute;
	width: 0;
	top: 5px;
	left: -25px;
}

#searchContents.open #btnMainSearch {
	width: 24px;
}

#searchContents.open #close {
	width: 20px;
}
</style>
<script type="text/javascript">
	var favicon = "favicon";
	
	var olm={};
	olm.url={};
	var baseLayout;
	var cntnLayout;
	var menuTreeLayout;
	var treeImgPath="";
	var topMenuCnt={};
	var currItemId="";
	var mainLayout;
	var tmplCode="";
	var isTempLoad={};
	var varFilter="";
	
	window.onload=setInit;
	jQuery(document).ready(function() {
		var lang_style="width:"+"${tmpTextMaxLng}"+"px;"; var cmpny_style="width:"+"${cmpnyTextMaxLng}"+"px";
// 		fnChangeLangComboStyle(lang_style);
// 		fnChangeCmpnyComboStyle(cmpny_style);
		
		// IP CHECK
// 		if("${tmplFilter}".indexOf("ipCheck=Y") > -1){
// 			checkIP("${templCode}","main");
// 		}
		
		$('.logo').click(function(){
        	setClearTopMenuStyle();
	        $("#cmbTempl").val("${templCode}");changeTempl("${templCode}","${templText}","${mainURL}","","${mainUrlFilter}","${tmplFilter}");
		});
		 		 
//         $('.home').click(function(){ 
//         	var layerTypeHmBtn = $("#layerTypeHmBtn").val();
// 			var layerTextHmBtn = $("#layerTextHmBtn").val();
// 			var mainUrlHmBtn = $("#mainUrlHmBtn").val();
// 			var mainScnTextHmBtn =  $("#mainScnTextHmBtn").val();
// 			var mainUrlFilterHmBtn = $("#mainUrlFilterHmBtn").val();
// 			var tmplFilterHmBtn = $("#tmplFilterHmBtn").val();
// 			var tmplProjectID = $("#tmplProjectID").val();
          		
//        		$("#cmbTempl").val($("#layerTypeHmBtn").val());
//        		changeTempl(layerTypeHmBtn,layerTextHmBtn,mainUrlHmBtn,mainScnTextHmBtn,mainUrlFilterHmBtn,tmplFilterHmBtn,tmplProjectID); 
//         });
        
// 		$('.help').click(function(){
// 			var meunNm=$(this).attr('alt');
// 			var title=$(this).attr('title');
// 			clickMainMenu(meunNm, title);
// 			setTopIcon(meunNm);
// 			setClearTopMenuStyle();
// 		});
		
		$('.myPage').click(function(){
			clickMainMenu("MYPAGE", "MYPAGE");
// 			setTopIcon(meunNm);
			setClearTopMenuStyle();
		});
		
// 		$('.serviceRequest').click(function(){
// 			var meunNm=$(this).attr('alt');
// 			var title=$(this).attr('title');
// 			clickMainMenu(meunNm, title);
// 			setTopIcon(meunNm);
			
// 			var layerTypeHmBtn ="SRM";
// 			var layerTextHmBtn = "Service Request";
// 			var mainUrlHmBtn = "mainHomLayer_v2";
// 			var mainScnTextHmBtn = "MAIN";
// 			var mainUrlFilterHmBtn = "";
			
// 		    $("#layerTypeHmBtn").val(layerTypeHmBtn);
// 			$("#layerTextHmBtn").val(layerTextHmBtn);
// 			$("#mainUrlHmBtn").val(mainUrlHmBtn);
// 			$("#mainScnTextHmBtn").val(mainScnTextHmBtn);
// 			$("#mainUrlFilterHmBtn").val(mainUrlFilterHmBtn); 
			
// 			$("#cmbTempl").val($("#layerTypeHmBtn").val());
// 			fnSetServiceRequest(layerTypeHmBtn,layerTextHmBtn,mainUrlHmBtn,mainScnTextHmBtn,mainUrlFilterHmBtn); 
// 		});
		
// 		$('.logout').click(function(){logout();});
// 		$('.topIcon').click(function(){var meunNm = $(this).attr('alt');var title = $(this).attr('title');clickMainMenu(meunNm, title);setTopIcon(meunNm);setClearTopMenuStyle();});

		$("#mainSearchValue").keyup(function() {
			if(event.keyCode == '13') {
				fnMainSearch();
				setClearTopMenuStyle();
			}
		});		
		
		var footerHtml =    '<div style="float:left;margin-top:5px;">'+
        '    <p class="user_info-out">USER IP : <%=userIP%> Login Date : <%=nowTime%> USER Info : [${sessionScope.loginInfo.sessionLoginId}] ${sessionScope.loginInfo.sessionUserNm}</p>'+
        '</div>';
       
		$('#footersection').prepend(footerHtml);
		
		setInitOneLayout();
		autoComplete("mainSearchValue", "AT00001", "", "", "", 5, "top");
	});

    function fnMainSearch(){
    	setClearTopMenuStyle();
		var searchValue = encodeURIComponent($("#mainSearchValue").val());
    	var url = "searchItemWFile.do?"; 
    	var data = "searchValue="+searchValue; 
    	clickMainMenu('MN172','','','','','', url+data);
    }
    
// 	function fnSetServiceRequest(layerType,layerText, mainUrl, mainScnText, mainUrlFilter) { 
// 	 	if(layerType==null||layerType==undefined){
// 			layerType="${templCode}";
// 		}else{
// 			$("#layerTypeHmBtn").val(layerType);
// 			$("#layerTextHmBtn").val(layerText);
// 			$("#mainUrlHmBtn").val(mainUrl);
// 			$("#mainScnTextHmBtn").val(mainScnText);
// 			$("#mainUrlFilterHmBtn").val(mainUrlFilter);
// 			layerType = $("#layerTypeHmBtn").val();
// 		} 

// 		//if(layerText==null||layerText== undefined){layerText="${templText}";}
// 		//$("#cmbTemplate").html(layerText);
// 		tmplCode=layerType;
// 		ajaxSubmitNoAdd(document.langFrm, "templateSetting.do?templCode="+tmplCode, "blankFrame");
// 		setTopIcon("");
// 	    setInitMenu(false,true);
// 		var menuIcon=""; var defDimValueID=""; var menuStyle=""; var scndMenuStyle=""; mainUrl+=".do?"+mainUrlFilter;
// 		clickMainMenu("TMPL_CHG_URL", mainScnText, menuIcon, defDimValueID, menuStyle, scndMenuStyle, mainUrl);
// 	}
	
	function setInit(){
// 		console.log("setInit")
		var arcLinkYN = "N";
		if("${mainType}" == "arcLink"){
			arcLinkYN = "Y";
		}
// 		if(window.attachEvent) window.attachEvent("onresize",resizeLayout);
// 		else window.addEventListener("resize",resizeLayout, false);
		var t;
// 		function resizeLayout(){window.clearTimeout(t);
// 		t=window.setTimeout(function(){setScreenResize();},200);}
		changeTempl('${templCode}','${templText}','${mainURL}','${mainScnText}','${mainUrlFilter}','${tmplFilter}','${projectID}','',arcLinkYN,'${mainType}');
        var ntcCnt=parseInt('${ntcCnt}');
        var cookieId="sfolmLdNtc_"+"${BoardID}";
        var isNtc=getCookie(cookieId);
        if(isNtc==undefined){isNtc=false;}/*isNtc = false;*/
        if(isNtc==false&&ntcCnt>0){
        	var url="boardAlarmPop.do";
        	//var data="";
        	var data="languageID=${sessionScope.loginInfo.sessionCurrLangType}&templCode={templCode}";
        	fnOpenLayerPopup(url,data,"",600,300);/*openPopup(url,400,400,"new");*/
        }
	}	
	
// // 	function setScreenResize(h){if(h == null || h == undefined) h = 90; var clientHeight=document.body.clientHeight;document.getElementById("container").style.height = (clientHeight - (h)) + "px";if( baseLayout==null){if(cntnLayout!=null && cntnLayout!=undefined){cntnLayout.setSizes();}}else{var minWidth=lMinWidth+rMinWidth;var wWidth=document.body.clientWidth;if(minWidth>wWidth){baseLayout.items[0].setWidth(lMinWidth);} baseLayout.setSizes();}}
// 	function setInitMenu(isLeft, isMain){
// 		if(isMain){
// 			$("#menusection").attr("style","display:block;");
// 		}else{
// 			$("#menusection").attr("style","display:none;");
// 		}
// // 		setScreenResize();
// 	}
	function changeLanguage(langType,langText) {if(langText==null||langText==undefined){langText="${sessionScope.loginInfo.sessionCurrLangNm}";}$("#cmbLanguage").html(langText);ajaxSubmitNoAdd(document.langFrm, "languageSetting.do?LANGUAGE="+langType+"&NAME="+langText, "blankFrame");}
	
	function doReturnLanguage(){
		location.href="mainpage.do?loginIdx=${loginIdx}&screenType=${screenType}&srID=${srID}&mainType=${mainType}&sysCode=${sysCode}&status=${status}"
					+ "&defTemplateCode=${defTemplateCode}"
					+ "&defArcCode=${defArcCode}";
	}
	
	function changeTempl(layerType,layerText, mainUrl, mainScnText, mainUrlFilter, tmplFilter, tmplProjectID, tmplType, arcLinkYN, mainType) {
// 		console.log("changeTempl")
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
		
		if(tmplCode == "TMPL001") favicon = "favicon_PAL";
		if(tmplCode == "TMPL002") favicon = "favicon_ITS";
		if(tmplCode == "TMPL003") favicon = "favicon_PCM";
		if(tmplCode == "ADMIN") favicon = "favicon_SYS";
		
		var parent = window.parent.document;
		var link = parent.querySelector("link[rel*='icon']");
		if(link) {
			link.type = 'image/x-icon';
		    link.rel = 'shortcut icon';
		    link.href = '${pageContext.request.contextPath}/'+favicon+'.ico';
		} else {
			link = document.createElement("link");
			link.type = 'image/x-icon';
		    link.rel = 'shortcut icon';
		    link.href = '${pageContext.request.contextPath}/'+favicon+'.ico';
		    document.getElementsByTagName('head')[0].appendChild(link);
		}
	    
// 		setTopIcon("");
// 		if(layerType == "TMPL999"){setInitMenu(false,false);}else{setInitMenu(false,true);}
		var menuIcon=""; var defDimValueID=""; var menuStyle=""; var scndMenuStyle=""; mainUrl+=".do?"+mainUrlFilter;
		var menuType = "TMPL_CHG_URL";

		if(arcLinkYN == "Y"){
			menuType = "${arcCode}"; 
			mainScnText = "${arcLinkName}"; 			
			defDimValueID = "${arcLinkDimTypeID}";
			mainUrl = "${arcLinkURL}.do?${arcLinkFILTER}";
			menuStyle = "${arcLinkSTYLE}";
		}

		if(mainType == "mySRDtl" || mainType == "myWFDtl"){
			clickMainMenu("MYPAGE","MYPAGE", "", "", "", "", "", "", mainType);			
		} else if(mainType == "myWF"){ // SR바로접속 Link My page >> To do list >> Service request (Def = 진행 중)
			clickMainMenu("MYPAGE","MYPAGE", "", "", "", "", "", "", "myWF"); $("#mainType").val("");
		}
		else if(mainType == "SRDtlView"){
			clickMainMenu("SRREQ","SRREQ", "", "", "", "", "srMgt.do?srType=ITSP&screenType=srRqst&mainType=${mainType}&srID=${srID}");
		}else{
			clickMainMenu(menuType, mainScnText, menuIcon, defDimValueID, menuStyle, scndMenuStyle, mainUrl,"","", tmplFilter, tmplProjectID, tmplType,"","","");
		}
	}
	
	function openInNewTab(layerType,layerText, mainUrl, mainScnText, mainUrlFilter, tmplFilter, tmplProjectID, tmplType, mainType) {
		// IP CHECK
		var result = "true";
		if(tmplFilter.indexOf("ipCheck=Y") > -1){
			checkIP(layerType,"btn");
		} else {
			window.open("mainpage.do?loginIdx=${loginIdx}&s_templCode="+layerType,layerType);
		}
	}
	
	// IP CHECK
	function checkIP(layerType,type){
		$.ajax({
			url:"checkIPforTmpl.do",
			type:"POST",
			async: false,
			success: function(data){
				if(data.result != "true") {
					alert("This is not the IP of a registered administrator!");
					if(type == "btn"){
						return false;
					}else{
						var ret = window.open("about:blank", "_self");
						ret.close();
					}
				} else {
					if(type == "btn"){
						window.open("mainpage.do?loginIdx=${loginIdx}&s_templCode="+layerType,layerType);
					}
				}
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
	}
	
	function changeCmpny(cmpnyType){
		ajaxSubmitNoAdd(document.cmpnyFrm, "companySetting.do?cmpnyCode="+cmpnyType, "blankFrame");
	}
	function fnSetTemplate(val){
		alert(val);
	}
	function setTopIcon(menuNm) {$('.topIcon').each(function(){if($(this).attr('alt') == menuNm) {$(this).addClass('on');} else {$(this).removeClass('on');}});}	
// 	function fnCallLanguage(){return '${sessionScope.loginInfo.sessionCurrLangType}';}		
// 	function fnCallTreeInfo(){var treeInfo = new Object(); treeInfo.data=olm.menuTree.serializeTreeToJSON(); treeInfo.imgPath=treeImgPath; return treeInfo;}	
	function setInitControl(isSchText, isSchURL, menuName, menuIcon){		
// 		console.log("setInitControl")
		if(menuName == undefined) menuName = "";
		if(menuIcon == undefined || menuIcon == "") menuIcon = "icon_home.png";
		elsemenuIcon = "root_" +menuIcon;
		var fullText = "<img src='${root}${HTML_IMG_DIR}/"+menuIcon+"'>&nbsp;&nbsp;"+menuName;
		$("#menuFullTitle").val(fullText);
		if(isSchText){if($('#schTreeText').length>0){$('#schTreeText').val('');}}		
		if(isSchURL) olm.url={};
	}
// 	function logout() {
// 		var loginIdx = "${loginIdx}";
// 		if(loginIdx == "BASE"){
// 			ajaxSubmitNoAdd(document.menuFrm, "<c:url value='/login/logout.do'/>", "blankFrame");
// 		}else{
// 			top.window.open('about:blank','_self').close(); 
// 			top.window.opener=self;
// 			top.self.close(); 
// 		}
// 	}
// 	function fnCheckedDuplicateLogin(activLoginIp) {
// 		if(typeof(opener)) {
// 			opener.parent.fnCheckedDuplicateLoginOpener(activLoginIp);self.close();
// 		}else{
// 			parent.fnCheckedDuplicateLogin(activLoginIp);
// 		}
// 	}
	function fnLoginForm() {parent.fnLoginForm();}
	function setInitOneLayout(viewType){
// 		console.log("setInitOneLayout");
// 		setLayoutUnload(false);
// 		cntnLayout = new dhtmlXLayoutObject("container",layout_1C);
// 		cntnLayout.items[0].hideHeader();
// 		mainLayout=cntnLayout.items[0];		

		cntnLayout = new dhx.Layout("main-layout", {
			rows: [
		        {
		            id: "main-container",
		        },
		    ]
		});
		mainLayout = cntnLayout.getCell("main-container");
		
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
	function setLayoutUnload(isBase){
		if(isBase){
			if(typeof(baseLayout) != "undefined"){
				try{
					baseLayout.unload();
				}catch(e){
					
				}
				baseLayout = null;
			}
		}
		
		if(typeof(cntnLayout) != "undefined"){
			try{
				cntnLayout.unload();
			}
			catch(e){
				
			}
			
			cntnLayout = null;
		}
		
		if(typeof(mainLayout) != "undefined"){
			try{
				mainLayout.unload();
			}catch(e){
				
			}
			mainLayout = null;
		}
	}
	
	function setLayoutResize(){var minWidth=lMinWidth+rMinWidth;var lWidth=baseLayout.items[0].getWidth();var rWidth=baseLayout.items[1].getWidth();var wWidth=document.body.clientWidth;if(lWidth<lMinWidth){baseLayout.items[0].setWidth(lMinWidth);}if(wWidth >= minWidth && rWidth < rMinWidth){baseLayout.items[1].setWidth(rMinWidth);}}	
	olm.getMenuUrl=function(id){var ids = id.split("_");currItemId=ids[0];$('#MENU_ID').val(currItemId);document.menuFrm.action = "menuURL.do";document.menuFrm.target="blankFrame";document.menuFrm.submit();};
	var menuOption = "";	
	
	function creatMenuTab(id, menuURL, level){
		var fullId = "";var text = "";var url = menuURL;
		if(url == 'null' || url == ''){url = "setTabMenu.do?option="+menuOption+"&url="+menuURL+"&level="+level;if(id!="null" && id!=""){url=url+"&id="+id;}
		}olm.create_tab(id, fullId, text, url, true);
	}	
	olm.create_tab=function(id,fullId,text,url,isInclude){
		const cacheBuster = "t=" + new Date().getTime();
		const newUrl = url.includes("?") ? url + "&"+cacheBuster : url + "?"+cacheBuster;
		
		var templCode = $("#layerTypeHmBtn").val(); url += "&templCode="+templCode;
		if(id == ""){id=menuOption;}fullId=id;var cntnTitle=""; if(olm.menuTree==null){cntnTitle=text;}else{cntnTitle=text||olm.menuTree.getItemText(id);}var fullText=$("#menuFullTitle").val();fullText=fullText + "&nbsp;>&nbsp;" + cntnTitle;
		//$("#cntnTitle").html("<span style=color:#333;font-size:12px;font-weight:bold;>&nbsp;&nbsp;"+fullText+"</span>");  /*제목 요기*/	
		
		if(!olm.url[fullId]){
// 			olm.url[fullId]=fullId+"^"+url;
// 			mainLayout.attachURL(url);
			mainLayout.attachHTML("<iframe height=100% width=100% style='border: none;' src="+newUrl+"></ifame>")
		}else{
			olm.url[fullId]=fullId+"^"+url;
// 			mainLayout.attachURL(url);
			mainLayout.attachHTML("<iframe height=100% width=100% style='border: none;' src="+newUrl+"></ifame>")
		}
// 		var ifr =mainLayout.getFrame();ifr.scrolling="no";
		getTreeSubItems();
	};			
	function getTreeSubItems(subItems){
		var itemId = "";if( subItems == 'undefined' || subItems == null){if( olm.menuTree != null){subItems = olm.menuTree.getSubItems(olm.menuTree.getSelectedItemId());}else{subItems = "";}}
		if( olm.menuTree != null){itemId = olm.menuTree.getSelectedItemId();}var url = "setSessionParameter.do";var target = "blankDiv";var data = "subItems="+subItems+"&ItemId="+itemId;ajaxPage(url, data, target);
	}	
	 function clickMainMenu(menuType, menuName, menuIcon, defDimValueID, menuStyle, scndMenuStyle, menuUrl, boardMgtID, mainType, tmplFilter, projectID, tmplType, refreshYN, s_itemID, scrnMode, visitLogYN, MenuID){
		if(document.querySelector(".gnb .menu.selected")) document.querySelectorAll(".gnb .menu").forEach(e => e.classList?.remove("selected"));
// 		console.log("menuType : "+menuType+", menuName :"+menuName+"&tmplFilter="+tmplFilter+", mainType :"+mainType+", menuUrl  :"+menuUrl+", visitLogYN:"+visitLogYN);
		if(s_itemID == undefined){ s_itemID = ""; }
		if(refreshYN == 'Y'){ menuUrl = $("#menuUrl").val() + "&s_itemID="+s_itemID+"&scrnMode="+scrnMode; }else{ $("#menuUrl").val(menuUrl); }
		var url="";var isChangeLayout=true;var layerType=layout_2E ;varFilter = tmplFilter;
		if(varFilter == undefined){varFilter = "";}
		if(mainType == undefined){mainType = "";}		
		if(defDimValueID == undefined){defDimValueID = "";}
		if(menuStyle == undefined || menuStyle ==""){menuStyle = "csh_process";}
		if(scndMenuStyle==undefined || scndMenuStyle==""){treeImgPath = menuStyle;}else{treeImgPath=scndMenuStyle;}
		$("#MENU_SELECT").val(menuType);		
		getTreeSubItems('');
		setTopIcon(menuType);
		if(boardMgtID == undefined || boardMgtID == ""){boardMgtID="";}
		if(projectID == undefined || projectID == ""){projectID="";}
		if( menuType == undefined || menuType == ""){alert("${CM00044}");
		}else if(menuType == "HOME"){ url = menuUrl+".do?languageID=${sessionScope.loginInfo.sessionCurrLangType}";name = "HOME";
		}else if(menuType == "BOARD"){changeCheck=false; url ="boardMgt.do"; if($("#cmbTempl").val()=="LY004"){url="boardAdminMgt.do";} url = url+"?boardMgtID="+boardMgtID;name = "게시판";
		}else if(menuType == "MYPAGE"){url = "mySpaceV34.do?srID=${srID}&myPageTmplFilter=${myPageTmplFilter}&tmplFilter="+tmplFilter+"&mainType="+mainType+"&wfInstanceID=${wfInstanceID}"; name = "MYPAGE";
		}else if(menuType == "HELP"){url = "mainHelpMainMenu.do?noticType=1";name = "HELP";
		}else if(menuType == "ServiceRequest"){url = "mainHomLayer_v2.do";name = "ServiceRequest";
		}else if(menuType == "CHANGESET") {
			url = "changeSetInfoListV4.do?&mainMenu=0&isMine=N&arcCode=AR000004&menuStyle=csh_bluebooks&screenType=view&tmplFilter=undefined&ProjectID=&classCodes="+tmplFilter+"&listFilterType=CSR";
			
		}else if(menuType == "TMPL_CHG_URL" || menuUrl !=".do?"){
			if(menuUrl != undefined){
				if(tmplType == "popUp"){fnGoProjectPop(menuUrl);return;
				}else{	url = menuUrl+"&arcCode="+menuType+"&menuStyle="+menuStyle+"&tmplFilter="+tmplFilter+"&ProjectID="+projectID+"&defDimValueID="+defDimValueID; }
			}else{ url = menuUrl; }
			
			if(menuType != "TMPL_CHG_URL" && menuType != "MN172") {
				const clickedEl = defDimValueID == "" ? document.querySelector(".menu[data-id="+menuType+"]") : document.querySelector(".menu[data-id="+menuType+"-"+defDimValueID+"]")
				if(clickedEl) {
					if(!clickedEl?.classList?.contains("selected")) {
						clickedEl.classList.add("selected");
					}
				}
				if (window.event) {
			        window.activateSelectedMenu(clickedEl);
			    }
			}
		}else{
			getCategory(menuType, defDimValueID);
		}	
   
		if(url!=undefined && url.length > 0){
			isChangeLayout = false;
			goMenu(url, menuName, isChangeLayout, layerType, menuType);
			setInitControl(false, true, menuName, menuIcon);
		} else{
			setInitControl(true, true, menuName, menuIcon);
		}	
		
		if(visitLogYN == "Y"){
			fnSetVisitLog(MenuID);
		}
	}
	function setUnfoldTreeMaster(){
		//varFilter="unfold=true";//unfold 테스트시 해당라인 주석 제거
		if(varFilter == undefined || varFilter == ""){return false;}var unfold = varFilter.match("unfold=true");if(unfold==null || unfold ==  undefined){return false;}
		if(olm.menuTree!=null){olm.menuTree.closeAllItems(0);var ch = olm.menuTree.hasChildren(0);for(var i=0; i<ch; i++){var lev1 = olm.menuTree.getChildItemIdByIndex(0,i);olm.menuTree.openItem(lev1);}}}
	function goMenu(url, name, isChangeLayout, layerType, menuType){
		if( isChangeLayout) setInitOneLayout(layerType);
		if(url=="null"){
			menuOption=$("#MENU_SELECT").val();
			creatMenuTab("",url,1);
		}else if( url.length > 0){ 
			olm.create_tab(100, "", name, url, false)
		}
	}
	function getCategory(avg, defDimValueID){setInitTwoLayout();menuOption = avg;olm.menuTree.getSelectedItemId();olm.menuTree.deleteChildItems(0);var layerTypeHmBtn = $("#layerTypeHmBtn").val();var tmplProjectID = $("#tmplProjectID").val();var projectID = "";if(layerTypeHmBtn=="TMPL003"){projectID=tmplProjectID;}var data="projectID="+projectID;if(defDimValueID != ""){data="DefDimValueID="+defDimValueID+"&projectID="+projectID;}var d=fnSetMenuTreeData(data);fnLoadDhtmlxTreeJson(olm.menuTree, d.key, d.cols, d.data, avg);}
	function setDisplayTopMenu(menuType){
		var selectedId="slidemenu0"+tmplCode;$('.topSlideMenu').each(function(){var menuId = $(this).attr('id');classNm=$("#"+menuId).attr("classNm");if(menuId==selectedId){$("#"+menuId).attr("style", "display:block");$("#"+menuId).addClass(classNm);var background=$("#"+menuId).css('background-color');if(background!=""){$("#menuRight").attr("style","background:"+background+";");}if(!isTempLoad[tmplCode]){jqueryslidemenu.buildmenu(menuId, arrowimages);isTempLoad[tmplCode]=true;}}else{$("#"+menuId).attr("style", "display:none;visibility:hidden;");$("#"+menuId).removeClass(classNm);}});}	
	function setClearTopMenuStyle(){
		const allMenuItems = document.querySelectorAll('.menu:not(.template .menu, .language .menu)')
		allMenuItems.forEach(item => item.classList.remove('selected'));
	}
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
	
	function fnGoTreeMgt(customerNo,custGRNo,currPage,custLvl,custType){
	    var url = "custTreeMgt.do";
		var data   = "customerNo="+customerNo+"&custGRNo="+custGRNo+"&custLvl="+custLvl+"&custType="+custType
					+"&currPage="+currPage+"&arcCode=CRM1100&menuStyle=csh_organization";
		goMenu(url+"?"+data, "", "", "", "");
	}
	
	function fnGoCustList(currPage,custLvl,custType){
		var url = "custList.do?currPage="+currPage+ "&custLvl=" + custLvl+ "&custType" + custType;
		goMenu(url, "", "", "", "");
	}
	
	//	history.go(1);
 	history.pushState(null, document.title, location.href);  // push 
	window.addEventListener('popstate', function(event) {    //  뒤로가기 이벤트 등록
	   // 특정 페이지로 가고싶다면 location.href = '';
	   history.pushState(null, document.title, location.href);  // 다시 push함으로 뒤로가기 Block
	});
 	
	function fnSetVisitLog(menuID){
		var url = "setVisitLog.do";
		var target = "blankDiv";
		var data = "ActionType=ARCMN&MenuID="+menuID;
		ajaxPage(url, data, target);
	}
	
	
	function fnChangeTeam(memberID) {
		ajaxSubmit(document.teamFrm, "changeSessionInfo.do?memberID="+memberID, "blankFrame");
	}

	function toggleFoldMenu(e) {
		const nextSibling = e.nextElementSibling;
		if (nextSibling && nextSibling.classList.contains('fold-menu')) nextSibling.classList.toggle('open');
	}
	
	function toggleAlram(e) {
		const nextSibling = e.nextElementSibling;
		if (nextSibling && nextSibling.classList.contains('context-menu')) nextSibling.classList.toggle('open');
	}
	
	function showSearchBar() {
		document.querySelector("#searchContents").classList.add("open");
	}
	
	function hideSearchBar() {
		document.querySelector("#searchContents").classList.remove("open");
	}

	/**
	 * 부모 깊이에 상관없이 클릭된 메뉴와 그 조상 메뉴들에 selected 클래스를 부여합니다.
	 */
	window.activateSelectedMenu = function(el) {
		const clickedTarget = el;
		
	    // 1. 전체 메뉴에서 기존 selected 클래스 제거 (초기화)
	    const allMenuItems = document.querySelectorAll('.menu:not(.template .menu, .language .menu)')
	    allMenuItems.forEach(item => item.classList.remove('selected'));

	    // 2. 클릭된 요소로부터 가장 가까운 li.menu 찾기
	    let currentItem = clickedTarget.closest('.menu');

	    // 3. 최상위(body)까지 올라가면서 모든 li.menu에 selected 추가
	    // 부모가 있으면 계속 올라가고, 없으면 멈춥니다.
	    while (currentItem) {
	        currentItem.classList.add('selected');

	        // 현재 요소의 부모 노드 중 가장 가까운 .menu를 탐색
	        // <ul>을 건너뛰고 상위 <li>.menu를 찾습니다.
	        const parentLi = currentItem.parentElement.closest('.menu');
	        
	        if (parentLi) {
	            currentItem = parentLi;
	        } else {
	            currentItem = null; // 더 이상 상위 메뉴가 없으면 종료
	        }
	    }
	};
</script>
</head>
<body>
	<input type="hidden" id="menuFullTitle"></input>
	<input type="hidden" id="TemplCode" name="TemplCode"></input>
	<input type="hidden" id="layerTypeHmBtn" name="layerTypeHmBtn">
	<input type="hidden" id="layerTextHmBtn" name="layerTextHmBtn">
	<input type="hidden" id="mainUrlHmBtn" name="mainUrlHmBtn">
	<input type="hidden" id="mainScnTextHmBtn" name="mainScnTextHmBtn">
	<input type="hidden" id="mainUrlFilterHmBtn" name="mainUrlFilterHmBtn">
	<input type="hidden" id="tmplFilterHmBtn" name="tmplFilterHmBtn">
	<input type="hidden" id="tmplProjectID" name="tmplProjectID">
	<input type="hidden" id="mainType" name="mainType" value="${mainType}">
	<input type="hidden" id="screenType" name="screenType" value="${screenType}">
	<input type="hidden" id="sysCode" name="sysCode" value="${sysCode}">
	<input type="hidden" id="menuUrl" name="menuUrl">

	<input type="hidden" id="defTemplateCode" name="defTemplateCode" value="${defTemplateCode}">
	<input type="hidden" id="defArcCode" name="defArcCode" value="${defArcCode}">

	<div id="maincontainer">
		<!-- BEGIN ::: TOP -->
		<header class="flex header-v4">
			<div class="logo">
				<img src="${root}${HTML_IMG_DIR}/logo.png" id="imgHome" alt="HOME" style="margin: 0 auto;" />
			</div>
			<!-- BEGIN ::: MENU -->
			<div class="gnb-wrapper flex justify-between align-center">
				<div class="gnb-left">
					<div id="mainMenuInc">
						<form name="langFrm" id="langFrm" action="#" method="post" onsubmit="return false;"></form>
						<form name="menuFrm" id="menuFrm" action="#" method="post" onsubmit="return false;">
							<input type="hidden" id="MENU_URL" name="MENU_URL"></input>
							<input type="hidden" id="MENU_ID" name="MENU_ID"></input>
							<input type="hidden" id="MENU_SELECT" name="MENU_SELECT"></input>
						</form>
						<c:choose>
							<c:when test="${templCode == ''}">
								<div id="slidemenu01" class="slidemenu" style="display: block"></div>
							</c:when>
							<c:otherwise>
								<c:forEach var="templ" items="${templList}" varStatus="status">
								<c:if test="${templCode eq templ.TemplCode}">
									<div id="slidemenu0${templ.TemplCode}" class="topSlideMenu" <c:if test="${templCode eq templ.TemplCode}">style="display:block"</c:if> <c:if test="${templCode ne templ.TemplCode}">style="display:none;visibility:hidden;"</c:if>>
									<script>
										document.querySelector(".header-v4").classList.add("${templ.Style}")
									</script>
										<ul class="gnb">
											<c:forEach var="mainMenu" items="${mainMenuList}" varStatus="status">
												<c:if test="${templ.TemplCode == mainMenu.TemplCode}">
													<c:choose>
														<c:when test="${mainMenu.CHILD_MENT_CNT > 0}">
															<li class="menu" data-id="${mainMenu.MENU_ID}"><a onmouseover="showHeaderContext(this)" onmouseout="hideHeaderContext(this)" href="#" alt="${mainMenu.MENU_NM}" class="topmenu" id="${mainMenu.MENU_NM}">${mainMenu.MENU_NM}</a>
																<ul class="context-menu">
																	<c:forEach var="scnMenu" items="${scnMenuList}" varStatus="status">
																		<c:if test="${mainMenu.MENU_ID == scnMenu.PRNT_MENU_ID && mainMenu.TemplCode == scnMenu.TemplCode}">
																			<c:if test="${scnMenu.DimTypeID != '0'}">
																				<li class="menu right-arrow flex justify-between" onmouseover="showHeaderContextSub(this)" onmouseout="hideHeaderContextSub(this)"><a href="#" alt="${scnMenu.MENU_NM}">${scnMenu.MENU_NM}</a>
																					<ul class="context-sub-menu">
																						<c:forEach var="thdMenu" items="${thdMenuList}" varStatus="status">
																							<c:if test="${scnMenu.MENU_ID == thdMenu.PRNT_MENU_ID}">
																								<li class="menu" data-id="${thdMenu.PRNT_MENU_ID}-${thdMenu.DefDimValueID}" onclick="clickMainMenu('${thdMenu.PRNT_MENU_ID}','${mainMenu.MENU_NM}','${mainMenu.ICON}', '${thdMenu.DefDimValueID}','${mainMenu.STYLE}','${scnMenu.STYLE}','${thdMenu.URL}.do?${thdMenu.FILTER}','','','','','','','','','Y','${thdMenu.MenuID}')"><a href="#" alt="${thdMenu.MENU_NM}">${thdMenu.MENU_NM}</a></li>
																							</c:if>
																						</c:forEach>
																					</ul></li>
																			</c:if>
																			<c:if test="${scnMenu.DimTypeID == '0'}">
																				<li class="menu" data-id="${scnMenu.MENU_ID}" onclick="clickMainMenu('${scnMenu.MENU_ID}','${mainMenu.MENU_NM}&nbsp;::&nbsp;${scnMenu.MENU_NM}','${mainMenu.ICON}','','${mainMenu.STYLE}','${scnMenu.STYLE}','${scnMenu.URL}.do?${scnMenu.FILTER}','','','','','','','','','Y','${scnMenu.MenuID}')"><a href="#" alt="${scnMenu.MENU_NM}">${scnMenu.MENU_NM}</a></li>
																			</c:if>
																		</c:if>
																	</c:forEach>
																</ul></li>
														</c:when>
														<c:otherwise>
															<li class="menu" data-id="${mainMenu.MENU_ID}" onclick="clickMainMenu('${mainMenu.MENU_ID}','${mainMenu.MENU_NM}','${mainMenu.ICON}','','${mainMenu.STYLE}','','${mainMenu.URL}.do?${mainMenu.FILTER}','','','','','','','','','Y','${mainMenu.MenuID}')"><a href="#" alt="${mainMenu.MENU_NM}" class="topmenu" id="${mainMenu.MENU_NM}">${mainMenu.MENU_NM}</a></li>
														</c:otherwise>
													</c:choose>
												</c:if>
											</c:forEach>
										</ul>
									</div>
								</c:if>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
				<div class="gnb-right flex align-center">
					<div id="searchContents">
						<svg id="close" onclick="hideSearchBar()" class="cur-po" xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 -960 960 960" width="20px" fill="#FFFFFF">
							<path d="m291-240-51-51 189-189-189-189 51-51 189 189 189-189 51 51-189 189 189 189-51 51-189-189-189 189Z" /></svg>
						<input type="text" id="mainSearchValue" name="mainSearchValue" class="text" placeholder="Search">
						<%-- 					<input id="btnMainSearch" type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" value="Search" Onclick="fnMainSearch();"> --%>
						<svg onclick="fnMainSearch();" id="btnMainSearch" xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#305685">
							<path d="M784-120 532-372q-30 24-69 38t-83 14q-109 0-184.5-75.5T120-580q0-109 75.5-184.5T380-840q109 0 184.5 75.5T640-580q0 44-14 83t-38 69l252 252-56 56ZM380-400q75 0 127.5-52.5T560-580q0-75-52.5-127.5T380-760q-75 0-127.5 52.5T200-580q0 75 52.5 127.5T380-400Z" /></svg>
					</div>
					<button>
						<svg onclick="showSearchBar()" xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#fff">
							<path d="M784-120 532-372q-30 24-69 38t-83 14q-109 0-184.5-75.5T120-580q0-109 75.5-184.5T380-840q109 0 184.5 75.5T640-580q0 44-14 83t-38 69l252 252-56 56ZM380-400q75 0 127.5-52.5T560-580q0-75-52.5-127.5T380-760q-75 0-127.5 52.5T200-580q0 75 52.5 127.5T380-400Z" /></svg>
					</button>
					<!-- 
				<div class="context-menu-wrapper">
					<button class="context-menu-opener" onclick="toggleAlram(this)"><svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#666666"><path d="M160-200v-80h80v-280q0-83 50-147.5T420-792v-28q0-25 17.5-42.5T480-880q25 0 42.5 17.5T540-820v28q80 20 130 84.5T720-560v280h80v80H160Zm320-300Zm0 420q-33 0-56.5-23.5T400-160h160q0 33-23.5 56.5T480-80ZM320-280h320v-280q0-66-47-113t-113-47q-66 0-113 47t-47 113v280Z"/></svg></button>
					<ul class="context-menu pdL20 pdR20" style="right:0;left: unset;width: 250px;">
						<li class="flex justify-between pdB15 pdT10">
							<div>모든 알림</div>
							<button>모두 읽음</button>
						</li>
						<li class="mgB15 unreaded po-re">
							<div class="flex justify-between">
								<p>결재 요청</p>
								<p class="c-a8">23시간전</p>
							</div>
							<p class="fw-600">ㅇㅇㅇ님이 결재를 요청했습니다.</p>
						</li>
					</ul>
				</div>
				 -->
					 <button class="myPage">
					 	<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#FFFFFF"><path d="M480-480q-66 0-113-47t-47-113q0-66 47-113t113-47q66 0 113 47t47 113q0 66-47 113t-113 47ZM160-160v-112q0-34 17.5-62.5T224-378q62-31 126-46.5T480-440q66 0 130 15.5T736-378q29 15 46.5 43.5T800-272v112H160Zm80-80h480v-32q0-11-5.5-20T700-306q-54-27-109-40.5T480-360q-56 0-111 13.5T260-306q-9 5-14.5 14t-5.5 20v32Zm240-320q33 0 56.5-23.5T560-640q0-33-23.5-56.5T480-720q-33 0-56.5 23.5T400-640q0 33 23.5 56.5T480-560Zm0-80Zm0 400Z"/></svg>
					</button>
					<div class="context-menu-wrapper">
						<button class="context-menu-opener" onmouseover="showHeaderContext(this)" onmouseout="hideHeaderContext(this)">
							<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#FFFFFF"><path d="M200-120q-33 0-56.5-23.5T120-200v-560q0-33 23.5-56.5T200-840h168q13-36 43.5-58t68.5-22q38 0 68.5 22t43.5 58h168q33 0 56.5 23.5T840-760v560q0 33-23.5 56.5T760-120H200Zm0-80h560v-560H200v560Zm80-80h280v-80H280v80Zm0-160h400v-80H280v80Zm0-160h400v-80H280v80Zm200-190q13 0 21.5-8.5T510-820q0-13-8.5-21.5T480-850q-13 0-21.5 8.5T450-820q0 13 8.5 21.5T480-790ZM200-200v-560 560Z"/></svg>
						</button>
						<ul class="context-menu" style="left: 50%;transform: translateX(-50%);;">
							<c:forEach var="topMenu" items="${topMenuList}" varStatus="status" >
								<li class="menu" data-id="${topMenu.MenuID}" onclick="clickMainMenu('${topMenu.MenuID}','${topMenu.Name}','','','','','${topMenu.URL}.do?${topMenu.FILTER}')"><a href="#" alt="${topMenu.Name}" id="${topMenu.MenuID}">${topMenu.Name}</a></li>
							</c:forEach>
						</ul>
					</div>
					<div class="context-menu-wrapper">
						<button class="context-menu-opener" onmouseover="showHeaderContext(this)" onmouseout="hideHeaderContext(this)">
							<svg xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 -960 960 960" width="20px" fill="#fff">
								<path d="M263.79-408Q234-408 213-429.21t-21-51Q192-510 213.21-531t51-21Q294-552 315-530.79t21 51Q336-450 314.79-429t-51 21Zm216 0Q450-408 429-429.21t-21-51Q408-510 429.21-531t51-21Q510-552 531-530.79t21 51Q552-450 530.79-429t-51 21Zm216 0Q666-408 645-429.21t-21-51Q624-510 645.21-531t51-21Q726-552 747-530.79t21 51Q768-450 746.79-429t-51 21Z" /></svg>
						</button>
						<ul class="context-menu" style="right: 0; left: unset;">
							<li class="title" style="height: 58px;">
								<div class="mem_list flex align-center">
									<span class="thumb mgR5" style="width: 30px; height: 30px;"> <span class="initial_profile" style="background-color: rgb(134, 164, 212);"> <em style="font-size: 15px;">${fn:substring(sessionScope.loginInfo.sessionUserNm,0,1)}</em>
									</span>
									</span> <span class="address_item_info"> <span class="name_info"> <span class="name_txt"> <span class="name">${sessionScope.loginInfo.sessionUserNm} (${sessionScope.loginInfo.sessionTeamName})</span>
										</span>
									</span>
										<p class="company_info">
											<span> <span>${sessionScope.loginInfo.sessionEmail}</span>
											</span>
										</p>
									</span>
								</div>
							</li>
							<li class="menu justify-between fold" onclick="toggleFoldMenu(this)">
								<div class="align-center flex">
									<svg xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 -960 960 960" width="20px" fill="#666666" class="mgR5">
										<path d="M144-204v-240h300v240H144Zm372 0v-240h300v240H516ZM144-516v-240h672v240H144Zm72 240h156v-96H216v96Zm372 0h156v-96H588v96Zm-294-48Zm372 0Z"></path></svg>
									Template
								</div>
								<svg xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 -960 960 960" width="20px" fill="#666666">
									<path d="M480-333 240-573l51-51 189 189 189-189 51 51-240 240Z" />
								</svg>
							</li>
							<ul class="fold-menu template">
								<c:forEach var="templ" items="${templList}" varStatus="status">
									<c:if test="${templ.Invisible ne '1'}">
										<li class="menu <c:if test="${templ.TemplCode eq templCode}">selected</c:if>" onclick="openInNewTab('${templ.TemplCode}','${templ.TemplText}','${templ.MainURL}','${templ.MainScnText}','${templ.URLFilter}','${templ.TmplFilter}','','${templ.TmplType}');">
											<a href="#" alt="${templ.TemplText}" id="${templ.TemplCode}">${templ.TemplText}</a> <script type="text/javascript">isTempLoad['${templ.TemplCode}']=false;</script>
										</li>
									</c:if>
								</c:forEach>
							</ul>
							<li class="menu justify-between fold" onclick="toggleFoldMenu(this)">
								<div class="align-center flex">
									<svg xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 -960 960 960" width="20px" fill="#666666" class="mgR5">
										<path d="M480-96q-79 0-149-30t-122.5-82.5Q156-261 126-331T96-480q0-80 30-149.5t82.5-122Q261-804 331-834t149-30q80 0 149.5 30t122 82.5Q804-699 834-629.5T864-480q0 79-30 149t-82.5 122.5Q699-156 629.5-126T480-96Zm0-75q17-17 34-63.5T540-336H420q9 55 26 101.5t34 63.5Zm-91-10q-14-30-24.5-69T347-336H204q29 57 77 97.5T389-181Zm182 0q60-17 108-57.5t77-97.5H613q-7 47-17.5 86T571-181ZM177-408h161q-2-19-2.5-37.5T335-482q0-18 .5-35.5T338-552H177q-5 19-7 36.5t-2 35.5q0 18 2 35.5t7 36.5Zm234 0h138q2-20 2.5-37.5t.5-34.5q0-17-.5-35t-2.5-37H411q-2 19-2.5 37t-.5 35q0 17 .5 35t2.5 37Zm211 0h161q5-19 7-36.5t2-35.5q0-18-2-36t-7-36H622q2 19 2.5 37.5t.5 36.5q0 18-.5 35.5T622-408Zm-9-216h143q-29-57-77-97.5T571-779q14 30 24.5 69t17.5 86Zm-193 0h120q-9-55-26-101.5T480-789q-17 17-34 63.5T420-624Zm-216 0h143q7-47 17.5-86t24.5-69q-60 17-108 57.5T204-624Z" /></svg>
									Language
								</div>
								<svg xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 -960 960 960" width="20px" fill="#666666">
									<path d="M480-333 240-573l51-51 189 189 189-189 51 51-240 240Z" />
								</svg>
							</li>
							<ul class="fold-menu language">
								<c:forEach var="lang" items="${langList}" varStatus="status">
									<li class="menu <c:if test="${sessionScope.loginInfo.sessionCurrLangType eq lang.CODE}">selected</c:if>" onclick="changeLanguage('${lang.CODE}','${lang.NAME}');"><a href="#" alt="${lang.NAME}" id="${lang.CODE}">${lang.NAME}</a></li>
								</c:forEach>
							</ul>
							<li class="menu logout"><svg xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 -960 960 960" width="20px" fill="#666666">
									<path d="M216-144q-29.7 0-50.85-21.15Q144-186.3 144-216v-528q0-29.7 21.15-50.85Q186.3-816 216-816h264v72H216v528h264v72H216Zm432-168-51-51 81-81H384v-72h294l-81-81 51-51 168 168-168 168Z" /></svg> Log out</li>
							<!-- 						<li class="menu"><button class="primary mgB5 mgT4" onclick="openDhxVaultModal()">파일 등록</button></li> -->
						</ul>
					</div>
				</div>
			</div>
		</header>

		<!-- BEGIN ::: CONTENTS -->
		<!-- 	<div id="contentwrapper">		 -->
		<!-- 		<div id="contentcolumn" class="nonecontentcolumn">		 -->
		<!-- 			<div class="container" id="container" scrolling='no' style="background:#fff;"> -->
		<!-- 				<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none;overflow:hidden;" frameborder="0" allowfullscreen="true" webkitallowfullscreen="true" mozallowfullscreen="true"></iframe> -->
		<!-- 			 </div>			 -->
		<!-- 		</div> -->

		<!-- 	</div>	 -->

		<div id="main-layout" style="height: calc(100% - 91px);"></div>
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display: none; overflow: hidden;" frameborder="0" allowfullscreen="true" webkitallowfullscreen="true" mozallowfullscreen="true"></iframe>
		<!-- END ::: CONTENTS -->
	</div>
	<tiles:insertAttribute name="footer" />
	<script>
const menuCloseTimers = new Map();
const CLOSE_DELAY = 100;

 window.showHeaderContext = function(element) {
    const menuLi = element.parentNode;
    const contextMenu = element.nextElementSibling;
    
    const allContextMenus = document.querySelectorAll('.context-menu.open');
    allContextMenus.forEach(cm => {
        const parentLi = cm.parentNode;
        if (parentLi !== menuLi) { // 현재 열려는 메뉴가 아닌 경우
            
            if (menuCloseTimers.has(parentLi)) {
                clearTimeout(menuCloseTimers.get(parentLi));
                menuCloseTimers.delete(parentLi);
            }
            cm.classList.remove('open');
        }
    });
    
    if (menuCloseTimers.has(menuLi)) {
        clearTimeout(menuCloseTimers.get(menuLi));
        menuCloseTimers.delete(menuLi);
    }
    
    if (contextMenu && contextMenu.classList.contains('context-menu')) {
        // 메뉴 열기
        contextMenu.classList.add('open');
        
        if (!contextMenu.dataset.listenerAttached) {
            
            contextMenu.addEventListener('mouseenter', function() {
                if (menuCloseTimers.has(menuLi)) {
                    clearTimeout(menuCloseTimers.get(menuLi));
                    menuCloseTimers.delete(menuLi);
                }
            });
            
            contextMenu.addEventListener('mouseleave', function() {
                const timerId = setTimeout(() => {
                    this.classList.remove('open');
                    menuCloseTimers.delete(menuLi);
                }, CLOSE_DELAY);
                menuCloseTimers.set(menuLi, timerId);
            });
            
            contextMenu.dataset.listenerAttached = 'true';
        }
    }
}

window.hideHeaderContext = function(element) {
    const menuLi = element.parentNode;
    const contextMenu = element.nextElementSibling;
    
    if (contextMenu && contextMenu.classList.contains('context-menu')) {
        if (menuCloseTimers.has(menuLi)) {
            clearTimeout(menuCloseTimers.get(menuLi));
        }
        
        // 200ms 후 닫기 실행
        const timerId = setTimeout(() => {
            contextMenu.classList.remove('open');
            menuCloseTimers.delete(menuLi);
        }, CLOSE_DELAY); 
        
        menuCloseTimers.set(menuLi, timerId);
    }
}

 const subMenuCloseTimers = new Map();
 const SUB_CLOSE_DELAY = 50; 

 window.showHeaderContextSub = function(element) {
     const allSubMenus = document.querySelectorAll('.context-sub-menu.open');
     allSubMenus.forEach(subMenu => {
         if (!element.contains(subMenu)) {
             subMenuCloseTimers.forEach((timerId, elem) => {
                 if (elem.contains(subMenu)) {
                     clearTimeout(timerId);
                     subMenuCloseTimers.delete(elem);
                 }
             });
             subMenu.classList.remove('open');
         }
     });

     const subMenu = element.querySelector('.context-sub-menu');
     
     if (subMenuCloseTimers.has(element)) {
         clearTimeout(subMenuCloseTimers.get(element));
         subMenuCloseTimers.delete(element);
     }

     if (subMenu) {
         subMenu.classList.add('open');
         
         if (!subMenu.dataset.listenerAttached) {
             
             subMenu.addEventListener('mouseenter', function() {
                 if (subMenuCloseTimers.has(element)) {
                     clearTimeout(subMenuCloseTimers.get(element));
                     subMenuCloseTimers.delete(element);
                 }
             });
             
             subMenu.addEventListener('mouseleave', function() {
                 const timerId = setTimeout(() => {
                     this.classList.remove('open');
                     subMenuCloseTimers.delete(element);
                 }, SUB_CLOSE_DELAY);
                 subMenuCloseTimers.set(element, timerId);
             });
             
             subMenu.dataset.listenerAttached = 'true';
         }
     }
 }
 
 window.hideHeaderContextSub = function(element) {
     const subMenu = element.querySelector('.context-sub-menu');
     
     if (subMenu) {
         if (subMenuCloseTimers.has(element)) {
             clearTimeout(subMenuCloseTimers.get(element));
         }
         
         const timerId = setTimeout(() => {
             subMenu.classList.remove('open');
             subMenuCloseTimers.delete(element);
         }, SUB_CLOSE_DELAY); 
         
         subMenuCloseTimers.set(element, timerId);
     }
 }
</script>
</body>
</html>