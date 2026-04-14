<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

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
	p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
	
}

function setOTGridData(){


	var result = new Object();
	result.title = "${title}";
	
	result.key = "procConfig_SQL.AddItemFileType";
	result.header = "${menu.LN00024},#master_checkbox,FltpCode,Name,FilePath";	
	// #master_checkbox =  check box 전체선택
	
	result.cols = "CHK|FltpCode|Name|FilePath"; 
	
	result.widths = "50,50,100,200,200,"; 
	result.sorting = "int,int,str,str,str";
	result.aligns = "center,center,center,center,center"; 
	
	result.data =  "ItemID=${s_itemID}"
				+ "&varFilter=${varFilter}"
		 		+ "&languageID=${languageID}";
	 		
	return result;

}



// END ::: GRID	
//===============================================================================

	
//조회
function doOTSearchList(){
	var d = setOTGridData();
	fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
}

function SaveFileType(){
	
	if (p_gridArea.getCheckedRows(1).length == 0) {
		//alert("항목을 한개 이상 선택하여 주십시요.");
		alert("${WM00023}");
	} else {
		//if (confirm("선택된 항목을 저장하시겠습니까?")) {
		if (confirm("${CM00034}")) {
			var checkedRows = p_gridArea.getCheckedRows(1).split(",");
			var fileTypeCodes = "";
			
			for ( var i = 0; i < checkedRows.length; i++) {
				if (fileTypeCodes == "") {
					fileTypeCodes = p_gridArea.cells(checkedRows[i], 2).getValue();
				} else {
					fileTypeCodes = fileTypeCodes + "," +p_gridArea.cells(checkedRows[i], 2).getValue();
				}
			}
			
			var url = "pim_AddAllocItemFile.do";
			var data = "&fileTypeCodes=" + fileTypeCodes
						+ "&itemID=${s_itemID}&varFilter=${varFilter}";
			var target = "ArcFrame";
	
			ajaxPage(url, data, target);
		}
	}
}

//[save] 이벤트 후 처리
function selfClose() {
	//var opener = window.dialogArguments;
	opener.urlReload();
	self.close();
}

</script>
<body>
	<div class="child_search_head">
			<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Add File</p>
	</div>
	
	<form name="AddClassTypeList" id="AddClassTypeList"
		action="*" method="post" onsubmit="return false;">
	<input type="hidden" id="SaveType" name="SaveType" value="Edit" /> 

				<div id="gridDiv" class="mgB10 mgT5 mgL5 mgR5">
				<div id="grdGridArea" style="height:400px; width:100%"></div>
			</div>
		
		<ul>
			<li class="floatR pdR20">
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">					
						<span class="btn_pack medium icon"><span class="save"></span><input value="save" type="submit" onclick="SaveFileType()"></span>
					</c:if>
			</li>
		</ul>
	</form>
		<!-- START :: FRAME -->
		<div class="schContainer" id="schContainer">
			<iframe name="ArcFrame" id="ArcFrame" src="about:blank"
				style="display: none" frameborder="0" scrolling='no'></iframe>
		</div>
</body>
</html>
