<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:url value="/" var="root" />

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css" />

<script type="text/javascript">
	var p_gridArea; //그리드 전역변수
	var defItemTypeCode = "${defItemTypeCode}";
	$(document).ready(
		function() {
			// 초기 표시 화면 크기 조정 
			$("#grdGridArea").attr("style", "height:" + (setWindowHeight() * 0.45) + "px;");
			// 화면 크기 조정
			window.onresize = function() {
				$("#grdGridArea").attr("style", "height:" + (setWindowHeight() * 0.45) + "px;");
			};


			$("#excel").click(function() {
				doExcel();
				return false;
			});

			$('.searchList').click(function() {
				doSearchList();
			});

			// 레이어 팝업 닫기
			$('.closeBtn').click(function() {
				layerWindow.removeClass('open');
			});
			
			changeClassCode("'"+defItemTypeCode+"'");
			$('#AttrCode').SumoSelect();
			
			changeItemTypeCode();
			$("#itemTypeCode").SumoSelect({parentWidth: 13});
			
			var timer = setTimeout(function() {
				gridInit();
			}, 1000); //1000 = 1초
		});
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
	// [속성 option] 설정
	// 항목계층 SelectBox 값 선택시  속성 SelectBox값 변경
	function changeClassCode(itemTypeCodes){
		$("#attrIndex").val("0");
		$("#appendDiv").empty();
		$("#displayLabel").empty();
		var url    = "getSearchSelectOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&sqlID=search_SQL.attrBySearch&itemTypeCodes="+itemTypeCodes; //파라미터들
		var target = "AttrCode";            // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxMultiSelect(url, data, target, defaultValue, isAll);
		setTimeout(appendOption,1000);
	}
	
	function changeItemTypeCode(){
		var url    = "getSearchSelectOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&sqlID=dim_SQL.getItemTypeCodeList"; //파라미터들
		var target = "itemTypeCode";            // selectBox id
		var defaultValue = defItemTypeCode;              // 초기에 세팅되고자 하는 값
		var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxMultiSelect(url, data, target, defaultValue, isAll);
		setTimeout(appendItemTypeCodeOption,1000);
	}

	function appendOption() {
		var optionName = '${menu.LN00028}';
		$("#AttrCode").prepend("<option value='AT00001'>" + optionName + "</option>");

		$('#AttrCode')[0].sumo.reload();
		checkAttrCode("AT00001", optionName, "NEW");

	}
	
	function appendItemTypeCodeOption(){
		$("#itemTypeCode")[0].sumo.reload();
		checkItemTypeCode(defItemTypeCode);
	}
	
	function checkItemTypeCode(value) {
		var ari = $("#itemTypeCodeIndex").val();

		if ($("#option" + value).hasClass("selected")) {

			if (ari * 1 > 0)
				$("#itemTypeCodeIndex").val(ari * 1 - 1);

			$("." + value).remove();
			$("#itemTypeCode")[0].sumo.attrOptClick("option" + value);
		} else if (ari * 1 < 4) {
			$("#itemTypeCode")[0].sumo.attrOptClick("option" + value);
			$("#itemTypeCodeIndex").val(ari * 1 + 1);
		} else {
			//문구 추가 필요
			alert("최대 4개 선택 가능 합니다.");
		}
		var itemTypeCodeData = "";
		$("#itemTypeCode :selected").each(function(i, el){ 
			var aval = "'"+$(el).val()+"'";
			itemTypeCodeData += aval;
			if(($("#itemTypeCode :selected").length -1) != i){
				itemTypeCodeData += ",";
			}
		});
		changeClassCode(itemTypeCodeData);
		
	}

	function checkAttrCode(value, text, isNew) {
		var ari = $("#attrIndex").val();
		var bf = $("#isSelect" + value).val();

		if ($("#option" + value).hasClass("selected") && isNew != "NEW") {

			if (ari * 1 > 0)
				$("#attrIndex").val(ari * 1 - 1);

			$("." + value).remove();

			if (bf != "") {
				$("#asDiv" + bf).empty();
				$("#beforeCode").val(bf);
			}
			$("#AttrCode")[0].sumo.attrOptClick("option" + value);
		} else if (ari * 1 < 4) {
			changeAttrCode(value);
			checkAttrDiv(value, text, ari);
			$("#AttrCode")[0].sumo.attrOptClick("option" + value);
			$("#attrIndex").val(ari * 1 + 1);
		} else {
			//문구 추가 필요
			alert("최대 4개 선택 가능 합니다.");
		}
	}

	function changeAttrCode(avg) {
		var url = "getAttrLov.do";
		var data = "attrCode=" + avg;
		var target = "blankFrame";
		ajaxPage(url, data, target);
	}

	function checkAttrDiv(divClassName, text, ari) {
		var html = "";
		var bfAttr = $("#beforeCode").val();

		html += '<div class="'+divClassName+'" style="margin-top:10px;">';
		html += "<div style=\"width: 120px; text-align: right; line-height: 30px; padding-left: 10px; margin-right:30px; float:left;\" ><b>"
				+ text + "</b></div>";

		html += "<select id=\"constraint"
				+ divClassName
				+ "\" name=\"constraint[]\" class=\"SlectBox\" style=\"width:180px;\" onChange=\"changeConstraint($(this).val(),'"
				+ divClassName + "')\" >";
		html += "<option value=\"\">include(equal to)</option>";
		html += "<option value=\"1\">is specified</option>";
		html += "<option value=\"2\">is not specified</option>";
		html += "<option value=\"3\">not include(not equal to)</option>";
		html += "</select>&nbsp;";
		html += "<input type=\"text\" id=\"searchValue"
				+ divClassName
				+ "\" value=\"\" class=\"stext\" style=\"width:50%;height:25px;margin-left:10px;\">";
		html += "<select id=\"AttrLov"+divClassName+"\" name=\"AttrLov[]\" style=\"display:none;width:120px;margin-left:30px;\" multiple=\"multiple\">";
		html += "<option value=\"\">Select</option>	";
		html += "</select><input type=\"hidden\" id=\"isLov"+divClassName+"\" value=\"\">";
		html += "<input type=\"hidden\" id=\"isSelect"+divClassName+"\" value=\""+bfAttr+"\">";
		html += '<div id="asDiv'+divClassName+'" style="height: 30px; margin-left: 10px; display: inline;"></div>';

		if (ari > 0) {
			var html2 = "";
			html2 += '<select id="selectOption'+divClassName+'" name="selectOption'+divClassName+'" style="width:80px; " >';
			html2 += "<option value=\"AND\" selected=\"selected\">AND</option>";
			html2 += "<option value=\"OR\">OR</option>	";
			html2 += '</select>';
			$("#asDiv" + bfAttr).append(html2);
			$("#selectOption" + divClassName).SumoSelect({
				csvDispCount : 3
			});
		}

		html += "</div>";

		if ($("div").hasClass(divClassName)) {
			$("." + divClassName).remove();
		} else {
			$("#appendDiv").append(html);
			$("#constraint" + divClassName).SumoSelect({
				csvDispCount : 3
			});
		}
		$("#beforeCode").val(divClassName);
	}

	function changeAttrCode2(attrCode, dataType, isComLang) {
		var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
		// isComLang == 1 이면, 속성 검색 의 언어 조건을 defaultLang으로 설정 해줌
		if (isComLang == '1') {
			$("#isComLang").val("Y");
		} else {
			$("#isComLang").val("");
		}

		if (dataType == "LOV" || dataType == "MLOV") {
			$("#isLov" + attrCode).val("Y");
			$("#searchValue" + attrCode).attr('style', 'display:none; width:50%; height: 25px; margin-left: 10px; ');

			var url = "getAttrLovSelectOption.do"; // 요청이 날라가는 주소
			var data = "languageID=" + languageID + "&attrCode=" + attrCode; //파라미터들
			var target = "AttrLov" + attrCode; // selectBox id
			var defaultValue = ""; // 초기에 세팅되고자 하는 값
			var isAll = "no"; // "select" 일 경우 선택, "true" 일 경우 전체로 표시
			ajaxMultiSelect(url, data, target, defaultValue, isAll);
			setTimeout("setAttrLovMulti('" + attrCode + "')", 500);
		} else {
			$("#isLov" + attrCode).val("");
			$("#searchValue" + attrCode).attr('style', 'width:50%; height: 25px; margin-left: 10px; display: inline;');
			$("#AttrLov" + attrCode).attr('style', 'display:none;width:50%;margin-left:30px;');
		}

	}

	function setWindowHeight() {
		var size = window.innerHeight;
		var height = 0;
		if (size == null || size == undefined) {
			height = document.body.clientHeight;
		} else {
			height = window.innerHeight;
		}
		return height;
	}

	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridInit() {
		var d = setGridData();

		p_gridArea = fnNewInitGrid("grdGridArea", d, "", true);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/item/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/item/");
		fnSetColType(p_gridArea, 2, "img");
		fnSetColType(p_gridArea, 11, "img");
		p_gridArea.enablePaging(true, 50, null, "pagingArea", true, "recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.setColumnHidden(0, true);
		p_gridArea.setColumnHidden(1, true);

		p_gridArea.attachEvent("onRowSelect", function(id,ind) {gridOnRowSelect(id,ind);}); 

	}

	function setGridData() {
		var result = new Object();
		var dimData = fnGetDimValueCheckBox();
		result.title = "${title}";
		result.key = "dim_SQL.getDimSearchList";
		result.header = "${menu.LN00024},ItemID,${menu.LN00042},${menu.LN00016},${menu.LN00106},${menu.LN00028},${menu.LN00043},${menu.LN00018},${menu.LN00004},${menu.LN00070},${menu.LN00027},File";
		result.cols = "ItemID|ItemTypeImg|classCodeName|Identifier|ItemName|ItemPath|teamName|authorName|LastUpdated|statusName|fileIcon";
		result.widths = "50,50,50,150,170,230,*,80,100,100,50,50";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,left,left,center,center,center,center,center";
		result.data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+ "&searchKey="+ $("#searchKey").val()
				+ "&searchValue="+ $("#searchValue").val() 
				+ dimData;
				
		if($("#itemTypeCode").val() != '' & $("#itemTypeCode").val() != null){
			var itemTypeCodeData = "";
			$("#itemTypeCode :selected").each(function(i, el){ 
				var aval = "'"+$(el).val()+"'";
				itemTypeCodeData += aval;
				if(($("#itemTypeCode :selected").length -1) != i){
					itemTypeCodeData += ",";
				}
			});
			result.data += "&itemTypeCodes=" + itemTypeCodeData;
		}				
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
				

				// [속성] 조건 선택, 입력값 
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
			result.data += "&AttrCodeOLM_MULTI_VALUE=" + attrArray;
		}	
		
		return result;
	}
	
	function gridOnRowSelect(id, ind){
		if(ind != 11){
			doDetail(p_gridArea.cells(id, 1).getValue());
		}else{
			var fileCheck = p_gridArea.cells(id, 11).getValue();
			if(fileCheck.indexOf("blank.gif") < 1) {
				var url = "selectFilePop.do";
				var data = "?s_itemID="+p_gridArea.cells(id, 1).getValue(); 
			   
			    var w = "400";
				var h = "350";
			    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");	
			}
		}
		
	}
	
	function doDetail(avg1, avg2) {
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="
				+ avg1 + "&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url, w, h, avg1);
	}
	function goItemPopUp(avg1) {
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="
				+ avg1 + "&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url, w, h, avg1);
	}

	function doSearchList(){			
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);	
	}

