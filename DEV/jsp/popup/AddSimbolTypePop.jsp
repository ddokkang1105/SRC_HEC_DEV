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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00034" var="CM00034" />

<!-- 2. Script -->
<script type="text/javascript">

$(document).ready(function() {
	$.ajaxSetup({
		headers: {
			'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
		},
	});	
});

var schCntnLayout;	//layout적용

function doOTSearchList(){
		var sqlID = "config_SQL.SelectAddSimbolType";
		var param = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+  "ModelTypeCode=${ModelTypeCode}"	
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

function SaveSymbolType(){
	var selectedCell = grid.data.findAll(function (data) {
		return data.checkbox; 
	});
	if(!selectedCell.length){ 
	alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
	} else {
		if (confirm("${CM00034}")) {
			for (idx in selectedCell) {
				var url = "admin/AddSymbolType.do";
				var data = "&SymTypeCode=" + selectedCell[idx].SymTypeCode
// 						+ "&ItemTypeCode=" + p_gridArea.cells(checkedRows[i], 3).getValue()
// 						+ "&ClassCode=" + p_gridArea.cells(checkedRows[i], 4).getValue()
// 						+ "&ItemCategory=" + p_gridArea.cells(checkedRows[i], 5).getValue()
						+ "&ModelTypeCode=${ModelTypeCode}"
						+ "&LanguageID=${LanguageID}";
				var i = Number(idx) + 1;
				if (i == selectedCell.length) {
					data = data + "&FinalData=Final";
				}
				var target = "ArcFrame";
				ajaxPage(url, data, target);
				grid.data.remove(selectedCell[idx].id);	
			}
		}
	}
}

//[save] 이벤트 후 처리
function selfClose() {
	opener.urlReload();
	self.close();
}

</script>
<body>
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${Name} > Add Simbol Type</p>
	</div>
	<form name="AddClassTypeList" id="AddClassTypeList"	action="*" method="post" onsubmit="return false;">
		<input type="hidden" id="SaveType" name="SaveType" value="Edit" /> 
		<input type="hidden" id="Name" name="Name" value="${Name}" /> 
		<input type="hidden" id="Creator" name="Creator" value="${sessionScope.loginInfo.sessionUserId}" />
		<div id="gridDiv" class="mgB10 mgT5 mgL5 mgR5">
			<div id="grdGridArea" style="width:100%; height: 500px;"></div>
		</div>
		<ul>
			<li class="floatR pdR20">
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
						<span class="btn_pack medium icon"><span class="save"></span><input value="save" type="submit" onclick="SaveSymbolType()"></span>
					</c:if>
			</li>
		</ul>
	</form>
		<!-- START :: FRAME -->
		<div class="schContainer" id="schContainer">
			<iframe name="ArcFrame" id="ArcFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
		</div>
</body>

<script type="text/javascript">

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
	var grid = new dhx.Grid("grdGridArea", {
		columns: [
			{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
			{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
			{ width: 100, id: "SymTypeCode", header: [{ text: "SymTypeCode" , align: "center" }], align: "center" },
			{ width: 100, id: "SymbolIcon", header: [{ text: "${menu.LN00176}" , align:"center" }], htmlEnable: true, align: "center",
				template: function (text, row, col) {
	            	return "<img src='${root}${HTML_IMG_DIR_MODEL_SYMBOL}/symbol/" + row.SymbolIcon + "' />";
				}
			},
			{ hidden: true, width: 100, id: "ItemTypeCode", header: [{ text: "ItemTypeCode", align: "center" }], align: "center" },
			{ hidden: true, width: 100, id: "ClassCode", header: [{ text: "ClassCode", align: "center" }], align: "left" },
			{ hidden: true, width: 100, id: "ItemCategory", header: [{ text: "ItemCategory", align: "center" }], align: "center" },
			{ width: 100, id: "Name", header: [{ text: "Name", align: "center" }] , align: "center"},				
			{ width: 150, id: "Description", header: [{ text: "Description", align: "center" }], align: "center" },				
			{ hidden: true, width: 100, id: "ArisTypeNum", header: [{ text: "ArisTypeNum", align: "center" }], align: "center" },
			{ hidden: true, width: 100, id: "FromSymType", header: [{ text: "FromSymType", align: "center" }], align: "center" },
			{ hidden: true, width: 100, id: "ToSymType", header: [{ text: "ToSymType", align: "center" }], align: "center" },
			{ fillspace: true, id: "ImagePath", header: [{ text: "ImagePath", align: "center" }], align: "left", htmlEnable : true }		
		],
		autoWidth: true,
		resizable: true,
		selection: "row",
		tooltip: false,
		data: gridData
	});
	layout.getCell("a").attach(grid);

	// END ::: GRID	
	//===============================================================================

</script>

</html>