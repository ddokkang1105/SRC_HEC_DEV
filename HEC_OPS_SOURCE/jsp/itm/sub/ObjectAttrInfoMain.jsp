<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP/CSS -->
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/model.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120" />
<script type="text/javascript">
	var chkReadOnly = true;
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
<script type="text/javascript">
var isPossibleEdit = "${isPossibleEdit}";
var itemStatus = "${itemStatus}";

function editPopup(url){
   	var data = "?s_itemID=${s_itemID}&languageID="+$('#languageID').val();  	
    	var w = 940;
	var h = 700;
	window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");	
}

function fnUrlReload(){
	var screenType = "${screenType}";
	if(screenType=="model"){		
		reload();
	}else{
		parent.document.getElementById("diagramInfo").src="subMenu.do?url=occMenu&s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID=${ModelID}";
	}
} 

function fnRunSAP(url, attrUrl, attrTypeCode){ 
	var lovCode = "${lovCode}";	
	var itemID = "${s_itemID}";
	if(url == null || url == ""){ 
		url = attrUrl; 
		itemID = "${fromItemID}";
	}

	url = url+".do?itemID="+itemID+"&loveCode="+lovCode+"&attrTypeCode="+attrTypeCode; 
	window.open(url,'_newtab');
}


</script>
</head><body>
<form name="OAIFrm" id="OAIFrm" action="saveObjAttrChild.do" method="post" onsubmit="return false;">
	<input type="hidden" id="s_itemID" name="s_itemID"  value="${s_itemID}" />
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
	<div id="objectInfoDiv" class="hidden" style="width:100%;height:100%;">
	<div id="obAttrDiv" style="margin-bottom:20px;overflow-x:hidden;overflow-y:hidden;">
		<table class="tbl_blue01" style="width:100%;margin-top:5px;" >
			<colgroup>
				<col width="25%">
				<col width="75%">
				<col>
			</colgroup>
			<c:if test="${itemInfo eq '' }">
				<tr>
					<td  class="viewtop alignC" colspan = 2>
						 No attribute type allocated 
					</td>
				</tr>
			</c:if>
			<tr>
				<th class="viewtop alignC">${menu.LN00028}</th>
				<td class="viewtop alignL" style="padding:5px 0 5px 10px;">${itemInfo.ItemName}</td>
			</tr>	
			<tr>
				<th class="alignC">${menu.LN00106}</th>
				<td class="alignL" style="padding:5px 0 5px 10px;">${identifier}</td>
			</tr>	
			<!-- Item_Attr -->
			<c:forEach var="i" items="${getList}" varStatus="iStatus">
				<tr>
					<th class="alignC">${i.Name}</th>
					<td class="tit" style="height:${i.AreaHeight}px;">
						<c:if test="${i.HTML eq '1'}">
							<textarea class="tinymceText" style="width:100%;height:${i.AreaHeight}px;">${i.PlainText}</textarea>
						</c:if>
						<c:if test="${i.HTML ne '1'}">						
							<c:if test="${i.Link == null}" >
							<textarea style="width:100%;height:${i.AreaHeight}px;" readonly="readonly">${i.PlainText}</textarea>
							</c:if>
							<c:if test="${i.Link != null}" >
								<a href="#" onClick="fnRunSAP('${i.URL}','${attrUrl}','${i.AttrTypeCode}');" style="color:#0054FF;text-decoration: underline;"> 
								${i.PlainText}
								</a>
							</c:if>
						</c:if>
					</td>			
				</tr>
			</c:forEach>
			<tr>
				<th class="alignC">${menu.LN00027}</th>
				<td class="alignL" style="padding:5px 0 5px 10px;">${itemInfo.ItemStatusText}</td>
			</tr>
			<tr>
				<th class="alignC">${menu.LN00070}</th>
				<td class="alignL" style="padding:5px 0 5px 10px;">${itemInfo.LastUpdated}</td>
			</tr>
			<tr>
				<th class="alignC">${menu.LN00013}</th>
				<td class="alignL" style="padding:5px 0 5px 10px;">${itemInfo.CreateDT}</td>
			</tr>
			<tr>
				<th class="alignC">${menu.LN00004}</th>
				<td class="alignL" style="padding:5px 0 5px 10px;">${itemInfo.AuthorName}(${itemInfo.OwnerTeamName})</td>
			</tr>
		</table>
		 <c:if test="${fn:length(getList) > 0 && attrRevYN ne 'Y' && isPossibleEdit eq 'Y'}">
		 	<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor' and myItem == 'Y'}">
				<div class="alignBTN">
					<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" onclick="editPopup('editAttrPop.do')" type="submit"></span>
				</div>
			</c:if>
		</c:if>
	</div>			
	</div>
</form>
</body></html>
