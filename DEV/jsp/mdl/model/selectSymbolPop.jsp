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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00066" var="CM00066"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00020" var="WM00020"/>


<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;			//그리드 전역변수
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
		
	function fnClickedCheckBox(){
		if ($("input:checkbox[id='defSymSizeCheck']").is(":checked") == true) {
			$("#defSymSize").val("Y");
		}else{
			$("#defSymSize").val("N");
		}
	}
	
</script>

</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>
<body>
<div style="width:98%;" class="pdL10">
<form name="symbolFrm" id="symbolFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" name="SymTypeCode" id="SymTypeCode" >
	<input type="hidden" name="ModelID" id="ModelID" value="${ModelID}" >
	<input type="hidden" name="ItemID" id="ItemID" value="${ItemID}" >
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;Replace symbol</p>
	</div>
    <div class="countList">
        <li class="count">Total  <span id="TOT_CNT"></span></li>
    </div>
    <div id="defaultSize" style="width:100%;height:30px;">
    	<input type="hidden" id="defSymSize" name="defSymSize" value="Y" >&nbsp;
    	<input type="checkbox" id="defSymSizeCheck" name="defSymSizeCheck" onclick="fnClickedCheckBox()" checked>&nbsp;Default symbol size&nbsp;&nbsp;
    </div>	
   	<div style="width:100%; margin-top: 40px;" id="layout"></div>
</form>
</div>
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
	var pagination;
	
	var gridData = ${gridData};
	
	var grid = new dhx.Grid("grid",  {
	    columns: [
	    	
			{ width: 45, id: "RNUM", header: [{ text: "${menu.LN00024}", align:"center"}], align:"center"},
	        { width: 80, id: "ClassName", header: [{ text: "${menu.LN00016}", align:"center" }], align: "center"},
	        { width: 80, id: "SybolIcon", header: [{ text: "${menu.LN00176}", align:"center" }], htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR_MODEL_SYMBOL}/symbol/' + row.SybolIcon + '">';
	            }	        	
	        },
	        { width: 220, id: "SymTypeName", header: [{text: "${menu.LN00169}", align:"center"}], align: "center"},
	        { width: 80, id: "SymTypeCode", header: [{text: "${menu.LN00169}", align:"center"}], align: "center"},
	      
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    multiselection : true   
	    
	});
	
	$("#TOT_CNT").html(grid.data.getLength());

 	grid.events.on("cellClick", function(row,column,e){
		var SymTypeCode = row.SymTypeCode;
		var replaceLinkID = "${ItemID}";
		var defSymSize = $("#defSymSize").val();
		var modelID = "${ModelID}";
		
		if(SymTypeCode == ""){
			alert("${WM00020}"); return;
		}
		
		if (confirm("${CM00001}")) {
			opener.fnRelease(SymTypeCode, replaceLinkID, defSymSize, modelID);
			
			self.close();
		} else {
			alert("${CM00066}");
		}
		
 	 });
	
	 layout.getCell("a").attach(grid);
	 
</script>

</body>
</html>