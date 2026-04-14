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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00034" var="CM00034" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00148" var="WM00148" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>

<!-- 2. Script -->
<script type="text/javascript">
var schCntnLayout;	//layout적용

	//조회
	function doSearchList(){
		var sqlID = "config_SQL.getAllocAttrType";
		var param = "evTypeCode=${evTypeCode}"
					+"&category=${category}"
					+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&sqlID="+sqlID;
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

	function fnAddAttr() { //add pop
		var evTypeCode = $("#evTypeCode").val();
		var url = "addEvalAttrAlloc.do?evTypeCode="+evTypeCode;
		var option = "width=820,height=500,left=600,top=100,toolbar=no,status=no,resizable=yes";
		window.open(url, "", option);
	}
	
	function fnDelAttr(){
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){
			alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
		}else{
			if(confirm("${CM00004}")){
				var evTypeCode = $("#evTypeCode").val();
				for(idx in selectedCell){
					var url = "delEvalAttrAlloc.do";
					var data = "evTypeCode="+evTypeCode+"&attrTypeCodes="+selectedCell[idx].AttrTypeCode;
					var i = Number(idx) + 1;
					if (i == selectedCell.length) {
						data = data + "&FinalData=Final";
					}
					var target = "saveDFrame";
					ajaxPage(url, data, target);
					grid.data.remove(selectedCell[idx].id);	
				}
			}
		}
	}

function callBack() {
	doSearchList();
}

</script>

<body>
	<div class="child_search_head cfgtitle">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Attribute Allocation</p>
	</div>
	<form name="attrAllocPopList" id="attrAllocPopList"	action="*" method="post" onsubmit="return false;">
		<input type="hidden" id="evTypeCode" name="evTypeCode" value="${evTypeCode}" /> 
		<input type="hidden" id="category" name="category" value="${category}" /> 

		<div class="mgT10 mgB12" >				
			<li class="floatR mgR20">
				<button class="cmm-btn mgR5" style="height: 30px;"onclick="fnAddAttr()" value="Add">Add Allocation</button>
				<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnDelAttr()" value="Del">Delete</button>
			</li>
		</div>
		<div id="gridDiv" class="mgB10 clear mgL10 mgR10" style="padding-top: 10px;">
			<div id="layout" style="height:550px; width:100%"></div> <!--layout 추가한 부분-->
		</div>
	</form>
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="saveDFrame" id="saveDFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
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
			{ width: 80, id: "AttrTypeCode", header: [{ text: "${menu.LN00015}" , align: "center" }], align: "center",editable: false},
			{ fillspace: true, id: "Name", header: [{ text: "${menu.LN00028}" , align: "center" }], align: "left"},
			{ width: 300, id: "Description", header: [{ text: "${menu.LN00035}" , align: "center" }], align: "left"}
		],
		autoWidth: true,
		resizable: true,
		selection: "row",
		tooltip: false,
		data:gridData
	});

	layout.getCell("a").attach(grid);

	// END ::: GRID	
	//===============================================================================

</script>

</html>