/*
	function doSearchList() {
		var url = "mDimItemSearchXml.do";
		var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+ "&searchKey="+ $("#searchKey").val() 
				+ "&searchValue=" + $("#searchValue").val() 
				+ fnGetDimValueCheckBox();
		if($("#itemTypeCode").val() != '' & $("#itemTypeCode").val() != null){
			var itemTypeCodeData = "";
			$("#itemTypeCode :selected").each(function(i, el){ 
				var aval = "'"+$(el).val()+"'";
				itemTypeCodeData += aval;
				if(i != 0 && ($("#itemTypeCode :selected").length -1) != i){
					itemTypeCodeData = ",";
				}
			});
			data += "&itemTypeCodes=" + itemTypeCodeData;
		}				
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
				

				// [속성] 조건 선택, 입력값 
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
			data += "&AttrCodeOLM_MULTI_VALUE=" + attrArray;
		}	
		
		var target = "blankFrame";
		ajaxPage(url, data, target);
	}
	function loadXml(totalCNT) {
		$("#TOT_CNT").text(totalCNT);
		p_gridArea.clearAll();
		p_gridArea.loadXML("${root}upload/dimSearchListXml.xml");
	}
*/

	// [+ -] Button Click
	function attrDisplayCtrl(avg) {
		if ($(".attr" + avg).css("display") == "none") {
			$(".attr" + avg).css("display", "block");
			$(".plus" + avg).css("display", "none");
			$(".minus" + avg).css("display", "table-cell");
			setOtherAttrArea(avg); // 그외 다른 Attr 내용을 닫아줌
		} else {
			$(".attr" + avg).css("display", "none");
			$(".plus" + avg).css("display", "table-cell");
			$(".minus" + avg).css("display", "none");
		}
	}

	function doExcel() {
		p_gridArea.toExcel("${root}excelGenerate");
	}

	function fnGetDimValueCheckBox() {
		var dimDataArray = new Array;
		var dimTypes = new Array;
		<c:forEach var="itemDim" items="${itemDimNameList}" varStatus="status" >
			<c:if test="${itemDim.Level eq '1' }">
				dimTypes.push("${itemDim.DimTypeID}");
			</c:if>
		</c:forEach>
		
		var selDimTypeIDs = new Array;
		var selDimValueIDs = new Array;
		var i = 0;
		<c:forEach var="dimType" items="${dimTypeNameList}" varStatus="status" >
		if ($("#${dimType.DimTypeID}_${dimType.DimValueSelect}_span").val() == "Y") {
			selDimTypeIDs[i] = "${dimType.DimTypeID}";
			selDimValueIDs[i] = "${dimType.DimValueID}";
			i++;
		}
		</c:forEach>
		<c:forEach var="dimType" items="${dimTypeNameList}" varStatus="status" >
		if ($("input:checkbox[id='${dimType.ParentID}_${dimType.DimValueSelect}']").is(":checked") == true) {
			selDimTypeIDs[i] = "${dimType.DimTypeID}";
			selDimValueIDs[i] = "${dimType.DimValueID}";
			i++;
		}
		</c:forEach>
		
		for(var j=0; j<dimTypes.length; j++){
			var dimValues = new Array;
			for(var i=0; i<selDimTypeIDs.length; i++){
				if(dimTypes[j] == selDimTypeIDs[i]){
					dimValues.push(selDimValueIDs[i]);
				}
			}
			if(dimValues.length > 0){
				dimDataArray.push({'dimTypeID' : dimTypes[j], 'dimValueID' : dimValues})
			}
		}
		
		return (dimDataArray.length > 0 ? "&dimDataOLM_MULTI_DIM="+JSON.stringify(dimDataArray) : "");
	}
	
	function fnDimLayer(dimValueID, clickID) {
		var linkLayer = "";
		if ($("#" + clickID).attr('style') == undefined	|| $("#" + clickID).attr('style') == "" || $("#" + clickID).val() == 'N') {
			$("#" + clickID).val("Y");
		} else {
			$("#" + clickID).val("N");
		}
		var dimLvl2ID = new Array;
		var i = 0;
		var lvl2Div = 0;
		<c:forEach var="dimTypeLvl2" items="${dimTypeNameList}" varStatus="status" >
		if ($("input:checkbox[id='${dimTypeLvl2.ParentID}_${dimTypeLvl2.DimValueSelect}']").is(":checked") == true) {
			dimLvl2ID[i] = "${dimTypeLvl2.ParentID}_${dimTypeLvl2.DimValueSelect}";
			i++;
		}
		</c:forEach>

		<c:forEach var="dimType" items="${dimTypeNameList}" varStatus="status" >

		if ($("#${dimType.DimTypeID}_${dimType.DimValueSelect}_span").val() == "Y") {
			
			if ($("#${dimType.DimValueSelect}").val() == undefined) {
			<c:choose>
				<c:when test = "${dimType.subDimYN eq 'N'}">
					
				</c:when>
				<c:otherwise>
					lvl2Div++;
					linkLayer += "<div id='${dimType.DimValueSelect}' class='mgT5'>";
					linkLayer += "<tr><td style='cursor:hand;height:25px;' class='alignL last mgT5' ><div class='countList pdT5 pdB5'><span style='border-radius: 10px;background-color: #0d1a79; padding:0 5px;color: #fff;'>${dimType.DimValueName}</span>&nbsp;&nbsp;&nbsp;&nbsp;";
					
					linkLayer += "<span id='${dimType.DimValueSelect}_chkY' class='btn_pack medium icon' style='display:inline_block;float:right;'><span class='confirm'></span><input value='select all' type='submit' onclick=fnCkeckAllDim('${dimType.DimValueSelect}','Y');></span>";
					linkLayer += "<span id='${dimType.DimValueSelect}_chkN' class='btn_pack medium icon' style='display:none;'><span class='confirm'></span><input value='clear all' type='submit' onclick=fnCkeckAllDim('${dimType.DimValueSelect}','N');></span>";
	
					linkLayer += "<input value='' type='hidden' id='${dimType.DimValueSelect}_chk' ></div></td></tr>";
					linkLayer += "<tr><td style='cursor:hand;height:25px;width:100%;' class='alignL last mgT5'>";
	
					<c:forEach var="dimTypeLvl2" items="${dimTypeNameList}" varStatus="status" >
					if ("${dimTypeLvl2.Level}" == "2" && "${dimTypeLvl2.ParentID}" == "${dimType.DimValueID}") {
						//linkLayer += "&nbsp;&nbsp;<input type='checkbox' name='${dimType.DimValueID}' id='${dimType.DimValueID}_${dimTypeLvl2.DimValueID}' class='mgL2 mgR2'onclick='doSearchList();'>&nbsp;${dimTypeLvl2.DimValueName}";
						linkLayer += "&nbsp;&nbsp;<input type='checkbox' name='${dimType.DimValueSelect}' id='${dimType.DimValueSelect}_${dimTypeLvl2.DimValueSelect}' class='mgL2 mgR2'>&nbsp;${dimTypeLvl2.DimValueName}";
					}
					</c:forEach>
					linkLayer += "</td></tr></div>";
				</c:otherwise>
			</c:choose>
				
				
			} else {
				$("#${dimType.DimValueSelect}").attr('style', 'display:block');
			}
			$("#${dimType.DimTypeID}_${dimType.DimValueSelect}_span").attr("style", "border-radius: 10px;background-color: #0d1a79; padding:0 5px;color: #fff;");

		} else {
			$("#${dimType.DimTypeID}_${dimType.DimValueSelect}_span").attr("style", "");
		}
		</c:forEach>

		$('#appendDiv3').html(linkLayer);
		if (lvl2Div > 0) {
			$("#appendTr").attr('style', 'display:block');
			$("#appendTr").attr('style', 'width:100%');
		} else {
			$("#appendTr").attr('style', 'display:none');
		}

		<c:forEach var="dimType" items="${dimTypeNameList}" varStatus="status" >
		if ($("#${dimType.DimTypeID}_${dimType.DimValueSelect}_span").val() == "N") {
			$("#${dimType.DimValueSelect}").remove();
			//$("#${dimType.DimValueSelect}").attr('style', 'display:none');
		}

		</c:forEach>

		for (var j = 0; j < dimLvl2ID.length; j++) {
			document.all(dimLvl2ID[j]).checked = true;
		}
		
		//doSearchList();	
		
	}

	function fnCkeckAllDim(id, currChkYN) {
		<c:forEach var="dimTypeLvl2" items="${dimTypeNameList}" varStatus="status" >
		if ("${dimTypeLvl2.Level}" == "2" && "${dimTypeLvl2.ParentID}" == id) {
			if (currChkYN == "Y") {
				document.all(id + "_${dimTypeLvl2.DimValueSelect}").checked = true;
			} else {
				document.all(id + "_${dimTypeLvl2.DimValueSelect}").checked = false;
			}
		}
		</c:forEach>

		if (currChkYN == "Y") {
			$("#" + id + "_chkN").attr('style', 'display:inline_block;float:right;');
			$("#" + id + "_chkY").attr('style', 'display:none;float:right;');
		} else {
			$("#" + id + "_chkN").attr('style', 'display:none;float:right;');
			$("#" + id + "_chkY").attr('style', 'display:inline_block;float:right;');
		}
		$("#" + id + "_chk").val(currChkYN);
	}
	
	// [Clear] click
	function clearSearchCon() {
		changeClassCode("'"+defItemTypeCode+"'");
		changeItemTypeCode();
		
		for(var i=0; i<$(".dimArea").length;i++){
			if($(".dimArea").eq(i).val() == "Y"){
				$(".dimArea").eq(i).val("N");
				$(".dimArea").eq(i).attr("style", "");
			}
		}
		//doSearchList();
	}
