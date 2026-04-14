﻿<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<c:url value="/" var="root" />

<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00098" var="WM00098" />

<script type="text/javascript">

	// dhtmlx 5, 9 충돌 해결
	if (window.dhtmlx) {
	    for (const key in window.dhtmlx) {
	        delete window.dhtmlx[key];
	    }
	    delete window.dhtmlx;
	}

	// 변수 선언
	var languageID          = "${sessionScope.loginInfo.sessionCurrLangType}";
	var itemID              = "${itemID}";
	var s_itemID            = "${s_itemID}";
	var screenType          = "${screenType}";
	var instanceNo          = "${instanceNo}";
	var isProcInst          = "${isProcInst}";
	var changeSetID         = "${changeSetID}";
	var projectID           = "${projectID}";
	var myBoard             = "${myBoard}";
	var emailCode           = "${emailCode}";
	var boardTitle          = "${boardTitle}";
	var varFilters          = "${varFilters}";
	var showItemInfo        = "${showItemInfo}";
	var dueDateMgt          = "${dueDateMgt}";
	var mailRcvListSQL      = "${mailRcvListSQL}";
	var replyMailOption     = "${replyMailOption}";
	var forumMailOption     = "${forumMailOption}";
	var showAuthorInfo      = "${showAuthorInfo}";
	var showItemVersionInfo = "${showItemVersionInfo}";
	var showReplyDT         = "${showReplyDT}";
	var openDetailSearch    = "${openDetailSearch}";
	var reviewDept          = "${boardMap.reviewDept}";
	var identifier          = "${ItemCsInfoMap.Identifier}";
	var docTitle            = "${ItemCsInfoMap.Title}";
	var itemVersion         = "${ItemCsInfoMap.ItemVersion}";

	// varFilters 파싱
	var params = varFilters.replace(/^&/, "").split("&");
	const paramMap = {};
	if (params.length > 0) {
		params.forEach(pair => {
			const [key, value] = pair.split("=");
			paramMap[key] = value;
			if (key === "showItemInfo")        showItemInfo = value;
			if (key === "dueDateMgt")          dueDateMgt = value;
			if (key === "mailRcvListSQL")      mailRcvListSQL = value;
			if (key === "emailCode")           emailCode = value;
			if (key === "replyMailOption")     replyMailOption = value;
			if (key === "forumMailOption")     forumMailOption = value;
			if (key === "showAuthorInfo")      showAuthorInfo = value;
			if (key === "showItemVersionInfo") showItemVersionInfo = value;
			if (key === "showReplyDT")         showReplyDT = value;
			if (key === "openDetailSearch")    openDetailSearch = value;
		});
	}

	// grid 관련 변수
	var layout;
	var grid;
	var pagination;

	var OFFSET       = 300; // 상단 UI 높이 (forum은 상세검색 영역이 있어서 300)
	var PAGINATION_H = 46;

	function setGridHeight() {
		var h = (window.innerHeight || document.documentElement.clientHeight) - OFFSET - PAGINATION_H;
		$("#gridLayout").css("height", h + "px");
	}

	const columns = [
		{ width: 50,  id: "RNUM",         header: [{ text: "${menu.LN00024}", align: "center" }], align: "center" },
		{ width: 200, id: "Identifier",   header: [{ text: "문서번호",        align: "center" }], align: "center" },
		{ width: 300, id: "itemName",     header: [{ text: "문서명",          align: "center" }], align: "center" },
		{ width: 100, id: "Version",      header: [{ text: "개정번호",        align: "center" }], align: "center" },
		{ width: 400, id: "Subject",      header: [{ text: "${menu.LN00002}", align: "center" }], align: "left" },
		{ hidden: true, width: 100, id: "ItemTypeNM", header: [{ text: "${menu.LN00021}", align: "center" }], align: "center" },
		{ hidden: true, width: 30,  id: "AttechImg",  header: [{ text: "", align: "center" }], htmlEnable: true, align: "center",
			template: function(text, row, col) {
				if (!row.AttechImg || row.AttechImg === "blank.png") return "";
				return '<img src="${root}${HTML_IMG_DIR}/' + row.AttechImg + '" width="10" height="10">';
			}
		},
		{ id: "WriteUserNM",  header: [{ text: "${menu.LN00060}",              align: "center" }], align: "center" },
		{ id: "TeamNM",       header: [{ text: "${menu.LN01008}",              align: "center" }], align: "center" },
		{ id: "ModDT",        header: [{ text: "${menu.LN00390}",              align: "center" }], align: "center" },
		{ hidden: true, id: "ReplyDT",      header: [{ text: "${menu.LN00323}${menu.LN00391}", align: "center" }], align: "center" },
		{ width: 100, id: "BrdCategory",  header: [{ text: "구분",            align: "center" }], align: "center" },
		{ hidden: true, width: 50, id: "ReadCNT",    header: [{ text: "Count", align: "center" }], align: "center" },
		{ hidden: true, width: 50, id: "CommentCNT", header: [{ text: "Reply", align: "center" }], align: "center" },
		{ hidden: true, width: 40, id: "IsNew",      header: [{ text: "${menu.LN00068}", align: "center" }], htmlEnable: true, align: "center",
			template: function(text, row, col) {
				if (!row.IsNew || row.IsNew === "blank.png") return "";
				return '<img src="${root}${HTML_IMG_DIR}/' + row.IsNew + '" width="13" height="13">';
			}
		},
		{ hidden: true, width: 30, id: "BoardID",     header: [{ text: "boardID",     align: "center" }], align: "center" },
		{ hidden: true, width: 30, id: "ItemID",      header: [{ text: "ItemID",      align: "center" }], align: "center" },
		{ hidden: true, width: 30, id: "BoardMgtID",  header: [{ text: "BoardMgtID",  align: "center" }], align: "center" },
		{ hidden: true, width: 0,  id: "CategoryCode",header: [{ text: "CategoryCode",align: "center" }], align: "center" },
		{ hidden: true, width: 30, id: "ItemTypeCode",header: [{ text: "ItemTypeCode",align: "center" }], align: "center" },
		{ id: "BlockedStatus", header: [{ text: "상태", align: "center" }], align: "center" },
	];

	$(document).ready(function() {

		// 상세검색 박스 이벤트 - document.ready 안으로 이동 (동적 삽입 시 null 방지)
		const searchBox = document.querySelector(".detail_box");
		if (searchBox) {
			searchBox.addEventListener("keyup", (event) => {
				event.stopPropagation();
				if (event.keyCode === 13) { doSearchListForum(); }
			});
		}

		$("#categoryCode").val("${category}");
		const detailShowBtn = document.querySelector("#forumDetailSearch");
		const detail_box    = document.querySelector(".detail_box");

		if (detail_box && ($("#itemTypeCode").val() || $("#SC_STR_DT").val() || $("#regUserName").val()
				|| $("#authorName").val() || $("#categoryCode").val() || openDetailSearch === "Y")) {
			detail_box.className = "detail_box show_detail";
		}
		if (detailShowBtn && detail_box) {
			detailShowBtn.addEventListener("click", (event) => {
				if (event.pointerType !== "") {
					detail_box.className = detail_box.className.includes("show_detail")
						? "detail_box" : "detail_box show_detail";
				}
			});
		}

		// grid 초기화
		bindEvents();
		setTimeout(function() { initGrid(); }, 200);

		// 이벤트 바인딩
		$("#makeNew").click(function() {
			var url  = "boardListInfoMgt.do"; // Change from registerForumPost.do
			var data = "s_itemID=${s_itemID}&noticType=${noticType}&BoardMgtID=${BoardMgtID}&isMyCop=${isMyCop}&screenType=${screenType}&listType=${listType}"
					+ "&srID=${srID}&srType=${srType}&showItemInfo=" + showItemInfo + "&scrnType=${scrnType}"
					+ "&emailCode=" + emailCode + "&mailRcvListSQL=" + mailRcvListSQL + "&boardTitle=" + encodeURIComponent(boardTitle)
					+ "&identifier=${ItemCsInfoMap.Identifier}"
					+ "&docTitle=${ItemCsInfoMap.Title}"
					+ "&forumMailOption=" + forumMailOption
					+ "&showReplyDT=" + showReplyDT
					+ "&openDetailSearch=" + openDetailSearch
					+ "&itemVersion=${ItemCsInfoMap.ItemVersion}&dueDateMgt=" + dueDateMgt
					+ "&showAuthorInfo=" + showAuthorInfo
					+ "&showItemVersionInfo=" + showItemVersionInfo
					+ "&fileTokenYN=Y"
					+ "&replyMailOption=" + replyMailOption;
			if (instanceNo != '') { data += "&instanceNo=" + instanceNo + "&projectID=" + projectID; }
			if (changeSetID != '') { data += "&changeSetID=" + changeSetID; }
			var target = "help_content";
			data += "&url=/board/frm/registerForumPostV4"; // V4 URL 추가
			ajaxPage(url, data, target);
			return false;
		});

		$("#backSR").click(function() {
			var url      = "processISP.do";
			var scrnType = "${scrnType}";
			if (scrnType == "" || scrnType == undefined) scrnType = "srRqst";
			var data = "srType=${srType}&scrnType=" + scrnType + "&itemProposal=${itemProposal}&srID=${srID}&defCategory=${defCategory}"
					+ "&category=${srCategory}&subject=${subject}"
					+ "&receiptUser=${receiptUser}&requestUser=${requestUser}&requestTeam=${requestTeam}"
					+ "&startRegDT=${startRegDT}&endRegDT=${endRegDT}&searchSrCode=${searchSrCode}"
					+ "&srReceiptTeam=${srReceiptTeam}&searchStatus=${searchStatus}"
					+ "&srArea1=${srArea1}&srMode=${srMode}";
			var target = "help_content";
			ajaxPage(url, data, target);
			return false;
		});

		$("input.datePicker").each(generateDatePicker);
		setTimeout(function() { $('#searchValue').focus(); }, 0);
		setTimeout(function() { doSearchListForum(); }, 300);

		fnSelect('itemTypeCode', 'languageID=${sessionScope.loginInfo.sessionCurrLangType}&editable=1&category=OJ&BoardMgtID=${BoardMgtID}', 'getCategory', '${ItemTypeCode}', 'Select', 'forum_SQL');
		setTimeout(function() {
			$("#itemTypeCode").append("<option value='General'>General</option>");
		}, 250);
	});

	// 리사이즈 이벤트
	function bindEvents() {
		$(window).on("resize", function() {
			setGridHeight();
			if (grid) grid.paint();
			if (pagination) pagination.paint();
		});
	}

	// grid 초기화
	function initGrid() {
	    if (grid) { grid.destructor(); grid = null; }
	    if (pagination) { pagination.destructor(); pagination = null; }
	    if (layout) { layout.destructor(); layout = null; }
	    $("#gridLayout").empty();
	    $("#pagination").empty();
	
	    setGridHeight();
	
	    // 기존처럼 Layout + Grid 구조 유지
	    layout = new dhx.Layout("gridLayout", {
	        rows: [{ id: "a" }]
	    });
	
	    grid = new dhx.Grid(null, {
	        columns: columns,
	        autoWidth: true,
	        resizable: true,
	        selection: "row",
	        tooltip: false,
	    });
	
	    // 컬럼 표시/숨김
	    if ("${categoryCnt}" == 0 || "${boardMgtInfo.CategoryYN}" == "N") {
	        grid.hideColumn("BrdCategory");
	    }
	    if (showItemInfo === "N") {
	        grid.hideColumn("ItemTypeNM");
	        grid.hideColumn("Identifier");
	        grid.hideColumn("itemName");
	        grid.hideColumn("Version");
	    }
	    if (showReplyDT === "Y") {
	        grid.showColumn("ReplyDT");
	    }
	
	    layout.getCell("a").attach(grid);
	
	    pagination = new dhx.Pagination("pagination", {
	        data: grid.data,
	        pageSize: 20,
	    });
	
	    grid.events.on("cellClick", function(row, column, e) {
	        if (column.id != "checkbox") { gridOnRowSelect(row); }
	    });
	
	    grid.paint();
	}
	
	// 데이터 조회 (getData.do API)
	async function doSearchListForum() {
		var category   = $("#categoryCode").val();
		var statusCode = $("#statusCode").val();
		if (category == 'undefined' || category == null) { category = ""; }
		if (statusCode == "BRDSTS102")     { statusCode = 0;  }
		else if (statusCode == "BRDSTS101") { statusCode = 1;  }
		else                                { statusCode = ""; }

		var itemTypeCode = $("#itemTypeCode").val() ?? "";

		const reqParams = new URLSearchParams({
			sqlID:       "forum_SQL.forumGridList",
			languageID:  languageID,
			noticType:   "${noticType}",
			itemTypeCode:itemTypeCode,
			category:    category,
			statusCode:  statusCode,
			itemID:      itemID,
			BoardMgtID:  "${BoardMgtID}",
			myBoard:     myBoard,
			searchValue: $("#searchValue").val(),
			subjectName: $("#subjectName").val(),
			pageNum:     $("#currPage").val(),
			regUserName: $("#regUserName").val(),
			authorName:  $("#authorName").val(),
			content:     $("#content").val(),
			scStartDt:   "${srID}" == "" ? $("#SC_STR_DT").val() : "",
			scEndDt:     "${srID}" == "" ? $("#SC_END_DT").val() : "",
			TeamNM:      $("#TeamNM").val(),
			instanceNo:  instanceNo,
			isProcInst:  isProcInst,
			srID:        "${srID}",
		});

		try {
			$('#loading').fadeIn(150);
			const response = await fetch("getData.do?" + reqParams.toString(), { method: "GET" });
			if (!response.ok) throw new Error("HTTP " + response.status);

			const data = await response.json();
			if (!data.success) throw new Error(data.message || "요청 처리 실패");

			if (data && data.data) { fnReloadGrid(data.data); }

		} catch (error) {
			console.log("ERR: " + error.message);
		} finally {
			$('#loading').fadeOut(150);
		}
	}

	function fnReloadGrid(newGridData) {
		grid.data.parse(newGridData);
		$("#TOT_CNT").html(grid.data.getLength());
	}

	function setWindowHeight() {
		var size = window.innerHeight;
		return (size == null || size == undefined) ? document.body.clientHeight : window.innerHeight;
	}

	function deleteforum(boardID) {
		var data   = "boardID=" + boardID;
		var url    = "boardForumDelete.do";
		var target = "help_content";
		ajaxPage(url, data, target);
	}

	function InfoView(isNew, BoardMgtID, noticType, boardID, ItemID, s_itemID, userId) {
		var data = "NEW=" + isNew + "&BoardMgtID=" + BoardMgtID + "&noticType=101&boardID=" + boardID
				+ "&ItemID=" + ItemID + "&s_itemID=" + s_itemID + "&userId=" + userId + "&srID=${srID}";
		if (instanceNo != '') { data += "&instanceNo=" + instanceNo + "&projectID=" + projectID; }
		var url    = "boardListInfoMgt.do";
		var target = "help_content";
		ajaxPage(url, data, target);
	}

	function gridOnRowSelect(row) {
		var isNew        = "N";
		var BoardMgtID   = row.BoardMgtID;
		var noticType    = "${noticType}";
		var boardID      = row.BoardID;
		var ItemID       = row.ItemID;
		var s_itemID     = "${s_itemID}";
		var pageNum      = $("#currPage").val();
		var itemTypeCode = row.ItemTypeCode;
		
		var data = "NEW=" + isNew + "&BoardMgtID=" + encodeURIComponent(BoardMgtID) + "&noticType=" + noticType
				+ "&boardID=" + encodeURIComponent(boardID) + "&ItemID=" + encodeURIComponent(ItemID) + "&s_itemID=" + encodeURIComponent(s_itemID)
				+ "&pageNum=" + encodeURIComponent(pageNum) + "&isMyCop=${isMyCop}"
				+ "&searchValue="  + encodeURIComponent($("#searchValue").val())
				+ "&subjectName="  + encodeURIComponent($("#subjectName").val())
				+ "&regUserName="  + encodeURIComponent($("#regUserName").val())
				+ "&authorName="   + encodeURIComponent($("#authorName").val())
				+ "&category="     + encodeURIComponent($("#categoryCode").val())
				+ "&itemTypeCode=" + encodeURIComponent(itemTypeCode)
				+ "&instanceNo="   + encodeURIComponent(instanceNo)
				+ "&listType=${listType}"
				+ "&showItemInfo=" + encodeURIComponent(showItemInfo)
				+ "&screenType="   + encodeURIComponent(screenType)
				+ "&mailRcvListSQL=" + encodeURIComponent(mailRcvListSQL)
				+ "&emailCode="    + encodeURIComponent(emailCode)
				+ "&srID=${srID}"
				+ "&srType=${srType}"
				+ "&scrnType=${scrnType}"
				+ "&myBoard="      + myBoard
				+ "&replyMailOption="     + replyMailOption
				+ "&forumMailOption="     + forumMailOption
				+ "&showReplyDT="         + showReplyDT
				+ "&openDetailSearch="    + openDetailSearch
				+ "&showAuthorInfo="      + showAuthorInfo
				+ "&showItemVersionInfo=" + showItemVersionInfo
				+ "&dueDateMgt="          + dueDateMgt;

		if (mailRcvListSQL === "review") {
			data += "&boardTitle=" + encodeURIComponent(boardTitle)
					+ "(" + encodeURIComponent(row.Identifier) + "_" + encodeURIComponent(row.itemName) + "_" + encodeURIComponent(row.Version) + ")";
		} else {
			data += "&boardTitle=" + encodeURIComponent(boardTitle);
		}

		if ("${srID}" == null || "${srID}" == '') {
			data += "&scStartDt=" + encodeURIComponent($("#SC_STR_DT").val()) + "&scEndDt=" + encodeURIComponent($("#SC_END_DT").val());
		} else {
			data += "&srCategory=${srCategory}&subject=${subject}";
			data += "&startRegDT=${startRegDT}&endRegDT=${endRegDT}&searchSrCode=${searchSrCode}";
			data += "&receiptUser=${receiptUser}&requestUser=${requestUser}&requestTeam=${requestTeam}";
			data += "&srReceiptTeam=${srReceiptTeam}&searchStatus=${searchStatus}";
			data += "&srArea1=${srArea1}&srMode=${srMode}";
		}
		if (instanceNo != '') { data += "&instanceNo=" + encodeURIComponent(instanceNo); }

		var url    = "boardListInfoMgt.do";
		var target = "help_content";
		data += "&url=/board/frm/viewForumPostV4"; // V4 URL 추가
		ajaxPage(url, data, target);
	}

