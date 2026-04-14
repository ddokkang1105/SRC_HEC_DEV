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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

<!-- 2. Script -->
<script type="text/javascript">			
	var skin = "dhx_skyblue";
	
	$(document).ready(function() {		
		
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			},
		});	
		
		$("#excel").click(function(){ fnGridExcelDownLoad(); });	
	});	

	//조회
	function doOTSearchList(){
		var sqlID = "config_SQL.getAllBoardMgtList";
		var param =  "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
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
 		$("#TOT_CNT").html(grid.data.getLength());
 		fnMasterChk('');
 	}

	function fnAddBoardMgt(){
		var url = "boardMgtDetail.do";
		var data = "&pageNum=" + $("#currPage").val() +"&viewType=N";				
		var target = "boardMgtList";	
		ajaxPage(url,data,target);	
	}
	
	function fnDelBoardMgt(){		
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){ //배열의 길이가 0   => !FALSE == TRUE
			alert("${WM00023}");	
		}
		var boardMgtID = new Array;
		var j = 0;
		for(idx in selectedCell){	
			var i = Number(idx) + 1;
			if(i == selectedCell.length){	
				if(selectedCell[idx].checkbox > 0){				
					if(selectedCell[idx].BoardMgtCnt == 0 && selectedCell[idx].BoardCnt == 0){
						boardMgtID[j] = selectedCell[idx].BoardMgtID;
						j++;
					}else{
						alert(selectedCell[idx].BoardMgtName+" ${WM00148}");
						return;
					}			
				}
			}
		}

		var url = "admin/deleteBoardMgt.do";
		var data = "&boardMgtID="+selectedCell[idx].BoardMgtID+"&pageNum=" + $("#currPage").val();
		var target = "saveDFrame";	
		ajaxPage(url,data,target);	
		grid.data.remove(selectedCell[idx].id);
	}
	
	function fnCallBack(){
		doOTSearchList();
	}
	

</script>
<body>
<div id="boardMgtDiv">
	<form name="boardMgtList" id="boardMgtList" action="" method="post" onsubmit="return false;">	
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<div class="cfgtitle" >				
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Board management</li>
		</ul>
	</div>	
	<div class="child_search01 mgL10 mgR10">
		<li class="floatR pdR10">
		    <button class="cmm-btn mgR5" style="height: 30px;" onclick="fnAddBoardMgt()" value="New">New</button>
			<button class="cmm-btn mgR5" style="height: 30px;" value="Down" id="excel">Download List</button>
			<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnDelBoardMgt()" value="Delete">Delete</button>
		</li>
	</div>
	<div class="countList pdL10">
		<li class="count">Total  <span id="TOT_CNT"></span></li>
		<li class="floatR">&nbsp;</li>
 	</div>
	<div id="gridOTDiv" class="mgB10 clear mgL10 mgR10">
		<div id="grdOTGridArea" style="height:360px; width:100%">
			<div style="width: 100%;" id="layout"></div> <!--layout 추가한 부분-->
			<div id="pagination"></div>
		</div>
	</div>
		
	</form>
	</div>
	<iframe name="saveDFrame" id="saveDFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
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
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ width: 50, id: "checkbox", header: [{ text: "" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
				{ width: 150, id: "Level1", header: [{ text: "Group ID" , align: "center" }, { content: "inputFilter" }], align: "center" },
				{ fillspace: true, id: "Level1Name", header: [{ text: "Group Name", align: "center" }, { content: "inputFilter" }], align: "left" },
				{ width: 150, id: "Level2", header: [{ text: "Board ID", align: "center" }, { content: "inputFilter" }], align: "center" },
				{ width: 150, id: "Level2Name", header: [{ text: "Board Name", align: "center" }, { content: "inputFilter" }], align: "center" },
				{ hidden: true, width: 60, id: "BoardTypeCD", header: [{ text: "Board Type", align: "center" }] },
				{ width: 150, id: "BoardTypeName", header: [{ text: "Board Type", align: "center" }, { content: "inputFilter" }], align: "center" },
				{ width: 150, id: "RegDT", header: [{ text: "${menu.LN00013}", align: "center" }, { content: "inputFilter" }], align: "center" },
				{ width: 150, id: "ModUserName", header: [{ text: "${menu.LN00004}", align: "center" }, { content: "inputFilter" }], align: "center" },
				{ hidden: true, width: 70, id: "BoardMgtID", header: [{ text: "BoardMgtID", align: "center" }] },				
				{ hidden: true, width: 100, id: "BoardMgtCnt", header: [{ text: "BoardMgtCnt", align: "center" }] },				
				{ hidden: true, width: 70, id: "BoardCnt", header: [{ text: "BoardCnt", align: "center" }] },				
				{ hidden: true, width: 70, id: "BoardMgtName", header: [{ text: "BoardName", align: "center" }] }						
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data: gridData
		});
		layout.getCell("a").attach(grid);
		$("#TOT_CNT").html(grid.data.getLength());

		//그리드ROW선택시
		grid.events.on("cellClick", function(row,column,e){
			if(column.id != "checkbox"){
				gridOnRowOTSelect(row);
			}
		}); 
	
		function gridOnRowOTSelect(row) { //그리드ROW선택시
			var url = "boardMgtDetail.do";
			var data = "&boardMgtID="+ row.BoardMgtID + 
					"&languageID=${sessionScope.loginInfo.sessionCurrLangType}" + 
					"&pageNum=" + $("#currPage").val()+
					"&viewType=E";				
			var target = "boardMgtList";	
			ajaxPage(url,data,target);
		}
		
</script>

</html>