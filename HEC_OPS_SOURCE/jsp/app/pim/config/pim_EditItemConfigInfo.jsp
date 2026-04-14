<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<head>
<title>${ClassName} : ${OwnerTeamName}</title>
<script src="<c:url value='/cmm/js/tinymce_v4.3/tinymce.min.js'/>" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/pim.css"/>
<script type="text/javascript">
	var chkReadOnly = false;
</script>
<!-- 개요 기본정보 수정 팝업 -->
 
 <!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
 
<script type="text/javascript">

	$(document).ready(function(){		
		$("input.datePicker").each(generateDatePicker);
		/* document.getElementById('objectInfoDiv').style.height = (setWindowHeight() - 100)+"px";			
		window.onresize = function() {
			document.getElementById('objectInfoDiv').style.height = (setWindowHeight() - 100)+"px";	
		}; */
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	function saveObjInfoMain(){	
		if(confirm("${CM00001}")){	
			var dataType = "";
			var url = "pim_SaveItemConfigInfo.do";	
			ajaxSubmit(document.objectInfoFrm, url);
		}
	}

	function returnSaveObj(){location.reload();}
	
	// [save] 이벤트 후 처리
	function goBack() {
		var url = "pim_ItemConfigMgt.do";
		var target = "actFrame";
		var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}"; 
	 	ajaxPage(url, data, target);
	}
	
	//[Back] Click
	function selfClose() {
		goBack();
	}

</script>

</head>

<form name="objectInfoFrm" id="objectInfoFrm" action="pim_SaveItemConfigInfo.do" method="post" onsubmit="return false;">
<div class="child_search mgB10">
	<li class="shortcut">
	 	 <img src="${root}${HTML_IMG_DIR}/sc_Edit.png"></img>&nbsp;&nbsp;<b>${menu.LN00046}</b>
	</li>
	<li class="floatR pdR20">
	   <span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="saveObjInfoMain()" type="submit"></span>
	   <span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="goBack()" type="submit"></span>
	 </li>
</div>
<div id="objectInfoDiv" class="hidden" style="width:100%;overflow:auto;margin-bottom:5px;overflow-x:hidden;">
		<input type="hidden" id="s_itemID" name="s_itemID"  value="${s_itemID}" />
		<input type="hidden" id="itemConfigID" name="itemConfigID"  value="${itemConfigMap.ItemConfigID}" />
		<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />		
		<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />		
		<input type="hidden" id="function" name="function" value="saveObjInfoMain">
		<div class="table">
			<table width="100%" cellpadding="0" cellspacing="0">
				<colgroup>
					<col width="11%">
				    <col width="14%">
				    <col width="11%">
				    <col width="14%">
				    <col width="11%">
				    <col width="14%">
				    <col width="11%">
				    <col width="14%">
				</colgroup>
				
				<c:forEach var="prcList" items="${prcList}" varStatus="status">
				<tr>
					<th>${menu.LN00015}</th>
					<td>${prcList.Identifier}</td>
					<th>${menu.LN00028}</th>
					<td>${prcList.ItemName}</td>
					<th>${menu.LN00016}</th>
					<td>${prcList.ClassName}</td>
					<th>항목 담당자</th>
					<td id="authorInfo" style="cursor:pointer;_cursor:hand">${prcList.Name}</td>
				</tr>
				<tr>
					<th>Configuration No.</th>
					<td>${itemConfigMap.ItemConfigID}</td>
					<th>Status</th>
					<td>${itemConfigMap.Status}</td>
					<th>Configurator</th>
					<td id="actorInfo" style="cursor:pointer;_cursor:hand">${itemConfigMap.Configurator}</td>
					<th>${menu.LN00070}</th>
					<td>${itemConfigMap.LastUpdated}</td>
				</tr>
				<tr>
					<th>${menu.LN00035}</th>
					<td class="pdL5 pdR5" colspan="7">
						<textarea id="description" name="description" class="tinymceText" style="width:100%;height:160px;">${itemConfigMap.Description}</textarea>
					</td>
				</tr>
				</c:forEach>
			</table>
		</div>
</div>	
</form>	
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
	
