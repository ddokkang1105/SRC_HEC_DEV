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

<!-- 2. Script -->
<script type="text/javascript">
$(function(){
	// 초기 표시 화면 크기 조정
	$("#layout").attr("style","height:"+(setWindowHeight() - 80)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#layout").attr("style","height:"+(setWindowHeight() - 80)+"px;");
	};
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

// [Add]	
function addConnectionType(){
	var url = "addConnectionType.do";
	var option = "width=510,height=250,left=500,top=300,toolbar=no,status=no,resizable=yes";
    window.open(url, self, option);
}

// [Del]
// function delConnectionType() {
// 	if (OT_gridArea.getCheckedRows(1).length == 0) {
// 		//alert("항목을 한개 이상 선택하여 주십시요.");	
// 		alert("${WM00023}");	
// 	} else {
// 		//if (confirm("선택된 항목을 삭제하시겠습니까?")) {
// 		if (confirm("${CM00004}")) {
// 			var checkedRows = OT_gridArea.getCheckedRows(1).split(",");
// 			var connectionTypeCode = "";
// 			for ( var i = 0; i < checkedRows.length; i++) {
// 				var cnt = OT_gridArea.cells(checkedRows[i], 10).getValue();
// 				if (cnt > 0) {
// 					var id = "ID:" + OT_gridArea.cells(checkedRows[i], 2).getValue();
// 					"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00112' var='WM00112' arguments='"+ id +"'/>"
// 					alert("${WM00112}");
// 					OT_gridArea.cells(checkedRows[i], 1).setValue(0); 
// 				} else {
// 					if (connectionTypeCode == "") {
// 						connectionTypeCode = OT_gridArea.cells(checkedRows[i], 2).getValue();
// 					} else{ 
// 						connectionTypeCode = connectionTypeCode + "," + OT_gridArea.cells(checkedRows[i], 2).getValue();
// 					}
// 				}
// 			}
			
// 			if (connectionTypeCode != "") {
// 				var url = "delConnectionType.do";
// 				var data = "connectionTypeCode=" + connectionTypeCode;
// 				var target = "saveFrame";
// 				ajaxPage(url, data, target);
// 			}
			
// 		}
// 	}
	
// }
function exportXlsx() {	
		fnGridExcelDownLoad(treeGrid);
	}

function fnEditConnection(cxnType){
	var url = "connectionTypeView.do";
	var data = "ItemTypeCode="+ cxnType+"&selectedCat="+$("#CategoryCode").val();
	var target = "connectionTypeDiv";
	ajaxPage(url, data, target);
}

function fnEditClass(classCode){
	/* var url = "ClassTypeView.do";
	var data = "classCode="+ classCode+"&selectedCat="+$("#CategoryCode").val();
	var target = "connectionTypeDiv";
	ajaxPage(url,data,target); */
	
	
	var url = "subTab.do"; // 요청이 날라가는 주소
	var data = "url=AllocationListMenu&filter="+classCode
			+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&cfgCode=${cfgCode}"
			+"&selectedCat="+$("#CategoryCode").val();
	var target = "connectionTypeDiv";
	ajaxPage(url,data,target);
}

//popup 창 띄우기, 창 크기 부분
function AddClassPopup() {
	var url = "addClassPop.do";
	var data = "?categories='CN','MCN','ST2'";
	var option = "width=510,height=250,left=300,top=300,toolbar=no,status=no,resizable=yes";
	window.open(url + data, self, option);
}
	
	
</script>
<style>
	.group_row {
		background: rgba(65, 152, 247, 0.15);
	}
	.dhx_layout-rows {
		flex: 1 auto;
	}
	.dhx_layout-columns .dhx_layout-rows:first-child .dhx_form-element {
		padding-right:20px;
	}
	.icon-bg {
		background: #525252;
	}
	.dhx_grid-row:hover {
		background: rgba(65, 152, 247, 0.15);
	    cursor: pointer;
	    box-shadow: 2px 0px 0px 0px #4265ee inset;
	    transition: background-color .2s ease-out;
	}
	.font-bold * {
		font-weight: 600;
	}
</style>
</head>

<body>
<div id="connectionTypeDiv" style="display: block;height: 100%;overflow: hidden auto;">	
<form name="objectTypeList" id="objectTypeList" action="saveObject.do" method="post" onsubmit="return false;">
	<input type="hidden" id="orgTypeCode" name="orgTypeCode" />
	<input type="hidden" id="SaveType" name="SaveType" value="New" />
	<div class="cfgtitle" >	
			
		<ul>
			<li style="font-size:14px;"><a style="font-weight:400;font-size:14px;">Master data&nbsp;></a>&nbsp;&nbsp;Connection Type</li>
		</ul>
	</div>

	<div class="child_search01 mgL10 mgR10">
		<li class="">
			Category
			<select id="CategoryCode" name="CategoryCode" onchange="fnGetCategoryList(this.value)" style="margin-left:10px;margin-right: 10px;">
				<option value="">Select</option>
				<option value="CN">CN</option>
				<option value="MCN">MCN</option>
				<option value="ST2">ST2</option>
			</select>
		</li>
		<li class="floatR pdR10">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				
				<button class="cmm-btn mgR5" style="height: 30px;" onclick="addConnectionType();" value="Add" >Add Connection</button>
				<button class="cmm-btn mgR5" style="height: 30px;" onclick="AddClassPopup()"  value="Class">Add Class</button>
				<button class="cmm-btn mgR5" style="height: 30px;" onclick="exportXlsx()"  value="Down" >Download List</button>
				
				<!-- 삭제 아이콘  -->
<!-- 				&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delConnectionType();" ></span> -->
		</c:if>
		</li>
	</div>
</form>
	<div id="treeGridArea" style="width: 100%"></div>
	<div style="width: 100%;" id="layout"></div>
</div>	
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
	<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var treeGridData = ${treeGridData};
	
	var treeGrid = new dhx.Grid("treeGridArea", {
		type: "tree",
		columns: [
	    	{ id: "Name", type: "string", header: [{ text: "Name", align:"center" }, { content: "inputFilter" }], fillspace: true},
	        { id: "Action", type: "string", header: [{ text: "Action", align:"center" }], width:200, htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		if(row.parent == "treeGridArea") return '<span class="btn_pack small icon mgR10"><span class="config"></span><input value="Config." type="submit" onclick="fnEditConnection(\''+row.id+'\')" ></span>';
	        		else return '<span class="btn_pack small icon mgR10"><span class="config"></span><input value="Config." type="submit" onclick="fnEditClass(\''+row.id+'\')" ></span>';
	            },
	        },
// 	        { id: "checkbox", type: "boolean", header: [{ text: "" }], editable: true, width:70 },
	        { id: "id", type: "string", header: [{ text: "Code", align:"center" }, { content: "inputFilter" }], width:150, align:"center"},
// 	        { id: "Level", type: "string", header: [{ text: "Level", align:"center" }, { content: "selectFilter" }], width:80, align:"center" },
// 	        { id: "FileOption", type: "string", header: [{ text: "File Option", align:"center" }, { content: "selectFilter" }], width:110, align:"center"},
// 	        { id: "ChangeMgt", type: "string", header: [{ text: "Change Mgt", align:"center" }, { content: "selectFilter" }], width:110, align:"center"},
// 	        { id: "CheckInOption", type: "string", header: [{ text: "Check In Option", align:"center" }, { content: "selectFilter" }], width:130, align:"center" },
// 	        { id: "HasDimension", type: "string", header: [{ text: "Dimension", align:"center" }, { content: "selectFilter" }], width:100, align:"center" },
	        { id: "FromItemName", type: "string", header: [{ text: "From Type", align:"center" }, { content: "selectFilter" }], width:150, align:"center" },
	        { id: "ToItemName", type: "string", header: [{ text: "To Type", align:"center" }, { content: "selectFilter" }], width:150, align:"center" },
	        { id: "Deactivated", type: "string", header: [{ text: "Deactivated", align:"center" }, { content: "selectFilter" }], width:150, align:"center" },
	        { id: "Category", type: "string", header: [{ text: "Category" },{content :"selectFilter"}], width:100, hidden:true },
	    ],
	    autoWidth: true,
	    resizable: true,
	    data : treeGridData
	});

	layout.getCell("a").attach(treeGrid);
	
	treeGridData.filter(function (item) {
		if(item.parent != "treeGridArea") treeGrid.collapse(item.parent);
    });
	
	if("${selectedCat}" != "") {
		console.log("${selectedCat}")
		$("#CategoryCode").val("${selectedCat}");
		fnGetCategoryList("${selectedCat}");
	}
	
	function fnGetCategoryList(category){
		treeGrid.data.findAll(function (item) {
			if(category == "") {
				treeGrid.data.findAll(function (item) {
					treeGrid.showRow(item.id);
				});
			}
			
			if(item.parent == "treeGridArea") {
				if(item.Category != category) treeGrid.hideRow(item.id);
				if(item.Category == category) treeGrid.showRow(item.id);
			}
		});
	}
		
	function fnCallBack(newData){
		$.ajax({
			url: "getCxnAndClassList.do",
			data:"",
			type:"POST",
			cotentType:"application/json",
			success: function(result){				
				if(treeGrid != ""){
					treeGrid.data.parse(result);
					treeGridData.filter(function (item) {
						if(item.parent != "treeGridArea") treeGrid.collapse(item.parent);
				    });
				}
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	}
</script>
</body>
</html>