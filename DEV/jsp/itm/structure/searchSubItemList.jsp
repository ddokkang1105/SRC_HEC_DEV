<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

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
.DimensionTd .SumoSelect{
	float:left;
	margin-right:7px;
}
</style>

<!-- 2. Script -->
<script type="text/javascript">
	
	
	$(document).ready(function() {
		const windowHeightSetter = 400;
		$("input.datePicker").each(generateDatePicker);
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - windowHeightSetter)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - windowHeightSetter)+"px;");
		};
		
		$("#excel").click(function(){
			fnGridExcelDownLoad();
		});

		$('#btnSearch').click(function(){
			$("#currPage").val("");
			doSearchList();
			return false;
		});

		$("#frame_sh").mouseover(function(){
			var tmp = $(this).attr("src");
			if($(this).hasClass("frame_show")) {
				$(this).attr("src",tmp.replace("btn_frame_show","btn_frame_hide"));
			}
			else {
				$(this).attr("src",tmp.replace("btn_frame_hide","btn_frame_show"));
			}
		});
		
		$("#frame_sh").mouseout(function(){
			var tmp = $(this).attr("src");
			if($(this).hasClass("frame_show")) {
				$(this).attr("src",tmp.replace("btn_frame_hide","btn_frame_show"));
			}
			else {
				$(this).attr("src",tmp.replace("btn_frame_show","btn_frame_hide"));
			}
		});
		
		 $('#AttrCode').SumoSelect();
		 $('#dimValueId').SumoSelect({parentWidth: 50});
		 
		//fnSelect('Status', '&Category=ITMSTS', 'getDicWord', '', 'Select'); // 아이템 상태 조건
		
		// [속성] option 설정
		changeClassCode("", '${ItemTypeCode}');
		
		// Attr Lov option 셋팅 : 선택된 AttrTypeCode의 DataType이 [LOV] 일때
		// 						선택된 AttrTypeCode의 DataType이 [LOV] 가 아닐때는 searchValue textbox를 표시
		/*$('#AttrCode').change(function(){
			changeAttrCode($(this).val());
		});*/
		$('#dimTypeId').change(function(){changeDimValue($(this).val());});
		$('#classCode').change(function(){changeClassCode($(this).val(), "");});
		$('#detailClassCode').change(function(){changeClassCode($(this).val(), "");});
		
		$('#constraint').change(function(){changeConstraint($(this).val(), "");});
		
		$('#searchValue').keypress(function(onkey){
			if(onkey.keyCode == 13){doSearchList();return false;}
		});		
		
