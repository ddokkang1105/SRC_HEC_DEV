<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_1" arguments="${menu.LN00274}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_2" arguments="${menu.LN00185}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_3" arguments="${menu.LN00067}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00007" var="WM00007" arguments="${menu.LN00222}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00026" var="CM00026" arguments="${menu.LN00082}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00028" var="CM00028"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00131" var="WM00131"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00051" var="CM00051"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00015" var="CM00015"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00015" var="WM00015" arguments="${menu.LN00222}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00002}"/> <!-- 제목 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00003}"/> <!-- 개요 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="${menu.LN00004}"/> <!-- 개요 입력 체크  -->

<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<script type="text/javascript">
	var p_gridArea;
	var dp;
	
	$(document).ready(function(){
		$("input.datePicker").each(generateDatePicker);

		$("#grdGridArea").attr("style","height:200px;");
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}";
		fnSelect('crArea1', data, 'getSrArea1', '${getMap.CRArea1}', 'Select');
		fnSelect('priority', data+"&category=PRT", 'getDictionaryOrdStnm', '${getMap.Priority}', 'Select');
		fnGetCRArea2("${getMap.CRArea1}","${getMap.CRArea2}");
		gridCSListInit();
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function fnCheckValidation(){
		var isCheck = true;		
		
		var crArea1 = $("#crArea1").val();
		var crArea2 = $("#crArea2").val();
		var priority = $("#priority").val();
		var subject = $("#subject").val();
		var description = $("#description").val();
		var receiptName = $("#receiptName").val();
		if(crArea1 == ""){ alert("${WM00025_1}"); isCheck = false; return isCheck;}
		if(crArea2 == ""){ alert("${WM00025_2}"); isCheck = false; return isCheck;}
		if(priority == ""){ alert("${WM00025_3}"); isCheck = false; return isCheck;}
		if(subject == ""){ alert("${WM00034_1}"); isCheck = false; return isCheck;}
		if(description == "" ){ alert("${WM00034_2}"); isCheck = false; return isCheck;}
		if(receiptName == "" ){ alert("${WM00034_3}"); isCheck = false; return isCheck;}
		
		return isCheck;
	}
	
	// [Save]
	function saveNewCr() {
		// 프로젝트, 변경오더, 완료요청일  필수 Check
		var crMode = "${crMode}";
		
		if ($('#ReqDueDate').val() == "") {
			alert("${WM00007}");
			return;
		} 
				
		//완료요청일 check : 시스템 날짜보다과거 이면 안됨
		var sysDate = "${thisYmd}"; 
		var reqdueDate = $('#ReqDueDate').val();
		if (fnDateCompare(reqdueDate, sysDate) > 0) {
			alert("${WM00015}");
			return;
		}
		
		if(!fnCheckValidation()){return;}
		if(confirm("${CM00001}")){
			var url = "saveCrInfo.do";
			ajaxSubmit(document.addCrFrm, url);
		}
	}
	
	// [List]
	function goBack() {
		var isCrEdit = "${isCrEdit}";
		// issue 목록 화면으로 [등록]
		var url = "crMstList.do";
		var data = "ProjectID=${ProjectID}&isNew=${isNew}&mainMenu=${mainMenu}" 
				+ "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}"
				+ "&Creator=${Creator}&ParentID=${ParentID}&issueMode=${issueMode}"
				+ "&currPageI=${currPageI}"
				+ "&screenType=${screenType}";
		if (isCrEdit == "Y") {
			// Cr 상세 화면으로 이동[편집]
			url = "crInfoDetail.do";
			data = "issueMode=${issueMode}&issueId=${getMap.IssueID}&crID=${getMap.CRID}"
					+ "&currPageI=${currPageI}"
					+ "&ParentID=${ParentID}"
					+ "&screenType=${screenType}";
		} 
		var target = "createCRDiv";
		ajaxPage(url, data, target);
	}
	
	function fnGetCRArea2(CRArea1ID, CRArea2ID){
		if( CRArea2ID == 'undefined'){CRArea2ID="";}
		if(CRArea2ID != ""){
			fnGetReceipt(CRArea2ID);
		}
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&parentID="+CRArea1ID;
		fnSelect('crArea2', data, 'getSrArea2', CRArea2ID, 'Select');
	}
	
	function fnGetReceipt(crArea2){
		var url = "getReceipt.do";
		var data = "crArea2="+crArea2;
		var target = "saveFrame";
		
		ajaxPage(url, data, target);
	}
	
	function fnSetReceipt(receiptID,receiptName,receiptTeamID,ITSMType){
		var checkObj = document.all("assigned");
		if( checkObj.checked == true){ 
			$("#receiptID").val(receiptID);
			$("#receiptName").val(receiptName);
			$("#receiptTeamID").val(receiptTeamID);
		}
		$("#ITSMType").val(ITSMType);
	}
	
	function fnGoBackSR(){
		opener.fnCallBackSR();
		self.close();
	}
	
	function fnCheckReceipt(){
		var checkObj = document.all("assigned");
		if( checkObj.checked == false){ 
			$("#searchReceiptBtn").attr('style', 'display: done');
			$("#receiptID").val("");
			$("#receiptName").val("");
			$("#receiptTeamID").val("");
		} else {
			$("#searchReceiptBtn").attr('style', 'display: none');
		}
	}
	
	function searchPopupWf(avg){	
		var url = avg + "&searchValue=" + encodeURIComponent($('#receiptName').val()) 
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		window.open(url,'window','width=340, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSearchNameWf(avg1,avg2,avg3,avg4){
		$("#receiptName").val(avg2+"("+avg3+")");
		$("#receiptID").val(avg1);
		$("#receiptTeamID").val(avg4);
	}
	
	/* ChangeSet List */
	function gridCSListInit(){
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);	
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
		
		p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowSelect(id,ind);
		});
		
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.setColumnHidden(8, true);
		
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data, false, "", "", "", "", "${WM00119}", 1000);		
	}
	
	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		
		result.key = "item_SQL.getOwnerItemList";
		
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00015},${menu.LN00028},${menu.LN00043},${menu.LN00027},${menu.LN00004},${menu.LN00070},,";
		result.cols = "CHK|Identifier|ItemNM|Path|StatusNM|AuthorName|LastUpdated|ItemID|Status";
		result.widths = "30,30,100,200,300,80,80,100,1,1";
		result.sorting = "int,int,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&authorID=${sessionScope.loginInfo.sessionUserId}"
					+ "&itemTypeCode=${getMap.ItemTypeCode}"
					+ "&isCR=Y" 
					+ "&srID=${getMap.SRID}"
					+ "&classCode=";					
					
		return result;
	}

	// 그리드ROW선택시
	function gridOnRowSelect(id, ind){
		
		var itemId = p_gridArea.cells(id, 7).getValue();
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,itemId);
		
	}
	
	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}	
	
	function setItemIDs() {
		var items = "";
		var status = "";
		var checkedRows = p_gridArea.getCheckedRows(1).split(",");	
		if(checkedRows != ""){
		
		for(var i = 0 ; i < checkedRows.length; i++ ){			
			status = p_gridArea.cells(checkedRows[i], 9).getValue();
			
			if(status != "NEW1") {
				if (items == "") {
					items = p_gridArea.cells(checkedRows[i], 8).getValue();
				} else {
					items = items + "," + p_gridArea.cells(checkedRows[i], 8).getValue();
				}
			}
		}
		
		$("#itemIDs").val(items);
		}
	}
	
	function fnCompletion(){
		if(!fnCheckValidation()){return;}
		if(confirm("${CM00001}")){
			var url = "completionCR.do";
			ajaxSubmit(document.addCrFrm, url);
		}
	}

