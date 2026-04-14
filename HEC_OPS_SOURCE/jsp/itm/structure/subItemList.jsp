<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/autoCompText.jsp"%>


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
<style>
	.grid_hover {
		background-color:f2f8ff;
		font-size:20px;
	}
</style>

<script>
var tc_gridArea;				//그리드 전역변수
$(document).ready(function(){
	
	// 초기 표시 화면 크기 조정 
	$("#grdChildGridArea").attr("style","height:"+(setWindowHeight() - 355)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#grdChildGridArea").attr("style","height:"+(setWindowHeight() - 355)+"px;");
	};
	
	$("#excel").click(function(){tc_gridArea.toExcel("${root}excelGenerate");});
	
 	var data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
	fnSelect('dimTypeID', data, 'getDimensionTypeID', '', 'Select');	
	gridTcInit();		
	doTcSearchList();
	
	autoComplete("newItemName", "AT00001", "${itemTypeCode}", "", "", 5, "top");

});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

function urlReload() {
	gridTcInit();		
	doTcSearchList();
}


//===============================================================================
// BEGIN ::: GRID
function doTcSearchList(){
	var tcd = setTcGridData();fnLoadDhtmlxGridJson(tc_gridArea, tcd.key, tcd.cols, tcd.data,false,false,"","","selectedTcListRow()");
}

function gridTcInit(){	
	var tcd = setTcGridData();
	tc_gridArea = fnNewInitGrid("grdChildGridArea", tcd);
	//tc_gridArea.enableHeaderImages(true);
	tc_gridArea.setImagePath("${root}${HTML_IMG_DIR}/item/");
	tc_gridArea.setIconPath("${root}${HTML_IMG_DIR}/item/");

	fnSetColType(tc_gridArea, 20, "img");
	fnSetColType(tc_gridArea, 2, "img");
	fnSetColType(tc_gridArea, 1, "ch");
	
	tc_gridArea.enableRowsHover(true,'grid_hover');
	tc_gridArea.enableMultiselect(true);
	
	tc_gridArea.setColumnHidden(10, true);
	tc_gridArea.setColumnHidden(11, true);
	tc_gridArea.setColumnHidden(12, true);
	tc_gridArea.setColumnHidden(14, true);
	tc_gridArea.setColumnHidden(15, true);
	tc_gridArea.setColumnHidden(16, true);
	tc_gridArea.setColumnHidden(17, true);

	tc_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
	tc_gridArea.attachEvent("onCheckbox",fnOnCheck);
}

function fnOnCheck(rowId,cellInd,state){
	if(state){
		tc_gridArea.setRowColor(rowId, "#f2f8ff");
	}else{
		tc_gridArea.setRowColor(rowId, "#ffffff");
	}
}