// 		gridInit();
		$("#dimTypeId").SumoSelect({ csvDispCount: 3, parentWidth: 45 });
		$("#detailClassCode").SumoSelect({csvDispCount: 3, parentWidth: 98});
		$("#detailCompanyId").SumoSelect({csvDispCount: 3, parentWidth: 98});
		$("#Status").SumoSelect({csvDispCount: 3, parentWidth: 98});
	});	
	
	function checkAttrCode(value,text,isNew) {
		var ari = $("#attrIndex").val();
		var bf = $("#isSelect"+value).val();
		var attrCodeSorting = $("#attrCodeSorting").val();
		
		if($("#option"+value).hasClass("selected") && isNew != "NEW") {	
			
			if(ari*1 > 0)
				$("#attrIndex").val(ari*1 - 1);
			
			$("."+value).remove();

			if(bf != "") {
				$("#asDiv"+bf).empty();
				$("#beforeCode").val(bf);
			}
			$("#AttrCode")[0].sumo.attrOptClick("option"+value);
			attrCodeSorting = attrCodeSorting.replace(","+value,"");
			attrCodeSorting = attrCodeSorting.replace(value,"");
		}
		else if(ari*1 < 4){
			changeAttrCode(value);
			checkAttrDiv(value,text,ari);
			$("#AttrCode")[0].sumo.attrOptClick("option"+value);
			$("#attrIndex").val(ari*1+1);
			if(attrCodeSorting == ""){
				attrCodeSorting = value;
			}else{
				attrCodeSorting = attrCodeSorting +","+ value;
			}
		}
		else {
			//문구 추가 필요
			alert("최대 4개 선택 가능 합니다.");
		}
		
		$("#attrCodeSorting").val(attrCodeSorting);
		
	}
	
	function checkAttrDiv(divClassName,text,ari){
		var html = "";
		var bfAttr = $("#beforeCode").val();

		html += '<div class="'+divClassName+'" style="margin-top:10px;">';

		html += "<div style=\"width: 120px; text-align: right; line-height: 30px; padding-left: 10px; margin-right:30px; float:left;\" ><b>"+text+"</b></div>";	
			
		html += "<select id=\"constraint"+divClassName+"\" name=\"constraint[]\" class=\"SlectBox\" style=\"width:180px;\" onChange=\"changeConstraint($(this).val(),'"+divClassName+"')\" >";
		html += "<option value=\"\">include(equal to)</option>";
		html += "<option value=\"1\">is specified</option>";
		html += "<option value=\"2\">is not specified</option>";
		html += "<option value=\"3\">not include(not equal to)</option>";
		html += "</select>&nbsp;";
		html += "<input type=\"text\" id=\"searchValue"+divClassName+"\" value=\"\" class=\"stext\" style=\"width:50%;height:25px;margin-left:10px;\">";
		html += "<select id=\"AttrLov"+divClassName+"\" name=\"AttrLov[]\" style=\"display:none;width:120px;margin-left:30px;\" multiple=\"multiple\">";
		html += "<option value=\"\">Select</option>	";
		html += "</select><input type=\"hidden\" id=\"isLov"+divClassName+"\" value=\"\">";
		html += "<input type=\"hidden\" id=\"isSelect"+divClassName+"\" value=\""+bfAttr+"\">";
		html += '<div id="asDiv'+divClassName+'" style="height: 30px; margin-left: 10px; display: inline;"></div>';

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
		}
		$("#beforeCode").val(divClassName);
	}
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//===============================================================================
	// BEGIN ::: GRID
	
	function setGridConfig(){
		var result = new Object();
		result.title = "${title}";
		result.key = "search_SQL.getSearchMultiList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00042},${menu.LN00016},${menu.LN00015},${menu.LN00028},${menu.LN00043},${menu.LN00014},${menu.LN00018},${menu.LN00004},${menu.LN00070},Report,ItemID,ClassCode,${menu.LN00027}";
		result.cols = "CHK|ItemTypeImg|ClassName|Identifier|ItemName|Path|TeamName|OwnerTeamName|Name|LastUpdated|Report|ItemID|ClassCode|StatusName";
		result.widths = "30,30,30,80,80,180,*,120,120,100,80,0,0,0,90"; // item 검색
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,left,left,left,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&defaultLang=" + $("#defaultLang").val()
					+ "&isComLang=" + $("#isComLang").val()
		 			+ "&pageNum=" + $("#currPage").val()
		 			+ "&showID=Y";
		
		/* [기본정보] 조건 선택, 입력값 */
		result.data = result.data+ setAllCondition();
		
		if($("#AttrCode").val() != '' & $("#AttrCode").val() != null){			
			var attrCodeSortings = $("#attrCodeSorting").val().split(",");
			var attrArray = new Array();
			attrCodeSortings.forEach(function(attr, idx) {
			    
			    var valueArray = new Array();
				var aval = attr;	
				var lovCode = "";
				var searchValue = "";
				var AttrCodeEscape = "";
				var constraint = "";
				var selectOption = "";
				
				if(idx*1 > 0) {
					selectOption = $("#selectOption"+aval).val();
				}
				else if(idx == 0){
					selectOption = $("#selectOption"+aval).val();
					if(selectOption == "AND" || selectOption == "OR"){
						selectOption = $("#selectOption"+aval).val();
					}else{			
						selectOption = "AND";
					}
				}
				
				if(selectOption == undefined) selectOption = "AND";

				/* [속성] 조건 선택, 입력값 */
				if ($("#constraint"+aval).val() == "" || $("#constraint"+aval).val() == "3") {
					if ($("#AttrLov"+aval).val() != "" || $("#searchValue"+aval).val() != "") {
						if ("Y" == $("#isLov"+aval).val()) {
							lovCode = $("#AttrLov"+aval).val() + "";
							lovCode = lovCode.replace(/,/gi,"*");
						} else {
							$("#isSpecial").val("");
							searchValue = setSpecialChar($("#searchValue"+aval).val().replace(",","comma"));
							AttrCodeEscape = $("#isSpecial").val();
						}
					}
					if($("#constraint"+aval).val() == "3")
						constraint = $("#constraint"+aval).val();
					
				} else {
					constraint = $("#constraint"+aval).val();
				}
				
				valueArray.push(attr);
				valueArray.push(lovCode);
				valueArray.push(searchValue);
				valueArray.push(AttrCodeEscape);
				valueArray.push(constraint);
				valueArray.push(selectOption);
				
				attrArray.push(valueArray);
			});
		
			var attrArrayList = $("#attrArrayList").val();
			result.data = result.data+ "&AttrCodeOLM_MULTI_VALUE=" + attrArray;
		}	
	
		/* [Dimension] 조건 선택값 */		
		
		var nothing = "";
		if ($("#dimTypeId").val() != "") {
			
			var dvArray = new Array();
			$("#dimValueId :selected").each(function(i, el){ 
				var dvTemp = $(el).val(); 
				if (dvTemp != "" && "nothing" != dvTemp && "Nothing" != dvTemp) {
					dvArray.push(dvTemp);
					nothing = "&nothingDim=";
				} else if("nothing" == dvTemp || "Nothing" == dvTemp) {
					nothing = "&nothingDim=Y";
				}

			});

			result.data = result.data+ "&DimTypeID=" + $("#dimTypeId").val() + "&isNotIn=N&DimValueIDOLM_ARRAY_VALUE="+dvArray+nothing;
		}
			
		result.data = result.data+ "&childItems=${childItems}";
		result.data = result.data+ "&isNothingLowLank=${isNothingLowLank}";

		return result;
	}

	function fnCallBack(){doSearchList();}
	
	// [기본정보] 모든 조건 검색 입력
	function setAllCondition() {
		var condition = "";
		
		if ($("#detailID").val() != "" ) { // Identifier 
			condition = condition+ "&AttrCodeBase2=Identifier";
			$("#isSpecial").val("");
			condition = condition+ "&baseCondition2=" + setSpecialChar($("#detailID").val());
			condition = condition+ "&baseCon2Escape=" + $("#isSpecial").val();
		}
		if ($("#detailClassCode").val() != "" ) { // 계층
			condition = condition+ "&ClassCode=" + $("#detailClassCode").val();
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
		if ($("#Status").val() != "" ) { // 상태
			condition = condition+ "&Status=" + $("#Status").val();
		}
		return condition;
	}
	
	// END ::: GRID	
	//===============================================================================
		
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

	function setSubFrame(avg, avg2){
		$("#"+avg2).attr('style', 'display: none');
		$("#"+avg).removeAttr('style', 'display: none');
		
		if(avg == 'addNewItem'){
			setSubFrame('saveOrg','editOrg');
		}else if(avg == 'OrganizationInfo'){
			setSubFrame('editOrg','saveOrg');
		}
	}

	function doDetail(avg){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg);
	}
	
	// [속성 option] 설정
	// 항목계층 SelectBox 값 선택시  속성 SelectBox값 변경
	function changeClassCode(avg1, avg2, avg3){
		$("#attrIndex").val("0");
		$("#appendDiv").empty();
		$("#displayLabel").empty();
		var url    = "getSearchSelectOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&sqlID=search_SQL.attrBySearch&s_itemID="+avg2+"&s_itemID2="+avg1; //파라미터들
		var target = "AttrCode";            // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxMultiSelect(url, data, target, defaultValue, isAll);
		setTimeout(appendOption,1000);
	}
	
	function appendOption(){
		 var optionName = '${menu.LN00028}';
		 $("#AttrCode").prepend("<option value='AT00001'>"+optionName+"</option>");
		 
		 $('#AttrCode')[0].sumo.reload();
		 checkAttrCode("AT00001",optionName, "NEW");

	}

	function setAttrLovMulti(atrCode){
		
		 $('#AttrLov'+atrCode).SumoSelect({ csvDispCount: 3 });
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
			$("#searchValue"+attrCode).attr('style', 'display:none; width:50%; height: 25px; margin-left: 10px; ');	
			
			var url    = "getAttrLovSelectOption.do"; // 요청이 날라가는 주소
			var data   = "languageID="+languageID+"&attrCode="+attrCode; //파라미터들
			var target = "AttrLov"+attrCode;            // selectBox id
			var defaultValue = "";              // 초기에 세팅되고자 하는 값
			var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
			ajaxMultiSelect(url, data, target, defaultValue, isAll);
			setTimeout("setAttrLovMulti('"+attrCode+"')",500);
		} else {
			$("#isLov"+attrCode).val("");
			$("#searchValue"+attrCode).attr('style', 'width:50%; height: 25px; margin-left: 10px; display: inline;');
			$("#AttrLov"+attrCode).attr('style', 'display:none;width:50%;margin-left:30px;');	
		}
		
		
	}

	function setAttrLovMulti(atrCode){
		 $('#AttrLov'+atrCode).SumoSelect();
		 $('#ssAttrLov'+atrCode).attr("style","width:235px;margin-left:10px;");
	}
	
	
	// [dimValue option] 설정
	function changeDimValue(avg){
		var url    = "getDimValueSelectOption.do"; // 요청이 날라가는 주소
		var data   = "dimTypeId="+avg+"&searchYN=Y"; //파라미터들
		var target = "dimValueId";            // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시

		ajaxMultiSelect(url, data, target, defaultValue, isAll);
		
		setTimeout(appendDimOption,1000);
	}
	
	function appendDimOption(){
		$("#dimValueId")[0].sumo.reload();
	}
	
	// [속성 검색 제약] 설정
	function changeConstraint(avg, avg2) {
		if (avg == "" || avg == "3") {
			if ($("#isLov"+avg2).val() == "Y") {
				$("#searchValue"+avg2).attr('style', 'display:none; width:50%; height: 25px; margin-left: 10px; ');
				$("#ssAttrLov"+avg2).attr('style', 'width:235px;margin-left:10px;');
			} else {
				$("#searchValue"+avg2).attr('style', 'display:inline; width:50%; height: 25px; margin-left: 10px; ');
				$("#ssAttrLov"+avg2).attr('style', 'display:none;width:120px;margin-left:10px;');
			}
		} else {
			$("#searchValue"+avg2).val("");
			$("#searchValue"+avg2).attr('style', 'display:none; width:50%; height: 25px; margin-left: 10px; ');
			$("#ssAttrLov"+avg2).attr('style', 'display:none;width:120px;margin-left:10px;');
		}
	}
	
	
	// [Clear] click
	function clearSearchCon() {
		// 계층
		
		$("#appendDiv").empty();
		//$("#classCode").val("").attr("selected", "selected");
		// 기본정보 상세
		$("#detailID").val('');
		$("#detailOwnerTeam").val('');
		$("#detailAuthor").val('');
		$("#SC_STR_DT1").val('');
		$("#SC_END_DT1").val('');
		$("#SC_STR_DT2").val('');
		$("#SC_END_DT2").val('');


		$("#attrIndex").val("0");
		changeClassCode("", '${ItemTypeCode}');
		// Dimension

		$("#dimTypeId")[0].sumo.selectItem(0);
		fnResetSelectBox("dimValueId[]","");
		$('#dimValueId')[0].sumo.reload();
		// 상태
		
		$("#Status")[0].sumo.selectItem(0);
		$("#detailClassCode")[0].sumo.selectItem(0);
	
		$("#detailCompanyId")[0].sumo.selectItem(0);
	}
	
	// [back] click
	function goBack() {
		var url = "subItemList.do";
		var data = "s_itemID=${s_itemID}&option=${option}&pop=${pop}";
		var target = "actFrame";
		ajaxPage(url, data, target);
	}

	function fnResetSelectBox(objName,defaultValue){
		$("select[name='"+ objName +"'] option").not("[value='"+defaultValue+"']").remove(); 
	}
	
	function fnHideSearch() {
		var tempSrc = $("#frame_sh").attr("src");
		if($("#frame_sh").hasClass("frame_show")) {
			$("#search").hide();
			$("#buttonGroup").hide();
			$("#frame_sh").attr("class","frame_hide");
			$("#frame_sh").attr("alt","${WM00159}");
			$("#frame_sh").attr("src",tempSrc.replace("btn_frame_show","btn_frame_hide"));
		}
		else {
			$("#search").show();
			$("#buttonGroup").show();
			$("#frame_sh").attr("class","frame_show");
			$("#frame_sh").attr("alt","${WM00158}");
			$("#frame_sh").attr("src",tempSrc.replace("btn_frame_hide","btn_frame_show"));
		}
	}
	

	function fnPublishItem() {
		if(p_gridArea.getCheckedRows(1).length == 0){
			alert("${WM00023}");			
		}else{
			var checkedRows = p_gridArea.getCheckedRows(1).split(",");	
			var items = "";
			var cngts = "";
			var pjtIds = "";
			var msg = "";
		
			
			for(var i = 0 ; i < checkedRows.length; i++ ){
				
				if (items == "") {
					items = p_gridArea.cells(checkedRows[i], 12).getValue();
				} else {
					items = items + "," + p_gridArea.cells(checkedRows[i], 12).getValue();
				}
				
			}
			
			if (items != "") {
				var url = "publishItem.do?";
				var data = "items=" + items;
				var target = "blankFrame";		
				ajaxPage(url, data, target);
			}
		}
	}

	
