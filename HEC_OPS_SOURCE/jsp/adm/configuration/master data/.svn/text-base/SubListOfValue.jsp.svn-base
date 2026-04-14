<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

<!-- 2. Script -->
<script type="text/javascript">

var p_gridArea;				//그리드 전역변수
var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용

$(document).ready(function() {	
	
	fnSelect('getLanguageID', '', 'langType', '${languageID}', 'Select');
	
	var refAttrTypeCode = "${refAttrTypeCode}";
	if(refAttrTypeCode != ""){
		var data = "langugeID=${languageID}&attrTypeCode="+refAttrTypeCode;		
		fnSelect('RefLovCode',data, 'getAttrTypeLov', '', 'Select');	
	}
	
	//Grid 초기화
	gridOTInit();
	doOTSearchList();	
	
});	


//===============================================================================
// BEGIN ::: GRID
//그리드 초기화
function gridOTInit(){		
	var d = setOTGridData();
	
	p_gridArea = fnNewInitGrid("grdGridArea", d);
	
	fnSetColType(p_gridArea, 1, "ch");
	p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
	//p_gridArea.setColumnHidden(3, true);
	//p_gridArea.setColumnHidden(4, true);
	p_gridArea.setColumnHidden(8, true);
	p_gridArea.setColumnHidden(9, true);
	p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
		gridOnRowPSelect(id,ind);
	});
}

function setOTGridData(){
	var result = new Object();
	result.title = "${title}";
	result.key = "config_SQL.getSubListOfValueCode";
	result.header = "${menu.LN00024},#master_checkbox,Code,AttrType Code,Value,Ref. LovCode,Ref. Value,Language,Language ID,Value,LinkFilter"; // 5
	result.cols = "CHK|LovCode|AttrTypeCode|NAME|RefLovCode|RevLovName|LanguageCode|LanguageID|Value|LinkFilter"; //5-1
	result.widths = "50,50,100,100,150,100,150,100,0,100"; //5
	result.sorting = "int,int,str,str,str,str,str,str,str,str"; //5
	result.aligns = "center,center,center,center,center,center,center,center,center,center"; //5
	result.data = "LanguageID=${languageID}&TypeCode=${s_itemID}";//&maxCntLang=${maxCntLang}"; 
	return result;
}

// END ::: GRID	
//===============================================================================
	
//조회
function doOTSearchList(){
	var d = setOTGridData();
	fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
}

//그리드ROW선택시
function gridOnRowPSelect(id, ind) {
	$("#RefLovCode").val(p_gridArea.cells(id, 5).getValue());
	$("#LovCode").val(p_gridArea.cells(id, 2).getValue());
	$("#LovValue").val(p_gridArea.cells(id, 4).getValue());
	$("#BeforeLovValue").val(p_gridArea.cells(id, 7).getValue());
	$("#LinkFilter").val(p_gridArea.cells(id, 10).getValue());
}


function AddListOfValue(){
	var url = "AddListOfValuePop.do?";
	var data = "TypeCode=${s_itemID}&languageID=" + $("#getLanguageID").val();			
	var option = "width=510,height=170,left=800,top=300,toolbar=no,status=no,resizable=yes";
    window.open(url+data,"",option);
}

// [Del] click
function delListOfValue(){
	if (p_gridArea.getCheckedRows(1).length == 0) {
		//alert("항목을 한개 이상 선택하여 주십시요.");
		alert("${WM00023}");
	} else {
		//if (confirm("선택된 항목을 삭제하시겠습니까?")) {
		if (confirm("${CM00004}")) {	
			var checkedRows = p_gridArea.getCheckedRows(1).split(",");
			var lovCodes = "";
			for ( var i = 0; i < checkedRows.length; i++) {
				if (lovCodes == "") {
					lovCodes = p_gridArea.cells(checkedRows[i], 2).getValue();
				} else{ 
					lovCodes = lovCodes + "," + p_gridArea.cells(checkedRows[i], 2).getValue();
				}
			}
			
			if (lovCodes != "") {
				var url = "delListOfValue.do";
				var data = "lovCodes=" + lovCodes + "&TypeCode=${s_itemID}&languageID=" + $("#getLanguageID").val();
				var target = "SaveFrame";
				ajaxPage(url, data, target);
			}
		}
	}
}

