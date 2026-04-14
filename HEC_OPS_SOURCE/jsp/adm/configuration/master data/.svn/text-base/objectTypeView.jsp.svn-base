<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root" />

<!--1. Include JSP -->
<!--  <script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script> -->

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />

<!-- Script -->
<script type="text/javascript">

	$(document).ready(function() {
		fnSelect('getLanguageID', '', 'langType', '${languageID}', 'Select');
		fnSelect('ObjCategory', '', 'ObjCategoryCode', '${resultMap.Category}', 'Select');
	});

	function UpdateObjectType() {
		if (confirm("${CM00001}")) {
			var checkConfirm = false;
			if ('${sessionScope.loginInfo.sessionCurrLangType}' != $("#getLanguageID").val()) {
				if (confirm("${CM00006}")) {
					checkConfirm = true;
				}
			} else {
				checkConfirm = true;
			}

			if(checkConfirm) {
				var url = "UpdateObjectType.do";
				ajaxSubmit(document.ObjectTypeViewList, url, "blankFrame");
			}
		}

	}

	function goBack() {
		var url = "DefineObjectType.do";
		var data =   "&pageNum=" + $("#currPage").val();
		var target = "objectTypeDiv";
		
		ajaxPage(url, data, target);
	}
	
	function CheckBox1(){
		
		var chk1 = document.getElementsByName("check1");
		
		if(chk1[0].checked == true)
		{
			
			$("#objDeactivated").val("1");
		}
		else{
			
			$("#objDeactivated").val("0");
		}
		
	}

function objReload(){
	var url    = "objectTypeView.do"; // 요청이 날라가는 주소
	var data   = "LanguageID="+$("#getLanguageID").val() +
				 "&ItemTypeCode="+$("#objItemTypeCode").val() +
				 "&pageNum=" + $("#currPage").val();
	var target = "objectTypeDiv";
	ajaxPage(url,data,target);
}

function onlyNumber(){
	if((event.keyCode < 48) || (event.keyCode > 57)){
		event.returnValue = false;
	}
}

// [Allocation] click
function editAttrSortNum() {
	var url = "editAttrSortNumPop.do?";
	var data = "itemTypeCode=${resultMap.ItemTypeCode}";
	var option = "width=450,height=600,left=300,top=100,toolbar=no,status=no,resizable=yes";
    window.open(url+data, self, option);
}

</script>

<form name="ObjectTypeViewList" id="ObjectTypeViewList" action="*" method="post" onsubmit="return false;">	
	<div id="groupListDiv" class="hidden" style="width: 100%; height: 100%;">
		<input type="hidden" id="orgLastUser" name="orgLastUser" value="${sessionScope.loginInfo.sessionUserId}" />
		<input type="hidden" id="SaveType" name="SaveType" value="Edit" /> 
		<input type="hidden" id="objDeactivated" name="objDeactivated" value="${resultMap.Deactivated}">
		<input type="hidden" id="objItemTypeCode" name="objItemTypeCode" value="${resultMap.ItemTypeCode}">
		<input type="hidden" id="currPage" name="currPage" value="${pageNum}"/> 
	</div>
			
	<div class="cfg">
		<li class="cfgtitle"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Edit Object Type</li>
		<li class="floatR pdR20 pdT10">
		  <select id="getLanguageID" name="getLanguageID" onchange="objReload()"></select>
		</li>
	</div><br>
	<table style="table-layout:fixed;" class="tbl_blue01" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="14%">
			<col width="20%">
			<col width="14%">
			<col width="20%">
			<col width="14%">
			<col width="20%">
		</colgroup>
		<tr>
			<th class="viewtop">${menu.LN00015}</th>
			<td class="viewtop">${resultMap.ItemTypeCode}</td>
			<th class="viewtop">${menu.LN00028}</th>
			<td class="viewtop">
			<input type="text" class="text" id="objName" name="objName" value="${resultMap.Name}" maxlength="255" /></td>

			<th class="viewtop">
				<c:if test="${!empty resultMap.Icon}"><img src="${root}${HTML_IMG_DIR_ITEM}/${resultMap.Icon}"/></c:if>
				<c:if test="${empty resultMap.Icon}">Icon</c:if>
			</th>
			
			<td class="viewtop last">
				<c:if test="${!empty resultMap.Icon}"><input type="text" class="text" id="objIcon" name="objIcon" value="${resultMap.Icon}" /></c:if>
			</td>
			
		</tr>

		<tr>
			<th>DefArc</th>
			<td><input type="text"  class="text" id="objDefArc" name="objDefArc" value="${resultMap.DefArc}"/></td>
			
			<th>RootItemID</th>
			<td><input type="text" class="text" id="objRootItemId" name="objRootItemId" value="${resultMap.RootItemID}" onkeypress="onlyNumber();" style="ime-mode:disabled"/></td>
			
			<th>Category</th>
			<td class="last">
				<select id="ObjCategory" name="ObjCategory"></select>
			</td>
		</tr>
		<tr>	
			<th>Deactivated</th>
			<td><input type="checkbox" name="check1" 
				<c:if test="${resultMap.Deactivated == '1'}">
					checked="checked"
				</c:if>
				value="${resultMap.Deactivated}" onclick="CheckBox1()"></td>
				
			<th>${menu.LN00060}</th>
			<td>${resultMap.CreateName}</td>

			<th>${menu.LN00013}</th>
			<td class="last">${resultMap.CreationTime}</td>
		<tr>
			<!--  <th></th>-->
			<td colspan="8" style="height:180px;" class="tit last">
			<textarea id="objDescription" name="objDescription" rows="12" cols="50" style="width: 100%; height: 98%;border:1px solid #fff" >${resultMap.Description}</textarea></td>
		</tr>
		<tr>
			<td class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="8">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}"> 
					<span class="btn_pack small icon"><span class="edit"></span><input value="Allocation" type="submit" onclick="editAttrSortNum();"></span>
					<span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit" onclick="goBack()"></span>
					<span class="btn_pack medium icon"> <span class="save"></span><input value="Save" type="submit" onclick="UpdateObjectType()"></span>
				</c:if>	 	
			</td>
		</tr>
	</table>
</form>
	
<!-- START :: FRAME -->
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
</div>
		

