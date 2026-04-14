<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="Name"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>


<!-- 2. Script -->
<script type="text/javascript">
	var pp_grid;				//그리드 전역변수
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {	
		$('.searchPList').click(function(){doPSearchList();});
		$("#searchValue").focus();	
		//$('#searchValue').keypress(function(onkey){if(onkey.keyCode == 13){doPSearchList();return false;}});
		
		PgridInit();
		doPSearchList();
	});	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function PgridInit(){		
		var d = setPGridData();
		pp_grid = fnNewInitGrid("gridArea", d);
		pp_grid.setImagePath("${root}${HTML_IMG_DIR}/");
		//pp_grid.setColumnHidden(5, true);
		//pp_grid.setColumnHidden(6, true);
		pp_grid.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowSelect(id,ind);
		});
	}
	
	function setPGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "link_SQL.getAttrTypeInfoList";
		result.header = "${menu.LN00024},MenuID,화면,Parameter,SystemType";
		result.cols = "TCode|ItemName|Parameter|SystemTypeText";
		result.widths = "30,60,220,120,100";
		result.sorting = "int,str,str,str,str,str";
		result.aligns = "center,center,left,left,left,left";
		result.data = "itemID=${itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		return result;
	}
	
	//조회
	function doPSearchList(){
		var d = setPGridData();
		fnLoadDhtmlxGridJson(pp_grid, d.key, d.cols, d.data, false);
	}
	
	function gridOnRowSelect(id, ind){
		var menuID = pp_grid.cells(id,1).getValue();
		var parameter = pp_grid.cells(id,3).getValue();
		var systemType = pp_grid.cells(id,4).getValue()
		opener.fnLinkLFWeb(menuID,parameter,systemType);
		self.close();
	}
	
</script>

</head>
<body>
<form name="userNameListFrm" id="userNameListFrm" action="#" method="post" onsubmit="return false;">
<div id="attrDiv" style="padding: 0 6px 0 6px;"> 
	<div>
		<ul>
			<li>
				<h3 style="padding: 6px 0 0 0;">
					<img src="${root}${HTML_IMG_DIR}/category.png">Select Menu
				</h3>
			</li>
		</ul>
	</div>
	<div style="border-bottom:1px solid #ccc;">&nbsp;</div>
	<div class="countList">
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">&nbsp;</li>
    </div>
	<div id="gridDiv" class="mgB10 clear">
		<div id="gridArea" style="height: 280px; width: 100%"></div>
	</div>
	<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>
   </div>
</form>
</body>
</html>