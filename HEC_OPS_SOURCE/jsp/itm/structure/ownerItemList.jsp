<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00123" var="WM00123" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00124" var="WM00124" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00129" var="WM00129" />

<script>
var tc_gridArea;
var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용
var listScale = "<%=GlobalVal.LIST_SCALE%>";
var option = "${option}";
var defItemTypeCode = "${defItemTypeCode}";

	
$(document).ready(function(){
	var data =  "sessionCurrLangType=${sessionScope.loginInfo.sessionCurrLangType}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&Deactivated=1";
	fnSelect('itemTypeCode', data, 'itemTypeCode', defItemTypeCode, 'Select');	
	fnSelect('classCode', data, 'getItemClassCode', '', 'Select');	
	fnSelect('status', data+"&category=ITMSTS", 'getDictionaryOrdStnm', '${status}', 'Select');
	
	var bottomHeight = 180 ;
	if("${ownerType}" == "team" || "${ownerType}" == "user"){
		bottomHeight = 500;
	}
	
	// 초기 표시 화면 크기 조정 
	$("#grdGridArea").attr("style","height:"+(setWindowHeight() - bottomHeight)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - bottomHeight)+"px;");
	};
	
	$("#excel").click(function(){tc_gridArea.toExcel("${root}excelGenerate");});

	gridTcInit();		
	var timer = setTimeout(function() {
		doTcSearchList();
	}, 350); //1000 = 1초
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
	tc_gridArea = fnNewInitGrid("grdGridArea", tcd);
	tc_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
	tc_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
	
	// fnSetColType(tc_gridArea, 2, "img");
	fnSetColType(tc_gridArea, 1, "ch");
	
	tc_gridArea.setColumnHidden(2, true);	
	tc_gridArea.setColumnHidden(11, true);
	
	tc_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
	tc_gridArea.enablePaging(true,40,10,"pagingArea",true,"recInfoArea");
	
	tc_gridArea.setPagingSkin("bricks");
	tc_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
}
function setTcGridData(){
	var subTeam = "";
	if($("input:checkbox[name=subTeam]").is(":checked") == true) {
		subTeam = "Y";	
	}
	var tcResult = new Object();
	tcResult.title = "${title}";
	
	tcResult.key = "item_SQL.getOwnerItemList";
	tcResult.header = "${menu.LN00024},#master_checkbox,${menu.LN00042},${menu.LN00106},${menu.LN00028},${menu.LN00016},${menu.LN00356},${menu.LN00357},${menu.LN00004},${menu.LN00070},${menu.LN00027},${menu.LN00089},SCOUNT,ClassCode,Status,ItemID,AuthorID,Blocked";
	tcResult.cols = "CHK|ItemTypeImg|Identifier|ItemNM|ClassName|Version|ValidFrom|AuthorName|LastUpdated|StatusNM|ChangeMgtYN|SCOUNT|ClassCode|Status|ItemID|AuthorID|Blocked";
	tcResult.widths = "30,30,30,120,300,100,100,100,150,80,70,00,0,0,0,0,0,0";
	tcResult.sorting = "int,int,str,str,str,str,str,str,str,str,str,int,str,str,str,str,str,str";
	tcResult.aligns = "center,center,left,left,left,center,center,center,center,center,center,center,center, center,center,center";
	tcResult.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&statusList=${statusList}&changeMgtYN=Y&ownerType=${ownerType}&authorID=${authorID}" 
				+ "&pageNum=" + $("#currPage").val()
		        + "&searchKey=" + $("#searchKey").val()
		        + "&searchValue=" + $("#searchValue").val();
				
				if("${ownerType}" == "team"){
					tcResult.data = tcResult.data + "&ownerTeamID=${teamID}";
				}
				if(subTeam != ""){
					tcResult.data = tcResult.data + "&subTeam="+subTeam;
				}
								
				if($("#itemTypeCode").val() != null && $("#itemTypeCode").val() != ""){
			  		tcResult.data = tcResult.data + "&itemTypeCode=" + $("#itemTypeCode").val();
			  	}
				if($("#classCode").val() != null && $("#classCode").val() != ""){
			  		tcResult.data = tcResult.data + "&classCode=" + $("#classCode").val();
			  	}
				
				if($("#status").val() != null && $("#status").val() != ""){
			  		tcResult.data = tcResult.data + "&status=" + $("#status").val();
			  	}				
				else if("${status}" != "" && ($("#status").val() == null || $("#status").val() == "")) {
					tcResult.data = tcResult.data + "&status=${status}";
				}
			//	if($("#changeMgtYN").val() != null && $("#changeMgtYN").val() != ""){
			//  		tcResult.data = tcResult.data +  + $("#changeMgtYN").val();
			//  	}
	return tcResult;
}
function gridOnRowSelect(id, ind){if(ind != 1){doDetail(tc_gridArea.cells(id, 15).getValue(), tc_gridArea.cells(id, 12).getValue());}else{tranSearchCheck = false;}}
function doDetail(avg1, avg2){
	var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop&accMode=OPS";
	var w = 1200;
	var h = 900;
	itmInfoPopup(url,w,h,avg1);
	
}

