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

<!-- 2. Script -->
<script type="text/javascript">
	var pp_grid1;				//그리드 전역변수
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {	
		PgridInit();
		doPSearchList();
	});	

	//그리드 초기화
	function PgridInit(){		
		var d = setPGridData();
		pp_grid1 = fnNewInitGrid("grdPAArea", d);
		pp_grid1.setImagePath("${root}${HTML_IMG_DIR}/");
		pp_grid1.setColumnHidden(5, true);
		pp_grid1.setColumnHidden(6, true);
		pp_grid1.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
	}
	
	function setPGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "model_SQL.getValidateElementLst";
		result.header = "${menu.LN00024},From,To,Check,#cspan,FromItemID,ToItemID";
		result.cols = "FromName|ToName|FromIDEx|ToIDEx|FromItemID|ToItemID";
		result.widths = "30,230,230,110,110,80,80";
		result.sorting = "str,str,str,str,str,str,str";
		result.aligns = "center,left,left,center,center,center,center";
		result.data = "ModelID=${ModelID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		return result;
	}
	
	function doPSearchList(){
		var d = setPGridData();
		fnLoadDhtmlxGridJson(pp_grid1, d.key, d.cols, d.data, false);
	}	
	
	function gridOnRowSelect(id, ind){
		var ItemID = "";
		if(ind == 1){
			ItemID = pp_grid1.cells(id, 5).getValue();
		}else if(ind == 2){
			ItemID = pp_grid1.cells(id, 6).getValue();
		}else{
			return;
		}
		
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+ItemID+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,ItemID);
	}
	
</script>

</head>
<body style="width:100%;">
<form name="symbolFrm" id="symbolFrm" action="" method="post" onsubmit="return false;">
<div class="child_search_head">
<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00127}</p>
</div>
<div class="countList" style="padding:10px 0 0 0;">
    <li class="count">Total  <span id="TOT_CNT"></span></li>
    <li class="floatR">&nbsp;</li>
</div>
<div id="grdPAArea" style="width:100%;height:500px;"></div>	
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
</body>
</html>