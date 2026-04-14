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
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 190)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 190)+"px;");
		};
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&projectType=PG";
		fnSelect('projectGroup', data, 'getProject', '${refPGID}', 'Select');
		
		// 검색 버튼 클릭
		$('.searchList').click(function(){
			var url = "srStatistics.do";
			var data = "";
			var target = "mainLayer";
			
			/* 검색 조건 설정 */
			// project Group
			if($("#projectGroup").val() != '' & $("#projectGroup").val() != null){
				data = data +"&refPGID="+ $("#projectGroup").val();
			}
			// 도메인
			if($("#srArea1").val() != '' & $("#srArea1").val() != null){
				data = data +"&srArea1="+ $("#srArea1").val();
			}
			// 시스템
			if($("#srArea2").val() != '' & $("#srArea2").val() != null){
				data = data +"&srArea2="+ $("#srArea2").val();
			}
			// 요청부서
			if($("#reqTeam").val() != '' & $("#reqTeam").val() != null){
				data = data +"&reqTeam="+ $("#reqTeam").val();
			}
			// 접수팀 
			if($("#receiptTeam").val() != '' & $("#receiptTeam").val() != null){
				data = data +"&receiptTeam="+ $("#receiptTeam").val();
			}
			// 등록일
			if($("#SC_STR_DT").val() != '' & $("#SC_END_DT").val() != null){
				data = data + "&SC_STR_DT=" + $("#SC_STR_DT").val();
		        data = data + "&SC_END_DT=" + $("#SC_END_DT").val();
			}
			ajaxPage(url, data, target);
		});
		
		//도메인 설정
		$('#srArea1').change(function(){
			fnGetSRArea2($(this).val()); 		
		});
		
		//시스템 초기화 
		fnGetSRArea2("${srArea1Code}");
		
		gridInit();
		if (isMainMenu == "") { // 초기화면 통계 데이터 출력 안함
			setTimeout(function() {
				doSearchList();
			}, 30);
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
		var colCnt = "${colCnt}"-2;
		var colWidth = (document.body.clientWidth - 230 - 130 - 150 -30) / colCnt;
		
		var header1 = "${header1}";
// 		var header2 = "${header2}";
		
		for (var i = 0; i < colCnt; i++) {
			widths = widths + "," + colWidth;
			sorting = sorting + ",str";
			aligns = aligns + ",center";
		}
		
		result.title = "";
		result.key = "";
		result.header = "Category/Sub Category,#cspan,"+header1+",Total";
// 		result.attachHeader1 ="상태,"+header2+",#rspan" ;
		
		result.widths = "120, *" + widths;
		result.sorting = "str" + sorting;
		result.aligns = "center" + aligns;
		result.data = ""; //alert(result.data);
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
	
	function fnGetSRArea2(SRArea1ID){
		if(SRArea1ID == ''){
			for(var i = $("#srArea2").get(0).length-1 ; i>=1 ; i--){
				$("#srArea2").get(0).options[i] =  null;
			}
		}else{
			var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&parentID="+SRArea1ID;
			fnSelect('srArea2', data, 'getSrArea2', '${srArea2Code}', 'Select');
		}		
	}
</script>

<div class="floatL mgT10 mgB12">
	<h3><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;SR 처리현황 통계</h3>
</div>
<!-- BEGIN :: SEARCH -->
<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
	<colgroup>
	    <col width="5%">
	    <col width="15%">
	    <col width="5%">
	    <col width="13%">
	    <col width="5%">
	    <col width="13%">
	    <%-- <col width="5%">
	    <col width="13%">
	    <col width="5%">
	    <col>
	    <col width="8%"> --%>
    </colgroup>
    <tr>
    	<!-- 프로젝트그룹 -->
		<th class="viewtop">${menu.LN00277}</th>
		<td class="viewtop alignL">
			<select id="projectGroup" Name="projectGroup" style="width:90%"></select>
		</td>
    	<!-- 등록일 -->
		<th class="viewtop">${menu.LN00013}</th>
		<td class="viewtop alignL">
			<font> <input type="text" id="SC_STR_DT" name="SC_STR_DT" value="${beforeYmd}" class="input_off datePicker text" size="8"
					style="width: 70px;" onchange="this.value = makeDateType(this.value);" maxlength="10">
			</font>
			~
			<font> <input type="text" id="SC_END_DT" name="SC_END_DT" value="${thisYmd}" class="input_off datePicker text" size="8"
					style="width: 70px;" onchange="this.value = makeDateType(this.value);" maxlength="10">
			</font>
		</td>
		
		<!-- 요청부서 -->
		<th class="viewtop">${menu.LN00026}</th>
		<td class="viewtop alignL">
			<select id="reqTeam" Name="reqTeam" style="width:90%">
				<option value=''>Select</option>
				<c:forEach var="i" items="${reqTeamList}">
					<option value="${i.CODE}" <c:if test="${i.CODE == reqTeamCode}">selected="selected"</c:if>>${i.NAME}</option>
				</c:forEach>
			</select>
		</td>
	</tr>
	<br>
	<tr>
		<!-- 도메인 -->
       	<th>${menu.LN00274}</th>
       	<td>
       		<select id="srArea1" Name="srArea1" style="width:90%">
       			<option value=''>Select</option>
	        	<c:forEach var="i" items="${srArea1List}">
	            	<option value="${i.CODE}" <c:if test="${i.CODE == srArea1Code}">selected="selected"</c:if>>${i.NAME}</option>
	            </c:forEach>
       		</select>
       	</td>
       	
       	<!-- 시스템 -->
		<th>${menu.LN00185}</th>
		<td>
			<select id="srArea2" Name="srArea2" style="width:90%">
            	<option value="">Select</option>            
        </select>
		</td>
		
		<!-- 접수팀 -->
		<th>${menu.LN00227}</th>
		<td class="alignL">
			<select id="receiptTeam" Name="receiptTeam" style="width:90%">
				<option value=''>Select</option>
				<c:forEach var="i" items="${receiptTeamList}">
					<option value="${i.CODE}" <c:if test="${i.CODE == receiptTeamCode}">selected="selected"</c:if>>${i.NAME}</option>
				</c:forEach>
			</select>
		</td>
	</tr>
</table>
<li class="mgT5 alignR">
	<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" />
	<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
</li>
		
<form name="rptForm" id="rptForm" action="" method="post" >
	
	<div id="gridDiv" class="mgT5">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<!-- END :: LIST_GRID -->				
		
</form>