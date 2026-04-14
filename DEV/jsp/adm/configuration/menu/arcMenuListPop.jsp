<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012" />
<style>
	.dhx_grid-cell {
		color: rgba(0, 0, 0, 0.95);
	}
</style>
<body>
    <div class="title-section">
		Menu
		<span class="floatR btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="fnAdd()"></span>
	</div>
	<div id="gridArea" style="height:490px;"></div>
	<div id="pagination"></div>
	<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none; height:0px;" frameborder="0" scrolling='no'></iframe>
</body>
<script>
	var gridData = ${gridData};
	var grid = new dhx.Grid("gridArea", {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" }], align: "center" },
	        { width: 70, id: "MenuID", header: [{ text: "MenuID" }, { content: "inputFilter" }], align: "center" },
	        { width: 100,  id: "Category", header: [{ text: "Category" }, { content: "selectFilter" }] },
	        { id: "MenuName", header: [{ text: "MenuName" }, { content: "inputFilter" }] },
	        { id: "URL", header: [{ text: "URL" }, { content: "inputFilter" }] }
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    multiselection : true,
	});
	
	function fnAdd(){
		var selectedCell = grid.selection.getCell();
// 		var idx = p_gridArea.getSelectedRowId();
		var menuId = selectedCell.row.MenuID;
		var menuName = selectedCell.row.MenuName;
	
		opener.fnSetMenu(menuId, menuName);
		self.close();
	}
</script>