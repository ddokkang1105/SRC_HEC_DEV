<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<c:if test="${screenType ne 'model'}"><%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%></c:if>

<script type="text/javascript">
	var s_itemID = '${s_itemID}';
	var classCode = '${classCode}';

	var menuIndex = "1 2 3";
	
	$(document).ready(function() {
		classCode = '${classCode}';
		
	    if (classCode === 'CL01006') {
	        setoccFrame('zSKON_ObjectAttrInfo', '1', '${filter}'); 
	        /* $("#plisOM1").click(function() {setoccFrame('zSKON_ObjectAttrInfo','1','${filter}');}); */
	    }
	    else {
	    	setoccFrame('ObjectAttrInfo', '1', '${filter}'); 
	    	/*  $("#plisOM1").click(function() {setoccFrame('ObjectAttrInfo','1','${filter}');}); */
	    }
	    
		/* $("#plisOM2").click(function() {setoccFrame('goFileMdlList','2','${filter}');});
		$("#plisOM3").click(function() {setoccFrame('modelFilterMenu','3','${filter}');}); */
	});

	function setoccFrame(avg, avg2, filter){ 
		if(filter == ''){filter = 'mapOcc';}		
		var url = avg+".do";
		var languageID = "${languageID}";
		if(languageID == ""){
			languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
		}
		var data = "languageID="+languageID
				+"&ModelID=${modelID}"
				+"&s_itemID=${s_itemID}"
				+"&option="+$("#option",parent.document).val()
				+"&userID=${sessionScope.loginInfo.sessionUserId}"
				+"&filter="+filter
				+"&getAuth=${sessionScope.loginInfo.sessionLogintype}"
				+"&screenType=${screenType}"
				+"&attrRevYN=${attrRevYN}"
				+"&changeSetID=${changeSetID}"
				+"&itemTypeFilter="+encodeURIComponent("${itemTypeFilter}")
				+"&dimTypeFilter="+encodeURIComponent("${dimTypeFilter}")
				+"&symTypeFilter="+encodeURIComponent("${symTypeFilter}"); 

		var target="occDiv";
		var src = url+"?"+data;
		$.ajax({
			url: url,type: 'post',data: data,async: false,error: function(xhr, status, error) {alert(status+"||"+error); }
			,success: function(data){$("#" + target).hide();$("#" + target).html(data);$("#" + target).fadeIn(10);}
		});	
		//$("#occFrame").attr('src',src);		
		
		//tab Change
		setSubTab(menuIndex, avg2, "plisOM", "selected");
	}
	function setSubTab(menuIdx, avg, tabNm, classNm){var realMenuIndex = menuIdx.split(' '); if(tabNm == null || tabNm == "undefined"){tabNm = "pli";}if(classNm == null || classNm == "undefined"){classNm = "on";}for(var i = 0 ; i < realMenuIndex.length; i++){if(realMenuIndex[i] == avg){$('#'+tabNm+realMenuIndex[i]).addClass(classNm);}else{$('#'+tabNm+realMenuIndex[i]).removeClass(classNm);}}}

	
	// reload 추가 
	function reload(){
		
		if (classCode === 'CL01006') {
	        setoccFrame('zSKON_ObjectAttrInfo', '1', '${filter}'); 
	        /* $("#plisOM1").click(function() {setoccFrame('zSKON_ObjectAttrInfo','1','${filter}');}); */
	    }
	    else {
	    	setoccFrame('ObjectAttrInfo', '1', '${filter}'); 
	    	/*  $("#plisOM1").click(function() {setoccFrame('ObjectAttrInfo','1','${filter}');}); */
	    }
	}
	
</script>
<%-- <div class="ddoverlap" style="line-height:1.3em;">
	<ul>
		<li id="plisOM1" class="selected"><a><span>${menu.LN00031}</span> </a></li> <!-- 속성 -->
		<li id="plisOM2" ><a><span>${menu.LN00019}</span></a></li> <!-- 첨부문서 -->
		<c:if test="${mdlFilter eq 'Y' }">
			<li id="plisOM3" ><a><span>${menu.LN00394}</span></a></li>
		</c:if>
	</ul>
</div> --%>
<div id="occDiv" name="occDiv" style="width:100%;hegiht:100%;overflow:hidden;line-height:1.3em;font-weight:normal;"></div>
 
