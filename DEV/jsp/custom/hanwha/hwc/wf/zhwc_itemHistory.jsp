<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript">

var p_gridArea_child;				//그리드 전역변수

$(document).ready(function(){
	
	// 초기 표시 화면 크기 조정 
	$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 270)+"px;");
	
	// 화면 크기 조정
	window.onresize = function() {
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 270)+"px;");
	};
	
	$("#sExcel").click(function(){p_gridArea_child.toExcel("${root}excelGenerate");});
	
	gridInit();		
	doSearchList();

});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

//===============================================================================
// BEGIN ::: GRID

function doSearchList(){
	var d = setGridData();
	fnLoadDhtmlxGridJson(p_gridArea_child, d.key, d.cols, d.data);
}

//그리드 초기화
function gridInit(){	
	var d = setGridData();
	p_gridArea_child = fnNewInitGrid("grdGridArea", d);
	p_gridArea_child.setImagePath("${root}${HTML_IMG_DIR}/");
	p_gridArea_child.setIconPath("${root}${HTML_IMG_DIR}/");
	
	fnSetColType(p_gridArea_child, 4, "img");
	fnSetColType(p_gridArea_child, 16, "img");

	p_gridArea_child.setColumnHidden(2, true);	
	p_gridArea_child.setColumnHidden(5, true);	
	p_gridArea_child.setColumnHidden(7, true);	
	p_gridArea_child.setColumnHidden(8, true);	
		
	p_gridArea_child.setColumnHidden(11, true);	
	p_gridArea_child.setColumnHidden(12, true);
	p_gridArea_child.setColumnHidden(13, true);
	p_gridArea_child.setColumnHidden(14, true);
	p_gridArea_child.setColumnHidden(15, true);
	p_gridArea_child.setColumnHidden(16, true);
	p_gridArea_child.setColumnHidden(17, true);	
	
	p_gridArea_child.attachEvent("onRowSelect", function(id,ind){
		gridOnRowSelectChild(id,ind);
	});

}

function setGridData(){
	var result = new Object();
	result.title = "${title}";
	result.key = "cs_SQL.getItemChangeList";
	result.header = "${menu.LN00024},Version,${menu.LN00129},${menu.LN00131},#cspan,${menu.LN00022},${menu.LN00004},${menu.LN00063},${menu.LN00070},${menu.LN00296},${menu.LN00027},${menu.LN00094},ChangeSetID,ProjectID,RequestUserId,ChangeStsCode,Task,ParentID";
	result.cols = "Version|CSRID|ProjectName|ImgPjtInfoView|ChangeType|RequestUserName|RequestDate|CompletionDate|ValidFromDate|ChangeSts|ApprovedUserName|ChangeSetID|ProjectID|RequestUserId|ChangeStsCode|ImgTaskInfoView|ParentID";
	result.widths = "30,50,110,*,30,100,100,100,100,100,100,0,0,0,0,0,30,0";
	result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
	result.aligns = "center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center";
	result.data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
	return result;
}

//그리드ROW선택시
function gridOnRowSelectChild(id, ind){
	if(ind == 4){
		doDetailChild(p_gridArea_child.cells(id, 13).getValue(),p_gridArea_child.cells(id, 17).getValue());
	}else if(ind == 16){
		var cngtId = p_gridArea_child.cells(id, 11).getValue();
		var url = "getTaskMgtFromObjHistory.do?cngtId="+cngtId+"&isFromMain=Y";
		var w = 1200;
		var h = 600; 
		itmInfoPopup(url,w,h);
	}else {
	
		var status = p_gridArea_child.cells(id, 15).getValue();			
		var cngtId = p_gridArea_child.cells(id, 12).getValue();
		var projectID = p_gridArea_child.cells(id, 13).getValue();
		
		if (status == "MOD") {
			screenMode = "edit";
		}
		else {
			screenMode = "view";
		}
	
		var url = "viewItemChangeInfo.do?changeSetID="+cngtId+"&StatusCode="+status
					+"&ProjectID="+projectID+"&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&isItemInfo=Y&seletedTreeId=${s_itemID}&isStsCell=Y";
		var w = 1200;
		var h = 600; 
		itmInfoPopup(url,w,h);
	}
}

function doDetailChild(avg, avg2){
	var projectID = avg;
	var parentId = avg2;
	var screenMode ="V";
	
 	var url = "csrDetailPop.do?ProjectID=" + projectID + "&screenMode=" + screenMode + "&s_itemID="+parentId+"&isItemInfo=Y&seletedTreeId=${s_itemID}";
	var w = 1200;
	var h = 800;
	window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");

 }

// [Check Out] click
function checkOutPop() {
	var url = "cngCheckOutPop.do?";
	var data = "s_itemID=${s_itemID}";
	window.open(url+data, "", "width=350, height=150, top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
}

function urlReload(){ 
	var url = "itemHistory.do"; // 변경이력
	var data = "s_itemID=${s_itemID}";
	var target = "help_content";
	ajaxPage(url, data, target);
}

function fnReload(){ urlReload(); }

// END ::: GRID	
//===============================================================================


function goNewItemInfo() {
	var isFromTask="${isFromTask}";
	if(isFromTask == "Y"){
		var url = "taskMgt.do?itemID=${s_itemID}";
	}else{
		var url = "NewItemInfoMain.do";
	}
	var target = "actFrame";
	var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}"; 
 	ajaxPage(url, data, target);
}

</script>
<div id="help_content">
	<form name="historyList" id="historyList" action="#" method="post" onsubmit="return false;">
	<div id="processListDiv">	
		<div class="child_search">
			 <li class="shortcut">
			 	<img src="${root}${HTML_IMG_DIR}/sc_change.png"></img>&nbsp;&nbsp;<b>${menu.LN00012}</b>
			 </li>
		     <li class="floatR pdR20">		     	
		     	<c:if test="${backBtnYN != 'N'}" >
		     	<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="goNewItemInfo()" type="submit"></span>
		     	</c:if>
		     </li>
		</div>
	</div>
	<!-- BIGIN :: LIST_GRID -->
	   <div class="countList">
              <li class="count">Total  <span id="TOT_CNT"></span></li>
              <li class="floatR">&nbsp;</li>
          </div>
	<div id="gridDiv" class="mgT10 mgB10 clear">
		<div id="grdGridArea" style="height:200px; width:100%"></div>
	</div>
	<!-- END :: LIST_GRID -->
	</form>
</div>	