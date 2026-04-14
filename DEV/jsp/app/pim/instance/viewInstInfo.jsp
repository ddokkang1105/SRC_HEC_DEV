<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP/CSS -->
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/model.css">
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">


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
		parent.document.getElementById("diagramInfo").src="elmInfoTabMenu.do?s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&modelID=${ModelID}";
	}
} 

function fnRunSAP(url, attrUrl){ 
	var lovCode = "${lovCode}";	
	var itemID = "${s_itemID}";
	if(url == null || url == ""){ 
		url = attrUrl; 
		itemID = "${fromItemID}";
	}

	url = url+".do?itemID="+itemID+"&loveCode="+lovCode; 
	window.open(url,'_newtab');
}


</script>
</head><body>
<form name="viewProcElmFrm" id="viewProcElmFrm" action="" method="post" onsubmit="return false;">	
	<div id="obAttrDiv" style="margin-top:5px;margin-bottom:20px;	width:100%;hegiht:100%;overflow:hidden;line-height:1.3em;font-weight:normal;">
		<table style="table-layout: fixed;" width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_blue01">
		<colgroup>
			<col width="30%">
			<col width="70%">
		</colgroup>		
		<c:if test="${procInstanceInfo.size() == 0 && elmInstanceInfo.size() == 0}">
			<tr>	
				<td style="height:20px;" colspan="2">No information</td>
			</tr>
		</c:if>
		<c:choose>		
   		<c:when test="${elmInstanceInfo.size() > 0}">
			<tr>	
				<th>ID</th>
				<td style="text-align:left" class="last"><input type="text" value="${elmInstanceInfo.Identifier}" style="width:100%;border:0px;" readOnly></td>
			</tr>
			<tr>
				<th>${menu.LN00028}</th>
				<td style="text-align:left" class="last"><input type="text" value="${elmInstanceInfo.elmItemName}" style="width:100%;border:0px;" readOnly></td>
			</tr>
			<tr>	
				<th>Project</th>
				<td style="text-align:left" class="last"><input type="text" value="${procInstanceInfo.ProcInstanceNM}" style="width:100%;border:0px;" readOnly></td>
			</tr>
			<tr>
				<th>role 명</th>
				<td style="text-align:left" class="last"><input type="text" value="${elmInstanceInfo.roleName}" style="width:100%;border:0px;" readOnly></td>
			</tr>
			<tr>
				<th>${menu.LN00004}</th>
				<td style="text-align:left" class="last"><input type="text" value="${elmInstanceInfo.actorName}" style="width:100%;border:0px;" readOnly></td>
			</tr>
			<tr>
				<th>${menu.LN00061}</th>
				<td style="text-align:left" class="last"><input type="text" value="${elmInstanceInfo.SchStartDate}" style="width:100%;border:0px;" readOnly></td>
			</tr>
			<tr>
				<th>Email Date</th>
				<td style="text-align:left" class="last"><input type="text" value="${elmInstanceInfo.AlarmDate}" style="width:100%;border:0px;" readOnly></td>
			</tr>	
			<tr>
				<th>${menu.LN00027}</th>
				<td style="text-align:left" class="last">${elmInstanceInfo.StatusNM}</td>
			</tr>			
			<c:if test="${instAttrList.size() > 0}">
				<c:forEach var="attrList" items="${instAttrList}" varStatus="status">
				<c:choose>	
					<c:when test="${attrList.HTML eq '1'}">
						<tr>
							<th>${attrList.AttrTypeName}</th>
							<td class="tdLast alignL pdL5">
								<div style="width:100%;height:200px;">
									<textarea class="tinymceText" name="${attrList.AttrTypeCode}"  readonly="readonly">
										${attrList.PlainText}
									</textarea>
								</div>
							</td>
						</tr>	
					</c:when>
					<c:otherwise>
						<tr>
							<th>${attrList.AttrTypeName}</th>
							<td style="text-align:left" class="last"><input type="text" value="${attrList.PlainText}" style="width:100%;border:0px;" readOnly></td>
						</tr>	
					</c:otherwise>
				</c:choose>
				</c:forEach>
			</c:if>
			
		</c:when>		
		<c:otherwise>
		<c:if test="${procInstanceInfo.size() > 0}">
			<tr>	
				<th>Project No.</th>
				<td style="text-align:left" class="last"><input type="text" value="${procInstanceInfo.DocumentNo}" style="width:100%;border:0px;" readOnly></td>
			</tr>
			<tr>
				<th>Project Name</th>
				<td style="text-align:left" class="last"><input type="text" value="${procInstanceInfo.ProcInstanceNM}" style="width:100%;border:0px;" readOnly></td>
			</tr>
			<tr>	
				<th>Manager</th>
				<td style="text-align:left" class="last"><input type="text" value="${procInstanceInfo.OwnerName}(${procInstanceInfo.OwnerTeamName})" style="width:100%;border:0px;" readOnly></td>
			</tr>
			<tr>	
				<th>Start date</th>
				<td style="text-align:left"class="last">
					<c:choose>
						<c:when test="${scrnMode eq 'E' }">
							<input type="text" id="startTime" name="startTime" value="${procInstanceInfo.StartTime}" class="datePicker stext"
								style="width: 80px;text-align: center;" onchange="this.value = makeDateType(this.value);" maxlength="10">
							
						</c:when>
						<c:otherwise><input type="text" value="${procInstanceInfo.StartTime}" style="width:100%;border:0px;" readOnly></c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr>	
				<th>${menu.LN00027 }</th>
				<td style="text-align:left" class="last">${procInstanceInfo.StatusName}</td>
			</tr>
			<tr>	
				<th style="height:60px;">${menu.LN00035}</th>
				<td style="height:60px;" class="tdLast alignL pdL5 last" >
					<c:choose>
						<c:when test="${scrnMode eq 'E' }">
						<textarea class="edit" style="resize:none; width:100%; height:50px;background: #fff;" name="description">${procInstanceInfo.PrcInstanceDesc}</textarea>
						</c:when>
						<c:otherwise><textarea style="resize:none; width:100%; height:50px;background: #fff;" name="description">${procInstanceInfo.PrcInstanceDesc}</textarea></c:otherwise>
					</c:choose>
				</td>
			</tr>	
		</c:if>
		</c:otherwise>
		</c:choose>
		</table>
		
	</div>	
</form>
</body></html>