</script>
<form name="dimensionSchFrm" id="dimensionSchFrm" action="" method="post" onsubmit="return false">
	<div style="padding: 10px 10px 10px 10px;">
		<div id="htmlReport" style="width: 100%; overflow: auto; overflow-x: hidden; padding: 0;">
			<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}"/>
			<input type="hidden" id="currPage" name="currPage" value="${pageNum}"/>
			<input type="hidden" id="isComLang" name="isComLang" value="">
			<input type="hidden" id="isSpecial" name="isSpecial" value="">
			<input type="hidden" id="isLov" name="isLov" value="">
			<input type="hidden" id="items" name="items" >
			<input type="hidden" id="classCodes" name="classCodes" >
			<input type="hidden" id="attrIndex" value="0">
			<input type="hidden" id="itemTypeCodeIndex" value="0">
			<input type="hidden" id="beforeCode" value="">
			
			<div class="cop_hdtitle" style="border-bottom: 1px solid #ccc;">
				<ul>
					<li>
						<h3>
							<img src="${root}${HTML_IMG_DIR_ITEM}/img_dim.png">&nbsp;&nbsp;${title}
						</h3>
					</li>
				</ul>
			</div>
			<div id="dictionary_search">
				<div>
				<table class="tbl_blue01 mgT10" style="table-layout: fixed;" width="100%" border="0" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="20%">
						<col width="80%">
					</colgroup>
					<tr>
				    	<th class="alignL pdL10">${menu.LN00021}</th>
			 			<td class="alignL pdL10 last">
			 				<select id="itemTypeCode" name="itemTypeCode[]" multiple="multiple">
								<option value="">Select</option>
							</select>
			 			</td>
			 		</tr>
					<c:forEach var="itemDim" items="${itemDimNameList}"
						varStatus="status">
						<tr>
							<th class="alignL pdL10">${itemDim.DimTypeName}</th>
							<td class="alignL pdL10 last" style="cursor: pointer;">
								<c:forEach var="dimType" items="${dimTypeNameList}" varStatus="status">
									<c:if test="${itemDim.DimTypeID eq dimType.DimTypeID && dimType.Level eq '1' }">
										<span id="${itemDim.DimTypeID}_${dimType.DimValueSelect}_span" class="dimArea" onClick="fnDimLayer('${dimType.DimValueSelect}','${itemDim.DimTypeID}_${dimType.DimValueSelect}_span')">${dimType.DimValueName}</span>
										&nbsp;&nbsp;&nbsp;&nbsp;
			  						</c:if>
								</c:forEach>
							</td>
						</tr>
					</c:forEach>
					<tr id="appendTr" style="display: none;">
						<th class="alignL pdL10" width="20%"></th>
						<td class="alignL pdL10 last" width="80%">
							<div style="width: 100%;" id="appendDiv3" style="display:none;"></div>
						</td>
					</tr>
					<%-- 
			<tr>	
				<th class="alignL pdL10">Search</th> 
				<td class="alignL pdL10 last" style="cursor:pointer;">	
				
				&nbsp;&nbsp;&nbsp;&nbsp;<select id="searchKey" name="searchKey" style="width:150px;">
					<option value="Name">${menu.LN00002}</option>
					<option value="Info" 
						<c:if test="${searchKey == 'Info'}"> selected="selected"</c:if>>
						${menu.LN00003}
					</option>					
				</select>
				
				
				<input type="text" class="stext"  id="searchValue" name="searchValue" value="${searchValue}" style="width:250px;ime-mode:active;">
				&nbsp;<img src="${root}${HTML_IMG_DIR}/btn_icon_search.png" class="searchList" style="cursor:pointer;" >&nbsp;
				</td>
			</tr>
			 --%>
					<tr>
						<!-- 속성 -->
						<th>${menu.LN00031}</th>
						<td colspan="4" class="alignL pdL10 last">
							<select id="AttrCode" Name="AttrCode[]" multiple="multiple" class="SlectBox">
							</select>
							<div id="appendDiv" style="width: 100%;"></div>
