<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>


<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_1" arguments="${menu.LN00274}"/> <!-- 도메인 입력 체크 -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_2" arguments="${menu.LN00185}"/> <!-- 시스템 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_3" arguments="${menu.LN00212}"/> <!-- 역학 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="Transfer Reason"/> <!-- 이관사유 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00149" var="WM00149" arguments="${menu.LN00004}"/> <!-- 담당자를 변경 해주십시오  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00018" var="WM00018"/>
<script type="text/javascript">	
	jQuery(document).ready(function() {
		$("input.datePicker").each(generateDatePicker);
		jQuery("#comment").focus();

		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}";
		fnSelect('srArea1', data, 'getSrArea1', '${srInfoMap.SRArea1}', 'Select');
		if('${srInfoMap.SRArea1}' != ''){
			fnGetSRArea2('${srInfoMap.SRArea1}');
		}
	});
	
	function fnSaveSRTransfer(){
		if(!confirm("${CM00001}")){ return;}
		if(!fnCheckValidation()){return;}		
		var currReceiptUserID = "${srInfoMap.ReceiptUserID}";
		var transferReceiptUserID = $("#receiptUserID").val();
		if(currReceiptUserID == transferReceiptUserID){
			alert("${WM00149}"); return;
		}
		var url  = "transferESR.do";
		var target = "saveFrame";
		
		ajaxSubmit(document.srFrm, url, target);
	}
	
	function fnCheckValidation(){
		var isCheck = true;		
		var srArea1 = $("#srArea1").val();
		var srArea2 = $("#srArea2").val();
		var roleType = $("#roleType").val();
		var transferReason = $("#transferReason").val();		
		if(srArea1 == ""){ alert("${WM00025_1}"); isCheck = false; return isCheck;}
		if(srArea2 == ""){ alert("${WM00025_2}"); isCheck = false; return isCheck;}
		if(roleType == ""){ alert("${WM00025_3}"); isCheck = false; return isCheck;}
		if(transferReason == ""){ alert("${WM00034_2}"); isCheck = false; return isCheck;}
		
		return isCheck;
	}

	function fnCallBack(){
		opener.fnGoSRList();
		self.close();
	}
	
	function fnGetSRArea2(SRArea1ID){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&parentID="+SRArea1ID;
		fnSelect('srArea2', data, 'getSrArea2', '${srInfoMap.SRArea2}', 'Select');
	}
	
	function fnGetReceiptUser(roleType){		
		var srArea = "${srArea}";
		var itemID = $("#srArea2").val();
		if(srArea == "SRArea1"){
			itemID = $("#srArea1").val();
		}
		
		var data = "srArea="+itemID+"&RoleType="+roleType;
		var url = "getReceiptUser.do";
		var target = "saveFrame";
		ajaxPage(url, data, target);
	}
	
	function fnGetReceiptUserSrArea2(itemID){
		if(itemID == ""){return;}
		var srArea = "${srArea}";
		if(srArea == "SRArea1"){
			itemID = $("#srArea1").val();
		}
		var roleType = $("#roleType").val();
		var data = "srArea="+itemID+"&RoleType="+roleType;
		var url = "getReceiptUser.do";
		var target = "saveFrame";
		ajaxPage(url, data, target);
	}
	
	function fnSetReceiptUser(receiptUserID,receiptTeamID,receiptName){
		if(receiptUserID != ""){
			$("#receiptUserID").val(receiptUserID);
			$("#receiptName").val(receiptName);
			$("#receiptTeamID").val(receiptTeamID);
		}else{
			alert("${WM00018}");
		}
	}
	
	function searchPopupWf(avg){	
		var url = avg + "&searchValue=" + encodeURIComponent($('#receiptName').val()) 
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		window.open(url,'new_window1','width=340, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSearchNameWf(avg1,avg2,avg3,avg4){
		// window.opener.setSearchNameWf(avg1, avg2, avg3, $('#objId').val(), $('#objName').val());
		$("#receiptName").val(avg2+"("+avg3+")");
		$("#receiptUserID").val(avg1);
		$("#receiptTeamID").val(avg4);
		
	}
	
	function fnCheckReceipt(){
		var checkObj = document.all("assigned");
		if( checkObj.checked == true){ 
			$("#searchReceiptBtn").attr('style', 'display: none');
			$("#receiptName").val("${srInfoMap.ReceiptName}");
			$("#receiptUserID").val("${srInfoMap.ReceiptUserID}");
			$("#receiptTeamID").val("${srInfoMap.ReceiptTeamID}");
		} else {
			$("#searchReceiptBtn").attr('style', 'display: done');
			$("#receiptName").val("");
			$("#receiptUserID").val("");
			$("#receiptTeamID").val("");
		}
	}
	
</script>
</head>

<body>
<div class="pdL10 pdR10">
<form name="srFrm" id="srFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<input type="hidden" id="srID" name="srID" value="${srInfoMap.SRID}">
	<input type="hidden" id="srCode" name="srCode" value="${srInfoMap.SRCode}">
	<input type="hidden" id="subject" name="subject" value="${srInfoMap.Subject}">
	<div class="mgT10 mgB10">
		<h3><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>&nbsp;Transfer  SR</h3>
	</div>
	<table class="tbl_brd mgT5 mgB5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0"> 
		<colgroup>
			<col width="20%">
			<col>
			<col width="20%">
			<col>
		</colgroup>		
		<tr>
			<!-- 도메인 -->
			<th class="alignL pdL10"> ${menu.LN00274}</th>
			<td class="sline tit last" >
				<select id="srArea1" Name="srArea1" OnChange="fnGetSRArea2(this.value);" style="width:250px">
	       			<option value=''>Select</option>
	     	  	</select>
			</td>
			<!-- 시스템 -->
			 <th class="alignL pdL10"> ${menu.LN00185}</th>
			<td class="sline tit last">
				<select id="srArea2" Name="srArea2" style="width:250px" OnChange="fnGetReceiptUserSrArea2(this.value)">
         		   <option value=''>Select</option>
         		  </select>
			</td>
		</tr>
		<tr>
			<th class="alignL pdL10">${menu.LN00163}</th>
			<td class="sline tit last">
				<select id="roleType" name="roleType" style="width:250px;" OnChange="fnGetReceiptUser(this.value)">
				   	<option value="A" <c:if test="${roleType == 'A'}"> selected="selected"</c:if>>PO</option>
					<option value="R" <c:if test="${roleType == 'R'}"> selected="selected"</c:if>>IT</option>
				</select>
			</td>
			<th class="alignL pdL10">SR&nbsp;${menu.LN00004}(&nbsp;Assigned : <input type="checkbox" id="assigned" name="assigned" OnClick="fnCheckReceipt()" checked>&nbsp;) </th>
			<td class="sline tit last" >
				<input type="text" class="text" id="receiptName" name="receiptName" value="${srInfoMap.ReceiptName}" style="ime-mode:active;width:250px;" />
				<input type="hidden" id="receiptUserID" name="receiptUserID" value="${srInfoMap.ReceiptUserID}" />
				<input type="hidden" id="receiptTeamID" name="receiptTeamID" value="${srInfoMap.ReceiptTeamID}" />
				<input type="image" class="image" id="searchReceiptBtn" name="searchReceiptBtn" style="display:none;" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="searchPopupWf('searchPluralNamePop.do?objId=resultID&objName=resultName&UserLevel=ALL')" value="검색">
			</td>
		</tr>
		<tr>
			<th class="alignL pdL10">Transfer Reason</th>
			<td class="sline tit pdR10 last" colspan="3" style="height:120px;">
				<textarea class="edit" id="transferReason" name="transferReason" style="width:100%;height:120px;"></textarea>		
			</td>
		</tr>
	</table>
	<div class="alignBTN">
		<span id="viewSave" class="btn_pack medium icon"><span class="confirm"></span><input value="Transfer" type="submit" onclick="fnSaveSRTransfer()"></span>&nbsp;&nbsp;
	</div>
	</form>
</div>
<!-- END :: DETAIL -->
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>
</body>
</html>
