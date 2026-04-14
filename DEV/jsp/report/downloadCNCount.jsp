<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">


<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_1" arguments="${menu.LN00131}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_2" arguments="${menu.LN00016}"/>

<script type="text/javascript">
	var p_gridArea
	
	$(document).ready(function() {	

		$('#fileDownLoading').removeClass('file_down_on');
		$('#fileDownLoading').addClass('file_down_off');
		
		$("input.datePicker").each(generateDatePicker); // calendar
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		};
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
			
	});	
	
	function setWindowHeight(){
		var size = window.innerHeight;
		var height = 0;
		if( size == null || size == undefined){
			height = document.body.clientHeight;
		}else{
			height=window.innerHeight;
		}return height;
	}
	
	//===============================================================================


	function fnGetCsrCombo(parentID){
		fnSelect('itemClass','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID='+parentID,'getItemClassTaskTP','Select');
		fnSelect('csrList','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID='+parentID,'getCsrOrder','Select');
		fnSelect('csrTeam','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID='+parentID,'getCsrTeam','Select');
	}
	
	function fnSearchList(){
		var CNTypeCode = "${CNTypeCode}";
		var itemClassCode = "${itemClassCode}";
		var attrTypeCode = "${attrTypeCode}";
		var searchKey = $("#searchKey").val();
		var searchValue = $("#searchValue").val();
		var treeItemTypeCode = "${treeItemTypeCode}";
		var url = "downloadCNCount.do";
		var data = "itemTypeCode="+CNTypeCode+"&s_itemID=${s_itemID}&itemClassCode="+itemClassCode+"&attrTypeCode="+attrTypeCode+"&searchKey="+searchKey+"&searchValue="+searchValue+"&treeItemTypeCode="+treeItemTypeCode;
	
		var target = "searchDiv";
		ajaxPage(url, data, target);
	}
	
	function doExcel() {		
	
		fnGridExcelDownLoad();
	}
	
	function gridOnRowSelect(row, col){
		if(col.id ==="identifier" || col.id === "itemName" || col.id === "path"){
			var s_itemID = row.itemID; 
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+s_itemID+"&scrnType=pop";
			var w = 1200;
			var h = 900;
			itmInfoPopup(url,w,h,s_itemID);
		} 
	}
	
	function goBack() {
		var url = "objectReportList.do";
		var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&kbn=newItemInfo"; 
		var target = "actFrame";
	 	ajaxPage(url, data, target);
	}
	


	/* ============================================== Grid ===================================== */
	 var layout = new dhx.Layout("grdGridArea", { rows: [{ id: "a" }] });

	 var gridData = ${gridData};

	 // 1) 고정 컬럼
	 const baseCols = [
	  
	   //from 그룹 
	   { width: 100, id: "identifier", header: [{ text: "${treeItemTypeName}", align: "center", colspan: 3 }, { text: "Identifier", align: "center" }], align: "center" },
	   { width: 200, id: "itemName",   header: [{ text: "", align: "center" },{ text: "Name", align: "center" }], align: "left" },
	   { width: 300, id: "path",   header: [{ text: "", align: "center" },{ text: "Path", align: "center" }], align: "left" },
	   { hidden:true, id: "itemID",   header: [{ text: "", align: "center" },{ text: "", align: "center" }], align: "left" }


	 
	 ];

	//2)  동적 키 : 첫행만 보고 키 추출 
 	const FIXED = new Set(["identifier","itemName","path","itemID"]);
	const keys = gridData?.[0] ? Object.keys(gridData[0]) : [];
	let dynamicKeys = keys.filter(k => !FIXED.has(k));

	
    // 3) total은 항상 맨 뒤로 보내기
     const totalIdx = dynamicKeys.indexOf("total"); 
    if (totalIdx >= 0) {
      const [t] = dynamicKeys.splice(totalIdx, 1);
      dynamicKeys.push(t);
    } 

   
   console.log(dynamicKeys);
 var gridHeadData = ${gridHeadData};
   const dynamicCols = dynamicKeys.map((k, i) => ({
	   width: 100,
	   id: k,
	   header: [
	     { text: i === 0 ? "${relatedItemTypeName}" : "", align: "center", colspan: i === 0 ? dynamicKeys.length : 1 },
	     { text: (gridHeadData.find(x => x.LovCode === k)?.Value) ?? k, align: "center" } 
	   ],
	   align: "right"
	 }));

	 // grid 생성
	  var grid = new dhx.Grid(null, {
	    columns: baseCols.concat(dynamicCols),    
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData
	  });


	 layout.getCell("a").attach(grid);
	 
	grid.events.on("cellClick", function(row, column, e) {
		   gridOnRowSelect(row, column);
		    
		});
	 var pagination = new dhx.Pagination("pagingArea", {
		    data: grid.data,
		    pageSize: 40,
		 
		});	
		
		pagination.setPage(document.getElementById('currPage').value);
		$("#TOT_CNT").html(grid.data.getLength());
		
	 
</script>
<div id="searchDiv">
<form name="taskSearchFrm" id="taskSearchFrm" action="#" method="post" onsubmit="return false;">
<input type="hidden" id="currPage" name="currPage" value="${currPage}" />
<div class="child_search mgT10">
	<li class="pdL55">
		<select id="searchKey" name="searchKey">
			<option value="Name">Name</option>
			<option value="ID">ID</option>
		</select>
		<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;"/>
		<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="fnSearchList()" value="검색">
	</li>
	<li class="floatR pdR20">
		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>	
		<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="goBack()" type="submit"></span>
	</li>
</div>
 <div class="countList pdT10">
    <li class="count">Total <span id="TOT_CNT">${totalCnt}</span></li>
 </div>
<form name="rptForm" id="rptForm" action="" method="post" > 
<div id="gridIssueDiv" style="width:100%;" class="clear"  >
	<div id="grdGridArea" style="background-color:white;"></div>
</div>
<!-- START :: PAGING -->
<div style="width:100%;" class="paginate_regular">
<div id="pagingArea" style="display:inline-block;"></div>
</div>



<!-- END :: PAGING -->	
</form>
</div>
