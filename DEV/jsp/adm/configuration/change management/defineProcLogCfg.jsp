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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00068" var="WM00068" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="Function Name"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="PID Parameter"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="Action Parameter"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="Activity Code"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>

<style>
.dhx_grid-cell {
	color: rgba(0, 0, 0, 0.95);
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
		$("#layout").attr("style","height:"+(setWindowHeight() - 140)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 140)+"px;");
		};
	});	
	
	function ListToSelectOption(list){
		var options 	= new Array();
		
		var json = new Object();
		
		for(idx in list){
			var json = new Object();
		    json.value = list[idx].CODE;
			json.content = list[idx].NAME,
			
			json = JSON.stringify(json);
			options.push(JSON.parse(json));
		};
		return options;
	}
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
			
	function fnSaveGridData(data){
		var PLOGCFGID = data.PLOGCFGID;
		var functionNM = data.FunctionNM;
		var pIDParameter = data.PIDParameter;
		var actionParameter = data.ActionParameter;
		var eventParameter = data.EventParameter;
		var eventValue = data.EventValue;
		var activityCD = data.ActivityCD;
		var commentParameter = data.CommentParameter;
		
		if (functionNM == "") {
			alert("${WM00034_1}");
			grid.selection.setCell(data.id, grid.config.columns[2]);
			grid.editCell(data.id, grid.config.columns[2].id);
			return false;
		}
		
		if (pIDParameter == "") {
			alert("${WM00034_2}");
			grid.selection.setCell(data.id, grid.config.columns[3]);
			grid.editCell(data.id, grid.config.columns[3].id);
			return false;
		}
		
		if (actionParameter == "") {
			alert("${WM00034_3}");
			grid.selection.setCell(data.id, grid.config.columns[4]);
			grid.editCell(data.id, grid.config.columns[4].id);
			return false;
		}
		
		if (activityCD == "") {
			alert("${WM00025}");
			grid.selection.setCell(data.id, grid.config.columns[7]);
			grid.editCell(data.id, grid.config.columns[7].id, "select");
			return false;
		}
		
		var url = "saveProcLog.do";
		var data = "PLOGCFGID=" + PLOGCFGID
						+"&functionNM="+functionNM
						+"&pIDParameter="+pIDParameter
						+"&actionParameter="+actionParameter
						+"&eventParameter="+eventParameter
						+"&eventValue="+eventValue
						+"&activityCD="+activityCD
						+"&commentParameter="+commentParameter;
		var target = "saveDFrame";
		ajaxPage(url, data, target);
	}
	
	function fnDel(){
// 		var selectedCell = grid.selection.getCell();
// 		if(!selectedCell){
// 			alert("${WM00023}");	
// 		}else{
// 			if(confirm("${CM00004}")){
// 				grid.data.remove(selectedCell.row.id);
// 				var url = "delProcLog.do";
// 				var data = "pLogCfgID="+selectedCell.row.PLOGCFGID;
// 				var target = "saveDFrame";
// 				ajaxPage(url, data, target);		
// 			}
// 		}
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00023}");	
		} else {
			if(confirm("${CM00004}")){
				var url = "delProcLog.do";
				var pLogCfgIDs = "";
				for(idx in selectedCell){
					grid.data.remove(selectedCell[idx].id);
				    if (pLogCfgIDs == "") {
						pLogCfgIDs = selectedCell[idx].PLOGCFGID;
					} else {
						pLogCfgIDs += ","+selectedCell[idx].PLOGCFGID;
					}
				};
				var data = "pLogCfgIDs="+pLogCfgIDs;
				var target = "saveDFrame";
				ajaxPage(url, data, target);
			}
		}
	}
	

	var formConfig = {
	        padding: 0,
	        rows: [
	        	{
	        		 cols: [
	        			 {
	        				 rows: [
	        					 {
	        			                type: "input",
	        			                name: "FunctionNM",
	        			                label: "Function Name",
	        			                required: true
	        			            },
	        			            {
	        			                type: "input",
	        			                name: "ActionParameter",
	        			                label: "Action Parameter",
	        			                required: true
	        			                
	        			            },
	        			            {
	        			                type: "input",
	        			                name: "EventValue",
	        			                label: "Event Value"
	        			            },
	        			            {
	        			                type: "input",
	        			                name: "CommentParameter",
	        			                label: "Comment Parameter"
	        			            },
	        				 ]
	        			 },
	        			 {
	        				 rows: [
	        			            {
	        			                type: "input",
	        			                name: "PIDParameter",
	        			                label: "PIDParameter",
	        			                required: true,
	        			            },

	        			            {
	        			                type: "input",
	        			                name: "EventParameter",
	        			                label: "Event Parameter"
	        			            },
	        			            {
	        			                type: "input",
	        			                name: "ActivityCD",
	        			                label: "Activity Code",
	        			                type: "select",
	        			                options: ListToSelectOption(${activityCodes}),
	        			                required: true
	        			            },
	        			            {
	        			                type: "input",
	        			                name: "PLOGCFGID",
	        			                label: "PLOGCFGID",
	        			                hidden: true
	        			            }
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
	    }
	
	var form;
	function fnLoadAddPage(data) {
// 		var url = "addProcLogCfg.do";
// 		var data = "";
// 		var target = "procLogList";
// 		ajaxPage(url, data, target);
			form = new dhx.Form(null, formConfig);
		
		if(data) {
			editWindow.show();
			editWindow.attach(form);
			form.setValue(data);
		} else {
			addWindow.show();
			addWindow.attach(form);
		}
		

		form.getItem("save-button").events.on("click", function (value) {
			if(form.validate(false, value)){
				var newData = form.getValue();
				var url = "saveProcLog.do";
				var data = "PLOGCFGID=" +newData.PLOGCFGID
								+"&functionNM="+newData.FunctionNM
								+"&pIDParameter="+newData.PIDParameter
								+"&actionParameter="+newData.ActionParameter
								+"&eventParameter="+newData.EventParameter
								+"&eventValue="+newData.EventValue
								+"&activityCD="+newData.ActivityCD
								+"&commentParameter="+newData.CommentParameter;
				var target = "saveDFrame";
				ajaxPage(url, data, target);
			    closeEditor();
			}
		});
	}
	
	var addWindow = new dhx.Window({
		title: "Add Process Log",
	    width: 600,
	    height: 450,
	    modal: true,
	    movable: true
	});
	
	var editWindow = new dhx.Window({
		title: "Edit Process Log",
	    width: 600,
	    height: 450,
	    modal: true,
	    movable: true
	});
		
	function closeEditor() {
		form.clear();
		addWindow.hide();
	    editWindow.hide();
	}
	
// 	function checkAll(){
// 	    var selectedCell = grid.data.findAll(function (data) {
// 	        grid.data.update(data.id, { checkbox: true });
// 	        return !data.checkbox;
// 	    });
// 	}
	
</script>
<body>
	<form name="procLogList" id="procLogList" action="" method="post" onsubmit="return false;">
		<div class="cfgtitle" >					
			<ul>
				<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Process Log</li>
			</ul>
		</div>
		<div class="child_search01 mgL10 mgR10">
			<li class="floatR pdR10">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
					<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnLoadAddPage()"  value="Add" >Add Process Log</button>
					<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnSaveAll()" value="Save All">Save All</button>
					<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnDel()"  value="Del">Delete</button>
				</c:if>
				</li>
		</div>
		<div style="width: 100%;" id="layout"></div>
		<div id="pagination"></div>
	</form>
	<iframe name="saveDFrame" id="saveDFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});

	var gridData = ${gridData};
	var activityCodes = ${activityCodes};
	var activityNames = ${activityNames};
	var grid = new dhx.Grid("grdOTGridArea", {
	    columns: [
// 	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" }], align: "center" },
	        { width: 50, id: "checkbox", header: [{ text: "" }], align: "center", type: "boolean",  editable: true},
	        { width: 100, id: "PLOGCFGID", header: [{ text: "${menu.LN00106}" }, { content: "inputFilter" }] },
	        { id: "FunctionNM", header: [{ text: "Function Name" }, { content: "inputFilter" }] },
	        { width: 130, id: "PIDParameter", header: [{ text: "PIDParameter" }, { content: "inputFilter" }] },
	        { width: 130, id: "ActionParameter", header: [{ text: "Action Parameter" }, { content: "inputFilter" }] },
	        { width: 130, id: "EventParameter", header: [{ text: "Event Parameter" }, { content: "inputFilter" }] },
	        { width: 130, id: "EventValue", header: [{ text: "Event Value" }, { content: "inputFilter" }] },
	        { width: 130, id: "ActivityCDName", header: [{ text: "Activity Code" }, { content: "selectFilter" }], editorType: "select", options: activityNames },
	        { width: 150, id: "CommentParameter", header: [{ text: "Comment Parameter" }, { content: "inputFilter" }] },
	        {
	            id: "action", width: 150, header: [{ text: "Actions", align: "center" }],
	            htmlEnable: true, align: "center",
	            template: function () {
	                return "<span class='action-buttons'><a class='edit-button'>edit</a></span>"
	            }
	        },
	        { width: 130, id: "ActivityCD", header: [{ text: "Activity Code" }] },
	    ],
	    eventHandlers: {
	        onclick: {
	            "edit-button": function (e, data) {
	            	fnLoadAddPage(data.row);
	            },
	            "save-button": function (e, data) {
	            	fnSaveGridData(data.row);
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
	grid.hideColumn("ActivityCD");
	
	grid.events.on("AfterEditEnd", function(value,row,column){
	    if(column.id == "ActivityCDName") {
	    	var activityCD = activityCodes[activityCodes.findIndex(function(obj){
		        return obj.NAME == value
		    })].CODE;
			grid.data.update(row.id, { ActivityCD: activityCD })
	    }
	});
	
	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 20,
	});

	var editedRow = [];
	var ids = new Array();
	grid.events.on("CellDblClick", function(row,column,e){
		if(!ids.includes(row.id)) {
			ids.push(row.id);
			editedRow.push(row);
		}
	});
	
	function fnSaveAll(){
		if (editedRow.length == 0 ){
			return false;
		} else {
			for (var i = 0; i < editedRow.length; i++) {
				  if (editedRow[i].FunctionNM == "") {
					  alert("${WM00034_1}");
					  grid.selection.setCell(editedRow[i].id, grid.config.columns[2]);
					  grid.editCell(editedRow[i].id, grid.config.columns[2].id);
					  return false;
				  }
				  if (editedRow[i].PIDParameter == "") {
					  alert("${WM00034_2}");
					  grid.selection.setCell(editedRow[i].id, grid.config.columns[3]);
					  grid.editCell(editedRow[i].id, grid.config.columns[3].id);
					  return false;
				  }
				  if (editedRow[i].ActionParameter == "") {
					  alert("${WM00034_3}");
					  grid.selection.setCell(grid.data.getItem(editedRow[i].id), grid.config.columns[4]);
					  grid.editCell(editedRow[i].id, grid.config.columns[4].id);
					  return false;
				  }
				  if (editedRow[i].ActivityCD == "") {
					  alert("${WM00025}");
					  grid.selection.setCell(grid.data.getItem(editedRow[i].id), grid.config.columns[7]);
					  grid.editCell(editedRow[i].id, grid.config.columns[7].id, "select");
					  return false;
				  }
			}
			
			if(confirm("${CM00001}")){
				var jsonData = JSON.stringify(editedRow);
				
				$.ajax({
			        type: "POST",
			        data: {"editedRow" : jsonData},
			        dataType: "json",
			        url: "saveAllProcLog.do",
			        async: false,
			        contentType: "application/x-www-form-urlencoded; charset=utf-8",
			        success: function(data) {
			        	editedRow = [];
			        	ids = [];
			        	alert("${WM00067}");
			        	fnCallBack(data);
			        }, error:function(request,status,error){
			        	alert("${WM00068}");
			        }
			    });
			}
		}
	}
	
	function fnCallBack(newGridData){
		grid.data.parse(newGridData);
	}
</script>
</html>