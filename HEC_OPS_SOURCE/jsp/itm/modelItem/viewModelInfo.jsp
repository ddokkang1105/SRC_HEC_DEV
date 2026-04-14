<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<script type="text/javascript">
	var chkReadOnly = true;	
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<head>

<script type="text/javascript">
	
	$(document).ready(function(){		
		
	});
	
	function updateModel(){
		var blocked = "${Blocked}";
		var itemAthId = "${itemAthId}";
		var userId = "${sessionScope.loginInfo.sessionUserId}";
		var modelBlocked = "${modelInfo.ModelBlocked}";
	
		if(blocked != "2" && itemAthId == userId && modelBlocked == "0" || '${loginInfo.sessionMlvl}' == "SYS"){
			if(confirm("${CM00001}")){
				doBlockedChecked();
				doIsPublicChecked();
				var url  = "updateModel.do";
				ajaxSubmit(document.objectInfoFrm, url,"subFrame");
			}
		}else{			
			alert("${WM00040}"); return;
		}
		
	}
	
	function callbackUpdate(){
		self.close();
		opener.reloadList();
	}
	
	function doBlockedChecked(){		
		if ($("input:checkbox[id='Blocked']").is(":checked") == true){
			$("#Blocked").val(1);
		}else{
			$("#Blocked").val(0);
		}
	}
	
	function doIsPublicChecked(){		
		if ($("input:checkbox[id='IsPublic']").is(":checked") == true){
			$("#IsPublic").val(1);
		}else{
			$("#IsPublic").val(0);
		}
	}
	
</script>
</head>
<body >	
	<div id="objectInfoDiv" class="hidden" style="width:98%;height:220px;padding:0 10px 0 10px;">
		<table class="tbl_blue01 mgT10" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="10%">
				<col width="15%">
				<col width="10%">
				<col width="15%">
				<col width="10%">
				<col width="15%">
				<col width="10%">	
				<col width="15%">			
			</colgroup>		
			<tr>
				<th width="10%" >${menu.LN00028}</th>
				<td width="15%" align="left">${modelInfo.ModelName}</td>
				<th width="10%" style="word-break:break-all">${menu.LN00032}</th>
				<td width="15%" align="left">${modelInfo.ModelTypeName}</td>
				<th width="10%" style="word-break:break-all">${menu.LN00033}</th>
				<td width="15%" align="left"  >${modelInfo.MTCategoryName}</td>
				<th width="10%" style="word-break:break-all">${menu.LN00027}</th>
				<td width="15%" align="left" class="last">${modelInfo.StatusName}</td>
			</tr>
			<tr>
				<th width="10%" style="word-break:break-all">${menu.LN00060}</th>
				<td width="15%" align="left">${modelInfo.CreatorNm}</td>
				<th width="10%" style="word-break:break-all">${menu.LN00013}</th>
				<td width="15%" align="left">${modelInfo.CreationTime}</td>
				<th width="10%" style="word-break:break-all">${menu.LN00105}</th>
				<td width="15%" align="left">${modelInfo.LastUserNm}</td>
				<th width="10%" style="word-break:break-all">${menu.LN00070}</th>
				<td width="15%" align="left"  class="last">${modelInfo.LastUpdated}</td>
			</tr>			
			<tr>
				<th width="10%" style="word-break:break-all">Valid From</th>
				<td width="15%" align="left">${modelInfo.ValidFrom}</td>
				<th width="10%" style="word-break:break-all">Valid To</th>
				<td width="15%" align="left">${modelInfo.ValidTo}</td>
				<th width="10%" style="word-break:break-all">Blocked</th>
				<td width="15%" align="left">
					<input type="checkbox" id="Blocked" name="Blocked" value="${modelInfo.ModelBlocked}"
					<c:if test="${modelInfo.ModelBlocked == '1'}">
							checked="checked"
						</c:if> disabled></td>
				<th width="10%" style="word-break:break-all">Public</th>
				<td width="15%" align="left"  class="last">
					<input type="checkbox" id="IsPublic" name="IsPublic" value="${modelInfo.IsPublic}"
					<c:if test="${modelInfo.IsPublic == '1'}">
							checked="checked"
						</c:if> disabled>
				</td>
			</tr>
			<tr>
				<th width="10%">${menu.LN00035}</th>
				<td width="90%" colspan="7" class="last">
					<textarea id='description' name='description' style="width:100%;height:130px;" readOnly >${modelInfo.Description}</textarea>
				</td>
			</tr>
		</table>
		<div class="alignBTN" id="divUpdateModel" >			
		<c:if test="${modelInfo.ModelBlocked eq '0' && ( modelInfo.IsPublic eq '1' || myItem eq 'Y') }">
		<span class="btn_pack medium icon"><span class="edit"></span><input value="Edit" onclick="fnGoModelInfo('edit')" type="submit"></span>
		</c:if>	
	</div>	
		<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
</html>