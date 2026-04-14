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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

<style>
	.input {
		border: 1px solid #ccc;
		color: #000;
		vertical-align: top;
		width: 98%;
		height: 22px;
		border-radius: 3px;
	}
	.tranBtn{
    	background-color: transparent;
    	border: transparent;
		font-size: 12px;
    	font-family: 'Noto Sans KR',sans-serif;
	}
</style>
<!-- 2. Script -->
<script type="text/javascript">			
	var skin = "dhx_skyblue";
	var ids= new Array;
	var codes= new Array;

	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정
		$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 150)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 150)+"px;");
		};

	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
		
	function fnGetEmailForm(data){
		var emailCode = data.EmailCode;
		var url = "editEmailFormPop.do?emailCode="+emailCode;
		window.open(url,'','width=1100, height=590, left=300, top=200,scrollbar=yes,resizble=0');
	}
		
	function fnSaveGridData(data){
		var emailCode = data.EmailCode;
		var name = data.Name;
		var description = data.Description;

		var url = "saveEmailForm.do";
		var data = "emailCode=" + emailCode+"&name="+name+"&description="+description+"&viewType=E";
		var target = "saveDFrame";
		ajaxPage(url, data, target);
	}

	//조회
	function doOTSearchList(){
		var sqlID = "config_SQL.getAllEmailFormList";
		var param =  "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&Category=${Category}" + "&sqlID="+sqlID;
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
 		for(var i=0; i < total; i++){
 			var rowId = grid.data.getId(i);
 			grid.addCellCss(rowId, "Name", "input");
 			grid.addCellCss(rowId, "Description", "input");
 		}
 	}


	function fnCallBack(){
		doOTSearchList();
	}


	function fnAddEmailForm(){
		var url = "addEmailFormPop.do";
		window.open(url,'','width=1100, height=670, left=300, top=200,scrollbar=yes,resizble=0');
		fnCallBack();
	}
	

	function fnDelEmailForm(){
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){ //배열의 길이가 0   => !FALSE == TRUE
			alert("${WM00023}");	
		}else{
			if(confirm("${CM00004}")){
				for(idx in selectedCell){
					var url = "delEmailForm.do";
					var data = "emailCodes="+selectedCell[idx].EmailCode;
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

	function fnSaveAll(){
		var selectedData = grid.data.findAll(function (data) {
			return {
				names: data.Name,
				descriptions: data.Description,
				emailCodes: data.EmailCode
			};
		});
		
		var emailCodes = "";
		var names = "";
		var descriptions = "";
		var hasEmptyName = false;

		for(var i=0;i<selectedData.length;i++){
			if (i > 0) {
				emailCodes += ",";
				names += ",";
				descriptions += ",";
			}
			emailCodes += selectedData[i].EmailCode;
			if (selectedData[i].Name === "") {
				hasEmptyName = true;
				alert("명칭은 비워둘 수 없습니다.");
				break;
			}
			names += selectedData[i].Name;
			if (i === selectedData.length - 1) {
				descriptions += (selectedData[i].Description === "" || selectedData[i].Description === " ") ? " ," : selectedData[i].Description;
			} else {
				descriptions += selectedData[i].Description;
			}
		}

		var url = "saveAllEmailForm.do?emailCodes="+emailCodes+"&names="+names+"&descriptions="+descriptions;
		if (!hasEmptyName && confirm("${CM00001}")) {
			ajaxSubmit(document.emailFormList, url,"saveDFrame");
		}
	}

</script>

<body>
<div id="">
	<form name="emailFormList" id="emailFormList" action="" method="post" onsubmit="return false;">	
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<div class="cfgtitle" >				
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Email Form</li>
		</ul>
	</div>
    <div class="countList">
        <li class="floatR mgR20 pdT5">
        	<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnSaveAll()" value="Save All">Save All</button>
        	<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnAddEmailForm()" value="Add">Add Form</button>
        	<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnDelEmailForm()" value="Del">Delete</button>
		</li>
    </div>
	<div id="gridOTDiv" class="mgB10 clear mgL10 mgR10">
		<div id="grdOTGridArea" style="width:100%"></div>
<!-- 			<div style="width: 100%; height:100%;" id="layout"></div> -->
			<div id="pagination"></div>
		
	</div>	
	</form>
	</div>
	<iframe name="saveDFrame" id="saveDFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>

<script type="text/javascript">	
	//===============================================================================
	// BEGIN ::: GRID
	var layout = new dhx.Layout("grdOTGridArea", { 
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
			{ width: 150, id: "EmailCode", header: [{ text: "${menu.LN00015}" , align: "center" }, { content: "inputFilter" }], align: "center",editable: false},
			{ fillspace: true, id: "Name", header: [{ text: "${menu.LN00028}" , align: "center" }, { content: "inputFilter" }], align: "left"},
			{ width: 180, id: "HTMLForm", header: [{ text: "HTMLForm" , align: "center" },{ content: "inputFilter" }], align: "left" , hidden:true},
			{ fillspace: true, id: "Description", header: [{ text: "${menu.LN00035}" , align: "center" }, { content: "inputFilter" }], align: "left"},
			{
				id: "Config", width: 200, header: [{ text: "Config", align: "center" }],
				htmlEnable: true, align: "center",
				template: function (e, data) {
					if(data.HTMLForm !== undefined && data.HTMLForm !== null && data.HTMLForm !== ""){
						return '<span class="gridBtn small icon mgR10 save"><span class="config"></span><input value="save" type="submit" class="tranBtn"></span>' +
						       '<span class="gridBtn small icon mgR10 html blue" ><span class="config"></span><input value="html" type="submit" class="tranBtn" style="color: #0288D1;"></span>';
					}else{
						return '<span class="gridBtn small icon mgR10 save"><span class="config"></span><input value="save" type="submit" class="tranBtn"></span>' +
						       '<span class="gridBtn small icon mgR10 html" ><span class="config"></span><input value="create" type="submit" class="tranBtn"></span>';
					}
				}
        	}
		],
		eventHandlers: {
        onclick: {
					"save": function (e, data) {
						fnSaveGridData(data.row);
					},
					"html": function (e, data) {
						fnGetEmailForm(data.row);
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