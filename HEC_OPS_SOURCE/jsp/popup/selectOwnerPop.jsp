<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<c:url value="/" var="root"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00043" var="CM00043"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
 
<script type="text/javascript">
$(document).ready(function(){
	$("#Author").attr("checked",true);
	editCheckedAllItems();
});

function searchPopup(url){	window.open(url,'window','width=400, height=330, left=300, top=300,scrollbar=yes,resizble=0');}
function setSearchName(memberID,memberName){$('#AuthorID').val(memberID);$('#AuthorName').val(memberName);}
function setSearchTeam(teamID,teamName){$('#ownerTeamCode').val(teamID);$('#teamName').val(teamName);}

// [edit] 이벤트
function editCheckedAllItems(){
	var count = getCheckedItem();
	if (count == 0) {
		alert("${WM00023}");
		$("#AllEdit").attr("style", "display:none");
		$("#AllEdit").addClass(".help_hidden");
		return;
	} 
	if ($("input:checkbox[id='OwnerTeam']").is(":checked") == true ||  $("input:checkbox[id='Company']").is(":checked") == true) {
		$("#transfer").attr("checked",false);
		$("input:checkbox[id='transfer']").attr("disabled",true);
	} else {
		$("input:checkbox[id='transfer']").removeAttr("disabled");
	}
	openEditArea();
}

//[save] 이벤트
function saveOwnerInfo() {
	if(confirm("${CM00001}")){
		var url = "saveOwnerInfo.do";	
		ajaxSubmit(document.OAIPFrm, url, "saveFrame");
	}
}

// 체크된 항목 취득
function getCheckedItem() {
	var count = 0;
	if ($("input:checkbox[id='Author']").is(":checked") == true) {
		count++;
	}
	if ($("input:checkbox[id='OwnerTeam']").is(":checked") == true) {
		count++;
	}
	if ($("input:checkbox[id='Company']").is(":checked") == true) {
		count++;
	}
	return count;
}

// 편집 Area display
function openEditArea(){
	$("#AllEdit").removeAttr("style", "display:none");
	$("#AllEdit").removeClass(".help_hidden");
	
	if ($("input:checkbox[id='Author']").is(":checked") == true) {
		$("#trAuthor").removeAttr("style", "display:none;");
		$("#checkAuthor").val("1");
	} else {
		$("#trAuthor").attr("style", "display:none;");
		$("#checkAuthor").val("0");
	} 
	if ($("input:checkbox[id='OwnerTeam']").is(":checked") == true) {
		$("#trOwnerTeam").removeAttr("style", "display:none;");
		$("#checkOwnerTeam").val("1");
	}  else {
		$("#trOwnerTeam").attr("style", "display:none;");
		$("#checkOwnerTeam").val("0");
	} 
	if ($("input:checkbox[id='Company']").is(":checked") == true) {
		$("#trCompany").removeAttr("style", "display:none;");
		$("#checkCompany").val("1");
	}  else {
		$("#trCompany").attr("style", "display:none;");
		$("#checkCompany").val("0");
	} 
	
	if ($("input:checkbox[id='includeLowLank']").is(":checked") == true) {
		$("#checkIncludeLowLank").val("1");
	}  else {
		$("#checkIncludeLowLank").val("0");
	} 
	if ($("input:checkbox[id='transfer']").is(":checked") == true) {
		$("#checkTransfer").val("1");
// 		$("#OwnerTeam").attr("checked",false);
// 		$("#Company").attr("checked",false);
		$("#checkCompany").val("0");
		$("#checkOwnerTeam").val("0");
		$("#trCompany").attr("style", "display:none;");
		$("#trOwnerTeam").attr("style", "display:none;");
	}  else {
		$("#checkTransfer").val("0");
	} 
	
}

// 처리가 끝나고 팝업창 닫고 부모창 리로드
function selfClose(){
	//var opener = window.dialogArguments;
	opener.urlReload();
	self.close();
}

