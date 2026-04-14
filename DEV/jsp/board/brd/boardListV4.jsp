<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script>
	// screenType:
	// - Admin: 관리자/일반 게시판 화면
	// - cust : 커스텀 화면(프로젝트 선택/조회 조건이 다르게 동작)
	var screenType = "${screenType}";
	// baseURL: 게시판 상세/목록 링크 분기에 쓰는 URL 키(sf, forumMgt 등).
	var baseURL = "${baseUrl}";
	var templProjectID = "${templProjectID}";
	var projectType = "${projectType}";
	var projectCategory = "${projectCategory}";
	var projectID = "${projectID}";
	var projectIDs = "${projectIDs}"; 
	var category = "${category}";

	var gridLayout, grid;
	var pagination;	
	
	var OFFSET = 290; // 상단 UI 높이
	var PAGINATION_H = 46;  // dhtmlx Pagination 고정 높이

	// 그리드 높이를 계산해서 적용한다.
	function setGridHeight() {
	    var h = (window.innerHeight || document.documentElement.clientHeight) - OFFSET - PAGINATION_H;
	    $("#gridLayout").css("height", h + "px");
	}	
	
	const columns = [
		{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
		{ width: 50, id: "checkbox", header: [{ text: "" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
		{ fillspace: true, id: "Subject", header: [{ text: "${menu.LN00002}" , align: "center" }],htmlEnable:true, align: "left" },
		{ width: 150, id: "ProjectName", header: [{ text: "${menu.LN00131}", align: "center" }], align: "center" },
		{ width: 150, id: "WriteUserNM", header: [{ text: "${menu.LN00212}", align: "center" }], align: "center" },
		{ width: 130, id: "ModDT2", header: [{ text: "${menu.LN00390}", align: "center" }], align: "center" },
		{ width: 60, id: "ReadCNT", header: [{ text: "${menu.LN00030}", align: "center" }], align: "center" },
		{ hidden: true, width: 0, id: "BoardMgtID", header: [{ text: "BoardMgtID", align: "center" }], align: "center" },
		{ hidden: true, width: 0, id: "BoardID", header: [{ text: "BoardID", align: "center" }], align: "center" },
		{ width: 50, id: "IsNew", header: [{ text: "${menu.LN00068}" , align: "center"}],htmlEnable:true, align: "center",
			template:function (text,row,col){
				if (!row.IsNew || row.IsNew === "blank.png") return "";
				return  '<img src="${root}${HTML_IMG_DIR}/'+row.IsNew+'" width="13" height="13">';
			}	
		},
		{ hidden: true, width: 50, id: "ActiveNotice", header: [{ text: "ActiveNotice" }], align: "center" }			
	]
	

	$(document).ready(function(){
		bindEvents();		
		setTimeout(function() {
	        initGrid();
	    }, 200);

		if(screenType != 'cust'){
			if(projectCategory != null && projectCategory != ""){
				projectID = projectCategory;
			}
		}
		
		if(screenType == 'cust' && projectIDs == ''){projectIDs = "0";}
		
		// project select
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		if(templProjectID != undefined && templProjectID != '') {
			data = data + "&templProjectID="+templProjectID+"&projectType="+projectType;
		}
		fnSelect('project', data, 'getProject', projectID, 'Select');
		
		$("input.datePicker").each(generateDatePicker);
		$('.searchList').click(function(){
			doSearchList("Y");
			return false;
		});
		$('#searchValue').keypress(function(onkey){
			if(onkey.keyCode == 13){
				doSearchList();
				return false;
			}
		});		
		$('#new').click(function(){ 
			doClickNew();
			return false;
		});	
		
		setTimeout(function() {$('#searchValue').focus();}, 0);		
		
		if (category != "") {
			setTimeout(function() { fnSearchCat("${categoryIndex}", "${categoryCnt}", "${category}"); }, 300);
		} else { 
			setTimeout(function() { doSearchList(); }, 300);  // 이게 초기 데이터 로딩까지 담당
		}
	});

	// 브라우저 윈도우 리사이즈 시 그리드 영역의 높이를 자동 조절한다.
	function bindEvents() {
	    $(window).on("resize", function() {
	        setGridHeight();
	        if (grid) grid.paint();
	        if (pagination) pagination.paint();
	    });
	}

	function gridOnRowSelect(row, col) {
		if (col.id == "checkbox") return;

		var boardMgtID = row.BoardMgtID;
		var boardID = row.BoardID;
		var currPage = $("#currPage").val();
		var projectID = $("#project").val();
		var category = $("#categoryCode").val();
		if (category == 'undefined' || category == null) { category = ""; }
		var categoryIndex = $("#categoryIndex").val();
		if (categoryIndex == 'undefined' || categoryIndex == null) { categoryIndex = ""; }
		var categoryCnt = $("#categoryCnt").val();
		if (categoryCnt == 'undefined' || categoryCnt == null) { categoryCnt = ""; }
		var projectCategory = $("#project").val();
		var projectIDs = $("#projectIDs").val();
		if (projectID == null || projectID == undefined) { projectID = ""; }

		var back = "&scStartDt=" + $("#SC_STR_DT").val()
			+ "&searchKey=" + $("#searchKey").val()
			+ "&searchValue=" + $("#searchValue").val()
			+ "&scEndDt=" + $("#SC_END_DT").val()
			+ "&projectCategory=" + projectCategory;

		var url = "boardListInfoMgt.do";
		var data = "NEW=N&boardID=" + encodeURIComponent(boardID)
			+ "&boardMgtID=" + encodeURIComponent(boardMgtID)
			+ "&url=/board/brd/boardDetailV4"
			+ "&screenType=" + encodeURIComponent("${screenType}")
			+ "&pageNum=" + encodeURIComponent(currPage)
			+ "&projectID=" + encodeURIComponent(projectID || "${projectID}")
			+ "&category=" + encodeURIComponent(category)
			+ "&categoryIndex=" + encodeURIComponent(categoryIndex)
			+ back
			+ "&categoryCnt=" + categoryCnt
			+ "&projectIDs=" + encodeURIComponent(projectIDs);

		var target = "help_content";
		ajaxPage(url, data, target);
	}

	function initGrid() {
	    if (grid) { grid.destructor(); grid = null; }
	    if (pagination) { pagination.destructor(); pagination = null; }
	    $("#gridLayout").empty();
	    $("#pagination").empty();

	    setGridHeight();

	    grid = new dhx.Grid("gridLayout", {
	        columns: columns,
	        autoWidth: true,
	        resizable: true,
	        selection: "row",
	        tooltip: false,
	    });

	    pagination = new dhx.Pagination("pagination", {
	        data: grid.data,
	        pageSize: 20,
	    });

	    grid.events.on("cellClick", function(row, column, e) {
	        gridOnRowSelect(row, column);
	    });

	    grid.paint(); // 초기 렌더링
	}
	
	// async function loadData() {
	// 	$('#loading').fadeIn(150);
	// 	var sqlID = "board_SQL.boardList";
	// 	const params = new URLSearchParams({
	// 		LanguageID: "${sessionScope.loginInfo.sessionCurrLangType}",
	// 		BoardMgtID: "${BoardMgtID}",
	// 		projectType: projectType,
	// 		projectID: projectID,
	// 		category: category,
	// 		baseURL: baseURL,
	// 		replyLev: "0",
	// 		screenType: screenType,
	// 		sqlID: sqlID
	// 	});

	// 	try {
	// 		const response = await fetch("getData.do?" + params);
	// 		if (!response.ok) throw new Error("Network response was not ok");
			
	// 		const result = await response.json();
			
	// 		if (result && result.success) {
	// 			// dhtmlx Suite 6+ 방식: data.parse() 사용
	// 			grid.data.parse(result.data); 
	// 			// Total 건수 업데이트
	// 			$("#TOT_CNT").text(grid.data.getLength());
	// 		} else {
	// 			console.error("Data load failed:", result.message);
	// 		}
	// 	} catch (error) {
	// 		console.error("Fetch error:", error);
	// 	} finally {
	// 		$('#loading').fadeOut(150);
	// 	}
	// }

	function handleAjaxError(err) {
		console.error(err);
		Promise.all([getDicData("ERRTP", "LN0014"), getDicData("BTN", "LN0034")])
				.then(([errDic, btnDic]) => showDhxAlert(errDic.LABEL_NM, btnDic.LABEL_NM));
	}

	//조회
	// 목록 데이터를 조회해서 그리드를 갱신한다.
	function doSearchList() {
		if (screenType != 'cust') {
			projectID = $("#project").val();
			if (projectID == null) { projectID = ""; }
		}
		var category = $("#categoryCode").val();
		if (category == 'undefined' || category == null) { category = ""; }
		if (screenType != 'cust') {
			if (projectID == "" && templProjectID != "" && templProjectID != "0") {
				projectID = templProjectID;
			}
		}
		if ($("#project").val() != "" && $("#project").val() != null && $("#project").val() != undefined) {
			projectType = "PJT";
		} else {
			projectType = "PG";
		}

		var sqlID = "board_SQL.boardList";
		const reqParams = new URLSearchParams({
			LanguageID: "${sessionScope.loginInfo.sessionCurrLangType}",
			BoardMgtID: "${BoardMgtID}",
			scStartDt: $("#SC_STR_DT").val(),
			searchKey: $("#searchKey").val(),
			searchValue: $("#searchValue").val(),
			scEndDt: $("#SC_END_DT").val(),
			projectType: projectType,
			projectID: projectID,
			category: category,
			baseURL: baseURL,
			replyLev: "0",
			screenType: screenType,
			sqlID: sqlID
		});

		fetch("getData.do?" + reqParams.toString(), { method: "GET" })
			.then(function (response) {
				if (!response.ok) throw new Error("HTTP " + response.status);
				return response.json();
			})
			.then(function (result) {
				if (!result.success) throw new Error(result.message || "요청 처리 실패");
				fnReloadGrid(result.data || []);
			})
			.catch(function (error) {
				console.log("ERR :" + error.message);
			});
	}

	function fnReloadGrid(newGridData) {
		grid.data.parse(newGridData);
		$("#TOT_CNT").html(grid.data.getLength());
	}
	
	function listToArray(fullString, separator) {var fullArray = [];if (fullString !== undefined) {if (fullString.indexOf(separator) == -1) {fullArray.push(fullString);} else {fullArray = fullString.split(separator);}}return fullArray;}
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	// 현재 화면 조건을 유지한 채 글쓰기 화면으로 이동한다.
	function doClickNew(){
		var projectID = $("#project").val();
		if(projectID==undefined){projectID="${projectID}";}
		var category = $("#categoryCode").val();if(category=='undefined' || category==null){ category=""; }
		var categoryIndex = $("#categoryIndex").val();if(categoryIndex=='undefined' || categoryIndex==null){ categoryIndex=""; }
		var categoryCnt = $("#categoryCnt").val();if(categoryCnt=='undefined' || categoryCnt==null){ categoryCnt=""; }
		var url = "editBoard.do";
		var data = "NEW=Y&BoardMgtID=${BoardMgtID}&projectType=${projectType}&url=${boardUrl}&screenType=${screenType}&pageNum="+$("#currPage").val()
					+"&projectID="+templProjectID+"&screenType=${screenType}"
					+"&defBoardMgtID=${defBoardMgtID}&category="+category
					+"&categoryIndex="+categoryIndex
					+"&templProjectID="+templProjectID
					+"&categoryCnt="+categoryCnt;
		var target = "help_content";
		ajaxPage(url, data, target);		
	}
	
	// 카테고리를 선택하고 목록을 다시 조회한다.
	function fnSearchCat(statusCount,cnt,categoryCode){
		var menuName = "bcList";
		$("#categoryCode").val(categoryCode);
		$("#categoryIndex").val(statusCount);
		$("#categoryCnt").val(cnt);
		for(var i=0; i<=cnt; i++){
			if(statusCount==i){
				$("#"+menuName+i).css('color','#0000FF');
				$("#"+menuName+i).css('font-weight','bold');				
			}else{
				$("#"+menuName+i).css('color','#000000');
				$("#"+menuName+i).css('font-weight','');
			}
		}
		doSearchList();
	}
	
	// 카테고리 필터를 전체(ALL)로 초기화하고 목록을 다시 조회한다.
	function fnGetAll(cnt){ // 카테고리 ALL
		var menuName = "bcList";
		$("#categoryCode").val("");
		$("#categoryIndex").val("");
		for(var i=0; i<=cnt; i++){
			if(i==0){
				$("#"+menuName+i).css('color','#0000FF');
				$("#"+menuName+i).css('font-weight','bold');				
			}else{
				$("#"+menuName+i).css('color','#000000');
				$("#"+menuName+i).css('font-weight','');
			}
		}
		doSearchList();
	}
	
</script>
<div id="help_content" class="mgL10 mgR10">
<form name="boardForm" id="boardForm" action="" method="post" >
	<input type="hidden" id="NEW" name="NEW" value="">
	<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<input type="hidden" id="categoryCode" name="categoryCode" value="${category}">
	<input type="hidden" id="categoryIndex" name="categoryIndex" value="">
	<input type="hidden" id="categoryCnt" name="categoryCnt" value="">
	<c:if test="${screenType != 'cust'}">
		<div class="cop_hdtitle">
			<h3 style="padding: 6px 0;"><img src="${root}${HTML_IMG_DIR}/${icon}">&nbsp;${boardMgtName}</h3>
		</div>
	</c:if>
	<!-- BEGIN :: SEARCH -->
	<table style="table-layout:fixed;" border="0" cellpadding="0" cellspacing="0" class="tbl_search mgT5"  id="search">
		<colgroup>
		    <col width="7%">
		    <col width="18%">
		    <col width="7%">
		    <col width="18%">
		    <col width="7%">
		    <col width="18%">
		    <col width="7%">
		    <col width="18%">
	    </colgroup>
	    <tr>
	    	<th class="alignL" <c:if test="${projectType ne 'PG' && screenType ne 'Admin'}" >style="display:none;"</c:if>>${menu.LN00131}</th>
	    	<td class="alignL" <c:if test="${projectType ne 'PG' && screenType ne 'Admin'}" >style="display:none;"</c:if>><select id="project" name="project" class="sel"></select></td>
	    	<th class="alignL">${menu.LN00390}</th>
	    	<td class="alignL">
	    		<c:if test="${scStartDt != '' and scEndDt != ''}">
					<fmt:parseDate value="${scStartDt}" pattern="yyyy-MM-dd" var="beforeYmd"/>
					<fmt:parseDate value="${scEndDt}" pattern="yyyy-MM-dd" var="thisYmd"/>
					<fmt:formatDate value="${beforeYmd}" pattern="yyyy-MM-dd" var="beforeYmd"/>
					<fmt:formatDate value="${thisYmd}" pattern="yyyy-MM-dd" var="thisYmd"/>
				</c:if>
				<c:if test="${scStartDt == '' or scEndDt == ''}">
					<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
				</c:if>
				 <input type="text" id="SC_STR_DT" name="SC_STR_DT" value="${beforeYmd}"	class="text datePicker" size="8"
						style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
				~
				 <input type="text" id=SC_END_DT	name="SC_END_DT" value="${thisYmd}"	class="text datePicker" size="8"
						style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
	    	</td>
	    	<th class="alignL">
	    		<select id="searchKey" name="searchKey" class="sel">
					<option value="Name">${menu.LN00002}</option>
					<option value="Info" 
						<c:if test="${searchKey == 'Info'}"> selected="selected"</c:if>>
						${menu.LN00003}
					</option>					
				</select>
	    	</th>
	    	<td class="alignL">
	    		<input type="text" class="stext"  id="searchValue" name="searchValue" value="${searchValue}">
	    	</td>
	    	<td colspan=<c:choose><c:when test="${projectType == 'PG' or screenType == 'Admin'}" >2</c:when><c:otherwise>4</c:otherwise></c:choose> class="alignR">
	    	<button class="cmm-btn2 searchList" style="height: 30px;" value="Search">Search</button>
	    </tr>
	</table>
	
	<c:if test="${CategoryYN == 'Y' && brdCatListCnt != '0'}">
		<div class="child_search" style="border-top:0px;">
			<li style="font-weight:bold;">${menu.LN00033}</li>	
			<li>													
			<a href="#" id="bcList0" OnClick="fnSearchCat('0','${brdCatListCnt}','')" class="mgR5">ALL</a>&nbsp;|&nbsp;
			<c:forEach var="bcList" items="${brdCatList}" varStatus="status">				
				<a href="#" id="bcList${status.count}" onclick="fnSearchCat('${status.count}','${brdCatListCnt}','${bcList.CODE}');" class="mgR5">
				${bcList.NAME} 				
				</a><c:if test="${!status.last}" >&nbsp;|&nbsp;</c:if>
			</c:forEach>
			</li>
		</div>
	</c:if>
	<!-- END :: SEARCH -->
	<div class="countList pdT10">
       <li  class="count">Total  <span id="TOT_CNT"></span></li>
       <li class="floatR">
       		<c:if test="${screenType ne 'cust'}">
				<c:if test="${(mgtInfoMap.MgtOnlyYN eq 'Y' and mgtInfoMap.MgtUserID eq sessionScope.loginInfo.sessionUserId) or
				              (mgtInfoMap.MgtOnlyYN ne 'Y' and mgtInfoMap.MgtGRID eq mgtInfoMap.Mgtgrid) or
				              (mgtInfoMap.MgtOnlyYN ne 'Y' and mgtInfoMap.MgtGRID < 1 and sessionScope.loginInfo.sessionAuthLev <= 2) }">
				<li class="floatR pdR10">
					<button class="cmm-btn floatR " style="height: 30px;" id="new"  value="Write">Write</button>
				</li>
				</c:if>
			</c:if>	
       </li>
    </div>

	<div id="gridDiv" class="mgB10 clear" style="width:100%;">
	    <div id="grdOTGridArea02" style="width:100%;">
	        <div id="gridLayout" style="width:100%;"></div>
	        <div id="pagination"></div>
	    </div>
	</div>

	<!-- END :: LIST_GRID -->
</form>
</div>
