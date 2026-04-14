<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/ui/jqueryJsInc.jsp" %>
<%@ include file="/WEB-INF/jsp/cmm/ui/olmJsInc.jsp" %>
<html>
<head>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
	var isMainMenu = "${isMainMenu}";
	
	$(document).ready(function(){
		$("input.datePicker").each(generateDatePicker);
		
		// 초기 표시 화면 크기 조정 
		$("#grid_container").attr("style","height:"+(setWindowHeight() * 0.8)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grid_container").attr("style","height:"+(setWindowHeight() * 0.8)+"px;");
		};
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		// 검색 버튼 클릭
		$('.searchList').click(function(){
			var url = "changeSetStatistics.do";
			var data = "";
			var target = "help_content";
			
			/* 검색 조건 설정 */
			// 프로젝트
			if($("#project").val() != '' & $("#project").val() != null){
				data = data +"&ParentID="+ $("#project").val();
			}
			// 담당조직
			if($("#team").val() != '' & $("#team").val() != null){
				data = data +"&OwnerTeamID="+ $("#team").val();
			}
			// 계층
			if($("#class").val() != '' & $("#class").val() != null){
				data = data +"&ItemClassCode="+ $("#class").val();
			}
			// 기간기준
			var period = $("#period").val(); // 1:등록일, 2:완료일
			data = data + "&period=" + period;
			if($("#SC_STR_DT").val() != '' & $("#SC_END_DT").val() != null){
				data = data + "&SC_STR_DT=" + $("#SC_STR_DT").val();
		        data = data + "&SC_END_DT=" + $("#SC_END_DT").val();
			}
			ajaxPage(url, data, target);
		});
		
		$('#project').change(function(){
			changeAuthorTeamList($(this).val()); // 담당조직 option 셋팅
		});
		changeAuthorTeamList("${ParentID}"); // 담당조직 option 초기 설정
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	var gridData = ${cngStatisticsListData};
	var grid = new dhx.Grid("grid_container", {
		columns: [
	    	{ width: 150, id: 'csrName', align:'left' ,header: [{ text: '${menu.LN00191}',rowspan: 2, align:'center'}] }
	    	,{ width: 90, id: 'cngtCount', align:'center' ,header: [{ text: 'Total', rowspan: 2, align:'center'}]}  
	    	${cngHeaderConfig}
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: true,
	    rowCss: function (row) { return row.csrName == "Total" ? "my_custom_row" : ""},
	    data: gridData
	});
	
	function doExcel() {	
		grid.export.xlsx({
	        url: "//export.dhtmlx.com/excel"
	    });
	}
	
	// [담당조직 option] 설정
	function changeAuthorTeamList(avg){
		var url    = "getAuthorTeamListOption.do"; // 요청이 날라가는 주소
		var data   = "parentPjtID="+avg; //파라미터들
		var target = "team";             // selectBox id
		var defaultValue = "${OwnerTeamID}";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}
		
</script>
<style>
	body {
        margin: 0;
    }

	.my_custom_row {
		background: #f7f7f7;
	}
</style>

<div class="msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;ChangeSet</div>

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
       		<select id="project" Name="project" style="width:150px;">
       			<option value=''>Select</option>
	        	<c:forEach var="i" items="${projectList}">
	            	<option value="${i.CODE}" <c:if test="${i.CODE == ParentID}">selected="selected"</c:if>>${i.NAME}</option>
	            </c:forEach>
       		</select>
       	</td>
       	
       	<!-- 담당조직 -->
		<th class="viewtop">${menu.LN00153}</th>
		<td class="viewtop alignL">
			<select id="team" Name="team" style="width:150px;">
			</select>
		</td>
		
		<!-- 계층 -->
		<th class="viewtop">${menu.LN00016}</th>
		<td class="viewtop alignL">
			<select id="class" Name="class" style="width:150px;">
				<option value=''>Select</option>
				<c:forEach var="i" items="${classCodeList}">
					<option value="${i.CODE}" <c:if test="${i.CODE == ItemClassCode}">selected="selected"</c:if>>${i.NAME}</option>
				</c:forEach>
			</select>
		</td>
		
		<!-- 기간기준 -->
		<th class="viewtop">${menu.LN00234}</th>
		<td class="viewtop alignL">
			<select id="period" Name="period" style="width:100px;">
				<option value='1' <c:if test="${period == 1}">selected="selected"</c:if>>${menu.LN00013}</option>
				<option value='2' <c:if test="${period == 2}">selected="selected"</c:if>>${menu.LN00064}</option>
			</select>
			 <input type="text" id="SC_STR_DT" name="SC_STR_DT" value="${beforeYmd}" class="input_off datePicker text" size="8"
					style="width: 70px;" onchange="this.value = makeDateType(this.value);" maxlength="10">
			
			~
			 <input type="text" id="SC_END_DT" name="SC_END_DT" value="${thisYmd}" class="input_off datePicker text" size="8"
					style="width: 70px;" onchange="this.value = makeDateType(this.value);" maxlength="10">
			
		</td>
		<td class="viewtop last alignR">
			<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" style="cursor:pointer;"/>
		</td>
	</tr>
</table>

<li class="mgT5 alignR"><span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span></li>
<div id="gridDiv" class="mgT5">
	<div id="grid_container" style="width:100%"></div>
</div>		
		
