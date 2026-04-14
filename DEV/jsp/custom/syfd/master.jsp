<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<c:url value="/" var="root"/>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<c:set value='<%= request.getParameter("retfnc") %>' var="retfnc"/>
<%
String userIP = request.getRemoteAddr();

SimpleDateFormat format1 = new SimpleDateFormat ( "yyyy-MM-dd HH:mm:ss");
Date today = new Date();

String nowTime = format1.format(today);

%>
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
<tiles:insertAttribute name="tagInc"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/menuOnloader.jsp"%>

<%@ include file="/WEB-INF/jsp/template/autoCompText.jsp"%>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<script type="text/javascript" src="${root}cmm/js/xbolt/lovCssHelper.js"></script>
<%@ include file="/WEB-INF/jsp/cmm/ui/dhtmlxJsInc.jsp"%>
<style>

#searchType {display:inline-block;}
#searchType select{
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
	background:#fff;
    border-radius: 15px;
    border: 1px solid #cccccc;
    position: relative;
    width: 380px;
    height: 30px;
}
#searchContents #mainSearchValue {
    color: #444;
    position: relative;
    overflow: hidden;
    border: none;
    background: none;
    width: calc(100% - 35px);
    box-sizing: border-box;
    padding-left: 15px;
    height: inherit;
    text-overflow: ellipsis;
}
#searchContents #mainSearchValue::placeholder{color:#ccc;}
#searchContents #mainSearchValue:-ms-input-placeholder{color:#ccc;}
#searchContents #btnMainSearch{
	position: absolute;
    right: 8px;
    bottom: 5px;
    top: 3px;
    border: 0;
    background: none;
    cursor: pointer;
}

