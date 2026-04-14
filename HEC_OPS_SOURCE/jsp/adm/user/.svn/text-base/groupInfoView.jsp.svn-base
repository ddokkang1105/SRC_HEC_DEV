<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 관리자 : 사용자/그릅 관리  -->
<!-- 
	@RequestMapping(value="/groupInfoView.do")
	* user_SQL.xml - selectUser
	* Action
	  - Update   :: editUserGroup.do
	  - SubTap   :: userGroupMenu
 -->
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00005" var="CM00005"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="${menu.LN00106}"/>

 <script>
$(document).ready(function(){
	doDetail();

	fnSelectNone('Authority','&Category=MLVL','dictionyCode', '${getData.MLVL}');
	fnSelect('companyID', '', 'getCompany', '${getData.CompanyID}', '','');
});
function editGroup(){	
	// [LoginID] 필수 체크
	if($("#UserID").val() == ""){
		alert("${WM00034}");
		$("#UserID").focus();
		return;
	}	
	if(confirm("${CM00005}")){	
		var url = "memberUpdate.do";
		var data = "s_itemID=${s_itemID}&MemberID=${s_itemID}&type=update"
					+"&loginID="+$("#UserID").val()
					+"&Name="+$("#Name").val()
					+"&Email="+$("#Email").val()
					+"&companyID="+$("#companyID").val()
					+"&Authority="+$("#Authority").val();
		var target = "blankFrame";
		//alert(data);
		ajaxPage(url, data, target);
	}
}
function doDetail(){	
	var url    = "subMenu.do"; // 요청이 날라가는 주소
	var data   = "url=userGroupMenu&languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${s_itemID}&currPage=${currPage}"; //파라미터들
	var target = "transDiv";
	ajaxPage(url, data, target);	
	//setSubDiv('OrganizationInfo');
}

function reload(memberId){
	var url    = "groupInfoView.do"; // 요청이 날라가는 주소
	var data   = "currPage=${currPage}&languageID=${sessionScope.loginInfo.sessionCurrLangType}"+"&s_itemID="+memberId; //파라미터들
	var target = "groupList";
	ajaxPage(url,data,target);
}

function goBack() {
	var url    = "UserGroupList.do"; // 요청이 날라가는 주소
	var data   = "currPage=${currPage}&languageID=${sessionScope.loginInfo.sessionCurrLangType}"; //파라미터들
	var target = "groupList";
	ajaxPage(url,data,target);
}

function searchPopup(url){	window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');}
function setSearchTeam(teamID,teamName){$('#ownerTeamCode').val(teamID);$('#teamName').val(teamName);}
</script>
<div id="groupListDiv" class="hidden" style="width:100%;height:100%;">
	<form name="groupList" id="groupList" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="${getData.OwnerTeamID}" />			
	<input type="hidden" id="option" name="option" value="${option}">
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
	<div class="msg"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;${menu.LN00098}&nbsp;${menu.LN00108}</div>
	
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
					<td  class="viewtop"><input type="text" class="text" id="UserID" name="UserID"  value="${getData.LoginID}"/></td>
					<th  class="viewtop">Name</th>
					<td  class="viewtop"><input type="text" class="text" id="Name" name="Name"  value="${getData.UserNAME}"/></td>
					<th  class="viewtop">E-mail</th>
					<td  class="viewtop"><input type="text"class="text" id="Email" name="Email"  value="${getData.Email}"/></td>				
					<th  class="viewtop">Authority</th>
					<td  class="viewtop">
						<select id="Authority" name="Authority"></select>
					</td>
					<th  class="viewtop">${menu.LN00014}</th>
					<td  class="viewtop">
						<select id="companyID" name="companyID" style="width:120px"></select>
					</td>
				</tr>
			</table>		
<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
		<div  class="alignBTN" id="saveOrg">
			<span class="btn_pack medium icon"><span class="list"></span><input value="List" onclick="goBack()" type="submit"></span>&nbsp;
			<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="editGroup()"  type="submit"></span>
		</div>
</c:if>		
	</form>	
	<div id="transDiv"></div>
</div>

