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

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>

//var pO_gridArea;				//그리드 전역변수
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
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

//===============================================================================
// BEGIN ::: GRID
function doSearchList(){ 
	var sqlID = "organization_SQL.getOrganizationList";
	var param =  "s_itemID=${s_itemID}"				
        + "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
        + "&searchKey="     + $("#searchKey").val()
        + "&searchValue="     	+ $("#searchValue").val()
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

var layout = new dhx.Layout("grdGridArea", {
    rows: [
        {
            id: "a",
        },
    ]
});

var gridData = ${gridData};
var grid = new dhx.Grid("grid", {
    columns: [
        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
        { width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center" }], align: "center", type: "boolean", editable: true, sortable: false},
   		{ width: 50, id: "OrgTypeImg", header: [{ text: "${menu.LN00042}", align:"center" }], htmlEnable: true, align: "center",
        	template: function (text, row, col) {
        		return '<img src="${root}${HTML_IMG_DIR}/item/'+row.OrgTypeImg+'" width="18" height="18">';
            }
        },
        { width: 100, id: "TeamID", header: [{ text: "${menu.LN00106}", align: "center" } ], align: "center" },
        { width: 100, id: "TeamCode", header: [{ text: "Code", align: "center" } ], align: "center" },
        {  id: "Name", header: [{ text: "${menu.LN00028}", align: "center" } ], align: "childOrgMgt" },
        { width: 150, id: "TeamTypeNM", header: [{ text: "Type", align: "center" } ], align: "center" },
        { width: 100, id: "MCOUNT", header: [{ text: "Members", align: "center" } ], align: "center" },

    ],
    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    data: gridData
});

layout.getCell("a").attach(grid);

function fnReloadGrid(newGridData){
 		grid.data.parse(newGridData);
 		fnMasterChk('');
 		$("#TOT_CNT").html(grid.data.getLength());
 	}

$("#TOT_CNT").html(grid.data.getLength());
//그리드ROW선택시
grid.events.on("cellClick", function(row,column,e){
	if(column.id != "checkbox"){
		doDetail(row.TeamID);
	}
}); 
	 
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
	var selectedCell = grid.data.findAll(function (data) {
        return data.checkbox;
    });
	if(!selectedCell.length){
		alert("${WM00023}");
	}else{
		var url = "orgUserTreePop.do";
		var data = "s_itemID=${s_itemID}";
		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}	
}
function doCallBack(avg){
	var selectedCell = grid.data.findAll(function (data) {
        return data.checkbox;
    });
	var newTeamId = avg;
	var items = selectedCell.map(function(cell) {
    	return cell.TeamID;
	}).join(",");
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
        <div class="countList pdT10">
             <li class="count">Total  <span id="TOT_CNT"></span></li>
             <li class="pdL55 floatL">
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