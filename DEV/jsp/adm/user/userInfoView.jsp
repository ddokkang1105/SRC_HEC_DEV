<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 관리자 : 사용자/그릅 관리  -->
<!-- 
	@RequestMapping(value="/userInfoView.do")
	* user_SQL.xml - selectUser
	* Action
	  - Update(Add) :: saveUser.do
 -->
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00106}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="Employee No"/>

<script>
var menuIndex = "1 2 3 4 5 6 7";
var SubinfoTabsNum = 1; /* 처음 선택된 tab메뉴 ID값*/
$(document).ready(function(){
// 	doDetail();
	setpmFrame('UserGroup','','1');
	//var defaultCompany = "${getData.CompanyID}";
	var defaultAthority = "${getData.MLVL}";
// 	fnSelectNone('Authority','&Category=MLVL','getDicWord', defaultAthority);
	//fnSelect('companyCode', '', 'getCompany', defaultCompany, '','');
	$('.UnderSubinfoTabs ul li').mouseover(function(){
		$(this).addClass('on');
	}).mouseout(function(){
		if($(this).attr('id').replace('pliug', '') != SubinfoTabsNum) {
			$(this).removeClass('on');
		}
		$('#tempDiv').html('SubinfoTabsNum : ' + SubinfoTabsNum);
	}).click(function(){
		SubinfoTabsNum = $(this).attr('id').replace('pliug', '');
	});
});

function editUser(avg){
	// [LoginID] 필수 체크
	if($("#loginID").val() == ""){
		alert("${WM00034_1}");
		$("#loginID").focus();
		return;
	}
	// [Name] 필수 체크
	if($("#userName").val() == ""){
		alert("${WM00034_2}");
		$("#userName").focus();
		return false;
	}
	// [사번] 필수 체크
	if($("#EmployeeNum").val() == ""){
		alert("${WM00034_3}");
		$("#EmployeeNum").focus();
		return false;
	}
	if(!confirm("${CM00001}")){ return;}
	var url    = "admin/saveUser.do"; // 요청이 날라가는 주소
	var data   = "MemberID=${memberID}"
				+"&loginID=${sessionScope.loginInfo.sessionAuthId}"	
				+"&LoginID="+$("#loginID").val()
				+"&Name="+$("#userName").val()
				+"&NameEn="+$("#enName").val()
				+"&City="+$("#City").val()
				+"&EmployeeNum="+$("#EmployeeNum").val()
				+"&Email="+$("#Email").val()
				+"&MTelNum="+$("#MTelNum").val()
				+"&TelNum="+$("#TelNum").val()
				+"&TeamID="+$("#ownerTeamCode").val()
				+"&Position="+$("#Position").val();
// 				+"&Authority="+$("#Authority").val(); //파라미터들
	if (avg == 1) {
		data = data+"&kbn=pwreset";
	}
	var target = "blankFrame";
	ajaxPage(url, data, target);	
}

function doDetail(){	
	var url    = "subMenu.do"; // 요청이 날라가는 주소
	var data   = "url=userMenu&languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${memberID}&currPage=${currPage}"; //파라미터들
	var target = "transUserDiv";
	ajaxPage(url, data, target);	
	//setSubDiv('OrganizationInfo');
}

function reload(memberId){
	var url    = "userInfoView.do"; // 요청이 날라가는 주소
	var data   = "currPage=${currPage}&languageID=${sessionScope.loginInfo.sessionCurrLangType}" + "&memberID="+memberId;
	var target = "userList";
	ajaxPage(url,data,target);
}

function goBack() {
	var url    = "UserList.do"; // 요청이 날라가는 주소
	var data   = "currPage=${currPage}&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&clientID=${clientID}&companyID=${companyID}&teamID=${teamID}&searchKey=${searchKey}&searchValue=${searchValue}&active=${active}"; 
	var target = "userList";
	ajaxPage(url,data,target);
}

