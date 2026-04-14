<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="${menu.LN00032}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="${menu.LN00028}"/>

<script type="text/javascript">

	var p_gridArea;	
<%-- 	var listScale = "<%=GlobalVal.LIST_SCALE%>"; --%>
		
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 250)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 250)+"px;");
		};

		$("#excel").click(function(){
			doExcel();
		});
		
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
	
	function doExcel() {
 		if(confirm("Excel download 를 진행 하시겠습니까?")){
			fnGridExcelDownLoad();
 		}
	} 
	
	function fnOpenCreateDiagram(){	
		var ItemTypeCode = $("#ItemTypeCode").val(); 
		var data = "&ItemTypeCode=";

		$("#divTabDiagramAdd").removeAttr('style', 'display: none');
		$("#newDiagram").removeAttr('style', 'display: none');
		$("#newDiagram").focus();		
		fnSelect('modelTypeCode', data, 'getMDLTypeCode', '', 'Select'); 
	}
	
	function fnCreateDiagram(){
		var newDiagramName = $("#newDiagramName").val();
		var modelTypeCode = $("#modelTypeCode").val();
		
		if(newDiagramName == "") {
			alert("${WM00034}");
			return false;
		} else if(modelTypeCode == "") {
			alert("${WM00025}");
			return false;
		} else {
			if(confirm("${CM00009}")){	
				var url = "createDiagram.do";
				var data = "&modelTypeCode="+$("#modelTypeCode").val()
							+"&newDiagramName="+$("#newDiagramName").val();
				var target = "blankFrame";		
				ajaxSubmit(document.diaFrm, url, target);
			}
		}
	}
	
	function fnDeleteDiagram(){
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox; 
		});
		if(!selectedCell.length){ //배열의 길이가 0   => !FALSE == TRUE
			alert("${WM00023}");
			return;
		} else {
				// 배열의 길이가 하나이상 있음 1 => !TRUE ==FALSE
			if(confirm("${CM00004}")){ 
				var diagramIDs = new Array();
				for(idx in selectedCell){
					diagramIDs[idx] = selectedCell[idx].DiagramID;
				}
 				var url = "deleteDiagram.do";
				var data = "&diagramIDs="+diagramIDs;
				var target = "blankFrame";
				ajaxPage(url, data, target);
			}
		}
		
	}

</script>
</head>
<body>
<div class="pdL10 pdR10 pdT10" style="background:#fff;height:100%;">
<form name="diaFrm" id="diaFrm" action="#" method="post" onsubmit="return false;" >
	<input type="hidden" id="diagramID" name="diagramID" >
	<input type="hidden" id="scrnType" name="scrnType" >
	<input type="hidden" id="autoSave" name="autoSave" value="${autoSave}">

	<div class="child_search" >
		<li class="shortcut"><h3 style="padding: 6px 0"><img src="${root}${HTML_IMG_DIR}/img_folderClosed.png">&nbsp;&nbsp;Diagram List</h3></li>
	</div>
	<div class="countList">
	   	<li class="count">Total  <span id="TOT_CNT"></span></li>
		<li class="floatR pdR20">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<span class="btn_pack nobg white" sytle="width:100%;"><a onclick="fnOpenCreateDiagram();"class="add mgT2 " title="Add"></a></span>
			<span class="btn_pack nobg white" sytle="width:100%;"><a onclick="fnDeleteDiagram();"class="del mgT2 " title="Delete"></a></span>
			</c:if>
			<span class="btn_pack nobg white" sytle="width:100%;"><a id="excel" class="xls mgT2 " title="Excel"></a></span>
		</li>		
	</div>
	<div id="grdGridArea" style="width:100%"></div>
	<!-- START :: PAGING -->
	<div id="pagination"></div>
	<!-- END :: PAGING -->	
	<div id="divTabDiagramAdd" class="ddoverlap" style="display: none;">
		<ul>
			<li class="selected" ><a><span>Create Diagram</span></a></li>
		</ul>
	</div>
	<table id="newDiagram" class="tbl_blue01 mgT5" width="100%"  cellpadding="0" cellspacing="0" style="display: none;">
		<tr>
			<th>${menu.LN00028}</th>
			<th>${menu.LN00032}</th>
			<th></th>
		</tr>
		<tr>
			<td><input type="text" class="text" id="newDiagramName" name="newDiagramName"  value=""/></td>
			<td><select id="modelTypeCode" name="modelTypeCode" class="sel"></select></td>
			<td>
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
					<span class="btn_pack medium icon"><span  class="save"></span><input value="Save" onclick="fnCreateDiagram()"  type="submit"></span>
				</c:if>	
		    </td>
		</tr>	
	</table>
	
	
