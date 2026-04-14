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
		fnSelect('classCode', data, 'getElementClassCode', '', 'Select');
		
		gridInit();		
		doSearchList();
	});
	
	function urlReload(){
		gridInit();		
		doSearchList();
	}
	
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
		fnSetColType(p_gridArea, 3, "img");
		p_gridArea.setColumnHidden(0, true);
		//p_gridArea.setColumnHidden(2, true);
		p_gridArea.setColumnHidden(13, true);
	}
	
	function setGridData(){
		var classCode = $("#classCode").val();	
		var result = new Object();
		result.title = "${title}";
		result.key =  "model_SQL.getElementItemList";
		result.header = "${menu.LN00024},#master_checkbox,Seq.,${menu.LN00042},${menu.LN00016},${menu.LN00106},${menu.LN00028},Path,${menu.LN00027},${menu.LN00014},${menu.LN00018},${menu.LN00004},${menu.LN00070},itemID,classCode,authorID";
		result.cols = "CHK|SortNum|ItemTypeImg|ClassName|Identifier|ItemName|Path|StatusName|ComTeamName|OwnerTeamName|AuthorName|LastUpdated|ItemID|ClassCode|AuthorID";
		result.widths = "30,30,30,50,70,70,*,*,60,100,80,70,80,0,0,0";
		result.aligns = "center,center,center,center,center,center,left,left,center,center,center,center,center,center";
		result.sorting = "int,int,int,str,str,str,str,str,str,str,str,str,str";
		result.data = "modelID=${modelID}"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"					
			        + "&searchKey="+ $("#searchKey").val()
			        + "&searchValue="+ $("#searchValue").val();				
					if(classCode != null && classCode != ''){
						result.data = result.data + "&classCode="+classCode
					}
		return result;
	}
		
	function gridOnRowSelect(id, ind){
		if(ind == 0){ return; }
		var itemID = p_gridArea.cells(id,13).getValue();
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
		var h = 600;
		itmInfoPopup(url,w,h);
	}
	
	function fnEditAttr(){
		var checkedRows = p_gridArea.getCheckedRows(1).split(",");	;
		if(p_gridArea.getCheckedRows(1).length == 0){	
			alert("${WM00023}");		
			return;
		}
		
		var itemIDs = new Array;
		var classCodes = new Array;
		var sessionUserID = "${sessionScope.loginInfo.sessionUserId}";
		
		for(var i = 0 ; i < checkedRows.length; i++ ){					
			if(sessionUserID != p_gridArea.cells(checkedRows[i], 15).getValue()){
				alert(p_gridArea.cells(checkedRows[i], 6).getValue() + "은  ${WM00040}");
				return;
			}
			itemIDs[i] = p_gridArea.cells(checkedRows[i], 13).getValue();
			classCodes[i] = p_gridArea.cells(checkedRows[i], 14).getValue();
			
		}
		
		var modelID = "${modelID}";
		var url = "selectAttributePop.do?classCodes="+classCodes+"&items="+itemIDs;
		$("#items").val(itemIDs);
		var w = 600;
		var h = 600;
		itmInfoPopup(url,w,h);
	}
	
</script>
<form name="elementFrm" id="elementFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="items" name="items" >
	<div id="divMDList" class="hidden" style="width:98%;height:100%;">
	<div style="overflow:auto;overflow-x:hidden;">			
		<div class="child_search">		
		 <li class="shortcut">
		 	&nbsp;&nbsp;&nbsp;	${menu.LN00016} &nbsp;&nbsp;
			<select id="classCode" name="classCode" class="sel" style="width:250px;margin-left=5px;"></select>
	 	 	&nbsp;&nbsp;&nbsp;
	 	 	<select id="searchKey" name="searchKey" style="width:120px;">
				<option value="Name">Name</option>
				<option value="ID" <c:if test="${!empty searchID}"> selected="selected" </c:if> >ID</option>
			</select>			
			<input type="text" class="text"  id="searchValue" name="searchValue" value="${searchValue}" style="width:250px;">
			<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchList()" value="Search">
	   	 </li>
		<li class="floatR pdR20">
			<c:if test="${modelInfo.ModelBlocked eq '0' && myItem eq 'Y'}">	
			<span class="btn_pack medium icon"><span class="edit"></span><input value="Attribute" onclick="fnEditAttr()" type="submit"></span>
			<span class="btn_pack medium icon"><span class="edit"></span><input value="Sequence" onclick="fnEditSortNum()" type="submit"></span>
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