<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00034" var="CM00034" />

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
	var Category = "${Category}";
	//조회
	function doOTSearchList(){
		var sqlID;
		if(Category =="ESM"){
			var sqlID = "config_SQL.AllocateEsmFileType";
		}else{
			var sqlID =  "config_SQL.AllocateFileType";;
		}
		var param = "&languageID=${languageID}&ItemClassCode=${ClassCode}"
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
	
	function SaveFileType(){
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){
			alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
		}else{
			if (confirm("${CM00034}")) {    //if (confirm("선택된 항목을 저장하시겠습니까?"))
				var fileTypeCodes = "";
				for (idx in selectedCell) {
					if (fileTypeCodes == "") {
						fileTypeCodes = selectedCell[idx].FltpCode
					} else {
						fileTypeCodes = fileTypeCodes + "," + selectedCell[idx].FltpCode
					}
				}
				
				if(Category =="ESM"){
					var url = "SaveEsmFileType.do";
					var data = "&fileTypeCodes=" + fileTypeCodes
							 + "&s_itemID=${s_itemID}";
				}else{
					var url = "admin/SaveFileType.do";
					var data = "&fileTypeCodes=" + fileTypeCodes
							 + "&ItemClassCode=${ClassCode}";
				}
				var target = "ArcFrame";
				ajaxPage(url, data, target);
				grid.data.remove(selectedCell[idx].id);
			}
		}
	}

	//[save] 이벤트 후 처리
	function selfClose() {
		//var opener = window.dialogArguments;
		opener.doOTSearchList();
		self.close();
	}

</script>
<body>
	<div class="child_search_head">
			<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Add File</p>
	</div>
	
	<form name="AddClassTypeList" id="AddClassTypeList"
		action="*" method="post" onsubmit="return false;">
	<input type="hidden" id="SaveType" name="SaveType" value="Edit" /> 

				<div id="gridDiv" class="mgB10 mgT5 mgL5 mgR5">
				<div id="grdGridArea" style="height:400px; width:100%"></div>
			</div>
		
		<ul>
			<li class="floatR pdR20">
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">					
						<span class="btn_pack medium icon"><span class="save"></span><input value="save" type="submit" onclick="SaveFileType()"></span>
					</c:if>
			</li>
		</ul>
	</form>
		<!-- START :: FRAME -->
		<div class="schContainer" id="schContainer">
			<iframe name="ArcFrame" id="ArcFrame" src="about:blank"
				style="display: none" frameborder="0" scrolling='no'></iframe>
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
			{ width: 100, id: "FltpCode", header: [{ text: "Fltp Code" , align: "center" }], align: "center" },
			{ width: 200, id: "Name", header: [{ text: "Name", align: "center" }], align: "center" },
			{ fillspace: true, id: "FilePath", header: [{ text: "File Path", align: "center" }], align: "center"}
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
