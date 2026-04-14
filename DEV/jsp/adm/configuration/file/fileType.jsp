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

//[Add Click] popup 창 띄우기, 창 크기 부분
function AddFltpTypePop() {
	var url = "addFileTypePop.do";
	var option = "width=510,height=240,left=500,top=300,toolbar=no,status=no,resizable=yes";
    window.open(url, self, option);
}

//[Del Click]
function delFileType() {
	var selectedCell = grid.data.findAll(function (data) {
        return data.checkbox;
    });
	if(!selectedCell.length){
		alert("${WM00023}");	
	} else {
		if(confirm("${CM00004}")){
			var fltpCode = "";
			for(idx in selectedCell){
				if (selectedCell[idx].CNT > 0) {
					var id = "ID:" + selectedCell[idx].FltpCode;
					"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00112' var='WM00112' arguments='"+ id +"'/>"
					alert("${WM00112}");
					grid.data.update(selectedCell[idx].id, { checkbox: false });
				} else {
					if (fltpCode == "") {
						fltpCode = selectedCell[idx].FltpCode;
					} else{ 
						fltpCode = fltpCode + "," + selectedCell[idx].FltpCode;
					}
				}
			};
			
			if (fltpCode != "") {
				var url = "admin/delFileType.do";
				var data = "fltpCodes=" + fltpCode;
				var target = "blankFrame";
				ajaxPage(url, data, target);
			}			
		}
	}
}
</script>
</head>
<body>
<div id="fileTypeDiv">
<form name="processList" id="processList" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<div class="cfgtitle" >					
		<ul>
			<li style="font-size:14px;"><a style="font-weight:400;font-size:14px;">Master data&nbsp;></a>&nbsp;File Type</li>
		</ul>
	</div>

	<div class="child_search01 mgL10 mgR10">
		<ul>
		<li class="floatR pdR10">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<button class="cmm-btn mgR5" style="height: 30px;" onclick="AddFltpTypePop()" value="Add" >Add File Type</button>
				<button class="cmm-btn mgR5" style="height: 30px;" id="excel" value="Down" >Download List</button>
				<button class="cmm-btn mgR5" style="height: 30px;" onclick="delFileType()" value="Del">Delete</button>	
		</c:if>	
		</li>
		</ul>
	</div>
</form>
	<div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>
</div>
	
<!-- START :: FRAME --> 		
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>	
<!-- END :: FRAME -->	
<script>
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
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}", align: "center" }], align: "center" },
	        { width: 50, id: "checkbox", header: [{ text: "", align: "center" }], align: "center", type: "boolean",  editable: true},
	        { width: 150, id: "FltpCode", header: [{ text: "FltpCode", align: "center" }, { content: "inputFilter" }] , align: "center"},
	        { width: 200, id: "Name", header: [{ text: "Name", align: "center" }, { content: "selectFilter" }], align: "left" },
	        {
	            id: "action", width: 150, header: [{ text: "Actions", align: "center" }],
	            htmlEnable: true, align: "center",
	            template: function () {
	            	return '<span class="btn_pack small icon mgR10 edit"><span class="config"></span><input value="Config." type="submit"></span>';
	            }
	        },
	        { width: 100, id: "RevisionYN", header: [{ text: "Revision", align: "center" }, { content: "selectFilter" }], align: "center" },
	        { width: 100, id: "IsPublic", header: [{ text: "Is Public", align: "center" }, { content: "selectFilter" }], align: "center" },
	        { fillsapce: true, id: "FilePath", header: [{ text: "File Path", align: "center" }, { content: "inputFilter" }], align: "left" },
	       
	    ],
	    eventHandlers: {
	        onclick: {
	            "edit": function (e, data) {
	            	fnEditFltp(data.row);
	            }
	        }
	    },
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
// 	    editable: true,
	    data: gridData
	});
	layout.getCell("a").attach(grid);
	
	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 20,
	});
	
	function fnEditFltp(data){
		var url = "fileTypeView.do";
		var data = "FltpCode="+ data.FltpCode;
		var target = "fileTypeDiv";
		ajaxPage(url, data, target);
	}

	function urlReload(){
		$.ajax({
			url: "getFileTypeList.do",
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