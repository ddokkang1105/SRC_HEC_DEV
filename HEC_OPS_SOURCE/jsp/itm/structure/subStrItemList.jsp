<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00054" var="WM00054"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00024" var="WM00024"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00052" var="WM00052"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00121" var="WM00121"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046"/>
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
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
			
	 	var data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('dimTypeID', data, 'getDimensionTypeID', '', 'Select');	
		gridTcInit();		
		doTcSearchList();
		
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function thisReload() {
		gridTcInit();		
		doTcSearchList();
	}
	
	function doTcSearchList(){
		var tcd = setTcGridData();fnLoadDhtmlxGridJson(tc_gridArea, tcd.key, tcd.cols, tcd.data,false,false,"","","selectedTcListRow()");
	}
	
	function gridTcInit(){	
		var tcd = setTcGridData();
		tc_gridArea = fnNewInitGrid("grdChildGridArea", tcd);
		tc_gridArea.setImagePath("${root}${HTML_IMG_DIR}/item/");
		tc_gridArea.setIconPath("${root}${HTML_IMG_DIR}/item/");
	
		fnSetColType(tc_gridArea, 20, "img");
		fnSetColType(tc_gridArea, 2, "img");
		fnSetColType(tc_gridArea, 1, "ch");
		
		tc_gridArea.enableRowsHover(true,'grid_hover');
		tc_gridArea.enableMultiselect(true);
	
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
		tcResult.key = "item_SQL.getSubStrItemList";
		if(document.all("IncludeAllSubStrItems").checked == true ){
			tcResult.key = "item_SQL.getAllSubStrItemList";
		}
		tcResult.header = "${menu.LN00024},#master_checkbox,${menu.LN00042},${menu.LN00015},${menu.LN00016},${menu.LN00028},${menu.LN00043},${menu.LN00018},${menu.LN00004},${menu.LN00070},${menu.LN00027},ItemID,subStrItemID";
		tcResult.cols = "CHK|ItemTypeImg|Identifier|ClassName|ItemName|Path|OwnerTeamName|Name|LastUpdated|ItemStatusText|ItemID|StrItemID";
		tcResult.widths = "30,30,30,130,100,250,*,120,140,140,110,0,0";
		tcResult.sorting = "int,int,str,str,str,str,str,str,str,str,str,str";
		tcResult.aligns = "center,center,center,center,center,left,left,center,center,center,center,center";
		tcResult.data = "s_itemID=${s_itemID}&strItemID=${strItemID}"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"				
			        + "&option=" + $("#option").val()
			        + "&filterType=${filterType}"
			        + "&TreeDataFiltered=${TreeDataFiltered}"  
			        + "&defDimTypeID=${defDimTypeID}"
			        + "&defDimValueID=${defDimValueID}"      
			        + "&searchKey=" + $("#searchKey").val()
			        + "&searchValue=" + $("#searchValue").val()
			        + "&showTOJ=${showTOJ}"
			        + "&showElement=${showElement}";
		return tcResult;
	}
	
	function gridOnRowSelect(id, ind){
		if(ind != 1){
			//doDetail(tc_gridArea.cells(id, 11).getValue());
			fnTreeLoad(tc_gridArea.cells(id, 12).getValue());
		}
	}
	
	function fnTreeLoad(strItemID){
		parent.fnRefreshTree(strItemID, true);
	}
	
	function doDetail(avg1){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";

		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
		
	}
	
	function fnDeleteStrItem(){
		if(tc_gridArea.getCheckedRows(1).length == 0){
			alert("${WM00023}");
		}else{
			if(confirm("${CM00004}")){
				var checkedRows = tc_gridArea.getCheckedRows(1).split(",");	
				var items = "";
				
				for(var i = 0 ; i < checkedRows.length; i++) {
					if (items == "") {
						items = tc_gridArea.cells(checkedRows[i], 12).getValue();
					} else {
						items = items + "," + tc_gridArea.cells(checkedRows[i], 12).getValue();
					}
				}
				
				if (items != "") {
					var url = "deleteStrItem.do";
					var data = "s_itemID=${strItemID}&items="+items+"&categoryCode=ST2";
					var target = "blankFrame";
					ajaxPage(url, data, target);
				}
			}
		}
	 }
	
	//[Assign] click 이벤트	
	function fnAssignItem(){
		//if ("${selectedItemBlocked}" == "0") {
			var url = "itemTypeCodeTreePop.do";
			var data = "openMode=assign&ItemTypeCode=AR100203&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
						+"&s_itemID=${strItemID}&option=AR100203"
						+"&varFilter=ST00018&connectionType=From&strType=${strType}";
						//+"&varFilter=${varFilter}&connectionType=From";
	
			fnOpenLayerPopup(url,data,doCallBack,617,436);
		/* } else {
			if ("${selectedItemStatus}" == "REL") {
				alert("${WM00120}"); // [변경 요청 안된 상태]
			} else {
				alert("${WM00050}"); // [승인요청중]
			}
		} */
	}
	
	function setCheckedItems(checkedItems){
		var url = "createCxnItem.do";
		var data = "s_itemID=${s_itemID}&cxnItemType=ST00018&connectionType=From"
					+ "&cxnClassCode=${subStrItemClassCode}&categoryCode=ST2&items="+checkedItems
					+ "&strType=${strType}&strItemID=${strItemID}";
		var target = "blankFrame";
		
		ajaxPage(url, data, target);	
		
		$(".popup_div").hide();
		$("#mask").hide();	
	}
	
	function fnUpdateChilidItemOrder(){
		var sqlKey = "item_SQL.getChildStrItemList";
		var url = "childItemOrderList.do?s_itemID=${strItemID}&sqlKey="+sqlKey+"&strType=${strType}";
		var w = 500;
		var h = 500;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");

	}
	
	function doExcel() {		
		tc_gridArea.toExcel("${root}excelGenerate");
	}
	

</script>	
<form name="processList" id="processList" action="#" method="post" onsubmit="return false;">
	<div id="processListDiv" class="hidden" style="width:100%;height:100%;">
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
				<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doTcSearchList()" value="Search" style="cursor:pointer;">&nbsp;&nbsp;&nbsp;
				<input type="checkbox" id="IncludeAllSubStrItems" />&nbsp;&nbsp;Include sub all items&nbsp; 
			</li>
			<li class="floatR pdR20">
				<c:if test="${pop != 'pop'}">
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
						<c:if test="${myItem == 'Y'}">
								&nbsp;<span class="btn_pack small icon"><span class="assign"></span><input value="Assign" type="submit" onclick="fnAssignItem();"></span>
								&nbsp;<span class="btn_pack small icon"><span class="updown"></span><input value="Edit Order" type="submit" onclick="fnUpdateChilidItemOrder();"></span>
								&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDeleteStrItem();"></span>
						</c:if>	
					</c:if>
				</c:if>
				<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			</li>	
          </div>
		<div id="gridDiv" class="mgB10 clear">
			<div id="grdChildGridArea" style="width:100%"></div>
		</div>
		</div>
	</div>
	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>