<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
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

	$(document).ready(function() {
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			},
		});	
	});

	$(function(){	
		$("#layout").attr("style","height:"+(setWindowHeight() - 90)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 90)+"px;");
		};
	});
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function fnEditArc(arcCode, type){
		var url = "subTab.do";
		var urlDetail = "DefineArchitectureMenu";
		
// 		if(type=="G"){
// 			url = "allocateArchitecture.do";
// 		}else{
// 			urlDetail = "DefineArchitectureMenu";
// 		}
		var data ="url="+urlDetail+"&ArcCode="+arcCode+"&type="+type
				+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+ "&viewType=E&cfgCode=${cfgCode}";
		var target ="processListDiv";
		ajaxPage(url,data,target);
	}
	
	function fnDelArc(){
		var selectedCell = treeGrid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00023}");
		} else {
			if(confirm("${CM00004}")){
				var url = "admin/deleteArchitecture.do";
				var arcCodes = "";
				for(idx in selectedCell){
				    if (arcCodes == "") {
				    	arcCodes = selectedCell[idx].id;
					} else {
						arcCodes += ","+selectedCell[idx].id;
					}
				};
				
				var target = "blankFrame";
				var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&arcCodes="+arcCodes;
				ajaxPage(url,data,target);
			}
		}
	}
	
	function fnCallBack(e){
		var arcCodes = e.split(",");
		arcCodes.forEach(function(arcCode){
			treeGrid.data.remove(arcCode);
		});
	}
	
	function fnAddArc(){
		var url = "architectureView.do";
		var data = "&cfgCode=${cfgCode}&pageNum=" + $("#currPage").val() +"&viewType=N";				
		var target = "processList";	
		ajaxPage(url,data,target);	
	}

	function exportXlsx() {
		fnGridExcelDownLoad(treeGrid);
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
<div id="processListDiv" style="display: block;height: 100%;overflow: hidden auto;">	
<form name="processList" id="processList" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="arcCodes" name="arcCodes" value="" />
	<div class="cfgtitle" >					
				<span id="cfgPath">
					<c:forEach var="path" items="${path}" varStatus="status">
						<c:choose>
							<c:when test="${status.last}">
							<span style="font-weight: bold;">${path.cfgName}</span>
							</c:when>
							<c:otherwise>
							<span>${path.cfgName}&nbsp;>&nbsp;</span>
							</c:otherwise>					
						</c:choose>
					</c:forEach>
				</span>
	</div>
	<div class="child_search01 mgL10 mgR10">
		<li class="floatR pdR10">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				
				<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnAddArc()"  value="Add" >Add Arc Type</button>
				<button class="cmm-btn mgR5" style="height: 30px;" onclick="exportXlsx()" value="Down" >Download List</button>
				<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnDelArc()"  value="Del">Delete</button>	
			</c:if>
		</li>
	</div>
	<div style="width: 100%;" id="layout"></div>
	</form>
	</div>	
	<div class="schContainer" id="schContainer" style="display:none;">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
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
	        { id: "id", type: "string", header: [{ text: "Code", align: "center" }, { content: "inputFilter" }], align: "left", width:150,
	            mark: function (cell, data, row, col) {
	                return row.parent == "treeGridArea" ? "font-bold" : "";
	            }
	        },
	        { id: "checkbox", type: "boolean", header: [{ text: "", align: "center" }], editable: true, width:70 },
	        { id: "Name", type: "string", header: [{ text: "Name", align: "center" }, { content: "inputFilter" }], align: "left", fillspace: true },
	        { id: "Action", type: "string", header: [{ text: "Action", align: "center" }], width:150, htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	                return '<span class="btn_pack small icon mgR10"><span class="config"></span><input value="Config." type="submit" onclick="fnEditArc(\''+row.id+'\',\''+row.Type+'\')" ></span>';
	            },
	        },
	        { id: "MenuName", type: "string", header: [{ text: "Menu", align: "center" }, { content: "inputFilter" }], width: 200, align: "center" },
	        { id: "Style", type: "string", header: [{ text: "Style", align: "center" }, { content: "inputFilter" }], width:200, align: "center" },
	        { id: "Icon", type: "string", header: [{ text: "Icon", align: "center" }, { content: "inputFilter" }], width:100, htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	                return text ? "<img src='${root}${HTML_IMG_DIR_ARC}/" + text + "'>": "";
	            },
// 	            mark: function (cell, data, row, col) {
// 	                return cell ? "icon-bg" : "";
// 	            }
	        },
	        { id: "Deactivated", type: "string", header: [{ text: "Deactivated", align: "center" }, { content: "selectFilter" }], width:100, align: "center" },
	        { id: "Type", type: "string", header: [{ text: "Type", align: "center" }, { content: "selectFilter" }], width:100, align: "center" },
	    ],
	    autoWidth: true,
	    resizable: true,
	    data : treeGridData
	});
	
	layout.getCell("a").attach(treeGrid);
	
	treeGridData.filter(function (item) {
		if(item.parent != "treeGridArea") treeGrid.collapse(item.parent);
    });
	</script>
</body>
</html>