<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root"/>
  <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%-- <jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/> --%>
<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<head>
<style>
/*   html, body {
        height: 100%;
        margin: 0;
        padding: 0;
        overflow: auto; /* 페이지 전체에 스크롤 */
    } */
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
	

 	.new {
		color:blue;
		font-weight:bold
	}
	.mod {
		color:orange;
		font-weight:bold
	}
	.remain{
	color:#000000;
	}

</style>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00057" var="CM00057"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00042" var="CM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00061" var="CM00061" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00059" var="CM00059" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00180" var="WM00180"/>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00073" var="CM00073"/>

<script type="text/javascript">
	var chkReadOnly = true;	
</script>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
<script type="text/javascript">
const defSiteCode = "${defSiteCode}";
const defDimValueID ="${defDimValueID}";
var checkOutFlag = "N";
var scrnType="${scrnType}";


let itemListData = [];
let accRight = "${accRight}";
let nctInfo="";
$(document).ready(function(){
	//getDefSKONAttr();
	//fnZAT01090Change(nctInfo);
	
	getDefSKONAttr(() => {
		if (nctInfo === "Y") {
			fnZAT01090Change(nctInfo);
			document.getElementById("nctMessageDiv").style.display = "";
		}
	});
	
	(async () => {
		if("${accRight}" == "") accRight = await getItemAccRight("${itemID}");

		if(accRight == "Y") {
			document.getElementsByName("frontFrm").forEach(e => e.style.display = "block")
			var itemOption = "${itemOption}";
			
			updateCheckboxes();
			$(".chkbox").click(function() {
			    if( $(this).is(':checked')) {
			        $("#"+this.name).show();
			    } else {
			        $("#"+this.name).hide(300);
			    }
			});
			
			$("#frontFrm input:checkbox:not(:checked)").each(function(){
				$("#"+$(this).attr("name")).css('display','none');
			});
				
				
			var  url = "zSKON_MindMap.do";  
			var data = "s_itemID=${itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&frameName=subRelFrame&TsdYN=Y";

			 ajaxPage(url, data, "subRelFrame");
			 
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

			 
			 window.addEventListener("DOMContentLoaded", function () {
				  const sourceElement = document.querySelector(".dhx_diagram__scale-container");
				  const targetElement = document.getElementById("subRelFrame");

				  if (sourceElement && targetElement) {
				    const height = sourceElement.clientHeight + "px"; 
				    targetElement.style.height = height; 
				  }
			});
		} else {
			alert("${WN00180}");
			document.frontFrm.innerHTML = "";
		}
	 })();
	});
	
