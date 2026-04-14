<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root" />
<%-- <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%> --%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00045" var="WM00045"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>

<!-- 2. Script -->
<script type="text/javascript">
	var p_tree;
	var assignedDimValues = "${dimValues}".split(",");
	
	initTree();
	
	//===============================================================================
	// 트리 정의
	function initTree(){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemTypeCode=${itemTypeCode}&tFilterCode=DIM";		
		var d = fnSetMenuTreeData(data);
		d.cols += "|DimTypeID";
		
		p_tree = new dhx.Tree("treeArea", {
			checkbox: true,
			selection: true,
			itemHeight: 30
		});
		
		setTreeData("menuId="+d.key+"&SelectMenuId="+option+"&"+d.data+"&cols="+d.cols);
	}

	// 트리 데이터 불러오는 함수
	async function setTreeData(queryData){
		$('#loading').fadeIn(100);
		const url = "jsonDhtmlxTreeListData.do?"+new URLSearchParams(queryData).toString();
	    try {
			const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message);
			}
	
			const result = await response.json();
			// success 필드 체크
			if (!result.success) {
				throw throwServerError(result.message);
			}
	
			if (result && result.data) {
				// string으로 넘어오는 parent 값들 number 형태로 바꾸고 tree 데이터로 파싱하기
				// 이미 선택된 아이템은 체크박스 삭제			
				p_tree.data.parse(
					result.data.map(e => {
				        if (assignedDimValues.includes(e.id)) return { ...e, parent: Number(e.parent), checkbox: false };
				        else return { ...e, parent: Number(e.parent) };
					})
				)
			} else {
				return;
			}
		} catch (error) {
			handleAjaxError(error);
		} finally {
			$('#loading').fadeOut(100);
		}
	}

	function fnSetDisableCheckBoxIDs(tmp) {
		if (!tmp || !p_tree) return;

		var disabledList = tmp.split(",").map(function(item) { return item.trim(); });

		for (var i = 0; i < disabledList.length; i++) {
			var targetId = disabledList[i];
			if (targetId && p_tree.getItemText(targetId) !== null) {
				p_tree.disableCheckbox(targetId, true);
			}
		}

		var allItemsStr = p_tree.getAllSubItems(0);
		if (!allItemsStr) return;

		var allIds = allItemsStr.split(",");
		allIds.reverse();

		for (var j = 0; j < allIds.length; j++) {
			var id = allIds[j];

			if (p_tree.hasChildren(id) > 0) {
				var subItemsStr = p_tree.getSubItems(id);
				if (!subItemsStr) continue;

				var subItems = subItemsStr.split(",");
				var isAllChildDisabled = true;

				for (var k = 0; k < subItems.length; k++) {
					var childId = subItems[k];
					if (disabledList.indexOf(childId) === -1) {
						isAllChildDisabled = false;
						break;
					}
				}

				if (isAllChildDisabled) {
					p_tree.disableCheckbox(id, true);
					if (disabledList.indexOf(id) === -1) {
						disabledList.push(id);
					}
				}
			}
		}
	}
	
	// [Assign][Add] click
	async function assignItem(){
		var checkedIds = p_tree.getChecked();

		var finalIds = checkedIds.filter(function(id) {
			return !assignedDimValues.includes(String(id));
		});

		if(p_tree.getChecked().length == 0){
// 			alert("${WM00023}");
			const [btn] = await Promise.all([
				getDicData("BTN", "LN0034")    // 닫기 버튼
			]);
			showDhxAlert("${WM00045}", btn.LABEL_NM);
			return false;
		}

		if(confirm("${CM00012}")){
			var url = "addDimensionForItem.do";
			var data = "s_itemID=${s_itemID}&ids="+finalIds.join(",");
			var target = "blankFrame";
			ajaxPage(url, data, target);
// 			$(".popup_div").hide();
// 			$("#mask").hide();
		}
	}
	
  	let searchItem = [];
  	let oldText = "";
  	let currentIndex = 0;
  	
  //트리 메뉴에서 '이전', '다음' 검색
  	function fnSearchTreeText(type){
  		var schText=$("#schTreeMenuText").val();
  		if(schText==""){alert("${WM00045}"); return false;}

		if(type == "1") search()
		else if(type == "2") focusNext()
		else if(type == "3") focusPrev()
		
  		oldText = schText;
  	}
  
  	const searchState = {
  			matches: [],
  			index: -1,
  			lastQuery: ""
  		};

  		function normalizeText(text) {
  			return String(text ?? "").trim().toLowerCase();
  		}

  		function clearSearch() {
  			searchState.matches = [];
  			searchState.index = -1;
  			searchState.lastQuery = "";
  		}

  		function activateMatch(id) {
  			if (!id) return;
  			p_tree.selection.add(id);
  			p_tree.focusItem(id);
  		}

  		function searchText() {
  			const input = document.querySelector("#schTreeMenuText");
  			if (!input) return;

  			const query = normalizeText(input.value);
  			if (!query) return;

  			clearSearch();

  			const matches = [];
  			p_tree.data.forEach((item) => {
  				const label = normalizeText(item.value);
  				if (label.includes(query)) {
  					matches.push(item.id);
  				}
  			});

  			searchState.matches = matches;
  			searchState.index = -1;
  			searchState.lastQuery = query;
  		}

  		function ensureSearch() {
  			const input = document.querySelector("#schTreeMenuText");
  			
  			if (!input) return;

  			const query = normalizeText(input.value);
  			if (!query) return;

  			if (
  				searchState.lastQuery !== query ||
  				!searchState.matches.length
  			) {
  				searchText();
  			}
  		}

  		function search() {
  			ensureSearch();
  			if (!searchState.matches.length) return;

  			if (searchState.index === -1) {
  				searchState.index = 0;
  			}

  			activateMatch(searchState.matches[0]);
  		}

  		function focusNext() {
  			ensureSearch();
  			if (!searchState.matches.length) return;

  			if (searchState.index === -1) {
  				searchState.index = 0;
  			} else {
  				searchState.index =
  					(searchState.index + 1) % searchState.matches.length;
  			}

  			activateMatch(searchState.matches[searchState.index]);
  		}


  		function focusPrev() {
  			ensureSearch();
  			if (!searchState.matches.length) return;

  			if (searchState.index === -1) {
  				searchState.index = 0;
  			} else {
  				searchState.index =
  					(searchState.index - 1 + searchState.matches.length) %
  					searchState.matches.length;
  			}

  			activateMatch(searchState.matches[searchState.index]);
  		}
	
	/**
	 * @function handleAjaxError
	 * @description 데이터 로드 실패 시 에러 메시지 팝업 출력
	 * @param {Error} err - 발생한 에러 객체
	*/
	function handleAjaxError(err) {
		console.error(err);
		Promise.all([getDicData("ERRTP", "LN0014"), getDicData("BTN", "LN0034")])
				.then(([errDic, btnDic]) => showDhxAlert(errDic.LABEL_NM, btnDic.LABEL_NM));
	}
