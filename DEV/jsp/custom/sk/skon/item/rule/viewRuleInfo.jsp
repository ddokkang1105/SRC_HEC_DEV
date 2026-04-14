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
getCSFileList();

$(document).ready(function(){	
	var itemOption = "${itemOption}";

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

	});
	

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
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
	
	
	//변경이력 팝업 
	function clickHistoryItemEvent(cngtId,  ItemID) {
		var url = "popupMasterItem.do?"
			+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&id="+ItemID
				+"&changeSetID="+cngtId
				+"&screenMode=pop&accMode=OPS";
				
		var w = 1200;
		var h = 600; 
		itmInfoPopup(url,w,h);

		
	}
	
	//edit버튼 클릭시
	function fnEditItemInfo() {
	 	var url = "processItemInfo.do";
		var data = "itemID=${itemID}&s_itemID=${itemID}&option=${option}"
		+"&itemEditPage=custom/sk/skon/item/rule/editRuleInfo"
		+"&itemViewPage=${itemViewPage}&accMode=DEV&scrnMode=E&showSaveAlert=Y"
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
		+"&itemEditPage=custom/sk/skon/item/rule/editRuleInfo"
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
		
		async function getCSFileList() {
		    document.querySelector("#csfileList").innerHTML = '';

		    const res = await fetch("/getFileList.do?documentID=${changeSetID}&docCategory=CS&languageID=${sessionScope.loginInfo.sessionCurrLangType}&changeSetID=${changeSetID}&hideBlocked=N");
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
					html += '<td>'+data.data[i].LastUpdated+'</td>';
					html += '</tr>';
				}
				html += '</tbody>';
				document.querySelector("#csfileList").insertAdjacentHTML("beforeend", html);
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
						<p class="cont_title mgB1">${menu.LN00005}</p>
						<ul class="mgL20">
							<li class="floatR pdR20" style="width: 300px;">
								<input type="checkbox" class="mgR3 chkbox" name="process" id="process_chk" checked><label for="process_chk" class="mgR3">${menu.LN00005}</label>
								<input type="checkbox" class="mgR3 chkbox" name="file" id="file_chk" checked><label for="file_chk" class="mgR3">${menu.LN00019}</label>
								<c:if test="${screenMode ne 'pop'}">
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
				 	<col width="20%">
					<col width="30%">
					<col width="20%">
					<col width="30%">
					</colgroup>

					<tr>
						<!-- 사규번호 -->
						<th>${menu.ZLN0133}</th>
						<td class="alignL pdL10">${prcList.Identifier}</td>	
						<!-- 개정번호 -->		
						<th><span style="color: red;">*</span>${menu.LN00356}</th>
						<td class="alignL pdL10">${prcList.Version}<span style="font-weight:bold; margin-left:5px;">(${csInfo.CSStatusName})</span></td>
					</tr>
					
					<tr>
						<!-- 규정명 -->
						<th>${menu.ZLN0134}</th>
						<td class="alignL pdL10">${prcList.ItemName}</td>
						<!-- 작성부서 -->			
						<th><span style="color: red;">*</span>${menu.LN01008}</th>
						<td class="alignL pdL10">${attrMap.ZAT04002}</td>	
					</tr>
					
					<!-- 주요개정사항 -->
					<tr>
						<th><span style="color: red;">*</span>${menu.LN00360}</th>
						<td class="alignL pdL10" colspan="3">	
							<textarea id="Description" name="Description" style="width:100%;height:40px;" readonly="readonly">${csInfo.Description}</textarea>
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
			
			<!-- 품의서 --> 
			<c:if test="${itemInfo.AuthorID == sessionScope.loginInfo.sessionUserId }">
				<div id="file" class="mgB30 pdT15">
					<p class="cont_title mgB10">${menu.ZLN0135}</p>
					<table  class="tbl_preview" id="csfileList"></table>
				</div>
			</c:if>

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
