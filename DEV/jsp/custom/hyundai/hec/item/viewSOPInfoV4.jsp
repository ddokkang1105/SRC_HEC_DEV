<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
 
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<style>
	#itemDiv > div {
		padding : 0 10px;
	}
	#refresh:hover {
		cursor:pointer;
	}
	.tdhidden{display:none;}
	#maintext table {
		border: 1px solid #ccc;
		width:100%;
	}
	#maintext th{
		text-align: left;
		padding: 10px;
		color: #000;
		font-weight: bold;
	}
	#maintext td{
	    display: block;
	    padding: 10px;
	    overflow-x: auto;
	    line-height: 18px;
	}
	#maintext  textarea {
		width: 100%;
		resize:none;
	}
	#itemNameAndPath, #functions{
		display:inline;
	}
</style>
<script type="text/javascript">
	var chkReadOnly = true;
	
	// cmm
	var languageID = `${sessionScope.loginInfo.sessionCurrLangType}`;
	var s_itemID = `${s_itemID}`;
	var changeSetID = `${changeSetID}`;
	var accMode = `${accMode}`;
	var cxnTypeList = `${cxnTypeList}`;
	var notInCxnClsList = `${notInCxnClsList}`;
	var hideBlocked = `${hideBlocked}`;
	
</script>

