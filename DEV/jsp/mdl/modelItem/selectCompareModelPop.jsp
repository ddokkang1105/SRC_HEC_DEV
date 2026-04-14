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

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00042" var="WM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="2 Models"/>


<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;	
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 200)+"px; width:100%;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 200)+"px; width:100%;");
		};
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	function doGetCompareModelList(){
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(selectedCell.length != 2){
			alert("${WM00025}");
			return false;
		} else {
			var url = "compareModel.do?s_itemID=${ItemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&modelID1="+selectedCell[1].ModelID+"&modelID2="+selectedCell[0].ModelID;
			var w = 1000;
			var h = 600;
			window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		}
		fnMasterChk('');
		self.close();
	}
	
</script>

</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>
<body style="width:100%;">
<form name="symbolFrm" id="symbolFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" name="SymTypeCode" id="SymTypeCode" >
	<input type="hidden" name="ModelID" id="ModelID" value="${ModelID}" >
	<input type="hidden" name="ItemID" id="ItemID" value="${ItemID}" >
	
		<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00127}</p>
	</div>
	<div>
   		<div class="alignR mgT5 mgB5 mgR5">	
		<span class="btn_pack small icon"><span class="report"></span><input value="Report" type="submit" onclick="doGetCompareModelList()" ></span>
		</div>
    </div>
	<div style="width:100%;" id="layout"></div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
		
<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid;
	
	var gridData = ${gridData};
	
	var grid = new dhx.Grid("grid",  {
	    columns: [
			{ width: 45, id: "RNUM", header: [{ text: "${menu.LN00024}", align:"center"}], align:"center"},
	        { width: 50, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", align:"center", htmlEnable: true }], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 80, id: "ModelID", header: [{ text: "Model No.", align:"center" }], align: "center"},
	        { width: 80, id: "Version", header: [{ text: "Version", align:"center" }], align: "center"},
	        { width: 380, id: "Name", header: [{text: "${menu.LN00028}", align:"center"}], align: "center"},
	        { width: 80, id: "MTCategory", header: [{text: "${menu.LN00033}", align:"center"}], align: "center"},
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    multiselection : true   
	    
	});
	
	layout.getCell("a").attach(grid);
	 
</script>

</body>
</html>