<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root" />
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/ui/dhtmlxJsInc.jsp"%>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00042" var="WM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00135" var="WM00135"/>

<!-- 2. Script -->
<script type="text/javascript">
	var p_tree;
	var treeImgPath="${menuStyle}";
	var assignedIDs = "${assignedIDs}";

	$(document).ready(function() {
		$('#popup_close_btn').click(function(){
			thisClose();
		});
		
		initTree();

		$('#IncludeSubitems').change(function() {
			if (this.checked) {
				var checkedIds = p_tree.getAllChecked();
				if (checkedIds) {
					var idArray = checkedIds.split(",");
					for (var i = 0; i < idArray.length; i++) {
						p_tree.setSubChecked(idArray[i], true);
					}
				}
			}
		});

		$('#schTreeMenuText').keypress(function(onkey){if(onkey.keyCode == 13){fnSearchTreeText('1');}});
	});
	
	//===============================================================================
	// BEGIN ::: GRID
	function initTree() {
		var data = "";
		var d = fnSetMenuTreeData(data);
		p_tree = new dhtmlXTreeObject("treeArea", "100%", "100%", 0);	
		p_tree.setSkin('dhx_skyblue');
		p_tree.setImagePath("${root}cmm/js/dhtmlx/dhtmlxTree/codebase/imgs/csh_organization/");
		p_tree.enableSmartXMLParsing(true);
		p_tree.enableCheckBoxes(true);	//CheckBox
		p_tree.enableDragAndDrop(false);
		fnLoadDhtmlxTreeJson(p_tree, d.key, d.cols, d.data, "AR000002");
		p_tree.setOnLoadingEnd(function() {
			fnEndLoadPopupTree();

			if (assignedIDs && assignedIDs !== "") {
				var idArr = assignedIDs.split(",");
				for (var i = 0; i < idArr.length; i++) {
					var targetId = idArr[i].trim();
					if (p_tree.getItemText(targetId) !== null) {
						p_tree.disableCheckbox(targetId, true);
					}
				}
			}
		});
		p_tree.attachEvent("onCheck", function(id, state){fnOnCheck(id,state); });
		setTimeout(fnSelectItem,1000); 	
	}
	
	function fnSelectItem(){
		p_tree.selectItem("${s_itemID}",true,false);
	}
	function fnEndLoadPopupTree(){
		p_tree.disableCheckbox("${s_itemID}",false);
	}
	
	// [Move] click
	function fnAdd(){
		var teamIDs =p_tree.getAllChecked().split(",");	
		var teamNames = "";
		
		if(teamIDs == ""){
			alert("${WM00042}");
			return false;
		}
		
		for(var i = 0 ; i < teamIDs.length; i++ ){
			
			if(i == 0) {
				teamNames = p_tree.getItemText(teamIDs[i]);
			}
			else {
				teamNames = teamNames + "," + p_tree.getItemText(teamIDs[i]);				
			}
		
		}
	 
		fnSaveTeamRole(teamIDs,teamNames);
		
		if (window.dhtmlx) {
	        for (const key in window.dhtmlx) {
	            delete window.dhtmlx[key];
	        }
	        delete window.dhtmlx;
	    }

	    if (window.dhx) {
	        delete window.dhx;
	    }
		
		thisClose();
	}
	
	function fnSearchTreeText(type){
		var schText = $("#schTreeMenuText").val();
		//1:검색, 2:다음, 3:이전
		if(type == "1")p_tree.findItem(schText,0,1);
		else if(type == "2") p_tree.findItem(schText);
		else if(type == "3") p_tree.findItem(schText,1);	
	}
	
	//[Close] Close
	function thisClose(){
		$(".popup_div").hide();
		$("#mask").hide();
	}
	
	function fnOnCheck(id,state){
		if(document.all("IncludeSubitems").checked == true ){
			if(state == 1){
				p_tree.setSubChecked(id,true);
			}else{
				p_tree.setSubChecked(id,false);
			}
		}
	}
	
</script>
<input type="hidden" id="option" name="option" value="${option}">
<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">

<div class="popup01">
<ul>
  <li class="con_zone">
	<div class="title popup_title"><span class="pdL10"> Search Organization</span>
		<div class="floatR mgR10">
			<img class="popup_closeBtn" id="popup_close_btn" src='${root}${HTML_IMG_DIR}/btn_close1.png' title="close">
		</div>
	</div> 
	<div class="szone">
  		<div class="con01 mgL10">
  			<div class="floatL mgT5 mgB5"> 
   				<input type="checkbox" id="IncludeSubitems" />&nbsp;&nbsp;Include sub items&nbsp; 
   			</div>	
     		<div class="alignR mgT5 mgB5">
     			<!-- 검색  -->
	     		<input type="text" class="text" id="schTreeMenuText" style="width:150px;ime-mode:active;"/>
	     		<a onclick="fnSearchTreeText('1')"><img src="${root}${HTML_IMG_DIR}/btn_icon_search.png"></a>
	     		<a onclick="fnSearchTreeText('3')"><img src="${root}${HTML_IMG_DIR}/btn_previous.png"></a> | <a onclick="fnSearchTreeText('2')"> <img src="${root}${HTML_IMG_DIR}/btn_next.png"> </a>
	     		<!-- Assign Button  -->
     			<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="fnAdd();"></span>
     			
     		</div>	
			<div id="treeArea" style="width:100%;height:325px;background-color:#f9f9f9;border :1px solid Silver;overflow:auto;"></div>  		
		</div>
	</div>
	</li>
	</ul>
</div>
<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>