</script>

<div id="help_content" style="display: block; overflow-y: auto; height: 100%;" class="pdL10 pdR10">
	<form name="boardForumList" id="boardForumList" action="" method="post" onsubmit="return false;">
		<input type="hidden" id="s_itemID"   name="s_itemID"   value="${s_itemID}">
		<input type="hidden" id="BoardMgtID" name="BoardMgtID" value="${BoardMgtID}">
		<input type="hidden" id="BoardID"    name="BoardID"    value="">
		<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}">
		<input type="hidden" id="noticType"  name="noticType"  value="${noticType}">
		<input type="hidden" id="currPage"   name="currPage"   value="${pageNum}">

		<div class="detail_box">
			<div class="search_box flex">
				<input type="text" id="searchValue" value="${searchValue}" name="searchValue"
					class="stext" style="width: 310px;" placeholder="${WM00098}" autocomplete="off">
				<button class="detail" id="forumDetailSearch">${menu.LN00108}</button>
			</div>
			<div class="search_detail">
				<div class="box_col1" style="display:none;">
					<div class="title">${menu.LN00021}</div>
					<select id="itemTypeCode" class="sel"></select>
				</div>
				<c:if test="${boardMgtInfo.CategoryYN == 'Y' && brdCatListCnt != '0'}">
					<div class="box_col1">
						<div class="title">${menu.LN00042}</div>
						<select class="sel" id="categoryCode" name="categoryCode">
							<option value="">ALL</option>
							<c:forEach var="bcList" items="${brdCatList}" varStatus="status">
								<c:if test="${bcList.CODE != 'BRDSTS101' and bcList.CODE != 'BRDSTS102'}">
									<option value="${bcList.CODE}">${bcList.NAME}</option>
								</c:if>
							</c:forEach>
						</select>
					</div>
				</c:if>
				<div class="box_col1">
					<div class="title">${menu.LN00002}</div>
					<input type="text" id="subjectName" value="" name="subjectName" class="stext">
				</div>
				<div class="box_col1 mgL10">
					<div class="title">상태</div>
					<select class="sel" id="statusCode" name="statusCode">
						<option value="">ALL</option>
						<c:forEach var="bcList" items="${brdCatList}" varStatus="status">
							<c:if test="${bcList.CODE eq 'BRDSTS101' or bcList.CODE eq 'BRDSTS102'}">
								<option value="${bcList.CODE}">${bcList.NAME}</option>
							</c:if>
						</c:forEach>
					</select>
				</div>
				<div class="box_col1 mgL20" style="display:none;">
					<div class="title">${menu.LN00003}</div>
					<input type="text" id="content" value="${content}" name="content" class="stext">
				</div>
				<span style="display: block; height: 10px;"></span>
				<div class="box_col1 mgL20" style="display:none;">
					<div class="title">${menu.LN00060}</div>
					<input type="text" id="regUserName" value="${regUserName}" name="regUserName" class="stext">
				</div>
				<div class="box_col1 mgL20" style="margin-left: 0px !important;">
					<div class="title">${menu.LN00060}</div>
					<input type="text" id="authorName" value="${authorName}" name="authorName" class="stext">
				</div>
				<div class="box_col1 mgL10">
					<div class="title">${menu.LN01008}</div>
					<input type="text" id="TeamNM" value="" name="TeamNM" class="stext">
				</div>
				<div class="box_col2 mgL20">
					<div class="title">${menu.LN00390}</div>
					<c:if test="${scStartDt != '' and scEndDt != ''}">
						<fmt:parseDate value="${scStartDt}" pattern="yyyy-MM-dd" var="beforeYmd" />
						<fmt:parseDate value="${scEndDt}"   pattern="yyyy-MM-dd" var="thisYmd" />
						<fmt:formatDate value="${beforeYmd}" pattern="yyyy-MM-dd" var="beforeYmd" />
						<fmt:formatDate value="${thisYmd}"   pattern="yyyy-MM-dd" var="thisYmd" />
					</c:if>
					<c:if test="${scStartDt == '' or scEndDt == ''}">
						<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd" />
					</c:if>
					<input type="text" id="SC_STR_DT" name="SC_STR_DT" value="${beforeYmd}"
						class="text datePicker mgR6" size="8" style="width: 117px"
						onchange="this.value = makeDateType(this.value);" maxlength="10">
					-
					<input type="text" id="SC_END_DT" name="SC_END_DT" value="${thisYmd}"
						class="text datePicker mgL6" size="8" style="width: 117px"
						onchange="this.value = makeDateType(this.value);" maxlength="10">
				</div>
				<button onclick="doSearchListForum()" class="submit_detail">${menu.LN00047}</button>
			</div>
		</div>
		<!-- END :: SEARCH -->

		<div class="pdT10 pdB10 align-center flex justify-between">
			<p style="font-size: 13px; font-weight: bold;" class="mgR120 mgL10">${boardTitle}</p>
			<div class="floatR">
				<c:choose>
					<c:when test="${boardMgtInfo.MgtOnlyYN eq 'Y' && boardMgtInfo.ReplyOption eq '3' && ItemMgtUserMap.AuthorID == sessionScope.loginInfo.sessionUserId}">
						<button class="cmm-btn floatR" style="height: 30px;" id="makeNew" value="Request review">Request review</button>
					</c:when>
					<c:when test="${boardMgtInfo.MgtOnlyYN eq 'Y' && boardMgtInfo.ReplyOption ne '3' && boardMgtInfo.MgtUserID == sessionScope.loginInfo.sessionUserId}">
						<button class="cmm-btn floatR" style="height: 30px;" id="makeNew" value="Post Subject">Post Subject</button>
					</c:when>
					<c:when test="${mailRcvListSQL eq 'review' && boardMgtInfo.ReplyOption eq '3' && ItemMgtUserMap.AuthorID == sessionScope.loginInfo.sessionUserId}">
						<button class="cmm-btn floatR" style="height: 30px;" id="makeNew" value="Request review">Write</button>
					</c:when>
					<c:when test="${boardMgtInfo.MgtOnlyYN ne 'Y' && myBoard ne 'Y' && mailRcvListSQL ne 'review'}">
						<button class="cmm-btn floatR" style="height: 30px;" id="makeNew" value="Write">Write</button>
					</c:when>
				</c:choose>
				<c:if test="${not empty srID}">
					&nbsp;<button class="cmm-btn" style="height: 30px;" id="backSR" value="Back">Back</button>&nbsp;
				</c:if>
			</div>
		</div>

		<!-- GRID -->
		<div id="gridDiv" class="mgB10 clear" style="width:100%;">
		    <div style="width:100%;" id="gridLayout" class="forum"></div>
		    <div id="pagination"></div>
		</div>

	</form>
</div>