</style>
<script type="text/javascript">
	var favicon = "favicon";
	
	var olm={};	olm.pages={};olm.url={};var baseLayout;var cntnLayout;var menuTreeLayout;var treeImgPath="";var topMenuCnt={};var currItemId="";var mainLayout;var tmplCode="";var isTempLoad={};
	var homeUrl;var varFilter="";
	window.onload=setInit;
	jQuery(document).ready(function() {	
		var lang_style="width:"+"${tmpTextMaxLng}"+"px;"; var cmpny_style="width:"+"${cmpnyTextMaxLng}"+"px";
		fnChangeLangComboStyle(lang_style);
		fnChangeCmpnyComboStyle(cmpny_style);
		
		// IP CHECK
		if("${tmplFilter}".indexOf("ipCheck=Y") > -1){
			checkIP("${templCode}","main");
		}
		
		$('.logo').click(function(){ 	        	
		//	clickMainMenu("HOME", "HOME", "", "", "", "", homeUrl);
		
        	setClearTopMenuStyle();
	        $("#cmbTempl").val("${templCode}");changeTempl("${templCode}","${templText}","${mainURL}","","${mainUrlFilter}","${tmplFilter}");
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

		$("#mainSearchValue").keyup(function() {if(event.keyCode == '13') {fnMainSearch();}});
		
		var footerHtml =    '<div style="float:left;margin-top:5px;">'+
        '    <p class="user_info-out">USER IP : <%=userIP%> Login Date : <%=nowTime%> USER Info : [${sessionScope.loginInfo.sessionLoginId}] ${sessionScope.loginInfo.sessionUserNm}</p>'+
        '</div>';
       
		$('#footersection').prepend(footerHtml);
		
		setInitOneLayout(layout_2E);
		autoComplete("mainSearchValue", "AT00001", "", "", "", 5, "top");
	});

    function fnMainSearch(){
		var searchValue = encodeURI($("#mainSearchValue").val());
    	var url = "searchItemWFile.do?"; 
    	var data = "searchValue="+searchValue; 
    	clickMainMenu('MN172','','','','','', url+data);
    }
    
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
		var arcLinkYN = "N";
		if("${mainType}" == "arcLink"){
			arcLinkYN = "Y";
		}
		if(window.attachEvent){window.attachEvent("onresize",resizeLayout);}else{window.addEventListener("resize",resizeLayout, false);}var t;function resizeLayout(){window.clearTimeout(t);t=window.setTimeout(function(){setScreenResize();},200);}
		changeTempl('${templCode}','${templText}','${mainURL}','${mainScnText}','${mainUrlFilter}','${tmplFilter}','${projectID}','',arcLinkYN,'${mainType}');
		homeUrl = "${mainURL}"+".do?"+"${mainUrlFilter}";
        var ntcCnt=parseInt('${ntcCnt}');var cookieId="sfolmLdNtc_"+"${BoardID}";var isNtc=getCookie(cookieId);if(isNtc==undefined){isNtc=false;}/*isNtc = false;*/
        if(isNtc==false&&ntcCnt>0){
        	var url="boardAlarmPop.do";
        	//var data="";
        	var data="languageID=${sessionScope.loginInfo.sessionCurrLangType}&templCode={templCode}";
        	fnOpenLayerPopup(url,data,"",600,300);/*openPopup(url,400,400,"new");*/
        }
	}	
	
	function setScreenResize(h){if(h == null || h == undefined) h = 130; var clientHeight=document.body.clientHeight;document.getElementById("container").style.height = (clientHeight - (h)) + "px";if( baseLayout==null){if(cntnLayout!=null && cntnLayout!=undefined){cntnLayout.setSizes();}}else{var minWidth=lMinWidth+rMinWidth;var wWidth=document.body.clientWidth;if(minWidth>wWidth){baseLayout.items[0].setWidth(lMinWidth);} baseLayout.setSizes();}}
	function setInitMenu(isLeft, isMain){if(isMain){$("#menusection").attr("style","display:block;");}else{$("#menusection").attr("style","display:none;");}setScreenResize();}
	function changeLanguage(langType,langText) {if(langText==null||langText==undefined){langText="${sessionScope.loginInfo.sessionCurrLangNm}";}$("#cmbLanguage").html(langText);ajaxSubmitNoAdd(document.langFrm, "languageSetting.do?LANGUAGE="+langType+"&NAME="+langText, "blankFrame");}
	
	function doReturnLanguage(){
		location.href="mainpage.do?loginIdx=${loginIdx}&screenType=${screenType}&srID=${srID}&mainType=${mainType}&sysCode=${sysCode}&status=${status}"
					+ "&defTemplateCode=${defTemplateCode}"
					+ "&defArcCode=${defArcCode}";
	}
	
	function changeTempl(layerType,layerText, mainUrl, mainScnText, mainUrlFilter, tmplFilter, tmplProjectID, tmplType, arcLinkYN, mainType) { 
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
	    
		setTopIcon("");
		if(layerType == "TMPL999"){setInitMenu(false,false);}else{setInitMenu(false,true);}
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
		ajaxSubmitNoAdd(document.menuFrm, "<c:url value='/login/logout.do'/>", "blankFrame");
		/* if(loginIdx == "BASE"){
			ajaxSubmitNoAdd(document.menuFrm, "<c:url value='/login/logout.do'/>", "blankFrame");
		}else{
			top.window.open('about:blank','_self').close(); 
			top.window.opener=self;
			top.self.close(); 
		}*/
	}
	function fnCheckedDuplicateLogin(activLoginIp) {
		if(typeof(opener)) {
			opener.parent.fnCheckedDuplicateLoginOpener(activLoginIp);self.close();
		}else{
			parent.fnCheckedDuplicateLogin(activLoginIp);
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
		var templCode = $("#layerTypeHmBtn").val(); url += "&templCode="+templCode;
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
		//console.log("menuType : "+menuType+", menuName :"+menuName+"&tmplFilter="+tmplFilter+", mainType :"+mainType+", menuUrl  :"+menuUrl+", visitLogYN:"+visitLogYN);
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
			url = "changeInfoList.do?&mainMenu=0&isMine=N&arcCode=AR000004&menuStyle=csh_bluebooks&screenType=view&tmplFilter=undefined&ProjectID=&classCodes="+tmplFilter;
			
		}else if(menuType == "TMPL_CHG_URL" || menuUrl!=".do?"){
			if(menuUrl != undefined){
				if(tmplType == "popUp"){fnGoProjectPop(menuUrl);return;
				}else{	url = menuUrl+"&arcCode="+menuType+"&menuStyle="+menuStyle+"&tmplFilter="+tmplFilter+"&ProjectID="+projectID+"&defDimValueID="+defDimValueID; }
			}else{ url = menuUrl; }
		}else{ getCategory(menuType, defDimValueID);}	
   
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
	function setDisplayTopMenu(menuType){
		var selectedId="slidemenu0"+tmplCode;$('.topSlideMenu').each(function(){var menuId = $(this).attr('id');classNm=$("#"+menuId).attr("classNm");if(menuId==selectedId){$("#"+menuId).attr("style", "display:block");$("#"+menuId).addClass(classNm);var background=$("#"+menuId).css('background-color');if(background!=""){$("#menuRight").attr("style","background:"+background+";");}if(!isTempLoad[tmplCode]){jqueryslidemenu.buildmenu(menuId, arrowimages);isTempLoad[tmplCode]=true;}}else{$("#"+menuId).attr("style", "display:none;visibility:hidden;");$("#"+menuId).removeClass(classNm);}});}	
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
 	
	function fnSetVisitLog(arcCode){
		var url = "setVisitLog.do";
		var target = "blankDiv";
		var data = "ActionType="+arcCode;
		ajaxPage(url, data, target);
	}

</script>
</head>
<body>
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
<input type="hidden" id="menuUrl" name="menuUrl">

<input type="hidden" id="defTemplateCode" name="defTemplateCode" value="${defTemplateCode}" >
<input type="hidden" id="defArcCode" name="defArcCode" value="${defArcCode}" >

<div id="maincontainer">
	<!-- BEGIN ::: TOP -->
	<div id="topsection" class="flex justify-between">
		<div class="topL">
		  <li alt="HOME" class="logo"><img src="${root}${HTML_IMG_DIR}/logo.png" style="cursor:pointer; margin-right:15px" id="imgHome" alt="HOME"></img></li>
		  <li class="pdR10 pdL21 pdT6"><img src="${root}${HTML_IMG_DIR}/icon_admin_w.png"/></li>
		  <c:if test="${loginIdx == 'BASE'}" > 
		  <li class="pdR10 pdT6 cPointer" OnClick="fnChangePwd();" alt="USER" titl="USER"> <font style="font-weight:bold;"><u>${sessionScope.loginInfo.sessionUserNm}</u></font>&nbsp;(${sessionScope.loginInfo.sessionTeamName})</li> 
		  </c:if>
		  <c:if test="${loginIdx != 'BASE'}" > 
		  <li class="pdR10 pdT6" alt="USER" titl="USER" > <font style="font-weight:bold;"><u>${sessionScope.loginInfo.sessionUserNm}</u></font>&nbsp;(${sessionScope.loginInfo.sessionTeamName})</li> 
		  </c:if>
		  <li class="logout logoutbtn"><a href="#" class="logout" ><img src="${root}${HTML_IMG_DIR}/menu_icon_logout.png" style="cursor:pointer"></a></li>       
       </div>
		<ul>
			<li id="searchContents">
				<input type="text" id="mainSearchValue" name="mainSearchValue" class="text" placeholder="Search">
				<input id="btnMainSearch" type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" value="Search" Onclick="fnMainSearch();">
			</li>
		</ul>
		<div class="floatR pdR0" id="MemInfo">
			<ul class="floatR">
			<li class="pdR10 pdL20 mgT5"><img src="${root}${HTML_IMG_DIR}/icon_mypage.png"/></li>
				<li class="myPage hypen mgT5" style="cursor:pointer;" alt="MYPAGE" title="MYPAGE">My Page</li>
				<li class="hypen ">			
				<form name="templFrm" id="templFrm" action="#" method="post" onsubmit="return false;">	
					<ul id="nav2">
						<li class="top"><span id="cmbTemplate">${templText}</span>							
						<ul class="sub2">
							<c:forEach var="templ" items="${templList}" varStatus="status" >							
								<li onclick="openInNewTab('${templ.TemplCode}','${templ.TemplText}','${templ.MainURL}','${templ.MainScnText}','${templ.URLFilter}','${templ.TmplFilter}','','${templ.TmplType}');" <c:if test="${templ.Invisible=='1'}" >style="display:none;"</c:if>><a href="#" alt="${templ.TemplText}" id="${templ.TemplCode}">${templ.TemplText}</a>
								<script type="text/javascript">isTempLoad['${templ.TemplCode}']=false;</script>
								</li>								
							</c:forEach>
						</ul>
						</li>						
					</ul></form>				
				</li>
<%-- 				<c:if test="${isCmpnyView == 'Y'}"> --%>
<!-- 				<li class="hypen"><form name="cmpnyFrm" id="cmpnyFrm" action="#" method="post" onsubmit="return false;">	 -->
<!-- 					<ul id="nav3"> -->
<%-- 						<li class="top"><span id="cmbCampany">${cmpnyText}</span>	 --%>
<%-- 							<c:if test="${isCmpnySelect == 'Y'}">						 --%>
<!-- 								<ul class="sub3"> -->
<%-- 								<c:forEach var="cmpny" items="${cmpnyList}" varStatus="status" > --%>
<%-- 									<li onclick="changeCmpny('${cmpny.CmpnyCode}');"><a href="#" alt="${cmpny.CmpnyText}" id="${cmpny.CmpnyCode}">${cmpny.CmpnyText}</a> --%>
<!-- 									</li> -->
<%-- 								</c:forEach> --%>
<!-- 								</ul> -->
<%-- 							</c:if> --%>
<!-- 						</li>						 -->
<!-- 					</ul></form> -->
<!-- 				</li>	 -->
<%-- 				</c:if>			 --%>
                <li class="hypen"><form name="langFrm" id="langFrm" action="#" method="post" onsubmit="return false;">
                    <ul id="nav">
                        <li class="top mgT3"><span id="cmbLanguage">${sessionScope.loginInfo.sessionCurrLangNm}</span>
                            <ul class="sub">
                            <c:forEach var="lang" items="${langList}" varStatus="status" >
                                <li onclick="changeLanguage('${lang.CODE}','${lang.NAME}');">
                                <a href="#" alt="${lang.NAME}" id="${lang.CODE}">${lang.NAME}</a>
                                </li>
                            </c:forEach>                            
                            </ul>
                        </li>                       
                    </ul></form>                    
                </li>                 
				<%--<li class="help pdL15 hypen mgT5" alt="HELP" title="HELP" style="cursor:pointer;">Help</li> --%>
			</ul>
		</div>		
	</div>
	<!--END::TOP -->	
	<!-- BEGIN ::: MENU -->
	<div id="menusection">
		<div id="menu_wrapper">
			<div  class="menu_center" id="mainMenuInc">
			
			<form name="menuFrm" id="menuFrm" action="#" method="post" onsubmit="return false;">
				<input type="hidden" id="MENU_URL" name="MENU_URL"></input>
				<input type="hidden" id="MENU_ID" name="MENU_ID"></input>
				<input type="hidden" id="MENU_SELECT" name="MENU_SELECT"></input>
			</form>	
			<c:choose>
		       <c:when test="${templCode == ''}">
		     		<div id="slidemenu01" class="slidemenu" style="display:block"></div>
		    	</c:when>
		    	<c:otherwise>
					<c:forEach var="templ" items="${templList}" varStatus="status">
						<div id="slidemenu0${templ.TemplCode}" class="${templ.Style} topSlideMenu" classNm="${templ.Style}" 
							<c:if test="${status.first}">style="display:block"</c:if>
							<c:if test="${!status.first}">style="display:none;visibility:hidden;"</c:if>
						 >
							<ul>
							    <li class="first"><a href="#" class="home">Home</a></li>
								<c:forEach var="mainMenu" items="${mainMenuList}" varStatus="status" >
									<c:if test="${templ.TemplCode == mainMenu.TemplCode}">
										<c:choose>
							    			<c:when test="${mainMenu.CHILD_MENT_CNT > 0}">
												<li><a href="#" alt="${mainMenu.MENU_NM}" class="topmenu" id="${mainMenu.MENU_NM}"><c:if test="${mainMenu.ICON != ''}"><img class="menuicon" src="${root}${HTML_IMG_DIR_ARC}/${mainMenu.ICON}"></img></c:if>${mainMenu.MENU_NM}</a>
												<ul>
													<c:forEach var="scnMenu" items="${scnMenuList}" varStatus="status" >
														<c:if test="${mainMenu.MENU_ID == scnMenu.PRNT_MENU_ID && mainMenu.TemplCode == scnMenu.TemplCode}">
															<c:if test="${scnMenu.DimTypeID != '0'}">
																<li><a href="#" alt="${scnMenu.MENU_NM}">${scnMenu.MENU_NM}</a>
																	<ul>
																		<c:forEach var="thdMenu" items="${thdMenuList}" varStatus="status" >
																			<c:if test="${scnMenu.MENU_ID == thdMenu.PRNT_MENU_ID}">
																				<li onclick="clickMainMenu('${thdMenu.PRNT_MENU_ID}','${mainMenu.MENU_NM}','${mainMenu.ICON}', '${thdMenu.DefDimValueID}','${mainMenu.STYLE}','${scnMenu.STYLE}','${thdMenu.URL}.do?${thdMenu.FILTER}','','','','','','','','','Y')"><a href="#" alt="${thdMenu.MENU_NM}">${thdMenu.MENU_NM}</a></li>
																			</c:if>
																		</c:forEach>
																	</ul>
																</li>
															</c:if>
															<c:if test="${scnMenu.DimTypeID == '0'}">
																<li onclick="clickMainMenu('${scnMenu.MENU_ID}','${mainMenu.MENU_NM}&nbsp;::&nbsp;${scnMenu.MENU_NM}','${mainMenu.ICON}','','${mainMenu.STYLE}','${scnMenu.STYLE}','${scnMenu.URL}.do?${scnMenu.FILTER}','','','','','','','','','Y')"><a href="#" alt="${scnMenu.MENU_NM}">${scnMenu.MENU_NM}</a></li>
															</c:if>
														</c:if>
													</c:forEach>	
												</ul>
												</li>
											</c:when>
											<c:otherwise>
							         			<li onclick="clickMainMenu('${mainMenu.MENU_ID}','${mainMenu.MENU_NM}','${mainMenu.ICON}','','${mainMenu.STYLE}','','${mainMenu.URL}.do?${mainMenu.FILTER}','','','','','','','','','Y')"><a href="#" alt="${mainMenu.MENU_NM}" class="topmenu" id="${mainMenu.MENU_NM}"><c:if test="${mainMenu.ICON != ''}"><img class="menuicon" src="${root}${HTML_IMG_DIR_ARC}/${mainMenu.ICON}"></img></c:if>${mainMenu.MENU_NM}</a></li>
											</c:otherwise>
										</c:choose>
									</c:if>
								</c:forEach>
							</ul>
							<span style="clear: left"></span>
						</div>
					</c:forEach>
				</c:otherwise></c:choose>
			</div>
		</div>
		<div class="menu_right" id="menuRight" style="display:block;background:#5E904B;">
			<div class="quick_menu" style="float:left !important">
				<ul>
					<c:forEach var="topMenu" items="${topMenuList}" varStatus="status" >
						<li class="topIcon" alt="${topMenu.MenuID}" title="${topMenu.Name}" onclick="clickMainMenu('${topMenu.MenuID}','${topMenu.Name}','','','','','${topMenu.URL}.do?${topMenu.FILTER}')"><img class="topIconImg" alt="img${topMenu.MenuID}" src="${root}${HTML_IMG_DIR_SHORTCUT}${topMenu.Icon}"></img></li>
					</c:forEach>
				</ul>
			</div>
			<img id="hideMenu" onClick="fnHideTopMenu();" class="show" style="padding-left:5px;padding-top:5px;" alt="Hide Top" src="${root}${HTML_IMG_DIR_SHORTCUT}icon_hide.png"></img>
		</div>
	</div>
	<!-- END ::: MENU -->
	<!-- BEGIN ::: CONTENTS -->
	<div id="contentwrapper">		
		<div id="contentcolumn" class="nonecontentcolumn">		
			<div class="container" id="container" scrolling='no' style="background:#fff;">
				<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none;overflow:hidden;" frameborder="0" allowfullscreen="true" webkitallowfullscreen="true" mozallowfullscreen="true"></iframe>
			 </div>	
			<div id="divCntn" ></div>
		</div>
	</div>	
	<!-- END ::: CONTENTS -->
</div>	
<div id="blankDiv"></div>
<tiles:insertAttribute name="footer"/> 
</body>
</html>