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
	});	
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit(){		
		var d = setOTGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);	
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowOTSelect(id,ind);
		});
	}
	
	function setOTGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "procConfig_SQL.getPimMenuList";
		result.header = "${menu.LN00024},MenuID,MenuName,URL";
		result.cols = "MenuID|MenuName|URL"; 
		result.widths = "50,100,180,180"; 
		result.sorting = "int,str,str,str"; 
		result.aligns = "center,center,left,left"; 
		result.data = "languageId=${languageID}&menuCat=${menuCat}&ItemID=${s_itemID}";
		return result;
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
	
	function fnAddMenu(){
		var idx = p_gridArea.getSelectedRowId();
		var menuId = p_gridArea.cells(idx,1).getValue();
		var menuName = p_gridArea.cells(idx,2).getValue();
	
		opener.fnSetMenu(menuId, menuName);
		self.close();
	}
	
</script>
</head>
<body>
	<form name="SubAttrTypeList" id="SubAttrTypeList" action="*" method="post" onsubmit="return false;">
	<div class="cfgtitle">
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Menu</li>
		</ul>
	</div>
	<div class="child_search">	
		<li class="floatR pdR20">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">	
				<span class="btn_pack medium icon"><span class="add"></span><input value="Add" type="submit" onclick="fnAddMenu()"></span>
			</c:if>
		</li>		
	</div>
	<div id="gridDiv" class="mgT10 clear">
		<div id="grdGridArea" style="height:300px; width:100%;"></div>
	</div>
	</form>
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="ArcFrame" id="ArcFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
</body>
</html>