function searchPopup(url){window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');}
function setSearchTeam(teamID,teamName){$('#ownerTeamCode').val(teamID);$('#teamName').val(teamName);}
function setpmFrame(avg,oj, avg2){
	var url = avg+".do";
	var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+"&memberID=${memberID}"
			+"&userType=1"
			+"&width="+ugFrame.offsetWidth
			+"&option=${option}"
			+"&getAuth=${sessionScope.loginInfo.sessionLogintype}"
			+"&currPage=${currPage}"
			+"&authorID=${memberID}";
	var target="ugFrame";

	ajaxPage(url,data,target);
	//alert(22);
	var realMenuIndex = menuIndex.split(' ');
	
	for(var i = 0 ; i < realMenuIndex.length; i++){
		if(realMenuIndex[i] == avg2){
			$("#pliug"+realMenuIndex[i]).addClass("on");
		}else{
			$("#pliug"+realMenuIndex[i]).removeClass("on");
		}
	}
}

function fnSetIsDefault(templCode, memberID, isDefault){		
	var url = "setAccessRightIsDefault.do";
	var data = "templCode="+templCode+"&memberID="+memberID+"&isDefault="+isDefault;
	var target = "ugFrame"; 
	
	ajaxPage(url,data,target);
}

function fnCallBack(){
	setpmFrame('userAccessRight','','2');
}
</script>
<!-- 
${getData}
 -->
	<!-- BEGIN :: USER_INFO_FORM -->
	<form name="userInfo" id="userInfo" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="MemberID" name="MemberID" value="${memberID}">
	<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="${getData.TeamID}" />
	<div class="msg"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;${menu.LN00072}&nbsp;${menu.LN00108}</div>
			<table class="tbl_blue01 mgT10" width="100%" border="0" cellpadding="0" cellspacing="0">
				<colgroup>
					<col width="9%">
					<col width="16%">
					<col width="9%">
					<col width="16%">
					<col width="9%">
					<col width="16%">
					<col width="9%">
					<col>
				</colgroup>
				<tr>
					<!-- ID -->
					<th  class="viewtop">${menu.LN00106}</th>
					<td  class="viewtop"><input type="text" class="text" id="loginID" name="loginID"  value="${getData.LoginID}" maxlength="50"/></td>				
					<!-- Name -->
					<th  class="viewtop">${menu.LN00028}</th>
					<td  class="viewtop"><input type="text" class="text" id="userName" name="userName"  value="${getData.UserNAME}"/></td>
					<th  class="viewtop">English Name</th>
					<td  class="viewtop"><input type="text" class="text" id="enName" name="enName"  value="${getData.EnName}"/></td>
					<th  class="viewtop">Employee No</th>
					<td  class="viewtop last"><input type="text" class="text" id="EmployeeNum" name="EmployeeNum"  value="${getData.EmployeeNum}" maxlength="40"/></td>				
									
				</tr>
				<tr>
					<!-- <th>${menu.LN00014}</th>
					<td>
					<select id="companyCode" name="companyCode" class="sel">
					</select>
					</td> -->
					<th>City</th>
					<td><input type="text" class="text" id="City" name="City"  value="${getData.City}"/></td>
					<th>${menu.LN00104}</th>
					<td><input type="text"class="text" id="teamName" name="teamName" readonly="readonly" onclick="searchPopup('searchTeamPop.do?teamTypeYN=${teamTypeYN}')" value="${getData.TeamName}" /></td>
					<th>Position</th>
					<td><input type="text" class="text" id="Position" name="Position"  value="${getData.Position}"/></td>	
					<th>Authority</th>	
					<td class="alignL pdR20 last">${getData.AuthorityNm }
<!-- 						<select id="Authority" name="Authority" style="width:80%"></select> -->
					</td>				
				</tr>
				
				<tr>
					<th>E-mail</th>
					<td><input type="text"class="text" id="Email" name="Email"  value="${getData.Email}" maxlength="100"/></td>	
					<th>Tel</th>
					<td><input type="text" class="text" id="TelNum" name="TelNum"  value="${getData.TelNum}"/></td>	
					<th>Mobile</th>
					<td><input type="text" class="text" id="MTelNum" name="MTelNum"  value="${getData.MTelNum}"/></td>								
				    <td class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="6">
				    	<span class="btn_pack small icon"><span class="edit"></span><input value="Password Reset" type="submit" onclick="editUser(1);"></span>
				    	<span class="btn_pack medium icon"><span class="list"></span><input value="List" onclick="goBack()" type="submit"></span>&nbsp;
				        <span class="btn_pack small icon"><span class="save"></span><input value="Save" type="submit" id="newButton"  onclick="editUser(0)">
                        </span>
                     </td>
				 </tr>
			</table>

</form>
<input type="hidden" id="currPage" name="currPage" value="${currPage}">
<div class="SubinfoTabs">
	<ul>
<!-- 
	1. jsp/adm/user/sub/UserGroup
	2. jsp/adm/userProject/sub/userGroupAccessRight
 -->
		<li id="pliug1" class="on"><a href="javascript:setpmFrame('UserGroup','','1');"><span>User Group</span> </a></li>
<!-- 
		<li id="pliug2"><a href="javascript:setpmFrame('userAdminOrganization','','2');"><span>Organization</span></a></li>		
 -->		
		<li id="pliug2"><a href="javascript:setpmFrame('userAccessRight','','2');"><span>Access Right</span></a></li>
		<li id="pliug3"><a href="javascript:setpmFrame('userProject','','3');"><span>${menu.LN00131}</span></a></li>
		<li id="pliug4"><a href="javascript:setpmFrame('ownerItemList','','4');"><span>${menu.LN00190}</span></a></li>		
		<li id="pliug5"><a href="javascript:setpmFrame('myChangeSet','','5');"><span>${menu.LN00082}</span></a></li>		
		<li id="pliug6"><a href="javascript:setpmFrame('userDimList','','6');"><span>${menu.LN00088}</span></a></li>		
		<li id="pliug7"><a href="javascript:setpmFrame('myRoleList','','7');"><span>${menu.LN00119}</span></a></li>		
	</ul>
</div>
<div id="ugFrame"></div>
<!-- 
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>		
 -->	