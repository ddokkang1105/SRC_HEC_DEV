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
<!-- 관리자 : 사용자/그릅 관리  -->
<!-- 
	사용 안함
	@RequestMapping(value="/groupInfoView.do")
	* user_SQL.xml - selectUser
	* Action
	  - Update(Add) :: memberUpdate.do
 -->
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="${menu.LN00106}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
 
<script>

var p_gridArea;				//그리드 전역변수
var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용

$(document).ready(function(){
	fnSelect('Authority','&Category=MLVL','getDicWord', 'VIEWER','','');
	fnSelect('companyID','', 'getCompany', '', '','');
});

//===============================================================================
// BEGIN ::: GRID

function newGroupInsert(){
	
	if($("#loginID").val() == ""){
		//alert("ID를 입력하십시요.");
		alert("${WM00034}");
		return;
	}
	
	//if(confirm("신규 정보를 생성 하시겠습니까?")){
	if(confirm("${CM00009}")){
		
		var url = "admin/memberUpdate.do";
		var data = "regID=${sessionScope.loginInfo.sessionUserId}&UserType=2&type=insert"
					+"&companyID="+$("#companyID").val()
					+"&Name="+$("#Name").val()
					+"&loginID="+$("#UserID").val()
					+"&Email="+$("#Email").val()
					+"&Authority="+$("#Authority").val();
		var target = "blankFrame";
		
		
		$("#Name").val("");
		$("#Email").val("");
		$("#companyID").val("");
		$("#Authority").val("");
		
		ajaxPage(url, data, target);
		
//		doSearchList();
//		parent.top.fnSearchTreeId('${s_itemID}');

	}
}
/*
function searchPopup(url){	window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');}
function setSearchTeam(teamID,teamName){$('#ownerTeamCode').val(teamID);$('#teamName').val(teamName);}
 */
</script>

</head>

<body>

	<!-- BEGIN :: BOARD_ADMIN_FORM -->
	<form name="groupList" id="groupList" action="#" method="post" onsubmit="return false;">
	<div id="groupListDiv" class="hidden" style="width:100%;height:100%;">
	<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="" />
	<div id="groupInfoDiv" class="hidden" style="width:100%;height:400px;">
		<table class="tbl_blue01 mgT5" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="7%">
				<col width="13%">
				<col width="7%">
				<col width="13%">
				<col width="7%">
				<col width="13%">
				<col width="7%">
				<col width="13%">
				<col width="7%">
				<col>
			</colgroup>
			<tr>
				<th  class="viewtop">ID</th>
				<td  class="viewtop"><input type="text" class="text" id="UserID" name="UserID"  value="${getData.UserID}"/></td>
				<th  class="viewtop">${menu.LN00028}</th>
				<td  class="viewtop"><input type="text" class="text" id="Name" name="Name"  value="${getData.UserNAME}"/></td>
				<th  class="viewtop">E-mail</th>
				<td  class="viewtop"><input type="text"class="text" id="Email" name="Email"  value="${getData.Email}"/></td>				
				<th  class="viewtop">${menu.LN00014}</th>
				<td  class="viewtop">
					<select id="companyID" name="companyID"></select>
				</td>
				<th  class="viewtop">Authority</th>
				<td  class="viewtop">
					<select id="Authority" name="Authority"></select>
				</td>
			</tr>			
		</table>
	<div class="alignBTN" id="saveGrp">
		<span class="btn_pack medium icon">
			<span  class="save"></span>
			<input value="Save" onclick="newGroupInsert()"  type="submit">
		</span>
	</div>
	</div>	
			
	
	</div>
	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>		
</body>
</html>