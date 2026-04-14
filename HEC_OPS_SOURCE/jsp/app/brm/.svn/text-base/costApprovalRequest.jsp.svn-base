<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<head>
<title></title>
<script src="<c:url value='/cmm/js/tinymce_v4.3/tinymce.min.js'/>" type="text/javascript"></script>
<script type="text/javascript">
	var chkReadOnly = false;
</script>

 <!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00068" var="WM00068"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="금액"/>
 
<script type="text/javascript">

	$(document).ready(function(){		
		
		fnSelect('condition','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&ruleId=${ruleId}','getRulePathConditionList','${condition}','Select',"brm_SQL","");
		
		document.getElementById('decideApproveInfoDiv').style.height = (setWindowHeight() - 100)+"px";			
		window.onresize = function() {
			document.getElementById('decideApproveInfo').style.height = (setWindowHeight() - 100)+"px";	
		};
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	

	function returnSaveObj(){location.reload();}
	function searchPopup(url){	window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');}
	
	// [save] 이벤트 후 처리
	function goBack() {
		var url = "costApprovalRequest.do";
		var target = "actFrame";
		var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}"; 
	 	ajaxPage(url, data, target);
	}
	function decideApproveInfoMain() {
		if(confirm("${CM00001}")){
			if($("#ruleId").val() == ''){
				alert("${WM00068}");
				return false;
			}else if($("#Cost").val() == ''){
				alert("${WM00034}");
				return false;
			}
			var url = "decideApprovPath.do";			
			ajaxSubmit(document.decideApprovePathFrm, url);
		}
	}
	
	//[Back] Click
	function selfClose() {
		goBack();
	}
	 function inNumber(){
		if(event.keyCode<48 || event.keyCode>57){
	    	event.returnValue=false;
	 	}
	 }
</script>

</head>

<form name="decideApprovePathFrm" id="decideApprovePathFrm" action="decideApprovePath.do" method="post" onsubmit="return false;">
<div class="child_search mgB10">
	<li class="floatR pdR20">
	   <span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="decideApproveInfoMain()" type="submit"></span>
	   <span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="goBack()" type="submit"></span>
	 </li>
</div>
<div id="decideApproveInfoDiv" class="hidden" style="width:100%;overflow:auto;margin-bottom:5px;overflow-x:hidden;">
		
		<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />		
		<input type="hidden" id="UserNM" name="UserNM" value="${sessionScope.loginInfo.sessionUserNm}" />		
		<input type="hidden" id="TeamId" name="TeamId" value="${sessionScope.loginInfo.sessionTeamId}" />			
		<input type="hidden" id="TeamName" name="TeamName" value="${sessionScope.loginInfo.sessionTeamName}" />			
		<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
		<input type="hidden" id="ruleId" name="ruleId" value="${ruleId}" />
			
		<input type="hidden" id="function" name="function" value="decideApproveInfoMain">
		<table style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview">	
			<colgroup>
				<col width="30%">
				<col width="20%">
				<col width="20%">
				<col width="30%">	
			</colgroup>
			<tr>
				<!-- 비용계정 -->
				<th class="viewtop">비용계정</th>
				<td class="viewtop pdL5 pdR5"><select name="condition" id="condition">
							<option value="cgffd">식대</option>
							<option value="rcpxpns">접대비</option>
						</select>
				</td>
				<!-- 금액 -->
				<th class="viewtop">금액</th>
				
				<td class="viewtop pdL5 pdR5"><input type="text" class="text" id="Cost" name="Cost" onkeypress="inNumber();"/></td>
			</tr>		
			<tr>				
			<tr>
			  <td colspan="6" class="hr1">&nbsp;</td>
			 </tr>	
		</table>
</div>	
</form>	
