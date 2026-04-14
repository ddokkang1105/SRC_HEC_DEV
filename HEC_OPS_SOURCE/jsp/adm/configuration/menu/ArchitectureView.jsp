<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root" />

<!--1. Include JSP -->
<!-- <script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script> -->

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />

<!-- Script -->
<script type="text/javascript">
	$(document).ready(function() {
		var languageID = "${languageID}";
		if(languageID == ""){languageID = '${sessionScope.loginInfo.sessionCurrLangType}';}
		var data = "&languageID="+languageID+"&menuCat=ARC";
		fnSelect('getLanguageID', '', 'langType',languageID, 'Select');
		fnSelect('filterType', '', 'getFilterType', '${resultMap.FilterType}', 'Select');
		fnSelect('menuType', data, 'getMenuType', '${resultMap.MenuID}', 'Select');
		$("#treeType").val("${resultMap.Type}").attr("selected", "selected");
		fnSelect('parentID','','getArcCode','${resultMap.ParentID}', 'Select');
		$("#WID").val("${resultMap.WID}");
		$("#idFilter").val("${resultMap.IDFilter}");
	});

	function updateArchitecture() {
		if($("#dimTypePath").val() == ''){$("#dimTypeID").val("");}
		if (confirm("${CM00001}")) {
			var checkConfirm = false;
			if ('${sessionScope.loginInfo.sessionCurrLangType}' != $("#getLanguageID").val()) {
				if (confirm("${CM00006}")) {
					checkConfirm = true;
				}
			} else {
				checkConfirm = true;
			}

			if (checkConfirm) {
				var url = "updateArchitectrue.do?viewType=${viewType}";
				ajaxSubmit(document.ArchitecturDetail, url);
			}
		}

	}

	function goBack() {
		var url = "DefineArchitecture.do";
		var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}" + "&pageNum=" + $("#currPage").val();
		var target = "processListDiv";
		
		ajaxPage(url, data, target);
	}
	
	function fnArcAllocation(){
		var type = "${resultMap.Type}";
		var url = "subTab.do";
		var urlDetail = "";
		
		if(type=="G"){
			url = "allocateArchitecture.do";
		}else{
			urlDetail = "DefineArchitectureMenu";
		}
		var data ="url="+urlDetail+"&ArcCode=${resultMap.ArcCode}"
				+ "&pageNum=" + $("#currPage").val()
				+ "&languageID="+ $("#getLanguageID").val()
				+ "&viewType=${viewType}"; 
		var target ="ArchitecturDetail";
		ajaxPage(url,data,target);
	}
	
	function CheckBox1(){
		var chk1 = document.getElementsByName("check1");
		if(chk1[0].checked == true){
			$("#objDimTypeID").val("1");
		}else{ $("#objDimTypeID").val("0");}
		
	}
/* 	function CheckBox2(){
		var chk2 = document.getElementsByName("WID");
		if(chk2[0].checked == true){
			$("#widVal").val("1");
		}else{
			$("#widVal").val("0");
		}
	} */
	
	function CheckBox3(){
		var chk3 = document.getElementsByName("Deactivated");
		if(chk3[0].checked == true){
			$("#Deactivated").val("1");
		}else{
			$("#Deactivated").val("0");
		}
	}
	
	function CheckBox4(){
		var chk4 = document.getElementsByName("UntitledOption");

		if(chk4[0].checked == true){
			$("#UntitledOption").val("Y");
		}else{
			$("#UntitledOption").val("N");
		}
	}

	function CheckBox5(){
		var chk5 = document.getElementsByName("SortOption");
		if(chk5[0].checked == true){
			$("#SortOption").val("1");
		}else{
			$("#SortOption").val("0");
		}
	}
	
	function ArcReload(){	
		var url    = "architectureView.do"; // 요청이 날라가는 주소
		var data   = "&ArcCode="+$("#ArcCode").val() +
					 "&languageID="+$("#getLanguageID").val() +
					 "&pageNum="+$("#currPage").val();
						
		var target = "processListDiv";		
		ajaxPage(url,data,target);
	}
	
	function fnChangeTreeType(){
		var treeType = $("#treeType").val();
		
		if(treeType=="G"){		
			$("#parentID").attr('disabled', 'disabled: true');	
		}
	}
	
	function searchItem(){
		var url = "orgItemTreePop.do";
		var data = "ItemID="+$("#dimTypeID").val()+"&ItemTypeCode=OJ00010";
		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}
	
	function doCallBack(avg){
		var ItemID = avg;
		$("#dimTypeID").val(ItemID);
		var url = "getPathOrg.do";
		var data = "ItemID="+ItemID;
		var target = "blankFrame";
		ajaxPage(url,data,target);
	}

	function thisReload(Path){
		$("#dimTypePath").val(Path);
		$(".popup_div").hide();
		$("#mask").hide();
	}

</script>

