<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root" />
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/ui/dhtmlxJsInc.jsp"%>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>

<!-- 2. Script -->
<script type="text/javascript">
	var p_tree;
	var dimValues = "${dimValues}";
	
	$(document).ready(function() {
		initTree();
		setTimeout(function() {fnSetDisableCheckBoxIDs(dimValues);}, 100);
	});
	
	//===============================================================================
	// BEGIN ::: GRID
	function initTree(){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemTypeCode=${itemTypeCode}&tFilterCode=DIM";		
		var d = fnSetMenuTreeData(data);
		p_tree = new dhtmlXTreeObject("treeArea", "100%", "100%", 0);

		p_tree.attachEvent("onXLE", function(){
			fnSetDisableCheckBoxIDs(dimValues);
		});

		p_tree.setSkin('dhx_skyblue');
		p_tree.setImagePath("${root}cmm/js/dhtmlx/dhtmlxTree/codebase/imgs/csh_process/");
		p_tree.enableSmartXMLParsing(true);
		p_tree.enableCheckBoxes(true);	//CheckBox

		p_tree.enableThreeStateCheckboxes(false);
		p_tree.enableDragAndDrop(false);

		p_tree.attachEvent("onCheck", function(id, state){
			fnCheckChildren(id, state);
			fnCheckParent(id);
		});

		d.cols += "|DimTypeID";			
		
		fnLoadDhtmlxTreeJson(p_tree, d.key, d.cols, d.data, "");
		
	}

	/**
	 * @function fnCheckChildren
	 * @description 상위 노드 체크 시 하위 모든 노드에 상태를 전달
	 */
	function fnCheckChildren(id, state) {
		var subIds = p_tree.getAllSubItems(id);
		if(subIds) {
			var arr = subIds.split(",");
			for(var i=0; i<arr.length; i++) {
				p_tree.setCheck(arr[i], state);
			}
		}
	}

	/**
	 * @function fnCheckParent
	 * @description 하위 노드 체크 해제 시 상위 노드도 해제
	 */
	function fnCheckParent(id) {
		var parentId = p_tree.getParentId(id);
		// 최상위 노드가 아닐 때까지 반복
		if(parentId != 0 && parentId != null) {
			var subIds = p_tree.getSubItems(parentId).split(",");
			var allChecked = true;

			for(var i=0; i<subIds.length; i++) {
				if(p_tree.isItemChecked(subIds[i]) == 0) {
					allChecked = false;
					break;
				}
			}

			p_tree.setCheck(parentId, allChecked ? 1 : 0);

			fnCheckParent(parentId);
		}
	}


	// function fnSetDisableCheckBoxIDs(tmp){
	// 	if(!tmp) return;
	// 	var ids = tmp.split(",");
	// 	for(var i=0; i<ids.length; i++){
	// 		var targetId = ids[i].trim();
	// 		if(p_tree.getItemText(targetId) !== null) {
	// 			p_tree.disableCheckbox(targetId, true);
	// 		}
	// 	}
	// }

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
	function assignItem(){		
		if(p_tree.getAllChecked() == ""){
			alert("${WM00023}");
			return false;
		}

		if(confirm("${CM00012}")){
			addDimension(p_tree.getAllChecked());
		}
	}

	//트리 메뉴에서 '이전', '다음' 검색
	function fnSearchTreeText(type){
		//1:검색, 2:다음, 3:이전
		if(type == "1") p_tree.findItem(document.getElementById('schTreeMenuText').value,0,1);
		else if(type == "2") p_tree.findItem(document.getElementById('schTreeMenuText').value);
		else if(type == "3") p_tree.findItem(document.getElementById('schTreeMenuText').value,1);		
	}	
	// [Add] Click
	function addDimension(ids) {
		var url = "addDimensionForItem.do";
		var data = "s_itemID=${s_itemID}&ids="+ids;		
		var target = "blankFrame";
		ajaxPage(url, data, target);
		$(".popup_div").hide();
		$("#mask").hide();
	}
	
</script>
<input type="hidden" id="option" name="option" value="${option}">
<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">


<div class="popup01">
<ul>
  <li class="con_zone">
	<div class="title popup_title"><span class="pdL10"> Search</span>
		<div class="floatR mgR10">
			<img class="popup_closeBtn" id="popup_close_btn" src='${root}${HTML_IMG_DIR}/btn_close1.png' title="close">
		</div>
	</div> 
	<div class="szone">
  		<div class="con01 mgL10">
     		<div class="alignR mgT5 mgB5">
     			<!-- 검색  -->
	     		<input type="text" class="text" id="schTreeMenuText" style="width:150px;ime-mode:active;"/>
	     		<a onclick="fnSearchTreeText('1')"><img src="${root}${HTML_IMG_DIR}/btn_icon_search.png"></a>
	     		<a onclick="fnSearchTreeText('3')"><img src="${root}${HTML_IMG_DIR}/btn_previous.png"></a> | <a onclick="fnSearchTreeText('2')"> <img src="${root}${HTML_IMG_DIR}/btn_next.png"> </a>
	     		<!-- Assign Button  -->
     			<span class="btn_pack small icon"><span class="${btnStyle}"></span><input value="${btnName}" type="submit" onclick="assignItem();"></span>
     			
     		</div>	
			<div id="treeArea" style="width:100%;height:325px;background-color:#f9f9f9;border :1px solid Silver;overflow:auto;"></div>  		
		</div>
	</div>
	</li>
	</ul>
</div>
<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>
