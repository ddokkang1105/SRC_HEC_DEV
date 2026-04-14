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
<!--Dhtmlx 7 업그레이드  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<!-- 2. Script -->
<script type="text/javascript">
var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용

$(document).ready(function() {

	$.ajaxSetup({
		headers: {
			'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
		},
	});
	
	
	// 초기 표시 화면 크기 조정 
	$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 290)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 290)+"px;");
	};
	
	
});	


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
		{ width: 70, id: "SortNum", header: [{ text: "Sort No." , align: "center" }], align: "center" },
		{ width: 150, id: "AttrTypeCode", header: [{ text: "Code", align: "center" }], align: "center" },
		{ fillspace: true, id: "Name", header: [{ text: "${menu.LN00028}", align: "center" }], align: "left" },
		{ width: 100, id: "Mandatory", header: [{ text: "Mandatory", align: "center" }], align: "center" },
		{ width: 100, id: "Invisible", header: [{ text: "Invisible"  , align: "center" }], align: "center"},
		{ width: 100, id: "LinkName", header: [{ text: "Link", align: "center" }] , align: "center"},				
		{ hidden:true,width: 100, id: "Link", header: [{ text: "Link" }], align: "center" },
		{ width: 100, id: "RowNum", header: [{ text: "RowNum"  , align: "center" }], align: "center" },
		{ width: 100, id: "ColumnNum", header: [{ text: "ColumnNum"  , align: "center" }], align: "center" },
		{ width: 100, id: "AreaHeight", header: [{ text: "Height"  , align: "center" }], align: "center" },
		{ fillspace: true, id: "VarFilter", header: [{ text: "VarFilter"  , align: "center" }], align: "left" },
		{ width: 100, id: "DefValue", header: [{ text: "Default Value"  , align: "center" }], align: "center" },
		
		{ hidden:true,width: 100, id: "AllocationType", header: [{ text: "Allocation" , align: "center"  }], align: "center" }
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


function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}



function AddAttributeType(){
	var url = "addAttrTypeCode.do";
	var data = "&TypeCode=${s_itemID}" + 
				"&languageID=${languageID}"+ 
				"&ItemTypeCode=${ItemTypeCode}"+
				"&ClassName=" + escape(encodeURIComponent('${ClassName}'));			
	url += "?" + data;
	var option = "width=920,height=600,left=300,top=100,toolbar=no,status=no,resizable=yes";
    window.open(url, self, option);
}

// END ::: GRID	
//===============================================================================
	

//조회
	function doOTSearchList(){
		var sqlID = "config_SQL.getClassAttrLocateList";
		var param = "&ItemClassCode=${s_itemID}"	
 					+ "&languageID=${languageID}"
 			 		 + "&sqlID="+sqlID;
					
			$.ajax({
				url:"jsonDhtmlxListV7.do",
				type:"POST",
				data:param,
				success: function(result){
					console.log(result);
					grid.data.parse(result);
					fnMasterChk('');			
				},error:function(xhr,status,error){
					console.log("ERR :["+xhr.status+"]"+error);
				}
			});	
		}	




function DelteAttrType(){
	var selectedCell = grid.data.findAll(function (data) {
		return data.checkbox; 
	});
	if(!selectedCell.length){
		alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
	}else{
		if (confirm("${CM00004}")) {
			for (idx in selectedCell) {
				console.log(typeof idx);
				var url = "admin/DeleteAttrType.do";
				var data = "&SortNum=" + selectedCell[idx].SortNum
							+ "&AttrTypeCode=" +selectedCell[idx].AttrTypeCode
							+ "&ItemClassCode=${s_itemID}" 
							+ "&ItemTypeCode=${ItemTypeCode}";
					
				if (Number(idx) + 1 == selectedCell.length) {
					data = data + "&FinalData=Final"; }

				var target = "ArcFrame";
				
			console.log(selectedCell[idx].SortNum+" "+selectedCell[idx].AttrTypeCode+" ");
				ajaxPage(url, data, target);
				grid.data.remove(selectedCell[idx].id);	
			}
		}
	}
	
}



//그리드ROW선택시
function gridOnRowOTSelect(row){
	 var str = row.VarFilter || "";
		console.log(str);	
    var sortNum = row.SortNum ||"";
	var url    = "SubAttributeType_SortNum.do"; // 요청이 날라가는 주소
	var data   = "&SortNum="+ sortNum +
				 "&AttrTypeCode="+ row.AttrTypeCode +
				 "&Mandatory=" + row.Mandatory +
				 "&Invisible=" + row.Invisible +
				 "&Link=" + row.Link +
				 "&ItemClassCode=${s_itemID}" +
				 "&ClassName=${ClassName}" +
				 "&languageID=${languageID}" +
				 "&areaHeight=" + row.AreaHeight+
				 "&rowNum="+ row.RowNum+
				 "&columnNum="+ row.ColumnNum+
				 "&varFilter=" + str+
				 "&allocationType=" + row.AllocationType+
				 "&CategoryCode=${CategoryCode}&ItemTypeCode=${ItemTypeCode}&pageNum=${pageNum}";
			
	var target = "testDiv";
	ajaxPage(url, data, target);	
}

function Back(){
	var url = "ClassTypeView.do";
	var target = "classTypeDiv";
	var data = "&ItemClassCode=${s_itemID}&LanguageID=${languageID}"
		+ "&CategoryCode=${CategoryCode}&ItemTypeCode=${ItemTypeCode}&pageNum=${pageNum}";
	ajaxPage(url,data,target);
}

function urlReload(){
	var url = "SubAttributeTypeAllocation.do";
	var data = "&languageID=${languageID}&s_itemID=${s_itemID}&ClassName=${ClassName}"
		+ "&CategoryCode=${CategoryCode}&ItemTypeCode=${ItemTypeCode}&pageNum=${pageNum}";
	var target = "ArcFrame";
	ajaxPage(url, data, target);
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
			<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="AddAttributeType()"></span>	
			<span class="btn_pack small icon"><span class=del></span><input value="Del" type="submit" onclick="DelteAttrType()"></span>
		</c:if>	
	</div>
	<div id="gridDiv" class="mgT10">
		<div id="grdGridArea" style="width:100%;"></div>
	</div>
	<div id="testDiv" style="margin-top: 5%"></div>
	</form>
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="ArcFrame" id="ArcFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
</body>
</html>

