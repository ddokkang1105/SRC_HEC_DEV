﻿<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%-- <link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxToolbar/codebase/skins/dhtmlxtoolbar_dhx_skyblue.css'/>">
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>"> --%>

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
		
		$("#detailOwnerTeam").val("${defOwnerTeamID}");
		$("#detailAuthor").val("${defAuthorID}");
		$("#AttrCode").val("${defAttrTypeCode}");
		
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
		   
		  changeClassCode("CL05003", 'OJ00005');
		  
		  $('#constraint').change(function(){changeConstraint($(this).val(), "");});
		  
		  $('#searchValue').keypress(function(onkey){
		   if(onkey.keyCode == 13){
		    $("#searchValueAT00001").val($(this).val());
		    doSearchList();
		    return false
		   ;}
		  });  
		  

		getSearchSOPList();
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

		html += "<div style=\"text-align: right; line-height: 25px; float:left;\" ><b>"+text+"</b></div>";	
			
		html += "<select id=\"constraint"+divClassName+"\" name=\"constraint[]\" class=\"SlectBox\" style=\"width:150px;margin-left:20px;\" onChange=\"changeConstraint($(this).val(),'"+divClassName+"')\" >";
		html += "<option value=\"\">포함(또는 같음)</option>";
		html += "<option value=\"3\">포함하지 않음(또는 다름)</option>";
		html += "</select>&nbsp;";
		html += "<input type=\"text\" id=\"searchValue"+divClassName+"\" value=\"\" class=\"stext\" style=\"width:20%;height:23px;margin-left:10px;\">";
		html += "<select id=\"AttrLov"+divClassName+"\" name=\"AttrLov[]\" style=\"display:none;width:120px;margin-left:20px;\" multiple=\"multiple\">";
		html += "<option value=\"\">Select</option>	";
		html += "</select><input type=\"hidden\" id=\"isLov"+divClassName+"\" value=\"\">";
		html += "<input type=\"hidden\" id=\"isSelect"+divClassName+"\" value=\""+bfAttr+"\">";
		html += '<div id="asDiv'+divClassName+'" style="height: 25px; margin-left: 10px; display: inline;"></div>';

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
	  if ($("#SC_STR_DT2").val() != "" && $("#SC_END_DT2").val() != "" ) { // 수정일
	   condition = condition+ "&LastUpdated=Y";
	   condition = condition+ "&scStartDt2=" + $("#SC_STR_DT2").val();
	   condition = condition+ "&scEndDt2=" + $("#SC_END_DT2").val();
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
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&id="+avg+"&scrnType=pop&screenMode=pop&accMode=${accMode}";

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
			$("#searchValue"+attrCode).attr('style', 'display:none;width: 20%; height: 23px; margin-left: 10px;');	
			
			var url    = "getAttrLovSelectOption.do"; // 요청이 날라가는 주소
			var data   = "languageID="+languageID+"&attrCode="+attrCode; //파라미터들
			var target = "AttrLov"+attrCode;            // selectBox id
			var defaultValue = "";              // 초기에 세팅되고자 하는 값
			var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
			ajaxMultiSelect(url, data, target, defaultValue, isAll);
			setTimeout("setAttrLovMulti('"+attrCode+"')",500);
		} else {
			$("#isLov"+attrCode).val("");
			$("#searchValue"+attrCode).attr('style', 'width: 20%; height: 23px; margin-left: 10px; display: inline; ');
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
				$("#searchValue"+avg2).attr('style', 'display:none;width: 20%; height: 23px; margin-left: 10px; ');
				$("#ssAttrLov"+avg2).attr('style', 'width:235px;margin-left:30px;');
			} else {
				$("#searchValue"+avg2).attr('style', 'display:inline;width: 20%; height: 23px; margin-left: 10px;');
				$("#ssAttrLov"+avg2).attr('style', 'display:none;width:120px;margin-left:30px;');
			}
		} else {
			$("#searchValue"+avg2).val("");
			$("#searchValue"+avg2).attr('style', 'display:none;width: 20%; height: 23px; margin-left: 10px;');
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
		$("#detailClassCode")[0].sumo.selectItem(0);
	
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
		var SeqLevel = "";
		var AuthorID = "";
		
		for(var i = 0 ; i < checkedRows.length; i++ ){			
			// 이동 할 ITEMID의 문자열을 셋팅
			if (items == "") {
				items = p_gridArea.cells(checkedRows[i], 13).getValue();
				classCodes = p_gridArea.cells(checkedRows[i], 14).getValue();
				nowClassCode = p_gridArea.cells(checkedRows[i], 14).getValue();
				SeqLevel = p_gridArea.cells(checkedRows[i], 15).getValue();
				AuthorID = p_gridArea.cells(checkedRows[i], 16).getValue();
			} else {
				items = items + "," + p_gridArea.cells(checkedRows[i], 13).getValue();
				SeqLevel = SeqLevel + "," + p_gridArea.cells(checkedRows[i], 15).getValue();
				AuthorID = AuthorID + "," + p_gridArea.cells(checkedRows[i], 16).getValue();
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
			} else if(avg == "Subscribe") {
				if(confirm("Do you really subscibe this item?")){
					var url = "saveRoleAssignment.do";
					var data = "itemID="+items+"&assignmentType=SUBSCR&accessRight=R&assigned=1&memberID=${sessionScope.loginInfo.sessionUserId}&seq=";
					var target = "blankFrame";
					ajaxPage(url, data, target);
				}
			} else if(avg == "Report"){
				var item = "";
				var items = items.split(",");
				var SeqLevel = SeqLevel.split(",");
				var AuthorID = AuthorID.split(",");
				for(var j=0; j<items.length; j++){
					if(SeqLevel[j] > 1){
						alert("보안등급으로 인해 리포트를 실행할 수 없습니다.");
					} else if (SeqLevel[j] == 1){
						if(AuthorID[j] == "${sessionScope.loginInfo.sessionUserId}") {
							if (item == "") item += items[j];
							else item += ","+items[j];
						}
					} else {
						if (item == "") item += items[j];
						else item += ","+items[j];
					}
				}
				$("#s_itemIDs").val(item);
				if(item != ""){
					var url = "subItemInfoReport.do?";
					var data = "itemInfoRptUrl=${itemInfoRptUrl}";
					window.open(url+data, "", "width=420, height=200,top=100,left=100,toolbar=no,status=no,resizable=yes");
					return false;
				}
			}
		}
		 
	}
	
	function subItemInfoRpt(URL, classCodeList, outputType) {
		$('#fileDownLoading').removeClass('file_down_off');
		$('#fileDownLoading').addClass('file_down_on');
		timer = setTimeout(function() {checkDocDownCom();}, 1000);
		var url = "subItemInfoReportEXE.do";	
		$('#URL').val(URL);
		$('#outputType').val(outputType);
		ajaxSubmitNoAdd(document.processList, url, "blankFrame");
	}
	
	function checkDocDownCom(){
		$.ajax({
			url: "checkDocDownComplete.do",
			type: 'post',
			data: "",
			error: function(xhr, status, error) { 
			},
			success: function(data){
				data = data.replace("<script>","").replace(";<\/script>","");
			
				if(data == "Y") {
					afterWordReport();
					clearTimeout(timer);
				}
				else {
					clearTimeout(timer);				
					timer = setTimeout(function() {checkDocDownCom();}, 1000);
				}
			}
		});	
	}
	
	function urlReload(){
		//gridInit();
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
	
	function fnItemMenuReload(){
		urlReload();
	}
	
	function fnChangeMenu(menuID,menuName) {
		if(menuID == "management"){
			parent.fnGetMenuUrl("${s_itemID}", "Y");
		}
	}
</script>
</head>
<body>
<div class="pdL10 pdR10">
<div id="fileDownLoading" class="file_down_off">
	<img src="${root}${HTML_IMG_DIR}/img_circle.gif"/>
</div>
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
		<h3 style="display: inline-block"><img src="${root}${HTML_IMG_DIR}/icon_search_title.png">&nbsp;&nbsp;${itemTypeName} - ${selectedItemPath}</h3>
		<c:if test="${sessionScope.loginInfo.sessionAuthLev == 1}" >
			<span class="btn_pack small icon mgR25" style="float: right;"><input value="Standard Menu" type="button" style="padding-left: 2px;" onclick="fnChangeMenu('management','Management');"></span>
		</c:if>
	</div>

	<div id="search" align="center" style="margin-top: 20px;">
		<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:30%;ime-mode:active;">
		<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doNameSearchList()" value="Search" style="cursor:pointer;">
		<input type="image" class="image" onclick="showMultiSearchDiv();" src="${root}${HTML_IMG_DIR}/btn_search_plus.png" value="Conditional Search" style="cursor:pointer;">
	</div>
	<div align="center">
		<table style="table-layout:fixed;display:none;" border="0" cellpadding="0" cellspacing="0" class="tbl_search"  id="mSearch">
		   <colgroup>
		       <col width="5%">
		       <col width="8%">
		       <col width="5%">
		       <col width="8%">
		       <col width="5%">
		       <col width="8%">
		       <col width="5%">
		       <col width="16%">
		      </colgroup>
		      <!-- 계층, ID, 상태 -->
		      <tr>
		      <th  class="viewtop">ID</th>
		      <td  class="viewtop"><input type="text" id="detailID" name="detailID" value="" class="stext"></td>
		      <th  class="viewtop">${menu.LN00018}</th>
		    <td  class="viewtop"><input type="text" id="detailOwnerTeam" name="detailOwnerTeam" value="" class="stext"></td>
		    <th  class="viewtop">${menu.LN00004}</th>
		    <td  class="viewtop"><input type="text" id="detailAuthor" name="detailAuthor" value="" class="stext"></td> 
		     
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
		       <td colspan="7" class="alignL">
		     <select id="AttrCode" Name="AttrCode[]" multiple="multiple" class="SlectBox" >
		     </select>
		     
		     <div id="appendDiv"></div>
		    </td>
		      </tr>
		  </table>
		  
	    <ul>
		<li id="buttonGroup" class="floatC mgR20 mgT5" style="display:none;">
			<input id="btnSearch" type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" style="cursor:pointer;">
			&nbsp;<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="cursor:pointer;" onclick="clearSearchCon();">
			<input type="image" class="image" onclick="showMultiSearchDiv();" src="${root}${HTML_IMG_DIR}/btn_search_plus.png" value="Advanced Search" style="cursor:pointer;">
		</li>
		</ul>
		
	   <div class="countList pdT10">
	   <ul>
	        <li class="count"><input type="image" id="frame_sh" class="frame_show" alt="${WM00158}" src="${root}${HTML_IMG_DIR}/btn_frame_show.png" value="Clear" style="cursor:pointer;width:20px;height:15px;margin-right:5px;" onclick="fnHideSearch();">Total  <span id="TOT_CNT"></span></li>
	        <li class="floatR"> 
	        <c:if test="${pop != 'pop'}">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
	<%-- 			<c:if test="${myItem == 'Y'}"> --%>
	<!-- 				&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="gov"></span><input value="Gov" type="submit" onclick="editCheckedAllItems('Owner');"></span> -->
	<!-- 				&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="edit"></span><input value="Attribute" type="submit" onclick="editCheckedAllItems('Attribute');"></span> -->
	<%-- 			</c:if> --%>
				</c:if>
				</c:if>
				&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="subscribe"></span><input value="Book mark" type="button" onclick="editCheckedAllItems('Subscribe');"></span>
			<c:if test="${selectedItemPath ne '지원/인사'}">
				&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="report"></span><input value="Report" type="submit" onclick="editCheckedAllItems('Report');"></span>
			</c:if>
				&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
				&nbsp;&nbsp;&nbsp;&nbsp;
	        </li>
	      </ul>
	   </div>
	</div>		
	</form>
	</div>
	 -->
	<div id="gridCngtDiv" style="width:100%;" class="clear">
		<div id="grdGridArea"></div>
	</div>
	<!-- START :: PAGING -->
		<div id="pagination"></div>
	<!-- END :: PAGING -->
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
	</div>	
<script type="text/javascript">
/* ========================grid  api 방식 호출====================================   */
async function getSearchSOPList() {
    $('#loading').fadeIn(150);
    
    // 1. 기본 파라미터 구성
    const requestData = {
        sqlID: "zHEC_SQL.zhec_getSearchMultiList", // 요청하신 기존 SQL ID
        languageID: "${sessionScope.loginInfo.sessionCurrLangType}",
        s_itemID: "${s_itemID}",
        ownerType: "${ownerType}",
        showTOJ: "${showTOJ}",
        defaultLang: $("#defaultLang").val(),
        isComLang: $("#isComLang").val(),
        pageNum: $("#currPage").val() || "1",
        assignMentType: "SUBSCR",
        sessionUserID: "${sessionScope.loginInfo.sessionUserId}",
        ClassCode: "CL05003"
    };

    const params = new URLSearchParams(requestData);

    // 2. [기본조건] setAllCondition() 추가
    let url = "getData.do?" + params.toString() + setAllCondition();

    // 3. [속성] 멀티 검색 조건 
    if ($("#AttrCode").val()) {
        let attrArray = [];
        $("#AttrCode :selected").each(function(i, el) {
            let aval = $(el).val();
            let lovCode = "", searchValue = "", AttrCodeEscape = "", constraint = "";
            let selectOption = (i === 0) ? "AND" : ($("#selectOption" + aval).val() || "AND");

            if (!$("#constraint" + aval).val() || $("#constraint" + aval).val() == "3") {
                if ($("#AttrLov" + aval).val() || $("#searchValue" + aval).val()) {
                    if ("Y" == $("#isLov" + aval).val()) {
                        lovCode = ($("#AttrLov" + aval).val() + "").replace(/,/gi, "*");
                    } else {
                        searchValue = ($("#searchValue" + aval).val() || "").replace(/,/g, "comma");
                        if(typeof setSpecialChar === "function") searchValue = setSpecialChar(searchValue);
                    }
                }
                if ($("#constraint" + aval).val() == "3") constraint = "3";
            } else {
                constraint = $("#constraint" + aval).val();
            }
            attrArray.push([aval, lovCode, searchValue, AttrCodeEscape, constraint, selectOption].join(","));
        });
        url += "&AttrCodeOLM_MULTI_VALUE=" + attrArray.join("|");
    }

    try {
  
        const response = await fetch(url);
        const result = await response.json();
        
        if(result.data){
            fnReloadGrid(grid,result.data);
            return true;
            
        } else {
        	throw new Error(`Problem with data occured: ${data}`)
        }
        
    } catch (error) {
    	handleAjaxError(error, "LN0014"); // 서버 내부 오류가 발생했습니다. 관리자에게 문의해주세요.    	
    } finally {
    	$('#loading').fadeOut(150);
    }
    return false;
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



// ========================================== [ 그리드 설정 ] ============================================== //
var layout;
var grid; 
var pagination;

    layout = new dhx.Layout("grdGridArea", {
        rows: [{ id: "a" }]
    });

    grid = new dhx.Grid(null, {
        columns: [
            { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}", align: "center" }], align: "center" },
            { 
                width: 50, id: "CHK", // 기존 CHK/checkbox 통합
                header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(event, this.checked)'>", align: "center" }], 
                align: "center", type: "boolean", editable: true, sortable: false 
            },
            {  hidden:true,
                width: 50, id: "ItemTypeName", header: [{ text: "${menu.LN00021}", align: "center" }], 
                htmlEnable: true, align: "center",
                template: function (text, row) {
                    return row.ItemTypeImg ? '<img src="${root}${HTML_IMG_DIR_ITEM}/' + row.ItemTypeImg + '" width="18" height="18">' : "";
                }
            },
            { width: 150, id: "Identifier", header: [{ text: "SOP No.", align: "center" }, { content: "selectFilter" }], align: "center" },
            { hidden:true, id: "TeamName", header: [{ text: "${menu.LN00247}", align: "center" }, { content: "inputFilter" }], align: "left" },
            { width: 70, id: "L1Name", header: [{ text: "${menu.LN00353}", align: "center" }, { content: "selectFilter" }], align: "center" },
            { width: 150, id: "L2Name", header: [{ text: "${menu.LN00354}", align: "center" }, { content: "inputFilter" }], align: "center" },
            { flex: 1, id: "ItemName", header: [{ text: "SOP명", align: "center" }, { content: "selectFilter" }], align: "center" },
            { width: 180, id: "OwnerTeamName", header: [{ text: "${menu.LN00018}", align: "center" }, { content: "selectFilter" }], align: "center" },
            { hidden:true, width: 130, id: "Name", header: [{ text: "${menu.LN01007}", align: "center" }, { content: "selectFilter" }], align: "center" },
            { width: 100, id: "CSVersion", header: [{ text: "${menu.LN00356}", align: "center" }], align: "center" },
            { width: 100, id: "ValidFrom", header: [{ text: "${menu.LN00357}", align: "center" }], align: "center" },
            { 
                width: 60, id: "FileIcon", header: [{ text: "File", align: "center" }], align: "center", 
                htmlEnable: true,
                template: function(text, row) {
                    return text ? '<img src="${root}${HTML_IMG_DIR_ITEM}/' + text + '" width="10" height="15">' : "";
                }
            },
         // Hidden Columns (기존 너비 0 처리된 항목들)
            { hidden: true, id: "ItemID",      header: [{ text: "ItemID" }] },
            { hidden: true, id: "ClassCode",   header: [{ text: "ClassCode" }] },
            { hidden: true, id: "SeqLevel",    header: [{ text: "SeqLevel" }] },
            { hidden: true, id: "AuthorID",    header: [{ text: "AuthorID" }] }
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
        const rowId = row.id;
        const colId = column.id;

        // 1. 체크박스 컬럼(CHK) 클릭 시에는 무시 
        if (colId === "CHK") return;

        // 2. 파일 아이콘 컬럼(FileIcon) 클릭 시 
        if (colId === "FileIcon") {
            var fileCheck = row.FileIcon; // row 객체에서 바로 가져옴

            // 파일이 존재하는지 체크 
            if (fileCheck && fileCheck.indexOf("blank.gif") < 0) {
                var url = "selectFilePop.do";
                var data = "?hideBlocked=Y&s_itemID=" + row.ItemID; // 인덱스 13 대신 ID 사용
                
                var w = "400";
                var h = "350";
                window.open(url + data, "", "width=" + w + ", height=" + h + ", top=100,left=100,toolbar=no,status=no,resizable=yes");
            }
        } 
        // 3. 그 외 컬럼 클릭 시 상세조회 
        else {
            // row.ItemID를 직접 참조 
            if (row.ItemID) {
                doDetail(row.ItemID);
            }
        }
    });

/* 검색시  */
    async function doSearchList() {
        // 1. 검색 실행 시 현재 페이지를 1로 초기화 
        $("#currPage").val("1");

        const success = await getSearchSOPList();

	//건수제한 알림 
   /*      if (success) {
            const totalCount = grid.data.getLength();
            if (totalCount > 1000) {
                alert("${WM00119}"); 
            }
        } */
    }
//===========================================[그리드 설정 끝]================================================//
	
</script>
</body>
</html>