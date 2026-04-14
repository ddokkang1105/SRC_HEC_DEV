<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

<!-- 2. Script -->
<script type="text/javascript">

	var p_gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용

	$(document).ready(function() {	
		gridOTInit();
		doOTSearchList();
	});	
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit(){		
		var d = setOTGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);	
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowOTSelect(id,ind);
		});
	}
	
	function setOTGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "config_SQL.getBoardCatAllocList";
		result.header = "${menu.LN00024},#master_checkbox,CategoryCode,CategoryName,SortNum";
		result.cols = "CHK|CategoryCode|CategoryName|SortNum";
		result.widths = "50,50,100,160,100";
		result.sorting = "int,int,str,str,str"; 
		result.aligns = "center,center,center,center,center";
		result.data = "languageID=${languageID}&boardMgtID=${boardMgtID}";
		return result;
	}
	
	function fnAddBrdCat(){
		var url = "addBrdCatListPop.do?languageID=${languageID}&boardMgtID=${boardMgtID}";
		var w = 400;
		var h = 400;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function fnDeleteBoardMgtCatAlloc(){
		if (p_gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00023}");
			return;
		}
		var cnt  = p_gridArea.getRowsNum();
		var boardCategoryCode = new Array;
		var j = 0;
		for ( var i = 0; i < cnt; i++) { 
			chkVal = p_gridArea.cells2(i,1).getValue();
			if(chkVal == 1){
				boardCategoryCode[j]= p_gridArea.cells2(i, 2).getValue();
				j++;
			}
		}
		
		if(confirm("${CM00004}")){
			var url = "deleteBoardMgtCatAlloc.do";
			var data = "&boardCategoryCode="+boardCategoryCode+"&boardMgtID=${boardMgtID}&languageID=${languageID}&pageNum=${pageNum}";
			var target = "saveFrame";
			ajaxPage(url, data, target);	
		}
	}
			
	//조회
	function doOTSearchList(){ 
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	//그리드ROW선택시
	function gridOnRowOTSelect(id, ind){ 
		$("#editStNum").attr('style', 'display: block');	
		$("#editStNum").attr('style', 'width: 100%');	
		$("#divSaveStNum").attr('style', 'display: block');	
		$("#sortNum").val(p_gridArea.cells(id,4).getValue());
		$("#sortNum").focus();
		$("#categoryCode").val(p_gridArea.cells(id,2).getValue());
	}
	
	function fnGoBack(){
		var url = "boardMgtDetail.do";
		var target = "boardMgtDiv";
		var data = "&boardMgtID=${boardMgtID}&pageNum=${pageNum}&languageID=${languageID}&viewType=${viewType}";	
		ajaxPage(url,data,target);
	}
	
	function fnSaveStNum(){
		if(confirm("${CM00001}")){
			var sortNum = $("#sortNum").val();
			var categoryCode = $("#categoryCode").val();
			var url = "updateBoardMgtCatAllocStNum.do";
			var data = "&boardMgtID=${boardMgtID}&categoryCode="+categoryCode+"&sortNum="+sortNum+"&pageNum=${pageNum}&languageID=${languageID}"; 
			var target = "saveFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnCallBack(){ 
		$("#editStNum").attr('style', 'display: none');	
		$("#divSaveStNum").attr('style', 'display: none');
		$("#sortNum").val("");
		$("#categoryCode").val("");
		
		gridOTInit();
		doOTSearchList();
	}

	
</script>
</head>
<body>
	<form name="allocBoardMgt" id="allocBoardMgt" action="*" method="post" onsubmit="return false;">
	<div class="cfgtitle">
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Board Management Allocation</li>
		</ul>
	</div>
	<div class="child_search mgL10 mgR10">	
		<li class="floatR pdR20">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="submit" onclick="fnGoBack()"></span>		
				<span class="btn_pack medium icon"><span class="add"></span><input value="Add" type="submit" onclick="fnAddBrdCat()"></span>
				<span class="btn_pack medium icon"><span class=del></span><input value="Del" type="submit" onclick="fnDeleteBoardMgtCatAlloc()"></span>
			</c:if>
		</li>		
	</div>
	<div id="gridDiv" class="mgT10  mgL10 mgR10">
		<div id="grdGridArea" style="height:300px; width:100%"></div>
	</div>
	<div class="mgT10 mgL10 mgR10">
	<table id="editStNum" class="tbl_blue01" width="100%"   cellpadding="0" cellspacing="0" style="display:none">
		<tr>
			<th>SortNum</th>
			<td class="last">
				<input type="text" id="sortNum" name="sortNum" class="text" value="" />
				<input type="hidden" id="categoryCode" name="categoryCode" >
			</td>
		</tr>
	</table>
	</div>
	<div  class="alignBTN" id="divSaveStNum" style="display: none;">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<span class="btn_pack medium icon"><span  class="save"></span><input value="Save" onclick="fnSaveStNum()"  type="submit"></span>
		</c:if>		
	</div>
	</form>
		<!-- START :: FRAME -->
		<div class="schContainer" id="schContainer">
			<iframe name="saveFrame" id="saveFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
		</div>
</body>
</html>