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
var screenMode="${screenMode}";

let itemListData = [];

getFileList();

$(document).ready(function(){	
	var itemOption = "${itemOption}";
	getSKONAttr();

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
		
		setTimeout(() => {loadMindMap()}, "2000");
		 
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
		        	csListData = response.list; 
		        	updateCSTable();
		        },
		    });
		 
// 		 getLevelName(1, "L1Name");
// 		 getLevelName(2, "L2Name");
		 
		 window.addEventListener("DOMContentLoaded", function () {
			  const sourceElement = document.querySelector(".dhx_diagram__scale-container");
			  const targetElement = document.getElementById("subRelFrame");

			  if (sourceElement && targetElement) {
			    const height = sourceElement.clientHeight + "px"; 
			    targetElement.style.height = height; 
			  }
		});
	});
function getSKONAttr(){
	

	fetch("/getSKONAttr.do?itemID=${itemID}&accMode=${accMode}&languageID=${sessionScope.loginInfo.sessionCurrLangType}")
	.then(res => res.json())
	.then(data => {
	attrTypeCodeList = data.list.map(item => item.AttrTypeCode); //attr리스트
	

		let datas = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		if(data.list.filter(e => e.AttrTypeCode === "ZAT01030").length) {
			document.getElementById("ZAT01030Value").insertAdjacentHTML("beforeend", data.list.filter(e => e.AttrTypeCode === "ZAT01030")[0].PlainText)
			//document.getElementById("ZAT01030").value = data.list.filter(e => e.AttrTypeCode === "ZAT01030")[0].LovCode;
		}
		if(data.list.filter(e => e.AttrTypeCode === "ZAT02022").length) {
			document.getElementById("ZAT02022Value").insertAdjacentHTML("beforeend", data.list.filter(e => e.AttrTypeCode === "ZAT02022")[0].PlainText)
			//document.getElementById("ZAT01030").value = data.list.filter(e => e.AttrTypeCode === "ZAT01030")[0].LovCode;
		}


	});

}

	function loadMindMap() {
		var  url = "zSKON_MindMap.do";  
		var data = "s_itemID=${itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&frameName=subRelFrame&TsdYN=N";

		 ajaxPage(url, data, "subRelFrame");
	}
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function updateTable() {
	    let tableContent = "";
	    let no = 1;
	    itemListData.forEach((item) => {	    
	        if (item.ItemTypeCode === "OJ00001" || item.ItemTypeCode === "OJ00016") {
	            tableContent += `<tr style='cursor:pointer;' onclick = "clickTermEvent('${"${item.id}"}')">
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
	

		   function updateCheckboxes() {
		
		        var checkboxes = document.querySelectorAll('input[type="checkbox"][name="siteCode"]');
		     
		        //선택한 dimCode값 
		        var dimInfoMap = "${dimInfotMap}".replace(/[{}]/g, '');
		        var dimList  = dimInfoMap.split(',').map(function(pair){
		        	return pair.split('=')[0].trim();
		        }); 


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
	
	// 용어의 정의 팝업
	function clickTermEvent(trObj) {
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
				+"&screenMode=pop&accMode=OPS"
				
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
				document.querySelectorAll("#relatedTerm").forEach(e => e.style.display = "none");
				if(attr.getAttribute("name") === "b") attr.style.display = "table-row";
				else attr.style.display = "none";
			}
		}

	
		if("${itemInfo.ClassCode}" == "CL01005" || "${itemInfo.ClassCode}" == "CL01005A") {
			document.querySelectorAll(".L4show").forEach(e => e.style.display = "none");
			document.querySelectorAll(".L4hidden").forEach(e => e.style.display = "table-cell");
		}
		
		// L4
		if("${itemInfo.ClassCode}" == "CL01006A" || "${itemInfo.ClassCode}" == "CL01006B") {
			document.querySelectorAll(".L4show").forEach(e => e.style.display = "table-cell");
			document.querySelectorAll(".L4hidden").forEach(e => e.style.display = "none");
		}
	}
	
	// 드래그 한 부분 번역기능
	document.addEventListener("selectionchange", () => {
	    const selectedText = window.getSelection().toString();
	    
	    if (selectedText) {
	        // 최상위 문서(top)로 직접 전달
	        window.top[0].postMessage({ type: "selectedText", text: selectedText }, "*");
	    }
	});
	
	
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
			<div class="mgB10">
				<div class="flex justify-between align-center pdT10 pdB10">
					<div class="flex align-center">
						<!-- 기본정보 -->
						<p class="cont_title mgB1">${menu.LN00005}</p>
						<ul class="mgL20">
							<li class="flex">
								<input type="checkbox" class="mgR3 chkbox" name="process" id="process_chk" checked><label for="process_chk" class="mgR3">${menu.LN00005}</label>
								<input type="checkbox" class="mgR3 chkbox" name="file" id="file_chk" checked><label for="file_chk" class="mgR3">${menu.LN00019}</label>
								<input type="checkbox" class="mgR3 chkbox" name="relatedProcess" id="relatedProcess_chk" checked><label for="relatedProcess_chk" class="mgR3">${menu.ZLN0086}</label>
								<input type="checkbox" class="mgR3 chkbox" name="cxnmMap" id="cxnmMap_chk" checked><label for="cxnmMap_chk" class="mgR3">${menu.ZLN0087}</label>
								<input type="checkbox" class="mgR3 chkbox" name="relatedTerm" id="relatedTerm_chk" checked><label for="relatedTerm_chk" class="mgR3">${menu.ZLN0088}</label>
								<c:if test="${screenMode != 'pop'}">
								<input type="checkbox" class="mgR3 chkbox" name="history" id="history_chk" checked><label for="history_chk" class="mgR3">${menu.LN00012}</label>
								</c:if>
							</li>
						</ul>
					</div>
				        <c:if test="${screenMode ne 'pop' && accMode ne 'OPS' && (itemInfo.AuthorID == sessionScope.loginInfo.sessionUserId || sessionScope.loginInfo.sessionAuthLev eq '1')}" >
								<c:if test="${itemInfo.Blocked eq '0' && itemInfo.Status ne 'DEL1'}" >
								<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="button" onclick="fnEditItemInfo()"></span>				
						</c:if>
					</c:if>
				</div>
				<table class="tbl_preview mgB10" id="process">
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
						<th>${menu.ZLN0068}</th>
						<td colspan="2" class="alignL pdL10">${prcList.Identifier}</td>
						<th>${menu.LN00101}</th>
					    <td colspan="3" class="alignL pdL10">${prcList.ItemName}</td>				
						<th>${menu.LN00356}</th>
						<td colspan="2" class="alignL pdL10">${prcList.Version}<span style="font-weight:bold; margin-left:5px;">(${csInfo.CSStatusName})</span></td>
					</tr>
					
					<!-- 담당Unit / 담당부서 / 담당자 / 문서레벨  -->
					<tr>
					    <th>${menu.ZLN0089}</th>
					    <td colspan="2"  class="alignL pdL10">${SiteInfo.siteNM}</td>				
						<th>${menu.ZLN0074}</th>
						<td class="alignL pdL10"  > <!-- style="cursor:pointer;color: #0054FF;text-decoration: underline;"  OnClick="fnOpenTeamInfoMain(${prcList.OwnerTeamID})" -->
						${prcList.OwnerTeamName}	
						<!-- 
						<input type="hidden" id="orderTeamName" name="orderTeamName"  value="${itemInfo.itemCreatorTeamNM}"/>	 --></td> 
						<th>${menu.LN00004}</th>
						<td class = "alignL pdL10" id="authorInfo">${prcList.AuthorName} </td> <!--  style="cursor:pointer;_cursor:hand;color: #0054FF;text-decoration: underline;" onclick="fnOpenAuthorInfo(${prcList.AuthorID})" -->
						<th>${menu.ZLN0075}</th>
					    <td colspan="2" class="alignL pdL10">${attrMap.ZAT01020}</td>	
					</tr>
					
					<!-- 영역 / 상세영역 / 문서유형 / 문서분야  -->
					<tr>	
				    	<th>${menu.ZLN0072}</th>
					    <td colspan="2" class="alignL pdL10" id="ZAT01030Value"></td> 
					   	<th>${menu.ZLN0073}</th>
					    <td colspan="1" class="alignL pdL10" id="ZAT02022Value"></td> 
					    <th>${menu.LN00091}</th>
						<td class="alignL pdL10">${attrMap.ZAT01060}</td>
					    <th>${menu.ZLN0085}</th>
					    <td colspan="2" class="alignL pdL10">${attrMap.ZAT01040}</td>						    
					</tr>

					
					<tr style="height:40px;">
						<!-- 배포Site -->
						<th>${menu.ZLN0031}</th>
						<td style="" colspan=4 class="alignL pdL10" >
							<input type="checkbox" name="siteCode" id="cmm" value="cmm">
							<label for="cmm" class="mgR10">${menu.ZLN0028}</label>
							<input type="checkbox" name="siteCode" id="SKO1" value="SKO1">
							<label for="SKO1" class="mgR10">${menu.ZLN0029}</label>
							<input type="checkbox" name="siteCode" id="SKO2" value="SKO2">
							<label for="SKO2" class="mgR10">${menu.ZLN0030}</label>
							<input type="checkbox" name="siteCode" id="SKBA" value="SKBA">
							<label for="SKBA" class="mgR10">${menu.ZLN0079}</label>
							<input type="checkbox" name="siteCode" id="SKOH1" value="SKOH1">
							<label for="SKOH1" class="mgR10">${menu.ZLN0080}</label>
							<input type="checkbox" name="siteCode" id="SKOH2" value="SKOH2">
							<label for="SKOH2" class="mgR10">${menu.ZLN0081}</label>
							<input type="checkbox" name="siteCode" id="SKBM" value="SKBM">
							<label for="SKBM" class="mgR10">${menu.ZLN0082}</label>
							<input type="checkbox" name="siteCode" id="SKOJ" value="SKOJ">
							<label for="SKOJ" class="mgR10">${menu.ZLN0083}</label>
							<input type="checkbox" name="siteCode" id="SKOY" value="SKOY">
							<label for="SKOY" class="mgR10">${menu.ZLN0084}</label>
							<input type="checkbox" name="siteCode" id="SKOS" value="SKOS">
							<label for="SKOS">${menu.ZLN0150}</label>
						</td>
						<!-- 공정 / 상세공정 -->
						<th class="L4show"><span style="color: red;">*</span>${menu.ZLN0044}</th>
						<td class="alignL pdL10 L4show">${attrMap.ZAT01050}</td>
						<th class="L4show"><span style="color: red;">*</span>${menu.ZLN0067}</th>
						<td class="alignL pdL10 L4show" colspan="2">${attrMap.ZAT01051}</td>								
						<td class="L4hidden"></td>
						<td class="L4hidden"></td>
						<td class="L4hidden"></td>
						<td class="L4hidden"></td>
						<td class="L4hidden"></td>
					</tr>
				<!-- 목적 -->
				<tr name="a" class="attr">			
					<th>${menu.LN00386}</th>
					<td class="alignL pdL10" colspan="9" >
						<textarea style="width:100%;height:40px;resize:none;" readonly="readonly">${attrMap.AT00803}</textarea>
					</td>
				</tr>
				<!--적용범위 -->
				<tr name="a" class="attr">			
					<th>${menu.ZLN0091}</th>
					<td class="alignL pdL10" colspan="9" >
						<textarea  style="width:100%;height:40px;resize:none;" readonly="readonly">${attrMap.ZAT02016}</textarea>
					</td>
				</tr>	
				<!--  책임과 권한 -->
				<tr name="a" class="attr">			
					<th>${menu.ZLN0092}</th>
					<td class="alignL pdL10" colspan="9" >
						<div style="height:450px;">
						<textarea class="tinymceText" style="height:450px;" readonly="readonly">
							<div class="mceNonEditable">${attrMap.ZAT02017}</div>		
						</textarea>
						</div>
					</td>
				</tr>
				<!--  기록 및 보관 -->
				<tr name="a" class="attr">			
					<th>${menu.ZLN0093}</th>
					<td class="alignL pdL10" colspan="9" >
						<div style="height:250px;">
						<textarea class="tinymceText" style="height:250px;" readonly="readonly">
							<div class="mceNonEditable">${attrMap.ZAT02020}</div>		
						</textarea>
						</div>
					</td>
				</tr>
				<!--  문서개요  -->
				<tr name="b" class="attr">			
					<th>${menu.ZLN0094}</th>
					<td class="alignL pdL10" colspan="9" >
						<div style="height:270px;">
						<textarea class="tinymceText" style="height:270px;" readonly="readonly">
							<div class="mceNonEditable">${attrMap.AT00003}</div>		
						</textarea>
						</div>
					</td>
				</tr>
				<!-- 키워드 -->
				<tr>
					<th>${menu.ZLN0070}</th>
					<td class="alignL pdL10" colspan="9">${attrMap.AT01007}</td>		
				</tr>
				<!-- 주요개정사항 -->
				<tr>
					<th>${menu.LN00360}</th>
					<td class="alignL pdL10" colspan="9">	
						<textarea id="Description" name="Description" style="width:100%;height:40px;resize:none;" readonly="readonly">${csInfo.Description}</textarea>
					</td>
				</tr>
			</table>
		</div>
		<!--  //end 기본정보 -->	
		
		<!-- 첨부문서 --> 
		<div id="file" class="mgB30 pdT15">
			<p class="cont_title mgB10">${menu.LN00019}</p>
			<table  class="tbl_preview" id="fileList"></table>
		</div>
			
		<!-- 연관문서 -->
		<div id="relatedProcess" class="mgB30 pdT15">
   		<p class="cont_title mgB10">${menu.ZLN0086}</p>
		    <div id="cxn">
		        <table class="tbl_preview mgB10" border="1">
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
		
		 <!-- 용어의 정의 (cxn ver.) -->
		<div id="relatedTerm" class="mgB30 pdT15">
   		<p class="cont_title mgB10">${menu.ZLN0088}</p>
		    <div id="cxn">
		        <table class="tbl_preview mgB10" border="1">
		            <colgroup>
		                <col width="5%">
		                <col width="15%">
		                <col width="80%">
		             
		            </colgroup>
		            <thead>
		                <tr>
		                	<!-- No / 용어 / 용어의 정의 -->
		                    <th>${menu.LN00024}</th>
		                    <th>${menu.LN00388}</th>
		                    <th>${menu.ZLN0088}</th>
		                </tr>
		            </thead>
	           		<tbody id="itemTermTable"></tbody>
		        </table>    
		    </div>    
		</div> 
		
		
		<!-- 변경이력-->
		<c:if test="${screenMode != 'pop'}">
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
