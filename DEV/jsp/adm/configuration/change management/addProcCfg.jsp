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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="SR Type"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="Function Name"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="PID Parameter"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_4" arguments="Action Parameter"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="Spe Code"/>
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
		if(data) {
			var PRCCFGID = data.PRCCFGID;
			var srType = data.SRType;
			var functionNM = data.FunctionNM;
			var pIDParameter = data.PIDParameter;
			var actionParameter = data.ActionParameter;
			var eventParameter = data.EventParameter;
			var eventValue = data.EventValue;
			var speName = data.SpeName;
			var speCode = data.SpeCode;
			var procPathID = data.ProcPathID;

			if (srType == "") {
				alert("${WM00034_1}");
				grid.selection.setCell(data, grid.config.columns[2]);
				grid.editCell(data.id, grid.config.columns[2].id);
				return false;
			}
			if (functionNM == "") {
				alert("${WM00034_2}");
				grid.selection.setCell(data, grid.config.columns[3]);
				grid.editCell(data.id, grid.config.columns[3].id);
				return false;
			}
			if (pIDParameter == "") {
				alert("${WM00034_3}");
				grid.selection.setCell(data, grid.config.columns[4]);
				grid.editCell(data.id, grid.config.columns[4].id);
				return false;
			}
			if (actionParameter == "") {
				alert("${WM00034_4}");
				grid.selection.setCell(data, grid.config.columns[5]);
				grid.editCell(data.id, grid.config.columns[5].id);
				return false;
			}
			if (speName == "") {
				alert("${WM00025}");
				grid.selection.setCell(data, grid.config.columns[8]);
				grid.editCell(data.id, grid.config.columns[8].id, "select");
				return false;
			}
			
			var url = "saveProcCfg.do";
			var data = "PRCCFGID=" + PRCCFGID
							+"&srType="+srType
							+"&functionNM="+functionNM
							+"&pIDParameter="+pIDParameter
							+"&actionParameter="+actionParameter
							+"&eventParameter="+eventParameter
							+"&eventValue="+eventValue
							+"&speCode="+speCode
							+"&procPathID="+procPathID;
			var target = "saveDFrame";
			ajaxPage(url, data, target);
		}
	}
</script>
<body>
	<form name="procLogList" id="procLogList" action="" method="post" onsubmit="return false;">
		<input type="hidden" id="editedRow" name="editedRow" value=""></input> 
	    <div class="title-section">
			Process Config
			<li class="floatR">
			<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnDel()" value="Del">Delete</button>
			<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnSaveAll()" value="Save All">Save All</button>
			<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnAddRow()" value="Add">Add Process Config</button>
			</li>
		</div>
		<div style="width: 100%; height: 500px;" id="grdOTGridArea"></div>
	</form>
	<iframe name="saveDFrame" id="saveDFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
<script>
	var speList = ${speList};
	var speNames = ${speNames};
	var grid = new dhx.Grid("grdOTGridArea", {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" }], align: "center", editable: false },
	        { width: 100, id: "PRCCFGID", header: [{ text: "${menu.LN00106}" }, { content: "inputFilter" }] , editable: false},
	        { width: 100, id: "SRType", header: [{ text: "SR Type" }, { content: "inputFilter" }] },
	        { id: "FunctionNM", header: [{ text: "Function Name" }, { content: "inputFilter" }] },
	        { width: 130, id: "PIDParameter", header: [{ text: "PIDParameter" }, { content: "inputFilter" }] },
	        { width: 130, id: "ActionParameter", header: [{ text: "Action Parameter" }, { content: "inputFilter" }] },
	        { width: 130, id: "EventParameter", header: [{ text: "Event Parameter" }, { content: "inputFilter" }] },
	        { width: 130, id: "EventValue", header: [{ text: "Event Value" }, { content: "inputFilter" }] },
	        { width: 130, id: "SpeName", header: [{ text: "Spe Code" }, { content: "selectFilter" }], editorType: "select", options: speNames},
	        { width: 150, id: "SpeCode", header: [{ text: "SpeCode" }]},
	        {
	            id: "action", width: 150, header: [{ text: "Actions", align: "center" }],
	            htmlEnable: true, align: "center",
	            template: function () {
	                return "<span class='action-buttons'><a class='edit-button'>save</a></span>"
	            }
	        }
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
	});
	
	grid.hideColumn("SpeCode");
	
	function addRowInit() {
		for(var i = 1; i <= 5; i++) {
			grid.data.add({id: "temp"+i, "RNUM":i, "PRCCFGID": "","SRType": "", "FunctionNM": "", "PIDParameter": "", "ActionParameter": "", "EventParameter": "", "EventValue": "", "SpeName": "", "speCode":""});
		}
	
	    grid.data.sort({
	        by: "id",
	        dir: "desc"
	    })
	}
	
	addRowInit();
	
	grid.events.on("AfterEditEnd", function(value,row,column){
	    if(column.id == "SpeName") {
	    	var speCode = speList[speList.findIndex(function(obj){
		        return obj.NAME == value
		    })].CODE;
			grid.data.update(row.id, { SpeCode: speCode })
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
				if (editedRow[i].SRType == "") {
					  alert("${WM00034_1}");
					  grid.selection.setCell(grid.data.getItem(editedRow[i].id), grid.config.columns[2]);
					  grid.editCell(editedRow[i].id, grid.config.columns[2].id);				  
					  return false;
				  }
				  if (editedRow[i].FunctionNM == "") {
					  alert("${WM00034_2}");
					  grid.selection.setCell(grid.data.getItem(editedRow[i].id), grid.config.columns[3]);
					  grid.editCell(editedRow[i].id, grid.config.columns[3].id);
					  return false;
				  }
				  if (editedRow[i].PIDParameter == "") {
					  alert("${WM00034_3}");
					  grid.selection.setCell(grid.data.getItem(editedRow[i].id), grid.config.columns[4]);
					  grid.editCell(editedRow[i].id, grid.config.columns[4].id);
					  return false;
				  }
				  if (editedRow[i].ActionParameter == "") {
					  alert("${WM00034_4}");
					  grid.selection.setCell(grid.data.getItem(editedRow[i].id), grid.config.columns[5]);
					  grid.editCell(editedRow[i].id, grid.config.columns[5].id);
					  return false;
				  }
				  if (editedRow[i].SpeName == "") {
					  alert("${WM00025}");
					  grid.selection.setCell(grid.data.getItem(editedRow[i].id), grid.config.columns[8]);
					  grid.editCell(editedRow[i].id, grid.config.columns[8].id, "select");
					  return false;
				  }
			}
			
			if(confirm("${CM00001}")){
				var jsonData = JSON.stringify(editedRow);
				
				$.ajax({
			        type: "POST",
			        data: {"editedRow" : jsonData},
			        url: "saveAllProcCfg.do",
			        async: false,
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
		var url = "defineProcCfg.do";
		var data = "";
		var target = "procLogList";
		ajaxPage(url, data, target);
	}
	
	var max = 5;
	function fnAddRow() {
		max = max + 1;
		grid.data.add({id: "temp"+max, "RNUM":max, "PRCCFGID": "","SRType": "", "FunctionNM": "", "PIDParameter": "", "ActionParameter": "", "EventParameter": "", "EventValue": "", "SpeName": "", "speCode":""});
	    grid.editCell(max, "SRType");
	    
	    grid.data.sort({
	        by: "id",
	        dir: "desc"
	    })
	}
</script>
</html>