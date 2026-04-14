<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">

$(document).ready(function(){
	$("#historyLayout").attr("style","height:"+(setWindowHeight() - 210)+"px;");
	
	window.onresize = function() {
		$("#historyLayout").attr("style","height:"+(setWindowHeight() - 210)+"px;");
	};
	
	$("#excel").click(function (){
		fnGridExcelDownLoad();
	});
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

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
	window.open(url+data, "", "width=500, height=150, top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
}

function urlReload(){ 
	var url = "itemHistory.do"; // 변경이력
	var data = "s_itemID=${s_itemID}";
	var target = "help_content";
	ajaxPage(url, data, target);
}

function fnReload(){ urlReload(); }

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
    <div class="countList" style="margin:3px 0px 3px 0px">
    
    	<li class="count">Total  <span id="TOT_CNT"></span></li>
    	<li class="floatR">
        	<span class="btn_pack nobg white"><a class="xls"  title="Excel"  id="excel"></a></span>
       </li>
    </div>
	<div style="width: 100%;" id="historyLayout"></div>
	<div id="pagination"></div>
	</form>
</div>	

<script>
	var layout = new dhx.Layout("historyLayout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid;
	var pagination;
	var gridData = ${gridData};
	var grid = new dhx.Grid(null,  {
	    columns: [
	    	{ width: 40, id: "RNUM", header: [{ text: "No.", align:"center"}], align:"center"},
	        { width: 70, id: "Version", header: [{ text: "Version", align:"center"}], align:"center"},
	        { width: 100, id: "CSRID", header: [{ text: "${menu.LN00129}", align:"center"}, { content: "inputFilter" }], align: "center"},
	        { id: "ProjectName", header: [{ text: "${menu.LN00131}", align:"center" }, { content: "inputFilter" }],  align: "left", htmlEnable: true,
	        	template: function (text, row, col) {
	        		let result = "";
	        		if("${sessionScope.loginInfo.sessionAuthLev}" == "1") result += '<span class="mgR10"><img src="${root}${HTML_IMG_DIR}/btn_view.png" width="26" height="24" OnClick="doDetailChild('+row.ProjectID+','+row.ParentID+')"></span>';
	        		result += row.ProjectName;
	        		return result;
	            }
	        },
	        { width: 130, id: "ChangeType", header: [{ text: "${menu.LN00022}", align:"center" },{ content: "selectFilter" }], align:"center"},
	        { width: 120, id: "RequestUserName", header: [{ text: "${menu.LN00004}", align:"center" },{ content: "inputFilter" }], align:"center"},
	        { width: 110, id: "RequestDate", header: [{text: "${menu.LN00063}", align:"center"}], align:"center"},
	        { width: 80, id: "CompletionDate", header: [{ text: "${menu.LN00070}", align:"center"}], align:"center"},
	        { width: 80, id: "ApproveDate", header: [{ text: "${menu.LN00095}", align:"center" }], align:"center" },
	        { width: 110, id: "ValidFromDate", header: [{ text: "${menu.LN00296}", align:"center"}], align:"center"},
	        { width: 70, id: "ChangeSts", header: [{ text: "${menu.LN00027}", align:"center"}], align:"center"},
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    multiselection : true,	    
	});
	 
	grid.events.on("cellClick", function(row,column,e){				
		if(column.id != "ProjectName"){
			var cngtId = row.ChangeSetID;
			var status = row.ChangeStsCode;			
			var projectID = row.ProjectID;
			
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
	 }); 
	  
	 grid.events.on("filterChange", function(row,column,e,item){
		$("#TOT_CNT").html(grid.data.getLength());
	 });

	 layout.getCell("a").attach(grid);
	 
	 $("#TOT_CNT").html(grid.data.getLength());
	 
	 if(pagination){pagination.destructor();}
	 pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});
	
	
</script>