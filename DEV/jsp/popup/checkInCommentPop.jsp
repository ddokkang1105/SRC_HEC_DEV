<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>


<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00049" var="CM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>

<!-- 2. Script -->
<script type="text/javascript">
	var pp_grid1;				//그리드 전역변수
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {	
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
		fnSetColType(pp_grid1, 1, "ch");
		
		pp_grid1.setColumnHidden(6, true);
		pp_grid1.setColumnHidden(7, true);
		pp_grid1.setColumnHidden(8, true);
		
		pp_grid1.attachEvent("onCheckbox", function(id,ind){gridOnCheckbox(id,ind);});
	}
	
	// [Check Box] check event : total 카운트 계산
	function gridOnCheckbox(id,ind) {
		var curTtlCnt = Number($("#TOT_CNT2").html());
		var checkValue = pp_grid1.cells(id, 1).getValue(); // 0:X, 1:O
		var checkedRows = pp_grid1.getCheckedRows(1).split(",").length;	
		var allRows = pp_grid1.getAllRowIds(",").split(",").length;	
		
		if (checkedRows == allRows) {
			$("#TOT_CNT2").html(allRows);
		} else {
			if (checkValue == 0) {
				$("#TOT_CNT2").html(curTtlCnt-1);
			}
			if (checkValue == 1) {
				$("#TOT_CNT2").html(curTtlCnt+1);
			}
		}
	}
	
	function setPGridData(){
		var result = new Object();
		
		result.title = "${title}";
		result.key = "cs_SQL.getCheckOutCngt";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00015},${menu.LN00028},${menu.LN00016},${menu.LN00043},,,";
		result.cols = "CHK|Identifier|ItemName|ClassCode|ItemPath|ItemID|ChangeSetID|ProjectID";
		result.widths = "30,30,100,150,100,218,0,0,0";
		result.sorting = "int,int,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,left,center,left,center,center,center";
		result.data = "cngts=${cngts}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		 			
		return result;
	}
	
	
	// END ::: GRID	
	//===============================================================================
	//조회
	function doPSearchList(){
		var d = setPGridData();
		/* 건수 제한 메세지 표시 */
		fnLoadDhtmlxGridJson(pp_grid1, d.key, d.cols, d.data, false, "", "TOT_CNT2", "", "", "${WM00119}", 1000);
	}	
	
	// [Check in] Click <-- Check out 
	function checkIn() {
		if(pp_grid1.getCheckedRows(1).length == 0){
			alert("${WM00023}");			
		}else{
			if(confirm("${CM00049}")){
				var checkedRows = pp_grid1.getCheckedRows(1).split(",");	
				var items = "";
				var cngts = "";
				var pjtIds = "";
				
				for(var i = 0 ; i < checkedRows.length; i++ ){
					// check in 할 (ChangeSetID, ItemID)의 문자열을 셋팅
					if (items == "") {
						items = pp_grid1.cells(checkedRows[i], 6).getValue();
						cngts = pp_grid1.cells(checkedRows[i], 7).getValue();
						pjtIds = pp_grid1.cells(checkedRows[i], 8).getValue();
					} else {
						items = items + "," + pp_grid1.cells(checkedRows[i], 6).getValue();
						cngts = cngts + "," + pp_grid1.cells(checkedRows[i], 7).getValue();
						pjtIds = pjtIds + "," + pp_grid1.cells(checkedRows[i], 8).getValue();
					}
				}
				if (items != "") {
					var url = "checkInMgt.do";
					var data = "items=" + items + "&cngts=" + cngts + "&pjtIds=" + pjtIds + "&description=" + $("#description").val();
					var target = "blankFrame";
					ajaxPage(url, data, target);
				}
			}
		}
	}
	
</script>

<div class="popup01">
<ul>
	<li class="con_zone">
	<div class="title popup_title"><span class="pdL10"> Check In</span>
		<div class="floatR mgR10">
			<img class="popup_closeBtn" id="popup_close_btn" src='${root}${HTML_IMG_DIR}/btn_close1.png' title="close">
		</div>
	</div> 
	<div class="szone">	
	
	<div>
		<div id="framecontent" class="mgT10 mgB5">	
		<div class="attr">
			<table class="tbl_popup" cellpadding="0" cellspacing="0" border="0" width="100%">
           		<tr>
           			<td class="floatL mgB3"><b>Comment</b></td>
           		</tr>
            	<tr>
               		<td>
						<textarea id="description" name="description" style="width:100%;height:80px;"></textarea>
               		</td>
               	</tr>	
      	</table>
      	</div>
      	</div>
  	<!-- BEGIN::CONTENT-->
 	<!-- BEGIN::CONTENT_CONTAINER mgL45--> 	
  		<div class="mgL10 mgR10">
  			<div class="alignL">	
				<p style="color:#1141a1;">
					Total  
					<span id="TOT_CNT2"></span>
					<span class="btn_pack medium icon floatR mgB2">
						<span class="confirm"></span><input value="Check in" onclick="checkIn()" type="submit">
					</span>
				</p>	
			</div>
		    <div id="grdPAArea" style="width:100%;height:210px;"></div>
  		</div>
  		
	</div>
	
	</div>
	</li>
</ul>	
</div>	
<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>
