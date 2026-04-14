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

<script type="text/javascript">

	var gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	
	var userId = "${sessionScope.loginInfo.sessionUserId}";	
	var Authority = "${sessionScope.loginInfo.sessionAuthLev}";
	var selectedItemLockOwner = "${selectedItemLockOwner}";
	var selectedItemAuthorID = "${selectedItemAuthorID}";
	var selectedItemBlocked = "${selectedItemBlocked}";
	var selectedItemStatus = "${selectedItemStatus}";
	var showVersion = "${showVersion}";
	var showValid = "${showValid}";
	var showPath = "${showPath}";
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 350)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 350)+"px;");
		};
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemTypeCode=${itemTypeCode}";
		fnSelect('languageID', data, 'langType', '${sessionScope.loginInfo.sessionCurrLangType}', 'Select');
	
		$("input.datePicker").each(generateDatePicker);
		
		$("#blocked").click(function(){
			if(!$(this).is(':checked')) {
				$("#filtered").val("N");
			}
			else {
				$("#filtered").val("Y");				
			}
			fnReload();
		});
		
		$("#excel").click(function(){ fnGridExcelDownLoad(); });
		
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
	
	function fnCheckItemArrayAccRight(seq, DocumentID, id){
		$.ajax({
			url: "checkItemArrayAccRight.do",
			type: 'post',
			data: "&itemIDs="+DocumentID+"&seq="+seq,
			error: function(xhr, status, error) { 
			},
			success: function(data){				
				data = data.replace("<script>","").replace(";<\/script>","");		
				fnCheckAccCtrlFileDownload(data, seq, DocumentID, id);
			}
		});	
	}
	
	function fnCheckAccCtrlFileDownload(data, seq, DocumentID, id, strItemID){
		var dataArray = data.split(",");
		var accRight = dataArray[0];
		var fileName = dataArray[1];
		
		if(accRight == "Y"){
			if(id == "FileIcon"){ // 다운로드 이미지 클릭시 
				var url  = "fileDownload.do?seq="+seq;
					ajaxSubmitNoAdd(document.fileFrm, url,"blankFrame");			
			}else{						
				var url  = "documentDetail.do?&seq="+seq
						+"&DocumentID="+DocumentID+"strItemID="+strItemID
						+"&itemTypeCode=${itemTypeCode}&fltpCode=${fltpCode}";
				var w = 1200;
				var h = 500;
				itmInfoPopup(url,w,h); 	
			}
		}else{			
			alert(fileName + "은 ${WM00033}"); return;
		}
	}
	
	function fnFileDownload(){
		var seq = new Array();
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		
		if(!selectedCell.length){
			alert("${WM00049}");	
		} else {
			for(idx in selectedCell){
				seq[idx] = selectedCell[idx].Seq;
			};
			
			$("#seq").val(seq);
			var url  = "fileDownload.do";
			ajaxSubmitNoAdd(document.fileFrm, url,"blankFrame");
		}
	}	
	
	function fnStrItemFileDownLoad(){
		var url  = "zSkdc_strItemfileDownload.do?strItemID=${strItemID}&s_itemID=${s_itemID}";
		ajaxSubmitNoAdd(document.fileFrm, url,"blankFrame");
	}

	function fnBlock(){
		var seq = new Array();
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		
		if(!selectedCell.length){
			alert("${WM00023}"); return;
		} else {
			for(idx in selectedCell){
				seq[idx] = selectedCell[idx].Seq;
			};
		}
		
		if(confirm("${CM00001}")){	
			var url  = "updateFileBlocked.do";
			var data = "&seq="+seq;
			ajaxPage(url,data,"blankFrame");
		}
	}
	
	function doSearchList(){
		fnReload();
	}
	
	function setSubFrame(){
		fnReload();
	}
	
	function fnClearSearch(){
		$("#identifier").val("");
		$("#itemName").val("");
		$("#AT00000").val("");
		$("#level").val("");
		$("#levelName").val("");
	}
	
	function fnGoFileList(){
		var url = "zSkdc_subItemFileList.do";
		var target = "editSubItemFileDiv";
		var data = "s_itemID=${s_itemID}&strItemID=${strItemID}&mstItemID=${mstItemID}&udfSTR=${udfSTR}"; 
	 	ajaxPage(url, data, target);
	}
	
	function fnSaveAttrText(){
		var editedRow = [];
		if(!confirm("${CM00001}")){ return;}
		
		for(var i=0; i< grid.data._order.length; i++) {
			editedRow.push(grid.data._order[i]);	
		}	
		
		var jsonData = JSON.stringify(editedRow);		
		$("#updateData").val(jsonData);		
		
		var url = "zSkdc_updateItemAttr.do";	
		ajaxSubmitNoAdd(document.fileFrm, url, "blankFrame")
	}
	
	
