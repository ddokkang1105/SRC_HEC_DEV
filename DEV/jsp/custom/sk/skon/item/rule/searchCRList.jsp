<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00054" var="WM00054"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00024" var="WM00024"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00052" var="WM00052"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00055" var="WM00055"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00056" var="WM00056"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00057" var="WM00057"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00058" var="WM00058"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00059" var="WM00059"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_1" arguments="${menu.LN00016}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_2" arguments="CSR"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00060" var="WM00060"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00040" var="CM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00121" var="WM00121" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00122" var="WM00122" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00123" var="WM00123" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00124" var="WM00124" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00116" var="WM00116_1" arguments="${menu.LN00015}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00116" var="WM00116_2" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00106" var="WM00106" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033"/>

<script>
//그리드 전역변수
$(document).ready(function(){
	
	// 초기 표시 화면 크기 조정 
	$("#layout").attr("style","height:"+(setWindowHeight() - 355)+"px; width:100%;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#layout").attr("style","height:"+(setWindowHeight() - 355)+"px; width:100%;");
	};
	
	$("#excel").click(function(){ fnGridExcelDownLoad(); });
	
 	var data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
	fnSelect('dimTypeID', data, 'getDimensionTypeID', '', 'Select');	
	
	
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

function urlReload() {
	fnReload();
}

function fnCheckItemArrayAccRight(itemIDs){
	$.ajax({
		url: "checkItemArrayAccRight.do",
		type: 'post',
		data: "&itemIDs="+itemIDs,
		error: function(xhr, status, error) { 
		},
		success: function(data){	
			data = data.replace("<script>","").replace(";<\/script>","");		
			fnCheckAccCtrlFilePopOpen(data,itemIDs);
		}
	});	
}

function fnCheckAccCtrlFilePopOpen(data,itemIDs){
	var dataArray = data.split(",");
	var accRight = dataArray[0];
	var fileName = dataArray[1];
	
	if(accRight == "Y"){
		var url = "selectFilePop.do";
		var data = "?s_itemID="+itemIDs; 
	   
	    var w = "400";
		var h = "350";
	    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}else{			
		alert("${WM00033}"); return;
	}
}

function doDetail(avg1){
	var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop"+"&accMode=${accMode}";
	var w = 1400;
	var h = 900;
	itmInfoPopup(url,w,h,avg1);
	
}

function deleteItem(){
	var selectedCell = grid.data.findAll(function (data) {
        return data.checkbox;
    });
	if(!selectedCell.length){
		alert("${WM00023}");
		return false;
	}
	
	if(confirm("${CM00004}")){
		var items = new Array();	
		for(idx in selectedCell){
			//items.push(selectedCell[idx].ItemID);
			if(selectedCell[idx].Blocked == "0"){
				if(selectedCell[idx].GUBUN == "O"){						
					alert(selectedCell[idx].ItemName +" - ${WM00052}"); 
					grid.data.update(selectedCell[idx].id, { "checkbox" : false });
				
				}else if(selectedCell[idx].ChangeMgt == "1" && (selectedCell[idx].Status == "MOD1" || selectedCell[idx].Status == "DEL1")){						
					alert(selectedCell[idx].ItemName+" ${WM00046}"); 
					grid.data.update(selectedCell[idx].id, { "checkbox" : false });
				
				}else {	
					if(selectedCell[idx].SCOUNT != 0){
						// 하위항목이 존재할 경우 삭제 불가
						alert(selectedCell[idx].ItemName+" - ${WM00024}");
						grid.data.update(selectedCell[idx].id, { "checkbox" : false });
						return false;
						
				   } else {
						items.push(selectedCell[idx].ItemID);
				   }
			    }
			} else {
		  		if (selectedCell[idx].ItemStatus == "REL") {
					alert(selectedCell[idx].ItemName +" ${WM00121}"); 
				} else {
					alert(selectedCell[idx].ItemName +" ${WM00054}"); 
				}
		  		grid.data.update(selectedCell[idx].id, { "checkbox" : false });
		  	}
		};
		
		if (items != "") {
			var url = "setItemStatusForDel.do";
			var data = "s_itemID=${s_itemID}&items="+items;
			var target = "blankFrame";
			ajaxPage(url, data, target);
		}
		
	}
		
}

function testLayer(avg1,avg2,avg3){
	// 조회 창을 닫음
	$(".popup_div").hide();
	$("#mask").hide();
	// 변경요청 화면을 모달로 표시
	goInsertChangeSet(avg1,avg2,avg3);
}

/* 변경요청 insert -체크항목 , 유형, 선택항목(이동시)*/
function goInsertChangeSet(avg1, avg2 , avg3) {
	//var url = "changeInfoAddViewPop.do?";
	//var data = "items=" + avg1 + "&changeType=" + avg2 + "&userId=${sessionScope.loginInfo.sessionUserId}&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"; 
	
	//Move - 구조 이동시
	if(avg3 != ""){
		//현재 항목과 이동될 항목이 같은지 체크
		if('${s_itemID}'==avg3){
			//alert("같은 항목으로는 이동 하지 못합니다.");//arguments
			alert("${WM00055}");//arguments
			return;
		}
		var checkVal = avg1.split(",");
		for(var i = 0; i < checkVal.length ; i++){
			if(checkVal[i] == avg3){
				//alert("이동 될 항목중 선택 된 항목이 들어 있습니다.");
				alert("${WM00056}");
				return
			}
		}
		data = data + "&fromItemID=${s_itemID}&toItemID="+avg3;
	}
	
	var url = "changeInfoAddView.do";
	var data = "backScreen=1&s_itemID=${s_itemID}&option=${option}&items=" + avg1 + "&changeType=" + avg2 
		+ "&userId=${sessionScope.loginInfo.sessionUserId}&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}";
	var target = "processList";		
	ajaxPage(url, data, target);
	
	//var option = "dialogWidth:1050px; dialogHeight:305px; scroll:yes";
    //window.showModalDialog(url + data , self, option);
}

function setSubDiv(avg, avg2){	
	$("#"+avg2).attr('style', 'display: none');
	$("#"+avg).removeAttr('style', 'display: none');	
	if(avg == 'addNewItem'){
		$("#ownerTeamID").val('${sessionScope.loginInfo.sessionTeamId}');
		
		$("#addNewItem").removeAttr('style', 'display: none');
		
		$("#divTapItemAdd").removeAttr('style', 'display: none');
		$("#divTapItemCopy").attr('style', 'display: none');
		$("#transDiv").attr('style', 'display: none');
		$("#moveOrg").attr('style', 'display: none');		
		$("#newIdentifier").focus();
		
		var data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('dimTypeID', data, 'getDimensionTypeID', '', 'Select');	
		fnSelect('dimTypeValueID', data, 'getDimTypeValueId', '', 'Select');	
	}else if(avg == 'MoveItem'){/*Move*/
		var items = new Array();
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00057}");
			return false;
		}
	
		for(idx in selectedCell){
			if(selectedCell[idx].GUBUN == "O" || selectedCell[idx].GUGUN == "o"){
				alert(selectedCell[idx].ItemName + "${WM00059}");
				return false;
			}else{
				items.push(selectedCell[idx].ItemID);
			}
		};
			
		if (items != "") {
			$("#addNewItem").attr('style', 'display: none');
			
			$("#divTapItemAdd").attr('style', 'display: none');
			var url = "acrCodeTreePop.do";
			var data = "items=" + items + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${s_itemID}&option=${option}";
			fnOpenLayerPopup(url,data,doCallBackMove,617,436);
		}
	}
}

