<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root" />

<!--1. Include JSP -->
<!-- <%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%> -->
<!-- <script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>  -->

<!-- 화면 표시 메세지 취득  -->
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
		
		var defalutlang = "";
		
		// [IsComLang] 이 1인경우
		if ('${resultMap.IsComLang}' == 1) {
			//$("#getLanguageID").attr("disabled", "disabled"); 
			defalutlang = "${defalutlang}";
		} else {
			defalutlang = "${resultMap.LanguageID}";
		}
		
		fnSelect('getLanguageID', '', 'langType', defalutlang, 'Select');
		fnSelect('DataType', '', 'AttpopupType', '${resultMap.DataType}', '');		
		fnSetSubAttrTypeCode("${resultMap.DataType}");
	});
	
	function fnSetSubAttrTypeCode(dataType){
		if(dataType == "LOV"){
			var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&attrTypeCode=${resultMap.AttrTypeCode}";
			fnSelect('subAttrTypeCode', data, 'getAttrTypeCodeLov', '${resultMap.SubAttrTypeCode}', 'Select');
			$("#subAttrTypeCode").attr('style', 'visibility:visible;width:100%');
		}else{
			$("#subAttrTypeCode").attr('style', 'visibility:hidden');
		}
	}
	
	// [Save] Click
	function updateAttrribute() {
		if (confirm("${CM00001}")) {
			$("#getLanguageID").removeAttr("disabled");
			var url = "admin/updateAttribute.do";
			ajaxSubmit(document.AttributeTypeList, url);
		}

	}

	function goBack() {
		var url = "DefineAttributeType.do";
		var data = "pageNum=${pageNum}";
		var target = "attributeTypeDiv";
		ajaxPage(url, data, target);
	}
	
	function CheckBox1(){
		var chk1 = document.getElementsByName("check1");
		if(chk1[0].checked == true){
			$("#objHTML").val("1");
		}else{
			$("#objHTML").val("");
		}
	}
	
	function CheckBox2(){	
		var chk2 = document.getElementsByName("check2");
		if(chk2[0].checked == true){
			$("#objIsComLang").val("1");
		}else{
			$("#objIsComLang").val("");
		}
	}
	
	function CheckBox3(){
		var chk3 = document.getElementsByName("check3");
		if(chk3[0].checked == true){
			$("#objEditable").val("1");
		}else{
			$("#objEditable").val("0");
		}
	}
	
	function ListOfValue(){
	
		var url = "subTab.do"; // 요청이 날라가는 주소
		var data = "url=DefineAttributeTypeMenu&itemID=${resultMap.AttrTypeCode}&LoveDataType=${resultMap.DataType}&languageID=${resultMap.LanguageID}&pageNum=${pageNum}";
		var target = "attributeTypeDiv";
		
		ajaxPage(url, data, target);
		
	}
	
	// [언어 선택]
	function AttrReload(){
		var url    = "AttributeTypeView.do"; // 요청이 날라가는 주소
		var data   = "itemID=${resultMap.AttrTypeCode}"
						+ "&isComLang=${resultMap.IsComLang}"
						+ "&getLanguageID="+$("#getLanguageID").val() 
						+ "&pageNum=${pageNum}";
		var target = "attributeTypeDiv";
		ajaxPage(url,data,target);
	}

</script>

