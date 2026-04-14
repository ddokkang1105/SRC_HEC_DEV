<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<style>
	div.gridbox table.obj tr td {
		text-overflow:ellipsis;
	}
</style>
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">


<script type="text/javascript">

var p_gridArea_child;//그리드 전역변수

$(document).ready(function(){
	
	// 초기 표시 화면 크기 조정 
	$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 200)+"px;");

	// 화면 크기 조정
	window.onresize = function() {
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 200)+"px;");
	};
	
	$("#excel").click(function(){ fnGridExcelDownLoad(); });

	
	doSearchList();
	
	$("input.datePicker").each(generateDatePicker);
	$('.searchList').click(function(){
		doSearchList();
		return false;
	});
	$('#searchValue').keypress(function(onkey){
		if(onkey.keyCode == 13){
			doSearchList();
			return false;
		}
	});		
	setTimeout(function() {$('#searchValue').focus();}, 0);	
	
	
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

//===============================================================================
// BEGIN ::: GRID

function setGridConfig(){
	var result = new Object();
	result.title = "${title}";
	result.key = "revision_SQL.revisionList";

	result.data = "s_itemID=${documentID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&scStartDt="     + $("#SC_STR_DT").val()
			        + "&searchKey="    	+ $("#searchKey").val()
			        + "&searchValue="  	+ $("#searchValue").val()			        
			        + "&scEndDt="     	+ $("#SC_END_DT").val()
			        + "&pageNum="     	+ $("#currPage").val();
	return result;
}

function doSearchList(){
	var gridConfig = setGridConfig();

	var param = "";
	param += gridConfig.data + "&sqlID="+gridConfig.key
	
	$.ajax({
		url:"jsonDhtmlxListV7.do",
		type:"POST",
		data:param,
		success: function(result){
			fnReloadGrid(result);
			$('#loading').fadeOut(150);
		},error:function(xhr,status,error){
			console.log("ERR :["+xhr.status+"]"+error);
		}
	});
	
	function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
			$("#TOT_CNT").html(grid.data.getLength());
	}
}

// 미사용 함수
function urlReload(){ 
	var url = "revisionList.do"; // 변경이력
	var data = "s_itemID=${documentID}";
	var target = "help_content";
	ajaxPage(url, data, target);
}

// 미사용 함수
function fnReload(){ urlReload(); }

// END ::: GRID	
//===============================================================================


function goNewItemInfo() {
	var isFromTask="${isFromTask}";
	if(isFromTask == "Y"){
		var url = "taskMgt.do?itemID=${documentID}";
	}else{
		var url = "NewItemInfoMain.do";
	}
	var target = "actFrame";
	var data = "s_itemID=${documentID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}"; 
 	ajaxPage(url, data, target);
}

function fnRegRevision(){
	var url = "addRevision.do?documentID=${documentID}&docCategory=${docCategory}";
	var pop_state;
	pop_state = window.open(url,'','width=800, height=380, left=200, top=100,scrollbar=yes,resizble=0');
	pop_state.focus();
}


</script>


