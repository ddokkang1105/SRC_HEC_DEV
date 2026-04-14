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
		var data = "&SRTypeCode=${resultMap.SRTypeCode}"
				+"&LanguageID=${languageID}"
				+"&languageID=${languageID}"
				+"&DocCategory=${resultMap.DocCategory}"
				+"&option=OJ"
				+"&ItemType=${resultMap.ItemType}"
				+"&menuCat=ARC";
				
		fnSelect('DocCategory', data+"&Category=DOCCAT", 'CategroyTypeCode', '${resultMap.TS_DocCategory}', 'Select');
		fnSelect('ItemType',data,'getObjectCodeFromClass','${resultMap.ItemTypeCode}','Select', 'config_SQL');
		fnSelect('MenuID', data, 'getMenuType', '${resultMap.MenuID}', 'Select');
		fnSelect('evalType', data+"&Category=EVTP", 'CategroyTypeCode', '${resultMap.EvalTypeCode}', 'Select');
		fnSelect('wfID', data+"&Category=WF", 'CategroyTypeCode', '${resultMap.DefWFID}', 'Select');
		$("#itemProposal").val('${resultMap.ItemProposal}').attr("selected", "selected");
		
		if ("${viewType}" == 'N')	{
			$("#SRTypeCode").attr('readonly', false);
		} else {
			$("#SRTypeCode").attr('readonly', true);
		}

	});

	//담당자 Search 팝업
	function searchmgt(){		
		$('#MgtUserNM').attr('onClick',"searchPopup('searchNamePop.do');");	
	}
	
	function searchPopup(url){ 
		window.open(url,'window','width=350, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}

	function setSearchName(memberID,memberName){
		$('#managerID').val(memberID);$('#MgtUserNM').val(memberName); 
	} 
	
	
	$("#DocCategory").change(function(){
		$("#ItemClassCodeNew").val($("#ItemClassNameNew").val());
	});

	function checkBox1(){			
		var chk1 = document.getElementsByName("Deactivated");
		if(chk1[0].checked == true){ $("#Deactivated").val("1");
		}else{	$("#Deactivated").val("0"); }
	}
	
	// 참조모델 팝업오픈
	function fnOpenModelListPop(){
		var url = "searchModelGridList.do?SRTypeCode=${resultMap.SRTypeCode}";
		var w = 900;
		var h = 500;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	//ProcModelIdSetting
	function doSetModelID(ModelID, ProcModelName){		
		$("#ProcModelID").val(ModelID);
		$("#ProcModelName").val(ProcModelName);
	}
	
	function searchItem(){
		var url = "orgItemTreePop.do";
		var data = "ItemID="+$("#DimTypeID").val()+"&ItemTypeCode=OJ00010";
		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}
	
	function doCallBack(avg){
		var ItemID = avg;
		$("#DimTypeID").val(ItemID);
		var url = "getPathOrg.do";
		var data = "ItemID="+ItemID;
		var target = "blankFrame";
		ajaxPage(url,data,target);
	}
	
	function thisReload(Path){
		$("#Dimension").val(Path);
		$(".popup_div").hide();
		$("#mask").hide();
	}
	


	function fnSaveSrType() {
		if($("#dimTypePath").val() == ''){$("#dimTypeID").val("");}
		if (confirm("${CM00001}")) {
			var url = "admin/saveSRType.do?viewType=${viewType}&lastUser=${sessionScope.loginInfo.sessionUserId}";
			ajaxSubmit(document.srTypeDetail, url,"saveFrame");			
		}
	}
	
	function fnCallBack(){
		var url = "defineSRType.do";
		var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}" + "&pageNum=" + $("#CurrPageNum").val();
		var target = "srTypeDetail";
		ajaxPage(url, data, target);
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

<style>
	a:hover{
		text-decoration:underline;
		cursor:pointer;
	}
</style>

<div id="groupListDiv" style="width:99%;">
	<form name="srTypeDetail" id="srTypeDetail" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />
		<input type="hidden" id="CurrPageNum" name="CurrPageNum" value="${pageNum}">
		<input type="hidden" id="managerID" name="managerID" value="${resultMap.managerID}">	
		<div class="cfg">
			<li class="cfgtitle"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Edit SR Type</li>
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
				<th class="viewtop alignL pdL10">Code</th>
				<td class="viewtop">
					<input type="Text"  class="text" id="SRTypeCode" name="SRTypeCode" value="${resultMap.SRTypeCode}"  onkeyup="fnOnlyEnNum(this);" onchange="fnOnlyEnNum(this);">	
				</td>
				<th class="viewtop alignL pdL10">Name</th>
				<td class="viewtop">
					<input type="Text"  class="text" id="SRTypeNM" name="SRTypeNM" value="${resultMap.SRTypeNM}" >	
				</td>
				<th class="viewtop  alignL pdL10">Domain</th>
				<td class="viewtop">
					<input type="text" class="text" id="DocDomain" name="DocDomain" value="${resultMap.DocDomain}"/>
				</td>
				<th class="viewtop  alignL pdL10">Category</th>
				<td class="viewtop last">
					<select name="DocCategory" id="DocCategory" style="width:100%;" ></select>
				</td>
				
			</tr>
			<tr>	
				<th class="alignL pdL10"><a onclick="fnOpenModelListPop()">Process Model</a></th>
				<td class="alignL" colspan="3">
					<input type="Text" class="text" id="ProcModelName" name="ProcModelName" value="${resultMap.ProcModel}">
					<input type="hidden" id="ProcModelID" name="ProcModelID" value="${resultMap.ProcModelID}" / >
				</td> 
				<!-- 담당자 추가-->

				<th class="alignL pdL10">담당자</th>
				<td class="alignL last" colspan="3">
					<input type="text" class="text" id="MgtUserNM" name="MgtUserNM" value="${resultMap.MgtUserNM}" onclick="searchmgt()">
				</td>
				</tr>

			<tr>
				<th class="alignL pdL10" >항목 유형</th>
				<td class="alignL" colspan="3">
					<select name="ItemType" id="ItemType" style="width:100%;" ></select>
				</td>		
				<th class="alignL pdL10">MenuID</th>
					<td class="alignL last" colspan="3">
						<select name=MenuID id="MenuID" style="width:100%;"></select>						
					</td>
			</tr>	

			<tr>
				<th class="alignL pdL10">Var Filter</th>
				<td class="alignL" colspan="3">
					<input type="Text" class="text" id="VarFilter" name="VarFilter" value="${resultMap.VarFilter}">
				</td>
				<th class="alignL pdL10">Prefix</th>
				<td class="alignL">
					<input type="Text" class="text" id="Prefix" name="Prefix" value="${resultMap.Prefix}"  maxlength="5">			
				</td>
				<th class="alignL pdL10">Max Level</th>
				<td class="alignL last">
					<input type="Text" class="text" id="MaxSRAreaLvl" name="MaxSRAreaLvl" value="${resultMap.MaxSRAreaLvl}"  >			
				</td>
			</tr>
			<tr>
				<th class="alignL pdL10">Dimension</th>
				<td class="alignL">
					<input type="text" id="Dimension" name="Dimension" value="${resultMap.Dimension}" onclick="searchItem()" class="text" />
					<input type="hidden" id="DimTypeID" name="DimTypeID" value="${resultMap.DimTypeID}">
				</td>
				<th class="alignL pdL10">Deactivated</th>
				<td>
					<input type="checkbox" name="Deactivated" id="Deactivated"
					<c:if test="${resultMap.Deactivated == '1'}">checked="checked"</c:if>
					value="${resultMap.Deactivated}" onclick="checkBox1()">
				</td>
				<th class="alignL pdL10">Item Proposal</th>
				<td class="last">
					<select name=itemProposal  id="itemProposal" style="width:100%;">
						<option value="Y">Y</option>
						<option value="N">N</option>
					</select>	
				</td>
				<th class="alignL pdL10">Eval Type</th>
				<td class="alignL last"><select name=evalType  id="evalType" style="width:100%;"></select></td>
			</tr>
			<tr>
				<th class="alignL pdL10">Def. WF ID</th>
				<td class="alignL"><select name=wfID  id="wfID" style="width:100%;"></select></td>
				<th class="alignL pdL10">WF Approve URL</th>
				<td class="alignL">
					<input type="text" id="wfAprvURL" name="wfAprvURL" value="${resultMap.WFAprvURL}" class="text" />
				</td>
				<th class="alignL pdL10">WF Document URL</th>
				<td class="alignL last" colspan=3>
					<input type="text" id="wfDocURL" name="wfDocURL" value="${resultMap.WFDocURL}" class="text" />
				</td>
			</tr>
			<tr>
				<td class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="8">
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
<!-- 						<span class="btn_pack medium icon"><span class="allocation"></span><input value="Allocation" type="submit" onclick="fnAllocation()"></span> -->						
						<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnCallBack()" value="List">List</button>
				    <button class="cmm-btn2 mgR5" style="height: 30px;" onclick="fnSaveSrType()"  value="Save">Save</button>	
						
					</c:if>
				</td>
			</tr>
		</table>
	</form>
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>
</div>