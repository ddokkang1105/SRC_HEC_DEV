<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<c:if test="${screenType ne 'model'}"><%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%></c:if>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/common.css"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/base.css"/>

<script type="text/javascript">
	var s_itemID = '${s_itemID}';
	var option = '${option}';
	$(document).ready(function(){
		setoccFrame('ObjectAttrInfo','1','${filter}');
	});
	
	var SubinfoTabsNum = 1; /* 처음 선택된 tab메뉴 ID값*/
	$(function(){
		$("#plisOM"+SubinfoTabsNum+" a").addClass("tab--active");
		
		$('.tabbar ul li a').click(function(){
			$(".tabbar ul li a").removeClass("tab--active"); //Remove any "active" class
			$(this).addClass('tab--active');
			SubinfoTabsNum = $(this).attr('id').replace('plisOM', '');
		});
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
	}
	
	// reload 추가 
	function reload(){
		setoccFrame('ObjectAttrInfo','1','${filter}');
	}
	

	
</script>
<div class="tabbar">
	<ul class="pdL10">
		<li id="plisOM1" class="flex align-center"><a class="tab--active flex align-center" onclick="setoccFrame('ObjectAttrInfo','1','${filter}')"><span>${menu.LN00031}</span> </a></li>
		<li id="plisOM2" class="flex align-center" ><a onclick="setoccFrame('goFileMdlList','2','${filter}')" class="flex align-center"><span>${menu.LN00019}</span></a></li>
		<c:if test="${mdlFilter eq 'Y' }">
			<li id="plisOM3" class="flex align-center"><a onclick="setoccFrame('modelFilterMenu','3','${filter}')" class="flex align-center"><span>${menu.LN00394}</span></a></li>
		</c:if>
	</ul>
</div>
<div id="occDiv" name="occDiv" style="width:100%;hegiht:100%;overflow:hidden;line-height:1.3em;font-weight:normal;"></div>
 
