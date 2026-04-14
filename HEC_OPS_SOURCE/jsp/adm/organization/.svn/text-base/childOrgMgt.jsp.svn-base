<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00024" var="WM00024" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00035" var="CM00035" />

<script>

var pO_gridArea;				//그리드 전역변수
var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용

$(document).ready(function(){
	// 초기 표시 화면 크기 조정 
	$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 420)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 420)+"px;");
	};

	$('#searchKey').change(function(){
		if($(this).val() != ''){
			$('#search' + $(this).val()).show();
		}
	});
	gridInit();		
	doSearchList();

});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

//===============================================================================
// BEGIN ::: GRID

function doSearchList(){
	var d = setGridData();
	fnLoadDhtmlxGridJson(pO_gridArea, d.key, d.cols, d.data);
}

//그리드 초기화
function gridInit(){	
	var d = setGridData();
	pO_gridArea = fnNewInitGrid("grdGridArea", d);
	pO_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
    pO_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
	fnSetColType(pO_gridArea, 1, "ch");//ra : radio
    fnSetColType(pO_gridArea, 2, "img");
	
	pO_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
		gridOnRowSelect(id,ind);
	});

}

function setGridData(){
	var result = new Object();
	result.title = "${title}";
	result.key = "organization_SQL.getOrganizationList";
	result.header = "${menu.LN00024},#master_checkbox,${menu.LN00042},ID,Code,${menu.LN00028},Type, Members";
	result.cols = "CHK|OrgTypeImg|TeamID|TeamCode|Name|TeamTypeNM|MCOUNT";
	result.widths = "50,50,50,100,100,*,150,100";
	result.sorting = "int,int,int,int,str,str,str,int";
	result.aligns = "center,center,center,center,left,center,center,center";
	result.data = "s_itemID=${s_itemID}"
				+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
		        + "&searchKey="     + $("#searchKey").val()
		        + "&searchValue="     	+ $("#searchValue").val();
	return result;
}

//그리드ROW선택시
function gridOnRowSelect(id, ind){
	if(ind != 1){
		doDetail(pO_gridArea.cells(id, 3).getValue());
	}
}

function doDetail(avg){
	var url    = "orgInfoView.do"; // 요청이 날라가는 주소
	var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID=${s_itemID}&s_itemID="+avg; //파라미터들
	var target = "objInfo";
	ajaxPage(url,data,target);
}

// END ::: GRID	
//===============================================================================

// [Move] button Click
function searchOrgPopUp(){
	if(pO_gridArea.getCheckedRows(1).length == 0){
		alert("${WM00023}");
	}else{
		var url = "orgUserTreePop.do";
		var data = "s_itemID=${s_itemID}";
		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}	
}
function doCallBack(avg){
	var newTeamId = avg;
	var checkedRows = pO_gridArea.getCheckedRows(1).split(",");
	var items = pO_gridArea.cells(checkedRows[0], 3).getValue();
	for(var i = 1 ; i < checkedRows.length; i++ ){
		items += ","+ pO_gridArea.cells(checkedRows[i], 3).getValue();
	}
	var url = "transOrg.do";
	var data = "s_itemID=${s_itemID}&parentID="+newTeamId +"&items="+items;
	var target = "blankFrame";
	ajaxPage(url,data,target);
}

//[orgtree popup] Close
function thisReload(){
	$(".popup_div").hide();
	$("#mask").hide();
	doSearchList();
}

// [HR Interface] click
function callHrInterface(){
	var url = "callHrInterface.do";
	var data = "";
	var target = "blankFrame";
	ajaxPage(url, data, target);
}


</script>

<form name="processList" id="processList" action="#" method="post" onsubmit="return false;">
	<div id="processListDiv" class="hidden" style="width:100%;height:100%;">
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
	
	<div style="overflow:auto;overflow-x:hidden;">	

		<!-- BEGIN :: SEARCH -->
		<div>
			<li class="floatL pdL20">
				<select id="searchKey" name="searchKey">
					<option value="Name">Name</option>
					<option value="ID">ID</option>
				</select>
				<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;">
				<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchList()" value="검색">
			</li>
			<li class="floatR pdR20">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
					<c:if test="${hrIfProc != 'NULL'}">
						<span class="btn_pack small icon"><span class="edit"></span><input value="HR Interface" type="submit" onclick="callHrInterface();"></span>
					</c:if>	
						<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="doDetail('')"></span>
						<span class="btn_pack small icon"><span class="move"></span><input value="Move" type="submit" onclick="searchOrgPopUp()"></span>						
				</c:if>			
			</li>
			</ul>
		</div>
		<!-- END :: SEARCH -->
		
        <div class="countList">
             <li class="count">Total  <span id="TOT_CNT"></span></li>
             <li class="floatR">&nbsp;</li>
         </div>
		<!-- BIGIN :: LIST_GRID -->
		<div id="gridDiv" class="mgB10 clear">
			<div id="grdGridArea" style="width:100%"></div>
		</div>
		<!-- END :: LIST_GRID -->		
	</div>
	<div id="objInfo"></div>	
</div>
</form>
<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>