<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00148" var="WM00148" />

<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용

	$(document).ready(function() {
		
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			},
		});	
		
		// 초기 표시 화면 크기 조정
		$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 340)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 340)+"px;");
		};
		
		$("#excel").click(function(){ fnGridExcelDownLoad(); });	
	});
	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	
	//조회
	function doOTSearchList(){
		var sqlID = "config_SQL.getAllSRTypeList";
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
 

//추가(add) 버튼 클릭시
function fnAddSRType(){
	var url = "srTypeDetail.do";
	var data = "&pageNum=" + $("#currPage").val() +"&viewType=N";				
	var target = "srTypeList";	
	ajaxPage(url,data,target);	
}

//삭제(delete) 버튼 클릭시
function fnDelSRType(){
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){
			alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
		}else{
			if(confirm("${CM00004}")){
				for(idx in selectedCell){
					var url = "admin/deleteSRType.do";
					var data = "&SRTypeCode="+selectedCell[idx].SRTypeCode
							  +"&pageNum=" + $("#currPage").val()+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}";	
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

function fnCallBack(){
	doOTSearchList();
}
</script>
</head>
<body>
<div id="srTypeDiv">
	<form name="srTypeList" id="srTypeList" action="" method="post" onsubmit="return false;">	
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input>
	<div class="cfgtitle" >				
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;SR Type List</li>
		</ul>
	</div>	
	<div class="child_search01 mgL10 mgR10">
		<li class="floatR pdR10">
				<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnAddSRType()" value="Add" >Add SR Type</button>
				<button class="cmm-btn mgR5" style="height: 30px;" id="excel" value="Down" >Download List</button>
				<button class="cmm-btn mgR5" style="height: 30px;"onclick="fnDelSRType()" value="Del">Delete</button>
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

<script type="text/javascript">	//그리드7 자바스크립트
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
		var grid = new dhx.Grid("grdOTGridArea", {
			columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
				{ width: 100, id: "SRTypeCode", header: [{ text: "Code" , align: "center" }, { content: "inputFilter" }], align: "center" },
				{ fillspace: true, id: "SRTypeNM", header: [{ text: "Name", align: "center" }, { content: "inputFilter" }], align: "left" },
				{ width: 250, id: "DocCategory", header: [{ text: "${menu.LN00099}", align: "center" }, { content: "selectFilter" }], align: "center" },
				{ width: 200, id: "ItemType", header: [{ text: "${menu.LN00087} ${menu.LN00217}", align: "center" }, { content: "selectFilter" }], align: "center" },
				{ width: 200, id: "ProcModel", header: [{ text: "Process Model", align: "center" }, { content: "inputFilter" }], align: "left" },
				{ width: 100, id: "MenuID", header: [{ text: "MenuID", align: "center" }, { content: "inputFilter" }], align: "center" },
				{ hidden: true, width: 200, id: "VarFilter", header: [{ text: "VarFilter", align: "center" }] },
				{ hidden: true, width: 50, id: "Prefix", header: [{ text: "PreFix", align: "center" }] },
				{ hidden: true, width: 70, id: "MaxSRAreaLvl", header: [{ text: "MaxSRLvl", align: "center" }] },
				{ hidden: true, width: 100, id: "Deactivated", header: [{ text: "Deactivated", align: "center" }] },
				{ hidden: true, width: 70, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align: "center" }] },
				{ hidden: true, width: 70, id: "TS_DocCategory", header: [{ text: "TS_DocCategory", align: "center" }] },
				{ hidden: true, width: 70, id: "ProcModelID", header: [{ text: "ProcModelID", align: "center" }] },
				{ hidden: true, width: 70, id: "DocDomain", header: [{ text: "DocDomain", align: "center" }] },
				{ width: 100, id: "Dimension", header: [{ text: "${menu.LN00088}", align: "center" }, { content: "inputFilter" }], align: "left" },
				{ hidden: true, width: 70, id: "DimTypeID", header: [{ text: "DimTypeID", align: "center" }] },				
				{ hidden: true, width: 100, id: "SRMstCnt", header: [{ text: "SRMstCnt", align: "center" }] },				
				{ hidden: true, width: 70, id: "SRCatCnt", header: [{ text: "SRCatCnt", align: "center" }] },				
				{ hidden: true, width: 70, id: "SRAreaCnt", header: [{ text: "SRAreaCnt", align: "center" }] },				
				{ hidden: true, width: 70, id: "ModelID", header: [{ text: "ModelID", align: "center" }] },				
				{ hidden: true, width: 70, id: "ItemID", header: [{ text: "ItemID", align: "center" }] }		
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
			if(column.id != "checkbox" && column.id != "ProcModel"){
				gridOnRowOTSelect(row);
			}else if(column.id != "checkbox" && column.id == "ProcModel"){
				fnSRModelDtail(row);
			}
		}); 

		function gridOnRowOTSelect(row) {
				var url = "srTypeDetail.do";
				var data = "&SRTypeCode="+ row.SRTypeCode + 
						"&TS_DocCategory="+ row.TS_DocCategory +
						"&languageID=${sessionScope.loginInfo.sessionCurrLangType}" + 
						"&pageNum=" + $("#currPage").val()+
						"&viewType=E";				
				var target = "srTypeList";	
				ajaxPage(url,data,target);	
		}
		
		//Model 프로세스 맵 보이는 버튼 호출
		function fnSRModelDtail(row) {
				var modelID = row.ModelID;
				var s_itemID = row.ItemID;
				
				var url = "popupMasterMdlEdt.do?"
						+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
						+"&s_itemID="+s_itemID
						+"&modelID="+modelID
						+"&scrnType=view";
				
				var w = 1200;
				var h = 900;
				window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		}

		$("#TOT_CNT").html(grid.data.getLength());

		// END ::: GRID	
	//===============================================================================

	

</script>
</html>
