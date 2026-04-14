<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root" />
<%-- <%@ include file="/WEB-INF/jsp/cmm/ui/dhtmlxJsInc.jsp"%> --%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00045" var="WM00045"/>

<!-- 2. Script -->
<script type="text/javascript">
	var p_tree;
	var treeCheckbox = false;
	
	// 	$(document).ready(function() {
		initTree();
		if("${searchValue}" != ""){			
			$("#schTreeMenuText").val("${searchValue}");
		}
// 	});
	
	//===============================================================================
	// BEGIN ::: GRID
	function initTree(){
		var option ="${option}";
		var data = "ItemTypeCode=${ItemTypeCode}&rootItemID=${rootItemID}&tFilterCode=${tFilterCode}&hiddenClassList=${hiddenClassList}";		
		var d = fnSetMenuTreeData(data);
		if ("${openMode}" == "assign" || "${openMode}" == "assignRefItem") {
			treeCheckbox = true;
		}
		
		p_tree = new dhx.Tree("treeArea", {
			checkbox: treeCheckbox,
			selection: true,
			itemHeight: 30
		});
		
		setTreeData("menuId="+d.key+"&SelectMenuId="+option+"&"+d.data+"&cols="+d.cols);

// 		setTimeout(fnSelectItem,1000);
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
				p_tree.data.parse(result.data);
				
		 		if("${searchValue}" != ""){
		 			fnSearchTreeText("1");
		 		}
			} else {
				return;
			}
		} catch (error) {
			handleAjaxError(error);
		} finally {
			$('#loading').fadeOut(100);
		}
	}
	
	// [Assign][Add] click
	function assignItem(){
		if ("${openMode}" == "assign") {
			if(p_tree.getChecked() == ""){
				alert("${WM00023}");
				return false;
			}
			fnCheckExistItem(p_tree.getChecked());
		}else if ("${openMode}" == "assignRefItem") {
			if(p_tree.getChecked() == ""){
				alert("${WM00023}");
				return false;
			}
			fnUpdateRefItemID(p_tree.getChecked());
		} else if ("${openMode}" == "assignParentItem") {

			if(p_tree._focusId == ""){
				alert("${WM00023}");
				return false;
			}
			fnGetItemPath(p_tree._focusId);
		} else if ("${openMode}" == "assignWText") {
			if(p_tree._focusId == ""){
				alert("${WM00023}");
				return false;
			}
			fnReturn(p_tree._focusId,p_tree.getSelectedItemText());
		} else {
			if(p_tree._focusId == ""){
				alert("${WM00023}");
				return false;
			}
			fnGetItemPath(p_tree._focusId);
		}
	}
	
	function fnGetItemPath(id){
		var url = "getPathWithItemId.do";		
		var data = "s_itemID="+id;
		var target="blankFrame";
		ajaxPage(url, data, target);
	}
	function fnCheckExistItem(ids){		
		var url = "checkExistItem.do";	
		if('${strType}' == '2') url = "checkExistStrItem.do";
		var data = "ids="+ids+"&s_itemID=${s_itemID}&varFilter=${varFilter}&connectionType=${connectionType}";
		var target="blankFrame";
		ajaxPage(url, data, target);
	}
	function fnCheckCngItem(id){
		var url = "checkChangeItem.do";		
		var data = "projectID=${projectID}&s_itemID="+id;
		var target="blankFrame";
		ajaxPage(url, data, target);
	}
	function fnReturn(avg,avg2){
		
		if ("${openMode}" == "assign" || "${openMode}" == "assignRefItem") {
			setCheckedItems(avg);
		} else if("${openMode}" == "assignWText"){
			setCheckedItems(avg,avg2);
		} else {
			setParentItem(p_tree._focusId, avg);
		}
		
	}
	
	let searchItem = [];
  	let oldText = "";
  	let currentIndex = 0;
  	
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
	
	function fnUpdateRefItemID(ids){
		var url = "updateRefItem.do";		
		var data = "ids="+ids+"&s_itemID=${s_itemID}&varFilter=${varFilter}&connectionType=${connectionType}";
		var target="blankFrame";
		ajaxPage(url, data, target);
	}

	function fnUpdateRefItemID(ids){
		setParentItem(ids);
	}
	
	function fnGetParentItemID(ids) {
		setParentItemInfo(ids);
	}
	