<script type="text/javascript">
	$(document).ready(function(){				
		
		// item name & Path 정보
		renderItemNameAndPath(s_itemID, changeSetID);
		// item 기본정보 - 유관조직
		renderRoleList();
		// item attr 정보 - 본문
		renderAttr('AT00501');
		// 관련 Process
		renderRelItemList();
		// file
		renderFileList()
		
		$(".chkbox").click(function() {
		    if( $(this).is(':checked')) {
		        $("#"+this.name).show();
		    } else {
		        $("#"+this.name).hide(300);
		    }
		});
		
		$("input:checkbox:not(:checked)").each(function(){
			$("#"+$(this).attr("name")).css('display','none');
		});

		modelView();
			 
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
	
// 	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	function modelView(){
		var browserType="";
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url = "newDiagramViewer.do";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&s_itemID=${itemID}"
					+"&width="+$("#model2").width()
					+"&getAuth=${sessionScope.loginInfo.sessionLogintype}"
					+"&userID=${sessionScope.loginInfo.sessionUserId}"
					+"&varFilter=${revViewOption}"
					+"&displayRightBar=none";
		var src = url +"?" + data+"&browserType="+browserType;
//  		document.getElementById('model2').contentWindow.location.href= src; // firefox 호환성  location.href에서 변경
// 		$("#model2").attr("style", "display:block;height:600px;border: 0;");
	}
	
	/* 첨부문서, 관련문서 다운로드 */
	function FileDownload(checkboxName, isAll){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		var j =0;
		var checkObj = document.all(checkboxName);
		
		// 모두 체크 처리를 해준다.
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = true;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = true;
			}
		}
		
		// 하나의 파일만 체크 되었을 경우
		if (checkObj.length == undefined) {
			if (checkObj.checked) {
				var checkObjVal = checkObj.value.split(',');
				sysFileName[0] =  checkObjVal[2] + checkObjVal[0];
				originalFileName[0] =  checkObjVal[1];
				filePath[0] = checkObjVal[2];
				seq[0] = checkObjVal[3];
				j++;
			}
		};
		for (var i = 0; i < checkObj.length; i++) {
			if (checkObj[i].checked) {
				var checkObjVal = checkObj[i].value.split(',');
				sysFileName[j] =  checkObjVal[2] + checkObjVal[0];
				originalFileName[j] =  checkObjVal[1];
				filePath[j] = checkObjVal[2];
				seq[j] = checkObjVal[3];
				j++;
			}
		}
		if(j==0){
			alert("${WM00049}");
			return;
		}
		j =0;
		var url  = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.frontFrm, url,"blankFrame");
		// 모두 체크 해제
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = false;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = false;
			}
		}
	}
	
	function fileNameClick(avg1, avg2, avg3, avg4, avg5){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		sysFileName[0] =  avg3 + avg1;
		originalFileName[0] =  avg3;
		filePath[0] = avg3;
		seq[0] = avg4;
		
		if(avg3 == "VIEWER") {
			var url = "openViewerPop.do?seq="+seq[0];
			var w = screen.width;
			var h = screen.height;
			
			if(avg5 != "") { 
				url = url + "&isNew=N";
			}
			else {
				url = url + "&isNew=Y";
			}
			window.open(url, "Mnado", "width="+w+", height="+h+",top=0,left=0,resizable=yes");
			//window.open(url,1316,h); 
		}
		else {
	
			var url  = "fileDownload.do?seq="+seq;
			ajaxSubmitNoAdd(document.frontFrm, url,"blankFrame");
		}
	}
	
	
	// 관련항목 팝업
	function clickItemEvent(itemID) {
		var url = "itemMainMgt.do?"
				+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
 				+"&s_itemID=" + itemID
				+"&scrnType=pop&itemMainPage=itm/itemInfo/itemMainMgt";
		var w = 1200;
		var h = 900;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function clickItemEvent2(trObj) {
		var classCode = $(trObj).find("#classCode").text()		
		var masterIden = $(trObj).find("#masterKey").text();
		// var url = "https://vell.hec.co.kr/ll/LLMasterInfo.View?s_InterfaceYn=Y&s_ObjectId="+$(trObj).find("#masterKey").text();
		/*
		VE :  https://ivell.hec.co.kr/member-popup/ve-pj/qi/detail?masterIden=11936
		LL :  https://ivell.hec.co.kr/member-popup/ll/master-detail-view?masterIden=20560 
		*/
		var url = "https://ivell.hec.co.kr/member-popup/ve-pj/qi/detail?masterIden="+masterIden; // VE : CL12002
		if(classCode == "CL12003"){ // LL 
			url = "https://ivell.hec.co.kr/member-popup/ll/master-detail-view?masterIden="+masterIden;
		}
		
		var w = 1200;
		var h = 900;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	// 변경이력 팝업
	function clickChangeHistoryEvent(trObj) {
		var url = "viewItemChangeInfo.do?"
				+"changeSetID="+$(trObj).find("#ChangeSetID").text()
 				+"&StatusCode="+$(trObj).find("#ChangeStsCode").text()
				+"&ProjectID"+$(trObj).find("#ChangeStsCode").text()
				+"&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&isItemInfo=Y&seletedTreeId=${itemID}&isStsCell=Y";
		var w = 1200;
		var h = 900;
		window.open(url, "", "width=1200,height=600,top=100,left=100,toolbar=no,status=no,resizable=yes")	
	}
	
// 	function fnChangeMenu(menuID,menuName) {
// 		$("#itemDescriptionDIV").css('display','block');
// 		$("#itemDiv").css('display','none');
// 		$("#viewPageBtn").css('display','block');
// 		if(menuID == "management"){
// 			parent.fnGetMenuUrl("${itemID}", "Y");
// 		}else if(menuID == "file"){
// 			var url = "goFileMgt.do?&fileOption=${menuDisplayMap.FileOption}&itemBlocked=${itemBlocked}"; 
// 			var target = "itemDescriptionDIV";
// 			var data = "s_itemID=${itemID}&kbn=newItemInfo&backBtnYN=N"; 
// 		 	ajaxPage(url, data, target);
// 		}else if(menuID == "report"){
// 			var url = "objectReportList.do";
// 			var target = "itemDescriptionDIV";
// 			var data = "s_itemID=${itemID}&kbn=newItemInfo&backBtnYN=N"; 
// 		 	ajaxPage(url, data, target);
// 		}else if(menuID == "changeSet"){
// 			var url = "itemHistory.do";
// 			var target = "itemDescriptionDIV";
// 			var data = "s_itemID=${itemID}&kbn=newItemInfo&backBtnYN=N&myItem=${myItem}&itemStatus=${itemStatus}";
// 		 	ajaxPage(url, data, target);
// 		}else if(menuID == "dimension"){
// 			var url = "dimListForItemInfo.do";
// 			var target = "itemDescriptionDIV";
// 			var data = "s_itemID=${itemID}&backBtnYN=N";
// 		 	ajaxPage(url, data, target);
// 		}
// 	}
	function fnChangeMenu(menuID,menuName) {
// 		if(menuID == "management"){
// 			parent.fnGetMenuUrl("${itemID}", "Y");
// 		}
		const url = "itemInfoPop.do?languageID="+languageID+"&id="+s_itemID+"&scrnType=${scrnType}&ArcCode=${ArcCode}&changeSetID=${changeSetID}";
		location.href = url;
	}
	
	function fnViewPage(){
		$("#itemDescriptionDIV").css('display','none');
		$("#itemDiv").css('display','block');
		$("#viewPageBtn").css('display','none');
	}
	
	function fnMenuReload(){
// 		$("#itemDescriptionDIV").html("");
// 		$("#itemDiv").css('display','block');
		if(parent.olm?.menuTree) {
			// 트리 오른쪽 화면에서 view 화면으로 돌아갈 경우 - 트리 클릭 이벤트로 아이템 다시 로드
			parent.olm.menuTree.selection.add("${itemID}");
			parent.olm.getMenuUrl("${itemID}");
		} else {
			// 팝업에서 로드할 경우, url 재호출
			location.reload();
		}
	}
	
	function fnOpenParentItemPop(pID){// ParentItem Popup
		var itemId = pID;
		if(itemId=="" || itemId=="0"){return;}
		var option = "${option}";
		
		if(option != "") {
			parent.olm.menuTree.selectItem(itemId,false,false);
			parent.olm.getMenuUrl(itemId);
		} else {
			var url = "itemMainMgt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID="+pID+"&scrnType=pop&screenMode=pop&itemMainPage=itm/itemInfo/itemMainMgt";
			var w = 1200;
			var h = 900;
			itmInfoPopup(url,w,h,itemId);
		}
	}
	
	function fnSubscribe(){
		if(confirm("Do you really subscibe this item?")){
			var url = "saveRoleAssignment.do";
			var data = "itemID=${itemID}&assignmentType=SUBSCR&accessRight=R&assigned=1&memberID=${sessionScope.loginInfo.sessionUserId}&seq=";
			var target = "saveFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnUnsubscribe(){
		if(confirm("Do you really unsubscibe this item?")){
			var url = "deleteRoleAssignment.do";
			var data = "seqArr=${myItemSeq}";
			var target = "saveFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnGoReportList() {
		var url = "objectReportList.do";
		var target = "itemDescriptionDIV";
		var accMode = $("#accMode").val();
		var data = "s_itemID=${itemID}&option=${option}&kbn=newItemInfo&accMode="+accMode; 
		$("#itemDescriptionDIV").css('display','block');
		$("#itemDiv").css('display','none');
		ajaxPage(url, data, target);
	}
	
	function fnEditItemInfo() {
		var url = "itemMainMgt.do";
		var data = "itemID=${itemID}&s_itemID=${itemID}&option=${option}&itemEditPage=${itemEditPage}&itemViewPage=${itemViewPage}&accMode=DEV&scrnMode=E&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"; 
		ajaxPage(url, data, "processItemInfo");
	}
	
	
	function fnGoChangeMgt() {
		var url = "itemHistoryV4.do";
		var target = "itemDescriptionDIV";
		var data = "s_itemID=${itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&myItem=${myItem}&itemStatus=${itemStatus}&backBtnYN=N";
		
		$("#itemDescriptionDIV").css('display','block');
		$("#itemDiv").css('display','none');
		ajaxPage(url, data, target);
	}
	
	function fnGoForumMgt(){
		var url = "forumMgt.do";
		var target = "itemDescriptionDIV";
		var data = "&s_itemID=${itemID}&BoardMgtID=4";
		
		$("#itemDescriptionDIV").css('display','block');
		$("#itemDiv").css('display','none');
		ajaxPage(url, data, target);
	}
	function fnGoForumMgt2(){
		var url = "forumMgt.do";
		var target = "itemDescriptionDIV";
		var data = "&s_itemID=${itemID}&BoardMgtID=BRD110&varFilter=BRD110";
		
		$("#itemDescriptionDIV").css('display','block');
		$("#itemDiv").css('display','none');
		ajaxPage(url, data, target);
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
				             onclick="fnOpenParentItemPop('\${parentItemID}');" 
				             style="cursor:pointer;vertical-align: text-top !important;">
				        &nbsp;\${info.FromItemName}
				        
				        <img src="${root}${HTML_IMG_DIR_ITEM}\${info.ToItemTypeImg}" 
				             onclick="fnOpenParentItemPop('\${parentItemID}');" 
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
	
	/**
    * @function renderRoleList
    * @param {String} itemID
    * @description itemID를 통해 해당 item의 role List를 조회하고, html 렌더링 합니다.
    */
	async function renderRoleList(){
	    
    	const isSubItem = `${isSubItem}`;
	    
    	let sqlID = "role_SQL.getItemTeamRoleList";
		if(isSubItem === 'Y') sqlID = "role_SQL.getSubItemRoleList";
    	
		let asgnOption = '1,2'; // 해제,해제중 미출력
		if(accMode === 'OPS') asgnOption = '2,3'; // 해제,신규 미출력
		
		const requestData = { languageID, itemID : s_itemID, asgnOption, sqlID };
        
		const params = new URLSearchParams(requestData).toString();
		const url = "getData.do?" + params;
		
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
				
				const html = result.data
	            .filter(item => item.TeamRoletype === 'REL')
	            .map(item => item.TeamNM)
	            .join(', ');
				
				document.getElementById('roleList').textContent = html;
	       
				
			} else {
				return [];
			}
		
		} catch (error) {
			handleAjaxError(error);
		}
		
	}
    /**
     * @function renderAttr
     * @param {String} AttrTypeCode
     * @description itemID과 attrTypeCode 통해 해당 item의 attr Value를 조회하고, html 렌더링 합니다.
     */
 	async function renderAttr(AttrTypeCode){
 	    
 		
 		const requestData = { languageID, s_itemID, accMode, AttrTypeCode };
         
 		const params = new URLSearchParams(requestData).toString();
 		const url = "getItemAttrList.do?" + params;
 		
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
 				const html = result.data[0].PlainText || ""; 
 				const editor = document.getElementById(AttrTypeCode);
 				
 				if(editor)editor.innerHTML = html;
 				
 				const script = document.createElement('script');
			    script.type = 'text/javascript';
			    script.src = '<c:url value="/cmm/js/xbolt/tinyEditorHelper.js"/>';
			    
			    document.body.appendChild(script);
 			} else {
 				return [];
 			}
 		
 		} catch (error) {
 			handleAjaxError(error);
 		}
 		
 	}
    
    /**
     * @function renderRelItemList
     * @description itemID을 통해 해당 item의 관련항목 리스트를 조회하고, html 렌더링 합니다.
     */
    async function renderRelItemList() {
   	    const requestData = { s_itemID, languageID, cxnTypeList, notInCxnClsList };
   	    const params = new URLSearchParams(requestData).toString();
   	    const url = "getCxnItemList.do?" + params;
   		
   		try {
   			const response = await fetch(url, { method: 'GET' });
   			
   			if (!response.ok) {
   				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
   				throw throwServerError(result.message,result.status);
   			}

   			const result = await response.json();
   			// success 필드 체크
   			if (!result.success) {
   				throw throwServerError(result.message,result.status);
   			}

   			if (result && result.data) {
   				
   				const relItemList = result.data;
   				const tbody_rel = document.getElementById("relProcess_tbody");
   				const tbody_vell = document.getElementById("vell_tbody");
   				
   				if(!tbody_rel) return;
   				
   				// list.TypeName이 없음. 원소스 보고 확인 필요
   				tbody_rel.innerHTML = relItemList
   		        .filter(list => list.ItemTypeCode !== 'OJ00012')
   		        .map((list, index) => `
   		            <tr onclick="clickItemEvent('\${list.ItemID}')" style="cursor: pointer;">
   		                <td>\${list.ClassName ?? ""}</td>
   		                <td>\${list.Identifier ?? ""}</td>
   		                <td class="alignL pdL10">\${list.ItemName ?? ""}</td>
   		            </tr>
   		        `).join("");
   		    	
   				if(!tbody_vell) return;
   				
   				tbody_vell.innerHTML = relItemList
   		        .filter(list => list.ItemTypeCode === 'OJ00012')
   		        .map((list, index) => `
   		            <tr onclick="clickItemEvent2(this)" style="cursor: pointer;">
   		                <td>\${list.ClassName ?? ""}</td>
   		                <td>\${list.Identifier ?? ""}</td>
   		             	<td>\${list.ZAT0001 ?? ""}</td>
   		          		<td>\${list.ZAT0002 ?? ""}</td>
   		                <td class="alignL pdL10"><font style="color: blue; border-bottom: 1px solid blue;">\${list.ItemName ?? ""}</font></td>
   		                
   		             	<td class="tdhidden" id="ItemID">${list.ItemID}</td>
						<td class="tdhidden" id="masterKey">${list.AT00014}</td>
						<td class="tdhidden" id="classCode">${list.ClassCode}</td>
   		            </tr>
   		        `).join("");
   				
   			} else {
   				return [];
   			}

   		} catch (error) {
   			handleAjaxError(error);
   		}	
   	}
    
    /**
   	* @function renderFileList
   	* @description 현재 item의 첨부파일 리스트를 api 통해 조회 후 html 렌더링 합니다.
    * @returns {String} 아이템 릴리즈 버전
  	*/
	let attachFileList = "";
	async function renderFileList() {
		
	    let requestData = { DocumentID : s_itemID, s_itemID, DocCategory : 'ITM', languageID , isPublic : 'N', hideBlocked };
	 	// getRltdItemId
		const rltdItemId = await getRltdItemId();
		if(rltdItemId && rltdItemId !== ''){
			requestData = {
					...requestData,
					rltdItemId
			}
	    }
		
	    const params = new URLSearchParams(requestData).toString();
	    const url = "getItemFileListInfo.do?" + params;
	    
		try {
			const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message);
			}

			const result = await response.json();
			if (result && result.data ) {
				
				// file 정보 조회
				attachFileList = result.data;
				const fileList = document.querySelector("tbody[name='file-list']");
				
				// 파일 표시
				attachFileList.forEach((file, index) => {
					const fileFormat = file.FileFormat || '';
			        let iconClass = 'log';
			        if (fileFormat.includes('do')) iconClass = 'doc';
			        else if (fileFormat.includes('xl')) iconClass = 'xls';
			        else if (fileFormat.includes('pdf')) iconClass = 'pdf';
			        else if (fileFormat.includes('hw')) iconClass = 'hwp';
			        else if (fileFormat.includes('pp')) iconClass = 'ppt';
					
				    const row = document.createElement('tr');
				    row.innerHTML = `
				        <td>\${index+1}</td>
				        <td class="alignL pdL10 flex align-center">
				        	<span class="btn_pack small icon mgR25"><span class="\${iconClass}"></span></span>
	                    	<span style="cursor:pointer;" onclick="fileNameClick('', '', '', '\${file.Seq}', '');">
	                        	\${file.FileRealName}
	                    	</span>
	                    </td>
	                <td>\${file.WriteUserNM}</td>
	                <td>\${file.LastUpdated}</td>
				    `;
				    
				    fileList.appendChild(row);
				});
				
			} else {
				return []; // 조회 불가능한 경우
			}

		} catch (error) {
			handleAjaxError(error);
		}
		
	}
		
	/**
   	* @function getRltdItemId
   	* @description file attach List 조회 용 연관id를 찾습니다.
  	*/
	async function getRltdItemId(){
	  const requestData = { languageID, DocumentID: s_itemID };
	  const params = new URLSearchParams(requestData).toString();
	  const url = "getRltdItemId.do?" + params;
	  
	  try {
			const response = await fetch(url, { method: 'GET' });
			
			if (!response.ok) {
				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
				throw throwServerError(result.message,result.status);
			}

			const result = await response.json();
			// success 필드 체크
			if (!result.success) {
				throw throwServerError(result.message,result.status);
			}

			if (result && result.data) {
				return result.data;
			} else {
				return [];
			}

		} catch (error) {
			handleAjaxError(error);
		}
	}
    
	/**
	 * @function handleAjaxError
	 * @description 데이터 로드 실패 시 에러 메시지 팝업 출력
	 * @param {Error} err - 발생한 에러 객체
	*/
	function handleAjaxError(err) {
		console.error(err);
		Promise.all([getDicData("ERRTP", "LN0014"), getDicData("BTN", "LN0034")])
				.then(([errDic, btnDic]) => showDhxAlert(errDic.LABEL_NM, btnDic.LABEL_NM));
	}
	 
	function fnGetAuthorInfo(memberID){
		var url = "viewMbrInfo.do?memberID="+memberID;		
		window.open(url,'window','width=1200, height=700, left=400, top=100,scrollbar=yes,resizble=0');
	}
