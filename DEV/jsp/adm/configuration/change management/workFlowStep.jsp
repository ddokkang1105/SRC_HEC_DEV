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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

<!-- 2. Script -->
<script type="text/javascript">

var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용

$(document).ready(function() {	
	
	$.ajaxSetup({
		headers: {
			'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
		},
	});
	
	// 초기 표시 화면 크기 조정
	$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 160)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 160)+"px;");
	};
	$("#excel").click(function(){fnGridExcelDownLoad();})
});	
function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
function setOTLayout(type){
	if( schCntnLayout != null){
		schCntnLayout.unload();
	}
	schCntnLayout = new dhtmlXLayoutObject("schContainer",type, skin);
	schCntnLayout.setAutoSize("b","a;b"); //가로, 세로		
	schCntnLayout.items[0].setHeight(350);
}

//조회
function doOTSearchList(){
	var sqlID = "config_SQL.workFlowStep";
	var param =  "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+ "&pageNum="+ $("#currPage").val()
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


// [Add] click
function addWorkFlowStepPop() {
	var url = "addWorkFlowStepPop.do";
	var data = "LanguageID=${sessionScope.loginInfo.sessionCurrLangType}";
	var option = "width=510,height=205,left=500,top=300,toolbar=no,status=no,resizable=yes";
	url += "?"+ data;
    window.open(url, self, option);
}

function urlReload() {
	doOTSearchList();
}

// [Del] click
function delWorkFlow() {
	var selectedCell = grid.data.findAll(function (data) {
		return data.checkbox; 
	});
	if(!selectedCell.length){ 
		alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
	} else {
		if (confirm("${CM00004}")) {//if (confirm("선택된 항목을 삭제하시겠습니까?"))
			var wfStepIds = "";
			for (idx in selectedCell) {
				var cnt = selectedCell[idx].CNT; 
				var chk = selectedCell[idx].checkbox;
				if (cnt > 0) {
					var id = "ID:" + selectedCell[idx].WFStepID;
					"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00112' var='WM00112' arguments='"+ id +"'/>"
					alert("${WM00112}");
					chk = 0; 
				} else {
					if (wfStepIds == "") {
						wfStepIds = selectedCell[idx].WFStepID;
					} else{ 
						wfStepIds = wfStepIds + "," + selectedCell[idx].WFStepID;;
					}
				}
			}
			
			if (wfStepIds != "") {
				var url = "admin/delWorkFlowStep.do";
				var data = "wfStepIds=" + wfStepIds;
				var target = "saveFrame";
				ajaxPage(url, data, target);
			}
		}
	}
}

</script>
<body>
<div id="workFlowStepDiv">
<!-- BEGIN :: BOARD_ADMIN_FORM -->
<form name="WorkFlowList" id="WorkFlowList" action="#" method="post" onsubmit="return false;">
	<div id="processListDiv">
		<input type="hidden" id="setId" name="setId">
		<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	</div>
		<div class="cfgtitle" >				
			<ul>
				<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Work Flow</li>
			</ul>
		</div>	
		<div class="child_search01 mgL10 mgR10">
			<ul>
			<li class="floatR pdR10">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
					<button class="cmm-btn mgR5" style="height: 30px;" onclick="addWorkFlowStepPop()" value="Add" >Add WorkFlow</button>
					<button class="cmm-btn mgR5" style="height: 30px;" id="excel" value="Down" >Download List</button>
					<button class="cmm-btn mgR5" style="height: 30px;" onclick="delWorkFlow()" value="Del">Delete</button>
				</c:if>
			</li>
			</ul>
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
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
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
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},			
				{ width: 100, id: "WFStepID", header: [{ text: "${menu.LN00015}" , align: "center" }], align: "center" },
				{ width: 150, id: "Name", header: [{ text: "${menu.LN00028}", align: "center" }], align: "center" },
				{ width: 100, id: "DocCategory", header: [{ text: "DocCategory", align: "center" }], align: "center" },
				{ fillspace: true, id: "Description", header: [{ text: "${menu.LN00035}", align: "center" }], align: "left" },
				{ width: 100, id: "Deactivated", header: [{ text: "Deactivated", align: "center" }], align: "center" },		
				{ hidden: true, width: 100, id: "Creator", header: [{ text: "Creator", align: "center" }], align: "center" },
				{ hidden: true, width: 100, id: "CreationTime", header: [{ text: "CreationTime", align: "center" }], align: "center" },
				{ hidden: true, width: 0, id: "CNT", header: [{ text: "CNT", align: "center" }], align: "center" },	
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
	
		function gridOnRowOTSelect(row) {
			var url = "workFlowStepDetailView.do";
			var data = "WFStepID="+ row.WFStepID
						+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
						+ "&pageNum=" + $("#currPage").val();
			var target = "workFlowStepDiv";
			ajaxPage(url,data,target);
		}
</script>

</html>