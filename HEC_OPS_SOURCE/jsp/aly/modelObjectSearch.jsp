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

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_1" arguments="${menu.LN00033}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_2" arguments="${menu.LN00021}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>

<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;			
	var p_gridDownArea;
	
	$(document).ready(function() {	
		$("input.datePicker").each(generateDatePicker);
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		};
		
		$("#excel").click(function(){p_gridArea.toExcel("${root}excelGenerate");doExcel();});
		$("#excelData").click(function(){fnDownData();});
		$('#btnSearch').click(function(){
			$("#currPage").val("");
			doSearchList();
			return false;
		});
		
		$('#category').change(function(){changeCategory($(this).val());});
		
		$('#ItemTypeCode').change(function(){
			changeItemTypeCode($(this).val()); // 계층 option 셋팅
			changeClassCode("", $(this).val()); // 속성 option 초기화
			changeSbOption($(this).val()); // symbol option
		});
		// 속성 option 셋팅 : 선택된 classCode를 조건으로
		$('#classCode').change(function(){changeClassCode($(this).val(), "");});
		
		//fnSelect('ItemTypeCode', '&Deactivated=1', 'itemTypeCode', '${ItemTypeCode}', 'Select');
		fnSelect('Status', '&Category=ITMSTS', 'dictionyCode', '', 'Select'); // 아이템 상태 조건
		
		// Attr Lov option 셋팅 : 선택된 AttrTypeCode의 DataType이 [LOV] 일때
		// 						선택된 AttrTypeCode의 DataType이 [LOV] 가 아닐때는 searchValue textbox를 표시
		$('#AttrCode').change(function(){changeAttrCode($(this).val());});
		
		$('#constraint').change(function(){changeConstraint($(this).val());});
		
		$('#searchValue').keypress(function(onkey){
			if(onkey.keyCode == 13){doSearchList();return false;}
		});		
		gridInit();gridDownInit();
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//===============================================================================
	// BEGIN ::: GRID
	function gridInit(){		
		var d = setGridData();		
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
		
		p_gridArea.setColumnHidden(11, true); // Report
		p_gridArea.setColumnHidden(12, true);
		p_gridArea.setColumnHidden(13, true);
		fnSetColType(p_gridArea, 1, "ch");
		fnSetColType(p_gridArea, 2, "img");	
		fnSetColType(p_gridArea, 11, "img");
		
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		
		//START - PAGING
		p_gridArea.enablePaging(true, 1000, null, "pagingArea", true, "recinfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
		//END - PAGING
	}	
	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "search_SQL.getSearchList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00042},${menu.LN00016},${menu.LN00015},${menu.LN00028},${menu.LN00043},${menu.LN00014},${menu.LN00018},${menu.LN00004},${menu.LN00070},Report,ItemID,ClassCode";
		result.cols = "CHK|ItemTypeImg|ClassName|Identifier|ItemName|Path|TeamName|OwnerTeamName|Name|LastUpdated|Report|ItemID|ClassCode";
		result.widths = "50,50,50,100,100,220,*,120,120,70,70,60,0,0"; // base 검색
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,left,left,left,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&defaultLang=" + $("#defaultLang").val()
					+ "&isComLang=" + $("#isComLang").val()
		 			+ "&pageNum=" + $("#currPage").val();
		 			
		/* [기본정보] 조건 선택, 입력값 */
		result.data = result.data+ setAllCondition();
		
		/* [속성] 조건 선택, 입력값 */
		var attrArray = new Array();
		var valueArray = new Array();
		var aval = "";	
		var lovCode = "";
		var searchValue = "";
		var AttrCodeEscape = "";
		var constraint = "";
		var selectOption = "";
		
		if ($("#constraint").val() == "") {
			if ($("#AttrLov").val() != "" || $("#searchValue").val() != "") {
				if ("Y" == $("#isLov").val()) {
					//result.data = result.data+ "&AttrCodeOLM_MULTI_VALUE=" + attrArray;;
					//result.data = result.data+ "&lovCode=" + $("#AttrLov").val();
					attrArray[0] = $("#AttrCode").val();
					lovCode = $("#AttrLov").val();
				} else {
					//result.data = result.data+ "&AttrCodeOLM_MULTI_VALUE=" + attrArray;;
					$("#isSpecial").val("");
					//result.data = result.data+ "&searchValue=" + setSpecialChar($("#searchValue").val());
					// result.data = result.data+ "&AttrCodeEscape=" + $("#isSpecial").val();
					
					attrArray[0] = $("#AttrCode").val();
					searchValue = setSpecialChar($("#searchValue").val());
					AttrCodeEscape= $("#isSpecial").val();
				}
				selectOption = "AND";
			}
		} else {			
			//result.data = result.data+ "&constraint=" + $("#constraint").val();
			//result.data = result.data+ "&AttrCodeOLM_MULTI_VALUE=" + attrArray;
			
			constraint= $("#constraint").val();
			attrArray[0] = $("#AttrCode").val();
		}
		
		valueArray.push(lovCode);
		valueArray.push(searchValue);
		valueArray.push(AttrCodeEscape);
		valueArray.push(constraint);
		valueArray.push(selectOption);
		
		attrArray.push(valueArray);
		
		result.data = result.data+ "&CategoryCode=" + $('#category').val();		
		result.data = result.data+ "&ItemTypeCode=" + $('#ItemTypeCode').val();
		result.data = result.data+ "&ClassCode=" + $("#classCode").val();
		if(searchValue != "") result.data = result.data+ "&AttrCodeOLM_MULTI_VALUE=" + attrArray;
		
		return result;
	}
	
	function gridDownInit(){		
		var d = setGridDownData();		
		p_gridDownArea = fnNewInitGrid("grdGridDownArea", d);
		p_gridDownArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridDownArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
/* 
		//START - PAGING
		p_gridDownArea.enablePaging(true, 1000, null, "pagingArea", true, "recinfoArea");
		p_gridDownArea.setPagingSkin("bricks");
		p_gridDownArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
		//END - PAGING */
	}	
	
	function setGridDownData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "search_SQL.getSearchList";
		result.header = "${menu.LN00024},${menu.LN00016},ItemID,${menu.LN00028}";
		result.cols = "ClassName|ItemID|ItemName";
		result.widths = "50,180,80,200"; // base 검색
		result.sorting = "int,str,str,str";
		result.aligns = "center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&defaultLang=" + $("#defaultLang").val()
					+ "&isComLang=" + $("#isComLang").val()
		 			+ "&pageNum=" + $("#currPage").val();
		 			
		/* [기본정보] 조건 선택, 입력값 */
		result.data = result.data+ setAllCondition();
		
		/* [속성] 조건 선택, 입력값 */
		if ($("#constraint").val() == "") {
			if ($("#AttrLov").val() != "" || $("#searchValue").val() != "") {
				if ("Y" == $("#isLov").val()) {
					result.data = result.data+ "&AttrCode=" + $("#AttrCode").val();
					result.data = result.data+ "&lovCode=" + $("#AttrLov").val();
				} else {
					result.data = result.data+ "&AttrCode=" + $("#AttrCode").val();
					$("#isSpecial").val("");
					result.data = result.data+ "&searchValue=" + setSpecialChar($("#searchValue").val());
					result.data = result.data+ "&AttrCodeEscape=" + $("#isSpecial").val();
				}
			}
		} else {
			result.data = result.data+ "&constraint=" + $("#constraint").val();
			result.data = result.data+ "&AttrCode=" + $("#AttrCode").val();
		}
		
		result.data = result.data+ "&CategoryCode=" + $('#category').val();		
		result.data = result.data+ "&ItemTypeCode=" + $('#ItemTypeCode').val();
		result.data = result.data+ "&ClassCode=" + $("#classCode").val();
		
		return result;
	}
	
	// [기본정보] 모든 조건 검색 입력
	function setAllCondition() {
		var condition = "";
		if ($("#detailID").val() != "" ) { // Identifier 
			condition = condition+ "&AttrCodeBase2=Identifier";
			$("#isSpecial").val("");
			condition = condition+ "&baseCondition2=" + setSpecialChar($("#detailID").val());
			condition = condition+ "&baseCon2Escape=" + $("#isSpecial").val();
		}
		if ($("#detailCompanyId").val() != "" ) { // 법인
			condition = condition+ "&CompanyID=" + $("#detailCompanyId").val();
		}
		if ($("#detailOwnerTeam").val() != "" ) { // 관리조직
			$("#isSpecial").val("");
			condition = condition+ "&OwnerTeam=" + setSpecialChar($("#detailOwnerTeam").val());
			condition = condition+ "&ownerTeamEscape=" + $("#isSpecial").val();
		}
		if ($("#detailAuthor").val() != "" ) { // 담당자
			$("#isSpecial").val("");
			condition = condition+ "&Name=" + setSpecialChar($("#detailAuthor").val());
			condition = condition+ "&nameEscape=" + $("#isSpecial").val();
		}
		if ($("#SC_STR_DT1").val() != "" && $("#SC_END_DT1").val() != "" ) { // 생성일
			condition = condition+ "&CreationTime=Y";
			condition = condition+ "&scStartDt1=" + $("#SC_STR_DT1").val();
			condition = condition+ "&scEndDt1=" + $("#SC_END_DT1").val();
		}
		if ($("#SC_STR_DT2").val() != "" && $("#SC_END_DT2").val() != "" ) { // 수정일
			condition = condition+ "&LastUpdated=Y";
			condition = condition+ "&scStartDt2=" + $("#SC_STR_DT2").val();
			condition = condition+ "&scEndDt2=" + $("#SC_END_DT2").val();
		}
		if ($("#symbolCode").val() != "" ) { // Symbol
			condition = condition+ "&DefSymCode=" + $("#symbolCode").val();
		}
		return condition;
	}
	
	// [검색 조건] 특수 문자 처리
	function setSpecialChar(avg) {
		var result = avg;
		var strArray =  result.split("[");
		
		if (strArray.length > 1) {
			result = result.split("[").join("[[]");
		}
		
		strArray =  result.split("%");
		if (strArray.length > 1) {
			result = result.split("%").join("!%");
			$("#isSpecial").val("Y");
		}
		
		strArray =  result.split("_");
		if (strArray.length > 1) {
			result = result.split("_").join("!_");
			$("#isSpecial").val("Y");
		}
		
		strArray =  result.split("@");
		if (strArray.length > 1) {
			result = result.split("@").join("!@");
			$("#isSpecial").val("Y");
		}
		
		return result;
	}
	
	// [row click]
	function gridOnRowSelect(id, ind){
		if(ind != 1) {
			if(ind == 11){
				goReportList(p_gridArea.cells(id, 12).getValue());
			} else {
				doDetail(p_gridArea.cells(id, 12).getValue());
			}
		}
	}
	
	function doSearchList(){
		if ($('#category').val() == "") {
			alert("${WM00041_1}");
			return false;
		}
		if ($('#ItemTypeCode').val() == "") {
			alert("${WM00041_2}");
			return false;
		}
		var d = setGridData();
		//fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
		/* 건수 제한 메세지 표시 */
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data, "", "", "", "", "", "${WM00119}", 1000);
	}
	
	
	// END ::: GRID	
	//===============================================================================

	function doDetail(avg){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg);
	}
	
	// [항목유형 option] 설정
	function changeCategory(avg){
		if (avg == "MOJ") {
			avg = "OJ";
		}
		var url    = "getItemTypeSelectOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&category="+avg; //파라미터들
		var target = "ItemTypeCode";             // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}
	
	// [계층 option] 설정
	function changeItemTypeCode(avg){
		var url    = "getClassCodeOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&option="+avg; //파라미터들
		var target = "classCode";             // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}
	
	// [속성 option] 설정
	// 항목계층 SelectBox 값 선택시  속성 SelectBox값 변경
	function changeClassCode(avg1, avg2){
		$("#isLov").val("");
		$("#searchValue").attr('style', 'display:inline;width:150px;');
		$("#AttrLov").attr('style', 'display:none;width:120px;');
		$("#constraint").val("").attr("selected", "selected");
		var url    = "getSearchSelectOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&sqlID=search_SQL.attrBySearch&s_itemID="+avg2+"&s_itemID2="+avg1; //파라미터들
		var target = "AttrCode";            // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
		setTimeout(appendOption,1000);
	}
	function appendOption(){
		var optionName = '${menu.LN00028}';
		 $("#AttrCode").prepend("<option value='AT00001'>"+optionName+"</option>");
		 $("#AttrCode").val("AT00001").attr("selected", "selected");
	}
	
	// [LOV option] 설정
	// 화면에서 선택된 속성의 DataType이 Lov일때, Lov selectList를 화면에 표시
	function changeAttrCode(avg){
		var url = "getAttrLov.do";		
		var data = "attrCode="+avg;
		var target="blankFrame";
		ajaxPage(url, data, target);
	}
	function changeAttrCode2(attrCode, dataType, isComLang) {
		var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
		// isComLang == 1 이면, 속성 검색 의 언어 조건을 defaultLang으로 설정 해줌
		if (isComLang == '1') {
			languageID = "${defaultLang}";
			$("#isComLang").val("Y");
		} else {
			$("#isComLang").val("");
		}
		
		if (dataType == "LOV") {
			$("#isLov").val("Y");
			$("#AttrLov").attr('style', 'display:inline;width:120px;');
			$("#searchValue").attr('style', 'display:none;width:150px;');	
			
			var url    = "getAttrLovSelectOption.do"; // 요청이 날라가는 주소
			var data   = "languageID="+languageID+"&attrCode="+attrCode; //파라미터들
			var target = "AttrLov";            // selectBox id
			var defaultValue = "";              // 초기에 세팅되고자 하는 값
			var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
			ajaxSelect(url, data, target, defaultValue, isAll);
		} else {
			$("#isLov").val("");
			$("#searchValue").attr('style', 'display:inline;width:150px;');
			$("#AttrLov").attr('style', 'display:none;width:120px;');	
		}
		
		$("#constraint").val("").attr("selected", "selected");
	}
	
	/**  
	 * [Owner][Attribute] 버튼 이벤트
	 */
	function editCheckedAllItems(avg){
		if(p_gridArea.getCheckedRows(1).length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요.");
			alert("${WM00023}");
			return;
		}

		var checkedRows = p_gridArea.getCheckedRows(1).split(",");	
		var items = "";
		var classCodes = "";
		var nowClassCode = "";
		
		for(var i = 0 ; i < checkedRows.length; i++ ){
			
			// 이동 할 ITEMID의 문자열을 셋팅
			if (items == "") {
				items = p_gridArea.cells(checkedRows[i], 12).getValue();
				classCodes = p_gridArea.cells(checkedRows[i], 13).getValue();
				nowClassCode = p_gridArea.cells(checkedRows[i], 13).getValue();
			} else {
				items = items + "," + p_gridArea.cells(checkedRows[i], 12).getValue();
				if (nowClassCode != p_gridArea.cells(checkedRows[i], 13).getValue()) {
					classCodes = classCodes + "," + p_gridArea.cells(checkedRows[i], 13).getValue();
					nowClassCode = p_gridArea.cells(checkedRows[i], 13).getValue();
				}
			}
		}
		
		if (items != "") {
			if (avg == "Attribute") {
				var url = "selectAttributePop.do?";
				var data = "items="+items+"&classCodes="+classCodes; 
			    var option = "dialogWidth:400px; dialogHeight:250px;";
			    //window.showModalDialog(url + data , self, option);
			    var w = "400";
				var h = "250";
				document.getElementById("items").value = items;
				document.getElementById("classCodes").value = classCodes;
			    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
			} else if(avg == "Owner") {
				/* var url = "selectOwnerPop.do?";
				var data = "items="+items; 
			    var option = "dialogWidth:450px; dialogHeight:370px;";
			    window.showModalDialog(url + data , self, option); */
			    
			    var url = "selectOwnerPop.do?items="+items; 
			    var option = "width=450, height=300, left=300, top=300,scrollbar=yes,resizble=0";
			    window.open(url, "", option);
			}
			
		}
	}
	function urlReload(){
		gridInit();
		doSearchList();
	}
	
	// [symbol option] 설정
	function changeSbOption(avg){
		var url    = "getSymbolSelectOption.do"; // 요청이 날라가는 주소
		var data   = "itemTypeCode="+avg; //파라미터들
		var target = "symbolCode";            // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}
	
	// [속성 검색 제약] 설정
	function changeConstraint(avg) {
		if (avg == "") {
			if ($("#isLov").val() == "Y") {
				$("#searchValue").attr('style', 'display:none;width:140px;');
				$("#AttrLov").attr('style', 'display:inline;width:120px;');
			} else {
				$("#searchValue").attr('style', 'display:inline;width:140px;');
				$("#AttrLov").attr('style', 'display:none;width:120px;');
			}
		} else {
			$("#searchValue").val("");
			$("#searchValue").attr('style', 'display:none;width:140px;');
			$("#AttrLov").attr('style', 'display:none;width:120px;');
		}
	}
	
	// [Clear] click
	function clearSearchCon() {
		// 항목유형, 계층
		$("#ItemTypeCode").val("").attr("selected", "selected");
		$("#classCode").val("").attr("selected", "selected");
		// 기본정보 상세
		$("#detailID").val('');
		$("#detailOwnerTeam").val('');
		$("#detailAuthor").val('');
		$("#SC_STR_DT1").val('');
		$("#SC_END_DT1").val('');
		$("#SC_STR_DT2").val('');
		$("#SC_END_DT2").val('');
		$("#detailCompanyId").val("").attr("selected", "selected");
		// 속성
		$("#AttrCode").val("AT00001").attr("selected", "selected");
		$("#AttrLov").val("").attr("selected", "selected");
		$("#searchValue").val('');
		$("#isLov").val("");
		$("#searchValue").attr('style', 'display:inline;width:150px;');
		$("#AttrLov").attr('style', 'display:none;width:120px;');
	}
	
	function fnDownData() {			
		var d = setGridDownData();
		fnLoadDhtmlxGridJson(p_gridDownArea, d.key, d.cols, d.data,"","","TOT_CNTD","","fnDownExcel()");
	}
	
	function fnDownExcel() {		
		p_gridDownArea.toExcel("${root}excelGenerate");
	}
	
</script>
</head>
<body>
<div class="pdL10 pdR10">
	<form name="processList" id="processList" action="#" method="post"  onsubmit="return false;">
	<input type="hidden" id="searchKey" name="searchKey" value="Name">
	<input type="hidden" id="currPage" name="currPage" value="${currPage}"></input>
	<input type="hidden" id="isLov" name="isLov" value="">
	<input type="hidden" id="defaultLang" name="defaultLang" value="${defaultLang}">
	<input type="hidden" id="isComLang" name="isComLang" value="">
	<input type="hidden" id="isSpecial" name="isSpecial" value="">	
	<input type="hidden" id="items" name="items" >
	<input type="hidden" id="classCodes" name="classCodes" >
	<div class="msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Model Object</div>	
	<div align="center">	
	<table style="table-layout:fixed;" border="0" cellpadding="0" cellspacing="0" class="tbl_search mgT5"  id="search">
		<colgroup>
		    <col width="7%">
		    <col width="18%">
		    <col width="7%">
		    <col width="18%">
		    <col width="7%">
		    <col width="16%">
	    </colgroup>	    
	    <!-- Category, 항목유형, 계층-->
	    <tr>
	    	<!-- [Category] -->
            <th>${menu.LN00033}</th>
            <td>
            	<select id="category" name="category" style="width:120px;" >
					<option value="">Select</option>
					<option value="TXT">TXT</option>
					<option value="MOJ">MOJ</option>
					<option value="MCN">MCN</option>	
				</select>
			</td>
	    	<!-- [항목유형] -->
            <th>${menu.LN00021}</th>
            <td>
            	<select id="ItemTypeCode" name="ItemTypeCode" style="width:150px;">
            		<option value="">Select</option>
            	</select>
            </td>
            <!-- [계층] -->
            <th>${menu.LN00016}</th>
            <td>
            	<select id="classCode" name="classCode" style="width:120px;" >
					<option value="">Select</option>	
				</select>
			</td>
	    </tr>
	    
	    <!-- 법인, 관리조직, 담당자 -->
	    <tr>
	    	<th>${menu.LN00014}</th>
            <td align="left">
                <select id="detailCompanyId" name="detailCompanyId" style="width:120px;" >
                    <option value="">Select</option>    
                    <c:forEach var="i" items="${companyOption}">
                    <option value="${i.TeamID}">${i.Name}</option>                      
                    </c:forEach>
                </select>
            </td>
            <th>${menu.LN00018}</th>
            <td align="left" ><input type="text" id="detailOwnerTeam" name="detailOwnerTeam" value="" class="stext" style="width:150px"></td>
            <th>${menu.LN00004}</th>
            <td class="last" align="left"><input type="text" id="detailAuthor" name="detailAuthor" value="" class="stext" style="width:150px"></td>
	    </tr>	    
	    <!-- 생성일, 수정일, 상태 -->
	    <tr>
	    	<th>${menu.LN00013}</th>    
            <td align="left" >
                <font><input type="text" id="SC_STR_DT1" name="SC_STR_DT1" value="" class="input_off datePicker stext" size="8"
                style="width: 70px;" onchange="this.value = makeDateType(this.value);"  maxlength="10">
                </font>
                ~
                <font><input type="text" id=SC_END_DT1  name="SC_END_DT1" value="" class="input_off datePicker stext" size="8"
                        style="width: 70px;" onchange="this.value = makeDateType(this.value);"  maxlength="10">
                </font>
            </td>
            <th>${menu.LN00070}</th>    
            <td align="left">
                <font><input type="text" id="SC_STR_DT2" name="SC_STR_DT2" value="" class="input_off datePicker stext" size="8"
                style="width: 70px;" onchange="this.value = makeDateType(this.value);"  maxlength="10">
                </font>
                ~
                <font><input type="text" id=SC_END_DT2  name="SC_END_DT2" value="" class="input_off datePicker stext" size="8"
                        style="width: 70px;" onchange="this.value = makeDateType(this.value);"  maxlength="10">
                </font>
            </td>
           <th>Symbol</th>	
   			<td class="last">
   				<select id="symbolCode" style="width:150px">
		    		<option value=''>Select</option>
           	   		<c:forEach var="i" items="${symbolCodeList}">
                   		<option value="${i.CODE}">${i.NAME}</option>
           	    	</c:forEach>
				</select>
   			</td>			
	    </tr>	    
	    <!-- 속성, Dimension, Button -->
	    <tr>
	    	<!-- 속성 -->
		    <th>${menu.LN00031}</th>
		    <td class="alignL" colspan="3">
				<select id="AttrCode" style="width:120px">
					<option value="AT00001">${menu.LN00028}</option>
				</select>
				
				<select id="constraint" name="constraint" style="display:inline;width:105px;" >
					<option value="">include(equal to)</option>
					<option value="1">is specified</option>
					<option value="2">is not specified</option>
				</select>
				
				<!-- DataType != 'LOV' -->
				<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="stext" style="width:150px">
				<!-- DataType == 'LOV' -->
				<select id="AttrLov" name="AttrLov" style="display:none;width:120px;" >
					<option value="">Select</option>	
				</select>
			</td>
	    	<!-- ID -->
		    <th>ID</th>
            <td  class="last"><input type="text" id="detailID" name="detailID" value="" class="stext" style="width:150px"></td>
	    </tr>
	</table>	
	<li class="floatC mgR20 mgT5">
		<input id="btnSearch" type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" style="display:inline-block;cursor:pointer;">
		&nbsp;<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;cursor:pointer;" onclick="clearSearchCon();">
	</li>	
	<div class="countList" style="padding:0 0 0 0">
        <li  class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="gov"></span><input value="Gov" type="submit" onclick="editCheckedAllItems('Owner');"></span>
			&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="edit"></span><input value="Attribute" type="submit" onclick="editCheckedAllItems('Attribute');"></span>
		</c:if>
		&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Data" type="submit" id="excelData"></span>
		<!-- &nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span> -->
        </li>
   </div>
	<div id="gridDiv" class="mgB10 clear" align="center">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<div id="gridDownDiv" style="width:100%;visibility:hidden;" > 
		<li class="count">Total <span id="TOT_CNTD"></span></li>		
		<div id="grdGridDownArea" style="width:100%;height:200px;"></div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	</div>
	<!-- END :: PAGING -->		
	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
	</div>	
</body>
</html>