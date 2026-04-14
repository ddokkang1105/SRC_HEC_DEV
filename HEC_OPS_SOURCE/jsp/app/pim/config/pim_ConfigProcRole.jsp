<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/> 

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/dhtmlx/dhtmlxgrid_treegrid.css'/>">
<script src="<c:url value='/cmm/js/dhtmlx/dhtmlxTreeGrid/codebase/dhtmlxtreegrid.js'/>" type="text/javascript" charset="utf-8"></script>

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/> 
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00114" var="WM00114"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00016}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="${menu.LN00043}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/>

<style>
.child_search_j {background:#f7f7f7;height:60px;padding-top:3px;border:0px solid #ccc;color:#000}
.child_search_j li {border:0px solid #000;vertical-align:middle; z-index:9999;padding:3px 10px;line-height:170%;}
.child_search_j li.shortcut span{padding-left:10px;padding-top:3px;border:0px solid #000;float:left;}
</style>
<!-- 2. Script -->
<script type="text/javascript">
	var ptg_gridArea;
	var selectedItemBlocked = "${selectedItemBlocked}";
	var selectedItemStatus = "${selectedItemStatus}";
	var posX = ""; var posY = "";
	var popupVal;
	var p_itemID = "";
	
	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정 
		$("#grdPtgArea").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdPtgArea").attr("style","height:"+(setWindowHeight() - 100)+"px;");
		};		

		$("#grdPtgArea").mousemove(function(e){
			 
		    posX = e.pageX;
		    posY = e.pageY;
		 
		});
		
		$("#dpName").click(function(){this.focus();});

		$("#popup_close_btn").click(function(){fnCloseitemTreePop();});		
		var t;
		setPtgGridList();
		
		p_itemID = parent.fnGetProjectItemID();
	});
	function resizeLayout(){window.clearTimeout(t);t=window.setTimeout(function(){setScreenResize();},200);}
	function setScreenResize(){var clientHeight=document.body.clientHeight; alert(clientHeight);}
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	//===============================================================================
	// BEGIN ::: GRID
	function setPtgGridList(){	
		var treePData="${prcTreeXml}";
	    ptg_gridArea = new dhtmlXGridObject('grdPtgArea');
	    ptg_gridArea.selMultiRows = true;
	    ptg_gridArea.imgURL = "${root}${HTML_IMG_DIR_ITEM}/";
		ptg_gridArea.setHeader("${menu.LN00028},${menu.LN00043},${menu.LN00014},${menu.LN00018},${menu.LN00004},${menu.LN00013},${menu.LN00027},itemID");
		ptg_gridArea.setInitWidths("*,250,80,80,80,80,80,80");
		ptg_gridArea.setColAlign("left,left,left,left,center,center,center,center");
		ptg_gridArea.setColTypes("tree,ro,ro,ro,ro,ro,ro,ro");
		ptg_gridArea.setColSorting("str,str,str,str,str,str,str,str");
		ptg_gridArea.setColumnHidden(7, true);
   	  	ptg_gridArea.init();

		ptg_gridArea.setSkin("dhx_web");
		ptg_gridArea.attachEvent("onRowSelect", function(id,ind){ptgGridOnRowSelect(id,ind);});
		ptg_gridArea.loadXMLString(treePData);
		ptg_gridArea.enableTreeCellEdit(false);
		ptg_gridArea.enableAutoWidth(true);

	}
	function setLoaingEndTreeGrid(){
		 ptg_gridArea.forEachRow(function(id){
			 //var classCode=ptg_gridArea.cells(id, 11).getValue();if(classCode==""||classCode=="CL01005"){ptg_gridArea.cellById(id,0).setDisabled(true);}else{}
		 });
	}

	function ptgGridOnRowSelect(id, ind){		
		var itemID=ptg_gridArea.cells(id, 7).getValue();
		if(id == 0){ doPtgDetail(itemID); }		
	}	
	
	function doPtgDetail(avg){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg);
	}	
	function doPPSearchList(){setPtgGridList();}

	function fnSearchList(){
		var itemIDs = $("#departmentList").val();
		
		if(itemIDs == undefined || itemIDs == null)
			itemIDs = "";
		
		var dpName = $("#dpName").val();
		var url = "/zdaelim_jobCxnMgt.do";
		var target = "actFrame";
		var data = "s_itemID=${itemID}&option=${option}&filter=${filter}&screenMode=${screenMode}&varFilter=${varFilter}&itemIDs="+itemIDs+"&dpName="+dpName;
	 	ajaxPage(url, data, target);
	}
	
	function fnDeleteJopCnx(){
		var url = "/daelim/plant/zdaelim_jobDelPop.do?"; 
		var data = "itemID=${itemID}";
		var w = 900;
		var h = 400;

		window.open(url+data,"_blank","width="+w+",height="+h);
	}
			
	//[Add] click 이벤트
	function addRelItem() {
		if (selectedItemBlocked == "0") {
			$("#newItemArea").attr("style", "display:block;");
		} else {
			if (selectedItemStatus == "REL") {
				alert("${WM00120}"); // [변경 요청 안된 상태]
			} else {
				alert("${WM00050}"); // [승인요청중]
			}
		} 
	}
	
	function newItemInsert() {
		if($("#newItemName").val() == ""){alert("${WM00034_1}");$("#newItemName").focus();return false;}
		if($("#newClassCode").val() == ""){alert("${WM00034_2}");$("#newClassCode").focus();return false;}
		if($("#parentItemPath").val() == ""){alert("${WM00034_3}");$("#parentItemPath").focus();return false;}
	
		if(confirm("${CM00009}")){		
			var url = "newItemInsertAndAssign.do";
			var data = "s_itemID=${itemID}&option=${option}"
						+"&CNItemTypeCode=${CNItemTypeCode}&isFromItem=${isFromItem}"
						+"&newClassCode="+$("#newClassCode").val()
						+"&newIdentifier="+replaceText($("#newIdentifier").val())						
						+"&newItemName="+replaceText($("#newItemName").val());
			var target = "blankFrame";		
			ajaxPage(url, data, target);
		}
	}
	
	function urlReload() {
		fnSearchList();
	}
	
	function fnUrlReload() {
		fnSearchList();
	}
	
	// Assign insert 후 
	function thisReload() {
		var selectedTreeItemID = "${itemID}";
		var assignItems = $("#assignItems").val();
		
		var url = "checkToItems.do";
		var data = "selectedTreeItemID="+selectedTreeItemID+"&assignItems="+assignItems;
		var target="blankFrame";
		ajaxPage(url, data, target);
	}
	
	function fnOpenParentItemPop(){// ParentItem Popup
		var itemId = "${parentItemID}";
		if(itemId=="" || itemId=="0"){return;}
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id=${parentItemID}&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,itemId);
	}
	
	// 신규 생성  할 항목의 부모 아이템을 선택 할 popup창을 표시
	function itemTypeCodeTreePop() { 
		var url = "itemTypeCodeTreePop.do";
		var data = "openMode=add&ItemTypeCode=${ItemTypeCode}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${s_itemID}&option=${option}";
		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}
	
	
	function doCallBack() {}
	
	//After [Assign -> Assign]
	function setCheckedItems(checkedItems){
		var url = "checkClassCode.do";
		var data = "itemIDs="+checkedItems+"&varFilter=${varFilter}";
		var target="blankFrame";
		ajaxPage(url, data, target);
		
		$(".popup_div").hide();
		$("#mask").hide();	
	}
		
	function fnInsertAssinID(checkedItems){
		var connectionType = "From";
		if ("${isFromItem}" == "N") {
			connectionType = "To";
		}
		$("#assignItems").val(checkedItems);
		var url = "createCxnItem.do";
		var data = "s_itemID=${itemID}&loginID=${sessionScope.loginInfo.sessionUserId}&connectionType="+connectionType+"&items="+checkedItems;
		var target = "blankFrame";
		
		ajaxPage(url, data, target);	 
	}
	
	function fnNotItemIDs(notItemIDs){
		alert(notItemIDs+"는 저장 할 수 없습니다.");
	}
	

	function fnCloseLayer(){
		var layerWindow = $('.bpList_layer');
		layerWindow.removeClass('open');
	}

	/* BP Link */	
	
	
	
	function fnCloseItemTreePop(){
		$(".popup_div").hide();	
		$("#mask").hide();
	}
	
	

	
	function fnDownExcel(){
		ptg_gridArea.toExcel("${root}excelGenerate");
	}

</script>
<body>
<div id="processDIV">
<form name="JobFrm" id="JobFrm" action="" method="post" onsubmit="return false;">
<input type="hidden" id="assignItems" name="assignItems" >
	<div class="child_search" id="pertinentSearch">
		<ul>
			<li class="floatR pdR5" >
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel" onclick="fnDownExcel()" style="cursor:hand;"></span>
			</li>			
		</ul>
	</div>
	
	<div id="gridPtgDiv" class="mgB10 mgT5">
		<div id="grdPtgArea" style="width:100%;"></div>
	</div>
</form>
<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>
</div>
</body>
