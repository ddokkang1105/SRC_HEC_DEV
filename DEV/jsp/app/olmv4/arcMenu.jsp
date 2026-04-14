<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012" />

<!-- 2. Script -->
<script type="text/javascript">
	var sqlData = "&LanguageID=${languageID}&category=LN";
	var viewType = "";
	
	$(document).ready(function() {
		//초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 220)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 220)+"px;");
		};
	});
	
	function setWindowHeight(){
		var size = window.innerHeight;
		var height = 0;
		if( size == null || size == undefined){
			height = document.body.clientHeight;
		}else{
			height=window.innerHeight;
		}return height;
	}
		
	function fnAddArcMenu(){
		editForm.clear("value");
		
		viewType = "N";
	    editForm.getItem("objTypeCode").setOptions(fnSelectJson("", "itemTypeCode","","Select"));
	    editForm.getItem("classCode").setOptions(fnSelectJson(sqlData,"classCode","","Select"));
	    editForm.getItem("dicCode").setOptions(fnSelectJson(sqlData, "getDictionary","","Select"));
	    	    
	    editWindow.show();
	    editWindow.attach(editForm);
	}
	
	function fnDeleteArcMenu(seq){
		if(confirm("${CM00004}")){
			var url = "admin/deleteArcMenu.do";
			var data = "&languageID=${languageID}&arcCode=${arcCode}&seq="+seq;
			var target = "ArcFrame";
			ajaxPage(url, data, target);	
		}
	}
	
	function fnOpenMenuListPop(){
		$("#menuId").blur();
		var url = "menuListPop.do?languageID=${languageID}";
		var w = 700;
		var h = 550;
		itmInfoPopup(url,w,h);
	}
	
	function fnSetMenu(menuId, menuName){
		editForm.getItem("menuId").setValue(menuId);
	}
	
	function fnReload(){
		var itemTypeCode = $("#itemTypeCode").val();
		var classCode = $("#searchValue").val();
		var url = "arcMenu.do"
		var data = "&languageID=${languageID}&ArcCode=${arcCode}&itemTypeCode="+itemTypeCode+"&classCode="+classCode;
		var target = "arcFrame";
		ajaxPage(url, data, target);
	}