<div id="help_content">
	<form name="RevisionList" id="RevisionList" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
		<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
		<div id="processListDiv">	
			<div class="child_search">
				 <li class="shortcut">
				 	<img src="${root}${HTML_IMG_DIR}/img_revision.png"></img>&nbsp;&nbsp;<b>Revision List</b>
				 </li>
				 <li style="font-weight:bold;">${menu.LN00013}</li>
				 <li style="position:relative;">
					<c:if test="${scStartDt != '' and scEndDt != ''}">
						<fmt:parseDate value="${scStartDt}" pattern="yyyy-MM-dd" var="beforeYmd"/>
						<fmt:parseDate value="${scEndDt}" pattern="yyyy-MM-dd" var="thisYmd"/>
						<fmt:formatDate value="${beforeYmd}" pattern="yyyy-MM-dd" var="beforeYmd"/>
						<fmt:formatDate value="${thisYmd}" pattern="yyyy-MM-dd" var="thisYmd"/>
					</c:if>
					<c:if test="${scStartDt == '' or scEndDt == ''}">
						<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
						<fmt:formatDate value="<%=xbolt.cmm.framework.util.DateUtil.getDateAdd(new java.util.Date(),2,-12 )%>" pattern="yyyy-MM-dd" var="beforeYmd"/>
					</c:if>
					 <input type="text" id="SC_STR_DT" name="SC_STR_DT" value="${beforeYmd}"	class="text datePicker" size="8"
							style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
					~
					 <input type="text" id=SC_END_DT	name="SC_END_DT" value="${thisYmd}"	class="text datePicker" size="8"
							style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
				 </li>				
				 <li>
					<select id="searchKey" name="searchKey" style="width:150px;">
						<option value="Description">${menu.LN00290}</option>
						<option value="AuthorTeamName" 
							<c:if test="${searchKey == 'AuthorTeamName'}"> selected="selected"</c:if>>
							${menu.LN00153}
						</option>					
					</select>
				 </li>
				 <li>
					<input type="text" class="stext"  id="searchValue" name="searchValue" value="${searchValue}" style="width:150px;ime-mode:active;">
					<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" />
				 </li>
				 
			     <li class="floatR pdR20">
			     	<c:if test="${itemAuthorID == sessionScope.loginInfo.sessionUserId && itemBlocked == 0 && revisionCNT == 0 }">
			     		<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="fnRegRevision()" ></span>
			     	</c:if>
			     	<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			     	<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="goNewItemInfo()" type="submit"></span>
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
		
		<!-- START :: PAGING -->
		<div id="pagination" class="mgT20"></div>	
		<!-- END :: PAGING -->
	</form>
</div>

<script>
// result.header = "${menu.LN00024},Revision ${menu.LN00024},${menu.LN00290},${menu.LN00021},${menu.LN00060},${menu.LN00153},${menu.LN00070}";//9
// result.cols = "RevisionID|Description|ObjectTypeName|AuthorName|AuthorTeamName|LastUpdated";//8
// result.widths = "0,100,*,110,110,110,110,130";

function handleGridRowSelect(row, column, e){
	var revisionID = row.RevisionID;
	if(column.id != "checkbox"){
		var url = "revisionInfo.do?LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&documentID=${documentID}&scrnType=pop&revisionID="+revisionID;
		var w = 800;
		var h = 380;
		itmInfoPopup(url,w,h,"${documentID}");
	}
}


const grdGridArea = new dhx.Layout("grdGridArea", {
	rows: [ { id: "a" } ] });

var grid = new dhx.Grid("grid", {
	columns: [

    	{ width: 100 , id: "RevisionID", header: [{ text: "Revision ${menu.LN00024}" , align: "center" }], align: "center" },
    	{ id: "Description", header: [{ text: "${menu.LN00290}", align: "center" } ], align: "center" },
    	{ width: 100, id: "ObjectTypeName", header: [{ text: "${menu.LN00021}", align: "center" } ], align: "center" },
    	{ width: 100,id: "AuthorName", header: [{ text: "${menu.LN00060}", align: "center" } ], align: "left" },
    	{ width: 100, id: "AuthorTeamName", header: [{ text: "${menu.LN00153}", align: "center" } ], align: "center" },
    	{ width: 100, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align: "center" } ], align: "center" },

	],
	autoWidth: true,
	resizable: true,
	selection: "row",
	tooltip: false,
});

grdGridArea.getCell("a").attach(grid);

var pagination = new dhx.Pagination("pagination", {
	data: grid.data,
	pageSize: 50,
});

$("#TOT_CNT").html(grid.data.getLength());

grid.events.on("cellClick", (row, column, e) => handleGridRowSelect(row, column, e)); 
</script>