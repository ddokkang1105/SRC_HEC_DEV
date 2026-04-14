<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<c:url value="/" var="root" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00034" var="CM00034" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012" />

<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea; //그리드 전역변수
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용

	$(document).ready(function() {
		//Grid 초기화
		gridOTInit();
		doOTSearchList();
	});

	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit() {
		var d = setOTGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		fnSetColType(p_gridArea, 1, "ch");
		//p_gridArea.setColumnHidden(2, true);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid

	}

	function setOTGridData() {
		var result = new Object();
		result.title = "${title}";
		result.key = "config_SQL.getArcListForAddTmpl";
		result.header = "${menu.LN00024},#master_checkbox,ArcCode,Level1,Level2";
		result.cols = "CHK|ArcCode|Level1|Level2";
		result.widths = "30,30,90,160,160";
		result.sorting = "int,str,str,str,str";
		result.aligns = "center,center,center,left,left";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&templCode=${templCode}";
		return result;
	}

	//조회
	function doOTSearchList() {
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}

	function fnSaveArc() {
		if (p_gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00023}");
			return;
		}
		var cnt  = p_gridArea.getRowsNum();
		var arcArr = new Array;
		var j = 0;
		for ( var i = 0; i < cnt; i++) { 
			chkVal = p_gridArea.cells2(i,1).getValue();
			if(chkVal == 1){
				arcArr[j]= p_gridArea.cells2(i, 2).getValue();
				j++;
			}
		}
		
		if(confirm("${CM00012}")){
			var url = "addArcTempl.do";
			var data = "arcCode=" + arcArr + "&templCode=${templCode}"
					+ "&languageID=${languageID}";
			var target = "ArcFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnCallBack(){	
		if(window.dialogArguments){
			opener = window.dialogArguments;
		}
		opener.doOTSearchList();
		window.close();
	}
	
</script>
<body>
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Add Architecture</p>
	</div>
	<form name="AddClassTypeList" id="AddClassTypeList" action="*" method="post" onsubmit="return false;">
		<div id="gridDiv" class="mgB10 mgT5 mgL5 mgR5">
			<div id="grdGridArea" style="height: 400px; width: 100%"></div>
		</div>
		<ul>
			<li class="floatR pdR20">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
					<span class="btn_pack medium icon"><span class="save"></span>
					<input value="save" type="submit" onclick="fnSaveArc()"></span>
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