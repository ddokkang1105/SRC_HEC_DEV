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
<tiles:insertAttribute name="tagInc"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/menuOnloader.jsp"%>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<script type="text/javascript" src="${root}cmm/js/xbolt/lovCssHelper.js"></script>

<script type="text/javascript">
    var olm={};	olm.pages={};olm.url={};var baseLayout;var cntnLayout;

	var t;
	jQuery(document).ready(function() {
		var sessionlvl = "${sessionScope.loginInfo.sessionAuthLev}";
		var gloProjectID = "${gloProjectID}";
		
		if(sessionlvl > 2 && gloProjectID != "" && gloProjectID != null){
			fnOpenItemPop("${itemID}");	
		}else{		
			cntnLayout = new dhtmlXLayoutObject("mastercontainer",layout_1C);
			cntnLayout.items[0].hideHeader();
			mainLayout=cntnLayout.items[0];
			mainLayout.attachURL("${mainTemplateURL}");
			var ifr =mainLayout.getFrame();ifr.scrolling="no";
			if(window.attachEvent){
				window.attachEvent("onresize",resizeLayout);
			}else{
				window.addEventListener("resize",resizeLayout, false);
			}
		}
	});
	function resizeLayout(){
		window.clearTimeout(t);
		t=window.setTimeout(function(){setScreenResize();},200);
	}
	function setScreenResize(h){
		if(h == null || h == undefined) h = 15; 
		var clientHeight=document.body.clientHeight;
		document.getElementById("mastercontainer").style.height = (clientHeight - (h)) + "px";
		if( baseLayout==null){
			if(cntnLayout!=null && cntnLayout!=undefined){
				cntnLayout.setSizes();}
			}else{
				var minWidth=lMinWidth+rMinWidth;
				
				var wWidth=document.body.clientWidth;
				
				if(minWidth>wWidth){
					baseLayout.items[0].setWidth(lMinWidth);
				} 
				
				baseLayout.setSizes();
			}
		}
	
	function fnSetServiceRequest(templeURL) { 
		mainLayout.attachURL(templeURL);
		var ifr =mainLayout.getFrame();ifr.scrolling="no";
	}
		
	function fnOpenItemPop(itemID){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop&focusedItemID=${focusedItemID}";
		//var w = 1200;
		//var h = 1000; 
		
		var wX = screen.availWidth;
		var wY = screen.availHeight;
		wY = (wY-38);
		
		window.open(url, "DAELIM IEP", "width="+wX+", height="+wY+", top=0,left=0,toolbar=no,status=no,resizable=yes");
		window.top.close();
	}
	
</script>
</head>
<body>
<div id="mastercontainer" style="width:100%;height:100%">
</div>	
</body>
</html>