// 	function fnOnCheck(id,state){
// 		if(document.all("IncludeSubitems").checked == true ){
// 			if(state == 1){
// 				p_tree.setSubChecked(id,true);
// 			}else{
// 				p_tree.setSubChecked(id,false);
// 			}
// 		}
// 	}

	p_tree.events.on("afterCheck", function (index, id, value) {
	    if(!document.querySelector("#IncludeSubitems").checked) {
	    	p_tree.data.eachChild(id, e => 
			        p_tree.setState({
		    			[e.id] : {
		    	            "selected" : 0
		    	        }
		    	    })
			)
	    }
	});
	
	function fnSetUnfoldTree(){if(p_tree!=null){p_tree.closeAllItems(0);var ch = p_tree.hasChildren(0);for(var i=0; i<ch; i++){var lev1 = p_tree.getChildItemIdByIndex(0,i);p_tree.openItem(lev1);}}}
	
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
<!--   			<div class="floatL mgT5 mgB5">   -->
<%--   				<c:if test="${openMode eq 'assign' || openMode eq assignRefItem}" >					 --%>
<!--      			<input type="checkbox" id="IncludeSubitems" />&nbsp;&nbsp;Include sub items&nbsp;  -->
<%--      			</c:if> --%>
<!--      		</div>	 -->
<!--      		<div class="alignR mgT5 mgB5">     					 -->
<!-- 	     		<input type="text" class="text" id="schTreeMenuText" style="width:150px;ime-mode:active;"/> -->
<%-- 	     		<a onclick="fnSearchTreeText('1')"><img src="${root}${HTML_IMG_DIR}/btn_icon_search.png"></a> --%>
<%-- 	     		<a onclick="fnSearchTreeText('3')"><img src="${root}${HTML_IMG_DIR}/btn_previous.png"></a> | <a onclick="fnSearchTreeText('2')"> <img src="${root}${HTML_IMG_DIR}/btn_next.png"> </a> --%>
<%--      			<span class="btn_pack small icon"><span class="${btnStyle}"></span><input value="${btnName}" type="submit" onclick="assignItem();"></span> &nbsp;    --%>
<!--      		</div>	 -->
	    	<div class="btn-wrap mgB10">
				<div>
					<c:if test="${openMode eq 'assign' || openMode eq assignRefItem}" >					
	     				<input type="checkbox" id="IncludeSubitems" />&nbsp;&nbsp;Include sub items&nbsp; 
	     			</c:if>
		     		<input type="text" class="text" id="schTreeMenuText" style="width:150px;ime-mode:active;"/>
		     		<a onclick="fnSearchTreeText('1')"><img src="${root}${HTML_IMG_DIR}/btn_icon_search.png"></a>
	     			<a onclick="fnSearchTreeText('3')"><img src="${root}${HTML_IMG_DIR}/btn_previous.png"></a> | <a onclick="fnSearchTreeText('2')"> <img src="${root}${HTML_IMG_DIR}/btn_next.png"> </a>
				</div>
				<div class="btns">
					<button onclick="assignItem()" class="primary">${btnName}</button>
				</div>
			</div>
			<div id="treeArea" style="width:100%;height:calc(100% - 50px);background-color:#f9f9f9;border :1px solid Silver;overflow:auto;"></div>  		
<!-- 		</div> -->
<!-- 	</div> -->
<!-- 	</li> -->
<!-- 	</ul> -->
<!-- </div> -->
<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>
