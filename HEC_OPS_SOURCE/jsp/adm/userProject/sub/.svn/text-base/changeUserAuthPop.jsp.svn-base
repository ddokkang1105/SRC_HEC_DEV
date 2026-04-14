<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<c:url value="/" var="root"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_1" arguments="${menu.LN00144}"/>

<script type="text/javascript">
	$(document).ready(function(){
		var data = "LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&Category=MLVL";
		fnSelectNone('authority', data, 'dictionyCode');
	});
	
	function fnEditUserAuth(){	
		if(confirm("${CM00001}")){			
			var url  = "editUserAuthority.do";
			ajaxSubmit(document.objectInfoFrm, url,"subFrame");
		}
	}
	
	function fnCallBack(){
		opener.fnCallBack();
		self.close();
	}
</script>
<form name="objectInfoFrm" id="objectInfoFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="memberIDs" name="memberIDs" value="${memberIDs}" >
	<div id="objectInfoDiv" class="hidden" style="width:100%;">
		<div class="child_search_head">
			<p><img src="${root}${HTML_IMG_DIR}/category.png"><span>&nbsp;&nbsp;Change Users Authority</span></p>
		</div>
		<ul id="breadcrumb">
	        <li><span>Select Authority</span></li>
	    </ul>
		<div id="editArea" style="width:95%;" >
			<table class="tbl_preview mgL10 mgR10" border="0" cellpadding="0" cellspacing="0">
				<colgroup>
					<col width="25%">
					<col width="75%">
				</colgroup>
				<tr>
					<th>${menu.LN00149}</th>
					<td>
						<select id="authority" name="authority" style="width:100%;"></select>
					</td>
				</tr>
			</table>
			<div id="btnSave" class="alignBTN" >
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnEditUserAuth()"  type="submit"></span>
			</div>
		</div>
	</div>
</form>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>