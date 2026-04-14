﻿<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00021" var="CM00021"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00019" var="WM00019"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00071" var="WM00071"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00116" var="WM00116" arguments="Year"/>

<!-- 2. Script -->
<script type="text/javascript">
	var imgKind = "asp jsp php war cer cdx asa html htm js aspx exe dll txt";  
	var originData; //원본 데이터
	
	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 250)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 250)+"px;");
		};
		
		// 수정버튼 show / 저장버튼 hide
		$("#editBtn").css("display","inline-block");
		$("#saveAllBtn").css("display","none");
		
		// 엑셀 업로드
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
		 });	
		
		// 필터링
		fnInit("N");
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
		ajaxSubmit(document.commandMap, url, "blankFrame");	
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
	
	function doReturn(errMsgYN, fileName, downFile){
		$('#fileDownLoading').removeClass('file_down_on');
		$('#fileDownLoading').addClass('file_down_off');
	
		if(errMsgYN=="Y"){ 
			$('#original').val(fileName);
			$('#filename').val(fileName);
			$('#downFile').val(downFile);
			$('#errMsgYN').val(errMsgYN);
			var url = "fileDown.do";
			
			ajaxSubmitNoAlert(document.commandMap, url);
		}else{
			fnInit("N");
		}
		
	}
	function fnDownload() {
		fnGridExcelDownLoad("", "Y");
	};

	function fnOpenInputPop() {
		var year = document.getElementById("year").value;
		var url = "zhkfc_InputKpiList.do?"
				+"&s_itemID=${s_itemID}"
				+"&year="+year
				+"&itemTypeCode=${itemTypeCode}";
		
		var w = 1400;
		var h = 900;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
     
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
	
	<input type="hidden" id="original" name="original" value="">
	<input type="hidden" id="filename" name="filename" value="">
	<input type="hidden" id="downFile" name="downFile" value="">
	<input type="hidden" id="errMsgYN" name="errMsgYN" value="">
	<input type="hidden" id="scrnType" name="scrnType" value="excel">
	
	<input type="hidden" id="mode" name="mode" value="">
	
	<div class="pdL10 ">	
		<input type="hidden" id="currPage" name="currPage" value="${currPage}"></input>
		<input type="hidden" id="defaultLang" name="defaultLang" value="${defaultLang}">
		<input type="hidden" id="isComLang" name="isComLang" value="">
		<div class="title-section" >
	   		<span style="padding-right:20px;" > Process Monitoring Index </span>	   		 
			<select id="company" OnChange="fnApplyFilters()" width="250px">
				<option value=""> ${menu.LN00014}</option>
			</select>
			<select id="year" OnChange="fnApplyFilters()" width="250px">
				<option value="">Year</option>
			</select>	
	   		<span class="floatR btn_pack nobg white"><a class="xls" id="excel" OnClick="fnDownload();" title="Excel"></a></span>
	   		<c:if test="${myItemCnt > 0 || roleMNID eq sessionScope.loginInfo.sessionUserId || sessionScope.loginInfo.sessionAuthLev < 2}">
	   			<span class="floatR btn_pack nobg mgR6" ><a class="del" OnClick="fnDeleteRow()" title="Delete Row"></a></span>
	   			<span class="floatR btn_pack nobg mgR6"><a class="upload" title="Upload" >
		       	<input type="text" id="txtFilePath" readonly onfocus="this.blur()" class="txt_file_upload" style="display:none;"/>
		       	<input style="padding:23px 0px 8px 9px;" value="up" type="button" id="data" OnClick="fnUpload()">        	
		       	<input type="file" name="FD_FILE_PATH" id="FD_FILE_PATH" class="file_upload2" style="display:none;"></a>
		       	</span>

	       		<span class="floatR btn_pack nobg mgR6"><a class="add" id="Input" OnClick="fnOpenInputPop();" title="Input"></a></span>
	       	   	<span id="saveAllBtn" class="floatR btn_pack nobg mgR6" ><a class="save" id="save" OnClick="fnSaveAll()" title="Save All"></a></span>
	   		   	<span id="editBtn" class="floatR btn_pack nobg mgR6"><a class="edit" id="Input" OnClick="fnEdit()" title="Edit"></a></span>
	   		   	
			</c:if>
		</div>
		<div id="layout" style="width: 100%;"></div>
		<div id="pagination"></div>
	</div>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</form>
<script>

	var jsonData;
	
	const companyData = ${companyList};
	const selectBoxCompany = document.getElementById("company");
	
	companyData.forEach((company) => {
		 const option = document.createElement("option");
	     option.value = company.CODE;
	     option.text = company.NAME;
	     selectBoxCompany.appendChild(option);
	});
	
	
	// 연도 select box 설정
	var kpiList = ${gridData};
	var yearList = new Set();
	
	var currentDate = new Date();
	var currentYear = currentDate.getFullYear().toString();
	
	kpiList.forEach(function(item) {
		yearList.add(item.Year);
	});
	
	// 금년도 초기설정
	if(!yearList.has(currentYear)) {
		yearList.add(currentYear);
	}
	
	var selectBoxYear = document.getElementById("year");
	yearList.forEach(function(year) {
	  var option = document.createElement("option");
	  option.value = year;
	  option.textContent = year;
	  selectBoxYear.appendChild(option);
	});
	// 초기설정
	selectBoxYear.value = currentYear;
	
	var gridData;
	var gridConfig = {
		    columns: [
		        { width: 40, id: "RNUM", header: [{ text: "${menu.LN00024}", align: "center"}], align: "center",editable:false},
		        { width: 30, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" }], align: "center", type: "boolean", editable: true, sortable: false, htmlEnable : true},
		        { width: 80, id: "ProcCode", header: [{ text: "${menu.LN00011} ID", align: "center"}, { content: "selectFilter" }], editable:false },
		        { width: 150, id: "ProcName", header: [{ text: "${menu.LN00011} ${menu.LN00028}", align: "center" }, { content: "inputFilter" }], align: "center", editable:false },
		        { width: 160, id: "KpiName", header: [{ text: "${menu.ZLN0010}${menu.ZLN0005} ${menu.LN00028}", align: "center"}, { content: "inputFilter" }], align: "center", editable:false },
		        { width: 110, id: "TeamName", header: [{ text: "${menu.ZLN0011}", align: "center"}, { content: "selectFilter" }], align: "center", editable:false},
		        { width: 100, id: "KpiLastUpdated", header: [{ text: "${menu.ZLN0012}", align: "center"}, { content: "inputFilter" },{ align: "center"}], align: "center" , type: "date", format: '%Y/%m/%d', editable:false },	  
		        { width: 50, id: "TargetValue", header: [{ text: "${menu.ZLN0013}", align: "center"}], align: "center" },
		        { width: 100, id: "AT00009TEXT", header: [{ text: "${menu.ZLN0014}", align: "center" },{content:"selectFilter"}], align: "center", editable:false },
		        { width: 140, id: "RoleManagerNM", header: [{ text: "${menu.LN00011} ${menu.LN00004}", align: "center" },{content:"selectFilter"}], align: "center", editable:false },
		        { width: 70, id: "Year", header: [{ text: "Year", align: "center"}, { content: "selectFilter"}], align: "right" },
		        { width: 70, id: "Month1", header: [{ text: "Jan(1월)", align: "center" }], align: "right" },
		        
		        { width: 70, id: "Month2", header: [{ text: "Feb(2월)", align: "center" }], align: "right" },
		        { width: 70, id: "Month3", header: [{ text: "Mar(3월)", align: "center" }], align: "right" },
		        { width: 70, id: "Month4", header: [{ text: "Apr(4월)", align: "center" }], align: "right" },
		        { width: 70, id: "Month5", header: [{ text: "May(5월)", align: "center" }], align: "right" },
		        { width: 70, id: "Month6", header: [{ text: "Jun(6월)", align: "center" }], align: "right" },
		        { width: 70, id: "Month7", header: [{ text: "Jul(7월)", align: "center" }], align: "right" },
		        { width: 70, id: "Month8", header: [{ text: "Aug(8월)", align: "center" }], align: "right" },
		        { width: 70, id: "Month9", header: [{ text: "Sep(9월)", align: "center" }], align: "right" },
		        { width: 70, id: "Month10", header: [{ text: "Oct(10월)", align: "center" }], align: "right" },
		        { width: 70, id: "Month11", header: [{ text: "Nov(11월)", align: "center" }], align: "right" },
		        { width: 70, id: "Month12", header: [{ text: "Dec(12월)" }], align: "right" },
		        { width: 70, id: "Result", header: [{ text: "${menu.LN00256}${menu.ZLN0015}", align: "center" }], align: "right" , editable : false},
		        { width: 150,id: "Remark", header: [{ text: "${menu.ZLN0016}", align: "center" },{ content: "inputFilter" }], align: "center", gravity: 1 } ,
		        // hidden value
		        { width:80,id: "ProcItemID", header: [{ text: "ProcItemID" }], align: "center", hidden:true },
		        { width:80,id: "KpiItemID", header: [{ text: "KpiItemID" }], align: "center", hidden:true },
		        { width:80, id: "YearOrg", header: [{ text: "YearOrg" }], align: "center" , hidden:true},
		        { width:80, id: "TeamID", header: [{ text: "TeamID" }], align: "center" , hidden:true},
		        { width:70, id: "RoleManagerID", header: [{ text: "RoleManagerID" }], hidden : true },
		        { width:80, id: "dimensionCompayList", header: [{ text: "dimensionCompayList" }], align: "center", hidden:true },
		    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "complex",
		    multiselection: true,
		    tooltip: false
		};

	var grid;
	var editedRow = [];
	var pagination;
	var layout;
	
	var ids;
	
	function doSaveReturn(newGridData, savecallback){
		if (grid) {
	        grid.destructor();
	        layout.destructor();
	        pagination.destructor();
	    }
		layout = new dhx.Layout("layout", {
		    rows: [
		        {
		            id: "a",
		        },
		    ]
		});
		grid = new dhx.Grid("gridDiv", gridConfig);
		grid.data.parse(newGridData);
		pagination = new dhx.Pagination("pagination", {
		    data: grid.data,
		    pageSize: 20,
		});
		
		layout.getCell("a").attach(grid);
		ids = new Array();
		grid.events.on("CellClick", function(row,column,e){
			if(column.id === "ProcCode" || column.id === "ProcName") doDetail(row.ProcItemID);
			if(column.id === "KpiName") doDetail(row.KpiItemID);
			if(column.id === "TeamName") fnOpenTeamInfoMain(row.TeamID);
		});
	
		grid.events.on("AfterEditStart", function (row, col, editorType) {
			if(col.id != "KpiLastUpdated" && col.id != "Remark")
		    dhx.awaitRedraw().then(function () {
		        var element = document.querySelector(".dhx_cell-editor")
		        element.type = "number"
		    })
		    
		    // 수정 항목 추가
		    if(!ids.includes(row.id)) {
				ids.push(row.id);
				editedRow.push(row);
			}
		});
	
		grid.events.on("afterEditEnd", function (row, col, editorType) {
			var editedData = grid.data.serialize(); // 편집이 반영된 data
			var columnsToCheck = ["ProcItemID", "KpiItemID", "TeamName","Year"];
			
			var  hasDuplicate = checkDuplicates(editedData, columnsToCheck);
			if(hasDuplicate != ""){
				alert("${WM00116}");
			}
		});
		
		if(savecallback == "Y"){
			grid.config.editable = false;
			$("#editBtn").css("display","inline-block");
			$("#saveAllBtn").css("display","none");
			
			events = "";
		}
		
	}
	
	function fnEdit() {
		$("#mode").val("EDT");
		fnInit("N");
		
		grid.config.editable = true;
		$("#editBtn").css("display","none");
		$("#saveAllBtn").css("display","inline-block");
		
		events = "";
	}
	
	function fnSaveAll(){
		var s_itemID = "${s_itemID}";
		var jsonData = JSON.stringify(editedRow);
		var year = selectBoxYear.value;
		
		if (editedRow.length == 0 ){
			alert("${WM00019}");
			return false;
		} else {
			if(confirm("${CM00001}")){
				$("#mode").val("");
				var jsonData = JSON.stringify(editedRow);
				
				$.ajax({
			        type: "POST",
			        data: {"editedRow" : jsonData, "s_itemID" : s_itemID, "year" : year },
			        url: "zhkfc_saveKpiList.do",
			        async: false,
			        success: function(data) {
			        	editedRow = [];		        	
			        	fnInit("Y");
			        	alert("${WM00067}");		        	
			        }, error:function(request,status,error){
			        	alert("${WM00068}");
			        }
			    });
			}
		}
	}
	
	// 중복체크 로직  //
	function checkDuplicates(jsonData, columns) {
	  var setMap = {};
	  var duplicates = [];
	
	  for (var i = 0; i < jsonData.length; i++) {
	    var key = "";
	    for (var j = 0; j < columns.length; j++) {
	      key += jsonData[i][columns[j]] + "-";
	    }
	
	    if (setMap[key]) {
	      duplicates.push(key);
	    } else {
	      setMap[key] = true;
	    }
	  }
	  
	  return duplicates;
	}
	
	function fnInit(savecallback){
		var s_itemID = "${s_itemID}";
		var year = "";
		var itemTypeCode = "${itemTypeCode}";
		var sessionID = "${sessionScope.loginInfo.sessionUserId}";
		var sessionLev = "${sessionScope.loginInfo.sessionAuthLev}";
		var mode = $("#mode").val();
		
		$.ajax({
	        type: "POST",
	        data: { "s_itemID" : s_itemID, "year" : year, "itemTypeCode" : itemTypeCode, "mode" : mode},
	        url: "zhkfc_getKpiList.do",
	        async: false,
	        success: function(data) {	
	        	data = JSON.parse(data);
	        	
	        	originData = data;
	        	doSaveReturn(data, savecallback);
	        	
	        	fnApplyFilters();
	        }, error:function(request,status,error){
	        }
	    });
	}
	
	function fnApplyFilters() {
		var company = selectBoxCompany.value;
		var year = selectBoxYear.value;
		
		var data = originData;
		
		if(company != null && company != ""){
			data = data.filter(function(e){
				if(e.CompanyList.indexOf(company) > -1) return e; 
			});
		}
		
		if(year != null && year != ""){
			data = data.filter(function(e){
				return e.Year === year;
			});
		}
		
		doSaveReturn(data, "N");
		
	}

	function fnDeleteRow(){
		var selectedCell = grid.data.findAll(function (data) {
		    return data.checkbox;
		});
		if(!selectedCell.length){
			alert("${WM00023}");
			return false;
		}
				
		if(confirm("${CM00004}")){
			var itemIDs = new Array();	
			var kpiItemIDs = new Array();
			var yearOrgs = new Array();
			var teamIDs = new Array();
			
			for(idx in selectedCell){
				itemIDs.push(selectedCell[idx].ProcItemID);
				kpiItemIDs.push(selectedCell[idx].KpiItemID);
				yearOrgs.push(selectedCell[idx].YearOrg);
				teamIDs.push(selectedCell[idx].TeamID);
			}
			var url = "zHKFC_deleteKkpiValue.do";
			var data = "s_itemID=${s_itemID}&itemIDs="+itemIDs+"&kpiItemIDs="+kpiItemIDs+"&yearOrgs="+yearOrgs+"&teamIDs="+teamIDs;
			var target = "blankFrame";
			ajaxPage(url, data, target);
		}
	}

</script>
</html>