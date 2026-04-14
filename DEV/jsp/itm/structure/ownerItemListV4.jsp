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
<!-- Dhtmlx7 그리드적용 -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<style>
 	.new {
		color:blue;
		font-weight:bold;
	}
	.mod{
		color:orange;
		font-weight:bold;
	}
	.remain{
		color:#000000;
	}
</style>
<script>

var tc_gridArea;
var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용
var listScale = "<%=GlobalVal.LIST_SCALE%>";

var languageID = '${sessionScope.loginInfo.sessionCurrLangType}';
var sessionUserId = '${sessionScope.loginInfo.sessionUserId}';

var option = "${option}";
var defItemTypeCode = "${defItemTypeCode}";
var status = "${status}";
var statusList = "${statusList}";
var authorID = "${authorID}";
var ownerTeamID = "${ownerTeamID}";
var ownerType = "${ownerType}";
	
$(document).ready(function(){
	var data =  "sessionCurrLangType=${sessionScope.loginInfo.sessionCurrLangType}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&Deactivated=1";
	fnSelect('itemTypeCode', data, 'itemTypeCode', defItemTypeCode, 'Select');	
	fnSelect('classCode', data, 'getItemClassCode', '', 'Select');	
	fnSelect('status', data+"&category=ITMSTS", 'getDictionaryOrdStnm', status, 'Select');
	
	var bottomHeight = 175 ;
	if(ownerType == "team" || ownerType == "user" || ownerType == "ownerTeam"){
		bottomHeight = 320;
	}
	
	// 초기 표시 화면 크기 조정 
	$("#grdGridArea").attr("style","height:"+(setWindowHeight() - bottomHeight)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - bottomHeight)+"px;");
	};
	
 	$("#excel").click(function (){
		fnGridExcelDownLoad();
	});
 	
 	loadOwnerItemList();

	
});


/**
 * @function setWindowHeight
 * @description 윈도우 높이를 구합니다.
 * @returns {Number} 높이
 */
function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}


//===============================================================================
// BEGIN ::: GRID


