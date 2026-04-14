<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00123" var="WM00123" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00124" var="WM00124" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00129" var="WM00129" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00042" var="CM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00059" var="CM00059"/>
<style>
/* 공통 스타일 */
/* 상태 아이템 공통 레이아웃 */
.grid__cell_status-item {
    display: inline-block;
    padding: 2px 5px;
}

/* 신규 (Blue) */
.grid__cell_status-item.status-new {
    color: blue !important;
    font-weight: bold;
}

/* 개정/수정 (Orange) */
.grid__cell_status-item.status-mod {
    color: orange !important;
    font-weight: bold;
}

/* 기본 (Black) */
.grid__cell_status-item.status-default {
    color: #333333;
    font-weight: normal;
}
</style>
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
	
	$("#excel").click(function(){

		fnGridExcelDownLoad();
	});


	
	initGrid();
	setTimeout(function() {
		getMyOwnerItemList();
	}, 350);
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

function urlReload() {

	initGrid();
	getMyOwnerItemList();
}

//===============================================================================
// BEGIN ::: GRID

var grid;
var pagination;
function initGrid() {
	grid = new dhx.Grid("grdGridArea", {
		columns: [
            { width: 50,  id: "RNUM",        header: [{ text: "${menu.LN00024}", align: "center" }], align: "center" },
            { 
                width: 50, id: "checkbox", 
                header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(event, this.checked)'>", align: "center" }], 
                align: "center", type: "boolean", editable: true, sortable: false 
            },
            { width: 50,  id: "ItemTypeImg", header: [{ text: "${menu.LN00042}", align: "center" }], align: "center", htmlEnable: true,
                template: function (text) {
                    return text ? '<img src="${root}${HTML_IMG_DIR_ITEM}/' + text + '" width="18" height="18">' : "";
                }
            },
            { width: 120, id: "Identifier",  header: [{ text: "${menu.LN00106}", align: "center" }], align: "left" },
            { id: "ItemNM",      header: [{ text: "${menu.LN00028}", align: "center" }], align: "left" },
            { width: 100, id: "ClassName",   header: [{ text: "${menu.LN00016}", align: "center" }], align: "left" },
            { width: 100, id: "Version",     header: [{ text: "${menu.LN00356}", align: "center" }], align: "center" },
            { width: 100, id: "ValidFrom",   header: [{ text: "${menu.LN00357}", align: "center" }], align: "center" },
            { width: 150, id: "AuthorName",  header: [{ text: "${menu.LN00004}", align: "center" }], align: "center" },
            { width: 150, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align: "center" }], align: "center" },
            { 
                width: 80, 
                id: "StatusNM", 
                header: [{ text: "${menu.LN00027}", align: "center" }], 
                align: "center",
                htmlEnable: true, 
                template: function (text, row, col) {
                    if (!text) return ""; 
                    
                    var code = row.Status;  
                    var statusName = text; 
                    var className = "";

                    
                    switch (code) {
                        case "NEW1": 
                            className = "status-new"; // Blue 
                            break;
                        case "MOD1": 
                        case "MOD2": 
                            className = "status-mod"; // Orange 
                            break;
                        default:
                            className = "status-default"; // 기본 (Black)
                            break;
                    }
                    
                    // 클래스가 입혀진 HTML 문자열 반환
                    return '<span class="grid__cell_status-item ' + className + '">' + statusName + '</span>';
                }
            },
            { hidden: true,  id: "ChangeMgtYN", header: [{ text: "${menu.LN00089}" }], align: "center" },
            { hidden: true,  id: "SCOUNT",      header: [{ text: "SCOUNT" }], align: "center" },
            { hidden: true,  id: "ClassCode",   header: [{ text: "ClassCode" }], align: "center" },
            { hidden: true,  id: "Status",      header: [{ text: "Status" }], align: "center" },
            { hidden: true,  id: "ItemID",      header: [{ text: "ItemID" }], align: "center" },
            { hidden: true,  id: "AuthorID",    header: [{ text: "AuthorID" }], align: "center" },
            { hidden: true,  id: "Blocked",     header: [{ text: "Blocked" }], align: "center" }
        ],
        autoWidth: true,
        resizable: true,
        selection: "row",
        tooltip: false
    });

    grid.events.on("cellClick", function(row, column) {
        if (column.id !== "checkbox") {
            doDetail(row.ItemID, row.ClassCode);
        }
    });
}

function fnMasterChk(e, checked) {
    grid.data.forEach(function (item) {
        grid.data.update(item.id, { checkbox: checked });
    });
}

