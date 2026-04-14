<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="${menu.LN00003}"/> 

<script type="text/javascript">
	function fnSaveRevision() {
		var description = $("#Description").val();
		if(description == ""){ alert("${WM00034}"); return;}
		if(confirm("${CM00001}")){
			var url = "saveRevision.do";
			ajaxSubmit(document.revFrm, url);
		}
	}
	
	function fnCallBack(){
		opener.urlReload();
		self.close();
	}
		 
</script> 

<form name="revFrm" id="revFrm" action="#" method="post" onsubmit="return false;">
<div id="changeInfoVeiwDiv" class="hidden" style="overflow:auto; overflow-x:hidden; padding: 6px; 6px; 6px; 6px;" >
	<input type="hidden" id="revisionID" name="revisionID" value="${getData.RevisionID}" >
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 6px 0 6px 6px">
			<img src="${root}${HTML_IMG_DIR}/img_revision.png">&nbsp;&nbsp;
			Revision info.
		</h3>
	</div>
	<div id="tblChangeSet" style="width:99%">
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="10%"/>
				<col width="22%"/>
				<col width="10%"/>
				<col width="22%"/>
				<col width="10%"/>
				<col width="23%"/>			
			</colgroup>
			<tr>
				<td colspan="6" class="last alignL">
					Last updated on ${getData.LastUpdated} by ${getData.Name} (${getData.NameEN} / ${getData.AuthorTeamName})
				</td>
			</tr>
			<tr>
				<!-- 개요 -->
				<td colspan="6" class="last alignL pdL5" style="width:100%;height:150px;" valign="top">							
					<c:if test="${getData.AuthorID == sessionScope.loginInfo.sessionUserId}" >
						<textarea id="Description" name="Description" style="width:100%;height:180px;">${getData.Description}</textarea></c:if>
					<c:if test="${getData.AuthorID != sessionScope.loginInfo.sessionUserId}" >${getData.Description}</c:if>
				</td>
			</tr>
		</table>
		<c:if test="${getData.AuthorID == sessionScope.loginInfo.sessionUserId}" >
		<div class="alignBTN">
			<span id="viewSave" class="btn_pack medium icon"><span class="save"></span>
			<input value="Save" type="submit" onclick="fnSaveRevision()"></span>&nbsp;
		</div>
		</c:if>	
	</div>
</div>
</form>

<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
