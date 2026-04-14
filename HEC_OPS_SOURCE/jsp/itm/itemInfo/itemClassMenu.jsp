<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 <%@ page import="xbolt.cmm.framework.val.GlobalVal"%>  
 <%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<style>
#refresh:hover {
	cursor:pointer;
}
#itemNameAndPath, #functions{
	display:inline;
  	line-height: 23px;
}
</style>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00057" var="CM00057"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00042" var="CM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00061" var="CM00061" />
<script type="text/javascript">
	var height = 0;
	var checkOutFlag = "N";
	$(document).ready(function(){
		var topHeight = 5+$(".SubinfoTabs").height();
		height = document.body.clientHeight - topHeight - 60;
		$("#itemConWrapper").innerHeight(document.body.clientHeight - 55);
		
		window.onresize = function() {
			$("#digramFrame").attr("style", "display:block;height:"+getHeigth()+"px;border: 0;");
			$("#itemConWrapper").innerHeight(document.body.clientHeight - 55);
		}
	    
		var currIdx = "${currIdx}";
		if(currIdx == "" || currIdx == "undefined"){currIdx = "0";}
		
		var itemIDs = getCookie('itemIDs').split(','); 
	    fnOpenItems(currIdx,itemIDs);
	    
	});
	
	
	function fnGoBackNextPage(pID,preNext,currIdx){
		var itemId = pID;
		if(itemId=="" || itemId=="0"){return;}
		var option = "${option}";
		
		if(option != "") {
			parent.olm.menuTree.selectItem(itemId,false,false);
			parent.olm.getMenuUrl(itemId,preNext,currIdx);
		} 
	}
	
	function getHeigth(){
		var topHeight = 23+$(".SubinfoTabs").height();
		var height = document.body.clientHeight - topHeight-33;
		return height;
	}
	//ajax에서 페이지에 넘길 변수값들 지정
	function getData(avg, avg1, avg2){
		var Data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&s_itemID=${id}"
				//+"&modelID=${id}"
				+"&pop=${pop}"
				+"&width="+$("#actFrame").width()
				+"&getAuth=${sessionScope.loginInfo.sessionLogintype}"
				+"&userID=${sessionScope.loginInfo.sessionUserId}"
				+"&option=${option}"
				+"&MenuID="+avg2
				+ avg + "&fromModelYN=${fromModelYN}"
				+"&changeSetID=${changeSetID}"
				+"&showElement=${showElement}"
				+"&showTOJ=${showTOJ}"
				+"&tLink=${tLink}";
		
		// 테이불 TB_MENU_ALLOC 컬럼 Varfilter 내용 추가	
		if(avg1 != ''){
			Data = Data + "&varFilter=" + avg1;		
		}
		
		/* 하위 항목 이나 검색 화면에서 본 화면을 popup으로 표시 했을때 버튼 제어를 위해 screenMode 파라메터를 넘겨줌 */
		var screenMode = "${screenMode}";
		if (screenMode == 'pop') {
			Data = Data + "&screenMode=${screenMode}";		
		}
		return Data;
	}
	
	function setActFrame(avg, avg2, avg3, avg4,avg5){
		$("#url").val(avg);
		$("#sort").val(avg2);
		$("#menuFilter").val(avg3);
		$("#varFilter").val(avg4);
		$("#menuID").val(avg5);
		
		var browserType="";
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url = avg+".do";
		var data = getData(avg3, avg4,avg5);
		var target = "actFrame";
		var src = url +"?" + data+"&browserType="+browserType;
		var idx = (window.location.href).lastIndexOf('/');
		$("#clickedURL").val((window.location.href).substring(0,idx)+"/"+src);
		$("#actFrame").empty();
		if( avg == "newDiagramEditor" || avg == "newDiagramViewer" || avg == "modelView_H" || avg == "modelInfoMain"){
			//$("#digramFrame").attr("src", src);
			//document.digramFrame.location.replace  = src;
			document.getElementById('digramFrame').contentWindow.location.href= src; // firefox 호환성  location.href에서 변경
			$("#tabMenu").attr("style", "display:block;");
			$("#digramFrame").attr("style", "display:block;height:"+getHeigth()+"px;border: 0;");
			$("#actFrame").attr("style", "display:none;");
		} else {
			$("#tabMenu").attr("style", "display:block;");
			$("#digramFrame").attr("style", "display:none;");
			$("#actFrame").attr("style", "display:block;height:"+height+"px;");
			$("#actFrame").attr("style", "height:"+height+"px;");
			ajaxTabPage(url, data, target);
		}
	}
	var SubinfoTabsNum = 1; /* 처음 선택된 tab메뉴 ID값*/
	$(function(){
		$("#pli"+SubinfoTabsNum).addClass('on');
		
		$('.SubinfoTabs ul li').mouseover(function(){
// 			$(this).addClass('on');
		}).mouseout(function(){
// 			if($(this).attr('id').replace('pli', '') != SubinfoTabsNum) {
// 				$(this).removeClass('on');
// 			}
			$('#tempDiv').html('SubinfoTabsNum : ' + SubinfoTabsNum);
		}).click(function(){
			$(".SubinfoTabs ul li").removeClass("on"); //Remove any "active" class
			$(this).addClass('on');
			SubinfoTabsNum = $(this).attr('id').replace('pli', '');
		});
	});
	
	// 담당자 정보 표시
	function fnGetAuthorInfo(memberID){
		var url = "authorInfoPop.do?memberID="+memberID;		
		window.open(url,'window','width=302, height=235, left=800, top=300,scrollbar=yes,resizble=0');
		
	}
	
	function fnOpenParentItemPop(pID){// ParentItem Popup
		var itemId = pID;
		if(itemId=="" || itemId=="0"){return;}
		var option = "${option}";
		
		if(option != "") {
			parent.olm.menuTree.selectItem(itemId,false,false);
			parent.olm.getMenuUrl(itemId);
		} else {
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+pID+"&scrnType=pop&screenMode=pop";
			var w = 1200;
			var h = 900;
			itmInfoPopup(url,w,h,itemId);
		}
	}
	
	function fnItemMenuReload(){
		var scrnType = "${scrnType}";
		if(scrnType == "pop"){
			location.reload();
		}else{
			parent.olm.getMenuUrl('${s_itemID}');
		}
	}
	
	function fnMenuReload(){		
		var url = $("#url").val();
		var sort = $("#sort").val();
		var menuFilter = $("#menuFilter").val();
		var varFilter = $("#varFilter").val();
		var menuID = $("#menuID").val();
		setActFrame(url, sort, menuFilter, varFilter, menuID);
	}
	
	function fnGoReportList() {
		var url = "objectReportList.do";
		var target = "actFrame";
		var data = "s_itemID=${id}&option=${option}&kbn=newItemInfo"; 
	 	
		$("#tabMenu").attr("style", "display:none;");
	 	$("#digramFrame").attr("style", "display:none;");
		$("#actFrame").attr("style", "display:block;height:"+height+"px;");
		$("#actFrame").attr("style", "height:"+height+"px;");
		ajaxPage(url, data, target);
	}
	
	function fnGoChangeMgt() {
		var url = "itemHistory.do";
		var target = "actFrame";
		var data = "s_itemID=${id}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&myItem=${myItem}&itemStatus=${itemStatus}&backBtnYN=N";
		
		$("#tabMenu").attr("style", "display:none;");
	 	$("#digramFrame").attr("style", "display:none;");
		$("#actFrame").attr("style", "display:block;height:"+height+"px;");
		$("#actFrame").attr("style", "height:"+height+"px;");
		ajaxPage(url, data, target);
	}
	
	// [Check in] Click 
	function fnCheckInItem() {
		var items = "${id}";
		var cngts = "${itemInfo.CurChangeSet}";
		var pjtIds = "${itemInfo.ProjectID}";
		var url = "checkInItem.do";
		var data = "items=" + items + "&cngts=" + cngts + "&pjtIds=" + pjtIds;
		var target = "blankFrame";
		ajaxPage(url, data, target);
	}
	
	// [Check in] Click 
	function fnCommitItem() {
		var items = "${id}";
		var cngts = "${itemInfo.CurChangeSet}";
		var pjtIds = "${itemInfo.ProjectID}";
		var url = "cngCheckOutPop.do";
		var data = "?s_itemID=" + items + "&cngts=" + cngts + "&pjtIds=" + pjtIds + "&checkType=COMMIT";
		window.open(url+data,'',"width=350px, height=350px, left=200, top=100,scrollbar=yes,resizble=0");
	}
	
	function fnEditChangeSet(){
		var url = "editItemChangeInfo.do"
		var data = "?changeSetID=${itemInfo.CurChangeSet}&StatusCode=${StatusCode}"
			+ "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&mainMenu=${mainMenu}&seletedTreeId=${s_itemID}"
			+ "&isItemInfo=Y&screenMode=edit"
			+ "&isMyTask=Y";
		window.open(url+data,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizable=yes');
	}
	
	function fnSubscribe(){
		if(confirm("Do you really subscibe this item?")){
			var url = "saveRoleAssignment.do";
			var data = "itemID=${s_itemID}&assignmentType=SUBSCR&accessRight=R&assigned=1&memberID=${sessionScope.loginInfo.sessionUserId}&seq=";
			var target = "blankFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnUnsubscribe(){
		if(confirm("Do you really unsubscibe this item?")){
			var url = "deleteRoleAssignment.do";
			var data = "seqArr=${myItemSeq}";
			var target = "blankFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnQuickCheckOut(){
		var projectNameList = "${projectNameList}";
		
		if(checkOutFlag == "N") {
			if(parseInt(projectNameList)>0){
				dhtmlx.confirm({
					ok: "Yes", cancel: "No",
					text: "${CM00042}",
					width: "310px",
					callback: function(result){
						if(result){
							var url = "cngCheckOutPop.do?";
							var data = "s_itemID=${s_itemID}";
						 	var target = self;
						 	var option = "width=350px, height=350px, left=200, top=100,scrollbar=yes,resizble=0";
						 	window.open(url+data, 'CheckOut', option);
						 	checkOutFlag = "Y";
						}
					}		
				});	
			}else{
				if(confirm("${CM00057}")){
					//var url = "csrDetailPop.do?isNew=Y&quickCheckOut=Y&itemID=${s_itemID}";	
					var url = "registerCSR.do?quickCheckOut=Y&itemID=${s_itemID}";
					window.open(url,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizble=0');
				} 
			}			
		}
		else {
			//alert(""); --> Edit Start 진행 도중 재 클릭 하였을 시 노출 시킬 경고 메시지를 추가 할 경우 해당 주석을 제거 후 메시지 추가
		}
	}

	function fnCallBack(checkInOption){
		if(checkInOption == "03" || checkInOption == "03A"){
			dhtmlx.confirm({
				ok: "Yes", cancel: "No",
				text: "${CM00061}",
				width: "310px",
				callback: function(result){					
					if(result){
						goApprovalPop();
					}
					fnItemMenuReload();	
				}		
			});
		}else{
			fnItemMenuReload();	
		}
	}
	
	function goApprovalPop() {
		var url = "${wfURL}.do?";
		var data = "isPop=Y&changeSetID=${itemInfo.CurChangeSet}&isMulti=N&wfDocType=CS";
				
		var w = 1200;
		var h = 550; 
		itmInfoPopup(url+data,w,h);
	}
		
	function thisReload() {
		fnItemMenuReload();
	}

	function fnCngCallBack() {
		fnItemMenuReload();
	}
	
	function fnReload() {
		fnItemMenuReload();
	}

	function fnChangeOpinion() {
		var url = "ispList.do";
		var target = "actFrame";
		var data = "srType=${srType}&itemID=${s_itemID}"; 
		height = height + 50;
		
		$("#tabMenu").attr("style", "display:none;");
	 	$("#digramFrame").attr("style", "display:none;");
		$("#actFrame").attr("style", "display:block;height:"+height+"px;width:100%;");
		ajaxPage(url, data, target);
	}
	
	function fnGetProjectItemID() {
		var p_itemID =  "${id}";
		return p_itemID;
	}
	
	function fnTLink(itemID, refresh){
		parent.fnRefreshTree(itemID, refresh);
	}
	
</script>

<input type="text" id="clickedURL" style="width:800px;display:none;">
<input type="text" id="url" style="display:none;">
<input type="text" id="sort"  style="display:none;">
<input type="text" id="menuFilter" style="display:none;">
<input type="text" id="varFilter" style="display:none;">
<input type="text" id="menuID" style="display:none;">
<input type="text" id="itemMenu" value="itemMenu" style="display:none;">
<input type="hidden" id="currIdx" value="">
<input type="hidden" id="openItemList" value="">

<div class="pdL10 pdT10" id="titWrap" style="width:98%;">
	<ul>
		<li>
			<c:if test="${showPreNextIcon eq 'Y'}" >
			<div id="openItemsli" style="font-family:arial;" class="floatL">
				<span id="preAbl" name="preAbl"><img style="cursor:auto;" src="${root}cmm/common/images/icon_back_btn.png" width="26" height="24" OnClick="fnGoBackItem();"></span>
				<span id="preDis" name="preDis" disabled=true><img style="cursor:auto;" src="${root}cmm/common/images/icon_back_btn_.png" width="26" height="24"></span>
				<input type="hidden" id="openItemName" name="openItemName" size="8">	
				<input type="hidden" id="openItemID" name="openItemID" size="8">		
				<span id="nextAbl" name="nextAbl" ><img style="cursor:auto;" src="${root}cmm/common/images/icon_next_btn.png"  width="26" height="24" OnClick="fnGoNextItem();"></span>	
				<span id="nextDis" name="nextDis"><img style="cursor:auto;" src="${root}cmm/common/images//icon_next_btn_.png"  width="26" height="24"></span>	
			</div>&nbsp;
			</c:if>
		<div id="itemNameAndPath">
		<c:choose>
	   		<c:when test="${itemInfo.CategoryCode eq 'MCN' || itemInfo.CategoryCode eq 'CN' || itemInfo.CategoryCode eq 'CN1' }" >
	   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${itemInfo.FromItemTypeImg}" OnClick="fnOpenParentItemPop('${parentItemID}');" style="cursor:pointer;vertical-align: text-top !important;">&nbsp;${itemInfo.FromItemName}
	   		 --> 
	   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${itemInfo.ToItemTypeImg}" OnClick="fnOpenParentItemPop('${parentItemID}');" style="cursor:pointer;vertical-align: text-top !important;">&nbsp;${itemInfo.ToItemName}
			 <c:if test="${itemInfo.ItemName ne '' && prcList.ItemName != null}">/<font color="#3333FF"><b>${itemInfo.ItemName}</b></font> </c:if>
	   		</c:when>
	   		<c:otherwise>
	   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${itemInfo.ItemTypeImg}" OnClick="fnOpenParentItemPop('${parentItemID}');" style="cursor:pointer;vertical-align: text-top !important;">
			  	<font color="#3333FF"><b style="font-size:13px;">${itemInfo.Identifier}&nbsp;${itemInfo.ItemName}</b></font>&nbsp;
			  		   	
				<c:forEach var="path" items="${itemPath}" varStatus="status">
				
					<c:choose>
						<c:when test="${status.first}">
						(<span style="cursor:pointer" OnClick="fnOpenParentItemPop('${path.itemID}');" >${path.PlainText}</span>
						</c:when>
						<c:when test="${status.last}">
						>&nbsp;<span style="cursor:pointer" OnClick="fnOpenParentItemPop('${path.itemID}');" >${path.PlainText}</span>
						</c:when>
						<c:otherwise>>&nbsp;<span style="cursor:pointer" OnClick="fnOpenParentItemPop('${path.itemID}');" >${path.PlainText}</span></c:otherwise>
					</c:choose>
					
					
				</c:forEach>		  	
			  	<c:if test="${itemPath != null && itemPath.size() > 0 }">)</c:if>
	   		</c:otherwise>
	   	</c:choose>
	   	</div>
	   	&nbsp;
			<div id="functions">
			<c:choose>
		   		<c:when test="${itemInfo.SubscrOption eq '1' && myItem ne 'Y' && myItemCNT eq '0' && quickCheckOut ne 'Y'}"  >
        			 <span class="btn_pack small icon"><span class="unsubscribe"></span><input value="Subscribe" type="button" onclick="fnSubscribe()"></span>
		   		</c:when>
		   		<c:when test="${myItem ne 'Y' && myItemCNT ne '0' && quickCheckOut ne 'Y' }"  >
        			 <span class="btn_pack small icon"><span class="subscribe"></span><input value="Unsubscribe" type="button" onclick="fnUnsubscribe()"></span>
		   		</c:when>
	   		</c:choose>			   		
		        <span class="btn_pack small icon"><span class="report"></span><input value="Report" type="button" onclick="fnGoReportList()"></span>
	        <c:if test="${itemInfo.ChangeMgt eq '1'}">
		  		 <span class="btn_pack small icon"><span class="cs"></span><input value="History" type="button" onclick="fnGoChangeMgt()"></span>
		  	</c:if>
		  	<c:if test="${srType != null && srType != ''}" >
		  		<span class="btn_pack small icon"><span class="isp"></span><input value="Q&A" type="button" onclick="fnChangeOpinion()"></span>
		  	</c:if>
	   		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor' and quickCheckOut eq 'Y' and itemInfo.Status eq 'REL' && itemInfo.CheckOutOption ne '02'}" >
   				<span class="btn_pack small icon"><span class="checkout"></span><input value="Check Out" type="button" onclick="fnQuickCheckOut()"></span>
	   		</c:if>	   		
		   	<c:if test="${itemInfo.ChangeMgt eq '1' && itemInfo.Blocked ne '2' && (sessionScope.loginInfo.sessionUserId eq itemInfo.AuthorID || sessionScope.loginInfo.sessionAuthLev eq '1') && (itemInfo.Status eq 'NEW1' || itemInfo.Status eq 'MOD1' || itemInfo.Status eq 'DEL1') && itemInfo.CheckInOption ne '03A' && itemInfo.CheckOutOption ne '02'}" >
	   			<span class="btn_pack small icon"><span class="checkin"></span><input value="Check In" type="button" onclick="fnEditChangeSet()"></span>
	   		</c:if>
		  	<c:if test="${itemInfo.ChangeMgt eq '1' && itemInfo.Blocked ne '2' && (sessionScope.loginInfo.sessionUserId eq itemInfo.AuthorID || sessionScope.loginInfo.sessionAuthLev eq '1') && (itemInfo.Status eq 'NEW1' || itemInfo.Status eq 'MOD1' || itemInfo.Status eq 'DEL1') && itemInfo.CheckInOption eq '03A' && itemInfo.CheckOutOption ne '02'}" >
		   		<span class="btn_pack small icon"><span class="checkin"></span><input value="Complete" type="button" onclick="fnCheckInItem()"></span>
	   		</c:if>
	   		<c:if test="${itemInfo.ChangeMgt eq '1' && myItem eq 'Y' && itemInfo.CheckOutOption eq '02'}" >
	   			<span class="btn_pack small icon"><span class="checkin"></span><input value="Commit" type="button" onclick="fnCommitItem()"></span>
	   		</c:if>
	   		<span class="btn_pack medium icon"><span class="reload"></span><input value="Reload" type="button" onclick="fnMenuReload()"></span>
	   		</div>
	   		<div class="floatR">
				<ul>
					<li  id="memberPhotoArea" style="font-family:arial;cursor:pointer;">
						<c:if test="${empPhotoItemDisPlay ne 'N' && roleAssignMemberList.size() > 0 }" >		   	
							<c:forEach var="author" items="${roleAssignMemberList}" varStatus="status">
							 <span id="authorInfo${status.index}" name="authorInfo${status.index}" ><img src="${author.Photo}" width="26" height="24" OnClick="fnGetAuthorInfo('${author.MemberID}');"></span>
							</c:forEach>
						</c:if>
						
					</li> 
				</ul>
			</div> 
	   	</li>
	</ul>
</div>

<div id="itemConWrapper">
	
	<div id="tabMenu" class="SubinfoTabs mgL10 mgR10">
		<ul>
			<c:set value="1" var="tabNum" />
			<c:forEach var="i" items="${getList}" varStatus="status" >
				<li id="pli${tabNum}" onclick="setActFrame('${i.URL}', ${i.Sort}, '${i.MenuFilter}', '${i.VarFilter}', '${i.MenuID}') "><a><span>${i.Name} ${BASE_ATCH_URL }</span></a></li>
			<c:set var="tabNum" value="${tabNum+1}"/>
			</c:forEach>
		</ul>
	</div>
	
	<div class="pdL10 pdR10">
	<div id="actFrame" style="width:100%;overflow:auto; overflow-x:hidden; padding:0 0 17px 0;" ></div>
	
	<iframe width="100%" frameborder="0" scrolling="no" style="display:none;border: 0;overflow:auto; padding:0 0 17px 0;" name="digramFrame" id="digramFrame"></iframe>
	<form style="border: 0" name="subFrame" id="subFrame"></form>
	
	<c:forEach var="i" items="${getList}" varStatus="status" >
		<c:if test="${status.count == '1' }" >
			<script>
			setActFrame('<c:out value="${i.URL}" />', <c:out value="${i.Sort}" />, '<c:out value="${i.MenuFilter}" />', '${i.VarFilter}', '<c:out value="${i.MenuID}" />');
			</script>	
		</c:if>
	</c:forEach>
	</div>
</div>
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>

