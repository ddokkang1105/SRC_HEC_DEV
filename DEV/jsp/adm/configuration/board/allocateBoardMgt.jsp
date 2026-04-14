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

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용

	
	function fnAddBrdCat(){
		var url = "addBrdCatListPop.do?languageID=${languageID}&boardMgtID=${boardMgtID}";
		var w = 400;
		var h = 400;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	// function fnDeleteBoardMgtCatAlloc(){
	// 	var selectedCell = grid.data.findAll(function (data) {
	// 		return data.checkbox; 
	// 	});
	// 	if(!selectedCell.length){ //배열의 길이가 0   => !FALSE == TRUE
	// 		alert("${WM00023}");	
	// 	}
	// 	for(idx in selectedCell){
	// 		var url = "deleteBoardMgtCatAlloc.do";
	// 		var data = "&boardCategoryCode="+selectedCell[idx].CategoryCode+"&boardMgtID=${boardMgtID}&languageID=${languageID}&pageNum=${pageNum}";
	// 		var i = Number(idx) + 1;
	// 		if (i == selectedCell.length) {
	// 			data = data + "&FinalData=Final";
	// 		}	
	// 		if(confirm("${CM00004}")){
	// 			var target = "saveFrame";
	// 			ajaxPage(url, data, target);	
	// 			grid.data.remove(selectedCell[idx].id);
	// 		}
	// 	}
	// }

	function fnDeleteBoardMgtCatAlloc(){
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){
			alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
		}else{
			if(confirm("${CM00004}")){
				for(idx in selectedCell){
					var url = "deleteBoardMgtCatAlloc.do";
					var data = "&boardCategoryCode="+selectedCell[idx].CategoryCode+"&boardMgtID=${boardMgtID}&languageID=${languageID}&pageNum=${pageNum}";
					var i = Number(idx) + 1;
					if (i == selectedCell.length) {
						data = data + "&FinalData=Final";
					}
					var target = "saveFrame";
					ajaxPage(url, data, target);
					grid.data.remove(selectedCell[idx].id);	
				}
			}
		}
	}

	
	function fnGoBack(){
		var url = "boardMgtDetail.do";
		var target = "boardMgtDiv";
		var data = "&boardMgtID=${boardMgtID}&pageNum=${pageNum}&languageID=${languageID}&viewType=${viewType}";	
		ajaxPage(url,data,target);
	}
	
	function fnSaveStNum(){
		if(confirm("${CM00001}")){
			var sortNum = $("#sortNum").val();
			var categoryCode = $("#categoryCode").val();
			var url = "updateBoardMgtCatAllocStNum.do";
			var data = "&boardMgtID=${boardMgtID}&categoryCode="+categoryCode+"&sortNum="+sortNum+"&pageNum=${pageNum}&languageID=${languageID}"; 
			var target = "saveFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnCallBack(){ 
		$("#editStNum").attr('style', 'display: none');	
		$("#divSaveStNum").attr('style', 'display: none');
		$("#sortNum").val("");
		$("#categoryCode").val("");
		thisReload();
	}

	function thisReload(){
		var sqlID = "config_SQL.getBoardCatAllocList";
		var param =  "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&boardMgtID=${boardMgtID}"
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
	
</script>
</head>
<body>
	<form name="allocBoardMgt" id="allocBoardMgt" action="*" method="post" onsubmit="return false;">
	<div class="cfgtitle">
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Board Management Allocation</li>
		</ul>
	</div>
	<div class="child_search mgL10 mgR10">	
		<li class="floatR pdR20">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="submit" onclick="fnGoBack()"></span>		
				<span class="btn_pack medium icon"><span class="add"></span><input value="Add" type="submit" onclick="fnAddBrdCat()"></span>
				<span class="btn_pack medium icon"><span class=del></span><input value="Del" type="submit" onclick="fnDeleteBoardMgtCatAlloc()"></span>
			</c:if>
		</li>		
	</div>
	<div id="gridDiv" class="mgT10  mgL10 mgR10">
		<div id="grdGridArea" style="height:300px; width:100%">
			<div style="width: 100%; height:100%;" id="layout"></div> <!--layout 추가한 부분, 자꾸 안보여서 아예 height를 줌-->
			<div id="pagination"></div>
		</div>
	</div>
	<div class="mgT10 mgL10 mgR10">

	<table id="editStNum" class="tbl_blue01" width="100%"   cellpadding="0" cellspacing="0" style="display: none;">
		<tr>
			<th>SortNum</th>
			<td class="last">
				<input type="text" id="sortNum" name="sortNum" class="text" value="" />
				<input type="hidden" id="categoryCode" name="categoryCode" value=""/>
			</td>
		</tr>
	</table>

	</div>
	<div  class="alignBTN" id="divSaveStNum" style="display: none;">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<span class="btn_pack medium icon"><span  class="save"></span><input value="Save" onclick="fnSaveStNum()"  type="submit"></span>
		</c:if>		
	</div>
	</form>
		<!-- START :: FRAME -->
		<div class="schContainer" id="schContainer">
			<iframe name="saveFrame" id="saveFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
		</div>
</body>
<script type="text/javascript">	//그리드 자바스크립트
	var layout = new dhx.Layout("layout", { 
			rows: [
				{
					id: "a",
				},
			]
		});
	
		var gridData = ${gridData};
		var grid = new dhx.Grid("grdOTGridArea", {
			columns: [
				{ width: 80, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ width: 80, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
				{ fillspace: true, id: "CategoryCode", header: [{ text: "CategoryCode" , align: "center" }, { content: "inputFilter" }], align: "center" },
				{ fillspace: true, id: "CategoryName", header: [{ text: "CategoryName" , align: "center" }, { content: "inputFilter" }], align: "center" },
				{ width: 150, id: "SortNum", header: [{ text: "SortNum", align: "center" }, { content: "inputFilter" }], align: "center" }					
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data: gridData
		});
		layout.getCell("a").attach(grid);

		//그리드ROW선택시
		grid.events.on("cellClick", function(row,column,e){
			if(column.id != "checkbox"){
				gridOnRowOTSelect(row);
			}
		}); 
	
		function gridOnRowOTSelect(row) { //그리드ROW선택시
			$("#editStNum").attr('style', 'display: block');	
			$("#editStNum").attr('style', 'width: 100%');	
			$("#divSaveStNum").attr('style', 'display: block');	
			$("#sortNum").val(row.SortNum);
			$("#sortNum").focus();
			$("#categoryCode").val(row.CategoryCode);	
		}

</script>

</html>