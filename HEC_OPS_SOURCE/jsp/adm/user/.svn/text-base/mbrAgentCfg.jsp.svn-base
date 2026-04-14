<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00014" var="WM00014" arguments="${menu.LN00233}" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="대무자"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00233}"/>

<style>
	.settings{
		display:none;
	}
</style>
<script>
	$(document).ready(function(){
		$("input.datePicker").each(generateDatePicker);
		
		var active = "${mbrAgent.Active}";
		var status = "";
		if(active == '0'){
			status = "1";
			$("#agentName").val("${mbrAgent.Name}");
			$("#dueDate").val("${mbrAgent.DueDate}");
		} else {
			status = "0";
		}
		fnSettings(status);
		$("#status").val(status).attr("selected", "selected");
	});

	function searchPopup(url){	window.open(url,'window','width=400, height=330, left=300, top=300,scrollbar=yes,resizble=0');}
	function setSearchName(memberID,memberName){$('#agentID').val(memberID);$('#agentName').val(memberName);}
	
	function fnSettings(val){
		if(val == '0'){
			$(".settings").css("display","none");
			$("#agentID").val("");
			$("#dueDate").val("");
		} else {
			$(".settings").css("display","table-row");
		}
	}
	
	function fnSave(){
		var status = $("#status").val();
		var agentName = $("#agentName").val();
		var currDate = "${thisYmd}";
		var dueDate = $("#dueDate").val().replaceAll("-","");
		
		if(status == '1'){
			if(agentName == null || agentName == ""){
				alert("${WM00034_1}"); return;
			}
			if(dueDate == null || dueDate == ""){
				alert("${WM00034_2}"); return;
			} else{
				if(parseInt(dueDate) <= parseInt(currDate) ){ 	
					alert("${WM00014}");
					return;
				}
			}
		}
		if(!confirm("${CM00001}")){ return;}
		
		var url  = "saveMbrAgent.do";
		ajaxSubmit(document.mbrAgentFrm, url,"saveFrame");
	}
	
	function reload(){
		var url    = "mbrAgentCfg.do"; // 요청이 날라가는 주소
		var data   = "";
		var target = "help_content";
		ajaxPage(url,data,target);
	}
</script>

<form name="mbrAgentFrm" id="mbrAgentFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="seq" name="seq" value="${mbrAgent.Seq}" />
	<input type="hidden" id="agentID" name="agentID" value="${mbrAgent.AgentID}" />
	<h3 class="mgT10 mgB12" style="width:100%"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;&nbsp;Out-of-office setting</span></h3>
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_blue01">
		<colgroup>
		    <col width="10%">
		    <col width="90%">
    	</colgroup>
    	<tr>
    		<th>Status</th>
    		<td class="alignL last pdL10">
    			<select id="status" name="status" style="width:152px; height:26px;" onchange="fnSettings(this.value)">
					<option value="0">Working</option>
					<option value="1">out of office </option>
				</select>
    		</td>
    	</tr>
    	<tr class="settings">
    		<th>대무자</th>
    		<td class="alignL pdL10"><input type="text" class="text pdL5" id="agentName" name="agentName" readonly="readonly" onclick="searchPopup('searchNamePop.do')" value="${getList.Name}" style="width:145px"></td>
    	</tr>
    	<tr class="settings">
    		<th>${menu.LN00233}</th>
    		<td class="alignL pdL10">
    			<font><input type="text" id="dueDate" name="dueDate" class="text datePicker stext pdL5" size="10"
					style="width: 145px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				</font>
    		</td>
    	</tr>
	</table>
	<div id="btnSave" class="alignBTN" >
		<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnSave()" type="submit"></span>
		</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>