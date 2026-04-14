<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00106}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="Employee No"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
$(document).ready(function(){	
	
	// alarmOption
	var alarmOption = "${getData.AlarmOption}";
    if (alarmOption.trim() === "0") {
        $("input[name='email_box']").prop("checked", true);
        $("input[name='msg_box']").prop("checked", true);
    } else if (alarmOption.trim() === "1") {
        $("input[name='email_box']").prop("checked", true);
    }
	
	fnSelect('USER_TIME_ZONE', '', 'timeZone', '${getData.TimeZone}', 'Select');
});

function saveAlarm(){
    var emailChecked = $("input[name='email_box']").is(":checked");
    var msgChecked = $("input[name='msg_box']").is(":checked");

    var option =  "";
    
    if (emailChecked) {
    	option =  "0";
    } else {
    	option =  "3";
    }
    
    var url = "zDaerim_updateAlarmOption.do"; 
	var data =  "memberID=${memberID}&alarmOption=" + option;
	var target = "actFrame";
 
	ajaxPage(url, data, target);

}

// change timezone
function changeTimeZone(selectedValue) {
	if(confirm("${CM00001}")) {
// 		ajaxSubmitNoAdd(document.userInfo, "timeZoneSetting.do?timeZone=" + selectedValue, "blankFrame");
		ajaxPage("admin/saveUser.do", "MemberID=${sessionScope.loginInfo.sessionUserId}&timeZone="+selectedValue, "returnFrame");
	}
}

// callback - changeTimeZone
function reload(){
	
}

</script>

<style>
	table{background:#fff;}
	
	.alarm_div {
        float:left;
    }	
</style>


<div id="userDiv" class="pdL10 pdR10">
	
	<form name="userInfo" id="userInfo" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="MemberID" name="MemberID" value="${memberID}">
		<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="${getData.TeamID}" />
		<div class="page-title">${menu.LN00072}&nbsp;${menu.LN00108}</div>
		<table class="tbl_blue01 mgT10" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="8%">
				<col width="12%">
				<col width="8%">
				<col width="12%">
				<col width="8%">
				<col width="12%">
				<col width="8%">
				<col width="12%">
			</colgroup>
			<tr>
				<!-- ID -->
				<th>${menu.LN00106}</th>
				<td  class=" alignL">${getData.LoginID}</td>				
				<!-- Name -->
				<th>${menu.ZLN0199}</th>
				<td  class=" alignL">${empty getData.EnName ? getData.UserNAME : getData.EnName}</td>
				<th>${menu.ZLN0072}</th>
				<td  class=" alignL">${getData.UserNAME}</td>
				<th>${menu.LN00148}</th>
				<td  class=" last alignL">${getData.EmployeeNum}</td>				
								
			</tr>
			<tr>
				<th>${menu.ZLN0073}</th>
				<td class="alignL">${getData.City}</td>
				<th>${menu.LN00104}</th>
				<td class="alignL">${getData.TeamName}</td>
				<th>${menu.ZLN0074}</th>
				<td class="alignL">${getData.Position}</td>	
				<th>${menu.LN00149}</th>	
				<td class="last alignL">
					${getData.AuthorityNm}
				</td>				
			</tr>
			
			<tr>
				<th>${menu.ZLN0054}</th>
				<td class="alignL">${getData.Email}</td>	
				<th>${menu.ZLN0055}</th>
				<td class="alignL">${getData.TelNum}</td>	
				<th>${menu.ZLN0056}</th>
				<td class="alignL">${getData.MTelNum}</td>								
			    <td class="alignR pdR20 last" colspan="2">
			    	<!-- <span class="btn_pack small icon"><span class="edit"></span><input value="Request Authorization" type="submit" onclick="reQuestUserAuth();"></span> -->
                    </td>
			 </tr>
			 <tr>
			 	<th>Time zone</th>
			 	<td class="alignL" colspan="8">
			 		<select name="USER_TIME_ZONE" id="USER_TIME_ZONE" onchange="changeTimeZone(this.value)"></select>
			 	</td>
			 </tr>
			 <tr>
				<th>${menu.ZLN0075}</th>
				<td class="alignL" colspan="6" name="alarm_td">
					<div class="alarm_div" style="margin-left:10px;margin-right: 30px;">
						<input type="checkbox" value="1" name="email_box" id="email_box" /> <label for="email_box">${menu.ZLN0054}</label>
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
</div>
