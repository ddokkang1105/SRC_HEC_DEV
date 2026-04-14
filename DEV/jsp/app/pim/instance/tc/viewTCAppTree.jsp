<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00168" var="WM00168" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00042" var="CM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00132" var="WM00132" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00114" var="WM00114" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="${menu.LN00004}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00168" var="WM00168" arguments="${menu.LN00148}"/>
<!-- 2. Script -->
<script type="text/javascript">

	var gridArea;				
	var skin = "dhx_skyblue";
	var objIds = new Array;
	var elmInstNos = new Array;
	var elmItemIDs = new Array;
	var procInstNos= new Array;
	
	var gridData = ${gridData}
	
	function fnDownLoadExcel() {
		$('#fileDownLoading').removeClass('file_down_off');
		$('#fileDownLoading').addClass('file_down_on');
		
		var url = "testObjectReportExcel.do";
		ajaxSubmit(document.testObjectFrm, url);
	}
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	
	
	//===============================================================================
	// BEGIN ::: GRID
// 	function setElmGridList(){
// 		var treePData="${elmTreeXml}";
// 		console.log("treePData :"+treePData);
// 	    gridArea = new dhtmlXGridObject('gridArea');
// 	    gridArea.selMultiRows = true;
// 	    gridArea.imgURL = "${root}${HTML_IMG_DIR_ITEM}/";
// 	    gridArea.setImagePath("${root}${HTML_IMG_DIR_ITEM}/");
// 	    gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
// 		gridArea.setHeader("${menu.LN00028},${menu.LN00043},${menu.LN00119} / ${menu.LN00004},Link,CxnItemID,LinkURL,LovCode,AttrTypeCode,${menu.LN00027},테스트 결과,Test Date,ElmInstNo");
// 		gridArea.setInitWidths("420,330,180,50,50,50,50,50,150,120,120,80");
// 		gridArea.setColAlign("left,left,center,center,left,left,left,left,center,center,center,center");
// 		gridArea.setColTypes("tree,ro,ro,img,ro,ro,ro,ro,ro,icon,ro,ro");
// 		gridArea.setColSorting("str,str,str,str,str,str,str,str,str,str,str,str");
//    	  	gridArea.init();
// 		gridArea.setSkin("dhx_web");
// 		gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
// 		gridArea.loadXMLString(treePData);
	
// 		gridArea.setColumnHidden(4, true);
// 		gridArea.setColumnHidden(5, true);
// 		gridArea.setColumnHidden(6, true);
// 	 	gridArea.setColumnHidden(7, true);
// 		gridArea.setColumnHidden(11, true);
// 		gridArea.enableTreeCellEdit(false);
// 		gridArea.checkAll(false);
// 	}
	
	// END ::: GRID	
	//===============================================================================
	
	//조회
// 	function doSearchList(){
// 		//gridArea.loadXML("${root}" + "${xmlFilName}");
// 		var d = setGridData();
// 		fnLoadDhtmlxGridJson(gridArea, d.key, d.cols, d.data, "", "", "", "", "", "${WM00119}", 1000);
	
// 	}
	

	
	function fnPimElementInfo(procInstNo,elmInstNo){
		var url = "viewTCDetail.do?";
		var data = "procInstNo="+procInstNo+"&elmInstNo="+elmInstNo+"&instanceClass=ELM"; 
	    var w = "1000";
		var h = "800";
	    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");	
	}
	
	function fnOpenLink(itemID,url,lovCode,attrTypeCode){
		var url = url+".do?itemID="+itemID+"&lovCode="+lovCode+"&attrTypeCode="+attrTypeCode;
	
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h);
	}

	function fnViewTODetail(procInstNo,elmInstNo){
		var url = "viewTODetail.do?";
		var data = "procInstNo="+procInstNo+"&elmInstNo="+elmInstNo+"&instanceClass=ELM&testCase=Y&List=Y"; 
	    var w = "1400";
		var h = "800";
	    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");	

	}
	
	function fnCopyElm(){
		var url = "selectTestObject.do?modelID=${procModelID}&instanceNo=${instanceNo}&processID=${nodeID}";
		var w = 800;
		var h = 900;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function fnCallBackSubmit() {
		doSearchList();
	}
	function fnCallBackEnsembleUserList(errorMessage, errortype) {
		if(errortype == 0){
			alert(errorMessage + "${WM00114}");	
		}else if(errortype == 1){
			alert(errorMessage + "${WM00168}");	
		}
	}
	
	function fnDeleteAll(){
		if (confirm("${CM00042}")) {
			var url  = "deleteElmInst.do";
			var data = "&procInstNo=${instanceNo}";
			var target = "saveFrame";
			ajaxPage(url,data,target);
		}
	}
	
	function fnReload() {
		goProcInstanceInfoEdit("V");
	}
	
	function doFileDown(avg1, avg2) {
		var url = "fileDown.do";
		$('#original').val(avg1);
		$('#filename').val(avg1);
		$('#scrnType').val(avg2);
		
		ajaxSubmitNoAlert(document.testObjectFrm, url);
		$('#fileDownLoading').addClass('file_down_off');
		$('#fileDownLoading').removeClass('file_down_on');
	}
</script>
<style type="text/css">
	
	 .row20px div img{  height:18px;  }
	 .objbox{
		overflow-x:hidden!important;
		}
	div.gridbox_dhx_web.gridbox .odd_dhx_web {background:none;}
	.fa {
	    width: 9px;
	    height: 9px;
	    display: block;
	    margin: 0 auto;
	    border-radius: 2px;
	}
	.fa-gray {
		background: #bbb;
	}
	.fa-blue {
		background: #183ec5;
	}
	.fa-red {
		background: #ea0c0c;
	}
}
</style>
</head>
<body>
<div id="fileDownLoading" class="file_down_off">
	<img src="${root}${HTML_IMG_DIR}/loading_circle.gif"/>
