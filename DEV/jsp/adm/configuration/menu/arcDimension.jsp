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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012" />

<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {
		var data = "&LanguageID=${languageID}";
		fnSelect('objTypeCode', '', 'itemTypeCode', '', 'Select'); 
		fnSelect('dimTypeId', data, 'getDimTypeId', '', 'Select'); 
// 		fnSelect('dimValueId', data, 'getDimTypeValueId', '', 'Select'); 
	});	
	
	function fnAddArcDim(){
		$("#newArcDim").attr('style', 'display: block');	
		$("#newArcDim").attr('style', 'width: 100%');	
		$("#divSaveArcDim").attr('style', 'display: block');	
	}
		
	function fnSaveArcDim(){
		if(confirm("${CM00012}")){
			var objTypeCode = $("#objTypeCode").val();
			var dimTypeId = $("#dimTypeId").val();
			var dimValueId = $("#dimValueId").val();
			var url = "saveArcDim.do";
			var data = "arcCode=${arcCode}&objTypeCode="+objTypeCode+"&dimTypeId="+dimTypeId+"&dimValueId="+dimValueId; 
			var target = "ArcFrame";
			ajaxPage(url, data, target);
		}
	}

	//조회
	function doOTSearchList(){
		var sqlID = "config_SQL.getArcFilterDimList";
		var param = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&arcCode=${arcCode}" + "&sqlID="+sqlID;
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


	function fnCallBack(){ 
		$("#newArcDim").attr('style', 'display: none');	
		$("#divSaveArcDim").attr('style', 'display: none');	
		doOTSearchList();
	}
	
	function fnDeleteArcDim(){
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){
			alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
		}else{
			if(confirm("${CM00004}")){
				var ClassCode = "";
				for(idx in selectedCell){
					var url = "deleteArcDim.do";
					var data = "&arcCode=${arcCode}&dimTypeId="+selectedCell[idx].DimTypeID;
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

	function fnGetDimValue(dimTypeId){
		var data = "&LanguageID=${languageID}&dimTypeId="+dimTypeId;
		fnSelect('dimValueId', data, 'getDimTypeValueId', '', 'Select'); 
	}
</script>
</head>
<body>
	<form name="SubAttrTypeList" id="SubAttrTypeList" action="*" method="post" onsubmit="return false;" class="mgL10 mgR10">
	<input type="hidden" id="ItemTypeCode" name="ItemTypeCode" value="${ItemTypeCode}">
	<input type="hidden" id="ItemClassCode" name="ItemClassCode" value="${s_itemID}">
	<input type="hidden" id="AttrTypeCode" name="AttrTypeCode">
	<div class="floatR pdR10 mgB7">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<button class="cmm-btn mgR5" style="height: 30px;"  onclick="fnAddArcDim()" value="Add">Add Dimension</button>
			<button class="cmm-btn mgR5" style="height: 30px;"  onclick="fnDeleteArcDim()" value="Del">Delete</button>
		</c:if>
	</div>
	
	<div id="gridDiv" class="mgT10">
		<div id="layout" style="height:250px; width:100%; margin-bottom: 50px;"></div> <!--layout 추가한 부분-->
	</div>
	
	<div class="mgT10">
	<table id="newArcDim" class="tbl_blue01" width="100%"   cellpadding="0" cellspacing="0" style="display:none">
		<tr>
			<th class="viewtop last">Item Type</th>
			<th class="viewtop last">Dimension type</th>
			<th class="viewtop last">Dimension Value</th>
		</tr>
		<tr>
			<td class="last"><select id="objTypeCode" name="objTypeCode" class="sel" ></select></td>
			<td class="last"><select id="dimTypeId" name="dimTypeId" class="sel" OnChange="fnGetDimValue(this.value)"></select></td>
			<td class="last"><select id="dimValueId" name="dimValueId" class="sel" ></select></td>
		</tr>
	</table>
	</div>

	<div  class="alignBTN" id="divSaveArcDim" style="display: none;">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<button class="cmm-btn2 mgR5 mgT10 floatR" style="height: 30px;" onclick="fnSaveArcDim()" value="Save">Save</button>
		</c:if>		
	</div>	

	</form>
	
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="ArcFrame" id="ArcFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
</body>

<script type="text/javascript">	
	//===============================================================================
	// BEGIN ::: GRID
	var layout = new dhx.Layout("layout", { 
		rows: [	
			{
				id: "a",
			},
		]
	});

	var gridData = ${gridData};
	var grid = new dhx.Grid(null, {
		columns: [
			{ width: 80, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center"},
			{ width: 80, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
			{ fillspace: true, id: "ObjTypeName", header: [{ text: "ObjTypeName" , align: "center" }], align: "center"},
			{ fillspace: true, id: "DimTypeName", header: [{ text: "DimTypeName" , align: "center" }], align: "center"},
			{ fillspace: true, id: "DimValueName", header: [{ text: "DimValueName" , align: "center" }], align: "center"},
			{ width: 50, id: "ObjTypeCode", header: [{ text: "ObjTypeCode" , align: "center" }], align: "center", hidden: true},
			{ width: 50, id: "DimTypeID", header: [{ text: "DimTypeID" , align: "center" }], align: "center", hidden: true},
			{ width: 50, id: "DefDimValueID", header: [{ text: "DefDimValueID" , align: "center" }], align: "center", hidden: true}
		],
		autoWidth: true,
		resizable: true,
		selection: "row",
		tooltip: false,
		data:gridData
	});
	layout.getCell("a").attach(grid);

	// END ::: GRID	
	//===============================================================================

	grid.events.on("cellClick", function(row,column,e){
		if(column.id != "checkbox"){
			gridOnRowOTSelect(row);
		}
	}); 

	function gridOnRowOTSelect(row) { //그리드ROW선택시
		$("#divSaveArcDim").attr('style', 'display: none');
		$("#newArcDim").attr('style', 'display: block');	
		$("#newArcDim").attr('style', 'width: 100%');	

		var objTypeCode = row.ObjTypeCode;
		var dimTypeId = row.DimTypeName;
		var dimValueId = row.DimValueName;
		var dimTypeCode = row.DimTypeID;
		var defDimValueId = row.DefDimValueID;

		var data = "&LanguageID=${languageID}";		//Item Type
		fnSelect('objTypeCode', data, 'itemTypeCode', objTypeCode, 'Select'); 
		var data1 = "&languageID=${languageID}";	//Dimension type
		fnSelect('dimTypeId', data1, 'getDimensionTypeID', dimTypeCode, 'Select'); 
		var data2 = "&LanguageID=${languageID}&dimTypeId="+dimTypeCode; //Dimension Value
		fnSelect('dimValueId', data2, 'getDimTypeValueId', defDimValueId, 'Select'); 
	}

	//원본 그리드 ROW 선택 함수
	// function gridOnRowOTSelect(id, ind){
	// 	var url    = "SubAttributeType_SortNum.do"; // 요청이 날라가는 주소
	// 	var data   = "&SortNum="+ p_gridArea.cells(id, 2).getValue() +
	// 				 "&AttrTypeCode="+ p_gridArea.cells(id, 3).getValue() +
	// 				 "&Mandatory=" + p_gridArea.cells(id, 6).getValue() +
	// 				 "&ItemClassCode=${s_itemID}" +
	// 				 "&ClassName=${ClassName}" +
	// 				 "&languageID=${languageID}"
	// 				 + "&CategoryCode=${CategoryCode}&ItemTypeCode=${ItemTypeCode}&pageNum=${pageNum}";
	// 	var target = "testDiv"; 
	// 	ajaxPage(url, data, target);	
	// }

</script>

</html>