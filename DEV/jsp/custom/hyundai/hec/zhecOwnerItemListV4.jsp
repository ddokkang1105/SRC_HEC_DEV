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

<script>
//var tc_gridArea;
var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용
var listScale = "<%=GlobalVal.LIST_SCALE%>";
var option = "${option}";
var s_itemID = "";
var s_authorID = "";
var scrnMode = "${scrnMode}";
var accMode = "${accMode}";
var regFlg = "${regFlg}";

var root = "${root}";

$(document).ready(function(){
	
	var bottomHeight = 180 ;
	if("${ownerType}" == "team" || "${ownerType}" == "user"){
		bottomHeight = 330;
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
	
 	var data =  "sessionCurrLangType=${sessionScope.loginInfo.sessionCurrLangType}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&Deactivated=1";
	fnSelect('itemTypeCode', data, 'itemTypeCode', '', 'Select');	
	fnSelect('classCode', data, 'getItemClassCode', '', 'Select');	
	fnSelect('status', data+"&category=ITMSTS", 'getDictionaryOrdStnm', '${status}', 'Select');
	
	if(regFlg !== "Y"){
		// 그리드 초기화
	    initGrid();
	    // 초기 조회 실행
	    setTimeout(function() {
	    	getOwnerItemList();
	    }, 200);
	}
	
	if("${sessionScope.loginInfo.sessionMlvl}" == "VIEWER") {
	    dhx.confirm({
	        text: "편집 권한이 없습니다. 권한 요청 하시겠습니까?",
	        buttons: ["No", "Yes"],
	        css: "align-center"
	    }).then(function (result) {
	    	if(result){
	    		reQuestUserAuth();
			}
	    });
	}
	else if(regFlg == "Y") {
		fnCreateSopInfo("Y");
	}
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

function urlReload() {
	initGrid();		
	getOwnerItemList();
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
                width: 50, id: "checkbox", // 기존 CHK/checkbox 통합
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
            { id: "Path",        header: [{ text: "${menu.LN00043}", align: "center" }], align: "left" },
            { id: "PjtName",     header: [{ text: "${menu.LN00131}", align: "center" }], align: "center" },
            { id: "AuthorName",  header: [{ text: "${menu.LN00004}", align: "center" }], align: "center" },
            { width: 100,  id: "LastUpdated", header: [{ text: "${menu.LN00070}", align: "center" }], align: "center" },
            { width: 70,  id: "StatusNM",    header: [{ text: "${menu.LN00027}", align: "center" }], align: "center" },
            

            { hidden: true,  id: "ChangeMgtYN", header: [{ text: "${menu.LN00089}", align: "center" }], align: "center", hidden: true },

            { hidden: true,  id: "SCOUNT",      header: [{ text: "SCOUNT" }], align: "center" },
            { hidden: true,  id: "ClassCode",   header: [{ text: "ClassCode" }], align: "center" },
            { hidden: true,  id: "Status",      header: [{ text: "Status" }], align: "center" },
            { hidden: true,  id: "ItemID",      header: [{ text: "ItemID" }], align: "center" },
            { hidden: true,  id: "AuthorID",    header: [{ text: "AuthorID" }], align: "center" },
            { hidden: true,  id: "Blocked",     header: [{ text: "Blocked" }], align: "center" },
            
  
            { width: 70,  id: "editIcon",    header: [{ text: "", align: "center" }], align: "center", htmlEnable: true },
            
           
            { id: "DefCSRID",    header: [{ text: "DefCSRID" }], hidden: true },
            { id: "csStatus",    header: [{ text: "csStatus" }], hidden: true },
            { id: "ChangeSetID", header: [{ text: "ChangeSetID" }], hidden: true }
        ],
        autoWidth: true,
        resizable: true,
        selection: "row",
        tooltip: false
    });

    // 이벤트 로직
    grid.events.on("cellClick", function(row, column) {
        if (column.id === "editIcon") {
            handleEditAction(row);
        } else if (column.id !== "checkbox") {
            doDetail(row.ItemID, row.ClassCode);
        }
    });
}

