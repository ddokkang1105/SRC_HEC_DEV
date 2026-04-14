<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<c:if test="${screenType ne 'model'}"><%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%></c:if>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
		+"&ModelID=${parentID}"
		+"&occID=${s_itemID}"
		+"&s_itemID=${s_itemID}"
		+"&option="+$("#option",parent.document).val()
		+"&userID=${sessionScope.loginInfo.sessionUserId}"
		+"&filter=${filter}"
		+"&getAuth=${sessionScope.loginInfo.sessionLogintype}"
		+"&screenType=${screenType}"
		+"&attrRevYN=${attrRevYN}"
		+"&changeSetID=${changeSetID}"; 
	
	var tabbar = new dhx.Tabbar("tabbar", {
// 	    css: "dhx_widget--bordered",
// 	    tabAutoWidth:true,
	    views: [
	    	{ id: "attr", tab: "${menu.LN00031}", html: "<div id='attr' style='width: 100%; overflow: hidden; line-height: 1.3em; font-weight: normal; display: block;'>"+setoccFrame('ObjectAttrInfo','${filter}','attr')+"</div>"},
	        { id: "file", tab: "${menu.LN00019}", html: "<div id='file' style='width: 100%; overflow: hidden; line-height: 1.3em; font-weight: normal; display: block;'>"+setoccFrame('goFileMdlListV4','${filter}','file')+"</div>" }
    	]
	});
	
	tabbar.events.on("Change", function(activeId, prevId){
	    if(activeId == "attr") ajaxPage("ObjectAttrInfo.do",data, activeId);
	    if(activeId == "file") ajaxPage("goFileMdlListV4.do",data, activeId);
	});
	
	function setoccFrame(avg, filter, target){
		if(filter == ''){filter = 'mapOcc';}		
		var url = avg+".do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&ModelID=${parentID}"
				+"&occID=${s_itemID}"
				+"&s_itemID=${s_itemID}"
				+"&option="+$("#option",parent.document).val()
				+"&userID=${sessionScope.loginInfo.sessionUserId}"
				+"&filter="+filter
				+"&getAuth=${sessionScope.loginInfo.sessionLogintype}"
				+"&screenType=${screenType}"
				+"&attrRevYN=${attrRevYN}"
				+"&changeSetID=${changeSetID}"; 
		ajaxPage(url, data, target);
	}
</script>
<section class="dhx_sample-container" style="height:100%;">
    <div id="tabbar" style="width: 100%; height:100%;"></div>
</section>