function doCallBackMove(){}
function doCallBackRef(){doPPSearchList();}
function reloadTcSearchList(s_itemID){doTcSearchList();$('#itemID').val(s_itemID);}
function selectedTcListRow(){	
	var s_itemID = $('#itemID').val();$('#itemID').val("");
	if(s_itemID != ""){tc_gridArea.forEachRow(function(id){/*alert(s_itemID+":::"+tc_gridArea.cells(id, 14).getValue()+"::::"+id);*/if(s_itemID == tc_gridArea.cells(id, 14).getValue()){tc_gridArea.selectRow(id-1);}
	});}
}
/**  
 * [Owner][Attribute] 버튼 이벤트
 */
function editCheckedAllItems(avg){			
	if(tc_gridArea.getCheckedRows(1).length == 0){
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
				classCodes = tc_gridArea.cells(checkedRows[i], 13).getValue();
				nowClassCode = tc_gridArea.cells(checkedRows[i], 13).getValue();
			} else {
				items = items + "," + tc_gridArea.cells(checkedRows[i], 15).getValue();
				if (nowClassCode != tc_gridArea.cells(checkedRows[i], 13).getValue()) {
					classCodes = classCodes + "," + tc_gridArea.cells(checkedRows[i], 13).getValue();
					nowClassCode = tc_gridArea.cells(checkedRows[i], 13).getValue();
				}
			}
		}
		
	}
	
	if (items != "") {
		$("#items").val(items);

		if (avg == "Attribute2") {
			var url = "selectAttributePop.do";
			var data = "items="+items+"&classCodes="+classCodes; 
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
		   
		    var w = "400";
			var h = "350";
			$("#classCodes").val(classCodes);
		    window.open("", "selectAttribute", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		    document.processList.action=url;
		    document.processList.target="selectAttribute";
		    document.processList.submit();
			    
		} else  if (avg == "Owner") {   
		    var url = "selectOwnerPop.do"; 
		    var option = "width=480, height=350, left=300, top=300,scrollbar=yes,resizble=0";
		    window.open("", "SelectOwner", option);
		    document.processList.action=url;
		    document.processList.target="SelectOwner";
		    document.processList.submit();
		} 
	 }
	
}

	function fnGetClassCode(itemTypeCode){
		var data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}&option="+itemTypeCode;
		fnSelect('classCode', data, 'classCodeOption', '', 'Select');	
	}


	// [Add] Click
	function checkOutPop() {
		if(tc_gridArea.getCheckedRows(1).length == 0){
			alert("${WM00023}");
		} else {
			var checkedRows = tc_gridArea.getCheckedRows(1).split(",");
			var items = "";
			
			for(var i = checkedRows.length-1 ; i >=0 ; i-- ){
				var itemId = tc_gridArea.cells(checkedRows[i], 15).getValue();
				var itemStatus = tc_gridArea.cells(checkedRows[i], 14).getValue();
				var itemName = tc_gridArea.cells(checkedRows[i], 4).getValue();
				
				if (itemStatus != "REL") {
					msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00145' var='WM00145' arguments='"+ itemName +"'/>";
					alert("${WM00145}");
					tc_gridArea.cells(checkedRows[i], 0).setValue(0); 
				} else {
					// 삭제 할 ITEMID의 문자열을 셋팅
					if (items == "") {
						items = itemId;
					} else {
						items = items + "," + itemId;
					}
				}
			}
			var csrID = "${csrID}";
			if (items != "") {
				if(csrID != ""){
					var url = "checkOutItem.do";		
					var data = "projectId=${csrID}&itemIds="+items;
					var target = "help_content";
					var screenType = "${screenType}";
					if(screenType == "CSR"){
						target = "saveFrame";
					}					
					ajaxPage(url, data, target);
				}else{
					var url = "cngCheckOutPop.do?";
					var data = "s_itemID=" + items+"&srID=${srID}";
				 	var target = self;
				 	var option = "width=350px, height=350px, left=200, top=100,scrollbar=yes,resizble=0";
				 	window.open(url+data, 'CheckOut', option);
				}
			}
		}	
		
		/* 아이템 리스트 검색 창을 띄우는 경우
		var url = "selectAllItemPop.do?";
		var data = "";
	    fnOpenLayerPopup(url,data,doCallBack,617,436);
	    */
	}
	function doCallBack(){}
	
	// 본 화면 Reload [Seach][After Check In]
	function thisReload(){
		var url = "ownerItemList.do";
		var target = "help_content";
		var screenType = "${screenType}";
		if(screenType == "CSR"){
			target = "myItemDiv";
		}
		
		var data = "screenType="+screenType+"&csrID=${csrID}&ownerType=editor&changeMgtYN=Y";
		if($("#Status").val() != '' & $("#Status").val() != null){
			data = data + "&Status="+ $("#Status").val();
		}
		if($("#ClassCode").val() != '' & $("#ClassCode").val() != null){
			data = data + "&ClassCode="+ $("#ClassCode").val();
		}
		
	 	ajaxPage(url, data, target);
	}
	
	function urlReload() {
		thisReload();
	}
	
	function fnItemMenuReload(){
		opener.fnUpdateStatus("SPE015");
		self.close();
	}
	
