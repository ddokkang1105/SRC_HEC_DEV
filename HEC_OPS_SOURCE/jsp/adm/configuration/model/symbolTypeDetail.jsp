<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!--1. Include JSP -->
<!--  <script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script> -->

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00016}"/>

<!-- Script -->
<script type="text/javascript">

	$(document).ready(function() {		
		fnSelect('getLanguageID', '', 'langType', '${sessionScope.loginInfo.sessionCurrLangType}', 'Select');
		fnSelect('ItemTypeCode', '&category=${resultMap.ItemCategory}', 'itemTypeCode', '${resultMap.ItemTypeCode}',  'Select');
		fnSelect('ClassCode', '&option=${resultMap.ItemTypeCode}', 'classCodeOption', '${resultMap.ClassCode}', 'Select');
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&attrTypeCode=''";
		fnSelect('DefLovCode', data, 'getAttrTypeCodeLov', '${resultMap.DefLovCode}', 'Select');
		
		var myCP;
		myCP = dhtmlXColorPicker(["DefColor","DefStrokeColor","DefGradientColor","DefFillColor","DefFontColor","DefLabelBGColor"]);
		myCP.setColor([143,235,0]);
	});
	
	function saveSymbolType(){
		if(confirm("${CM00001}")){	
			if($("#SymbolName").val() == null || $("#SymbolName").val() == ""){
				alert("${WM00034_1}");
				return false;
			}/* else if($("#ClassCode").val() == null || $("#ClassCode").val() == ""){
				alert("${WM00034_2}");
				return false;
			} */
			var url = "saveSymbolType.do?viewType=${viewType}";
			var target = "saveFrame";		
			ajaxSubmitNoAdd(document.SymbolTypeDetail, url, target);
		}
	}

	function goBack() {
		var url = "symbolType.do";
		var data = "&pageNum=${pageNum}";
		var target = "symbolTypeDiv";
		ajaxPage(url, data, target);
	}
	
	function CheckBox1(){
		var chk1 = document.getElementsByName("Deactivated");
		if(chk1[0].checked == true){
			$("#Deactivated").val("1");
		}else{
			$("#Deactivated").val("0");
		}
	}
	
	function fnGetItemType(category){
		fnSelect('ItemTypeCode', '&category='+category, 'itemTypeCode', '',  'Select');
	}
	
	function fnChangeItemType(itemTypeCode){
		fnSelect('ClassCode', '&option='+itemTypeCode, 'classCodeOption', '', 'Select');
	}
	
	function fnSymTypAttrDp(){
		var url = "allocateSymbolAttrDp.do";
		var data = "symTypeCode=${resultMap.SymTypeCode}&languageID="+$("#getLanguageID").val();
		var target = "SymbolTypeDetail";
		ajaxPage(url, data, target);
	}
	
</script>
<form name="SymbolTypeDetail" id="SymbolTypeDetail" action="*" method="post" onsubmit="return false;">
<div class="cfg">
	<li class="cfgtitle"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png"  id="subTitle_baisic">&nbsp;Edit Symbol Type</li>
	<li class="floatR pdR20 pdT10">
	 <select id="getLanguageID" name="getLanguageID"  value="${sessionScope.loginInfo.sessionCurrLangType}"></select>
	</li>