</script>
<style>
	.cmm-btn {border: 1px solid #dfdfdf; background: #fff;border-radius: 3px;height: 33px;transition: all .2s ease-out;}
</style>
<body>
<div id="editSubItemFileDiv" name="editSubItemFileDiv" >
<form name="fileFrm" id="fileFrm" action="" method="post" onsubmit="return false">
	<input type="hidden" id="itemAthId" name="itemAthId" value="${selectedItemAuthorID}">
	<input type="hidden" id="Blocked" name="Blocked" value="${selectedItemBlocked}" />
	<input type="hidden" id="LockOwner" name="LockOwner" value="${selectedItemLockOwner}" />	
	<input type="hidden" id="sysFileName" name="sysFileName">
	<input type="hidden" id="originalFileName" name="originalFileName">
	<input type="hidden" id="filePath" name="filePath" >
	<input type="hidden" id="seq" name="seq" >	
	<input type="hidden" id="filtered" value="Y"> 
	<input type="hidden" id="updateData" name="updateData" >
	
	
   	
	<div class="countList pdT5" >
	  	<li class="count mgT10 floatL">Total  <span id="TOT_CNT"></span></li>
    	<li class="floatR mgR20">
    		<span id="backBtn" class="btn_pack nobg white"><a class="clear" onclick="fnGoFileList()" title="Back"></a></span>	
    		<span id="saveAllBtn" class="btn_pack nobg" ><a class="save" id="Input" OnClick="fnSaveAttrText()" title="Save All"></a></span>	
        </li>
    </div>
	<div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>
</form>

<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>
</body>

<style>

    .edit_cell {
		background: #E3F0FE;
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
	        { width: 50, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center"},
	       
	        { width: 80, id: "Identifier", header: [{text: "ID", align:"center"}], align: "center"},
	        { width: 280, id: "ItemName", header: [{ text: "${menu.LN00028}", align:"center" }], htmlEnable: true, align:"left"},	
	        { width: 300, id: "FileRealName", header: [{ text: "${menu.LN00101}", align:"center"},{content : "inputFilter"}], align:"left" , hidden: true},
	        
	        { width: 125, id: "L0ItemName", header: [{text: "L0", align:"center"},{content : "selectFilter"}], align: "center"},
	        { width: 125, id: "L1ItemName", header: [{text: "L1", align:"center"},{content : "selectFilter"}], align: "center"},
	        { width: 125, id: "L2ItemName", header: [{text: "L2", align:"center"},{content : "selectFilter"}], align: "center"},
	        { width: 125, id: "L3ItemName", header: [{text: "L3", align:"center"},{content : "selectFilter"}], align: "center"},
	        { width: 125, id: "L4ItemName", header: [{text: "L4", align:"center"},{content : "selectFilter"}], align: "center"},
	        { width: 125, id: "L5ItemName", header: [{text: "L5", align:"center"},{content : "selectFilter"}], align: "center"},
	        { width: 180, id: "ItemNo", header: [{text: "설비 Item No.", align:"center"},{text : "설비 Item No를 입력하세요." }], align: "center", editable: true
	        	,mark: function (cell, data) { return "edit_cell"; }},
	        
	        { width: 60, id: "StrItemID", header: [{ text: "${menu.LN00030}", align:"center" }], align:"center", hidden: true},
	        { width: 60, id: "MstItemID", header: [{ text: "mstItemID", align:"center" }], align:"center", hidden: true}
	      
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    multiselection : true   
	    
	});
	
	$("#TOT_CNT").html(grid.data.getLength());
	
	//var tranSearchCheck = false;
	grid.events.on("cellClick", function(row,column,e){
		var seq = row.Seq;
		var isNew = "N";
		var DocumentID = row.DocumentID;	
		var strItemID = row.StrItemID;
		
		if(column.id != "checkbox" && column.id != "ItemNo"){
			if( '${loginInfo.sessionMlvl}' != "SYS"){
				fnCheckItemArrayAccRight(seq, DocumentID, column.id, strItemID); // 접근권한 체크후 DownLoad
			}else{
				var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+strItemID+"&scrnType=pop";
				var w = 1200;
				var h = 900; 
				itmInfoPopup(url,w,h,strItemID);
			}
		}
	 }); 
	 
	 grid.events.on("filterChange", function(row,column,e,item){
		$("#TOT_CNT").html(grid.data.getLength());
	 });

	 layout.getCell("a").attach(grid);
	 
	 if(pagination){pagination.destructor();}
	 pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});
	
 	function fnReload(){ 
 		var varFilter ="${classCode}";
		var classCode = "";
		if(varFilter != ""){
			var classCodeSpl = varFilter.split(",");				
				if(classCodeSpl.length >0){
					for(var i=0; i<classCodeSpl.length; i++){
					if(i==0){
						classCode += "'"+classCodeSpl[i]+"'";
					}else{
			  			classCode += ",'"+classCodeSpl[i]+"'";
					}
				}
			}
		}
		if($("#startLastUpdated").val() != "" && $("#endLastUpdated").val() == "")	$("#endLastUpdated").val(new Date().toISOString().substring(0,10));
		
		var level = $("#level").val();
		var levelName = $("#levelName").val();
		var categoryCode = "ST2";
		if("${udfSTR}"=="Y"){
			categoryCode = "ST3";
		}
		
		var sqlID = "custom_SQL.zSkdc_getSubItemFileList";
		var param =  "strItemID=${strItemID}"	
				+ "&s_itemID=${mstItemID}"
			 	+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			 	+ "&identifier="+$("#identifier").val()
				+ "&itemName="+$("#itemName").val()
				+ "&AT00000="+$("#AT00000").val()
				+ "&categoryCode="+categoryCode
				+ "&sqlID="+sqlID;
				
				if(level == "L1"){
					param = param + "&L1="+levelName;
				} else if(level == "L2"){
					param = param + "&L2="+levelName;
				} else if(level == "L3"){
					param = param + "&L3="+levelName;
				} else if(level == "L4"){
					param = param + "&L4="+levelName;
				} else if(level == "L5"){
					param = param + "&L5="+levelName;
				}
				
				console.log("param: "+param);
			
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
 		fnMasterChk('');
 		$("#TOT_CNT").html(grid.data.getLength());
 	}
 	
</script>

</html>