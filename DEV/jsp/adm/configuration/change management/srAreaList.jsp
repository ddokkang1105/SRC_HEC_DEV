<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용

	$(document).ready(function() {
		
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			},
		});	
		
		// 초기 표시 화면 크기 조정
		$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 340)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 340)+"px;");
		};
		
		fnSelect('SRType', '', 'getSRTypeCode', '', 'Select');
		
		$("#excel").click(function(){ fnGridExcelDownLoad(); });	
	});
	
	
function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

function fnAddSRAreaList(){
	viewType = "N";
	$("#NewSRArea").attr('style', 'display: table');	
	$("#divSaveSRArea").attr('style', 'display: block');
	$(".addTd").attr('style', 'display: table-cell');
	$(".modTd").attr('style', 'display: none');

	fnSelect('SRTypeNameNew', '&languageID=${sessionScope.loginInfo.sessionCurrLangType}', 'getNameFromSRTypeCode','', 'Select');
 	$("#SRTypeNameNew").val("");
	$("#ItemClassNameNew").val("");
	$("#LevelNew").val(""); 
 	$("#SRTypeNameNew").change(function(){
		 var SRTypeCode = $("#SRTypeNameNew").val();
		 var data = "&sessionCurrLangType=${sessionScope.loginInfo.sessionCurrLangType}&srTypeCode=" + SRTypeCode;
		fnSelect('ItemClassNameNew', data, 'classCodeOption','', 'Select');
	}); 
	 $("#ItemClassNameNew").change(function(){
		$("#ItemClassCodeNew").val($("#ItemClassNameNew").val());
	}); 
}

function saveSRArea(){
	var ItemClassCode = $("#ItemClassCode").text();
	
	if(viewType == "N" ){	// add일 경우
		var SRTypeCode = $("#SRTypeNameNew").val();
		var ItemClassCodeNew = $("#ItemClassCodeNew").val();
		var LevelNew = $("#LevelNew").val();
		// [OBJECT 필수 체크]		
		if(LevelNew == ""){
			alert("${WM00034_3}");
			return false;
		}
		if(ItemClassCodeNew == ""){
			alert("${WM00034_1}");
			alert("${WM00034_2}");
			return false;
		}
	} else {		//edit일 경우
		var SRTypeCode = $("#SRTypeTd").text();
		var ItemClassCodeNew = $("#ItemClassNameTd").val();
		var LevelTd = $("#Level").val();
		var LevelNew = $("#LevelTd").val();
		var ItemClassCode = $("#ItemClassCode").val();
	}
	
	var url = "admin/saveSRArea.do";
	var data = "viewType="+viewType+"&SRTypeCode="+SRTypeCode+"&ItemClassCodeTd="+ItemClassCode+"&LevelTd="+LevelTd+"&Level="+LevelNew
	+"&ItemClassCode="+ItemClassCodeNew+"&languageID=${languageID}&lastUser=${sessionScope.loginInfo.sessionUserId}"; 
	var target = "saveDFrame";

	ajaxPage(url, data, target);
	thisReload();
}

function fnDelSRAreaList(){
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){
			alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
		}else{
			if(confirm("${CM00004}")){
				for(idx in selectedCell){
					var url = "admin/deleteSRAreaList.do";
					var data = "&ItemClassCode="+selectedCell[idx].ItemClassCode+"&Level="+selectedCell[idx].Level+"&pageNum=" + $("#currPage").val();	
					var i = Number(idx) + 1;
					if (i == selectedCell.length) {
						data = data + "&FinalData=Final";
					}
					var target = "saveDFrame";
					ajaxPage(url, data, target);
					grid.data.remove(selectedCell[idx].id);	
				}
			}
		}
	}
 
function fnCallBack(){ 
	$("#NewSRArea").attr('style', 'display: none');
	$("#divSaveSRArea").attr('style', 'display: none');
	$("#SRTypeNew").val("");
	$("#ItemClassCode").val("");
	$("#ItemClassName").val("");	
}

