<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/> 
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
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
		$('#departmentList').SumoSelect({placeholder : "Select department", defaultValues: "${itemIDs}"});
		
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
		ptg_gridArea.setHeader("${menu.LN00112},${menu.LN00042},Category,Know-how,L/L,V/E,사내표준,참고자료,IT System,${menu.LN00070},ItemID,Identifier,ClassCode,AuthorID,CNItemID,CategoryCode");
		ptg_gridArea.setInitWidths("*,80,100,80,60,60,60,60,60,60,50,50,0,0,0,0");
		ptg_gridArea.setColAlign("left,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center");
		ptg_gridArea.setColTypes("tree,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
		ptg_gridArea.setColSorting("str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str");
		ptg_gridArea.setColumnHidden(10, true);
		ptg_gridArea.setColumnHidden(11, true);
		ptg_gridArea.setColumnHidden(12, true);
		ptg_gridArea.setColumnHidden(13, true);
		ptg_gridArea.setColumnHidden(14, true);
		ptg_gridArea.setColumnHidden(15, true);
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

		var itemID=ptg_gridArea.cells(id, 10).getValue();
		var identifier=ptg_gridArea.cells(id, 11).getValue();
		var authorId = ptg_gridArea.cells(id,13).getValue();
		var cnItemID=ptg_gridArea.cells(id, 14).getValue();
		var category=ptg_gridArea.cells(id, 15).getValue();

		if(ind !=0 && ind == 2) {
			if(authorId == "${sessionScope.loginInfo.sessionUserId}"){
				fnGoEditAttrPop(itemID,cnItemID);
			}
		}
		else if(ind != 0 && ind == 3) {
			fnSetLinkList(itemID,category);
		}
		else if(ind == 4 && ptg_gridArea.cells(id, ind).getValue() != "") {
			var type = "B0030001";
			fnGoLinkPopup(identifier,category,type);
		}
		else if(ind == 5 && ptg_gridArea.cells(id, ind).getValue() != "") {
			var type = "B0080002";
			fnGoLinkPopup(identifier,category,type);
		}
		else if(ind == 6 && ptg_gridArea.cells(id, ind).getValue() != "") {
			var type = "B0030004";
			fnGoLinkPopup(identifier,category,type);
		}
		else if(ind == 7 && ptg_gridArea.cells(id, ind).getValue() != "") {
			var type = "OTHER";
			fnGoLinkPopup(identifier,category,type);
		}
		else if(ind == 8 && ptg_gridArea.cells(id, ind).getValue() != "") {
			var type = "B0030012";
			fnGoLinkPopup(identifier,category,type);
		}
		else if(ind > 9 || ind < 1){
			if(itemID!=""&&itemID!=undefined){
				doPtgDetail(itemID);
			}
		}
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
	
	function fnUpdateCategory(cnt){
		var selectedTreeItemID = "${itemID}";
		var assignItems = $("#assignItems").val();
		if(Number(cnt) > 0){
			// Open  select Category popup
			var url = "/daelim/plant/zdaelim_jobAssignPop.do?selectedTreeItemID="+selectedTreeItemID+"&assignItems="+assignItems;
			window.open(url,'','width=900, height=400, left=200, top=100,scrollbar=yes,resizble=0');
		}else{
			// direct insert
			var url = "/daelim/plaint/zdaelim_assignJobDf.do";
			var data = "selectedTreeItemID="+selectedTreeItemID+"&assignItems="+assignItems;
			var target="blankFrame";
			ajaxPage(url, data, target);
		}
		
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
	
	// [Assign] click 이벤트	
	function assignOrg(){
		if (selectedItemBlocked == "0") {
			$("#newItemArea").attr("style", "display:none;");
			
			var connectionType = "To";
			if ("${isFromItem}" == "N") {
				connectionType = "From";
			}
			var url = "/daelim/plant/zdaelim_jobAssignTreePop.do";
			var data = "openMode=assign&ItemTypeCode=${ItemTypeCode}&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
						+"&selectedTreeItemID=${itemID}&option=${option}"
						+"&varFilter=${varFilter}&connectionType=" + connectionType;
			fnOpenLayerPopup(url,data,doCallBack,617,436);
			$('#popupDiv').hide();
		} else {
			if (selectedItemStatus == "REL") {
				alert("${WM00120}"); // [변경 요청 안된 상태]
			} else {
				alert("${WM00050}"); // [승인요청중]
			}
		}
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
	function linkLayerPopupView(sLinkName, top, left)  { 
		var nTop = top;
		var nLeft = left;
		var oPopup = document.getElementById(sLinkName);
		var scrollTop = document.getElementById("processDIV").scrollTop;
		oPopup.style.top = (nTop - 130) + "px";
		oPopup.style.left = nLeft +"px";
	} 
	
	function fnSetLinkList(itemID,plainText){
		var data="itemID="+itemID+"&plainText="+encodeURIComponent(plainText)+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		var returnData;
		var layerOpen = "Y";
		$.ajax({   
			url : "/daelim/getBPLinkList.do",     
			type: "POST",     
			data : data,
			beforeSend: function(x) {if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}	},
			success: function(returnData){
				var temp = returnData.split("/");
				var itemIDs = temp[0].split(",");
				var cnt = temp[1];
				
				if(cnt > 1) {
					fnGoBPListPop(itemIDs);
				}
				else if(cnt > 0)
					fnGoBPLink(itemIDs);
				
				
			},     
			error: function (jqXHR, textStatus, errorThrown)     {       }
			});
	}


	function fnGoLinkPopup(identifier,categoryCode,type){
		var data="identifier="+encodeURIComponent(identifier)+"&categoryCode="+categoryCode+"&refTypeCode="+type;
		var url = "/daelim/getLinkList.do?";
		var w = 1000;
		var h = 300;
		popupVal = window.open(url+data,"_blank","width="+w+",height="+h);
	}

	
	function fnGoBPListPop(itemID) {
		
		var url = "/daelim/goBPListPop";
			
		url = url+".do?itemID="+itemID;	
		
		var w = 800;
		var h = 300;
		popupVal = window.open(url,"_blank","width="+w+",height="+h);
	}
	
	function fnGoBPLink(itemID) {
		
		if(popupVal != null && popupVal != undefined)
			popupVal.close();
		
		var url = "/daelim/runBPPopup";
		p_itemID = parent.fnGetProjectItemID();	
		url = url+".do?itemID="+itemID+"&p_itemID="+p_itemID;	
		
		var nHeight = 800;
		var nWidth = 1250;
		var nScreenHeight = screen.availHeight;
		var nScreenWidth = screen.availWidth;
		var nLeft = (nScreenWidth - (nWidth)) / 2;
		var nTop = (nScreenHeight - (nHeight)) / 2;

		var sFeatures = 'height=' + nHeight + ',width=' + nWidth + ',left=' + nLeft + ',top=' + nTop + ',status=no,toolbar=no,menubar=no,location=no,scrollbars=yes';

		window.open(url,'_blank',sFeatures);
	}

	  
	function fnGoNewPopup(url) {
		if(popupVal != null && popupVal != undefined)
			popupVal.close();

		var nHeight = 800;
		var nWidth = 1250;
		var nScreenHeight = screen.availHeight;
		var nScreenWidth = screen.availWidth;
		var nLeft = (nScreenWidth - (nWidth)) / 2;
		var nTop = (nScreenHeight - (nHeight)) / 2;

		var sFeatures = 'height=' + nHeight + ',width=' + nWidth + ',left=' + nLeft + ',top=' + nTop + ',status=no,toolbar=no,menubar=no,location=no,scrollbars=yes';

		window.open(url,'_blank',sFeatures);
	}
	
	function fnGoVnEPopup(urlVal,parameter) {
		
		if(popupVal != null && popupVal != undefined)
			popupVal.close();
		
		var url = "/daelim/runVnEPopup";
		var nHeight = 800;
		var nWidth = 1250;
		var nScreenHeight = screen.availHeight;
		var nScreenWidth = screen.availWidth;
		var nLeft = (nScreenWidth - (nWidth)) / 2;
		var nTop = (nScreenHeight - (nHeight)) / 2;

		var sFeatures = 'height=' + nHeight + ',width=' + nWidth + ',left=' + nLeft + ',top=' + nTop + ',status=no,toolbar=no,menubar=no,location=no,scrollbars=yes';
			
		url = url+".do?url="+urlVal+"&parameter="+parameter;	

		window.open(url,'_blank',sFeatures);
	}

	
	function fnCloseItemTreePop(){
		$(".popup_div").hide();	
		$("#mask").hide();
	}
	
	function fnGoConnectionDelete(checkedItems){
		var url = "/daelim/plant/zdaelim_jobConnectionDel.do";
		var data = "itemIDs="+checkedItems;
		var target = "blankFrame";
		
		ajaxPage(url, data, target);	 
	}
	
	function fnUpdateCategorys(itemID,categoryCode){		
		var url = "/daelim/plant/updateJobCxnCategory.do";
		var data = "itemID="+itemID+"&lovCode="+categoryCode;
		var target = "blankFrame";
		
		ajaxPage(url, data, target);	 
	}


	function fnGoEditAttrPop(itemID,cnItemID) {
		var url = "/daelim/plant/editJobCxnCategoryPop.do?";
		var data = "itemID=" + itemID + "&cnItemID="+cnItemID; 
		var w = 600;
		var h = 400;
		popupVal = window.open(url+data,"_blank","width="+w+",height="+h);
	}
	
	function fnDownExcel(){
		ptg_gridArea.toExcel("${root}excelGenerate");
	}

</script>
<body>
<div id="processDIV">
<form name="JobFrm" id="JobFrm" action="" method="post" onsubmit="return false;">
<input type="hidden" id="assignItems" name="assignItems" >
	<div class="child_search_j" id="pertinentSearch">
		<ul>
			 <li class="shortcut">
			  <c:forEach var="itemInfo" items="${itemInfo}" varStatus="status">
			  	 <img src="${root}${HTML_IMG_DIR_ITEM}/${itemInfo.ItemTypeImg}" OnClick="fnOpenParentItemPop();" style="cursor:pointer;">&nbsp;${itemInfo.Path}/<b>${itemInfo.ItemName}</b> 
			  </c:forEach>	
			  </li>
			  <li class="floatL pdR5">
			  	<select id="departmentList" Name="departmentList" style="width:150px;height:17px;margin-top:-2px;" multiple="multiple">
					<option value="">ALL</option>
					<c:forEach var="i" items="${itemDepList}">
						<option value="${i.CODE}">${i.NAME}</option>						
					</c:forEach>
	       		</select>	
	       		<li class="floatL pdR5">
	       		<input type="text" id="dpName" name="dpName" value="${dpName}" style="width:150px;height:28px;margin-top:-2px;">
	       		</li>
	       		<li class="floatL pdR10" >
	       		<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/icon_search.png" value="Search" onclick="fnSearchList()" style="cursor:hand;"/>&nbsp;
				<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/icon_excel.png"  id="excel" value="excel" onclick="fnDownExcel()" style="cursor:hand;"/>
			</li>
			<li class="floatR pdR5" >
			<c:if test="${myItem == 'Y' || sessionScope.loginInfo.sessionAuthLev == 1}">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor' || sessionScope.loginInfo.sessionAuthLev == 1}">
					&nbsp;<span class="btn_pack small icon"><span class="assign"></span><input value="Assign" type="submit" onclick="assignOrg();"></span>
					&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDeleteJopCnx();"></span>
					
				</c:if>	
			</c:if>		
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
