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
	var parentID = parseInt("${modelID}") + 1;  
	$(document).ready(function(){	
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 500)+"px;");

		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 500)+"px;");
		};
		
		$("#excel").click(function(){p_gridArea.toExcel("${root}excelGenerate");});
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&modelID=${modelID}";
		fnSelect('groupClassCode', data, 'getGroupElementClassCode', '', 'Select');		
		fnSelect('groupElementCode', data, 'getGroupElementCode', '', 'Select');
		
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
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR_ITEM}/");//path to images required by grid
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");		
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		fnSetColType(p_gridArea, 1, "ch");
		
		p_gridArea.setColumnHidden(1, true);
		p_gridArea.setColumnHidden(2, true);
		p_gridArea.setColumnHidden(9, true);
		p_gridArea.setColumnHidden(10, true);
	}
	
	function setGridData(){
		var groupClassCode = $("#groupClassCode").val();
		var groupElementCode = $("#groupElementCode").val();
		
		var result = new Object();
		result.title = "${title}";
		result.key =  "model_SQL.getGroupElementItemList";
		result.header = "${menu.LN00024},#master_checkbox,No,Group Class,Group ID,Group Name,Sub  Element Class, Sub Element ID, Element Name,GroupItemID,ChildItemID";
		result.cols = "CHK|SortNum|GroupClassName|GroupID|GroupItemName|ChildClassName|ChildID|ChildItemName|GroupItemID|ChildItemID";
		result.widths = "30,30,90,90,95,*,120,95,*,50,50";
		result.aligns = "center,center,center,center,center,left,center,center,left,center,center";
		result.sorting = "int,int,int,str,str,str,str,str,str,str,str";
		result.data = "modelID=${modelID}"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&parentID="+parentID;		
					if(groupClassCode != null && groupClassCode != ''){
						result.data = result.data + "&groupClassCode="+groupClassCode;
					}
					if(groupElementCode != null && groupElementCode != ''){
						result.data = result.data + "&groupElementCode="+groupElementCode;
					}
		return result;
	}
		
	function gridOnRowSelect(id, ind){
		var itemID = "";
		if(ind == 0){ return; 
		}else if (ind == 3 || ind == 4 || ind == 5 ){
			itemID = p_gridArea.cells(id,9).getValue();
		}else if (ind == 6 || ind == 7 || ind == 8 ){
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
			itemIDs[i] = p_gridArea.cells(checkedRows[i], 13).getValue();
		}
	
		var modelID = "${modelID}";
		var url = "openEditModelSortNum.do?modelID="+modelID+"&itemIDs="+itemIDs;
		var w = 600;
		var h = 400;
		itmInfoPopup(url,w,h);
	}
	
	function fnGetGroupElementList(classCode){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&modelID=${modelID}&classCode="+classCode;
		fnSelect('groupElementCode', data, 'getGroupElementCode', '', 'Select');
	}
	
</script>
<form name="elementFrm" id="elementFrm" action="#" method="post" onsubmit="return false;">
	<div id="divMDList" class="hidden" style="width:98%;height:100%;">
	<div style="overflow:auto;overflow-x:hidden;">			
		<div class="child_search">		
		 <li class="shortcut">
		 	&nbsp;&nbsp;&nbsp;Element Group Class
			<select id="groupClassCode" name="groupClassCode" class="sel" OnChange="fnGetGroupElementList(this.value);" style="width:250px;margin-left=5px;"></select>
	 	 	&nbsp;&nbsp;&nbsp;Element Group
			<select id="groupElementCode" name="groupElementCode" class="sel" style="width:250px;margin-left=5px;"></select>
	 	 	&nbsp;&nbsp;&nbsp;
			<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchList()" value="Search">
	   	 </li>
		<li class="floatR pdR20">
			<c:if test="${modelInfo.ModelBlocked eq '0' && ( modelInfo.IsPublic eq '1' || myItem eq 'Y') }">	
			<!-- <span class="btn_pack medium icon"><span class="confirm"></span><input value="Edit" onclick="fnEditSortNum()" type="submit"></span> -->
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