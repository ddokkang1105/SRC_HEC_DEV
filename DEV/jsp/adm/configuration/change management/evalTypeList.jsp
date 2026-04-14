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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00148" var="WM00148" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>

<style>
	.input {
		border: 1px solid #ccc;
		color: #000;
		vertical-align: top;
		width: 98%;
		height: 22px;
		border-radius: 3px;
	}
	.allocationCss{
		background: #eee;
		border:1px solid #ddd;
		border-radius:5px;
		padding: 1px 7px;
		color: #3F3C3C; 
		margin-right: 5px;
	}
	.saveCss{
		background: #eee;
		border:1px solid #ddd;
		border-radius:5px;
		padding: 1px 7px;
		color: #3F3C3C;
	}
</style>


<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	
	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정
		$("#layout").attr("style","height:"+(setWindowHeight() - 100)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 100)+"px;");
		};
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function fnSaveGridData(data){
		var evTypeCode = data.EvalTypeCode;
		var name = data.Name;
		var description = data.Description;
		
		var url = "saveEvalType.do";
		var data = "evTypeCode=" + evTypeCode+"&name="+name+"&description="+description+"&viewType=E";
		var target = "saveDFrame";
		ajaxPage(url, data, target);
	}
	
	//조회
	function doOTSearchList(){
		var sqlID = "config_SQL.getAllEvalTypeList";
		var param =  "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&Category=${Category}" + "&sqlID="+sqlID;
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadGrid1(result);		
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
	}	
	function fnReloadGrid1(newGridData){
 		grid.data.parse(newGridData);
 		fnMasterChk('');
 	}

	 function fnAlloc(row) { //alloc pop창 함수 
		var evTypeCode = row.EvalTypeCode;
		var url = "attrAllocPop.do";
		var data = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
				 + "&evTypeCode=" + evTypeCode
				 + "&category=EVAL";
		var option = "width=1000,height=600,left=250,top=100,toolbar=no,status=no,resizable=yes";
		url += "?" + data;
		window.open(url, self, option);
	}

	function fnCallBack(){
		$("#allocDiv").attr("style","display:none;");
		doOTSearchList();
	}
	
	function fnAddEvalType(){
		var url = "addEvalTypePop.do";
		window.open(url,'','width=500, height=200, left=300, top=200,scrollbar=yes,resizble=0');
	}
	
	function fnDelEvalType(){
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){
			alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
		}else{
			if(confirm("${CM00004}")){
				var evTypeCodes = "";
				for(idx in selectedCell){
					var url = "delEvalType.do";
					var data = "evTypeCodes="+ selectedCell[idx].EvalTypeCode;
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

</script>
<body>
	<div>
		<form name="emailFormList" id="emailFormList" action="" method="post" onsubmit="return false;">	
		<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
		<input type="hidden" id="evTypeCode" name="evTypeCode" value=""></input> 
		<div class="cfgtitle" >				
			<ul>
				<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Evaluation Type</li>
			</ul>
		</div>
	    <div class="countList">
	        <li class="floatR mgR20">
	        	<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnAddEvalType()" value="Add">Add Evaluation</button>
				<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnDelEvalType()" value="Del">Delete</button>
			</li>
	    </div>
		<div id="gridOTDiv" class="mgB10 clear mgL10 mgR10">
			<div id="layout"></div> <!--layout1 추가한 부분-->
		</div>	
		</form>
	</div>	
	<iframe name="saveDFrame" id="saveDFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
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
			{ width: 80, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center"},
			{ width: 80, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
			{ width: 150, id: "EvalTypeCode", header: [{ text: "${menu.LN00015}" , align: "center" }, { content: "inputFilter" }], align: "center",editable: false},
			{ width: 300, id: "Name", header: [{ text: "${menu.LN00028}" , align: "center" }, { content: "inputFilter" }], align: "left", editable: true},
			{ fillspace: true, id: "Description", header: [{ text: "${menu.LN00035}" , align: "center" },{ content: "inputFilter" }], align: "left", editable: true},
			{
				id: "Config", width: 200, header: [{ text: "Config", align: "center" }],
				htmlEnable: true, align: "center",
				template: function () {
						return '<button class="allocationCss AllBtn">Allocation</button>'
							 + '<button class="saveCss SaveBtn" >Save</button>'
					}
        	}
		],
		eventHandlers: {
        onclick: {
					"AllBtn": function (e, data) {
						fnAlloc(data.row);
					},
					"SaveBtn": function (e, data) {
						fnSaveGridData(data.row);
					}
				},
		},
		editable: true,
		autoWidth: true,
		resizable: true,
		selection: true,
		tooltip: false,
		data:gridData
	});
	
	var total = grid.data.getLength();
	layout.getCell("a").attach(grid);

	for(var i=0; i < total; i++){
		var rowId = grid.data.getId(i);
		grid.addCellCss(rowId, "Name", "input");
		grid.addCellCss(rowId, "Description", "input");
	}

	// END ::: GRID
	//===============================================================================
	
</script>


</html>