<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<script>
	var p_gridArea;				//그리드 전역변수
	var p_chart;
	var grid_skin = "dhx_brd";
	var isMainMenu = "${isMainMenu}";
	
	$(document).ready(function(){
		$("input.datePicker").each(generateDatePicker);
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		// 검색 버튼 클릭
		$('.searchList').click(function(){
			var url = "issueStatistics.do";
			var data = "";
			var target = "help_content";
			
			/* 검색 조건 설정 */
			// 프로젝트
			if($("#project").val() != '' & $("#project").val() != null){
				data = data +"&ParentID="+ $("#project").val();
			}
			// 유형
			if($("#issueType").val() != '' & $("#issueType").val() != null){
				data = data +"&ItemTypeCode="+ $("#issueType").val();
			}
			// 요청조직
			if($("#team").val() != '' & $("#team").val() != null){
				data = data +"&ReqTeamID="+ $("#team").val();
			}
			// 기간기준
			var period = $("#period").val(); // 1:등록일, 2:처리일
			data = data + "&period=" + period;
			if($("#SC_STR_DT").val() != '' & $("#SC_END_DT").val() != null){
				data = data + "&SC_STR_DT=" + $("#SC_STR_DT").val();
		        data = data + "&SC_END_DT=" + $("#SC_END_DT").val();
			}
			ajaxPage(url, data, target);
		});
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 150)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 150)+"px;");
		};
		
		gridInit();
		if (isMainMenu == "") { // 초기화면 통계 데이터 출력 안함
			doSearchList();
		}
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridInit(){		
		var d = setGridData();		
		p_gridArea = fnNewInitGridMultirowHeader("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
	}
	
	function setGridData(){
		var result = new Object();
		var widths = "";
		var sorting = "";
		var aligns = "";
		var aCnt = 8;
		var colWidth = (document.body.clientWidth - 225 - 150) / 8;
		
		for (var i = 0; i < aCnt; i++) {
			widths = widths + "," + colWidth;
			sorting = sorting + ",str";
			aligns = aligns + ",center";
		}
		
		result.title = "";
		result.key = "";
		result.header = "${menu.LN00191},${menu.LN00235},#cspan,${isStsMap.IS01},#cspan,${isStsMap.IS02},#cspan,${isStsMap.IS03},#cspan";
		result.widths = "150" + widths;
		result.sorting = "str" + sorting;
		result.aligns = "center" + aligns;
		result.data = "";
		return result;
	}
	
	//조회
	function doSearchList(){
		p_gridArea.enableRowspan();
		p_gridArea.enableColSpan(true);
		p_gridArea.loadXML("${root}" + "${xmlFilName}");
	}
	// END ::: GRID	
	//===============================================================================
		
		
	//===============================================================================
	// BEGIN ::: EXCEL
	function doExcel() {	
		p_gridArea.toExcel("${root}excelGenerate");
	}
	// END ::: EXCEL
	//===============================================================================
		
</script>


<div class="msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Issue</div>

<!-- BEGIN :: SEARCH -->
<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
	<colgroup>
	    <col width="8%">
	    <col width="11%">
	    <col width="8%">
	    <col width="11%">
	    <col width="8%">
	    <col width="11%">
	    <col width="8%">
	    <col>
	    <col width="8%">
    </colgroup>
    <tr>
   		<!-- 프로젝트 -->
       	<th class="viewtop">${menu.LN00131}</th>
       	<td class="viewtop alignL">
       		<select id="project" Name="project">
       			<option value=''>Select</option>
	        	<c:forEach var="i" items="${projectList}">
	            	<option value="${i.CODE}" <c:if test="${i.CODE == ParentID}">selected="selected"</c:if>>${i.NAME}</option>
	            </c:forEach>
       		</select>
       	</td>
       	
       	<!-- 유형 -->
		<th class="viewtop">${menu.LN00217}</th>
		<td class="viewtop alignL">
			<select id="issueType" Name="issueType">
				<option value=''>Select</option>
				<c:forEach var="i" items="${issueTypeList}">
					<option value="${i.CODE}" <c:if test="${i.CODE == ItemTypeCode}">selected="selected"</c:if>>${i.NAME}</option>
				</c:forEach>
			</select>
		</td>
       	
       	<!-- 요청조직 -->
		<th class="viewtop">${menu.LN00026}</th>
		<td class="viewtop alignL">
			<select id="team" Name="team">
				<option value=''>Select</option>
				<c:forEach var="i" items="${issueReqTeamList}">
					<option value="${i.TeamID}" <c:if test="${i.TeamID == ReqTeamID}">selected="selected"</c:if>>${i.TeamName}</option>
				</c:forEach>
			</select>
		</td>
		
		<!-- 기간기준 -->
		<th class="viewtop">${menu.LN00234}</th>
		<td class="viewtop alignL">
			<select id="period" Name="period">
				<option value='1' <c:if test="${period == 1}">selected="selected"</c:if>>${menu.LN00013}</option>
				<option value='2' <c:if test="${period == 2}">selected="selected"</c:if>>${menu.LN00236}</option>
			</select>
			<font> <input type="text" id="SC_STR_DT" name="SC_STR_DT" value="${beforeYmd}" class="input_off datePicker text" size="8"
					style="width: 70px;" onchange="this.value = makeDateType(this.value);" maxlength="10">
			</font>
			~
			<font> <input type="text" id="SC_END_DT" name="SC_END_DT" value="${thisYmd}" class="input_off datePicker text" size="8"
					style="width: 70px;" onchange="this.value = makeDateType(this.value);" maxlength="10">
			</font>
		</td>
		
		<td class="viewtop last alignR">
			<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" style="cursor:pointer;"/>
		</td>
	</tr>
</table>

<li class="mgT5 alignR"><span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span></li>
		
<form name="rptForm" id="rptForm" action="" method="post" >
	<div id="gridDiv" class="mgT5">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
</form>