<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root" />
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/ui/dhtmlxJsInc.jsp"%>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>

<!-- 2. Script -->
<script type="text/javascript">
	var p_tree;
	
	$(document).ready(function() {
		initTree();
	});
	
	//===============================================================================
	// BEGIN ::: GRID
	function initTree(){
		var option ="AR000000";
		var data = "ItemTypeCode=${ItemTypeCode}&selectedTreeItemID=${selectedTreeItemID}";
		var d = fnSetMenuTreeData(data);
		p_tree = new dhtmlXTreeObject("treeArea", "100%", "100%", 0);	
		p_tree.setSkin('dhx_skyblue');
		p_tree.setImagePath("${root}cmm/js/dhtmlx/dhtmlxTree/codebase/imgs/csh_grayprocess/");
		p_tree.enableSmartXMLParsing(true);
		if ("${openMode}" == "assign" || "${openMode}" == "assignRefItem") {
			p_tree.enableCheckBoxes(true);	//CheckBox
		}
		p_tree.enableDragAndDrop(false);
		zdaelim_loadDhtmlxTreeJson(p_tree, d.key, d.cols, d.data, option);
		//p_tree.setOnLoadingEnd(fnEndLoadPopupTree);
		//fnEndLoadPopupTree();
		setTimeout(fnEndLoadPopupTree,2000); 	
	}
	
	function zdaelim_loadDhtmlxTreeJson(tree, key, cols, value, select, noMsg) {
		var msg = "${WM00018}";
		var data = "menuId="+key;
			data += "&cols=" + cols;
			data += "&SelectMenuId=" + select;
			data += "&" + value;
		try{if(key==null || key == ""){fnLog("ERROR fnLoadDhtmlxTreeJson() data: " + data);
		fnLog("ERROR fnLoadDhtmlxTreeJson() callstack : " + showCallStack());}} catch(e) {}
		ajaxTreeLoad("<c:url value='/zdaelim_jsonDhtmlxTreeList.do'/>", data, tree, false, noMsg, msg);
	}
	
	function fnSelectItem(){ 
		p_tree.selectItem("${s_itemID}",true,false);
	}
	var StartDate;
	function fnEndLoadPopupTree(id){
		//StartDate = new Date();
	 	//var allItems = p_tree.getAllFatItems();		
		var url = "zdaelim_checkDuplicatedItem.do";		
		var data = "s_itemID=${selectedTreeItemID}&varFilter=${varFilter}&connectionType=${connectionType}";
		var target="blankFrame";
		ajaxPage(url, data, target); 
	}
	
	function fnSetDisableCheckBoxIDs(tmp){ 	
		var ids = tmp.split(",");
		for(var i=0; i<ids.length; i++){ 
			p_tree.disableCheckbox(ids[i],true);
		}
		$('#popupDiv').show();
		/* var StopDate = new Date();
		var Diff = StopDate.getTime() - StartDate.getTime();
		Diff = Diff/1000;			
		alert("tree : " +Diff + "초"); */	 
	}
	
	// [Assign][Add] click
	function assignItem(){
		if ("${option}" == "AR050110") {
			if(p_tree.getSelectedItemId() == ""){
				alert("${WM00023}");
				return false;
			}
			fnCheckCngItem(p_tree.getSelectedItemId());
		} else {
			if ("${openMode}" == "assign") {
				if(p_tree.getAllChecked() == ""){
					alert("${WM00023}");
					return false;
				}
				fnCheckExistItem(p_tree.getAllChecked());
			}else if ("${openMode}" == "assignRefItem") {
				if(p_tree.getAllChecked() == ""){
					alert("${WM00023}");
					return false;
				}
				fnUpdateRefItemID(p_tree.getAllChecked());
			} else {
				if(p_tree.getSelectedItemId() == ""){
					alert("${WM00023}");
					return false;
				}
				fnGetItemPath(p_tree.getSelectedItemId());
			}
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
	function fnReturn(avg){
		if ("${option}" == "AR050110") {
			setSelectedItem(avg);
		} else {
			if ("${openMode}" == "assign" || "${openMode}" == "assignRefItem") {
				setCheckedItems(avg);
			} else {
				setParentItem(p_tree.getSelectedItemId(), avg);
			}
		}
	}
	
	function fnSearchTreeText(type){
		var schText = $("#schTreeMenuText").val();
		//1:검색, 2:다음, 3:이전
		if(type == "1")p_tree.findItem(schText,0,1);
		else if(type == "2") p_tree.findItem(schText);
		else if(type == "3") p_tree.findItem(schText,1);	
	}
	
	function fnUpdateRefItemID(ids){
		var url = "updateRefItem.do";		
		var data = "ids="+ids+"&s_itemID=${s_itemID}&varFilter=${varFilter}&connectionType=${connectionType}";
		var target="blankFrame";
		ajaxPage(url, data, target);
	}
	
</script>
<input type="hidden" id="option" name="option" value="${option}">
<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
<div class="popup01">
<ul>
  <li class="top_zone popup_title"><img src="${root}${HTML_IMG_DIR}/popup_box2_.png" /></li>
  <li class="con_zone">
	<div class="title popup_title"><span class="pdL10"> Search</span>
		<div class="floatR mgR20">
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
			<div id="treeArea" style="width:100%;height:305px;background-color:#f9f9f9;border :1px solid Silver;overflow:auto;"></div>  		
		</div>
	</div>
	</li>
	</ul>
</div>
<div class="bot_zone">
	<img src="${root}${HTML_IMG_DIR}/popup_box6_.png">
</div>
<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>
