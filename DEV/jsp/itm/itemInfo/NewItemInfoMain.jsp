<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root"/>
<!-- Item 정보 -->
<!-- 
	@RequestMapping(value="/NewItemInfoMain.do")
	
-->
<script type="text/javascript">
	var chkReadOnly = true;
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00057" var="CM00057"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00042" var="CM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00058" var="CM00058" arguments="CSR"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00061" var="CM00061" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002" />
<script type="text/javascript">
	
	var isPossibleEdit = "${isPossibleEdit}";
	var itemStatus = "${itemStatus}";
	var checkOutFlag = "N";
	
	$(document).ready(function(){	
		
		var itemObj = $('.geSidebarContainer');
		var height = setWindowHeight();
		if(itemObj.length != 0){
			var objTop = itemObj.offset().top;
			if(objTop > 100){
				height = itemObj.height();
			}
		}
		
		if(document.getElementById('htmlReport')!=null&&document.getElementById('htmlReport')!=undefined){
			$("#htmlReport").innerHeight(document.body.clientHeight - 145);

			window.onresize = function() {
				$("#htmlReport").innerHeight(document.body.clientHeight -145);
			};
		}
		
		// 관련항목 타이틀 화면 표시 & 클릭 이벤트 설정
		var strClassName = "${strClassName}"; 
		var classNameArray = strClassName.split(",");
		for (var i = 1; i < classNameArray.length + 1; i++) {
			var subTitleId = "subTitle" + i;
			if(document.getElementById(subTitleId)!=null){document.getElementById(subTitleId).innerHTML = classNameArray[i-1];}
		}
		
		// TODO : 담당자 정보 표시
		var layerWindow = $('.item_layer_photo');
		$('#authorInfo').click(function(){			
			var url = "viewMbrInfo.do?memberID=${authorID}";		
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
		var loadEdit = "${loadEdit}";
		if(loadEdit == "Y"){
			goItemInfoEdit();
		}
		
		
	});
	
	function DiagramAsNewWindow(itemId, modelId) {
		var url = "PopupModelDiagramMain.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemID=" + itemId 
				+"&modelID="+ modelId +"&percentOfImage=100&getWidth=1200&getCheck=0";
		var w = 1200;
		var h = 900;
		openPopup(url,w,h,itemId);
	}
		
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	/* 프린트 버튼 클릭 이벤트 */
	function printDiv() {
		var url = "NewItemInfoMain.do?";
		var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&kbn=printView"; 
		var w = 700;
		var h = 800;
		openPopup(url+data,w,h,"popUpPrint");
		
	}
	
	/* edit */
	function goItemInfoEdit() {
		if (isPossibleEdit == "Y") { 
		
		    var url = "editItemInfo.do";
			var target = "actFrame";
			var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&showVersion=${showVersion}&showInvisible=${showInvisible}";
		 	ajaxPage(url, data, target);
		} else {
			if (itemStatus == "REL") {
				alert("${WM00120}"); // [변경 요청 안된 상태]
			} else {
				alert("${WM00050}"); // [승인요청중]
			}
		}
	}
	

	function doCallBack(){}
	
	function urlReload() {
		thisReload();
	}
	
	function afterCar() {
		thisReload();	
	}
	
	function thisReload() {
		var url = "NewItemInfoMain.do";
		var target = "actFrame";
		var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&varFilter=${showVersion}"; 
	 	ajaxPage(url, data, target);
	}
	
	/*
	function goReportList() {
		var url = "objectReportList.do";
		var target = "actFrame";
		var data = "s_itemID=${s_itemID}&option=${option}&kbn=newItemInfo"; 
	 	ajaxPage(url, data, target);
	}
	*/
	
	/* 의견공유, 변경이력, 관련문서, Dimension 등의 화면으로 이동 */
	function goMenu(avg) {
		var url = "";
		var target = "actFrame";
		var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&myItem=${myItem}"; 
		
		if (avg == "fileMgt") {
			url = "goFileMgt.do?&fileOption=${menuDisplayMap.FileOption}&itemBlocked=${itemBlocked}&langFilter=${langFilter}"; // 관련문서
		} else if (avg == "changeMgt") {
			url = "itemHistory.do"; // 변경이력
			data = data + "&myItem=${myItem}&itemStatus=${itemStatus}";
		} else if (avg == "forum") {
			url = "forumMgt.do"; // 의견공유
		} else if (avg == "dim") {
			url = "dimListForItemInfoV4.do"; // Dimension
		} else if (avg == "model") {
			url = "modelInfoMgt.do"; // Item Model Used List
			data = data + "&listFilterType=itemUsedList";	
		} else if (avg == "rev") {
			url = "revisionList.do?docCategory=ITM"; // Revision
		} else if (avg == "editCS") {
			fnEditChangeSet();
			
			return false;
		}
		
		ajaxPage(url, data, target);
	}
	
	function fnEditChangeSet(){
		var url = "editItemChangeInfo.do"
		var data = "?changeSetID=${curChangeSet}&StatusCode=${StatusCode}"
			+ "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&mainMenu=${mainMenu}&seletedTreeId=${s_itemID}"
			+ "&isItemInfo=Y&screenMode=edit"
			+ "&isMyTask=Y";
		window.open(url+data,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizable=yes');
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
				var checkObjVal = checkObj.value.split('/');
				sysFileName[0] =  checkObjVal[2] + checkObjVal[0];
				originalFileName[0] =  checkObjVal[1];
				filePath[0] = checkObjVal[2];
				seq[0] = checkObjVal[3];
				j++;
			}
		};
		for (var i = 0; i < checkObj.length; i++) {
			if (checkObj[i].checked) {
				var checkObjVal = checkObj[i].value.split('/');
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
		
		if(avg3 == "VIEWER" || avg3 == "PDFCNVT") {
			var url = "openViewerPop.do?seq="+seq[0]+"&fileOption="+avg3;
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
	
	function fnOpenItemPop(itemID){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop";
		var w = 1200;
		var h = 900; 
		itmInfoPopup(url,w,h,itemID);
	}
	
	function fnItemLinkLayer(itemID, layerID, classCode){ 
		var layerWindow = $('.connection_layer');
		var pos = $('#'+layerID).offset();  
		linkLayerPopupView(layerID, 'connectionPopup', pos);
		
		// 화면 스크롤시 열려있는 레이어 팝업창을 모두 닫음
		document.getElementById("htmlReport").onscroll = function() {
			// 본문 레이어 팝업
			layerWindow.removeClass('open');
		};
		fnSetLinkList(itemID, classCode);
	}

	function fnSetLinkList(itemID, classCode){
		var data="itemID="+itemID+"&itemClassCode="+classCode+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		var returnData;
		var layerOpen = "Y";
		$.ajax({   
			url : "getAttrLinkList.do",     
			type: "POST",     
			data : data,
			//dataType :  'json',
			//contentType: "application/x-www-form-urlencoded; charset=utf-8",
			beforeSend: function(x) {if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}	},
			success: function(returnData){
				var arrReturnData = returnData.split("/");
				var link = arrReturnData[0].split(",");
				var url = arrReturnData[1].split(",");				
				var lovCode = arrReturnData[2].split(",");
				var attrTypeCode = arrReturnData[3].split(",");
				var cnt = arrReturnData[4].split(",");
				var linkLayer ="";
				linkLayer += "<tr>";
				linkLayer += "<td style='cursor:hand;height:20px;' onClick='fnOpenItemPop("+itemID+");' class='alignL last'>${menu.LN00138}</td>";
				linkLayer += "</tr>"; 
				
				if(cnt > 0){					
					for(var i=0; i<link.length; i++){ 
						$("#url").val(url[i]);
						$("#lovCode").val(lovCode[i]);
						linkLayer += "<tr>";
						linkLayer += "<td height='20px' style='cursor:hand;' onClick='fnGoLink("+itemID+",\""+attrTypeCode[i]+"\");' class='alignL last'> "+link[i]+" </td>";
						linkLayer += "</tr>";
					}
					$('.connection_layer').addClass('open');
					$('#link').html(linkLayer);
				}else{
					fnOpenItemPop(itemID);					
				} 				
			},     
			error: function (jqXHR, textStatus, errorThrown)     {       }
			});
	}
	
	function fnGoLink(itemID, attrTypeCode){ 
		var lovCode = $("#lovCode").val();
		var url = $("#url").val();
		if(url == null || url == ""){
			alert("No system can be executed!");
			return;
		}else{		
			url = url+".do?itemID="+itemID+"&lovCode="+lovCode+"&attrTypeCode="+attrTypeCode;
		}
		window.open(url,'_newtab');
	}

 	function fnRunLink(url,attrUrl,attrTypeCode,varFilter){
		var lovCode = "${lovCode}"; 
		var itemID = "${s_itemID}";
		var fromItemID = "${fromItemID}";
		if(fromItemID != ""){
			itemID = fromItemID;
		}
		
		if(url == null || url == ""){
			url = attrUrl;		
		}
		if(url == null || url == ""){
			alert("No system can be executed!");
			return;
		}	
		 else if (url.includes("cxnItemListPop")) {
			url = url+".do?s_itemID="+itemID+"&lovCode="+lovCode+"&attrTypeCode="+attrTypeCode + varFilter;
			window.open(url,'','width=750, height=500, left=200, top=100, scrollbar=yes,resizable=yes');					
		}
		 else if (url.includes("cxnItemListMgtV4")) {
			 	url =  url + ".do";
				var data = "s_itemID=" + itemID + varFilter
				var w = 1200;
				var h = 800;
				openUrlWithDhxModal(url, data, title="", w, h)			 
			 
				//url = url+".do?s_itemID="+itemID + varFilter;
				//window.open(url,'','width=1200, height=800, left=200, top=100, scrollbar=yes,resizable=yes');					
		}		
		 else {
			url = url+".do?itemID="+itemID+"&lovCode="+lovCode+"&attrTypeCode="+attrTypeCode;
			window.open(url,'_newtab');					
		}
	} 
	
	function fnCloseLayer(){
		var layerWindow = $('.connection_layer');
		layerWindow.removeClass('open');
	}
	
	/* 관련항목 메뉴 popup창에 표시 : 상세항목정보, link 메뉴 */
	function linkLayerPopupView(sLinkName, sDivName, pos)  { 
		var nTop = pos.top;
		var nLeft = pos.left;
		var oPopup = document.getElementById(sDivName);
		var oLink = document.getElementById(sLinkName);
		var scrollTop = document.getElementById("htmlReport").scrollTop;
		oPopup.style.top = (oLink.offsetTop + nTop - 130) + "px";
		oPopup.style.left = nLeft +"px";
	} 
	
	function fnRefItemLayer(itemID, layerID){ 
		var layerWindow = $('.connection_layer');
		var pos = document.getElementById(layerID).getBoundingClientRect();
		linkLayerPopupView(layerID, 'connectionPopup', pos);
		layerWindow.addClass('open');
		// 화면 스크롤시 열려있는 레이어 팝업창을 모두 닫음
		document.getElementById("htmlReport").onscroll = function() {
			// 본문 레이어 팝업
			layerWindow.removeClass('open');
		};
				 
		var linkLayer ="";
		linkLayer += "<tr>";
		linkLayer += "<td style='cursor:pointer;height:20px;' onClick='fnOpenItemPop("+itemID+");' class='alignL last'>${menu.LN00138}</td>";
		linkLayer += "</tr>"; 
		 $('#link').html(linkLayer);
	}
	
	// 최신 changeSet 이전 changSet 정보 
	function fnOpenViewVersionItemInfo(changeSetID){
		var projectID = "${preChangeSetInfo.ProjectID}";
		var authorID = "${preChangeSetInfo.AuthorID}";
		var status = "${preChangeSetInfo.Status}";
		var version = "${preChangeSetInfo.Version}";
	
		var url = "viewVersionItemInfo.do?s_itemID=${s_itemID}"
					+"&changeSetID="+changeSetID
					+"&projectID="+projectID
					+"&authorID="+authorID
					+"&status="+status
					+"&version="+version;
		window.open(url,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizable=yes');
	}
	
	function fnRegNewCSR(){
		if(confirm("${CM00058}")){
			//var url = "csrDetailPop.do?isNew=Y&quickCheckOut=Y&itemID=${s_itemID}";	
			var url = "registerCSR.do?quickCheckOut=Y&itemID=${s_itemID}";
			var pop_state;
			pop_state = window.open(url,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizble=0');
			pop_state.focus();
		}
	}
	

	// [Check in] Click 
// 	function fnCheckInItem() {
// 		var items = "${s_itemID}";
// 		var cngts = "${curChangeSet}";
// 		var pjtIds = "${projectID}";
// 		var url = "checkInMgt.do";
// 		var validFrom = $("#ValidFrom").val();
// 		var data = "items=" + items + "&cngts=" + cngts + "&pjtIds=" + pjtIds;
// 		var target = "blankFrame";
// 		ajaxPage(url, data, target);
// 	}

	/* function fnCallBack(checkInOption){
		if(checkInOption == "03" || checkInOption == "03B"){
			dhtmlx.confirm({
				ok: "Yes", cancel: "No",
				text: "${CM00061}",
				width: "310px",
				callback: function(result){					
					if(result){
						goApprovalPop();
					}
					opener.fnItemMenuReload();	
				}		
			});
		}else{
			opener.fnItemMenuReload();	
		}
	}

	function goApprovalPop() {
		var url = "${wfURL}.do?";
		var data = "isPop=Y&changeSetID=${curChangeSet}&isMulti=N&wfDocType=CS";
				
		var w = 1200;
		var h = 550; 
		itmInfoPopup(url+data,w,h);
	} */

	function fnOpenTeamInfoMain(teamID){
		var w = "1200";
		var h = "800";
		var url = "orgMainInfo.do?id="+teamID;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	/* function fnRoleCallBack(){
		thisReload();
	} */
	
	function fnCngCallBack() {
		opener.fnItemMenuReload();	
	}
	
	function fnOpenPapagoTrans(attrTypeCode, isHTML) {
		var w = "1200";
		var h = "800";
		var url = "getPapagoTrans.do?itemID="+${s_itemID}+"&attrTypeCode="+attrTypeCode+"&languageID="+${sessionScope.loginInfo.sessionCurrLangType};
		window.open(url, "papago", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}

	function fnOpenGPTAITrans(attrTypeCode, isHTML) {
		var w = "1200";
		var h = "800";
		var url = "getGPTAITrans.do?itemID="+${s_itemID}+"&attrTypeCode="+attrTypeCode+"&languageID="+${sessionScope.loginInfo.sessionCurrLangType};
		window.open(url, "gptAI", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}

</script>

<form name="objectInfoFrm" id="objectInfoFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}" />
	<input type="hidden" id="ArcCode" name="ArcCode" value="${option}"/>
	<input type="hidden" id="onlyMap" name="onlyMap"  value="" />
	<input type="hidden" id="paperSize" name="paperSize"  value="" />
	<input type="hidden" id="lovCode" name="lovCode"  value="" />
</form>
<!-- BIGIN :: -->
<form name="frontFrm" id="frontFrm" action="#" method="post" onsubmit="return false;"> 
<div id="htmltop">
</div>

<div class="clear"></div>
<div class="child_search01 mgB10">
		<c:if test="${itemReleaseVersion ne '' && changeMgt eq '1' && itemInfo.Status eq 'REL' }">
		 <li class="shortcut">	   
		   ${menu.LN00017}&nbsp;:&nbsp;${itemReleaseVersion}&nbsp;/&nbsp;${menu.LN00296}&nbsp;:&nbsp;${itemValidFrom}&nbsp; 
		 </li>
		</c:if>
	   <li class="floatR"> 
	   		<c:choose>
	   		<c:when test="${sessionScope.loginInfo.sessionLogintype == 'editor' and quickCheckOut eq 'Y' and itemInfo.Status eq 'REL' }" >
	   			<%-- <span class="icon" alt="Check Out" title="Check Out" style="cursor:pointer;_cursor:hand"><img onclick="fnQuickCheckOut();" class="topIconImg" alt="imgCHANGEMGT" src="${root}${HTML_IMG_DIR}/item/icon_checkOut.png"></img></span>&nbsp; --%>
	   		</c:when>
	   		<c:otherwise>
	   			<c:if test="${itemBlocked eq '0' && sessionScope.loginInfo.sessionLogintype == 'editor' and myItem == 'Y'}">
		   			
		   			<span class="btn_pack nobg white"><a href="javascript:goItemInfoEdit();"class="edit mgT2 " title="Attributes"></a></span>		   		
	     	    </c:if>
	   		</c:otherwise>
	   		</c:choose>	   		
	   	  	<c:if test="${menuDisplayMap.FileOption ne  'N'}">
		  		<span class="btn_pack nobg" alt="FILEMGT" title="Files"  style="cursor:pointer;_cursor:hand"><a onclick="goMenu('fileMgt');" class="file mgT2 mgR3" alt="imgFILEMGT"></a></span>
		  		<font color="#1141a1" class="alarm">${FILE_CNT}</font>
		  	</c:if>
		   	<c:if test="${menuDisplayMap.HasDimension eq '1' && itemBlocked eq '0' && myItem == 'Y'}">
		  		<span class="btn_pack nobg" alt="DIMENSION" title="Dimension"  style="cursor:pointer;_cursor:hand"><a onclick="goMenu('dim');" class="dimen mgT2 mgR3" alt="imgDIMENSION"></a></span>
		  		<font color="#1141a1" class="alarm">${menuDisplayMap.DIM_CNT}</font>
		  	</c:if>
		  	<c:if test="${isExistModel eq 'Y'}">
		  		<span class="btn_pack nobg" alt="Occurrence" title="Occurrence"  style="cursor:pointer;_cursor:hand"><a onclick="goMenu('model');"class="model mgT2 mgR3"></a></span>
		  		<font color="#1141a1" class="alarm">${MDL_CNT}</font>
		  	</c:if>
		  	<c:if test="${changeMgt ne '1' && curChangeSet ne '' && itemInfo.Status ne 'NEW1' && itemInfo.Status ne 'NEW2'}">
	   			<span class="btn_pack nobg" alt="Revision" title="Revision"  style="cursor:pointer;_cursor:hand"><a onclick="goMenu('rev');" class="edit2 mgT2 mgR3"></a></span>
		  		<font color="#1141a1" class="alarm">${REV_CNT}</font>
		  	</c:if>
	   </li>
    </div>
<div id="htmlReport" style="width:100%;overflow:auto; overflow-x:hidden; padding:0;">
<input type="hidden" id="url" name="url" >
	<!-- BIGIN :: 기본정보 -->
	<div id="processList">	
	<table style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview">
		<c:forEach var="prcList" items="${prcList}" varStatus="status">
			<colgroup> 
				<col width="11%">
				<col width="14%">
				<col width="11%">
				<col width="14%">
				<col width="11%">
				<col width="14%">
				<col width="11%">
				<col width="14%">
			</colgroup>
			<tr>
				<!-- 항목계층 -->
				<th class="viewtop">${menu.LN00016}</th>
				<td class="viewtop">${prcList.ClassName}</td>
				<!-- 상태 -->
				<th class="viewtop">${menu.LN00027}</th>
				<td class="viewtop">${prcList.StatusName}</td>				
				<!-- 수정일 -->
				<th class="viewtop" >${menu.LN00070}</th>
				<td class="viewtop">${prcList.LastUpdated}</td>
				<!-- 생성일 -->
				<th class="viewtop" >${menu.LN00013}</th>
				<td class="tdLast viewtop">${prcList.CreateDT}</td>
			</tr>
			<tr>				
				<!-- 관리조직 -->
				<th>${menu.LN00018}</th>
				<td style="cursor:pointer;color: #0054FF;text-decoration: underline;"  OnClick="fnOpenTeamInfoMain(${prcList.OwnerTeamID})" >${prcList.OwnerTeamName}</td>
				<input type="hidden" id="orderTeamName" name="orderTeamName"  value="${prcList.OwnerTeamName}"/>
				<!-- 담당자 -->	
				<th>${menu.LN00004}</th>			
				<c:if test="${roleAssignMemberList.size() == 1}" >
				<td id="authorInfo" style="cursor:pointer;_cursor:hand;color: #0054FF;text-decoration: underline;">${prcList.Name} </td>
				</c:if>
				<c:if test="${roleAssignMemberList.size() > 1}" > 
					<td>
						<select id="roleAssignMember" Name="roleAssignMember" style="width:90%" OnChange="fnGetAuthorInfo(this.value);">
							<c:forEach var="list" items="${roleAssignMemberList}" varStatus="status">
								<option value="${list.MemberID}">${list.Name}</option>
							</c:forEach>
						</select>
					</td>
				 </c:if>
				 <!-- 법인 -->	
				<th>${menu.LN00352}</th>
				<td>${prcList.TeamName}</td>
				<!-- 프로젝트 -->
				<th>${menu.LN00131}</th>
				<td>${prcList.ProjectName}</td>
			</tr>
			<c:if test="${itemFileOption ne 'VIEWER' and itemFileOption ne 'PDFCNVT' }">
			<tr>
				<!-- 첨부 및 관련 문서 --> 
				<th style="height:53px;">${menu.LN00019}</th>
				<td style="height:53px;" class="tdLast alignL pdL5" colspan="7">
					<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
						<div class="floatR pdR20">
						<c:if test="${attachFileList.size() > 0}">
							<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('checkedFile', 'Y')"></span><br>
							<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('checkedFile')"></span><br>
						</c:if>
						</div>					
							<c:forEach var="fileList" items="${attachFileList}" varStatus="status">
								<input type="checkbox" name="checkedFile" value="${fileList.FileName}/${fileList.FileRealName}//${fileList.Seq}" class="mgL2 mgR2">
								<span style="cursor:pointer;" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.Seq}','${fileList.ExtFileURL}');">${fileList.FileRealName}</span><br>
							</c:forEach>								
					</div>
				</td> 
			</tr>
			</c:if>			
			<c:if test="${itemFileOption eq 'VIEWER' || itemFileOption eq 'PDFCNVT' }">
			<tr>
				<!-- 첨부 및 관련 문서 --> 
				<th style="height:53px;">${menu.LN00019}</th>
				<td style="height:53px;" class="tdLast alignL pdL5" colspan="7">
					<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
					<div class="floatR pdR20">
					</div>
					
					<c:forEach var="fileList" items="${attachFileList}" varStatus="status">
						<span style="cursor:pointer;" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','${fileList.fileOption}','${fileList.Seq}','${fileList.ExtFileURL}');">${fileList.FileRealName}</span>
						&nbsp;&nbsp;
						<img src="${root}${HTML_IMG_DIR}/btn_view_en.png" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','${fileList.fileOption}','${fileList.Seq}','${fileList.ExtFileURL}');" style="cursor:pointer;">
						&nbsp;
						<c:if test="${myItem == 'Y'}">
						<img src="${root}${HTML_IMG_DIR}/btn_down_en.png" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.Seq}','${fileList.ExtFileURL}');" style="cursor:pointer;">
						</c:if>
						<br>
					</c:forEach>
					
					<c:forEach var="relatedfileList" items="${pertinentFileList}" varStatus="status">
						<span style="cursor:pointer;" onclick="fileNameClick('${relatedfileList.FileName}','${relatedfileList.FileRealName}','${relatedfileList.fileOption}','${relatedfileList.Seq}','${relatedfileList.ExtFileURL}');">${relatedfileList.FileRealName}</span>
						<c:if test="${fileList.fileOption ne 'VIEWER'}">
						<img src="${root}${HTML_IMG_DIR}/btn_down_en.png" onclick="fileNameClick('${relatedfileList.FileName}','${relatedfileList.FileRealName}','','${relatedfileList.Seq}','${relatedfileList.ExtFileURL}');" style="cursor:pointer;">
						</c:if>
						<c:if test="${fileList.FileOption eq 'VIEWER'}">
						<img src="${root}${HTML_IMG_DIR}/btn_view_en.png" onclick="fileNameClick('${relatedfileList.FileName}','${relatedfileList.FileRealName}','${relatedfileList.fileOption}','${relatedfileList.Seq}','${relatedfileList.ExtFileURL}');" style="cursor:pointer;">
						</c:if>
						<br>
					</c:forEach>
					</div>
				</td> 
			</tr>
			</c:if>
			
		</c:forEach>
		
		<!-- 최신이전 changeSet 정보   -->	
		<c:if test="${preChangeSetID ne '' && preChangeSetID != null }" >
			<tr>
				<th>Previous</th>
				<td colspan="7" class="tdLast alignL pdL5">							
					<a onClick="fnOpenViewVersionItemInfo('${preChangeSetID}');" style="color:#0054FF;text-decoration:underline;cursor:pointer;">
					Ver.${preChangeSetInfo.Version}&nbsp;Last released on&nbsp;${preChangeSetInfo.CompletionDT}&nbsp; 
					by ${preChangeSetInfo.AuthorName}
					</a>				
				</td>
			</tr>
		</c:if>		
		
		<tr>
			<td colspan="8" class="hr1">&nbsp;</td>
		</tr>		
		 
	</table>
	<!--  //end 기본정보 -->


	<!-- BIGIN :: 속성 -->
		<c:if test="${attributesList.size() > 0}">
		<div id="attrList">
			<table width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview">
				<c:forEach var="attrList" items="${attributesList}" varStatus="status">
					<c:choose>
			   		<c:when test="${columnNum2YN eq 'N' }" >
			   			<colgroup>	
							<col width="11%">
							<col width="89%">
						</colgroup>
			   		</c:when>
			   		<c:otherwise>
			   			<colgroup>	
							<col width="11%">
							<col width="39%">
							<col width="11%">
							<col width="39%">
						</colgroup>
			   		</c:otherwise>
		   		</c:choose>				
				<tr>
					<th>
						<c:if test="${attrList.Mandatory eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${attrList.Name}
						<c:if test="${papagoTrans eq 'Y' && attrList.DataType eq 'Text' && attrList.HTML ne '1'}"><button onclick="fnOpenPapagoTrans('${attrList.AttrTypeCode}','${attrList.HTML}')">Papago</button></c:if>
						<c:if test="${gptAITrans eq 'Y' && attrList.DataType eq 'Text' && attrList.HTML ne '1'}"><button onclick="fnOpenGPTAITrans('${attrList.AttrTypeCode}','${attrList.HTML}')">Translate</button></c:if>
					</th>
					<td class="tdLast alignL pdL5 "
					<c:if test="${attrList.DataType eq 'Text'}">style="height:${attrList.AreaHeight}px;" </c:if>
					<c:if test="${attrList.ColumnNum2 ne '2' }"> colspan="3" </c:if>
					>
						<c:if test="${attrList.HTML eq '1'}">
						<div style="width:100%; height:${attrList.AreaHeight > 200 ? attrList.AreaHeight : 200}px;">
							<textarea class="tinymceText" readonly="readonly">
							 ${attrList.PlainText} 	
							</textarea>
						</div>
						</c:if>
						<c:if test="${attrList.HTML ne '1'}">	
							<c:if test="${attrList.Link == null}">
							<textarea style="width:100%;height:${attrList.AreaHeight}px;" readonly="readonly">${attrList.PlainText}</textarea></c:if>
							<c:if test="${attrList.Link != null || attrUrl != null}" >
								<a onClick="fnRunLink('${attrList.URL}','${attrUrl}', '${attrList.AttrTypeCode}', '${attrList.VarFilter}');" style="color:#0054FF;text-decoration:underline;cursor:pointer;">
								${attrList.PlainText}
								</a>
							</c:if>
						</c:if>
					</td>
					<!-- 두번째 컬럼   -->
					<c:if test="${attrList.ColumnNum2 eq '2' }">
					<th>
						<c:if test="${attrList.Mandatory2 eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${attrList.Name2}
						<c:if test="${papagoTrans eq 'Y' && attrList.DataType2 eq 'Text' && attrList.HTML2 ne '1'}"><button onclick="fnOpenPapagoTrans('${attrList.AttrTypeCode2}','${attrList.HTML2}')">번역</button></c:if>
						<c:if test="${gptAITrans eq 'Y' && attrList.DataType2 eq 'Text' && attrList.HTML2 ne '1'}"><button onclick="fnOpenGPTAITrans('${attrList.AttrTypeCode2}','${attrList.HTML2}')">Translate</button></c:if>
					</th>
					<td class="tdLast alignL pdL5"
					<c:if test="${attrList.DataType2 eq 'Text'}">style="height:${attrList.AreaHeight}px;" </c:if>
					>
						<c:if test="${attrList.HTML2 eq '1'}">
						<div style="width:100%; height:${attrList.AreaHeight > 0 ? 200 : attrList.AreaHeight}px;">
							<textarea class="tinymceText" readonly="readonly">
								${attrList.PlainText2}
							</textarea>
						</div>
						</c:if>
						<c:if test="${attrList.HTML ne '1'}">	
							<c:if test="${attrList.Link2 == null}">
							<textarea style="width:100%;height:${attrList.AreaHeight}px;" readonly="readonly">${attrList.PlainText2}</textarea></c:if>
							<c:if test="${attrList.Link2 != null || attrUrl != null}" >
								<a onClick="fnRunLink('${attrList.URL2}','${attrUrl}', '${attrList.AttrTypeCode2}', '${attrList.VarFilter2}');" style="color:#0054FF;text-decoration:underline;cursor:pointer;">
								${attrList.PlainText2}
								</a>
							</c:if>
						</c:if>
					</td>
					</c:if>
				</tr>													
			</c:forEach>		
		</table>				
		</div>
		</c:if>
		<!--  //end 속성 -->
		<!-- 연관항목 리스트 -->
		<%-- 
		<c:if test="${relItemRowList.size() > 0}">	
			<tr>
				<td colspan="4" class="hr1">&nbsp;</td>
			</tr>	
		<table style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview">
			<colgroup>
				<col width="11%">
				<col width="89%">
			</colgroup>
			<c:forEach var="classList" items="${relItemClassList}" varStatus="status">
			<tr>
				<th>${classList.ClassName}</th>
				<td class="tdLast alignL pdL5">
				<c:forEach var="result" items="${relItemList}" varStatus="loop">
					<c:if test="${classList.ClassCode == result.ClassCode}">
					<a onClick="fnItemLinkLayer('${result.s_itemID}','linkLayer_${loop.index}','${result.ClassCode}');" style="color:#0054FF;text-decoration:underline;cursor:pointer;">
					<span id="linkLayer_${loop.index}"> ${result.Identifier} ${result.ItemName}</span>
					</a>
					&nbsp;&nbsp;&nbsp;
					</c:if>
				</c:forEach>
				</td>
			</tr>
			</c:forEach>		
		 </table>
		</c:if> 
		--%>
		
		<!-- BIGIN :: Dimension -->
		<c:if test="${menuDisplayMap.HasDimension eq '1'}">
			<c:if test="${dimResultList.size() > 0}">
				<tr>
					<td colspan="4" class="hr1">&nbsp;</td>
				</tr>
				<div id="dimensionInfo">
					<table width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview">
						<c:forEach var="dimList" items="${dimResultList}" varStatus="status">
							<colgroup>
								<col width="11%">
								<col width="89%">
							</colgroup>
							<tr>
								<th>${dimList.dimTypeName}</th>
								<td class="tdLast alignL pdL5">
									${dimList.dimValueNames}
								</td>
							</tr>
						</c:forEach>
					</table>
				</div>
			</c:if>
		</c:if>
		<!-- END :: Dimension -->
		<!-- Master 항목 -->
		<c:if test="${mstItemMap != null && mstItemMap.size() > 0}">		
		<table style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview">
			<colgroup>
				<col width="11%">
				<col width="89%">
			</colgroup>
			<tr>
				<td colspan="2" class="hr1">&nbsp;</td>
			</tr>
			<tr>
				<th>Master</th>
				<td class="tdLast alignL pdL5">							
					<a onClick="fnRefItemLayer('${mstItemMap.ItemID}','mstItemLayer');" style="color:#0054FF;text-decoration:underline;cursor:pointer;">
					<span id="mstItemLayer"> ${mstItemMap.Identifier} ${mstItemMap.ItemName}</span>
					</a>				
				</td>
			</tr>		
		</table>		
		</c:if> 
	</div>
</div>
	<!-- 관련항목 메뉴 레이어 팝업 -->	
	<div class="connection_layer" id="connectionPopup">	
		<span class="closeBtn">
			<span style="cursor:pointer;_cursor:hand;position:absolute;right:10px;" OnClick="fnCloseLayer();">Close</span>
		</span> <br>					
		<div class="mgT10 mgB10 mgL5 mgR5">
		<table id="link" class="tbl_blue01 mgT5" style="width:100%;height:99%;table-layout:fixed;">	
		</table> 
		</div>
	</div> 
	
</form>

<!-- START :: FRAME --> 		
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</div>	
<!-- END :: FRAME -->
