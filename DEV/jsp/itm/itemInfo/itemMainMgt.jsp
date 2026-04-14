<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 <%@ page import="xbolt.cmm.framework.val.GlobalVal"%>  
 <%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %> 
<!DOCTYPE html>

<title><c:if test="${!empty htmlTitle}">${htmlTitle}</c:if></title>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00057" var="CM00057"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00042" var="CM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00061" var="CM00061" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00059" var="CM00059" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00003" var="WM00003"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00191" var="WM00191" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033"/>

<script type="text/javascript">
	var height = 0;
	var checkOutFlag = "N";
	var languageID = `${languageID}`;
	var s_itemID = `${s_itemID}`;
	var changeSetID = `${changeSetID}`;
	var accMode = `${accMode}`;
	
	// popup parameter
	var scrnType = `${scrnType}`;
	var screenMode=`${screenMode}`;
	var MTCategory=`${MTCategory}`;
	var focusedItemID = `${focusedItemID}`;
	var srcUrl = "";
	var popOption = `${popOption}`;
	
	$(document).ready(function(){
		
		// popup 설정
		if(scrnType == 'pop'){
			fnSetVisitLog(s_itemID);		
			if('${loginInfo.sessionMlvl}' != "SYS"){
				fnCheckUserAccRight(s_itemID, "fnGetMenuPage("+s_itemID+")", "${WM00033}");
			}else{
				fnGetMenuPage(s_itemID);
			}
		}
		
		height = document.body.clientHeight - 137;
		
		// item name & Path 정보
		renderItemNameAndPath(s_itemID, changeSetID);
		//renderRootItemPath();
		
		var currIdx = "${currIdx}";
		if(currIdx == "" || currIdx == "undefined"){currIdx = "0";}
		
		if(getCookie('itemIDs')) {
			var itemIDs = getCookie('itemIDs').split(',');
			fnOpenItems(currIdx,itemIDs);
		}
		
		// TODO : 담당자 정보 표시
		var layerWindow = $('.item_layer_photo');
		$('#item-author').click(function(){			
			var url = "viewMbrInfo.do?memberID=${itemInfo.AuthorID}";		
			window.open(url,'window','width=1200, height=700, left=400, top=100,scrollbar=yes,resizble=0');
		});
		
		// 레이어 팝업 닫기
		$('.closeBtn').click(function(){
			layerWindow.removeClass('open');
		});
		
		// 레이어 팝업 닫기
		$('.popup_closeBtn').click(function(){
			layerWindow.removeClass('open');
		});
		
		if("${showAttr}" == "Y") getAttr();
	});
	
	function getAttr() {
		var languageID = "${languageID}";
		if(languageID == ""){
			languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
		}
		ajaxPage("viewItemAttr.do", "&s_itemID=${id}&languageID="+languageID, "attr-section")
	}
	
	function fnGoBackNextPage(pID,preNext,currIdx){
	

		var itemId = pID;
		if(itemId=="" || itemId=="0"){return;}
		var option = "${option}";
		if(option != "") {
			parent.olm.menuTree.selectItem(itemId,false,false);
			parent.olm.getMenuUrl(itemId,preNext,currIdx);
		
		} 
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
			height = document.body.clientHeight - 137;
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
			$("#digramFrame").attr("style", "display:block;height:calc(100vh - 138px);border: 0;");
			$("#actFrame").attr("style", "display:none;");
		} else {
			$("#tabMenu").attr("style", "display:block;");
			$("#digramFrame").attr("style", "display:none;");
			if("${showAttr}" != "Y") $("#actFrame").attr("style", "overflow: hidden auto; height:"+height+"px;");
			ajaxTabPage(url, data, target);
		}
	 }
		
	var SubinfoTabsNum = 1; /* 처음 선택된 tab메뉴 ID값*/
	$(function(){
		$("#pli"+SubinfoTabsNum+" a").addClass("tab--active");
		
		$('.tabbar ul li a').click(function(){
			$(".tabbar ul li a").removeClass("tab--active"); //Remove any "active" class
			$(this).addClass('tab--active');
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
// 			parent.olm.menuTree.selectItem(itemId,false,false);
// 			parent.olm.getMenuUrl(itemId);

			parent.olm.menuTree.focusItem(itemId);
			
			//parent.olm.menuTree.selectItem(itemId,false,false); // 이렇게 하면 선택 잘 됨
			parent.olm.menuTree.selection.add(itemId); // 이 코드를 쓰면 selection을 못찾아서 오류 발생
			
			parent.olm.getMenuUrl(itemId);
		} else {
			// item Popup
			var url = "itemMainMgt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID="+pID+"&scrnType=pop&screenMode=pop&itemMainPage=/itm/itemInfo/itemMainMgt";
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
		var url = "itemHistory.do";
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
		var data = "changeSetID=${itemInfo.CurChangeSet}&StatusCode=${StatusCode}"
			+ "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&mainMenu=${mainMenu}&seletedTreeId=${s_itemID}"
			+ "&isItemInfo=Y&screenMode=edit"
			+ "&isMyTask=Y&scrnType=${scrnType}"
			+ "&checkInOption=${itemInfo.CheckInOption}";
	 	var w =  900;
	    var h =  700;
	    window.currentDhxModal = openUrlWithDhxModal(url, data, "${menu.LN00207}", w, h) 
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
	
	function fnOpenTeamInfoMain(teamID){
		var w = "1200";
		var h = "800";
		var url = "orgMainInfo.do?id="+teamID;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	// [popup]
	
	// visitLog 추가
	function fnSetVisitLog(itemID){
		var url = "setVisitLog.do";
		var target = "blankFrame";
		var data = "ItemId="+itemID;
		ajaxPage(url, data, target);
	}
	
	// itemClassMenuURL 값 존재하면 해당 url로 이동
	async function fnGetMenuPage(itemID){
		
		const arcCode = (await getArcCode()) ?? "";
		const itemClassMenuURL = (await getItemClassMenuURL()) ?? "";
		const itemClassMenuVarFilter = (await getItemClassMenuVarFilter()) ?? "";
		//const htmlTitle = `${htmlTitle}`;
		//document.title = htmlTitle;
		
		if(itemClassMenuURL != "" && !itemClassMenuVarFilter.includes("itm/itemInfo/itemMainMgt")){
			srcUrl = itemClassMenuURL+".do?itemID="+itemID
					+"&itemPopYN=Y&ArcCode=" + arcCode + "&accMode=${accMode}"
					+"&scrnType="+scrnType
					+"&changeSetID=${changeSetID}"
					+itemClassMenuVarFilter
					+"&s_itemID="+itemID;
			window.location.href = srcUrl;
		} else {
			document.getElementById('main-container').style.visibility = 'visible';
		}
	}
	
	// popup 권한 체크 ajax ( 기존 common.js 에 있는 function 사용 )
	function fnCheckUserAccRight(itemID, func, msg, msg2){
		
		$.ajax({
			url: "checkItemAccRight.do",
			type: 'post',
			data: "&itemID="+itemID,
			error: function(xhr, status, error) { 
			},
			success: function(data){				
				data = data.replace("<script>","").replace(";<\/script>","");
				fnCallbackCheckAccCtrl(data, itemID, func, msg, msg2);
			}
		});	
	}
	// popup 권한 체크 ( 기존 common.js 에 있는 function 사용 )
	function fnCallbackCheckAccCtrl(accRight, itemID, func, msg, msg2){	
		if(accRight == "Y"){ 
			eval(func);
		} else {
			if(accRight == "N"){
				alert(msg); window.close();	
				return;
			}else{		
				alert(msg2); window.close();
				return;
			}
		}
	}
	
	/**
    * @function renderRootItemPath
    * @param {String} itemID
    * @description itemID를 통해 해당 item의 path를 조회하고, pathContainer에 html 렌더링 합니다.
    */
	async function renderRootItemPath(itemID){
	    
        const requestData = { 
        	itemID, 
            languageID
        };
        
		const params = new URLSearchParams(requestData).toString();
		const url = "getRootItemPath.do?" + params;
		
		try {
			const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message, result.status);
			}
		
			const result = await response.json();
			// success 필드 체크
			if (!result.success) {
				throw throwServerError(result.message, result.status);
			}
		
			if (result && result.data) {
				
				document.querySelector('#pathContainer').innerHTML = renderBreadcrumb(result.data);
				
			} else {
				return [];
			}
		
		} catch (error) {
			handleAjaxError(error);
		}
		
	}
    
    /**
     * @function renderBreadcrumb
     * @param {Array} paths
     * @description item path 정보를 가공하여 html로 렌더링합니다.
     */
	const renderBreadcrumb = (paths) => {
	    // 값 없는 경우 return
		if (!paths?.length) return '';

	    const links = paths
	        .map(({ itemID, PlainText }) => 
	            `<span style="cursor:pointer" onClick="fnOpenParentItemPop('\${itemID}')">\${PlainText}</span>`
	        )
	        .join(' > ');

	    return `(\${links})`;
	};
	
	// [API] arcCode 호출 api
	async function getArcCode(){
		
		if(popOption == "CNGREW"){
			
			const sqlID = "project_SQL.getItemStatus";
			const requestData = { s_itemID : s_itemID, sqlGridList : 'N', sqlID };
			const params = new URLSearchParams(requestData).toString();
			const url = "getData.do?" + params;
			let arcCode = '';
			
			try {
				const response = await fetch(url, { method: 'GET' });
				
				if (!response.ok) {
					// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
					throw throwServerError(result.message, result.status);
				}
			
				const result = await response.json();
				// success 필드 체크
				if (!result.success) {
					throw throwServerError(result.message, result.status);
				}
			
				if (result && result.data) {
					
					const status = result.data;
					if (status === "MOD1" || status === "MOD2") {
						arcCode = "AR000004";
					} else {
						arcCode = "AR000004A";
					}
					
					return arcCode;
					
				} else {
					return '${arcCode}';
				}
			
			} catch (error) {
				handleAjaxError(error);
			}
			
		} else {
			return;
		}
		
	}
	
	// [API] itemClassMenuURL 호출 api
	async function getItemClassMenuURL(){
		
		const sqlID = "menu_SQL.getItemClassMenuURL";
		const requestData = { itemID : s_itemID, sqlGridList : 'N', sqlID };
		const params = new URLSearchParams(requestData).toString();
		const url = "getData.do?" + params;
		let arcCode = '';
		
		try {
			const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message, result.status);
			}
		
			const result = await response.json();
			// success 필드 체크
			if (!result.success) {
				throw throwServerError(result.message, result.status);
			}
		
			if (result && result.data) {
				
				return result.data;
				
			} else {
				return '${arcCode}';
			}
		
		} catch (error) {
			handleAjaxError(error);
		}
		
	}
	
	// [API] itemClassMenuURLVarFilter 호출 api
	async function getItemClassMenuVarFilter(){
		
		const sqlID = "menu_SQL.getItemClassMenuVarFilter";
		const requestData = { itemID : s_itemID, sqlGridList : 'N', sqlID };
		const params = new URLSearchParams(requestData).toString();
		const url = "getData.do?" + params;
		let arcCode = '';
		
		try {
			const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message, result.status);
			}
		
			const result = await response.json();
			// success 필드 체크
			if (!result.success) {
				throw throwServerError(result.message, result.status);
			}
		
			if (result && result.data) {
				
				return result.data[0];
				
			} else {
				return '${arcCode}';
			}
		
		} catch (error) {
			handleAjaxError(error);
		}
		
	}
	
	/**
   	* @function renderItemNameAndPath
   	* @description item명과 Path 를 렌더링합니다.
  	*/
	async function renderItemNameAndPath(itemID, changeSetID){
		
		let sqlID = "report_SQL.getItemInfo";
		if(accMode === 'OPS') sqlID = "item_SQL.getItemAttrRevInfo";
		
		const sqlGridList = 'N';
		const requestData = { languageID, s_itemID : itemID, changeSetID , sqlGridList, sqlID, sqlGridList };
		const params = new URLSearchParams(requestData).toString();
		const url = "getData.do?" + params;
		let arcCode = '';
		
		try {
			const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message, result.status);
			}
		
			const result = await response.json();
			// success 필드 체크
			if (!result.success) {
				throw throwServerError(result.message, result.status);
			}
		
			if (result && result.data) {
				
				const div = document.getElementById("itemNameAndPath");
				const info = result.data[0];
				
				const isSpecialCategory = ['MCN', 'CN', 'CN1'].includes(info.CategoryCode);

				let html = "";

				if (isSpecialCategory) {
				    // CategoryCode가 MCN, CN, CN1인 경우
				    html = `
				        <img src="${root}${HTML_IMG_DIR_ITEM}\${info.FromItemTypeImg}" 
				             onclick="fnOpenParentItemPop('\${info.CxnFromItemID}');" 
				             style="cursor:pointer;vertical-align: text-top !important;">
				        &nbsp;\${info.FromItemName}
				        
				        <img src="${root}${HTML_IMG_DIR_ITEM}\${info.ToItemTypeImg}" 
				             onclick="fnOpenParentItemPop('\${info.CxnToItemID}');" 
				             style="cursor:pointer;vertical-align: text-top !important;">
				        &nbsp;\${info.ToItemName}
				    `;
				    if(info.ItemName !== '') html += `/<font color="#3333FF"><b>${info.ItemName}</b></font>`;
				    
				} else {
				    // 그 외
				    html = `
				        <img src="${root}${HTML_IMG_DIR_ITEM}\${info.ItemTypeImg}" 
				             onclick="fnOpenParentItemPop('${parentItemID}');" 
				             style="cursor:pointer;vertical-align: text-top !important;">
				        <b style="font-size:13px;">\${info.Identifier}&nbsp;\${info.ItemName}</b>
				        <p id="pathContainer" style="display:inline-block;"></p>
				    `;
				}

				div.innerHTML = html;
				
				await renderRootItemPath(itemID); // path 설정
				
			} else {
				return;
			}
		
		} catch (error) {
			handleAjaxError(error);
		}
		
	}
	