</script>
</head>
<body>
	<form name="SubAttrTypeList" id="SubAttrTypeList" action="*" method="post" onsubmit="return false;">
	<input type="hidden" id="seq" name="seq" >
	<input type="hidden" id="viewType" name="viewType" value="">
	<input type="hidden" id="arcCode" name="arcCode" value="${arcCode }">
	<input type="hidden" id="languageID" name="languageID" value="${languageID }">
	<div class="child_search01 mgL10 mgR10">
		<li class="floatR pdR10">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<span class="btn_pack medium icon"><span class="add"></span><input value="Add" type="submit" onclick="fnAddArcMenu()"></span>
			</c:if>
		</li>		
	</div>
	<div style="width: 100%" id="layout"></div>
	<div id="pagination"></div>
	</form>	
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="ArcFrame" id="ArcFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>	
	<script>
	
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var gridData = ${gridData};
		
	var grid = new dhx.Grid("grid", {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" }], align: "center", editable: false },
	        { width: 150, id: "ItemTypeName", header: [{ text: "Object Name" }, { content: "selectFilter" }] },
	        { width: 150, id: "ClassName", header: [{ text: "Class Name" }, { content: "selectFilter" }] },
	        { width: 150, id: "MenuID", header: [{ text: "Menu ID" }, { content: "inputFilter" }] },
	        { width: 150, id: "Alias", header: [{ text: "Alias" }, { content: "inputFilter" }] },
	        { width: 150, id: "Sort", header: [{ text: "Sort" }, { content: "inputFilter" }] },
	        { width: 150, id: "VarFilter", header: [{ text: "Var Filter" }, { content: "inputFilter" }] },
	        { width: 150, id: "HideOption", header: [{ text: "Hide Option" }, { content: "selectFilter" }] },
	        {
	            id: "action", width: 150, header: [{ text: "Actions", align: "center" }],
	            htmlEnable: true, align: "center",
	            template: function () {
	                return "<span class='action-buttons'><a class='edit-button'><i class='mdi mdi-pencil'></i></a><a class='remove-button'><i class='mdi mdi-delete'></i></a></span>"
	            }
	        }
	    ],
	    eventHandlers: {
	        onclick: {
	            "remove-button": function (e, data) {
					grid.data.remove(data.row.id);
	                fnDeleteArcMenu(data.row.Seq)
	            },
	            "edit-button": function (e, data) {
	                openEditor(data.row.id);
	            }
	        }
	    },
	    resizable: true,
	    data: gridData
	});
	
	layout.getCell("a").attach(grid);
	
	function openEditor(id) {
	    viewType = "E";
	    
	    var item = grid.data.getItem(id);
	    
	    editForm.getItem("objTypeCode").setOptions(fnSelectJson("", "itemTypeCode"));
	    editForm.getItem("classCode").setOptions(fnSelectJson(sqlData,"classCode"));
	    editForm.getItem("dicCode").setOptions(fnSelectJson(sqlData, "getDictionary"));
	    
	    if (item) {
	    	var hideOption = false;
	    	if(item.HideOption == "Y") hideOption = true;
	    	var editFormData = {
	    			"Seq" : item.Seq,
	    			"objTypeCode" : item.ItemTypeCode,
	    			"menuId" : item.MenuID,
	    			"sort" : item.Sort,
	    			"classCode" : item.ClassCode,
	    			"dicCode" : item.DicCode,
	    			"hideOption" : hideOption,
	    			"varFilter" : item.VarFilter
	    		};
	    	if(editFormData.HideOption == "Y") editFormData.HideOption = true;
	    	else editFormData.HideOption = false;
			
	        editForm.setValue(editFormData);
	    }
	    
	    editWindow.show();
	    editWindow.attach(editForm);
	}
		
	var editWindow = new dhx.Window({
		title: "Edit Menu Allocation",
	    width: 700,
	    height: 450,
	    modal: true,
	    movable: true
	})
	
     var editForm = new dhx.Form(null, {
         padding: 0,
 		 rows: [
 			 {
 				 cols : [
 					 {
 						 width : "50%",
 						 rows : [
 							 {
 								id: "objTypeCode",
 				                type: "select",
 				                name: "objTypeCode",
 				                label: "Object Name",
 				                options : [{value : "",content : ""}]
 				            },
 				            {
 				                id:"menuId",
 				                type: "input",
 				                name: "menuId",
 				                label: "Menu ID"
 				            },
 				            {
 				                type: "input",
 				                name: "sort",
 				                label: "Sort"
 				            },
 			            ]
 					 }, 					
 					 {
 						width : "50%",
 						 rows : [
 							 {
 								id: "classCode",
 				                type: "select",
 				                name: "classCode",
 				                label: "Class Name",
 				                options : [{value : "",content : ""}]
 				            },
 				            {
 				            	id: "dicCode",
 				                type: "select",
 				                name: "dicCode",
 				                label: "Alias",
 				                options : [{value : "",content : ""}]
 				            },
 				            {
 				                type: "checkbox",
 				                name: "hideOption",
 				                label: "Hide Option"
 				            },
 			            ]
 					 }
 				 ]
 			 },
            {
                type: "input",
                name: "varFilter",
                label: "Var Filter",
            },
            {
                type: "input",
                name: "Seq",
                label: "Seq",
                hidden: true
            },
 			 {
                 align: "end",
                 cols: [
                     {
                         id: "save-button",
                         type: "button",
                         text: "Save",              
                         icon: "mdi mdi-check",
                         circle: true,
                         submit: true,
                     }
                 ]
             }            
 		 ]
     });
     
	// 7.3 적용 부분
     editForm.getItem("menuId").events.on("focus", function () {
    	 fnOpenMenuListPop();
 	});
     
     editForm.getItem("objTypeCode").events.on("change", function(value) {
    	 editForm.getItem("classCode").setOptions(fnSelectJson(sqlData+"&itemTypeCode="+value,"classCode"));
    });
     
     editForm.getItem("save-button").events.on("click", function (value) {
 		if(editForm.validate(false, value)){
 			var newData = editForm.getValue();
 			var hideOption = "N";
			if(newData.hideOption) hideOption = "Y";
 			var url = "admin/saveArcMenu.do";
 			var data = "&languageID=${languageID}"
 							+"&arcCode=${arcCode}"
 							+"&viewType="+viewType
 							+"&seq="+newData.Seq
 							+"&menuId="+newData.menuId
 							+"&classCode="+newData.classCode
 							+"&sortNum="+newData.sort
 							+"&dicCode="+newData.dicCode
 							+"&varFilter="+encodeURIComponent(newData.varFilter)
 							+"&hideOption="+hideOption;

 			var target = "ArcFrame";
 			ajaxPage(url, data, target);
 		}
 	});
     
	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});
	
	function fnCallBack(newGridData){
		editWindow.hide();
		editForm.clear("value");
		grid.data.parse(newGridData);
	}
	</script>
</body>
</html>