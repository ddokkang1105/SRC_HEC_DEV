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
		pp_grid = fnNewInitGrid("grdPAArea", d);
		pp_grid.setImagePath("${root}${HTML_IMG_DIR}/");
		pp_grid.setColumnHidden(5, true);
		pp_grid.setColumnHidden(6, true);
		pp_grid.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowSelect(id,ind);
		});
	}
	
	function setPGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "task_SQL.getPjtMemberList";
		result.header = "${menu.LN00024},LoginID,Name,${menu.LN00202},E-Mail,MemberID,TeamID";
		result.cols = "LoginID|UserName|TeamPath|Email|MemberID|TeamID";
		result.widths = "30,60,80,310,148,80,80";
		result.sorting = "int,str,str,str,str,str,str";
		result.aligns = "center,center,left,left,center,center,center";
		result.data = "projectID=${projectID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
		 			+ "&Name=" + $('#searchValue').val();
		return result;
	}
	// END ::: GRID	
	//===============================================================================
		
	//조회
	function doPSearchList(){
		var d = setPGridData();
		fnLoadDhtmlxGridJson(pp_grid, d.key, d.cols, d.data, false);
	}
	
	function gridOnRowSelect(id, ind){
		$("#memberId").val(pp_grid.cells(id,5).getValue());
		$("#memberName").val(pp_grid.cells(id,2).getValue());
		$("#teamID").val(pp_grid.cells(id,6).getValue());
	}
	
	// [Add] 버튼 Click
	function addPjtMember(){
		if(pp_grid.getCheckedRows(1).length == 0){
			alert("${WM00023}");
		} else {
			if(confirm("${CM00012}")){
				var memberId = $("#memberId").val();
				var memberName = $("#memberName").val();
				var teamID = $("#teamID").val();
				opener.fnSetMember(memberId, memberName, teamID);
				self.close();
			}			
		} 
	}
	
</script>

</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>
<body style="width:100%;">
<form name="userNameListFrm" id="userNameListFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="memberId" name="memberId" >
	<input type="hidden" id="memberName" name="memberName" >
	<input type="hidden" id="teamID" name="teamID" >
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00127}</p>
	</div>
	<div>
		<div class="child_search">
			<table class="tbl_popup" cellpadding="0" cellspacing="0" border="0" width="100%">
            	<tr>
               		<td class="pdL5">Name</td>
					<td class="alignL">
						<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="stext" style="width:150px;ime-mode:active;">
						<input type="image" class="image searchPList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색">&nbsp;	
					</td>
					<td class="alignR pdR20">
						<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="addPjtMember()" ></span>
					</td>
               	</tr>
      		</table>
       	</div>
  	<!-- BEGIN::CONTENT-->
 	<!-- BEGIN::CONTENT_CONTAINER mgL45-->
  		<div class="mgL10 mgR10">
  			<div class="alignL mgT5 mgB5">	
				<p style="color:#1141a1;">Total  <span id="TOT_CNT"></span></p>
			</div>
		    <div id="grdPAArea" style="width:100%;height:250px;"></div>
  		</div>
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
<!-- END::POPUP BOX-->

</body>
</html>