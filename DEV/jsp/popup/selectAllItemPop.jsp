<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>


<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00087" var="WM00087"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00042" var="WM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="${menu.LN00016}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="300"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="${menu.LN00131}"/>


<!-- 2. Script -->
<script type="text/javascript">
	var pp_grid1;				//그리드 전역변수
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {	
		$('.searchPList').click(function(){doPSearchList();});
		$("#searchValue").focus();	
		$('#searchValue').keypress(function(onkey){if(onkey.keyCode == 13){doPSearchList();return false;}});
		
		fnSelect('newTypeCode', '&Category=OJ&Deactivated=1', 'itemTypeCode', '', 'All');
		PgridInit();
	});	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function PgridInit(){		
		var d = setPGridData();
		pp_grid1 = fnNewInitGrid("grdPAArea", d);
		pp_grid1.setImagePath("${root}${HTML_IMG_DIR}/");
		
		pp_grid1.setColumnHidden(7, true);
		pp_grid1.setColumnHidden(8, true);
		pp_grid1.setColumnHidden(9, true);
		pp_grid1.setColumnHidden(10, true);
		pp_grid1.setColumnHidden(11, true);
		fnSetColType(pp_grid1, 1, "ch");
	}
	
	function setPGridData(){
		var result = new Object();
		var status = "'REL'";
		result.title = "${title}";
		result.key = "project_SQL.getAllItemList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00015},${menu.LN00028},${menu.LN00016},${menu.LN00043},${menu.LN00070},ItemID,${menu.LN00004},${menu.LN00027},,";	//9
		result.cols = "CHK|Identifier|ItemName|ClassName|FatherName|LastUpdated|ItemID|AuthorName|StatusName|AuthorID|Status";
		result.widths = "30,30,80,110,80,*,80,0,0,0,0,0";
		result.sorting = "int,int,str,str,str,str,str,int,str,str,str,str";
		result.aligns = "center,center,center,center,left,left,left,center,center,center,center,center";
		result.data = "searchKey=" + $('#searchKey').val()
					+ "&searchValue=" + $('#searchValue').val()
		            + "&ClassCode=" + $("#newPClassCode").val()
		 			+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
		 			+ "&AuthorID=${sessionScope.loginInfo.sessionUserId}"
		 			+ "&Status=" + status
		 			+ "&ChangeMgt=1"
		 			+ "&ProjectID=" + $("#project").val();
		 			
		return result;
	}
	
	// END ::: GRID	
	//===============================================================================
	//조회
	function doPSearchList(){
		// [프로젝트] 선택 필수
		if ($('#project').val() == "") {
			alert("${WM00041}");
			return false;
		}
		var d = setPGridData();
		/* 건수 제한 메세지 표시 */
		fnLoadDhtmlxGridJson(pp_grid1, d.key, d.cols, d.data, false, "", "TOT_CNT2", "", "", "${WM00119}", 300);
	}	
	
	// [Add] click event
	function processNEW(){
		if(pp_grid1.getCheckedRows(1).length == 0){
			// 항목을 한개 이상 선택하여 주십시요.
			alert("${WM00023}");
		} else {
			if(confirm("${CM00012}")){
				var checkedRows = pp_grid1.getCheckedRows(1).split(",");	
				var itemIds =""; 
				
				for(var i = 0 ; i < checkedRows.length; i++ ){
					if (itemIds == "") {
						itemIds = pp_grid1.cells(checkedRows[i], 7).getValue();
					} else {
						itemIds = itemIds + "," + pp_grid1.cells(checkedRows[i], 7).getValue();
					}
				}
				
				var url = "checkOutItem.do";		
				var data = "projectID=" + $("#project").val() + "&itemIds="+itemIds;
				var target="blankFrame";
				ajaxPage(url, data, target);
			}
		} 
	}
	
</script>

<div class="popup01">
<ul>
	<li class="con_zone">
	<div class="title popup_title"><span class="pdL10"> Search</span>
		<div class="floatR mgR10">
			<img class="popup_closeBtn" id="popup_close_btn" src='${root}${HTML_IMG_DIR}/btn_close1.png' title="close">
		</div>
	</div> 
	<div class="szone">	
	
	<div>
		<div class="child_search">
			<table class="tbl_popup" cellpadding="0" cellspacing="0" border="0" width="100%">
            	<tr>
            		<td style="width:60px;">${menu.LN00131}</td>
            		<td>
						<select id="project" name="project" class="sel" style="width:100px;">
							<option value=''>${menu.LN00113}</option>
							<c:forEach var="i" items="${projectNameList}">
								<option value="${i.ProjectID}">${i.Name}</option>
							</c:forEach>
						</select>
					</td>
               		<td style="width:60px;">${menu.LN00016}</td>
               		<td>
						<select id="newPClassCode" name="newPClassCode" class="sel" style="width:100px;">
							<option value=''>${menu.LN00113}</option>
							<c:forEach var="i" items="${changeClassList}">
								<option value="${i.CODE}">${i.NAME}</option>
							</c:forEach>
						</select>
               		</td>
               		
               		<td>					
						<select id="searchKey" name="searchKey" class="sel" style="width:60px;">
							<option value="Name">Name</option>
							<option value="Code">ID</option> 				
						</select>
						
						<input type="text" id="searchValue" name="searchValue" value="${searchValue}"  class="stext" style="width:130px;ime-mode:active;">
						<input type="image" class="image searchPList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색">
						&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="processNEW()" ></span>
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
		    <div id="grdPAArea" style="width:100%;height:280px;"></div>
  		</div>
	</div>
	
	</div>
	</li>
</ul>	
</div>	
<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>