// [Save] 선택한 Lov  update
function UpdateListOfValue(){
	if (confirm("${CM00001}")) {
		var LinkFilter = $("#LinkFilter").val().replace(/&/g,"%26");
		var url = "updateListOfValue.do";
		var data = "&LovValue="+$("#LovValue").val() +
					"&LovCode="+$("#LovCode").val()+
					"&getLanguageID="+$("#getLanguageID").val()+
					"&AttrTypeCode="+$("#AttrTypeCode").val()+
					"&BeforeLovValue="+$("#BeforeLovValue").val()+
					"&RefLovCode="+$("#RefLovCode").val()+
					"&LinkFilter="+LinkFilter;
		var target = "SaveFrame";
		ajaxPage(url, data, target);
	}
}

function urlReload(LanguageID){
	var url = "SubListOfValue.do";
	var target = "arcFrame";
	var data = "s_itemID=${s_itemID}&languageID="+LanguageID+"&pageNum=${pageNum}"; 
 	ajaxPage(url,data,target);
}

// [Back] Click
function Back(){
	var url = "AttributeTypeView.do";
	var target = "attributeTypeDiv";
	var data = "itemID=${s_itemID}&getLanguageID=${languageID}&pageNum=${pageNum}"; 
	
	ajaxPage(url,data,target);
}

</script>
<div id="groupListDiv" class="hidden" style="width: 100%; height: 100%;">
	<form name="AttriLovList" id="AttributeTypeList" action="#" method="post" onsubmit="return false;">

	<div id="gridDiv" class="mgB10">
		<input type="hidden" id="AttrTypeCode" name="AttrTypeCode" value="${s_itemID}">
		<input type="hidden" id="BeforeLovValue" name="BeforeLovValue">
		
		<!-- <div style="height:250px; overflow:auto;margin-bottom:5px;overflow-x:hidden;"> -->
			<div class="child_search mgL10 mgR10">
			<ul>
				<li class="floatR pdR20">
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">			
						<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="submit" onclick="Back()"></span>		
						<c:if test="${sessionScope.loginInfo.sessionDefLanguageId==languageID}" >
						<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="AddListOfValue()"></span>
						</c:if>
						<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delListOfValue()"></span>
					</c:if>
					<select id="getLanguageID" name="getLanguageID" onchange="urlReload($(this).val());"></select>
				</li>
			</ul>
			</div>
			<div class="mgT10  mgL10" id="grdGridArea" style="height:300px; width:98%"></div>
	
		</div>
		<div class="mgT5 mgL10 mgR10">
		<table id="newListOfValue" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" >
			<tr>
				<th class="viewtop">LoV Code</th>
				<th class="viewtop last">Value</th>
				<th class="viewtop">Reference LoV</th>
			</tr>
			<tr>			
				<td><input type="text" class="text" id="LovCode" name="LovCode" readonly = true></td>
				<td class="last"><input type="text" class="text" id="LovValue"></td>	
				<td><select id="RefLovCode" name="RefLovCode" style="width:100%;"></select></td>			
			</tr>	
			<tr>
				<th colspan="3">LinkFilter</th>
			</tr>
			<tr>
				<td colspan="3"><input type="text" class="text" id="LinkFilter" name="LinkFilter" value="${LinkFilter}" /></td>
			</tr>
			<tr>
				<td class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="8">
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
						&nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="UpdateListOfValue()"></span>
					</c:if>
				</td>
			</tr>	
			
		</table>
		</div>
		</form>
	
	<div id="testDiv"></div>
	
	<!-- START :: FRAME -->
		<div class="schContainer" id="schContainer">
			<iframe name="SaveFrame" id="SaveFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
		</div>
	<!-- END :: BOARD_ADMIN_FORM -->
		
</div>
</html>