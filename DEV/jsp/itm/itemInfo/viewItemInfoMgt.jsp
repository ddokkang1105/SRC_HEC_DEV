<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<c:url value="/" var="root"/>

<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>
<link rel="stylesheet" href="${root}cmm/common/css/materialdesignicons.min.css"/>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">


<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00057" var="CM00057"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00042" var="CM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00061" var="CM00061" />



<script>
	
	$(document).ready(function(){
		fnViewFileItemDetail();
	});
	
	function fnViewFileItemDetail(){
		var url = "";		
		if("${accMode}" == "DEV"){
			url = "setItemTabMenu.do?option=${menuOption}"
				+"&level=${level}${varFilter}"
				+"&openItemIDs=${openItemIDs}"
				+"&showPreNextIcon=N"
				+"&showTOJ=${showTOJ}"
				+"&tLink=${tLink}"
				+"&accMode=${accMode}"
				+"&s_itemID=${s_itemID}"
				+"&rewBrdMgtID=${rewBrdMgtID}";	
		}else{
			url = "processItemInfo.do?option=${menuOption}"
				+"&itemViewPage=${itemViewPage}"
				+"&itemEditPage=${itemEditPage}"
				+"&hideBlocked=N&accMode=${accMode}"
				+"&level=${level}${varFilter}"
				+"&openItemIDs=${openItemIDs}"
				+"&showPreNextIcon=N"
				+"&showTOJ=${showTOJ}"
				+"&tLink=${tLink}"
				+"&accMode=${accMode}"
				+"&s_itemID=${s_itemID}"
				+"&rewBrdMgtID=${rewBrdMgtID}";	
		}

		var target = "viewFileItemMenuDiv";
		var data = "";
				
		ajaxPage(url, data, target);
	}
	
	function fnReportList() {
		var url = "objectReportList.do";
		var target = "viewFileItemMenuDiv";
		var data = "s_itemID=${s_itemID}&option=${option}&kbn=newItemInfo";
		
		ajaxPage(url, data, target);
	}
	
	function fnChangeMgt() {
		var url = "itemHistory.do";
		var target = "viewFileItemMenuDiv";
		var data = "s_itemID=${s_itemID}&myItem=${myItem}&itemStatus=${itemStatus}&backBtnYN=N";	
		ajaxPage(url, data, target);
	}
	
	function fnForumMgt(){
		var url = "forumMgt.do";
		var target = "viewFileItemMenuDiv";
		var data = "&s_itemID=${s_itemID}&BoardMgtID=4";
		ajaxPage(url, data, target);
	}
	
	function fnEditItemInfo() {
		var url = "processItemInfo.do";
		var target = "viewFileItemMenuDiv";
		var data = "itemID=${itemID}&s_itemID=${itemID}&option=${option}&itemEditPage=${itemEditPage}&itemViewPage=${itemViewPage}&accMode=DEV&scrnMode=E&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"; 
		ajaxPage(url, data, target);
	}
	
	function fnGoForumMgt2(){
		var url = "forumMgt.do";
		var target = "viewFileItemMenuDiv";
		var data = "&s_itemID=${itemID}&BoardMgtID=BRD120&varFilter=BRD120";
		ajaxPage(url, data, target);
	}
	
	function fnStandardMenu(menuID,menuName) {
		var url = "setItemTabMenu.do?option=${menuOption}"
				+"&level=${level}${varFilter}"
				+"&openItemIDs=${openItemIDs}"
				+"&showPreNextIcon=N"
				+"&showTOJ=${showTOJ}"
				+"&tLink=${tLink}"
				+"&accMode=${accMode}"
				+"&s_itemID=${s_itemID}"
				+"&rewBrdMgtID=${rewBrdMgtID}";			
		var target = "viewItemInfoFrm";
		var data = "";
				
		ajaxPage(url, data, target);
	}
	
	function fnOpenItemPop(pID, e){
		e.stopPropagation();
		var itemId = pID;
		if(itemId=="" || itemId=="0"){return;}
		
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+pID+"&scrnType=pop&screenMode=pop&accMode=${accMode}";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,itemId);
	}
	
	var checkOutFlag = "N";
	function fnQuickCheckOut(){
		var projectNameList = "${projectNameList}";
		
		if(checkOutFlag == "N") {
			if(parseInt(projectNameList)>0){
			    dhx.confirm({
			        text: "${CM00042}",
			        buttons: ["No", "Yes"],
			        css: "align-center"
			    }).then(function (result) {
			    	if(result){
			    		var url = "cngCheckOutPop.do?";
						var data = "s_itemID=${s_itemID}";
					 	var target = self;
					 	var option = "width=500px, height=350px, left=200, top=100,scrollbar=yes,resizble=0";
					 	window.open(url+data, 'CheckOut', option);
					 	checkOutFlag = "Y";
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
		if(checkInOption == "03" || checkInOption == "03A" || checkInOption == "03B"){
		    dhx.confirm({
		        text: "${CM00061}",
		        buttons: ["No", "Yes"],
		        css: "align-center"
		    }).then(function (result) {
		    	if(result){
					goApprovalPop();
				}
				fnItemMenuReload();	
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
	
	function thisReload(){
		fnOpenTab("${s_itemID}",'', "${itemInfo.ClassVarFilter}");
	}
		
	function fnItemMenuReload(){
		fnOpenTab("${s_itemID}",'', "${itemInfo.ClassVarFilter}");
	}
	
	function fnSubscribe(){
		if(confirm("Do you really subscibe this item?")){
			var url = "saveRoleAssignment.do";
			var data = "itemID=${s_itemID}&assignmentType=SUBSCR&accessRight=R&assigned=1&memberID=${sessionScope.loginInfo.sessionUserId}&seq=";
			var target = "blankFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnUnSubscribe(){
		if(confirm("Do you really unsubscibe this item?")){
			var url = "deleteRoleAssignment.do";
			var data = "seqArr=${myItemSeq}";
			var target = "blankFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnRoleCallBack(){
		fnOpenTab("${s_itemID}",'', "${itemInfo.ClassVarFilter}");
	}
	
	function fnEditItemInfo(){		
		var url = "processItemInfo.do?option=${menuOption}"
			+"&itemViewPage=${itemViewPage}"
			+"&itemEditPage=${itemEditPage}"
			+"&hideBlocked=N&accMode=${accMode}"
			+"&level=${level}${varFilter}"
			+"&openItemIDs=${openItemIDs}"
			+"&showPreNextIcon=N"
			+"&showTOJ=${showTOJ}"
			+"&tLink=${tLink}"
			+"&accMode=${accMode}"
			+"&s_itemID=${s_itemID}"
			+"&rewBrdMgtID=${rewBrdMgtID}"
			+"&scrnMode=E";	

		var target = "viewFileItemMenuDiv";
		var data = "";
				
		ajaxPage(url, data, target);
	}
	
</script>

<style>

	.circle{	
		width:18px;
		height:18px;
		border-radius:50%;
		background:#86A4D4;
		font-size:12px;
		color:#ffffff;
		text-align:center;
		line-height:18px;	
	}
	.mdi:hover {background:#EFF2F4;}
	.nobg:hover {background:none;}
	.txtBtn:hover {background:#EFF2F4;}
	

</style>
	
<form name="viewItemInfoFrm" id="viewItemInfoFrm" action="#" method="post" onsubmit="return false;" style="height: 100%;">
	<c:if test="${accMode ne 'DEV'}" >
		<div id="cont_Header">
			<div class="pdT10">	
				
			   	<div class="align-center flex justify-between mgB5">
			   		<div style="color: #3f3c3c;">
			   		<img src="${root}${HTML_IMG_DIR_ITEM}/${itemInfo.ItemClassImg}" style="vertical-align: text-top !important;" class="mgR10 mgL10">
					  	<b style="font-size:16px;" class="mgR10">${itemInfo.Identifier}&nbsp; ${itemInfo.ItemName}</b>
					  	<i class="mdi mdi-vector-arrange-above nobg pdR15" onclick="fnOpenItemPop(${s_itemID},event)" style="color:#767676; cursor:pointer; width:32px; height:32px; border-right:1px solid gray;"></i>
					  	<div class="icon_color_inherit mgL5" style="color:#767676; display:inline;">
					    	<i class="mdi mdi-comment-processing h32-icon"  onclick="fnForumMgt()"></i>
					  		<c:if test="${myItemCNT ne 0 }"><i class="mdi mdi-star h32-icon" style="color: #3C76FF;" onclick="fnUnSubscribe()"></i></c:if>
					  		<c:if test="${myItemCNT eq 0 }"><i class="mdi mdi-star h32-icon" onclick="fnSubscribe()"></i></c:if>
					  	</div>
					</div>
			   	</div>
			</div>	
			
			<div class="align-center flex justify-between mgB10 mgL45">
		   		<div style="color: #767676;">
		   		<div class="circle floatL mgT2"><c:set var="authorName" value="${itemInfo.Name}" /> ${fn:substring(authorName,0,1) }</div>
		   		<div class="floatR mgL8" style="line-height:22px;">
		   		<span style="font-size:12px;color: #3f3c3c;">${itemInfo.Name}</span>&nbsp;&nbsp;${itemInfo.OwnerTeamName}&emsp;|&emsp;
		   		${itemInfo.LastUpdated}&emsp;|&emsp;Ver.&nbsp;${itemInfo.Version}&emsp;	${itemInfo.ItemStatusText} 
		   		</div>
				</div>
				<div id="functions" class="pdR10">
						<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor' and itemEditPage ne '' }" > 
			   				<button class="cmm-btn mgR5" onclick="fnQuickCheckOut();">Check out</button>
			   				
			   				<button class="cmm-btn mgR5" onclick="fnEditItemInfo();">Edit</button>
		   				 </c:if>
		   				<button class="cmm-btn mgR5" onclick="fnReportList();">Report</button>
			   		</div>
		   	</div>
		</div>	
	</c:if>	
	<div id="viewFileItemMenuDiv" name="viewFileItemMenuDiv"<c:if test="${accMode ne 'DEV'}" > style="height: calc(100% - 81px);overflow: auto;border-top: 1px solid #ddd;"</c:if>></div>
</form>
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>


	