</script>
<div class="iteminfo-wrapper" id="main-container" <c:if test="${scrnType eq 'pop'}"> style="visibility:hidden;"</c:if>>
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
	<div class="item-header pdL20 pdT10 pdB10 pdR20">
		<div class="flex justify-between btn-wrap">
			<div class="align-center flex">
				<c:if test="${showPreNextIcon eq 'Y'}" >
				<div id="openItemsli" style="font-family:arial;" class="floatL">
					<span id="preAbl" name="preAbl"><img style="cursor:auto;" src="${root}cmm/common/images/icon_back_btn.png" width="26" height="24" OnClick="fnGoBackItem();"></span>
					<span id="preDis" name="preDis" disabled=true><img style="cursor:auto;" src="${root}cmm/common/images/icon_back_btn_.png" width="26" height="24"></span>
					<input type="hidden" id="openItemName" name="openItemName" size="8">	
					<input type="hidden" id="openItemID" name="openItemID" size="8">		
					<span id="nextAbl" name="nextAbl" ><img style="cursor:auto;" src="${root}cmm/common/images/icon_next_btn.png"  width="26" height="24" OnClick="fnGoNextItem();"></span>	
					<span id="nextDis" name="nextDis"><img style="cursor:auto;" src="${root}cmm/common/images//icon_next_btn_.png"  width="26" height="24"></span>	
				</div>
				</c:if>
				<div id="itemNameAndPath"></div>
		   	</div>
			<div id="functions" class="btns">
		   		<c:choose>
			   		<c:when test="${itemInfo.SubscrOption eq '1' && myItem ne 'Y' && myItemCNT eq '0'}"  >
