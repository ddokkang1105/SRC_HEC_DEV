<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/> 

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/dhtmlx/dhtmlxgrid_treegrid.css'/>">
<script src="<c:url value='/cmm/js/dhtmlx/dhtmlxTreeGrid/codebase/dhtmlxtreegrid.js'/>" type="text/javascript" charset="utf-8"></script> 

<style type="text/css" media="screen">

 .row20px div img{  height:18px;  }
</style>
<!-- 연관항목 목록 TreeGrid pop up  ->

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012" />

<!-- 2. Script -->
<script type="text/javascript">
	var ptg_gridArea;
	$(document).ready(function() {
		if(window.attachEvent){window.attachEvent("onresize",resizeLayout);}else{window.addEventListener("resize",resizeLayout, false);}
		setPtgGridList();
	});
	function resizeLayout(){window.clearTimeout(t);t=window.setTimeout(function(){setScreenResize();},200);}
	function setScreenResize(){var clientHeight=document.body.clientHeight; alert(clientHeight);}
	/*
	function setSample(){
		var treeData="${treeXml}";
	    ptg_gridArea = new dhtmlXGridObject('grdPtgArea');
	    ptg_gridArea.selMultiRows = true;
	    ptg_gridArea.imgURL = "${root}cmm/js/dhtmlxGrid/codebase/imgs/icons_books/";
		ptg_gridArea.setHeader("Tree,Price,Note");
		ptg_gridArea.setInitWidths("200,150,100");
		ptg_gridArea.setColAlign("left,right,center");
		ptg_gridArea.setColTypes("tree,price,ch");
		ptg_gridArea.setColSorting("str,str,str");
	  	ptg_gridArea.init();
		ptg_gridArea.setSkin("dhx_skyblue");
		ptg_gridArea.loadXMLString(treeData);
	}*/
	//===============================================================================
	// BEGIN ::: GRID
	function setPtgGridList(){	
		var treePData="${prcTreeXml}";
	    ptg_gridArea = new dhtmlXGridObject('grdPtgArea');
	    ptg_gridArea.selMultiRows = true;
	    ptg_gridArea.imgURL = "${root}${HTML_IMG_DIR_ITEM}/";
		ptg_gridArea.setHeader("#master_checkbox,${menu.LN00028},${menu.LN00043},${menu.LN00014},${menu.LN00018},${menu.LN00004},${menu.LN00013},${menu.LN00027},ItemID,ClassCode");
		ptg_gridArea.setInitWidths("30,350,340,100,100,50,80,80,0,0");
		ptg_gridArea.setColAlign("center,left,left,center,center,center,center,center,left,center");
		ptg_gridArea.setColTypes("ch,tree,ro,ro,ro,ro,ro,ro,ro,ro");
		ptg_gridArea.setColSorting("int,str,str,str,str,str,str,str,str,str");
   	  	ptg_gridArea.init();
		ptg_gridArea.setSkin("dhx_web");
		ptg_gridArea.setColumnHidden(8, true);
		ptg_gridArea.setColumnHidden(9, true);
		ptg_gridArea.attachEvent("onCheck", function(rId,cInd,state){ptgGridOnCheck(rId,cInd,state);});
		ptg_gridArea.loadXMLString(treePData);
		ptg_gridArea.checkAll(false);
		ptg_gridArea.enableTreeCellEdit(false);
	}
	function setLoaingEndTreeGrid(){
		 ptg_gridArea.forEachRow(function(id){
			 var classCode=ptg_gridArea.cells(id, 9).getValue();if(classCode==""||classCode=="CL01005"){ptg_gridArea.cellById(id,0).setDisabled(true);}else{}
		 });
	}
	function ptgGridOnCheck(rId,cInd,state){
		if (state) {
			var classCode=ptg_gridArea.cells(rId, 9).getValue();
			//if(classCode==""||classCode=="CL01005"){
			if(classCode==""){
				alert("${WM00046}");
				ptg_gridArea.cells(rId,0).setValue(0);
			} else { 
				var itemID=ptg_gridArea.cells(rId, 8).getValue();
				if(itemID==""||itemID==undefined){var subitems=ptg_gridArea.getSubItems(rId).split(",");for(var i=0;i<subitems.length;i++){ptg_gridArea.cells(subitems[i],0).setValue(1);}}
			}
		}else{if(itemID==""||itemID==undefined){var subitems=ptg_gridArea.getSubItems(rId).split(",");for(var i=0;i<subitems.length;i++){ptg_gridArea.cells(subitems[i],0).setValue(0);}}} 
	}
	function doPPSearchList(){setPtgGridList();}
	// END ::: GRID
	//===============================================================================
	
	function addItems() {
		if(ptg_gridArea.getCheckedRows(0).length == 0){
			alert("${WM00023}");			
		}else{
			if(confirm("${CM00012}")){
				var checkedRows = ptg_gridArea.getCheckedRows(0).split(",");	
				var items = "";
				var itmNms = "";
				
				for(var i = 0 ; i < checkedRows.length; i++ ){
					// 삭제 할 (ItemID, Item명칭)의 문자열을 셋팅
					if (items == "") {
						items = ptg_gridArea.cells(checkedRows[i], 8).getValue();
						itmNms = ptg_gridArea.cells(checkedRows[i], 1).getValue();
					} else {
						items = items + "," + ptg_gridArea.cells(checkedRows[i], 8).getValue();
						itmNms = itmNms + ":::" + ptg_gridArea.cells(checkedRows[i], 1).getValue();
					}
				}
				
				$("#items").val(items);
				$("#itmNms").val(itmNms);
				//alert(items);
				var url = "addCNItemToChangeSetList.do";
				ajaxSubmit(document.cnItemFrm, url);
			}
		}
	}
	
	// [add] 이벤트 후 처리
	function selfClose() {
		var opener = window.dialogArguments;
		opener.reload();
		self.close();
	}
	
</script>

</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>
<body style="width:100%;">
<form name="cnItemFrm" id="cnItemFrm" action="addCNItemToChangeSetList.do" method="post" onsubmit="return false;">	
	
	<input type="hidden" id="ProjectID" name="ProjectID"  value="${ProjectID}" />
	<input type="hidden" id="cngtID" name="cngtID"  value="${cngtID}" />
	<input type="hidden" id="s_itemID" name="s_itemID"  value="${s_itemID}" />
	<input type="hidden" id="items" name="items"  value="" />
	<input type="hidden" id="itmNms" name="itmNms"  value="" />
	<input type="hidden" id="languageID" name="languageID"  value="${sessionScope.loginInfo.sessionCurrLangType}" />
	
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00008}</p>
	</div>
	
	<div class="child_search" id="pertinentSearch">
		<ul>
			<li class="endR" >
				&nbsp;<span id="btnAdd" class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="addItems()"></span>
			</li>			
		</ul>
	</div>
	<div id="gridPtgDiv" class="mgB10">
		<div id="grdPtgArea" style="height:430Px;width:100%;"></div>
	</div>
</form>	
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
</body>
</html>
