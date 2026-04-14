﻿<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<c:url value="/" var="root"/>
 
 <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlx/dhtmlxToolbar/codebase/skins/dhtmlxtoolbar_dhx_skyblue.css'/>">
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00132" var="WM00132"/>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00185" var="WM00185_4" arguments="4"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00186" var="WM00186"/>

<style>
input.stext {
    width: 100%;
    box-sizing: border-box;
    height: 30px;
}

.dhx_grid_data{
	cursor:pointer;
}
</style>

<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;	
	let ZAT03011Value = "";
 	let L2ItemID = "";
	let lovListFilter = "";
	let itemName = "";
	
	$(document).ready(function() {

		let data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";		
		if("${s_itemID}" == 1) {
			L2ItemID = "";
			fnSelect('ZAT03010', data+"&attrTypeCode=ZAT03010", 'getAttrTypeLov', '', 'Select');
		} else if("${parentID}" == 12) { // CL12001 일 경우
			L2ItemID = "";
			fnSelect('ZAT03010', data+"&attrTypeCode=ZAT03010", 'getAttrTypeLov', '', 'Select');
		} else { // CL12002 일 경우
			L2ItemID = "${s_itemID}";
			
			// select parent에 ItemName 표시
			document.getElementById("ZAT03010").parentNode.insertAdjacentHTML("beforeend", "${itemName}");
			// select box 삭제
			document.getElementById("ZAT03010").remove();

			$.ajax({
				 url: "/getItemAttrLovCode.do",
			     type: "GET",
			     data: {
			    	itemID: "${s_itemID}",
			        languageID: "${sessionScope.loginInfo.sessionCurrLangType}",
			        attrTypeCode: "ZAT03010"
			     },
			     dataType: "text",
			     success: function(result) {
			    	fnSelect('ZAT03011', "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&lovCode="+result, 'getSubLovList', '', 'Select');
			  
			     },
			     error: function() {
			         console.error("에러 발생");
			     }
			 });
		}

		getAttrLovList("ZAT01070");
		getAttrLovList("ZAT03090");
		   
	 	$("input.datePicker").each(generateDatePicker);
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 281)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			if($("#frame_sh").hasClass("frame_show")) {
				$("#layout").attr("style","height:"+(setWindowHeight() - 281)+"px;");
			}
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

		  $('#constraint').change(function(){changeConstraint($(this).val(), "");});
		  
		  $('#searchValue').keypress(function(onkey){
		   if(onkey.keyCode == 13){
		    $("#searchValueAT00001").val($(this).val());
		    return false
		   ;}
		  });  
		  
		$("#loading").fadeIn(100);
		checkLoadingBar();
		showMultiSearchDiv();

		doSearchList();
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
			alert("${WM00185_4}"); // 최대 4개 선택 가능 합니다.
		}
	}
	
	function checkAttrDiv(divClassName,text,ari){
		var html = "";
		var bfAttr = $("#beforeCode").val();

		html += '<div class="'+divClassName+'" style="margin-top:10px;">';

		html += "<div style=\"text-align: right; line-height: 25px; float:left;\" ><b>"+text+"</b></div>";	
			
		html += "<select id=\"constraint"+divClassName+"\" name=\"constraint[]\" class=\"SlectBox\" style=\"width:150px;margin-left:20px;\" onChange=\"changeConstraint($(this).val(),'"+divClassName+"')\" >";
		html += "<option value=\"\">${menu.ZLN0117}</option>";			// 포함(또는 같음)
		html += "<option value=\"3\">${menu.ZLN0118}</option>";		// 포함하지 않음(또는 다름)
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

	function clickItemEvent(itemID, authorID, status, accRight){
		var accMode = "";
		var userID = "${sessionScope.loginInfo.sessionUserId}";
		var myItem=""
		  // AJAX 요청
        $.ajax({
            url: '/checkMyItem.do',  
            type: 'GET', 
            data: {
                itemID: itemID,  // 보내는 데이터
                userID: userID
            },
            dataType: 'json',  
            success: function(response) {
               
                if (response.memberID) {
                    
                    myItemUser=response.memberID;
                   
                    myItem = "Y";
               			
                } else {
            
                    myItem="N";
               }
    
        		
              	accMode = authorID == "${sessionScope.loginInfo.sessionUserId}"|| myItem=="Y" ? "DEV" : "OPS";
    			if(authorID == "${sessionScope.loginInfo.sessionUserId}"|| myItem=="Y") accMode = "DEV";
    			else {
    				if(status == "REL") accMode = "DEV";
    			/* 	else {
    					alert("접근 할 수 없습니다.");
    					return false;
    				} */
    			}
    			var url = "processItemInfo.do";
    			var data = "itemID="+itemID+"&s_itemID="+itemID+"&option=${option}&itemEditPage=${itemEditPage}&itemViewPage=${itemViewPage}&scrnMode=V"
    				+"&accMode="+accMode+"&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
    				+"&url=/custom/sk/skon/item/mtr/viewMTRInfo"
    				+"&scrnOption=Y"
    				+"&itemOption=Y"
    				+"&defDimValueID=${defDimValueID}&nodeID="
    				+"&selectedTreeID=${s_itemID}&fixedDimValueID=${fixedDimValueID}&accRight="+accRight;
    			
    			var w = 1200;
    			var h = 900;
//    	 		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
    			document.getElementById("processList").classList = "";
    			ajaxPage(url, data, "processList");
                
            },
            error: function(xhr, status, error) {
                // 오류 처리
                alert("${WM00186}");	// 오류가 발생했습니다. 다시 시도해주세요.
            }
        });
		
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
		 //doSearchList();
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
	
	
	// Clear btn.
	function clearSearchCon() {
		
		$("#appendDiv").empty();

		// 기본정보 상세
		$("#ZAT03010").val('');
		
		$("#ZAT03011").val('');	// 불량유형	
		$("#ZAT03030").val('');	// 불량위치
		$("#ZAT03040").val('');	// 세부현상	
		
		$("#ZAT01070").val('');	// Site
		$("#ZAT09006").val('');	// Line	
		$("#ZAT09005").val(''); // Model		

		$("#AT00001").val('');	// 문서명
		$("#ZAT03050").val('');	// 상세공정(검출)
		$("#ZAT03070").val('');	// 상세공정(기인)
		$("#ZAT03090").val('');	// 원인	
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
	

	
	// [back] click

	function fnResetSelectBox(objName,defaultValue)
	{
		$("select[name='"+ objName +"'] option").not("[value='"+defaultValue+"']").remove(); 
	}

	
	function showMultiSearchDiv() {
			$("#search").hide();
			$("#mSearch").show();
			$("#buttonGroup").show();
			$("#layout").attr("style","height:"+(setWindowHeight() - 281)+"px;");
   
	}

	function doNameSearchList() {
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
	//cop_hdtitle
	
	/*공통등록*/
	function fnCreateMTR(){
		var url = "processItemInfo.do";
		var data = "&itemEditPage=custom/sk/skon/item/mtr/createMTRInfo&accMode=DEV&scrnMode=N&option=${option}&screenOption=C"
					+"&curItemID=${s_itemID}"
					+"&defDimValueID=${defDimValueID}"
					+"&selectedTreeID=${s_itemID}&fixedDimValueID=${fixedDimValueID}";	
		var target = "myItemList";

		ajaxPage(url, data, target);
	}
	
	async function getItemAccRight(itemID) {
		const res = await fetch("getItemAccRight.do?itemID="+itemID+"&userID=${sessionScope.loginInfo.sessionUserId}")
		const data = await res.json();
		
		return data.data;
	}
	
	// 그리드ROW선택시 
	async function gridOnRowSelect(row,col){
		const accRight = await getItemAccRight(row.ItemID);
		
		if(accRight == "Y") {
			if(col.id != "CHK") {
				
				if(col.id != "FileIcon" ) {
					clickItemEvent(row.ItemID, row.AuthorID, row.Status, accRight);			
				}
				else if(col.id != "CHK" && col.id != "FileIcon") {
					var fileCheck = row.FileIcon;
		
					if(fileCheck.indexOf("blank.gif") < 1) {
						var url = "selectFilePop.do";
						var data = "?hideBlocked=Y&s_itemID="+row.ItemID+"&scrnOption=E"
					   
					    var w = "400";
						var h = "350";
					    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");	
					}
				}
			}
		} else {
			alert("${WM00033}")
		}
	}
	
	function fnZAT03010Change(value){
		fnSelect('ZAT03011', "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&lovCode=" + value + "&lovListFilter=" + lovListFilter, 'getSubLovList', '', 'Select');
	}
	
	function reloadItem() {
		parent.olm.getMenuUrl(document.getElementById("processList").dataset.id,'','',parent.olm.menuTree.getSelectedItemText());
	
	}

	function fnHideSearch() {
		var tempSrc = $("#frame_sh").attr("src");
		if($("#frame_sh").hasClass("frame_show")) {
			$("#mSearch").hide();
			$("#buttonGroup").hide();
			$("#frame_sh").attr("class","frame_hide");
			$("#frame_sh").attr("alt","${WM00159}");
			$("#frame_sh").attr("src",tempSrc.replace("btn_frame_show","btn_frame_hide"));
			$("#layout").attr("style","height:"+(setWindowHeight() - 168)+"px;");
		}
		else {
			$("#mSearch").show();
			$("#buttonGroup").show();
			$("#frame_sh").attr("class","frame_show");
			$("#frame_sh").attr("alt","${WM00158}");
			$("#frame_sh").attr("src",tempSrc.replace("btn_frame_hide","btn_frame_show"));
			$("#layout").attr("style","height:"+(setWindowHeight() - 428)+"px;");
		}
	}

	 
	function editCheckedAllItems(avg){
		var selectedCell = grid.data.findAll(function (data) {
	        return data.CHK;
	    });
		if(!selectedCell.length){
			alert("${WM00023}");
			return false;
		}
		var items = new Array();	
		var classCodes = new Array();
		for(idx in selectedCell){
			items.push(selectedCell[idx].ItemID);
		  	classCodes.push(selectedCell[idx].ClassCode);
		};
		
		if (items != "") {
			$("#items").val(items);
			if (avg == "Attribute2") {
				var url = "selectAttributePop.do";
				var data = "items="+items+"&classCodes="+classCodes; 
			    var option = "dialogWidth:400px; dialogHeight:250px;";
			    window.open("", "selectAttribute2", "width=400, height=350, top=100,left=100,toolbar=no,status=no,resizable=yes");
				$("#classCodes").val(classCodes);
			    document.processList.action=url;
			    document.processList.target="selectAttribute2";
			    document.processList.submit();
			    
			}else if (avg == "Attribute") {
				var url = "selectAttributePop.do";
				var data = "classCodes="+classCodes+"&items="+items; 
			    var option = "dialogWidth:400px; dialogHeight:250px;";		
			   
			    var w = "400";
				var h = "350";
				$("#classCodes").val(classCodes);
			    window.open("", "selectAttribute", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
			    document.processList.action=url;
			    document.processList.target="selectAttribute";
			    document.processList.submit();
				    
			} else  if (avg == "Owner") {			    
			    var url = "selectOwnerPop.do"; 
			    var option = "width=550, height=350, left=300, top=300,scrollbar=yes,resizble=0";
			    window.open("", "SelectOwner", option);
			    document.processList.action=url;
			    document.processList.target="SelectOwner";
			    document.processList.submit();
			} 
		 }
	}
	
	// callback - editCheckedAllItems('Owner')
	function urlReload() {
		doSearchList();
	}
	
	function openImagePopup() {
	    fetch("/setPopupToken.do")
	      .then(() => {
	        let w = 1600, h = 950;
	        window.open("zSKON_openImagePopup.do", "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	      });
	}
	
	async function getAttrLovList(attrTypeCode){		
		let param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
							+"&sqlID=attr_SQL.selectAttrLovOption"
							+"&attrTypeCode="+attrTypeCode;

		await getLovListByItemType(attrTypeCode).then(res => {
			if(attrTypeCode == "ZAT03011") lovListFilter = res;
			param += "&lovListFilter=" + res;
		});
		
		
		fetch("/olmapi/getLovValue/?"+param)	
		.then(res => res.json())
		.then(res => {
			let lovHtml = "";
			lovHtml += "<option value=''>Select</option>"
			for(var i=0; i < res.data.length; i++) {
				lovHtml += '<option value="'+res.data[i].CODE+'">'+res.data[i].NAME+'</option>';
			}
			
			document.querySelector("#"+attrTypeCode).innerHTML = lovHtml;
		});
	}
	
	async function getLovListByItemType(attrTypeCode) {
		const res = await fetch("/olmapi/skAttrLovList/?itemTypeCode=OJ00012&attrTypeCode="+attrTypeCode);
		const data = await res.json();
		return data;
	}
</script>
</head>
<body>
<form name="processList" id="processList" action="#" method="post"  onsubmit="return false;" class="pdL10 pdR10" data-id="${s_itemID}" style="height: 100%;overflow: auto;">
	<input type="hidden" id="searchKey" name="searchKey" value="Name">
	<input type="hidden" id="currPage" name="currPage" value="${currPage}"></input>
	<input type="hidden" id="defaultLang" name="defaultLang" value="${defaultLang}">
	<input type="hidden" id="attrIndex" value="0">
	<input type="hidden" id="multiSearch" value="N">
	<input type="hidden" id="accMode" name="accMode" value="${accMode}" />
	<input type="hidden" id="items" name="items" />
	<input type="hidden" id="classCodes" name=classCodes />
	
	<div id="myItemList">
		<div class="cop_hdtitle" id ="cop_hdtitle" style="padding: 10px 0; ">
			<h3 style="display: inline-block"><img src="${root}${HTML_IMG_DIR}/icon_search_title.png">&nbsp;${itemName}&nbsp;
				<c:forEach var="path" items="${itemPath}" varStatus="status">
						<c:choose>
							<c:when test="${status.first}">
							( <span style="cursor:pointer">${path.PlainText}</span>
							</c:when>
							<c:when test="${status.last}">
							>&nbsp;<span style="cursor:pointer">${path.PlainText}</span>
							</c:when>
							<c:otherwise>>&nbsp;<span style="cursor:pointer">${path.PlainText}</span></c:otherwise>
						</c:choose>
				</c:forEach>
				<c:if test="${itemPath != null && itemPath.size() > 0 }">)</c:if>
			</h3>
			<c:if test="${sessionScope.loginInfo.sessionAuthLev == 1}" >
				<span class="btn_pack small icon mgR25" style="float: right;"><input value="Standard Menu" type="button" style="padding-left: 2px;" onclick="fnChangeMenu('management','Management');"></span>
			</c:if>
		</div>

	<div align="center">
		<table style="table-layout:fixed;display:none;" border="0" cellpadding="0" cellspacing="0" class="tbl_search"  id="mSearch">
			<colgroup>
				<col width="10%">
				<col width="15%">
				<col width="10%">
				<col width="15%">
				<col width="10%">
				<col width="15%">
				<col width="10%">
				<col width="15%">
			</colgroup>
					
			 <tr>
			 	<!-- 불량등급 -->
			 	<th class="viewtop alignl">${menu.ZLN0033}</th>
				<td class="viewtop alignl ZAT03010">
					<select id="ZAT03010" name="ZAT03010"style="width: 100%;display: inline-block;" onchange="fnZAT03010Change(this.value)">
						<option value=''></option>
					</select>
				</td>
				
				<!-- 불량유형 -->
				<th class="viewtop alignl">${menu.ZLN0034}</th>
				<td class="viewtop alignl">
					<select id="ZAT03011" name="ZAT03011"style="width: 100%;display: inline-block;">
						<option value=''></option>
					</select>
				</td>
				
				<!-- 불량위치 -->
				<th class="viewtop alignl">${menu.ZLN0041}</th>
				<td class="viewtop alignl"><input type="text" id="ZAT03030" name="ZAT03030" class="stext"></td>
				
				<!-- 세부현상 -->
				<th class="viewtop alignl">${menu.ZLN0042}</th>
				<td class="viewtop alignl"><input type="text" id="ZAT03040" name="ZAT03040" class="stext"></td>
			</tr> 
			
			<tr>
			 	<!-- Site -->
				<th class="viewtop alignl">${menu.ZLN0037}</th>
				<td class="viewtop alignl">
					<select id="ZAT01070" name="ZAT01070"style="width: 100%;display: inline-block;">
						<option value=''></option>
					</select>
				</td>
				
				<!-- 라인 -->
				<th class="viewtop alignl">${menu.ZLN0038}</th>
				<td class="viewtop alignl"><input type="text" id="ZAT09006" name="ZAT09006" class="stext"></td>
				
				<!-- 모델 -->
				<th class="viewtop alignl">${menu.ZLN0040}</th>
				<td class="viewtop alignl"><input type="text" id="ZAT09005" name="ZAT09005" class="stext"></td>
				<th class="viewtop alignl"></th>
			</tr> 
			
			<tr>
				<!-- 문서명 -->
				<th class="viewtop alignl">${menu.LN00101}</th>
				<td class="viewtop alignl"><input type="text" id="AT00001" name="AT00001" class="stext"></td>
				
				<!-- 상세공정(검출) -->
				<th class="viewtop alignl">${menu.ZLN0067}(${menu.ZLN0043})</th>
				<td class="viewtop alignl"><input type="text" id="ZAT03050" name="ZAT03050" class="stext"></td>
				
				<!-- 상세공정(기인) -->
				<th class="viewtop alignl">${menu.ZLN0067}(${menu.ZLN0061})</th>
				<td class="viewtop alignl"><input type="text" id="ZAT03070" name="ZAT03070" class="stext"></td>
				
				<!-- 원인 -->
				<th class="viewtop alignl">${menu.ZLN0047}</th>
				<td class="viewtop alignl">
					<select id="ZAT03090" name="ZAT03090"style="width: 100%;display: inline-block;">
						<option value=''></option>
					</select>
				</td>
				<th class="viewtop alignl"></th>
			</tr> 

			</table>
			 <ul>
				<li id="buttonGroup" class="floatC mgR20 mgT5" style="display:none;">
					<input id="btnSearch" type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" style="cursor:pointer;">
					&nbsp;<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="cursor:pointer;" onclick="clearSearchCon();">
				</li>
			</ul>
	</div>	
	
		<div id="proDiv" style="overflow:auto;">
		   <div class="countList pdT10"> <!-- Total & 버튼들 -->
			       <!-- total -->
			       <ul>
			        <li class="count"><input type="image" id="frame_sh" class="frame_show" alt="${WM00158}" src="${root}${HTML_IMG_DIR}/btn_frame_show.png" value="Clear" style="cursor:pointer;width:20px;height:15px;margin-right:5px;" onclick="fnHideSearch();">Total  <span id="TOT_CNT"></span></li>
			        <li class="floatR">
			        	 &nbsp;<span class="btn_pack small icon"><span class="move"></span><input value="Guide" type="submit" id="add" onClick="openImagePopup()"></span>
						<%-- <c:if test="${myItem == 'Y'}">
			        	 &nbsp;<span class="btn_pack small icon"><span class="gov"></span><input value="Gov" type="submit" id="gov" onClick="editCheckedAllItems('Owner')"></span>
			        	</c:if>  --%>
						<c:if test="${s_ClassCode eq 'CL12002'}">
						 &nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Create" type="submit" id="add" onClick="fnCreateMTR()"></span>
						</c:if>
						 &nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="down"></span><input value="Down" type="submit" id="excel"></span> 
					<!--<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnGridExcelDownLoad()" value="Down">Download List</button>-->
						&nbsp;&nbsp;&nbsp;&nbsp;
			        </li>
			        </ul>
		   	</div>
		</div>
		<div style="width: 100%;"id="layout" style="width:100%;"></div>
		<div id="pagination" style="width:100%; height:60px;"></div>
		</div>
</form>
<iframe name="blankFrame" id="blankFrame" style="width:0px;height:0px;display: none;"></iframe>

<script type="text/javascript">



	var layout = new dhx.Layout("layout", {
		rows : [ 
		{
			id : "a",
			
		},  ]
	});	
	
	var grid = new dhx.Grid("", {
		 columns: [
			// No / Site  / 문서명 / 기인 공정 / 불량등급 / 불량유형 / 세부현상 
			{ width: 50, id: "RENUM", header: [{ text: "${menu.LN00024}", align: "center" }], align: "center" },
			{ width: 80, id: "Site", header: [{ text: "${menu.ZLN0037}" , align: "center" }, { content: "selectFilter" }], align: "center" },
			{  id: "ItemName", header: [{ text: "${menu.LN00101}" , align: "center" }, { content: "inputFilter" }], align: "center" },
	        { width: 150, id: "ZAT03070", header: [{ text: "${menu.ZLN0061} ${menu.ZLN0044}", align: "center" }, { content: "selectFilter" }], align: "center" },
	        {  width: 80, id: "ZAT03010", header: [{ text: "${menu.ZLN0033}", align: "center" }, { content: "selectFilter" }], align: "center" },
	        {  width: 150, id: "ZAT03011", header: [{ text: "${menu.ZLN0034}", align: "center" }, { content: "selectFilter" }], align: "center" },
	        {  id: "ZAT03040", header: [{ text: "${menu.ZLN0042}", align: "center" }, { content: "selectFilter" }], align: "center" },
			// 등록일 / 등록부서 / 등록자 / 상태 / ItemID
	        {  width: 100, id: "CreationTime", header: [{ text: "${menu.LN00078}", align: "center" }, { content: "inputFilter" }], align: "center" },
			{  width: 150, id: "OwnerTeamName", header: [{ text: "${menu.ZLN0141}", align: "center" }, { content: "inputFilter" }], align: "center" },
			{  width: 100, id: "Name", header: [{ text: "${menu.LN00212}", align: "center" }, { content: "inputFilter" }], align: "center" },
			{  width: 100, id: "CSStatusName", header: [{ text: "${menu.LN00027}", align: "center" }, { content: "inputFilter" }], align: "center"}, 
	        { hidden: true, width: 100, id: "ItemID", header: [{ text: "itemid", align: "center" }], align: "center" }
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	});
	
	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: Math.floor((setWindowHeight() - 281) / 30),
	});
	
	layout.getCell("a").attach(grid);


	$("#TOT_CNT").html(grid.data.getLength());
	

	grid.events.on("cellClick", function(row, column, e) {
		gridOnRowSelect(row,column);
	});
	
	function doSearchList(){
		$('#loading').fadeIn(150);
		let siteCode = "";
		var sqlID = "zSK_SQL2.getMTRList";
		let defClassList = "";
		"${defClassList}".split(",").forEach(e => {defClassList += defClassList === "" ?  "'"+e+"'" : ",'"+e+"'"});
		var param = "";
		param += "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&defClassList="+defClassList
		+ "&sqlID="+sqlID
		+"&pItemID=${s_itemID}";	

		if("${classCode}" == 'CL12001') {
			param += "&ZAT03010="+$("#ZAT03010").val(); // 불량등급
		}
		else if ("${classCode}" == 'CL12002') {
			param += "&L2ItemID="+ L2ItemID;			// 불량등급
		}
		
		param += "&ZAT03011="+$("#ZAT03011").val(); // 불량유형
		param += "&ZAT03030="+$("#ZAT03030").val(); // 불량위치
		param += "&ZAT03040="+$("#ZAT03040").val(); // 세부현상
		
		param += "&ZAT01070="+$("#ZAT01070").val(); // Site
		param += "&ZAT09006="+$("#ZAT09006").val(); // Line
		param += "&ZAT09005="+$("#ZAT09005").val(); // Model
		
		param += "&AT00001="+$("#AT00001").val();   // 문서명
		param += "&ZAT03050="+$("#ZAT03050").val(); // 상세공정(검출)
		param += "&ZAT03070="+$("#ZAT03070").val(); // 상세공정(기인)
		param += "&ZAT03090="+$("#ZAT03090").val(); // 원인
		
		
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadGrid(result);
				$('#loading').fadeOut(150);
			},error:function(xhr,status,error){
			}
		});
	}
	
	function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
		$("#TOT_CNT").html(grid.data.getLength());
	}
</script>
</body>
</html>
