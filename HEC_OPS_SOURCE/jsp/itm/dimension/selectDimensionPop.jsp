<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="${menu.LN00186}"/>

<!-- 2. Script -->
<script type="text/javascript">
	var pp_grid1;				//그리드 전역변수
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {	
		PgridInit();
		//doPSearchList();
	});	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function PgridInit(){		
		var d = setPGridData();
		pp_grid1 = fnNewInitGrid("grdArea", d);
		pp_grid1.setImagePath("${root}${HTML_IMG_DIR}/");
		pp_grid1.setColumnHidden(5, true);
		fnSetColType(pp_grid1, 1, "ch");
		pp_grid1.enableAutoHeight(true, 275);
	}
	
	function setPGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "dim_SQL.selectAllDim";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00186},Code,${menu.LN00187},DimTypeID";	//5
		result.cols = "CHK|DimTypeName|DimValueID|DimValueName|DimTypeID";
		result.widths = "30,30,150,150,*,0";
		result.sorting = "str,str,str,str,str,str";
		result.aligns = "center,center,center,center,left,center";
		result.data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		
		/* 검색 조건 설정 */			
		// DimTypeID
		if($("#dimTypeId2").val() != '' & $("#dimTypeId2").val() != null){
			result.data = result.data +"&dimTypeId2="+ $("#dimTypeId2").val();
		}
		return result;
	}
	
	function doPSearchList(){
		if($("#dimTypeId2").val() == ''){
			alert("${WM00025}");
			return false;
		}
		var d = setPGridData();
		fnLoadDhtmlxGridJson(pp_grid1, d.key, d.cols, d.data, false, '', 'TOT_CNT2');
	}	
	
	// END ::: GRID	
	//===============================================================================
	
	// [Add] Click
	function addDimension() {
		if(pp_grid1.getCheckedRows(1).length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요.");	
			alert("${WM00023}");	
		}else{
			//if(confirm("선택된 항목을 추가 하시겠습니까?")){
			if(confirm("${CM00012}")){
				var checkedRows = pp_grid1.getCheckedRows(1).split(",");
				var dimValueIds =""; 
				var dimTypeIds =""; 
				for(var i = 0 ; i < checkedRows.length; i++ ){
					if (dimTypeIds == "") {
						dimTypeIds = pp_grid1.cells(checkedRows[i], 5).getValue();
						dimValueIds = pp_grid1.cells(checkedRows[i], 3).getValue();
					} else {
						dimTypeIds = dimTypeIds + "," + pp_grid1.cells(checkedRows[i], 5).getValue();
						dimValueIds = dimValueIds + "," + pp_grid1.cells(checkedRows[i], 3).getValue();
					}
				}
				
				var url = "addDimensionForItem.do";
				var data = "s_itemID=${s_itemID}&dimTypeIds="+dimTypeIds+"&dimValueIds=" + dimValueIds;
				var target = "blankFrame";
				ajaxPage(url, data, target);
				$(".popup_div").hide();
				$("#mask").hide();
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
		<div class="child_search">
			<table  class="tbl_popup" cellpadding="0" cellspacing="0" border="0" width="100%">
            	<colgroup>
            		<col width="35%">
            		<col>
            	</colgroup>
	            	<tr>
	               		<td class="pdL10">
							<select id="dimTypeId2" Name="dimTypeId2">
				             	<option value=''>Select</option>
				             	<c:forEach var="i" items="${dimTypeList}">
				                 	<option value="${i.DimTypeID}">${i.DimTypeName}</option>
				             	</c:forEach>
				         	</select> 
				         	<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doPSearchList();" value="Search">              		
						</td>
						<td class="alignR pdR10">
							&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="addDimension()" ></span>
						</td>
	               	</tr>
       			</table>
       		</div>
  		<div class="con01 mgL10">	
     		<div class="alignL mgT5 mgB5">	
				<p style="color:#1141a1;">Total  <span id="TOT_CNT2"></span></p>
			</div>
			<div id="grdArea" style="width:100%;height:300px;background-color:#f9f9f9;border :1px solid Silver;overflow:auto;"></div>  		
		</div>
	</div>
	</li>
	</ul>
</div>
<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>