<div id="groupListDiv" class="hidden" style="width: 100%; height: 100%;">
	<form name="AttributeTypeList" id="AttributeTypeList" action="*" method="post" onsubmit="return false;">
		<input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />
		<input type="hidden" id="orgTypeCode" name="orgTypeCode"value="${itemID}" /> 
		<input type="hidden" id="orgCreator" name="orgCreator" value="${sessionScope.loginInfo.sessionUserId}" />
		<input type="hidden" id="SaveType" name="SaveType" value="Edit" /> 
		<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}"> 
		<input type="hidden" id="objHTML" name="objHTML" value="${resultMap.HTML}">
		<input type="hidden" id="objIsComLang" name="objIsComLang" value="${resultMap.IsComLang}">
		<input type="hidden" id="objEditable" name="objEditable" value="${resultMap.Editable}">
		<input type="hidden" id="objAttrTypeCode" name="objAttrTypeCode" value="${resultMap.AttrTypeCode}">
        <div class="cfg">
	         <li class="cfgtitle"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Edit AttributeType</li>
	         <li class="floatR pdR20 pdT10">
	           <select id="getLanguageID" name="getLanguageID"  onchange="AttrReload()"></select>
	         </li>
        </div><br>			
		<table style="table-layout:fixed;" class="tbl_blue01" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="10%">
				<col width="23%">
				<col width="10%">
				<col width="23%">
				<col width="10%">
				<col width="24%">				
			</colgroup>
			<tr>
				<th class="viewtop">${menu.LN00015}</th>
				<td class="viewtop">${resultMap.AttrTypeCode}</td>
				<th class="viewtop">${menu.LN00028}</th>
				<td class="viewtop">
				<c:if test=""></c:if>
				<input type="text" class="text" id="objName" name="objName" value="${resultMap.Name}" maxlength="255" /></td>
				<th class="viewtop">${menu.LN00070}</th>
				<td class="last viewtop" align="left">${resultMap.LastUpdated}</td>
			</tr>
			<tr>
			<th >${menu.LN00033}</th>
				<td>
					<select id="attrCategory" name="attrCategory" style="width:100%;">
						<option value="">Select</option>
						<option value="ITM" <c:if test="${resultMap.AttrCategory == 'ITM' }">selected</c:if> >ITM</option>
						<option value="EVAL" <c:if test="${resultMap.AttrCategory == 'EVAL' }">selected</c:if> >EVAL</option>
						<option value="ESM" <c:if test="${resultMap.AttrCategory == 'ESM' }">selected</c:if> >ESM</option>
					</select>
				</td>
				<th>${menu.LN00021}</th>
				<td class="last">
					<select id="DataType" name="DataType" style="width:100%;" OnChange=fnSetSubAttrTypeCode(this.value);></select>
				</td>
				<th>Sub AttrType</th>
				<td class="last">
					<select id="subAttrTypeCode" name="subAttrTypeCode" style="width:100%;"></select>					
				</td>
			</tr>
			<tr>				
				<th>IsComLang</th>
				<td><input type="checkbox" name="check2"  
					<c:if test="${resultMap.IsComLang == '1'}">
						checked="checked"
					</c:if>				
					value="${resultMap.IsComLang}" onclick="CheckBox2()"></td>
				<th>Editable</th>
				<td><input type="checkbox" name="check3" 
					<c:if test="${resultMap.Editable == '1'}">
						checked="checked"
					</c:if>
					value="${resultMap.Editable}" onclick="CheckBox3()">
				</td>
				<th>HTML</th>
				<td><input type="checkbox" name="check1"
					<c:if test="${resultMap.HTML == '1'}">
						checked="checked"
					</c:if>
					 value="${resultMap.HTML}" onclick="CheckBox1()">
				 </td>
			</tr>
			<tr>
				<td colspan="6" style="height:180px;" class="tit last">
				<textarea id="objDescription" name="objDescription" style="width: 100%; height: 98%;border:1px solid #fff"" >${resultMap.Description}</textarea></td>
			</tr>
			<tr>
				<td class="last" bgcolor="#f9f9f9" colspan="6">
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				    <div class="lovBTN">
						<c:if test="${resultMap.DataType == 'LOV' || resultMap.DataType == 'MLOV'}">
							<button class="cmm-btn mgR5" style="height: 30px;" onclick="ListOfValue()" value="LOV" >LOV</button>
						</c:if>
							<button class="cmm-btn mgR5" style="height: 30px;" onclick="goBack()" value="List" >List</button>
							<button class="cmm-btn2 mgR5" style="height: 30px;" onclick="updateAttrribute()" value="Save">Save</button>
					</div>
					</c:if>	 	
				</td>
			</tr>
		</table>
	</form>
	<!-- START :: FRAME -->
	<iframe id="saveFrame" name="saveFrame" style="display:none;width:0px;height:0px;"></iframe>
</div>
