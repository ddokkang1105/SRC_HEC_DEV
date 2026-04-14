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
		
		// 초기 표시 화면 크기 조정
		$("#layout").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		};
		
		fnSelect('SRTypeCode', '', 'getSRTypeCode', '', 'Select');
		$("#excel").click(function(){ fnGridExcelDownLoad(); });	
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;};
	

	//조회
	function doOTSearchList(){
		var sqlID = "config_SQL.getAllSRCatMgtList";
		var SRTypeCode = $("#SRTypeCode").val();
		var param =  "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
				   + "&SRType="+SRTypeCode
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

	function fnAddSRCategory(){
		var url = "srCatDetail.do";
		var data = "&pageNum=" + $("#currPage").val() +"&viewType=N";				
		var target = "srCategoryList";	
		ajaxPage(url,data,target);	
	}
	
	function fnDelSRCategory(){		
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){ //배열의 길이가 0   => !FALSE == TRUE
			alert("${WM00023}");	
		}
		var srCatID = new Array;
		var j = 0;
		for(idx in selectedCell){
			var i = Number(idx) + 1;
			if (i == selectedCell.length) {
				if(selectedCell[idx].checkbox > 0){		
					if(selectedCell[idx].SRCatCnt == 0 && selectedCell[idx].SRMstCnt == 0){
						srCatID[j] = selectedCell[idx].SRCatID;
						j++;
					}else{
						alert(selectedCell[idx].SRCatID+" ${WM00148}");
						return;
					}
				}
			}
		}		
		var url = "admin/deleteSRCat.do";
		var data = "&srCatID="+selectedCell[idx].SRCatID+"&pageNum=" + $("#currPage").val();	
		var target = "saveDFrame";	
		ajaxPage(url,data,target);	
		grid.data.remove(selectedCell[idx].id);
	}
	
	function fnCallBack(){
		doOTSearchList();
	}
</script>

<body>
<div id="srCategoryDiv">
	<form name="srCategoryList" id="srCategoryList" action="" method="post" onsubmit="return false;">	
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<div class="cfgtitle" >				
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;SR Category management</li>
		</ul>
	</div>	
	<div class="child_search01 mgL10 mgR10">
		<li class="pdL10">
			SR Type
			<select id="SRTypeCode" name="SRTypeCode" onchange="doOTSearchList()" style="width:120px;margin-left:5px;">
			</select>
		</li>
		<li class="floatR pdR10">
			<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnAddSRCategory()"  value="Add" >Add SR Category</button>
			<button class="cmm-btn mgR5" style="height: 30px;" id="excel" value="Down">Download List</button>
			<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnDelSRCategory()"  value="Del">Delete</button>
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

<script type="text/javascript">// BEGIN ::: GRID

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
					{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
					{ width: 50, id: "checkbox", header: [{ text: "" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
					{ width: 90, id: "SRType", header: [{ text: "SR Type" , align: "center" }, { content: "selectFilter" }], align: "center" },
					{ width: 90, id: "Level1", header: [{ text: "Category ID" , align: "center" }, { content: "selectFilter" }], align: "center" },
					{ width: 120, id: "Level1Name", header: [{ text: "Category Name", align: "center" }, { content: "selectFilter" }], align: "center" },
					{ width: 120, id: "Level2", header: [{ text: "Sub Category ID", align: "center" }, { content: "selectFilter" }], align: "center" },
					{ width: 130, id: "Level2Name", header: [{ text: "Sub Category Name", align: "center" }, { content: "selectFilter" }], align: "center" },
					{ width: 120, id: "ItemTypeCodeNM", header: [{ text: "${menu.LN00021}", align: "center" }, { content: "selectFilter" }], align: "center" },
					{ width: 120, id: "SRAreaName", header: [{ text: "Receiver level", align: "center" }, { content: "selectFilter" }], align: "center" },
					{ width: 100, id: "RoleTypeTxt", header: [{ text: "1st Receiver", align: "center" }, { content: "selectFilter" }], align: "center" },
					{ fillspace: true, id: "ProcModelName", header: [{ text: "Process Path", align: "center" }, { content: "selectFilter" }], align: "center" },
					{ hidden: true, width: 80, id: "ProcessType", header: [{ text: "Process Type" }] },
					{ width: 100, id: "ModDT", header: [{ text: "${menu.LN00070}", align: "center" }, { content: "selectFilter" }], align: "center" },
					{ width: 80, id: "ModUserName", header: [{ text: "${menu.LN00105}", align: "center" }, { content: "selectFilter" }], align: "center" }, 
					{ hidden: true, width: 80, id: "SRCatID", header: [{ text: "CategoryID", align: "center" }] },				
					{ hidden: true, width: 80, id: "SRCatCnt", header: [{ text: "CategoryCnt", align: "center" }] },				
					{ hidden: true, width: 70, id: "SRCatName", header: [{ text: "Category Name", align: "center" }] },				
					{ hidden: true, width: 70, id: "SRMstCnt", header: [{ text: "SRMasterCnt", align: "center" }] }				
				],
				autoWidth: true,
				resizable: true,
				selection: "row",
				tooltip: false,
				data: gridData
			});
			layout.getCell("a").attach(grid);
			$("#TOT_CNT").html(grid.data.getLength());

			var pagination = new dhx.Pagination("pagination", {
				data: grid.data,
				pageSize: 15,
			});	
		
			//그리드ROW선택시
			grid.events.on("cellClick", function(row,column,e){
				if(column.id != "checkbox"){
					gridOnRowOTSelect(row);
				}
			}); 
		
			function gridOnRowOTSelect(row) { //그리드ROW선택시
				var url = "srCatDetail.do";
				var data = "&srCatID="+ row.SRCatID + 
						"&languageID=${sessionScope.loginInfo.sessionCurrLangType}" + 
						"&pageNum=" + $("#currPage").val()+
						"&viewType=E";				
				var target = "srCategoryList";	
				ajaxPage(url,data,target);
			}
</script>


</html>