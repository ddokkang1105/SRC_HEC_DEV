<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root" />
<%@ include file="/WEB-INF/jsp/template/tagIncV7.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="./cmm/js/xbolt/popupHelper.js"></script>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

<script>
var grid;
var editedRow = [];
var gridData = ${taskFileList};

	$(document).ready(function(){	
		$("input.datePicker").each(generateDatePicker);
		
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
				{ width: 80, id: "RNUM", header: [{ text: "No"}], editable:false },
		        { width: 100, id: "FltpName", header: [{ text: "${menu.LN00091}"}], editable:false },
		        { width: 50, id: "AttachFileBtn", header: [{ text: "File"}], htmlEnable: true },
		        { width: 150, id: "FileRealName", header: [{ text: "${menu.LN00101}"}], editable:false },
		        { width: 150, id: "LastUpdated", header: [{ text: "${menu.LN00070}"}], editable:false },
		        { width: 100, id: "RegMemberName", header: [{ text: "${menu.LN00060}"}], editable:false },
		        { width: 100, id: "TeamName", header: [{ text: "${menu.LN00104}"}], editable:false },
		        { width: 40, id: "DownCNT", header: [{ text: "${menu.LN00030}"}], editable:false },

		        <c:if test="${(csrAuthorID == sessionScope.loginInfo.sessionUserId || actorYN == 'Y')  && csrStatus != 'CLS'}">
		        {
		            id: "action", width: 200, header: [{ text: "fileUpload", align: "center" }],
		            htmlEnable: true, align: "center", sortable: false,
		            template: function(text, row, col) {
		            	
		            	return "<input style=\"width:150px;\" type=\"file\" name=\"uploadFile\" id=\"uploadFile\" OnChange=\"saveTaskFile('"+row.TaskID+"','"+row.FltpCode+"','"+row.FileID+"')\">";
		            }
		        },  
		        </c:if>
		        
		        { hidden:true, width: 130, id: "FileID", header: [{ text: "FileID" }] },
		        { hidden:true, width: 130, id: "SysFileName", header: [{ text: "SysFileName" }] },
		        { hidden:true, width: 130, id: "SysFile", header: [{ text: "SysFile" }] },		      
		        
			],
			autoWidth: true,
			data: resultdata,
			selection: "row",
			resizable: true,
		    //adjust: true
			
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
		/*
		var pagination = new dhx.Pagination("pagination", {
		    data: grid.data,
		    pageSize: 20,
		});
		*/
		grid.events.on("AfterEditEnd", function(value,row,column){
    		console.log(column.id);
    		console.log(taskAuthorData);
		    if(column.id == "ActorNameP") {
		    	var actorP = taskAuthorData[taskAuthorData.findIndex(function(obj){
		    		console.log(obj);
		    		console.log(value);
			        return obj.MemberID == value
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
	
	function fnEdit() {
		grid.config.editable = true;
		grid.addCellCss(2, "TeamNameP", "my_сustom_сlass");

		//grid.showColumn("action");
		$("#saveAllBtn").css("display","");
		$("#editBtn").css("display","none");
		$("#backBtn").css("display","");
	}
	
	function fnBack() {
		//grid.hideColumn("checkbox");
		grid.config.editable = false;
		grid.hideColumn("action");
		
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
	// [Attach] 버튼 클릭
	function saveTaskFile(taskID,fltpCode,fileID){
		$("#taskID").val(taskID);
		$("#fltpCode").val(fltpCode);
		$("#fileID").val(fileID);
		var url  = "saveTaskFile.do"; 
		ajaxSubmit(document.taskDlvrblsFrm, url,"blankFrame");
	}
	
</script>
	<form name="taskDlvrblsFrm" id="taskDlvrblsFrm" action="" enctype="multipart/form-data" method="post">
	<input type="hidden" id="csrAuthorID" name="csrAuthorID" value="${csrAuthorID}">
	<input type="hidden" id="csrStatus" name="csrStatus" value="${csrStatus}">
	<input type="hidden" id="changeSetID" name="changeSetID" value="${changeSetID}">
	<input type="hidden" id="itemID" name="itemID" value="${itemID}">
	<input type="hidden" id="taskID" name="taskID" value="">
	<input type="hidden" id="fltpCode" name="fltpCode" value="">
	<input type="hidden" id="fileID" name="fileID" value="">
	<input type="hidden" id="updateData" name="updateData" value="${updateData}">
	
	
	<div style="width:100%;overflow:auto;overflow-x:hidden;margin: 0;">
		<div style="width: 100%;" id="grid_container"></div>
	</div>	
	</form>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
	