<!-- 	        			 <span class="btn_pack small icon"><span class="unsubscribe"></span><input value="subscribe" type="button" onclick="fnSubscribe()"></span> -->
	        			 <button onclick="fnSubscribe()" class="secondary">subscribe</button>
			   		</c:when>
			   		<c:when test="${myItem ne 'Y' && myItemCNT ne '0'}"  >
<!-- 	        			 <span class="btn_pack small icon"><span class="subscribe"></span><input value="unsubscribe" type="button" onclick="fnUnsubscribe()"></span> -->
	        			 <button onclick="fnUnsubscribe()" class="secondary">unsubscribe</button>
			   		</c:when>
		   		</c:choose>
<!-- 			    <span class="btn_pack small icon"><span class="report"></span><input value="Report" type="button" onclick="fnGoReportList()"></span> -->
		       <c:if test="${itemInfo.ChangeMgt eq '1'}">
<!-- 			  	    <span class="btn_pack small icon"><span class="cs"></span><input value="History" type="button" onclick="fnGoChangeMgt()"></span>			 -->
				   <c:if test="${scrnType ne 'pop' && accMode ne 'OPS'}">
						    <!-- Check Out 일반 -->
					  	 	<c:if test="${quickCheckOut eq 'Y' && itemInfo.Deleted ne '1' && itemInfo.CheckInOption ne '00'}" >  
