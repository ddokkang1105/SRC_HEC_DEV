<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="Name"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<!-- dhtmlx 7버전 업그레이드   -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<!-- 2. Script -->
<script type="text/javascript">
	var pp_grid;				//그리드 전역변수
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	var listEditable = "${listEditable}";
	
	console.log(listEditable);
	$(document).ready(function() {
		// SKON CSRF 보안 조치
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
				}
		})		
		
		// 초기 표시 화면 크기 조정 
		$("#grdPAArea").attr("style","height:"+(setWindowHeight() - 210)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdPAArea").attr("style","height:"+(setWindowHeight() - 210)+"px;");
		};
		
		$('.searchPList').click(function(){doPSearchList();});
			
		//$("#excel").click(function(){pp_grid.toExcel("${root}excelGenerate");});
	
	    $("#excel").click(function(){
	    	doExcel();
		 });
	      
	});	
	
	function setWindowHeight(){
		var size = window.innerHeight;
		var height = 0;
		if( size == null || size == undefined){
			height = document.body.clientHeight;}
		else{
			height=window.innerHeight;}
		return height;
		
	}
	function doExcel() {
		if(!confirm("Excel download 를 진행 하시겠습니까?")){ return;}
		grid.export.xlsx();
		
		grid.export.xlsx({
		    name:"grid_data",
		    url: "//export.dhtmlx.com/excel"
		});
		
	} 

	function fnAddPjtTaskType(url){
		var data = "projectID=${projectID}&listEditable=Y&isNew=${isNew}&isPjtMgt=${isPjtMgt}";
		var target = "help_content";
		if($("#help_content").val() == undefined) target = "mainLayer";		
		ajaxPage(url, data, target);
	}
	
	function fnDelPjtTaskType() {
		
		var checkedDel = grid.data.findAll(function (data) {
			return data.CHK;
		});
		if (checkedDel.length == 0) {
			alert("${WM00023}");
		}else {
			if (confirm("${CM00004}")) {
				var	taskTypeCodeDel;
				var pjtTaskCnt = checkedDel.map(function (data) {
					return data.PjtTaskCnt;
				});
				console.log("pjtTaskCnt>>"+pjtTaskCnt);
				if(pjtTaskCnt > 0){
					var taskTypeName = checkedDel.map(function (data) {
						return data.TaskTypeName;
					});
					
					var taskTypeCode = checkedDel.map(function (data) {
						return data.TaskTypeCode;	
					});
					var task = taskTypeName +"("+ taskTypeCode+")";
					"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00144' var='WM00144' arguments='"+ task +"'/>"
					alert("${WM00144}");
					
					console.log("task>>"+task);
					grid.selection.removeCell();
				}else{
				   	taskTypeCodeDel = checkedDel.map(function (data) {
						return data.TaskTypeCode;	
					});
				}
				if (taskTypeCodeDel !== undefined) {
					console.log("taskTypeCodeDel>>"+taskTypeCodeDel);
					var url = "admin/deletePjtTaskTypeCode.do";
					var data = "projectID=${projectID}&taskTypeCodes=" + taskTypeCodeDel;
					var target = "saveFrame";
					
					ajaxPage(url, data, target);
				}
				
				
			}
		}


	}
	
	// [Select] 버튼 Click
	function fnSelectNewTaskType() {

		var checkedAdd = grid.data.findAll(function (data){
			return data.CHK;
		});
		
	  	 if (checkedAdd.length == 0 ) {
			alert("${WM00023}");
		}else {
			if (confirm("${CM00012}")) { 
				var taskTypeCodes = checkedAdd.map(function (data) {
					return data.TaskTypeCode; // checkedRow에서 속성 추출 (체크한 항목의 taskTypeCode 추출  )
					
				});
				
				var itemClassCodes = checkedAdd.map(function (data) {
					return data.ItemClassCode;
				});
				
				console.log("taskTypeCodes>>"+taskTypeCodes);
				console.log("itemClassCodes>>"+itemClassCodes);
				var url = "admin/insertPjtTaskType.do";
				var data = "projectID=${projectID}&taskTypeCodes=" + taskTypeCodes+"&itemClassCodes="+itemClassCodes; 
				var target = "saveFrame";
				
				ajaxPage(url, data, target);
			}
		}  
		  
	}
	
	function fnCallBack(){
		var url = "selectPjtTaskType.do";
		var data = "projectID=${projectID}&listEditable=N&isNew=${isNew}&isPjtMgt=${isPjtMgt}&screenType=${screenType}"; 
		var target = "selectPjtTaskType";
		ajaxPage(url, data, target);
	}
		
	function goBack() {
		var url = "selectPjtTaskType.do";
		var data = "projectID=${projectID}&listEditable=N&isNew=${isNew}&isPjtMgt=${isPjtMgt}";
		var target = "selectPjtTaskType";
		
		if ("N" == listEditable) {
			url = "viewProjectInfo.do";
			data = "isNew=${isNew}&s_itemID=${projectID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&pjtMode=R&screenType=${screenType}";
		}
		ajaxPage(url, data, target);
	}
	
	//그리드ROW선택시
	function gridOnRowSelect(id, ind){ 
		$("#editTaskType").attr('style', 'display: block');	
		$("#editTaskType").attr('style', 'width: 100%');	
		$("#divSaveBtn").attr('style', 'display: block');	
		
		$("#taskTypeCode").val(pp_grid.cells(id,2).getValue());
		$("#sortNum").val(pp_grid.cells(id,7).getValue());
		$("#mandatory").val(pp_grid.cells(id,8).getValue());

		if(pp_grid.cells(id,8).getValue() == 1){
			$("#mandatory").attr('checked', 'checked');	
		}else{
			$("#mandatory").attr('checked', '');	
		}
	}
	
	function fnSetCheckBox(){			
		var chk = document.getElementsByName("mandatory");
		if(chk[0].checked == true){ $("#mandatory").val("1");
		}else{	$("#mandatory").val("0"); }
	}
	
	function fnSaveTaskTypeInfo(){
		var taskTypeCode = $("#taskTypeCode").val();
		var sortNum = $("#sortNum").val();
		var mandatory = $("#mandatory").val();
		var url = "saveTaskTypeInfo.do";
		var data = "projectID=${projectID}&taskTypeCode="+taskTypeCode+"&sortNum="+sortNum+"&mandatory="+mandatory; 
		var target = "saveFrame";
		ajaxPage(url, data, target);
		
		$("#editTaskType").attr('style', 'display: none');	
		$("#divSaveBtn").attr('style', 'display: none');	
	}
	
