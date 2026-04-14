<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00018" var="WM00018"/>
<style>
	.grid_hover {
		background-color:f2f8ff;
		font-size:20px;
	}
</style>

<script>
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 355)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 355)+"px;");
		};
		
		$("#excel").click(function(){ fnGridExcelDownLoad(); });
			
	 	var data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('dimTypeID', data, 'getDimensionTypeID', '', 'Select');	
// 		gridTcInit();		
		doTcSearchList();
		
		var htmlCode = "<div class='dhx_grid_data2' style='display:none;'><p style='text-align:center;font-size:14px;margin:10px;'>${WM00018}</p></div>";
		$(".objbox").append(htmlCode);
		
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function thisReload() {
// 		gridTcInit();		
		doTcSearchList();
	}
	
// 	function doTcSearchList(){
// 		var tcd = setTcGridData();fnLoadDhtmlxGridJson(tc_gridArea, tcd.key, tcd.cols, tcd.data,false,false,"","","fnSetResultCount()");
// 	}
	
// 	function fnSetResultCount(){
// 		if(tc_gridArea.getRowsNum() == 0){
// 			$(".dhx_grid_data2").show(); 
// 		}else{
// 			$(".dhx_grid_data2").hide(); 
// 		}
// 	}
	
// 	function gridTcInit(){	
// 		var tcd = setTcGridData();
// 		tc_gridArea = fnNewInitGrid("grdChildGridArea", tcd);
// 		tc_gridArea.setImagePath("${root}${HTML_IMG_DIR}/item/");
// 		tc_gridArea.setIconPath("${root}${HTML_IMG_DIR}/item/");
	
// 		fnSetColType(tc_gridArea, 20, "img");
// 		fnSetColType(tc_gridArea, 2, "img");
// 		fnSetColType(tc_gridArea, 1, "ch");
		
// 		tc_gridArea.enableRowsHover(true,'grid_hover');
// 		tc_gridArea.enableMultiselect(true);
	
// 		tc_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
// 		tc_gridArea.attachEvent("onCheckbox",fnOnCheck);
// 	}
	
// 	function fnOnCheck(rowId,cellInd,state){
// 		if(state){
// 			tc_gridArea.setRowColor(rowId, "#f2f8ff");
// 		}else{
// 			tc_gridArea.setRowColor(rowId, "#ffffff");
// 		}
// 	}
	
// 	function setTcGridData(){
// 		var tcResult = new Object();
// 		tcResult.title = "${title}";
// 		tcResult.key = "item_SQL.getSubStrItemList";
// 		if(document.all("IncludeAllSubStrItems").checked == true ){
// 			tcResult.key = "item_SQL.getAllSubStrItemList";
// 		}
// 		tcResult.header = "${menu.LN00024},#master_checkbox,${menu.LN00042},${menu.LN00015},${menu.LN00016},${menu.LN00028},${menu.LN00043},${menu.LN00018},${menu.LN00004},${menu.LN00070},${menu.LN00027},ItemID,subStrItemID";
// 		tcResult.cols = "CHK|ItemTypeImg|Identifier|ClassName|ItemName|Path|OwnerTeamName|Name|LastUpdated|ItemStatusText|ItemID|StrItemID";
// 		tcResult.widths = "30,30,30,130,100,250,*,120,140,140,110,0,0";
// 		tcResult.sorting = "int,int,str,str,str,str,str,str,str,str,str,str";
// 		tcResult.aligns = "center,center,center,center,center,left,left,center,center,center,center,center";
// 		tcResult.data = "s_itemID=${mstItemID}&strItemID=${strItemID}"
// 					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"				
// 			        + "&option=" + $("#option").val()
// 			        + "&filterType=${filterType}"
// 			        + "&TreeDataFiltered=${TreeDataFiltered}"  
// 			        + "&defDimTypeID=${defDimTypeID}"
// 			        + "&defDimValueID=${defDimValueID}"      
// 			        + "&searchKey=" + $("#searchKey").val()
// 			        + "&searchValue=" + $("#searchValue").val()
// 			        + "&showTOJ=${showTOJ}"
// 			        + "&showElement=${showElement}"
// 			        + "&udfSTR=${udfSTR}";
// 		return tcResult;
// 	}
	