<!-- 				   				<span class="btn_pack small icon"><span class="checkout"></span><input value="Check Out" type="button" onclick="fnQuickCheckOut('')"></span> -->
				   				<button onclick="fnQuickCheckOut()" class="secondary">Check Out</button>
					        </c:if> 
					        <!-- 폐기 결재  Check out >> Check In , Change Type = DEL  >> Approval Request -->
					   		<c:if test="${quickCheckOut eq 'Y' && itemInfo.Deleted ne '1' && itemInfo.CheckInOption eq '03A' }" >
<!-- 					   			<span class="btn_pack medium icon"><span class="delete"></span><input value="폐기" type="button" onclick="fnQuickCheckOut('DEL')"></span> -->
					   			<button onclick="fnQuickCheckOut('DEL')" class="secondary">폐기</button>
							</c:if>		
							<!-- 신규 Item 삭제 -->
							<c:if test="${itemInfo.Blocked eq '0' && itemInfo.Status eq 'NEW1' &&  myItem eq 'Y' }" >
<!-- 								<span class="btn_pack medium icon"> <span class="delete"></span><input value="Delete" type="button" onclick="fnUpdateItemDeleted()"></span> 			 -->
					   			<button onclick="fnUpdateItemDeleted()" class="secondary">Delete</button>
							</c:if>    		      
					        <!-- Commit Check In Option = 00-->
							<c:if test="${ myItem eq 'Y' && itemInfo.CheckInOption eq '00' && itemInfo.Blocked eq '0' }" >
