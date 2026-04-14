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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>

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

	//조회
	function doOTSearchList(){
		var sqlID = "config_SQL.getReportMgtList";
		var param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&templCode=${templCode}"
			      + "&templCode=${templCode}"
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

	
	function fnAddReport(){		
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){
			alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
		}else{
			if(confirm("${CM00012}")){
				var reportCode = new Array();
				var j = 0;
				for (idx in selectedCell) {
					reportCode[j] = selectedCell[idx].ReportCode;
					j++;
				}
				var url = "admin/addReportAllocMgt.do";
				var data = "&reportCode="+reportCode+"&templCode=${templCode}&projectID=${projectID}";
				var target = "addFrame";
				ajaxPage(url, data, target); 
				grid.data.remove(selectedCell[idx].id);
			}
		}
	}
	
	function fnCallBack(){
		opener.fnCallBack();
		self.close();
	}
	
</script>
<body>
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Add Report</p>
	</div>
	<div id="gridDiv" class="mgB10 mgT5 mgL5 mgR5">
	<div id="grdGridArea" style="height:380px; width:100%"></div>
	</div>
	<div class="floatR pdR20 pdB10">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit"  alt="신규" onclick="fnAddReport()" ></span>
		</c:if>
	</div>	
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="addFrame" id="addFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
</body>

<script type="text/javascript">	//그리드 자바스크립트

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
			{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
			{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
			{ width: 90, id: "ReportCode", header: [{ text: "ReportCode" , align: "center" }], align: "center" },
			{ fillspace: true, id: "ReportName", header: [{ text: "ReportName", align: "center" }], align: "left" }
		],
		autoWidth: true,
		resizable: true,
		selection: "row",
		tooltip: false,
		data: gridData
	});
	layout.getCell("a").attach(grid);

// END ::: GRID	
//===============================================================================

</script>

</html>