<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root" />

<!--1. Include JSP -->

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />

<!-- Script -->
<script type="text/javascript">

	$(document).ready(function() {
		fnSelect('getLanguageID', '', 'langType', "${sessionScope.loginInfo.sessionCurrLangType}", 'Select');
 		fnSelect('menuType', '', 'getMenuCat', "${resultMap.MenuCat}", 'Select');
		if("${resultMap.ItemID}" != '0'){
			doCallBack("${resultMap.ItemID}");
		}
	});
	
	// [Save] Click
	function updateMenu() {
		if($("#program").val() == ''){$("#s_itemID").val("");}
		if ($("input:checkbox[id='deActivatedCheck']").is(":checked") == true ) {
			$("#menuDeactivated").val("1");
		} else {
			$("#menuDeactivated").val("0");
		}
		if (confirm("${CM00001}")) {
			var url = "updateMenu.do";
			ajaxSubmit(document.menuDetailFrm, url, "saveFrame");
		}
	}
	
	// [List] Click
	function goBack() {
		var url = "DefineMenuTypeGrid.do";
		var data = "pageNum=${pageNum}";
		var target = "menuTypeDiv";
		ajaxPage(url, data, target);
	}
	
	function fnCallBack(){
		var url = "DefineMenuTypeGrid.do";
		var data = "&pageNum=" + $("#CurrPageNum").val();
		var target = "menuDetailFrm";
		ajaxPage(url, data, target);
	}
	
	function searchItem(){
		var url = "orgItemTreePop.do";
		var data = "ItemID="+$("#s_itemID").val()+"&ItemTypeCode=OJ00004";
		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}
	
	function doCallBack(avg){
		var ItemID = avg;
		$("#s_itemID").val(ItemID);
		var url = "getPathOrg.do";
		var data = "ItemID="+ItemID;
		var target = "blankFrame";
		ajaxPage(url,data,target);
	}

	function thisReload(Path){
		$("#program").val(Path);
		$(".popup_div").hide();
		$("#mask").hide();
	}

</script>

<div id="menuDetailtDiv" class="hidden" style="width: 100%; height: 100%;">
	<form name="menuDetailFrm" id="menuDetailFrm" action="*" method="post" onsubmit="return false;">
		<input type="hidden" id="menuDeactivated" name="menuDeactivated" value="${resultMap.Deactivated}">
		<input type="hidden" id="menuId" name="menuId" value="${resultMap.MenuID}">
		<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
		<input type="hidden" id="s_itemID" name="s_itemID" value="${resultMap.ItemID}" />
				           
        <div class="cfg">
	         <li class="cfgtitle"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Edit Menu</li>
	         <li class="floatR pdR20 pdT10">
	           <select id="getLanguageID" name="getLanguageID"  onchange="thisReload()"></select>
	         </li>
        </div><br>			
		<table style="table-layout:fixed;" class="tbl_blue01" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="8%">
				<col width="20%">
				<col width="8%">
				<col width="20%">
			</colgroup>
			<tr>
				<th class="viewtop">${menu.LN00015}</th>
				<td class="viewtop">${resultMap.MenuID}</td>

				<th class="viewtop">${menu.LN00028}</th>
				<td class="viewtop last">
					<input type="text" class="text" id="menuName" name="menuName" value="${resultMap.MenuName}" maxlength="255" />
					<%-- <select id="menuName" name="menuName" style="width:100%;">
						<option value="">Select</option>	
						<c:forEach var="i" items="${labelList}">
							<option value="${i.TypeCode}" <c:if test="${i.TypeCode eq resultMap.DicCode}"> selected="selected"</c:if>>${i.Name}</option>						
						</c:forEach>
					</select> --%>
				</td>
			</tr>
			<tr>
				<th>Category</th>
				<td>
					<select id="menuType" name="menuType" style="width:100%;"></select>
				</td>

				<th>Program</th>
				<td class="last">
					<input type="text" name="program" id="program" value="${resultMap.program}" onclick="searchItem()" class="text"  />
				</td>
			</tr>

			<tr>
				<th>URL</th>
				<td>
					<input type="text" class="text" id="menuUrl" name="menuUrl" value="${resultMap.URL}" maxlength="255" />
				</td>
				
				<th>VarFilter</th>
				<td  class="last">
					<input type="text" class="text" id="menuVarFilter" name="menuVarFilter" value="${resultMap.VarFilter}" maxlength="255" />
				</td>
			</tr>
			<tr>
				<th>
					<c:if test="${resultMap.Icon eq 'btn_dim_del.png'}">
						<img src="${root}${HTML_IMG_DIR_ITEM}/${resultMap.Icon}">
					</c:if>
					<c:if test="${resultMap.Icon != 'btn_dim_del.png'}">
						<img src="${root}${HTML_IMG_DIR_SHORTCUT}/${resultMap.Icon}">
					</c:if>
				</th>
				<td >
					<c:if test="${resultMap.Icon eq 'btn_dim_del.png'}">
						<input type="text" class="text" id="menuIcon" name="menuIcon" value="">
					</c:if>
					<c:if test="${resultMap.Icon != 'btn_dim_del.png'}">
						<input type="text" class="text" id="menuIcon" name="menuIcon" value="${resultMap.Icon}">
					</c:if>
				</td>
				
				<th>Deactivated</th>
				<td class="last">
					<input type="checkbox" id="deActivatedCheck" <c:if test="${resultMap.Deactivated == '1'}">checked="checked"</c:if> value="${resultMap.Deactivated}">
				</td>
			</tr>
			<tr>
				<td colspan="4" style="height:180px;" class="tit last">
				<textarea id="description" name="description" rows="12" cols="50" style="width: 100%; height: 98%;border:1px solid #fff" >${resultMap.Description}</textarea>
				</td>
			</tr>
			<tr>
				<td class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="4">
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				   		<span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit" onclick="goBack()"></span>
						<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="updateMenu()"></span>
					</c:if>	 	
				</td>
			</tr>
		</table>
	</form>

	<!-- START :: FRAME -->
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;"></iframe>
		
</div>
