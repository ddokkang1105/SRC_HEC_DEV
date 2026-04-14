<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:url value="/" var="root"/> 

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046"/>
 
<style>
	.row-css {
		background: #eff6ff;
	}
</style>

<script type="text/javascript">
	var gridArea;
	var dimTypeID = "${dimTypeID}";
	var dimValueID = "${dimValueID}";

	$(document).ready(function(){
		$("#layout").attr("style","height:"+(setWindowHeight() - 210)+"px;");
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 210)+"px;");
		};
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('dimTypeId', data, 'getDimensionTypeID', dimTypeID, 'Select');
		if(dimTypeID != "") fnGetDimValueID(dimTypeID, dimValueID);
		
		$("#excel").click(function(){ fnGridExcelDownLoad(); });
		window.parent.closeMaskLayer();
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function fnOpenLink(itemID,url,lovCode,attrTypeCode){
		var url = url+".do?itemID="+itemID+"&lovCode="+lovCode+"&attrTypeCode="+attrTypeCode;
	
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h);
	}
	
	function fnItemPopUp(itemID){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,itemID);
	}
	
	function fnGetDimValueID(dimTypeID, dimValueID) {
		var data = "&dimTypeId="+dimTypeID+"&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('dimValueId', data, 'getDimTypeValueId', dimValueID, 'Select');
	}
	
	function fnView() {
		var url = "e2eProcessTreeInfo.do";
		var data = "&s_itemID=${s_itemID}&elmClass=${elmClass}&modelID="+$("#modelList").val()
						+"&dimTypeID="+$("#dimTypeId").val()
						+"&dimValueID="+$("#dimValueId").val();
		var target = "actFrame";
		ajaxPage(url, data, target);
	}
	
	function fnCollapseL4(){
		var ch = gridArea.hasChildren(1);
		for(var i=0; i<ch; i++){
			var lev1 = gridArea.getChildItemIdByIndex(1,i);
			gridArea.closeItem(lev1);
		}
	}
</script>
<style type="text/css">
	div.gridbox_dhx_web.gridbox .odd_dhx_web {background:none;}
	div.gridbox_dhx_web.gridbox table.obj tr.rowselected {background:none;}
	div.gridbox_dhx_web.gridbox table.obj.row20px tr.rowselected td {background:none;}
	.row20px img{   height:11px;  }
	.row20px div img{  height:18px;  }
	#filter{margin-bottom:20px; margin-top: 10px;}
	.layout_cell {padding-right: 1.5%;float:left;}
	.layout_cell label:first-child { margin-right: 5px; cursor: auto; font-weight: 700;}
</style>
</head>
<body>
<div id="processDIV">
<form name="procInstFrm" id="procInstFrm" action="#" method="post" onsubmit="return false;">
	<div class="child_search pdB5">
		<li class="floatL"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;&nbsp;<b>E2E Process Tree Info</b></li>
	</div>
	<div id="filter">
		<div class="layout_cell">
			<label>${menu.LN00125}</label>
			<select id="modelList" name="modelList" style="width:250px;">
				<c:forEach var="i" items="${modelList}">
				 <option value="${i.ModelID }" <c:if test="${modelID eq  i.ModelID}">selected</c:if>>${i.Name} (${i.MTCName})</option>
				</c:forEach>
			</select>
		</div>
		<div class="layout_cell">
			<label>${menu.LN00088}</label>
			<select id="dimTypeId" name="dimTypeId" style="width:100px;" onChange="fnGetDimValueID(this.value)">
				<option value="">Select</option>
			</select>
			<select id="dimValueId" name="dimValueId" style="width:100px;">
				<option value="">Select</option>
			</select>
		</div>
		<span class="btn_pack medium icon mgR10"><span class="search"></span><input value="View" type="submit" onclick="fnView()"></span>
		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		<div class="floatR">
			<img src="${root}${HTML_IMG_DIR}/csr_right_blue.png" onclick="expandAll()" style="width:16px;margin-right:5px;cursor: pointer;" title="expand">
			<img src="${root}${HTML_IMG_DIR}/csr_minus_blue.png" onclick="collapseAll()" style="width:16px;cursor: pointer;" title="collapse">
		</div>
	</div>
	<div id="layout" style="width:100%;"></div>