</script>
</head>
<body>
<div id="createCRDiv" name="createCRDiv" style="padding: 0 6px 6px 6px;">
<form name="addCrFrm" id="addCrFrm" enctype="multipart/form-data" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
	<input type="hidden" id="isCrEdit" name="isCrEdit" value="${isCrEdit}" />	
	<input type="hidden" id="crID" name="crID" value="${getMap.CRID}" />
	<input type="hidden" id="crMode" name="crMode" value="${crMode}" />
	<input type="hidden" id="srID" name="srID" value="${getMap.SRID}" />
	<input type="hidden" id="ProjectID" name="ProjectID" value="${ProjectID}" />
	<input type="hidden" id="csrID" name="csrID" value="${CSRID}" />
	<input type="hidden" id="ITSMType" name="ITSMType" value="" />	
	<input type="hidden" id="mainMenu" name="mainMenu" value="${mainMenu}" />
	<input type="hidden" id="screenType" name="screenType" value="${screenType}" />	
	<input type="hidden" id="itemIDs" name="itemIDs" value="" />	
	
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 6px 0 6px 0"><img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;${menu.LN00240}</h3>
	</div>
	<div id="crDiv" class="hidden" style="width:100%;height:400px;">
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">	
			<colgroup>
				<col width="15%">
				<col width="35%">
				<col width="15%">
				<col width="35%">			
			</colgroup>
			 <tr>
		   		<!-- 도메인 -->
			    <th class=" alignL pdL10">${menu.LN00274}</th>
			    <td class=" alignL pdL10">     
				  	<select id="crArea1" Name="crArea1" OnChange="fnGetCRArea2(this.value);" style="width:80%">
				    </select>
			    </td>
		       	<!-- 시스템 -->
		        <th class=" alignL pdL10" last>${menu.LN00185}</th>
		        <td class=" alignL pdL10 last">     
		        <select id="crArea2" Name="crArea2" style="width:80%" OnChange="fnGetReceipt(this.value);">
		        </select>
		        </td>
			</tr>
			 <tr>
      		    <!-- 담당자 -->
		       <th class=" alignL pdL10">${menu.LN00004}(&nbsp;<input type="checkbox" id="assigned" name="assigned" OnClick="fnCheckReceipt()" checked>&nbsp; Assigned)</th>
		       <td class=" alignL pdL10">  
		           <input type="text" class="text" id="receiptName" name="receiptName" value="${getMap.ReceiptName}" style="ime-mode:active;width:80%;" />
		       	   <input type="hidden" id="receiptID" name="receiptID" value="${getMap.ReceiptUserID}" style="ime-mode:active;width:80%;" />
		       	   <input type="hidden" id="receiptTeamID" name="receiptTeamID" value="${getMap.ReceiptTeamID}" />	
		       	   <input type="image" class="image" id="searchReceiptBtn" name="searchReceiptBtn" style="display:none;" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="searchPopupWf('searchPluralNamePop.do?objId=resultID&objName=resultName')" value="검색">
		       </td>
		       <!-- 요청자 -->
		       <th class="alignL pdL10">  ${menu.LN00025}</th>
		       	<td class=" alignL pdL10 last" >${sessionScope.loginInfo.sessionUserNm}(${sessionScope.loginInfo.sessionTeamName})
		       		<input type="hidden" class="text" id="requestUserID" name="requestUserID" value="${sessionScope.loginInfo.sessionUserId}" style="ime-mode:active;width:80%;" />
		       </td>
		    </tr> 
			
			<tr>	
				<!-- 완료요청일 -->
				<th class=" alignL pdL10">${menu.LN00222}</th>
				<td class=" alignL pdL10">   
					<input type="text" id="ReqDueDate" name="ReqDueDate" value="${getMap.DueDate}" class="text datePicker" style="width: 70px;" onchange="this.value = makeDateType(this.value);" maxlength="10">
				</td>
				<!-- Priority -->
		        <th class=" alignL pdL10 ">  ${menu.LN00067}</th>
	        	<td class="alignL pdL10 last">			        
			        <select id="priority" Name="priority"  style="width:100px;">
			            <option value=''>Select</option>
			        </select>
		        </td>
			</tr>
			<tr>
				<!-- 제목  -->
				<th class=" alignL pdL10 ">${menu.LN00002}</th>
				<td class=" alignL pdL10 last" colspan="3">
					<input type="text" class="text" id="Subject" name="Subject" value="${getMap.Subject}"/> 					
				</td>
			</tr>
			<!-- 개요 -->			
			<tr>
				<th class=" alignL pdL10 ">${menu.LN00035}</th>
				<td colspan="4" class="alignL pdL10 last">
					<div style="width:100%;height:200px;">
						<textarea class="tinymceText"  id="Description" name="Description" >${getMap.Description}</textarea>
					</div>
				</td>
			</tr>
			<tr>
			<th class=" alignL pdL10 ">Item's</th>
				<td colspan="4" class="alignL pdL10 last">
			
				<div id="gridCngtDiv" style="width:100%;" class="clear">
					<div id="grdGridArea" style="width:100%"></div>
				</div>		
				</td>
			</tr>
			 <tr>
	       	<td colspan="4" class="alignR pdR20 last" bgcolor="#f9f9f9">  
	       		<span id="viewList" class="btn_pack medium icon"><span class="confirm"></span><input value="Save" onclick="saveNewCr()" type="button"></span> 
	       		<c:if test="${getMap.Status ne 'CLS'}" >
	       		<span id="viewSave" class="btn_pack medium icon"><span class="confirm"></span><input value="Complete" type="submit" onclick="fnCompletion()"></span>&nbsp;
	       		</c:if>
				<c:if test="${crMode != 'SR'}" >
				<span class="btn_pack medium icon"><span class="pre"></span><input value="Cancel" onclick="goBack()" type="button"></span>
				</c:if>
			</tr>
		</table>	
	</div>
</form>
</div>
<div style="display:none;">
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</div>
</body>
</html>
