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

<style>
	.dhx_grid-row  {
	    cursor: pointer;
	}
</style>

<script>

$(document).ready(function(){
	
	// 초기 표시 화면 크기 조정 
	$("#gridArea").attr("style","height:"+(setWindowHeight() - 340)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#gridArea").attr("style","height:"+(setWindowHeight() - 340)+"px;");
	};
	
	$("#excel").click(function(){ fnGridExcelDownLoad(); });

 	var data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
	fnSelect('dimTypeID', data, 'getDimensionTypeID', '', 'Select');	
	doTcSearchList();
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

function doTcSearchList(){
	var currentGridData = setTcGridData();
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

function urlReload() {		
	doTcSearchList();
}

function thisReload() {		
	doTcSearchList();
}


//===============================================================================
// BEGIN ::: GRID

function setTcGridData(){
	var tcResult = new Object();
	tcResult.title = "${title}";
	tcResult.key = "item_SQL.getItemCompositionList";
	tcResult.header = "${menu.LN00024},#master_checkbox,${menu.LN00042},Code,Type,Object ${menu.LN00106},${menu.LN00028},${menu.LN00018},${menu.LN00004},${menu.LN00070},${menu.LN00042},SCOUNT,ClassCode,${menu.LN00027},Status,ItemID,AuthorID,Blocked,CXNItemID";
	tcResult.cols = "CHK|ItemTypeImg|Identifier|ClassName|HrcyNo|ItemName|OwnerTeamName|Name|LastUpdated|GUBUN|SCOUNT|ClassCode|StatusName|Status|ItemID|AuthorID|Blocked|CXNItemID";
	tcResult.widths = "30,30,30,80,80,80,*,120,80,80,0,0,0,80,0,0,0,0";
	tcResult.sorting = "int,int,str,str,str,str,str,str,str,str,str,int,str,str,str,str,str,str";
	tcResult.aligns = "center,center,center,center,center,center,left,left,center,center,center,center,center, center,center,center";
	tcResult.data = "s_itemID=${s_itemID}"
				+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
		        + "&option="     + $("#option").val()
		        + "&filterType=${filterType}"
		        + "&subItemTypeList=${subItemTypeList}"
		        + "&TreeDataFiltered=${TreeDataFiltered}"        
		        + "&searchKey="     + $("#searchKey").val()
		        + "&searchValue="     	+ $("#searchValue").val();
	return tcResult;
}
// function gridOnRowSelect(id, ind){if(ind != 1){doDetail(tc_gridArea.cells(id, 15).getValue(), tc_gridArea.cells(id, 12).getValue());}else{tranSearchCheck = false;}}


// END ::: GRID	
//===============================================================================
function fnDeleteCxnItem(){
	
	var checkedRows = grid.data.findAll(function (data){
		return data.checkbox
	});
	
	
	console.log(checkedRows);
	
	if(checkedRows.length == 0){
		alert("${WM00023}");
	}else{
		//if(confirm("선택된 항목를 삭제하시겠습니까?")){
		if(confirm("${CM00004}")){
			var items = "";
			for(var i = 0 ; i < checkedRows.length; i++) {
				if (items == "") {
					items = checkedRows[i].ItemID;
				} else {
					items = items + "," + checkedRows[i].ItemID;
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

function setSubDiv(avg, avg2){	
	$("#"+avg2).attr('style', 'display: none');
	$("#"+avg).removeAttr('style', 'display: none');	
	if(avg == 'addNewItem'){

		$("#ownerTeamID").val('${sessionScope.loginInfo.sessionTeamId}');		
		$("#addNewItem").removeAttr('style', 'display: none');
		
		$("#divTapItemAdd").removeAttr('style', 'display: none');
		$("#transDiv").attr('style', 'display: none');
		$("#moveOrg").attr('style', 'display: none');		
		$("#newIdentifier").focus();
		
		var data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('dimTypeID', data, 'getDimensionTypeID', '', 'Select');	
		fnSelect('dimTypeValueID', data, 'getDimTypeValueId', '', 'Select');		
	}
}

function doCallBackMove(){}
function doCallBackRef(){doPPSearchList();}
function newItemInsert(){
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
					+"&dimTypeValueID="+$("#dimTypeValueID").val();
		var target = "blankFrame";		
		ajaxPage(url, data, target);
	}
}
function reloadTcSearchList(s_itemID){doTcSearchList();$('#itemID').val(s_itemID);}
// function selectedTcListRow(){	
// 	var s_itemID = $('#itemID').val();$('#itemID').val("");
// 	if(s_itemID != ""){tc_gridArea.forEachRow(function(id){ if(s_itemID == tc_gridArea.cells(id, 14).getValue()){tc_gridArea.selectRow(id-1);}
// 	});}
// }

function doReturnInsert(){ 	
	setTimeout(function() {urlReload();}, 2000);
	$("#newClassCode").val("");$("#newIdentifier").val("");
	$("#ownerTeamID").val("");$("#newItemName").val("");
	$("#addNewItem").attr('style', 'display: none');	
	$("#divTapItemAdd").attr('style', 'display: none');
}

var tranSearchCheck = false;
// function fnMoveItems(avg, isCheck){
// 	if(isCheck == "false") {
// 		//alert("권한이 없는 항목으로는 이동 하지 못합니다.");
// 		alert("${WM00060}");
// 		return;
// 	}
	
// 	if(tc_gridArea.getCheckedRows(1).length == 0){
// 		//alert("항목을 한개 이상 선택하여 주십시요.");
// 		alert("${WM00023}");
// 		return;
// 	}else{
		
// 		if('${s_itemID}'==avg){
// 			//alert("같은 항목으로는 이동 하지 못합니다."); //arguments
// 			alert("${WM00055}");
// 			return;
// 		}
// 		//if(confirm("선택된 항목을 구조이동 하시겠습니까?")){
// 		if(confirm("${CM00040}")){
			
// 			var checkedRows = tc_gridArea.getCheckedRows(1).split(",");
// 			var items = "";
// 			for(var i = 0 ; i < checkedRows.length; i++ ){
				
// 				if(tc_gridArea.cells(checkedRows[i], 15).getValue() == avg){
// 					//alert("이동 될 항목중 선택 된 항목이 들어 있습니다.");
// 					alert("${WM00056}");
// 					return;
// 				}
// 				// blocked == 2 인 경우 승인요청 중, 편집 불가 경고창 표시
// 				var itemStatus = tc_gridArea.cells(checkedRows[i], 14).getValue();
// 				var blocked = tc_gridArea.cells(checkedRows[i], 17).getValue();
		
// 				if (items == "") {
// 					items = tc_gridArea.cells(checkedRows[i], 15).getValue();
// 				} else {
// 					items = items + "," + tc_gridArea.cells(checkedRows[i], 15).getValue();
// 				}		
// 			}	
			
// 			if(items != ""){
// 				var url = "changeItemParent.do";
// 				var data = "s_itemID=${s_itemID}&userId=${sessionScope.loginInfo.sessionUserId}&items="+items+"&fromItemID="+avg;
// 				var target = "blankFrame";
// 				ajaxPage(url, data, target);
// 				//tc_gridArea.deleteRow(checkedRows[i]);
// 			}
// 			$(".popup_div").hide();
// 			$("#mask").hide();
// 		}		
// 	}
// }

/** [Owner][Attribute] 버튼 이벤트 */
 
function editMulitiItemID(){
    var url = "editCxnItemIDNamePop.do"; 
    var option = "width=550, height=570, left=100, top=100,scrollbar=yes,resizble=0";
    window.open("", "SelectOwner", option);
    document.processList.action=url;
    document.processList.target="SelectOwner";
    document.processList.submit();
}

// 안쓰이는 함수임
// function editCheckedAllItems(avg){	
		
// 	if(tc_gridArea.getCheckedRows(1).length == 0){
// 		//alert("항목을 한개 이상 선택하여 주십시요.");
// 		alert("${WM00023}");
// 		return;
// 	}

// 	var checkedRows = tc_gridArea.getCheckedRows(1).split(",");	
// 	var items = "";
// 	var classCodes = "";
// 	var nowClassCode = "";
	
// 	for(var i = 0 ; i < checkedRows.length; i++ ){
// 		// blocked == 2 인 경우 승인요청 중, 편집 불가 경고창 표시
// 		var itemStatus = tc_gridArea.cells(checkedRows[i], 14).getValue();
// 		var blocked = tc_gridArea.cells(checkedRows[i], 17).getValue();
// 		if (blocked != "0" && avg != "Owner") {
// 			if (itemStatus == "REL") {
// 				alert(tc_gridArea.cells(checkedRows[i], 4).getValue()+"${WM00124}"); // [변경 요청 안된 상태]
// 			} else {
// 				alert(tc_gridArea.cells(checkedRows[i], 4).getValue()+"${WM00123}"); // [승인요청중]
// 			}
// 			tc_gridArea.cells(checkedRows[i], 1).setValue(0); 
// 		} else {
// 			// 이동 할 ITEMID의 문자열을 셋팅
// 			if (items == "") {
// 				items = tc_gridArea.cells(checkedRows[i], 15).getValue();
// 				classCodes = tc_gridArea.cells(checkedRows[i], 12).getValue();
// 				nowClassCode = tc_gridArea.cells(checkedRows[i], 12).getValue();
// 			} else {
// 				items = items + "," + tc_gridArea.cells(checkedRows[i], 15).getValue();
// 				if (nowClassCode != tc_gridArea.cells(checkedRows[i], 12).getValue()) {
// 					classCodes = classCodes + "," + tc_gridArea.cells(checkedRows[i], 12).getValue();
// 					nowClassCode = tc_gridArea.cells(checkedRows[i], 12).getValue();
// 				}
// 			}
// 		}
		
// 	}
	
// 	if (items != "") {
// 		$("#items").val(items);

// 		if (avg == "Attribute2") {
// 			var url = "selectAttributePop.do";
// 			var data = "items="+items+"&classCodes="+classCodes; 
// 		    var option = "dialogWidth:400px; dialogHeight:250px;";
// 		    //window.showModalDialog(url + data , self, option);
// 		    window.open("", "selectAttribute2", "width=400, height=350, top=100,left=100,toolbar=no,status=no,resizable=yes");
// 			$("#classCodes").val(classCodes);
// 		    document.processList.action=url;
// 		    document.processList.target="selectAttribute2";
// 		    document.processList.submit();
		    
// 		}
	
// 		//if (items != "") {
// 		else if (avg == "Attribute") {
// 				var url = "selectAttributePop.do";
// 				var data = "classCodes="+classCodes+"&items="+items; 
// 			    var option = "dialogWidth:400px; dialogHeight:250px;";			
// 			    //window.showModalDialog(url + data , self, option);
			   
// 			    var w = "400";
// 				var h = "350";
// 				$("#classCodes").val(classCodes);
// 			    window.open("", "selectAttribute", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
// 			    document.processList.action=url;
// 			    document.processList.target="selectAttribute";
// 			    document.processList.submit();
			    
// 		} else  if (avg == "Owner") {				
			    
// 			    var url = "selectOwnerPop.do"; 
// 			    var option = "width=480, height=350, left=300, top=300,scrollbar=yes,resizble=0";
// 			    window.open("", "SelectOwner", option);
// 			    document.processList.action=url;
// 			    document.processList.target="SelectOwner";
// 			    document.processList.submit();
			    
// 		} 
// 	 }
	
// }


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

// function fnSetDimension(hasDimension){ 
// 	if(hasDimension == "1"){
// 		$("#dim1").attr('style', 'visibility:visible;');
// 		$("#dim2").attr('style', 'visibility:visible;');
// 		$("#dim3").attr('style', 'visibility:visible;');
// 		var data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
// 		fnSelect('dimTypeID', data, 'getDimensionTypeID', '', 'Select');	
// 		fnSelect('dimTypeValueID', data, 'getDimTypeValueId', '', 'Select');			
// 	}else{
// 		$("#dim1").attr('style', 'visibility:hidden');
// 		$("#dim2").attr('style', 'visibility:hidden');
// 		$("#dim3").attr('style', 'visibility:hidden');
// 	}
// }

//[Assign] click 이벤트	
function assignItem(){
	if ("${selectedItemBlocked}" == "0") {
		$("#newItemArea").attr("style", "display:none;");
		$("#relatedItemList").attr("style","height:"+(setWindowHeight() - 90)+"px;");
		
	
		var url = "itemTypeCodeTreePop.do";
		var data = "openMode=assign&ItemTypeCode=${ItemTypeCode}&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&s_itemID=${s_itemID}"
					+"&varFilter=${varFilter}&connectionType=From";

		fnOpenLayerPopup(url,data,doCallBackMove,617,436);
	} else {
		if ("${selectedItemStatus}" == "REL") {
			alert("${WM00120}"); // [변경 요청 안된 상태]
		} else {
			alert("${WM00050}"); // [승인요청중]
		}
	}
}

//After [Assign -> Assign]
// function setCheckedItems(checkedItems){

// 	var url = "createCxnItem.do";
// 	var data = "s_itemID=${s_itemID}&cxnItemType=${cxnItemTypeCode}&connectionType=From"
// 				+ "&cxnClassCode=NL00000&categoryCode=ST2&items="+checkedItems;
// 	var target = "blankFrame";
	
// 	ajaxPage(url, data, target);	
	
// 	$(".popup_div").hide();
// 	$("#mask").hide();	
// }

function fnUpdateItemSortNum(){
	var sqlKey = "item_SQL.getItemCompositionList";
	var url = "childItemOrderList.do?s_itemID=${s_itemID}&sqlKey="+sqlKey;
	var w = 500;
	var h = 500;
	window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
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
	
	<div style="overflow:auto;margin-bottom:5px;overflow-x:hidden;">	
		<div class="child_search">
			<li class="pdL55">
				<select id="searchKey" name="searchKey">
					<option value="Name">Name</option>
					<option value="ID" 
						<c:if test="${!empty searchID}">selected="selected"
						</c:if>	
					>ID</option>
				</select>
				<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;">
				<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doTcSearchList()" value="Search" style="cursor:pointer;">
				
			</li>
			<li class="floatR pdR20">
				<c:if test="${pop != 'pop'}">
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
						<c:if test="${myItem == 'Y'}">
								<c:if test="${blocked != 'Y'}">
								&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="setSubDiv('addNewItem')"></span>
								</c:if>
								&nbsp;<span class="btn_pack small icon"><span class="assign"></span><input value="Assign" type="submit" onclick="assignItem();"></span>
								&nbsp;<span class="btn_pack small icon"><span class="edit"></span><input value="Edit ID/Name" type="submit" onclick="editMulitiItemID();"></span>
								&nbsp;<span class="btn_pack small icon"><span class="updown"></span><input value="Edit Order" type="submit" onclick="fnUpdateItemSortNum();"></span>
								&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDeleteCxnItem();"></span>
						</c:if>	
					</c:if>
				</c:if>
        		<!-- &nbsp;<span class="btn_pack nobg"><a class="xls" id="excel" title="Down"></a></span> -->
			</li>			
		</div>
		  
        <div class="countList">
              <li class="count">Total  <span id="TOT_CNT"></span></li>
              <li class="floatR">&nbsp;</li>
          </div>
		<div id="gridDiv" class="mgB10 clear">
			<div id="gridArea" style="width:100%"></div>
		</div>
		</div>

		<div id="divTapItemAdd" class="ddoverlap mgB5" style="display: none;">
			<ul>
				<li class="selected" ><a><span>${menu.LN00096}</span></a></li>
			</ul>
		</div>
		<table id="addNewItem" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" style="display: none;">
			<tr>
				<th>${menu.LN00015}</th>
				<th>${menu.LN00028}</th>
				<th>${menu.LN00016}</th>
				<th class="last">CSR</th>
			</tr>
			<tr>
				<td style="width:15%"><input type="text" class="text" id="newIdentifier" name="newIdentifier"  value=""/></td>
				<td><input type="text" class="text" id="newItemName" name="newItemName"  value=""/></td>
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
				<td class="last" align="right"><span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="newItemInsert()"  type="submit"></span></td>
			</tr>						
		</table>		
		<div id="transDiv"></div>
	</div>
	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
	
<script>

var gridAreaLayout = new dhx.Layout("gridArea", {
	rows: [ { id: "a" } ] });

var grid = new dhx.Grid(null, {
    columns: [
        { width: 40, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center", htmlEnable: true}], align: "center", type: "boolean", editable: true, sortable: false},
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
        { width: 80, id: "Identifier", header: [{ text: "${menu.LN00106}", align:"center" },]},
        { width: 120, id: "ClassName", header: [{ text: "${menu.LN00016}", align:"center" },], align: "center" },
        { id: "ItemName", header: [{ text: "${menu.LN00028}", align:"center" }] },
        { width: 120, id: "OwnerTeamName", header: [{ text: "${menu.LN00018}", align:"center" }], align: "center" },
        { width: 100, id: "Name", header: [{ text: "${menu.LN00004}", align:"center" }], align: "center" },
        { width: 90, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align:"center" }], align: "center" },
        { width: 90, id: "StatusName", header: [{ text: "${menu.LN00027}", align:"center" }], align: "center" }
        ],
    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false
});

gridAreaLayout.getCell("a").attach(grid);

function doDetail(avg1, avg2){
	var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";
	var w = 1200;
	var h = 900;
	itmInfoPopup(url,w,h,avg1);
}

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

</script>