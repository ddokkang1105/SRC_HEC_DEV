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
	color: rgba(0, 0, 0, 0.9);
}
.dhx_grid-cell .edit-button {
	padding: 0 25px;
    color: #fff;
}
</style>
<!-- 2. Script -->
<script type="text/javascript">
	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정
		$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 80)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 80)+"px;");
		};
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
			
	function fnSaveGridData(data){
		if(data){
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
	}
</script>
<body>
	<form name="procLogList" id="procLogList" action="" method="post" onsubmit="return false;">
		<input type="hidden" id="editedRow" name="editedRow" value=""></input> 
	    <div class="title-section">
			Process Log
			<span class="floatR btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDel()"></span>
			<span class="floatR btn_pack small icon mgR10"><span class="save"></span><input value="Save All" type="submit" onclick="fnSaveAll()"></span>
			<span class="floatR btn_pack small icon mgR10"><span class="add"></span><input value="Add" type="submit" onclick="fnAddRow()"></span>
		</div>
		<div style="width: 100%;" id="grdOTGridArea"></div>
	</form>
	<iframe name="saveDFrame" id="saveDFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
<script>	
	var activityCodes = ${activityCodes};
	var activityNames = ${activityNames};
	var grid = new dhx.Grid("grdOTGridArea", {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" }], align: "center", editable: false },
	        { width: 100, id: "PLOGCFGID", header: [{ text: "${menu.LN00106}" }, { content: "inputFilter" }] , editable: false},
	        { width: 300, id: "FunctionNM", header: [{ text: "Function Name" }, { content: "inputFilter" }] },
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
	                return "<span class='action-buttons'><a class='edit-button'>save</a></span>"
	            }
	        },
	        { width: 130, id: "ActivityCD", header: [{ text: "Activity Code" }] }
	    ],
	    eventHandlers: {
	        onclick: {
	            "edit-button": function (e, data) {
	            	fnSaveGridData(data.row);
	            }
	        }
	    },
	    autoWidth: true,
	    resizable: true,
	    selection: "complex",
	    tooltip: false,
	    editable: true,
	    data: "",
// 	    multiselection: true
	});
	
	grid.hideColumn("ActivityCD");

	function addRowInit() {
		for(var i = 1; i <= 5; i++) {
			grid.data.add({id: "temp"+i, "RNUM":i, "PLOGCFGID": "","FunctionNM": "", "FunctionNM": "", "PIDParameter": "", "ActionParameter": "", "EventParameter": "", "EventValue": "", "ActivityCDName": "", "CommentParameter":"", "ActivityCD": ""});
		}
	
	    grid.data.sort({
	        by: "id",
	        dir: "desc"
	    })
	}

	addRowInit();
	
	grid.events.on("AfterEditEnd", function(value,row,column){
	    if(column.id == "ActivityCDName") {
	    	var activityCD = activityCodes[activityCodes.findIndex(function(obj){
		        return obj.NAME == value
		    })].CODE;
			grid.data.update(row.id, { ActivityCD: activityCD })
	    }
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
	
	function fnDel() {
		var selectedCell = grid.selection.getCell();
		if (confirm("${CM00004}")) {
			grid.data.remove(selectedCell.row.id);
			editedRow.splice(editedRow.findIndex(function (obj) {
				return obj.id == selectedCell.row.id;
			}), 1);
		}
	}
	
	function fnCallBack(){
		var url = "defineProcLogCfg.do";
		var data = "";
		var target = "procLogList";
		ajaxPage(url, data, target);
	}
	
	var max = 5;
	function fnAddRow() {
		max = max + 1;
		grid.data.add({id: "temp"+max, "RNUM":max, "PLOGCFGID": "","FunctionNM": "", "FunctionNM": "", "PIDParameter": "", "ActionParameter": "", "EventParameter": "", "EventValue": "", "ActivityCDName": "", "CommentParameter":"", "ActivityCD": ""});
	    grid.editCell(max, "FunctionNM");
	    
	    grid.data.sort({
	        by: "id",
	        dir: "desc"
	    })
	}
	
</script>
</html>