</script>

<div id="selectPjtTaskType">
<form name="taskTypeListFrm" id="taskTypeListFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="ProjectID" name="ProjectID" value="${projectID}" />
	<input type="hidden" id="currPage" name="currPage" value="${currPage}" />
	<div class="msg mgT5" style="width:100%;">
	   <c:if test="${listEditable == 'N'}">
       	   <img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Manager project task type
       </c:if>
       <c:if test="${listEditable == 'Y'}">
           <img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Add New TaskType
       </c:if>
    </div>
	<div class="child_search">
	
		<li class="floatR pdR20">
			<c:if test="${listEditable == 'N'}">
				<c:if test="${getMap.Status != 'CLS'}"> 
	               	<c:if test="${sessionScope.loginInfo.sessionUserId == getMap.AuthorID || sessionScope.loginInfo.sessionAuthLev == 1}">
						<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="fnAddPjtTaskType('selectPjtTaskType.do')" ></span>
						&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDelPjtTaskType()"></span>
					</c:if>
				</c:if>
			</c:if>
			
			<c:if test="${listEditable == 'Y'}">
				<span class="btn_pack small icon"><span class="add"></span><input value="Select" type="submit" onclick="fnSelectNewTaskType()" ></span>
			</c:if>
			&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>			
			<c:if test="${isPjtMgt != 'Y'}">
				&nbsp;<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="goBack()" type="submit"></span>
			</c:if>
		</li>
    </div>
  	
	<div class="countList pdT5">
    	<li  class="count">Total  <span id="TOT_CNT"></span></li>
   	</div>
	<div id="gridDiv" class="mgB10 clear" align="left">
		<div id="grdPAArea" style="height:200px;width:100%"></div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular" >
	<div id="pagingArea" style="display:inline-block;"></div>
	</div>
	<div class="mgT5 mgL10 mgR10">
	<table id="editTaskType" class="tbl_blue01" width="100%"   cellpadding="0" cellspacing="0" style="display:none">
		<colgroup>
			<col width="20%">
			<col width="30%">
			<col width="20%">
			<col width="30%">
		</colgroup>
		<tr>
			<th>SortNum</th>
			<td class="last">
				<input type="text" id="sortNum" name="sortNum" class="text" value="" />
				<input type="hidden" id="taskTypeCode" name="taskTypeCode" >
			</td>
			<th>Mandatory</th>
			<td class="last">
				<input type="checkbox" id="mandatory" name="mandatory" onClick="fnSetCheckBox()"/>
			</td>
		</tr>
	</table>
	</div>
	<div  class="alignBTN" id="divSaveBtn" style="display: none;">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<span class="btn_pack medium icon"><span  class="save"></span><input value="Save" onclick="fnSaveTaskTypeInfo()"  type="submit"></span>
		</c:if>		
	</div>
</form>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;" frameborder="0"></iframe>
<script type="text/javascript">
		var layout = new dhx.Layout("grdPAArea", {
			rows : [ {
				id : "a",
			}, ]
		});	
		var gridData = ${gridData}; 
	
		var grid = new dhx.Grid("grdPAArea", {
		    columns: [
		        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
		        { width: 50, id: "CHK", header: [{ text: "" }], align: "center", type: "boolean",  editable: true},
		        { width: 100, id: "TaskTypeCode", header: [{ text: "TaskTypeCode" }], align: "center"},
		        { width: 250, id: "TaskTypeName", header: [{ text: "Name" , align: "center"}, { content: "inputFilter" }]},
		        { width: 350, id: "ItemClass", header: [{ text: "${menu.LN00016}" , align: "center" }]},
		        { hidden:true,width: 250, id: "ItemClassCode", header: [{ text: "ItemclassCode" , align: "center" }, { content: "selectFilter" }]},
		        { hidden:true, width: 100, id: "PjtTaskCnt", header: [{ text: "Cnt" , align: "center" }, { content: "" }]},
		        { width: 100, id: "SortNum", header: [{ text: "SortNum" , align: "center" }, { content: "" }], align: "" },
		        { width: 100, id: "Mandatory", header: [{ text: "Mandatory" , align: "center" }, { content: "" }] }
		        
		        
		    ],
		    eventHandlers: {
		        onclick: {
		         
		        }
		    },
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    data: gridData
		});
		
	
		
		layout.getCell("a").attach(grid);
		
		var pagination = new dhx.Pagination("pagingArea", {
		    data: grid.data,
		    pageSize: 40,
		 
		});	
		
		pagination.setPage(document.getElementById('currPage').value);
		$("#TOT_CNT").html(grid.data.getLength());
	/* 	grid.events.on("cellClick", function(row, column, e) {
		    var projectId  = row.ProjectID;
		    goInfoView(projectId);
		    console.log("클릭한 행의 ProjectID 값은:", projectId);
		}); */
</script>
