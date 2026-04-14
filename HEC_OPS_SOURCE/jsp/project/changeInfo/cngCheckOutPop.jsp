<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00043" var="CM00043"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="${menu.LN00191}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>
<title>${menu.LN00331}</title>
</head>

<body>
<script type="text/javascript">
	var SRID = "${srID}";
	var checkType = "${checkType}";
	
	$(document).ready(function(){	
		$('.sem001').click(function(){
			$('.sem001').css('background-color', '#ffffff');
			$('.sem001').attr('alt', '');
			$(this).css('background-color', '#eafafc');
			$(this).attr('alt', '1');
		}).mouseover(function(){
			$(this).css('background-color', '#eafafc');
		}).mouseout(function(){
			if($(this).attr('alt') != 1) 
				$(this).css('background-color', '#ffffff');
		});

		var CSRID = "${CSRID}";
		
		if(SRID != "" && CSRID != "" && checkType == "OUT") {
			opener.selectCheckOutItem(CSRID);
			self.close();
		}
		else if(SRID == "" && CSRID != "" && checkType == "OUT"){
			var url = "checkOutItem.do";		
			var data = "projectId="+CSRID+"&itemIds=${s_itemID}";
			var target="blankFrame";			
			ajaxPage(url, data, target);
		}
		else if(SRID != "" && CSRID != "" && checkType == "COMMIT") {
			opener.fnCommitItem(CSRID);
			self.close();
		}
		else if(SRID == "" && CSRID != "" && checkType == "COMMIT"){
			var url = "openCommitCommentPop.do";		
			var data = "pjtIds="+CSRID+"&items=${s_itemID}+&srID=${srID}";
			var target="objectInfoDiv";			
			ajaxPage(url, data, target);
		}
	});

	// 처리가 끝나고 팝업창 닫고 부모창 리로드
	function thisReload(){
		var itemMenu = opener.$("#itemMenu").val();
		dhtmlx.alert("${WM00067}", function(){
			if(itemMenu == 'itemInfoMemu'){
				opener.fnItemInfoMenuReload();
			}else{
				opener.fnItemMenuReload();
			}
			self.close();
		});
	}
	
	function fnChangeCSR(csr){	
		if (csr == "NEWCSR") {
			var opener = window.dialogArguments;
			window.opener.fnRegNewCSR();
			self.close();
			event.returnValue = false;
		}
	}
	
	function fnClickCSR(projectID){
		if (projectID == "") {
			dhtmlx.alert("${WM00025}");
			return;
		}
		
		fnCheckType(projectID);
		
		
	}
	
	function fnCheckType(projectID) {
		if(checkType == "OUT") {
			exeCheckOut(projectID);
		}
		else if (checkType == "COMMIT"){
			exeCommit(projectID);
		}
	}
	
	function exeCheckOut(projectID) {
		if(SRID != "") {
			opener.selectCheckOutItem(projectID);
			self.close();
		}
		else {
		
			dhtmlx.confirm("${CM00001}", function(btn){
				if(btn){
					var url = "checkOutItem.do";		
					var data = "projectId="+projectID+"&itemIds=${s_itemID}&srID=${srID}"; 
					var target="blankFrame";			
					ajaxPage(url, data, target);
				}else{
					return false;
				}
			});
		}
	}
	
	function exeCommit(projectID) {
		if(SRID != "") {
			opener.fnCommitItem(projectID);
			self.close();
		}
		else {
		
			dhtmlx.confirm("${CM00001}", function(btn){
				if(btn){
					var url = "openCommitCommentPop.do";		
					var data = "pjtIds="+projectID+"&items=${s_itemID}&srID=${srID}"; 
					var target = "objectInfoDiv";			
					ajaxPage(url, data, target);
				}else{
					return false;
				}
			});
		}
	}
	
	function fnReload() {
		thisReload();
	}

</script>
<form name="OAIPFrm" id="OAIPFrm" action="" method="post" onsubmit="return false;">
	
<div id="objectInfoDiv" class="hidden" style="width:98%; height:320px; overflow-y:scroll;">
	<ul id="breadcrumb">
        <li><span>${menu.LN00191}</span></li>
    </ul>
	<div id="selAttr" style="overflow:auto;overflow-x:hidden;">			
		<table class="tbl_blue01 mgT5" width="90%" cellpadding="0" cellspacing="0" border="0">
	        <tr>
	            <th class="viewtop">CSR No.</th>
	            <th class="viewtop">${menu.LN00191}</th>
	        </tr>
			<c:forEach var="i" items="${projectNameList}" varStatus="listStatus">
            <tr class="sem001">
            	<input type="hidden" id="projectID" name="projectID" value="" >
                <td onclick="fnClickCSR('${i.ProjectID}')">${i.ProjectCode}</td>
                <td class="tit" onclick="fnClickCSR('${i.ProjectID}')">${i.PJTFullName}</td>
            </tr>
			</c:forEach>
	     </table>
	</div>	
</div>	
</form>
<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>
</body>
</html>