/**
 * gridOnRowSelect의 분기 로직
 */
function handleEditAction(row) {
    var blocked = row.Blocked;//0
    var itemStatus = row.Status;//MOD1
    var csStatus = row.csStatus;//MOD

  
    // 1. 편집 모드 (Blocked 0 & REL )
    if (blocked == 0 && itemStatus != "REL") {
        s_itemID = row.ItemID;
        s_authorID = row.AuthorID;
        scrnMode = "E";
        thisReload();
    }
    // 2. 체크아웃
    else if ((blocked != 0 || itemStatus == "REL") && csStatus == "CLS") {
        s_authorID = row.AuthorID;
        scrnMode = "E";
        
        dhx.confirm({
            text: "${CM00042}",
            buttons: ["No", "Yes"],
            css: "align-center"
        }).then(function (result) {
            if (result) checkOutPop(row.id); // row.id는 dhtmlx 내부 row id
        });
    }
    // 3. 리워크 HOLD
    else if (csStatus == "HOLD") {
        s_itemID = row.ItemID;
        var csID = row.ChangeSetID;
        scrnMode = "E";
        dhx.confirm({
            text: "${CM00059}",
            buttons: ["No", "Yes"],
            css: "align-center"
        }).then(function (result) {
            if (result) reworkPop(s_itemID, csID);
        });
    }
    //  일반 조회 모드
    else {
        s_itemID = row.ItemID;
        s_authorID = row.AuthorID;
        scrnMode = "V";
        thisReload();
    }
}

