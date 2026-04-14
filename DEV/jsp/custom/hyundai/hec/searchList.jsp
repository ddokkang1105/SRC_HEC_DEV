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
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxToolbar/codebase/skins/dhtmlxtoolbar_dhx_skyblue.css'/>">
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="${menu.LN00021}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00158" var="WM00158"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00159" var="WM00159"/>
<style>
body {background:url("${root}${HTML_IMG_DIR}/blank.png")}
.DimensionTd .SumoSelect{
	float:left;
	margin-right:7px;
}
.objbox{
	overflow-x:hidden!important;
}
</style>
<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
	var changeMgt = "${changeMgt}";
	var screenType = "${screenType}";
	
	$(document).ready(function() {	
		$("input.datePicker").each(generateDatePicker);
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 480)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 480)+"px;");
		};

		$('#AttrCode').SumoSelect();
	
		$("#ItemTypeCode").SumoSelect({csvDispCount: 3, parentWidth: 99});
		
		
		$("#excel").click(function(){p_gridArea.toExcel("${root}excelGenerate");doExcel();});
		$('#btnSearch').click(function(){
			$("#currPage").val("");
			doSearchList();
			return false;
		});


		gridInit();	
		
		if(screenType == "main"){
			$("#ItemTypeCode").val("${ItemTypeCode}").prop("selected",true);
			appendOption();
		}
	});	

	function checkAttrCode(value,text,isNew) {
		var ari = $("#attrIndex").val();
		var bf = $("#isSelect"+value).val();
		
		if($("#option"+value).hasClass("selected") && isNew != "NEW") {	
			
			if(ari*1 > 0)
				$("#attrIndex").val(ari*1 - 1);
			
			$("."+value).remove();

			if(bf != "") {
				$("#asDiv"+bf).empty();
				$("#beforeCode").val(bf);
			}
			$("#AttrCode")[0].sumo.attrOptClick("option"+value);
		}
		else if(ari*1 < 4){
			//changeAttrCode(value);
			checkAttrDiv(value,text,ari);
			$("#AttrCode")[0].sumo.attrOptClick("option"+value);
			$("#attrIndex").val(ari*1+1);
		}
		else {
			//문구 추가 필요
			alert("최대 4개 선택 가능 합니다.");
		}
	}
	function checkAttrDiv(divClassName,text,ari){
		var html = "";
		var bfAttr = $("#beforeCode").val();

		html += '<div class="'+divClassName+'" style="margin-top:10px; display: flex;">';

		html += "<div style=\"width: 120px; text-align: right; line-height: 30px; padding-left: 10px; margin-right:30px; float:left;\" ><b>"+text+"</b></div>";	
			
		html += "<select id=\"constraint"+divClassName+"\" name=\"constraint[]\" class=\"SlectBox\" style=\"width:180px;\" onChange=\"changeConstraint($(this).val(),'"+divClassName+"')\" >";
		html += "<option value=\"\">포함(또는 같음)</option>";
		html += "<option value=\"3\">포함하지 않음(또는 다름)</option>";
		html += "</select>&nbsp;";
		html += "<input type=\"text\" id=\"searchValue"+divClassName+"\" value=\"\" class=\"stext\" style=\"width:50%;height:28px;margin-left:30px;\">";
		html += "<select id=\"AttrLov"+divClassName+"\" name=\"AttrLov[]\" style=\"display:none;width:120px;margin-left:30px;\" multiple=\"multiple\">";
		html += "<option value=\"\">Select</option>	";
		html += "</select><input type=\"hidden\" id=\"isLov"+divClassName+"\" value=\"\">";
		html += "<input type=\"hidden\" id=\"isSelect"+divClassName+"\" value=\""+bfAttr+"\">";
		html += '<div id="asDiv'+divClassName+'" style="height: 26px; margin-left: 30px; display: inline;"></div>';

		if(ari > 0) {		
			var html2 = "";
				html2 += '<select id="selectOption'+divClassName+'" name="selectOption'+divClassName+'" style="width:80px; " >';
				html2 += "<option value=\"AND\" selected=\"selected\">AND</option>";
				html2 += "<option value=\"OR\">OR</option>	";
				html2 += '</select>';
			$("#asDiv"+bfAttr).append(html2);
			$("#selectOption"+divClassName).SumoSelect({csvDispCount: 3});
		}
		
		html += "</div>";
		
		
		if($("div").hasClass(divClassName)) {
			$("."+divClassName).remove();
		}
		else {
			$("#appendDiv").append(html);
			$("#constraint"+divClassName).SumoSelect({csvDispCount: 3});
			$('#searchValue'+divClassName).keypress(function(onkey){
				if(onkey.keyCode == 13){doSearchList();return false;}
			});	
		}
		$("#beforeCode").val(divClassName);
	}

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//===============================================================================
	// BEGIN ::: GRID
	function gridInit(){		
		var d = setGridData();		
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
		
		p_gridArea.setColumnHidden(1, true);
		p_gridArea.setColumnHidden(10, true); // LastUpdated
		p_gridArea.setColumnHidden(11, true); // Report
		p_gridArea.setColumnHidden(12, true);
		p_gridArea.setColumnHidden(13, true);
		fnSetColType(p_gridArea, 1, "ch");
		fnSetColType(p_gridArea, 2, "img");	
		fnSetColType(p_gridArea, 11, "img");
		
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		
		//START - PAGING
		//p_gridArea.enablePaging(true, 1000, null, "pagingArea", true, "recinfoArea");
		p_gridArea.enablePaging(true,100,100,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
		//END - PAGING
	}	
	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "zHEC_SQL.zhec_getSearchMultiList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00042},${menu.LN00016},${menu.LN00015},${menu.LN00028},${menu.LN00043},${menu.LN00014},${menu.LN00018},${menu.LN00004},${menu.LN00070},Report,ItemID,ClassCode";
		result.cols = "CHK|ItemTypeImg|ClassName|Identifier|ItemName|Path|TeamName|OwnerTeamName|Name|LastUpdated|Report|ItemID|ClassCode";
		result.widths = "50,50,50,180,180,220,*,120,120,70,70,60,0,0"; // base 검색
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,left,left,left,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&isMain=Y&showTOJ=N"
					+ "&defaultLang=" + $("#defaultLang").val()
					+ "&isComLang=" + $("#isComLang").val()
					+ "&CategoryCode=OJ"
		 			+ "&pageNum=" + $("#currPage").val()
					+ "&idExist=${idExist}&ClassCodeList='CL05003','CL16004','CL01005','CL01006'";
		 			
		/* [기본정보] 조건 선택, 입력값 */
		if(changeMgt !=""){
			result.data += "&changeMgt="+changeMgt;
		}
		result.data = result.data+ setAllCondition();
		if($("#AttrCode").val() != '' & $("#AttrCode").val() != null){
			var attrArray = new Array();
			$("#AttrCode :selected").each(function(i, el){ 
				var valueArray = new Array();
				var aval = $(el).val();	
				var lovCode = "";
				var searchValue = "";
				var AttrCodeEscape = "";
				var constraint = "";
				var selectOption = "";
				

				if(i*1 > 0)
					selectOption = $("#selectOption"+aval).val();
				else if(i == 0)
					selectOption = "AND";
				
				/* [속성] 조건 선택, 입력값 */
				if ($("#constraint"+aval).val() == "" || $("#constraint"+aval).val() == "3") {
					if ($("#AttrLov"+aval).val() != "" || $("#searchValue"+aval).val() != "") {
						if ("Y" == $("#isLov"+aval).val()) {
							lovCode = $("#AttrLov"+aval).val() + "";
							lovCode = lovCode.replace(/,/gi,"*");
							//result.data = result.data+ "&lovCode=" + $("#AttrLov"+aval).val();
						} else {
							$("#isSpecial").val("");
							searchValue = setSpecialChar($("#searchValue"+aval).val().replace(",","comma"));
							AttrCodeEscape = $("#isSpecial").val();
							//result.data = result.data+ "&searchValue=" + setSpecialChar($("#searchValue"+aval).val());
							//result.data = result.data+ "&AttrCodeEscape=" + $("#isSpecial"+aval).val();
						}
					}
					if($("#constraint"+aval).val() == "3")
						constraint = $("#constraint"+aval).val();
						//result.data = result.data+ "&constraint"+aval+"=" + $("#constraint"+aval).val();
					
				} else {
					constraint = $("#constraint"+aval).val();
					//result.data = result.data+ "&constraint"+aval+"=" + $("#constraint"+aval).val();
				}
				
				searchValue = encodeURIComponent(searchValue);
				valueArray.push($(el).val());
				valueArray.push(lovCode);
				valueArray.push(searchValue);
				valueArray.push(AttrCodeEscape);
				valueArray.push(constraint);
				valueArray.push(selectOption);
				attrArray.push(valueArray);
			});
			result.data = result.data+ "&AttrCodeOLM_MULTI_VALUE=" + attrArray;
		}	
		
		/* [Dimension] 조건 선택값 */
		var nothing = "";
				
		result.data = result.data+ "&ItemTypeCode=" + $('#ItemTypeCode').val();
		//result.data = result.data+ "&ClassCode=" + $("#classCode").val();
		result.data = result.data+ "&isNothingLowLank=${isNothingLowLank}";

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
		if ($("#SC_STR_DT1").val() != "") { // 신규 개정일
			condition += "&scStartDt1=" + $("#SC_STR_DT1").val();
		}
		if ($("#SC_END_DT1").val() != "" ) { // 신규 개정일
			condition += "&scEndDt1=" + $("#SC_END_DT1").val();
		}
		if ($("#SC_STR_DT1").val() != "" || $("#SC_END_DT1").val() != "" ) { // 신규 개정일
			condition = condition+ "&CreationTime=Y";
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
		
		var d = setGridData();
		//fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
		/* 건수 제한 메세지 표시 */
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data, "", "", "", "", "", "${WM00119}", 1000);
		$("#loading").fadeIn(100);
		checkLoadingBar();

	}
	
	function checkLoadingBar() {
		if($("#TOT_CNT").html() != "") {
			$("#loading").fadeOut(100);
		}		
		else {
			$("#loading").fadeIn(100);
			setTimeout(function() { checkLoadingBar(); },500);
			
		}
	}	
	
	
	// END ::: GRID	
	//===============================================================================

	function doDetail(avg){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg);
	}
	
	// [계층 option] 설정
	function changeItemTypeCode(avg){
		var url    = "getClassCodeOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&option="+avg; //파라미터들
		var target = "classCode";             // selectBox id
		var defaultValue = "${classCode}";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxMultiSelect(url, data, target, defaultValue, isAll);
		
	}
	
	// [속성 option] 설정
	// 항목계층 SelectBox 값 선택시  속성 SelectBox값 변경
	
	function changeClassCode(avg1, avg2){
		$("#attrIndex").val("0");
		$("#appendDiv").empty();
		$("#displayLabel").empty();
		var url    = "getSearchSelectOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&sqlID=search_SQL.attrBySearch&s_itemID="+avg2+"&s_itemID2="+avg1; //파라미터들
		var target = "AttrCode";            // selectBox id
		var defaultValue = "${AttrCode}";              // 초기에 세팅되고자 하는 값
		var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxMultiSelect(url, data, target, defaultValue, isAll);
		setTimeout(appendOption,1000);
		
	}
	
	function appendClassOption(){
		//$("#classCode")[0].sumo.reload();
	}
	function appendOption(){
		var optionName = '${menu.LN00028}';
		 $("#AttrCode").prepend("<option value='AT00501'>${menu.LN00145}</option>");
		 $("#AttrCode").prepend("<option value='AT00003'>${menu.LN00005}</option>");
		 $("#AttrCode").prepend("<option value='AT00001'>"+optionName+"</option>");
		
		checkAttrCode("AT00001",optionName,"NEW");	
		//checkAttrCode("AT00501","${menu.LN00145}","NEW");
		//checkAttrCode("AT00003","${menu.LN00005}","NEW");	

		if(screenType == "main") {
			$("#searchValueAT00001").val("${searchValue}");
			//$("#searchValueAT00501").val("${searchValue}");		
			//$("#selectOptionAT00501")[0].sumo.selectItem(1);
			//$("#searchValueAT00003").val("${searchValue}");		
			//$("#selectOptionAT00003")[0].sumo.selectItem(1);
			doSearchList();
			screenType = "";
		}
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

		if (dataType == "LOV" || dataType == "MLOV") {
			$("#isLov"+attrCode).val("Y");
			$("#searchValue"+attrCode).attr('style', 'display:none;width:50%; height: 26px; margin-left: 30px; ');	
			
			var url    = "getAttrLovSelectOption.do"; // 요청이 날라가는 주소
			var data   = "languageID="+languageID+"&attrCode="+attrCode; //파라미터들
			var target = "AttrLov"+attrCode;            // selectBox id
			var defaultValue = "";              // 초기에 세팅되고자 하는 값
			var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
			ajaxMultiSelect(url, data, target, defaultValue, isAll);
			setTimeout("setAttrLovMulti('"+attrCode+"')",500);
		} else {
			$("#isLov"+attrCode).val("");
			$("#searchValue"+attrCode).attr('style', 'width:50%; height: 26px; margin-left: 30px; display: inline;');
			$("#AttrLov"+attrCode).attr('style', 'display:none;width:120px;margin-left:30px;');	
		}
	}
	

	function setAttrLovMulti(atrCode){
		 $('#AttrLov'+atrCode).SumoSelect();
		 $('#ssAttrLov'+atrCode).attr("style","width:235px;margin-left:30px;");
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
		//var classCodes = "";
		//var nowClassCode = "";
		
		for(var i = 0 ; i < checkedRows.length; i++ ){
			
			// 이동 할 ITEMID의 문자열을 셋팅
			if (items == "") {
				items = p_gridArea.cells(checkedRows[i], 12).getValue();
				//classCodes = p_gridArea.cells(checkedRows[i], 13).getValue();
				//nowClassCode = p_gridArea.cells(checkedRows[i], 13).getValue();
			} else {
				items = items + "," + p_gridArea.cells(checkedRows[i], 12).getValue();
				/*
				if (nowClassCode != p_gridArea.cells(checkedRows[i], 13).getValue()) {
					classCodes = classCodes + "," + p_gridArea.cells(checkedRows[i], 13).getValue();
					nowClassCode = p_gridArea.cells(checkedRows[i], 13).getValue();
				}
				*/
			}
		}
		
		if (items != "") {
			if (avg == "Attribute") {
				var url = "selectAttributePop.do?";
				//var data = "items="+items+"&classCodes="+classCodes; 
				var data = "items="+items;
			    var option = "dialogWidth:400px; dialogHeight:250px;";
			    window.showModalDialog(url + data , self, option);
			} else if(avg == "Owner") {
				var url = "selectOwnerPop.do?";
				var data = "items="+items; 
			    var option = "dialogWidth:450px; dialogHeight:370px;";
			    window.showModalDialog(url + data , self, option);
			}
			
		}
	}
	function urlReload(){
		gridInit();
		doSearchList();
	}
	
	// [dimValue option] 설정
	function changeDimValue(avg){
		var url    = "getDimValueSelectOption.do"; // 요청이 날라가는 주소
		var data   = "&searchYN=Y"; //파라미터들
		var target = "";            // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "true";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxMultiSelect(url, data, target, defaultValue, isAll);
		setTimeout(appendDimOption,1000);
	}
	function appendDimOption(){
		
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
	function changeConstraint(avg, avg2) {
		if (avg == "" || avg == "3") {
			if ($("#isLov"+avg2).val() == "Y") {
				$("#searchValue"+avg2).attr('style', 'display:none;width:50%; height: 26px; margin-left: 30px; ');
				$("#ssAttrLov"+avg2).attr('style', 'width:235px;margin-left:30px;');
			} else {
				$("#searchValue"+avg2).attr('style', 'width:50%; height: 26px; margin-left: 30px; ');
				$("#ssAttrLov"+avg2).attr('style', 'display:none;');
			}
		} else {
			$("#searchValue"+avg2).val("");
			$("#searchValue"+avg2).attr('style', 'display:none;width:50%; height: 26px; margin-left: 30px; ');
			$("#ssAttrLov"+avg2).attr('style', 'display:none;');
		}
	}
	
	// [Clear] click
	function clearSearchCon() {

		$("#appendDiv").empty();
		
		// 기본정보 상세
		$("#detailID").val('');
		$("#detailOwnerTeam").val('');
		$("#detailAuthor").val('');
		$("#SC_STR_DT1").val('');
		$("#SC_END_DT1").val('');	
		$("#CSR_STR_DT").val('');
		$("#CSR_END_DT").val('');
		
		$("#ItemTypeCode")[0].sumo.selectItem(0);
		
	}
	
	function fnResetSelectBox(objName,defaultValue)
	{
		$("select[name='"+ objName +"'] option").not("[value='"+defaultValue+"']").remove(); 
	}

	function fnHideSearch() {
		var tempSrc = $("#frame_sh").attr("src");
		if($("#frame_sh").hasClass("frame_show")) {
			$("#search").hide();
			$("#buttonGroup").hide();
			$("#frame_sh").attr("class","frame_hide");
			$("#frame_sh").attr("title","${WM00159}");
			$("#frame_sh").attr("src",tempSrc.replace("btn_frame_show","btn_frame_hide"));
		}
		else {
			$("#search").show();
			$("#buttonGroup").show();
			$("#frame_sh").attr("class","frame_show");
			$("#frame_sh").attr("title","${WM00158}");
			$("#frame_sh").attr("src",tempSrc.replace("btn_frame_hide","btn_frame_show"));
		}
	}
	
</script>

</head>
<body >
<div class="pdL10 pdR10">
	<form name="processList" id="processList" action="#" method="post"  onsubmit="return false;">
	<input type="hidden" id="searchKey" name="searchKey" value="Name">
	<input type="hidden" id="currPage" name="currPage" value="${currPage}"></input>
	<input type="hidden" id="defaultLang" name="defaultLang" value="${defaultLang}">
	<input type="hidden" id="isComLang" name="isComLang" value="">
	<input type="hidden" id="isSpecial" name="isSpecial" value="">
	<input type="hidden" id="attrIndex" value="0">
	<input type="hidden" id="beforeCode" value="">
	
	<div class="cop_hdtitle">
		<h3 style="padding: 6px 0"><img src="${root}${HTML_IMG_DIR}/icon_search_title.png">&nbsp;&nbsp;${menu.LN00047}</h3>
	</div>
	
	<!-- <div align="center">  -->
	
	<table style="table-layout:fixed;" border="0" cellpadding="0" cellspacing="0" class="tbl_search mgT5"  id="search">
		<colgroup>
		    <col width="5%">
		    <col width="27%">
		    <col width="5%">
		    <col width="27%">
		    <col width="5%">
		    <col width="27%">
	    </colgroup>
	    
	    <!-- 항목유형, 계층, ID -->
	    <tr>
            <%-- <th class="">${menu.LN00021}</th> --%>
            <th class="">${menu.LN00021}</th>
            <td class="">
            	<select id="ItemTypeCode" class="sel" name="ItemTypeCode">
					<option value="">Select</option>
					<c:forEach var="i" items="${itemTypeList}">
						<option value="${i.CODE}">${i.NAME}</option>						
					</c:forEach>
            	</select>
            </td>
			<th  class="">${menu.ZLN014}</th>
            <td  class=""><input type="text" id="detailID" name="detailID" value="" class="text"></td>
            <%-- <th class="">${menu.LN00018}</th> --%>
            <th class="">${menu.LN00018}</th>
            <td class="" ><input type="text" id="detailOwnerTeam" name="detailOwnerTeam" value="${searchTeamName}" class="text"></td>
	    </tr>
	    
	    <!-- 법인, 관리조직, 담당자 -->
		<tr>
			<%-- <th class="">${menu.LN00013}</th> --%>
			<th class=""></th>
            <td class="">
            </td>
			<th class="">${menu.LN00357}</th>   
            <td class="">
                <input type="text" id="SC_STR_DT1" name="SC_STR_DT1" value="" class="input_off datePicker text" size="8"
                style="width: 38%;" onchange="this.value = makeDateType(this.value);"  maxlength="10">
                
                ~
                <input type="text" id=SC_END_DT1  name="SC_END_DT1" value="" class="input_off datePicker text" size="8"
                        style="width: 38%;" onchange="this.value = makeDateType(this.value);"  maxlength="10">
                
            </td>
            <%-- <th class="">${menu.LN00004}</th> --%>
            <th class="">${menu.LN00004}</th>
            <td class="" align="left"><input type="text" id="detailAuthor" name="detailAuthor" value="${searchAuthorName}" class="text"></td>
	    </tr>
	    <!-- 속성, Dimension, Button -->
	    <tr>
	    	<!-- 속성 -->
		    <th class="">${menu.LN00031}</th>
		    <td colspan="5" class="">				
				<select id="AttrCode" Name="AttrCode[]" multiple="multiple" style="width:300px;" class="SlectBox" >
					<option value="AT00001">${menu.LN00028}</option>
					<option value="AT00501">${menu.LN00145}</option>
					<option value="AT00003">${menu.LN00005}</option>
				</select>
				<div id="appendDiv"></div>
			</td>	
	    </tr>
	</table>
	
	<li class="mgT5" >
		<div align="center">
		<input id="btnSearch" type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" style="display:inline-block;">
		&nbsp;<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;" onclick="clearSearchCon();">
		</div>
	</li>
	
	<div class="countList" >
        <li class="count"><input type="image" id="frame_sh" class="frame_show" title="${WM00158}" src="${root}${HTML_IMG_DIR}/btn_frame_show.png" value="Clear" style="cursor:pointer;width:20px;height:15px;margin-right:5px;" onclick="fnHideSearch();">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<c:if test="${myItem == 'Y'}">
					&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="gov"></span><input value="Gov" type="submit" onclick="editCheckedAllItems('Owner');"></span>
					&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="edit"></span><input value="Attribute" type="submit" onclick="editCheckedAllItems('Attribute');"></span>
				</c:if>
			</c:if>
			
			&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
        </li>
   </div>
	<div id="gridDiv" class="mgB10 clear" align="center">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->		
	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
	</div>	
</body>
</html>