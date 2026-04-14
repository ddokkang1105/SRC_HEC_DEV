<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>


<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00054" var="WM00054"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00024" var="WM00024"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00052" var="WM00052"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00121" var="WM00121"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046"/>
<style>
	.grid_hover {
		background-color:f2f8ff;
		font-size:20px;
	}
</style>

<script>
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 355)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 355)+"px;");
		};
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function thisReload() {
		doTcSearchList('');
	}
	
	function doDetail(avg1){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
	}
</script>	
<form name="processList" id="processList" action="#" method="post" onsubmit="return false;">
	<div id="processListDiv" class="hidden" style="width:100%;height:100%;">
	<div style="overflow:auto;margin-bottom:5px;overflow-x:hidden;">	
		 <div class="countList">
              <li class="pdL20 floatL">
				 <input type="radio" name="upLow" value="1" checked onClick="doTcSearchList('');">&nbsp;&nbsp;All
	   		&nbsp;&nbsp;<input type="radio" name="upLow" value="2" onClick="doTcSearchList('Up');">&nbsp;&nbsp;Up
	   		&nbsp;&nbsp;<input type="radio" name="upLow" value="3" onClick="doTcSearchList('Lower');">&nbsp;&nbsp;Lower				
			  </li>
		</div>	
		<div class="countList">
            <li class="pdL20 floatL" >
				<span style="color:blue"> All : ${AllCNT} &nbsp;&nbsp;Up : ${UpCNT} &nbsp;&nbsp;Lower : ${LowerCNT} </span>				
			</li>
		</div>	
		<div id="layout" style="width:100%"></div>
		</div>
	</div>
	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
	<script>
		doTcSearchList();
	
		var layout = new dhx.Layout("layout", {
		    rows: [
		        {
		            id: "a",
		        },
		    ]
		});
		
		var grid = new dhx.Grid("grid",  {
			columns: [
		        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}", align:"center"}], align:"center" },
		        { width: 160, id: "UpLow", header: [{ text: "${menu.LN00042}", align:"center" }], align:"center"},
		        { id: "Path", header: [{text: "${menu.LN00043}", align:"center"}]},
		    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false
		});
		
		layout.getCell("a").attach(grid);
		
		function doTcSearchList(upLow){
			var sqlID = "item_SQL.getUpLowStrItemList";
			var param ="strItemID=${s_itemID}"
				+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"				
		        + "&s_itemID=${toItemID}&upLow="+upLow
				+ "&sqlID="+sqlID;
				
			$.ajax({
				url:"jsonDhtmlxListV7.do",
				type:"POST",
				data:param,
				success: function(result){
					grid.data.parse(result);
				},error:function(xhr,status,error){
					console.log("ERR :["+xhr.status+"]"+error);
				}
			});
		}
		
		grid.events.on("cellClick", function(row,column,e){
			parent.fnRefreshTree(row.ItemID, true);
		});
	</script>