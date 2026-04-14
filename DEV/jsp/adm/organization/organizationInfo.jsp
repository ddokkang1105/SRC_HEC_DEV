<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>  
<c:url value="/" var="root"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
 
<script type="text/javascript">

$(document).ready(function(){
	
	$.ajaxSetup({
		headers: {
			'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
		},
	});	
	
	fnSelect('teamType','&Category=TMTP','getDicWord','${getMap.TeamType}'); // Type
	fnSelect('companyID', '', 'getCompany', '${getMap.CompanyID}', '',''); // 법인
	
	var data = "&LanguageID=${languageID}";	
	fnSelect('itemTypeCode',data,'itemTypeCode','${getMap.ItemTypeCode}','Select');
	
});

// [Save] button Click
function saveOrgInfo(){
	if($("#Name").val() == ""){alert("${WM00034_1}");$("#Name").focus();return false;}
	var teamId = "${getMap.TeamID}";
	var isNew = "Y";
	if (teamId != "") {
		isNew = "N";
	}
	if($("#path").val() == ""){$("#ItemID").val("");}
	if(confirm("${CM00001}")){ 
		var url    = "admin/saveOrgInfo.do"; 
		var data   = "TeamType="+$("#teamType").val()
					+"&companyID="+$("#companyID").val()
					+"&teamName="+encodeURIComponent($("#Name").val())
					+"&TeamCode="+$("#TeamCode").val()	
					+"&TeamID=${getMap.TeamID}"
					+"&parentID=${parentID}"
					+"&ItemID="+$("#ItemID").val()
					+"&isNew="+isNew; //파라미터들
		var target = "saveFrame";
		ajaxPage(url, data, target);
	}
}

function searchItem(){
	var url = "orgItemTreePop.do";
	var data = "s_itemID=${s_itemID}&ItemID="+$("#ItemID").val()+"&ItemTypeCode="+$("#itemTypeCode").val();
	fnOpenLayerPopup(url,data,doCallBack,617,436);
}
function doCallBack(avg){
	var ItemID = avg;
	$("#ItemID").val(ItemID);
	var url = "getPathOrg.do";
	var data = "ItemID="+ItemID;
	var target = "blankFrame";
	ajaxPage(url,data,target);
}

function thisReload(Path){
	$("#path").val(Path);
	$(".popup_div").hide();
	$("#mask").hide();
	doSearchList();
}

function itemTypeCodeSelect(){
	$("#path").val("");
	$("#ItemID").val("");
}

</script>
	
<form name="objectInfoFrm" id="objectInfoFrm" action="saveObjectInfo.do" method="post" onsubmit="return false;">
<div id="objectInfoDiv" class="hidden" style="width:100%;margin-top:-10px;">
	<table class="tbl_blue01 mgT10" width="100%" border="0" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="8%">
			<col width="17%">
			<col width="8%">
			<col width="17%">
			<col width="8%">
			<col width="17%">
			<col width="12%">
			<col width="15%">
			<col>
		</colgroup>
		<tr>		
			<th  class="viewtop">Code</th>
			<td  class="viewtop">
				<input type="text"class="text" id="TeamCode" name="TeamCode"  value="${getMap.TeamCode}"/>
			</td>
			
			<th  class="viewtop">${menu.LN00028}</th>
			<td  class="viewtop">
				<input type="text" class="text" id="Name" name="Name"  value="${getMap.OrgName}"/>
			</td>	
			<th  class="viewtop">Manager</th>
			<td  class="viewtop">${getMap.TeamManagerNM}</td>	
			<th  class="viewtop">Role Manager</th>
			<td class="last viewtop">${getMap.RoleManagerNM}</td>						
			
		</tr>
		
		<tr>
							
			<th>${menu.LN00014}</th>
			<td>
				<select style="float:left;width:100%;" id="companyID" name="companyID" ></select> 
			</td>			
			<th >Type</th>
			<td >
				<select style="float:left;width:85%;"  id="teamType" name="teamType" ></select> 
			</td>				
			<th>Item</th>
			<td class="last" colspan="3">
				<select style="float:left; width:45%;" id="itemTypeCode" name="itemTypeCode" onclick="itemTypeCodeSelect();"></select>
				<input style="float:left; width:45%; margin-left:2%;" type="text" class="text" id="path" value="${Path}" onclick="searchItem()" /></td>
				<input type="hidden" id="ItemID" value="${getMap.ItemID}" />
			</td>
		</tr>			
	</table>
	<div class="alignBTN">
		<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="saveOrgInfo()" type="submit"></span>
		</div>	
		<div id="subDiv"></div>
</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;"></iframe>
