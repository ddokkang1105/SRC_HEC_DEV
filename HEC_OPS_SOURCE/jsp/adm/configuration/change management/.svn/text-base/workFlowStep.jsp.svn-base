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

<!-- 2. Script -->
<script type="text/javascript">

var OT_gridArea;				//그리드 전역변수
var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용

$(document).ready(function() {	
	// 초기 표시 화면 크기 조정
	$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 160)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 160)+"px;");
	};
	$("#excel").click(function(){OT_gridArea.toExcel("${root}excelGenerate");});
	
	//Grid 초기화
	gridOTInit();
	doOTSearchList();
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

//===============================================================================
// BEGIN ::: GRID
//그리드 초기화
function gridOTInit(){		
	var d = setOTGridData();
	OT_gridArea = fnNewInitGrid("grdOTGridArea", d);
	fnSetColType(OT_gridArea, 1, "ch");
	OT_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
	OT_gridArea.setColumnHidden(7, true);
	OT_gridArea.setColumnHidden(8, true);
	OT_gridArea.setColumnHidden(9, true);
	OT_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
		gridOnRowOTSelect(id,ind);
	});
	//START - PAGING
	OT_gridArea.enablePaging(true,20,10,"pagingArea",true,"recInfoArea");
	OT_gridArea.setPagingSkin("bricks");
	OT_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	//END - PAGING
}

function setOTGridData(){
	var result = new Object();
	result.title = "${title}";
	result.key = "config_SQL.workFlowStep";
	result.header = "${menu.LN00024},#master_checkbox,${menu.LN00015},${menu.LN00028},DocCategory,${menu.LN00035},Deactivated,Creator,CreationTime,CNT";
	result.cols = "CHK|WFStepID|Name|DocCategory|Description|Deactivated|Creator|CreationTime|CNT";
	result.widths = "50,50,100,150,100,*,100,100,100,0";
	result.sorting = "int,int,str,str,str,str,str,str,str,str";
	result.aligns = "center,center,center,left,center,left,left,center,center,center";
	result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&pageNum="      + $("#currPage").val();
		
	return result;

}

//그리드ROW선택시
function gridOnRowOTSelect(id, ind) {
	var url = "workFlowStepDetailView.do";
	var data = "WFStepID="+ OT_gridArea.cells(id,2).getValue()
				+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+ "&pageNum=" + $("#currPage").val();
	var target = "workFlowStepDiv";
	ajaxPage(url,data,target);
}

// END ::: GRID	
//===============================================================================

	
//조회
function doOTSearchList(){
	var d = setOTGridData();
	fnLoadDhtmlxGridJson(OT_gridArea, d.key, d.cols, d.data);
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
	gridOTInit();
	doOTSearchList();
}

// [Del] click
function delWorkFlow() {
	if (OT_gridArea.getCheckedRows(1).length == 0) {
		//alert("항목을 한개 이상 선택하여 주십시요.");	
		alert("${WM00023}");	
	} else {
		//if (confirm("선택된 항목을 삭제하시겠습니까?")) {
		if (confirm("${CM00004}")) {
			var checkedRows = OT_gridArea.getCheckedRows(1).split(",");
			var wfStepIds = "";
			for ( var i = 0; i < checkedRows.length; i++) {
				var cnt = OT_gridArea.cells(checkedRows[i], 9).getValue();
				if (cnt > 0) {
					var id = "ID:" + OT_gridArea.cells(checkedRows[i], 2).getValue();
					"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00112' var='WM00112' arguments='"+ id +"'/>"
					alert("${WM00112}");
					OT_gridArea.cells(checkedRows[i], 1).setValue(0); 
				} else {
					if (wfStepIds == "") {
						wfStepIds = OT_gridArea.cells(checkedRows[i], 2).getValue();
					} else{ 
						wfStepIds = wfStepIds + "," + OT_gridArea.cells(checkedRows[i], 2).getValue();
					}
				}
			}
			
			if (wfStepIds != "") {
				var url = "delWorkFlowStep.do";
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
					<!-- 엑셀 다운 아이콘  -->
					&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
					<!-- ADD 버튼  -->
					&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" alt="신규" onclick="addWorkFlowStepPop()"></span>
					<!-- DEL 버튼 -->
					&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delWorkFlow()"></span>
				</c:if>
			</li>
			</ul>
		</div>
         <div class="countList pdL10">
             <li class="count">Total  <span id="TOT_CNT"></span></li>
            <li class="floatR">&nbsp;</li>
        </div>
		<div id="gridOTDiv" class="mgB10 clear mgL10 mgR10">
			<div id="grdOTGridArea" style="height:360px; width:100%"></div>
		</div>	
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->	
</form>
</div>	
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
	
</body>
</html>