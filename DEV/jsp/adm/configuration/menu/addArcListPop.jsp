<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%
	request.setCharacterEncoding("utf-8");
%>
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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00034" var="CM00034" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012" />

<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용

	//조회
	function doOTSearchList(){
		var sqlID = "config_SQL.getArcTreeList";
		var param = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&arcCode=${ArcCode}"
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

	function fnSaveArc() {
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){ //배열의 길이가 0   => !FALSE == TRUE
			alert("${WM00023}");	
		}
		var arcArr = new Array;
		for (idx in selectedCell) { 
			arcArr.push(selectedCell[idx].ArcCode);
		}
		
		if(confirm("${CM00012}")){
			var url = "updateParentArc.do";
			var data = "arcCode=" + arcArr + "&parentArcCode=${ArcCode}"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
			var target = "ArcFrame";
			ajaxPage(url, data, target);
		}
	}

	function fnCallBack() {
		opener.doOTSearchList();
		self.close();
	}
</script>
<body>
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Add Architecture</p>
	</div>
	<form name="AddClassTypeList" id="AddClassTypeList" action="*" method="post" onsubmit="return false;">
		<div id="gridDiv" class="mgB10">
			<div id="grdGridArea" style="height: 400px; width: 100%"></div>
		</div>
		<ul>
			<li class="floatR pdR20">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
					<span class="btn_pack medium icon"><span class="save"></span>
					<input value="save" type="submit" onclick="fnSaveArc()"></span>
				</c:if>
			</li>
		</ul>
	</form>
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="ArcFrame" id="ArcFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
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
		var grid = new dhx.Grid("grdGridArea", {
			columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
				{ width: 80, id: "SortNum", header: [{ text: "SortNum" , align: "center" }], align: "center" },
				{ width: 100, id: "ArcCode", header: [{ text: "ArcCode", align: "center" }], align: "center" },
				{ fillspace: true, id: "ArcName", header: [{ text: "ArcName", align: "center" }], align: "center" }
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