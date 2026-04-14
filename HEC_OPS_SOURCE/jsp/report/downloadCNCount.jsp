<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_1" arguments="${menu.LN00131}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_2" arguments="${menu.LN00016}"/>

<script type="text/javascript">
	var p_gridArea
	
	$(document).ready(function() {	
		$('#fileDownLoading').removeClass('file_down_on');
		$('#fileDownLoading').addClass('file_down_off');
		
		$("input.datePicker").each(generateDatePicker); // calendar
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		};
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		gridInit();		
		doSearchList();				
	});	
	
	function setWindowHeight(){
		var size = window.innerHeight;
		var height = 0;
		if( size == null || size == undefined){
			height = document.body.clientHeight;
		}else{
			height=window.innerHeight;
		}return height;
	}
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridInit(){		
		var d = setGridData();		
		p_gridArea = fnNewInitGridMultirowHeader("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		p_gridArea.enablePaging(true,50,10,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.setColumnHidden(3);
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		//p_gridArea.attachFooter(",,,,#stat_total");
	}
	
	function setGridData(){ // chnageSetId 옆에 changeType 필드 추가 
		var reqAttachHeader1 = "${attachHeader1}";
		var reqHeader = "";
		var reqWidth = "";
		var reqSorting = "";
		var reqAligns = "";
		
		var lovSize = "${lovSize}";
		if(Number(lovSize) > 0){
			for (var i = 0; i < Number(lovSize)-1; i++) {
				reqHeader = reqHeader +",#cspan";
				reqWidth = reqWidth +",80";				
				reqSorting =  reqSorting+",int";
				reqAligns = reqAligns+",center";
			}
			reqHeader =  reqHeader +",#cspan,#cspan";
			reqWidth = reqWidth +",80,80";				
			reqSorting =  reqSorting+",int,int";
			reqAligns = reqAligns+",center,center";
		}else{
			reqWidth = ",80";
			reqSorting =  ",int";
			reqAligns = ",center";
		}
		var header = "${treeItemTypeName},#cspan,#cspan,#cspan,${relatedItemTypeName}"+reqHeader;
		var attachHeader1 = "Identifier, Name, Path, ItemID"+reqAttachHeader1;
		var widths = "80,240,250,0,80"+reqWidth;
		var sorting = "str,str,str,str,int"+reqSorting;
		var aligns = "center,left,left,left,center"+reqAligns;
		
		var result = new Object();
		result.title = "";
		result.key = "";
		result.header = header;
		result.attachHeader1 = attachHeader1;
		result.widths = widths;
		result.sorting = sorting;
		result.aligns = aligns;
		
		result.data = "";
		return result;
		
	}
	
	//조회
	function doSearchList(){
		p_gridArea.enableRowspan();
		p_gridArea.enableColSpan(true);
		p_gridArea.loadXML("${root}" + "${xmlFilName}");
	}
	
	function fnGetCsrCombo(parentID){
		fnSelect('itemClass','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID='+parentID,'getItemClassTaskTP','Select');
		fnSelect('csrList','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID='+parentID,'getCsrOrder','Select');
		fnSelect('csrTeam','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID='+parentID,'getCsrTeam','Select');
	}
	
	function fnSearchList(){
		var CNTypeCode = "${CNTypeCode}";
		var itemClassCode = "${itemClassCode}";
		var attrTypeCode = "${attrTypeCode}";
		var searchKey = $("#searchKey").val();
		var searchValue = $("#searchValue").val();
		var treeItemTypeCode = "${treeItemTypeCode}";
		var url = "downloadCNCount.do";
		var data = "itemTypeCode="+CNTypeCode+"&s_itemID=${s_itemID}&itemClassCode="+itemClassCode+"&attrTypeCode="+attrTypeCode+"&searchKey="+searchKey+"&searchValue="+searchValue+"&treeItemTypeCode="+treeItemTypeCode;
	
		var target = "searchDiv";
		ajaxPage(url, data, target);
	}
	
	function doExcel() {		
		p_gridArea.toExcel("${root}excelGenerate");
	}
	
	function gridOnRowSelect(id, ind){
		if(ind == 0 || ind == 1 || ind == 2){
			var s_itemID = p_gridArea.cells(id, 3).getValue(); 
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+s_itemID+"&scrnType=pop";
			var w = 1200;
			var h = 900;
			itmInfoPopup(url,w,h,itemID);
		}
	}
	
	function goBack() {
		var url = "objectReportList.do";
		var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&kbn=newItemInfo"; 
		var target = "actFrame";
	 	ajaxPage(url, data, target);
	}
	
	
</script>
<div id="searchDiv">
<form name="taskSearchFrm" id="taskSearchFrm" action="#" method="post" onsubmit="return false;">
<input type="hidden" id="currPage" name="currPage" value="${currPage}" />
<div class="child_search mgT10">
	<li class="pdL55">
		<select id="searchKey" name="searchKey">
			<option value="Name">Name</option>
			<option value="ID">ID</option>
		</select>
		<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;"/>
		<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="fnSearchList()" value="검색">
	</li>
	<li class="floatR pdR20">
		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>	
		<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="goBack()" type="submit"></span>
	</li>
</div>
 <div class="countList pdT10">
    <li class="count">Total <span id="TOT_CNT">${totalCnt}</span></li>
 </div>
<form name="rptForm" id="rptForm" action="" method="post" > 
<div id="gridIssueDiv" style="width:100%;" class="clear"  >
	<div id="grdGridArea" style="background-color:white;"></div>
</div>
<!-- START :: PAGING -->
<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
<!-- END :: PAGING -->	
</form>
</div>
