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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="Role Category"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="RoleTypeCode"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="RoleType"/>

<style>
.dhx_grid-cell {
	color: rgba(0, 0, 0, 0.95);
}
.dhx_dataview {
    background-color: transparent;
}
.dhx_dataview-item {
    background-color: #fff;
    overflow: hidden;
    padding : 0;
}
.item_wrap {
	padding: 8px;
}
.dhx_grid-cell .edit-button, .dhx_grid-cell .save-button {
	padding: 0 25px;
}
.dhx_grid-cell .edit-button {
    border: 1px solid #0288d1;
    background:none;
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
		// 초기 표시 화면 크기 조정
		$("#roleTPview").css("height",setWindowHeight() - 130 + "px");
		$("#layout").css("height",setWindowHeight() - 120 + "px");
		// 화면 크기 조정
		window.onresize = function() {
			$("#roleTPview").css("height",setWindowHeight() - 130 + "px");
			$("#layout").css("height",setWindowHeight() - 120 + "px");
		};
	
	   	var icon = document.getElementsByClassName("hidden");
	   	for(var i=0; i < icon.length; i++) {
	   		icon[i].style.display = "none";
	    }
	   	document.querySelector(".addBtn").style.display = "block";
	   	
	   	document.getElementById("dataViewWrap").style.display = "block";
		document.getElementById("gridWrap").style.display = "none";
		
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function fnBack() {
		var icon = document.getElementsByClassName("hidden");
    	for(var i=0; i < icon.length; i++) {
    		icon[i].style.display = "none";
        }
    	document.querySelector(".addBtn").style.display = "block";
		document.getElementById("dataViewWrap").style.display = "block";
		document.getElementById("gridWrap").style.display = "none";
		document.getElementById("title").innerText = "Role Category";
		document.querySelector(".back").style.display = "none";
	}
</script>
<body>
   <div class="title-section flex align-center justify-between">
   		<span class="flex">
   			<span class="back" style="display: none;"><span class="icon arrow"></span></span>
   			<span id="title">Role Category</span>
 	
 	 </span>
 	  <span class="flex floatR">
			<button class="cmm-btn mgR10 addBtn" style="height: 30px;" onclick="addRoleCategory()" value="Add">Add Category</button>
			<button class="cmm-btn mgR5 hidden" style="height: 30px;" onclick="delRoleType()" value="Delete">Delete</button>
			<button class="cmm-btn mgR10 hidden" style="height: 30px;" onclick="addRoleType()" value="Add">Add</button>
		</span>
	</div>
	<div name="" id="dataViewWrap" action="" method="post" onsubmit="return false;">
		<div id="roleTPview" style="padding: 5px;background: #f7f7f7;"></div>
		<div id="pagination1"></div>
	</div>
	<div id="gridWrap">
		<div style="width: 100%;" id="layout"></div>
		<div id="pagination2"></div>
	</div>
	<iframe name="saveDFrame" id="saveDFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
<script>
	var back = document.getElementsByClassName("back");
	back[0].addEventListener("click", fnBack);

	var dataset = '${roleCat}';
	var gridData = ${gridData};
	var roleCode = "";
	var roleName = "";
	var grid = "";
	
	var gridConfig = {
		    columns: [
//	 	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" }], align: "center" },
		        { width: 50, id: "checkbox", header: [{ text: "" }], align: "center", type: "boolean", editable:true},
		        { width: 100, id: "ActorType", header: [{ text: "Actor Type" }, { content: "selectFilter" }]},
		        { id: "RoleCategory", header: [{ text: "Category" }, { content: "selectFilter" }] },
		        { width: 130, id: "RoleType", header: [{ text: "Name" }, { content: "inputFilter" }] },
		        { width: 130, id: "RoleTypeCode", header: [{ text: "Code" }, { content: "inputFilter" }] },
		        { width: 130, id: "ProcessType", header: [{ text: "Process Type" }, { content: "selectFilter" }] },
		        { width: 130, id: "CreationTime", header: [{ text: "${menu.LN00013}" }, { content: "inputFilter" }] },
		        { width: 130, id: "LastUpdated", header: [{ text: "${menu.LN00070}" }, { content: "inputFilter" }]},
		        { width: 100, id: "LastUserName", header: [{ text: "${menu.LN00105}" }, { content: "inputFilter" }] },
		        { width: 100, id: "LanguageCode", header: [{ text: "Language" }, { content: "selectFilter" }] },
		        { width: 100, id: "Deactivated", header: [{ text: "Deactivated" }],
		        	htmlEnable: true,
		        	template: function (text, row, col) {
		        		return "<input class=\"custom_div\" type=\"checkbox\" disabled " + (text == "1" ? "checked" : "") + " ></div>";
		        	},
		        	align: "center"
		        
		        },
		        {
		            id: "action", width: 150, header: [{ text: "Actions", align: "center" }],
		            htmlEnable: true, align: "center",
		            template: function(text, row, col) {
		            	return "<span class='action-buttons'><a class='edit-button'>edit</a></span>";
		            }
		        },
		    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    eventHandlers: {
		        onclick: {
		            "edit-button": function (e, data) {
		            	editRoleType(data.row);
		            }
		        }
		    },
		};
	
	
	
	function template(item) {
		var description = item.Description? item.Description : "-";
		let template = "<div class='item_wrap'>";
		template += "<div style='display:flex;align-items: center;justify-content: space-between;'><h3 style='margin: 4px 0'>" + item.NAME + "</h3>";
		template += '<img src="${root}${HTML_IMG_DIR}/btn_forum_del.png" onclick="delRoleCategory(event,\''+item.CODE+'\'); "></div>';
		template += "<p style='margin: 4px 0'>" + item.CODE + "</p>";
		template += "<p style='margin: 4px 0'>" + description  + "</p>";
		template += "</div>";
		return template;
	}	
	
	var dataview = new dhx.DataView("roleTPview", {
		itemsInRow: 4,
		gap: 15,
		template: template,
		data: dataset,
		eventHandlers: {
	        onclick: {
	            item_wrap: function(e, id) {	            	
	            	var icon = document.getElementsByClassName("hidden");
	            	for(var i=0; i < icon.length; i++) {
	            		icon[i].style.display = "block";
	                }
	            	document.querySelector(".addBtn").style.display = "none";
	            	document.getElementById("dataViewWrap").style.display = "none";
	        		document.getElementById("gridWrap").style.display = "block";
	        		document.querySelector(".back").style.display = "block";
					
	        		roleCode = dataview.data.getItem(id).CODE;
	        		roleName = dataview.data.getItem(id).NAME;
	        		
	            	document.getElementById("title").innerText = "Role Category - "+roleName;
	        		if (grid) {
	        	        grid.destructor();
	        	        layout.destructor();
	        	    }
	        		grid = new dhx.Grid("roleTypeList", gridConfig);
	        		grid.data.parse(gridFilterData(gridData, roleCode));
	        		layout = new dhx.Layout("layout", {
	    			    rows: [
	    			        {
	    			            id: "a",
	    			        },
	    			    ]
	    			});
	        		layout.getCell("a").attach(grid);
	        		
	        		var pagination2 = new dhx.Pagination("pagination2", {
	        		    data: grid.data,
	        		    pageSize: 20,
	        		});
	        		
	            }
	        }
	    }
	});
		
	var pagination1 = new dhx.Pagination("pagination1", {
	    data: dataview.data,
	    pageSize: 20,
	});
		

	function gridFilterData(list, category) {
		var result 	= new Array();
		var json = new Object();
		
		for(idx in list){
			if(list[idx].AssignmentType == category) {
				var json = new Object();
			    json.ActorType = list[idx].ActorType;
				json.RoleCategory = list[idx].RoleCategory;
				json.RoleType = list[idx].RoleType;
				json.RoleTypeCode = list[idx].RoleTypeCode;
				json.ProcessType = list[idx].ProcessType;
				json.CreationTime = list[idx].CreationTime;
				json.LastUpdated = list[idx].LastUpdated;
				json.LastUserName = list[idx].LastUserName;
				json.LanguageCode = list[idx].LanguageCode;
				json.Deactivated = list[idx].Deactivated;
				json.AssignmentType = list[idx].AssignmentType;
				
				json = JSON.stringify(json);
				result.push(JSON.parse(json));
			}
		};
		return result;
	}

	function addRoleCategory(){
		addCategory.show();
		addCategory.attach(addCategoryForm);
	}
	
	function delRoleCategory(e,code) {
		e.stopPropagation();
		if(confirm("${CM00004}")){
			var url = "deleteRoleType.do";
			var roleTypeCode = new Array;
			var data = "&roleTypeCode="+code+"&roleCategory=ROLECAT&languageID=${languageID}";
			var target = "saveDFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function addRoleType(){
		var data = {
			"AssignmentType" : roleCode,
			"RoleCategory" : roleName
			
		};
		addTypeForm.setValue(data);
		addType.show();
		addType.attach(addTypeForm);
	}
	
	function editRoleType(data) {
		var editTypeFormData = {
			"ActorType" : data.ActorType,
			"RoleCategory" : data.RoleCategory,
			"RoleType" : data.RoleType,
			"ProcessType" : data.ProcessType,
			"Deactivated" : data.Deactivated,
			"RoleTypeCode" : data.RoleTypeCode,
			"AssignmentType" : data.AssignmentType
		};
		if(editTypeFormData.Deactivated == "1") editTypeFormData.Deactivated = true;
		else editTypeFormData.Deactivated = false;
		editTypeForm.setValue(editTypeFormData);
		
		editType.show();
		editType.attach(editTypeForm);
	}
	
	var addCategory = new dhx.Window({
		title: "Add Role Category",
	    width: 600,
	    height: 400,
	    modal: true,
	    movable: true
	});
	
	var addCategoryForm = new dhx.Form(null, {
        padding: 0,
		 rows: [
		 	{
                type: "input",
                name: "Name",
                label: "Name"
            },
            {
                type: "input",
                name: "Code",
                label: "Code",
                maxlength : 10
            },
            {
                type: "input",
                name: "Description",
                label: "Description"
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
	
	addCategoryForm.getItem("save-button").events.on("click", function (value) {
		if(addCategoryForm.validate(false, value)){
			var newData = addCategoryForm.getValue();
			var url = "saveRoleType.do";
			var data = "&languageID=${languageID}"
							+"&editRoleCategory=Y"
							+"&roleTypeCategory=ROLECAT"
							+"&roleTypeCode=" +newData.Code
							+"&roleType="+newData.Name
							+"&description="+newData.Description;
			var target = "saveDFrame";
			ajaxPage(url, data, target);
			
			addCategoryForm.clear();
		    addCategory.hide();
		}
	});

	var addType = new dhx.Window({
		title: "Add Role Type",
	    width: 600,
	    height: 450,
	    modal: true,
	    movable: true
	});

	var addTypeForm = new dhx.Form(null, {
        padding: 0,
		 rows: [
			 {
				 cols : [
					 {
						 rows : [
							 {
				                type: "input",
				                name: "ActorType",
				                label: "Actor Type",
				                maxlength : 10
				            },
				            {
				                type: "input",
				                name: "RoleType",
				                label: "Name"
				            },
				            {
				                type: "input",
				                name: "ProcessType",
				                label: "Process Type",
				                maxlength : 10
				            },
				            {
				                type: "input",
				                name: "AssignmentType",
				                label: "RoleCategory",
				                hidden: true
				            },
			            ]
					 },
					 {
						 rows : [
							 {
				                type: "input",
				                name: "RoleCategory",
				                label: "Category",
				                disabled: true
				            },
				            {
				                type: "input",
				                name: "RoleTypeCode",
				                label: "Code",
				                maxlength : 10
				            },
				            {
				                type: "checkbox",
				                name: "Deactivated",
				                label: "Deactivated"
				            },
				            {
				                type: "input",
				                name: "viewType",
				                label: "viewType",
				                value:"N",
				                hidden: true
				            },
			            ]
					 }
				 ]
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
	
	var editType = new dhx.Window({
		title: "Edit Role Type",
	    width: 600,
	    height: 550,
	    modal: true,
	    movable: true
	});

	var editTypeForm = new dhx.Form(null, {
        padding: 0,
		 rows: [
		 	{
                type: "input",
                name: "ActorType",
                label: "Actor Type",
                disabled: true
            },
            {
                type: "input",
                name: "RoleCategory",
                label: "Category",
                disabled: true
                
            },
            {
                type: "input",
                name: "RoleType",
                label: "Name"
            },
            {
                type: "input",
                name: "ProcessType",
                label: "Process Type"
            },
            {
                type: "checkbox",
                name: "Deactivated",
                label: "Deactivated"
            },
            {
                type: "input",
                name: "RoleTypeCode",
                label: "RoleTypeCode",
                hidden: true
            },
            {
                type: "input",
                name: "AssignmentType",
                label: "AssignmentType",
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
	 		
	addTypeForm.getItem("save-button").events.on("click", function (value) {
		sendForm(addTypeForm, value);
		addTypeForm.clear();
		addType.hide();
	});
	
	editTypeForm.getItem("save-button").events.on("click", function (value) {
		sendForm(editTypeForm, value);
		editTypeForm.clear();
	    editType.hide();
	});
	
	function sendForm(sendform, value){
		if(sendform.validate(false, value)){
			var newData = sendform.getValue();
			var deactivated = 0;
			if(newData.Deactivated) deactivated = 1;
			var url = "saveRoleType.do";
			var data = "&languageID=${languageID}"
							+"&viewType=" +newData.viewType
							+"&actorType=" +newData.ActorType
							+"&roleType="+newData.RoleType
							+"&processType="+newData.ProcessType
							+"&deactivated="+deactivated
							+"&roleTypeCode="+newData.RoleTypeCode
							+"&roleTypeCategory="+newData.AssignmentType;
			var target = "saveDFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function delRoleType(){
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00023}");	
		} else {
			if(confirm("${CM00004}")){
				var url = "deleteRoleType.do";
				var roleTypeCode = new Array;
				var roleCategory = new Array;
				for(idx in selectedCell){
					grid.data.remove(selectedCell[idx].id);
					roleTypeCode[idx]= selectedCell[idx].RoleTypeCode;
					roleCategory[idx]= selectedCell[idx].AssignmentType;
				};
				var data = "&roleTypeCode="+roleTypeCode+"&roleCategory="+roleCategory+"&languageID=${languageID}";
				var target = "saveDFrame";
				ajaxPage(url, data, target);
			}
		}
	}
	
	function fnCallBack(returnData, category){
		if(category) {	//reload grid
			if (grid) {
    	        grid.destructor();
    	        layout.destructor();
    	    }
			layout = new dhx.Layout("layout", {
			    rows: [
			        {
			            id: "a",
			        },
			    ]
			});
			gridData = returnData;
    		grid = new dhx.Grid("layout", gridConfig);
    		grid.data.parse(gridFilterData(gridData, category));
    		layout.getCell("a").attach(grid);
    		
    		var pagination2 = new dhx.Pagination("pagination2", {
    		    data: grid.data,
    		    pageSize: 20,
    		});
		} else { //reload dataview
			dataview.data.parse(returnData);
		}
	}
</script>
</html>