<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root" />
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/cmm/ui/dhtmlxJsInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>

<!-- 2. Script -->
<script type="text/javascript">
	var p_tree;
	var scrnType = "${scrnType}";
	$(document).ready(function() {
		initTree();
		var unfold ="${unfold}";
		if(unfold != "false" || unfold == ''){	setTimeout(function() {fnSetUnfoldTree();}, 1000);}
		
		$('#schTreeMenuText').keypress(function(onkey){
			if(onkey.keyCode == 13){
				fnSearchTreeText("1");
				return false;
			}
		});		
	});	
	
	function fnSetUnfoldTree(){
		if(p_tree!=null){		
			p_tree.closeAllItems(0);
			var ch = p_tree.hasChildren(0);
			for(var i=0; i<ch; i++){var lev1 = p_tree.getChildItemIdByIndex(0,i);p_tree.openItem(lev1);}
		}
	}
	
	// BEGIN ::: GRID
	function initTree(){
		// var option = $("#option").val();
		var option ="AR000000";
		var data = "ItemTypeCode=${ItemTypeCode}";
		var d = fnSetMenuTreeData(data);
		p_tree = new dhtmlXTreeObject("treeArea", "100%", "100%", 0);	
		p_tree.setSkin('dhx_skyblue');
		p_tree.setImagePath("${root}cmm/js/dhtmlx/dhtmlxTree/codebase/imgs/csh_process/");
		p_tree.enableSmartXMLParsing(true);
		p_tree.enableCheckBoxes(true);	//CheckBox
		p_tree.enableDragAndDrop(false);
		fnLoadDhtmlxTreeJson(p_tree, d.key, d.cols, d.data, option);
		p_tree.setOnLoadingEnd(fnEndLoadPopupTree);
		
		//setTimeout(fnSelectItem,1000); 	
	}
	
	function fnEndLoadPopupTree(){
		p_tree.disableCheckbox("${s_itemID}",true);
		//p_tree.enableRadioButtons("${s_itemID}",false);
		p_tree.selectItem("${s_itemID}",true,false);
	}
	
	function createE2eProcess(){
		var items =p_tree.getAllChecked();
		if(items.length==0){ alert("${WM00023}");return;}
		
		var url = "e2eCreateTreeListModel.do";
		if(scrnType=="addObj"){
			url = "addObjectToDiagram.do";
		}
		var target = "blankFrame";
				
		$("#e2eItmeIDS").val(items);
		var positionX = Math.round("${positionX}");
		var positionY = Math.round("${positionY}");
		if(confirm("${CM00009}")){	
			var data   = "ItemID=${ItemID}&e2eItmeIDS="+items+"&modelID=${modelID}"
						+ "&positionX="+positionX+"&positionY="+positionY
						+ "&newModelName=${newModelName}&MTCTypeCode=${MTCTypeCode}&ModelTypeCode=${ModelTypeCode}"
						+ "&itemTypeCode=${ItemTypeCode}";
			ajaxPage(url,data,target);	
		}
		
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
		//p_tree.findItem(schText,0,1);
		//1:검색, 2:다음, 3:이전
		if(type == "1")p_tree.findItem(schText,0,1);
		else if(type == "2") p_tree.findItem(schText);
		else if(type == "3") p_tree.findItem(schText,1);	
	}
	
</script>
<form name="e2eFrm" id="e2eFrm" action="#" method="post" onsubmit="return false;">
<input type="hidden" id="option" name="option" value="${option}">
<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
<input type="hidden" id="ItemID" name="ItemID" value="${ItemID}">
<input type="hidden" id="e2eItmeIDS" name="e2eItmeIDS" >
<input type="hidden" id="newModelName" name="newModelName" value="${newModelName}" >
<input type="hidden" id="MTCTypeCode" name="MTCTypeCode"  value="${MTCTypeCode}" >
<input type="hidden" id="ModelTypeCode" name="ModelTypeCode"  value="${ModelTypeCode}">
<input type="hidden" id="modelID" name="modelID" value="${modelID}" >
<input type="hidden" id="positionX" name="positionX" value="${positionX}" >
<input type="hidden" id="positionY" name="positionY" value="${positionY}" >
</form>
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
     		<input type="text" class="text" id="schTreeMenuText" style="width:150px;ime-mode:active;"/>
     		<a onclick="fnSearchTreeText('1')"><img src="${root}${HTML_IMG_DIR}/btn_icon_search.png"></a>
     		<a onclick="fnSearchTreeText('3')"><img src="${root}${HTML_IMG_DIR}/btn_previous.png"></a> | <a onclick="fnSearchTreeText('2')"> <img src="${root}${HTML_IMG_DIR}/btn_next.png"> </a>
     			<span class="btn_pack small icon"><span class="save"></span><input type="button" value="Create" onclick="createE2eProcess()" ></span>	
     		</div>     		
			<div id="treeArea" style="width:100%;height:325px;background-color:#f9f9f9;border :1px solid Silver;overflow:auto;"></div>  		</div>
	</div>
	</li>
	</ul>
</div>
<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>
