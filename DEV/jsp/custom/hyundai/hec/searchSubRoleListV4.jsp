<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%-- <link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxToolbar/codebase/skins/dhtmlxtoolbar_dhx_skyblue.css'/>"> --%>
<%-- <link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>"> --%>

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
			//그리드 전역변수
	
	// common 변수
	var s_itemID = `${s_itemID}`;
	var languageID = `${sessionScope.loginInfo.sessionCurrLangType}`;
	var itemTypeCode = `${itemTypeCode}` || 'OJ00002';
	
	$(document).ready(function() {
		// api
		renderTitle(); // 타이틀 셋팅
		
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
		$("#AttrCode").val("${defAttrTypeCode}");
		

		$("#excel").click(function(){ fnGridExcelDownLoad(); });
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
		 
		
		$('#constraint').change(function(){changeConstraint($(this).val(), "");});
		
		$('#searchValue').keypress(function(onkey){
			if(onkey.keyCode == 13){
				$("#searchValueAT00001").val($(this).val());
				doSearchList();
				return false
			;}
		});		


		changeClassCode("CL02003", 'OJ00002'); // 여기서 doSeatchList호출됨 
		

		
		$("#loading").fadeIn(100);
		checkLoadingBar();

	});	
	
	function checkLoadingBar() {
		if($("#TOT_CNT").html() != "") {
			$("#loading").fadeOut(100);
		}		
		else {
			$("#loading").fadeIn(100);
			setTimeout(function() { checkLoadingBar(); },500);
			
		}
	}		
	
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
		html += "<option value=\"\">포함(또는 같음)</option>";
		html += "<option value=\"3\">포함하지 않음(또는 다름)</option>";
		html += "</select>&nbsp;";
		html += "<input type=\"text\" id=\"searchValue"+divClassName+"\" value=\"\" class=\"stext\" style=\"width:250px;height:25px;margin-left:30px;margin-top: -23px;\">";
		html += "<select id=\"AttrLov"+divClassName+"\" name=\"AttrLov[]\" style=\"display:none;width:120px;margin-left:30px;\" multiple=\"multiple\">";
		html += "<option value=\"\">Select</option>	";
		html += "</select><input type=\"hidden\" id=\"isLov"+divClassName+"\" value=\"\">";
		html += "<input type=\"hidden\" id=\"isSelect"+divClassName+"\" value=\""+bfAttr+"\">";
		html += '<div id="asDiv'+divClassName+'" style="height: 25px; margin-left: 30px; display: inline;"></div>';

		if(ari > 0) {		
			var html2 = "";
				html2 += '<select id="selectOption'+divClassName+'" name="selectOption'+divClassName+'" style=\"width:80px; \" >';
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

	
	// [기본정보] 모든 조건 검색 입력
	async function setAllCondition() {
	    const requestData = {
	        languageID: "${sessionScope.loginInfo.sessionCurrLangType}",
	        s_itemID: "${s_itemID}",
	        defaultLang: $("#defaultLang").val(),
	        isComLang: $("#isComLang").val(),
	        pageNum: $("#currPage").val() || "1",
	        ClassCode: "CL02003"
	    };
	
	    // 🔹 childItems 조건 (기존 cnxFlag 분기)
	    if ("${cnxFlag}" !== "Y") {
	    	const childItems = await getChildItems(s_itemID);
			if (childItems) requestData.childItems = childItems;
			else requestData.isNothingLowLank = 'Y';
	    }
	
	    // 🔹 Identifier
	    const detailID = document.querySelector("#detailID")?.value ?? "";
	    if (detailID !== "") {
	        requestData.AttrCodeBase2 = "Identifier";
	
	        const isSpecialEl = document.querySelector("#isSpecial");
	        if (isSpecialEl) isSpecialEl.value = "";
	
	        requestData.baseCondition2 = setSpecialChar(detailID);
	        requestData.baseCon2Escape = isSpecialEl?.value ?? "";
	    }
	
	    // 🔹 수정일
	    const SC_STR_DT2 = document.querySelector("#SC_STR_DT2")?.value ?? "";
	    const SC_END_DT2 = document.querySelector("#SC_END_DT2")?.value ?? "";
	
	    if (SC_STR_DT2 !== "" && SC_END_DT2 !== "") {
	        requestData.LastUpdated = "Y";
	        requestData.scStartDt2 = SC_STR_DT2;
	        requestData.scEndDt2 = SC_END_DT2;
	    }
	
	    // 🔹 AttrCode 조건
	    const AttrCode = document.querySelector("#AttrCode")?.value ?? "";
	    if (AttrCode !== "") {
	
	        const selectedOptions = document.querySelectorAll("#AttrCode option:checked");
	        const attrArray = [];
	
	        selectedOptions.forEach((el, i) => {
	
	            const aval = el.value;
	
	            let lovCode = "";
	            let searchValue = "";
	            let AttrCodeEscape = "";
	            let constraint = "";
	            let selectOption = "";
	
	            // AND / OR
	            if (i > 0) {
	                selectOption = document.querySelector("#selectOption" + aval)?.value ?? "";
	            } else {
	                selectOption = "AND";
	            }
	
	            const constraintVal = document.querySelector("#constraint" + aval)?.value ?? "";
	            const isLovVal = document.querySelector("#isLov" + aval)?.value ?? "";
	            const attrLovVal = document.querySelector("#AttrLov" + aval)?.value ?? "";
	            const searchInputVal = document.querySelector("#searchValue" + aval)?.value ?? "";
	
	            if (constraintVal === "" || constraintVal === "3") {
	
	                if (attrLovVal !== "" || searchInputVal !== "") {
	
	                    if (isLovVal === "Y") {
	                        lovCode = String(attrLovVal).replace(/,/g, "*");
	                    } else {
	                        const isSpecialEl = document.querySelector("#isSpecial");
	                        if (isSpecialEl) isSpecialEl.value = "";
	
	                        searchValue = setSpecialChar(searchInputVal.replace(",", "comma"));
	                        AttrCodeEscape = isSpecialEl?.value ?? "";
	                    }
	                }
	
	                if (constraintVal === "3") {
	                    constraint = "3";
	                }
	
	            } else {
	                constraint = constraintVal;
	            }
	
	            const valueArray = [
	                aval,
	                lovCode,
	                encodeURIComponent(searchValue),
	                AttrCodeEscape,
	                constraint,
	                selectOption
	            ];
	
	            attrArray.push(valueArray);
	        });
	
	        requestData.AttrCodeOLM_MULTI_VALUE = attrArray.join(",");
	    }
	
	    return requestData;
	}

    // api
	/**
    * @function getChildItems
    * @param {String} s_itemID
    * @description itemID를 통해 해당 item의 하위항목을 조회합니다.
    */
	async function getChildItems(s_itemID) {
		const requestData = { s_itemID };
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getChildItems.do?" + params;
	    
	    try {
			const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				throw throwServerError(result.message);
			}
	
			const result = await response.json();
			if (!result.success) {
				throw throwServerError(result.message);
			}
	
			if (result && result.data) {
				return result.data;
			} else {
				return [];
			}
	
		} catch (error) {
			handleAjaxError(error);
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
	
	// [Report] Click
	function goReportList(avg) {
	 	var url = "objectReportList.do?s_itemID="+avg;
		var w = 1000;
		var h = 800;
		openPopup(url,w,h,avg);
	}

	function doDetail(avg){
		var url = "itemMainMgt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID="+avg+"&scrnType=pop&screenMode=pop&itemMainPage=itm/itemInfo/itemMainMgt";
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
		$("#appendDiv").empty();
		$("#detailID").val('');
		$("#SC_STR_DT1").val('');
		$("#SC_END_DT1").val('');
		$("#SC_STR_DT2").val('');
		$("#SC_END_DT2").val('');
		$("#searchValue").val('');

		$("#attrIndex").val("0");
		changeClassCode("", '${ItemTypeCode}');

		$("#Status")[0].sumo.selectItem(0);
		$("#detailClassCode")[0].sumo.selectItem(2);
		$("#detailCompanyId")[0].sumo.selectItem(0);
	}
	
	/**  
	 * [Owner][Attribute] 버튼 이벤트
	 */
	function editCheckedAllItems(avg){ 
        var selectedCell = grid.data.findAll(function (item) {
            return item.checkbox;
        });

        if(!selectedCell.length){
            Promise.all([
                    getDicData("BTN", "LN0034") // 닫기
            ]).then(results => {
                    showDhxAlert('${WM00023}', results[0].LABEL_NM);
            });
            return;
        }

		var itemsArr = [];
		var classCodesArr = [];
		
		selectedCell.forEach(function(item) {
		    itemsArr.push(item.ItemID);
		    
		    // classCode 중복 체크
		    if (!classCodesArr.includes(item.ClassCode)) {
		        classCodesArr.push(item.ClassCode);
		    }
		});
		
		var items = itemsArr.join(",");
		var classCodes = classCodesArr.join(",");

		if (items != "") {
			if (avg == "Attribute") {
				var url = "selectAttributePop.do?";
				var data = "classCodes="+classCodes+"&items="+items; 
			    var option = "dialogWidth:400px; dialogHeight:250px;";			
			   
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


	function fnChangeMenu(menuID,menuName) {
		if(menuID == "management"){
			parent.fnGetMenuUrl("${s_itemID}", "Y");
		}
	}

    /**
     * @function getItemTypeName
     * @description api를 통해 itemTypeName을 조회합니다.
     */
 	async function getItemTypeName() {
    	const sqlID = "common_SQL.getNameFromDic";
 		const requestData = { sqlGridList : 'N' , sqlID , languageID, typeCode : itemTypeCode, category : 'OJ'};
 	    const params = new URLSearchParams(requestData).toString();
 	    const url = "getData.do?" + params;
 	    
 	    try {
 			const response = await fetch(url, { method: 'GET' });
 			
 			if (!response.ok) {
 				throw throwServerError(result.message);
 			}
 	
 			const result = await response.json();
 			if (!result.success) {
 				throw throwServerError(result.message);
 			}
 	
 			if (result && result.data) {
 				return result.data;
 			} else {
 				return '';
 			}
 	
 		} catch (error) {
 			handleAjaxError(error);
 		}
 	}
 	
 	/**
     * @function getSelectedItemPath
     * @description api를 통해 selectedItemPath를 조회합니다.
     */
 	async function getSelectedItemPath() {
    	const sqlID = "item_SQL.getItemPath";
 		const requestData = { sqlGridList : 'N' , sqlID , languageID, s_itemID};
 	    const params = new URLSearchParams(requestData).toString();
 	    const url = "getData.do?" + params;
 	    
 	    try {
 			const response = await fetch(url, { method: 'GET' });
 			
 			if (!response.ok) {
 				throw throwServerError(result.message);
 			}
 	
 			const result = await response.json();
 			if (!result.success) {
 				throw throwServerError(result.message);
 			}
 	
 			if (result && result.data) {
 				return result.data;
 			} else {
 				return '';
 			}
 	
 		} catch (error) {
 			handleAjaxError(error);
 		}
 	}
	
 	/**
     * @function renderTitle
     * @description api를 통해 itemTypeName과 selectedItemPath를 조회 후 타이틀 html 렌더링 합니다.
     */
 	async function renderTitle() {
		const itemTypeName = await getItemTypeName();
		const selectedItemPath = await getSelectedItemPath();
	
		const h3 = document.getElementById("cop_hdtitle_h3");
		const html = `<img src="${root}${HTML_IMG_DIR}/icon_search_title.png">&nbsp;&nbsp;\${itemTypeName || ''} - \${selectedItemPath || ''}`;
		h3.innerHTML = html;
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
	
	<input type="hidden" id="s_itemIDs" name="s_itemIDs" value="" />
	<input type="hidden" id="accMode" name="accMode" value="${accMode}" />
	<input type="hidden" id="URL" name="URL" value="" />
	<input type="hidden" id="outputType" name="outputType" value="" />
	
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc; padding: 6px 0 6px 0; ">
		<h3 id="cop_hdtitle_h3" style="display: inline-block"></h3>
		<c:if test="${sessionScope.loginInfo.sessionAuthLev == 1}" >
			<span class="btn_pack small icon mgR25" style="float: right;"><input value="Standard Menu" type="button" style="padding-left: 2px;" onclick="fnChangeMenu('management','Management');"></span>
		</c:if>
	</div>

	<div id="search" align="center" style="margin-top: 20px;">
		<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:30%;ime-mode:active;">
		<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doNameSearchList()" value="Search" style="cursor:pointer;">
		<input type="image" class="image" onclick="showMultiSearchDiv();" src="${root}${HTML_IMG_DIR}/btn_search_plus.png" value="Advanced Search" style="cursor:pointer;">
	</div>
	<div align="center">
		<table style="table-layout:fixed;display:none;" border="0" cellpadding="0" cellspacing="0" class="tbl_search"  id="mSearch">
		   <colgroup>
		       <col width="5%">
		       <col width="8%">
		       <col width="5%">
		       <col width="16%">
		      </colgroup>
		      <!-- 계층, ID, 상태 -->
		      <tr>
		      <th  class="viewtop">ID</th>
		      <td  class="viewtop"><input type="text" id="detailID" name="detailID" value="" class="stext"></td>

		       <th class="viewtop">${menu.LN00070}</th> 
		       <td class="viewtop last">
		        <input type="text" id="SC_STR_DT2" name="SC_STR_DT2" value="" class="input_off datePicker stext" size="8"
		      style="width: 42%;" onchange="this.value = makeDateType(this.value);" maxlength="10">
		     
		      ~
		     <input type="text" id=SC_END_DT2 name="SC_END_DT2" value="" class="input_off datePicker stext" size="8"
		      style="width: 42%;" onchange="this.value = makeDateType(this.value);" maxlength="10">
		     
		       </td> 
		      </tr>
		      
		      <!-- 속성, Dimension -->
		      <tr>
		       <!-- 속성 -->
		       <th>${menu.LN00031}</th>
		       <td colspan="3" class="alignL">
		     <select id="AttrCode" Name="AttrCode[]" multiple="multiple" class="SlectBox" >
		     </select>
		     
		     <div id="appendDiv"></div>
		    </td>
		      </tr>
		  </table>
	
		<li id="buttonGroup" class="floatC mgR20 mgT5" style="display:none;">
			<input id="btnSearch" type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" style="cursor:pointer;">
			&nbsp;<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="cursor:pointer;" onclick="clearSearchCon();">
			<input type="image" class="image" onclick="showMultiSearchDiv();" src="${root}${HTML_IMG_DIR}/btn_search_plus.png" value="Advanced Search" style="cursor:pointer;">
		</li>
		
	   <div class="countList pdT10">
	        <li class="count"><input type="image" id="frame_sh" class="frame_show" alt="${WM00158}" src="${root}${HTML_IMG_DIR}/btn_frame_show.png" value="Clear" style="cursor:pointer;width:20px;height:15px;margin-right:5px;" onclick="fnHideSearch();">Total  <span id="TOT_CNT"></span></li>
	        <li class="floatR"> 
				&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
				&nbsp;&nbsp;&nbsp;&nbsp;
	        </li>
	   </div>
	</div>		
	</form>
	
	<div id="gridDiv" class="mgB10 clear" align="center">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<div id="pagination"></div>
	
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
</div>

<script>
/* ========================grid  api 방식 호출====================================   */
async function getSearchSubRoleList() {
    $('#loading').fadeIn(150);
    
    // 1. 기본 파라미터 구성
    const requestData = await setAllCondition();
    
    const url = "zhec_getItemListInfo.do";
    
    try {
      	const response = await fetch(url, { 
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: new URLSearchParams(requestData).toString()
        });
		if (!response.ok) { throw throwServerError(result.message); }

		const result = await response.json();
		if (!result.success) { throw throwServerError(result.message); }

		if (result && result.data) {
			fnReloadGrid(grid,result.data);
		} else {
			return [];
		}
        
    } catch (error) {
    	handleAjaxError(error, "LN0014");
    } finally {
    	$('#loading').fadeOut(150);
    }
}

function handleAjaxError(err, errDicTypeCode) {
	console.error("handleAjaxError err :"+err);
	Promise.all([getDicData("ERRTP", errDicTypeCode), getDicData("BTN", "LN0034")])
			.then(([errDic, btnDic]) => showDhxAlert(errDic.LABEL_NM, btnDic.LABEL_NM));
}

function fnReloadGrid(targetGrid, newGridData) {
    targetGrid.data.removeAll(); 
    targetGrid.data.parse(newGridData); 
    
    $("#TOT_CNT").html(targetGrid.data.getLength());
}

//========================================== [ Grid 설정] ============================================== //
var layout;
var grid; 
var pagination;

layout = new dhx.Layout("grdGridArea", {
    rows: [{ id: "a" }]
});

grid = new dhx.Grid(null, {
    columns: [
        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}", align: "center" }], align: "center" },
        { width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(event, this.checked)'>", align: "center" }], align: "center", type: "boolean", editable: true, sortable: false },
        { width: 90, id: "ClassName", header: [{ text: "클래스", align: "center" }], htmlEnable: true, align: "center",
           template: function (text, row) {
               return row.ItemTypeImg ? '<img src="${root}${HTML_IMG_DIR_ITEM}/' + row.ItemTypeImg + '" width="18" height="18">' : "";
           }
        },
        { width: 100, id: "Identifier", header: [{ text: "No.", align: "center" }, { content: "inputFilter" }], align: "center" },
        { width: 400, id: "ItemName", header: [{ text: "명칭", align: "center" }, { content: "inputFilter" }], align: "left" },
        { hidden: true, id: "L1Name", header: [{ text: "기능", align: "center" }, { content: "selectFilter" }], align: "center" },
        { hidden: true, id: "L2Name", header: [{ text: "대분류", align: "center" }, { content: "selectFilter" }], align: "center" },
        { hidden: true, id: "L3Name", header: [{ text: "중분류", align: "center" }, { content: "selectFilter" }], align: "center" },
        { hidden: true, id: "L4Name", header: [{ text: "소분류", align: "center" }, { content: "selectFilter" }], align: "center" },
        { hidden: true, id: "Path", header: [{ text: "분류체계", align: "center" }, { content: "inputFilter" }], align: "left" },
        { hidden: true, id: "OwnerTeamName", header: [{ text: "${menu.LN00018}", align: "center" }, { content: "selectFilter" }], align: "center" },
        { hidden: true, id: "Name", header: [{ text: "작성자", align: "center" }, { content: "inputFilter" }], align: "center" },
        { hidden: true, id: "CSVersion", header: [{ text: "개정번호", align: "center" }], align: "center" },
        { hidden: true, id: "ValidFrom", header: [{ text: "개정일", align: "center" }], align: "center" },
        { hidden: true, id: "Report", header: [{ text: "Report", align: "center" }], align: "center", htmlEnable: true },
        { hidden: true, id: "ItemID", header: [{ text: "ItemID" }] },
        { hidden: true, id: "ClassCode", header: [{ text: "ClassCode" }] },
        { flex: 1, id: "ProcessInfo", header: [{ text: "정의", align: "center" }, { content: "inputFilter" }], align: "left" },
        { width: 80, id: "Comment", header: [{ text: "비고", align: "center" }, { content: "inputFilter" }], align: "center" }
    ],
    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    editable: true
});

layout.getCell("a").attach(grid);

pagination = new dhx.Pagination("pagination", {
    data: grid.data,
    pageSize: 100,
});

grid.events.on("cellClick", function(row, column, e) {
    const rowId = row.id;
    const colId = column.id;

    if (colId === "checkbox") return;
    else {
        if (row.ItemID) {
            doDetail(row.ItemID);
        }
    }
});

/* 검색시  */
async function doSearchList() {
    $("#currPage").val("1");
    await getSearchSubRoleList();
}
</script>