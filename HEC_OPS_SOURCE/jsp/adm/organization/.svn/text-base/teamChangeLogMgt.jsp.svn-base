<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<c:url value="/" var="root" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message
	code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message
	code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

<!-- 2. Script -->
<script type="text/javascript">
	var OT_gridArea; //그리드 전역변수
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용

	$(document).ready(
			function() {
				// 초기 표시 화면 크기 조정
				$("#grdGridArea").attr("style","height:" + (setWindowHeight() - 180) + "px;");
				// 화면 크기 조정
				window.onresize = function() {
					$("#grdGridArea").attr("style","height:" + (setWindowHeight() - 180) + "px;");
				};

				$("#excel").click(function() {
					OT_gridArea.toExcel("${root}excelGenerate");
				});
				$("input.datePicker").each(generateDatePicker);
				$('.searchList').click(function() {
					doSearchList();
					return false;
				});

				$("#statusCode").val("${StatusCode}");
				$("#changeTypeCode").val("${ChangetypeCode}");

				gridOTInit();
				doSearchList();

			});

	function setWindowHeight() {
		var size = window.innerHeight;
		var height = 0;
		if (size == null || size == undefined) {
			height = document.body.clientHeight;
		} else {
			height = window.innerHeight;
		}
		return height;
	}

	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit() {
		var d = setOTGridData();
		OT_gridArea = fnNewInitGrid("grdGridArea", d);
		OT_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		fnSetColType(OT_gridArea, 1, "ch");
		OT_gridArea.attachEvent("onRowSelect", function(id, ind) { //id : ROWNUM, ind:Index
			gridOnRowOTSelect(id, ind);
		});

		//START - PAGING
		OT_gridArea.enablePaging(true, 20, 20, "pagingArea", true,"recInfoArea");
		OT_gridArea.setPagingSkin("bricks");
		OT_gridArea.attachEvent("onPageChanged", function(ind, fInd, lInd) {
			$("#currPage").val(ind);
		});
		//END - PAGING
	}

	function setOTGridData() {
 		var result = new Object();
 		result.title = "${title}";
 		result.key = "organization_SQL.teamChangeLogList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00164},${menu.LN00104},ChangeType,${menu.LN00022},${menu.LN00013},${menu.LN00027},${menu.LN00236},${menu.LN00220},Seq,TeamID";
		result.cols = "CHK|TeamCode|TeamNM|ChangeType|ChangeTypeNM|CreationTime|Status|LastUpdated|LastUser|Seq|TeamID";
		result.widths = "50,50,100,150,0,100,100,100,100,100,0,0"; 
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "&languageID=${languageID}" + 
				"&scStartDt="+ $("#SC_STR_DT").val() + "&scEndDt=" + $("#SC_END_DT").val()
				+ "&status=" + $("#statusCode").val() + "&changeType="+ $("#changeTypeCode").val()
				+"&pageNum="+ $("#currPage").val();

		return result;
	}

	//그리드ROW선택시
	function gridOnRowOTSelect(id, ind) {
		var url = "orgMainInfo.do?id="+ OT_gridArea.cells(id, 11).getValue();
		var w = "1200";
		var h = "800";
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	// END ::: GRID	
	//===============================================================================

	//조회
	function doSearchList() {
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(OT_gridArea, d.key, d.cols, d.data);
	}

	//Process 실행
	function doProcess() {
		if (OT_gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00023}");
		} else {
			var checkedRows = OT_gridArea.getCheckedRows(1).split(",");
			var items = "";
			var checkSts = "";
			for (var i = 0; i < checkedRows.length; i++) {
				if (OT_gridArea.cells(checkedRows[i], 7).getValue() == "Waiting") {
					if (i == 0) {
						items = OT_gridArea.cells(checkedRows[i], 10).getValue();
						changeType = OT_gridArea.cells(checkedRows[i], 4).getValue();
						checkSts = OT_gridArea.cells(checkedRows[i], 7).getValue();
					} else {
						items = items	+ ","	+ OT_gridArea.cells(checkedRows[i], 10).getValue();
						changeType = OT_gridArea.cells(checkedRows[i], 4).getValue();
						checkSts = checkSts	+ ","	+ OT_gridArea.cells(checkedRows[i], 7).getValue();
					}
				}
			}
			if (checkSts != "") {
				var url = "processTeamChangeLog.do";
				var data = "?items=" + items;
				window.open(url + data, 'window',	'width=602, height=235, left=800, top=300,scrollbar=yes,resizble=0');
			} else {
				alert("This change event is already processed.");
			}
		}
	}

	// [TW_INSERT_TEAM_CHANGE_LOG] click
	function callTeamChangeLog() {
		var url = "callTeamChangeLog.do";
		var data = "";
		var target = "blankFrame";
		ajaxPage(url, data, target);
	}
