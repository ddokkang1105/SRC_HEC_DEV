<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagIncV7.jsp"%>
<style>
	.grid_edit {
		background: #aecdda;
	}
	.form_edit .dhx_input {
		background: #aecdda;
	}
</style>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

<script>
var grid;
var editedRow = [];
var gridData = ${taskListtData};
var taskAuthorData = ${taskAuthorData};

	$(document).ready(function(){	
		
		$("#grid_container").attr("style","height:"+(setWindowHeight() * 0.85 )+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grid_container").attr("style","height:"+(setWindowHeight() * 0.85)+"px;");
		};
		
		fnGridList(gridData);
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	function fnGridList(resultdata){
		
		grid = new dhx.Grid("grid_container", {
			columns: [
				{ id: "RNUM", header: [{ text: "No", rowspan: 2 }], editable:false },
		        { id: "TaskTypeName", header: [{ text: "Task", rowspan: 2 }], editable:false },
		        { id: "TeamNameP", header: [{ text: "Plan", colspan: 4 }, { text: "${menu.LN00153}" }], editable:false },
		        { id: "ActorNameP", header: ["", { text: "${menu.LN00004}" }], editorType: "select",
		        	options: [
		        		<c:forEach var="taskAuthordata" items="${taskAuthorList}">
		        		"${taskAuthordata.UserName}",
		        		</c:forEach>
		        		] },
		        { id: "StartDateP", header: ["", { text: "${menu.LN00061}" }], type: "date", dateFormat: "%Y-%m-%d" },
		        { id: "EndDateP", header: ["", { text: "${menu.LN00221}" }], type: "date", dateFormat: "%Y-%m-%d" },
		        { id: "MandayP", header: [{ text: "M/D", rowspan: 2 }] },

		        { id: "TeamNameA", header: [{ text: "Actual", colspan: 4 }, { text: "${menu.LN00153}" }], editable:false },
		        { id: "ActorNameA", header: ["", { text: "${menu.LN00004}" }], editorType: "select",
		        	options: [
		        		<c:forEach var="taskAuthordata" items="${taskAuthorList}">
		        		<%--<c:if test="${! empty item.MemberID}">--%>
		        			"${taskAuthordata.UserName}",
		        		<%--</c:if>--%>
		        		</c:forEach>
		        		] },
		        { id: "StartDateA", header: ["", { text: "${menu.LN00063}" }], type: "date", dateFormat: "%Y-%m-%d" },
		        { id: "EndDateA", header: ["", { text: "${menu.LN00064}" }], type: "date", dateFormat: "%Y-%m-%d" },
		        { id: "MandayA", header: [{ text: "M/D", rowspan: 2 }] },
		        
		        { id: "StartDateGap", header: [{ text: "Difference", colspan: 2 }, { text: "Start" }], editable:false },
		        { id: "EndDateGap", header: ["", { text: "End" }], editable:false },
		        {
		            id: 'AttachFileBtn', width: 80, header: [{ text: 'Down', align: 'center' }],
		            htmlEnable: true, align: 'center', sortable: false,
		            template: function(text, row, col) {
		            	return (row.FileRealName != "" ? "<img src=\"${root}${HTML_IMG_DIR}/btn_file_down.png\" style=\"cursor:pointer;width:13;height:13;\" alt=\"파일삭제\" onclick=\"fnFileDownLoad('"+row.FileID+"')\">" : "");
		            }
		        },
		        //{ width: 60, id: "AttachFileBtn", header: [{ text: "Down" }] ,htmlEnable: true, align:"center"},
		        
		        { hidden:true, width: 130, id: "TaskIDA", header: [{ text: "TaskIDA" }] },
		        { hidden:true, width: 130, id: "TaskIDP", header: [{ text: "TaskIDP" }] },
		        { hidden:true, width: 130, id: "SeqA", header: [{ text: "SeqA" }] },
		        { hidden:true, width: 130, id: "SeqP", header: [{ text: "SeqP" }] },
		        { hidden:true, width: 130, id: "ActorA", header: [{ text: "SeqP" }] },
		        { hidden:true, width: 130, id: "ActorP", header: [{ text: "SeqP" }] },
		        
		        { hidden:true, width: 130, id: "FileID", header: [{ text: "FileID" }] },
		        { hidden:true, width: 130, id: "SysFileName", header: [{ text: "SysFileName" }] },
		        { hidden:true, width: 130, id: "SysFile", header: [{ text: "SysFile" }] },
		        { hidden:true, width: 130, id: "OriginalFileName", header: [{ text: "OriginalFileName" }] },
		        { hidden:true, width: 130, id: "TaskTypeCode", header: [{ text: "TaskTypeCode" }] },
			],
			autoWidth: true,
			data: resultdata,
			selection: "row",
			resizable: true,
		    adjust: true
			
		});
		
		grid.events.on("cellClick", function(row,column,e){
		    var columnID = JSON.stringify(column.id).replace(/\"/g, "");
		    if(columnID == "AttachFileBtn"){
		    	 var fileID = JSON.stringify(row.TaskTypeCode).replace(/\"/g, "");
		    	 fnFileDownLoad(TaskTypeCode);
		    }
		});
		
		grid.events.on("filterChange", function(row,column,e, item){
			$("#TOT_CNT").html(grid.data.getLength());
		});	
		
		var pagination = new dhx.Pagination("pagination", {
		    data: grid.data,
		    pageSize: 20,
		});
		
		grid.events.on("AfterEditEnd", function(value,row,column, arguments){
		    if(column.id == "ActorNameP") {
		    	var actorP = taskAuthorData[taskAuthorData.findIndex(function(obj){
		    		
			        return obj.UserName == value
			    })].MemberID;
				grid.data.update(row.id, { ActorP: actorP })
		    }
		    if(column.id == "ActorNameA") {
		    	var actorA = taskAuthorData[taskAuthorData.findIndex(function(obj){
			        return obj.MemberID == value
			    })].MemberID;
				grid.data.update(row.id, { ActorA: actorA })
		    }
		});
	} 
	
	function exportXlsx() {
	    grid.export.xlsx({
	        url: "//export.dhtmlx.com/excel"
	    });
	};

	function fnFileDownLoad(seq){	
	/* 
		var originalFileName = $("#originalFileName"+taskTypeCode).val();
		var sysFileName = $("#sysFileName"+taskTypeCode).val();
		var seq = $("#fileID"+taskTypeCode).val(); 
	*/
		var url  = "fileDownload.do?seq="+seq;
	
		ajaxSubmitNoAdd(document.taskPlan, url,"blankFrame");
	}
	
	function fnEdit() {
		grid.config.editable = true;
		
		for(var i=0; i < grid.data.getLength(); i++){
			grid.addCellCss(grid.data.getId(i), "ActorNameP", "grid_edit");	
			grid.addCellCss(grid.data.getId(i), "StartDateP", "grid_edit");	
			grid.addCellCss(grid.data.getId(i), "EndDateP", "grid_edit");	
			grid.addCellCss(grid.data.getId(i), "MandayP", "grid_edit");	
		
			grid.addCellCss(grid.data.getId(i), "ActorNameA", "grid_edit");	
			grid.addCellCss(grid.data.getId(i), "StartDateA", "grid_edit");	
			grid.addCellCss(grid.data.getId(i), "EndDateA", "grid_edit");	
			grid.addCellCss(grid.data.getId(i), "MandayA", "grid_edit");	
		}
		
		$("#saveAllBtn").css("display","");
		$("#editBtn").css("display","none");
		$("#backBtn").css("display","");
	}
	
	function fnBack() {
		//grid.hideColumn("checkbox");
		grid.config.editable = false;
		for(var i=0; i < grid.data.getLength(); i++){
			grid.removeCellCss(grid.data.getId(i), "ActorNameP", "grid_edit");	
			grid.removeCellCss(grid.data.getId(i), "StartDateP", "grid_edit");	
			grid.removeCellCss(grid.data.getId(i), "EndDateP", "grid_edit");	
			grid.removeCellCss(grid.data.getId(i), "MandayP", "grid_edit");	
		
			grid.removeCellCss(grid.data.getId(i), "ActorNameA", "grid_edit");	
			grid.removeCellCss(grid.data.getId(i), "StartDateA", "grid_edit");	
			grid.removeCellCss(grid.data.getId(i), "EndDateA", "grid_edit");	
			grid.removeCellCss(grid.data.getId(i), "MandayA", "grid_edit");	
		}
		
		$("#backBtn").css("display","none");
		$("#addBtn").css("display","none");
		$("#saveAllBtn").css("display","none");
		$("#editBtn").css("display","");
		
		//events = "CellClick";
	}
	
	function fnSaveChildItemAttr(){ // saveAll
		editedRow = [];
		if(!confirm("${CM00001}")){ return;}
		
		
		for(var i=0; i< grid.data._order.length; i++) {			
			
			editedRow.push(grid.data._order[i]);	
		}	
		
		var jsonData = JSON.stringify(editedRow);		
		$("#updateData").val(jsonData);		
		var url = "saveTask.do";	
		ajaxSubmitNoAdd(document.taskPlan, url, "blankFrame");
		
	}
</script>
</head>
<body>
	<!-- <div style="height:5px"></div>  -->
	<div id="objectInfoDiv" style="width:100%;margin: 0;">
	<div class="countList">
		<ul>
			<li class="floatR pdR10">
			<c:if test="${ ( sessionScope.loginInfo.sessionMlvl == 'SYS' || csrAuthorID == sessionScope.loginInfo.sessionUserId) && csrStatus == 'MOD'}">
				<c:if test="${sessionScope.loginInfo.sessionMlvl == 'SYS' || curTask == 'RDY' || curTask == 'PLAN1'}"> 
					<span id="editBtn" class="btn_pack nobg white"><a class="edit" onclick="fnEdit();" title="Edit"></a></span>
    	       		<span id="backBtn" style="display:none;" class="btn_pack nobg white"><a class="clear" onclick="fnBack()" title="Back"></a></span>
        	   		<span id="saveAllBtn" style="display:none;" class="btn_pack nobg" ><a class="save" id="Input" OnClick="fnSaveChildItemAttr()" title="Save All"></a></span>
				</c:if>
			</c:if>
            </li>
		</ul>
     </div>
     
	<div style="width: 100%;" id="grid_container">
	</div>
	<form name="taskPlan" id="taskPlan" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="updateData" name="updateData" value="">
		<input type="hidden" id="itemID" name="itemID" value="${itemID}">
		<input type="hidden" id="changeSetID" name="changeSetID" value="${changeSetID}">
		<input type="hidden" id="projectID" name="projectID" value="${projectID}">
		<input type="hidden" id="csrAuthorID" name="csrAuthorID" value="${csrAuthorID}">
		<input type="hidden" id="curTask" name="curTask" value="${curTask}">
		<input type="hidden" id="parentID" name="parentID" value="${parentID}">
		<input type="hidden" id="csrStatus" name="csrStatus" value="${csrStatus}">
	</form>
	</div>	
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>

</html>
