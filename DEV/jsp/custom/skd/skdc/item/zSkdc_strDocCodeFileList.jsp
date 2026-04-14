<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00123" var="WM00123"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00021" var="WM00021D" arguments="Delete "/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00057" var="CM00057"/>

<script type="text/javascript">
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 220)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 220)+"px;");
		};
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
	
	function doSearchList(){
		fnReload();
	}

	function fnMultiUploadV4(){ 
		var url="addFilePopV4.do";
		var data="scrnType=ITM_M&docCategory=ITM&id=${mstItemID}";
		
		openPopup(url+"?"+data,480,450, "Attach File");
	}	
	
	function fnEditFileName(){		
	    var url = "editFileNamePop.do"; 
	    var option = "width=550, height=570, left=100, top=100,scrollbar=yes,resizble=0";
	    window.open("editFileNamePop.do?DocumentID=${mstItemID}", "", option);	 
    }
	
	function doSearchList(){
		var url = "zSkdc_strDocCodeFileList.do";
		var target = "fileFrm";
		var data = "s_itemID=${s_itemID}&strItemId=${strItemID}&mstItemID=${mstItemID}"; 
	 	ajaxPage(url, data, target);
	}
	
	function fnDeleteFile(){
		var seq = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
		
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00021D}");	
		} else {			
			var chkBlock = "";
			var documentID = "";
			var itemID = "${mstItemID}";
			for(idx in selectedCell){							
				seq[idx] = selectedCell[idx].Seq;
				sysFileName[idx] =  selectedCell[idx].Seq;
				filePath[idx] = selectedCell[idx].Seq;
			}
			if(confirm("${CM00002}")){
				var url = "deleteFileFromLst.do";
				var data = "&itemId=${mstItemID}&seq="+seq+"&sysFile="+sysFileName+"&filePath="+filePath;
				var target = "blankFrame";
				ajaxPage(url, data, target);	
			}
		}
	}
	
	function setSubFrame(){
		doSearchList();
	}
	
	function fnGetCSR(){
		if(!confirm("${CM00001}")){ return;}
		if(grid.data.getLength() == 0){
			alert("분류할 문서를 업로드 하세요.");
			return; 
		} 
			
		var projectNameList = "${projectNameList}";
		var projectListSize = "${projectNameListSize}";
		
		if(parseInt(projectListSize)> 0){
			var url = "cngCheckOutPop.do?";
			var data = "s_itemID=${ItemID}&checkType=CreateItem";
			var option = "width=480px, height=300px, left=200, top=100,scrollbar=yes,resizble=0";
		 	window.open(url+data, 'CreateItem', option);
		}else{
			if(confirm("${CM00057}")){
				var url = "registerCSR.do?itemID=${ItemID}&checkType=CreateItem";
				window.open(url,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizble=0');
			}
		}
	}
	
	function fnCallback(csrID){
		fnExeReport(csrID);
	}
	
	function fnExeReport(csrID){ 
		var editedRow = [];
		
		for(var i=0; i< grid.data._order.length; i++) {
			editedRow.push(grid.data._order[i]);	
		}	
		
		var jsonData = JSON.stringify(editedRow);	
		jsonData = encodeURIComponent(jsonData);
	
		var url  = "zSkdc_createStrWithDocCode.do";
		var data = "&s_itemID=${s_itemID}&strItemID=${strItemID}&mstItemID=${mstItemID}&updateData="+jsonData+"&csrID="+csrID;
		ajaxPage(url,data,"subFrame");
	}
	
</script>
<body>
<form name="fileFrm" id="fileFrm" action="" method="post" onsubmit="return false">	
	<div class="countList" >
	  	<li class="count mgT10 floatL">Total  <span id="TOT_CNT"></span></li>
    	<li class="floatR mgR10">
            <span class="btn_pack nobg"><a class="save" onclick="fnGetCSR()" title="Create Document"></a></span>
            <span class="btn_pack nobg"><a class="upload" onclick="fnMultiUploadV4()" title="Upload"></a></span>
            <span class="btn_pack nobg"><a class="list" onclick="fnEditFileName();" title="Rename"></a></span>
            <span class="btn_pack nobg white"><a class="del" onclick="fnDeleteFile()" title="Delete"></a></span>
        </li>
    </div>
	<div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>
</form>
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</body>

<!-- custom styles -->
<style>
	/* .dhx_grid-row:hover {
		background-color: var(--dhx-color-primary-light-hover);
	} */
	
	/*
	.dhx_grid-cell:hover {
	background: rgba(65, 152, 247, 0.15);
    cursor: pointer;
    box-shadow: 2px 0px 0px 0px #4265ee inset;
    transition: background-color .2s ease-out;
    */
    
    .edit_cell {
		background: #E3F0FE;
	}
	
	.my_custom_mark {
		background: lightcoral;
	}
	
}
</style>

