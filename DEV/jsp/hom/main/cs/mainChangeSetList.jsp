<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용

	$(document).ready(function() {
		// 초기 표시 화면 크기 조정
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 370)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 280)+"px;");
		};
		
		$("#excel").click(function(){	fnGridExcelDownLoad();  });
		$("input.datePicker").each(generateDatePicker);
		$('.searchList').click(function(){
			doSearchList(); 
			return false;
		});
		
		$("#statusCode").val("${StatusCode}");
		$("#changeTypeCode").val("${ChangetypeCode}");
		$("#actionTypeCode").val("${ActionTypeCode}");
		
		doSearchList();
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	var layout = new dhx.Layout("grdGridArea", { 
			rows: [
				{
					id: "a",
				},
			]
		});
	
		var gridData = ${gridData};
		var grid = new dhx.Grid(null, {
			columns: [
				{ width: 35, id: "RNUM", header: [{ text: "No" , align: "center" }], align: "center" },
				{ hidden: true, width: 35, id: "checkbox", header: [{ text: "" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
				{ width: 120, id: "Identifier", header: [{ text: "ID" , align: "center" }], align: "center" },
				{ fillspace: true, id: "ItemName", header: [{ text: "Name", align: "center" }], align: "center" },
				{ width: 110, id: "AuthorTeamName", header: [{ text: "${menu.LN00018}", align: "center" }], align: "center" },
				{ width: 55, id: "ChangeTypeName", header: [{ text: "${menu.LN00042}", align: "center" }], align: "left" },
				{ width: 90, id: "LastUserNM", header: [{ text: "${menu.LN00105}", align: "center" }], align: "center" },
				{ width: 80, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align: "center" }] , align: "center"},				
				{ hidden: true, width: 50, id: "ItemID", header: [{ text: "", align: "center" }], align: "center" }
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data: gridData
		});
		layout.getCell("a").attach(grid);

		//그리드ROW선택시
		grid.events.on("cellClick", function(row,column,e){
			if(column.id != "checkbox"){
				gridOnRowOTSelect(row);
			}
		}); 

		//그리드ROW선택시
		function gridOnRowOTSelect(row) {
			var itemID = row.ItemID;
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop&screenMode=pop";
			var w = 1200;
			var h = 900;
			itmInfoPopup(url,w,h,itemID);
		}
	
	// END ::: GRID	
	//===============================================================================


	//조회
	function doSearchList(){
		var sqlID = "cs_SQL.getChangeSetMultiList";
		var param = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&ItemTypeCode=${itemTypeCode}"  
					+"&Status=MOD"
					+"&qryOption=${qryOption}"		
					+"&changeType=${changeType}"
					+"&LIST_PAGE_SCALE=5&scrnType=main"
					+"&sqlID="+sqlID;

		if("${classCode}" != '' && "${classCode}" != null){
   			param += "&classCodeList='${classCode}'";
   		}
   		if("${dimTypeID}" != '' && "${dimTypeID}" != null && "${dimValueID}" != '' && "${dimValueID}" != null){
   			var dimValueID = new Array();
   			dimValueID.push('${dimValueID}');
   			param += "&isNotIn=N&DimTypeID=${dimTypeID}&DimValueIDOLM_ARRAY_VALUE="+dimValueID;
   		}


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

	function fnReloadGrid(newGridData){
 		grid.data.parse(newGridData);
 	}


</script>
<style>
	.objbox{overflow:hidden !important;}
</style>
</head>
<body>
<div id="itemAuthorList">     
	<div id="grdGridArea" style="width: 100%;"></div>
</div>	
</body>
</html>

