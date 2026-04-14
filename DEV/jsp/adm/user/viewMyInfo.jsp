<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00106}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="Employee No"/>

<script>
$(document).ready(function(){
// 	var defaultAthority = "${getData.MLVL}";
// 	fnSelectNone('Authority','&Category=MLVL','getDicWord', defaultAthority);
	
    var alarmOption = "${getData.AlarmOption}";
    if (alarmOption == "0") {
        $("input[name='email_box']").prop("checked", true);
        $("input[name='msg_box']").prop("checked", true);
    } else if (alarmOption == "1") {
        $("input[name='email_box']").prop("checked", true);
    } else if (alarmOption == "2") {
        $("input[name='msg_box']").prop("checked", true);
    }
});

function reQuestUserAuth(){
	var url = "reqUserAuth.do"; 
	var data =  "&sysUserID=1";
	var target = "returnFrame";

	ajaxPage(url, data, target);
}

function saveAlarm(){
    var emailChecked = $("input[name='email_box']").is(":checked");
    var msgChecked = $("input[name='msg_box']").is(":checked");

    var option =  "";
    
    if (emailChecked && msgChecked) {
    	option =  "0";
    } else if (emailChecked) {
    	option =  "1";
    } else if (msgChecked) {
    	option =  "2";
    } else {
    	option =  "3";
    }
    
    var url = "zDaerim_updateAlarmOption.do"; 
	var data =  "memberID=${memberID}&alarmOption=" + option;
	var target = "actFrame";
 
	ajaxPage(url, data, target);

}


</script>

<style type="text/css">
    .alarm_div {
        display: inline-block;
    }	
</style>

<form name="userInfo" id="userInfo" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="MemberID" name="MemberID" value="${memberID}">
	<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="${getData.TeamID}" />
	<h3 class="mgT10 mgB12"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;${menu.LN00072}&nbsp;${menu.LN00108}</h3>
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
					<th  class="">${menu.LN00106}</th>
					<td  class=" alignL">${getData.LoginID}</td>				
					<!-- Name -->
					<th  class="">${menu.LN00028}</th>
					<td  class=" alignL">${getData.UserNAME}</td>
					<th  class="">English Name</th>
					<td  class=" alignL">${getData.EnName}</td>
					<th  class="">Employee No</th>
					<td  class=" last alignL">${getData.EmployeeNum}</td>				
									
				</tr>
				<tr>
					<!-- <th>${menu.LN00014}</th>
					<td>
					<select id="companyCode" name="companyCode" class="sel">
					</select>
					</td> -->
					<th>City</th>
					<td class="alignL">${getData.City}</td>
					<th>${menu.LN00104}</th>
					<td class="alignL">${getData.TeamName}</td>
					<th>Position</th>
					<td class="alignL">${getData.Position}</td>	
					<th>Authority</th>	
					<td class="last alignL">
						${getData.AuthorityNm}
<!-- 						<select id="Authority" name="Authority" style="width:80%"></select> -->
					</td>				
				</tr>
				
				<tr>
					<th>E-mail</th>
					<td class="alignL">${getData.Email}</td>	
					<th>Tel</th>
					<td class="alignL">${getData.TelNum}</td>	
					<th>Mobile</th>
					<td class="alignL">${getData.MTelNum}</td>								
				    <td class="alignR pdR20 last" colspan="2">
				    	<span class="btn_pack small icon"><span class="edit"></span><input value="Request Authorization" type="submit" onclick="reQuestUserAuth();"></span>
<!-- 				    	<span class="btn_pack medium icon"><span class="list"></span><input value="List" onclick="goBack()" type="submit"></span>&nbsp; -->
<!-- 				        <span class="btn_pack small icon"><span class="save"></span><input value="Save" type="submit" id="newButton"  onclick="editUser(0)"></span> -->
                     </td>
				 </tr>
				 <tr>
					<th>ALARM</th>
					<td class="alignL" colspan="6" name="alarm_td">
						<div class="alarm_div" style="margin-left:10px;margin-right: 30px;">
							<input type="checkbox" value="1" name="email_box"> Email
						</div>
						<div class="alarm_div" style="margin-right: 35px;">
							<input type="checkbox" value="2" name="msg_box"> Messenger
						</div>
						<div class="alarm_div">
							<span class="btn_pack small icon"><span class="save"></span><input value="Save" type="submit" onclick="saveAlarm();"></span>
						</div>
					</td>								
				    <td class="alignR pdR20 last" colspan="2">
					</td>				 
				 </tr>
			</table>

</form>
	<div id="transUserDiv"></div>
	<iframe name="returnFrame" id="returnFrame" src="about:blank" style="display:none" frameborder="0"></iframe>