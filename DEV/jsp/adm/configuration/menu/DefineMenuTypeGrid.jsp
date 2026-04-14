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
	
	//===============================================================================
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//그리드ROW선택시
	function gridOnRowOTSelect(data){
		var url = "menuTypeDetailView.do"; // 요청이 날라가는 주소
		var data = "menuID="+ data.row.MenuID + "&pageNum=" + pagination.getPage();
		var target = "menuTypeDiv";
		ajaxPage(url,data,target);		
	}
	
	//popup 창 띄우기, 창 크기 부분
	function addMenuPopup() {
		var url = "addMenuPopup.do";
		var option = "width=570,height=260,left=500,top=300,toolbar=no,status=no,resizable=yes";
	    window.open(url, self, option);
	}
		
	// [Del] Click
	function deleteMenu() {
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00023}");
		} else {
			if (confirm("${CM00004}")) {
				var menuIds = "";				
				for(idx in selectedCell){
					if(selectedCell[idx].CNT > 0) {
						var id = "ID:" + selectedCell[idx].MenuID;
						"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00112' var='WM00112' arguments='"+ id +"'/>"
						alert("${WM00112}");
						grid.data.update(selectedCell[idx].id, { checkbox: false });
					} else {
					    if (menuIds == "") {
					    	menuIds = selectedCell[idx].MenuID;
						} else {
							menuIds += ","+selectedCell[idx].MenuID;
						}
					}
				};

				if (menuIds != "") {
					var url = "admin/deleteMenu.do";
					var data = "menuIds=" + menuIds + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
					var target = "blankFrame";
					ajaxPage(url, data, target);
				}
			}
		}
		
	}
	
	function urlReload() {
		$.ajax({
			url: "getMenuTypeList.do",
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

</head>
<body>
<div id="menuTypeDiv">
	<form name="processList" id="processList" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="currPage" name="currPage" value="${pageNum}"/> 
		<div class="cfgtitle" >					
			<ul>
				<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Menu</li>
			</ul>
		</div>	
		<div class="child_search01 mgL10 mgR10">
			<ul>
				<li class="floatR pdR10">
					<!-- 엑셀 다운 아이콘  -->
				    <button class="cmm-btn mgR5" style="height: 30px;" id="excel" value="Down" >Download List</button>
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
					<!-- 생성 아이콘 -->
					<button class="cmm-btn mgR5" style="height: 30px;" onclick="addMenuPopup();" value="Add" >Add Menu Type</button>
					<!-- 삭제 아이콘 -->
					<button class="cmm-btn mgR5" style="height: 30px;" onclick="deleteMenu()" value="Del">Delete</button>	
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
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}", align:"center" }], align: "center" },
	        { width: 50, id: "checkbox", type: "boolean", header: [{ text: "", align:"center" }], editable: true },
	        { width: 100, id: "MenuID", header: [{ text: "MenuID", align:"center" }, { content: "inputFilter" }], align: "center" },
	        { width: 200, id: "MenuName", header: [{ text: "MenuName", align:"center" }, { content: "inputFilter" }] },
	        {
	            id: "action", width: 150, header: [{ text: "Actions", align: "center" }],
	            htmlEnable: true, align: "center",
	            template: function () {
	            	return '<span class="btn_pack small icon mgR10 edit"><span class="config"></span><input value="Config." type="submit"></span>';
	            }
	        },
	        { id: "URL", header: [{ text: "URL", align:"center" }, { content: "inputFilter" }] },
	        { width: 250,  id: "VarFilter", header: [{ text: "VarFilter", align:"center" }, { content: "inputFilter" }] },
	        { width: 150,  id: "Category", header: [{ text: "Category", align:"center" }, { content: "selectFilter" }], align: "center" },
	        { width: 90,  id: "Deactivated", header: [{ text: "Deactivated", align:"center" }, { content: "selectFilter" }], align: "center" },
	        { hidden: true,  id: "CNT", header: [{ text: "CNT" }]},
       	 	
	    ],
	    eventHandlers: {
	        onclick: {
	            "edit": function (e, data) {
	            	gridOnRowOTSelect(data);
	            }
	        }
	    },
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	});
	
	layout.getCell("a").attach(grid);
	
	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});	

	pagination.setPage(document.getElementById('currPage').value);
</script>
		
</body>
</html>