<form name="ArchitecturDetail" id="ArchitecturDetail" action="*" method="post" onsubmit="return false;">
<div id="groupListDiv" class="hidden" style="width: 100%; height: 100%;">
<input type="hidden" id="orgLastUser" name="orgLastUser" value="${sessionScope.loginInfo.sessionUserId}" />
<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}"> 
<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
<input type="hidden" id="dimTypeID" name="dimTypeID" value="${resultMap.DimTypeID}">
<div class="cfg">
	<li class="cfgtitle"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Edit Architecture</li>
	<li class="floatR pdR20 pdT10">
        <select id="getLanguageID" name="getLanguageID"	onchange="ArcReload()"></select></span>
	</li>
</div><br>
<table style="table-layout:fixed;" class="tbl_blue01" width="100%" border="0" cellpadding="0" cellspacing="0">
	<colgroup>
		<col width="9%">
		<col width="16%">
		<col width="9%">
		<col width="16%">
		<col width="9%">
		<col width="16%">
		<col width="9%">
	</colgroup>
	<tr>
		<th class="viewtop">${menu.LN00015}</th>
		<td class="viewtop"><input type="text" class="text" id="ArcCode" name="ArcCode" value="${resultMap.ArcCode}" /></td>
		<th class="viewtop">Name</th>
		<td class="viewtop"><input type="text" class="text" id="ArcName" name="ArcName" value="${resultMap.ArcName}" /></td>
		<th class="viewtop">Style</th>
		<td class="viewtop"><input type="text" class="text" id="Style" name="Style" value="${resultMap.Style}" /></td>
		<th class="viewtop">Icon</th>
		<td class="viewtop"><input type="text" class="text" id="Icon" name="Icon" value="${resultMap.Icon}" /></td>
	</tr>
	<tr>
		<th>Parent Arc.</th>
		<td><select id="parentID" name="parentID" style="width:100%;" ></select></td>
		<th>MenuType</th>
		<td>
			<select id="treeType" name="treeType" style="width:100%;" OnChange="fnChangeTreeType()" >
				<option value="G">Group</option>
				<option value="T">Tree</option>
				<option value="M">Menu</option>
			</select>
		</td>					
		<th>Menu</th>
		<td>
			<select id="menuType" name="menuType" style="width:100%;" ></select> 
		</td>	
		<th>FilterType</th>
		<td>
			<c:if test="${resultMap.Type != 'G'}">
				<select id="filterType" name="filterType" style="width:100%;" ></select>
			</c:if>
		</td>
	</tr>
	<tr>
		<th>Show ID</th>
		<td>
			<select id="WID" name="WID" style="width:100%;">
				<option value="0">Select</option>
				<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
			</select>
		</td>
		<th>ID Filter</th>
		<td class="last">
			<select id="idFilter" name="idFilter" style="width:100%;">
				<option value="">Select</option>
				<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
			</select>
		</td>
		<th>SortOption</th>
		<td><input type="checkbox" name="SortOption" id="SortOption"  
			<c:if test="${resultMap.SortOption == '1'}">
				checked="checked"
			</c:if>				
			value="${resultMap.SortOption}" onclick="CheckBox5()"></td>
			<th>UntitledOption</th>
			<td class="last">
				<input type="checkbox" name="UntitledOption" id="UntitledOption"  
				<c:if test="${resultMap.UntitledOption == 'Y'}">
					checked="checked"
				</c:if>				
				value="${resultMap.UntitledOption}" onclick="CheckBox4()">
			</td>		
	</tr>
	<tr>
		<th>VarFilter</th>
		<td colspan="3"><input type="text" class="text" id="varFilter" name="varFilter" value="${resultMap.VarFilter}" /></td>
		<th>DimTypeID</th>
		<td><input type="text" id="dimTypePath" name="dimTypePath" value="${resultMap.Path}" onclick="searchItem()" class="text" /></td>
		<th>DeActivated</th>
		<td class="last"><input type="checkbox" name="Deactivated" id="Deactivated"  
			<c:if test="${resultMap.Deactivated == '1'}">
				checked="checked"
			</c:if>				
			value="${resultMap.Deactivated}" onclick="CheckBox3()"></td>
	</tr>
	<tr>
		<td colspan="8" style="height:180px;" class="tit last">
		<textarea id="objDescription" name="objDescription" rows="12" cols="50" style="width: 100%; height: 98%;border:1px solid #fff" >${resultMap.Description}</textarea>
		</td>
	</tr>
	<tr>
		<td class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="8">
			<c:if test="${viewType == 'E' && resultMap.Type != 'M'}">
			<span class="btn_pack medium icon"> 
			<span class="allocation"></span><input value="Allocation" type="submit" id="Allocation" onclick="fnArcAllocation()"></span> </c:if>
			<span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit" onclick="goBack()"></span>
		    <span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="updateArchitecture()"></span>	 	
		</td>
	</tr>
</table>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</div>
</form>
