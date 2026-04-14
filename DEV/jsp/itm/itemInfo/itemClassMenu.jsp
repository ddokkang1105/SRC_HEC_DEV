<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 <%@ page import="xbolt.cmm.framework.val.GlobalVal"%>  
 <%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %> 
<!DOCTYPE html>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00059" var="CM00059" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00003" var="WM00003"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00191" var="WM00191" />

<script type="text/javascript">
	var height = 0;
	var checkOutFlag = "N";
	$(document).ready(function(){
		
		var topHeight = 5+$(".SubinfoTabs").height();
		height = document.body.clientHeight - topHeight - 53;
		$("#itemConWrapper").innerHeight(document.body.clientHeight - 55);
		
		window.onresize = function() {
// 			$("#digramFrame").attr("style", "display:block;height:"+getHeigth()+"px;border: 0;");
			$("#itemConWrapper").innerHeight(document.body.clientHeight - 55);
		}
	    
		var currIdx = "${currIdx}";
		if(currIdx == "" || currIdx == "undefined"){currIdx = "0";}
		
		if(getCookie('itemIDs')) {
			var itemIDs = getCookie('itemIDs').split(',');
			fnOpenItems(currIdx,itemIDs);
		}
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
		var languageID = "${languageID}";
		if(languageID == ""){
			languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
		}		
		
		var Data = "languageID="+languageID
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
				+"&showTOJ=${showTOJ}"
				+"&tLink=${tLink}"
				+"&accMode=${accMode}"
				+"&loadEdit=${loadEdit}"
				+"&showLink=${showLink}"
				+"&myCSR=${myCSR}"
				+"&csrIDs=${csrIDs}"
				+"&udfSTR=${udfSTR}"
				+"&focusedObjID=${focusedObjID}";
			//	+"&dbFuncCode=${dbFuncCode}";
		
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
	
	function setActFrame(avg, avg2, avg3, avg4, avg5, avg6){
		$("#url").val(avg);
		$("#sort").val(avg2);
		$("#menuFilter").val(avg3);
		$("#varFilter").val(avg4);
		$("#menuID").val(avg5);
		$("#menuType").val(avg6);
		if(height == 0){
			var topHeight = 5+$(".SubinfoTabs").height();height = document.body.clientHeight - topHeight - 53;
		}
		var browserType="";
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url = avg+".do";
		var data = getData(avg3, avg4, avg5, avg6);
		var target = "actFrame";
		var src = url +"?" + data+"&browserType="+browserType;
		var idx = (window.location.href).lastIndexOf('/');
		$("#clickedURL").val((window.location.href).substring(0,idx)+"/"+src);
		$("#actFrame").empty();
		
		//if( avg == "newDiagramEditor" || avg == "newDiagramViewer" || avg == "modelView_H" || avg == "modelInfoMain" || avg == "rnrMatrix"  || avg == "editChildItemAttrList" ){
		if( avg6 == "01" ){ // menuType:01 
			openMaskLayer();		
			document.getElementById('digramFrame').contentWindow.location.href= src; // firefox 호환성  location.href에서 변경
			$("#tabMenu").attr("style", "display:block;");
			$("#digramFrame").attr("style", "display:block;height:"+getHeigth()+"px;border: 0;");
			$("#actFrame").attr("style", "display:none;");
		} else {
			$("#tabMenu").attr("style", "display:block;");
			$("#digramFrame").attr("style", "display:none;");
			$("#actFrame").attr("style", "display:block;height:"+height+"px;");
			$("#actFrame").attr("style", "height:"+height+"px;overflow: hidden auto;");
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
		var url = "viewMbrInfo.do?memberID="+memberID;		
		window.open(url,'window','width=1200, height=700, left=400, top=100,scrollbar=yes,resizble=0');
	}
	
	function fnOpenParentItemPop(pID){// ParentItem Popup
		var itemId = pID;
		if(itemId=="" || itemId=="0"){return;}
		var option = "${option}";
		
		if(option != "" && "${pop}" != "pop") {
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
	
	function fnRoleCallBack(){
		fnItemMenuReload();
	} 
	
	function fnMenuReload(){		
		var url = $("#url").val();
		var sort = $("#sort").val();
		var menuFilter = $("#menuFilter").val();
		var varFilter = $("#varFilter").val();
		var menuID = $("#menuID").val();
		var menuType = $("#menuType").val();
		setActFrame(url, sort, menuFilter, varFilter, menuID, menuType);
	}
	
	function fnGoReportList() {
		var url = "objectReportList.do";
		var target = "actFrame";
		var data = "s_itemID=${id}&option=${option}&kbn=newItemInfo&scrnType=${scrnType}&accMode=${accMode}&defDimValueID=${defDimValueID}"; 
	 	
		$("#tabMenu").attr("style", "display:none;");
	 	$("#digramFrame").attr("style", "display:none;");
		$("#actFrame").attr("style", "display:block;height:"+(height+60)+"px;");
		ajaxPage(url, data, target);
	}
	
	function fnGoChangeMgt() {
		var url = "itemHistoryV4.do";
		var target = "actFrame";
		var data = "s_itemID=${id}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&myItem=${myItem}&itemStatus=${itemStatus}&backBtnYN=N";
		
		$("#tabMenu").attr("style", "display:none;");
	 	$("#digramFrame").attr("style", "display:none;");
		$("#actFrame").attr("style", "display:block;height:"+(height+60)+"px;");
		ajaxPage(url, data, target);
	}
	
	// [Check in] Click 
	function fnCheckInItem() {
		fetch("checkInPassCheck.do?itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&sessionCurrLangCode=${sessionScope.loginInfo.sessionCurrLangCode}&cngts=${itemInfo.CurChangeSet}")
		.then(res => res.json())
		.then(res => {
			if(res.message) {
				alert(res.message);
				return;
			} else {
			    dhx.confirm({
			        text: "${CM00042}",
			        buttons: ["No", "Yes"],
			        css: "align-center"
			    }).then(function (result) {
			    	if(result){
						var items = "${id}";
						var cngts = "${itemInfo.CurChangeSet}";
						var pjtIds = "${itemInfo.ProjectID}";
						var url = "checkInMgt.do";
						var data = "items=" + items + "&cngts=" + cngts + "&pjtIds=" + pjtIds;
						var target = "blankFrame";
						ajaxPage(url, data, target);
					}
			    });
			}
		});
	}
	
	// [Check in] Click 
	function fnCommitItem() {
		var items = "${id}";
		var cngts = "${itemInfo.CurChangeSet}";
		var pjtIds = "${itemInfo.ProjectID}";
		var url = "cngCheckOutPop.do";
		var data = "?s_itemID=" + items + "&cngts=" + cngts + "&pjtIds=" + pjtIds + "&checkType=COMMIT&status=${itemInfo.Status}";
		window.open(url+data,'',"width=500px, height=350px, left=200, top=100,scrollbar=yes,resizble=0");
	}
	
	function fnEditChangeSetClsMn(){
		var url = "editItemCSInfo.do"
		var data = "?changeSetID=${itemInfo.CurChangeSet}&StatusCode=${StatusCode}"
			+ "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&mainMenu=${mainMenu}&seletedTreeId=${s_itemID}"
			+ "&isItemInfo=Y&screenMode=edit"
			+ "&isMyTask=Y&scrnType=${scrnType}"
			+ "&checkInOption=${itemInfo.CheckInOption}";
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
	
	
	function fnQuickCheckOut(avg){
	
		var changeType = avg;		
		if(checkOutFlag == "N") {
				dhx.confirm({
					text: "${CM00042}",
					buttons: ["No", "Yes"],
					css: "align-center"
				}).then(function(result) {
					if (result) {
						// 사이즈 확인용 fetch
						fetch("getMyCSRCount.do", {
							method: "POST",
							headers: {
								"Content-Type": "application/x-www-form-urlencoded",
								"Accept": "application/json"
							},
							body: new URLSearchParams({
								s_itemID: "${s_itemID}"
							})
						})
						.then(res => res.json())
						.then(data => {
							const info = data.dataInfo;
							
							if (info.size < 2) {
								// 팝업 없이 호출
								fetch("checkOutItem.do", {
									method: "POST",
									headers: { "Content-Type": "application/x-www-form-urlencoded" },
									body: new URLSearchParams({
										itemIds: "${s_itemID}",
										projectID: info.projectID,
										childLevel: 1,
										changeType: changeType,
									})
								})
								.then(res => res.text())
								.then(() => {
									alert("${WM00067}");
									fnItemMenuReload();
								})
								.catch(err => {
									console.error("체크아웃 오류:", err);
									alert("체크아웃 중 오류 발생");
								});
							} else {
								// DHTMLX Suite 9 Window 컴포넌트 사용
// 								const window = new dhx.Window({
// 									width: 500,
// 									height: 350,
// 									modal: true, // 기존 팝업처럼 모달로 설정
// 									title: "CheckOut",
// 									html: `<iframe src="cngCheckOutPop.do?s_itemID=${s_itemID}&changeType=${changeType}" style="width:100%; height:100%; border:none;"></iframe>`
// 								});
								
// 								window.show();
// 								checkOutFlag = "Y";
								
								//  기존 팝업 방식
								var url = "cngCheckOutPop.do?";
								var data = "&s_itemID=${s_itemID}&changeType=" + changeType;
								var option = "width=500px, height=350px, left=200, top=100,scrollbar=yes,resizble=0";
								window.open(url + data, 'CheckOut', option);
								checkOutFlag = "Y";
							}
						})
						.catch(error => {
							alert("프로젝트 조회 중 오류 발생");
							console.error(error);
						});
					}
				});
			
		}
		else {
			alert("WM00003"); 
		}
	}
	 
	
	function fnCallBack(checkInOption){
		if(checkInOption == "03" || checkInOption == "03A" || checkInOption == "03B"){
			//dhtmlx.confirm({
			//	ok: "Yes", cancel: "No",
			//	text: "${CM00061}",
			//	width: "310px",
			//	callback: function(result){					
			//		if(result){
						goApprovalPop();
					//}
					fnItemMenuReload();	
			//	}		
			//});
		}else{
			fnItemMenuReload();	
		}
	}
	
	function fnUpdateItemDeleted() {
		
		if(confirm("${CM00042}")){
			ajaxPage("deleteItem.do", "&s_itemID=${s_itemID}", "saveFrame");
			// insertVisitLog
			ajaxPage("setVisitLog.do", "ActionType=RPT&MenuID=RP00035&ItemId=${s_itemID}", "saveFrame");
		}
	}
	
	// call back - fnUpdateItemDeleted
	function doCallBack() {
		
	  
	  //fnGoBackItem()();
		parent.fnRefreshTree('${parentItemID}',true);
	
	}
	
	function goList(){
	 	var url = "zSKON_searchPrcList.do";
		var data = "&url=/custom/sk/skon/item/process/searchProcessList&defClassList=CL01005,CL01005A,CL01006A,CL01006B"
			+"&defDimValueID=${defDimValueID}&itemID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
		
		
		ajaxPage(url, data, "blankFrame"); 
		//fnItemMenuReload();
	}
	function goApprovalPop() {
		 var wfFrame = document.wfFrame;
		 var url = "${wfURL}.do";
		 
		 window.open("" ,"${wfURL}", "width=1200, height=750, left=400, top=200"); 
		 wfFrame.action =url;
		 wfFrame.method="post";
		 wfFrame.target="${wfURL}";
		 wfFrame.isPop.value = "Y";
		 wfFrame.changeSetID.value = "${itemInfo.CurChangeSet}";
		 wfFrame.isMulti.value = "N";
		 wfFrame.wfDocType.value = "CS";
		 wfFrame.docSubClass.value = "${itemInfo.ClassCode}";
		 wfFrame.submit();
	}
		
	function thisReload() {
		alert("${WM00067}");
	
		fnItemMenuReload();
	}

	function fnCngCallBack() {
		fnItemMenuReload();
	}
	
	function fnReload() {
		fnItemMenuReload();
	}

	function fnViewReload() {
		
		fnItemMenuReload();
	}
	
	
	function fnGetProjectItemID() {
		var p_itemID =  "${id}";
		return p_itemID;
	}
	
	function fnTLink(itemID, refresh){
		parent.fnRefreshTree(itemID, refresh);
	}
	
	function fnTransferItem(){		
		var w = 550;
		var h = 350;
		var url = "selectOwnerPop.do";
		var data = "items=${s_itemID}&authorID=${sessionScope.loginInfo.sessionUserId}&authorName=${sessionScope.loginInfo.sessionUserNm}&myTransfer=Y";
		window.open(url+"?"+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}

	//담당자 변경 
	function editAuthor(){
		var w = 550;
		var h = 350;
		var url = "selectOwnerPop.do";
		var data = "items=${s_itemID}&hideOption=Y&mailNotice=Y";
		window.open(url+"?"+data, "", "width="+w+", height="+h+", top=300,left=300,resizable=0,scrollbars=yes");
	}
	
	// [Rework] click
	function rework() {
		if (confirm("${CM00059}")) {
			var url = "rework.do";
			var data = "item=${itemInfo.ItemID}&cngt=${itemInfo.CurChangeSet}&pjtId=${itemInfo.ProjectID}"; 
			
			$.ajax({
				url: url,
				type: 'post',
				data: data,
				async: true,
				success: function(data){
					fnItemMenuReload();
				}
			});
		}
	}
	
	
	// model side bar dimension option call function -> viewModel.fnReloadModelFilter
	function fnReloadModelFilter(opacityList, itemTypeCodeList, blurredList, dimTypeID, dimValueList, symTypeCodeList){
		$('#digramFrame').get(0).contentWindow.fnReloadModelFilter(opacityList, itemTypeCodeList, blurredList, dimTypeID, dimValueList, symTypeCodeList);
	}
	
	// [결재 취소] click
	function withdrawAprvReq() {
		if (confirm("결재 취소하시겠습니까?")) {
			var url = "rework.do";
			var data = "item=${itemInfo.ItemID}&cngt=${itemInfo.CurChangeSet}&pjtId=${itemInfo.ProjectID}"; 
			
			$.ajax({
				url: url,
				type: 'post',
				data: data,
				async: true,
				success: function(data){
					fnItemMenuReload();
				}
			});
		}
	}
	
</script>

<input type="hidden" id="clickedURL" >
<input type="hidden" id="url">
<input type="hidden" id="sort">
<input type="hidden" id="menuFilter">
<input type="hidden" id="varFilter">
<input type="hidden" id="menuID">
<input type="hidden" id="menuType">
<input type="hidden" id="itemMenu" value="itemMenu">
<input type="hidden" id="currIdx" value="">
<input type="hidden" id="openItemList" value=""> 
<form name ="wfFrame" >
	<input type="hidden" id="isPop" name="isPop" value="">
	<input type="hidden" id="changeSetID" name="changeSetID" value="" />
	<input type="hidden" id="isMulti" name="isMulti" value="" />
	<input type="hidden" id="wfDocType" name="wfDocType" value="" />
	<input type="hidden" id="docSubClass" name="docSubClass" value="" />
</form>
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
	   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${itemInfo.FromItemTypeImg}" OnClick="fnOpenParentItemPop('${itemInfo.CxnFromItemID}');" style="cursor:pointer;vertical-align: text-top !important;">&nbsp;${itemInfo.FromItemName}
	   		 --> 
	   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${itemInfo.ToItemTypeImg}" OnClick="fnOpenParentItemPop('${itemInfo.CxnToItemID}');" style="cursor:pointer;vertical-align: text-top !important;">&nbsp;${itemInfo.ToItemName}
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
		   		<c:when test="${itemInfo.SubscrOption eq '1' && myItem ne 'Y' && myItemCNT eq '0'}"  >
        			 <span class="btn_pack small icon"><span class="unsubscribe"></span><input value="subscribe" type="button" onclick="fnSubscribe()"></span>
		   		</c:when>
		   		<c:when test="${myItem ne 'Y' && myItemCNT ne '0'}"  >
        			 <span class="btn_pack small icon"><span class="subscribe"></span><input value="unsubscribe" type="button" onclick="fnUnsubscribe()"></span>
		   		</c:when>
	   		</c:choose>
		    <span class="btn_pack small icon"><span class="report"></span><input value="Report" type="button" onclick="fnGoReportList()"></span>
	       <c:if test="${itemInfo.ChangeMgt eq '1'}">
		  	    <span class="btn_pack small icon"><span class="cs"></span><input value="History" type="button" onclick="fnGoChangeMgt()"></span>			
			   <c:if test="${scrnType ne 'pop' && accMode ne 'OPS'}">
					    <!-- Check Out 일반 -->
				  	 	<c:if test="${quickCheckOut eq 'Y' && itemInfo.Deleted ne '1' && itemInfo.CheckInOption ne '00'}" > 
			   				<span class="btn_pack small icon"><span class="checkout"></span><input value="Check Out" type="button" onclick="fnQuickCheckOut('')"></span>
				        </c:if> 
				        <!-- 폐기 결재  Check out >> Check In , Change Type = DEL  >> Approval Request -->
				   		<c:if test="${quickCheckOut eq 'Y' && itemInfo.Deleted ne '1' && itemInfo.CheckInOption eq '03A' }" >
				   			<span class="btn_pack medium icon"><span class="delete"></span><input value="폐기" type="button" onclick="fnQuickCheckOut('DEL')"></span>		   			
						</c:if>		
						<!-- 신규 Item 삭제 -->
						<c:if test="${itemInfo.Blocked eq '0' && itemInfo.Status eq 'NEW1' &&  myItem eq 'Y' }" >
							<span class="btn_pack medium icon"> <span class="delete"></span><input value="Delete" type="button" onclick="fnUpdateItemDeleted()"></span> 								
						</c:if>    		      
				        <!-- Commit Check In Option = 00-->
						<c:if test="${ myItem eq 'Y' && itemInfo.CheckInOption eq '00' && itemInfo.Blocked eq '0' }" >
				   			<span class="btn_pack small icon"><span class="checkin"></span><input value="Commit" type="button" onclick="fnCommitItem()"></span>
				   		</c:if>	
				  </c:if> 					   				  		
		 	  </c:if>
        		 		
		    <c:if test="${scrnType ne 'pop' && accMode ne 'OPS' && (sessionScope.loginInfo.sessionUserId eq itemInfo.AuthorID || sessionScope.loginInfo.sessionAuthLev eq '1')  && itemInfo.ChangeMgt eq '1'}" >	
							
			   <!-- Check In  Only Check In Option = 01 , 02, 03 03B -->
				<c:if test="${itemInfo.Blocked eq '0' && itemInfo.CheckInOption ne '03A' && itemInfo.CheckInOption ne '00'}" >
	   		 		<span class="btn_pack small icon"><span class="checkin"></span><input value="Check In" type="button" onclick="fnEditChangeSetClsMn()"></span>
		   		</c:if>		
		   		<!-- Check In  >> 결재상신  -->
				<c:if test="${itemInfo.Blocked eq '0' && itemInfo.CheckInOption eq '03A'}" >
				   	<span class="btn_pack small icon"><span class="checkin"></span><input value="App. Request" type="button" onclick="fnCheckInItem()"></span>
				</c:if>
			   	<!-- 변경 담당자 Rework -->				       
               		 <!-- 1) Check in 후 상신 전인 경우 -->
                <c:if test="${itemInfo.CSStatus == 'CMP'}" >
                  &nbsp;<span class="btn_pack medium icon"><span class="confirm"></span><input value="Rework" onclick="rework()" type="submit"></span>  
        		</c:if>	
        			<!-- 2) CS 결재 반려된 경우 -->
        		<c:if test="${itemInfo.WFInstanceID != ''  && itemInfo.WFStatus != '0' && itemInfo.CSStatus == 'HOLD'}" >
        		 <span class="btn_pack medium icon"><span class="confirm"></span><input value="Rework" onclick="rework()" type="submit"></span> 
        		</c:if>    
        		<!-- CS 결재 상신 후 결재 취소 -->
				<c:if test="${itemInfo.WFInstanceID != ''  && itemInfo.WFStatus eq '1' && itemInfo.CSStatus == 'APRV' && wfInstanceON eq 'N' }" >
				  &nbsp;<span class="btn_pack medium icon"><span class="confirm"></span><input value="Withdraw App. Request" onclick="withdrawAprvReq()" type="submit"></span> 					     
				</c:if>      		
			</c:if>
	   		
	   		<span class="btn_pack medium icon"><span class="reload"></span><input value="Reload" type="button" onclick="fnMenuReload()"></span>
	   	 	<c:if test="${checkItemAuthorTransferable eq 'Y'}" >
	   			<span class="btn_pack small icon"><span class="gov"></span><input value="Transfer" type="button" onclick="fnTransferItem()"></span>
	   		</c:if>
	   		<!-- 담당자 변경 추가  -->
	   		 <c:if test="${myItem eq 'Y'}" >
	   			<span class="btn_pack small icon"><span class="gov"></span><input value="Transfer" type="button" onclick="editAuthor()"></span>
	   		</c:if>
	   		</div>
	   		<div class="floatR">
				<ul>
					<li id="memberPhotoArea" style="font-family:arial;cursor:pointer;">
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
				<li id="pli${tabNum}" onclick="setActFrame('${i.URL}', ${i.Sort}, '${i.MenuFilter}', '${i.VarFilter}', '${i.MenuID}', '${i.MenuType}') "><a><span>${i.Name} ${BASE_ATCH_URL }</span></a></li>
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
			setActFrame('<c:out value="${i.URL}" />', <c:out value="${i.Sort}" />, '<c:out value="${i.MenuFilter}" />', '${i.VarFilter}', '<c:out value="${i.MenuID}" />', '<c:out value="${i.MenuType}" />');
			</script>	
		</c:if>
	</c:forEach>
	</div>
</div>
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