</script>

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
	<input type="hidden" id="attrIndex" value="0">
	<input type="hidden" id="beforeCode" value="">
	
	<input type="hidden" id="attrCodeSorting" value="">
		
	<div align="center">
	
	<table style="table-layout:fixed;" border="0" cellpadding="0" cellspacing="0" class="tbl_search"  id="search">
		<colgroup>
		    <col width="8.3%">
		    <col width="25%">
		    <col width="8.3%">
		    <col width="25%">
		    <col width="8.3%">
		    <col width="25%">
	    </colgroup>
	    <!-- 계층, ID, 상태 -->
	    <tr>
	    	<th class="">${menu.LN00016}</th>
 			<td   class="">
 				<select id="detailClassCode" name="detailClassCode">
					<option value="">Select</option>
					<c:forEach var="i" items="${classCodeList}">
						<option value="${i.CODE}">${i.NAME}</option>						
					</c:forEach>	
				</select>
 			</td>
 			
  			<th class="">ID</th>
  			<td class=""><input type="text" id="detailID" name="detailID" value="" class="stext"></td>
  			
  			<!-- [상태] -->
            <th  class="">${menu.LN00027}</th>
            <td class="alignL last ">
            	<select id="Status" name="Status">
            	<option value="">Select</option>
            	<c:forEach var="i" items="${statusList}">
						<option value="${i.CODE}">${i.NAME}</option>
            	</c:forEach>
            	</select>
            </td>		
	    </tr>
	    
	    <!-- 법인, 관리조직, 담당자 -->
	    <tr>
	    	<th>${menu.LN00014}</th>
   			<td  >
   				<select id="detailCompanyId" name="detailCompanyId" >
					<option value="">Select</option>	
					<c:forEach var="i" items="${companyOption}">
					<option value="${i.TeamID}">${i.Name}</option>						
					</c:forEach>
				</select>
			</td>
			<th>${menu.LN00018}</th>
			<td><input type="text" id="detailOwnerTeam" name="detailOwnerTeam" value="" class="stext"></td>
			<th>${menu.LN00004}</th>
			<td class="last" ><input type="text" id="detailAuthor" name="detailAuthor" value="" class="stext"></td>	
	    </tr>
	    
	    <!-- 생성일, 수정일 -->
	    <tr>
	    
	    	<!-- Dimension -->
		    <th>Dimension</th>
		    <td class="alignL DimensionTd">
		    	<select id="dimTypeId" >
		    		<option value=''>Select</option>
           	   		<c:forEach var="i" items="${dimTypeList}">
                   		<option value="${i.DimTypeID}">${i.DimTypeName}</option>
           	    	</c:forEach>
				</select>
				<select id="dimValueId" name="dimValueId[]" style="height:16px;" multiple="multiple">
					<option value="">Select</option>
				</select>
		    </td>	
		    
	    	<th>${menu.LN00013}</th>	
	    	<td>
   				<input type="text" id="SC_STR_DT1" name="SC_STR_DT1" value=""	class="input_off datePicker stext" size="8"
					style="width: calc(50% - 37px);" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
					~
				<input type="text" id=SC_END_DT1	name="SC_END_DT1" value="" class="input_off datePicker stext" size="8"
					style="width: calc(50% - 37px);" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
   			</td>
   			
   			<th>${menu.LN00070}</th>	
   			<td class="last">
   				<input type="text" id="SC_STR_DT2" name="SC_STR_DT2" value=""	class="input_off datePicker stext" size="8"
					style="width: calc(50% - 37px);" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
					~
				<input type="text" id=SC_END_DT2	name="SC_END_DT2" value="" class="input_off datePicker stext" size="8"
					style="width: calc(50% - 37px)" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
   			</td>			
	    </tr>
	    
	    <!-- 속성, Dimension -->
	    <tr>
	    	<!-- 속성 -->
		    <th>${menu.LN00031}</th>
		    <td colspan="5" class="alignL">
				<select id="AttrCode" Name="AttrCode[]" multiple="multiple" class="SlectBox" >
				</select>
				
				<div id="appendDiv"></div>
			</td>
   			<!-- 	
   			<th>Symbol</th>	
   			<td class="last">
   				<select id="symbolCode" style="width:120px">
		    		<option value=''>Select</option>
           	   		<c:forEach var="i" items="${symbolCodeList}">
                   		<option value="${i.CODE}">${i.NAME}</option>
           	    	</c:forEach>
				</select>
   			</td>
   			 -->
	    </tr>
	    
	</table>
	
	<li id="buttonGroup" class="floatC mgR20 mgT5">
		<input id="btnSearch" type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" style="cursor:pointer;">
		&nbsp;<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="cursor:pointer;" onclick="clearSearchCon();">
	</li>
	
   <div class="countList pdT10">
        <li class="count"><input type="image" id="frame_sh" class="frame_show" alt="${WM00158}" src="${root}${HTML_IMG_DIR}/btn_frame_show.png" value="Clear" style="cursor:pointer;width:20px;height:15px;margin-right:5px;" onclick="fnHideSearch();">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR"> 
        <c:if test="${pop != 'pop'}">
        
			<c:if test="${sessionScope.loginInfo.sessionMlvl eq 'SYS' && accMode == 'PUB'}">
			&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="EXE"></span><input value="Publish" type="submit" onclick="fnPublishItem();"></span>
				
			</c:if>	
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<c:if test="${myItem == 'Y'}">
				&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="gov"></span><input value="Gov" type="submit" onclick="editCheckedAllItems('Owner');"></span>
				&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="edit"></span><input value="Attribute" type="submit" onclick="editCheckedAllItems('Attribute');"></span>
			</c:if>
			</c:if>
			</c:if>
			&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			&nbsp;<span class="btn_pack medium icon" style="display:inline-block;"><span class="pre"></span><input value="Back" onclick="goBack();" type="submit"></span>
			&nbsp;&nbsp;&nbsp;&nbsp;
        </li>
   </div>
	
