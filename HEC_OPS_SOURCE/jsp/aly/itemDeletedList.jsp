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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00148" var="WM00148"/>

<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
	
	$(document).ready(function() {
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 180)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 180)+"px;");
		};
		fnSelect('status', "languageID=${sessionScope.loginInfo.sessionCurrLangType}&category=ITMSTS", 'getDictionaryOrdStnm', '', 'Select');
		gridInit();
		doSearchList();
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//===============================================================================
	// BEGIN ::: GRID
	function gridInit(){		
		var d = setGridData();		
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
		p_gridArea.setColumnHidden(11, true);
		p_gridArea.setColumnHidden(12, true);
		p_gridArea.setColumnHidden(13, true);
		fnSetColType(p_gridArea, 1, "ch");
		fnSetColType(p_gridArea, 2, "img");	
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		
		//START - PAGING
		p_gridArea.enablePaging(true, 1000, null, "pagingArea", true, "recinfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
		//END - PAGING
	}	
	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "analysis_SQL.getItemDeletedList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00042},${menu.LN00016},${menu.LN00015},${menu.LN00028},${menu.LN00043},${menu.LN00018},${menu.LN00004},${menu.LN00070},${menu.LN00027},ItemID,ClassCode,Status";
		result.cols = "CHK|ItemTypeImg|ClassName|Identifier|ItemName|Path|OwnerTeamName|Name|LastUpdated|StatusName|ItemID|ClassCode|Status";
		result.widths = "30,30,30,100,120,200,*,100,100,70,70,0,0,0"; // item 검색
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,left,left,left,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
		 			+ "&pageNum=" + $("#currPage").val()
		 			+ "&status=" + $("#status").val();
		
		return result;
	}
	
	// [Row] Click
	function gridOnRowSelect(id, ind){
		if(ind != 1) {
			doDetail(p_gridArea.cells(id, 11).getValue());
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
		var url = "itemDeletedList.do";
		var target="help_content";
		ajaxPage(url, "", target);
	}
	
	/**  
	 * [Recover][Delete Item Master] 버튼 이벤트
	 */
	function recoverOrDel(avg){
		if(p_gridArea.getCheckedRows(1).length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요.");
			alert("${WM00023}");
			return;
		}

		var checkedRows = p_gridArea.getCheckedRows(1).split(",");	
		var items = "";
		var url = "";
		var msg = "${CM00046}";
		if (avg == 1) {
			msg = "${CM00048}";
		}
		if(confirm(msg)){
			for(var i = 0 ; i < checkedRows.length; i++ ){
				// 이동 할 ITEMID의 문자열을 셋팅
				if (items == "") {
					items = p_gridArea.cells(checkedRows[i], 11).getValue();
				} else {
					items = items + "," + p_gridArea.cells(checkedRows[i], 11).getValue();
				}
			}
			
			if (items != "") {
				if (avg == 1) { // Recover
					url = "deletedItemRecover.do?";
				} else if(avg == 2) { // Delete Item Master
					url = "delItemMaster.do?";
				}
				var data = "items="+items; 
				var target="help_content";
				ajaxPage(url, data, target);
			}
		}
	}
	
	/**  
	 * [Delete Item Master] 버튼 이벤트
	 */
	function fnDeleteItemMaster(){
		if(p_gridArea.getCheckedRows(1).length == 0){
			alert("${WM00023}");
			return;
		}

		var checkedRows = p_gridArea.getCheckedRows(1).split(",");	
		var items = new Array();
		var msg = "${CM00046}";
		var index = 0;
		var status = "";
		var itemName = "";
		if(confirm(msg)){
			for(var i = 0 ; i < checkedRows.length; i++ ){
				status = p_gridArea.cells(checkedRows[i], 13).getValue();				
				if (status == "NEW1") {
					items[index] = p_gridArea.cells(checkedRows[i], 11).getValue();
					index++;
				}else{
					itemName = p_gridArea.cells(checkedRows[i], 5).getValue();
					alert(itemName+"${WM00148}");
				}
			}
			
			if (items != "") {				
				var url = "delItemMaster.do?";
				var data = "items="+items; 
				var target="help_content";
				ajaxPage(url, data, target);
			}
		}
	}
	
	
</script>

<form name="itemDeletedList" id="itemDeletedList" action="#" method="post"  onsubmit="return false;">
	<input type="hidden" id="currPage" name="currPage" value="${currPage}"></input>
	
	<div class="msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Deleted List(Item)</div>
	
	<div class="child_search">
		<li>			
			<li>
			${menu.LN00027} &nbsp;&nbsp; 		
			<select id="status" Name="status" style="width:150px;">
				<option value="" >Select</opiton> 
			</select>
			&nbsp;<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="doSearchList()" style="cursor:pointer;"/>
		</li>
		</li>
		<li class="floatR pdR20">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="edit"></span><input value="Recover" type="submit" onclick="recoverOrDel(1);"></span>
				&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="edit"></span><input value="Delete Item Master" type="submit" onclick="fnDeleteItemMaster();"></span>
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
	