function thisReload(){
		var sqlID = "config_SQL.getAllSRAreaList";
		var param =  "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
	        		+ "&sqlID="+sqlID;
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				location.reload();
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


</script>

</head>

<body>
<div id="srAreaDiv">
	<form name="srAreaList" id="srAreaList" action="" method="post" onsubmit="return false;">	
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input>
	<input type="hidden" id="Level" name="Level" value="${Level}"></input> 
	<input type="hidden" id="ItemClassCode" name="ItemClassCode" value="${ItemClassCode}" />
	<input type="hidden" id="ItemClassCodeNew" name="ItemClassCodeNew" value="" />
	<input type="hidden" id="ItemClassName" name="ItemClassName" value="${ItemClassName}" />
	<div class="cfgtitle" >				
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;SR Area List</li>
		</ul>
	</div>	
	<div class="child_search01 mgL10 mgR10">
		<li class="floatR pdR10">
			<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnAddSRAreaList()" value="Add" >Add SR Area</button>
			<button class="cmm-btn mgR5" style="height: 30px;" id="excel" value="Down">Download List</button>
			<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnDelSRAreaList()" value="Del">Delete</button>
		</li>
	</div>
	<div id="gridOTDiv" class="mgB10 clear mgL10 mgR10">
		<div id="grdOTGridArea" style="height:360px; width:100%"></div>
		<div id="pagination"></div>
	</div>
	</form>
	
	
	<div class="mgT10 mgL10 mgR10">
	<table id="NewSRArea" class="tbl_blue01" width="100%" cellpadding="0" cellspacing="0" style="display:none">

		<colgroup>
		</colgroup>
		
		<tr>
			<th width="25%" class="viewtop last">SR Type</th>
			<th width="25%" class="viewtop last modTd">Name</th>
			<th width="25%" class="viewtop last">클래스</th>
			<th width="25%" class="viewtop last">Level </th>
		</tr>
		<tr>
			<!-- <td width="" class="last addTd">
				<select id="SRTypeNew" name="SRTypeNew" class="sel"></select>
			</td> -->
			<td width="" class="last modTd" id="SRTypeTd"></td>
			<td width="" class="last addTd"><select id="SRTypeNameNew" name="SRTypeNameNew" class="sel" ></select></td>
			<td width="" class="last modTd" id="SRTypeNameTd"></td>
			<td width="" class="last addTd"><select id="ItemClassNameNew" name="ItemClassNameNew" class="sel" ></select></td>
			<td width="" class="last modTd"><select id="ItemClassNameTd" name="ItemClassNameTd" class="sel" ></select></td>
			<td width="" class="last addTd">
				<select id="LevelNew" name="LevelNew" class="sel">
					<option value="">Select</option>
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
				</select>
			</td>
			<td width="" class="last modTd">
				<select id="LevelTd" name="LevelTd" class="sel">
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
				</select>
			</td>
		</tr>
	</table>
</div>
</div>
<div class="alignBTN" id="divSaveSRArea" style="display: none;">
	<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
		<button class="cmm-btn2 mgR15" style="height: 30px;" onclick="saveSRArea()" value="Save">Save</button>	
	</c:if>		
</div>		
	<iframe name="saveDFrame" id="saveDFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>

<script type="text/javascript">	//그리드7 자바스크립트
//===============================================================================
// BEGIN ::: GRID
var layout = new dhx.Layout("grdOTGridArea", { 
		rows: [
			{
				id: "a",
			},
		]
	});

	var gridData = ${gridData};
	var grid = new dhx.Grid("grdOTGridArea", {
		columns: [
			{ width: 80, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
			{ width: 80, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
			{ width: 150, id: "SRTypeCode", header: [{ text: "SR Type" , align: "center" }, { content: "inputFilter" }], align: "center" },
			{ fillspace: true, id: "SRTypeNM", header: [{ text: "Name", align: "center" }, { content: "inputFilter" }], align: "center" },
			{ hidden: true, width: 100, id: "ItemClassCode", header: [{ text: "Item Class Code" }] },
			{ width: 200, id: "ItemClassName", header: [{ text: "Item Class Name", align: "center" }, { content: "inputFilter" }], align: "center" },
			{ width: 150, id: "Level", header: [{ text: "Level", align: "center" }, { content: "inputFilter" }], align: "center" }, 
			{ width: 150, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align: "center" }, { content: "selectFilter" }], align: "center" },
			{ width: 150, id: "LastUserName", header: [{ text: "${menu.LN00105}", align: "center" }, { content: "selectFilter" }], align: "center" },
			{ hidden: true, width: 100, id: "ItemTypeCode", header: [{ text: "ItemTypeCode" }] }		
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
			gridOnRowOTSelect(row);
		}
	}); 

	function gridOnRowOTSelect(row) {
		viewType = "E";
		$("#NewSRArea").attr('style', 'display: table');
		$("#divSaveSRArea").attr('style', 'display: block');
		$(".addTd").attr('style', 'display: none');
		$(".modTd").attr('style', 'display: table-cell');
		
		$("#SRTypeTd").text(row.SRTypeCode);
		$("#SRTypeNameTd").text(row.SRTypeNM);
		var ItemTypeCode = row.ItemTypeCode;
		var ItemClassCode = row.ItemClassCode;
		var data = "&sessionCurrLangType=${sessionScope.loginInfo.sessionCurrLangType}&option=" + ItemTypeCode;
		fnSelect('ItemClassNameTd', data, 'classCodeOption', ItemClassCode, 'Select');
		$("#ItemClassCode").val(ItemClassCode);
		$("#ItemClassCodeNew").val($("#ItemClassNameTd").val());
		$("#Level").val(row.Level);
		$("#LevelTd").val(row.LastUpdated);
	}
	// END ::: GRID	
	//===============================================================================	

</script>
</html>
