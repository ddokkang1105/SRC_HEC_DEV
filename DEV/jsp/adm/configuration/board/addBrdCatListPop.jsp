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
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	function fnAddBoardMgtAlloc(){		
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){ //배열의 길이가 0   => !FALSE == TRUE
			alert("${WM00023}");	
		}else{
			if(confirm("${CM00012}")){
				for(idx in selectedCell){
					var url = "addBoardMgtCatAlloc.do";
					var data = "&boardMgtID=${boardMgtID}&boardCatgoryCode="+selectedCell[idx].BoardCategoryCode;
					var i = Number(idx) + 1;
					if (i == selectedCell.length) {
						data = data + "&FinalData=Final";
					}	
					var target = "addFrame";
					ajaxPage(url, data, target); 
					grid.data.remove(selectedCell[idx].id);
				}
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
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Add Template</p>
		<div class="floatR pdR20 pdB10">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit"  alt="신규" onclick="fnAddBoardMgtAlloc()" ></span>
			</c:if>
		</div>	
	</div>
	<div id="gridDiv" class="mgB10 mgL5 mgR5 mgT5">
		<div id="grdGridArea" style="width:100%; height: 400px;"></div>
		<div id="pagination"></div>	
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
		var grid = new dhx.Grid("grdOTGridArea", {
			columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ width: 50, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center", htmlEnable: true}], align: "center", type: "boolean", editable: true, sortable: false},
				{ fillspace: true, id: "BoardCategoryCode", header: [{ text: "CategoryCode" , align: "center" }, { content: "inputFilter" }], align: "center" },
				{ fillspace: true, id: "BoardCategoryName", header: [{ text: "CategoryName" , align: "center" }, { content: "inputFilter" }], align: "center" }				
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