</script>	
<form name="processList" id="processList" action="#" method="post" onsubmit="return false;">
	
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
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<input type="hidden" id="ownerType" name="ownerType" value="${ownerType}" >
	
	<div style="overflow:auto;margin-bottom:5px;overflow-x:hidden;">	
		<div class="cop_hdtitle">
			<h3  style="padding: 6px 0; display: inline-block;"><img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;${menu.LN00190}</h3>
			<c:if test="${ownerType eq 'team'}">
				<div class="floatR pdR20" style="padding: 6px 0;">
				<input type='checkbox' class='mgR5 chkbox' name='subTeam' id='subTeam' checked><label for='subTeam'>Include sub teams&nbsp;</label>
				</div>
			</c:if>
		</div>
		
		<table style="table-layout:fixed;" border="0" cellpadding="0" cellspacing="0" class="tbl_search mgT5"  id="search">
			<colgroup>
			    <col width="5.5%">		    <col width="9%">
			    <col width="5.5%">		    <col width="9%">
			    <col width="5.5%">		    <col width="9%">
			    <col width="5.5%">		    <col width="9%">
			    <col width="5.5%">		    <col width="9%">
			    <col width="5.5%">		    <col width="9%">
			    <col width="5.5%">		    <col width="9%">
		    </colgroup>
		    <tr>
		    	<!--th>${menu.LN00089}</th>
		    	<td>
		    		<select class="sel" id="changeMgtYN" name="changeMgtYN" class="sel">
					  <option value="Yes">Yes</option>
					  <option value="No">No</option>		
					  <option value="">All</option>			
					</select>
		    	</td-->
		    	<th>${menu.LN00021}</th>
		    	<td><select id="itemTypeCode" name="itemTypeCode" OnChange="fnGetClassCode(this.value)" class="sel"></select></td>
		    	<th>${menu.LN00016}</th>
		    	<td><select id="classCode" name="classCode" class="sel" ></select></td>
		    	<th <c:if test="${option ne 'MYSPACE' || sessionScope.loginInfo.sessionMlvl ne 'VIEWER'}">style="display:none;"</c:if>>Role Type</th>
		    	<td <c:if test="${option ne 'MYSPACE' || sessionScope.loginInfo.sessionMlvl ne 'VIEWER'}">style="display:none;"</c:if>><select id="roleType" name="roleType" class="sel"></select></td>
		    	<th>${menu.LN00027}</th>
		    	<td><select id="status" name="status" class="sel" ></select></td>
		    	<th>
		    		<select id="searchKey" name="searchKey" class="sel">
						<option value="Name">Name</option>
						<option value="ID" 
							<c:if test="${!empty searchID}">selected="selected"
							</c:if>	
						>ID</option>
					</select>
		    	</th>
		    	<td><input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text"></td>
		    	<td class="alignR" colspan=<c:choose><c:when test="${option ne 'MYSPACE' || sessionScope.loginInfo.sessionMlvl ne 'VIEWER'}">4</c:when><c:otherwise>2</c:otherwise></c:choose>>
		    	<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doTcSearchList()" value="Search" style="cursor:pointer;"></td>
		    </tr>
		</table>
		  
        <div class="countList">
            <li class="count">Total  <span id="TOT_CNT"></span></li>
             
			<li class="floatR pdR20">	
				<c:if test="${option ne 'MYSPACE'}">
					<c:if test="${ownerType eq 'editor'|| ownerType eq 'user'}" >&nbsp;<span id="btnAdd" class="btn_pack small icon"><span class="add"></span><input value="Check out" type="submit" onclick="checkOutPop()"></span>
					&nbsp;&nbsp;&nbsp;<span class="btn_pack nobg"><a class="edit" onclick="editCheckedAllItems('Attribute');" title="Attribute"></a></span></c:if>
					<c:if test="${loginInfo.sessionMlvl eq 'SYS' || (ownerType eq 'team' && loginInfo.sessionUserId eq teamManagerID) }" ><span class="btn_pack nobg"><a class="gov" onclick="editCheckedAllItems('Owner');" title="Gov"></a></span></c:if>
				</c:if>
        		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			</li>			
          </div>
		<div id="gridDiv" class="mgB10 clear">
			<div id="grdGridArea" style="width:100%"></div>
		</div>
		<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	</div>
	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>