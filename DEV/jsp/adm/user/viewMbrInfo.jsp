<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00106}"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<script>
	var menuIndex = "1 2 3 4";

	$(document).ready(function(){
		setpmFrame('ownerItemList','','1');
	});
	
	function setpmFrame(avg,oj, avg2){
		var url = avg+".do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&memberID=${authorInfoMap.MemberID}"
				+"&userType=1"
				+"&width="+ugFrame.offsetWidth
				+"&option=${option}"
				+"&getAuth=${sessionScope.loginInfo.sessionLogintype}"
				+"&currPage=${currPage}"
				+"&authorID=${authorInfoMap.MemberID}"
				+"&hideTitle=Y";
		var target="ugFrame";
	
		ajaxPage(url,data,target);
		var realMenuIndex = menuIndex.split(' ');
		
		for(var i = 0 ; i < realMenuIndex.length; i++){
			if(realMenuIndex[i] == avg2){
				$("#pliug"+realMenuIndex[i]+" a").addClass("tab--active");
			}else{
				$("#pliug"+realMenuIndex[i]+" a").removeClass("tab--active");
			}
		}
	}

</script>
<table class="tbl_search" style="padding: 20px 30px;border-left: 0;border-right: 0;border-top: 0;background: #f7f7f7;">
	<colgroup>
		<col width="10%">
		<col width="8%"> 
		<col width="22%">
		<col width="8%">
		<col width="22%">
		<col width="8%">
		<col width="22%">
	</colgroup>
	<tr>
		<td rowspan=3 class="alignC" style="vertical-align: top;">
			<c:if test="${authorInfoMap.Photo == 'blank_photo.png' }" >
				<img src='<%=GlobalVal.HTML_IMG_DIR%>${authorInfoMap.Photo}' style="width:60px;height:60px;border-radius: 50px;">
			</c:if>
			<c:if test="${authorInfoMap.Photo != 'blank_photo.png' }" >
				<img src='<%=GlobalVal.EMP_PHOTO_URL%>${authorInfoMap.Photo}' style="width:60px;height:60px;border-radius: 50px;">
			</c:if>
		</td>
		<td colspan=6><span style="font-weight:bold;font-size:14px;padding-bottom: 15px;display: block;">${authorInfoMap.UserName}</span></td>
	</tr>
	<tr>
		<td>
			<span style="font-weight:bold;font-size:12px;">${menu.LN00104}</span>
		</td>
		<td>${authorInfoMap.TeamName}</td>
		<td>
			<span style="font-weight:bold;font-size:12px;">Position</span>
		</td>
		<td>${authorInfoMap.Position}</td>
		<td>
			<span style="font-weight:bold;font-size:12px;">E-mail</span>
		</td>
		<td>${authorInfoMap.Email}</td>
	</tr>
	<tr>
		<td>
			<span style="font-weight:bold;font-size:12px;">Tel</span>
		</td>
		<td>${authorInfoMap.TelNum}</td>
		<td>
			<span style="font-weight:bold;font-size:12px;">Mobile</span>
		</td>
		<td>${authorInfoMap.MTelNum}</td>
		<td>
			<span style="font-weight:bold;font-size:12px;">Location</span>
		</td>
		<td>${authorInfoMap.City}</td>
	</tr>
</table> 
<div class="tabbar">
	<ul>
		<li id="pliug1" class="flex align-center"><a href="javascript:setpmFrame('ownerItemList','','1');" class="flex align-center"><span>${menu.LN00190}</span></a></li>
		<li id="pliug2" class="flex align-center"><a href="javascript:setpmFrame('myChangeSet','','2');" class="flex align-center"><span>${menu.LN00082}</span></a></li>
		<li id="pliug3" class="flex align-center"><a href="javascript:setpmFrame('mbrCsrList','','3');" class="flex align-center"><span>${menu.LN00191}</span></a></li>
		<li id="pliug4" class="flex align-center"><a href="javascript:setpmFrame('myRoleList','','4');" class="flex align-center"><span>${menu.LN00119}</span></a></li>
	</ul>
</div>
<div id="ugFrame" class="pdL20 pdR20" style="height:calc(100% - 185px);overflow-y:auto;"></div>