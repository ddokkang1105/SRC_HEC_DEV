<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

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

	$(document).ready(function() {	
		$("input.datePicker").each(generateDatePicker);
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 350)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 350)+"px;");
		};
		
		// $("#excel").click(function(){fnGridExcelDownLoad();});
		$("#excelData").click(function(){fnDownData();}); 
		$('#btnSearch').click(function(){
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
		fnSelect('Status', '&Category=ITMSTS', 'getDicWord', '', 'Select'); // 아이템 상태 조건
		
		// Attr Lov option 셋팅 : 선택된 AttrTypeCode의 DataType이 [LOV] 일때
		// 						 선택된 AttrTypeCode의 DataType이 [LOV] 가 아닐때는 searchValue textbox를 표시
		$('#AttrCode').change(function(){changeAttrCode($(this).val());});
		
		$('#constraint').change(function(){changeConstraint($(this).val());});
		
		$('#searchValue').keypress(function(onkey){
			if(onkey.keyCode == 13){doSearchList();return false;}
		});		

	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//===============================================================================
	// BEGIN ::: GRID1
	
	var layout = new dhx.Layout("grdGridArea", { 
			rows: [
				{
					id: "a",
				},
			]
		});
	
		var gridData = [];
		var grid = new dhx.Grid("grdGridArea", {
			columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
				{ width: 50, id: "ItemTypeImg", header: [{ text: "${menu.LN00042}" , align:"center" }], htmlEnable: true, align: "center",
					template: function (text, row, col) {
						return '<img src="${root}${HTML_IMG_DIR}/'+row.ItemTypeImg+'" width="18" height="18">';
					}
				},
				{ width: 100, id: "ClassName", header: [{ text: "${menu.LN00016}", align: "center" }], align: "center" },
				{ width: 100, id: "Identifier", header: [{ text: "${menu.LN00015}", align: "center" }], align: "left" },
				{ width: 220, id: "ItemName", header: [{ text: "${menu.LN00028}", align: "center" }], align: "left" },
				{ fillspace: true, id: "Path", header: [{ text: "${menu.LN00043}", align: "center" }], align: "left" },
				{ width: 120, id: "TeamName", header: [{ text: "${menu.LN00014}", align: "center" }] , align: "center"},		
				{ width: 120, id: "OwnerTeamName", header: [{ text: "${menu.LN00018}", align: "center" }] , align: "center"},				
				{ width: 70, id: "Name", header: [{ text: "${menu.LN00004}", align: "center" }] , align: "center"},			
				{ width: 60, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align: "center" }] , align: "center"},		
				{ hidden: true, width: 30, id: "Report", header: [{ text: "Report", align: "center" }], align: "center" },				
				{ hidden: true, width: 30, id: "ItemID", header: [{ text: "ItemID", align: "center" }], align: "center" },
				{ hidden: true, width: 30, id: "ClassCode", header: [{ text: "ClassCode", align: "center" }], align: "center" }
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data: gridData
		});
		layout.getCell("a").attach(grid);
		$("#TOT_CNT").html(grid.data.getLength());

		var pagination = new dhx.Pagination("pagination", {
			data: grid.data,
			pageSize: 50,
		});	

		//그리드ROW선택시
		grid.events.on("cellClick", function(row,column,e){
			if(column.id != "checkbox"){
				doDetail(row.ItemID);
			}
			if(column.id == "Report"){
				goReportList(row.ItemID);
			}
		}); 

	//======================================================

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

	
	//조회
	function doSearchList(){
		if ($('#category').val() == "") {
			alert("${WM00041_1}");
			return false;
		}
		if ($('#ItemTypeCode').val() == "") {
			alert("${WM00041_2}");
			return false;
		}
		if($("#SC_STR_DT1").val() != "" && $("#SC_END_DT1").val() == "")		$("#SC_END_DT1").val(new Date().toISOString().substring(0,10));
		if($("#SC_STR_DT2").val() != "" && $("#SC_END_DT2").val() == "")		$("#SC_END_DT2").val(new Date().toISOString().substring(0,10));

		var sqlID = "search_SQL.getSearchList";
		var param = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&defaultLang=" + $("#defaultLang").val()
					+ "&isComLang=" + $("#isComLang").val()
					+ "&sqlID="+sqlID;

		/* [기본정보] 조건 선택, 입력값 */
		param = param + setAllCondition();
		
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
		
		param = param + "&CategoryCode=" + $('#category').val();		
		param = param + "&ItemTypeCode=" + $('#ItemTypeCode').val();
		param = param + "&ClassCode=" + $("#classCode").val();
		if(searchValue != "") param = param + "&AttrCodeOLM_MULTI_VALUE=" + attrArray;
		
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
		var limit = 1000;
		grid.data.parse(newGridData);
		var total = grid.data.getLength();
		$("#TOT_CNT").html(total);
		if (total > limit) { alert("${WM00119}"); } /* 건수 제한 메세지 표시 */
		fnMasterChk('');
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
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){ //배열의 길이가 0   => !FALSE == TRUE
			alert("${WM00023}");	
		}

		var items = "";
		var classCodes = "";
		var nowClassCode = "";
		
		for(idx in selectedCell ){
			// 이동 할 ITEMID의 문자열을 셋팅
			if (items == "") {
				items = selectedCell[idx].ItemID;
				classCodes = selectedCell[idx].ClassCode;
				nowClassCode = selectedCell[idx].ClassCode;
			} else {
				items = items + "," + selectedCell[idx].ItemID;
				if (nowClassCode != selectedCell[idx].ClassCode) {
					classCodes = classCodes + "," + selectedCell[idx].ClassCode;
					nowClassCode = selectedCell[idx].ClassCode;
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
		doSearchList();
		fnDownExcel();
		return false;
	}
	
	function fnDownExcel() {		
		grid.showColumn('RNUM');
		grid.showColumn('ClassName');
		grid.showColumn('ItemName');
		grid.showColumn('ItemID'); //
		grid.hideColumn('check');
		grid.hideColumn('ItemTypeImg');
		grid.hideColumn('Identifier');
		grid.hideColumn('Path');
		grid.hideColumn('TeamName');
		grid.hideColumn('OwnerTeamName');
		grid.hideColumn('Name');
		grid.hideColumn('LastUpdated');
		grid.hideColumn('Report');
		grid.hideColumn('ClassCode');

		fnGridExcelDownLoad(); 

		grid.showColumn('check');
		grid.showColumn('ItemTypeImg');
		grid.showColumn('Identifier');
		grid.showColumn('Path');
		grid.showColumn('TeamName');
		grid.showColumn('OwnerTeamName');
		grid.showColumn('Name');
		grid.showColumn('LastUpdated');
		grid.showColumn('Report');
		grid.showColumn('ClassCode');
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
	<div>	
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
            <td>
                <select id="detailCompanyId" name="detailCompanyId" style="width:120px;" >
                    <option value="">Select</option>    
                    <c:forEach var="i" items="${companyOption}">
                    <option value="${i.TeamID}">${i.Name}</option>                      
                    </c:forEach>
                </select>
            </td>
            <th>${menu.LN00018}</th>
            <td><input type="text" id="detailOwnerTeam" name="detailOwnerTeam" value="" class="stext" style="width:150px"></td>
            <th>${menu.LN00004}</th>
            <td class="last"><input type="text" id="detailAuthor" name="detailAuthor" value="" class="stext" style="width:150px"></td>
	    </tr>	    
	    <!-- 생성일, 수정일, 상태 -->
	    <tr>
	    	<th>${menu.LN00013}</th>    
            <td >
                <input type="text" id="SC_STR_DT1" name="SC_STR_DT1" value="" class="input_off datePicker stext" size="8"
                style="width: 70px;" onchange="this.value = makeDateType(this.value);"  maxlength="10">
                
                ~
                <input type="text" id=SC_END_DT1  name="SC_END_DT1" value="" class="input_off datePicker stext" size="8"
                        style="width: 70px;" onchange="this.value = makeDateType(this.value);"  maxlength="10">
                
            </td>
            <th>${menu.LN00070}</th>    
            <td>
                <input type="text" id="SC_STR_DT2" name="SC_STR_DT2" value="" class="input_off datePicker stext" size="8"
                style="width: 70px;" onchange="this.value = makeDateType(this.value);"  maxlength="10">
                
                ~
                <input type="text" id=SC_END_DT2  name="SC_END_DT2" value="" class="input_off datePicker stext" size="8"
                        style="width: 70px;" onchange="this.value = makeDateType(this.value);"  maxlength="10">
                
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
	<div class="floatC mgR20 mgT5" align="center">
		<input id="btnSearch" type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" style="display:inline-block;cursor:pointer;">
		&nbsp;<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;cursor:pointer;" onclick="clearSearchCon();">
	</div>	
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
	<div id="gridDiv" class="mgB10 clear">
		<div id="grdGridArea" style="width:100%"></div>
		<div id="pagination"></div></div>
	</div>
	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
	</div>	
</body>
</html>