// 	function gridOnRowSelect(id, ind){
// 		if(ind != 1){
// 			//doDetail(tc_gridArea.cells(id, 11).getValue());
// 			fnTreeLoad(tc_gridArea.cells(id, 12).getValue());
// 		}
// 	}
	
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
		if(grid.data.getInitialData().filter(e => e.checkbox).length == 0){
			alert("${WM00023}");
		}else{
			if(confirm("${CM00004}")){
				var items = grid.data.getInitialData().filter(e => e.checkbox).map(e => e.ItemID).join(",");
				
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
		var url = "itemTypeCodeTreePop.do";
		var data = "openMode=assign&ItemTypeCode=${mstItemTypeCode}&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&option=AR000000"
					+"&varFilter=&connectionType=From&strType=${strType}";
	
		fnOpenLayerPopup(url,data,"",617,436);
	}
	
	function setCheckedItems(checkedItems){
		var url = "createCxnItem.do";
		var udfSTR = "${udfSTR}";
		var categoryCode = "ST2";
		if(udfSTR == "Y"){
			categoryCode = "ST3";
		}
		var data = "s_itemID=${mstItemID}&cxnItemType=${strItemTypeCode}&connectionType=From"
					+ "&categoryCode="+categoryCode+"&items="+checkedItems
					+ "&strType=${strType}&strItemID=${strItemID}&structureID=${structureID}&strLevel=${strLevel}";
		var target = "blankFrame";
		
		ajaxPage(url, data, target);	
		
		$(".popup_div").hide();
		$("#mask").hide();	
	}
	
	function fnUpdateChilidItemOrder(){
		var sqlKey = "item_SQL.getChildStrItemList";
		var url = "childItemOrderList.do?s_itemID=${strItemID}&sqlKey="+sqlKey+"&strType=${strType}";
		var w = 550;
		var h = 500;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	function fnAddStrItem(avg, avg2){	
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
				var data = "items=" + items + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${strItemID}&option=${option}";
				fnOpenLayerPopup(url,data,"",617,436);
			}
		}
	}
	
	function newItemInsert(addYN){
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
						+"&preFix="+$("#preFix").val()
						+"&mstItemID=${mstItemID}"
						+"&connectionType=From&strType=${strType}"
						+"&strLevel=${strLevel}"
						+"&strItemTypeCode=${strItemTypeCode}"
						+"&mstItemTypeCode=${mstItemTypeCode}"
						+"&structureID=${structureID}";
						
			var target = "blankFrame";		
			ajaxPage(url, data, target);
		}
	}

</script>	
<form name="processList" id="processList" action="#" method="post" onsubmit="return false;" style="height:100%;">
	<div id="processListDiv" class="hidden" style="width:100%;height:100%;">
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
					        	&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="fnAddStrItem('addNewItem');"></span>
								&nbsp;<span class="btn_pack small icon"><span class="assign"></span><input value="Assign" type="submit" onclick="fnAssignItem();"></span>
								&nbsp;<span class="btn_pack small icon"><span class="updown"></span><input value="Edit Order" type="submit" onclick="fnUpdateChilidItemOrder();"></span>
								&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDeleteStrItem();"></span>
						</c:if>	
					</c:if>
				</c:if>
				<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			</li>	
          </div>
		<div id="layout" style="width:100%"></div>
	 
	 	<table id="addNewItem" class="tbl_blue01 mgT60" width="100%"  cellpadding="0" cellspacing="0" style="display: none;">
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
	 </div>
	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
	<script>
		doTcSearchList();
		
		var layout = new dhx.Layout("layout", {
		    rows: [
		        {
		            id: "a",
		        },
		    ]
		});
		
		var grid = new dhx.Grid("grid",  {
			columns: [
		        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}", align:"center"}], align:"center" },
		        { width: 30, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", htmlEnable: true }], align: "center", type: "boolean", editable: true, sortable: false},
		        { width: 50, id: "ItemTypeImg", header: [{ text: "${menu.LN00042}", align:"center" }], align:"center", htmlEnable: true,
		        	template: function (text, row, col) {
		        		return '<img src="${root}${HTML_IMG_DIR}/item/'+row.ItemTypeImg+'" width="18" height="18">';
		            }
		        },
		        { width: 130, id: "Identifier", header: [{text: "${menu.LN00015}", align:"center"}]},
		        { width: 100, id: "ClassName", header: [{ text: "${menu.LN00016}", align:"center" }], align:"center"},
		        { width: 250, id: "ItemName", header: [{ text: "${menu.LN00028}", align:"center" }]},
		        { id: "Path", header: [{ text: "${menu.LN00043}", align:"center" }]},
		        { width: 120, id: "OwnerTeamName", header: [{ text: "ITO ${menu.LN00018}", align:"center" }], align:"center"},
		        { width: 140, id: "Name", header: [{ text: "ITO ${menu.LN00004}", align:"center" }], align:"center"},
		        { width: 140, id: "LastUpdated", header: [{ text: "ITO ${menu.LN00070}", align:"center" }], align:"center"},
		        { width: 110, id: "ItemStatusText", header: [{ text: "ITO ${menu.LN00027}", align:"center" }], align:"center",  htmlEnable: true},
		    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false
		});
		
		layout.getCell("a").attach(grid);
		
		function doTcSearchList(){
			var sqlID = "item_SQL.getSubStrItemList";
			if(document.all("IncludeAllSubStrItems").checked == true ){
				sqlID = "item_SQL.getAllSubStrItemList";
			}
			var param = "s_itemID=${mstItemID}&strItemID=${strItemID}"
				+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"				
		        + "&option=" + $("#option").val()
		        + "&filterType=${filterType}"
		        + "&TreeDataFiltered=${TreeDataFiltered}"  
		        + "&defDimTypeID=${defDimTypeID}"
		        + "&defDimValueID=${defDimValueID}"      
		        + "&searchKey=" + $("#searchKey").val()
		        + "&searchValue=" + $("#searchValue").val()
		        + "&showTOJ=${showTOJ}"
		        + "&showElement=${showElement}"
		        + "&udfSTR=${udfSTR}"
				+ "&sqlID="+sqlID;
				
			$.ajax({
				url:"jsonDhtmlxListV7.do",
				type:"POST",
				data:param,
				success: function(result){
					if(result.length == 0) $(".dhx_grid_data2").show(); 
					else grid.data.parse(result);
				},error:function(xhr,status,error){
					console.log("ERR :["+xhr.status+"]"+error);
				}
			});
		}
		
		grid.events.on("cellClick", function(row,column,e){
			if(column.id != "checkbox") {
				fnTreeLoad(row.StrItemID);
			}
		});
	</script>