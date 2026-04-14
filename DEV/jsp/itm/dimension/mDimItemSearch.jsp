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

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
	var defItemTypeCode = "${defItemTypeCode}";
	$(document).ready(
		function() {
			// 초기 표시 화면 크기 조정 
			$("#layout").attr("style", "height:" + (setWindowHeight() - 490) + "px;");
			// 화면 크기 조정
			window.onresize = function() {
				$("#layout").attr("style", "height:" + (setWindowHeight() - 490) + "px;");
			};

			
			$("#itemTypeCodefilter").change(function() {
				grid.data.filter(e => {
			        return $(this).val() ? e.itemTypeCode == $(this).val() : e
				});
			});
			
			$("#excel").click(function(){ fnGridExcelDownLoad(grid); });

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
			alert("Maximum 4 items can be selected.");
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
	
	function aa(){
		var itemTypeOption = "<option value=''>select</option>";
		$("#itemTypeCode :selected").each(function(i, el){ 
			itemTypeOption += "<option value='"+$(el).val()+"'>"+$(el).text()+"</option>";	
			
		});
		$("#itemTypeCodefilter").html(itemTypeOption);
		$("#filter").css("display","block");
	}

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
		<div id="htmlReport" style="width: 100%; height:100%; overflow: auto; overflow-x: hidden; padding: 0;">
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
			
			<div class="cop_hdtitle">
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

					<tr>
						<!-- 속성 -->
						<th>${menu.LN00031}</th>
						<td colspan="4" class="alignL pdL10 last">
							<select id="AttrCode" Name="AttrCode[]" multiple="multiple" class="SlectBox">
							</select>
							<div id="appendDiv" style="width: 100%;"></div>
						</td>
				
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
				<ul>
					<li class="count">Total <span id="TOT_CNT"></span></li>
					<li class="mgL40 floatL" id="filter" style="display:none;">${menu.LN00021}&nbsp;&nbsp; <select id="itemTypeCodefilter"></select></li>
					<li class="floatR"><span class="btn_pack small icon">
						<span class="down"></span><input value="Down" type="button" id="excel"></span>
					</li>
				</ul>
			</div>

			<div id="layout" style="width: 100%;"></div>
			<div id="pagination"></div>
			<div id="dictionary_footer"></div>
		</div>

	</div>

</form>


<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
<script>
	doSearchList();

	var pagination;
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
		
	var grid = new dhx.Grid("grid",  {
		columns: [
	        { width: 50, id: "ItemTypeImg", header: [{ text: "${menu.LN00042}", align:"center" }], align: "center", htmlEnable: true,
	        	template: (value, row, col) => {
	                return "<img src='${root}${HTML_IMG_DIR_ITEM}/"+value+"'>";
            	}
        	},
	        { width: 150, id: "classCodeName", header: [{ text: "${menu.LN00016}", align:"center" }, { content: "selectFilter" }], align:"center"},
	        { width: 170, id: "Identifier", header: [{text: "${menu.LN00106}", align:"center"}, { content: "inputFilter" }], align: "center"},
	        { width: 250, id: "ItemName", header: [{ text: "${menu.LN00028}", align:"center" }, { content: "inputFilter" }]},
	        { id: "ItemPath", header: [{ text: "${menu.LN00043}", align:"center" }, { content: "inputFilter" }]},
	        { width: 120, id: "teamName", header: [{ text: "${menu.LN00018}", align:"center" }, { content: "inputFilter" }], align:"center"},
	        { width: 120, id: "authorName", header: [{ text: "${menu.LN00004}", align:"center" }, { content: "inputFilter" }], align:"center"},
	        { width: 100, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align:"center" }, { content: "inputFilter" }], align:"center"},
	        { width: 100, id: "statusName", header: [{ text: "${menu.LN00027}", align:"center" }, { content: "selectFilter" }], align:"center", htmlEnable: true},
	        { width: 50, id: "fileIcon", header: [{ text: "File", align:"center" }], align: "center", htmlEnable: true,
	        	template: (value, row, col) => {
	                return "<img src='${root}${HTML_IMG_DIR_ITEM}/"+value+"'>";
            	}
        	},
	        { hidden: true, id: "itemTypeCode", header: [{ text: "${menu.LN00021}", align:"center" }], align:"center"},
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false
	});
	
	 layout.getCell("a").attach(grid);
	 
	 if(pagination){pagination.destructor();}
	 pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});
	
	grid.events.on("cellClick", function(row,column,e){
		if(column.id == "fileIcon") {
			var fileCheck = row.fileIcon;
			if(fileCheck.indexOf("blank.gif") < 1) {
				var url = "selectFilePop.do";
				var data = "?s_itemID="+row.ItemID;
			   
			    var w = "400";
				var h = "350";
			    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");	
			}
		} else {
			doDetail(row.ItemID);
		}
	});
	
 	function doSearchList(){
 		var dimData = fnGetDimValueCheckBox();
		var sqlID = "dim_SQL.getDimSearchList";
		var param =  "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&searchKey="+ $("#searchKey").val()
			+ "&searchValue="+ $("#searchValue").val() 
			+ dimData
			+ "&sqlID="+sqlID;
		
		if($("#itemTypeCode").val() != '' & $("#itemTypeCode").val() != null){
			var itemTypeCodeData = "";
			$("#itemTypeCode :selected").each(function(i, el){ 
				var aval = "'"+$(el).val()+"'";
				itemTypeCodeData += aval;
				if(($("#itemTypeCode :selected").length -1) != i){
					itemTypeCodeData += ",";
				}
			});
			param += "&itemTypeCodes=" + itemTypeCodeData;
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
							//param = param+ "&lovCode=" + $("#AttrLov"+aval).val();
						} else {
							$("#isSpecial").val("");
							searchValue = setSpecialChar($("#searchValue"+aval).val());
							AttrCodeEscape = $("#isSpecial").val();
							//param = param+ "&searchValue=" + setSpecialChar($("#searchValue"+aval).val());
							//param = param+ "&AttrCodeEscape=" + $("#isSpecial"+aval).val();
						}
					}
					if($("#constraint"+aval).val() == "3")
						constraint = $("#constraint"+aval).val();
						//param = param+ "&constraint"+aval+"=" + $("#constraint"+aval).val();
					
				} else {
					constraint = $("#constraint"+aval).val();
					//param = param+ "&constraint"+aval+"=" + $("#constraint"+aval).val();
				}
				
				valueArray.push($(el).val());
				valueArray.push(lovCode);
				valueArray.push(searchValue);
				valueArray.push(AttrCodeEscape);
				valueArray.push(constraint);
				valueArray.push(selectOption);
				
				attrArray.push(valueArray);
			});
			param += "&AttrCodeOLM_MULTI_VALUE=" + attrArray;
		}
		
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadGrid(result);
				aa();
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
 	}
 	
 	function fnReloadGrid(newGridData){
 		grid.data.parse(newGridData);
 		$("#TOT_CNT").html(grid.data.getLength());
 	}
</script>