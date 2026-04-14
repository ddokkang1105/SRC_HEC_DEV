<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00046" var="CM00046"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00048" var="CM00048"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046"/>

<!-- 2. Script -->
<script type="text/javascript">

	$(document).ready(function() {
		// SKON CSRF 보안 조치
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
				}
		})
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 240)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 240)+"px;");
		};
		
		$("#excel").click(function(){ fnGridExcelDownLoad(); });	;
				
		var reportYN = "${reportYN}";
		var data = "&category=CN"; 

		if(reportYN=="Y"){
			data = data + "&objectType=${itemTypeCode}&Deactivated=1";
		}
		fnSelect('connectionType', data, 'itemTypeCode', '', 'Select');

		if(reportYN != "Y"){
			doSearchList();
		}
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//===============================================================================
	// BEGIN ::: GRID

	var layout = new dhx.Layout("grdGridArea", { 
			rows: [
				{
					id: "a",
				},
			]
		});
	
		var gridData = ${gridData};
		var grid = new dhx.Grid("grdGridArea", {
			columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ width: 30, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
				{ width: 120, id: "ConnectionType", header: [{ text: "ConnectionType" , align: "center" }], align: "center" },
				{ width: 120, id: "FromType", header: [{ text: "Source Type", align: "center" }], align: "center" },
				{ width: 100, id: "FromClass", header: [{ text: "Source Class", align: "center" }], align: "center" },
				{ width: 90, id: "FromIdentifier", header: [{ text: "Source ID", align: "center" }], align: "left" },
				{ width: 140, id: "FromItemName", header: [{ text: "Source Name", align: "center" }], align: "left" },
				{ width: 160, id: "ToType", header: [{ text: "Target Type", align: "center" }] , align: "center"},	
				{ width: 100, id: "ToClass", header: [{ text: "Target Class", align: "center" }] , align: "center"},		
				{ width: 80, id: "ToIdentifier", header: [{ text: "Target ID", align: "center" }] , align: "left"},		
				{ width: 140, id: "ToItemName", header: [{ text: "Target Name", align: "center" }] , align: "left"},		
				{ width: 80, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align: "center" }] , align: "center"},	
				{ hidden: true, width: 80, id: "CNItemID", header: [{ text: "CNItemID", align: "center" }] , align: "center"},	
				{ hidden: true, width: 80, id: "FromItemID", header: [{ text: "FromItemID", align: "center" }] , align: "center"},		
				{ hidden: true, width: 80, id: "ToItemID", header: [{ text: "ToItemID", align: "center" }] , align: "center"},					
				{ hidden: true, width: 80, id: "FromDeleted", header: [{ text: "FromDeleted", align: "center" }], align: "center" },				
				{ hidden: true, width: 80, id: "ToDeleted", header: [{ text: "ToDeleted", align: "center" }], align: "center" },
				{ width: 80, id: "CxnClassName", header: [{ text: "관계", align: "center" }], align: "center" }					
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data: gridData
		});
		layout.getCell("a").attach(grid);
		var total = grid.data.getLength();
		$("#TOT_CNT").html(total);

		var pagination = new dhx.Pagination("pagination", {
			data: grid.data,
			pageSize: 50,
		});	

		grid.events.on("cellClick", function(row,column,e){
			if(column.id != "checkbox"){
				gridOnRowSelect(row);
			}
		}); 

		// [Row] Click
		function gridOnRowSelect(row){
			doDetail(row.CNItemID);
		}
	
	// END ::: GRID	
	//===============================================================================
	

	//조회
	function doSearchList(){
		var sqlID = "analysis_SQL.getConnectionList";
		var param =  "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&DeletedYN=${DeletedYN}"
					+ "&connectionType=" + $("#connectionType").val()
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
		
	 function fnReloadGrid(newGridData) {
            var limit = 1000;
            grid.data.parse(newGridData);
            $("#TOT_CNT").html(total);
            if (total > limit) { alert("${WM00119}"); } /* 건수 제한 메세지 표시 */
            fnMasterChk('');
        }

	
	function doDetail(avg){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg);
	}
	
	function urlReload(){ 
		var data = "DeletedYN=${DeletedYN}";
		var url = "connectionList.do";
		var target="help_content";
		ajaxPage(url, data, target);
	}
	
	/**  
	 * [Recover][Delete Item Master] 버튼 이벤트
	 */
	function recoverOrDel(avg){
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){ //배열의 길이가 0   => !FALSE == TRUE
			alert("${WM00023}");	
		}
		var items = "";
		var url = "";
		var msg = "${CM00046}";
		var fromDeleted = "";
		var toDeleted = "";
		var sourceItem = "";
		if (avg == 1) {
			msg = "${CM00048}";
		}
		if(confirm(msg)){
			for(idx in selectedCell){
				sourceItem = selectedCell[idx].FromItemName;
				fromDeleted = selectedCell[idx].FromDeleted;
				toDeleted = selectedCell[idx].ToDeleted;
				if(avg == 1){
					if(fromDeleted == "0" && toDeleted == "0"){
						// 이동 할 ITEMID의 문자열을 셋팅
						if (items == "") {
							items = selectedCell[idx].CNItemID;
						} else {
							items = items + "," + selectedCell[idx].CNItemID;
						}
					}else{
						alert(sourceItem +"은(는) ${WM00046}");
						return;
					}
				}else{
					// 이동 할 ITEMID의 문자열을 셋팅
					if (items == "") {
						items = selectedCell[idx].CNItemID;
					} else {
						items = items + "," + selectedCell[idx].CNItemID;
					}
				}
			}
			if (items != "") {
				if (avg == 1) { // Recover
					url = "admin/deletedItemRecover.do?";
				} else if(avg == 2) { // Delete Item Master
					url = "admin/deleteCNItems.do?";
				}
				var data = "items="+items;  
				var target="help_content";
				
				ajaxPage(url, data, target);
				grid.data.remove(selectedCell[idx].id);	
			}
		}
	}
	
	function goBack() {
		url = "objectReportList.do";
		data = "s_itemID=${s_itemID}&option=${option}&kbn=newItemInfo"; 
		var target = "actFrame";
	 	ajaxPage(url, data, target);
	}
	
</script>

<form name="connectionDeletedList" id="connectionDeletedList" action="#" method="post"  onsubmit="return false;">
	<input type="hidden" id="currPage" name="currPage" value="${currPage}"></input>
	
	<div class="msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;${title}</div>
	
	<div class="child_search">
		<li class="floatL pdR20">
		 	<select id="connectionType" Name="connectionType" style="width:150px;">
		       	<option value=''>Select</option>
		    </select>
		    &nbsp;<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="doSearchList()"/>
	    </li>
		<li class="floatR pdR20">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor' && DeletedYN == 'Y'}">
				&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="edit"></span><input value="Recover" type="submit" onclick="recoverOrDel(1);"></span>
				&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="edit"></span><input value="Delete Item Master" type="submit" onclick="recoverOrDel(2);"></span>
			    &nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			</c:if>
			<c:if test="${DeletedYN == 'N'}">
			<span class="btn_pack small icon"><span class="down"></span><input value="download list" type="button" id="excel"></span>
			<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="goBack()" type="submit"></span>
			</c:if>
			
		</li>
	</div>
	
   	<div class="countList pdT5">
    	<li  class="count">Total  <span id="TOT_CNT"></span></li>
   	</div>
	<div id="gridDiv" class="mgB10 clear">
		<div id="grdGridArea" style="width:100%"></div>
		<div id="pagination"></div></div>
	</div>		
</form>
	
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>
	
