<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<c:url value="/" var="root" />
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message
	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023"
	var="WM00023" />
<spring:message
	code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004"
	var="CM00004" />
<spring:message
	code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006"
	var="CM00006" />
<spring:message
	code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001"
	var="CM00001" />
<spring:message
	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00020"
	var="WM00020" />
	
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<style>
.dhx_grid-cell {
	color: rgba(0, 0, 0, 0.95);
}
.dhx_grid-cell .edit-button, .dhx_grid-cell .save-button {
	padding: 0 25px;
}
.dhx_layout-rows {
	flex: 1 auto;
}
.dhx_layout-columns .dhx_layout-rows:first-child .dhx_form-element {
	padding-right:20px;
}
</style>
<!-- 2. Script -->
<script type="text/javascript">

	$(document).ready(function() {
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			},
		});	
	});
	

	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용

	$(document).ready(
			function() {
				var height = 360;
				// 초기 표시 화면 크기 조정 
				$("#layout").attr("style","height:" + (setWindowHeight() - height) + "px;");
				// 화면 크기 조정
				window.onresize = function() {
					$("#layout").attr("style",
							"height:" + (setWindowHeight() - height) + "px;");
				};
			});

	function setWindowHeight() {
		var size = window.innerHeight;
		var height = 0;
		if (size == null || size == undefined) {
			height = document.body.clientHeight;
		} else {
			height = window.innerHeight;
		}
		return height;
	}

	function AddWorkStep() {
		var url = "AddSimbolTypePop.do";
		var data = "&ModelTypeCode=${ModelTypeCode}" + "&LanguageID="
				+ $("#getLanguageID").val() + "&Name="
				+ escape(encodeURI('${Name}'));
		
		var option = "width=920,height=600,left=300,top=100,toolbar=no,status=no,resizable=yes";
		url += "?" + data;
		
		window.open(url, self, option);
	}

	function DeleteSymbolType() {
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox; 
		});
		 if(!selectedCell.length){ //배열의 길이가 0   => !FALSE == TRUE
		alert("${WM00023}");	
		} else {
			   // 배열의 길이가 하나이상 있음 1 => !TRUE ==FALSE
			if(confirm("${CM00004}")){ 
				for(idx in selectedCell){
					var url = "admin/DeleteSymbolType.do";
					var data = "&ModelTypeCode=" + selectedCell[idx].ModelTypeCode
							 +	"&SymTypeCode="+selectedCell[idx].SymTypeCode
					         + "&gubun=0"
					
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

	function fnEditSortNum() {
		var checkedCell = grid.data.findAll(function (data) {
	        return data.checkbox; 
		});
	 if(!checkedCell.length){ //배열의 길이가 0   => !FALSE == TRUE
			alert("${WM00020}");	
			} else {
				   // 배열의 길이가 하나이상 있음 1 => !TRUE ==FALSE
				var symTypes = new Array;
				for(idx in checkedCell){	
					symTypes[idx] = "'"+checkedCell[idx].SymTypeCode+"'";		 
				}
				console.log("symTypes"+symTypes);
				var url = "openEditSymAllocSortNum.do?symTypes="+symTypes+"&ModelTypeCode=${ModelTypeCode}";
				var w = 600;
				var h = 600;
				itmInfoPopup(url,w,h);
			}
	}


</script>
<body>
<form name="SimbolTypeList" id="SimbolTypeList" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="CurrPageNum" name="CurrPageNum"value="${pageNum}"> 
		<input type="hidden" id="Name"name="Name" value="${Name}"> <input type="hidden"id="ModelTypeCode" name="ModelTypeCode" value="${ModelTypeCode}">
		<input type="hidden" id="getLanguageID" name="getLanguageID"value="${LanguageID}">

	<div class="child_search01 mgB5 mgL10 mgR10">
		<ul>
			<li class="floatR pdR10">
			  <c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
					<button class="cmm-btn mgR5 floatR " style="height: 30px;" onclick="DeleteSymbolType()" value="Del">Del</button>
					<button class="cmm-btn mgR5 floatR " style="height: 30px;" onclick="fnEditSortNum()" value="Edit">Edit</button> 
					<button class="cmm-btn mgR5 floatR " style="height: 30px;" onclick="AddWorkStep()" value="Add">Add</button>
				</c:if>
			</li>
		</ul>
	</div>
</form>	

<div style="width: 100%;" id="layout"></div>
<!-- <div id="grdGridArea"  class="mgL10 mgR10" style="width:100%;" class="clear"></div>	
 -->

	
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="ArcFrame" id="ArcFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
	<!-- END :: BOARD_ADMIN_FORM -->
	

<script type="text/javascript">
var layout = new dhx.Layout("layout", {
    rows: [
        {
            id: "a",
        },
    ]
});


var gridData = ${gridData};
var grid = new dhx.Grid("grdOTGridArea", {
    columns: [
        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
		{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
        { hidden: true,width: 100, id: "ModelTypeCode", header: [{ text: "ModelTypeCode" , align: "center" }, { content: "inputFilter" }], align: "center" },
        { fillspace: true, id: "SymTypeCode", header: [{ text: "${menu.LN00015}", align: "center" }], align: "center" },
        { hidden: true,width: 100, id: "ItemTypeCode", header: [{ text: "ItemTypeCode", align: "center" }, { content: "inputFilter" }], align: "center" },     
      
        { width: 150, id: "SymbolIcon", header: [{ text: "${menu.LN00176}", align: "center" }], align: "center", htmlEnable: true,
    		template: function (text, row, col) {
            	var result = "";
            	if(text) result += "<img src='${root}${HTML_IMG_DIR_MODEL_SYMBOL}/symbol/" + row.SymbolIcon + "' />";
                return result;
            }	
        },	
        { width: 200, id: "Name", header: [{ text: "${menu.LN00028}" , align:"center"},{content:"inputFilter"}],align:"center" },
        { hidden: true, width: 100, id: "Description", header: [{ text: "${menu.LN00035}", align: "center" }] },
        { hidden: true, width: 200, id: "ArisTypeNum", header: [{ text: "ArisTypeNum", align: "center" }] },
        { hidden: true,width: 100, id: "FromSymType", header: [{ text: "FromSymType", align: "center" }] },
        { hidden: true,width: 100, id: "ToSymType", header: [{ text: "ToSymType", align: "center" }, { content: "selectFilter" }], align: "center" },
        { hidden: true,width: 100, id: "ImagePath", header: [{ text: "ImagePath", align: "center" }, { content: "selectFilter" }], align: "center" },
        { hidden: true,width: 300, id: "Creator", header: [{ text: "Creator", align: "center" }, { content: "selectFilter" }], align: "center" },
        { hidden: true,width: 100, id: "CreationTime", header: [{ text: "CreationTime", align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 200, id: "Category", header: [{ text: "Category", align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 200, id: "ItemTypeName", header: [{ text: "${menu.LN00021}", align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 200, id: "Class", header: [{ text: "${menu.LN00016}", align: "center" }], align: "center" },
        { width: 200, id: "SortNum", header: [{ text: "Sort No.", align: "center" }], align: "center" },
       
    ],

    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    data: gridData
});
layout.getCell("a").attach(grid);



 function urlReload() {
	$.ajax({
		url: "getModelTypeTabList.do",
		data: "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&ModelTypeCode=${ModelTypeCode}",
		type:"POST",
		cotentType:"application/json",
		success: function(result){				
			if(grid != ""){
				grid.data.parse(result);
				fnMasterChk('');
			}
		},error:function(xhr,status,error){
			console.log("ERR :["+xhr.status+"]"+error);
		}
	});
} 

</script>	
</body>
</html>

