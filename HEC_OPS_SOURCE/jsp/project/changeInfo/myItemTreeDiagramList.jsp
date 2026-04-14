<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/> 

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/dhtmlx/dhtmlxgrid_treegrid.css'/>">
<script src="<c:url value='/cmm/js/dhtmlx/dhtmlxTreeGrid/codebase/dhtmlxtreegrid.js'/>" type="text/javascript" charset="utf-8"></script> 

<style type="text/css" media="screen">
 .row20px img{   height:11px;  }
 .row20px div img{  height:18px;  }
</style>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;
	var ttl="${ttl}";
	
	$(document).ready(function() {
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 160)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 160)+"px;");
		};
		
		$("#excelPrc").click(function(){p_gridArea.toExcel("${root}excelGenerate");});
		fnSelect('Status','&Category=ITMSTS','dictionyCode','${selectedStatus}', 'Select');
		
		$("#TOT_CNT").html(ttl); // Total My ITEM 건수 표시
		setPtgGridList();
		
	});
	
	function setWindowHeight(){
		var size = window.innerHeight;
		var height = 0;
		if( size == null || size == undefined){
			height = document.body.clientHeight;
		}else{
			height=window.innerHeight;
		}return height;
	}
	
	
	//===============================================================================
	// BEGIN ::: GRID
	function setPtgGridList(){	
		var treePData="${myItemTreeXml}";
		//var nameWidth = window.innerWidth - 870; // 스크린 화면 크기에 따라 넓이 변동
		var nameWidth = document.body.clientWidth - 870;
	    p_gridArea = new dhtmlXGridObject('grdGridArea');
	    p_gridArea.selMultiRows = true;
	    p_gridArea.imgURL = "${root}${HTML_IMG_DIR_ITEM}/";
	    p_gridArea.setHeader("#master_checkbox,${menu.LN00028},${menu.LN00131},${menu.LN00191},${menu.LN00018},${menu.LN00070},${menu.LN00027},ItemID,ITMSTS");
		p_gridArea.setInitWidths("30,*,150,150,100,100,100,50,50");
		p_gridArea.setColAlign("center,left,center,center,center,center,center,center,center");
		p_gridArea.setColTypes("ch,tree,ro,ro,ro,ro,ro,ro,ro");
		p_gridArea.setColSorting("int,str,str,str,str,str,str,str,str");
   	  	
		p_gridArea.init();
		p_gridArea.setSkin("dhx_web");
		p_gridArea.setColumnHidden(7, true);
		p_gridArea.setColumnHidden(8, true);
		
		p_gridArea.attachEvent("onCheck", function(rId,cInd,state){ptgGridOnCheck(rId,cInd,state);});
		p_gridArea.attachEvent("onRowSelect", function(id,ind){ptgGridOnRowSelect(id,ind);});
		p_gridArea.loadXMLString(treePData);
		p_gridArea.checkAll(false);
		p_gridArea.enableTreeCellEdit(false);
	}
	
	// [OnCheck] event
	function ptgGridOnCheck(rId,cInd,state){
		var itemId = p_gridArea.cells(rId, 7).getValue();
		if(itemId == ""){
			alert("${WM00046}");
			p_gridArea.cells(rId,0).setValue(0);
		}
	}
	
	// [row Click] event
	function ptgGridOnRowSelect(id, ind){if(ind != 0){var itemID=p_gridArea.cells(id, 7).getValue();if(itemID==""||itemID==undefined){}else{doPtgDetail(itemID);}}}	
	function doPtgDetail(avg){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg);
	}	
	
	// [Add] Click
	function checkOutPop() {
		if(p_gridArea.getCheckedRows(0).length == 0){
			alert("${WM00023}");
		} else {
			var checkedRows = p_gridArea.getCheckedRows(0).split(",");
			var items = "";
			
			for(var i = checkedRows.length-1 ; i >=0 ; i-- ){
				var itemId = p_gridArea.cells(checkedRows[i], 7).getValue();
				var itemStatus = p_gridArea.cells(checkedRows[i], 8).getValue();
				var itemName = p_gridArea.cells(checkedRows[i], 1).getValue();
				
				if (itemStatus != "REL") {
					msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00145' var='WM00145' arguments='"+ itemName +"'/>";
					alert("${WM00145}");
					p_gridArea.cells(checkedRows[i], 0).setValue(0); 
				} else {
					// 삭제 할 ITEMID의 문자열을 셋팅
					if (items == "") {
						items = itemId;
					} else {
						items = items + "," + itemId;
					}
				}
			}
			var csrID = "${csrID}";
			if (items != "") {
				if(csrID != ""){
					var url = "checkOutItem.do";		
					var data = "projectId=${csrID}&itemIds="+items;
					var target = "help_content";
					var screenType = "${screenType}";
					if(screenType == "CSR"){
						target = "saveFrame";
					}					
					ajaxPage(url, data, target);
				}else{
					var url = "cngCheckOutPop.do?";
					var data = "s_itemID=" + items;
				 	var target = self;
				 	var option = "dialogWidth:350px; dialogHeight:150px; scroll:yes";
				 	window.showModalDialog(url+data, target, option);
				}
			}
		}	
		
		/* 아이템 리스트 검색 창을 띄우는 경우
		var url = "selectAllItemPop.do?";
		var data = "";
	    fnOpenLayerPopup(url,data,doCallBack,617,436);
	    */
	}
	function doCallBack(){}
	
	// 본 화면 Reload [Seach][After Check In]
	function thisReload(){
		var url = "myItemTreeDiagramList.do";
		var target = "help_content";
		var screenType = "${screenType}";
		if(screenType == "CSR"){
			target = "myItemDiv";
		}
		
		var data = "screenType="+screenType+"&csrID=${csrID}";
		if($("#Status").val() != '' & $("#Status").val() != null){
			data = data + "&Status="+ $("#Status").val();
		}
		if($("#ClassCode").val() != '' & $("#ClassCode").val() != null){
			data = data + "&ClassCode="+ $("#ClassCode").val();
		}
		
	 	ajaxPage(url, data, target);
	}
	
	function urlReload() {
		thisReload();
	}	
</script>

<div id="myItemDiv" name="myItemDiv">
<form name="MYFrm" id="MYFrm" action="" method="post" onsubmit="return false;">
	<div>
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3><img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp; My ITEM</h3>
	</div><div style="height:10px"></div>
	
	<div class="child_search">
		<li class="shortcut">
			<b class="mgL5">${menu.LN00016}</b>&nbsp;
	 	 	<select id="ClassCode" name="ClassCode">
				<option value=''>Select</option>
	        	<c:forEach var="i" items="${classCodeList}">
	            	<option value="${i.CODE}" <c:if test="${selectedClassCode == i.CODE}">selected="selected"</c:if>>${i.NAME}</option>
	            </c:forEach>
			</select>	
			
			<b class="mgL10">${menu.LN00027}</b>&nbsp;
	 	 	<select id="Status" name="Status"></select>			
			&nbsp;
			<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="thisReload()" value="검색">
	   	 </li>
		<li class="floatR pdR20">
			<c:if test="${projectNameList.size() > 0}">
				&nbsp;<span id="btnAdd" class="btn_pack small icon"><span class="add"></span><input value="Check out" type="submit" onclick="checkOutPop()"></span>
			</c:if>
			&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excelPrc"></span>	
		</li>
	</div>
	<div class="countList pdT5">
	    <li class="count">Total  <span id="TOT_CNT"></span></li>
	</div>
	<div id="gridPtgDiv" style="width:100%;" class="clear">
		<div id="grdGridArea"></div>
	</div>

<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>
</div>
</form>
</div>