</form>
</div>
<iframe id="saveFrame" name="saveFrame" style="display:none;width:0px;height:0px;"></iframe>
<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});

	var treeData = ${treeGridData};

	var grid = new dhx.Grid("", {
		type: "tree",
		columns: [
	    	{ width: 500, id: "ItemName", type: "string", header: [{ text: "${menu.LN00028}", align:"center" }, { content: "inputFilter" }], htmlEnable : true,
	            template: (value, row, col) => {
	            	let result;
	            	if(row.id == "1") {
	            		if(row.ModelID) result = "<span style='font-weight: bold;'><img src='${root}${HTML_IMG_DIR_ITEM}/img_sitemap.png' class='mgR5'>"+row.ItemName+"</span>";
	            		else result = "<span style='font-weight: bold;'><img src='${root}${HTML_IMG_DIR_ITEM}/img_sitemap.png' class='mgR5'> No model exists</span>";
	            	}
	            	else if(row.ItemTypeImg) result = "<img src='${root}${HTML_IMG_DIR_ITEM}/"+row.ItemTypeImg+"' class='mgR5'>"+ (row.Identifier ? row.Identifier : "") +" "+row.ItemName;
	            	else result = "<img src='${root}${HTML_IMG_DIR_ITEM}/"+row.ClassIcon+"' class='mgR5'>"+(row.Identifier ? row.Identifier : "") +" "+row.ItemName;
	                return result;
	            }
	        },
	    	{ id: "Path", type: "string", header: [{ text: "${menu.LN00043}", align:"center" }, { content: "inputFilter" }]},
	    	{ width: 150, id: "roleName", type: "string", header: [{ text: "${menu.LN00119}", align:"center" }, { content: "selectFilter" }], align: "center"},
	    	{ width: 60, id: "link", type: "string", header: [{ text: "Link", align:"center" }, { content: "inputFilter" }], align: "center", htmlEnable : true},
	    	{ width: 100, id: "OwnerTeamName", type: "string", header: [{ text: "${menu.LN00018}", align:"center" }, { content: "selectFilter" }], align: "center"},
	    	{ width: 100, id: "ItemStatusText", type: "string", header: [{ text: "${menu.LN00027}", align:"center" }, { content: "selectFilter" }], align: "center", htmlEnable : true},
	    	{ width: 100, id: "LastUpdated", type: "string", header: [{ text: "${menu.LN00070}", align:"center" }, { content: "inputFilter" }], align: "center"},
	    ],
	    autoWidth: true,
	    resizable: true,
	    data : treeData
	});
	
	layout.getCell("a").attach(grid);
	
	grid.data.getInitialData().filter(e => e.parent == "1")?.forEach(e => {
	    grid.addRowCss(e.id, "row-css");
	})
	
	grid.events.on("cellClick", (row, column, event) => {
		if(row.id != "1" && !event.target.className.includes("dhx_grid-expand-cell-icon")){
			if(column.id === "link") {
				if(row.linkUrl != "") fnOpenLink(row.ItemID, row.linkUrl, row.lovCode, row.attrTypeCode);
			}
			else if(column.id === "roleName") {
				if(row.roleID != "") fnItemPopUp(row.roleID);
			}
			else if(column.id === "OwnerTeamName") {
				var w = "1200";
				var h = "800";
				var url = "orgMainInfo.do?id="+row.OwnerTeamID;
				window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
			}
			else {
				fnItemPopUp(row.ItemID);
			}
		}
	});
	
	function expandAll() {
		grid.expandAll();
	}

	function collapseAll() {
	    grid.data.getInitialData().filter(e => e.parent === "1").forEach(e => {
	        grid.collapse(e.id);
	    })
	}
</script>
</body>
</html>