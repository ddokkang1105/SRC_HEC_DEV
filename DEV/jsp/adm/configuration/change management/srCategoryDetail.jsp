<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root" />

<!--1. Include JSP -->
<!-- <script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script> -->

<!-- 화면 표시 메세지 취득    -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />


<!-- Script -->
<script type="text/javascript">

	$(document).ready(function() {
		
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			},
		});	
		
		fnSelect('languageID', '', 'langType', '${languageID}', 'Select');
		var data = "&srCatID=${resultMap.SRCatID}"
				+"&languageID=${languageID}" 
				+"&assignmentType=SRROLETP"
				+"&category=SRAREA"
				+"&option=OJ"
				+"&srType=${resultMap.SRType}"; 
				
		fnSelect('parentID', data, 'getSRCatParentID', '${resultMap.ParentID}', 'Select');
		fnSelect('srArea', data, 'getSRAreaClsName', '${resultMap.SRArea}', 'Select','esm_SQL');			
		fnSelect('roleType', data, 'getOLMRoleType', '${resultMap.RoleType}', 'Select');		
		fnSelect('ItemTypeCode',data,'getObjectCodeFromClass','${resultMap.ItemTypeCode}','Select', 'config_SQL');
		$("#level").val('${resultMap.Level}').attr("selected", "selected");
	//	$("#roleType").val('${resultMap.RoleType}').attr("selected", "selected");
	});
	
	function fnpopupMaterMdlEdt(){
		var modelID = $("#procPathID").val();
		var s_itemID = $("#ItemID").val();
		
		var url = "popupMasterMdlEdt.do?"
				+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&s_itemID="+s_itemID
				+"&modelID="+modelID
				+"&scrnType=view";
		
		var w = 1200;
		var h = 900;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}

	function fnSaveSrCat() {
		if (confirm("${CM00001}")) {
			var url = "admin/saveSRCat.do?viewType=${viewType}";
			ajaxSubmit(document.srCatDetail, url,"saveFrame");			
		}
	}

	function fnCallBack(){
		var url = "srCatList.do";
		var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}" + "&pageNum=" + $("#CurrPageNum").val();
		var target = "srCategoryDiv";
		ajaxPage(url, data, target);
	}
	
	function fnChangeParent(){
		if($("#parentID option:selected").val()==""){
			$("#level").val("1");
		}else{
			$("#level").val("2");			
		}
	}
	
	// 참조모델 팝업오픈
	function fnOpenModelListPop(){
		var url = "searchModelGridList.do?SRTypeCode=${resultMap.SRType}";
		var w = 900;
		var h = 500;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	//ProcModelIdSetting
	function doSetModelID(ModelID, ProcModelName){
		$("#procPathID").val(ModelID);
		$("#procModelName").text(ProcModelName);
	}
		
	function fnOnlyEnNum(obj){
		var regType = /^[A-Za-z0-9*]+$/;
        if(!regType.test(obj.value)) {
            obj.focus();
            $(obj).val( $(obj).val().replace(/[^A-Za-z0-9]/gi,"") );
            return false;
        }
    }
</script>

<div id="groupListDiv" style="width:99%;"> 
	<form name="srCatDetail" id="srCatDetail" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />
		<input type="hidden" id="CurrPageNum" name="CurrPageNum" value="${pageNum}">	
		<input type="hidden" id="ItemID" name="ItemID" value="${resultMap.ItemID}">	
		<input type="hidden" id="MTCategory" name="MTCategory" value="${resultMap.MTCategory}">	
		<div class="cfg">
			<li class="cfgtitle"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Edit SR Category</li>
			<li class="floatR pdR20 pdT10"><span><select id="languageID" name="languageID"></select></span>
			</li>
		</div><br>
		<table style="table-layout:fixed;" class="tbl_blue01" width="100%">
			<colgroup>
				<col width="6%">
				<col width="10%">
				<col width="6%">
				<col width="10%">
				<col width="6%">
				<col width="10%">
				<col width="6%">
				<col width="10%">
			</colgroup>
			<tr>
				<th class="viewtop alignL pdL10">${menu.LN00015}</th>
				<td class="viewtop">
					<input type="Text"  class="text" id="srCatID" name="srCatID" value="${resultMap.SRCatID}"  onkeyup="fnOnlyEnNum(this);" onchange="fnOnlyEnNum(this);" >	
				</td>
				<th class="viewtop  alignL pdL10">${menu.LN00028}</th>
				<td class="viewtop">
					<input type="text" class="text" id="srCatName" name="srCatName" value="${resultMap.SRCatName}"/>
				</td>
				<th class="viewtop alignL pdL10">Parent</th>
				<td class="viewtop">
					<select id="parentID" name="parentID"  onclick="fnChangeParent()" style="width:100%;"></select>
				</td>
				<th class="viewtop alignL pdL10">SR Type</th>
				<td class="viewtop last">
					<input type="Text" class="text" id="srType" name="srType" value="${resultMap.SRType}"  >
				</td>
			</tr>
			<tr>	
				<th class=" alignL pdL10">${menu.LN00021}</th>
				<td class=" alignL">
					<select name="ItemTypeCode" id="ItemTypeCode" style="width: 100%;"></select>
				</td>
				<th class=" alignL pdL10">Receiver level</th>
				<td class=" alignL">
					<select name=srArea id="srArea" style="width:100%;"></select>
				</td> 
				<th class=" alignL pdL10">Receiver</th>
				<td class="alignL ">
					<select name=roleType id="roleType" style="width:100%;"></select>						
				</td>
				<th class="alignL pdL10">Level</th>
				<td class="alignL last">
					<select name=level  id="level" style="width:100%;">
						<option value="1">1</option>
						<option value="2">2</option>
					</select>					
				</td>
			</tr>
			<tr>
				<th class="alignL pdL10">Model</th>
				<td class="alignL last" colspan="7">
					<input type="hidden" id="procPathID" name="procPathID" value="${resultMap.ProcPathID}" / >
					<span class="mgR10" id="procModelName" name="procModelName"
								style="cursor: pointer;line-height: 25px;border-bottom: 1px solid #000;" onclick="fnpopupMaterMdlEdt()">${resultMap.ProcModelName}</span>
								<span class="btn_pack medium icon"><span class="search"></span>
				<c:choose>
					<c:when test="${viewType == 'E' }"><input value="Modify" type="submit" onclick="fnOpenModelListPop();"></c:when>
					<c:otherwise><input value="Search" type="submit" onclick="fnOpenModelListPop();"></c:otherwise>
				</c:choose>
				</span>
				</td>
			</tr>
			<tr>
				<td class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="8">
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
						<c:if test="${viewType == 'E' }">
						<!-- <span class="btn_pack medium icon"><span class="list"></span><input value="Allocation" type="submit" onclick="fnAllocSrCat()"></span> -->
						</c:if>
						<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnCallBack()" value="List">List</button>
				        <button class="cmm-btn2 mgR5" style="height: 30px;" onclick="fnSaveSrCat()" value="Save">Save</button>	
					</c:if>
				</td>
			</tr>
		</table>
	</form>
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>
</div>