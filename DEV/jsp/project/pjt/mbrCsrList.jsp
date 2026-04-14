<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00039" var="WM00039"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>

<script type="text/javascript">	
	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 280)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 280)+"px;");
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

	//===============================================================================
	// BEGIN ::: GRID

	var layout = new dhx.Layout("grdGridArea", { 
			rows: [
				{
					id: "a",
				},
			]
		});
	
		var gridData = ${gridData};
		var grid = new dhx.Grid(null, {
			columns: [
				{ hidden: true, width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ hidden: true, width: 30, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
				{ width: 100, id: "ProjectCode", header: [{ text: "${menu.LN00129}" , align: "center" }], align: "left" },
				{ fillspace: true, id: "ProjectName", header: [{ text: "${menu.LN00028}", align: "center" }], align: "left" },
				{ width: 120, id: "ParentName", header: [{ text: "${menu.LN00131}", align: "center"  }], align: "left"},
				{ width: 100, id: "AuthorTeamName", header: [{ text: "${menu.LN00153}", align: "center" }] , align: "center"},				
				{ width: 120, id: "AuthorName", header: [{ text: "${menu.LN00266}", align: "center" }], align: "center" },	
				{ width: 80, id: "CreationTime", header: [{ text: "${menu.LN00013}", align: "center" }], align: "center" },
				{ width: 80, id: "DueDate", header: [{ text: "${menu.LN00062}", align: "center" }], align: "center" },
				{ width: 100, id: "PriorityName", header: [{ text: "${menu.LN00067}", align: "center" }], align: "center" },
				{ width: 150, id: "StatusName", header: [{ text: "${menu.LN00027}", align: "center" }], align: "center" },
				{ hidden: true, id: "WFName", header: [{ text: "", align: "center" }], align: "center" },
				{ hidden: true, id: "CurWFStepName", header: [{ text: "", align: "center" }], align: "center" },
				{ hidden: true, id: "ProjectID", header: [{ text: "", align: "center" }], align: "center" },
				{ hidden: true, id: "ProjectType", header: [{ text: "" }], align: "center", align: "center" },
				{ hidden: true, id: "WFID", header: [{ text: "", align: "center" }], align: "center" },
				{ hidden: true, id: "AuthorID", header: [{ text: "", align: "center" }], align: "center" },
				{ hidden: true, id: "Creator", header: [{ text: "", align: "center" }], align: "center" },
				{ hidden: true, id: "PjtMemberIDs", header: [{ text: "", align: "center" }], align: "center" },
				{ hidden: true, id: "CNGT_CNT", header: [{ text: "", align: "center" }], align: "center" },
				{ hidden: true, id: "Status", header: [{ text: "", align: "center" }], align: "center" },
				{ width: 80, id: "ChangeStatus", header: [{ text: "${menu.LN00139}", align: "center" }], align: "center" },
				{ hidden: true, id: "ParentID", header: [{ text: "", align: "center" }], align: "center" }
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data: gridData
		});
		layout.getCell("a").attach(grid);
		$("#TOT_CNT").html(grid.data.getLength());

		var pagination = new dhx.Pagination("pagination", {
			data: grid.data,
			pageSize: 50,
		});	

		//그리드ROW선택시
		grid.events.on("cellClick", function(row,column,e){
			if(column.id != "checkbox"){
				gridOnPjtRowSelect(row);
			}
		}); 

		// 그리드ROW선택시 : 변경오더 조회 화면으로 이동
		function gridOnPjtRowSelect(row){
			var projectID = row.ProjectID;
			var status = row.Status;
			var pjtCreator = row.Creator
			var authorId = row.AuthorID;
			
			var screenMode = "V";
			var mainMenu = "${mainMenu}";
			var parentID =  row.ParentID;
			var url = "csrDetailPop.do?ProjectID=" + projectID + "&screenMode=" + screenMode + "&mainMenu=" + mainMenu;
					
			var w = 1200;
			var h = 800;
			window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
		}

	// END ::: GRID	
	//===============================================================================

	//조회
	function doSearchPjtList(){
		var sqlID = "project_SQL.getSetProjectListForCsr";
		var param = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
				  + "&memberId=${memberID}"
				  + "&filter=CSR"
				  + "&sqlID="+sqlID;
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadGrid(result);			
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
	}	

	function fnReloadGrid(newGridData){
 		grid.data.parse(newGridData);
 		$("#TOT_CNT").html(grid.data.getLength());
 		fnMasterChk('');
 	}
	
</script>

<div id="gridPjtDiv" style="width:100%;" class="clear mgB10 mgT20" >
	<div id="grdGridArea" ></div>
	<div id="pagination"></div>
</div>
<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
<iframe name="blankFrame" id="blankFrame" style="width:0px;height:0px; display:none;"></iframe>
