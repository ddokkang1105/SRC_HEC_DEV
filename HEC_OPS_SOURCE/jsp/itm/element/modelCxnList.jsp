<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00020" var="WM00020"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00106" var="WM00106"/>

<script>
	var p_gridArea;				//그리드 전역변수
	var itemAthId = "${selectedItemAuthorID}";
	var blocked = "${selectedItemBlocked}";
	var userId = "${sessionScope.loginInfo.sessionUserId}";
	var selectedItemStatus = "${selectedItemStatus}";
	
	$(document).ready(function(){		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 500)+"px;");

		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 500)+"px;");
		};
		
		$("#excel").click(function(){p_gridArea.toExcel("${root}excelGenerate");});
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&modelID=${modelID}";
		fnSelect('sourceClassCode', data, 'getElementClassCode', '', 'Select');
		fnSelect('targetClassCode', data, 'getElementClassCode', '', 'Select');
		
		gridInit();		
		doSearchList();
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	function gridInit(){	
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");		
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.setColumnHidden(1, true);
		p_gridArea.setColumnHidden(2, true);
		p_gridArea.setColumnHidden(10, true);
		p_gridArea.setColumnHidden(11, true);
		p_gridArea.setColumnHidden(12, true);
	}
	
	function setGridData(){
		var sourceClassCode = $("#sourceClassCode").val();
		var targetClassCode = $("#targetClassCode").val();	
		var sourceName = $("#sourceName").val();
		var targetName = $("#targetName").val();	
		
		var result = new Object();
		result.title = "${title}";
		result.key =  "model_SQL.getElementCxnItemList";
		result.header = "${menu.LN00024},#master_checkbox,No,Source Class,Source ID,Source Nmae,Target Class,Target ID,Target Name,Connection Name,ObjectID,SourceItemID,TargetItemID";
		result.cols = "CHK|SortNum|SourceClassName|SourceID|SourceName|TargetClassName|TargetID|TargetName|ConnectionName|ObjectID|SourceItemID|TargetItemID";
		result.widths = "30,30,30,80,70,*,80,70,*,150,0,50,50";
		result.aligns = "center,center,center,center,center,left,center,center,left,center,center";
		result.sorting = "int,int,int,str,str,str,str,str,str,str,str";
		result.data = "modelID=${modelID}"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"				
					if(sourceClassCode != null && sourceClassCode != ''){
						result.data = result.data + "&sourceClassCode="+sourceClassCode;
					}
					if(sourceName != null && sourceName != ''){
						result.data = result.data + "&sourceName="+sourceName;
					}
					if(targetClassCode != null && targetClassCode != ''){
						result.data = result.data + "&targetClassCode="+targetClassCode;
					}
					if(targetName != null && targetName != ''){
						result.data = result.data + "&targetName="+targetName;
					}
		return result;
	}
		
	function gridOnRowSelect(id, ind){
		var itemID = p_gridArea.cells(id,10).getValue();
		if(ind == 0){ 
			return; 
		}
		else if (ind == 3 || ind == 4 || ind == 5 ){
			itemID = p_gridArea.cells(id,11).getValue();
		}else if (ind == 6 || ind == 7 || ind == 8 ){
			itemID = p_gridArea.cells(id,12).getValue();
		}else if (ind == 9){
			itemID = p_gridArea.cells(id,10).getValue();
		}
		
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop";
		var w = 1200;
		var h = 900; 
		itmInfoPopup(url,w,h,itemID);
	}
	
	function fnEditSortNum(){
		var checkedRows = p_gridArea.getCheckedRows(1).split(",");	;
		if(p_gridArea.getCheckedRows(1).length == 0){	
			alert("${WM00020}");		
			return;
		}
		
		var itemIDs = new Array;
		for(var i = 0 ; i < checkedRows.length; i++ ){
			itemIDs[i] = p_gridArea.cells(checkedRows[i], 10).getValue();
		}
	
		var modelID = "${modelID}";
		var url = "openEditModelSortNum.do?modelID="+modelID+"&itemIDs="+itemIDs+"&cxnYN=Y";
		var w = 600;
		var h = 400;
		itmInfoPopup(url,w,h);
	}
	
</script>
<form name="elementFrm" id="elementFrm" action="#" method="post" onsubmit="return false;">
	<div id="divMDList" class="hidden" style="width:98%;height:100%;">
	<div style="overflow:auto;overflow-x:hidden;">			
		<div class="child_search">		
		 <li class="shortcut">
		 	&nbsp;&nbsp;&nbsp;
		 	Source Class
			<select id="sourceClassCode" name="sourceClassCode" class="sel" style="width:150px;margin-left=5px;"></select>
	 	 	&nbsp;&nbsp;&nbsp;
	 	 	Source Name
	 	 	<input type="text" id="sourceName" name="sourceName" value="" class="text" style="width:150px;ime-mode:active;">
	 	 	Target Class
			<select id="targetClassCode" name="targetClassCode" class="sel" style="width:150px;margin-left=5px;"></select>
	 	 	&nbsp;&nbsp;&nbsp;
	 	 	Target Name	 	 	
	 	 	<input type="text" id="targetName" name="targetName" class="text" style="width:150px;ime-mode:active;">
			<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchList()" value="Search">
	   	 </li>
		<li class="floatR pdR20">
			<c:if test="${modelInfo.ModelBlocked eq '0' && ( modelInfo.IsPublic eq '1' || myItem eq 'Y') }">	
			<!--span class="btn_pack medium icon"><span class="confirm"></span><input value="Edit" onclick="fnEditSortNum()" type="submit"></span-->
			</c:if>
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</li>			
		</div>
		<div class="countList">
              <li class="count">Total  <span id="TOT_CNT"></span></li>
              <li class="floatR">&nbsp;</li>
          </div>
		<div id="gridDiv" class="mgB10 clear">
			<div id="grdGridArea" style="width:100%;"></div>
		</div>
	</div>
</form>
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>	