</div>		
	</form>
	
	<div id="gridDiv" class="mgB10 clear" align="center">
		<div style="width: 100%;" id="grdGridArea"></div>
		<div id="pagination" style="width:100%; height:60px;"></div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->
	
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
	</div>	
<script>

	var grdGridArea = new dhx.Layout("grdGridArea", {
    	rows: [ { id: "a" } ] });

	var grid = new dhx.Grid("grdOTGridArea", {
	    columns: [
	        { width: 40, id: "RNUM", header: [{ text: "${menu.LN00024}", align:"center" }], align: "center" },
	        { width: 30, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center", htmlEnable: true}], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 40, id: "ItemTypeImg", header: [{ text: "${menu.LN00042}", align: "center" }], align: "center", htmlEnable: true,
	    		template: function (text, row, col) {

	            	var result = "";
	            	if(text) {
	            		result += "<img src='${root}${HTML_IMG_DIR_ITEM}/" + text + "' />";
	            		return result;
	            	}
	            	if(row.ItemTypeImg) {
	            		result += "<img src='${root}${HTML_IMG_DIR_ITEM}/" + row.ItemTypeImg + "' />";
	            		return result;
	            	}
	            	return result;
	                
	            }	
	        },
	        { width: 80, id: "ClassName", header: [{ text: "${menu.LN00016}", align:"center" },], align: "center" },
	        { width: 80, id: "Identifier", header: [{ text: "${menu.LN00106}", align:"center" },]},
	        { width: 180, id: "ItemName", header: [{ text: "${menu.LN00028}", align:"center" }] },
	        { id: "Path", header: [{ text: "${menu.LN00043}", align:"center" }] },
	        { width: 120, id: "TeamName", header: [{ text: "${menu.LN00014}", align:"center" }], align: "center" },
	        { width: 120, id: "OwnerTeamName", header: [{ text: "${menu.LN00018}", align:"center" }], align: "center" },
	        { width: 100, id: "Name", header: [{ text: "${menu.LN00004}", align:"center" }], align: "center" },
	        { width: 90, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align:"center" }], align: "center" },
	        { width: 90, id: "StatusName", header: [{ text: "${menu.LN00027}", align:"center" }], align: "center" }
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	});
	
	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});
	
	grid.events.on("cellClick", function(row, column, event) {
	    const rowId = row.id; // 클릭된 행의 ID
	    const colId = column.id; // 클릭된 컬럼 ID (index 대신 id 사용)
	    if (colId !== "checkbox") {
	    	const clikckedItem = grid.data.getItem(rowId).ItemID;
	    	if ('${loginInfo.sessionMlvl}' !== "SYS") {
	    		fnCheckUserAccRight(clikckedItem, `doDetail(${grid.data.getItem(rowId).ItemID})`, "${WM00033}");
    		} else {
                doDetail(clikckedItem);
            }
    	}
    });
	
	grdGridArea.getCell("a").attach(grid);
	
	function doSearchList(){
		if($("#SC_STR_DT1").val() != "" && $("#SC_END_DT1").val() == "")		$("#SC_END_DT1").val(new Date().toISOString().substring(0,10));
		if($("#SC_STR_DT2").val() != "" && $("#SC_END_DT2").val() == "")		$("#SC_END_DT2").val(new Date().toISOString().substring(0,10));
		$('#loading').fadeIn(150);
		
		var currentGridData = setGridConfig();
		var param = "";
		param += currentGridData.data + "&sqlID="+currentGridData.key
		
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
 				fnReloadGrid(result);
				$('#loading').fadeOut(150);
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
		
		function fnReloadGrid(newGridData){
			grid.data.parse(newGridData);
			$("#TOT_CNT").html(grid.data.getLength());
		}
	}
	
