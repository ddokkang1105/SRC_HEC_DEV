<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00046" var="CM00046"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00048" var="CM00048"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046"/>

<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
	
	$(document).ready(function() {
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 240)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 240)+"px;");
		};
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
				
		var reportYN = "${reportYN}";
		var data = "&category=CN"; 
		if(reportYN=="Y"){
			data = data + "&objectType=${itemTypeCode}&Deactivated=1";
		}
		fnSelect('connectionType', data, 'itemTypeCode', '', 'Select');
		
		
		gridInit();
		if(reportYN != "Y"){
			doSearchList();
		}
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//===============================================================================
	// BEGIN ::: GRID
	function gridInit(){		
		var d = setGridData();		
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
	
		p_gridArea.setColumnHidden(12, true);
		p_gridArea.setColumnHidden(13, true);
		p_gridArea.setColumnHidden(14, true);
		p_gridArea.setColumnHidden(15, true);
		p_gridArea.setColumnHidden(16, true);
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		
		//START - PAGING
		p_gridArea.enablePaging(true, 500, null, "pagingArea", true, "recinfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
		//END - PAGING
	}	
	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "analysis_SQL.getConnectionList";
		result.header = "${menu.LN00024},#master_checkbox,ConnectionType,Source Type,Source Class,Source ID,Source Name,Target Type,Target Class,Target ID,Target Name,${menu.LN00070},CNItemID,FromItemID,ToItemID,FromDeleted,ToDeleted";
		result.cols = "CHK|ConnectionType|FromType|FromClass|FromIdentifier|FromItemName|ToType|ToClass|ToIdentifier|ToItemName|LastUpdated|CNItemID|FromItemID|ToItemID|FromDeleted|ToDeleted";
		result.widths = "30,30,100,160,100,70,140,160,100,70,140,80,80,80,80"; 
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,left,left,center,center,left,left,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&DeletedYN=${DeletedYN}"
		 			+ "&pageNum=" + $("#currPage").val()
		 			+ "&connectionType=" + $("#connectionType").val();
		return result;
	}
	
	// [Row] Click
	function gridOnRowSelect(id, ind){
		if(ind != 1) {
			doDetail(p_gridArea.cells(id, 12).getValue());
		}
	}
	
	// END ::: GRID	
	//===============================================================================

	function doSearchList(){
		var d = setGridData();
		//fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
		/* 건수 제한 메세지 표시 */
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data, "", "", "", "", "", "${WM00119}", 1000);
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
		if(p_gridArea.getCheckedRows(1).length == 0){
			alert("${WM00023}");
			return;
		}

		var checkedRows = p_gridArea.getCheckedRows(1).split(",");	
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
			for(var i = 0 ; i < checkedRows.length; i++ ){
				sourceItem = p_gridArea.cells(checkedRows[i], 6).getValue();
				fromDeleted = p_gridArea.cells(checkedRows[i], 15).getValue();
				toDeleted = p_gridArea.cells(checkedRows[i], 16).getValue();
				if(avg == 1){
					if(fromDeleted == "0" && toDeleted == "0"){
						// 이동 할 ITEMID의 문자열을 셋팅
						if (items == "") {
							items = p_gridArea.cells(checkedRows[i], 12).getValue();
						} else {
							items = items + "," + p_gridArea.cells(checkedRows[i], 12).getValue();
						}
					}else{
						alert(sourceItem +"은(는) ${WM00046}");
						return;
					}
				}else{
					// 이동 할 ITEMID의 문자열을 셋팅
					if (items == "") {
						items = p_gridArea.cells(checkedRows[i], 12).getValue();
					} else {
						items = items + "," + p_gridArea.cells(checkedRows[i], 12).getValue();
					}
				}
			}
			if (items != "") {
				if (avg == 1) { // Recover
					url = "deletedItemRecover.do?";
				} else if(avg == 2) { // Delete Item Master
					url = "deleteCNItems.do?";
				}
				var data = "items="+items;  
				var target="help_content";
				ajaxPage(url, data, target);
			}
		}
	}
	
	function doExcel() {		
		p_gridArea.toExcel("${root}excelGenerate");
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
			<span class="btn_pack small icon"><span class="down"></span><input value="download list" type="button" id="excel" OnClick="doExcel();"></span>
			<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="goBack()" type="submit"></span>
			</c:if>
			
		</li>
	</div>
	
   	<div class="countList pdT5">
    	<li  class="count">Total  <span id="TOT_CNT"></span></li>
   	</div>
	<div id="gridDiv" class="mgB10 clear" align="center">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->		
</form>
	
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>
	
