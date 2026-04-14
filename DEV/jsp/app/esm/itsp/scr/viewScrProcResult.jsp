<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 600)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 600)+"px;");
		};
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
</script>
<div id="viewScrDiv">
	<form name="scrResultFrm" id="scrResultFrm" action="#" method="post" onsubmit="return false;">
		<div class="floatC" style="overflow:auto;overflow-x:hidden;">
			<c:if test="${scrUserID eq sessionScope.loginInfo.sessionUserId && scrStatus eq 'APREL'}">
			<div class="floatR mgR10 mgB10">
				<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="submit" onclick="fnEditScrResult()"></span>
			</div>
			</c:if>
			<table class="cb_module tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
				<colgroup>
					<col width="15%">
					<col width="35%">
					<col width="15%">
					<col width="35%">
				</colgroup>
				<tr>
					<th class="alignL pdL10 viewline">종료코드</th>
					<td class="pdL10">${scrInfo.ClosingCodeName}</td>
					<th class="alignL pdL10 viewline">실제투입공수(M/D)</th>
					<td class="pdL10 viewline last">${scrInfo.ActualManDay}</td>
				</tr>
				<tr>
					<th class="alignL pdL10 viewline">처리내용</th>
					<td colspan=3 class="last"><textarea style="width:100%;height:50px;background: #fff;" readOnly="true">${scrInfo.ChangeNotice}</textarea></td>
				</tr>
			</table>
			<div class="mgT10">
				<h3 class="mgL10" style="padding: 6px 0;">실제투입인력</h3>
				<div id="layout" style="width:100%;"></div>
			</div>
		</div>
	</form>
</div>

<script type="text/javascript">
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var gridData = ${gridData};
	var grid = new dhx.Grid("grdOTGridArea", {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center", editable:false },
	        { width: 50, id: "checkbox", header: [{ text: "" }], align: "center", type: "boolean",  editable: true},
	        { width: 120, id: "UserName", header: [{ text: "Name" , align: "center" }, { content: "inputFilter" }], align: "center", editable:false },
	        { width: 120, id: "Position", header: [{ text: "Position" , align: "center" }, { content: "selectFilter" }], align: "center", editable:false },
	        { id: "TeamPath", header: [{ text: "${menu.LN00202}" , align: "center" }], align: "center", editable:false },
	        { hidden: true, id: "MemberID", header: [{ text: "MemberID" , align: "center" }], align: "center" },
	        { hidden: true,id: "CNT", header: [{ text: "CNT" , align: "center" }], align: "center" },
	        { width: 120, id: "ActualManDay", header: [{ text: "공수(M/D)" , align: "center" }], align: "center"},
	        { width: 200, id: "RoleDescription", header: [{ text: "업무설명" , align: "center" }], align: "center" },
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    multiselection: true,
	    tooltip: false,
	    data: gridData
	});
	layout.getCell("a").attach(grid);
	
	//filer search 시 total 값 변경
	grid.events.on("filterChange", function(value,colId,filterId){
		$("#TOT_CNT").html(grid.data.getLength());
	});

	$("#TOT_CNT").html(grid.data.getLength());

	function doSearchList(){
		var sqlID = "scr_SQL.getSCRMbrRoleList";
		var param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&scrId=${scrId}"
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
	}
	
	function fnEditScrResult(){
		var url = "editScrProcResult.do";
		var data = "scrId=${scrId}"
		var target = "viewScrDiv";
		ajaxPage(url, data, target);
	}
</script>