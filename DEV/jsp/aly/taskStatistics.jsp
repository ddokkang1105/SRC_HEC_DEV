<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_1" arguments="${menu.LN00131}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_2" arguments="${menu.LN00016}"/>

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
			// 검색조건 필수 체크 (프로젝트, 계층)
			if ($('#project').val() == "") {
				alert("${WM00025_1}");
				return;
			}
			if ($('#class').val() == "") {
				alert("${WM00025_2}");
				return;
			}
			
			var url = "taskStatistics.do";
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
		
		$('#project').change(function(){
			changeAuthorTeamList($(this).val()); // 담당조직 option 셋팅
			changeClassList($(this).val()); // 계층 option 초기 설정
		});
		
		gridInit();
		changeAuthorTeamList("${ParentID}"); // 담당조직 option 초기 설정
		changeClassList("${ParentID}"); // 계층 option 초기 설정
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
		var aCnt = "${aCnt}";
		var taskActSize = "${taskActSize}";
		var actCspan = ",#cspan,#cspan";
		var colWidth = (document.body.clientWidth - 225 - 150) / aCnt;
		
		for (var i = 0; i < aCnt; i++) {
			widths = widths + "," + colWidth;
			sorting = sorting + ",str";
			aligns = aligns + ",center";
		}
		
		for (var i = 1; i < taskActSize; i++) {
			actCspan = actCspan + ",#cspan";
		}
		
		result.title = "";
		result.key = "";
		result.header = "${menu.LN00191},Total,PLAN,#cspan,#cspan,#cspan,#cspan,#cspan,Actual" + actCspan;
		result.attachHeader1 = "#rspan,#rspan,${taskPlanMap.RDY},#cspan,${taskPlanMap.PLAN1},#cspan,${taskPlanMap.PLAN2},#cspan," + "${taskActualHeader}" + ",${taskPlanMap.CLS},#cspan";
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
	
	// [담당조직 option] 설정
	function changeAuthorTeamList(avg){
		var url    = "getAuthorTeamListOption.do"; // 요청이 날라가는 주소
		var data   = "parentPjtID="+avg; //파라미터들
		var target = "team";             // selectBox id
		var defaultValue = "${OwnerTeamID}";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}
	
	// [계층 option] 설정
	function changeClassList(avg){
		var url    = "getClassCodeOfTaskOption.do"; // 요청이 날라가는 주소
		var data   = "parentPjtID="+avg; //파라미터들
		var target = "class";             // selectBox id
		var defaultValue = "${ItemClassCode}";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}
		
</script>


<div class="msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Task</div>

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
       	
       	<!-- 담당조직 -->
		<th class="viewtop">${menu.LN00153}</th>
		<td class="viewtop alignL">
			<select id="team" Name="team">
			</select>
		</td>
       	
       	<!-- 계층 -->
		<th class="viewtop">${menu.LN00016}</th>
		<td class="viewtop alignL">
			<select id="class" Name="class">
			</select>
		</td>
		
		<!-- 기간기준 -->
		<th class="viewtop">${menu.LN00013}</th>
		<td class="viewtop alignL">
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
<form name="rptForm" id="rptForm" action="" method="post" >
	
	<div id="gridDiv" class="mgT5">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<!-- END :: LIST_GRID -->				
		
</form>