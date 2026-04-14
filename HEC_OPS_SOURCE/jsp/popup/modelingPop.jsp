<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>	
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript">	
	var pop={};
	pop.pages={};
	pop.url={};
    var skin = "dhx_skyblue";
    var startIdx = 0;
    var lMinWidth = 210, rMinWidth=700;
	var currItemId = "";
    
	jQuery(document).ready(function() {			
		fnInit();
		$('#schClickedURL').change(function(){	changeClickedTreeURL($(this).val());});		
		$('#schTreeMenuText').keypress(function(onkey){if(onkey.keyCode == 13){fnSearchTreeText('1');}});		
	});		
	function fnInit(){
		fnInitLayout();
		currItemId = $('#ModelID').val();
		var paramId = "AR03000";
		var defDimValue = "";
		getCategory(paramId, defDimValue);		
	}		
	//=========================================================================
	/** Loyout 초기화  */
	function fnInitLayout(){
		pop.layout=new dhtmlXLayoutObject("container","2U",skin);
		pop.layout.setAutoSize("b","a;b"); //가로, 세로
		pop.layout.attachEvent("onPanelResizeFinish",function(){fnSetLayoutResize();});
		pop.layout.items[0].setWidth(250);
		pop.layout.items[1].hideHeader();	
		pop.menuTreeLayout = new dhtmlXLayoutObject(pop.layout.items[0], "2E");		
		pop.menuTreeLayout.items[0].setHeight(30);
		pop.menuTreeLayout.items[0].fixSize(false, true);	
		pop.menuTreeLayout.items[0].hideHeader();
		pop.menuTreeLayout.items[1].hideHeader();
		pop.menuSchObj = pop.menuTreeLayout.items[0].attachObject("divSchTreeMenu");
		pop.menuTree = pop.menuTreeLayout.items[1].attachTree(0);		
		pop.menuTree.setSkin(skin);
		pop.menuTree.setImagePath("${root}cmm/js/dhtmlxTree/codebase/imgs/csh_winstyle/");
	  	pop.menuTree.setOnClickHandler(pop.getMenuUrl);
		pop.menuTree.enableDragAndDrop(false);
		pop.menuTree.enableSmartXMLParsing(true);		
		pop.cntnLayout = new dhtmlXLayoutObject(pop.layout.items[1], "2E");
		pop.cntnLayout.items[0].setHeight(30);
		pop.cntnLayout.items[0].fixSize(false, true);	
		pop.cntnLayout.items[0].hideHeader();
		pop.cntnLayout.items[1].hideHeader();		
		pop.cntnTopObj = pop.cntnLayout.items[0].attachObject("divCntnTop");
	}	
	function fnSetLayoutResize(){
		var minWidth = lMinWidth + rMinWidth;
		var lWidth = pop.layout.items[0].getWidth();
		var rWidth = pop.layout.items[1].getWidth();
		var wWidth = document.body.clientWidth;
		if( lWidth < lMinWidth){pop.layout.items[0].setWidth(lMinWidth);}
		if( wWidth >= minWidth && rWidth < rMinWidth){pop.layout.items[1].setWidth(rMinWidth);}
	}

	pop.get_id_chain=function(tree,id){
		var chain=[id];
		while(id=tree.getParentId(id))
			chain.push(id);
		return chain.reverse().join("|");
	};	
	pop.getMenuUrl=function(id){
		var ids = id.split("_");
		$('#MENU_ID').val(ids[0]);		
		document.menuFrm.action = "menuURL.do";
		document.menuFrm.target="blankFrame";
		document.menuFrm.submit();
	};
	var menuOption = "";	
	function creatMenuTab(menuId, menuURL, level){
		var ModelID = $('#ModelID').val();
		if( startIdx > 0 && menuId == ModelID) return;
		++startIdx;
		$('#ModelID').val(menuId);		
		var id = menuId;
		var fullId = "";
		var text = "";
		var url = "newDiagramEditor.do";
		var data = "?"
		+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
		+"&modelID="+menuId
		+"&s_itemID="+menuId
		+"&option=${option}"
		+"&filter=element";		
		url = url + data;
		pop.create_tab(id, fullId, text, url, true); 
	}
	
	pop.create_tab=function(id,fullId,text,url,isInclude){
		$('#ModelID').val(id);
		fullId = id;
		var cntnTitle = text||pop.menuTree.getItemText(id);
		var fullText = $("#menuFullTitle").val();
		fullText = fullText + "&nbsp;::&nbsp;" + cntnTitle;
		$("#cntnTitle").html("<span style=color:#0D65B7;font-weight:bold;>&nbsp;&nbsp;"+fullText+"</span>");  /*제목 요기*/
		
		if(!pop.url[fullId]){
			pop.url[fullId]=fullId+"^"+url;
			pop.cntnLayout.items[1].attachURL(url);			
			if( isInclude){
				$("#schClickedURL").prepend("<option value='"+fullId+"' selected>"+cntnTitle+"</option>");
				$("#schClickedURL").val(fullId);
			}
		}else{
			pop.url[fullId]=fullId+"^"+url;
			pop.cntnLayout.items[1].attachURL(url);
			$("#schClickedURL").val(fullId);
		}
	};	
	//END ::: Contents
	//=========================================================================

	//=============================================================
	//BEGIN ::: MENU
	//트리 메뉴 조회 정보
	function setMenuTreeData(data) {
		if(data == undefined) data = "";		
		var result = new Object();
		result.title = "${title}";
		result.key = "menu_SQL.menuTreeList";
		result.header = "TREE_ID, PRE_TREE_ID,TREE_NM";
		result.cols = "TREE_ID|PRE_TREE_ID|TREE_NM";
		result.data = data ;
		return result;
	}	
	function getCategory(avg, defDimValueID){
		$("#MENU_SELECT").val(avg);
		menuOption = avg;
		pop.menuTree.getSelectedItemId();
		pop.menuTree.deleteChildItems(0);//초기화
		var data = "";
		if( defDimValueID != "") data = "DefDimValueID="+defDimValueID;
		var d = setMenuTreeData(data);
		fnLoadDhtmlxTreeJson(pop.menuTree, d.key, d.cols, d.data, avg);
		pop.menuTree.setOnLoadingEnd(fnEndLoadTree);
	}
	//END ::: MENU
	//=============================================================	
	
	//트리 메뉴에서 '이전', '다음' 검색
	function fnSearchTreeText(type){
		//1:검색, 2:다음, 3:이전
		if(type == "1") pop.menuTree.findItem(document.getElementById('schTreeMenuText').value,0,1);
		else if(type == "2") pop.menuTree.findItem(document.getElementById('schTreeMenuText').value);
		else if(type == "3") pop.menuTree.findItem(document.getElementById('schTreeMenuText').value,1);		
	}	
	function changeClickedTreeURL(avg)
	{
		var fullId = avg;
		var chkIdx = $("#schClickedURL option").index( $('#schClickedURL option:selected'));
		var idxSize = 0;

		if(avg == "PRE"){
			idxSize = $('#schClickedURL option:selected').nextAll().size();
			if(  idxSize > 0){ 
				chkIdx = chkIdx +1;
				$('#schClickedURL option:eq('+chkIdx+')').attr("selected", "selected");				
			}
		} else if(avg == "POST"){
			idxSize = $('#schClickedURL option:selected').prevAll().size();
			if(  idxSize > 0){ 
				chkIdx = chkIdx -1;
				$('#schClickedURL option:eq('+chkIdx+')').attr("selected", "selected");
			}
		}
		fullId = $('#schClickedURL option:selected').val();
		url = pop.url[fullId].split("^");
		pop.cntnLayout.items[1].attachURL(url[1]);		
		pop.menuTree.selectItem(fullId,true,false);
	}
	function fnSearchTreeId(itemId){
		if(itemId == null || itemId == undefined)
			itemId = pop.menuTree.getSelectedItemId();		
		currItemId = itemId;
		pop.menuTree.deleteChildItems(0);		
		var d = setMenuTreeData();
		fnLoadDhtmlxTreeJson(pop.menuTree, d.key, d.cols, d.data, menuOption,"");		
		pop.menuTree.setOnLoadingEnd(fnEndLoadTree);
	}
	function fnEndLoadTree(prtItemId){
		if(prtItemId == null || prtItemId == 'undefined'){ prtItemId = 1;}
		pop.menuTree.openItem(prtItemId);
		if(currItemId == null || currItemId == undefined){return false;}
		else{ 
			pop.menuTree.openAllItems(currItemId);		
			pop.menuTree.selectItem(currItemId,true,false);
		}
	}
	 
