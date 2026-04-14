<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root"/>
 
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<!-- dhtmlx7  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<head>
<style>
	#itemDiv > div {
		padding : 0 10px;
	}
	.cont_title {
		margin:0;
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

$(document).ready(function(){	
	var itemOption = "${itemOption}";
	
/* 	if(itemOption!=="Y"){
		document.getElementById("cont_HeaderItem").style.display = "none";	
	} */

	getAttrByClass();
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
		
		var data = "s_itemID=${itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&frameName=subRelFrame";

		 ajaxPage(url, data, "subRelFrame_map");
		 
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
		            updateTermTable();
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
		        	CSListData = response.list; 
		        	updateCSTable();
		        },
		    });
		 
		 getLevelName(1, "L1Name");
		 getLevelName(2, "L2Name");
	});
	

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
	            	<td >${"${item.path}"}</td>
	            	<td >${"${item.ItemName}"}</td>
	            	<td >${"${item.Identifier}"}</td>
	            </tr>`;
	            no++; 
	       }
	    });
	    $("#itemTable").html(tableContent);
	}
	
 	function updateTermTable() {
	    let tableContent = "";
	    let no = 1;
	    itemListData.forEach((cxnTerm) => {
	        if (cxnTerm.ItemTypeCode === "OJ00011" ) {
	            tableContent += "<tr style='cursor:pointer;' onclick='clickItemEvent("+cxnTerm.id+")'>";
	            tableContent += "<td>"+no+"</td>";
	            tableContent += "<td>"+cxnTerm.ItemName+"</td>";
	            tableContent += "<td class='alignL'>"+cxnTerm.KoreanText+"</td>";
	            tableContent += "</tr>";
	            no++; 
	       }
	    });
	    document.getElementById("itemTermTable").insertAdjacentHTML("beforeend", tableContent);
	} 
 	
 	function updateCSTable() {
		let tableContent = "";
		CSListData.forEach((item) => {	    
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
// 			var url = "openViewerPop.do?seq="+seq[0];
// 			var w = screen.width;
// 			var h = screen.height;
			
			if(avg5 != "") { 
				viewerForm.isNew.value = "N";
// 				url = url + "&isNew=N";
			}
			else {
				viewerForm.isNew.value = "Y";
// 				url = url + "&isNew=Y";
			}
// 			window.open(url, "openViewerPop", "width="+w+", height="+h+",top=0,left=0,resizable=yes");
// 			//window.open(url,1316,h); 
			
			 viewerForm.submit();
		}
		else {
	
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
		        
		          checkboxes.forEach(function(checkbox) {
		            var labelText = checkbox.nextElementSibling.innerText.trim(); 
		            
		            if (dimValueName.includes(labelText)) {
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
		+"&itemEditPage=custom/sk/skon/item/process/editProcessInfo"
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
		+"&itemEditPage=custom/sk/skon/item/process/editProcessInfo"
		+"&itemViewPage=${itemViewPage}&accMode=DEV&scrnMode=E"
		+"&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
		+"&defSiteCode="+defSiteCode
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

	// callbakc - goApprovalPop
/* 	function fnItemMenuReload() {
		fnEditItemInfo();

	} */
	
	// check out 실행 함수 

/* 	function fnQuickCheckOut(avg){
	
	
	   var defCSRID="${projectID}";
	   var changeType = avg;
	
		if(checkOutFlag == "N") {				
				dhtmlx.confirm({
					ok: "Yes", cancel: "No",
					text: "개정을 시작하시겠습니까?",
					width: "310px",
					callback: function(result){
						if(result){
							var url = "cngCheckOutPop.do?";
							var data = "changeType="+changeType+"&s_itemID=${itemID}&pjtIds="+defCSRID;
						 	var target = self;
						 	var option = "width=500px, height=350px, left=200, top=100,scrollbar=yes,resizble=0";
						 	window.open(url+data, 'CheckOut', option);
						 	checkOutFlag = "Y"; 						
						}
					}		
				});  
		}
	
	} */
	
	//Approval Request
	
/* 	function goApprovalPop() {
				
		var url = "wfDocMgt.do?";
		var data="isPop=Y&changeSetID=${itemInfo.CurChangeSet}&isMulti=N&wfInstanceID=${itemInfo.WFInstanceID}&wfDocType=CS&ProjectID=${itemInfo.ProjectID}&docSubClass=${itemInfo.ClassCode}";
	
		var w = 1200;
		var h = 750; 
		itmInfoPopup(url+data,w,h);
	} */
	
	// [Rework] click
/* 	function rework() {
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
	 */
	// [결재 취소] click
/* 	function withdrawAprvReq() {
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
	} */
	
	
	
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
	
	function getLevelName(level, el) {
		fetch("getItemNameListByHier.do?level="+level+"&itemID=${itemID}&itemTypeCode=OJ00001&languageID=${sessionScope.loginInfo.sessionCurrLangType}")
		.then(res => res.json())
		.then(data => document.getElementById(el).insertAdjacentHTML("beforeend", data.data.NAME));
	}
	function getAttrByClass() {
		const attrs = document.getElementsByClassName("attr");
		for(attr of attrs) {
			if("${itemInfo.ClassCode}" == "CL01005" || "${itemInfo.ClassCode}" == "CL01006A") {
				if(attr.getAttribute("name") === "a") attr.style.display = "table-row";
				else attr.style.display = "none";
			}
			if("${itemInfo.ClassCode}" == "CL01005A" || "${itemInfo.ClassCode}" == "CL01006B") {
				if(attr.getAttribute("name") === "b") attr.style.display = "table-row";
				else attr.style.display = "none";
			}
		}
	}
	
</script>
</head>
<body>
<form name ="viewerForm" >
	<input type="hidden" id="seq" name="seq" value="">
	<input type="hidden" id="isNew" name="isNew" value="">
</form>
<!-- BIGIN :: -->
<form name="frontFrm" id="frontFrm" action="#" method="post" enctype="multipart/form-data" onsubmit="return false;"> 

	<div id=htmlReport style="width:100%;overflow-y:auto;overflow-x:hidden;">
	<!-- 헤더값 -->
		<div id="itemDiv">
			<!-- BIGIN :: 기본정보 -->
			<div id="mainprocess" class="mgB10" style="width:99%">
			<div id="process" class="mgB10">
				<div class="flex justify-between align-center pdT10 pdB10">
					<div class="flex align-center">
						<p class="cont_title mgB1">기본정보</p>
						<ul class="mgL20">
							<li class="flex">
								<input type="checkbox" class="mgR3 chkbox" name="process" id="process_chk" checked><label for="process_chk" class="mgR3">${menu.LN00005 }</label>
								<input type="checkbox" class="mgR3 chkbox" name="file" id="file_chk" checked><label for="file_chk" class="mgR3">${menu.LN00019 }</label>
								<input type="checkbox" class="mgR3 chkbox" name="relatedProcess" id="relatedProcess_chk" checked><label for="relatedProcess_chk" class="mgR3">연관문서</label>
								<!-- <input type="checkbox" class="mgR3 chkbox" name="cxnmMap" id="cxnmMap_chk" checked><label for="cxnmMap_chk" class="mgR3">연관모델</label> -->
								<input type="checkbox" class="mgR3 chkbox" name="relatedTerm" id="relatedTerm_chk" checked><label for="relatedTerm_chk" class="mgR3">용어의 정의</label>
								<c:if test="${scrnType != 'pop'}">
								<input type="checkbox" class="mgR3 chkbox" name="history" id="history_chk" checked><label for="history_chk" class="mgR3">${menu.LN00012 }</label>
								</c:if>
							</li>
						</ul>
					</div>
					<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="button" onclick="fnEditItemInfo()"></span>
				</div>
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
						<col width="10%">
				
					</colgroup>

					<!-- 문서번호 / 문서명 / 개정번호  -->
					<tr>
						<th>문서번호</th>
						<td colspan="2" class="alignL pdL10">${prcList.Identifier}</td>
						<th>${menu.LN00101}</th>
					    <td colspan="3" class="alignL pdL10">${prcList.ItemName}</td>				
						<th>${menu.LN00356}</th>
						<td colspan="2" class="alignL pdL10">${prcList.Version}<span style="font-weight:bold; margin-left:5px;">(${csInfo.CSStatusName})</span></td>
					</tr>
					
					<!-- 담당Unit / 담당부서 / 담당자 / 문서레벨  -->
					<tr>
					    <th>담당Site</th>
					    <td colspan="2"  class="alignL pdL10">${SiteInfo.siteNM}</td>				
						<th>담당부서</th>
						<td class="alignL pdL10">${prcList.OwnerTeamName}</td>
						<th>${menu.LN00004}</th>
						<td class = "alignL pdL10" id="authorInfo" >${prcList.AuthorName} </td>
						<th>문서레벨</th>
					    <td colspan="2" class="alignL pdL10">${attrMap.ZAT01020}</td>	
					</tr>
					
					<!-- 영역 / 상세영역 / 문서유형 / 문서분야  -->
					<tr>	
				    	<th>영역</th>
					    <td colspan="2" class="alignL pdL10" id="L1Name"></td>	
					   <th>상세영역</th>
						<td class="alignL pdL10" id="L2Name"></td>
					    <th>문서유형</th>
						<td class="alignL pdL10">업무절차서</td>
					    <th>문서분야</th>
					    <td colspan="2" class="alignL pdL10">${attrMap.ZAT01040}</td>						    
					</tr>

					
					<!-- 적용Site / Site담당자 -->
					<tr style="">
				    <th>적용Site</th>
				   <td style="">
				        <input type="checkbox" name="siteCode" id="cmm" value="cmm">
				        <label for="cmm">공통</label>
				    </td>
				    <td style="border-left: 1px solid #ccc; ">
				        <input type="checkbox" name="siteCode" id="SKO1" value="SKO1">
				        <label for="SKO1">본사</label>
				    </td>
				    <td style="border-left: 1px solid #ccc; ">
				        <input type="checkbox" name="siteCode" id="SKO2" value="SKO2">
				        <label for="SKO2">서산</label>
				    </td>
				    <td style="border-left: 1px solid #ccc; ">
				        <input type="checkbox" name="siteCode" id="SKBA" value="SKBA">
				        <label for="SKBA">SKBA</label>
				    </td>
				    <td style="border-left: 1px solid #ccc; ">
				        <input type="checkbox" name="siteCode" id="SKOH1" value="SKOH1">
				        <label for="SKOH1">SKOH</label>
				    </td>
				    <td style="border-left: 1px solid #ccc; ">
				        <input type="checkbox" name="siteCode" id="SKOH2" value="SKOH2">
				        <label for="SKOH2">SKOH2</label>
				    </td>
				    <td style="border-left: 1px solid #ccc;">
				        <input type="checkbox" name="siteCode" id="SKBM" value="SKBM">
				        <label for="SKBM">SKBM</label>
				    </td>
				    <td style="border-left: 1px solid #ccc;">
				        <input type="checkbox" name="siteCode" id="SKOJ" value="SKOJ">
				        <label for="SKOJ">SKOJ</label>
				    </td>
				    <td style="border-left: 1px solid #ccc;">
				        <input type="checkbox" name="siteCode" id="SKOY" value="SKOY">
				        <label for="SKOY">SKOY</label>
				    </td>
		
				</tr>

				<tr name="a" class="attr">			
					<th>${menu.LN00386}</th>
					<td class="alignL pdL10" colspan="9" >
						<textarea class="tinymceText" style="height:150px;" readonly="readonly">
							<div class="mceNonEditable">${attrMap.AT00803}</div>		
						</textarea>
					</td>
				</tr>
				<!--적용범위 -->
				<tr name="a" class="attr">			
					<th>적용범위</th>
					<td class="alignL pdL10" colspan="13" >
						<textarea class="tinymceText" style="height:150px;" readonly="readonly">
							<div class="mceNonEditable">${attrMap.ZAT02016}</div>		
						</textarea>
					</td>
				</tr>	
				<!--  책임과 권한 -->
				<tr name="a" class="attr">			
					<th>책임과 권한</th>
					<td class="alignL pdL10" colspan="13" >
						<textarea class="tinymceText" style="height:150px;" readonly="readonly">
							<div class="mceNonEditable">${attrMap.ZAT02017}</div>		
						</textarea>
					</td>
				</tr>
				<!--  기록 및 보관 -->
				<tr name="a" class="attr">			
					<th>기록 및 보관</th>
					<td class="alignL pdL10" colspan="13" >
						<textarea class="tinymceText" style="height:150px;" readonly="readonly">
							<div class="mceNonEditable">${attrMap.ZAT02020}</div>		
						</textarea>
					</td>
				</tr>
				<!--  문서개요  -->
				<tr name="b" class="attr">			
					<th>문서개요</th>
					<td class="alignL pdL10" colspan="13" >
						<textarea class="tinymceText" style="height:270px;" readonly="readonly">
							<div class="mceNonEditable">${attrMap.AT00003}</div>		
						</textarea>
					</td>
				</tr>
				<!-- 키워드 -->
				<tr>
					<th>키워드</th>
					<td class="alignL pdL10" colspan="13">${attrMap.AT01007}</td>		
				</tr>
				<!-- 주요개정사항 -->
				<tr>
					<th>주요개정사항</th>
					<td class="alignL pdL10" colspan="10">						
						<%-- <textarea  id="Description" name="Description" style="width:100%;height:40px;">${itemInfo.ChangeSetDec}</textarea> --%>
						
						<textarea id="Description" name="Description" style="width:100%;height:40px;" readonly="readonly">${itemInfo.ChangeSetDec}</textarea>
					</td>
				</tr>
			</table>
		</div>
			<!--  //end 기본정보 -->	
			
			<!-- 첨부문서 --> 
			<div id="file" class="mgB30 pdT15">
				<p class="cont_title">${menu.LN00019 }</p>
				<table class="tbl_preview">
					<colgroup>
						<col width="5%">
						<col width="15%">
						<col width="60%">
						<col width="10%">
						<col width="10%">
					</colgroup>	
					<tr>
						<th>No</th>
						<th>문서유형</th>
						<th>문서명</th>
						<th>작성자</th>
						<th>등록일</th>
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
						<c:if test="${myItem == 'Y'}">
						<img src="${root}${HTML_IMG_DIR}/btn_down_en.png" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.Seq}','${fileList.ExtFileURL}');" style="cursor:pointer;">
						</c:if>
							</td> 
							<td>${fileList.WriteUserNM}</td>
							<td>${fileList.CreationTime}</td>
						</tr>
					<c:set var="no" value="${no+1}"/>
					</c:forEach>

				</table>
			</div>
			
	<!-- 연관문서 -->
		<div id="relatedProcess" class="mgB30 pdT15">
   		<p class="cont_title">연관문서</p>
		    <div id="cxn">
		        <table class="tbl_preview mgB10" border="1">
		            <colgroup>
		                <col width="5%">
		                <col width="15%">
		                <col width="20%">
		                <col width="20%">
		                <col width="20%">
		                <col width="20%">
		            </colgroup>
		            <thead>
		                <tr>
		                    <th>No</th>
		                    <th>문서레벨</th>
		                    <th>${menu.LN00091 }</th>
		                    <th>문서경로</th>
		                    <th>문서명</th>
		                    <th>문서번호</th>
		                    
		                    <!-- 
		                    <th>문서 구분</th>
		                    <th>${menu.LN00004 }</th>
		                    <th>담당부서</th> 
		                    <th>${menu.LN00027 }</th>
		                     -->
		                </tr>
		            </thead>
		            <tbody id="itemTable">
		            </tbody>
		        </table>    
		    </div>    
		</div>

		<!--  연관모델 -->
	<!-- 	 <div id="cxnmMap" class="mgB30">
			<p class="cont_title">연관모델</p>
			<div id="subRelFrame_map"  name="subRelFrame_map" style="width:100%; height:300px; overflow: auto;"></div>
		</div> 
		 -->
		 <!-- 용어의 정의 (cxn ver.) -->
		<div id="relatedTerm" class="mgB30 pdT15">
   		<p class="cont_title">용어의 정의</p>
		    <div id="cxn">
		        <table class="tbl_preview mgB10" border="1">
		            <colgroup>
		                <col width="5%">
		                <col width="15%">
		                <col width="80%">
		             
		            </colgroup>
		            <thead>
		                <tr>
		                    <th>No</th>
		                    <th>용어</th>
		                    <th>용어의정의</th>
		                </tr>
		            </thead>
	           		<tbody id="itemTermTable"></tbody>
		        </table>    
		    </div>    
		</div> 
		
		
		<!-- 변경 이력-->
		<c:if test="${scrnType != 'pop'}">
		<div id="history" class="mgB10">
   		<p class="cont_title mgB10">변경이력</p>
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
		                   	<th>${menu.LN00022 }</th>
							<th>문서번호</th>
							<th>문서명</th>
							<th>개정번호</th>
							<th>${menu.LN00004 }</th>
							<th>담당부서</th>
							<th>제/개정일자</th>
							<th>문서상태</th>
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
