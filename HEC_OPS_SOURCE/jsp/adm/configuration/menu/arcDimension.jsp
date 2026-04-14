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
		fnSelect('objTypeCode', '', 'itemTypeCode', '', 'Select'); 
		fnSelect('dimTypeId', data, 'getDimTypeId', '', 'Select'); 
		fnSelect('dimValueId', data, 'getDimTypeValueId', '', 'Select'); 
	});	
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit(){		
		var d = setOTGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);	
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		p_gridArea.setColumnHidden(5,true);
		p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowOTSelect(id,ind);
		});
		
	}
	
	function setOTGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "config_SQL.getArcFilterDimList";
		result.header = "${menu.LN00024},#master_checkbox,ObjTypeName,DimTypeName,DimValueName,DimTypeID";
		result.cols = "CHK|ObjTypeName|DimTypeName|DimValueName|DimTypeID"; 
		result.widths = "50,30,180,180,180,50"; 
		result.sorting = "int,int,str,str,str,str"; 
		result.aligns = "center,center,center,center,center,center"; 
		result.data = "arcCode=${arcCode}&languageId=${languageID}";
		return result;
	}
	
	function fnAddArcDim(){
		$("#newArcDim").attr('style', 'display: block');	
		$("#newArcDim").attr('style', 'width: 100%');	
		$("#divSaveArcDim").attr('style', 'display: block');	
	}
		
	//조회
	function doOTSearchList(){
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	//그리드ROW선택시
	function gridOnRowOTSelect(id, ind){
		var url    = "SubAttributeType_SortNum.do"; // 요청이 날라가는 주소
		var data   = "&SortNum="+ p_gridArea.cells(id, 2).getValue() +
					 "&AttrTypeCode="+ p_gridArea.cells(id, 3).getValue() +
					 "&Mandatory=" + p_gridArea.cells(id, 6).getValue() +
					 "&ItemClassCode=${s_itemID}" +
					 "&ClassName=${ClassName}" +
					 "&languageID=${languageID}"
					 + "&CategoryCode=${CategoryCode}&ItemTypeCode=${ItemTypeCode}&pageNum=${pageNum}";
		var target = "testDiv";
		ajaxPage(url, data, target);	
	}
	
	function fnSaveArcDim(){
		if(confirm("${CM00012}")){
			var objTypeCode = $("#objTypeCode").val();
			var dimTypeId = $("#dimTypeId").val();
			var dimValueId = $("#dimValueId").val();
			var url = "saveArcDim.do";
			var data = "arcCode=${arcCode}&objTypeCode="+objTypeCode+"&dimTypeId="+dimTypeId+"&dimValueId="+dimValueId; 
			var target = "ArcFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnCallBack(){ 
		$("#newArcDim").attr('style', 'display: none');	
		$("#divSaveArcDim").attr('style', 'display: none');	
		doOTSearchList();
		
	}
	
	function fnDeleteArcDim(){
		if (p_gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00023}");
			return;
		}
		var cnt  = p_gridArea.getRowsNum();
		var dimTypeId = new Array;
		var j = 0;
		for ( var i = 0; i < cnt; i++) { 
			chkVal = p_gridArea.cells2(i,1).getValue();
			if(chkVal == 1){
				dimTypeId[j]= p_gridArea.cells2(i, 5).getValue();
				j++;
			}
		}

		if(confirm("${CM00004}")){
			var url = "deleteArcDim.do";
			var data = "&arcCode=${arcCode}&dimTypeId="+dimTypeId;
			var target = "ArcFrame";
			ajaxPage(url, data, target);	
		}
	}
	
	function fnGetDimValue(dimTypeId){
		var data = "&LanguageID=${languageID}&dimTypeId="+dimTypeId;
		fnSelect('dimValueId', data, 'getDimTypeValueId', '', 'Select'); 
	}
</script>
</head>
<body>
	<form name="SubAttrTypeList" id="SubAttrTypeList" action="*" method="post" onsubmit="return false;">
	<input type="hidden" id="ItemTypeCode" name="ItemTypeCode" value="${ItemTypeCode}">
	<input type="hidden" id="ItemClassCode" name="ItemClassCode" value="${s_itemID}">
	<input type="hidden" id="AttrTypeCode" name="AttrTypeCode">
	<div class="cfgtitle">
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Architecture Filter Dimension</li>
		</ul>
	</div>
	<div class="child_search mgL10 mgR10">	
		<li class="floatR pdR20">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="submit" onclick="fnGoBack()"></span>		
				<span class="btn_pack medium icon"><span class="add"></span><input value="Add" type="submit" onclick="fnAddArcDim()"></span>
				<span class="btn_pack medium icon"><span class=del></span><input value="Del" type="submit" onclick="fnDeleteArcDim()"></span>
			</c:if>
		</li>		
	</div>
	</form>
	<div id="gridDiv" class="mgT10 mgL10 mgR10">
		<div id="grdGridArea" style="height:300px; width:100%"></div>
	</div>
	
	<div class="mgT10 mgL10 mgR10">
	<table id="newArcDim" class="tbl_blue01" width="100%"   cellpadding="0" cellspacing="0" style="display:none">
		<colgroup>
			<col width="33%">
		    <col width="33%">
		 	<col width="34%">		 
		</colgroup>	
	
		<tr>
			<th class="viewtop last">Item Type</th>
			<th class="viewtop last">Dimension type</th>
			<th class="viewtop last">Dimension Value</th>
		</tr>
		<tr>
			<td class="last"><select id="objTypeCode" name="objTypeCode" class="sel" ></select></td>
			<td class="last"><select id="dimTypeId" name="dimTypeId" class="sel" OnChange="fnGetDimValue(this.value)"></select></td>
			<td class="last"><select id="dimValueId" name="dimValueId" class="sel" ></select></td>
		</tr>
	</table>
	</div>
	
	<div  class="alignBTN" id="divSaveArcDim" style="display: none;">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<span class="btn_pack medium icon mgR20"><span  class="save"></span><input value="Save" onclick="fnSaveArcDim()"  type="submit"></span>
		</c:if>		
	</div>	
	
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="ArcFrame" id="ArcFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
</body>
</html>