<!-- 					   			<span class="btn_pack small icon"><span class="checkin"></span><input value="Commit" type="button" onclick="fnCommitItem()"></span> -->
					   			<button onclick="fnCommitItem()" class="secondary">Commit</button>
					   		</c:if>	
					  </c:if> 					   				  		
			 	  </c:if>
	        		 		
			    <c:if test="${scrnType ne 'pop' && accMode ne 'OPS' && (sessionScope.loginInfo.sessionUserId eq itemInfo.AuthorID || sessionScope.loginInfo.sessionAuthLev eq '1')  && itemInfo.ChangeMgt eq '1'}" >	
								
				    <!-- Check In  Only Check In Option = 01 , 02, 03 03B -->
					<c:if test="${itemInfo.Blocked eq '0' && itemInfo.CheckInOption ne '03A' && itemInfo.CheckInOption ne '00'}" >
<!-- 		   		 		<span class="btn_pack small icon"><span class="checkin"></span><input value="Check In" type="button" onclick="fnEditChangeSetClsMn()"></span> -->
		   		 		<button onclick="fnEditChangeSetClsMn()" class="secondary">Check In</button>
			   		</c:if>		
			   		<!-- Check In  >> 결재상신  -->
					<c:if test="${itemInfo.Blocked eq '0' && itemInfo.CheckInOption eq '03A'}" >
<!-- 					   	<span class="btn_pack small icon"><span class="checkin"></span><input value="App. Request" type="button" onclick="fnCheckInItem()"></span> -->
					   	<button onclick="fnCheckInItem()" class="secondary">App. Request</button>
					</c:if>
				   	<!-- 변경 담당자 Rework -->				       
	               		 <!-- 1) Check in 후 상신 전인 경우 -->
	                <c:if test="${itemInfo.CSStatus == 'CMP'}" >
<!-- 	                  &nbsp;<span class="btn_pack medium icon"><span class="confirm"></span><input value="Rework" onclick="rework()" type="submit"></span>   -->
	                  <button onclick="rework()" class="secondary">Rework</button>
	        		</c:if>	
	        			<!-- 2) CS 결재 반려된 경우 -->
	        		<c:if test="${itemInfo.WFInstanceID != ''  && itemInfo.WFStatus != '0' && itemInfo.CSStatus == 'HOLD'}" >