</script>
<form name="OAIPFrm" id="OAIPFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="items" name="items"  value="${items}" />
	
	<input type="hidden" id="AuthorID" name="AuthorID" value="" />
	<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="" />	
	
	<input type="hidden" id="checkAuthor" name="checkAuthor" value="0" />
	<input type="hidden" id="checkOwnerTeam" name="checkOwnerTeam" value="0" />
	<input type="hidden" id="checkCompany" name="checkCompany" value="0" />
	<input type="hidden" id="checkIncludeLowLank" name="checkIncludeLowLank" value="0" />
	<input type="hidden" id="checkTransfer" name="checkTransfer" value="0" />
	
	
<div id="objectInfoDiv" class="hidden" style="width:100%;height:300px;">
	
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Governance</p>
	</div>
	
	<ul id="breadcrumb">
        <li><span>Select option</span></li>
    </ul>
	
	<div id="framecontent" class="mgT10 mgB10">	
		<div class="attr">
	         <table width="95%"  border="0" cellspacing="0" cellpadding="0" >
				<tr style="height:25px;">
					<!-- 수정할 항목 -->
					<td>구분&nbsp;</td>
					<td>
						<input type="checkbox" id="Author" onClick="editCheckedAllItems();">&nbsp;${menu.LN00004}&nbsp;&nbsp;&nbsp;</input>
						<input type="checkbox" id="OwnerTeam" onClick="editCheckedAllItems();">&nbsp;${menu.LN00018}&nbsp;&nbsp;&nbsp;</input>
						<input type="checkbox" id="Company" onClick="editCheckedAllItems();">&nbsp;${menu.LN00014}&nbsp;&nbsp;&nbsp;</input>
					</td>
				</tr>
				<tr style="height:25px;">
					<!-- 하위항목 포함 유무 -->
					<td>Option</td>
					<td>
						<div id="OCGroup">
							<input type="checkbox" id="transfer" onClick="editCheckedAllItems();">&nbsp;${menu.LN00071}&nbsp;&nbsp;&nbsp;</input>
							<input type="checkbox" id="includeLowLank" onClick="editCheckedAllItems();">&nbsp;${menu.LN00159}&nbsp;&nbsp;&nbsp;</input>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<!--< div class="alignBTN mgB5">
			&nbsp;<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="submit" onclick="editCheckedAllItems();"></span>
		</div> -->
	</div>
	
	<div id="AllEdit" style="display:none;">
	<div id="editTitle">
		<ul id="breadcrumb">
	        <li><span>Edit</span></li>
	    </ul>
    </div>
	<div id="editArea" style="width:95%;" >
		<table class="tbl_preview mgL10 mgR10" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="12%">
				<col width="28%">
			</colgroup>
			<tr id="trAuthor" style="display:none;">
				<!-- 담당자-->			
				<th>${menu.LN00004}</th>
				<td class="tdLast"><input type="text" class="text" id="AuthorName" name="AuthorName" readonly="readonly" onclick="searchPopup('searchNamePop.do')" value="${getList.Name}"/></td>
			</tr>
			<tr id="trOwnerTeam" style="display:none;">
				<!-- 관리조직 -->
				<th>${menu.LN00018}</th>
				<td><input type="text"class="text" id="teamName" name="teamName" readonly="readonly" onclick="searchPopup('searchTeamPop.do?teamTypeYN=N')" value="${getList.OwnerTeamName}" /></td>				
			</tr>
			<tr id="trCompany" style="display:none;">
				<!-- 법인 -->
				<th>${menu.LN00014}</th>
				<td>
				<select id="companyCode" name="companyCode" class="sel">
					<c:forEach var="i" items="${companyOption}">
						<option value="${i.TeamID}" <c:if test="${ getList.TeamName == i.Name}">selected="selected"</c:if>>${i.Name}</option>						
					</c:forEach>
				</select>
				</td>	
			</tr>
			<!-- <tr></tr> -->
		</table>
		<div id="btnSave" class="alignBTN" >
		&nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="saveOwnerInfo()" type="submit"></span>
		</div>
	</div>
	</div>
		
</div>	
</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>