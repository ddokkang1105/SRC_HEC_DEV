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
.dhx_grid-row  {
    cursor: pointer;
}
</style>

<!-- 2. Script -->
<script type="text/javascript">
	var languageID = `${sessionScope.loginInfo.sessionCurrLangType}`;
	var s_itemID = `${s_itemID}`;
	var itemTypeCode = `${defItemTypeCode}`;
	var sessionUserId = `${sessionScope.loginInfo.sessionUserId}`;

	$(document).ready(function() {
		
		// api
		renderTitle(); // 타이틀 셋팅
		
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
		 
		// [속성] option 설정
		changeClassCode("", '${defItemTypeCode}');
		
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
	
	// [기본정보] 모든 조건 검색 입력 - UPDATE
	async function setAllCondition() {
		
		const requestData = {
	        languageID,
	        s_itemID,
	        defaultLang: $("#defaultLang").val() || languageID,
	        isComLang: $("#isComLang").val(),
	        pageNum: $("#currPage").val() || "1"
	    };
		
		// search childItem option
		if("${cnxFlag}" !== "Y") {
			const childItems = await getChildItems(s_itemID);
			if (childItems) requestData.childItems = childItems;
			else requestData.isNothingLowLank = 'Y';
		}
		
		// [기본] 검색 조건
		
		// Identifier 
		const detailID = document.getElementById("detailID").value;
		if (detailID !== "") {
			requestData.AttrCodeBase2 = "Identifier";
			document.getElementById("isSpecial").value = "";
			requestData.baseCondition2 = setSpecialChar(detailID);
			requestData.baseCon2Escape = document.getElementById("isSpecial").value;
		}
		
		// 계층
		const detailClassCode = document.getElementById("detailClassCode").value;
		if (detailClassCode !== "") requestData.ClassCode = detailClassCode;
		
		// 법인
		const detailCompanyId = document.getElementById("detailCompanyId").value;
		if (detailCompanyId !== "") requestData.CompanyID = detailCompanyId;
		
		
		// 관리조직
		const detailOwnerTeam = document.getElementById("detailOwnerTeam").value;
		if (detailOwnerTeam !== "") {
			document.getElementById("isSpecial").value = "";
			requestData.OwnerTeam = setSpecialChar(detailOwnerTeam);
			requestData.ownerTeamEscape = document.getElementById("isSpecial").value;
		}
		
		// 담당자
		const detailAuthor = document.getElementById("detailAuthor").value;
		if (detailAuthor !== "") {
			document.getElementById("isSpecial").value = "";
			requestData.Name = setSpecialChar(detailAuthor);
			requestData.nameEscape = document.getElementById("isSpecial").value;
		}
		
		// 생성일
		const SC_STR_DT1 = document.getElementById("SC_STR_DT1").value;
		const SC_END_DT1 = document.getElementById("SC_END_DT1").value;
		if (SC_STR_DT1 !== "" && SC_END_DT1 !== "") {
			requestData.CreationTime = 'Y';
			requestData.scStartDt1 = SC_STR_DT1;
			requestData.scEndDt1 = SC_END_DT1;
		}
		
		// 수정일
		const SC_STR_DT2 = document.getElementById("SC_STR_DT2").value;
		const SC_END_DT2 = document.getElementById("SC_END_DT2").value;
		if (SC_STR_DT2 !== "" && SC_END_DT2 !== "") {
			requestData.LastUpdated = 'Y';
			requestData.scStartDt2 = SC_STR_DT2;
			requestData.scEndDt2 = SC_END_DT2;
		}
		
		// 상태 
		const status = document.getElementById("Status").value;
		if (status !== "") requestData.Status = status;

		// Attribute multi search
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

			    if (i > 0) {
			        selectOption = document.querySelector("#selectOption" + aval)?.value ?? "";
			    } else if (i === 0) {
			        selectOption = "AND";
			    }

			    const constraintVal = document.querySelector("#constraint" + aval)?.value ?? "";
			    const isLovVal = document.querySelector("#isLov" + aval)?.value ?? "";
			    const attrLovVal = document.querySelector("#AttrLov" + aval)?.value ?? "";
			    const searchInputVal = document.querySelector("#searchValue" + aval)?.value ?? "";
				
			    /* [속성] 조건 선택, 입력값 */
			    if (constraintVal === "" || constraintVal === "3") {
			        if (attrLovVal !== "" || searchInputVal !== "") {
			            if (isLovVal === "Y") {
			                // ,를 *로 치환
			                lovCode = String(attrLovVal).replace(/,/g, "*");
			            } else {
			                // 특수문자 처리 및 Escape 값 저장
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

		/* [Dimension] 조건 선택값 */
		let nothingDim = ""; 
		const dimTypeId = document.querySelector("#dimTypeId")?.value ?? "";
		
		if (dimTypeId !== "") {
		    const dvArray = [];
		    const selectedDimValues = document.querySelectorAll("#dimValueId option:checked");
		
		    selectedDimValues.forEach((el) => {
		        const dvTemp = el.value;
		        
		        if (dvTemp !== "" && dvTemp.toLowerCase() !== "nothing") {
		            dvArray.push(dvTemp);
		            nothingDim = "";
		        } else if (dvTemp.toLowerCase() === "nothing") {
		        	nothingDim = "Y";
		        }
		    });
		
		    // requestData에 데이터 할당
		    requestData.DimTypeID = dimTypeId;
		    requestData.isNotIn = "N";
		    requestData.DimValueIDOLM_ARRAY_VALUE = dvArray.join(",");
		    requestData.nothingDim = nothingDim;
		}
		
		return requestData;
	}

	// UPDATE
	async function doSearchList() {
		// 1. 검색 실행 시 현재 페이지를 1로 초기화 
        $("#currPage").val("1");

        const success = await getSearchList();
		
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

	function goReportList(avg) {
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
	 * [Owner][Attribute] 버튼 이벤트 - UPDATE
	 */
	function editCheckedAllItems(avg){ 
		const selectedRows = grid.data.findAll(item => item.checkbox);
		if(selectedRows.length == 0){
			alert("${WM00023}");
			return;
		}

		var items = "";
		var classCodes = "";
		var nowClassCode = "";
		
		selectedRows.forEach(row => {
			if (items == "") {
				items = row.ItemID;
				classCodes = row.ClassCode;
				nowClassCode = row.ClassCode;
			} else {
				items = items + "," + row.ItemID;
				if (nowClassCode != row.ClassCode) {
					classCodes = classCodes + "," + row.ClassCode;
					nowClassCode = row.ClassCode;
				}
			}
		});

		if (items != "") {
			if (avg == "Attribute") {
				var url = "selectAttributePop.do?";
				var data = "classCodes="+classCodes+"&items="+items; 
			    var w = "400", h = "250";
				document.getElementById("items").value = items;
				document.getElementById("classCodes").value = classCodes;
			    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes"); 
			} else if(avg == "Owner") {
				var url = "selectOwnerPop.do?";
				var data = "items="+items; 
			    var w = "400", h = "370";
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
	
	async function loadSelectBox() {
		const requestData = { languageID, sqlGridList: 'N', sqlID: 'dim_SQL.getDimTypeList' };
		
		await loadSelectOption('detailClassCode', requestData, 'DimTypeID', 'DimTypeName');
		await loadSelectOption('detailCompanyId', requestData, 'DimTypeID', 'DimTypeName');
		await loadSelectOption('dimTypeId', requestData, 'DimTypeID', 'DimTypeName');
		await loadSelectOption('Status', requestData, 'DimTypeID', 'DimTypeName');
		
		$('#detailClassCode')[0].sumo.reload();
		$('#detailCompanyId')[0].sumo.reload();
		$('#dimTypeId')[0].sumo.reload();
		$('#Status')[0].sumo.reload();
	}

	// 해당 아이템 하위의 classcode리스트를 설정
	async function loadSelectOption(id, requestData, codeKey, nameKey) {
		
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getData.do?" + params;
	    
	    try {
			const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message);
			}
	
			const result = await response.json();
			// success 필드 체크
			if (!result.success) {
				throw throwServerError(result.message);
			}
	
			if (result && result.data) {
				await makeSelectOption(id, result.data, codeKey, nameKey);
			} else {
				return [];
			}
	
		} catch (error) {
			handleAjaxError(error);
		}
	}
	
	//[select option 공통]
	async function makeSelectOption(id, data, codeKey = 'CODE', nameKey = 'NAME'){
		const selectElement = document.getElementById(id);
	    selectElement.innerHTML = '<option value="">Select</option>';
	    
	    if (!data) return;
	    
	    data.forEach(item => {
	        const option = document.createElement('option');
	        option.value = item[codeKey];
	        option.textContent = item[nameKey];  
	        selectElement.appendChild(option);
	    });
	}
	
	//===============================================================================
	// BEGIN ::: GRID
	var layout;
	var grid; 
	var pagination;

	function gridInit(){		
		layout = new dhx.Layout("grdGridArea", {
			rows: [{ id: "a" }]
		});

		grid = new dhx.Grid(null, {
			columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}", align: "center" }], align: "center" },
				{ 
					width: 50, id: "checkbox", 
					header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(event, this.checked)'>", align: "center" }], 
					align: "center", type: "boolean", editable: true, sortable: false 
				},
				{ width: 90, id: "ItemTypeName", header: [{ text: "표준구분", align: "center" }], align: "center" },
				{ width: 90, id: "Identifier", header: [{ text: "No.", align: "center" }], align: "center" },
				{ flex: 1, id: "ItemName", header: [{ text: "명칭", align: "center" }], align: "left" },
				{ hidden: true, id: "L1Name", header: [{ text: "대분류" }] },
				{ hidden: true, id: "L2Name", header: [{ text: "중분류" }] },
				{ hidden: true, id: "L3Name", header: [{ text: "소분류" }] },
				{ hidden: true, id: "L4Name", header: [{ text: "분류체계" }] },
				{ width: 120, id: "OwnerTeamName", header: [{ text: "${menu.LN00018}", align: "center" }], align: "center" },
				{ width: 80, id: "Name", header: [{ text: "작성자", align: "center" }], align: "center" },
				{ width: 60, id: "CSVersion", header: [{ text: "개정번호", align: "center" }], align: "center" },
				{ width: 90, id: "ValidFrom", header: [{ text: "개정일", align: "center" }], align: "center" },
				{ 
					width: 60, id: "Report", header: [{ text: "Report", align: "center" }], align: "center",
					template: function() { return '<img src="${root}${HTML_IMG_DIR}/icon_report.png" style="cursor:pointer;">'; },
					htmlEnable: true
				},
				{ hidden: true, id: "ItemID", header: [{ text: "ItemID" }] },
				{ hidden: true, id: "ClassCode", header: [{ text: "ClassCode" }] }
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
			pageSize: 40,
		});

		grid.events.on("cellClick", function(row, column, e) {
			const colId = column.id;
			if (colId === "checkbox") return;

			if (colId === "Report") {
				goReportList(row.ItemID);
			} else {
				if (row.ItemID) {
					doDetail(row.ItemID);
				}
			}
		});
	}
	
	async function getSearchList() {
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
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message);
			}

			const result = await response.json();
			// success 필드 체크
			if (!result.success) {
				throw throwServerError(result.message);
			}

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


	// 그리드 갱신 공통 함수
	function fnReloadGrid(targetGrid, newGridData) {
	    targetGrid.data.removeAll(); // 기존 데이터 클리어
	    targetGrid.data.parse(newGridData); // 신규 데이터 로드
	    
	    $("#TOT_CNT").html(targetGrid.data.getLength());
	    
		window.event = { stopPropagation: function(){} };
		fnMasterChk(false);
	}
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
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message);
			}
	
			const result = await response.json();
			// success 필드 체크
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
 				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
 				throw throwServerError(result.message);
 			}
 	
 			const result = await response.json();
 			// success 필드 체크
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
 				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
 				throw throwServerError(result.message);
 			}
 	
 			const result = await response.json();
 			// success 필드 체크
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
	<input type="hidden" id="currPage" name="currPage" value="${currPage}">
	<input type="hidden" id="isLov" name="isLov" value="">
	<input type="hidden" id="defaultLang" name="defaultLang" value="${defaultLang}">
	<input type="hidden" id="isComLang" name="isComLang" value="">
	<input type="hidden" id="isSpecial" name="isSpecial" value="">
	
	<input type="hidden" id="items" name="items" >
	<input type="hidden" id="classCodes" name="classCodes" >
	<input type="hidden" id="attrIndex" value="0">
	<input type="hidden" id="beforeCode" value="">
	<input type="hidden" id="multiSearch" value="N">
	<input type="hidden" id="searchValueAT00001" value="">
	
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc;">
		<h3 style="padding: 6px 0 6px 0" id="cop_hdtitle_h3"></h3>
	</div>

	<div id="search" align="center" style="margin-top: 20px;">
		<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:30%;ime-mode:active;">
		<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doNameSearchList()" value="Search" style="cursor:pointer;">
		<input type="image" class="image" onclick="showMultiSearchDiv();" src="${root}${HTML_IMG_DIR}/btn_search_plus.png" value="Advanced Search" style="cursor:pointer;">
	</div>
	<div align="center">
		<table style="table-layout:fixed; display:none;" border="0" cellpadding="0" cellspacing="0" class="tbl_search"  id="mSearch">
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
					</select>
	 			</td>
	  			<th  class="viewtop">ID</th>
	  			<td colspan="2"   class="viewtop"><input type="text" id="detailID" name="detailID" value="" class="stext" style="width:150px"></td>
	  			<!-- [상태] -->
	            <th  class="viewtop">${menu.LN00027}</th>
	            <td class="alignL last viewtop">
	            	<select id="Status" name="Status" style="width:150px;">
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
					</select>
					<select id="dimValueId" name="dimValueId[]" style="width:120px;height:16px;" multiple="multiple">
						<option value="">Select</option>
					</select>
			    </td>	
		    	<th>${menu.LN00013}</th>	
		    	<td colspan="2">
	   				<input type="text" id="SC_STR_DT1" name="SC_STR_DT1" value=""	class="input_off datePicker stext" size="8"
						style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
						~
					<input type="text" id=SC_END_DT1	name="SC_END_DT1" value="" class="input_off datePicker stext" size="8"
						style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
	   			</td>
	   			<th>${menu.LN00070}</th>	
	   			<td class="last">
	   				<input type="text" id="SC_STR_DT2" name="SC_STR_DT2" value=""	class="input_off datePicker stext" size="8"
						style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
						~
					<input type="text" id=SC_END_DT2	name="SC_END_DT2" value="" class="input_off datePicker stext" size="8"
						style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
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
	
	<li id="buttonGroup" class="floatC mgR20 mgT5" style="display:none;">
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
	<div id="pagination"></div>
	<!-- END :: PAGING -->
	
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
	</div>	
</body>
</html>