// 	[Owner][Attribute] 버튼 이벤트

	function editCheckedAllItems(avg){ 
		var checkedRows = grid.data.findAll(function (data){
			return data.checkbox
		});
	
		if(checkedRows.length == 0){
			alert("${WM00023}");
			return;
		}

		var itemIDs = "";
		var classCodes = "";
		var nowClassCode = "";
		
		for(var i = 0 ; i < checkedRows.length; i++ ){			
			if (itemIDs == "") {
				itemIDs = "" + checkedRows[i].ItemID;
				classCodes = checkedRows[i].ClassCode;
				nowClassCode = checkedRows[i].ClassCode;
			} else {
				itemIDs = (itemIDs + "," + checkedRows[i].ItemID);
				if (nowClassCode !== checkedRows[i].ClassCode) {
					classCodes = classCodes + "," + checkedRows[i].ClassCode;
					nowClassCode = checkedRows[i].ClassCode;
				}
			}
		}
			
		if (itemIDs !== "") {
			if (avg == "Attribute") {
				var url = "selectAttributePop.do?";
				var data = "classCodes="+classCodes+"&items="+itemIDs; 
			    var option = "dialogWidth:400px; dialogHeight:250px;";			
			    //window.showModalDialog(url + data , self, option);
			   
			    var w = "400";
				var h = "250";
				document.getElementById("items").value = itemIDs;
				document.getElementById("classCodes").value = classCodes;
			    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes"); 
			} else if(avg == "Owner") {
				var url = "selectOwnerPop.do?";
				var data = "items="+itemIDs; 
			    var option = "dialogWidth:450px; dialogHeight:370px;";
			    var w = "400";
				var h = "370";
			    window.open(url + data , "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
			}			
		}
		 
	}
</script>