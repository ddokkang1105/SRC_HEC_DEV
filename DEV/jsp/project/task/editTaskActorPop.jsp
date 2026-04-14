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
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00138" var="WM00138" arguments="20"/>


<!-- 2. Script -->
<script type="text/javascript">
	var pp_grid;				//그리드 전역변수
	
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {	
		PgridInit();
		//doPSearchList();
	});	

	//그리드 초기화
	function PgridInit(){		
		var d = setPGridData();
		pp_grid = fnNewInitGrid("gridArea", d);
		pp_grid.setImagePath("${root}${HTML_IMG_DIR}/");
		
		pp_grid.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
	}
	
	function setPGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "task_SQL.getEditTaskActorList";
		result.header = "No,${menu.LN00004},Login ID,Team,Sys ID";
		result.cols = "UserName|LoginID|TeamName|MemberID";
		result.widths = "30,120,120,80,50";
		result.sorting = "int,str,str,str,str";
		result.aligns = "center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&Name="+$("#actorName").val();
		return result;
	}

	function gridOnRowSelect(id, ind){
		var actorID = pp_grid.cells(id, 4).getValue();
		
		var url = "editTaskActor.do";
		var target = "blankFrame";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}"
					+"itemIDArr=${itemIDArr}&changeSetIDArr=${changeSetIDArr}&taskTypeCodeArr=${taskTypeCodeArr}&actorID="+actorID; 
	 	ajaxPage(url, data, target);
	}
	
	function doPSearchList(){
		var d = setPGridData();
		fnLoadDhtmlxGridJson(pp_grid, d.key, d.cols, d.data, false);
	}	
	
	function fnGoBack(){ 		
		opener.doSearchList();
		self.close();
	}	
	
</script>

</head>

<body>
	<div style="width:98%;height:400px;padding:0 0 0 3px">
		<div class="child_search_head">
	     <p><img src="${root}${HTML_IMG_DIR}/user.png">&nbsp;${menu.LN00060} Search</p>
	   </div>
			<div class="child_search mgT5">
	           <li> ${menu.LN00060}</li>
	           <li>
	           <input type="text" id="actorName" name="actorName"  class="stext" style="width:150px;ime-mode:active;"/>
	           <input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doPSearchList()" value="검색">
	           </li>
	     </div>
		 <div class="countList">
	        <li class="count">Total  <span id="TOT_CNT"></span></li>
	        <li class="floatR">&nbsp;</li>
	     </div>
		<div id="gridDiv" class="mgB10 clear">
			<div id="gridArea" style="height: 320px; width: 100%"></div>
		</div>
		<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>
	</div>
</body>
</html>