</script>

</head>
<body>
	<div id="itemAuthorList">
		<div id="groupListDiv">
			<input type="hidden" id="currPage" name="currPage" value="${pageNum}" />
		</div>
		<div class="cfgtitle pdL0 pdR0 pdT5 pdB8">
			<ul>
				<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png"
					id="subTitle_baisic">&nbsp;Team Change History</li>
			</ul>
		</div>
		<div class="child_search">
			<!-- BEGIN :: SEARCH -->
			<li><span style="font-weight: bold;">From</span> <c:if
					test="${scStartDt != '' and scEndDt != ''}">
					<fmt:parseDate value="${scStartDt}" pattern="yyyy-MM-dd"
						var="beforeYmd" />
					<fmt:parseDate value="${scEndDt}" pattern="yyyy-MM-dd"
						var="thisYmd" />
					<fmt:formatDate value="${beforeYmd}" pattern="yyyy-MM-dd"
						var="beforeYmd" />
					<fmt:formatDate value="${thisYmd}" pattern="yyyy-MM-dd"
						var="thisYmd" />
				</c:if> <c:if test="${scStartDt == '' or scEndDt == ''}">
					<fmt:formatDate value="<%=new java.util.Date()%>"
						pattern="yyyy-MM-dd" var="thisYmd" />
					<fmt:formatDate
						value="<%=xbolt.cmm.framework.util.DateUtil.getDateAdd(
						new java.util.Date(), 3, -7)%>"
						pattern="yyyy-MM-dd" var="beforeYmd" />
				</c:if> <font> <input type="text" id="SC_STR_DT" name="SC_STR_DT"
					value="${beforeYmd}" class="text datePicker" size="8"
					style="width: 80px;"
					onchange="this.value = makeDateType(this.value);" maxlength="10">
			</font> <span style="font-weight: bold;">To</span> <font> <input
					type="text" id=SC_END_DT name="SC_END_DT" value="${thisYmd}"
					class="text datePicker" size="8" style="width: 80px;"
					onchange="this.value = makeDateType(this.value);" maxlength="10">
			</font></li>
			<li><span style="font-weight: bold;">Status</span> <select
				id="statusCode" name="statusCode" class="sel" style="width: 120px;">
					<option value="">Select</option>
					<option value="01">Waiting</option>
					<option value="02">Closed</option>
			</select></li>
			<li><span style="font-weight: bold;">Change Type</span> <select
				class="sel" id="changeTypeCode" name="changeTypeCode"
				style="width: 120px;">
					<option value="">Select</option>
					<option value="NEW">New</option>
					<option value="DEL">DEL</option>
			</select></li>
			<li><input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" />
			</li>
			<!-- END :: SEARCH -->
		</div>
		<div class="countList mgT8 mgB5">
			<li class="count">Total <span id="TOT_CNT"></span></li>
			<li class="floatR"><c:if
					test="${loginInfo.sessionMlvl == 'SYS'}">	
				&nbsp;<span class="btn_pack small icon"><span class="process"></span><input
						value="Process" type="submit" alt="신규" onclick="doProcess()"></span>
				&nbsp;<span class="btn_pack small icon"><span class="EXE"></span><input
						value="Update Log" type="submit" onclick="callTeamChangeLog()"></span>
				&nbsp;<span class="btn_pack small icon"><span class="down"></span><input
						value="Down" type="submit" id="excel"></span>
				</c:if></li>
		</div>

		<div id="gridOTDiv" class="mgB10 clear">
			<div id="grdGridArea" style="width: 100%"></div>
		</div>
		<!-- START :: PAGING -->
		<div style="width: 100%;" class="paginate_regular">
			<div id="pagingArea" style="display: inline-block;"></div>
			<div id="recinfoArea" class="floatL pdL10"></div>
		</div>
		<!-- END :: PAGING -->
	</div>

	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank"
			style="display: none; height: 0px;" frameborder="0" scrolling='no'></iframe>
	</div>

</body>
</html>