</div><br>
<table style="table-layout:fixed;" class="tbl_blue01" width="100%" cellpadding="0" cellspacing="0">
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
		<th class="viewtop">${menu.LN00015}</th>
		<td class="viewtop" align="left">${resultMap.SymTypeCode}
			<input type="hidden" id="SymTypeCode" name="SymTypeCode" value="${resultMap.SymTypeCode}" >
		</td>
		<th class="viewtop">${menu.LN00028}</th>
		<td class="viewtop">
		<input type="text" class="text" id="SymbolName" name="SymbolName" value="${resultMap.SymbolName}" /></td>
		<th class="viewtop">Deactived</th>
		<td class="viewtop"  align="center"><input type="checkbox" name="Deactivated" id="Deactivated" 
			<c:if test="${resultMap.Deactivated == '1'}">
				checked="checked"
			</c:if>
		value="${resultMap.Deactivated}" onclick="CheckBox1()"></td>
		<th class="viewtop">${menu.LN00033}</th>
		<td class="viewtop last" align="left">
			<select id="ItemCategory" name="ItemCategory" class="sel" OnChange="fnGetItemType(this.value)">
				<option <c:if test="${resultMap.ItemCategory == 'OJ' }">selected="selected"</c:if> value="OJ">OJ</option>
				<option <c:if test="${resultMap.ItemCategory == 'MCN' }">selected="selected"</c:if> value="MCN">MCN</option>
				<option <c:if test="${resultMap.ItemCategory == 'MOJ' }">selected="selected"</c:if> value="MOJ">MOJ</option>				
				<option <c:if test="${resultMap.ItemCategory == 'TXT' }">selected="selected"</c:if> value="TXT">TXT</option>
			</select>
		</td>
	</tr>
	<tr>
		<th>${menu.LN00021}</th>
		<td  align="left"><select id="ItemTypeCode" name="ItemTypeCode" class="sel" OnChange='fnChangeItemType(this.value)'></select></td>
		<th>${menu.LN00016}</th>
		<td  align="left"><select id="ClassCode" name="ClassCode" class="sel"></select></td>
		<th>DefWidth</th>
		<td><input type="number" class="text" id="DefWidth" name="DefWidth" value="${resultMap.DefWidth}" /></td>
		<th>DefHeight</th>
		<td><input type="number" class="text" id="DefHeight" name="DefHeight" value="${resultMap.DefHeight}" /></td>
	</tr>
	<tr>
		<th>DefFillColor</th>
		<td align="left" ><input type="text"  class="text" id="DefFillColor" name="DefFillColor" value="${resultMap.DefFillColor}"></td>
		<th>DefStrokeColor</th>
		<td><input type="text" class="text" id="DefStrokeColor" name="DefStrokeColor" value="${resultMap.DefStrokeColor}" /></td>
		<th>DefGradientColor</th>
		<td><input type="text" class="text" id="DefGradientColor" name="DefGradientColor" value="${resultMap.DefGradientColor}" /></td>
		<th>DefShadow</th>
		<td  class="last"><input type="number" class="text" id="DefShadow" name="DefShadow" value="${resultMap.DefShadow}" /></td>
	</tr>
	<tr>
		
	</tr>
	<tr>
		<th>DefFontColor</th>
		<td align="left" ><input type="text"  class="text" id="DefFontColor" name="DefFontColor" value="${resultMap.DefFontColor}"></td>
		<th>DefLabelBGColor</th>
		<td align="left" ><input type="text"  class="text" id="DefLabelBGColor" name="DefLabelBGColor" value="${resultMap.DefLabelBGColor}"></td>
		<th>DefSpacingTop</th>
		<td align="left" ><input type="number"  class="text" id="DefSpacingTop" name="DefSpacingTop" value="${resultMap.DefSpacingTop}"></td>
		<th>Dashed</th>
		<td align="left"><input type="number" class="text" id="Dashed" name="Dashed" value="${resultMap.Dashed}"></td>
	</tr>
	<tr>
		<th>Default LoV</th>
		<td align="left"><select id="DefLovCode" name="DefLovCode" class="sel"></select></td>
		<th>SortNum</th>
		<td align="left"><input type="number" class="text" id="SortNum" name="SortNum" value="${resultMap.SortNum}"></td>
		<th>${menu.LN00171}</th>
		<td align="left"  colspan="3" ><input type="text"  class="text" id="ImagePath" name="ImagePath" value="${resultMap.ImagePath}"></td>
	</tr>
	<tr>
		<td colspan="8" style="height:180px;" class="tit last">
		<textarea id="objDescription" name="objDescription" rows="12" cols="50" style="width: 100%; height: 98%;border:1px solid #fff" >${resultMap.Description}</textarea></td>
	</tr>
	<tr>
		<td class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="8">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<span class="btn_pack medium icon"><span class="allocation"></span> 
					<input value="Allocation" type="submit" id="Allocation" onclick="fnSymTypAttrDp()"></span>
				<span class="btn_pack medium icon"><span class="list"></span> 
					<input value="List" type="submit" onclick="goBack()"></span>
				 <span class="btn_pack medium icon"> <span class="save"></span> 
				 	<input value="Save" type="submit" onclick="saveSymbolType()"></span>
			</c:if>	 	
		</td>
	</tr>
</table>
</form>	
<!-- START :: FRAME -->
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>
		
