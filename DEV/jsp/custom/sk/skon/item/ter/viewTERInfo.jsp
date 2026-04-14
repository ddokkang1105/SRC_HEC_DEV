<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root"/>

<!DOCTYPE html>
<html lang="ko">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<!-- dhtmlx7  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.js?v=7.1.8"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.css?v=7.1.8">


<head>
<style>
	#itemDiv > div {
		padding : 0 10px;
	}
	
	.cont_title{
		border: 1px solid #dfdfdf;
	    border-bottom: 0;
	    padding: 5px 0px;
	    width: 20%;
	    text-align: center;
	    border-radius: 0 10px 0 0;
	}
	
	#refresh:hover {
		cursor:pointer;
	}
	
	.tdhidden{display:none;}
	#itemNameAndPath, #functions{
		display:inline;
   	 	line-height: 23px;
	}

	/*  스크롤바  */
	html, body {
	  height: 100%;
	  overflow-y: auto; 
	}
	
	iframe, textarea {
	  overflow-y: scroll; 
	}
	
	.info{
		  width: 10px;               
		  height: 10px;
		  background-image: "/cmm/sf/images/img_count.png"; 
		  background-repeat: no-repeat;  
		  background-position: center;  
		  background-size: 18px 18px;    
		  border: none;
		  background-color: transparent;
		  cursor: pointer;
	}
</style>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00057" var="CM00057"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00042" var="CM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00061" var="CM00061" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00059" var="CM00059" />

<script type="text/javascript">
	var chkReadOnly = true;	
</script>

<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
<script type="text/javascript">
var checkOutFlag = "N";
var scrnType="${scrnType}";

let itemListData = [];