<%-- 							&nbsp;<img src="${root}${HTML_IMG_DIR}/btn_icon_search.png" class="searchList" style="cursor:pointer;" >&nbsp; --%>
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
				</div>
				<ul style="text-align: center;">
					<li class="mgT5">
						<input id="" type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" style="cursor:pointer;">
						&nbsp;<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="cursor:pointer;" onclick="clearSearchCon();">
					</li>
				</ul>
			</div>
			<div class="countList pdT5 pdB5 ">
				<li class="count">Total <span id="TOT_CNT"></span>
				<li class="floatR"><span class="btn_pack small icon"><span
						class="down"></span><input value="Down" type="button" id="excel"></span>
				</li>
			</div>

			<div id="gridDiv" style="width: 100%;" class="clear">
				<div id="grdGridArea" style="width: 500px"></div>
			</div>
			<div style="width: 100%;" class="paginate_regular">
				<div id="pagingArea" style="display: inline-block;"></div>
				<div id="recinfoArea" class="floatL pdL10"></div>
			</div>
			<div id="dictionary_footer"></div>

			<!-- <div class="dimension_layer" id="dimPopup">
				<span class="closeBtn"> <span
					style="cursor: pointer; _cursor: hand; position: absolute; right: 10px;"
					OnClick="fnCloseLayer();">Close</span>
				</span> <br>
				<div class="mgT10 mgB10 mgL5 mgR5">
					<table id="level2" class="tbl_blue01 mgT5"
						style="width: 100%; height: 99%; table-layout: fixed;">
					</table>
				</div>

			</div> -->
		</div>

	</div>

</form>


<iframe name="blankFrame" id="blankFrame" src="about:blank"
	style="display: none" frameborder="0" scrolling='no'></iframe>