<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<c:url value="/" var="root" />
<c:url value="/getData.do" var="getDataUrl" />
<c:url value="/boardListV44.do" var="boardListUrl" />

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00003" var="CM00003"/>

<script type="text/javascript">
	// menuIndex: 현재 화면에 렌더된 메뉴 목록.
	// clickSubMenu/clickOpenClose에서 active 상태를 바꿀 때 사용한다.
	var menuIndex = "";
	// getData.do로 조회한 게시판 그룹/메뉴 원본 데이터.
	var boardGrpList = [];
	var boardMgtList = [];
	var startBoardIndex = 1;
	
	$(document).ready(function(){
		loadInitialListFallback();
		loadBoardMenuData();
	});

	// 메뉴 데이터 조회 전에 우측 리스트가 비지 않도록 기본 목록을 먼저 로드한다.
	function loadInitialListFallback() {
		var params = new URLSearchParams({
			languageID: "${sessionScope.loginInfo.sessionCurrLangType}",
			// screenType: 게시판 화면 모드(예: Admin, cust). 권한/화면 제어에 사용.
			screenType: "${screenType}",
			BoardMgtID: "${BoardMgtID}",
			// url/boardTypeCD: boardList.do 내부에서 화면 템플릿 분기 시 사용되는 값.
			url: "${Url}",
			boardTypeCD: "${BoardTypeCD}"
		});
		loadBoardListByApi(params.toString());
	}

	// 게시판 그룹/메뉴 데이터를 조회하고 좌측 메뉴와 초기 선택 게시판을 구성한다.
	function loadBoardMenuData() {
		$('#loading').fadeIn(150);
		var grpParams = new URLSearchParams({
				languageID: "${sessionScope.loginInfo.sessionCurrLangType}",
				sessionCurrLangType: "${sessionScope.loginInfo.sessionCurrLangType}",
				projectID: "${projectID}",
				defBoardMgtID: "${defBoardMgtID}",
				BoardMgtID: "${BoardMgtID}",
				dueDateMgt: "${dueDateMgt}",
				// getData.do는 기본적으로 sqlID + GridList를 호출하므로
				// 원본 SQL 그대로 실행하려면 sqlGridList=N이 필요하다.
				sqlGridList: "N",
				sqlID: "board_SQL.boardGrpList"
		});
		var mgtParams = new URLSearchParams({
				languageID: "${sessionScope.loginInfo.sessionCurrLangType}",
				sessionCurrLangType: "${sessionScope.loginInfo.sessionCurrLangType}",
				projectID: "${projectID}",
				defBoardMgtID: "${defBoardMgtID}",
				BoardMgtID: "${BoardMgtID}",
				dueDateMgt: "${dueDateMgt}",
				sqlGridList: "N",
				sqlID: "board_SQL.boardMgtListNew"
		});
		var nameParams = new URLSearchParams({
				languageID: "${sessionScope.loginInfo.sessionCurrLangType}",
				sessionCurrLangType: "${sessionScope.loginInfo.sessionCurrLangType}",
				projectID: "${projectID}",
				defBoardMgtID: "${defBoardMgtID}",
				BoardMgtID: "${BoardMgtID}",
				sqlGridList: "N",
				sqlID: "board_SQL.getTemplName"
		});

		Promise.all([
			fetch("${getDataUrl}?" + grpParams.toString(), { method: "GET" }),
			fetch("${getDataUrl}?" + mgtParams.toString(), { method: "GET" }),
			fetch("${getDataUrl}?" + nameParams.toString(), { method: "GET" })
		]).then(function(responses){
			var grpRes = responses[0], mgtRes = responses[1], nameRes = responses[2];
			if (!grpRes.ok || !mgtRes.ok || !nameRes.ok) {
				throw new Error("getData.do 호출 실패");
			}
			return Promise.all([grpRes.json(), mgtRes.json(), nameRes.json()]);
		}).then(function(jsons){
			var grpJson = jsons[0], mgtJson = jsons[1], nameJson = jsons[2];
			boardGrpList = (grpJson && grpJson.success && Array.isArray(grpJson.data)) ? grpJson.data : [];
			boardMgtList = (mgtJson && mgtJson.success && Array.isArray(mgtJson.data)) ? mgtJson.data : [];
			if (boardGrpList.length === 0 || boardMgtList.length === 0) {
				console.warn("board menu data empty", grpJson, mgtJson);
			}

			var templName = "";
			if (nameJson && nameJson.success && nameJson.data) {
				if (Array.isArray(nameJson.data) && nameJson.data.length > 0) {
					templName = nameJson.data[0] || "";
				} else if (nameJson.data.TemplName) {
					templName = nameJson.data.TemplName;
				}
			}
			$("#templName").text(templName);
			renderBoardMenu();

			var reqBoardMgtID = "${reqBoardMgtID}";
			// reqBoardMgtID: 외부에서 특정 게시판으로 진입할 때 전달되는 초기 선택값.
			var selected = findSelectedBoard(reqBoardMgtID);
			if (!selected && boardMgtList.length > 0) {
				selected = boardMgtList[0];
			}
			if (!selected) {
				return;
			}

			var selectedGrp = findGroupNo(selected.ParentID);
			clickOpenClose(selectedGrp);
			// goDetailOpt:
			// Y = 팝업/외부에서 상세로 바로 진입
			// N(기본) = 목록 먼저 로드
			var goDetailOpt = "${goDetailOpt}";
			var boardID = "${BoardID}";
			var s_itemID = "${s_itemID}";
			var selectedMenuNo = selected.MenuNo || "2";
			clickSubMenu(selectedMenuNo);

			if (goDetailOpt == "Y" && boardID != "") {
				fnInitValues();
				$("#currUrl").val(selected.URL || "");
				if ((selected.URL || "") == "forumMgt") {
					var data = "boardMgtID=" + selected.BoardMgtID + "&BoardMgtID=" + selected.BoardMgtID + "&boardID=" + boardID + "&s_itemID=" + s_itemID + "&goDetailOpt=" + goDetailOpt;
					ajaxPage("forumMgt.do", data, "help_content");
				} else {
					goDetail("N", selected.BoardMgtID, boardID);
				}
			} else {
				setSubFrame(selected.BoardMgtID, selectedMenuNo, selected.URL, selected.BoardTypeCD);
			}
		}).catch(function(e){
			console.error(e);
		}).finally(function(){
			$('#loading').fadeOut(150);
		});
	}

	// 조회한 그룹/메뉴 데이터로 좌측 메뉴 트리를 그린다.
	function renderBoardMenu() {
		var menuHtml = "";
		var menuNo = 2;
		var menuNoArr = [];

		for (var g = 0; g < boardGrpList.length; g++) {
			var grp = boardGrpList[g];
			var grpNo = g + 1;
			menuHtml += '<li class="dynMenu helpstitle line plus' + grpNo + '"><a onclick="clickOpenClose(' + grpNo + ');"><img class="mgR5" src="${root}cmm/common/images/menu//sidebar_tap_close.png"><span class="fontchange">&nbsp;' + (grp.BoardGrpName || '') + '</span></a></li>';
			menuHtml += '<li style="display:none;" class="dynMenu helpstitle line minus' + grpNo + '"><a class="on" onclick="clickOpenClose(' + grpNo + ');"><img class="mgR5" src="${root}cmm/common/images/menu//sidebar_tap_open.png"><span class="fontchange">&nbsp;' + (grp.BoardGrpName || '') + '</span></a></li>';

			for (var i = 0; i < boardMgtList.length; i++) {
				var list = boardMgtList[i];
				if ((grp.BoardGrpID + "") == (list.ParentID + "")) {
					list.MenuNo = String(menuNo);
					menuNoArr.push(String(menuNo));
					var liClass = "hlepsub line smenu" + grpNo;
					menuHtml += '<li style="display:none;" class="dynMenu ' + liClass + '"><a id="menuCng' + menuNo + '" onclick="setSubFrame(\'' + (list.BoardMgtID || '') + '\',\'' + menuNo + '\',\'' + (list.URL || '') + '\',\'' + (list.BoardTypeCD || '') + '\');">&nbsp;' + (list.BoardMgtName || '') + '</a></li>';
					menuNo++;
				}
			}
		}
		menuIndex = menuNoArr.join(" ");
		$("#boardMenu").find(".dynMenu").remove();
		$("#boardMenu").append(menuHtml);
	}

	// 요청 파라미터의 BoardMgtID로 선택 게시판을 찾는다.
	function findSelectedBoard(reqBoardMgtID) {
		if (!reqBoardMgtID) return null;
		for (var i = 0; i < boardMgtList.length; i++) {
			if ((boardMgtList[i].BoardMgtID + "") == (reqBoardMgtID + "")) {
				return boardMgtList[i];
			}
		}
		return null;
	}

	// 선택 게시판의 상위 그룹 인덱스를 찾는다.
	function findGroupNo(parentID) {
		for (var i = 0; i < boardGrpList.length; i++) {
			if ((boardGrpList[i].BoardGrpID + "") == (parentID + "")) {
				return i + 1;
			}
		}
		return 1;
	}
	
	// [Menu] Click
	// BoardMgtID: 선택 게시판 관리 ID
	// avg: 메뉴 강조용 인덱스(menuCngN)
	// url/boardTypeCD: boardList.do 내부 분기용 파라미터
	function setSubFrame(BoardMgtID, avg, url, boardTypeCD) {
		clickSubMenu(avg);
		fnInitValues(); 
		$("#currUrl").val(url);
		$('#BoardMgtID').val(BoardMgtID);
		const params = new URLSearchParams({
			languageID: "${sessionScope.loginInfo.sessionCurrLangType}",
			screenType: "${screenType}",
			BoardMgtID: BoardMgtID || "",
			url: url || "",
			boardTypeCD: boardTypeCD || ""
		});
		loadBoardListByApi(params.toString());
	}
	// [set link color]
	function clickSubMenu(avg) {
		var realMenuIndex = menuIndex.split(' ');
		var menuName = "menuCng";
		for(var i = 0 ; i < realMenuIndex.length; i++){
			if (realMenuIndex[i] == avg) {
				$("#"+menuName+realMenuIndex[i]).addClass("on");
			} else {
				$("#"+menuName+realMenuIndex[i]).removeClass("on");
			}
		}
	}
	function fnInitValues(){
		$('#BoardMgtID').val("");
		$('#BoardID').val("");
	}

	function goList(isConfirm, screenType, projectID, category, categoryIndex, categoryCnt, back){
		if(isConfirm){if(confirm("${CM00003}")) fnChangeList(screenType,projectID,category,categoryIndex,categoryCnt,back);} else{fnChangeList(screenType,projectID,category,categoryIndex,categoryCnt,back);}
	}	

	// 현재 필터/페이징 조건으로 우측 리스트 영역을 다시 조회한다.
	function fnChangeList(screenType,projectID,category,categoryIndex,categoryCnt,back){
		removeSubFrame();
		const params = new URLSearchParams({
			BoardMgtID: $('#BoardMgtID').val() || "",
			pageNum: $("#currPage").val() || "1",
			url: $("#currUrl").val() || "",
			screenType: screenType || "",
			s_itemID: projectID || "",
			category: category || "",
			categoryIndex: categoryIndex || "",
			categoryCnt: categoryCnt || ""
		});
		if (back) {
			// back: 기존 코드에서 "&key=value..." 형태로 넘어오는 추가 파라미터 문자열.
			const backQuery = back.charAt(0) === "&" ? back.substring(1) : back;
			if (backQuery) {
				backQuery.split("&").forEach(function(pair){
					if (!pair) return;
					const eq = pair.indexOf("=");
					if (eq > -1) {
						params.append(pair.substring(0, eq), pair.substring(eq + 1));
					} else {
						params.append(pair, "");
					}
				});
			}
		}
		loadBoardListByApi(params.toString());
	}
	
	function goDetail(isNew,boardMgtID, boardID, boardUrl, currPage, screenType, projectID, category, categoryIndex, categoryCnt,back){ 
		removeSubFrame();
		var url = "boardDetailV4.do";
		var data = "NEW="+ encodeURIComponent(isNew)
				+"&BoardID="+ encodeURIComponent(boardID)
				+"&BoardMgtID="+ encodeURIComponent(boardMgtID)			
				+"&url="+ encodeURIComponent(boardUrl)
				+"&currPage="+currPage
				+"&screenType="+ encodeURIComponent(screenType)
				+"&projectID="+ encodeURIComponent(projectID)
				+"&category="+ encodeURIComponent(category)
				+"&categoryIndex="+ encodeURIComponent(categoryIndex)
				+back
				+"&categoryCnt="+ categoryCnt;
		var target = "help_content";
		ajaxPage(url, data, target);		
	}
	
	function removeSubFrame(){
		//$("#help_content").empty();
		//$("#help_content").remove();
	}
	
	// [+][-] button event
	function clickOpenClose(avg) { 
		if (  $(".plus"+ avg).css("display") != "none" || $(".smenu" + avg).css("display") == "none") {
			$(".smenu" + avg).css("display", "block");
			$(".plus" + avg).css("display", "none");
			$(".minus" + avg).css("display", "block");
			setOtherArea(avg); 
		} else {
			$(".smenu" + avg).css("display", "none");
			$(".plus" + avg).css("display", "block");
			$(".minus" + avg).css("display", "none");
		}
	}
	
	// 한 그룹을 열 때 나머지 그룹은 닫는다.
	function setOtherArea(avg) {
		var indexArray = menuIndex.split(' ');
		for(var i = 0 ; i < indexArray.length; i++){
			var index = i + 1;
			if(index != avg){
				$(".smenu" + index).css("display", "none");
				$(".plus" + index).css("display", "block");
				$(".minus" + index).css("display", "none");
			}
		}
	}
	
	// boardList.do HTML을 조회해 우측 영역에 주입한다.
	// queryString은 URLSearchParams.toString() 결과(인코딩 완료 문자열)여야 한다.
	function loadBoardListByApi(queryString){
		$('#loading').fadeIn(150);
		fetch("${boardListUrl}?" + queryString, {
				method: "GET",
				headers: { "Accept": "text/html" }
			}).then(function(response){
			if (!response.ok) {
				throw new Error("board list api error : " + response.status);
			}
			return response.text();
		}).then(function(html){
			$("#help_content").html(html);
		}).catch(function(error){
			console.error("[boardMainMenu] loadBoardListByApi error", error);
		}).finally(function(){
			$('#loading').fadeOut(150);
		});
	}

</script>
</head>
<style type="text/css">
	* html body { /*IE6 hack*/
		padding: 0 0 0 200px; /*Set value to (0 0 0 WidthOfFrameDiv)*/
	}
	
	* html #carcontent { /*IE6 hack*/
		width: 100%;
	}
	a{
		cursor:pointer;
	}
</style>

<body id="mainMenu">
	<form name="boardMainFrm" id="boardMainFrm"></form>
		<input type="hidden" id="BoardMgtID" name="BoardMgtID" value="${BoardMgtID}"></input>
		<input type="hidden" id="BoardID" name="BoardID" value=""/>
		<input type="hidden" id="currUrl" name="currUrl" value=""></input>			
		<div id="carframe">
			<div>
				<ul class="help_menu" id="boardMenu">
					 <li class="helptitle2" style="border-bottom:0;">&nbsp;<span id="templName"></span></li>
				</ul>
			</div>
		</div>
		<div id="carcontent">
			<div id="help_content" class="pdL10 pdR10"></div>
		</div>
</body>
</html>
