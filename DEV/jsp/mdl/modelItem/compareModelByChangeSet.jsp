<!-- localhost OLM_DeV 1.1.2.5에서 테스트 -->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8"/>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00087" var="WM00087"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00042" var="WM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>


<!-- 2. Script -->
<script type="text/javascript">
	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 100)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 100)+"px;");
		};
		
// 		PgridInit();
// 		doPSearchList();
		setTimeout(function() {$('.row20px').rowspan(0);}, 150);
		
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	$.fn.rowspan = function(colIdx, isStats) {
		return this.each(function(){
			var that;
			$('tr', this).each(function(row) {
				$('td:eq('+colIdx+')', this).filter(':visible').each(function(col) {
					if ($(this).html() == $(that).html()&& (!isStats|| isStats && $(this).prev().html() == $(that).prev().html())) {
						rowspan = $(that).attr("rowspan") || 1;
						rowspan = Number(rowspan)+1;
					
						$(that).attr("rowspan",rowspan);
						$(this).hide();
					} else {
						that = this;
					}
					that = (that == null) ? this : that;
				});
			});
		});
	};
	
	function fnGetNewElements(){
		return grid.data.getInitialData().filter(e => e.ChangeMode == "New").map(e => e.TobeElementID);
	}
	
	function fnGetDelElements(){
		return grid.data.getInitialData().filter(e => e.ChangeMode == "Deleted").map(e => e.BaseElementID);;
	}
</script>
<form name="symbolFrm" id="symbolFrm" action="" method="post" onsubmit="return false;">	
	<c:choose>
		<c:when test="${empty ModelID1 || empty ModelID2}">
			Only one model exist. Model cannot be compared!!
		</c:when>
		<c:otherwise>
			<div class="child_search_head mgB10">
				<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Model comparison report</p>
			</div>
			<div class="countList">
		        <li class=" mgL10">
			        <span style="color:blue;">${menu.LN00381} : ${New}</span> , 
			        <span style="color:red;">${menu.LN00382} : ${Deleted}</span> , 
			        <span style="color:green;">${menu.LN00383} : ${Modified}</span>
		        </li>
		    </div>
		    <div id="layout" style="width:100%;"></div>
		</c:otherwise>
	</c:choose>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var gridData = ${gridData};
	
	var grid = new dhx.Grid("grid",  {
		columns: [
	        { width: 120, id: "ClassName", header: [{ text: "${menu.LN00016}", align:"center"}], align:"center" },
	        { width: 100, id: "Identifier", header: [{ text: "${menu.LN00106}", align:"center" }]},
	        { width: 250, id: "PlainTextBAS", header: [{ text: "${menu.LN00365} (${LastUpdated1})", align:"center" }], htmlEnable: true,
	    		template: function (value, row, col) {
	            	var result = "";
	            	if(row.id == "1") result = "<div style='width: 100%;display: flex;justify-content: space-between;'><p style='font-weight: bold;'>"+value+"</p><img src='${root}${HTML_IMG_DIR}/btn_model.png' title='모델 조회' style='cu'/></div>";
	            	else if(row.SymbolIconBAS) result = "<img src='${root}${HTML_IMG_DIR_MODEL_SYMBOL}/symbol/" + row.SymbolIconBAS + "' class='mgR10 mgL5'/>"+value;
	            	else result = value;
	                return result;
	            }
	        },
	        { width: 250, id: "PlainTextTOBE", header: [{ text: "${menu.LN00366} (${LastUpdated2})", align:"center" }], htmlEnable: true,
	    		template: function (value, row, col) {
	            	var result = "";
	            	if(row.id == "1") result = "<div style='width: 100%;display: flex;justify-content: space-between;'><p style='font-weight: bold;''>"+value+"</p><img src='${root}${HTML_IMG_DIR}/btn_model.png' title='모델 조회'/></div>";
	            	else if(row.SymbolIconTOBE) result = "<img src='${root}${HTML_IMG_DIR_MODEL_SYMBOL}/symbol/" + row.SymbolIconTOBE + "' class='mgR10 mgL5'/>"+value;
	            	else result = value;
	                return result;
	            }
	        },
	        { width: 80, id: "ChangeMode", header: [{ text: "${menu.LN00022}", align:"center" }], align:"center"},
	        { width: 80, id: "button", header: [{ text: "${menu.LN00384}", align:"center" }], align:"center", htmlEnable: true },
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: false,
	    data: gridData
	});
	
	layout.getCell("a").attach(grid);
	
	grid.events.on("cellClick", function(row,column,e){
		var itemID = row.ObjectID || "";
		var changeMode = row.ChangeMode || "";
		var preChangeSet = row.PreChangeSetID || "";
		var changeSet = row.ChangeSetID || "";
		if(row.id == "1"){
			var modelID1 = "${ModelID1}";
			var modelID2 = "${ModelID2}";
			var modelName1 = "${ModelName1}";
			var modelName2 = "${ModelName2}";
			var modelTypeName1 = "${ModelTypeName1}"
			var modelTypeName2 = "${ModelTypeName2}"
			
			if(column.id == "PlainTextBAS"){
				var delElementIDs = fnGetDelElements();	
				var url = "popupMasterMdlEdt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					 + "&s_itemID=${itemID1}&modelID="+modelID1+"&scrnType=view&MTCategory=${MTCategory1}"
					 + "&modelName="+encodeURIComponent(modelName1)
					 + "&modelTypeName="+encodeURIComponent(modelTypeName1)
					 + "&delElementIDs="+delElementIDs; 
				var w = 1200;
				var h = 900;
			    window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
			}else if(column.id == "PlainTextTOBE"){
				var newElementIDs = fnGetNewElements();			
				var url = "popupMasterMdlEdt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					 + "&s_itemID=${itemID2}&modelID="+modelID2+"&scrnType=view&MTCategory=${MTCategory2}"
					 + "&modelName="+encodeURIComponent(modelName2)
					 + "&modelTypeName="+encodeURIComponent(modelTypeName2)
					 + "&newElementIDs="+newElementIDs;
				var w = 1200;
				var h = 900;
			    window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
			}else if(column.id == "button"){
				var url = "compareAttribute.do?s_itemID="+itemID+"&preChangeSet="+preChangeSet+"&changeSet="+changeSet;
				var w = 1200;
				var h = 800;
				window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
			}else {
				var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop";
				var w = 1200;
				var h = 900; 
				itmInfoPopup(url,w,h,itemID);		
			}
		} else {
			if(column.id !== "button"){
				var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop";
				var w = 1200;
				var h = 900; 
				itmInfoPopup(url,w,h,itemID);		
			} 
			else{
				var url = "compareAttribute.do?s_itemID="+itemID+"&preChangeSet="+preChangeSet+"&changeSet="+changeSet;
				var w = 1200;
				var h = 800;
				window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
			}
		}
	});
</script>