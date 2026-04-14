<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagIncV7.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00138" var="WM00138" arguments="20"/>
<style>
	.grid_edit {
		background: #aecdda;
	}
	.form_edit .dhx_input {
		background: #aecdda;
	}
</style>
<script type="text/javascript">
var grid = ""; var pagination = "";
var editedRow = [];
var editForm;
var editFormConfig = {
        padding: 0,
        rows: [
        	{ id: "id", type: "input", name: "id",hidden: true },
        	{ type: "input", name: "ID", label: "ID", disabled : true },
        	{ type: "input", name: "ItemName", label: "ItemName", disabled : true },
        	{ type: "input", name: "ProjectName", label: "ProjectName", disabled : true },
        	{ type: "input", name: "CsrName", label: "CsrName", disabled : true },
        	{ type: "input", name: "TaskName", label: "TaskName", disabled : true },
        	{ type: "input", name: "ActorName", label: "ActorName", disabled : true },
        	{ type: "input", name: "PlanEndDate", label: "PlanEndDate", disabled : true },
        	{ type: "datepicker", name: "ActualStartDate", label: "ActualStartDate", dateFormat: "%Y-%m-%d", css : "form_edit" },
        	{ type: "datepicker", name: "ActualEndDate", label: "ActualEndDate", dateFormat: "%Y-%m-%d", css : "form_edit" },
        	{ type: "input", name: "EndDateGap", label: "EndDateGap", disabled : true },
        	{ type: "input", name: "ProgramID", label: "ProgramID", css : "form_edit" },
        	{ type: "input", name: "T_Code", label: "T_Code", css : "form_edit" },
         
        	{ hidden:true, type: "input", name: "ChangeSetID", label: "ChangeSetID" },
        	{ hidden:true, type: "input", name: "TaskTypeCode", label: "TaskTypeCode" },
        	{ hidden:true, type: "input", name: "TaskIDA", label: "TaskIDA" },
        	{ hidden:true, type: "input", name: "FltpCode", label: "FltpCode" },
        	{ hidden:true, type: "input", name: "ItemID", label: "ItemID" },
        	{ hidden:true, type: "input", name: "FileID", label: "FileID" },
        	{ hidden:true, type: "input", name: "SysFile", label: "SysFile" },
        	{ hidden:true, type: "input", name: "ProjectID", label: "ProjectID" },
        	{ hidden:true, type: "input", name: "TaskIDP", label: "TaskIDP" },	
        {
            type: "button",
            text: "File Upload",
            id: "send",
            icon: "mdi mdi-file-outline",
            color : "Success",
            Customization : "Use Icon",
            id: "file-button",
            
        },
        { align: "end", cols: [{ id: "save-button", type: "button", text: "Save", icon: "mdi mdi-content-save",circle: true, }]}
        ]};
var editWindow = new dhx.Window({
    width: 440,
    height: 650,
    modal: true
});

