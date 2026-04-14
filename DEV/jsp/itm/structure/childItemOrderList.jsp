<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00176" var="WM00176"/>

<script>
	var gridArea;
// 	var dp;
	$(document).ready(function(){	
// 		gridInit();		
		doSearchList();
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function thisReload() {
// 		gridInit();		
		doSearchList();
	}
	
// 	function gridInit(){	
// 		var tcd = setGridData();
// 		gridArea = fnNewInitGrid("grdGridArea", tcd);
// 		gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
// 		gridArea.setIconPath("${root}${HTML_IMG_DIR}/");
// 		gridArea.setColumnHidden(4, true);
// 		gridArea.setColumnHidden(5, true);
		
// 		dp = new dataProcessor("updateChildItemOrder.do?strType=${strType}"); // lock feed url
// 		dp.enableDebug(true);
// 		dp.setTransactionMode("POST",true); // set mode as send-all-by-post
// 		dp.setUpdateMode("off"); // disable auto-update
		
// 		dp.attachEvent("onAfterUpdateFinish", function(){
// 			fnAfterUpdateSendData();
// 		});
		
// 		dp.init(grid); 
// 		dp.styles={
// 			updated:"font-style:italic; color:black;",
// 			inserted:"font-weight:bold; color:green;",
// 			deleted:"font-weight:bold; color:red;",
// 			invalid:"color:orange; text-decoration:underline;",
// 			error:"color:red; text-decoration:underline;",
// 			clear:"font-weight:normal;text-decoration:none;"
// 		};
// 	}
	
	function fnAfterUpdateSendData(){
		alert("${WM00067} ${WM00176}");
		thisReload();
	}
	
	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		// result.key = "item_SQL.getChildItemList";
		result.key = "${sqlKey}";
		result.header = "${menu.LN00024},${menu.LN00106},${menu.LN00028},${menu.LN00016},Order,ItemID,CategoryCode";
		result.cols = "Identifier|ItemName|ClassName|SortNum|ItemID|CategoryCode";
		result.widths = "30,80,250,100,70,70";
		result.sorting = "int,str,str,str,str,str";
		result.aligns = "center,center,left,center,center,center";
		result.data = "s_itemID=${s_itemID}"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";;
		return result;
	}

	function fnMoveRowUp(){
// 		grid.moveRowUp(grid.getSelectedRowId());
		const selectedRow = grid.selection.getCell().row;
		const rowId = selectedRow.id;
		const index = grid.data.getIndex(rowId);
		if (index > 0) {
			grid.data.move(rowId, index - 1);
		}
	}
	
	function fnMoveRowDown(){
// 		grid.moveRowDown(grid.getSelectedRowId());
		const selectedRow = grid.selection.getCell().row;
		const rowId = selectedRow.id;
		const index = grid.data.getIndex(rowId);
		const rowCount = grid.data.getLength();
		if (index < rowCount - 1) {
			grid.data.move(rowId, index + 1);
		}
	}
	
		function fnSaveGridSortNum(){	
			const origRows = grid.data._initOrder // 각 행 데이터 처음 그리드 만들 때의 순서대로 나열한 배열 생성
			const origRowsIds = origRows.map((row)=>{ return row.id }); // 각 행의 id만 추출해 배열 생성
			
			const newRows = grid.data._order // 각 행 데이터 (순서 수정 후) 현재 순서대로 나열한 배열 생성
			const newRowsIds = newRows.map((row)=>{ return row.id }); // 각 행의 id만 추출해 배열 생성
			
			
			const newSortNums = origRowsIds.map((id) => { return newRowsIds.indexOf(id)+1 }) 

			const ids = origRows.map((row) => { return row.RNUM })
			
			if (!confirm("${CM00001}")) return;

			var url = "updateChildItemOrder.do?strType=${strType}"
	
			// 1. 기존 form 복제 및 input에 데이터 있다면 비우기
			var tempForm = document.createElement("form");
			tempForm.method = "post";
		    tempForm.action = url;
		    tempForm.target = "blankFrame";
		    tempForm.style.display = "none"; // 안 보이게
		    	
		    // 2. 그리드 데이터 Form 형태로 가공해줘야 함
	    
		    // ids
		    const idsInput = document.createElement("input");
		    idsInput.name  = "ids"
		    idsInput.type  = "hidden";
		    idsInput.value = ids;
		    tempForm.appendChild(idsInput);
		    
		    // c0 ~ c6
		    origRows.forEach(function(row, index){ // 각 row 순회
		        Object.keys(row).forEach(function(key){
				if (["CategoryCode", "ItemID", "SortNum", "ClassName" , "ItemName", "Identifier", "RNUM"].includes(key)) {
			            var tempInput = document.createElement("input");
			            var index2 = index+1
			            tempInput.type  = "hidden";
			            const tempName =
							key == "CategoryCode" ? "c6" :
							key == "ItemID" ? "c5" :
							key == "SortNum" ? "c4" :
							key == "ClassName" ? "c3" :
							key == "ItemName" ? "c2" :
							key == "Identifier" ? "c1" :
							key == "RNUM" ? "c0" :
							key;
			            tempInput.name  = index2 + "_" + tempName;
			            if (key == "SortNum") {
			            	tempInput.value = newSortNums[index] - 1
			            }
			            else {
			            	tempInput.value =row[key]
			            }
			            tempForm.appendChild(tempInput);
				}

		        });
	   
		    });
		    // 3. DOM에 임시 폼붙이기 (붙어있어야 ajaxSubmit이 동작함)
		    document.body.appendChild(tempForm);
		    const blankFrame = document.getElementById("blankFrame");
			
		    // 4. ajaxSubmit 완료되면 blankFrame이 로드됨. 이게 로드된 후 실행될 함수 정의
		    const afterLoad = () => {
		    	alert("${WM00067} ${WM00176}");
		    	grid.data.removeAll();
				doSearchList();
				blankFrame.onload = null;
				$("#isSubmit").val("false");
		    }
		    
			// 기존 blankframe onload함수 제거해 중복오류 방지
			blankFrame.onload = afterLoad;
			
		 	// submit 실행
		 	ajaxSubmit(tempForm, url, "blankFrame");
		}
</script>	 
</head>
<body>
<form name="childItemList" id="childItemList" action="#" method="post" onsubmit="return false;">
	<div id="processListDiv" class="hidden" style="width:100%;height:100%;">
	<div style="overflow:auto;margin-bottom:5px;overflow-x:hidden;">	
		<div class="msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Change item list Order</div>
			<div class="child_search">
				<li class="floatR pdL55">
					&nbsp;<span class="btn_pack medium icon"><span class="upload"></span><input value="&nbsp;Up" type="submit" id="file" onclick="fnMoveRowUp();"></span>
				    &nbsp;<span class="btn_pack medium icon"><span class="download"></span><input value="&nbsp;Down" type="submit" id="file" onclick="fnMoveRowDown();"></span>
				    &nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" id="file" onclick="fnSaveGridSortNum();"></span>
				</li>			
			</div>
			  
	        <div class="countList">
	              <li class="count">Total  <span id="TOT_CNT"></span></li>
	              <li class="floatR">&nbsp;</li>
	          </div>
			<div id="gridDiv" class="mgB10 clear">
				<div id="grdGridArea" style="height:380px; width:100%"></div>
			</div>
		</div>
	</div>
	</div>
</form>
	
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
</body>
</html>

<script>
var grdGridArea = new dhx.Layout("grdGridArea", {
	rows: [ { id: "a" } ] });

// result.cols = "Identifier|ItemName|ClassName|SortNum|ItemID|CategoryCode";
// result.widths = "30,80,250,100,70,70";

var grid = new dhx.Grid("grdOTGridArea", {
    columns: [
    	{ width: 40, id: "RNUM", header: [{ text: "${menu.LN00024}", align:"center" }], align: "center" },
        { width: 80, id: "Identifier", header: [{ text: "${menu.LN00106}", align:"center" },]},
        { id: "ItemName", header: [{ text: "${menu.LN00028}", align:"center" }] },
        { width: 100, id: "ClassName", header: [{ text: "${menu.LN00016}", align:"center" },], align: "center" },
        { width: 100, id: "CategoryCode", header: [{ text: "CategoryCode", align:"center" }], align: "center" }
        ],
    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    sortable: false
});

grdGridArea.getCell("a").attach(grid);

async function doSearchList(){
	var currentGridData = setGridData();
//		fnLoadDhtmlxGridJson(gridArea, tcd.key, tcd.cols, tcd.data,false,false,"","");
	var param = "";	
	param += currentGridData.data + "&sqlID="+currentGridData.key
	
	$.ajax({
		url:"jsonDhtmlxListV7.do",
		type:"POST",
		data:param,
		success: function(result){
// 			console.log('success');
// 			console.log(result);
			fnReloadGrid(result);
			$('#loading').fadeOut(150);
		},error:function(xhr,status,error){
			console.log("ERR :["+xhr.status+"]"+error);
		}
	});
	
	function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
		$("#TOT_CNT").html(grid.data.getLength());
	}
}
</script>