async function getMyOwnerItemList() {
    if (!grid || !grid.data) {
        setTimeout(getMyOwnerItemList, 150);
        return;
    }
    
    $('#loading').fadeIn(150);

    try {
        const requestParams = await setAllCondition();
        const queryString = new URLSearchParams(requestParams).toString();
        const url = "getData.do?" + queryString; 

        const response = await fetch(url, { 
            method: 'GET',
            headers: { 'Accept': 'application/json' }
        });

        if (!response.ok) {
            throw new Error("Network response was not ok");
        }

        const result = await response.json();

        if (result && result.success === false) {
            throw new Error(result.message || "Data load failed");
        }

        const gridData = Array.isArray(result) ? result : (result.data || []);
        
        if (gridData.length > 0) {
            fnReloadGrid(grid, gridData); 
            if ($("#TOT_CNT").length) $("#TOT_CNT").html(gridData.length);

            if (pagination) pagination.destructor();
            pagination = new dhx.Pagination("pagingArea", {
                data: grid.data,
                pageSize: 40
            });
        } else {
            grid.data.removeAll();
            if ($("#TOT_CNT").length) $("#TOT_CNT").html(0);
            if (pagination) pagination.destructor();
        }
        
    } catch (error) {
        console.error("Search Error Detail:", error);
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


async function setAllCondition() {
	var subTeam = "";
	if($("input:checkbox[name=subTeam]").is(":checked") == true) {
		subTeam = "Y";	
	}

    const requestData = {
        sqlID: "zHEC_SQL.getZhecOwnerItemList", 
        languageID: "${sessionScope.loginInfo.sessionCurrLangType}",
        statusList: "${statusList}",
        changeMgtYN: "Y",
        pageNum: $("#currPage").val() || "1",
        searchKey: $("#searchKey").val() || "Name",
        searchValue: $("#searchValue").val() || ""
    };

    if("${ownerType}" == "team"){
        requestData.ownerTeamID = "${teamID}";
    }
    if(subTeam != ""){
        requestData.subTeam = subTeam;
    }
    if("${ownerType}" == "author"){
        requestData.authorID = "${authorID}";
    }
    
    if ($("#itemTypeCode").val()) requestData.itemTypeCode = $("#itemTypeCode").val();
    if ($("#classCode").val()) requestData.classCode = $("#classCode").val();

    let statusVal = $("#status").val() || ("${status}" !== "" ? "${status}" : "");
    if (statusVal) requestData.status = statusVal;

    return requestData;
}

function fnReloadGrid(gridObj, data) {
    if (!gridObj || !gridObj.data) return;
    gridObj.data.removeAll();
    gridObj.data.parse(data);
}
	
	
function doDetail(avg1, avg2){
	var url = "itemMainMgt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID="+avg1+"&scrnType=pop&accMode=OPS"
			 +"&itemMainPage=/itm/itemInfo/itemMainMgt";
	var w = 1200;
	var h = 900;
	itmInfoPopup(url,w,h,avg1);
	
}

function doCallBackMove(){}
function doCallBackRef(){doPPSearchList();}
function reloadTcSearchList(s_itemID){
	// doTcSearchList();
	getMyOwnerItemList();
	$('#itemID').val(s_itemID);
}
function selectedTcListRow(){	
	var s_itemID = $('#itemID').val();$('#itemID').val("");
	if(s_itemID != ""){
		grid.data.forEach(function(item){
			if(s_itemID == item.ItemID){
				grid.selection.setCell(item.id);
			}
		});
	}
}
/**  
 * [Owner][Attribute] 버튼 이벤트
 */
function editCheckedAllItems(avg){			

    var checkedRows = [];
    grid.data.forEach(function(item) {
        if (item.checkbox) {
            checkedRows.push(item);
        }
    });

    if(checkedRows.length == 0){
        alert("${WM00023}");
        return;
    }

	// var checkedRows = tc_gridArea.getCheckedRows(1).split(",");	
	var items = "";
	var classCodes = "";
	var nowClassCode = "";
	
	for(var i = 0 ; i < checkedRows.length; i++ ){
		// blocked == 2 인 경우 승인요청 중, 편집 불가 경고창 표시
        var row = checkedRows[i];
		var itemStatus = row.Status;
		var blocked = row.Blocked;

		if (blocked != "0" && avg != "Owner") {
			if (itemStatus == "REL") {
				//[변경 요청 안된 상태]
                alert(row.ItemNM+"${WM00124}");
			} else {
				// [승인요청중]
                alert(row.ItemNM+"${WM00123}");
			}
			
            grid.data.update(row.id, { checkbox: false });
		} else {
			// 이동 할 ITEMID의 문자열을 셋팅
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

        var checkedRows = [];
        grid.data.forEach(function(item) {
            if (item.checkbox) {
                checkedRows.push(item);
            }
        });

        if(checkedRows.length == 0){
            alert("${WM00023}");
        } else {
            var items = "";
            for(var i = 0 ; i < checkedRows.length; i++ ){
                var row = checkedRows[i];
                var itemId = row.ItemID;
                var itemStatus = row.Status;
                var itemName = row.ItemNM;
                
                if (itemStatus != "REL") {
                    // msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00145' var='WM00145' arguments='"+ itemName +"'/>";
                    alert("${WM00145}");
                    grid.data.update(row.id, { checkbox: false });
                } else {
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
		    	<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="getMyOwnerItemList()" value="Search" style="cursor:pointer;"></td>
		    </tr>
		</table>
		  
        <div class="countList">
        <ul>
            <li class="count">Total  <span id="TOT_CNT"></span></li>
			<li class="floatR pdR20">	
				<c:if test="${option ne 'MYSPACE'}">
					<c:if test="${ownerType eq 'editor'|| ownerType eq 'user'}" >&nbsp;<span id="btnAdd" class="btn_pack small icon"><span class="add"></span><input value="Check out" type="submit" onclick="checkOutPop()"></span>
					&nbsp;&nbsp;&nbsp;<span class="btn_pack nobg"><a class="edit" onclick="editCheckedAllItems('Attribute');" title="Attribute"></a></span></c:if>
					<c:if test="${loginInfo.sessionMlvl eq 'SYS' || (ownerType eq 'team' && loginInfo.sessionUserId eq teamManagerID) }" ><span class="btn_pack nobg"><a class="gov" onclick="editCheckedAllItems('Owner');" title="Gov"></a></span></c:if>
				</c:if>
        		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			</li>	
		</ul>		
          </div>
		<div id="gridDiv" class="mgB10 clear">
			<div id="grdGridArea" style="width:100%"></div>
		</div>
		<!-- <div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div> -->
        <div id="pagingArea"></div>
	</div>
	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