function fnCallBack(){doTcSearchList();}
function doCallBackMove(){}
function doCallBackRef(){doPPSearchList();}
function newItemInsert(addYN){
	// 입력 필수 체크 : 계층, 명칭, CSR 입력 필수
	if($("#newClassCode").val() == ""){alert("${WM00041_1}");$("#newClassCode").focus();return false;}
	if($("#newItemName").val() == ""){alert("${WM00034_1}");$("#newItemName").focus();return false;}
	if($("#csrInfo").val() == ""){alert("${WM00041_2}");$("#csrInfo").focus();return false;}
	var newItemName = encodeURIComponent($("#newItemName").val());
	//if(confirm("신규 정보를 생성 하시겠습니까?")){		
	if(confirm("${CM00009}")){		
		var url = "createItem.do";
		var data = "s_itemID=${s_itemID}&option=${option}"
					+"&newClassCode="+$("#newClassCode").val()
					+"&newIdentifier="+$("#newIdentifier").val()
					+"&OwnerTeamId="+$("#ownerTeamID").val()
					+"&AuthorID="+$("#AuthorSID").val()
					+"&AuthorName="+$("#AuthorName").val()
					+"&newItemName="+newItemName
					+"&csrInfo="+$("#csrInfo").val()
					+"&dimTypeID="+$("#dimTypeID").val()
					+"&dimTypeValueID="+$("#dimTypeValueID").val()
					+"&addYN="+addYN
					+"&autoID="+$("#autoID").val()
					+"&preFix="+$("#preFix").val();
					
		var target = "blankFrame";		
		ajaxPage(url, data, target);
	}
}
function reloadTcSearchList(s_itemID){doTcSearchList();$('#itemID').val(s_itemID);}
function selectedTcListRow(){	
	var s_itemID = $('#itemID').val();$('#itemID').val("");
	if(s_itemID != ""){tc_gridArea.forEachRow(function(id){ if(s_itemID == tc_gridArea.cells(id, 14).getValue()){tc_gridArea.selectRow(id-1);}
	});}
}

