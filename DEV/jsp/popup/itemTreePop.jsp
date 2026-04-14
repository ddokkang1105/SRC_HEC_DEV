<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root" />
<%-- <%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%> --%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00047" var="WM00047"/>
<script type="text/javascript">
	var p_tree;
	
	var checkType = false;
	
	$(document).ready(function() {
		initTree();
// 		var unfold ="${unfold}";
// 		if(unfold != "false" || unfold == ''){	setTimeout(function() {fnSetUnfoldTree();}, 1000);}
		//checkbox 확인
		if('${checkType}' == 'check'){
			checkType = true;
		}		
	});
	
	// 트리 정의
	function initTree(){
		console.log("initTree")
		var option = $("#option").val();
		var d = fnSetMenuTreeData();
// 		p_tree = new dhtmlXTreeObject("treeArea", "100%", "100%", 0);	
// 		p_tree.setSkin('dhx_skyblue');
// 		//p_tree.setImagePath("${root}cmm/js/dhtmlx/dhtmlxTree/codebase/imgs/"+treeInfo.imgPath+"/");
// 		p_tree.setImagePath("${root}cmm/js/dhtmlx/dhtmlxTree/codebase/imgs/csh_process/");
// 		p_tree.enableSmartXMLParsing(true);
// 		//p_tree.enableCheckBoxes(true);	//CheckBox
// 		//p_tree.enableRadioButtons(true);	//Radion Button
// 		p_tree.enableDragAndDrop(false);
// 		//p_tree.enableThreeStateCheckboxes(true);	
// 		//'AR010101' <== Opition 값 : ArcCode
// 		fnLoadDhtmlxTreeJson(p_tree, d.key, d.cols, d.data, option);
// 		p_tree.setOnLoadingEnd(fnEndLoadPopupTree);
		
// 		setTimeout(fnSelectItem,1000); 
			
		p_tree = new dhx.Tree("treeArea", {
// 			icon: {
// 				folder: icon_set[treeImgPath].folder,
// 				openFolder: icon_set[treeImgPath].openFolder,
// 				file: icon_set[treeImgPath].file
// 			},
			selection: true,
			itemHeight: 30,
			data: []
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
				p_tree.data.parse(result.data);
				fnSelectItem();
			} else {
				return;
			}
	
		} catch (error) {
			handleAjaxError(error);
		} finally {
			$('#loading').fadeOut(100);
		}
	}
	
	// 현재 item 선택하여 표시하는 함수
	function fnSelectItem(){
		p_tree.focusItem("${s_itemID}");
		p_tree.selection.add("${s_itemID}");
		p_tree.data.eachParent("${s_itemID}", e => p_tree.expand(e.id))
	}

	function fnCheckedTree(id){
		var url = "checkAuthor.do";		
		var data = "userType=${sessionScope.loginInfo.sessionMlvl}&userId=${sessionScope.loginInfo.sessionUserId}&s_itemID="+id;
		var target="blankFrame";
		ajaxPage(url, data, target);
	}
	
	function fnReturnCheck(isCheck){
// 		fnMoveItems(p_tree.getSelectedItemId(), isCheck);
		fnMoveItems(p_tree._focusId, isCheck);
	}
	function fnEndLoadPopupTree(){
		p_tree.disableCheckbox("${s_itemID}",true);
		//p_tree.enableRadioButtons("${s_itemID}",false);
	}
	function processMOVE(){
		if(!p_tree._focusId){
			alert("${WM00047}");
			return false;
		}
		fnCheckedTree(p_tree._focusId);
				
		//if(checkType){
			//p_tree.getSelectedItemId()
		//}
		//변경요청할 화면 표시 및 선택된 tree아이템 값을 넘겨줌
		//testLayer("${items}","MOD", p_tree.getSelectedItemId());
		//goInsertChangeSet("${items}","MOD", p_tree.getSelectedItemId());
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
<!--      			<span class="btn_pack small icon"><span class="move"></span><input value="Move" type="submit" onclick="processMOVE()" ></span>	 -->
<!--      		</div>	 -->
			<div class="btn-wrap mgB10">
				<div></div>
				<div class="btns">
					<button onclick="processMOVE()" class="primary">Move</button>
				</div>
			</div>
			<div id="treeArea" style="width:100%;height:calc(100% - 50px);background-color:#f9f9f9;border :1px solid #ccc;overflow:auto;"></div>
<!-- 		</div> -->
<!-- 	</div> -->
<!-- 	</li> -->
<!-- 	</ul> -->
<!-- </div> -->
<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>