//아이템 생성후 attr 속성 리스트 API 
function getDefSKONAttr(callback){
	
		fetch("/zSKON_getDefSKONAttr.do?itemID=${itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&defDimValueID=${defDimValueID}"
				+"&curItemID=${itemID}")
		.then(res => res.json())
		.then(data => {
		
		    let defAttrInfoList = data.defAttrInfo;//속성
		    let docType ="";
		
		        // "siteNM"이 있는 객체 찾기
		        let ZAT01010VAL = defAttrInfoList.find(e => e.AttrTypeCode ==="ZAT01010");
		         if (ZAT01010VAL) { //담당site명
		            document.getElementById("siteName").innerText = ZAT01010VAL.PlainText;      
		        }
	         
		        let ZAT01030val= defAttrInfoList.find(e => e.AttrTypeCode === "ZAT01030"); //영역 
		    	// 영역 
		        if(ZAT01030val){
		        	document.getElementById("ZAT01030VAL").innerText = ZAT01030val.PlainText;	
		        }
		        
		        //문서레벨
		        let ZAT01020val = defAttrInfoList.find(e => e.AttrTypeCode  === "ZAT01020"); //문서레벨 
		
		         if(ZAT01020val){
		        	 document.getElementById("ZAT01020VAL").innerText = ZAT01020val.PlainText;
		      
		         }
		        //문서분야 
		
		        let ZAT01040val = defAttrInfoList.find(e => e.AttrTypeCode  === "ZAT01040"); //문서레벨 
		        if(ZAT01040val){
		        	document.getElementById("ZAT01040VAL").innerText = ZAT01040val.PlainText;
		            // nctInfo = ZAT01040val.PlainText;
		        }
		        
		        //문서유형 
		        let ZAT01060VAL = defAttrInfoList.find(e => e.AttrTypeCode ==="ZAT01060"); 
		        if(ZAT01060VAL){
		        	 document.getElementById("ZAT01060VAL").innerText = ZAT01060VAL.PlainText;
		        	 docType = ZAT01060VAL.LovCode;
		        	
		         }
		        
		        //공정 
		        let ZAT01050VAL = defAttrInfoList.find(e => e.AttrTypeCode ==="ZAT01050"); 
		        if(ZAT01050VAL){
		        	 document.getElementById("ZAT01050VAL").innerText = ZAT01050VAL.PlainText;
		        
		       
		         }
		        //상세공정 
		        let ZAT01051VAL = defAttrInfoList.find(e => e.AttrTypeCode ==="ZAT01051"); 
		        if(ZAT01051VAL){
		        	 document.getElementById("ZAT01051VAL").innerText = ZAT01051VAL.PlainText;
		        }
		        
		        // nct 대상 
		        let ZAT00040VAL = defAttrInfoList.find(e => e.AttrTypeCode ==="AT00040"); 
		        if(ZAT00040VAL){
		        	 document.getElementById("ZAT00040VAL").innerText = ZAT00040VAL.PlainText;
		        	 nctInfo = ZAT00040VAL.PlainText;
		        }
		        
		        let ZAT01090VAL = defAttrInfoList.find(e => e.AttrTypeCode ==="ZAT01090"); 
		        if(ZAT01090VAL){
		        	 document.getElementById("ZAT01090VAL").innerText = ZAT01090VAL.PlainText;

		        }
		        
		        //모델
		        let ZAT09005VAL = defAttrInfoList.find(e => e.AttrTypeCode ==="ZAT09005"); 
		        if(ZAT09005VAL){
		        	 document.getElementById("ZAT09005VAL").innerText = ZAT09005VAL.PlainText;
		        } 
		        
		        //라인
		        let ZAT09006VAL = defAttrInfoList.find(e => e.AttrTypeCode ==="ZAT09006"); 
		        if(ZAT09006VAL){
		        	 document.getElementById("ZAT09006VAL").innerText = ZAT09006VAL.PlainText;
		        }
		        
		        //제품코드
		        let ZAT09007VAL = defAttrInfoList.find(e => e.AttrTypeCode ==="ZAT09007"); 
		        if(ZAT09007VAL){
		        	if(docType =="CP"){
		        	 //console.log(docType);
		        	 document.getElementById("prodCode").style.display="";
		        	 document.getElementById("ZAT09007VAL").innerText = ZAT09007VAL.PlainText;
		        	}

		        }
		        
		        if (typeof callback === "function") callback();
		
		});
	
}

	
	async function getItemAccRight(itemID) {
		let result = "";
		await fetch("getItemAccRight.do?itemID="+itemID+"&userID=${sessionScope.loginInfo.sessionUserId}")
		.then(res => res.json())
		.then(res => {
			result = res.data
		})
		return result;
	}
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function updateTable() {
	    let tableContent = "";
	    let no = 1;
	    itemListData.forEach((item) => {	    
	        if (item.ItemTypeCode === "OJ00001" || item.ItemTypeCode === "OJ00016") {
	            tableContent += `<tr style='cursor:pointer;' onclick = "clickItemEvent('${"${item.id}"}')">
	            	<td >${"${no}"}</td>
	            	<td >${"${item.DocLevValue}"}</td>
	            	<td >${"${item.DocTypeValue}"}</td>
	            	<td style="text-align : left">${"${item.path}"}</td>
	            	<td >${"${item.ItemName}"}</td>
	            	<td >${"${item.Identifier}"}</td>
	            </tr>`;
	            no++; 
	       }
	    });
	    $("#itemTable").html(tableContent);
	}
	
	function updateCSTable() {
		let tableContent = "";
		csListData.forEach((item) => {	    
	        if (item.ChangeStsCode !== 'MOD') {
	            tableContent += `<tr style='cursor:pointer;' onclick = "clickHistoryItemEvent('${"${item.ChangeSetID}"}','${"${item.ItemID}"}')">
	            	<td >${"${item.ChangeType}"}</td>
	            	<td >${"${item.Identifier}"}</td>
	            	<td class="alignL pdL10">${"${item.ItemName}"}</td>
	            	<td >${"${item.Version}"}</td>
	            	<td >${"${item.RequestUserName}"}</td>
	            	<td >${"${item.RequestUserTeamName}"}</td>
	            	<td >${"${item.ApproveDate}"}</td>
	            	<td >${"${item.ChangeSts}"}</td>
	            </tr>`;
	       }
	    });
	    $("#itemCSTable").html(tableContent);
	   } 

	
	//NCT수출입여부 추가 
	function fnZAT01090Change(value){
		
		if(value==="Y"){ //nct y일때
		
		 	const AT00040td = document.getElementById("AT00040td");
			AT00040td.setAttribute("colspan","1");
			const ZAT01090th = document.getElementById("ZAT01090th");
			ZAT01090th.style.display = "table-cell";
			const ZAT01090td = document.getElementById("ZAT01090td");
			ZAT01090td.style.display = "table-cell"; 
			//fnSelect('ZAT01090', "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&lovCode="+value, 'getSubLovList', '', 'Select');
		}
		else { //nct N일때
			AT00040td.setAttribute("colspan","4");
			ZAT01090th.style.display = "none";
			ZAT01090td.style.display = "none";  
			//fnSelect('ZAT01090', data+"&attrTypeCode=ZAT01090", 'getAttrTypeLov', '', 'Select');
		}
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
			 var viewerForm = document.viewerForm;
			 var url = "openViewerPop.do";
			 window.open("" ,"viewerForm", "width="+screen.width+", height="+screen.height); 
			 viewerForm.action =url;
			 viewerForm.method="post";
			 viewerForm.target="viewerForm";
			 viewerForm.seq.value = +seq[0];
//			var url = "openViewerPop.do?seq="+seq[0];
//			var w = screen.width;
//			var h = screen.height;
			
			if(avg5 != "") { 
				viewerForm.isNew.value = "N";
//				url = url + "&isNew=N";
			}
			else {
				viewerForm.isNew.value = "Y";
//				url = url + "&isNew=Y";
			}
//			window.open(url, "openViewerPop", "width="+w+", height="+h+",top=0,left=0,resizable=yes");
//			//window.open(url,1316,h); 
			
			 viewerForm.submit();
		}
		else { 
	      //fileDownload
			
			/* if(nctInfo==="Y"){
				alert("${WM00180}");
			} */
			
			var url  = "fileDownload.do?seq="+seq;
		    ajaxSubmitNoAdd(document.frontFrm, url,"blankFrame");
		}
	}
	
	//===============================================================================
	
				var dimValueName = "${dimResultMap.dimValueNames}".split("/").map(function(value) {
		        return value.trim();  
		   		}); 
		

		   function updateCheckboxes() {
			
		       var checkboxes = document.querySelectorAll('input[type="checkbox"][name="siteCode"]');
		     //선택한 dimCode값 
		       var dimInfoMap = "${dimInfotMap}".replace(/[{}]/g, '');
		       var dimList  = dimInfoMap.split(',').map(function(pair){
		        	return pair.split('=')[0].trim();
		        }); 
			   
		      //체크박스 조정
		          checkboxes.forEach(function(checkbox) {
		           
		            if (dimList.includes(checkbox.id)) {
		                checkbox.checked = true;
		                checkbox.disabled = true;  
		            } else {
		                checkbox.checked = false;
		                checkbox.disabled = true;   
		            }
		        });
		  	  }
		  

	
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
	
	// 관련항목 팝업
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
		+"&itemEditPage=custom/sk/skon/item/tsd/editTSDInfo"
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
		+"&itemEditPage=custom/sk/skon/item/tsd/editTSDInfo"
		+"&itemViewPage=${itemViewPage}&accMode=DEV&scrnMode=E"
		+"&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
		+"&defSiteCode="+defSiteCode
		+"&defDimValueID=${defDimValueID}"
		+"&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}";
		
		ajaxPage(url, data, "frontFrm");
	}
	
	//HISTORY 클릭시
	function fnGoChangeMgt() {
		var url = "itemHistory.do";
		var target = "itemDescriptionDIV";
		var data = "s_itemID=${itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&myItem=${myItem}&itemStatus=${itemStatus}&backBtnYN=N";
		
		$("#itemDescriptionDIV").css('display','block');
		$("#itemDiv").css('display','none');
		ajaxPage(url, data, target);
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
					+"&url=/custom/sk/skon/item/tsd/viewTSDInfo&selectedTreeID=${selectedTreeID}&fixedDimValueID=${fixedDimValueID}"
					+"&defDimValueID=${defDimValueID}"
					+(scrnType === "pop" ? "&scrnType=pop" : "");
				ajaxPage(url, data, "frontFrm");
			}
			
	
	//Report
		function fnGoReportList() {
			var url = "objectReportList.do";
			var target = "itemDescriptionDIV";
			var accMode = $("#accMode").val();
			var data = "s_itemID=${itemID}&option=${option}&kbn=newItemInfo&accMode="+accMode; 
			$("#itemDescriptionDIV").css('display','block');
			$("#itemDiv").css('display','none');
			ajaxPage(url, data, target);
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
		    dhx.confirm({
		        text: "${CM00042}",
		        buttons: ["No", "Yes"],
		        css: "align-center"
		    }).then(function (result) {
		    	if(result){
		    		var url = "cngCheckOutPop.do?";
					var data = "changeType="+changeType+"&s_itemID=${itemID}";
				 	var target = self;
				 	var option = "width=500px, height=350px, left=200, top=100,scrollbar=yes,resizble=0";
				 	window.open(url+data, 'CheckOut', option);
				 	checkOutFlag = "Y";
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
		if (confirm("${CM00073}")) {	// 결재 취소하시겠습니까?
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
		var url = "zSKON_searchTsdItemList.do";
		var data = "&url=/custom/sk/skon/item/tsd/searchTSDList&defClassCode=CL16004&screenOption=Y"
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
	
	// call back - fnUpdateItemDeleted
	function doCallBack() {
		goList();
	}
	
	function editAuthor(){
	    var url = "selectOwnerPop.do";
	    var option = "width=550, height=350, left=300, top=300,scrollbar=yes,resizble=0";
	    window.open("", "SelectOwner", option);
	    document.popupForm.action=url;
	    document.popupForm.method="post";
	    document.popupForm.target="SelectOwner";
	    document.popupForm.submit();
	}
	
	// callback - 담당자 변경
	function urlReload() {
		fnMenuReload();
	}
	
	function fnRevWithdraw() {
	    dhx.confirm({
	        text: "${CM00042}",
	        buttons: ["No", "Yes"],
	        css: "align-center"
	    }).then(function (result) {
	    	if(result){
	    		ajaxPage("withdrawCS.do", "itemID=${itemID}", "saveFrame");
			}
	    });
	}
	
	function doCallBack(){
		
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
	
	function fnRoleCallBack() {
		fnMenuReload();
	}
</script>
</head>
<body>
<form name ="popupForm" >
	<input type="hidden" id="items" name="items" value="${itemID}">
	<input type="hidden" id="hideOption" name="hideOption" value="Y">
</form>
<form name ="viewerForm" >
	<input type="hidden" id="seq" name="seq" value="">
	<input type="hidden" id="isNew" name="isNew" value="">
</form>
<!-- BIGIN :: -->
<form name="frontFrm" id="frontFrm" action="#" method="post" enctype="multipart/form-data" onsubmit="return false;"> 

<div id=htmlReport style="width:100%;height:100vh;overflow-y:auto;overflow-x:hidden;">
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
							<c:choose>
						   		<c:when test="${itemInfo.SubscrOption eq '1' && myItem ne 'Y' && myItemCNT eq '0'}"  >
				        			 <span class="btn_pack small icon"><span class="unsubscribe"></span><input value="Subscribe" type="button" onclick="fnSubscribe()"></span>
						   		</c:when>
						   		<c:when test="${myItem ne 'Y' && myItemCNT ne '0'}"  >
				        			 <span class="btn_pack small icon"><span class="subscribe"></span><input value="Unsubscribe" type="button" onclick="fnUnsubscribe()"></span>
						   		</c:when>
					   		</c:choose>
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
						   		
						   		 <!-- 릴리즈 상태에서  폐기 >> VIEW >> Approval Request -->
						   		<c:if test="${quickCheckOut eq 'Y' && itemInfo.Deleted ne '1' && itemInfo.CheckInOption eq '03A' }" >
					   				<span class="btn_pack medium icon"><span class="delete"></span><input value="Discard" type="button" onclick="fnQuickCheckOut('DEL')"></span>	
					   				
						   		</c:if>
						   	    						   		
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
								 <c:if test="${itemInfo.AuthorID == sessionScope.loginInfo.sessionUserId || sessionScope.loginInfo.sessionAuthLev eq '1'}" >
									 <span class="btn_pack medium icon"><span class="gov"></span><input value="Transfer" type="button" onclick="editAuthor()"></span>
								 </c:if>
							 </c:if>
							 <!-- <button class="cmm-btn mgR5" style="height: 30px; margin-left:1px;" onclick="fnMenuReload()" value="Reload">Reload</button>	-->		
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
						<input type="checkbox" class="mgR3 chkbox" name="relatedProcess" id="relatedProcess_chk" checked><label for="relatedProcess_chk" class="mgR3">${menu.ZLN0086}</label>
						<input type="checkbox" class="mgR3 chkbox" name="cxnmMap" id="cxnmMap_chk" checked><label for="cxnmMap_chk" class="mgR3">${menu.ZLN0087}</label>
						<c:if test="${scrnType != 'pop'}">
						<input type="checkbox" class="mgR3 chkbox" name="history" id="history_chk" checked><label for="history_chk" class="mgR3">${menu.LN00012}</label>
						</c:if>
					</li>
				</ul>
			</div>
			<div id="nctMessageDiv" style="display: none;">
				<ul>
					<li class="floatR pdR20">
						<span class="floatR" style="text-align:center;color:#cd5e5e;font-weight: bold;margin-right:5px;">${menu.ZLN0148} ${menu.ZLN0149}</span>
					</li>
				</ul>
			</div>
			
			<!-- BIGIN :: 기본정보 -->
			<div id="mainprocess" class="mgB10" style="width:99%">
			<div id="process" class="mgB10">
			
				<!-- 기본정보 -->
				<p class="cont_title">${menu.LN00005}</p>
				<table class="tbl_preview mgB10">
					<colgroup>
				 	<col width="9%">
				 	<col width="9%">
				 	<col width="9%">
				 	<col width="9%">
				 	<col width="9%">
				 	<col width="9%">
				 	<col width="9%">
				 	<col width="9%">
				 	<col width="9%">
				 	<col width="9%">
				 	<col width="9%">
					</colgroup>
					
					<tr>
						<!-- 문서번호 -->
						<th>${menu.ZLN0068}</th>
						<td colspan="1" class="alignL pdL10">${prcList.Identifier}</td>
						<!-- 문서명 -->
						<th>${menu.LN00101}</th>
					    <td colspan="3" class="alignL pdL10">${prcList.ItemName}</td>				
						<!-- 개정번호 -->
						<th>${menu.LN00356}</th>
						<td colspan="4" class="alignL pdL10">${prcList.Version}<span style="font-weight:bold; margin-left:5px;">(${csInfo.CSStatusName})</span></td>
					</tr>

					<tr>
						<!-- 담당Site -->
					    <th>${menu.ZLN0089}</th>
					    <td colspan="1"  class="alignL pdL10">
					    <span id="siteName"></span>
					    </td>
					    <!-- 담당부서 -->				
						<th>${menu.ZLN0074}</th>
						<td class="alignL pdL10">${prcList.OwnerTeamName}</td>
						<!-- 담당자 -->
						<th>${menu.LN00004}</th>
						<td class = "alignL pdL10" id="authorInfo" >${prcList.AuthorName} </td>
						<!-- NCT대상 -->
						<th>${menu.ZLN0114}</th>
						<td id ="AT00040td" colspan="4" class="alignL pdL10" >
						<span id="ZAT00040VAL"></span>
						</td>
						<th id ="ZAT01090th"  style="display:none;">${menu.ZLN0032}</th>
						<td id ="ZAT01090td" colspan="2" class="alignL pdL10" style="display:none;" ><%-- ${attrMap.ZAT01090} --%>
							<span id="ZAT01090VAL"></span>
						</td>
						<!-- 프로젝트 -->
						<th style="display:none;">${menu.LN00131}</th>
						<td colspan="2" class="alignL pdL10"  style="display:none;">${prcList.ProjectName}</td>
					</tr>
					
					<tr>
						<!-- 영역 -->
				    	<th>${menu.ZLN0072}</th>
					    <td colspan="1" class="alignL pdL10">
					   	 <span id="ZAT01030VAL"></span>
					    </td>	
					    <!-- 문서유형 -->
					    <th>${menu.LN00091}</th>
						<td class="alignL pdL10">
						   <span id="ZAT01060VAL"></span>
						</td>
					    <!-- 문서분야 -->
					    <th>${menu.ZLN0085}</th>
					    <td class="alignL pdL10">
					    	<span id="ZAT01040VAL"></span>
					    </td>		
					    <!-- 문서레벨 -->
					    <th>${menu.ZLN0075}</th>
						<td colspan="4" class="alignL pdL10">
							<span id="ZAT01020VAL"></span>
						</td>
					</tr>
					
					<tr>
						<!-- 공정 -->
						<th>${menu.ZLN0044}</th>
						<td colspan="1" class="alignL pdL10">
						<span id="ZAT01050VAL"></span>
						</td>
						<!-- 상세공정 -->
						<th>${menu.ZLN0067}</th>
					    <td class="alignL pdL10">
					   	 <span id="ZAT01051VAL"></span>
					  </td>	
					    <!-- 모델 -->
					    <th>${menu.LN00125}</th>
						<td class="alignL pdL10">
						<span id="ZAT09005VAL"></span>
						</td>
						<!-- 라인 -->
						<th>${menu.ZLN0113}</th>
					    <td colspan="4" class="alignL pdL10">
					    <span id="ZAT09006VAL"></span>
					    </td>	
					</tr>

					<tr style="">
						<!-- 배포Site -->
					    <th>${menu.ZLN0031}</th>
					    <td style="">
					        <input type="checkbox" name="siteCode" id="cmm" value="cmm">
					        <label for="cmm">${menu.ZLN0028}</label>
					    </td>
					    <td style="border-left: 1px solid #ccc; width: 80px;">
					        <input type="checkbox" name="siteCode" id="SKO1" value="SKO1">
					        <label for="SKO1">${menu.ZLN0029}</label>
					    </td>
					    <td style="border-left: 1px solid #ccc; width: 80px;">
					       <input type="checkbox" name="siteCode" id="SKO2" value="SKO2">
					       <label for="SKO2">${menu.ZLN0030}</label>
					    </td>
					    <td style="border-left: 1px solid #ccc; width: 80px;">
					       <input type="checkbox" name="siteCode" id="SKBA" value="SKBA">
					       <label for="SKBA">${menu.ZLN0079}</label>
					    </td>
					    <td style="border-left: 1px solid #ccc; width: 80px;">
					       <input type="checkbox" name="siteCode" id="SKOH1" value="SKOH1">
					       <label for="SKOH1">${menu.ZLN0080}</label>
					    </td>
					    <td style="border-left: 1px solid #ccc; width: 80px;">
					       <input type="checkbox" name="siteCode" id="SKOH2" value="SKOH2">
					       <label for="SKOH2">${menu.ZLN0081}</label>
					    </td>
					    <td style="border-left: 1px solid #ccc; width: 80px;">
					       <input type="checkbox" name="siteCode" id="SKBM" value="SKBM">
					       <label for="SKBM">${menu.ZLN0082}</label>
					    </td>
					    <td style="border-left: 1px solid #ccc; width: 80px;">
					       <input type="checkbox" name="siteCode" id="SKOJ" value="SKOJ">
					       <label for="SKOJ">${menu.ZLN0083}</label>
					    </td>
					    <td style="border-left: 1px solid #ccc; width: 80px;">
					       <input type="checkbox" name="siteCode" id="SKOY" value="SKOY">
					       <label for="SKOY">${menu.ZLN0084}</label>
					    </td>
					    <td style="border-left: 1px solid #ccc; width: 80px;">
					       <input type="checkbox" name="siteCode" id="SKOS" value="SKOS">
					       <label for="SKOS">${menu.ZLN0150}</label>
					    </td>
					 </tr>
					
					<!-- 문서개요<br>(목적, 설명) -->
					<tr>
						<th>${menu.ZLN0094}<br>(${menu.LN00386}, ${menu.ZLN0116})</th>
						<td class="alignL pdL10" colspan="10" >
						<textarea  id="description" name="description"  style="height:100px;width:100%;" readonly="readonly">${prcList.Description}</textarea>
						</td>
					</tr>
					<!-- 주요개정사항 -->
					<tr>
						<th>${menu.LN00360}</th>
						<td class="alignL pdL10" colspan="10">						
							<textarea  id="Description" name="Description" style="width:100%;height:100px;" readonly="readonly">${csInfo.Description}</textarea> 
						</td>	
					</tr>
					<!-- 제품코드라인 -->
					<tr id = "prodCode" style="display:none;">
						<th>${menu.ZLN0120}</th>
						<td class="alignL pdL10" colspan="10" >
						<span id ="ZAT09007VAL"></span>
						
						</td>
					</tr>
					<!-- 키워드 -->
					<tr>
						<th>${menu.ZLN0070}</th>
						<td class="alignL pdL10" colspan="10">${attrMap.AT01007}</td>		
					</tr>
			</table>
		</div>
		<!--  //end 기본정보 -->	
			
		<!-- 첨부문서 --> 
		<div id="file" class="mgB30 pdT15">
			<p class="cont_title">${menu.LN00019}</p>
			<table class="tbl_preview">
				<colgroup>
					<col width="5%">
					<col width="15%">
					<col width="50%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
				</colgroup>	
				<tr>
					<!-- No / 문서유형 / 문서명 / 개정번호 / 작성자 / 등록일 -->
					<th>${menu.LN00024}</th>
					<th>${menu.LN00091}</th>
					<th>${menu.LN00101}</th>
					<th>${menu.LN00356}</th>
					<th>${menu.LN00060}</th>
					<th>${menu.LN00078}</th>
				</tr>
				<c:set value="1" var="no" />
				<c:forEach var="fileList" items="${attachFileList}" varStatus="status">
					<tr>
						<td>${no }</td>
						<td>${fileList.FltpName}</td>
						<td class="alignL pdL10 flex align-center">
								<span class="btn_pack small icon mgR20" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','${fileList.fileOption}','${fileList.Seq}','${fileList.ExtFileURL}');">
								
								<c:set var="FileFormat" value="${fileList.FileFormat}" />
									<span class="
											<c:choose>
												<c:when test="${fn:contains(FileFormat, 'do')}">doc</c:when>
												<c:when test="${fn:contains(FileFormat, 'xl')}">xls</c:when>
												<c:when test="${fn:contains(FileFormat, 'pdf')}">pdf</c:when>
												<c:when test="${fn:contains(FileFormat, 'hw')}">hwp</c:when>
												<c:when test="${fn:contains(FileFormat, 'pp')}">ppt</c:when>
												<c:otherwise>log</c:otherwise>
											</c:choose>
													"></span>
								</span>
								&nbsp;
								<span style="cursor:pointer;" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','${fileList.fileOption}','${fileList.Seq}','${fileList.ExtFileURL}');">${fileList.FileRealName}</span>
					&nbsp;&nbsp;
					<img src="${root}${HTML_IMG_DIR}/btn_view_en.png" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','${fileList.fileOption}','${fileList.Seq}','${fileList.ExtFileURL}');" style="cursor:pointer;">
					&nbsp;
					<%-- <c:if test="${myItem == 'Y'}"> --%>
					<img src="${root}${HTML_IMG_DIR}/btn_down_en.png" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.Seq}','${fileList.ExtFileURL}');" style="cursor:pointer;">
					<%-- </c:if> --%>
						</td> 
						<td>${fileList.Version}</td>
						<td>${fileList.WriteUserNM}</td>
						<td>${fileList.CreationTime}</td>
					</tr>
				<c:set var="no" value="${no+1}"/>
				</c:forEach>

			</table>
		</div>
			
		<!-- 연관문서 -->
		<div id="relatedProcess" class="mgB30 pdT15">
   		<p class="cont_title">${menu.ZLN0086}</p>
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
		                	<!--  No / 문서레벨 / 문서유형 / 문서경로 / 문서명 / 문서번호 -->
		                    <th>${menu.LN00024}</th>
		                    <th>${menu.ZLN0075}</th>
		                    <th>${menu.LN00091}</th>
		                    <th>${menu.LN00102}</th>
		                    <th>${menu.LN00101}</th>
		                    <th>${menu.ZLN0068}</th>
		                </tr>
		            </thead>
		            <tbody id="itemTable">
		            </tbody>
		        </table>    
		    </div>    
		</div>

		<!--  연관모델 -->
		<div id="cxnmMap" class="mgB30">
			<p class="cont_title">${menu.ZLN0087}</p>
			<div id="subRelFrame"  name="subRelFrame" style="width:100%;"></div>
		</div>
		
		
		<!-- 변경이력 -->
		<c:if test="${scrnType != 'pop'}">
		<div id="history" class="mgB10">
   		<p class="cont_title mgB10">${menu.LN00012}</p>
		    <div id="cxn">
		        <table class="tbl_preview mgB10">
		            <colgroup>
							<col width="5%">
							<col width="10%">
							<col width="10%">
							<col width="5%">
							<col width="15%">
							<col width="15%">
							<col width="5%">
							<col width="5%">
						</colgroup>
		            <thead>
		                <tr>
		                   	<!-- 변경구분 / 문서번호 / 문서명 / 개정번호 / 담당자 / 담당부서 / 제/개정일자 / 문서상태 -->
		                   	<th>${menu.LN00022}</th>
							<th>${menu.ZLN0068}</th>
							<th>${menu.LN00101}</th>
							<th>${menu.LN00356}</th>
							<th>${menu.LN00004}</th>
							<th>${menu.ZLN0074}</th>
							<th>${menu.ZLN0095}</th>
							<th>${menu.ZLN0071}</th>
		                </tr>
		            </thead>
		            <tbody id="itemCSTable">
		            </tbody>
		        </table>    
		    </div>    
		</div>						
		</c:if>

		</div>
		</div>
</div>
</form>
</body>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
</html>
