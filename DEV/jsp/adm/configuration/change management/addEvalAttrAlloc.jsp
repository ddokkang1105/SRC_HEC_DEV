<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<% request.setCharacterEncoding("utf-8"); %>
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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00034" var="CM00034" />

<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용

	function SaveAttrType(){
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if (!selectedCell.length) {
			alert("${WM00023}");
		} else {
			if (confirm("${CM00034}")) {
				var url = "SaveEvalAttrAlloc.do";
				var attrCodes = "";
				for (idx in selectedCell) {
					if (attrCodes == "") {
						attrCodes = selectedCell[idx].AttrTypeCode;
					} else {
						attrCodes += "," +selectedCell[idx].AttrTypeCode;
					}
				}
				
				var target = "ArcFrame";
				var data = "attrCodes=" + attrCodes + "&evTypeCode=${evTypeCode}";
				ajaxPage(url, data, target);
				grid.data.remove(selectedCell[idx].id);	
			}
		}
	}
		
	//[save] 이벤트 후 처리
	function selfClose(evTypeCode) {
		//var opener = window.dialogArguments;
		opener.doSearchList(evTypeCode);
		self.close();
	}

</script>
<body>

	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Add AttributeType</p>
	</div>

	<form name="AddClassTypeList" id="AddClassTypeList"	action="*" method="post" onsubmit="return false;">
		<div id="gridDiv" class="mgB10 mgT5 mgL5 mgR5">
			<div id="layout" style="height:400px; width:100%"></div> <!--layout 추가한 부분-->
		</div>
		<ul>
			<li class="floatR pdR20">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
					<span class="btn_pack medium icon"><span class="save"></span><input value="save" type="submit" onclick="SaveAttrType()"></span>
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

<script type="text/javascript">	
	//===============================================================================
	// BEGIN ::: GRID
	var layout = new dhx.Layout("layout", { 
		rows: [	
			{
				id: "a",
			},
		]
	});

	var gridData = ${gridData};
	var grid = new dhx.Grid(null, {
		columns: [
			{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center"},
			{ width: 50, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center", htmlEnable: true}], align: "center", type: "boolean", editable: true, sortable: false},
			{ width: 100, id: "AttrTypeCode", header: [{ text: "AttrTypeCode" , align: "center" }], align: "center"},
			{ fillspace: true, id: "Name", header: [{ text: "${menu.LN00028}" , align: "center" }], align: "left"},
			{ width: 250, id: "Description", header: [{ text: "${menu.LN00035}" , align: "center" }], align: "left"}
		],
		autoWidth: true,
		resizable: true,
		selection: "row",
		tooltip: false,
		data:gridData
	});
	
	var total = grid.data.getLength();
	layout.getCell("a").attach(grid);

	// END ::: GRID	
	//===============================================================================
</script>

</html>