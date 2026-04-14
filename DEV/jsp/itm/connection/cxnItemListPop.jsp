<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>


<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00114" var="WM00114"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00016}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="${menu.LN00043}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/>

<script>
var chkReadOnly = true;
var selectedItemBlocked = "${selectedItemBlocked}";
var selectedItemStatus = "${selectedItemStatus}";

$(document).ready(function(){
	$("#newItemArea").attr("style", "display:none;");
	// 초기 표시 화면 크기 조정 
	$("#relatedItemList").attr("style","height:"+(setWindowHeight() - 95)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#relatedItemList").attr("style","height:"+(setWindowHeight() - 95)+"px;");
	};
	
	// message 설정
	var msg = " * " + "${WM00114}";
	$("#msgArea").text(msg);
	
	// Total cnt 설정
	$("#TOT_CNT").text("${cnt}");
	
	// 속성창 열고 닫힘 상태를 재현
	if ("${attrDisplay}" != "") {
		var attrDisplay = "${attrDisplay}";
		var array = attrDisplay.split(",");
		var j = 1;
		for(var i = 0 ; i < array.length; i++ ){
			$(".attr" + j).css("display", array[i]);
			if (array[i] == "none") {
				$(".plus" + j).css("display", "table-cell");
				$(".minus" + j).css("display", "none");
			} else {
				$(".plus" + j).css("display", "none");
				$(".minus" + j).css("display", "table-cell");
			}
			j++;
		}
	}
	
	fnControlBtn("${addBtnYN}");

});


function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
// [Assign] click 이벤트	
function assignItem(){
	if (selectedItemBlocked == "0") {
		$("#newItemArea").attr("style", "display:none;");
		$("#relatedItemList").attr("style","height:"+(setWindowHeight() - 90)+"px;");
		
		var connectionType = "To";
		if ("${isFromItem}" == "N") {
			connectionType = "From";
		}
		var url = "itemTypeCodeTreePop.do";
		var data = "openMode=assign&ItemTypeCode=${ItemTypeCode}&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&s_itemID=${s_itemID}&option=AR000000"
					+"&varFilter=${varFilter}&connectionType=" + connectionType;
		fnOpenLayerPopup(url,data,doCallBack,617,436);
	} else {
		if (selectedItemStatus == "REL") {
			alert("${WM00120}"); // [변경 요청 안된 상태]
		} else {
			alert("${WM00050}"); // [승인요청중]
		}
	}
}

function doCallBack(){}

// [Assign popup] Close 이벤트
function doPPSearchList(){
	$(".popup_div").hide();
	$("#mask").hide();
}

// [Assign][Del] 이벤트 후 Reload
function thisReload(addBtnYN){
	var attrDisplay = setAttrDisplay();
	var url = "itemConnection.do";
	var target = "actFrame";
	var data = "s_itemID=${s_itemID}&varFilter=${varFilter},"+addBtnYN+ "&attrDisplay="+attrDisplay;
	
 	ajaxPage(url, data, target);
}

//속성창 열고 닫힘 상태를 취득
function setAttrDisplay() {
	var listCnt = "${cnt + 1}";
	var checkObj = document.all("delCheck");
	var attrDisplay = "";
	var j = 0;
	if (listCnt > 2) {
		if (listCnt == 2) {
			attrDisplay = $(".attr1").css("display");
		} else {
			for(var i = 1 ; i < listCnt; i++ ){
				j = i - 1;
				if ($("#isDel").val() == "Y") {
					if (!checkObj[j].checked) {
						if (i == 1) {
							attrDisplay = $(".attr" + i).css("display");
						} else {
							attrDisplay = attrDisplay + "," +$(".attr" + i).css("display");
						}
					}
				} else {
					if (i == 1) {
						attrDisplay = $(".attr" + i).css("display");
					} else {
						attrDisplay = attrDisplay + "," +$(".attr" + i).css("display");
					}
				}
			}
		}
	}
	return attrDisplay;
}

//[Edit] click 이벤트
function goItemInfoEdit(id) {
	$("#newItemArea").attr("style", "display:none;");
	$("#relatedItemList").attr("style","height:"+(setWindowHeight() - 90)+"px;");
	var url = "editAttrPop.do?";
	var data = "s_itemID=" + id + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"; 
    var option = "dialogWidth:940px; dialogHeight:500px;";
    window.showModalDialog(url + data , self, option);
}

