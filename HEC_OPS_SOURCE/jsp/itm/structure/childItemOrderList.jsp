<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>

<script>
	var gridArea;
	var dp;
	$(document).ready(function(){	
		gridInit();		
		doSearchList();
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function thisReload() {
		gridInit();		
		doSearchList();
	}
	
	function doSearchList(){
		var tcd = setGridData();fnLoadDhtmlxGridJson(gridArea, tcd.key, tcd.cols, tcd.data,false,false,"","");
	}
	
	function gridInit(){	
		var tcd = setGridData();
		gridArea = fnNewInitGrid("grdGridArea", tcd);
		gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		gridArea.setIconPath("${root}${HTML_IMG_DIR}/");
		gridArea.setColumnHidden(4, true);
		gridArea.setColumnHidden(5, true);
		
		dp = new dataProcessor("updateChildItemOrder.do?strType=${strType}"); // lock feed url
		dp.enableDebug(true);
		dp.setTransactionMode("POST",true); // set mode as send-all-by-post
		dp.setUpdateMode("off"); // disable auto-update
		
		dp.attachEvent("onAfterUpdateFinish", function(){
			alert("onAfterUpdateFinish");
			thisReload();
		});
		
		dp.init(gridArea); 
		dp.styles={
			updated:"font-style:italic; color:black;",
			inserted:"font-weight:bold; color:green;",
			deleted:"font-weight:bold; color:red;",
			invalid:"color:orange; text-decoration:underline;",
			error:"color:red; text-decoration:underline;",
			clear:"font-weight:normal;text-decoration:none;"
		};
	}
	
	function fnAfterUpdateSendData(){
		alert("${WM00067}");
		thisReload();
	}
	
	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		// result.key = "item_SQL.getChildItemList";
		result.key = "${sqlKey}";
		result.header = "${menu.LN00024},${menu.LN00106},${menu.LN00028},Order,ItemID,CategoryCode";
		result.cols = "Identifier|ItemName|SortNum|ItemID|CategoryCode";
		result.widths = "30,100,250,100,100";
		result.sorting = "int,str,str,str,str";
		result.aligns = "center,center,left,center,center";
		result.data = "s_itemID=${s_itemID}"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";;
		return result;
	}

	function fnMoveRowUp(){
		gridArea.moveRowUp(gridArea.getSelectedRowId());
	}
	
	function fnMoveRowDown(){
		gridArea.moveRowDown(gridArea.getSelectedRowId());
	}
	
	function fnSaveGridSortNum(){			
		if(confirm("${CM00001}")){
			var ids = gridArea.getAllRowIds().split(",");
			
			for(var i=0; i < ids.length; i++){
				gridArea.cells(ids[i], 3).setValue(i);
				dp.setUpdated(ids[i], true, "updated");
			}
			dp.sendData(); 
		}
	}


</script>	
</head>
<body>
<form name="childItemList" id="childItemList" action="#" method="post" onsubmit="return false;">
	<div id="processListDiv" class="hidden" style="width:100%;height:100%;">
	<div style="overflow:auto;margin-bottom:5px;overflow-x:hidden;">	
	<div class="msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Change item list Order</div>
		<div class="child_search">
			<li class="floatR pdL55">
				&nbsp;<span class="btn_pack medium icon"><span class="upload"></span><input value="&nbsp;Up" type="submit" id="file" onclick="fnMoveRowUp();"></span>
			    &nbsp;<span class="btn_pack medium icon"><span class="download"></span><input value="&nbsp;Down" type="submit" id="file" onclick="fnMoveRowDown();"></span>
			    &nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" id="file" onclick="fnSaveGridSortNum();"></span>
			</li>			
		</div>
		  
        <div class="countList">
              <li class="count">Total  <span id="TOT_CNT"></span></li>
              <li class="floatR">&nbsp;</li>
          </div>
		<div id="gridDiv" class="mgB10 clear">
			<div id="grdGridArea" style="height:380px; width:100%"></div>
		</div>
	</div>
	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
</body>
</html>