</script>
</head>

<body>
	<input type="hidden" id="menuFullTitle"></input>
	<input type="hidden" id="ItemID" name="ItemID" value="${ItemID}"/>
	<input type="hidden" id="ModelID" name="ModelID" value="${ModelID}"/>
	
<div id="maincontainer">
	<form name="menuFrm" id="menuFrm">
		<input type="hidden" id="MENU_URL" name="MENU_URL"></input>
		<input type="hidden" id="MENU_ID" name="MENU_ID"></input>
		<input type="hidden" id="MENU_SELECT" name="MENU_SELECT"></input>
	</form>	
	<!-- BEGIN ::: CONTENTS -->
	<div id="contentwrapper">
		<!-- BEGIN ::: SHORT MENU -->
		<div id="leftcolumn">
		</div>
		<!-- END ::: SHORT MENU -->
				
		<div id="contentcolumn">		
			<div class="container" id="container">
				<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
			 </div>	
	
			<div id="divSchTreeMenu" style="display:block">
				<input type="text" class="text" id="schTreeMenuText" style="width:120px;ime-mode:active;"/><a onclick="fnSearchTreeText('1')"><img src="${root}${HTML_IMG_DIR}/btn_icon_search.png"></a><a onclick="fnSearchTreeText('2')"><img src="${root}${HTML_IMG_DIR}/btn_previous.png"></a> |<a onclick="fnSearchTreeText('3')"> <img src="${root}${HTML_IMG_DIR}/btn_next.png"> </a>
			</div>	
			
			<div id="divCntnTop" style="display:block;">
				 <div class="floatL" id="cntnTitle" ></div>
				 <div class="cntnTitleR">
				 	<ul>
					<li>
						<a href="javascript:void(0)" onclick="changeClickedTreeURL('PRE')"><img src="${root}${HTML_IMG_DIR}/icon_page_pre.png" alt="이전"/></a>
					</li>
					<li>
						<select id="schClickedURL" name="schClickedURL" style="width:150px"></select>
					</li>
					<li>
						<a href="javascript:void(0)" onclick="changeClickedTreeURL('POST')"><img src="${root}${HTML_IMG_DIR}/icon_page_next.png" alt="다음"/></a>
					</li>
				 	</ul>
				 </div>
			</div>
			
			<div id="divCntn" ></div>
		</div>

	</div>	

	
	<!-- END ::: CONTENTS -->
 
</div>

</body>

</html>