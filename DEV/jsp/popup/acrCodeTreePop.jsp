<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root" />
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/ui/dhtmlxJsInc.jsp"%>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00047" var="WM00047"/>
<script type="text/javascript">
	var p_tree;
	
	var checkType = false;
	
	$(document).ready(function() {
		initTree();
// 		var unfold ="${unfold}";
// 		if(unfold != "false" || unfold == ''){	setTimeout(function() {fnSetUnfoldTree();}, 1000);}
		//checkbox íì¸
		if('${checkType}' == 'check'){
			checkType = true;
		}		
	});	
	//===============================================================================
	// BEGIN ::: GRID
	
	function initTree_OLD(){
		var treeInfo = parent.fnCallTreeInfo();
		p_tree = new dhtmlXTreeObject("treeArea", "100%", "100%", 0);		 
		p_tree.setSkin('dhx_skyblue');
		p_tree.setImagePath("${root}cmm/js/dhtmlx/dhtmlxTree/codebase/imgs/"+treeInfo.imgPath+"/");
		//p_tree.setImagePath("${root}cmm/js/dhtmlxTree/codebase/imgs/csh_bluebooks/");
		p_tree.enableSmartXMLParsing(true);
		//p_tree.enableCheckBoxes(true);	//CheckBox
		//p_tree.enableRadioButtons(true);	//Radion Button
		p_tree.enableDragAndDrop(false);
		//p_tree.enableThreeStateCheckboxes(true);
		eval('var treeData='+treeInfo.data); 
		p_tree.loadJSONObject(treeData);
		//p_tree.setOnCheckHandler(fnCheckedTree);
		p_tree.setOnLoadingEnd(fnEndLoadPopupTree);
	}
	
	// BEGIN ::: GRID
	function initTree(){
		var option = $("#option").val();
		var d = fnSetMenuTreeData();
		p_tree = new dhtmlXTreeObject("treeArea", "100%", "100%", 0);	
		p_tree.setSkin('dhx_skyblue');
		//p_tree.setImagePath("${root}cmm/js/dhtmlx/dhtmlxTree/codebase/imgs/"+treeInfo.imgPath+"/");
		p_tree.setImagePath("${root}cmm/js/dhtmlx/dhtmlxTree/codebase/imgs/csh_process/");
		p_tree.enableSmartXMLParsing(true);
		//p_tree.enableCheckBoxes(true);	//CheckBox
		//p_tree.enableRadioButtons(true);	//Radion Button
		p_tree.enableDragAndDrop(false);
		//p_tree.enableThreeStateCheckboxes(true);	
		//'AR010101' <== Opition ê° : ArcCode
		fnLoadDhtmlxTreeJson(p_tree, d.key, d.cols, d.data, option);
		p_tree.setOnLoadingEnd(fnEndLoadPopupTree);
		
		setTimeout(fnSelectItem,1000); 
			
	}
	
	function fnSelectItem(){
		p_tree.selectItem("${s_itemID}",true,false);
	}

	function fnCheckedTree(id){
		var url = "checkAuthor.do";		
		var data = "userType=${sessionScope.loginInfo.sessionMlvl}&userId=${sessionScope.loginInfo.sessionUserId}&s_itemID="+id;
		var target="blankFrame";
		ajaxPage(url, data, target);
	}
	function fnReturnCheck(isCheck){
		fnMoveItems(p_tree.getSelectedItemId(), isCheck);
	}
	function fnEndLoadPopupTree(){
		p_tree.disableCheckbox("${s_itemID}",true);
		//p_tree.enableRadioButtons("${s_itemID}",false);
	}
	function processMOVE(){
		if(p_tree.getSelectedItemId() == "" ){
			alert("${WM00047}");
			return false;
		}
		fnCheckedTree(p_tree.getSelectedItemId());
		
		if (window.dhtmlx) {
	        for (const key in window.dhtmlx) {
	            delete window.dhtmlx[key];
	        }
	        delete window.dhtmlx;
	    }
	    
    	if (window.dhx) {
		    delete window.dhx;
		}
		
		//if(checkType){
			//p_tree.getSelectedItemId()
		//}
		//ë³ê²½ìì²­í  íë©´ íì ë° ì íë treeìì´í ê°ì ëê²¨ì¤
		//testLayer("${items}","MOD", p_tree.getSelectedItemId());
		//goInsertChangeSet("${items}","MOD", p_tree.getSelectedItemId());
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
     			<span class="btn_pack small icon"><span class="move"></span><input value="Move" type="submit" onclick="processMOVE()" ></span>	
     		</div>	
			<div id="treeArea" style="width:100%;height:325px;background-color:#f9f9f9;border :1px solid Silver;overflow:auto;"></div>  		</div>
	</div>
	</li>
	</ul>
</div>
<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>