$(document).ready(function(){
	getFileList();
	

	$(".chkbox").click(function() {
	    if( $(this).is(':checked')) {
	        $("#"+this.name).show();
	    } else {
	        $("#"+this.name).hide(300);
	    }
	});
	
	 $.ajax({
	        url: "/zSKON_cxnItemList.do",
	        type: "GET",
	        data: {
	        	itemID: ${itemID},
	        	languageID: ${sessionScope.loginInfo.sessionCurrLangType}
	        },
	        dataType: "json",
	        success: function (response) {
	  
	            itemListData = response.list; 
	            updateTable();
	        },
	    });
	
	$.ajax({
        url: "/getItemCSInfo.do", 
        type: "GET",
        data: {
        	itemID: ${itemID},
        	languageID: ${sessionScope.loginInfo.sessionCurrLangType}
        },
        dataType: "json",
        success: function (response) {
        	csListData = response.list; 
        	updateCSTable();
        },
    });
	
	$("#frontFrm input:checkbox:not(:checked)").each(function(){
		$("#"+$(this).attr("name")).css('display','none');
	});
/* 	if(itemOption!=="Y"){
		document.getElementById("cont_HeaderItem").style.display = "none";	
	} */
		 
		 window.addEventListener("DOMContentLoaded", function () {
			  const sourceElement = document.querySelector(".dhx_diagram__scale-container");
			  const targetElement = document.getElementById("subRelFrame");

			  if (sourceElement && targetElement) {
			    const height = sourceElement.clientHeight + "px"; 
			    targetElement.style.height = height; 
			  }
		});
	});
	

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function updateTable() {
	    let tableContent = "";
	    let no = 1;
	    itemListData.forEach((item) => {	    
	        if (item.ItemTypeCode === "OJ00001" || item.ItemTypeCode === "OJ00016" || item.ItemTypeCode === "OJ00007") {
	            tableContent += `<tr style='cursor:pointer;' onclick = "clickItemEvent('${"${item.id}"}')">
	            	<td >${"${no}"}</td>
	            	<td >${"${item.ItemName}"}</td>
	            	<td >${"${item.Identifier}"}</td>
	            	<td >${"${item.DocLevValue}"}</td>
	            	<td >${"${item.DocTypeValue}"}</td>
	            	<td style="text-align : left">${"${item.path}"}</td>
	            </tr>`;
	            no++; 
	       }
	    });
	    $("#itemTable").html(tableContent);
	}
	
	
	function updateCSTable() { //변경일자
		let tableContent = "";
		csListData.forEach((item) => {	    
	        if (item.ChangeStsCode !== 'MOD') {
	            tableContent += `<tr style='cursor:pointer;' onclick = "clickHistoryItemEvent('${"${item.ChangeSetID}"}','${"${item.ItemID}"}')">
	            	<td >${"${item.ChangeSts}"}</td> //구분
	            	<td >${"${item.Version}"}</td>   //개정번호
	            	<td >${"${item.RequestUserName}"}</td> //성명
	            	<td >${"${item.RequestUserTeamName}"}</td>  //부서
	            	<td >${"${item.RequestDate}"}</td> //변경일자
	            	<td >${"${item.Description}"}</td> //변경사유 (확인해보기)
	            </tr>`;
	       }
	    });
	    $("#itemCSTable").html(tableContent);
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
				filePath[0] = checkObjVal[2]
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
			window.open(url, "openViewerPop", "width="+w+", height="+h+",top=0,left=0,resizable=yes");
			//window.open(url,1316,h); 
		}
		else {
	
			var url  = "fileDownload.do?seq="+seq;
			ajaxSubmitNoAdd(document.frontFrm, url,"blankFrame");
		}
	}
	
	//===============================================================================
		
	function fnOpenTeamInfoMain(teamID){
		var w = "1200";
		var h = "800";
		var url = "orgMainInfo.do?id="+teamID;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function fnOpenAuthorInfo(authorID) {
		var url = "viewMbrInfo.do?memberID="+authorID;		
		window.open(url,'window','width=1200, height=700, left=400, top=100,scrollbar=yes,resizble=0');
	}
	
	// 관련문서 팝업 
	function clickItemEvent(trObj) {
		var url = "popupMasterItem.do?"
				+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
 				+"&id="+trObj
				+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	//변경이력 팝업 
	function clickHistoryItemEvent(cngtId,  ItemID) {
		var url = "popupMasterItem.do?"
			+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&id="+ItemID
				+"&changeSetID="+cngtId
				+"&scrnType=pop&accMode=OPS"
				
		var w = 1200;
		var h = 600; 
		itmInfoPopup(url,w,h);	
	}
	
	//edit버튼 클릭시
	function fnEditItemInfo() {
	 	var url = "processItemInfo.do";
		var data = "itemID=${itemID}&s_itemID=${itemID}&option=${option}"
		+"&itemEditPage=custom/sk/skon/item/ter/editTERInfo"
		+"&itemViewPage=${itemViewPage}&accMode=DEV&scrnMode=E"
		+"&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
		+"&defSiteCode=${defSiteCode}"
		+"&wfOptopn=V"
		+"&defDimValueID=${defDimValueID}"
		+"&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
		
		ajaxPage(url, data, "frontFrm"); 
	}
	
	//편집 저장후 콜백
	function fnCllbackEdit(itemID) {
	 	var url = "processItemInfo.do";
		var data = "itemID="+itemID+"&s_itemID="+itemID+"&option=${option}"
		+"&itemEditPage=custom/sk/skon/item/ter/editTERInfo"
		+"&itemViewPage=${itemViewPage}&accMode=DEV&scrnMode=E"
		+"&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
		+"&defDimValueID=${defDimValueID}"
		+"&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
		
		ajaxPage(url, data, "frontFrm");
	}
	
	//Standardmenu
	function fnChangeMenu(menuID,menuName) {
		itemOption = "N";

		if(menuID == "management"){
			parent.fnGetMenuUrl("${itemID}", "Y");			
		}
	}
	
	// Reload
	function fnMenuReload() {
     	var url = "processItemInfo.do";
		var data = "itemID=${itemID}&s_itemID=${itemID}&option=${option}&itemEditPage=${itemEditPage}&itemViewPage=${itemViewPage}&scrnMode=V"
			+"&accMode=${accMode}&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
			+"&url=/custom/sk/skon/item/ter/viewTERInfo&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}"
			+"&defDimValueID=${defDimValueID}"
			+(scrnType === "pop" ? "&scrnType=pop" : "");
		ajaxPage(url, data, "frontFrm");
	}
	
	
	// callbakc - goApprovalPop
	function fnItemMenuReload() {
		fnEditItemInfo();
	}
	
	// check out 실행 함수 
	function fnQuickCheckOut(avg){
	  // var defCSRID="${projectID}";
	   var changeType = avg;
	
		if(checkOutFlag == "N") {				
				dhtmlx.confirm({
					ok: "Yes", cancel: "No",
					text: "${CM00042}",
					width: "310px",
					callback: function(result){
						if(result){
							var url = "cngCheckOutPop.do?";
							var data = "changeType="+changeType+"&s_itemID=${itemID}";
						 	var target = self;
						 	var option = "width=500px, height=350px, left=200, top=100,scrollbar=yes,resizble=0";
						 	window.open(url+data, 'CheckOut', option);
						 	checkOutFlag = "Y"; 						
						}
					}		
				});  
		}
	
	}

	
	// [Rework] click
	function rework() {
		if (confirm("${CM00059}")) {
			var url = "rework.do";
			var data = "item=${itemInfo.ItemID}&cngt=${itemInfo.CurChangeSet}&pjtId=${itemInfo.ProjectID}&defDimValueID=${defDimValueID}"; 
			
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
	
	
	function goList(){
		var url = "zSKON_searchPrcList.do";
		var data = "&url=/custom/sk/skon/item/ter/searchTERList&defClassList=CL12007&screenOption=Y"
					+"&defDimValueID=${defDimValueID}&itemID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";		
		ajaxPage(url, data, "frontFrm");
	}
		
	function fnUpdateItemDeleted() {
		if(confirm("${CM00042}")){
			ajaxPage("deleteItem.do", "&s_itemID=${itemID}", "saveFrame");
			// insertVisitLog
			ajaxPage("setVisitLog.do", "ActionType=RPT&MenuID=RP00035&ItemId=${itemID}", "saveFrame");
		}
	}
	
	function fnRevWithdraw() {
		dhtmlx.confirm({
			ok: "Yes", cancel: "No",
			text: "${CM00042}",
			width: "310px",
			callback: function(result){
				if(result){
					ajaxPage("withdrawCS.do", "itemID=${itemID}", "saveFrame");						
				}
			}		
		});
	}
	
	// call back - fnUpdateItemDeleted
	function doCallBack() {
		goList();
	}
	
// 	function editAuthor(){ //Transfer 기존 버튼
// 	    var url = "selectOwnerPop.do";
// 	    var option = "width=550, height=350, left=300, top=300,scrollbar=yes,resizble=0";
// 	    window.open("", "SelectOwner", option);
// 	    document.popupForm.action=url;
// 	    document.popupForm.method="post";
// 	    document.popupForm.target="SelectOwner";
// 	    document.popupForm.submit();
// 	}

	function fnTransferItem(){//Take Over 버튼 기능 가져옴
		var w = 550;
		var h = 350;
		var url = "selectOwnerPop.do";
		var data = "items=${s_itemID}&authorID=${sessionScope.loginInfo.sessionUserId}&authorName=${sessionScope.loginInfo.sessionUserNm}&myTransfer=Y";
		window.open(url+"?"+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	// callback - 담당자 변경
	function urlReload() {
		fnMenuReload();
	}
	
	async function getFileList() {
	    document.querySelector("#fileList").innerHTML = '';

	    const res = await fetch("/getFileList.do?documentID=${itemID}&docCategory=ITM&languageID=${sessionScope.loginInfo.sessionCurrLangType}&changeSetID=${changeSetID}&hideBlocked=N");
	    const data = await res.json();
	    
	    let html = "";
	    
	    if(data !== undefined && data !== null && data !== '') {
	    	// No / 문서유형 / 문서명 / 개정번호 / 작성자 / 등록일
			html += '<colgroup><col width="5%"><col width="15%"><col width="50%"><col width="10%"><col width="10%"><col width="10%"></colgroup>';
			html += '<tr><th>${menu.LN00024}</th><th>${menu.LN00091}</th><th>${menu.LN00101}</th><th>${menu.LN00356}</th><th>${menu.LN00060}</th><th>${menu.LN00078}</th></tr>';
			html += '<tbody name="file-list">';
			for(var i = 0; i < data.data.length; i++) {
				html += '<tr>';
				html += '<td>'+data.data[i].RNUM+'</td>';
				html += '<td>' + data.data[i].FltpName + '</td>';
				html += '<td class="alignL pdL10 flex align-center"><span class="btn_pack small icon mgR20"  onclick="fileNameClick(\''+data.data[i].FileName+'\',\''+data.data[i].FileRealName+'\',\''+data.data[i].fileOption+'\',\''+data.data[i].Seq+'\',\''+data.data[i].ExtFileURL+'\')">';
				html += '<span class="';
				if(data.data[i].FileFormat.includes("doc")) html += 'doc';
				else if(data.data[i].FileFormat.includes("xl")) html += 'xls';
				else if(data.data[i].FileFormat.includes("pdf")) html += 'pdf';
				else if(data.data[i].FileFormat.includes("hw")) html += 'hwp'
				else if(data.data[i].FileFormat.includes("pp")) html += 'ppt';
				else html += "log";
				html += '"></span></span><span style="cursor:pointer;margin-left: 10px;" onclick="fileNameClick(\''+data.data[i].FileName+'\',\''+data.data[i].FileRealName+'\',\''+data.data[i].fileOption+'\',\''+data.data[i].Seq+'\',\''+data.data[i].ExtFileURL+'\')">'+data.data[i].FileRealName+'</span>&nbsp;&nbsp;';
				html += '<img src="${root}${HTML_IMG_DIR}/btn_view_en.png" onclick="fileNameClick(\''+data.data[i].FileName+'\',\''+data.data[i].FileRealName+'\',\''+data.data[i].fileOption+'\',\''+data.data[i].Seq+'\',\''+data.data[i].ExtFileURL+'\')" style="cursor:pointer;">';
				/* if("${myItem}" == "Y") */ html += '&nbsp;&nbsp;<img src="${root}${HTML_IMG_DIR}/btn_down_en.png" onclick="fileNameClick(\''+data.data[i].FileName+'\',\''+data.data[i].FileRealName+'\',\'\',\''+data.data[i].Seq+'\',\''+data.data[i].ExtFileURL+'\')" style="cursor:pointer;">';
				html += '</td>';
				html += '<td>'+data.data[i].Version+'</td>';
				html += '<td>'+data.data[i].WriteUserNM+'</td>';
				html += '<td>'+data.data[i].CreationTime+'</td>';
				html += '</tr>';
			}
			html += '</tbody>';
			document.querySelector("#fileList").insertAdjacentHTML("beforeend", html);
	    }
	}
	
	function openImagePopup() {
	    fetch("/setPopupToken.do")
	      .then(() => {
	        let w = 1100, h = 700;
	        window.open("zSKON_TER2openImagePopup.do", "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	      });
	}
	
</script>
</head>
<body>
<form name ="popupForm" >
	<input type="hidden" id="items" name="items" value="${itemID}">
	<input type="hidden" id="hideOption" name="hideOption" value="Y">
</form>
<!-- BIGIN :: -->
<form name="frontFrm" id="frontFrm" action="#" method="post" enctype="multipart/form-data" onsubmit="return false;"> 

	<div id=htmlReport style="width:100%;overflow-y:auto;overflow-x:hidden;">
	<!-- 헤더값 -->
	<div id="cont_HeaderItem" >	
		<div class="pdL10 pdT10 pdB10" id="titWrap" style="width:99%;">
			<ul style="display: inline-block;">
				<li>
					<div id="itemNameAndPath">					
				   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${itemInfo.ItemTypeImg}" OnClick="fnOpenParentItemPop('${parentItemID}');" style="cursor:pointer;">
						  	<font color="#3333FF"><b style="font-size:13px;">${prcList.Identifier}&nbsp;${prcList.ItemName}</b></font>&nbsp;						  		   	
							<c:forEach var="path" items="${itemPath}" varStatus="status">							
								<c:choose>
									<c:when test="${status.first}">(${path.PlainText}</c:when>
									<c:when test="${status.last}">>&nbsp;${path.PlainText})	</c:when>
									<c:otherwise>>&nbsp;${path.PlainText}</c:otherwise>
								</c:choose>	
							</c:forEach>		  
				   	</div>&nbsp;
				   	
					<div id="functions">
					    <c:if test="${scrnType ne 'pop' }">
							 <span class="btn_pack medium icon"><span class="pre"></span><input value="List" type="button" onclick="goList()"></span> 
						</c:if>			
				        <c:if test="${scrnType ne 'pop' && accMode ne 'OPS' && (itemInfo.AuthorID == sessionScope.loginInfo.sessionUserId || sessionScope.loginInfo.sessionAuthLev eq '1')}" >
							<c:if test="${itemInfo.Blocked eq '0' && itemInfo.Status ne 'DEL1'}" >							  		
						         <span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="button" onclick="fnEditItemInfo()"></span> 						
						    </c:if>
						    <c:if test="${quickCheckOut eq 'Y' and itemInfo.CheckInOption ne '00' && itemInfo.Deleted ne '1'}" >
				   				 <span class="btn_pack small icon"><span class="checkout"></span><input value="Edit" type="button" onclick="fnQuickCheckOut('')"></span> 	
					   		</c:if>
					   		
					   		 <!-- 릴리즈 상태에서  폐기 >> VIEW >> Approval Request 
					   		 <c:if test="${quickCheckOut eq 'Y' && itemInfo.Deleted ne '1' && itemInfo.CheckInOption eq '03A' }" >
				   				<span class="btn_pack medium icon"><span class="delete"></span><input value="Discard" type="button" onclick="fnQuickCheckOut('DEL')"></span>			
					   		</c:if> -->
					   	    						   		
							<!-- 변경 담당자  Rework -->
				            <c:if test="${itemInfo.AuthorID == sessionScope.loginInfo.sessionUserId}" >
				                 <!-- CS 작성 완료 후 결재 상신 전인 경우 -->
				                <c:if test="${itemInfo.CSStatus == 'CMP' && itemInfo.Status ne 'DEL2'}" >
					           &nbsp;<span class="btn_pack medium icon"><span class="confirm"></span><input value="Rework" onclick="rework()" type="submit"></span>  					
				        		</c:if>	
				        
				        		<!-- CS 결재 반려된 경우 -->
				        		<c:if test="${itemInfo.WFInstanceID != ''  && itemInfo.WFStatus eq '3' && itemInfo.CSStatus == 'HOLD'}" >
				        		  &nbsp;<span class="btn_pack medium icon"><span class="confirm"></span><input value="Rework" onclick="rework()" type="submit"></span>					      
				        		</c:if> 
				        
				        		<!-- CS 결재 상신 후 결재 취소 -->
				        		<c:if test="${itemInfo.WFInstanceID != ''  && itemInfo.WFStatus eq '1' && itemInfo.CSStatus == 'APRV' && wfInstanceON eq 'N' }" >
				        		  &nbsp;<span class="btn_pack medium icon"><span class="confirm"></span><input value="Withdraw Approval Req." onclick="withdrawAprvReq()" type="submit"></span> 					     
				        		</c:if> 
				        	</c:if>		
				        	     <!--  신규 생성 후 Item 삭제 -->
					        <c:if test="${itemInfo.Blocked ne '2' && itemInfo.Status eq 'NEW1' }" >
							     <span class="btn_pack medium icon"> <span class="delete"></span>
							        <input value="Delete" type="button" onclick="fnUpdateItemDeleted()">
							    </span> 								
							</c:if>
							<c:if test="${itemInfo.Status eq 'MOD1'}">
								<span class="btn_pack small icon"> <span class="report"></span><input value="Rev. withdraw" type="button" onclick="fnRevWithdraw()"></span>
							</c:if>
						</c:if>	
						 <span class="btn_pack medium icon"><span class="reload"></span><input value="Reload" type="button" onclick="fnMenuReload()"></span> 
						 <c:if test="${scrnType ne 'pop' }">
<%-- 							 <c:if test="${itemInfo.AuthorID == sessionScope.loginInfo.sessionUserId}" > --%>
<%-- 							 <c:if test="${sessionScope.loginInfo.sessionAuthLev eq '1'}" > 다만 변경 권한이 ALL이면 C:if 조건이 필요없음 일단 주석 --%>
<!-- 								 <span class="btn_pack medium icon"><span class="gov"></span><input value="Transfer" type="button" onclick="fnTransferItem()"></span> -->
<%-- 							 </c:if>  --%>
							<c:if test="${itemInfo.Status eq 'REL'}">
								 <span class="btn_pack medium icon"><span class="gov"></span><input value="Take Over" type="button" onclick="fnTransferItem()"></span>
						  	</c:if>
						</c:if>
			   	</div>				
			  </li>
			</ul>
			<c:if test="${sessionScope.loginInfo.sessionAuthLev eq'1'}" >
				<span class="btn_pack small icon mgR25" style="float: right;"><input value="Standard Menu" type="button" style="padding-left: 2px;" onclick="fnChangeMenu('management','Management');"></span>
			</c:if> 
		</div>
	</div>
	
	<div id="menuDiv" style="margin:0 10px;border-top:1px solid #ddd;" >
		<div id="itemDescriptionDIV" name="itemDescriptionDIV" style="width:100%;text-align:center;">
		</div>
	</div>
		
	<div id="itemDiv">
		<div style="height: 22px; padding-top: 10px; width: 100%;">
			<ul>
				<li class="floatR pdR20">
					<input type="checkbox" class="mgR3 chkbox" name="process" id="process_chk" checked><label for="process_chk" class="mgR3">${menu.LN00005}</label>
					<input type="checkbox" class="mgR3 chkbox" name="file" id="file_chk" checked><label for="file_chk" class="mgR3">${menu.LN00019}</label>
					<c:if test="${scrnType ne 'pop' }">
					<input type="checkbox" class="mgR3 chkbox" name="history" id="history_chk" checked><label for="history_chk" class="mgR3">${menu.LN00012}</label>
					</c:if>
				</li>
			</ul>
		</div>
		
			<!-- BIGIN :: 기본정보 -->
			<div id="mainprocess" class="mgB10" style="width:99%">
			<div id="process" class="mgB10">
			
			<p class="cont_title">${menu.LN00005}</p>
			<table class="tbl_preview mgB10">
				<colgroup>
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
				</colgroup>
				
				<!-- 문서번호 / Rev / 작성자 / 작성자 소속 / 관련 문서 -->
				<tr>
					<th class="last">${menu.ZLN0068}</th>
					<td class="alignL pdL10 pdR10 last">${prcList.Identifier}</td> <!-- 문서번호 -->
					<th>${menu.ZLN0154}</th>
<%-- 					<td class="alignL pdL10 pdR10 last">${prcList.Version}<span style="font-weight:bold; margin-left:5px;">(${csInfo.CSStatusName})</span></td> <!-- Rev --> --%>
					<td class="alignL pdL10 pdR10 last">${prcList.Version}<span style="font-weight:bold; margin-left:5px;">(${itemInfo.StatusName})</span></td> <!-- Rev -->	
					<th class="last">${menu.LN00060}</th>
				    <td class="alignL pdL10 pdR10 last">${prcList.AuthorName}</td> <!-- 작성자 -->	
				    <th class="last">${menu.ZLN0155}</th>
				    <td class="alignL pdL10 pdR10 last">${prcList.OwnerTeamName}</td> <!-- 작성자 소속 -->	
				</tr>
							
				<!-- Site / 공정 / 적용 모델 / 문서목적 -->
				<tr>
				    <th class="last">${menu.ZLN0037}</th>
					<td class="alignL pdL10 pdR10 last">${dimResultMap.dimValueNames}</td> <!-- Site -->
				    <th class="last">${menu.ZLN0044}</th>
				   	<td class="alignL pdL10 pdR10 last">${attrMap.ZAT03260}</td> <!-- 공정 -->	
				    <th class="last">${menu.ZLN0157}</th>
				   	<td class="alignL pdL10 pdR10 last">${attrMap.ZAT04006}</td> <!-- 적용 모델 -->	
				    <th class="last">${menu.ZLN0152}
				    	&nbsp;<span class="info"><input  type="submit" id="add" onClick="openImagePopup()"></span> <!-- skon에는 이미지가 다름 -->	
				    </th>
				   	<td class="alignL pdL10 pdR10 last">${attrMap.ZAT04003}</td> <!-- 문서목적 -->		
				</tr>

				<tr>
					<th>${menu.ZLN0151}</th>	<!-- 보고제목  -->
					<td colspan="8" class="alignL pdL10 pdR10 last">${prcList.ItemName}</td> 
				</tr>
				<tr>
					<th>${menu.ZLN0070}</th>	<!-- 키워드  -->
					<td colspan="8" class="alignL pdL10 pdR10 last">${attrMap.AT01007}</td> 
				</tr>
				<tr>
					<th>${menu.LN00023}</th>	<!-- 변경사유 -->
					<td colspan="8" class="alignL pdL10 pdR10 last">${csInfo.Description}</td> 
				</tr>
		</table>
		<div class="infoMsg alignL pdL10" style="margin-top:10px; color: #555;">
			 ${menu.ZLN0161}
		</div>
		</div>
	<!--  //end 기본정보 -->	
	
	<!-- 첨부문서 --> 
	<div id="file" class="mgB30 pdT15">
		<p class="cont_title mgB10">${menu.LN00019}(Link)</p>
		<table  class="tbl_preview" id="fileList"></table>
	</div>
	
	
	<!-- 연관문서 -->
		<div id="relatedProcess" class="mgB30 pdT15">
   		<p class="cont_title">${menu.ZLN0086}(Link)</p>
		    <div id="cxn">
		        <table class="tbl_preview mgB10"  border="1">
		            <colgroup>
		                <col width="5%">
		                <col width="10%">
		                <col width="20%">
		                <col width="35%">
		                <col width="15%">
		                <col width="20%">
		            </colgroup>
		            <thead>
		                <tr>
		                	<!--  No / 문서명 / 문서번호/ 문서레벨 / 문서유형 / 문서경로  -->
		                    <th>${menu.LN00024}</th>
		                    <th>${menu.LN00101}</th>
		                    <th>${menu.ZLN0068}</th>
		                    <th>${menu.ZLN0075}</th>
		                    <th>${menu.LN00091}</th>
		                    <th>${menu.LN00102}</th>
		                </tr>
		            </thead>
		            <tbody id="itemTable">
		            </tbody>
		        </table>    
		    </div>    
		</div>
	
	
	<!-- 변경이력-->	
	<c:if test="${scrnType ne 'pop' }">
	<div id="history" class="mgB10">
  		<p class="cont_title mgB10">${menu.LN00012}(Link)</p>
	    <div id="cxn">
	        <table class="tbl_preview mgB10">
	            <colgroup>
					<col width="10%">
					<col width="10%">
					<col width="20%">
					<col width="20%">
					<col width="20%">
					<col width="20%">
				</colgroup>
	            <thead>
	                <tr>
						<!-- 구분 / 개정번호 / 성명 / 부서 / 변경일자 / 변경사유 -->
						<th>${menu.LN00042}</th>
						<th>${menu.LN00356}</th>
						<th>${menu.ZLN0158}</th>
						<th>${menu.LN00104}</th>
						<th>${menu.ZLN0159}</th>
						<th>${menu.LN00023}</th>
	                </tr>
	            </thead>
	            <tbody id="itemCSTable">
	            </tbody>
	        </table>    
	    </div>    
	</div>
	</c:if>
	
	</div> <!-- mainprocess -->
	</div> <!-- itemDiv -->
</div>
</form>
</body>
</html>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
