<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root" />
 
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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

<style>
	.varFilMargin {
		margin-top: 38px !important;
	}
</style>

<!-- 2. Script -->
<script type="text/javascript">

	$(document).ready(function() {
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			},
		});	
	});

	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용

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
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
				{ width: 100, id: "ReportCode", header: [{ text: "${menu.LN00015}" , align: "center" }], align: "center" },
				{ width: 100, id: "ReportType", header: [{ text: "Report Type", align: "center" }], align: "center" },
				{ width: 100, id: "OutputType", header: [{ text: "OutPut Type", align: "center" }], align: "center" },
				{ width: 250, id: "Name", header: [{ text: "${menu.LN00028}", align: "center" }], align: "left" },
				{ fillspace: true, id: "Description", header: [{ text: "${menu.LN00035}", align: "center" }], align: "left"},
				{ width: 250, id: "VarFilter", header: [{ text: "VarFilter", align: "center" }] , align: "left"},				
				{ width: 80, id: "SortNum", header: [{ text: "SortNum", align: "center" }], align: "center" }	
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data: gridData
		});
		layout.getCell("a").attach(grid);

		//그리드ROW선택시
		grid.events.on("cellClick", function(row,column,e){
			if(column.id != "checkbox"){
				gridOnRowSelect(row);
			}
		}); 

		//그리드ROW선택시
		function gridOnRowSelect(row){ 
			var reportCode =  row.ReportCode;
			var varFilter = (row.VarFilter ?? "").replace(/&amp;/g, "&");
			var sortNum = row.SortNum;
			$("#reportCode").val(reportCode);
			$("#varFilter").val(varFilter);
			$("#sortNum").val(sortNum);
			$("#varFilterTbl").attr('style', 'visibility:visible;');
			$(".alignBTN").attr('style', 'visibility:visible;');
		}
	
	// END ::: GRID	
	//===============================================================================


	function setSearchTeam(teamID,teamName){
		$('#ownerTeamCode').val(teamID);
		$('#teamName').val(teamName);
	}
		
	//조회
	function doOTSearchList(){
		var sqlID = "config_SQL.getClassReportLocateList";
		var param = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
				  + "&ClassCode=${classCode}&ClassName=${ClassName}"
				  + "&CategoryCode=${CategoryCode}&ItemTypeCode=${ItemTypeCode}&pageNum=${pageNum}"
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
 		fnMasterChk('');
 	}
	
	function AddReportTypeTab(){
		var url = "addReportCodeAlloc.do";
		var data = "&ClassCode=${classCode}" + 
					"&languageID=${languageID}" +
					"&ItemTypeCode=${ItemTypeCode}" +
					//"&ClassName=${ClassName}";
					"&ClassName=" + escape(encodeURIComponent('${ClassName}'));
		url += "?" + data;
		var option = "width=920,height=600,left=300,top=100,toolbar=no,status=no,resizable=yes";
	    window.open(url, self, option);
	}
	
	function DeleteReportType(){		
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){
			alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
		}else{
			if (confirm("${CM00004}")) {
				for (idx in selectedCell) {
					var url = "admin/DeleteReportType.do";
					var data = "&ReportCode=" + selectedCell[idx].ReportCode
							 + "&ClassCode=${classCode}";
					var i = Number(idx) + 1;
					if (i == selectedCell.length) {
						data = data + "&FinalData=Final";
					}
					var target = "ArcFrame";
					ajaxPage(url, data, target);	
					grid.data.remove(selectedCell[idx].id);	
				}
			}
		}
	}
	
	function Back(){
		var url = "ClassTypeView.do";
		var target = "classTypeDiv";
		var data = "&ItemClassCode=${classCode}&LanguageID=${languageID}"
				 + "&CategoryCode=${CategoryCode}&ItemTypeCode=${ItemTypeCode}&pageNum=${pageNum}";
		ajaxPage(url,data,target);
	}
	
	function fnSaveVarFilter(){		
		if(!confirm("${CM00001}")){ return;}		
		var url = "admin/updateReportAllocInfo.do?classCode=${classCode}&classCodeYN=Y"; 
		var target = "ArcFrame";
		ajaxSubmit(document.SubReportTypeList, url, "ArcFrame");
	}
	
	function fnCallBack(){
		$("#varFilterTbl").attr('style', 'visibility:hidden;');
		$("#alignBTN").attr('style', 'visibility:hidden;');
		doOTSearchList();
	}
	
</script>
<body>
	<div id="reportAllocDiv" class="hidden" style="width:100%;height:100%;">	
	<form name="SubReportTypeList" id="SubReportTypeList" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />
		<div class="floatR pdR10 mgB7">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">	
				<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="AddReportTypeTab()"></span>
				<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="DeleteReportType()"></span>			
			</c:if>
		</div>
		<div id="gridDiv" class="mgT10">
			<div id="grdGridArea" style="height:400px; width:100%"></div>
		</div>
		
		<table id="varFilterTbl" class="tbl_blue01 varFilMargin" width="100%"  cellpadding="0" cellspacing="0" style="visibility:hidden;" >
			<tr>
				<th>VarFilter</th>
				<td>
					<input type="text" class="text" id="varFilter" name="varFilter" />
					<input type="hidden" id="reportCode" name="reportCode" >
				</td>
				<th>SortNum</th>
				<td>
					<input type="text" class="text" id="sortNum" name="sortNum" />
				</td>
			</tr>		
		</table>
		<div class="alignBTN" style="visibility:hidden;">
			<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnSaveVarFilter()"  type="submit"></span>&nbsp;
		</div>
	</form>
	</div>
		<!-- START :: FRAME -->
		<div class="schContainer" id="schContainer">
			<iframe name="ArcFrame" id="ArcFrame" src="about:blank"
				style="display: none" frameborder="0" scrolling='no'></iframe>
		</div>
</body>
	
</html>