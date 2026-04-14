<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>

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
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");
	}

	function setOTGridData(){	
		var result = new Object();
		result.title = "${title}";
		result.key = "config_SQL.getBoardCatList";
		result.header = "${menu.LN00024},#master_checkbox,CategoryCode,CategoryName";
		result.cols = "CHK|BoardCategoryCode|BoardCategoryName"; 
		result.widths = "50,50,80,180";
		result.sorting = "int,int,str,str";
		result.aligns = "center,center,center,left";
		result.data = "languageID=${languageID}&boardMgtID=${boardMgtID}";			
		return result;
	}

	//조회
	function doOTSearchList(){
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	function fnAddBoardMgtAlloc(id, ind){		
		if(p_gridArea.getCheckedRows(1).length == 0){
			alert("${WM00023}");
			return;
		}else{
			if(confirm("${CM00012}")){
				var boardCatgoryCode = new Array();
				var checkedRows = p_gridArea.getCheckedRows(1).split(",");
				var j = 0;
				for ( var i = 0; i < checkedRows.length; i++) {
					boardCatgoryCode[j] = p_gridArea.cells(checkedRows[i],2).getValue(); 
					j++;
				}
				var url = "addBoardMgtCatAlloc.do";
				var data = "&boardMgtID=${boardMgtID}&boardCatgoryCode="+boardCatgoryCode;
				var target = "addFrame";
				ajaxPage(url, data, target); 
			}
		}
	}
	
	function fnCallBack(){
		opener.fnCallBack();
		self.close();
	}
	
	
	
</script>
<body>
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Add Template</p>
	</div>
	<div id="gridDiv" class="mgB10 mgL5 mgR5 mgT5">
	<div id="grdGridArea" style="height:250px; width:100%"></div>
	</div>
	<div class="floatR pdR20 pdB10">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit"  alt="신규" onclick="fnAddBoardMgtAlloc()" ></span>
		</c:if>
	</div>	
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="addFrame" id="addFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
</body>

</html>