<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE HTML>
<html>
  <head>
<%@ include file="/WEB-INF/jsp/template/tagIncV7.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00068" var="WM00068" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="구분"/>

<style>
	#teamArea, #memberArea {
   		padding: 10px 20px;
   		box-sizing: border-box;
	}
	
	#teamArea {
	    width: 50%;
	    border-right: 1px solid #dfdfdf;
	}
	
	#memberArea {
		width: 50%;
	}
	
	#teamMemo {
	    width: 100%;
	    height: 100%;
	    border-radius: 3px;
	    border: 1px solid #dfdfdf;
	    resize: none;
	    padding: 10px;
	    box-sizing: border-box;
	}
	
	#teamMemo.form-input:focus{
	    border-color: #4265EE;
	}
	
	#inaccessible {
		position: absolute;
	    background: rgba(0,0,0,0.2);
	    top: 0;
	    width: 100%;
	    height: 100%;
	    visibility: hidden;
        z-index: 9999;
	}
	
	#inaccessible div {
    	margin: 0 auto;
	    width: 300px;
	    height: 135px;
	    background: #fff;
	    color: #000;
	}
	
	#inaccessible .mdi {
		color: #000;
	    font-size: 30px;
	    width: auto;
	}
</style>
<script>	
	$(document).ready(function(){
		if("${pjtTeamID}" === "") {
			document.getElementById("inaccessible").style.visibility = 'visible'
		}
		
		var parentOfLayout = Math.ceil(document.querySelector("#memberArea").clientWidth-40);
		// 초기 표시 화면 크기 조정
		$("#layout").attr("style","height:"+(setWindowHeight() - 115)+"px; width :"+parentOfLayout+"px;");
		$("#layout2").attr("style","height:"+(setWindowHeight() - 480)+"px; width :100%;");
		// 화면 크기 조정
		window.onresize = function() {
			parentOfLayout = Math.ceil(document.querySelector("#memberArea").clientWidth-40);
			$("#layout").attr("style","height:"+(setWindowHeight() - 115)+"px; width :"+parentOfLayout+"px;");
			$("#layout2").attr("style","height:"+(setWindowHeight() - 480)+"px; width : 100%;");
			console.log(document.getElementById("layout2").style.width)
		};
		
		$("#excel").click(function (){
			$('#fileDownLoading').removeClass('file_down_off');
			$('#fileDownLoading').addClass('file_down_on');
			ajaxPage("downTeamTaskInfo.do", "projectID=${projectID}&teamID=${teamID}", "saveFrame");
		});
		
		
		$("#report").click(function (){
			$('#fileDownLoading').removeClass('file_down_off');
			$('#fileDownLoading').addClass('file_down_on');
			fnExeReport();
		});
		
		document.getElementById("collapseUp").addEventListener("click", function (){
			document.getElementById("collapseDown").style.display = "";
			document.getElementById("teamInfo").style.display = "none";
			$("#layout2").attr("style","height:"+(setWindowHeight() - 115)+"px; width :100%;");
		});
		
		document.getElementById("collapseDown").addEventListener("click", function (){
			document.getElementById("collapseDown").style.display = "none";
			document.getElementById("teamInfo").style = "";
			$("#layout2").attr("style","height:"+(setWindowHeight() - 480)+"px; width :100%;");
		});
		
		document.getElementById("collapseLayout").addEventListener("click", function (){
			let array = this.children.item(0).src.split("/");
			let imgFile = array.pop();
			let imgNum = /\d/.exec(imgFile)[0];
		    
		    switch (imgNum) {
		    	case "1" : 
		    		this.children.item(0).src = array.join("/")+"/"+imgFile.replace(imgNum, 2);
		    		document.getElementById("teamArea").style.width = "100%";
		    		document.getElementById("memberArea").style.display = "none";
		    		break;
		    	case "2" : 
		    		this.children.item(0).src = array.join("/")+"/"+imgFile.replace(imgNum, 3);
		    		document.getElementById("teamArea").style.display = "none";
		    		document.getElementById("memberArea").style.display = "";
		    		document.getElementById("memberArea").style.width = "100%";
		    		document.getElementById("layout").style.width = "100%";
		    		break;
		    	case "3" : 
		    		this.children.item(0).src = array.join("/")+"/"+imgFile.replace(imgNum, 1);
		    		document.getElementById("teamArea").style.width = "";
		    		document.getElementById("teamArea").style.display = "";
		    		document.getElementById("memberArea").style.width = "";
		    		document.getElementById("memberArea").style.display = "";
		    		document.getElementById("layout").style.width = Math.ceil(document.querySelector("#memberArea").clientWidth-40)+"px";
		    		break;
		    }
	    });
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function fnEditTeamMemo(e) {
		let textarea = "";
		textarea	= document.querySelector("#teamMemo");
		textarea.classList.add("form-input");
		textarea.removeAttribute("readonly");
		textarea.focus();
		
		e.parentElement.children.save.classList.remove("help_hidden");
		e.parentElement.children.cancel.classList.remove("help_hidden");
		e.parentElement.children.edit.classList.add("help_hidden");
	}
	
	function fnAfterSaveTeamMemo(e) {
		let textarea = "";
		textarea	= document.querySelector("#teamMemo");
		textarea.classList.remove("form-input");
		textarea.setAttribute("readonly",true);
    	
    	e.parentElement.children.edit.classList.remove("help_hidden");
    	e.parentElement.children.save.classList.add("help_hidden");
		e.parentElement.children.cancel.classList.add("help_hidden");
	}
	
	function fnSaveTeamTask(e){
		$.ajax({
	        type: "POST",
	        data: {"teamMemo" : teamMemo.value, "projectID" : "${projectID}", "teamID" : "${teamID}"},
	        url: "editTeamTask.do",
	        async: false,
	        contentType: "application/x-www-form-urlencoded; charset=utf-8",
	        success: function(data) {
	        	alert("${WM00067}");
	        	fnAfterSaveTeamMemo(e);
	        }, error:function(request,status,error){
	        	console.log(request,status,error)
	        	alert("${WM00068}");
	        }
	    });
	}
	
	function doFileDown(avg1, avg2) {
		var url = "fileDown.do";
		$('#original').val(avg1);
		$('#filename').val(avg1);
		$('#scrnType').val(avg2);
		
		ajaxSubmitNoAlert(document.saveFrm, url, "saveFrame");
		$('#fileDownLoading').addClass('file_down_off');
		$('#fileDownLoading').removeClass('file_down_on');
	}
</script>
</head>
<body>
<div id="fileDownLoading" class="file_down_off" style="z-index: 9999;">
	<img src="${root}${HTML_IMG_DIR}/img_circle.gif"/>
</div>
<form name="saveFrm" id="saveFrm" method="post" action="#" onsubmit="return false;" style="height: 100%;">
	<input type="hidden" id="original" name="original" value="" />
	<input type="hidden" id="filename" name="filename" value="" />
	<input type="hidden" id="scrnType" name="scrnType" value="" />
	<div style="width:100%;line-height: 38px;border-bottom: 1px solid #cfe7ff;background: #f7f9fd;font-weight:600;" class="align-center flex justify-between">
			<p class="pdL20">부서 과업 정보 조회</p>
			<div class="flex pdR20">
				<button class="cmm-btn" style="padding: 0 5px; height: 29px;" id="collapseLayout"><img src="${root}cmm/common/images/collapse_1.png" alt="새창열기"></button>
			</div>
	</div>
	<div class="flex justify-between" style="height: calc(100% - 45px);">
		<div id="teamArea">
			<div id="teamInfo">
				<div class="flex justify-between mgB10 align-center">
					<p style="color: #193598 !important;font-size: 14px;font-weight: 600;">부서 정보</p>
					<span id="collapseUp" class="cmm_btn" style="background: none;width: 32px;">
						<i class="mdi mdi-chevron-up" style="font-size: 22px;margin-left: -4px;color:#000"></i>
					</span>
				</div>
				<ul style="border: 1px solid #dfdfdf;padding: 10px;margin: 10px 0 20px;">
				 	<li class="flex align-center pdB10">
						 <div style="flex: 1 1 0;" class="align-center flex">
							<h3 class="tx">부서명</h3>
							<span class="wrap_sbj">${teamTaskInfo.teamName}</span>
						</div>
						<div style="flex: 1 1 0;" class="align-center flex">
							<h3 class="tx">최종 수정일</h3>
							<span class="wrap_sbj">${teamTaskInfo.LastUpdated}</span>
						</div>
					</li>
					<li class="flex align-center">
						<div style="flex: 1 1 0;" class="align-center flex">
							<h3 class="tx">부서 직무</h3>
							<span class="wrap_sbj">${teamTaskInfo.itemNames}</span>
						</div>
					</li>
				</ul>
				
				<div class="flex justify-between align-center mgB10">
					<div style="color: #193598 !important;font-size: 14px;font-weight: 600;">
					부서 과업
					<img class="mgL8" src="${root}cmm/common/images/detail.png" onclick="fnOpenPop()" style="width:12px; cursor:pointer;" alt="새창열기">
					</div>
					<c:if test="${teamTaskInfo.ManagerID eq sessionScope.loginInfo.sessionUserId}">
					<div class="alignR">
						<button class="cmm-btn" onclick="fnEditTeamMemo(this)" id="edit">Edit</button>
						<button class="cmm-btn help_hidden mgR5" onclick="fnAfterSaveTeamMemo(this)" id="cancel">Cancel</button>
						<button class="cmm-btn btn-4265EE help_hidden" onclick="fnSaveTeamTask(this)" id="save">Save</button>
					</div>
					</c:if>
				</div>
				<div style="width:100%;height:180px;" class="mgB20">
					<textarea id="teamMemo" readonly>${teamTaskInfo.Memo}</textarea>
				</div>
			</div>
			<div class="flex justify-between align-center mgB7">
				<div style="color: #193598 !important;font-size: 14px;font-weight: 600;">
				변경 내역
				</div>
				<div class="align-center alignR flex">
					<c:if test="${teamTaskInfo.ManagerID eq sessionScope.loginInfo.sessionUserId}">
						<button class="cmm-btn mgR5" onclick="fnAddNewRow()">Add</button>
						<button class="cmm-btn btn-4265EE mgR5" onclick="fnSaveTeamJob()" id="save">Save</button>
					</c:if>
					<button class="cmm-btn" id="excel">Excel</button>
					<span id="collapseDown" class="cmm_btn" style="background: none;width: 32px;display:none;">
						<i class="mdi mdi-chevron-down" style="font-size: 22px;margin-left: -4px;color:#000;"></i>
					</span>
				</div>
			</div> 
			
			<div id="layout2"></div>
		</div>
		<div id="memberArea" class="pdB20">
		    <div class="flex justify-between mgB7 align-center">
				<div style="color: #193598 !important;font-size: 14px;font-weight: 600;">부서원 Task</div>
				<div>
					<button class="cmm-btn mgR5" id="report">Report</button>
					<c:if test="${teamTaskInfo.ManagerID eq sessionScope.loginInfo.sessionUserId}">
					<button class="cmm-btn mgR5" onclick="fnSaveAll()">Save</button>
					<button class="cmm-btn btn-4265EE" onclick="fnSaveAll('2')">Submit</button>
					</c:if>
				</div>
			</div>
			<div id="layout"></div>
			<div id="reportGrid" style="display:none;"></div>
		</div>
	</div>
</form>
	
	<!-- START :: FRAME --> 		
	<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>
	<div id="inaccessible" class="align-center flex">
	    <div class="align-center flex-column justify-center">
	        <i class="mdi mdi-alert-circle mgB20 mgT40"></i>
	        <p>소속 조직정보를 찾을 수 없습니다.</p>
	    </div>
	</div>
	<script>
		var layout = new dhx.Layout("layout", {
		    rows: [
		        {
		            id: "grid",
		        },
		    ]
		});
		
		var gridData = ${gridData};
		var grid = new dhx.Grid("", {
		    columns: [
		        { width: 40, id: "RNUM", header: [{ text: "No", align:"center" }], align:"center"},
		        { width: 80, id: "Name", header: [{ text: "Name", align:"center" }, { content: "inputFilter" }], align:"center" },
		        { width: 80, id: "Position", header: [{ text: "직위", align:"center" }, { content: "selectFilter" }], align:"center"},
		        { width: 80, id: "EmployeeNum", header: [{ text: "사번", align:"center" }, { content: "inputFilter" }], align:"center"},
		        { width: 90, id: "joinDate", header: [{ text: "입사일자", align:"center" }, { content: "inputFilter" }], align:"center"},
		        { width: 100, id: "ItemName", header: [{ text: "직무", align:"center" }, { content: "selectFilter" }], align:"center"},
		        { id: "Memo", header: [{ text: "과업", align:"center" }, { content: "inputFilter" }]},
		    ],
		    data: gridData,
		    editable: false,
		    resizable: true,
		    tooltip: false,
		    autoWidth: true,
		    autoHeight: true
		});
		
		layout.getCell("grid").attach(grid);
		
		var editedRow = [];
		var ids = new Array();
		
		grid.events.on("cellClick", function(row,column,e){
			if(column.id == "ItemName") {
				var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+row.ItemID+"&scrnType=pop";
		    	var w = 1200;
		    	var h = 900;
		    	itmInfoPopup(url,w,h);
			}
			if("${teamTaskInfo.ManagerID}" == "${sessionScope.loginInfo.sessionUserId}") {
				if(column.id == "Memo") {
					grid.edit(row.id,column.id);
					if(!ids.includes(row.id)) {
						ids.push(row.id);
						editedRow.push(row);
					}
				}
			}
		});

		function fnSaveAll(assignedValue){
			if (editedRow.length != 0 || assignedValue){
				if(confirm("${CM00001}")){
					var jsonData = JSON.stringify(editedRow);
					
					$.ajax({
				        type: "POST",
				        data: {"editedRow" : jsonData, "projectID" : "${projectID}", "teamID" : "${teamID}", "assignedValue" : assignedValue},
				        dataType: "json",
				        url: "editMbrTask.do",
				        async: false,
				        contentType: "application/x-www-form-urlencoded; charset=utf-8",
				        success: function(data) {
				        	alert("${WM00067}");
				        	fnCallBack(data);
				        	editedRow = [];
				        	ids = [];
				        }, error:function(request,status,error){
				        	alert("${WM00068}");
				        }
				    });
				}
			} else {
				return false;
			}
		}
		
		var memoWindow = new dhx.Window({
			title:"부서 과업",
		    width: 1100,
		    height: 450,
		    modal: true,
		    movable: true,
		    resizable: true
		});
		
		function fnOpenPop() {			
			memoWindow.attachHTML( '<textarea id="teamMemo" readonly>'+document.getElementById("teamMemo").value+'</textarea>');
			memoWindow.show();
		}
		
		var reportGrid = new dhx.Grid("reportGrid", {
		    columns: [
		        { width: 100, id: "TeamCode", header: [{ text: "부서코드", align:"center" }], align:"center" },
		        { width: 100, id: "TeamName", header: [{ text: "부서명", align:"center" }], align:"center" },
		        { width: 100, id: "TeamPath", header: [{ text: "조직경로", align:"center" }]},
		        { width: 100, id: "EmployeeNum", header: [{ text: "사번", align:"center" }], align:"center"},
		        { width: 100, id: "userName", header: [{ text: "명칭", align:"center" }], align:"center"},
		        { width: 150, id: "Position", header: [{ text: "직위", align:"center" }], align:"center"},
		        { width: 150, id: "joinDate", header: [{ text: "입사일", align:"center" }], align:"center"},
		        { width: 150, id: "itemName", header: [{ text: "직무", align:"center" }], align:"center"},
		        { width: 150, id: "Memo", header: [{ text: "과업", align:"center" }]},
		    ]
		});
		
		function fnCallBack(newGridData){
			grid.data.parse(newGridData);
		}
		
		function fnExeReport(){
			var date = new Date();
			$.ajax({
		        type: "POST",
		        data: {"projectID" : "${projectID}", "teamID" : "${teamID}"},
		        dataType: "json",
		        url: "getTmMbrTaskList.do",
		        async: true,
		        contentType: "application/x-www-form-urlencoded; charset=utf-8",
		        success: function(data) {
		        	reportGrid.data.parse(data);
					reportGrid.export.xlsx({
						name : "grid_"+date.getTime(),
				        url: "//export.dhtmlx.com/excel"
				    });
					$('#fileDownLoading').addClass('file_down_off');
					$('#fileDownLoading').removeClass('file_down_on');
		        }, error:function(request,status,error){
		        	alert("${WM00068}");
		        }
		    });
		}
		
		var layout2 = new dhx.Layout("layout2", {
		    rows: [
		        {
		            id: "teamGrid",
		        },
		    ]
		});
		
		const teamData = ${teamData};
		const teamGrid = new dhx.Grid("", {
			columns: [
				{ width: 40, id: "RNUM", header: [{ text: "No", align:"center" }], align:"center", editable : false},
				{ width: 80, id: "Activity", header: [{ text: "업무", align:"center" }], align:"center" },
				{ id: "Before", header: [{ text: "변경 전", align:"center" }], align:"left" },
				{ id: "After", header: [{ text: "변경 후", align:"center" }], align:"left"},
				{ width: 60, id: "Type", header: [{ text: "구분", align:"center" }], align:"center",
					editorType: "select",
					options: ["추가", "변경", "이관", "삭제"]
				},
				{ width: 100, id: "RelTeamNM", header: [{ text: "이관부서", align:"center" }], align:"center"},
				{ width: 120, id: "Reason", header: [{ text: "사유", align:"center" }], align:"left"},
		        {
		            id: "action", width: 50, header: [{ text: "", align: "center" }],
		            htmlEnable: true, align: "center",
		            template: function () {
		                return "<span class='action-buttons'><a class='remove-button' style='margin:0;'><i class='mdi mdi-delete'></i></a></span>"
		            }, hidden : true
		        }
			],
		    eventHandlers: {
		        onclick: {
		            "remove-button": function (e, data) {
		            	editTeamLogIDs.forEach((e,i) => {
		            		(e === data.row.id) && editTeamLogIDs.splice(i,1);
		            	});
		            	editTeamLog.forEach((e,i) => {
		            		(e.id === data.row.id) && editTeamLog.splice(i,1);
		            	});
		                fnDeleteTeamJob(data.row.SEQ, data.row.id);
		            }
		        }
		    },
			data: teamData,
			resizable: true,
			tooltip: false,
			autoWidth: true,
			autoHeight: true
		});
		
		layout2.getCell("teamGrid").attach(teamGrid);
		
		if("${teamTaskInfo.ManagerID}" == "${sessionScope.loginInfo.sessionUserId}") {
			teamGrid.showColumn("action");
		}
		
        let max = teamData.length+1;
		function fnAddNewRow(){
			max++;
			teamGrid.data.add({id: "temp"+max, RNUM : "", Activity: "", Before: "", After: "", Type: "", RelTeamNM: "", Reason: ""});
		}
		
		var editTeamLog = [];
		var editTeamLogIDs = new Array();
		teamGrid.events.on("cellClick", function(row,column,e){
			if(column.id != "RNUM") {
				if("${teamTaskInfo.ManagerID}" == "${sessionScope.loginInfo.sessionUserId}") {
					teamGrid.edit(row.id,column.id);
					if(!editTeamLogIDs.includes(row.id)) {
						editTeamLogIDs.push(row.id);
						editTeamLog.push(row);
					}
				}
			}
		});
		
		function fnSaveTeamJob(){
			if (editTeamLog.length != 0){
				for (var i = 0; i < editTeamLog.length; i++) {
					if (editTeamLog[i].Type == "") {
						  alert("${WM00034_1}");
						  teamGrid.selection.setCell(teamGrid.data.getItem(editTeamLog[i].id), teamGrid.config.columns[4]);
						  teamGrid.editCell(editTeamLog[i].id, teamGrid.config.columns[4].id);
						  return false;
					  }
				}
				
				if(confirm("${CM00001}")){
					var jsonData = JSON.stringify(editTeamLog);
					
					$.ajax({
				        type: "POST",
				        data: {"editedRow" : jsonData, "pjtTeamID" : "${pjtTeamID}"},
				        dataType: "json",
				        url: "editTeamJobLog.do",
				        async: false,
				        contentType: "application/x-www-form-urlencoded; charset=utf-8",
				        success: function(data) {
				        	alert("${WM00067}");
				        	fnCallBack2(data);
				        	editTeamLog = [];
				        	editTeamLogIDs = [];
				        }, error:function(request,status,error){
				        	alert("${WM00068}");
				        }
				    });
				}
			} else {
				return false;
			}
		}
		
		function fnCallBack2(newGridData){
			teamGrid.data.parse(newGridData);
		}
		
		function fnDeleteTeamJob(seq, id){
			if(confirm("${CM00004}")){
				teamGrid.data.remove(id);
				if(seq) {
					var url = "deleteTeamJobLog.do";
					var data = "&seq="+seq;
					var target = "saveFrame";
					ajaxPage(url, data, target);	
				}
			}
		}
	</script>
</body>
</html>

