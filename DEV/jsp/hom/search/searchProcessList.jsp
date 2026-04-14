<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxToolbar/codebase/skins/dhtmlxtoolbar_dhx_skyblue.css'/>">
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="${menu.LN00021}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00158" var="WM00158"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00159" var="WM00159"/>
<style>
.DimensionTd .SumoSelect{
	float:left;
	margin-right:7px;
}
.objbox{
	overflow-x:hidden!important;
}
</style>
<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
	
	$(document).ready(function() {	
		$("input.datePicker").each(generateDatePicker);
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 380)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 380)+"px;");
		};
		
		doSearchList("${itemTypeCode}");
	});	
	
	function fnClickedTab(itemTypeCode, clickedIndex) { 
		doSearchList(itemTypeCode);
		var realMenuIndex = "${realMenuIndex}".split(' ');
		for ( var i = 0; i < realMenuIndex.length; i++) {
			if (realMenuIndex[i] == clickedIndex) {
				$("#pliugt" + realMenuIndex[i]).addClass("on");
			} else {
				$("#pliugt" + realMenuIndex[i]).removeClass("on");
			}
		}
	}
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function setGridData(itemTypeCode){
		var result = new Object();
		result.title = "${title}";
		result.key = "search_SQL.getSearchMultiList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00042},${menu.LN00016},${menu.LN00015},${menu.LN00028},${menu.LN00043},${menu.LN00014},${menu.LN00018},${menu.LN00004},${menu.LN00070},Report,ItemID,ClassCode";
		result.cols = "CHK|ItemTypeImg|ClassName|Identifier|ItemName|Path|TeamName|OwnerTeamName|Name|LastUpdated|Report|ItemID|ClassCode";
		result.widths = "50,50,50,100,100,220,*,120,120,70,70,60,0,0"; // base 검색
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,left,left,left,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&defaultLang=" + $("#defaultLang").val()
					+ "&isComLang=" + $("#isComLang").val()
					+ "&CategoryCode=OJ"
		 			+ "&pageNum=" + $("#currPage").val()
					+ "&idExist=${idExist}"
					+ "&ItemTypeCode=" + itemTypeCode;
					
					if("${searchValue}" != ""){
						result.data = result.data + "&baseCondition1=${searchValue}"+ "&AttrCodeBase1=AT00001";
					}
					
		return result;
	}
	
	function doDetail(avg){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg);
	}
</script>

</head>
<div class="pdL10 pdR10">	
	<input type="hidden" id="currPage" name="currPage" value="${currPage}"></input>
	<input type="hidden" id="defaultLang" name="defaultLang" value="${defaultLang}">
	<input type="hidden" id="isComLang" name="isComLang" value="">	
	<div class="SubinfoTabs">
		<ul>
		<c:forEach var="i" items="${itemTypeList}" varStatus="status" >
			<li id="pliugt${status.count}" <c:if test="${status.count == 1}"> class="on" </c:if>><a href="javascript:fnClickedTab('${i.CODE}','${status.count}');"><span>${i.NAME}</span></a></li> 
		</c:forEach>			
		</ul>
	</div>
	<div id="layout" style="width:100%"></div>
	<div id="pagination"></div>
</div>
<script>
	var pagination;
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid = new dhx.Grid("grid",  {
		columns: [
	        { width: 50, id: "RNUM", header: [{text: "${menu.LN00024}", align:"center"}], align: "center"},
	        { width: 50, id: "ItemTypeImg", header: [{ text: "${menu.LN00042}", align:"center" }], align: "center", htmlEnable: true,
	        	template: (value, row, col) => {
	                return "<img src='${root}${HTML_IMG_DIR_ITEM}/"+value+"'>";
	        	}
	    	},
	        { width: 100, id: "ClassName", header: [{ text: "${menu.LN00016}", align:"center" }, { content: "selectFilter" }], align:"center"},
	        { width: 100, id: "Identifier", header: [{text: "${menu.LN00015}", align:"center"}, { content: "inputFilter" }], align: "center"},
	        { width: 220, id: "ItemName", header: [{ text: "${menu.LN00028}", align:"center" }, { content: "inputFilter" }]},
	        { id: "Path", header: [{ text: "${menu.LN00043}", align:"center" }, { content: "inputFilter" }]},
	        { width: 120, id: "TeamName", header: [{ text: "${menu.LN00014}", align:"center" }, { content: "inputFilter" }], align:"center"},
	        { width: 120, id: "OwnerTeamName", header: [{ text: "${menu.LN00018}", align:"center" }, { content: "inputFilter" }], align:"center"},
	        { width: 100, id: "Name", header: [{ text: "${menu.LN00004}", align:"center" }, { content: "inputFilter" }], align:"center"},
	        { width: 100, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align:"center" }, { content: "inputFilter" }], align:"center"}
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false
	});
	
	 layout.getCell("a").attach(grid);
	 
	 if(pagination){pagination.destructor();}
	 pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 100,
	});
	
	grid.events.on("cellClick", function(row,column,e){
		doDetail(row.ItemID);
	});
	
	function doSearchList(itemTypeCode){
		var sqlID = "search_SQL.getSearchMultiList";
		var param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&defaultLang=" + $("#defaultLang").val()
			+ "&isComLang=" + $("#isComLang").val()
			+ "&CategoryCode=OJ"
 			+ "&pageNum=" + $("#currPage").val()
			+ "&idExist=${idExist}"
			+ "&ItemTypeCode=" + itemTypeCode
			+ "&sqlID="+sqlID;
			
		if("${searchValue}" != ""){
			param += "&baseCondition1=${searchValue}"+ "&AttrCodeBase1=AT00001";
		}
		
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadGrid(result);
				aa();
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
 	}
 	
 	function fnReloadGrid(newGridData){
 		if(newGridData.length > 1000) alert("${WM00119}");
 		grid.data.parse(newGridData);
 	}
</script>
</html>