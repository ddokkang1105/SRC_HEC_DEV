<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<style>
	.gray{
    	background-color: #f2f2f2;
		font-weight: bold;
	}
</style>

<script>
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
		
		$("#excel").click(function(){ fnGridExcelDownLoad(); });

		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&projectType=PG";
		fnSelect('projectGroup', data, 'getProject', '${refPGID}', 'Select');

		//도메인 설정
		$('#srArea1').change(function(){
			fnGetSRArea2($(this).val()); 		
		});
		
		//시스템 초기화 
		fnGetSRArea2("${srArea1Code}");
		
		if (isMainMenu == "") { // 초기화면 통계 데이터 출력 안함 
			setTimeout(function() {
				doSearchList();
			}, 30);
		}
		
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

//===============================================================================
// BEGIN ::: GRID

	var layout = new dhx.Layout("grdGridArea", { 
			rows: [
				{
					id: "a",
				},
			]
		});

	// XML 데이터 파싱
	var parser = new DOMParser();
	var xmlDoc = parser.parseFromString(`${xmlData}`, "text/xml");
	var rows = Array.from(xmlDoc.getElementsByTagName("row"));
	var headerList = ${headerListJson};

	var gridColumns = [ 
		{ width: 100, id: "category", header: [{ text: "Category" , align: "center" }], align: "center" },
		{ width: 100, id: "subCategory", header: [{ text: "Sub Category" , align: "center" }], align: "center" },
		];

	 headerList.forEach(header => {
		gridColumns.push({ width: 100, id: header.code, header: [{ text: header.name, align: "center" }], align: "center" });
	});

	gridColumns.push({ width: 100, id: "total", header: [{ text: "Total", align: "center" }], align: "center" });


	var gridData = {
		header: headerList,
		data: rows.map(row => {
			var rowData = {};
			var cells = Array.from(row.children);

			rowData["category"] = cells[0].textContent;
			rowData["subCategory"] = cells[1].textContent; 
			rowData["total"] = cells[cells.length - 1].textContent; 

			headerList.forEach((header, index) => {
				rowData[header.code] = parseInt(cells[index + 2].textContent, 10);
			});

			return rowData;
		})
	};

	var grid = new dhx.Grid("grdGridArea", {
		columns: gridColumns,
		autoWidth: true,
		resizable: true,
		selection: "row",
		tooltip: false,
		data: gridData.data
	});
	var total = grid.data.getLength();
	layout.getCell("a").attach(grid);

	//cell css
	grid.data.forEach(function(item) {
        grid.addCellCss(item.id, "category", "gray");
        grid.addCellCss(item.id, "subCategory", "gray");
        grid.addCellCss(item.id, "total", "gray");

        if (item.subCategory === "Sub Total" || item.category === "Total") {
            grid.config.columns.forEach(function(column) {
                grid.addCellCss(item.id, column.id, "gray");
            });
        }
    });
	
	// END ::: GRID	
	//===============================================================================

	// 검색 버튼 클릭
	$('.searchList').click(function(){  doSearchList(); });

	//조회
	function doSearchList(){
		var url = "srStatistics.do";
		var data = "isMainMenu="+$("#isMainMenu").val();
		var target = "srStatList";
		
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
	};

	// [Clear] click
	function clearSearchCon() {
		$("#projectGroup").val("").attr("selected", "selected");
		$("#srArea1").val("").attr("selected", "selected");
		$("#srArea2").val("").attr("selected", "selected");
		$("#reqTeam").val("").attr("selected", "selected");
		$("#receiptTeam").val("").attr("selected", "selected");
		$("#projectGroup").val("").attr("selected", "selected");
		$("#SC_STR_DT").val('');
		$("#SC_END_DT").val('');

		doSearchList();
	}

	// [담당조직 option] 설정
	function changeAuthorTeamList(avg){
		var url    = "getAuthorTeamListOption.do";    // 요청이 날라가는 주소
		var data   = "parentPjtID="+avg; 		      //파라미터들
		var target = "team";            			  // selectBox id
		var defaultValue = "${OwnerTeamID}";          // 초기에 세팅되고자 하는 값
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

<body>
	<div id="srStatList">
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
					 <input type="text" id="SC_STR_DT" name="SC_STR_DT" value="${beforeYmd}" class="input_off datePicker text" size="8"
							style="width: 70px;" onchange="this.value = makeDateType(this.value);" maxlength="10">
					
					~
					 <input type="text" id="SC_END_DT" name="SC_END_DT" value="${thisYmd}" class="input_off datePicker text" size="8"
							style="width: 70px;" onchange="this.value = makeDateType(this.value);" maxlength="10">
					
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
			&nbsp;<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;cursor:pointer;" onclick="clearSearchCon();">
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</li>
				
		<form name="rptForm" id="rptForm" action="" method="post" >
			<div id="gridDiv" class="mgT5"> <!-- GRID -->
				<div id="grdGridArea" style="width:100%"></div>
			</div>
		</form>

</body>

</html>