function doReturnInsert(classCode,addYN){
	setTimeout(function() {urlReload();}, 2000);
	if(addYN == "Y"){
		$("#newClassCode").val(classCode);
		$("#newIdentifier").val("");
		//$("#ownerTeamID").val("");
		$("#ownerTeamID").val('${sessionScope.loginInfo.sessionTeamId}');
		$("#newItemName").val("");
		$("#addNewItem").attr('style', 'display: done');	
		$("#divTapItemAdd").attr('style', 'display: done');	
	}else{
		$("#newClassCode").val("");$("#newIdentifier").val("");
		$("#ownerTeamID").val('${sessionScope.loginInfo.sessionTeamId}');
		//$("#ownerTeamID").val("");
		$("#newItemName").val("");
		$("#csrInfo").val("");
		$("#addNewItem").attr('style', 'display: none');	
		$("#divTapItemAdd").attr('style', 'display: none');
		
		$("#divTapItemCopy").attr('style', 'display: none');	
		$("#copyItem").attr('style', 'display: none');
	}
	
	$("#newIdentifier").attr('disabled',false);
	//$("#autoID").val(autoID);
	$("#preFix").val("");
}

function fnMoveItems(avg, isCheck){
	if(isCheck == "false") {
		alert("${WM00060}");
		return;
	}
	
	var selectedCell = grid.data.findAll(function (data) {
        return data.checkbox;
    });
	
	if(!selectedCell.length){
		alert("${WM00023}");
		return;
	}else{		
		if('${s_itemID}'==avg){
			alert("${WM00055}");
			return;
		}
		if(confirm("${CM00040}")){
			var items = new Array();
			for(idx in selectedCell){
				if(selectedCell[idx].ItemID == avg){
					alert("${WM00056}");
					return;
				}
				items.push(selectedCell[idx].ItemID);
			};
			
			if(items != ""){
				var url = "changeItemParent.do";
				var data = "s_itemID=${s_itemID}&items="+items+"&fromItemID="+avg;
				var target = "blankFrame";
				ajaxPage(url, data, target);
			}
			$(".popup_div").hide();
			$("#mask").hide();
		}		
	}
}

/**  
 * [Owner][Attribute] 버튼 이벤트
 */
 
function editMulitiItemID(){
	
	    var url = "editItemIDNamePop.do"; 
	    var option = "width=550, height=570, left=100, top=100,scrollbar=yes,resizble=0";
	    window.open("", "SelectOwner", option);
	    document.processList.action=url;
	    document.processList.target="SelectOwner";
	    document.processList.submit();
}

