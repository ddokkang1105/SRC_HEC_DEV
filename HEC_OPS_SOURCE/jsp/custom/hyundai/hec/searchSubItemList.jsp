<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxToolbar/codebase/skins/dhtmlxtoolbar_dhx_skyblue.css'/>">
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>

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
	var p_gridArea;				//그리드 전역변수
	
	$(document).ready(function() {
		$("input.datePicker").each(generateDatePicker);
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 208)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			if($("#frame_sh").hasClass("frame_show")) {
				$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 208)+"px;");
			} else {
				$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 408)+"px;");
			}
		};
		$("#detailClassCode").val("${defClassCode}");
		$("#Status").val("${defStatus}");
		$("#detailCompanyId").val("${defCompany}");
		$("#detailOwnerTeam").val("${defOwnerTeamID}");
		$("#detailAuthor").val("${defAuthorID}");
		$("#dimTypeId").val("${defDimTypeID}");
		$("#dimValueId").val("${defDimValueID}");
		$("#AttrCode").val("${defAttrTypeCode}");
		
		changeDimValue("${defDimTypeID}","${defDimValueID}");
		
		$("#excel").click(function(){p_gridArea.toExcel("${root}excelGenerate");doExcel();});
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
		 $('#dimValueId').SumoSelect();
		 
		//fnSelect('Status', '&Category=ITMSTS', 'dictionyCode', '', 'Select'); // 아이템 상태 조건
		
		// [속성] option 설정
		changeClassCode("", '${defItemTypeCode}');
		
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
			if(onkey.keyCode == 13){
				$("#searchValueAT00001").val($(this).val());
				doSearchList();
				return false
			;}
		});		
		
		gridInit();
		$("#dimTypeId").SumoSelect({ csvDispCount: 3 });
		$("#detailClassCode").SumoSelect({csvDispCount: 3});
		$("#detailCompanyId").SumoSelect({csvDispCount: 3});
		$("#Status").SumoSelect({csvDispCount: 3});

		
		$("#mSearch").hide();
		$("#buttonGroup").hide();
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
			changeAttrCode(value);
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

		html += '<div class="'+divClassName+'" style="margin-top:10px;">';

		html += "<div style=\"width: 120px; text-align: right; line-height: 30px; padding-left: 10px; float:left;\" ><b>"+text+"</b></div>";	
			
		html += "<select id=\"constraint"+divClassName+"\" name=\"constraint[]\" class=\"SlectBox\" style=\"width:180px;margin-left:30px;\" onChange=\"changeConstraint($(this).val(),'"+divClassName+"')\" >";
		html += "<option value=\"\">include(equal to)</option>";
		html += "<option value=\"1\">is specified</option>";
		html += "<option value=\"2\">is not specified</option>";
		html += "<option value=\"3\">not include(not equal to)</option>";
		html += "</select>&nbsp;";
		html += "<input type=\"text\" id=\"searchValue"+divClassName+"\" value=\"\" class=\"stext\" style=\"width:250px;height:25px;margin-left:30px;margin-top: -23px;\">";
		html += "<select id=\"AttrLov"+divClassName+"\" name=\"AttrLov[]\" style=\"display:none;width:120px;margin-left:30px;\" multiple=\"multiple\">";
		html += "<option value=\"\">Select</option>	";
		html += "</select><input type=\"hidden\" id=\"isLov"+divClassName+"\" value=\"\">";
		html += "<input type=\"hidden\" id=\"isSelect"+divClassName+"\" value=\""+bfAttr+"\">";
		html += '<div id="asDiv'+divClassName+'" style="height: 25px; margin-left: 30px; display: inline;"></div>';

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
	function gridInit(){		
		var d = setGridData();		
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
		
		p_gridArea.setColumnHidden(5, true);
		p_gridArea.setColumnHidden(6, true);
		p_gridArea.setColumnHidden(7, true);
		p_gridArea.setColumnHidden(8, true);
		p_gridArea.setColumnHidden(14, true); // Report
		p_gridArea.setColumnHidden(15, true);
		p_gridArea.setColumnHidden(16, true);
		fnSetColType(p_gridArea, 1, "ch");
		fnSetColType(p_gridArea, 14, "img");
		
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		
		//START - PAGING
		p_gridArea.enablePaging(true, 100, null, "pagingArea", true, "recinfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
		//END - PAGING
	}	
	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "custom_SQL.zhec_getSearchMultiList";
		result.header = "${menu.LN00024},#master_checkbox,표준구분, No.,명칭, 기능, 대분류, 중분류, 소분류, 분류체계, ${menu.LN00018}, 작성자, 개정번호, 개정일, Report, ItemID, ClassCode";
		result.cols = "CHK|ItemTypeName|Identifier|ItemName|L1Name|L2Name|L3Name|L4Name|Path|OwnerTeamName|Name|CSVersion|ValidFrom|Report|ItemID|ClassCode";
		result.widths = "30,30,90,90,250,80,120,120,120,*,120,80,60,90,90,90,90,0,0"; // item 검색
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,center,left,left,center,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&cnxItemID=${s_itemID}&cnxFlag=${cnxFlag}&cnxClassCode=${cnxClassCode}"
					+ "&defaultLang=" + $("#defaultLang").val()
					+ "&isComLang=" + $("#isComLang").val()
		 			+ "&pageNum=" + $("#currPage").val();
		
		/* [기본정보] 조건 선택, 입력값 */
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
				
				if(i*1 > 0) {
					selectOption = $("#selectOption"+aval).val();
				}
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
							searchValue = setSpecialChar($("#searchValue"+aval).val());
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
		if ($("#dimTypeId").val() != "") {
			
			var dvArray = new Array();
			var nothing = "";
			$("#dimValueId :selected").each(function(i, el){ 
				var dvTemp = $(el).val();
				if (dvTemp != "" && "nothing" != dvTemp && "Nothing" != dvTemp) {
					dvArray.push(dvTemp);
				} else if("nothing" == dvTemp || "Nothing" == dvTemp) {
					nothing = "&nothingDim=Y";
				}

			});

			result.data = result.data+ "&DimTypeID=" + $("#dimTypeId").val() + "&isNotIn=N&DimValueIDOLM_ARRAY_VALUE="+dvArray+nothing;
		}
		
		if("${cnxFlag}" != "Y") {
			result.data = result.data+ "&childItems=${childItems}";		
			result.data = result.data+ "&isNothingLowLank=${isNothingLowLank}";
		}

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
	
	function gridOnRowSelect(id, ind){
		if(ind != 1) {
			if(ind == 11){
				goReportList(p_gridArea.cells(id, 15).getValue());
			} else {
				doDetail(p_gridArea.cells(id, 15).getValue());
			}
		}
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
	function doSearchList(){
		var d = setGridData();
		//fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
		/* 건수 제한 메세지 표시 */
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data, "", "", "", "", "", "${WM00119}", 1000);
	}
	
	// [Report] Click
	function goReportList(avg) {
		/*
		var url = "objectReportList.do";
		var target = "processList";
		var data = "s_itemID="+avg+"&kbn=searchList&pageNum=" + $("#currPage").val()
		+ "&ItemTypeCode="		+ $('#ItemTypeCode').val()
		+ "&ClassCode="     	+ $("#ClassCode").val()
		+ "&AttrCode="     	+ $("#AttrCode").val()
		+ "&searchValue="     	+ $("#searchValue").val()
		; 
	 	ajaxPage(url, data, target);*/
	 	
	 	var url = "objectReportList.do?s_itemID="+avg;
		var w = 1000;
		var h = 800;
		openPopup(url,w,h,avg);
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
		var defaultValue = "${defClassCode}";              // 초기에 세팅되고자 하는 값
		var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxMultiSelect(url, data, target, defaultValue, isAll);
		setTimeout(appendOption,1000);
	}
	
	function appendOption(){
		 var optionName = '${menu.LN00028}';
		 $("#AttrCode").prepend("<option value='AT00001'>"+optionName+"</option>");
		 
		 $('#AttrCode')[0].sumo.reload();
		 if("${defAttrTypeCode}" != ""){
		 	checkAttrCode("${defAttrTypeCode}","${defAttrTypeName}", "NEW");
		 }else{
		 	checkAttrCode("AT00001",optionName, "NEW");
		 }
		 doSearchList();
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
			$("#searchValue"+attrCode).attr('style', 'display:none;width: 250px; height: 25px; margin-left: 30px;margin-top: -23px; ');	
			
			var url    = "getAttrLovSelectOption.do"; // 요청이 날라가는 주소
			var data   = "languageID="+languageID+"&attrCode="+attrCode; //파라미터들
			var target = "AttrLov"+attrCode;            // selectBox id
			var defaultValue = "";              // 초기에 세팅되고자 하는 값
			var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
			ajaxMultiSelect(url, data, target, defaultValue, isAll);
			setTimeout("setAttrLovMulti('"+attrCode+"')",500);
		} else {
			$("#isLov"+attrCode).val("");
			$("#searchValue"+attrCode).attr('style', 'width: 250px; height: 25px; margin-left: 30px; display: inline; margin-top: -23px;');
			$("#AttrLov"+attrCode).attr('style', 'display:none;width:120px;margin-left:30px;');	
		}
		
		
	}

	function setAttrLovMulti(atrCode){
		 $('#AttrLov'+atrCode).SumoSelect();
		 $('#ssAttrLov'+atrCode).attr("style","width:235px;margin-left:30px;");
	}
	
	
	// [dimValue option] 설정
	function changeDimValue(avg, avg2){
		var url    = "getDimValueSelectOption.do"; // 요청이 날라가는 주소
		var data   = "dimTypeId="+avg+"&searchYN=Y"; //파라미터들
		var target = "dimValueId";            // selectBox id
		var defaultValue = avg2;              // 초기에 세팅되고자 하는 값
		var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		
		ajaxMultiSelect(url, data, target, defaultValue, isAll);
		
		setTimeout(function() {appendDimOption(avg2);}, 1000);
	}
	
	function appendDimOption(avg2){
		$("#dimValueId")[0].sumo.reload();
		if(avg2 != ""){
			$("#dimValueId")[0].sumo.selectItem(avg2);
		}
	}
	
	// [속성 검색 제약] 설정
	function changeConstraint(avg, avg2) {
		if (avg == "" || avg == "3") {
			if ($("#isLov"+avg2).val() == "Y") {
				$("#searchValue"+avg2).attr('style', 'display:none;width: 250px; height: 25px; margin-left: 30px; ');
				$("#ssAttrLov"+avg2).attr('style', 'width:235px;margin-left:30px;');
			} else {
				$("#searchValue"+avg2).attr('style', 'display:inline;width: 250px; height: 25px; margin-left: 30px; ');
				$("#ssAttrLov"+avg2).attr('style', 'display:none;width:120px;margin-left:30px;');
			}
		} else {
			$("#searchValue"+avg2).val("");
			$("#searchValue"+avg2).attr('style', 'display:none;width: 250px; height: 25px; margin-left: 30px; ');
			$("#ssAttrLov"+avg2).attr('style', 'display:none;width:120px;margin-left:30px;');
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
		$("#searchValue").val('');


		$("#attrIndex").val("0");
		changeClassCode("", '${ItemTypeCode}');
		// Dimension

		$("#dimTypeId")[0].sumo.selectItem(0);
		fnResetSelectBox("dimValueId[]","");
		$('#dimValueId')[0].sumo.reload();
		// 상태
		
		$("#Status")[0].sumo.selectItem(0);
		$("#detailClassCode")[0].sumo.selectItem(2);
	
		$("#detailCompanyId")[0].sumo.selectItem(0);
	}
	
	/**  
	 * [Owner][Attribute] 버튼 이벤트
	 */
	function editCheckedAllItems(avg){ 
		if(p_gridArea.getCheckedRows(1).length == 0){
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
				items = p_gridArea.cells(checkedRows[i], 13).getValue();
				classCodes = p_gridArea.cells(checkedRows[i], 14).getValue();
				nowClassCode = p_gridArea.cells(checkedRows[i], 14).getValue();
			} else {
				items = items + "," + p_gridArea.cells(checkedRows[i], 13).getValue();
				if (nowClassCode != p_gridArea.cells(checkedRows[i], 14).getValue()) {
					classCodes = classCodes + "," + p_gridArea.cells(checkedRows[i], 14).getValue();
					nowClassCode = p_gridArea.cells(checkedRows[i], 14).getValue();
				}
			}
		}

		if (items != "") {
			if (avg == "Attribute") {
				var url = "selectAttributePop.do?";
				var data = "classCodes="+classCodes+"&items="+items; 
			    var option = "dialogWidth:400px; dialogHeight:250px;";			
			    //window.showModalDialog(url + data , self, option);
			   
			    var w = "400";
				var h = "250";
				document.getElementById("items").value = items;
				document.getElementById("classCodes").value = classCodes;
			    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes"); 
			} else if(avg == "Owner") {
				var url = "selectOwnerPop.do?";
				var data = "items="+items; 
			    var option = "dialogWidth:450px; dialogHeight:370px;";
			    var w = "400";
				var h = "370";
			    window.open(url + data , "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
			}			
		}
		 
	}
	
	function urlReload(){
		gridInit();
		doSearchList();
	}
	
	// [back] click
	function goBack() {
		var url = "subItemList.do";
		var data = "s_itemID=${s_itemID}&option=${option}&pop=${pop}";
		var target = "actFrame";
		ajaxPage(url, data, target);
	}

	function fnResetSelectBox(objName,defaultValue)
	{
		$("select[name='"+ objName +"'] option").not("[value='"+defaultValue+"']").remove(); 
	}

	function showMultiSearchDiv() {
		var avg = $("#multiSearch").val();

		if(avg == "N") {
			$("#search").hide();
			$("#mSearch").show();
			$("#buttonGroup").show();
			$("#multiSearch").val("Y");
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 408)+"px;");
        }
		else {
			$("#search").show();
			$("#mSearch").hide();
			$("#buttonGroup").hide();
			$("#multiSearch").val("N")
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 208)+"px;");
		}
	}
	
	function fnHideSearch() {
		var tempSrc = $("#frame_sh").attr("src");
		var avg = $("#multiSearch").val();

		if($("#frame_sh").hasClass("frame_show")) {
			if(avg == "N") {
				$("#search").hide();
			}
			else {
				$("#mSearch").hide();
				$("#buttonGroup").hide();
			}

			$("#frame_sh").attr("class","frame_hide");
			$("#frame_sh").attr("alt","${WM00159}");
			$("#frame_sh").attr("src",tempSrc.replace("btn_frame_show","btn_frame_hide"));

			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 108)+"px;");
		} else {
			if(avg == "N") {
				$("#search").show();
			}
			else {
				$("#mSearch").show();
				$("#buttonGroup").show();
			}
			$("#frame_sh").attr("class","frame_show");
			$("#frame_sh").attr("alt","${WM00158}");
			$("#frame_sh").attr("src",tempSrc.replace("btn_frame_hide","btn_frame_show"));
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 208)+"px;");
		}
	}

	function doNameSearchList() {
		$("#searchValueAT00001").val($("#searchValue").val());
		doSearchList();
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
	<input type="hidden" id="multiSearch" value="N">
	
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc;">
		<h3 style="padding: 6px 0 6px 0"><img src="${root}${HTML_IMG_DIR}/icon_search_title.png">&nbsp;&nbsp;${itemTypeName} - ${selectedItemPath}</h3>
	</div>

	<div id="search" align="center" style="margin-top: 20px;">
		<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:30%;ime-mode:active;">
		<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doNameSearchList()" value="Search" style="cursor:pointer;">
		<input type="image" class="image" onclick="showMultiSearchDiv();" src="${root}${HTML_IMG_DIR}/btn_search_plus.png" value="Advanced Search" style="cursor:pointer;">
	</div>
	<div align="center">
		<table style="table-layout:fixed;" border="0" cellpadding="0" cellspacing="0" class="tbl_search"  id="mSearch">
			<colgroup>
			    <col width="7%">
			    <col width="19%">
			    <col width="7%">
			    <col width="7%">
			    <col width="8%">
			    <col width="7%">
			    <col width="12%">
		    </colgroup>
		    <!-- 계층, ID, 상태 -->
		    <tr>
		    	<th class="viewtop">${menu.LN00016}</th>
	 			<td   class="viewtop">
	 				<select id="detailClassCode" name="detailClassCode" style="width:120px;" >
						<option value="">Select</option>
						<c:forEach var="i" items="${classCodeList}">
							<option value="${i.CODE}">${i.NAME}</option>						
						</c:forEach>	
					</select>
	 			</td>
	  			<th  class="viewtop">ID</th>
	  			<td colspan="2"   class="viewtop"><input type="text" id="detailID" name="detailID" value="" class="stext" style="width:150px"></td>
	  			<!-- [상태] -->
	            <th  class="viewtop">${menu.LN00027}</th>
	            <td class="alignL last viewtop"">
	            	<select id="Status" name="Status" style="width:150px;">
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
	   				<select id="detailCompanyId" name="detailCompanyId" style="width:120px;" >
						<option value="">Select</option>	
						<c:forEach var="i" items="${companyOption}">
						<option value="${i.TeamID}">${i.Name}</option>						
						</c:forEach>
					</select>
				</td>
				<th>${menu.LN00018}</th>
				<td colspan="2" ><input type="text" id="detailOwnerTeam" name="detailOwnerTeam" value="" class="stext" style="width:150px"></td>
				<th>${menu.LN00004}</th>
				<td class="last" ><input type="text" id="detailAuthor" name="detailAuthor" value="" class="stext" style="width:150px"></td>	
		    </tr>
		    
		    <!-- 생성일, 수정일 -->
		    <tr>
		    
		    	<!-- Dimension -->
			    <th>Dimension</th>
			    <td class="alignL DimensionTd">
			    	<select id="dimTypeId" style="width:120px" >
			    		<option value=''>Select</option>
	           	   		<c:forEach var="i" items="${dimTypeList}">
	                   		<option value="${i.DimTypeID}">${i.DimTypeName}</option>
	           	    	</c:forEach>
					</select>
					<select id="dimValueId" name="dimValueId[]" style="width:120px;height:16px;" multiple="multiple">
						<option value="">Select</option>
					</select>
			    </td>	
		    	<th>${menu.LN00013}</th>	
		    	<td colspan="2">
	   				<font><input type="text" id="SC_STR_DT1" name="SC_STR_DT1" value=""	class="input_off datePicker stext" size="8"
						style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</font>
						~
					<font><input type="text" id=SC_END_DT1	name="SC_END_DT1" value="" class="input_off datePicker stext" size="8"
						style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</font>
	   			</td>
	   			<th>${menu.LN00070}</th>	
	   			<td class="last">
	   				<font><input type="text" id="SC_STR_DT2" name="SC_STR_DT2" value=""	class="input_off datePicker stext" size="8"
						style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</font>
						~
					<font><input type="text" id=SC_END_DT2	name="SC_END_DT2" value="" class="input_off datePicker stext" size="8"
						style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</font>
	   			</td>			
		    </tr>
		    
		    <!-- 속성, Dimension -->
		    <tr>
		    	<!-- 속성 -->
			    <th>${menu.LN00031}</th>
			    <td colspan="6" class="alignL">
					<select id="AttrCode" Name="AttrCode[]" multiple="multiple" style="width:300px;" class="SlectBox" >
					</select>
					
					<div id="appendDiv"></div>
				</td>
		    </tr>
		</table>
	
	<li id="buttonGroup" class="floatC mgR20 mgT5">
		<input id="btnSearch" type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" style="cursor:pointer;">
		&nbsp;<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="cursor:pointer;" onclick="clearSearchCon();">
		<input type="image" class="image" onclick="showMultiSearchDiv();" src="${root}${HTML_IMG_DIR}/btn_search_plus.png" value="Advanced Search" style="cursor:pointer;">
	</li>
	
   <div class="countList pdT10">
        <li class="count"><input type="image" id="frame_sh" class="frame_show" alt="${WM00158}" src="${root}${HTML_IMG_DIR}/btn_frame_show.png" value="Clear" style="cursor:pointer;width:20px;height:15px;margin-right:5px;" onclick="fnHideSearch();">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR"> 
        <c:if test="${pop != 'pop'}">
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
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->
	
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
	</div>	