<!-- 	        		 <span class="btn_pack medium icon"><span class="confirm"></span><input value="Rework" onclick="rework()" type="submit"></span>  -->
	        		 	<button onclick="rework()" class="secondary">Rework</button>
	        		</c:if>    
	        		<!-- CS 결재 상신 후 결재 취소 -->
					<c:if test="${itemInfo.WFInstanceID != ''  && itemInfo.WFStatus eq '1' && itemInfo.CSStatus == 'APRV' && wfInstanceON eq 'N' }" >
<!-- 					  &nbsp;<span class="btn_pack medium icon"><span class="confirm"></span><input value="Withdraw App. Request" onclick="withdrawAprvReq()" type="submit"></span> 					      -->
					  	<button onclick="withdrawAprvReq()" class="secondary">Withdraw App. Request</button>
					</c:if>      		
				</c:if>
		   		
<!-- 		   		<span class="btn_pack medium icon"><span class="reload"></span><input value="Reload" type="button" onclick="fnMenuReload()"></span> -->
					<button onclick="fnMenuReload()" class="secondary">Reload</button>
		   	 	<c:if test="${checkItemAuthorTransferable eq 'Y'}" >
<!-- 		   			<span class="btn_pack small icon"><span class="gov"></span><input value="Transfer" type="button" onclick="fnTransferItem()"></span> -->
		   			<button onclick="fnTransferItem()" class="secondary">Transfer</button>
		   		</c:if>
		   		<!-- 담당자 변경 추가  -->
		   		 <c:if test="${myItem eq 'Y'}" >
<!-- 		   			<span class="btn_pack small icon"><span class="gov"></span><input value="Transfer" type="button" onclick="editAuthor()"></span> -->
		   			<button onclick="editAuthor()" class="secondary">Transfer</button>
		   		</c:if>
		   		</div>
		   		<!-- 
		   		<div class="floatR">
					<ul>
						<li id="memberPhotoArea" style="font-family:arial;cursor:pointer;">
							<c:if test="${empPhotoItemDisPlay ne 'N' && roleAssignMemberList.size() > 0 }" >		   	
								<c:forEach var="author" items="${roleAssignMemberList}" varStatus="status">
								 <span id="item-author${status.index}" name="item-author${status.index}" ><img src="${author.Photo}" width="26" height="24" OnClick="fnGetitem-author('${author.MemberID}');"></span>
								</c:forEach>
							</c:if>						
						</li> 
					</ul>
				</div> 		
				 -->
		 </div>
		 <div class="flex align-center mgT5">
			 <span class="mgR10 status">${itemInfo.StatusName}</span>
			 <span class="mgR5">${menu.LN00004}</span><span class="align-center flex link mgR10" id="item-author">${itemInfo.Name}</span>
			 <span class="mgR5">${menu.LN00018}</span><span class="mgR10 link" onclick="fnOpenTeamInfoMain(${itemInfo.OwnerTeamID})">${itemInfo.OwnerTeamName}</span>
			 <span class="align-center flex mgR10">Last Updated. ${itemInfo.LastUpdated}</span>
			 <span class="align-center flex mgR10">Created On. ${itemInfo.CreateDT}</span>
		 </div>
	</div>
	
	<div class="item-contents">
		<c:if test="${showAttr eq 'Y'}"><div class=" pdL20 pdR20 pdB20" id="attr-section"></div></c:if>
		
		<div id="itemConWrapper">
			<div class="tabbar">
				<ul>
					<c:set value="1" var="tabNum" />
					<c:forEach var="i" items="${getList}" varStatus="status" >
						<li id="pli${tabNum}" class="flex align-center">
							<a onclick="setActFrame('${i.URL}', ${i.Sort}, '${i.MenuFilter}', '${i.VarFilter}', '${i.MenuID}', '${i.MenuType}')" class="flex align-center">
								<span>${i.Name} ${BASE_ATCH_URL}</span>
							</a>
						</li>
					<c:set var="tabNum" value="${tabNum+1}"/>
					</c:forEach>
				</ul>
			</div>
			<div id="actFrame" style="width:100%; padding:0 0 17px 0;" class="pdL20 pdR20"></div>
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
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
	</div>
</div>