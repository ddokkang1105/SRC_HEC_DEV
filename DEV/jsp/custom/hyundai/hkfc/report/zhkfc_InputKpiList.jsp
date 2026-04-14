<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagIncV7.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00068" var="WM00068" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="Year"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00116" var="WM00116" arguments="data"/>

<!-- 2. Script -->
<script type="text/javascript">
	var imgKind = "asp jsp php war cer cdx asa html htm js aspx exe dll txt";  
	
	$(document).ready(function() {	
		fnInitGrid();
		
		// 초기 표시 화면 크기 조정 
		//$("#grid").attr("style","height:"+(setWindowHeight() - 210)+"px;");
		// 화면 크기 조정
		/* window.onresize = function() {
			$("#grid").attr("style","height:"+(setWindowHeight() - 210)+"px;");
		}; */
/* 
		 $('#FD_FILE_PATH').change(function(){
	        var upfile = $(this).val();
	        if("" != upfile) {
		    	var strKind=upfile.substring(upfile.lastIndexOf(".")+1).toLowerCase();
		    	var isCheck = false;
		    	var imgKinds = imgKind.split(' ');
		    	for(var i=0; i<imgKinds.length; i++){if(strKind == imgKinds[i]){ isCheck = true;}}
		    	
		    	if(isCheck){
		    		$('#txtFilePath').val(""); $('#FD_FILE_PATH').val("");
		    	}else{
		    		$('#txtFilePath').val( upfile ); doFileUpload();
		    	}
	        }
		 });				 */
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function fnOpenTeamInfoMain(teamID){
		var w = "1200";
		var h = "800";
		var url = "orgMainInfo.do?id="+teamID;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function doDetail(avg){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg);
	}
	
	function fnUpload(){ 
		 $('#FD_FILE_PATH').click();
	}
	
	function doFileUpload() {
		var url = "zhfkc_procExcelUpload.do";
		$('#fileDownLoading').removeClass('file_down_off');
		$('#fileDownLoading').addClass('file_down_on');
		ajaxSubmitNoAdd(document.commandMap, url, "blankFrame");	
	}
	
	function doSave(result) {
		var url = "zhfkc_procExcelSave.do";
		var data = {uploadExcelResult : result, languageID : "${sessionScope.loginInfo.sessionCurrLangType}"};
		if( confirm("${WM00071}" + "${CM00021}")) {

			$('#fileDownLoading').removeClass('file_down_off');
			$('#fileDownLoading').addClass('file_down_on');
			ajaxPage(url, data, "blankFrame");
		}		
	}
	
	function doCntReturn(tCnt, vCnt, aCnt, type, fileId, result, headerName, errMsgYN, fileName, downFile){
		$('#fileDownLoading').removeClass('file_down_on');
		$('#fileDownLoading').addClass('file_down_off');
		$("#TOT_CNT_E").val(tCnt);
		$("#FILE_VALD_CNT").val(vCnt);
		$("#FILE_NM").val(fileId);
		$("#ATTR_CNT").val(aCnt);
		$("#headerName").val(headerName);
		if(errMsgYN=="Y"){ 
			$('#original').val(fileName);
			$('#filename').val(fileName);
			$('#downFile').val(downFile);
			$('#errMsgYN').val(errMsgYN);
		}
		if(result.length > 0){
			doSave(result);
		}else{
			if(errMsgYN=="Y"){
				errorTxtDown();
			}
		}
	}
	
	function errorTxtDown(fileName, downFile) {
		var url = "fileDown.do";
		
		ajaxSubmitNoAlert(document.commandMap, url);
	}
	
</script>

</head>
<form name="commandMap" id="commandMap" enctype="multipart/form-data" action="zhfkc_procExcelSave.do" method="post" onsubmit="return false;">
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}"/>
	<input type="hidden" id="option" name="option" value="${option}"/>
	<input type="hidden" id="userId" name="userId" value="${sessionScope.loginInfo.sessionUserId}">
	<input type="hidden" id="selectedLang" name="selectedLang" value=""/>
	<input type="hidden" id="uploadTemplate" name="uploadTemplate" value=""/>
	<input type="hidden" id="uploadOption" name="uploadOption" value=""/>
	<input type="hidden" id="FILE_VALD_CNT" name="FILE_VALD_CNT" value="">
	<input type="hidden" id="TOT_CNT_E" name="TOT_CNT_E" value="">
	<input type="hidden" id="FILE_NM" name="FILE_NM" value="">
	<input type="hidden" id="ATTR_CNT" name="ATTR_CNT" value="">
	<input type="hidden" id="headerName" name="headerName" value="">
		<input type="hidden" id="editedRow" name="editedRow" value=""></input> 
	
	<input type="hidden" id="original" name="original" value="">
	<input type="hidden" id="filename" name="filename" value="">
	<input type="hidden" id="downFile" name="downFile" value="">
	<input type="hidden" id="errMsgYN" name="errMsgYN" value="">
	<input type="hidden" id="scrnType" name="scrnType" value="excel">
	
	<div class="pdL10 pdR10">	
		<input type="hidden" id="currPage" name="currPage" value="${currPage}"></input>
		<input type="hidden" id="defaultLang" name="defaultLang" value="${defaultLang}">
		<input type="hidden" id="isComLang" name="isComLang" value="">
		<div class="title-section">
	   		Input PMI List
	   		
	       	<span class="floatR btn_pack small icon mgR10"><span class="add"></span>	<input value="Add new year" type="submit" id="Save" OnClick="fnSaveAll();"></span>
	   		
		</div>
		<div id="grid" style="width: 100%;height:680px;"></div>
		<div id="pagination"></div>
	</div>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</form>
<script>
var gridData = ${gridData};
var gridConfig = {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" }], align: "center"},
	        { width: 30, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" }], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 110, id: "ObjectCode", header: [{ text: "${menu.LN00011} ID" }], editable:false },
	        { width: 130, id: "ObjectName", header: [{ text: "${menu.LN00011} ${menu.LN00028}" }], editable:false },
	        { width: 90, id: "KpiCode", header: [{ text: "${menu.ZLN0010}${menu.ZLN0005} ID" }], editable:false },
	        { width: 300, id: "KpiName", header: [{ text: "${menu.ZLN0010}${menu.ZLN0005} ${menu.LN00028}" }], editable:false },
	        { width: 180, id: "TeamName", header: [{ text: "${menu.ZLN0011}" }], editable:false },
	        { width: 150, id: "RoleManagerNM", header: [{ text: "${menu.LN00011} ${menu.LN00004}" }], editable:false },
	        { width: 70, id: "Year", header: [{ text: "Year" }] },

	        // hidden value
	        { width: 70, id: "TeamID", header: [{ text: "TeamID" }], hidden : true },
	        { width: 70, id: "RoleManagerID", header: [{ text: "RoleManagerID" }], hidden : true },
	        { width: 70, id: "ProcItemID", header: [{ text: "ProcItemID" }], hidden : true },
	        { width: 70, id: "KpiItemID", header: [{ text: "KpiItemID" }], hidden : true },
	        { width: 70, id: "TeamID", header: [{ text: "TeamID" }], hidden : true },
	        { width: 70, id: "RoleManagerID", header: [{ text: "RoleManagerID" }], hidden : true },
	        { width: 80, id: "YearOrg", header: [{ text: "YearOrg" }], align: "center" , hidden:true}
	        
	    ],
	   
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    multiselection: true,
	    tooltip: false,
	    editable: true
	};
	
	var grid;
	var pagination;
	var editedRow = [];
	function fnInitGrid(){
		grid = new dhx.Grid("grid", gridConfig);
		grid.data.parse(gridData);
		pagination = new dhx.Pagination("pagination", {
		    data: grid.data,
		    pageSize: 20,
		});
		
		grid.events.on("AfterEditStart", function (row, col, editorType) {
			if(col.id != "KpiLastUpdated" && col.id != "Remark")
		    dhx.awaitRedraw().then(function () {
		        var element = document.querySelector(".dhx_cell-editor")
		        element.type = "number"
		    })
		});
	}

	function fnSaveAll(){
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });	
		
		if(!selectedCell.length){
			alert("${WM00023}");
			return false;
		}
		var s_itemID = "${s_itemID}";
		var Year = "";
		var kpiName = "";
		var teamName = "";
		var procItemID = "";
		var kpiItemID = "";
		var teamID = "";
				
		if(confirm("${CM00001}")){
			for(idx in selectedCell){
				
				Year = selectedCell[idx].Year;
				kpiName = selectedCell[idx].KpiName;
				teamName = selectedCell[idx].TeamName;
				
				if(Year == ""){
					//alert(kpiName +"["+ teamName + "] 연도를 입력하세요."); return;
					alert("${WM00034}" + "( " + kpiName +"["+ teamName + "] )"); return;
				}
			}
			
			// 증복체크
			for(idx in selectedCell){
				var inputFields = {
					ProcItemID: selectedCell[idx].ProcItemID,
					KpiItemID: selectedCell[idx].KpiItemID,
					TeamID: selectedCell[idx].TeamID,
				    Year: selectedCell[idx].Year
				};
				
				console.log("check duplicates :"+fnCheckForDuplicates(inputFields));
				if(fnCheckForDuplicates(inputFields)) {
					//alert(selectedCell[idx].KpiName +"["+ selectedCell[idx].TeamName + "] 연도는 중복된 데이타가 있습니다.");
					alert("${WM00116}" + "( " + selectedCell[idx].KpiName +"["+ selectedCell[idx].TeamName + "] )");
					return;
				}
			}
			
			for(idx in selectedCell){
				selectedCell[idx].YearOrg = "";
				editedRow.push(selectedCell[idx]);	
			}		
								
			var jsonData = JSON.stringify(editedRow);

       		$.ajax({
   		        type: "POST",
   		        data: {"editedRow" : jsonData, "s_itemID" : s_itemID, "company" : "${company}", "newKpi" : "Y", "year" : "${year}"},
   		        url: "zhkfc_saveKpiList.do",
   		        async: false,
   		        success: function(data) {
   		        	editedRow = [];
   		        	opener.fnInit("Y");
   		        	//opener.doSaveReturn(data,"Y");
   		        	alert("${WM00067}");
   		        	
   		        	window.open('', '_self', '');
   		        	window.close();
   		        }, error:function(request,status,error){
   		        	alert("${WM00068}");
   		        }
   		    });
		}
		
	}
	

	function fnCallBack(newGridData){

		//grid.data.parse(newGridData);
	}
	
	// 중복을 체크할 함수
	function fnCheckForDuplicates(inputFields) {
		var pmiListData = ${pmiListData};
		
	    for (var i = 0; i < pmiListData.length; i++) {
	        var isDuplicate = true;
	        for (var field in inputFields) {
	            if (pmiListData[i][field] !== inputFields[field]) {
	                isDuplicate = false;
	                break;
	            }
	        }
	        if (isDuplicate) {
	            return true; 
	        }
	    }
	    return false; 
	}
</script>
</html>