//[Add] click 이벤트
function addRelItem() {
	if (selectedItemBlocked == "0") {
		$("#relatedItemList").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		$("#newItemArea").attr("style", "display:block;");
	} else {
		if (selectedItemStatus == "REL") {
			alert("${WM00120}"); // [변경 요청 안된 상태]
		} else {
			alert("${WM00050}"); // [승인요청중]
		}
	}
    
}

function urlReload(addBtnYN) {
	thisReload(addBtnYN);
}

function fnControlBtn(addBtnYN){
	if(addBtnYN == "Y"){
		$("#addBtn").attr("style", "display:done;");
	}else{
		$("#addBtn").attr("style", "display:none;");
	}
}

//[Del] click 이벤트	
function relItemDel(){
	if (selectedItemBlocked == "0") {
		$("#newItemArea").attr("style", "display:none;");
		$("#relatedItemList").attr("style","height:"+(setWindowHeight() - 90)+"px;");
		
		var checkObj = document.all("delCheck");
		var j = 0;
		var items = "";
		var value = new Array();

		if (checkObj.length == undefined) {
			if (checkObj.checked) {				
				value = checkObj.value.split("_");
				items = value[0];
				j++;
			}
		};
		for (var i = 0; i < checkObj.length; i++) {
			if (checkObj[i].checked) {
				value = checkObj[i].value.split("_");
				
				if (items == "") {
					items = value[0];
				} else {
					items = items + "," + value[0];
				}
				j++;
			}
		}
		
		if(j==0){
			alert("${WM00023}");
			return;
		}
		if (confirm("${CM00004}")) {
			var url = "DELCNItems.do"; 
			var data = "isOrg=Y&s_itemID=${s_itemID}&items="+items;
			var target = "blankFrame";
			ajaxPage(url, data, target);
		}
	} else {
		if (selectedItemStatus == "REL") {
			alert("${WM00120}"); // [변경 요청 안된 상태]
		} else {
			alert("${WM00050}"); // [승인요청중]
		}
	}
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

function setOtherAttrArea(avg) {
	var listMaxNum = "${relatedItemList.size()}";
	for(var i = 0 ; i < listMaxNum; i++){
		var index = i + 1;
		if(index != avg){
			$(".attr" + index).css("display", "none");
			$(".plus" + index).css("display", "table-cell");
			$(".minus" + index).css("display", "none");
		}
	}
}

// [항목조회]
function goItemPopUp(itemId) {
	var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId+"&scrnType=pop";
	var w = 1200;
	var h = 900;
	itmInfoPopup(url,w,h,itemId);
}	

//==============================================================================================
/* 신규항목 생성 관련 이벤트 */
/*
function searchPopup(url){window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');}
function setSearchName(memberID,memberName){$('#AuthorSID').val(memberID);$('#AuthorName').val(memberName);}
function setSearchTeam(teamID,teamName){$('#ownerTeamID').val(teamID);$('#teamName').val(teamName);}
*/

//[save] 이벤트
function newItemInsert() {
	if($("#newItemName").val() == ""){alert("${WM00034_1}");$("#newItemName").focus();return false;}
	if($("#newClassCode").val() == ""){alert("${WM00034_2}");$("#newClassCode").focus();return false;}
	if($("#parentItemPath").val() == ""){alert("${WM00034_3}");$("#parentItemPath").focus();return false;}
		
	if(confirm("${CM00009}")){		
		var url = "newItemInsertAndAssign.do";
		var data = "s_itemID=${s_itemID}&option=${option}"
					+"&CNItemTypeCode=${varFilter}&isFromItem=${isFromItem}"
					+"&newClassCode="+$("#newClassCode").val()
					+"&newIdentifier="+replaceText($("#newIdentifier").val())
					+"&OwnerTeamId="+$("#ownerTeamID").val()
					+"&AuthorID="+$("#AuthorSID").val()
					+"&newItemName="+replaceText($("#newItemName").val())
					+"&parentItemId="+$("#parentItemId").val()
					+"&addBtnYN=${addBtnYN}"
					+"&autoID="+$("#autoID").val()
					+"&preFix="+$("#preFix").val();
					
		var target = "blankFrame";		
		ajaxPage(url, data, target);
	}
}

function replaceText(avg) {
	var text = "<and>";
	return avg.replace(/&/gi, text);
}

// 신규 생성  할 항목의 부모 아이템을 선택 할 popup창을 표시
function itemTypeCodeTreePop() {
	var url = "itemTypeCodeTreePop.do";
	var data = "openMode=add&ItemTypeCode=${ItemTypeCode}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${s_itemID}&option=${option}";
	fnOpenLayerPopup(url,data,doCallBack,617,436);
}

// After [Add -> Assign]
function setParentItem(parentItemId, parentItemPath){
	$("#parentItemId").val(parentItemId);
	$("#parentItemPath").val(parentItemPath);
	
	$(".popup_div").hide();
	$("#mask").hide();	
}

//After [Assign -> Assign]
function setCheckedItems(checkedItems){
	var connectionType = "From";
	if ("${isFromItem}" == "N") {
		connectionType = "To";
	}
	var url = "createCxnItem.do";
	var data = "s_itemID=${s_itemID}&loginID=${sessionScope.loginInfo.sessionUserId}&connectionType="+connectionType+"&items="+checkedItems;
	var target = "blankFrame";
	
	ajaxPage(url, data, target);	
	
	$(".popup_div").hide();
	$("#mask").hide();	
}

function fnGetHasDimension(classCode){ 
	var url = "getHasDimension.do";
	var data = "itemClassCode="+classCode;
	var target = "blankFrame";
	ajaxPage(url, data, target);
}

function fnSetDimension(hasDimension, autoID, preFix){ 
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

	function fnEditAttr(){
		var checkObj = document.getElementsByName("delCheck");
		var j = 0;
		var items = new Array();
		var classCodes = new Array();

		var idx = 0;
		for (var i = 0; i < checkObj.length; i++) {
			console.log("checkObj[i].checked :"+checkObj[i].checked);
			if (checkObj[i].checked) {
				
				value = checkObj[i].value.split("_");
				items[idx] = value[1];
				classCodes[idx] = value[2];
				idx++;
			}
		}
				
		if(items.length == 0){
			alert("${WM00023}");
			return;
		}
		
		var url = "selectAttributePop.do";
				
		var data = "classCodes="+classCodes+"&items="+items;
		var option = "dialogWidth:400px; dialogHeight:250px;";		
		var w = "400";
		var h = "350";
		$("#items").val(items);
		$("#classCodes").val(classCodes);
		window.open("", "selectAttribute", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		document.relatedItemList.action=url;
		document.relatedItemList.target="selectAttribute";
		document.relatedItemList.submit();
	}
	
	function fnCheckAll(){
		var checkObj = document.all("checkAll");				
		<c:forEach var="itemList" items="${relatedItemList}" varStatus="status">
		if(checkObj.checked == true){
			if("${isFromItem}" == "N"){
				$("#${itemList.RelItemID}_${itemList.CnItemID}_${itemList.ClassCode}").attr('checked',true);
			}else if("${isFromItem}" != "N"){
				$("${itemList.PrcItemID}_${itemList.CnItemID}_${itemList.ClassCode}").attr('checked',true);
			}
		}else{
			if("${isFromItem}" == "N"){
				$("#${itemList.RelItemID}_${itemList.CnItemID}_${itemList.ClassCode}").attr('checked',false);
			}else if("${isFromItem}" != "N"){
				$("${itemList.PrcItemID}_${itemList.CnItemID}_${itemList.ClassCode}").attr('checked',false);
			}
		}
		</c:forEach>
	}
	
	function fnOpenLink(itemID,url,lovCode,attrTypeCode){
		var url = url+".do?itemID="+itemID+"&lovCode="+lovCode+"&attrTypeCode="+attrTypeCode;
	
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h);
	}	

</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<form name="relatedItemList" id="relatedItemList" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
	<input type="hidden" id="varFilter" name="varFilter" value="${varFilter}">	
	<input type="hidden" id="ownerTeamID" name="ownerTeamID" value="${sessionScope.loginInfo.sessionTeamId}">	
	<input type="hidden" id="AuthorSID" name="AuthorSID" value="${sessionScope.loginInfo.sessionUserId}">
	<input type="hidden" id="AuthorName" name="AuthorName" value="${sessionScope.loginInfo.sessionUserNm}">	
	<input type="hidden" id="parentItemId" name="parentItemId" value="${sessionScope.loginInfo.sessionUserId}">	
	<input type="hidden" id="autoID" name="autoID">	
	<input type="hidden" id="preFix" name="preFix">	
	<input type="hidden" id="items" name="items" >
	<input type="hidden" id="classCodes" name="classCodes" >
	<div id="relatedItemArea" style="height:100%;width:100%;overflow:auto; overflow-x:hidden; padding:0;">	
<%-- 	<div class="child_search01" >
		<li class="floatR pdR20">
			<c:if test="${myItem == 'Y'}">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
					<span class="btn_pack nobg"><a class="relationship" onclick="fnEditAttr();" title="Relationship"></a></span>
					<span class="btn_pack nobg"><a class="add" onclick="addRelItem();" title="Add"></a></span>
					<span class="btn_pack nobg"><a class="assign" onclick="assignItem();" title="Assign"></a></span>
				    <span class="btn_pack nobg white"><a class="del" onclick="relItemDel();" title="Delete"></a></span>
				</c:if>	
			</c:if>		
		</li>
	</div> --%>
		<!-- BIGIN :: LIST -->
		<c:if test="${relatedItemList.size() > 0}">
		
		<div class="countList">
		    <li class="count">Total <span id="TOT_CNT"> </span>
		    <c:if test="${identifier ne '' }">
		    	&nbsp;&nbsp; - &nbsp;&nbsp; ${identifier}&nbsp;${l5Name}&nbsp;(${cxnCodeName})
		    </c:if>
		    <!-- &nbsp;&nbsp;<input type="checkbox" name="checkAll" onClick="fnCheckAll();" style="vertical-align:top;"> -->
		    </li>
		    <li class="floatR">&nbsp;</li>
    	</div>
    
		<c:forEach var="itemList" items="${relatedItemList}" varStatus="status">
			<div id="Item${itemList.RNUM}" class="orgcont">
				<div class="org">
					<c:if test="${cxnParent ne 'Y' }">
			    	<li style="height: 20px;">
                    	<span class="icon plus${itemList.RNUM}" style="display: table-cell; height: 20px; vertical-align: middle;">
                        	<img onclick="attrDisplayCtrl('${itemList.RNUM}');" src="${root}${HTML_IMG_DIR}icon_open.png"></img>
                        </span>
                        <span class="icon minus${itemList.RNUM}" style="display:none; height: 20px; vertical-align: middle;">
                            <img onclick="attrDisplayCtrl('${itemList.RNUM}');" src="${root}${HTML_IMG_DIR}icon_close.png"></img>
                        </span>
                     </li>
                     </c:if>
                     <!-- 명칭 - 코드 - 경로 -->
					 <li class="org_title">
						<c:if test="${isFromItem eq 'N'}">
							<!-- delete check -->
							<%-- <input type="checkbox" name="delCheck" id="${itemList.RelItemID}_${itemList.CnItemID}_${itemList.ClassCode}" value="${itemList.RelItemID}_${itemList.CnItemID}_${itemList.ClassCode}" style="vertical-align:top;"> --%>
					       	<img src="${root}${HTML_IMG_DIR_ITEM}/${itemList.FromItemIcon}" style="vertical-align:top;"></img>
	                        ${itemList.RelID}&nbsp;${itemList.RelName}&nbsp;(&nbsp;${itemList.RelPath}&nbsp;)
	                	</c:if>
	                	<c:if test="${isFromItem eq 'Y'}">
	                		<!-- delete check -->
							<%-- <input type="checkbox" name="delCheck" id="${itemList.PrcItemID}_${itemList.CnItemID}_${itemList.ClassCode}" value="${itemList.PrcItemID}_${itemList.CnItemID}_${itemList.ClassCode}" style="vertical-align:top;"> --%>
					       	<img src="${root}${HTML_IMG_DIR_ITEM}/${itemList.ToItemIcon}" style="vertical-align:top;"></img>
					       	${itemList.PrcID}&nbsp;${itemList.PrcName}&nbsp;(&nbsp;${itemList.PrcPath}&nbsp;)
	                	</c:if>
	                </li>
					<li class="floatR">
					<!-- cxnItemList row.ItemID,row.linkUrl,row.lovCode,row.attrTypeCode -->
					<c:forEach var="linkList" items="${cxnItemList}" varStatus="status">
						<c:if test="${linkList.RNUM == itemList.RNUM}">
							<img onclick="fnOpenLink('${linkList.PrcItemID}','${linkList.linkUrl}','${linkList.lovCode}','${linkList.attrTypeCode}');" src="${root}${HTML_IMG_DIR}/item/icon_link.png" width="19" height="20">
						</c:if>
<%--						<c:if test="${isFromItem eq 'Y'}">
							<img src="${root}${HTML_IMG_DIR}icon_doc.png" title="View Item Info." style="cursor:pointer;" value="view" type="submit" onclick="goItemPopUp('${itemList.PrcItemID}');"></img>
						</c:if>
						<c:if test="${isFromItem eq 'N'}">
							<img src="${root}${HTML_IMG_DIR}icon_doc.png" title="View Item Info." style="cursor:pointer;" value="view" type="submit" onclick="goItemPopUp('${itemList.RelItemID}');"></img>
						</c:if>
 					  	<c:if test="${myItem == 'Y'}">
                       		<img src="${root}cmm/common/images/icon_connection.png" title="View Connection Info" style="cursor:pointer;" value="Edit" type="submit" onclick="goItemPopUp('${itemList.CnItemID}');"></img>
						</c:if> --%>
					</c:forEach>
                    </li>
				</div>	
			
				<div class="attr${itemList.RNUM}" id="sub_org" style="display:none;">
                <!-- 속성 정보 -->
	                <table class="tbl_org" width="100%" border="0" cellpadding="0" cellspacing="0">
	                	<c:forEach var="cnnAttrList" items="${itemList.connectionAttrList}" varStatus="status">
	                        <colgroup>
	                            <col width="20%">
	                            <col width="80%">
	                        </colgroup>
	                        <tr>
	                            <th>${cnnAttrList.Name}</th>
	                            <td class="last alignL pdL5 pdR5" >
		                            <c:if test="${cnnAttrList.HTML eq '1'}">
		                            	<div style="width:100%;height:${cnnAttrList.AreaHeight}px;">
											<textarea class="tinymceText" readonly="readonly">${cnnAttrList.PlainText}</textarea>
										</div>
									</c:if>
									<c:if test="${cnnAttrList.HTML ne '1'}">
										<textarea style="width:100%;height:${cnnAttrList.AreaHeight}px;" readonly="readonly">${cnnAttrList.PlainText}</textarea>
									</c:if>
	                            </td>
	                        </tr>
	                    </c:forEach>
	                    <c:if test="${itemList.relatedAttrList.size() > 0}">
	               		<tr>
                           <td colspan="2" class="hr1" height="1">&nbsp;</td>
                        </tr>
                        </c:if>
	                    <c:forEach var="attrList" items="${itemList.relatedAttrList}" varStatus="status"><br>
	                        <colgroup>
	                            <col width="20%">
	                            <col width="80%">
	                        </colgroup>
	                        <tr>
	                            <th>${attrList.Name}</th>
	                            <td class="last alignL pdL5 pdR5" >
		                            <c:if test="${attrList.HTML eq '1'}">
		                            	<div style="width:100%;height:${attrList.AreaHeight}px;">
											<textarea class="tinymceText" readonly="readonly">${attrList.PlainText}</textarea>
										</div>
									</c:if>
									<c:if test="${attrList.HTML ne '1'}">
										<textarea style="width:100%;height:${attrList.AreaHeight}px;" readonly="readonly">${attrList.PlainText}</textarea>
									</c:if>
	                            </td>
	                        </tr>
	                    </c:forEach>
	                    <tr>
                           <td colspan="2" class="hr1" height="1">&nbsp;</td>
                        </tr>
	                </table>
            	</div>
			</div>

		</c:forEach>
		</c:if>
		
		<c:if test="${relatedItemList.size() == 0}">
			<li class="org_title pdL5"><span id="msgArea"></span></li>
		</c:if>
		<!-- END :: LIST -->
	</div>	
	<!-- :: 신규항목 생성 -->
	<div id="newItemArea" style="display:none;">
		<div id="divTapItemAdd" class="ddoverlap mgB5 mgT40">
			<ul>
				<li class="selected" ><a><span>${menu.LN00096}</span></a></li>
			</ul>
		</div>
		
		<table id="addNewItem" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" >
			<colgroup>
				<col width="15%">
				<col width="30%">
				<col width="15%">
				<col width="30%">
			</colgroup>
			<tr>
				<th>Code</th>
				<td><input type="text" class="text" id="newIdentifier" name="newIdentifier"/></td>
				<th>${menu.LN00028}</th>
				<td class="last"><input type="text" class="text" id="newItemName" name="newItemName"/></td>
			</tr>	
			<tr>
				<th>${menu.LN00016}</th>
				<td>
					<select id="newClassCode" name="newClassCode" class="sel" OnChange="fnGetHasDimension(this.value);">
					<option value=""></option>
					<c:forEach var="i" items="${classOption}">
						<option value="${i.ItemClassCode}"  >${i.Name}</option>						
					</c:forEach>				
					</select>
				</td>
				<th>${menu.LN00043}</th>
				<td class="last"><input type="text"class="text" id="parentItemPath" name="parentItemPath" readonly="readonly" onclick="itemTypeCodeTreePop();"/></td>
			</tr>
		</table>
		
		<div class="alignBTN" >
			&nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="newItemInsert();" type="submit"></span>
		</div>
	</div>
	
</form>
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>		
