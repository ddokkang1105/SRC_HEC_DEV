<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<c:url value="/" var="root"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00016}"/>
 
<script type="text/javascript">
$(document).ready(function(){
});

function searchPopup(url){window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');}
function setSearchName(memberID,memberName){$('#AuthorSID').val(memberID);$('#AuthorName').val(memberName);}
function setSearchTeam(teamID,teamName){$('#ownerTeamID').val(teamID);$('#teamName').val(teamName);}


//[save] 이벤트
function newItemInsert() {
	if($("#newItemName").val() == ""){alert("${WM00034_1}");$("#newItemName").focus();return false;}
	if($("#newClassCode").val() == ""){alert("${WM00034_2}");$("#newClassCode").focus();return false;}
	
	//if(confirm("신규 정보를 생성 하시겠습니까?")){		
	if(confirm("${CM00009}")){		
		var url = "newItemInsertAndAssign.do";
		var data = "s_itemID=${s_itemID}&option=${option}"
					+"&CNItemTypeCode=${CNItemTypeCode}&isFromItem=${isFromItem}"
					+"&newClassCode="+$("#newClassCode").val()
					+"&newIdentifier="+$("#newIdentifier").val()
					+"&OwnerTeamId="+$("#ownerTeamID").val()
					+"&AuthorID="+$("#AuthorSID").val()
					+"&newItemName="+$("#newItemName").val();
		var target = "blankFrame";		
		ajaxPage(url, data, target);
	}
}

// 처리가 끝나고 팝업창 닫고 부모창 리로드
function selfClose(){
	var opener = window.dialogArguments;
	opener.urlReload();
	self.close();
}

</script>

<form name="OAIPFrm" id="OAIPFrm" action="" method="post" onsubmit="return false;">
	
	<input type="hidden" id="ownerTeamID" name="ownerTeamID" value="${sessionScope.loginInfo.sessionTeamId}">	
	<input type="hidden" id="AuthorSID" name="AuthorSID" value="${sessionScope.loginInfo.sessionUserId}">	
	
	
<div id="objectInfoDiv" class="hidden" style="width:100%;height:300px;">
	
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00096}</p>
	</div>
	
	<table id="addNewItem" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" >
		<colgroup>
			<col width="20%">
			<col>
		</colgroup>
		<tr>
			<th>Code</th>
			<td><input type="text" class="text" id="newIdentifier" name="newIdentifier"  value=""/></td>
		</tr>	
		<tr>
			<th>${menu.LN00028}</th>
			<td><input type="text" class="text" id="newItemName" name="newItemName"  value=""/></td>
		</tr>
		<tr>
			<th>${menu.LN00016}</th>
			<td>
				<select id="newClassCode" name="newClassCode" class="sel">
				<option value=""></option>
				<c:forEach var="i" items="${classOption}">
					<option value="${i.ItemClassCode}"  >${i.Name}</option>						
				</c:forEach>				
				</select>
			</td>
		</tr>
		
		<tr>
			<th>${menu.LN00018}</th>
			<td><input type="text"class="text" id="teamName" name="teamName" readonly="readonly" onclick="searchPopup('searchTeamPop.do');" value="${sessionScope.loginInfo.sessionTeamName}" /></td>
		</tr>
		<tr>
			<th>${menu.LN00060}</th>
			<td><input type="text"class="text" id="AuthorName" name="AuthorName" readonly="readonly" onclick="searchPopup('searchNamePop.do');" value="${sessionScope.loginInfo.sessionUserNm}" /></td>
		</tr>
	</table>
	
	<div class="alignBTN" >
		&nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="newItemInsert();" type="submit"></span>
	</div>
	
</div>	
</form>

<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>