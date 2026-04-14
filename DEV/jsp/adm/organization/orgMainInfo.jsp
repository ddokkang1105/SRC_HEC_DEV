<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta>
<meta http-equiv="X-UA-Compatible" content="IE=Edge; charset=utf-8"></meta>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
	
<script type="text/javascript">

$(document).ready(function(){
	setorgFrame('itemListMgt','1', 'ownerTeam');
});

function setorgFrame(avg, avg2, avg3){
	var url = avg+".do";
	var data="languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+"&s_itemID=${id}"
			+"&option=${option}"
			+"&getAuth=${sessionScope.loginInfo.sessionLogintype}"
			+"&ownerType="+avg3	
			+"&ownerTeamID=${getMap.TeamID}&teamID=${getMap.TeamID}"
			+"&teamManagerID=${getMap.TeamManagerID}"
			+"&defItemTypeCode=${defItemTypeCode}&hideTitle=Y"
			+"&subTeam=${subTeam}";
	
	if(avg2 == '1') data += '&itemListPage=/itm/structure/ownerItemListV4';
	if(avg2 == '2') data += '&itemListPage=/adm/role/teamRoleMgtV4';
			
	var target="orgFrame";
	
	ajaxPage(url,data,target);
	
	for(var i = 0 ; i < 5; i++){
		if(i == avg2){
			$("#pliOM"+i+" a").addClass("tab--active");
		}else{
			$("#pliOM"+i+" a").removeClass("tab--active");
		}
	}
}
	
</script>
</head>
<body>
<div class=" pdT10 pdB10 pdR10 pdL10">
	<form name="orgInfo" id="orgInfo" action="#" method="post" onsubmit="return false;">
		<div class="msg">
			<img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png" style="width:20px;" class="mgR5">&nbsp;Organization Info.		
		</div>
		<table class="tbl_blue01" width="100%" border="0" cellpadding="0"	cellspacing="0">
			<colgroup>
				<col width="10%">
				<col width="31%">
				<col width="10%">
				<col width="27%">
				<col width="10%">
				<col width="12%">
			</colgroup>
			
			<tr>
				<th class="alignL pdL10">${menu.LN00028}</th>
				<td class="alignL pdL10">${getMap.OrgName}</td>
				<th class="alignL pdL10">${menu.LN00164}</th>
				<td class="alignL pdL10">${getMap.TeamCode}</td>
				<th class="alignL pdL10">Team Type</th>
				<td class="alignL pdL10 last">${getMap.TeamTypeNM}</td>
			
			</tr>
			
			<tr>
				<th class="alignL pdL10">${menu.LN00014}</th>
				<td class="alignL pdL10">${getMap.CompanyName}</td>
				<th class="alignL pdL10">${menu.LN00162}</th>
				<td class="alignL pdL10">${getMap.ParentOrgPath}</td>
				<th class="alignL pdL10">Ref. Team</th>
				<td class="alignL pdL10 last">${getMap.RefTeamNM}</td>
			
			
			</tr>
			<tr>
				<th class="alignL pdL10">${menu.LN00288}</th>
				<td class="alignL pdL10">${authorNM}</td>
				<th class="alignL pdL10">Manager</th>
				<td class="alignL pdL10">${getMap.TeamManagerNM}</td>
				<th class="alignL pdL10">Role Manager</th>
				<td class="alignL pdL10 last">${getMap.RoleManagerNM}</td>
			
			</tr>
		</table>
	</form>
	<div class="tabbar">
		<ul>
			<li id="pliOM1" class="flex align-center"><a href="javascript:setorgFrame('itemListMgt','1','ownerTeam');" class="flex align-center"><span>${menu.LN00190}</span></a></li>			
			<li id="pliOM2" class="flex align-center"><a href="javascript:setorgFrame('itemListMgt','2','team');" class="flex align-center"><span>${menu.LN00119}</span></a></li>	
			<c:if test="${loginInfo.sessionMlvl == 'SYS'}">	
			<li id="pliOM3" class="flex align-center"><a href="javascript:setorgFrame('childOrgMgt','3');" class="flex align-center"><span>${menu.LN00048}</span> </a></li>
			</c:if>
			<c:if test="${empty loginInfo.sessionSecuLvl || loginInfo.sessionSecuLvl < 2}">
			<li id="pliOM4" class="flex align-center"><a href="javascript:setorgFrame('orgMemberMgt','4');" class="flex align-center"><span>${menu.LN00037}</span></a></li>
			</c:if>	
		</ul>
	</div>
	
	<div id="orgFrame"></div>
</div>
</body>
</html>