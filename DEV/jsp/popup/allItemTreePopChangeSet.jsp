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
		fnSelect("Category","&Category=PJTCAT","getDicWord","");
		fnSelect("PStatus","&Category=PJTSTS","getDicWord","");
		fnSelect("Reason","&Category=CR","getDicWord","");
		fnSelect("Type","&Category=CNGT1","getDicWord","");
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
		var data = "&AuthorID="+$("#subAuthorID").val()
					+"&AuthorName="+$("#subAuthorName").val()
					+"&Category="+$("#Category").val()
					+"&Status="+$("#PStatus").val()
					+"&Reason="+$("#Reason").val()
					+"&Type="+$("#Type").val()
					+"&TeamID="+$("#subOwnerTeamCode").val()
					+"&Description="+$("#subDescription").val();
		//alert(items);
		addItem(items, data);
		
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
	
	function searchPopup(url){
		window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}

	function setSubSearchName(memberID,memberName){
		$('#subAuthorID').val(memberID);
		$('#subAuthorName').val(memberName);
	}
	function setSubSearchTeam(teamID,teamName){
		$('#subOwnerTeamCode').val(teamID);
		$('#subTeamName').val(teamName);
	}
	
</script>
<input type="hidden" id="option" name="option" value="${option}">
<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
<input type="hidden" id="subAuthorID" name="subAuthorID" />
<input type="hidden" id="subOwnerTeamCode" name="subOwnerTeamCode" />
<div class="popup01">
<ul>
  <li class="con_zone">
	<div class="title popup_title"><span class="pdL10"> Search</span>
		<div class="floatR mgR10">
			<img class="popup_closeBtn" id="popup_close_btn" src='${root}${HTML_IMG_DIR}/btn_close1.png' title="close">
		</div>
	</div> 
	<div class="szone">
		<ul>
			<li class="pdL10">
				${menu.LN00018}
				<input type="text"class="text" id="subTeamName" name="subTeamName" readonly="readonly" onclick="searchPopup('searchTeamSubPop.do')" style="width:150px"/>
				${menu.LN00004}
				<input type="text"class="text" id="subAuthorName" name="subAuthorName" readonly="readonly" onclick="searchPopup('searchNameSubPop.do')" style="width:150px"/>
			</li>
			<li class="pdL10">
				${menu.LN00033}
				<select id="Category" Name="Category"></select>
				${menu.LN00027}
				<select id="PStatus" Name="PStatus"></select>
				${menu.LN00042}
				<select id="Reason" Name="Reason"></select>
				Type
				<select id="Type" Name="Type"></select>
			</li>
			
			<li class="pdL10">
				${menu.LN00035}
				<input type="text" class="text" id="subDescription" name="subDescription" style="width:500px">
			</li>
		</ul>
  		<div class="con01 mgL10">
     		<div class="alignR mgT5 mgB5">
     			<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="processAdd()" ></span>	
     		</div>	
		    <div id="treeArea" style="width:100%;height:255px;background-color:#f5f5f5;border :1px solid Silver;overflow:auto;"></div>
  		</div>
	</div>
	</li>
	</ul>
</div>