</form>	
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>
</body>
</html>
<script type="text/javascript">
	
	   // BEGIN ::: GRID
 	var layout = new dhx.Layout("grdGridArea", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	var gridData = ${gridData};
	var grid = new dhx.Grid("grid", {
	    columns:[
	    	
	    	{ width: 40, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", align: "center" }], type: "boolean", align: "center", htmlEnable: true, editable: true, sortable: false},
	    	{ width: 50, id: "RNUM", header: [{ text: "No", align: "center" }], align: "center", htmlEnable: true, editable: true, sortable: false },
	    	{ width: 130, id: "DiagramID", header: [{ text: "DiagramID", align: "center" }], align: "center" },
	    	{ width: 1030, id: "DiagramNM", header: [{ text: "${menu.LN00028}", align: "center" },{ content: "inputFilter" }], align: "center" },
	    	{ width: 250, id: "ModelTypeName", header: [{ text: "${menu.LN00032}", align: "center"}], align: "center" },
	    	{ width: 100, id: "CreatorName", header: [{ text: "${menu.LN00060}", align: "center" }], align: "center" },
	    	{ width: 120, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align: "center" }], align: "center" },
	    	{ width: 80, id: "ItemID", header: [{ text: "ItemID", align: "center" }], align: "left", hidden: true},
	    	{ width: 80, id: "ViewDiagram", header: [{ text: "VIEW", align: "center" }], htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR}/' + row.ViewDiagram + '"  border="0" style="max-height:27px" title="btn_view2.png">';
	            } 
	    	},
	    	{ width: 80, id: "EditDiagram", header: [{ text: "EDIT", align: "center" }], htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR}/' + row.EditDiagram + '"  border="0" style="max-height:27px" title="btn_gedit.png">';
	            } 
	    	},
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData
	});

	grid.events.on("cellClick", function(row, column, e) {
		if (column.id == "ViewDiagram" || column.id == "EditDiagram") {
			$("#newDiagram").attr('style', 'display: none');
			$("#divTabDiagramAdd").attr('style', 'display: none');
			$("#diagramID").val(row.DiagramID);

			if (column.id == "ViewDiagram") { $("#scrnType").val("view"); } else { $("#scrnType").val("edit"); }
			
			var url = "diagramMasterPop.do"; 
			var option = "width=1200, height=700, left=300, top=300,scrollbar=yes,resizble=0";
			window.open("", "diagramMaster", option);
			document.diaFrm.action=url;
			document.diaFrm.target="diagramMaster";
			document.diaFrm.submit();
		}
	});
	
	grid.events.on("filterChange", function(){
	    $("#TOT_CNT").html(grid.data.getLength());
	});
	
	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});

	$("#TOT_CNT").html(grid.data.getLength());
	layout.getCell("a").attach(grid);
	
	function fnCloseCreateDiagram(){	
		$("#divTabDiagramAdd").attr('style', 'display: none');
		$("#newDiagram").attr('style', 'display: none');
	}	
	   
 	function urlReload(){
 		var sqlID = "model_SQL.getDiagramList";
		var param =  "userID=${sessionScope.loginInfo.sessionUserId}"				
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"				
					+ "&sqlID="+sqlID;
 		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadGrid(result);
				
				$("#TOT_CNT").html(grid.data.getLength());
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
 		
 	}	
	
   function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
		fnMasterChk('');
		$("#TOT_CNT").html(grid.data.getLength());
	}	
	
</script>