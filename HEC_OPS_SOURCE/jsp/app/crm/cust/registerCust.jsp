<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="고객명"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="고객레벨"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00005" var="CM00005"/>
 
<script>

var p_gridArea;				//그리드 전역변수
var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용
var viewType = '${viewType}';

$(document).ready(function(){
	var height = setWindowHeight();
	$("#groupListDiv").height(height-30);
	window.onresize = function(){
		height = setWindowHeight();
		$("#groupListDiv").height(height-30);
	};
	
	fnSelect('countryID','', 'getCountry', '${resultMap.CountryID}','Select');
	fnSelect('custLvl', '&Category=CUSTTP', 'dictionyCode', '${resultMap.CustLvl}', 'Select');
	$('.subTr').hide();
	fnSetParentNo('${resultMap.CustLvl}');
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

//===============================================================================
// BEGIN ::: GRID

function fnSetParentNo(dataType){
	if(dataType == "C"){ //기업
		$('.subTr').show();
		fnSelect('parentNo','&custLvl=G', 'getCustMst', '${resultMap.ParentNo}','Select');
	
	}else if(dataType == "D"){ //Division
		
		$('.subTr').hide();
		$('.subTr2').show();
		if(viewType=='N'){
			$("#bizNo").val('');
			$("#ceoName").val('');
		}
		fnSelect('parentNo','&custLvl=C', 'getCustMst', '${resultMap.ParentNo}','Select');
	
	}
	else{ //그룹
		
		$('.subTr').hide();
		if(viewType=='N'){
			$("#parentNo").val('');
			$("#bizNo").val('');
			$("#ceoName").val('');
			$("#bizType").val('');
			$("#bizItem").val('');
			$("#countryID").val('');
			$("#city").val('');
			$("#addr1").val('');
			$("#addr2").val('');
		}
	}
}

function newCustInsert(type){

	if ($("#customerNM").val() == "") {
		alert("${WM00034_1}");
		return false;
	}
	
	if ($("#custLvl").val() == "") {
		alert("${WM00034_2}");
		return false;
	}
	
	var script = "this.goBack();";
	if(type == 'saveAdd'){script = "this.fnCallback();"}
	var confirm_Txt = "";
	if(viewType == 'N'){confirm_Txt = "${CM00009}";} else { confirm_Txt = "${CM00005}"; }
	
	if(confirm(confirm_Txt)){
		var url = "saveCust.do";
		var data = "regUserID=${sessionScope.loginInfo.sessionUserId}&viewType=${viewType}"
					+ "&customerNM=" + $("#customerNM").val()
					+ "&customerNM_EN=" + $("#customerNM_EN").val()
					+ "&custType=" + $("#custType").val()
					+ "&custLvl=" + $("#custLvl").val()
					+ "&parentNo=" + $("#parentNo").val()
					+ "&bizNo=" + $("#bizNo").val()
					+ "&ceoName=" + $("#ceoName").val()
					+ "&bizType=" + $("#bizType").val()
					+ "&bizItem=" + $("#bizItem").val()
					+ "&countryID=" + $("#countryID").val()
					+ "&state=" + $("#state").val()
					+ "&city=" + $("#city").val()
					+ "&addr1=" + $("#addr1").val()
					+ "&addr2=" + $("#addr2").val()
					+ "&customerDesc=" + $("#customerDesc").val()
					+ "&customerNo=${resultMap.CustomerNo}"
					+ "&teamID=${resultMap.TeamID}"
					+ "&script=" + script;

		var target = "groupListDiv";
		ajaxPage(url, data, target);
	}
}
	
function goBack() {
	if(viewType == 'N'){
		var url = "custList.do";
		var data =   "&pageNum=" + $("#currPage").val();
		var target = "groupListDiv";
		ajaxPage(url, data, target);
	}else{
		var url = "custDetail.do";
		var data =  "customerNo=${resultMap.CustomerNo}&custTeamID=${resultMap.TeamID}"
					+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&pageNum=" + $("#currPage").val();
		var target = "groupListDiv";
		ajaxPage(url, data, target);
	}
}

function fnCallback(){
	var url = "registCust.do";
	var data =   "&pageNum=" + $("#currPage").val();
	var target = "groupListDiv";
	ajaxPage(url, data, target);
}

</script>

</head>

<body>

	<!-- BEGIN :: BOARD_ADMIN_FORM -->
	<form name="groupList" id="groupList" action="#" method="post" onsubmit="return false;">
	<div id="groupListDiv" class="hidden" style="width:100%;overflow-y:auto;">
	<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="" />
	<div class="msg"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">
		<c:if test="${viewType == 'N'}">&nbsp;고객정보 등록</c:if>
		<c:if test="${viewType == 'E'}">&nbsp;고객정보 수정</c:if>
	</div>
	<div id="groupInfoDiv" class="hidden" style="width:100%;height:400px;">
		
		<table class="cmm_form_table mgT20">
			<colgroup>
				<col width="10%">
				<col width="40%">
				<col width="10%">
				<col width="40%">
			</colgroup>
			
			<tr>
				<th>고객명</th>
				<td><input type="text" class="text" id="customerNM" name="customerNM"  value="${resultMap.CustomerNM}"/></td>
				<th>영문고객명</th>
				<td><input type="text" class="text" id="customerNM_EN" name=customerNM_EN  value="${resultMap.CustomerNM_EN}"/></td>
			</tr>
			<tr>
				<th>고객레벨</th>
				<td><select class="sel" id="custLvl" name="custLvl" onclick="fnSetParentNo(this.value)"></td>
				<th>고객유형</th>
				<td>
					<select class="sel" id="custType" name="custType">
						<option value="">Select</option>
						<option value="CS" <c:if test="${resultMap.CustType == 'Customer'}">selected</c:if>>고객</option>
						<option value="BP" <c:if test="${resultMap.CustType == 'Partner'}">selected</c:if>>파트너</option>
				</select>
			</tr>
			
			<tr class="subTr subTr2">
				<th>상위조직</th>
				<td class="viewtop last"><select class="sel" id="parentNo" name="parentNo">
					<option value="">Select</option></select>
				</td>
				<th>국가</th>
				<td class="last"><select class="sel" id="countryID" name="countryID"><option value="">Select</option></select></td>
			</tr>
			<tr class="subTr">
				<th>사업자번호</th>
				<td><input type="text" class="text" id="bizNo" name="bizNo"  value="${resultMap.BizNo}"/></td>
				<th>대표자명</th>
				<td><input type="text" class="text" id="ceoName" name="ceoName"  value="${resultMap.CEOName}"/></td>
			</tr>
			<tr class="subTr subTr2">	
				<th>사업분야</th>
				<td class="last"><input type="text" class="text" id="bizType" name="bizType"  value="${resultMap.BizType}"/></td>
				<th>종목</th>
				<td><input type="text" class="text" id="bizItem" name="bizItem"  value="${resultMap.BizItem}"/></td>
			</tr>
			<tr class="subTr subTr2">
				<th>State</th>
				<td><input type="text" class="text" id="state" name="state"  value="${resultMap.State}"/></td>
				<th>도시</th>
				<td><input type="text" class="text" id="city" name="city"  value="${resultMap.City}"/></td>
			</tr>
			<tr class="subTr subTr2">	
				<th>주소1</th>
				<td><input type="text" class="text" id="addr1" name="addr1"  value="${resultMap.Addr1}"/></td>
				<th>주소2</th>
				<td class="last"><input type="text" class="text" id="addr2" name="addr2"  value="${resultMap.Addr2}"/></td>
			</tr>
			<tr>
				<th>개요</th>
				<td colspan="3" style="height:180px;" class="tit last">
					<textarea id="customerDesc" name="customerDesc" rows="12" cols="50" style="width:100%; height: 98%;border:1px solid #fff;resize:none;" >${resultMap.CustomerDesc}</textarea>
				</td>
			</tr>
		</table>
		
		<div class="cmm_form_btn mgT10" id="saveGrp">
			<span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit" onclick="goBack()"></span>
			<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="newCustInsert('base')"  type="submit"></span>
			<c:if test="${viewType == 'N'}">
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save and add" onclick="newCustInsert('saveAdd')"  type="submit"></span>
			</c:if>
		</div>
	</div>	
			
	
	</div>
	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>		
</body>
</html>