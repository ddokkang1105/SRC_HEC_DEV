<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>


<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00053" var="CM00053"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00042" var="WM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="300"/>


<!-- 2. Script -->
<script type="text/javascript">
	var pp_grid1;				//그리드 전역변수
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {	
		$('.searchPList').click(function(){doPSearchList();});
		$("#searchValue").focus();	
		$('#searchValue').keypress(function(onkey){if(onkey.keyCode == 13){doPSearchList();return false;}});
		
		PgridInit();
		doPSearchList();
	});	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function PgridInit(){		
		var d = setPGridData();
		pp_grid1 = fnNewInitGrid("grdPAArea", d);
		pp_grid1.setImagePath("${root}${HTML_IMG_DIR}/");
		
		pp_grid1.setColumnHidden(11, true);
		pp_grid1.setColumnHidden(12, true);
		pp_grid1.setColumnHidden(13, true);
		pp_grid1.setColumnHidden(14, true);
		pp_grid1.setColumnHidden(15, true);
		pp_grid1.setColumnHidden(16, true);
		pp_grid1.setColumnHidden(17, true);
		pp_grid1.setColumnHidden(18, true);
		pp_grid1.setColumnHidden(19, true);
		pp_grid1.setColumnHidden(20, true);
		
		fnSetColType(pp_grid1, 1, "ch");
	}
	
	function setPGridData(){
		var result = new Object();
		var status = "'CSR','CNG'";
		result.title = "${title}";
		result.key = "project_SQL.getSetProjectListForCsr";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00015},${menu.LN00028},${menu.LN00131},${menu.LN00153},${menu.LN00266},${menu.LN00078},${menu.LN00062},${menu.LN00027},${menu.LN00067},${menu.LN00042},${menu.LN00132},,,,,,,,";
		result.cols = "CHK|ProjectCode|ProjectName|ParentName|AuthorTeamName|AuthorName|CreationTime|DueDate|StatusName|PriorityName|WFName|CurWFStepName|ProjectID|ProjectType|WFID|AuthorID|Creator|PjtMemberIDs|CNGT_CNT|Status";
		result.widths = "30,30,100,120,100,100,100,80,80,80,80,0,0,0,0,0,0,0,0,0,0";
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str,int,int,int,int,str,str,str,str";
		result.aligns = "center,center,center,left,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "filter=CSR"	
					+ "&quickCheckOut=Y" // AND TP.Status IN('CSR','CNG')
		 			+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
		 			+ "&curPJTID=${curPJTID}";
		return result;
	}
	
	// END ::: GRID	
	//===============================================================================
	//조회
	function doPSearchList(){
		var d = setPGridData();
		/* 건수 제한 메세지 표시 */
		fnLoadDhtmlxGridJson(pp_grid1, d.key, d.cols, d.data, false, "", "TOT_CNT2", "", "", "${WM00119}", 300);
	}	
	
	// [Move] Click
	function changeCsrOrder(){
		if(pp_grid1.getCheckedRows(1).length != 1){
			alert("${WM00042}");
		} else {
			if(confirm("${CM00053}")){
				var checkedRows = pp_grid1.getCheckedRows(1).split(",");	
				var pjtId =""; 
				
				for(var i = 0 ; i < checkedRows.length; i++ ){
					pjtId = pp_grid1.cells(checkedRows[i], 13).getValue();
				}
				
				var url = "changeCsrOrder.do";		
				var data = "cngts=${cngts}&pjtId="+pjtId;
				var target="blankFrame";
				ajaxPage(url, data, target);
			}
		} 
	}
	
</script>

<div class="popup01">
<ul>
	<li class="top_zone popup_title"><img src="${root}${HTML_IMG_DIR}/popup_box2_.png" /></li>
	<li class="con_zone">
	<div class="title popup_title"><span class="pdL10"> Search</span>
		<div class="floatR mgR20">
			<img class="popup_closeBtn" id="popup_close_btn" src='${root}${HTML_IMG_DIR}/btn_close1.png' title="close">
		</div>
	</div> 
	<div class="szone">	
	
	<div>
		<div class="child_search">
			<table class="tbl_popup" cellpadding="0" cellspacing="0" border="0" width="100%">
				<colgroup>
            		<col width="80">
            		<col width="20">
            		<col>
            	</colgroup>
            	<tr>
               		<td>					
						<select id="searchKey" name="searchKey" class="sel" style="width:80px;">
							<option value="Name">Name</option>
							<option value="Code">ID</option> 				
						</select>
						<input type="text" id="searchValue" name="searchValue" value="${searchValue}"  class="stext" style="width:130px;ime-mode:active;">
						<input type="image" class="image searchPList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search">
						
					</td>
					<td class="alignR">
						<span class="btn_pack small icon mgR10"><span class="move"></span><input value="Move" type="submit" onclick="changeCsrOrder()"></span>
					</td>
					
					
               	</tr>
               	
      		</table>
       	</div>
  	<!-- BEGIN::CONTENT-->
 	<!-- BEGIN::CONTENT_CONTAINER mgL45-->
  		<div class="mgL10 mgR10">
  			<div class="alignL mgT5 mgB5">	
				<p style="color:#1141a1;">Total  <span id="TOT_CNT2"></span></p>
			</div>
		    <div id="grdPAArea" style="height:300px;"></div>
  		</div>
	</div>
	
	</div>
	</li>
</ul>	
</div>	
<div class="bot_zone" style="margin-top:10px;" >
	<img src="${root}${HTML_IMG_DIR}/popup_box6_.png" style="margin-top:-8px;">
</div>
<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>