function setTcGridData(){
	var tcResult = new Object();
	tcResult.title = "${title}";
	tcResult.key = "item_SQL.getSubItemList";
	tcResult.header = "${menu.LN00024},#master_checkbox,${menu.LN00042},${menu.LN00106},${menu.LN00028},${menu.LN00016},${menu.LN00131},${menu.LN00018},${menu.LN00004},${menu.LN00070},${menu.LN00042},SCOUNT,ClassCode,${menu.LN00027},Status,ItemID,AuthorID,Blocked,ItemTypeCode,ChangeMgt,File";
	tcResult.cols = "CHK|ItemTypeImg|Identifier|ItemName|ClassName|PjtName|OwnerTeamName|Name|LastUpdated|GUBUN|SCOUNT|ClassCode|ItemStatusText|Status|ItemID|AuthorID|Blocked|ItemTypeCode|ChangeMgt|FileIcon";
	tcResult.widths = "30,30,30,130,*,100,120,140,140,110,0,0,0,100,0,0,0,0,0,0,40";
	tcResult.sorting = "int,int,str,str,str,str,str,str,str,str,str,int,str,str,str,str,str,str,str,str,str";
	tcResult.aligns = "center,center,center,left,left,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center";
	tcResult.data = "s_itemID=${s_itemID}"
				+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"				
		        + "&option="     + $("#option").val()
		        + "&filterType=${filterType}"
		        + "&TreeDataFiltered=${TreeDataFiltered}"  
		        + "&defDimTypeID=${defDimTypeID}"
		        + "&defDimValueID=${defDimValueID}"      
		        + "&searchKey="     + $("#searchKey").val()
		        + "&searchValue="     	+ $("#searchValue").val()
		        + "&showTOJ=${showTOJ}"
		        +"&showElement=${showElement}";
	return tcResult;
}
function gridOnRowSelect(id, ind){
	if(ind != 1 && ind != 20){
		doDetail(tc_gridArea.cells(id, 15).getValue(), tc_gridArea.cells(id, 12).getValue());
	}
	else if(ind == 20) {
		var fileCheck = tc_gridArea.cells(id,20).getValue();

		if(fileCheck.indexOf("blank.gif") < 1) {
			var url = "selectFilePop.do";
			var data = "?s_itemID="+tc_gridArea.cells(id, 15).getValue(); 
		   
		    var w = "400";
			var h = "350";
		    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");	
		}
	}
	else{
		tranSearchCheck = false;
	}
}
function doDetail(avg1, avg2){
	var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";
	var w = 1200;
	var h = 900;
	itmInfoPopup(url,w,h,avg1);
	
}
// END ::: GRID	
//===============================================================================
function deleteItem(){
	if(tc_gridArea.getCheckedRows(1).length == 0){
		//alert("삭제할 항목을 한개 이상 선택하여 주십시요.");
		alert("${WM00023}");
	}else{
		//if(confirm("선택된 항목를 삭제하시겠습니까?")){
		if(confirm("${CM00004}")){
			var checkedRows = tc_gridArea.getCheckedRows(1).split(",");	
			var items = "";
			
			for(var i = 0 ; i < checkedRows.length; i++) {
				// blocked == 2 인 경우 승인요청 중, 편집 불가 경고창 표시
				var itemStatus = tc_gridArea.cells(checkedRows[i], 14).getValue();
				var blocked = tc_gridArea.cells(checkedRows[i], 17).getValue();
				var changeMgt = tc_gridArea.cells(checkedRows[i], 19).getValue();
				if (blocked != "0") {
					if (itemStatus == "REL") {
						alert(tc_gridArea.cells(checkedRows[i], 4).getValue()+"${WM00121}"); 
					} else {
						alert(tc_gridArea.cells(checkedRows[i], 4).getValue()+"${WM00054}"); 
					}
					tc_gridArea.cells(checkedRows[i], 1).setValue(0); 
				} else if (blocked == "0") {
					if(tc_gridArea.cells(checkedRows[i], 10).getValue() == "O"){						
						alert(tc_gridArea.cells(checkedRows[i], 4).getValue()+" - ${WM00052}"); 
						tc_gridArea.cells(checkedRows[i], 1).setValue(0);
					}else if(changeMgt == "1" && (itemStatus == "MOD1" || itemStatus == "DEL1")){						
						alert(tc_gridArea.cells(checkedRows[i], 4).getValue()+"${WM00046}"); 
						tc_gridArea.cells(checkedRows[i], 1).setValue(0);	
					}else {	
						if(tc_gridArea.cells(checkedRows[i], 11).getValue() != 0){
							// 하위항목이 존재할 경우 삭제 불가
							alert(tc_gridArea.cells(checkedRows[i], 4).getValue()+" - ${WM00024}");
							tc_gridArea.cells(checkedRows[i], 1).setValue(0); 
							
					   } else if (items == "") {
							items = tc_gridArea.cells(checkedRows[i], 15).getValue();
					   } else {
							items = items + "," + tc_gridArea.cells(checkedRows[i], 15).getValue();
					   }
				    }
			  }
			}
			if (items != "") {
				var url = "setItemStatusForDel.do";
				var data = "s_itemID=${s_itemID}&userId=${sessionScope.loginInfo.sessionUserId}&items="+items;
				var target = "blankFrame";
				ajaxPage(url, data, target);
			}
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
		//Item생성시 TeamID가 날아가서 다시 채워줌(왜인지 못찾음)
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
		if(tc_gridArea.getCheckedRows(1).length == 0){
			//alert("이동할 항목을 미리 선택하여 주십시요.");
			alert("${WM00057}");
			return;
		}
		
		var checkedRows = tc_gridArea.getCheckedRows(1).split(",");	
		var items = "";
		
		for(var i = 0 ; i < checkedRows.length; i++ ){	
			if(tc_gridArea.cells(checkedRows[i], 10).getValue() == "O" || tc_gridArea.cells(checkedRows[i], 10).getValue() == "o"){
		
				alert(tc_gridArea.cells(checkedRows[i], 4).getValue()+"${WM00059}");
				tc_gridArea.cells(checkedRows[i], 1).setValue(0);
			} else {
				// 이동 할 ITEMID의 문자열을 셋팅
				if (items == "") {
					items = tc_gridArea.cells(checkedRows[i], 15).getValue();
				} else {
					items = items + "," + tc_gridArea.cells(checkedRows[i], 15).getValue();
				}
			}
		}
		
		if (items != "") {
			$("#addNewItem").attr('style', 'display: none');
			
			$("#divTapItemAdd").attr('style', 'display: none');
			var url = "acrCodeTreePop.do";
			var data = "items=" + items + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${s_itemID}&option=${option}";
			fnOpenLayerPopup(url,data,doCallBackMove,617,436);
		}
	}
}
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
		var data = "s_itemID=${s_itemID}&option=${option}&loginID=${sessionScope.loginInfo.sessionUserId}"
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

var tranSearchCheck = false;
function fnMoveItems(avg, isCheck){
	if(isCheck == "false") {
		//alert("권한이 없는 항목으로는 이동 하지 못합니다.");
		alert("${WM00060}");
		return;
	}
	
	if(tc_gridArea.getCheckedRows(1).length == 0){
		//alert("항목을 한개 이상 선택하여 주십시요.");
		alert("${WM00023}");
		return;
	}else{
		
		if('${s_itemID}'==avg){
			//alert("같은 항목으로는 이동 하지 못합니다."); //arguments
			alert("${WM00055}");
			return;
		}
		//if(confirm("선택된 항목을 구조이동 하시겠습니까?")){
		if(confirm("${CM00040}")){
			
			var checkedRows = tc_gridArea.getCheckedRows(1).split(",");
			var items = "";
			for(var i = 0 ; i < checkedRows.length; i++ ){
				
				if(tc_gridArea.cells(checkedRows[i], 15).getValue() == avg){
					//alert("이동 될 항목중 선택 된 항목이 들어 있습니다.");
					alert("${WM00056}");
					return;
				}
				// blocked == 2 인 경우 승인요청 중, 편집 불가 경고창 표시
				var itemStatus = tc_gridArea.cells(checkedRows[i], 14).getValue();
				var blocked = tc_gridArea.cells(checkedRows[i], 17).getValue();
		
				if (items == "") {
					items = tc_gridArea.cells(checkedRows[i], 15).getValue();
				} else {
					items = items + "," + tc_gridArea.cells(checkedRows[i], 15).getValue();
				}		
			}	
			
			if(items != ""){
				var url = "changeItemParent.do";
				var data = "s_itemID=${s_itemID}&userId=${sessionScope.loginInfo.sessionUserId}&items="+items+"&fromItemID="+avg;
				var target = "blankFrame";
				ajaxPage(url, data, target);
				//tc_gridArea.deleteRow(checkedRows[i]);
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
		
	if(tc_gridArea.getCheckedRows(1).length == 0){
		//alert("항목을 한개 이상 선택하여 주십시요.");
		alert("${WM00023}");
		return;
	}

	var checkedRows = tc_gridArea.getCheckedRows(1).split(",");	
	var items = "";
	var classCodes = "";
	var nowClassCode = "";
	
	for(var i = 0 ; i < checkedRows.length; i++ ){
		// blocked == 2 인 경우 승인요청 중, 편집 불가 경고창 표시
		var itemStatus = tc_gridArea.cells(checkedRows[i], 14).getValue();
		var blocked = tc_gridArea.cells(checkedRows[i], 17).getValue();
		if (blocked != "0" && avg != "Owner") {
			if (itemStatus == "REL") {
				alert(tc_gridArea.cells(checkedRows[i], 4).getValue()+"${WM00124}"); // [변경 요청 안된 상태]
			} else {
				alert(tc_gridArea.cells(checkedRows[i], 4).getValue()+"${WM00123}"); // [승인요청중]
			}
			tc_gridArea.cells(checkedRows[i], 1).setValue(0); 
		} else {
			// 이동 할 ITEMID의 문자열을 셋팅
			if (items == "") {
				items = tc_gridArea.cells(checkedRows[i], 15).getValue();
				classCodes = tc_gridArea.cells(checkedRows[i], 12).getValue();
				nowClassCode = tc_gridArea.cells(checkedRows[i], 12).getValue();
			} else {
				items = items + "," + tc_gridArea.cells(checkedRows[i], 15).getValue();
				if (nowClassCode != tc_gridArea.cells(checkedRows[i], 12).getValue()) {
					classCodes = classCodes + "," + tc_gridArea.cells(checkedRows[i], 12).getValue();
					nowClassCode = tc_gridArea.cells(checkedRows[i], 12).getValue();
				}
			}
		}
		
	}
	
	if (items != "") {
		$("#items").val(items);

		if (avg == "Attribute2") {
			var url = "selectAttributePop.do";
			var data = "items="+items+"&classCodes="+classCodes; 
		    var option = "dialogWidth:400px; dialogHeight:250px;";
		    //window.showModalDialog(url + data , self, option);
		    window.open("", "selectAttribute2", "width=400, height=350, top=100,left=100,toolbar=no,status=no,resizable=yes");
			$("#classCodes").val(classCodes);
		    document.processList.action=url;
		    document.processList.target="selectAttribute2";
		    document.processList.submit();
		    
		}
	
		//if (items != "") {
		else if (avg == "Attribute") {
				var url = "selectAttributePop.do";
				var data = "classCodes="+classCodes+"&items="+items; 
			    var option = "dialogWidth:400px; dialogHeight:250px;";			
			    //window.showModalDialog(url + data , self, option);
			   
			    var w = "400";
				var h = "350";
				$("#classCodes").val(classCodes);
			    window.open("", "selectAttribute", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
			    document.processList.action=url;
			    document.processList.target="selectAttribute";
			    document.processList.submit();
			    
		} else  if (avg == "Owner") {
				/* var url = "selectOwnerPop.do?";
				var data = "items="+items; 
			    var option = "dialogWidth:450px; dialogHeight:370px;";
			    window.showModalDialog(url + data , self, option); */
			    
			    var url = "selectOwnerPop.do"; 
			    var option = "width=480, height=350, left=300, top=300,scrollbar=yes,resizble=0";
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
	var data = "s_itemID=${s_itemID}&menucat=middle&option=${option}&pop=${pop}";
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
	if(tc_gridArea.getCheckedRows(1).length != 1){
		alert("${WM00106}");
		return;
	}
	var checkedRows = tc_gridArea.getCheckedRows(1).split(",");
	var itemID = "";	
	var classCode = "";
	var gubun = "";
	var itemTypeCode = "";
	for(var i = 0 ; i < checkedRows.length; i++ ){
		itemID = tc_gridArea.cells(checkedRows[i], 15).getValue();	
		identifier = tc_gridArea.cells(checkedRows[i], 3).getValue();	
		itemName = tc_gridArea.cells(checkedRows[i], 4).getValue();	
		classCode = tc_gridArea.cells(checkedRows[i], 12).getValue();	
		gubun = tc_gridArea.cells(checkedRows[i], 10).getValue();	
		itemTypeCode = tc_gridArea.cells(checkedRows[i], 18).getValue();	
	}
	
	if(gubun != "M"){
		alert("${WM00046}");
		return;
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
	
}

function fnCopyItemInfo(){
	var cpIdentifier = $("#cpIdentifier").val();
	var cpItemName = $("#cpItemName").val();
	var cpCsrInfo = $("#cpCsrInfo").val();
	
	if(cpItemName == ""){alert("${WM00034_1}");$("#cpItemName").focus();return false;}
	if(cpCsrInfo == ""){alert("${WM00041_2}");$("#cpCsrInfo").focus();return false;}
	
	if(cpIdentifier == identifier){ alert("${WM00116_1}"); return;
	}else if(cpItemName == itemName){ alert("${WM00116_2}"); return; }

	if(confirm("${CM00009}")){		
		var url = "createItem.do";
		var data = "s_itemID=${s_itemID}&option=${option}&loginID=${sessionScope.loginInfo.sessionUserId}"
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
					+"&modelID="+$("#modelID").val()
					+"&checkElmts="+$("#checkElmts").val()
					+"&newModelName="+$("#newModelName").val()
					+"&MTCTypeCode="+$("#MTCTypeCode").val()
					+"&ModelTypeCode="+$("#ModelTypeCode").val()
					+"&modelGUGUN=insertRefModel&mstSTR=Y";
		
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
	<input type="hidden" id="showTOJ" name="showTOJ"  value="N">
	
	<div style="overflow:auto;margin-bottom:5px;overflow-x:hidden;">		
        <div class="countList">
              <li class="count">Total  <span id="TOT_CNT"></span></li>
              <li class="pdL55 floatL">
				<select id="searchKey" name="searchKey">
					<option value="Name">Name</option>
					<option value="ID" 
						<c:if test="${!empty searchID}">selected="selected"
						</c:if>	
					>ID</option>
				</select>
				<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;">
				<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doTcSearchList()" value="Search" style="cursor:pointer;">
				<input type="image" class="image" onclick="goSearchList();" src="${root}${HTML_IMG_DIR}/btn_search_plus.png" value="Advanced Search" style="cursor:pointer;">
				
			</li>
			<li class="floatR pdR20">
				<c:if test="${pop != 'pop'}">
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
						<c:if test="${myItem == 'Y'}">
								<c:if test="${blocked != 'Y'}">
								&nbsp;<span class="btn_pack nobg"><a class="add"onclick="setSubDiv('addNewItem','addNewItem')" title="Add"></a></span>
								<c:if test="${sessionScope.loginInfo.sessionMlvl eq 'SYS'}">
								<span class="btn_pack nobg"><a class="copy" onclick="fnCopyItemInfoOpen();" title="Copy Item"></a></span>
								</c:if>								
								&nbsp;<span class="btn_pack nobg"><a class="list" onclick="editMulitiItemID();" title="Edit ID/Name"></a></span>
								&nbsp;<span class="btn_pack nobg"><a class="edit" onclick="editCheckedAllItems('Attribute');" title="Attribute"></a></span>
								
								</c:if>
								&nbsp;<span class="btn_pack nobg"><a class="move" onclick="setSubDiv('MoveItem')" title="Move"></a></span>
								<c:if test="${sortOption eq '1'  && TreeDataFiltered eq 'N' }" >
								&nbsp;<span class="btn_pack nobg"><a class="updown" onclick="fnUpdateChilidItemOrder()" title="Edit Order"></a></span>
								</c:if>
								&nbsp;<span class="btn_pack nobg"><a class="gov" onclick="editCheckedAllItems('Owner');" title="Gov"></a></span>
								<c:if test="${blocked != 'Y'}">
								&nbsp;<span class="btn_pack nobg"><a class="del" onclick="deleteItem()" title="Del"></a></span>
								</c:if>
								
						</c:if>	
					</c:if>
				</c:if>
        		&nbsp;<span class="btn_pack nobg"><a class="xls" id="excel" title="Down"></a></span>
			</li>	
          </div>
		<div id="gridDiv" class="mgB10 clear">
			<div id="grdChildGridArea" style="width:100%"></div>
		</div>
		</div>

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
					<span class="btn_pack medium icon"><span class="save"></span><input value="Save and Add" onclick="newItemInsert('Y')"  type="submit"></span>&nbsp;
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