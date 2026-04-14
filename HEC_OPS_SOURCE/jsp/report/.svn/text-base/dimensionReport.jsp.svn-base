<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 1. Include CSS/JS -->
<style type="text/css">
	#framecontent{border:1px solid #e4e4e4;overflow: hidden; background: #f9f9f9;padding:10px;}
</style>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00029" var="WM00029"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00030" var="WM00030"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00031" var="WM00031"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="${menu.LN00021}"/>

<script>
	var p_excelGrid;				//그리드 전역변수
	var dimTypeID = "${dimTypeID}";
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#excelGridArea").attr("style","height:"+(setWindowHeight() - 210)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#excelGridArea").attr("style","height:"+(setWindowHeight() - 210)+"px;");
		};
		
		$("#excel").click(function(){
			p_excelGrid.toExcel("${root}excelGenerate");
			return false;
		});			

	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	
	
	function gridInit(dimValueId, dimValueName, idCnt){		
		var d = setGridData(dimValueId, dimValueName, idCnt);
		p_excelGrid = fnNewInitGrid("excelGridArea", d);
		p_excelGrid.setImagePath("${root}${HTML_IMG_DIR}/");
	}

	function setGridData(dimValueId, dimValueName, idCnt){
		var result = new Object();
		
		var cols = "";
		var widths = "";
		var sorting = "";
		var aligns = "";
		var types = "";
		
		for (var i = 1; i < idCnt + 1; i++) {
			cols = cols + "|DimValueName" + i ;  
			widths = widths + ",100";
			sorting = sorting + ",str";
			aligns = aligns + ",center";
			types = types + ",ch";
		}
		
		result.title = "${title}";
		result.header = "${menu.LN00024},${menu.LN00015},${menu.LN00028},${menu.LN00043},${menu.LN00016}" + dimValueName;
		result.cols = "Identifier|ItemName|Path|ClassName" + cols;
		result.widths = "50,80,150,*,80" + widths;
		result.sorting = "str,str,str,str,str" + sorting;
		result.aligns = "center,center,left,left,center" + aligns;
		result.types = "ro,ro,ro,ro,ro" + types; 
		result.data = "s_itemID=" + dimTypeID + "&ID=" + dimValueId + "&itemTypeCode=" + $("#ItemTypeCode").val();
		return result;
	}
	
	// [Search] Click
	function getDimensionInfo(){
		if($("#ItemTypeCode").val() == ""){alert("${WM00041}");return false;}
		var itemTypeCode = $("#ItemTypeCode").val();
			
		var url = "getDimensionInfo.do";		
		var data = "itemTypeCode="+itemTypeCode+"&dimTypeID="+dimTypeID;
		var target="blankFrame";
		ajaxPage(url, data, target);
	}
	function doSearchList(dimValueName, dimValueId, idCnt){
		var dimValueIdArray = dimValueId.split(',');		
		for(var i = 0 ; i < dimValueIdArray.length ; i++){	
			if (i == 0) {
				dimValueId = "'" + dimValueIdArray[i] + "'";
			} else {
				dimValueId = dimValueId + ",'" + dimValueIdArray[i] + "'";
			}
		}
		gridInit(dimValueId, dimValueName, idCnt);
		var d = setGridData(dimValueId, dimValueName, idCnt);
		p_excelGrid = fnNewInitGrid("excelGridArea", d);
		p_excelGrid.setImagePath("${root}${HTML_IMG_DIR}/");			
		var url="<c:url value='/dimensionReportGridJson.do'/>";
		fnLoadDhtmlxGridJson(p_excelGrid, d.key, d.cols, d.data, false, "", "", url);
		
		// 체크박스 비활성화
		p_excelGrid.setEditable(false);
		$("#divExcelDownBtn").attr("style", "display:block;"); // excel다운로드 버튼 활성화
	}
	// END ::: GRID	
	//===============================================================================
		
</script>

<div id="framecontent" class="mgT10">	
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="font-size:12px;">
			<colgroup>
				<col width="15%">
				<col>
			</colgroup>
			<tr>
				<!-- Download Option -->
				<th class="pdB5" style="text-align:left;">&nbsp;&nbsp;${menu.LN00021}</th>
				<td colspan="3" class="pdB5">
					<select id="ItemTypeCode" name="ItemTypeCode">
						<option value="">Select</option>
						<c:forEach var="i" items="${itemTypeCodeList}">
							<option value="${i.CODE}">${i.NAME}</option>						
						</c:forEach>	
					</select>
					<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="getDimensionInfo();" value="검색">
				</td>
			</tr>
		</table>
	</div>

<!-- BIGIN :: LIST_GRID -->
<div id="maincontent">
	<div id="divExcelDownBtn" class="alignBTN mgB5" style="display:none;">
		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
	</div>
	<div class="file_search_list">
		<div id="excelGridArea" style="width:100%"></div>
	</div>
</div>	

<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>	
<!-- END :: LIST_GRID -->