function editCheckedAllItems(avg){
	var selectedCell = grid.data.findAll(function (data) {
        return data.checkbox;
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

// [+] search 확장 버튼 click
function goSearchList() {
	var url = "searchList.do";
	var data = "s_itemID=${s_itemID}&menucat=middle&option=${option}&pop=${pop}&accMode=${accMode}";
	var target = "processList";
	ajaxPage(url, data, target);
}

function fnGetDimTypeValue(dimTypeID){
	var data = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&dimTypeId="+dimTypeID;
	fnSelect('dimTypeValueID', data, 'getDimTypeValueId', '', 'Select');	
}

function fnGetHasDimension(classCode){ 
	var url = "getHasDimension.do";
	var data = "itemClassCode="+classCode;
	var target = "blankFrame";
	ajaxPage(url, data, target);
}

function fnSetDimension(hasDimension, autoID, preFix){ 
	if(hasDimension == "1"){
		$("#dim1").attr('style', 'visibility:visible;');
		$("#dim2").attr('style', 'visibility:visible;');
		$("#dim3").attr('style', 'visibility:visible;');
		var data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('dimTypeID', data, 'getDimensionTypeID', '', 'Select');	
		fnSelect('dimTypeValueID', data, 'getDimTypeValueId', '', 'Select');			
	}else{
		$("#dim1").attr('style', 'visibility:hidden');
		$("#dim2").attr('style', 'visibility:hidden');
		$("#dim3").attr('style', 'visibility:hidden');
	}
	
	if(autoID == "Y"){
		$("#newIdentifier").attr('disabled',true);
		$("#newIdentifier").val("");
		$("#autoID").val(autoID);
		$("#preFix").val(preFix);
	}else{
		$("#newIdentifier").attr('disabled',false);
		$("#autoID").val(autoID);
		$("#preFix").val("");
	}
}

function fnUpdateChilidItemOrder(){
	var sqlKey = "item_SQL.getChildItemList";
	var url = "childItemOrderList.do?s_itemID=${s_itemID}&sqlKey="+sqlKey;
	var w = 500;
	var h = 500;
	window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");

}

var identifier = "";
var itemName = "";
function fnCopyItemInfoOpen(){
	var selectedCell = grid.data.findAll(function (data) {
        return data.checkbox;
    });	
	
	if(selectedCell.length != 1){
		alert("${WM00106}");
		return false;
	}
	
	var itemID = "";	
	var classCode = "";
	var gubun = "";
	var itemTypeCode = "";
	for(idx in selectedCell){	
	  	itemID = selectedCell[idx].ItemID;	
		identifier = selectedCell[idx].Identifier;	
		itemName = selectedCell[idx].ItemName;	
		classCode = selectedCell[idx].ClassCode;	
		gubun = selectedCell[idx].GUBUN;	
		itemTypeCode = selectedCell[idx].ItemTypeCode;	
	};
	if(gubun != "M"){
		alert("${WM00046}");
		return false;
	}
	
	var data = "&itemID="+itemID+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
	fnSelect('modelID', data, 'selectModelList', '', 'Select', 'model_SQL');
	
	$("#copyItem").removeAttr('style', 'display: none');
	$("#addNewItem").attr('style', 'display: none');	
	
	$("#ownerTeamID").val('${sessionScope.loginInfo.sessionTeamId}');	
	$("#divTapItemAdd").attr('style', 'display: none');	
	$("#divTapItemCopy").removeAttr('style', 'display: none');
	$("#transDiv").attr('style', 'display: none');
	$("#moveOrg").attr('style', 'display: none');		
	
	$("#cpItemID").val(itemID);
	$("#cpIdentifier").val(identifier);
	$("#cpItemName").val(itemName);
	$("#cpClassCode").val(classCode);
	$("#cpItemTypeCode").val(itemTypeCode);
	
	$("#checkElmts").val('');
	$("#newModelName").val('');
	$("#MTCTypeCode").val('');
	$("#ModelTypeCode").val(''); 
}

function fnCopyItemInfo(){
	var cpIdentifier = $("#cpIdentifier").val();
	var cpItemName = $("#cpItemName").val();
	var cpCsrInfo = $("#cpCsrInfo").val();
	
	if(cpItemName == ""){alert("${WM00034_1}");$("#cpItemName").focus();return false;}
	if(cpCsrInfo == ""){alert("${WM00041_2}");$("#cpCsrInfo").focus();return false;}
	
	if(cpIdentifier == identifier){ alert("${WM00116_1}"); return;}
	if(confirm("${CM00009}")){		
		var url = "createItem.do";
		var data = "s_itemID=${s_itemID}&option=${option}"
					+"&newClassCode="+$("#cpClassCode").val()
					+"&newIdentifier="+cpIdentifier
					+"&OwnerTeamId="+$("#ownerTeamID").val()
					+"&AuthorID="+$("#AuthorSID").val()
					+"&AuthorName="+$("#AuthorName").val()
					+"&newItemName="+cpItemName
					+"&csrInfo="+cpCsrInfo				
					+"&addYN="
					+"&autoID="+$("#autoID").val()
					+"&preFix="+$("#preFix").val()
					+"&cpItemID="+$("#cpItemID").val()
					+"&refItemID="+$("#cpItemID").val()
					+"&modelID="+$("#modelID").val()
					+"&checkElmts="+$("#checkElmts").val()
					+"&newModelName="+$("#newModelName").val()
					+"&MTCTypeCode="+$("#MTCTypeCode").val()
					+"&ModelTypeCode="+$("#ModelTypeCode").val()
					+"&elmCopyOption=ref"
					+"&mstSTR=Y";
		
		var target = "blankFrame";		
		ajaxPage(url, data, target);
	}
}

$("#modelID").change(function() {
	var modelID = $(this).val();
	if(modelID == ""){return;}
	var itemTypeCode = $("#cpItemTypeCode").val();
	
	var url = "openReferenceModelPop.do?ItemTypeCode="+itemTypeCode+"&modelID="+modelID; 
	var w = 500;
	var h = 400;
	itmInfoPopup(url,w,h);
	
});

function fnSetCopyModelInfo(checkElmts, newModelName, MTCTypeCode,ModelTypeCode){
	$("#checkElmts").val(checkElmts);
	$("#newModelName").val(newModelName);
	$("#MTCTypeCode").val(MTCTypeCode);
	$("#ModelTypeCode").val(ModelTypeCode); 
}

function fnRegisterItem(){
	let url = "registerItem.do";	
	let data = "&s_itemID=${s_itemID}&classCode=${classCode}&fltpCode=${fltpCode}&dimTypeList=${dimTypeList}";	
	let target = "processListDiv";
	ajaxPage(url, data, target);
}

</script>	
<form name="processList" id="processList" action="#" method="post" onsubmit="return false;">
	<div id="processListDiv" class="hidden" style="width:100%;height:100%;">
	<input type="hidden" id="itemID" name="itemID">
	<input type="hidden" id="ItemID" name="ItemID">
	<input type="hidden" id="checkIdentifierID" name="checkIdentifierID">
	<input type="hidden" id="itemDelCheck" name="itemDelCheck" value="N">
	<input type="hidden" id="option" name="option" value="${option}">
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
	<input type="hidden" id="level" name="level" value="${request.level}">
	<input type="hidden" id="Auth" name="Auth" value="${sessionScope.loginInfo.sessionLogintype}">	
	<c:if test="${sessionScope.loginInfo.sessionMlvl eq 'SYS'}">
		<input type="hidden" id="showBlocked" name="showBlocked" value="Y">	
	</c:if>
	<input type="hidden" id="ownerTeamID" name="ownerTeamID" value="${sessionScope.loginInfo.sessionTeamId}">	
	<input type="hidden" id="AuthorSID" name="AuthorSID" value="${sessionScope.loginInfo.sessionUserId}">	
	<input type="hidden" id="AuthorName" name="AuthorName" value="${sessionScope.loginInfo.sessionUserNm}">	
	<input type="hidden" id="fromItemID" name="fromItemID" >
	<input type="hidden" id="items" name="items" >
	<input type="hidden" id="classCodes" name="classCodes" >
	<input type="hidden" id="autoID" name="autoID" >
	<input type="hidden" id="preFix" name="preFix" >
	
	<input type="hidden" id="checkElmts" name="checkElmts" >
	<input type="hidden" id="newModelName" name="newModelName" >
	<input type="hidden" id="MTCTypeCode" name="MTCTypeCode" >
	<input type="hidden" id="ModelTypeCode" name="ModelTypeCode" >
	<div id="subItemListDiv" name="subItemListDiv" style="margin-bottom:5px;">		
        <div class="countList">
              <li class="count">Total  <span id="TOT_CNT"></span></li>
              
              <c:if test="${accMode != 'OPS' }">
	              <li class="pdL55 floatL">
					<select id="searchKey" name="searchKey" style="width:80px;">
						<option value="Name">Name</option>
						<option value="ID" 
							<c:if test="${!empty searchID}">selected="selected"
							</c:if>	
						>ID</option>
					</select>
					<input type="text" id="searchValue1" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;">
					<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="fnReload()" value="Search" style="cursor:pointer;">
					<%-- <input type="image" class="image" onclick="goSearchList();" src="${root}${HTML_IMG_DIR}/btn_search_plus.png" value="Advanced Search" style="cursor:pointer;"> --%>
					</li>
				</c:if>
			<li class="floatR pdR20">	
				<c:if test="${pop != 'pop'}">
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
						<c:if test="${myItem == 'Y'}">
							<c:if test="${blocked != 'Y'}">
								<span class="btn_pack nobg white"><a class="edit" onclick="editCheckedAllItems('Attribute');" title="Attribute"></a></span>
								 <c:choose>
							   		<c:when test="${addOption eq '01'}" >
							   			<span class="btn_pack nobg"><a class="add"onclick="fnRegisterItem()" title="Register Item"></a></span>
							   		</c:when>
							   		<c:otherwise>
							   			<span class="btn_pack nobg"><a class="add"onclick="setSubDiv('addNewItem','addNewItem')" title="Add"></a></span>
							   		</c:otherwise>
						   		</c:choose>
						   		<span class="btn_pack nobg"><a class="list" onclick="editMulitiItemID();" title="Edit ID/Name"></a></span>
							
								<c:if test="${sessionScope.loginInfo.sessionMlvl eq 'SYS'}">
								<span class="btn_pack nobg"><a class="copy" onclick="fnCopyItemInfoOpen();" title="Copy Item"></a></span>
								</c:if>
							</c:if>
							
							<span class="btn_pack nobg"><a class="move" onclick="setSubDiv('MoveItem')" title="Move"></a></span>
							
							<c:if test="${blocked != 'Y'}">
								<c:if test="${sortOption eq '1'  && TreeDataFiltered eq 'N' }" >
								<span class="btn_pack nobg"><a class="updown" onclick="fnUpdateChilidItemOrder()" title="Edit Order"></a></span>
								</c:if>
							</c:if>
							
							<span class="btn_pack nobg"><a class="gov" onclick="editCheckedAllItems('Owner');" title="Ownership"></a></span>
							
							<c:if test="${blocked != 'Y'}">
								<span class="btn_pack nobg white"><a class="del" onclick="deleteItem()" title="Delete"></a></span>
							</c:if>
						</c:if>	
					</c:if>
				</c:if>
        		<span class="btn_pack nobg white"><a class="xls" id="excel" title="Excel"></a></span>
			</li>	
          </div>
		</div>
		<div style="width: 100%;" id="layout"></div>
		<div id="pagination"></div>

		<div id="divTapItemAdd" class="ddoverlap mgB5" style="display: none;">
			<ul>
				<li class="selected" ><a><span>${menu.LN00096}</span></a></li>
			</ul>
		</div>
		<table id="addNewItem" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" style="display: none;">
			<tr>
				<th>${menu.LN00106}</th>
				<th>${menu.LN00028}</th>
				<th>${menu.LN00016}</th>
				<th class="last">${menu.LN00191}</th>
			</tr>
			<tr>
				<td style="width:15%;"><input type="text" class="text" id="newIdentifier" name="newIdentifier" value="" /></td>
				<td><input type="text" class="text" id="newItemName" name="newItemName"  value="" autocomplete="name"> </td>
				<td>
					<select id="newClassCode" name="newClassCode" class="sel" OnChange="fnGetHasDimension(this.value);">
					<option value="">Select</option>
					<c:forEach var="i" items="${classOption}">
						<option value="${i.ItemClassCode}"  >${i.Name}</option>						
					</c:forEach>				
					</select>
				</td>
				<td class="last" style="width:30%">
					<select id="csrInfo" name="csrInfo" class="sel">
					<option value="">Select</option>
					<c:forEach var="i" items="${csrOption}">
						<option value="${i.CODE}">${i.NAME}</option>						
					</c:forEach>				
					</select>
				</td>
			</tr>	
			<tr>
				<th id="dim1" style="visibility:hidden;">Dimension</th>
				<td id="dim2" style="visibility:hidden;"><select id="dimTypeID" name="dimTypeID" class="sel" OnChange="fnGetDimTypeValue(this.value);" ></select></td>
				<td id="dim3" style="visibility:hidden;"><select id="dimTypeValueID" name="dimTypeValueID" class="sel"></select></td>
				<td class="last" align="right">
					<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="newItemInsert()"  type="submit"></span>&nbsp;
					<!-- <span class="btn_pack medium icon"><span class="save"></span><input value="Save and Add" onclick="newItemInsert('Y')"  type="submit"></span>&nbsp; -->
				</td>
			</tr>						
		</table>	
		
		<div id="divTapItemCopy" class="ddoverlap mgB5" style="display: none;">
			<ul>
				<li class="selected" ><a><span>Copy Item</span></a></li>
			</ul>
		</div>
		<table id="copyItem" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" style="display: none;">
			<tr>
				<th>${menu.LN00106}</th>
				<th>${menu.LN00028}</th>
				<th>${menu.LN00191}</th>
				<th>${menu.LN00125}</th>
				<th></th>
			</tr>
			<tr>
				<td style="width:20%;">
					<input type="text" class="text" id="cpIdentifier" name="cpIdentifier" value="" />
					<input type="hidden" id="cpItemID" name="cpItemID" value="" />	
					<input type="hidden" id="cpClassCode" name="cpClassCode" value="" />
					<input type="hidden" id="cpItemTypeCode" name="cpItemTypeCode" value="" />
				</td>
				<td style="width:20%;"><input type="text" class="text" id="cpItemName" name="cpItemName"  value=""/></td>
				<td style="width:20%">
					<select id="cpCsrInfo" name="cpCsrInfo" class="sel">
					<option value="">Select</option>
					<c:forEach var="i" items="${csrOption}">
						<option value="${i.CODE}">${i.NAME}</option>						
					</c:forEach>				
					</select>
				</td>
				<td style="width:20%">
					<select id="modelID" name="modelID" class="sel"></select>
				</td>
				<td align="right" style="width:20%">
					<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnCopyItemInfo()"  type="submit"></span>&nbsp;
				</td>
			</tr>	
						
		</table>		
		<div id="transDiv"></div>
	</div>
	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
	
	
<%@ include file="/WEB-INF/jsp/template/autoCompText.jsp"%>

<script>
$(document).ready(function(){
	autoComplete("newItemName", "AT00001", "${itemTypeCode}", "", "", 5, "top");
});
</script>

<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid;
	var pagination;
	var gridData = ${gridData};
	
	var grid = new dhx.Grid("grid",  {
		columns: [
	    	// No / 0 / 사규번호 / 규정명 / 작성부서 / 담당부서 / 담당자 / 제정일자 / 개정일자 / 개정번호
    	 	{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}", align:"center"}], align:"center"},
	     	{ width: 30, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" }], align: "center", type: "boolean", editable: true, sortable: false, htmlEnable: true},
	        { width: 110, id: "Identifier", header: [{ text: "${menu.ZLN0133}", align:"center" }], align:"center"},
	        { 			  id: "ItemName", header: [{ text: "${menu.ZLN0134}", align:"center" }], htmlEnable: true, align:"left"},	 
	        { width: 200, id: "ManageTeamName", header: [{ text: "${menu.LN01008}", align:"center" }], align:"center"},
	       	{ width: 140, id: "OwnerTeamName", header: [{ text: "${menu.ZLN0074}", align:"center" }], align:"center"},
	        { width: 140, id: "Name", header: [{ text: "${menu.LN00004}", align:"center" }], align:"center" },
	        { width: 100, id: "CreationTime", header: [{ text: "${menu.ZLN0076}", align:"center" }], align:"center"},
	       	{ width: 100, id: "LastUpdated", header: [{ text: "${menu.ZLN0077}", align:"center" }], align:"center"},
	        { width: 100, id: "RevNo", header: [{ text: "${menu.LN00356}", align:"center" }], align:"center"},

	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    multiselection : true   
	    
	});
	
	$("#TOT_CNT").html(grid.data.getLength());
	
	grid.events.on("cellClick", function(row,column,e){
		if(column.id != "checkbox") {
			// doDetail(row.ItemID));
		
			$("#loading").fadeIn(150);
			parent.olm.menuTree.selectItem(row.ItemID,false,false);
			parent.olm.getMenuUrl(String(row.ItemID));
			parent.olm.menuTree.openItem(row.ItemID);
		}
			
	 }); 
	 
	 grid.events.on("filterChange", function(row,column,e,item){
		$("#TOT_CNT").html(grid.data.getLength());
	 });

	 layout.getCell("a").attach(grid);
	 
	 if(pagination){pagination.destructor();}
	 pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});
	
 	function fnReload(){ 
		var sqlID = "zSK_SQL.getRuleSubList";
		var param =  "s_itemID=${s_itemID}"				    
	        + "&searchKey="     + $("#searchKey").val()
	        + "&searchValue="     	+ $("#searchValue1").val()
	        + "&defClassList=${defClassList}"
			+ "&sqlID="+sqlID;
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
 		grid.data.parse(newGridData);
 		fnMasterChk('');
 		$("#TOT_CNT").html(grid.data.getLength());
 	}
 	
</script>