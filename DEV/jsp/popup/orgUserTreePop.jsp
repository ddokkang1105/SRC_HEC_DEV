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
	var org_tree;
	
	$(document).ready(function() {
		$('#popup_close_btn').click(function(){
			thisClose();
		});
		
		initTree();
		$('#schTreeMenuText').keypress(function(onkey){if(onkey.keyCode == 13){fnSearchTreeText('1');}});
	});
	
	//===============================================================================
	// BEGIN ::: GRID
	function initTree() {
		var data = "";
		var d = fnSetMenuTreeData(data);
		org_tree = new dhtmlXTreeObject("treeArea", "100%", "100%", 0);	
		org_tree.setSkin('dhx_skyblue');
		org_tree.setImagePath("${root}cmm/js/dhtmlx/dhtmlxTree/codebase/imgs/csh_process/");
		org_tree.enableSmartXMLParsing(true);
		org_tree.enableDragAndDrop(false);

		if ("${openMode}" == "assignOwnerTeam") {
			org_tree.enableCheckBoxes(true);	//CheckBox
		}
		org_tree.attachEvent("onCheck", function(id, state){fnOnCheck(id,state); });
		fnLoadDhtmlxTreeJson(org_tree, d.key, d.cols, d.data, "AR000002");
		org_tree.setOnLoadingEnd(fnEndLoadPopupTree);
		setTimeout(fnSelectItem,1000); 	
	}
	
	function fnSelectItem(){
		org_tree.selectItem("${s_itemID}",true,false);
	}
	function fnEndLoadPopupTree(){
		org_tree.disableCheckbox("${s_itemID}",false);
	}
	
	// [Move] click
	function moveOrg(){
			
		if ("${openMode}" != "assignOwnerTeam") {
			if(org_tree.getSelectedItemId() == ""){
				alert("${WM00042}");
				return false;
			}
			if(org_tree.getSelectedItemId() == "${s_itemID}"){
				alert("${WM00135}");
				return false;
			}
		}

		if ("${openMode}" == "assignOwnerTeam") {
			var checkedRows = org_tree.getAllChecked().split(",");	
			var teamNames =""; 
			
			for(var i = 0 ; i < checkedRows.length; i++ ){
				if (teamNames == "") {
					teamNames = org_tree.getItemText(checkedRows[i]);
				} else {
					teamNames = teamNames + ", " + org_tree.getItemText(checkedRows[i]);
				}
			}
					
			doCallBackTeam(org_tree.getAllChecked(),teamNames);
		}
		else {
			doCallBack(org_tree.getSelectedItemId());
		}
		thisClose();
		
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
	
	function fnSearchTreeText(type){
		var schText = $("#schTreeMenuText").val();
		//1:검색, 2:다음, 3:이전
		if(type == "1")org_tree.findItem(schText,0,1);
		else if(type == "2") org_tree.findItem(schText);
		else if(type == "3") org_tree.findItem(schText,1);	
	}
	
	//[Close] Close
	function thisClose(){
		$(".popup_div").hide();
		$("#mask").hide();
	}
	
	function fnOnCheck(id,state){
		if(document.all("IncludeSubitems").checked == true ){
			if(state == 1){
				org_tree.setSubChecked(id,true);
			}else{
				org_tree.setSubChecked(id,false);
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
  				<c:if test="${openMode eq 'assignOwnerTeam'}" >
     			<input type="checkbox" id="IncludeSubitems" />&nbsp;&nbsp;Include sub items&nbsp; 
     			</c:if>
     		</div>	
     		<div class="alignR mgT5 mgB5">
     			<!-- 검색  -->
	     		<input type="text" class="text" id="schTreeMenuText" style="width:150px;ime-mode:active;"/>
	     		<a onclick="fnSearchTreeText('1')"><img src="${root}${HTML_IMG_DIR}/btn_icon_search.png"></a>
	     		<a onclick="fnSearchTreeText('3')"><img src="${root}${HTML_IMG_DIR}/btn_previous.png"></a> | <a onclick="fnSearchTreeText('2')"> <img src="${root}${HTML_IMG_DIR}/btn_next.png"> </a>
	     		<!-- Assign Button  -->
     			<span class="btn_pack small icon"><span class="move"></span><input value="Move" type="submit" onclick="moveOrg();"></span>
     			
     		</div>	
			<div id="treeArea" style="width:100%;height:325px;background-color:#f9f9f9;border :1px solid Silver;overflow:auto;"></div>  		
		</div>
	</div>
	</li>
	</ul>
</div>
<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>
