<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

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
	
	// 초기 표시 화면 크기 조정
	$("#layout").attr("style","height:"+(setWindowHeight() - 140)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#layout").attr("style","height:"+(setWindowHeight() - 140)+"px;");
	};
	
	$("#excel").click(function (){
		fnGridExcelDownLoad(); 
	});
	
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

//popup 창 띄우기, 창 크기 부분
function addModelType() {
	
	var url = "modelTypeView.do";

	var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}" 
				+"&viewType=N"
				+"&pageNum=" + $("#currPage").val();

	var target ="modelTypeDiv";
	
	ajaxPage(url, data, target);  

}

function delModelFLow() {
	
	var selectedCell = grid.data.findAll(function (data) {
        return data.checkbox;
    });
	if(!selectedCell.length){
		alert("${WM00023}");	
	} else {
		if(confirm("${CM00004}")){
			for(idx in selectedCell){
				var url = "admin/DelModelType.do";
				var data = "&ModelTypeCode=" + selectedCell[idx].ModelTypeCode
				+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				
				var i = Number(idx) + 1;
				if (i == selectedCell.length) {
					data = data + "&FinalData=Final";
				}
				var target = "ModelFrame";
				ajaxPage(url, data, target);
				grid.data.remove(selectedCell[idx].id);
			}
		}
	}
}
</script>
</head>
<body>
<div id="modelTypeDiv" style="display: block;height: 100%;overflow: hidden auto;">
<form name="ModelTypeList" id="ModelTypeList" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="SaveType" name="SaveType" value="New" />
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<input type="hidden" id="cfgCode" name="cfgCode" value="${cfgCode}">
	<div class="cfgtitle" >					
		<ul>
			<li style="font-size:14px;"><a style="font-weight:400;font-size:14px;">Master data&nbsp;></a>&nbsp;Model Type</li>
		</ul>
	</div>
	<div class="child_search01 mgL10 mgR10">
		<ul>
			<li class="floatR pdR10">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
					<button class="cmm-btn mgR5" style="height: 30px;" onclick="addModelType()" value="Add" >Add Model Type</button>
					<button class="cmm-btn mgR5" style="height: 30px;" id="excel" value="Down" >Download List</button>
					<button class="cmm-btn mgR5" style="height: 30px;" onclick="delModelFLow()" value="Del">Delete</button>
				</c:if>	
			</li>
		</ul>
	</div>
</form>

<div style="width: 100%;" id="layout"></div>
<div id="pagination"></div>

<div id="testDiv"></div>
</div>

<!-- START :: FRAME --> 		
<div class="schContainer" id="schContainer">
	<iframe name="ModelFrame" id="ModelFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>	
<!-- END :: FRAME -->	

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
        { width: 50, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center", htmlEnable: true}], align: "center", type: "boolean", editable: true, sortable: false},
        { width: 150, id: "ModelTypeCode", header: [{ text: "${menu.LN00015}" , align: "center" }, { content: "inputFilter" }], align: "center" },
        { hidden: true, width: 150, id: "ItemTypeCode", header: [{ text: "ItemTypeCode" }] },
        { width: 300, id: "Name", header: [{ text: "${menu.LN00028}", align: "center" }, { content: "inputFilter" }], align: "left" },
        {
            id: "action", width: 150, header: [{ text: "Actions", align: "center" }],
            htmlEnable: true, align: "center",
            template: function () {
            	return '<span class="btn_pack small icon mgR10 edit"><span class="config"></span><input value="Config." type="submit"></span>';
            }
        },
        { fillspace: true, id: "Description", header: [{ text: "${menu.LN00035}", align: "center" }, { content: "inputFilter" }], align: "left" },
        { hidden: true, width: 100, id: "ArisTypeNum", header: [{ text: "ArisTypeNum" }] },
        { width: 100, id: "IsModel", header: [{ text: "IsModel", align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 200, id: "ZoomOptionName", header: [{ text: "ZoomOption", align: "center" }, { content: "selectFilter" }], align: "center" },
        { hidden: true, width: 100, id: "ZoomOption", header: [{ text: "ZoomOption" }] },
       
    ],
    eventHandlers: {
        onclick: {
            "edit": function (e, data) {
            	fnEditMltp(data.row);
            }
        }
    },
    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    data: gridData
});
layout.getCell("a").attach(grid);

var pagination = new dhx.Pagination("pagination", {
    data: grid.data,
    pageSize: 20,
});

function fnEditMltp(data) {

	var url = "subTab.do"; // 요청이 날라가는 주소
	var data = "url=modelTypeMenu"
	            +"&filter="+data.ModelTypeCode 
				+"&ItemTypeCode="+ data.ItemTypeCode 
				 +"&Name="+data.Name
				+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&cfgCode=${cfgCode}"
				+ "&pageNum=" + $("#currPage").val(); 
	var target = "modelTypeDiv"; 

	ajaxPage(url, data, target);

}

function urlReload() {
	
	$.ajax({
		url: "getModelTypeList.do",
		data:"",
		type:"POST",
		cotentType:"application/json",
		success: function(result){				
			if(grid != ""){
				grid.data.parse(result);
			}
		},error:function(xhr,status,error){
			console.log("ERR :["+xhr.status+"]"+error);
		}
	});
}

</script>
	
</body>
</html>