var gridConfig = {
    columns: [
    	{ width: 30, id: 'RNUM', header: [{ text: 'No' }]},
        
    	{ width: 50, id: 'checkbox', header: [{ text: '' }], align: 'center', type: 'boolean', editable:true},
        { width: 80, id: 'ID', header: [{ text: '${menu.LN00106}' }, { content: 'inputFilter' }], editable:false},
        { width: 200, id: 'ItemName', header: [{ text: '${menu.LN00028}' }, { content: 'inputFilter' }], editable:false },
        { width: 180, id: 'ProjectName', header: [{ text: '${menu.LN00131}' }], editable:false },
        { width: 160, id: 'CsrName', header: [{ text: '${menu.LN00130}' }], editable:false },
        { width: 100, id: 'TaskName', header: [{ text: 'Task' }, { content: 'selectFilter' }], editable:false },
        { width: 80, id: 'ActorName', header: [{ text: '${menu.LN00004}' }, { content: 'selectFilter' }], editable:false },
        { width: 90, id: 'PlanEndDate', header: [{ text: '${menu.LN00221}' }], editable:false},
        
        { width: 90, id: 'ActualStartDate', header: [{ text: '${menu.LN00063}' }], type: 'date', format: '%Y-%m-%d' },
        { width: 90, id: 'ActualEndDate', header: [{ text: '${menu.LN00064}' }], type: 'date', format: '%Y-%m-%d' },
        { width: 80, id: 'EndDateGap', header: [{ text: 'Gap' }], editable:false },
        { width: 150, id: 'ProgramID', header: [{ text: 'ProgramID' }] },
        { width: 70, id: 'T_Code', header: [{ text: 'T_Code' }] },
        { width: 60, id: 'AttachFileBtn', header: [{ text: 'Down' }] ,htmlEnable: true, align:'center'},
        
        // hidden
        {
            id: "action1", width: 200, header: [{ text: "fileUpload", align: "center" }],
            htmlEnable: true, align: "center", sortable: false,
            template: function(text, row, col) {
            	
            	//return "<input style=\"width:150px;\" type=\"file\" name=\"uploadFile\" id=\"uploadFile\" OnChange=\"saveTaskFile('"+row.ChangeSetID+"','"+row.TaskTypeCode+"','"+row.TaskIDA+"','"+row.FltpCode+"','"+row.ItemID+"','"+row.FileID+"','"+row.SysFile+"','"+row.ProjectID+"')\">";
            	return "<a onclick=\"fnFileUpload('"+row.ChangeSetID+"','"+row.TaskTypeCode+"','"+row.TaskIDA+"','"+row.FltpCode+"','"+row.ItemID+"','"+row.FileID+"','"+row.SysFile+"','"+row.ProjectID+"')\";\"><img src=\"/cmm/sf/images//item/icon_attach.png\"></a>";
            }
        },
        {
            id: 'action', width: 80, header: [{ text: 'Actions', align: 'center' }],
            htmlEnable: true, align: 'center', sortable: false,
            template: function(text, row, col) {
            	return "<span class='action-buttons'><a class='edit-button' title='edit'><i class='mdi mdi-pencil'></i></a></span>";
            }
        },
        
        { hidden:true, width: 130, id: 'FileID', header: [{ text: 'FileID' }] },
        { hidden:true, width: 130, id: 'SysFileName', header: [{ text: 'SysFileName' }] },
        { hidden:true, width: 130, id: 'SysFile', header: [{ text: 'SysFile' }] },
        { hidden:true, width: 130, id: 'OriginalFileName', header: [{ text: 'OriginalFileName' }] },
        
        { hidden:true, width: 130, id: 'UploadFileBtn', header: [{ text: 'UploadFileBtn' }]},
        { hidden:true, width: 130, id: 'ProjectID', header: [{ text: 'ProjectID' }] },
        { hidden:true, width: 130, id: 'FilePath', header: [{ text: 'FilePath' }] },	        
        { hidden:true, width: 130, id: 'ChangeSetID', header: [{ text: 'ChangeSetID' }] },
        { hidden:true, width: 130, id: 'TaskTypeCode', header: [{ text: 'TaskTypeCode' }] },
        { hidden:true, width: 130, id: 'ItemID', header: [{ text: 'ItemID' }] },
        { hidden:true, width: 130, id: 'FltpCode', header: [{ text: 'FltpCode' }] },
        { hidden:true, width: 130, id: 'TaskIDA', header: [{ text: 'TaskIDA' }] },	        
        { hidden:true, width: 130, id: 'TaskIDP', header: [{ text: 'TaskIDP' }] },
        { hidden:true, width: 130, id: 'CsrAuthorID', header: [{ text: 'CsrAuthorID' }] }
        
    ],
    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    eventHandlers: {
        onclick: {
            "edit-button": function (e, data) {
            	openEditor(data.row.id);
            }
        }
    },
};

	
	$(document).ready(function(){			
		// 초기 표시 화면 크기 조정 
		$("#grid_container").attr("style","height:"+(setWindowHeight() * 0.65)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grid_container").attr("style","height:"+(setWindowHeight() * 0.65)+"px;");
		};
		doSearchList();
		fnSelect('taskTypeCode','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}','getTaskTypeCode','','Select');
		fnSelect('actor','&userID=${sessionScope.loginInfo.sessionUserId}&itemTypeCode=${itemTypeCode}','getTskActor','','Select');
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
	
	function closeEditor() {
	    editForm.clear();
	    editWindow.hide();
	}
	
	function openEditor(id) {
	    editWindow.show();
	    var item = grid.data.getItem(id);
	    if (item) {
	        editForm.setValue(item);
	    }
	}
	
	function doSearchList(){
		var msg = "${WM00018}";
		var url = "jsonDhtmlxListV7.do";
		var target = "grid_container";
		var sqlID = "task_SQL.getTaskResultList";
		
		var data = "sqlID="+sqlID + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&userID=${sessionScope.loginInfo.sessionUserId}"	 
			+ "&itemTypeCode=${itemTypeCode}"
			+ "&searchValue=" + $("#searchValue").val()
			+ "&searchKey=" + $("#searchKey").val()			
			+ "&screenMode=myTask"
			+ "&currentDate=${thisYmd}"
			+ "&htmlImgDir=${root}${HTML_IMG_DIR}/";
			
			if($("#taskTypeCode").val() != null){ data = data +"&taskTypeCode="+$("#taskTypeCode").val();	}
			if($("#taskStatus").val() != null){	data = data +"&taskStatus="+$("#taskStatus").val();}
			if($("#actor").val() != null){data = data +"&actor="+$("#actor").val();}
			if($("#planEndDate").val() != null){data = data +"&planEndDate="+$("#planEndDate").val();}
			
		fnLoadDhtmlxGridJsonV7(msg,target,sqlID,data);
		
	}
	
	function fnLoadDhtmlxGridJsonV7(msg,target,sqlID,data,callback){
		var url = "jsonDhtmlxListV7.do";
		$.ajax({
			url: url,type: 'post',data: data
			,error: function(xhr, status, error) {('#loading').fadeOut(150);var errUrl = "errorPage.do";var errMsg = "status::"+status+"///error::"+error;var callback = "";var width = "300px";var height = "300px";var callBack = function(){};fnOpenLayerPopup(errUrl,errMsg,callBack,width,height);}
			,beforeSend: function(x) {$('#loading').fadeIn();if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}	}
			,success: function(result){
				$('#loading').fadeOut();
				if(result == 'error' || result == ""){
					alert(msg); 
					if (grid) {
	        	        grid.destructor();
	        	        pagination.destructor();
	        	    }
				}else{					
					result = JSON.parse(result);					
					if (grid) { grid.destructor();}
	        		grid = new dhx.Grid(target, gridConfig);	        		
	        		grid.data.parse(result);	        		

					$('#TOT_CNT').html(result.length);
					
					if(pagination){pagination.destructor();}
					pagination = new dhx.Pagination("pagination", {
					    data: grid.data,
					    pageSize: 20,
					});
					
					grid.events.on("cellClick", function(row,column,e){
					    var columnID = JSON.stringify(column.id).replace(/\"/g, "");
					    if(columnID == "AttachFileBtn"){
					    	 var fileID = JSON.stringify(row.FileID).replace(/\"/g, "");
					    	fnFileDown(fileID);
					    }else if(columnID == "ItemName"){
					    	 var itemID = JSON.stringify(row.ItemID).replace(/\"/g, "");
					    	fnItemDetail(itemID);
					    } 
					});

					grid.config.editable = false;
					grid.hideColumn("action");
					grid.hideColumn("action1");
					editForm = new dhx.Form(null, editFormConfig);
					
					editForm.events.on("click", function (e, data, id, arguments) {
				    	if(e == "file-button"){
					    	fnFileUpload(
					    		editForm.getValue().ChangeSetID,
					    		editForm.getValue().TaskTypeCode,
					    		editForm.getValue().TaskIDA,
					    		editForm.getValue().FltpCode,
					    		editForm.getValue().ItemID,
					    		editForm.getValue().FileID,
					    		editForm.getValue().SysFile,
					    		editForm.getValue().ProjectID
					    	)
					    }else if(e == "save-button"){
					    	fnSaveChildItemAttr('', editForm.getValue());
					    }
					});
					// attaching Form to Window
					editWindow.attach(editForm);
				}
			}
		});
	}
	
	function fnFileDown(fileID){
		var url  = "fileDownload.do?seq="+fileID;
		ajaxSubmitNoAdd(document.taskResultFrm, url,"subFrame");
	}
	
	function fnItemDetail(itemID){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop";
		var w = 1200;
		var h = 900; 
		itmInfoPopup(url,w,h,itemID);
	}
	
	function fnChangeActor(){
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		
		if(!selectedCell.length){
			alert("${WM00023}"); return;
		}
	
		var itemIDArr = new Array;
		var changeSetIDArr = new Array;
		var taskTypeCodeArr = new Array;
			
		for(idx in selectedCell){
			itemIDArr[idx]= selectedCell[idx].ItemID;
			changeSetIDArr[idx]= selectedCell[idx].ChangeSetID;
			taskTypeCodeArr[idx] = selectedCell[idx].TaskTypeCode;
		};
				
		if(itemIDArr != ""){
			var url = "editTaskActorPop.do?";
			var data = "itemIDArr="+itemIDArr
					+"&changeSetIDArr="+changeSetIDArr
					+"&taskTypeCodeArr="+taskTypeCodeArr
					+"&itemID=${itemID}"; 

		    var w = 450;
		    var h = 470;
		    window.open(url + data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		}
	}
	
	function fnSaveChildItemAttr(saveType, SaveData){ // saveAll
		editedRow = [];
		if(!confirm("${CM00001}")){ return;}
		if(saveType == 'ALL'){
			for(var i=0; i< grid.data._order.length; i++) {
				editedRow.push(grid.data._order[i]);	
			}	
		}else{
			editedRow.push(SaveData);
		}
		var jsonData = JSON.stringify(editedRow);		
		$("#updateData").val(jsonData);		
		var url = "saveTaskResult.do";	
		ajaxSubmitNoAdd(document.editTaskResultFrm, url, "subFrame");
		
	}
	
	function fnGoBack() {
		closeEditor();
		var url = "editTaskResultList.do";
		var data = "pageNum=${pageNum}&itemTypeCode=${itemTypeCode}"; 
		var mainVersion = "${mainVersion}";
		var target = "actFrame";
		if(mainVersion == "mainV4"){target = "help_content";}
	 	ajaxPage(url, data, target);
	}
	
	function fnEdit() {	
		
		for(var i=0; i < grid.data.getLength(); i++){
			grid.addCellCss(grid.data.getId(i), "ActualStartDate", "grid_edit");	
			grid.addCellCss(grid.data.getId(i), "ActualEndDate", "grid_edit");	
			grid.addCellCss(grid.data.getId(i), "ProgramID", "grid_edit");	
			grid.addCellCss(grid.data.getId(i), "T_Code", "grid_edit");	
		}
		grid.config.editable = true;
		grid.showColumn("action");
		grid.showColumn("action1");
		$("#saveAllBtn").css("display","");
		$("#editBtn").css("display","none");
		$("#backBtn").css("display","");
	}
	
	function fnBack() {
		for(var i=0; i < grid.data.getLength(); i++){
			grid.removeCellCss(grid.data.getId(i), "ActualStartDate", "grid_edit");	
			grid.removeCellCss(grid.data.getId(i), "ActualEndDate", "grid_edit");	
			grid.removeCellCss(grid.data.getId(i), "ProgramID", "grid_edit");	
			grid.removeCellCss(grid.data.getId(i), "T_Code", "grid_edit");	
		}
		
		grid.config.editable = false;
		grid.hideColumn("action");
		
		$("#backBtn").css("display","none");
		$("#addBtn").css("display","none");
		$("#saveAllBtn").css("display","none");
		$("#editBtn").css("display","");
		
		//events = "CellClick";
	}
	
	function fnFileUpload(changeSetID,taskTypeCode,taskID,fltpCode,itemID,fileID,sysFile,projectID){
		var url = "taskFileUploadPop.do?changeSetID="+changeSetID+"&taskTypeCode="+taskTypeCode+"&fltpCode="+fltpCode+"&itemID="+itemID+"&fileID="+fileID+"&taskID="+taskID+"&sysFile="+sysFile+"&projectID="+projectID;
		var w = 500;
		var h = 250;
		itmInfoPopup(url,w,h);
	}
	
	function fnCallBack() {
		doSearchList();
		self.close();
	}
	
</script>
<body>
<div id="attrDiv" name="attrDiv" >
	<form name="taskResultFrm" id="taskResultFrm" action="" method="post" onsubmit="return false">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<div class="cop_hdtitle mgB10" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 6px 0 6px 0">
			<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp; My Task
		</h3>
	</div>
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
		<colgroup>
		    <col width="10%">
		    <col width="20%">
		    <col width="10%">
		    <col width="20%">
		    <col width="10%">
		    <col width="20%">
	    </colgroup>
	    <tr>
			<!-- 진행상태 -->
	       	<th class="alignL">${menu.LN00065}</th>
	       	<td class="alignL">	       	
	       		<select id="taskStatus" Name="taskStatus" style="width:210px;">
	       			<option value='' >Select</option>
	       			<option value='1' >${menu.LN00118}</option>
	       			<option value='2' >${menu.LN00265}</option>
	       		</select>
	       	</td>
			<th class="alignL">
				<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색"  onclick="doSearchList()"/>
	       	</th>
	       	<td class="alignL">
				&nbsp;<span class="btn_pack small icon" style="display:inline-block;">				
				<span class="gov"></span><input value="Gov" type="submit" onclick="fnChangeActor();"></span>
	       	</td>
	     </tr>
	</table>
	<div class="countList">
              <li class="count">Total  <span id="TOT_CNT"></span></li>
              <li class="floatR pdR10">	
              	<span id="editBtn" class="btn_pack nobg white"><a class="edit" onclick="fnEdit();" title="Edit"></a></span>
              	<span id="backBtn" style="display:none;" class="btn_pack nobg white"><a class="clear" onclick="fnBack()" title="Back"></a></span>
              	<span id="saveAllBtn" style="display:none;" class="btn_pack nobg" ><a class="save" id="Input" OnClick="fnSaveChildItemAttr('ALL', '')" title="Save All"></a></span>
              </li>
     </div>
	<div id="gridDiv" class="mgB10 clear">
		<div id="grid_container" style="width: 100%"></div>
		<div id="pagination" style="padding: 0 10px;"  ></div>
	</div>	
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->		
</form>
<form name="editTaskResultFrm" id="editTaskResultFrm" action="*" method="post" onsubmit="return false">
	<input type="hidden" id="itemID" name="itemID" value="${itemID}">
	<input type="hidden" id="thisYmd" name="thisYmd" value="${thisYmd}">
	<input type="hidden" id="mainVersion" name="mainVersion" value="${mainVersion}">
	<input type="hidden" id="updateData" name="updateData" value="${updateData}">
</form>
</div>
</body>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>