</div>
<div style="width:100%;height:100%;">
 <div class="countList">
		<ul>
			<c:if test="${sessionScope.loginInfo.sessionUserId eq procInstanceInfo.OwnerID || sessionScope.loginInfo.sessionUserId eq prcMap.AuthorID}">
		    <li class="floatR mgR20">
				<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel" onclick="fnDownLoadExcel()"></span>
			</li>
			</c:if>
		</ul>
    </div>
	<form name="testObjectFrm" id="testObjectFrm" action="#" method="post" onsubmit="return false;" style="height: 100%;">
		<input type="hidden" id="original" name="original" value="">
		<input type="hidden" id="filename" name="filename" value="">
		<input type="hidden" id="downFile" name="downFile" value="">
		<input type="hidden" id="scrnType" name="scrnType" value="">
		<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
		
		<input type="hidden" id="procModelID" name="procModelID" value="${procModelID }">
		<input type="hidden" id="instanceNo" name="instanceNo" value="${instanceNo }">
		<input type="hidden" id="processID" name="processID" value="${nodeID }">
		<input type="hidden" id="instanceClass" name="instanceClass" value="${instanceClass }">
	   
		<div id="layout" class="mgB10 clear" style="height: 100%;"></div>
	</form>
	</div>

	<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
	
	<script>
	
		async function fnReloadGrid(newGridData){
			console.log("loading new grid data: ");
			console.log(newGridData);
	 		await grid.data.parse(newGridData);
	 	}
		
		var layout = new dhx.Layout("layout", {
		    rows: [
		        {
		            id: "a",
		        },
		    ]
		});
		
		var gridData = ${gridData}
		
		var grid = new dhx.Grid("grid", {
			type : "tree",
		    columns: [
		        { width: 420, id: "itemName", header: [{ text: "${menu.LN00028}", align: "center" }, { content: "inputFilter" }], align: "left", htmlEnable : true },
		        {             id: "Path", header: [{ text: "${menu.LN00043}", align: "center" }, { content: "inputFilter" }], align: "left" },
		        { width: 180, id: "roleName", header: [{ text: "${menu.LN00119} / ${menu.LN00004}", align: "center" }, { content: "inputFilter" }], align: "left" },
		        { width: 50, id: "linkImg", header: [{ text: "Link", align: "center" }], align: "center",  htmlEnable : true,
		        	template: function (text, row, col) {
		        		return text && '<img src="${root}${HTML_IMG_DIR}/item/'+text+'" />';
		            }
		        },
		        { hidden: true, width: 120, id: "CxnItemID", header: [{ text: "CxnItemID", align: "center" }], align: "left" },
		        { hidden: true, width: 120, id: "linkUrl", header: [{ text: "LinkURL", align: "center" }], align: "left" },
		        { hidden: true, width: 120, id: "lovCode", header: [{ text: "LovCode", align: "center" }], align: "left" },
		        { hidden: true, width: 120, id: "attrTypeCode", header: [{ text: "AttrTypeCode", align: "center" }], align: "left" },
		        { width: 150, id: "statusName", header: [{ text: "${menu.LN00027}", align: "center" }, { content: "inputFilter" }], align: "center",  htmlEnable : true },
		        { width: 120, id: "AT00402Style", header: [{ text: "테스트 결과", align: "center" }, { content: "inputFilter" }], align: "center", htmlEnable : true,
		        	template: function (text, row, col) {
		        		return row.AT00402Style && '<div class="dhx_grid_icon" title=""><i class="fa fa-'+text+'" title=""></i></div>'	
		        	}
		        },
		        { width: 120, id: "testDate", header: [{ text: "Test Date", align: "center" }], align: "center" },
		        { hidden: true, width: 80, id: "ElmInstNo", header: [{ text: "ElmInstNo", align: "center" }], align: "center" },
		    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    data: gridData
		});
		
		console.log("gridData");
		console.log(gridData);
		
		layout.getCell("a").attach(grid);
		 
		grid.events.on("cellClick", function(row,column,e){

			if(column.id == "linkImg"){
				var itemID = row.CxnItemID;
				var linkUrl = row.linkUrl;
				var lovCode = row.lovCode;
				var attrTypeCode = row.attrTypeCode;
				if(linkUrl){
					fnOpenLink(itemID,linkUrl,lovCode,attrTypeCode);
				}
			}else{
	            var elmInstNo=row.ElmInstNo;
	            if (elmInstNo==""||elmInstNo==undefined){                
	            }else{fnPimElementInfo("${instanceNo}",elmInstNo);}
			}
			
		 });
	</script>
	
</body>
</html>