<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/> 

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>

<style type="text/css">
div.gridbox_dhx_web table.obj tr td{
    height: 17px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    max-width: 150px;
    max-height: 100px;
}

</style>

<!-- 2. Script -->
<script type="text/javascript">
	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 260)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 260)+"px;");
		};

	});		

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	//===============================================================================
	// BEGIN ::: GRID

	var layout = new dhx.Layout("grdGridArea", { 
			rows: [
				{
					id: "a",
				},
			]
		});

	var gridData = ${gridData};
	var grid = new dhx.Grid("grdGridArea", {
		columns: [
			{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
			{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
			{ width: 100, id: "DimTypeName", header: [{ text: "${menu.LN00088}" , align: "center" }, { content: "selectFilter" }], align: "center" },
			{ width: 100, id: "DimValueID", header: [{ text: "Code", align: "center" }, { content: "selectFilter" }], align: "center" },
			{ width: 200, id: "DimValueName", header: [{ text: "Value", align: "center" }, { content: "inputFilter" }], align: "center" },
			{ hidden: true, width: 100, id: "DimTypeID", header: [{ text: "DimTypeID", align: "center" }], align: "center" },
			{ fillspace : true, id: "DescAbrv", header: [{ text: "Description", align: "center", colspan:"2" }, { content: "inputFilter" }], align: "left" },
			{ width: 50, id: "ImgView", header: [{ text: "View Detail", align:"center" }], htmlEnable: true, align: "center",
				template: function (text, row, col) {
					return '<img src="${root}${HTML_IMG_DIR}/'+row.ImgView+'" width="25" height="25">';
					}
			}
		],
		autoWidth: true,
		resizable: true,
		selection: "row",
		tooltip: true,	
		data: gridData
	});
	layout.getCell("a").attach(grid);
	$("#TOT_CNT").html(grid.data.getLength());

	//그리드ROW선택시
	grid.events.on("cellClick", function(row,column,e){
		if(column.id != "checkbox" && column.id == "ImgView"){
			gridOnRowSelect(row);
		}
	}); 

	//그리드ROW선택시
	function gridOnRowSelect(row){
		var dimTypeId = row.DimTypeID;
		var dimValueId = row.DimValueID;
		var url = "viewItemDimDesc.do";
		var data = "?s_itemID=${s_itemID}&dimValueId=" + dimValueId+"&dimTypeId="+dimTypeId;
		window.open(url+data,'window','width=500, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}

	// END ::: GRID	
	//===============================================================================

	//조회
	function doSearchList(){
		var sqlID = "dim_SQL.selectDim";
		var param = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&s_itemID=${s_itemID}"
					+ "&sqlID="+sqlID;

		if($("#dimTypeId").val() != '' & $("#dimTypeId").val() != null){
			param += "&dimTypeId="+ $("#dimTypeId").val();
		}

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

	// [Assign] click 이벤트	
	function assignOrg(){
		var url = "dimAssignTreePop.do";
		var data = "s_itemID=${s_itemID}";
		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}
	function doCallBack(){}
	
	// [Assign popup] Close 이벤트
	function assignClose(){
		doSearchList();
	}
	
	// [Del] Click
	function delDimension() {
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){ //배열의 길이가 0   => !FALSE == TRUE
			alert("${WM00023}");	
		}else{
			if(confirm("${CM00004}")){
				var dimValueIds =""; 
				var dimTypeIds =""; 
				for(idx in selectedCell){
					if (dimTypeIds == "") {
						dimTypeIds = selectedCell[idx].DimTypeID;
						dimValueIds = selectedCell[idx].DimValueID;
					} else {
						dimTypeIds = dimTypeIds + "," + selectedCell[idx].DimTypeID;
						dimValueIds = dimValueIds + "," + selectedCell[idx].DimValueID;
					}
				}
				
				var url = "delDimensionForItem.do";
				var data = "s_itemID=${s_itemID}&dimTypeIds="+dimTypeIds+"&dimValueIds=" + dimValueIds;
				var target = "blankFrame";
				ajaxPage(url, data, target);			
			}
		}	
	}

	
	// [Back] click
	function goBack() {
		var url = "NewItemInfoMain.do";
		var target = "actFrame";
		var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}"; 
		ajaxPage(url, data, target);
	}
	
</script>
<div>
	<div class="child_search">
	<span class="flex align-center">
			<span class="back" onclick="goBack()"><span class="icon arrow"></span></span>
	  <b>${menu.LN00088}</b>
	  </span>
	</div>
	<div class="countList">
		<li class="count">Total  <span id="TOT_CNT"></span></li>
	    <li class="floatR">&nbsp;</li>
	   <li class="floatR pdR10">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor' and myItem == 'Y'}">
				<span class="btn_pack nobg"><a class="assign" onclick="assignOrg();" title="Assign"></a></span>
				<span class="btn_pack nobg white"><a class="del" onclick="delDimension();" title="Delete"></a></span>
			</c:if>
			<c:if test="${backBtnYN != 'N'}" >
		
			</c:if>
		</li>	
	</div>
	
	<div id="gridDiv" class="mgB10 clear">
		<div id="grdGridArea" style="width:100%"></div>
	</div>		
	
</div>	
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>	
