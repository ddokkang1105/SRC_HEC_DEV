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

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>

<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용

	$(document).ready(function() {
		// 초기 표시 화면 크기 조정
		$("#grdGridArea").attr("style","height:" + (setWindowHeight() - 200) + "px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:" + (setWindowHeight() - 200) + "px;");
		};

		$("#excel").click(function(){ fnGridExcelDownLoad(); });	

		$("input.datePicker").each(generateDatePicker);
		$('.searchList').click(function() {
			doSearchList();
			return false;
		});

		$("#statusCode").val("${StatusCode}");
		$("#changeTypeCode").val("${ChangetypeCode}");
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

	var layout = new dhx.Layout("grdGridArea", { 
			rows: [
				{
					id: "a",
				},
			]
		});
	
		var gridData = ${gridData};
		var grid = new dhx.Grid(null, {
			columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
				{ width: 100, id: "TeamCode", header: [{ text: "${menu.LN00164}" , align: "center" }], align: "center" },
				{ width: 150, id: "TeamNM", header: [{ text: "${menu.LN00104}", align: "center" }], align: "center" },
				{ hidden: true, id: "ChangeType", header: [{ text: "ChangeType", align: "center"  }], align: "lcentereft"},
				{ width: 100, id: "ChangeTypeNM", header: [{ text: "${menu.LN00022}", align: "center" }] , align: "center"},				
				{ width: 150, id: "ChangeDesc", header: [{ text: "${menu.LN00108}", align: "center" }], align: "center" },	
				{ width: 100, id: "CreationTime", header: [{ text: "${menu.LN00013}", align: "center" }], align: "center" },
				{ width: 100, id: "Status", header: [{ text: "${menu.LN00027}", align: "center" }], align: "center" },
				{ width: 100, id: "LastUpdated", header: [{ text: "${menu.LN00236}", align: "center" }], align: "center" },
				{ width: 100, id: "LastUser", header: [{ text: "${menu.LN00220}", align: "center" }], align: "center" },
				{ hidden: true, id: "Seq", header: [{ text: "Seq", align: "center" }], align: "center" },
				{ hidden: true, id: "TeamID", header: [{ text: "TeamID", align: "center" }], align: "center" }
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data: gridData
		});
		layout.getCell("a").attach(grid);
		$("#TOT_CNT").html(grid.data.getLength());

		var pagination = new dhx.Pagination("pagination", {
			data: grid.data,
			pageSize: 20,
		});	

		//그리드ROW선택시
		grid.events.on("cellClick", function(row,column,e){
			if(column.id != "checkbox"){
				gridOnRowOTSelect(row);
			}
		}); 

		// 그리드ROW선택시 
		function gridOnRowOTSelect(row){
			var url = "orgMainInfo.do?id="+ row.TeamID;
			var w = "1200";
			var h = "800";
			window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		}

	// END ::: GRID	
	//===============================================================================

	//조회
	function doSearchList(){
		var sqlID = "organization_SQL.teamChangeLogList";
		var param = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
				  + "&scStartDt="+ $("#SC_STR_DT").val() 
				  + "&scEndDt=" + $("#SC_END_DT").val()
				  + "&status=" + $("#statusCode").val() 
				  + "&changeType="+ $("#changeTypeCode").val()
				  + "&sqlID="+sqlID;
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadGrid(result);			
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
	}	

	function fnReloadGrid(newGridData){
 		grid.data.parse(newGridData);
 		$("#TOT_CNT").html(grid.data.getLength());
 		fnMasterChk('');
 	}

	//Process 실행
	function doProcess() {
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){
			alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시오.");	
		}else{
			var items = "";
			var checkSts = "";
			for (idx in selectedCell) {
				if (selectedCell[idx].Status == "Waiting") {
					if (idx == 0) {
						items = selectedCell[idx].Seq;
						changeType = selectedCell[idx].ChangeType;
						checkSts = selectedCell[idx].Status;
					} else {
						items = items + "," + selectedCell[idx].Seq
						changeType = selectedCell[idx].ChangeType;
						checkSts = checkSts	+ "," + selectedCell[idx].Status;
					}
				}
			}
			if (checkSts != "") {
				//var url = "processTeamChangeLog.do";
				//var data = "?items=" + items;
				//window.open(url + data, 'window',	'width=602, height=235, left=800, top=300,scrollbar=yes,resizble=0');
				editProcessLog(items);
				
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
	
	// [Process] click
	function editProcessLog(items){		
		if(confirm("${CM00001}")){			
			var url = "updateTeamChangeLog.do";
			var data = "&items=" + items + "&userID=" + "${sessionScope.loginInfo.sessionUserId}" 
					 + "&languageID=" + "${languageID}";
			ajaxPage(url,data,"blankFrame");
		}
	}

	function fnCallBack() {
		alert("${WM00067}");
		doSearchList();
	}
</script>

</head>
<body>
	<div id="itemAuthorList">
		<div id="groupListDiv">
			<input type="hidden" id="currPage" name="currPage" value="${pageNum}" />
		</div>
		<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
			<h3 style="padding: 3px 0 3px 0"><img src="${root}${HTML_IMG_DIR}/img_process.png">&nbsp;Team Change History</h3>
		</div>
		${reportName}
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
					<option value="NMC">Name Change</option>
			</select></li>
			<li><input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" />
			</li>
			<!-- END :: SEARCH -->
		</div>
		<div class="countList mgT8 mgB5">
			<li class="count">Total <span id="TOT_CNT"></span></li>
			<li class="floatR"><c:if
					test="${loginInfo.sessionMlvl == 'SYS'}">	
				&nbsp;<span class="btn_pack small icon"><span class="EXE"></span><input
						value="Process" type="submit" alt="신규" onclick="doProcess()"></span>
				&nbsp;<span class="btn_pack small icon"><span class="EXE"></span><input
						value="Update Log" type="submit" onclick="callTeamChangeLog()"></span>
				&nbsp;<span class="btn_pack small icon"><span class="down"></span><input
						value="Down" type="submit" id="excel"></span>
				</c:if></li>
		</div>

		<div id="gridOTDiv" class="mgB10 clear">
			<div id="grdGridArea" style="width: 100%"></div>
			<div id="pagination"></div>
		</div>
	</div>
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank"
			style="display: none; height: 0px;" frameborder="0" scrolling='no'></iframe>
	</div>
</body>
</html>
