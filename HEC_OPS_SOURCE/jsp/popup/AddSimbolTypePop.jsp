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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00034" var="CM00034" />

<!-- 2. Script -->
<script type="text/javascript">

var p_gridArea;				//그리드 전역변수
var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용



$(document).ready(function() {	

	//Grid 초기화
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
	p_gridArea.setColumnHidden(3, true);
	p_gridArea.setColumnHidden(4, true);
	p_gridArea.setColumnHidden(5, true);
	p_gridArea.setColumnHidden(8, true);
	p_gridArea.setColumnHidden(9, true);
	p_gridArea.setColumnHidden(10, true);
	p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
	
}

function setOTGridData(){


	var result = new Object();
	result.title = "${title}";
	
	result.key = "config_SQL.SelectAddSimbolType";
	result.header = "${menu.LN00024},#master_checkbox,SymTypeCode,ItemTypeCode,ClassCode,ItemCategory,Name,Description,ArisTypeNum,FromSymType,ToSymType,ImagePath";	
	// #master_checkbox =  check box 전체선택
	
	result.cols = "CHK|SymTypeCode|ItemTypeCode|ClassCode|ItemCategory|Name|Description|ArisTypeNum|FromSymType|ToSymType|ImagePath"; 
	
	result.widths = "50,50,100,100,100,100,100,150,100,100,100,450"; 
	result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str"; 
	result.aligns = "center,center,center,center,center,center,center,center,center,center,center,left"; 
	
	result.data =  "ModelTypeCode=${ModelTypeCode}"	
	 			+ "&LanguageID=${LanguageID}";
	return result;

}

// END ::: GRID	
//===============================================================================

	
//조회
function doOTSearchList(){
	var d = setOTGridData();
	fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
}

/*function CompleteSave(){
	
	var url = "SubAttributeTypeAllocation.do";
	var data = "&languageID=${languageID}&s_itemID=${TypeCode}&ItemTypeCode=${ItemTypeCode}&ClassName=${ClassName}";
	var target = "AddClassTypeList";
	
	ajaxPage(url, data, target);
	
}*/
function SaveSymbolType(){
	
	if (p_gridArea.getCheckedRows(1).length == 0) {
		alert("${WM00023}");
	} else {
		if (confirm("${CM00034}")) {
			var checkedRows = p_gridArea.getCheckedRows(1).split(",");
			for ( var i = 0; i < checkedRows.length; i++) {
				var url = "AddSymbolType.do";

				var data = "&SymTypeCode=" + p_gridArea.cells(checkedRows[i], 2).getValue()
						+ "&ItemTypeCode=" + p_gridArea.cells(checkedRows[i], 3).getValue()
						+ "&ClassCode=" + p_gridArea.cells(checkedRows[i], 4).getValue()
						+ "&ItemCategory=" + p_gridArea.cells(checkedRows[i], 5).getValue()
						+ "&ModelTypeCode=${ModelTypeCode}"
						+ "&LanguageID=${LanguageID}";
						
				if (i + 1 == checkedRows.length) {
					data = data + "&FinalData=Final";
				}

				var target = "ArcFrame";
		
				ajaxPage(url, data, target);
				//p_gridArea.deleteRow(checkedRows[i]);
			}
		}
	}
	
}

//[save] 이벤트 후 처리
function selfClose() {
	//var opener = window.dialogArguments;
	opener.doOTSearchList();
	self.close();
}

</script>
<body>
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${Name} > Add Simbol Type</p>
	</div>
	<form name="AddClassTypeList" id="AddClassTypeList"	action="*" method="post" onsubmit="return false;">
		<input type="hidden" id="SaveType" name="SaveType" value="Edit" /> 
		<input type="hidden" id="Name" name="Name" value="${Name}" /> 
		<input type="hidden" id="Creator" name="Creator" value="${sessionScope.loginInfo.sessionUserId}" />
		<div id="gridDiv" class="mgB10 mgT5 mgL5 mgR5">
			<div id="grdGridArea" style="height:400px; width:100%"></div>
		</div>
		<ul>
			<li class="floatR pdR20">
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
						<span class="btn_pack medium icon"><span class="save"></span><input value="save" type="submit" onclick="SaveSymbolType()"></span>
					</c:if>
			</li>
		</ul>
	</form>
		<!-- START :: FRAME -->
		<div class="schContainer" id="schContainer">
			<iframe name="ArcFrame" id="ArcFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
		</div>
</body>
</html>