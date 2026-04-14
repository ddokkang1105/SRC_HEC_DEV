<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 <%@ page import="xbolt.cmm.framework.val.GlobalVal"%>  
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/pim.css"/>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00066" var="CM00066" arguments="Alarm Option"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00067" var="CM00067" arguments="${menu.LN00027}"/>

<script type="text/javascript">
var startTime = "${procInstanceInfo.StartTime}";
var procInstNo = "${procInstanceInfo.ProcInstNo}";
var procInstStatus = "${procInstanceInfo.Status}";

	$(document).ready(function(){
		var height = setWindowHeight();
		if("${scrnMode}" == "E"){
			var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&procType=${procType}";
			fnSelectNone('processID', data, 'getProcessList', '${procInstanceInfo.ProcessID}');
		}
		var agent = navigator.userAgent.toLowerCase();		
		setFrame(4);
	
		var timer = setTimeout(function() {
			$("input.datePicker").each(generateDatePicker);
		}, 250);
		
		window.onresize = function() {
			$("#digramFrame").height("calc(100% - 52px)");
			$("#cfgFrame").height("calc(100% - 52px)");
		}
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function setFrame(avg) {
		var browserType="";
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		
		var url= "";
		var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
						+ "&s_itemID=${s_itemID}"
						+ "&fromModelYN=${fromModelYN}"
						+ "&instanceNo="+procInstNo
						+ "&instanceClass=${instanceClass}"
						+ "&processID=${procInstanceInfo.ProcessID}"
						+ "&myItem=${myItem}"
						+ "&procModelID=${procInstanceInfo.ProcModelID}";
		var target = "cfgFrame";
						
		if(avg != 4){
			if(avg == 1){
				url = "viewElmInstList.do";
			}else if(avg == 2){
				url = "procInstRoleList.do";
			}else if(avg == 3){
				url = "pim_instanceFileList.do";
			}else if(avg == 5){
				url = "dimListForInstanceInfo.do";
			}else if(avg == 6){
				url = "forumMgt.do";
				data += "&projectID=${procInstanceInfo.ProjectID}&isProcInst=Y";
			}
			
//	 		var src = url +"?" + data+"&browserType="+browserType;
//	 		var idx = (window.location.href).lastIndexOf('/');
			var height = (setWindowHeight() - $(".wrapView").height()) - 400;
//	 		$("#clickedURL").val((window.location.href).substring(0,idx)+"/"+src);
			$("#cfgFrame").empty();
			$("#digramFrame").attr("style", "display:none;");
			$("#cfgFrame").attr("style", "display:block;height:calc(100% - 52px);");
			ajaxTabPage(url, data, target);
		} else {
			// url = "newDiagramViewer.do";
			url = "viewProcInstModel.do";
			data += "&getAuth=${sessionScope.loginInfo.sessionLogintype}"+"&userID=${sessionScope.loginInfo.sessionUserId}";
			var src = url +"?" + data+"&browserType="+browserType;
			var idx = (window.location.href).lastIndexOf('/');
			$("#clickedURL").val((window.location.href).substring(0,idx)+"/"+src);
			document.getElementById('digramFrame').contentWindow.location.href= src; // firefox 호환성  location.href에서 변경
			$("#digramFrame").attr("style", "display:block;height:calc(100% - 52px);border: 0;");
			$("#cfgFrame").attr("style", "display:none;");
		}
	}

	var SubTabNum = 4; /* 처음 선택된 tab메뉴 ID값*/
	$(function(){
		$("#cli"+SubTabNum).addClass('on');
		
		$('.SubTab ul li').mouseover(function(){
			$(this).addClass('on');
		}).mouseout(function(){
			if($(this).attr('id').replace('cli', '') != SubTabNum) {
				$(this).removeClass('on');
			}
			$('#tempDiv').html('SubTabNum : ' + SubTabNum);
		}).click(function(){
			$(".SubTab ul li").removeClass("on"); //Remove any "active" class
			$(this).addClass('on');
			SubTabNum = $(this).attr('id').replace('cli', '');
		});
	});

	function LayerPopupView(sLinkName, sDivName)  { 
		var oPopup = document.getElementById(sDivName);
		var oLink = document.getElementById(sLinkName);
		var scrollTop = document.getElementById("cfgFrame").scrollTop;
		var nTop = 140;
		oPopup.style.top = (oLink.offsetTop + nTop - scrollTop) + "px";    
		oPopup.style.left = (oLink.offsetLeft + 10) + "px";
	}
	
	function fnHideTable() {
		var tempSrc = $("#fitWindow").attr("src");
		if($("#fitWindow").hasClass("frame_show")) {
			//$("#wrapView").hide();
			var height = $("#wrapView").height();
			$("#wrapView").attr("style","visibility:hidden");
			$("#bottomView").attr("style","position:relative;top:-" + height + "px;");
			$("#bottomView").height("100%");
			$("#PlmViewPjtDIV").scrollTop(0);
			$("#fitWindow").attr("class","frame_hide");
			$("#fitWindow").attr("alt","${WM00159}");
			$("#gridArea").attr("style","height:calc(100% - 280px)");
			$("#pimElementFrm .objbox").height("calc(100% - 28px)");
		}
		else {
			$("#wrapView").attr("style","visibility:visible");
			$("#bottomView").attr("style","position:relative;top:" + height + "px;");
			$("#bottomView").height("calc(100% - "+$("#PLMFrm").innerHeight()+"px)");
			$("#fitWindow").attr("class","frame_show");
			$("#fitWindow").attr("alt","${WM00158}");
			$("#gridArea").attr("style","height:calc(100% - 280px)");
			$("#pimElementFrm .objbox").height("calc(100% - 28px)");
		}
	}
	
	
	
	/* 의견공유, 변경이력, 관련문서, Dimension 등의 화면으로 이동 */
	function goMenu(avg){
		var url = "";
		var target = "PlmViewPjtDIV";
		var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&myItem=${myItem}"
					+ "&instanceNo="+procInstNo
					+ "&instanceClass=${procInstanceInfo.instanceClass}"
					+ "&processID=${procInstanceInfo.ProcessID}"; 
		
		if (avg == "fileMgt") {
			url = "pim_instanceFileList.do?&fileOption=${menuDisplayMap.FileOption}";
		} else if (avg == "changeMgt") {
			url = "itemHistory.do"; // 변경이력
			data = data + "&myItem=${myItem}&itemStatus=${itemStatus}";
		} else if (avg == "forum") {
			url = "forumMgt.do"; // 의견공유
		} else if (avg == "dim") {
			url = "dimListForItemInfo.do"; // Dimension
		} else if (avg == "model") {
			url = "getModelListGrid.do"; // Model
			data = data + "&filter=subElement&isFromMain=Y";
		} else if (avg == "rev") {
			url = "revisionList.do?docCategory=ITM"; // Revision
		} 
		
		ajaxPage(url, data, target);
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
		var url  = "fileDownload.do?seq="+seq+"&scrnType=INST";
		ajaxSubmitNoAdd(document.PLMFrm, url,"blankFrame");
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
	
	/* edit */
	function goProcInstanceInfoEdit(scrnMode) {	
	    var url = "procInstDetail.do";
		var target = "instanceListDiv";
		var data = "masterItemID=${s_itemID}&instanceNo="+procInstNo+"&instanceClass=${procInstanceInfo.InstanceClass}&procType=${procType}&scrnMode="+scrnMode;
	 	ajaxPage(url, data, target);
		
	}
	
	function goProcInstanceInfoSave(){
		var url = "updateProcInstanceInfo.do";
		if(startTime != $("#startTime").val()){
			$("#startTimeChange").val("T");
		}else{
			$("#startTimeChange").val("F");
		}
		ajaxSubmit(document.PLMFrm, url,"subFrame");
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
		
		var url  = "fileDownload.do?seq="+seq+"&scrnType=INST";
		ajaxSubmitNoAdd(document.PLMFrm, url,"blankFrame");
		
	}
	
	function getHeigth(){
		var topHeight = 23+$(".SubinfoTabs").height();
		var height = document.body.clientHeight - topHeight-272;
		return height;
	}
	
	function searchPopup(){		
		var searchValue = $("#ownerName").val();
		var url = "searchPluralNamePop.do?objId=resultID&objName=resultName&UserLevel=ALL";
		url += "&searchValue=" + encodeURIComponent(searchValue) + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		window.open(url,'new_window1','width=340, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSearchNameWf(avg1,avg2,avg3,avg4,avg5){
		$("#ownerName").val(avg2);
		$("#ownerID").val(avg1);
		$("#ownerTeamName").text(avg3);
		$("#ownerTeamID").val(avg4);
	}
	
	function fnOpenItemPop(){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id=${s_itemID}&scrnType=pop";
		var w = 1200;
		var h = 900; 
		itmInfoPopup(url,w,h,"${s_itemID}");
	}
	
	function fnWithDrawProcInst(){
		if(confirm("${CM00067}")){
			var url = "withDrawProcInst.do";
			var data = "procInstNo="+procInstNo;
			if(procInstStatus == 'WTR'){
				data += "&status=WAT";	
			}else{
				data += "&status=WTR";
			}
				
			var target = "subFrame";
			ajaxPage(url, data, target);	
		}
	}
</script>

<input type="text" id="clickedURL" style="display:none;">
<div id="PlmViewPjtDIV" style="width:100%; height:100%; float:left; position:relative;">
<form name="PLMFrm" id="PLMFrm" action="" method="post" onsubmit="return false;">
<input type="hidden" id="procInstNo" name="procInstNo" value="${procInstanceInfo.ProcInstNo}" />
<input type="hidden" id="instanceClass" name="instanceClass" value="${procInstanceInfo.InstanceClass}" />
<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}" />
<div class="pdL10 pdR10 wrapView" id="wrapView" style="float:left;" >
	<div class="child_search01 pdT6 pdB5">
		<ul>
			<li class="floatL"><h3 class="floatL"><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>&nbsp;Project Information</h3></li>
			<li class="floatR">
				<c:if test="${(sessionScope.loginInfo.sessionUserId eq procInstanceInfo.OwnerID || sessionScope.loginInfo.sessionUserId eq prcMap.AuthorID)}">
					<c:if test="${scrnMode ne 'E' }">
						<c:choose>
							<c:when test="${procInstanceInfo.Status eq 'WAT'}">
							&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Withdraw" type="submit" onclick="fnWithDrawProcInst()"></span>
							</c:when>
							<c:when test="${procInstanceInfo.Status eq 'WTR'}">
							&nbsp;<span class="btn_pack small icon"><span class="edit"></span><input value="Recover" type="submit" onclick="fnWithDrawProcInst();"></span>
							</c:when>
						</c:choose>
						<c:if test="${procInstanceInfo.Status ne 'WTR' }">
							&nbsp;<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="submit" onclick="goProcInstanceInfoEdit('E');"></span>
						</c:if>
					</c:if>
					<c:if test="${scrnMode eq 'E' }">
						<c:choose>
							<c:when test="${procInstanceInfo.Status ne 'WTR'}">
								&nbsp;<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="submit" onclick="goProcInstanceInfoEdit('V');"></span>
								&nbsp;<span class="btn_pack small icon"><span class="save"></span><input value="Save" type="submit" onclick="goProcInstanceInfoSave();"></span>
							</c:when>
						</c:choose>
					</c:if>
					
				</c:if>
			</li>
	    </ul>
	</div>
	
	<table style="table-layout: fixed;" width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_blue01">
		<colgroup>
			<col width="10%">
			<col width="23%">
			<col width="10%">
			<col width="23%">		
			<col width="10%">
			<col width="23%">		
		</colgroup>
		<tr>	
			<th>Project No.</th>
			<td>${procInstanceInfo.DocumentNo}</td>
			<th>Project Name</th>
			<td>${procInstanceInfo.ProcInstanceNM}</td>
			<th>Project Type</th>
			<td class="last">${procInstanceInfo.docCategoryName}</td>
		
		</tr>
		<tr>
			<th>Process</th>
			<c:choose>
				<c:when test="${scrnMode eq 'E' and procInstanceInfo.Status eq 'OPN' }">
					<td><select class="sel" id="processID" name="processID" style="width:100%;"></select></td>
				</c:when>
				<c:otherwise><td style="text-decoration: underline;cursor: pointer;" onClick="fnOpenItemPop()">${procInstanceInfo.ItemName}</td></c:otherwise>
			</c:choose>
			<th>Manager</th>
			<td>
				
				<c:choose>
					<c:when test="${scrnMode eq 'E' }">
						<input type="text" class="text" id="ownerName" name="ownerName" value="${procInstanceInfo.OwnerName}" style="width: 89%;"/>
						<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="searchPopup()" value="검색">
						<input type="hidden" id="ownerID" name="ownerID" value="${procInstanceInfo.OwnerID}"/>
						<input type="hidden" id="ownerTeamID" name="ownerTeamID" value="${procInstanceInfo.OwnerTeamID}"/>
					</c:when>
					<c:otherwise>
						${procInstanceInfo.OwnerName}(<span id="ownerTeamName">${procInstanceInfo.OwnerTeamName}</span>)					
					</c:otherwise>
				</c:choose>
			</td>
			
			<th>${menu.LN00027}</th>
			<td class="last">${procInstanceInfo.StatusName}</td>
		</tr>
		<tr>
			
			<th>Start date</th>
			<td>
				<c:choose>
					<c:when test="${scrnMode eq 'E' }">
						<font><input type="text" id="startTime" name="startTime" value="${procInstanceInfo.StartTime}" class="datePicker stext"
							style="width: 80px;text-align: center;" onchange="this.value = makeDateType(this.value);" maxlength="10">
						</font>
						<input type="hidden" id="startTimeChange" name="startTimeChange" value="F"/>
					</c:when>
					<c:otherwise>${procInstanceInfo.StartTime}</c:otherwise>
				</c:choose>
				<%-- ${procInstanceInfo.StartTime} --%>
			</td>
			<th>Alarm On/Off</th>
			<td>
				<c:choose>
					<c:when test="${scrnMode eq 'E' }">
						<select id="alarmOption" name="alarmOption" class="sel">
							<option value="1">On</option>
							<option value="0">Off</option>
						</select>
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${procInstanceInfo.alarmOption eq '1' }">
								On
							</c:when>
							<c:otherwise>
								Off
							</c:otherwise>
						</c:choose>
					</c:otherwise>
				</c:choose> 
				
				<%-- <c:choose>
					<c:when test="${procInstanceInfo.alarmOption eq '1' }">
						On
					</c:when>
					<c:otherwise>
						Off
					</c:otherwise>
				</c:choose> --%>
				<input type="hidden" id="alarmOption" name="alarmOption" value="${procInstanceInfo.alarmOption}" />
			</td>
			<th>Alarm Interval</th>
			<td class="last">
				<c:choose>
				<c:when test="${scrnMode eq 'E' }">
						<input type="text" class="text" id="alarmInterval" name="alarmInterval" value="${procInstanceInfo.alarmInterval}" style="width: 89%;"/>
					</c:when>
					<c:otherwise>${procInstanceInfo.alarmInterval}</c:otherwise>
				</c:choose>
			</td>
			
		</tr>
			
		<tr>	
			<th style="height:60px;">${menu.LN00035}</th>
			<td style="height:60px;" class="tdLast alignL pdL5 last" colspan="5">
				<c:choose>
					<c:when test="${scrnMode eq 'E' }">
					<textarea class="edit" style="resize:none; width:100%; height:50px;background: #fff;" name="description">${procInstanceInfo.PrcInstanceDesc}</textarea>
					</c:when>
					<c:otherwise><textarea style="resize:none; width:100%; height:50px;background: #fff;" name="description">${procInstanceInfo.PrcInstanceDesc}</textarea></c:otherwise>
				</c:choose>
			</td>
		</tr>		
	</table>
</div>
</form>

<div id="bottomView" class="pdL10 pdR10" style="height:calc(100% - 177px);">
	<div class="SubTab" style="margin-top:20px;">
		<ul>
			<li id="cli4" onclick="setFrame(4)" class="on"><a><span>Process Map</span></a></li>
			<li id="cli1" onclick="setFrame(1)"><a><span>Activity List</span></a></li>	
<!-- 			<li id="cli2" onclick="setFrame(2)"><a><span>Member</span></a></li>		 -->
<!-- 			<li id="cli5" onclick="setFrame(5)"><a><span>Instance Dimension</span></a></li> -->
			<li id="cli6" onclick="setFrame(6)"><a><span>Q&A</span></a></li>

		</ul>
		<div class="instance_top_btn mgR10" ><a id="fitWindow" class="frame_show" onclick="fnHideTable()"></a></div>
	</div>
	<div id="cfgFrame" style="width:100%;overflow:auto; padding:0 0 17px 0;" ></div>
	<iframe width="100%" frameborder="0" scrolling="no" style="display:none;border: 0;overflow:auto; padding:0 0 17px 0;" name="digramFrame" id="digramFrame"></iframe>
	<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</div>
</div>