</script>
</head>
<body style="width:100%;height:100%;overflow-y:auto;overflow-x:hidden;">
<!-- BIGIN :: -->
<form name="frontFrm" id="frontFrm" action="#" method="post" onsubmit="return false;"> 
<div id="processItemInfo">
<input type="hidden" id="currIdx" value="">
<input type="hidden" id="openItemList" value="">

<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">	
<input type="hidden" id="itemViewPage" name="itemViewPage" value="${itemViewPage}">	
<input type="hidden" id="itemEditPage" name="itemEditPage" value="${itemEditPage}">	
<input type="hidden" id="defAccMode" name="defAccMode" value="${defAccMode}">	
<input type="hidden" id="scrnMode" name="scrnMode" value="${scrnMode}">	
<input type="hidden" id="option" name="option" value="${option}">	
<input type="hidden" id="accMode" name="accMode" value="${accMode}">	

	<div>
		<div id="cont_Header">	
			<div class="pdL10 pdT10 pdB10" id="titWrap" style="width:99%;">
				<ul style="display: inline-block;">
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
					<div id="itemNameAndPath"></div>
				   	&nbsp;
						<div id="functions">
						<!-- 251104 나의관리항목(ownerType=author) 인경우에만 SYS or (편집자이상 and 담당자) edit 버튼 출력 되도록 수정 -->
						<!--c:if test="${sessionScope.loginInfo.sessionLogintype eq 'editor' && myItem eq 'Y'}" > 	-->
						<c:if test="${sessionScope.loginInfo.sessionMlvl eq 'SYS'	
						             or (ownerType eq 'author'
						                 and sessionScope.loginInfo.sessionLogintype eq 'editor'
						                 and myItem eq 'Y')}">								  		
					        <span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="button" onclick="fnEditItemInfo()"></span>
					    </c:if>
						<c:choose>
					   		<c:when test="${itemInfo.SubscrOption eq '1' && myItem ne 'Y' && myItemCNT eq '0'}"  >
			        			 <span class="btn_pack small icon"><span class="unsubscribe"></span><input value="Subscribe" type="button" onclick="fnSubscribe()"></span>
					   		</c:when>
					   		<c:when test="${myItem ne 'Y' && myItemCNT ne '0'}"  >
			        			 <span class="btn_pack small icon"><span class="subscribe"></span><input value="Unsubscribe" type="button" onclick="fnUnsubscribe()"></span>
					   		</c:when>
				   		</c:choose>			   		
					        <span class="btn_pack small icon"><span class="report"></span><input value="Report" type="button" onclick="fnGoReportList()"></span>
				        <c:if test="${itemInfo.ChangeMgt eq '1'}">
					  		 <span class="btn_pack small icon"><span class="cs"></span><input value="History" type="button" onclick="fnGoChangeMgt()"></span>
					  	</c:if>
				  		<span class="btn_pack small icon"><span class="isp"></span><input value="Q&A" type="button" onclick="fnGoForumMgt()"></span>
				  		<span class="btn_pack small icon"><span class="isp"></span><input value="Review" type="button" onclick="fnGoForumMgt2()"></span>
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
				<c:if test="${sessionScope.loginInfo.sessionAuthLev == 1}" >
					<span class="btn_pack small icon mgR25" style="float: right;"><input value="Standard Menu" type="button" style="padding-left: 2px;" onclick="fnChangeMenu('management','Management');"></span>
				</c:if>
			</div>
		</div>
		
		<div id="menuDiv" style="margin:0 10px;border-top:1px solid #ddd;" >
			<div id="itemDescriptionDIV" name="itemDescriptionDIV" style="width:100%;text-align:center;">
			</div>
		</div>

				
		<div id="itemDiv">
			<div style="height: 22px; padding-top: 10px;">
				<ul>
					<li class="floatR pdR20">
						<input type="checkbox" class="mgR5 chkbox" name="process" checked>기본정보&nbsp;
						<input type="checkbox" class="mgR5 chkbox" name="maintext" checked>본문&nbsp;
						<input type="checkbox" class="mgR5 chkbox" name="relProcess" checked>관련 Process/SOP/ STP&nbsp;
						<input type="checkbox" class="mgR5 chkbox" name="vell" checked>관련 VELL&nbsp;
						<input type="checkbox" class="mgR5 chkbox" name="file" checked>첨부파일&nbsp;
					</li>
				</ul>
			</div>
			<!-- BIGIN :: 기본정보 -->
			<div id="process" class="mgB30">
				<p class="cont_title">기본 정보</p>
				<table class="tbl_preview mgB30">
					<colgroup>
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
					</colgroup>
					<tr>
						<th>SOP No.</th>
						<td class="alignL pdL10">${itemInfo.Identifier}</td>
						<th>Rev. No.</th>
						<td class="alignL pdL10">${itemInfo.Version}</td>
						<th>Rev. Date</th>
						<td class="alignL pdL10">${itemInfo.ValidFrom}</td>
						<th>${menu.LN00060}</th>
						<td class="alignL pdL10">${itemInfo.Name}</td>
					</tr>
					<tr>
						<th>조직구분</th>
						<td class="alignL pdL10"></td>
						<th>${menu.LN00358}</th>
						<td class="alignL pdL10" colspan="5">${itemInfo.Path}</td>
					</tr>
					<tr>
						<th>${menu.ZLN019}</th>
						<td class="alignL pdL10">${itemInfo.CurOwnerTeamName}</td>
						<th>${menu.ZLN021}</th>
						<td class="alignL pdL10" colspan="5" id="roleList"></td>
					</tr>
				</table>
			</div>
			
			<!-- BIGIN :: 본문 -->
			<div id="maintext" class="mgB30">
				<p class="cont_title">${menu.LN00145}</p>
				<table>
					<tr>
				   		<div style="height:300px;">
                         <textarea class="tinymceText" id="AT00501" name="AT00501"></textarea>
						</div>
					</tr>
				</table>
			</div>
						
			<!-- BIGIN :: 관련 SOP / STP -->
			<div id="relProcess" class="mgB30">
				<p class="cont_title">관련 Process / SOP /STP</p>
				<table class="tbl_preview mgB20">
					<colgroup>
						<col width="5%">
						<col width="30%">
						<col width="65%">					
					</colgroup>	
					<tr>
						<th>${menu.LN00042}</th>
						<th>ID</th>
						<th>${menu.ZLN018}</th>
					</tr>
					<tbody id="relProcess_tbody"></tbody>
				</table>	
			</div>
			
			<!-- BIGIN :: 관련 VELL -->
			<div id="vell" class="mgB30">
				<p class="cont_title">관련 VELL</p>
				<table class="tbl_preview mgB20">
					<colgroup>
						<col width="5%">
						<col width="10%">
						<col width="30%">
						<col width="15%">
						<col width="30%">
					</colgroup>
					<tr>
						<th>${menu.LN00042}</th>
						<th>No.</th>
						<th>사업명</th>
						<th>Phase</th>
						<th>Title</th>
					</tr>
					<tbody id="vell_tbody"></tbody>
				</table>	
			</div>
						
			<!-- 첨부 및 관련 문서 --> 
			<div id="file" class="mgB30">
				<p class="cont_title">${menu.LN00111}</p>
				<table class="tbl_preview">
					<colgroup>
						<col width="5%">
						<col width="60%">
						<col width="10%">
						<col width="10%">
					</colgroup>	
					<tr>
						<th>No</th>
						<th>${menu.LN00101}</th>
					    <th>${menu.LN00060}</th>
						<th>${menu.LN00078}</th>
					</tr>
					<tbody name="file-list"></tbody>
				</table>
			</div>
		</div>
	</div>
</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
</body>
</html>
