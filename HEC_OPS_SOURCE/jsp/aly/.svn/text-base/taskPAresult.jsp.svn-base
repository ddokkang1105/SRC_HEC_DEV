<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_1" arguments="${menu.LN00277}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_2" arguments="${menu.LN00021}"/>

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
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 150)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 150)+"px;");
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
		
		if (isMainMenu == "") { // 초기화면 통계 데이터 출력 안함
			gridInit();
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
		var colCnt = "${colCnt}";
		//var colWidth = (document.body.clientWidth - 225 - 100) / colCnt;
		var colWidth = 39;
		var header1 = "${header1}";
		var header2 = "${header2}";
		var header3 = "${header3}";
		
		for (var i = 0; i < colCnt; i++) {
			widths = widths + "," + colWidth;
			sorting = sorting + ",str";
			aligns = aligns + ",center";
		}
		
		result.title = "";
		result.key = "";
		result.header = "${menu.LN00042},#cspan," + header1 + ",${menu.LN00253},#cspan,#cspan";
		result.attachHeader1 = "${pjtGrHeader},${menu.LN00191}," + header2 + ",Total,${menu.LN00255},${menu.LN00254}";
		result.attachHeader2 = "#rspan,#rspan," + header3 + ",#rspan,#rspan,#rspan";
		result.widths = "50,*" + widths;
		result.sorting = "str,str" + sorting;
		result.aligns = "center,center" + aligns;
		result.data = "";
		return result;
	}
	
	//조회
	function doSearchList(){
		p_gridArea.enableRowspan(true);
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


<div class="msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Task(Plan/Actual)</div>

<!-- BEGIN :: SEARCH -->
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
       		<select id="pjtGr" Name="pjtGr">
       			<option value=''>Select</option>
	        	<c:forEach var="i" items="${pjtGrList}">
	            	<option value="${i.CODE}" <c:if test="${isMainMenu == '' && i.CODE == ProjectGr}">selected="selected"</c:if>>${i.NAME}</option>
	            </c:forEach>
       		</select>
       	</td>
       	
       	<!-- 프로젝트 -->
       	<th class="viewtop">${menu.LN00131}</th>
       	<td class="viewtop alignL">
       		<select id="project" Name="project">
       		</select>
       	</td>
       	
       	<!-- 항목 유형 -->
		<th class="viewtop">${menu.LN00021}</th>
		<td class="viewtop alignL">
			<select id="itemType" Name="itemType">
			</select>
		</td>
		
       	<!-- 담당조직>
		<th class="viewtop">${menu.LN00153}</th>
		<td class="viewtop alignL">
			<select id="team" Name="team">
			</select>
		</td -->
       	
       	
		<!-- 기준일 -->
		<th class="viewtop">${menu.LN00261}</th>
		<td class="viewtop alignL">
			<font> <input type="text" id="scStartDt" name="scStartDt" value="${thisYmd}" class="input_off datePicker text" size="8"
					style="width: 70px;" onchange="this.value = makeDateType(this.value);" maxlength="10">
			</font>
		</td>
		
		<td class="viewtop last alignR">
			<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" style="cursor:pointer;"/>
		</td>
	</tr>
</table>

<li class="mgT5 alignR">
	<c:if test="${isMainMenu == ''}">
		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
	</c:if>
</li>		

<form name="rptForm" id="rptForm" action="" method="post" >
	
	<div id="gridDiv" class="mgT5">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<!-- END :: LIST_GRID -->				
		
</form>