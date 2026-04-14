<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/ui/jqueryJsInc.jsp" %>
<%@ include file="/WEB-INF/jsp/cmm/ui/olmJsInc.jsp" %>
<html>
<head>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_1" arguments="${menu.LN00277}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_2" arguments="${menu.LN00021}"/>

<script>
	var isMainMenu = "${isMainMenu}";
	
	$(document).ready(function(){
			
		$("input.datePicker").each(generateDatePicker);
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		// 검색 버튼 클릭
		$('.searchList').click(function(){
			// 검색조건 필수 체크 (프로젝트 그룹, 항목 유형)
			if ($('#pjtGr').val() == "") {
				alert("${WM00025_1}");
				return;
			}
			if ($('#itemType').val() == "") {
				alert("${WM00025_2}");
				return;
			}
			
			var url = "taskPAresult.do";
			var data = "";
			var target = "help_content";
			
			/* 검색 조건 설정 */
			// 프로젝트 그룹
			if($("#pjtGr").val() != '' & $("#pjtGr").val() != null){
				data = data +"&ProjectGr="+ $("#pjtGr").val();
			}
			// 프로젝트
			if($("#project").val() != '' & $("#project").val() != null){
				data = data +"&ParentID="+ $("#project").val();
			}
			// 항목 유형
			if($("#itemType").val() != '' & $("#itemType").val() != null){
				data = data +"&ItemTypeCode="+ $("#itemType").val();
			}
			// 담당조직
			if($("#team").val() != '' & $("#team").val() != null){
				data = data +"&OwnerTeamID="+ $("#team").val();
			}
			// 기준일
			if($("#scStartDt").val() != '' & $("#scStartDt").val() != null){
				data = data + "&scStartDt=" + $("#scStartDt").val();
			}
			ajaxPage(url, data, target);
		});
		
		// 초기 표시 화면 크기 조정 
		$("#grid_container").attr("style","height:"+(setWindowHeight() - 180)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grid_container").attr("style","height:"+(setWindowHeight() - 180)+"px;");
		};
		
		$('#project').change(function(){
			changeAuthorTeamList($(this).val());
			changeItemTypeCodeList($("#pjtGr").val(), $(this).val());
		});
		
		$('#pjtGr').change(function(){
			changeItemTypeCodeList($(this).val(), '');
			changeProjectList($(this).val());
		});
		
		changeAuthorTeamList("${ParentID}"); // 담당조직 option 초기 설정
		changeItemTypeCodeList("${ProjectGr}", "${ParentID}");
		changeProjectList("${ProjectGr}");
		
		/* if (isMainMenu == "") { // 초기화면 통계 데이터 출력 안함			
			fnInitGridConfig();
		} */
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	var gridData = ${taskPAResultListData};	
	var grid = new dhx.Grid("grid_container", {
			columns: [
		    	{ width: 140, id: 'ProjectNM', align:'center' ,header: [{ text: '${menu.LN00042}', colspan: 2, align:'center'}
		    						  ,{ text: '${pjtGrHeader}' ,align:'center', rowspan:2}    										
		    						  ],resizable: true }
				,{ width: 150, id: 'Csr', header: ['', { text: '${menu.LN00191}', align:'center', rowspan:2} ], align:'left'}
				${headerConfig}
				,{ width: 80, id: 'total', align: 'center', header: [{text: '${menu.LN00253}', colspan: 3, align: 'center'}, { text: 'total', rowspan:2, align:'center'}]}
		    	,{ width: 80, id: 'totalP', align: 'center', header: ['', { text: '${menu.LN00255}', rowspan:2, align:'center'} ]}
		    	,{ width: 80, id: 'totalA', align: 'center', header: ['', { text: '${menu.LN00254}', rowspan:2, align:'center'} ]}
		    			
		    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: true,
		    spans: ${spanData},//[{ row: "1", column: "ProjectNM", rowspan: 3 }] 
	 		rowCss: function (row) { return row.Csr == "소계" ? "my_custom_row" : ""},
		    data : gridData
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
	
	// [항목 유형 option] 설정
	function changeItemTypeCodeList(avg1, avg2){
		var url    = "getItemTypeCodeOfTaskOption.do"; // 요청이 날라가는 주소
		var data   = "ProjectGr="+avg1+"&parentPjtID="+avg2; //파라미터들
		var target = "itemType";             // selectBox id
		var defaultValue = "${ItemTypeCode}";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}
	
	// [프로젝트 option] 설정
	function changeProjectList(avg){
		var url    = "getProjectOption.do"; // 요청이 날라가는 주소
		var data   = "parentPjtID="+avg; //파라미터들
		var target = "project";             // selectBox id
		var defaultValue = "${ParentID}";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}
		
</script>

<!-- custom styles -->
<style>
  	body {
        margin: 0;
    }
	.my_custom_row {
		background: #E0FFFF;
	}
</style>

<div class="msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Task(Plan/Actual)</div>
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
		<colgroup>
		    <col width="9%">
		    <col width="11%">
		    <col width="8%">
		    <col width="11%">
		    <col width="8%">
		    <col width="11%">
		    <col width="8%">
		    <!--col width="11%">
		    <col width="8%"-->
		    <col width="13%">
		    <col width="8%">
	    </colgroup>
	    <tr>
	    	<!-- 프로젝트 그룹-->
	       	<th class="viewtop">${menu.LN00277}</th>
	       	<td class="viewtop alignL">
	       		<select id="pjtGr" Name="pjtGr" style="width:180px;">
	       			<option value=''>Select</option>
		        	<c:forEach var="i" items="${pjtGrList}">
		            	<option value="${i.CODE}" <c:if test="${isMainMenu == '' && i.CODE == ProjectGr}">selected="selected"</c:if>>${i.NAME}</option>
		            </c:forEach>
	       		</select>
	       	</td>
	       	
	       	<!-- 프로젝트 -->
	       	<th class="viewtop">${menu.LN00131}</th>
	       	<td class="viewtop alignL">
	       		<select id="project" Name="project" style="width:180px;">
	       		</select>
	       	</td>
	       	
	       	<!-- 항목 유형 -->
			<th class="viewtop">${menu.LN00021}</th>
			<td class="viewtop alignL">
				<select id="itemType" Name="itemType" style="width:180px;">
				</select>
			</td>
				       	
			<!-- 기준일 -->
			<th class="viewtop">${menu.LN00261}</th>
			<td class="viewtop alignL">
				<input type="text" id="scStartDt" name="scStartDt" value="${thisYmd}" class="input_off datePicker text"
						style="width: 80px;" onchange="this.value = makeDateType(this.value);" maxlength="10">
			</td>
			
			<td class="viewtop last alignR">
				<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" style="cursor:pointer;"/>
			</td>
		</tr>
	</table>

	<li class="mgT5 mgB5 alignR">
		<c:if test="${isMainMenu == ''}">
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</c:if>
	</li>		

	
	<div id="gridDiv" style="width:100%;" class="clear" >
		<div id="grid_container" style="width: 100%"></div>
		<div id="pagination" style="padding: 0 10px;"  ></div>
	</div>