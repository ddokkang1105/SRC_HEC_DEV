<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

<script type="text/javascript">
	$(document).ready(function(){	
		var roleType = "${teamRoleInfo.TeamRoleType}";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&assignmentType=TEAMROLETP";
		fnSelect('roleType', data, 'getOLMRoleType', roleType, 'Select');
	});
	
	function searchPopupWf(avg){
		var searchValue = $("#memberName").val();
		var url = avg + "&searchValue="+encodeURIComponent(searchValue)
		+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		
		window.open(url,'window','width=340, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function fnEditTeamRole(){
	   	var url = "teamRoleDetail.do";
		var data = "teamRoleID=${teamRoleID}&editYN=Y";
		var target = "teamRoleDiv";
		ajaxPage(url, data, target);
	}
	
	function setSearchNameWf(avg1,avg2,avg3,avg4,avg5,avg6,avg7){
		$("#memberName").val(avg2+"("+avg3+")");
		$("#memberID").val(avg1);
		$("#path").val(avg7);
	}
	
	function fnUpdateTeamRoleInfo(){
		if(!confirm("${CM00001}")){ return;}
		var roleManagerID = $("#memberID").val();
		var teamRoleType = $("#roleType").val();
		var roleDescription = $("#roleDescription").val();
		
		var url = "updateTeamRoleInfo.do";
		var target = "saveFrame";		
		var data = "teamRoleID=${teamRoleID}&roleManagerID="+roleManagerID+"&teamRoleType="+teamRoleType+"&roleDescription="+roleDescription;
		ajaxPage(url, data, target);
	}
	
	function fnTeamRoleCallBack(teamRoleID){
		var url = "teamRoleDetail.do";
		var data = "teamRoleID="+teamRoleID;
		var target = "teamRoleDiv";
		ajaxPage(url, data, target);
	}
		
</script>
</head>
<body>
<div id="teamRoleDiv">
<div id="csrDetailDiv" style="padding: 0 6px 6px 6px;"> 
<form name="projectInfoFrm" id="projectInfoFrm" method="post" action="#" onsubmit="return false;">	
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 6px 0 6px 0"><img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;${menu.LN00119}</h3>
	</div>
	<div id="objectInfoDiv" class="hidden floatC" style="width:100%;overflow-x:hidden;overflow-y:hidden;">
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="20%">
				<col width="30%">
				<col width="20%">
				<col width="30%">
			</colgroup>
			<tr>							
				<th class=" alignL pdL10 viewline">${menu.LN00247}</th> 
				<td class=" alignL pdL10 ">${teamRoleInfo.TeamNM}</td>
				<th class="alignL pdL10">${menu.LN00162}</th>
				<td class=" alignL pdL10 last">${teamRoleInfo.TeamPath}</td>
			  						
			</tr>	
		 	<tr>
			   <th class=" alignL pdL10">${menu.LN00119}</th>				  
			   <td class=" alignL pdL10" >
			   	<c:if test="${editYN eq 'Y'}" >
			   		<select id="roleType" name="roleType" class="sel" style="width:95%;"></select>
			   	</c:if>
			   	<c:if test="${editYN ne 'Y'}" >
			   		${teamRoleInfo.TeamRoleNM}
			   	</c:if>
			   </td>						
		       <th class="alignL pdL10">${menu.LN00004}</th>
		       <td class="alignL pdL10 last" > 
			   		<c:if test="${editYN eq 'Y'}" >
				   		<input type="text" class="text" value="${teamRoleInfo.RoleManagerNM}" id="memberName" name="memberName"  style="ime-mode:active;width:80%;" />
						<input type="hidden" value="${teamRoleInfo.RoleManagerID}" id="memberID" name="memberID" />
						<input type="image" class="image" id="searchMemberBtn" name="searchMemberBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="searchPopupWf('searchPluralNamePop.do?objId=memberID&objName=memberName&UserLevel=ALL')" value="Search">
					</c:if>
					<c:if test="${editYN ne 'Y'}" >
						${teamRoleInfo.RoleManagerNM}
					</c:if>
			   </td>			  	
			</tr>
	 		<tr>
		 		<th class="alignL pdL10 viewline">${menu.LN00035}</th>
				<td class="alignL pdL10 last" colspan="3" style="height:100px;" valign="Top"> 
					<textarea class="edit"  id="roleDescription" name="roleDescription" style="width:100%;height:160px;outline:none;">${teamRoleInfo.RoleDescription}</textarea>
				</td>
			</tr>
	  		<tr>
			    <td class="alignR pdR20 last" colspan="4">
			    	<c:if test="${sessionScope.loginInfo.sessionUserId eq teamRoleInfo.RoleManagerID && editYN ne 'Y'}" >
			    	<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="submit" onclick="fnEditTeamRole();"></span>  
			    	</c:if> 
			    	
			    	<c:if test="${sessionScope.loginInfo.sessionUserId eq teamRoleInfo.RoleManagerID && editYN eq 'Y'}" >
			    	<span id="viewSave" class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="fnUpdateTeamRoleInfo()"></span>
			    	</c:if>
		        </td>
			</tr>
  		</table>	
	</div>
	</form>
	</div></div>
	
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>
</body>
</html>