<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid;
	var pagination;
	var gridData = ${gridData};
	
	var grid = new dhx.Grid("grid",  {
	    columns: [
	        { width: 38, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center"},
	        { width: 30, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" }], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 200, id: "PlainText", header: [{ text: "${menu.LN00101}", align:"center"},{content : "inputFilter"}], align:"left"},
	        { width: 130, id: "L0ItemName", header: [{text: "L0", align:"center"},{content : "selectFilter"}], align: "center"},
	        { width: 130, id: "L1ItemName", header: [{text: "L1", align:"center"},{content : "selectFilter"}], align: "center"},
	        { width: 140, id: "L2ItemName", header: [{text: "L2", align:"center"},{content : "selectFilter"}], align: "center"},
	        { width: 140, id: "L3ItemName", header: [{text: "L3", align:"center"},{content : "selectFilter"}], align: "center"},
	        { width: 140, id: "L4ItemName", header: [{text: "L4", align:"center"},{content : "selectFilter"}], align: "center"},
	        { width: 140, id: "L5ItemName", header: [{text: "L5", align:"center"},{content : "selectFilter"}], align: "center"},
	        { width: 160, id: "NewIdentifier", header: [{text: "Document Code", align:"center"}], align: "center"},
	        
	        { width: 155, id: "AT00000", header: [{text: "설비 Item No.", align:"center"},{text : "설비 Item No를 입력하세요." }]
	        	, align: "center", editable: true
	        , htmlEnable: true, mark: function (cell, data) { return "edit_cell"; } 
	        },
	        { width: 180, id: "Description", header: [{text: "비고", align:"center"}], align: "center"},
	        { width: 60, id: "Seq", header: [{ text: "Seq", align:"center" }], align:"center", hidden: true},
	        { width: 200, id: "errLogYN", header: [{text: "errLogYN", align:"center"}], align: "center", hidden: true},
	        { width: 60, id: "L0ItemID", header: [{ text: "L0ItemID", align:"center" }], align:"center", hidden: true},
	        { width: 125, id: "L1ItemID", header: [{text: "L1ItemID", align:"center"},{content : "selectFilter"}], align: "center", hidden: true},
	        { width: 125, id: "L2ItemID", header: [{text: "L2ItemID", align:"center"},{content : "selectFilter"}], align: "center", hidden: true},
	        { width: 125, id: "L3ItemID", header: [{text: "L3ItemID", align:"center"},{content : "selectFilter"}], align: "center", hidden: true},
	        { width: 125, id: "L4ItemID", header: [{text: "L4ItemID", align:"center"},{content : "selectFilter"}], align: "center", hidden: true},
	        { width: 125, id: "L5ItemID", header: [{text: "L5ItemID", align:"center"},{content : "selectFilter"}], align: "center", hidden: true},
	      
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    selection : true 
	    	    
	});
	
	$("#TOT_CNT").html(grid.data.getLength());
	
	 grid.events.on("filterChange", function(row,column,e,item){
		$("#TOT_CNT").html(grid.data.getLength());
	 });

	 layout.getCell("a").attach(grid);
	 
	 
	 
	 if(pagination){pagination.destructor();}
	 pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});
 	
</script>

</html>