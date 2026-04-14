<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root" />
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/ui/dhtmlxJsInc.jsp"%>
<!-- 2. Script -->
<script type="text/javascript">
	var p_tree;
	$(document).ready(function() {
		initTree();
		var unfold ="${unfold}";
		if(unfold != "false" || unfold == ''){	setTimeout(function() {fnSetUnfoldTree();}, 1000);}
	});	
	//===============================================================================
	
	// BEGIN ::: GRID
	function initTree(){
		var d = fnSetMenuTreeData();
		p_tree = new dhtmlXTreeObject("treeArea", "100%", "100%", 0);		 
		p_tree.setSkin('dhx_skyblue');
		//p_tree.setImagePath("${root}cmm/js/dhtmlxTree/codebase/imgs/"+treeInfo.imgPath+"/");
		p_tree.setImagePath("${root}cmm/js/dhtmlxTree/codebase/imgs/csh_bluebooks/");
		p_tree.enableSmartXMLParsing(true);
		p_tree.enableCheckBoxes(true);	//CheckBox
		//p_tree.enableRadioButtons(true);	//Radion Button
		p_tree.enableDragAndDrop(false);
		//p_tree.enableThreeStateCheckboxes(true);	
		//'AR010101' <== Opition 값 : ArcCode
		fnLoadDhtmlxTreeJson(p_tree, d.key, d.cols, d.data, "AR010101");
		/*
		eval('var treeData='+treeInfo.data); 
		p_tree.loadJSONObject(treeData);
		*/
		p_tree.setOnCheckHandler(fnCheckedTree);
		p_tree.setOnLoadingEnd(fnEndLoadPopupTree);
	}
	function fnCheckedTree(id, state){//alert("Check Item ID: " + id+", State:"+state);
	}
	function fnEndLoadPopupTree(){
		//p_tree.disableCheckbox("${s_itemID}",false);
		//p_tree.enableRadioButtons("${s_itemID}",false);
	}
	function processAdd(){
		//alert('Selected items : '+p_tree.getSelectedItemId());
		//fnMoveItems(p_tree.getSelectedItemId());
		var items =p_tree.getAllChecked();

		//alert(items);
		addItem(items);
		
		if (window.dhtmlx) {
	        for (const key in window.dhtmlx) {
	            delete window.dhtmlx[key];
	        }
	        delete window.dhtmlx;
	    }

	    if (window.dhx) {
	        delete window.dhx;
	    }
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
     			<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="processAdd()" ></span>	
     		</div>	
		    <div id="treeArea" style="width:100%;height:325px;background-color:#f9f9f9;border :1px solid Silver;overflow:auto;"></div>
  		</div>
	</div>
	</li>
	</ul>
</div>