/**
 * 데이터 조회 (GET 방식)
 */
 async function getOwnerItemList() {
	    // [방어] 그리드 준비 확인 (타이밍 이슈 방지)
	    if (!grid || !grid.data) {
	        setTimeout(getOwnerItemList, 150);
	        return;
	    }
	    
	    $('#loading').fadeIn(150);

	    try {
	        // 1. 파라미터 생성 
	        const requestParams = await setAllCondition();
	        
	        // 2. URL 생성 
	        const queryString = new URLSearchParams(requestParams).toString();
	        const url = "getData.do?" + queryString; 

	        // 3. 데이터 
	        const response = await fetch(url, { 
	            method: 'GET',
	            headers: { 'Accept': 'application/json' }
	        });

	        // 4. 응답 상태 체크 
	        if (!response.ok) {
	            throw new Error("Network response was not ok");
	        }

	        const result = await response.json();

	        // 5.결과 체크 
	 
	        if (result && result.success === false) {
	            throw new Error(result.message || "Data load failed");
	        }

	        // 6. 데이터 로드 
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

/**
 * 검색 파라미터 구성 (작성자, 관리조직, 속성 멀티 검색 등 포함)
 */
async function setAllCondition() {
    const requestData = {
        sqlID: "zHEC_SQL.zHec_getOwnerItemList", 
        languageID: "${sessionScope.loginInfo.sessionCurrLangType}",
        statusList: "${statusList}",
        changeMgtYN: "Y",
        showTOJ: "Y",
        pageNum: $("#currPage").val() || "1",
        searchKey: $("#searchKey").val() || "Name",
        searchValue: $("#searchValue").val() || ""
    };

    // OwnerType 조건
    const ownerType = "${ownerType}";
    const userId = "${sessionScope.loginInfo.sessionUserId}";
    if (ownerType === "author") requestData.authorID = userId;
    else if (ownerType === "manager") requestData.managerID = userId;
    else if (ownerType === "team") requestData.ownerTeamID = "${teamID}";

    // 셀렉트 박스 필터
    if ($("#itemTypeCode").val()) requestData.itemTypeCode = $("#itemTypeCode").val();
    if ($("#classCode").val()) requestData.classCode = $("#classCode").val();

    // 상태값 처리
    let statusVal = $("#status").val() || ("${status}" !== "" ? "${status}" : "");
    if (statusVal) requestData.status = statusVal;

    // --- 속성 및 멀티 검색 로직 
    const AttrCode = document.querySelector("#AttrCode")?.value ?? "";
    if (AttrCode !== "") {
        const selectedOptions = document.querySelectorAll("#AttrCode option:checked");
        const attrArray = [];
        selectedOptions.forEach((el, i) => {
            const aval = el.value;
            let selectOption = (i === 0) ? "AND" : (document.querySelector("#selectOption" + aval)?.value ?? "AND");
            let constraintVal = document.querySelector("#constraint" + aval)?.value ?? "";
            let searchValue = (document.querySelector("#searchValue" + aval)?.value ?? "").replace(",", "comma");
            
            // (필요 시 특수문자 처리 )
            attrArray.push([aval, "", encodeURIComponent(searchValue), "", constraintVal, selectOption].join(","));
        });
        requestData.AttrCodeOLM_MULTI_VALUE = attrArray.join("|");
    }

    return requestData;
}


function fnReloadGrid(gridObj, data) {
    if (!gridObj || !gridObj.data) return;
  
       gridObj.data.removeAll();
       gridObj.data.parse(data);
  
}

function reworkPop(avg1, avg2){
	var url = "rework.do";		
	var data = "item="+avg1+"&cngt="+avg2+"&pjtId=&myPage=Y";
	var target = "blankFrame";
	var screenType = "${screenType}";
	ajaxPage(url, data, target);
	
}
function doDetail(avg1, avg2){
	var url = "itemMainMgt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID="+avg1+"&scrnType=pop"+"&itemMainPage=/itm/itemInfo/itemMainMgt";
	var w = 1200;
	var h = 900;
	itmInfoPopup(url,w,h,avg1);
	
}

function doCallBackMove(){}
function doCallBackRef(){doPPSearchList();}
function reloadTcSearchList(s_itemID){
	getOwnerItemList();
	$('#itemID').val(s_itemID);
	}

	function fnGetClassCode(itemTypeCode){
		var data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}&option="+itemTypeCode;
		fnSelect('classCode', data, 'classCodeOption', '', 'Select');	
	}


	// [Add] Click
	function checkOutPop(rowId) {
    // 1. 그리드에서 해당 행의 전체 데이터를 가져옵니다.
    var row = grid.data.getItem(rowId);
    if (!row) return;

    var items = "";
    var itemId = row.ItemID;      // 기존 15번 인덱스
    var itemStatus = row.Status;  // 기존 14번 인덱스
    var itemName = row.ItemNM;    // 기존 4번 인덱스
    var defCsrID = row.DefCSRID;  // 기존 19번 인덱스
    
    // 2. 상태 체크 (REL이 아니면 경고)
    if (itemStatus != "REL") {
        // JSP에서 미리 정의된 메세지 처리 (arguments 전달은 기존 방식 유지)
        alert("${WM00145}"); 
        s_itemID = "";
    } else {
        items = itemId;            
    }
    
    // 3. 체크아웃 실행 로직
    if (items != "") {
        s_itemID = items;
        
        if (defCsrID && defCsrID != "") {
            // CSR ID가 있는 경우: 즉시 체크아웃 처리
            var url = "checkOutItem.do";        
            var data = "projectID=" + defCsrID + "&itemIds=" + items;
            var target = "blankFrame";
            ajaxPage(url, data, target);
        } else {
            // CSR ID가 없는 경우: CSR 선택 팝업 호출
            var url = "cngCheckOutPop.do?";
            var data = "s_itemID=" + items + "&srID=${srID}";
            var option = "width=500px, height=350px, left=200, top=100,scrollbar=yes,resizable=yes";
            window.open(url + data, 'CheckOut', option);
        }
    }
}

	function fnCallBack() {
		parent.fnRefreshPageCall(option, s_itemID,scrnMode);
		
		//parent.fnRefreshPage(option, s_itemID)
	}
	function doCallBack(){}
	
	// 본 화면 Reload [Seach][After Check In]
	function thisReload(){

		parent.fnRefreshPageCall(option, s_itemID,scrnMode);
	}
	
	function urlReload() {
		thisReload();
	}
	
	function fnItemMenuReload(){
		opener.fnUpdateStatus("SPE015");
		self.close();
	}
		
	function fnGetItemClassMenuURL(itemID, currIdx){ 
		var url = "getItemClassMenuURL.do";
		var target = "blankFrame";
		var data = "&itemID="+itemID+"&currIdx="+currIdx;
		ajaxPage(url, data, target);
	}

	function fnCreateSopInfo(avg){
		
		if(avg != "Y") {
		    dhx.confirm({
		        text: "신규 표준을 등록 하시겠습니까?",
		        buttons: ["No", "Yes"],
		        css: "align-center"
		    }).then(function (result) {
		    	if(result){
		    		var url = "registerItemInfo.do";
					var data = "&itemNewPage=custom/hyundai/hec/item/createSOPInfoV4&accMode=DEV&scrnMode=N&option=${option}";
					
					var target = "myItemList";
					ajaxPage(url, data, target);
				}
		    });
		}
		else {
			var url = "registerItemInfo.do";
		
			var data = "&itemNewPage=custom/hyundai/hec/item/createSOPInfoV4&accMode=DEV&scrnMode=N&option=${option}";
			
			var target = "myItemList";
			ajaxPage(url, data, target);
		}
		
	}
	
	function fnSetItemClassMenu(menuURL, itemID){
		var temp = itemID.split("&");
		
		var url = menuURL+".do";
		var data = "&itemID="+s_itemID+"&itemClassMenuUrl="+menuURL+"&scrnMode="+scrnMode;
		
		for(var i=0; i<temp.length; i++) {
			var temp2 = temp[i].split("=");

			if(temp2.length > 1 && scrnMode == "E" && temp2[0] != "itemViewPage") {                            
				data += "&" + temp2[0] + "=" + temp2[1];
			}
			else if(temp2.length > 1 && scrnMode != "E" && temp2[0] != "itemEditPage") {
				data += "&" + temp2[0] + "=" + temp2[1];
			}
		}
		
		var target = "myItemList";
		ajaxPage(url, data, target);
	}
	
	function reQuestUserAuth(){
		var url = "reqUserAuth.do"; 
		var data =  "&sysUserID=1";
		var target = "blankFrame";

		ajaxPage(url, data, target);
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
	
	<div id="myItemList" style="overflow:auto;margin-bottom:5px;overflow-x:hidden;">	
		<div class="cop_hdtitle">
			<h3  style="padding: 6px 0;"><img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;${menu.LN00190}</h3>
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
		    	<th>${menu.ZLN020}</th>
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
		    	<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="getOwnerItemList()" value="Search" style="cursor:pointer;"></td>
		    </tr>
		</table>
		  
        <div class="countList">
        <ul>
            <li class="count">Total  <span id="TOT_CNT"></span></li>
             
			<li class="floatR pdR20">	
				<c:if test="${ sessionScope.loginInfo.sessionMlvl ne 'VIEWER'}">
					<span class="btn_pack small icon"><span class="add"></span><input value="${menu.ZLN016}" type="submit" id="add" onClick="fnCreateSopInfo()"></span>
				</c:if>
					<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
					<c:if test="${sessionScope.loginInfo.sessionMlvl eq 'VIEWER' }">
					<span class="btn_pack small icon"><span class="edit"></span><input value="Request Authorization" type="submit" onclick="reQuestUserAuth();"></span>
					</c:if>
			</li>	
			</ul>		
          </div>
		<div id="gridDiv" class="mgB10 clear">
			<div id="grdGridArea" style="width:100%"></div>
		</div>
			<!-- START :: PAGING -->
		<div id="pagination"></div>
	<!-- END :: PAGING -->
	</div>
	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>