function gridOnRowSelect(row, col){
		if(col.id != "checkbox"){
		doDetail( row.ItemID, row.SCOUNT); }
		else{ tranSearchCheck = false; }
}
function doDetail(avg1, avg2){
	var url = "itemMainMgt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID="+avg1+"&scrnType=pop&itemMainPage=/itm/itemInfo/itemMainMgt";
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
	
	// check된 row 
	var checkedRows = grid.data.findAll(function (data) {
    return data.checkbox; 
	});
	
	if(checkedRows.length == 0){
		alert("${WM00023}");
		return;
	}

	//var checkedRows = tc_gridArea.getCheckedRows(1).split(",");	
	var items = "";
	var classCodes = "";
	var nowClassCode = "";
	
	for(var i = 0 ; i < checkedRows.length; i++ ){
		// blocked == 2 인 경우 승인요청 중, 편집 불가 경고창 표시
		var itemStatus = checkedRows[i].Status;
		var blocked = checkedRows[i].Blocked;
		if (blocked != "0" && avg != "Owner") {
			if (itemStatus == "REL") {
				checkedRows[i].ItemNM+"${WM00124}"; // [변경 요청 안된 상태]
			} else {
				checkedRows[i].ItemNM+"${WM00123}"; // [승인요청중]
			}
			checkedRows[i].checkbox; 
		} else {
			// 이동 할 ITEMID의 문자열을 셋팅
			if (items == "") {
				items = checkedRows[i].ItemID;
				classCodes = checkedRows[i].ClassCode;
				nowClassCode = checkedRows[i].ClassCode;
			} else {
				items = items + "," + checkedRows[i].ItemID
				if (nowClassCode != checkedRows[i].ClassCode) {
					classCodes = classCodes + "," + checkedRows[i].ClassCode;
					nowClassCode = checkedRows[i].ClassCode;
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
		
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00023}");
		} else {
			var items = "";
			
			for(var i = selectedCell.length-1 ; i >=0 ; i-- ){
				var itemId = selectedCell[i].ItemID;
				var itemStatus = selectedCell[i].Status;
				var itemName = selectedCell[i].ItemNM;
				if (itemStatus != "REL") {
					msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00145' var='WM00145' arguments='"+ itemName +"'/>";
					alert("${WM00145}");
	                grid.data.update(selectedCell[i].id, { checkbox: false });
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
					var data = "projectID=${csrID}&itemIds="+items;
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
				 	var option = "width=500px, height=350px, left=200, top=100,scrollbar=yes,resizble=0";
				 	window.open(url+data, 'CheckOut', option);
				}
			}
		}	
		
	}
	function doCallBack(){}
	
	// 본 화면 Reload [Seach][After Check In]
	function thisReload(){
		loadOwnerItemList();
	}
	
 	function urlReload() {
 		thisReload();
 	}
	
	function fnItemMenuReload(){
		opener.fnUpdateStatus("SPE015");
		self.close();
	}
	
</script>	
<form name="processList" id="processList" action="#" method="post" onsubmit="return false;" class="pdL10 pdR10">
	
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
	
	<c:if test="${hideTitle ne 'Y' }">
		<div class="cop_hdtitle floatL msg"> 
			<h3  style="padding: 6px 0; display: inline-block;"><img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;${menu.LN00190}</h3>
		</div>
	</c:if>

	<div class="countList pdT5">
           <li class="count">Total  <span id="TOT_CNT"></span></li>
            
		<li class="floatR">	
			<c:if test="${option ne 'MYSPACE'}">
				<c:if test="${ownerType eq 'editor'|| ownerType eq 'user'}" >&nbsp;<span id="btnAdd" class="btn_pack small icon"><span class="add"></span><input value="Check out" type="submit" onclick="checkOutPop()"></span>
				&nbsp;&nbsp;&nbsp;<span class="btn_pack nobg"><a class="edit" onclick="editCheckedAllItems('Attribute');" title="Attribute"></a></span></c:if>
				<c:if test="${(loginInfo.sessionMlvl eq 'SYS' || loginInfo.sessionUserId eq teamManagerID) && ownerType eq 'ownerTeam'  }" >
					<input type='checkbox' class='mgR5 chkbox' name='subTeam' id='subTeam' <c:if test="${subTeam eq 'Y' }"> checked </c:if> OnClick="thisReload();" ><label for='subTeam'>Include sub teams&nbsp;&nbsp;&nbsp;&nbsp;</label>
					<span class="btn_pack small icon"><span class="gov"></span><input value="Gov" type="submit"  onclick="editCheckedAllItems('Owner');" id="gov"></span></c:if>
			</c:if>
       		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</li>			
         </div>
	<div id="gridDiv" class="clear mgB10" style="width:100%;">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<div style="width:100%;" class="paginate_regular">
	<div id="pagination"></div>
	
	</div>

	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
	
	
<!-- DHTML 7 Grid init -->

<script type="text/javascript">

	
	// grid
	var layout = new dhx.Layout("grdGridArea", {
				rows : [ {
					id : "a",
				}, ]
			});	
	
	var pagination;
	var grid = new dhx.Grid("grdGridArea", {
		columns: [
	        {width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
	        {width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", align:"center"}]
	                , align: "center", type: "boolean", editable: true, sortable: false   },
	        { width: 50, id: "ItemTypeImg", header: [{ text: "${menu.LN00042}", align:"center" }], htmlEnable: true, align: "center",
	                  	template: function (text, row, col) {
	                  		return '<img src="${root}${HTML_IMG_DIR}/item/'+row.ItemTypeImg+'" width="18" height="18">';
	                      }
	                  },
	        { width: 100, id: "Identifier", header: [{ text: "${menu.LN00106}" , align: "center" }, { content: "inputFilter" }],align: "center"},
	        { width: 300, id: "ItemNM", header: [{ text: "${menu.LN00028}" , align: "center" }, { content: "inputFilter" }],align: "left"},
	        { width: 100, id: "ClassName", header: [{ text: "${menu.LN00016}" , align: "center" }, { content: "selectFilter" }],align: "center"},
	        { width: 380, id: "Path", header: [{ text: "${menu.LN00043}" , align: "center" }, { content: "inputFilter" }],align: "left" },
	        { width: 200, id: "PjtName", header: [{ text: "${menu.LN00131}" , align: "center" }, { content: "selectFilter" }],align: "center" },
	        { width: 150, id: "AuthorName", header: [{ text: "${menu.LN00004}" , align: "center" }, { content: "inputFilter" }],align: "center" },
	        { width: 100, id: "LastUpdated", header: [{ text: "${menu.LN00070}" , align: "center" }],align: "center"},
	        { width: 120, id: "StatusNM", header: [{ text: "${menu.LN00027}" , align: "center" },{ content: "selectFilter" }], htmlEnable: true, 
				         mark: function (cell, column, row) { 
				        	 if(row.Status==='NEW1'){return "new";}
			        		 else if (row.Status ==='MOD') {return "mod"}
			        		 else{return "remain"}
			        		  } ,align: "center"
	        },
	        { hidden:true,width: 80, id: "ChangeMgtYN", header: [{ text: "${menu.LN00089}" , align: "center" }, { content: "selectFilter" }]},
	        { hidden:true,width: 80, id: "SCOUNT", header: [{ text: "SCOUNT"  }, { content: "" }], align: "" },
	        { hidden:true,width: 80, id: "ClassCode", header: [{ text: "ClassCode"}, { content: "" }], align: "" },
	        { hidden:true,width: 80, id: "Status", header: [{ text: "Status" , align: "center" }, { content: "" }], align: "" },
	        { hidden:true,width: 80, id: "ItemID", header: [{ text: "ItemID" , align: "" }, { content: "" }], align: "" },
	        { hidden:true,width: 80, id: "AuthorID", header: [{ text: "AuthorID" , align: "" }, { content: "" }], align: "" },
	        { hidden:true,width: 80, id: "Blocked", header: [{ text: "Blocked" , align: "" }, { content: "" }], align: "" },
	    
	       
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	});
	
	layout.getCell("a").attach(grid);
	
	
	grid.events.on("cellClick", function(row, column, e) {
		gridOnRowSelect(row,column);
	});
	
	function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
		$("#TOT_CNT").html(grid.data.getLength());	
		if(pagination){pagination.destructor();}
		if(grid.data.getInitialData().length >= 50) {
			pagination = new dhx.Pagination("pagination", {
			    data: grid.data,
			    pageSize: 50,
			});
		} 
	} 
	
	/**
	* @function OnwerItemList
	* @description api를 통해 OwnerItemList 데이터를 가져와 grid 에 주입합니다.
	*/
	async function loadOwnerItemList(){
		
		$('#loading').fadeIn(150);
		
		// option
		var subTeam = "";
		if(document.querySelector('input[name="subTeam"]:checked')){
			subTeam = "Y";
		}
		var searchKeyElement = document.querySelector("#searchKey");
		var searchKey = searchKeyElement ? searchKeyElement.value : "";
		var searchValueElement = document.querySelector("#searchValue");
		var searchValue = searchValueElement ? searchValueElement.value : "";
		searchValue = encodeURIComponent(searchValue);
		
	    const requestData = { listType : 'owner', languageID, statusList, ownerType, authorID, searchKey, searchValue, subTeam, ownerTeamID, sessionUserId };
	    
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getItemListInfo.do?" + params;
	    
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
				fnReloadGrid(result.data);
			} else {
				return [];
			}
	        
	    } catch (error) {
	    	handleAjaxError(error);
	    } finally {
	    	$('#loading').fadeOut(150);
	    }
	}
	 
	/**
	* @function handleAjaxError
	* @description 데이터 로드 실패 시 에러 메시지 팝업 출력
	* @param {Error} err - 발생한 에러 객체
	*/
	function handleAjaxError(err) {
		console.error(err);
		Promise.all([getDicData("ERRTP", "LN0014"), getDicData("BTN", "LN0034")])
				.then(([errDic, btnDic]) => showDhxAlert(errDic.LABEL_NM, btnDic.LABEL_NM));
	}
		
</script>

	