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

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

<!-- 2. Script -->
<script type="text/javascript">
var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용

$(document).ready(function() {	
	fnSelect('getLanguageID', '', 'langType', '${languageID}', 'Select');

	// 화면 크기 조정
	$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 350)+"px;");
	window.onresize = function() {
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 350)+"px;");
	};
	
	var refAttrTypeCode = "${refAttrTypeCode}";
	if(refAttrTypeCode != ""){
		var data = "langugeID=${languageID}&attrTypeCode="+refAttrTypeCode;		
		fnSelect('RefLovCode',data, 'getAttrTypeLov', '', 'Select');	
	}

});	

//===============================================================================
// BEGIN ::: GRID

	var layout = new dhx.Layout("grdGridArea", { 
			rows: [
				{
					id: "a",
				},
			]
		});
	
		var gridData = ${gridData};
		var grid = new dhx.Grid(null, {
			columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
				{ width: 150, id: "LovCode", header: [{ text: "Code" , align: "center" }, { content: "selectFilter" }], align: "center" },
				{ width: 150, id: "AttrTypeCode", header: [{ text: "AttrType Code", align: "center" }, { content: "selectFilter" }], align: "center" },
				{ width: 200, id: "NAME", header: [{ text: "Value", align: "center" }, { content: "inputFilter" }], align: "center" },
				{ width: 150, id: "RefLovCode", header: [{ text: "Ref. LovCode", align: "center" }, { content: "inputFilter" }], align: "center	" },
				{ width: 200, id: "RevLovName", header: [{ text: "Ref. Value", align: "center" }, { content: "inputFilter" }], align: "center" },
				{ width: 150, id: "LanguageCode", header: [{ text: "Language", align: "center" }] , align: "center"},				
				{ hidden: true, width: 100, id: "LanguageID", header: [{ text: "Language ID", align: "center" }, { content: "inputFilter" }], align: "center" },				
				{ hidden: true, width: 100, id: "Value", header: [{ text: "Value", align: "center" }, { content: "inputFilter" }], align: "center" },
				{ fillspace: true, id: "LinkFilter", header: [{ text: "Link Filter", align: "center" }], align: "center" }		
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data: gridData
		});
		layout.getCell("a").attach(grid);

		//그리드ROW선택시
		grid.events.on("cellClick", function(row,column,e){
			if(column.id != "checkbox"){
				gridOnRowPSelect(row);
			}
		}); 

		//그리드ROW선택시
		function gridOnRowPSelect(row) {
			$("#RefLovCode").val(row.RefLovCode);
			$("#LovCode").val(row.LovCode);
			$("#LovValue").val(row.NAME);
			$("#BeforeLovValue").val(row.LanguageCode);
			$("#LinkFilter").val(row.LinkFilter);
		}
	
// END ::: GRID	
//===============================================================================

//조회
function doOTSearchList(){
		var sqlID = "config_SQL.getSubListOfValueCode";
		var param = 
			 "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&TypeCode=${s_itemID}"
			+ "&sqlID="+sqlID;

		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadGrid(result);			
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
		}	

	function fnReloadGrid(newGridData){
 		grid.data.parse(newGridData);
 		fnMasterChk('');
 	}



function AddListOfValue(){
	var url = "AddListOfValuePop.do?";
	var data = "TypeCode=${s_itemID}&languageID=" + $("#getLanguageID").val();			
	var option = "width=510,height=170,left=800,top=300,toolbar=no,status=no,resizable=yes";
    window.open(url+data,"",option);
}

// [Del] click
function delListOfValue(){
	var selectedCell = grid.data.findAll(function (data) {
		return data.checkbox; 
	});
	if(!selectedCell.length){ 
		alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
	} else {
		
		if (confirm("${CM00004}")) {	//if (confirm("선택된 항목을 삭제하시겠습니까?")) 
			var lovCodes = "";
			for (idx in selectedCell) {
				if (lovCodes == "") {
					lovCodes = selectedCell[idx].LovCode;
				} else{ 
					lovCodes = lovCodes + "," + selectedCell[idx].LovCode;
				}
			}
			
			if (lovCodes != "") {
				var url = "delListOfValue.do";
				var data = "lovCodes=" + lovCodes + "&TypeCode=${s_itemID}&languageID=" + $("#getLanguageID").val();
				var target = "SaveFrame";
				ajaxPage(url, data, target);
				grid.data.remove(selectedCell[idx].id);	
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
			<div class="mgT10  mgL10" id="grdGridArea" style="width:100%"></div>
	
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