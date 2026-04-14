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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012" />

<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {
		gridOTInit();
		doOTSearchList();
		var data = "&LanguageID=${languageID}";
		fnSelect('conTypeCode', data, 'conTypeCode', '', 'Select'); 
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
			//gridOnRowOTSelect(id,ind);
		});
	}
	
	function setOTGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "config_SQL.getArcFilterList";
		result.header = "${menu.LN00024},#master_checkbox,ConTypeCode,ConTypeName,RootItemID,RootItemName";	
		result.cols = "CHK|ConTypeCode|ConTypeName|RootItemID|RootItemName"; 
		result.widths = "50,50,100,200,100,180"; 
		result.sorting = "int,int,str,str,str,str"; 
		result.aligns = "center,center,center,center,center,center"; 
		result.data = "ArcCode=${ArcCode}&LanguageID=${languageID}";
		return result; 
	}
			
	//조회
	function doOTSearchList(){
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	function fnAddArcFilterPop(){
		var url = "addArcFilterListPop.do?LanguageID=${languageID}&ArcCode=${ArcCode}"; 
		var w = 700;
		var h = 600;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function fnAddArcFilter(){
		$("#newArcFilter").attr('style', 'display: block');	
		$("#newArcFilter").attr('style', 'width: 100%');	
		$("#divSaveArcFilter").attr('style', 'display: block');	
	}
	
	function fnDeleteArcFilter(){
		if (p_gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00023}");
			return;
		}
		var cnt  = p_gridArea.getRowsNum();
		var conTypeCodeArr = new Array;
		var rootItemIDArr = new Array;
		var j = 0;
		for ( var i = 0; i < cnt; i++) { 
			chkVal = p_gridArea.cells2(i,1).getValue();
			if(chkVal == 1){
				conTypeCodeArr[j] = p_gridArea.cells2(i, 2).getValue();
				rootItemIDArr[j] = p_gridArea.cells2(i, 4).getValue();
				j++;
			}
		}
		
		if(confirm("${CM00004}")){
			var url = "deleteArcFilter.do";
			var data = "&arcCode=${ArcCode}&conTypeCode="+conTypeCodeArr+"&rootItemID="+rootItemIDArr;
			var target = "ArcFrame";
			ajaxPage(url, data, target);	
		}
	}
			
	//그리드ROW선택시
	function gridOnRowOTSelect(id, ind){
		var url    = "SubAttributeType_SortNum.do"; // 요청이 날라가는 주소
		var data   = "&SortNum="+ p_gridArea.cells(id, 2).getValue() +
					 "&AttrTypeCode="+ p_gridArea.cells(id, 3).getValue() +
					 "&ItemClassCode=${s_itemID}" +
					 "&ClassName=${ClassName}" +
					 "&languageID=${languageID}"
					 + "&CategoryCode=${CategoryCode}&ItemTypeCode=${ItemTypeCode}&pageNum=${pageNum}";
		var target = "arcFilterDiv";
		ajaxPage(url, data, target);	
	}
	
	function fnGetTreePop(){
		var url = "searchRootItemTreePop.do";
		var conTypeCode = $("#conTypeCode").val();
		var data = "LanguageID=${languageID}&ArcCode=${ArcCode}&conTypeCode="+conTypeCode;
		
		fnOpenLayerPopup(url,data,doCallBackMove,617,436);
	}
	
	function doCallBackMove(){}
	
	function fnSaveArcFilter(){
		if(confirm("${CM00012}")){
			var rootItemId = $("#rootItemID").val();
			var conTypeCode = $("#conTypeCode").val();
			
			var url = "saveArcFilter.do";
			var data = "rootItemId=" + rootItemId + "&conTypeCode="+conTypeCode+"&arcCode=${ArcCode}"; 
			
			var target = "ArcFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnCallBack(){ 
		$("#newArcFilter").attr('style', 'display: none');	
		$("#divSaveArcFilter").attr('style', 'display: none');	
		doOTSearchList();
	}

</script>
</head>
<body>
	<form name="arcFilterFrm" id="arcFilterFrm" action="*" method="post" onsubmit="return false;">
	<div class="cfgtitle">
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Architecture Filter</li>
		</ul>
	</div>
	<div class="child_search mgL10 mgR10">	
		<li class="floatR pdR20">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="submit" onclick="fnGoBack()"></span>		
				<span class="btn_pack medium icon"><span class="add"></span><input value="Add" type="submit" onclick="fnAddArcFilter()"></span>
				<span class="btn_pack medium icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDeleteArcFilter()"></span>
			</c:if>
		</li>		
	</div>
	</form>
	<div id="gridDiv" class="mgT10 mgL10 mgR10">
		<div id="grdGridArea" style="height:300px; width:100%"></div>
	</div>
	
     <div class="mgT10 mgL10 mgR10">
	<table id="newArcFilter" class="tbl_blue01" width="100%"   cellpadding="0" cellspacing="0" style="display:none">
		<tr>
			<th class="viewtop last">ConTypeCode</th>
			<th class="viewtop last">RootItem</th>
		</tr>
		<tr>
			<td class="last"><select id="conTypeCode" name="conTypeCode" class="sel" ></select></td>
			<td class="last">
				<input type="text" class="text" id="rootItemName" name="rootItemName" OnClick="fnGetTreePop()" />
				<input type="hidden" class="text" id="rootItemID" name="rootItemID" />
			</td>
		</tr>
	</table>
    </div>
    
	<div class="alignBTN" id="divSaveArcFilter" style="display: none;">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<span class="btn_pack medium icon mgR20"><span  class="save"></span><input value="Save" onclick="fnSaveArcFilter()"  type="submit"></span>
		</c:if>		
	</div>	
	
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="ArcFrame" id="ArcFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
</body>
</html>