</script>
<input type="hidden" id="option" name="option" value="${option}">
<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">


<!-- <div class="popup01"> -->
<!-- <ul> -->
<!--   <li class="con_zone"> -->
<!-- 	<div class="title popup_title"><span class="pdL10"> Search</span> -->
<!-- 		<div class="floatR mgR10"> -->
<%-- 			<img class="popup_closeBtn" id="popup_close_btn" src='${root}${HTML_IMG_DIR}/btn_close1.png' title="close"> --%>
<!-- 		</div> -->
<!-- 	</div>  -->
<!-- 	<div class="szone"> -->
<!--   		<div class="con01 mgL10"> -->
<!--      		<div class="alignR mgT5 mgB5"> -->
<!--      			검색  -->

<!-- 	     		Assign Button  -->
<%--      			<span class="btn_pack small icon"><span class="${btnStyle}"></span><input value="${btnName}" type="submit" onclick="assignItem();"></span> --%>
     			
<!--      		</div>	 -->
     		<div class="btn-wrap mgB10">
				<div>
		     		<input type="text" class="text" id="schTreeMenuText" style="width:150px;ime-mode:active;"/>
		     		<a onclick="fnSearchTreeText('1')"><img src="${root}${HTML_IMG_DIR}/btn_icon_search.png"></a>
		     		<a onclick="fnSearchTreeText('3')"><img src="${root}${HTML_IMG_DIR}/btn_previous.png"></a> | <a onclick="fnSearchTreeText('2')"> <img src="${root}${HTML_IMG_DIR}/btn_next.png"> </a>
				</div>
				<div class="btns">
					<button onclick="assignItem()" class="primary">${btnName}</button>
				</div>
			</div>
			<div id="treeArea" style="width:100%;height:calc(100% - 50px);background-color:#f9f9f9;border :1px solid #ccc;overflow:auto;"></div>  		
<!-- 		</div> -->
<!-- 	</div> -->
<!-- 	</li> -->
<!-- 	</ul> -->
<!-- </div> -->
<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>
