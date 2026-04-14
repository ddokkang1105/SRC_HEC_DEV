<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<c:url value="/" var="root"/>

<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<script type="text/javascript">
	
	$(document).ready(function(){
		
		$('#saveChangeSetInfo').click(function(e){
			saveChangeSetInfo();
		});
		
		$('#back').click(function(e){
			goList();
		});
		
	});

	
	function saveChangeSetInfo(){
		if(confirm("입력한 내용을 저장하시겠습니까?")){
			var url = "saveCARInfo.do";
			ajaxSubmit(document.changeInfoVeiwFrm, url);
		}
	}
	
	// [save] 이벤트 후 , 본 화면(Popup) 을 close
	function selfClose() {
		var opener = window.dialogArguments;
		opener.urlReload();
		self.close();
		
		//var url = "setWfStepActorPop.do?";
		//var data = "s_itemID=${s_itemID}&userId=${sessionScope.loginInfo.sessionUserId}&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"; 
	    //var option = "dialogWidth:1050px; dialogHeight:305px; scroll:yes";
	    //window.showModalDialog(url + data , self, option);
		
	}
	
	function searchPopup(url){	window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');}
	function setSearchName(memberID, memberName, objId, objName){
		if ($('#' + objId).val() == "") {
			$('#' + objId).val(memberID);
		} else {
			$('#' + objId).val($('#' + objId).val() + "," + memberID);
		}
		
		if ($('#' + objName).val() == "") {
			$('#' + objName).val(memberName);
		} else {
			$('#' + objName).val($('#' + objName).val() + "," + memberName);
		}
		
	}
	
</script>

<!-- BEGIN :: DETAIL -->
<title>${menu.LN00092}</title>
<link rel="stylesheet" type="text/css" href="${root}${HTML_CSS_DIR}/style.css"/>
	
	<!-- BEGIN :: changeInfoVeiwFrm -->
	<form name="changeInfoVeiwFrm" id="changeInfoVeiwFrm" action="#" method="post" onsubmit="return false;" >
	<div id="changeInfoVeiwDiv" class="hidden">
		<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
		<input type="hidden" id="items" name="items" value="${items}">
		<input type="hidden" id="LanguageID" name="LanguageID" value="${sessionScope.loginInfo.sessionCurrLangType}">
		<input type="hidden" id="userId" name="userId" value="${sessionScope.loginInfo.sessionUserId}">
		<input type="hidden" id="carType" name="carType" value="${changeType}">
		
		<input type="hidden" id="fromItemID" name="fromItemID" value="${fromItemID}"/>
		<input type="hidden" id="toItemID" name="toItemID" value="${toItemID}"/>
		
		<c:forEach var="i" items="${wfStepList}">
			<input type="hidden" id="${i.WFStepID}ID" name="${i.WFStepID}ID" value="" />
		</c:forEach>
		
		
		<div class="child_search_head">
			<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00092}</p>
		</div>
		
		<div id="tblChangeSet">
			<table class="tbl_blue01 mgT10"  width="100%">
				<colgroup>
					<col width="20%"/>
					<col width="11%"/>
					<col width="9%"/>
					<col width="11%"/>
					<col width="8%"/>
					<col width="11%"/>
					<col width="8%"/>
					<col width="11%"/>
				</colgroup>
				<tr>
					<!-- 변경관리단위 -->
					<th class="viewtop alignC">${menu.LN00089}</th>
					<td class="viewtop alignC">
						<select id="projectId" name="projectId" class="sel">
							<c:forEach var="i" items="${projectNameList}">
								<option value="${i.ProjectID}">${i.Name}</option>				
							</c:forEach>				
						</select>
					</td>
					<!-- 변경사유 -->
					<th class="viewtop alignC">${menu.LN00023}</th>
					<td class="viewtop alignC">
						<select id="reason" name="reason" class="sel">
							<option value=""></option>
							<c:forEach var="i" items="${reasonList}">
								<option value="${i.TypeCode}">${i.Name}</option>					
							</c:forEach>				
						</select>
					</td>
					
					<!-- WF 선택 -->
					<th class="viewtop alignC">합의/승인 단계</th>
					<td class="viewtop alignC">
						<select id="WfStepSel" name="WfStepSel" class="sel">
							<c:forEach var="i" items="${wfList}">
								<option value="${i.WFID}">${i.Cateogory}</option>					
							</c:forEach>	
						</select>
					</td>
					
					<!-- 요청일 -->
					<th class="viewtop alignC">${menu.LN00093}</th>
					<td class="viewtop alignC">${toDay}</td>
					
					<!-- 변경구분 
					<th class="viewtop alignC">${menu.LN00022}</th>
					<td class="viewtop alignC">
						<select id="changeType" name="changeType" class="sel" disabled="disabled">
							<c:forEach var="i" items="${changeTypeList}">
								<option value="${i.TypeCode}" <c:if test="${changeType == i.TypeCode}">selected</c:if>>${i.Name}</option>				
							</c:forEach>				
						</select>
					</td>
					-->
					<!-- 상태 
					<th class="viewtop alignC">${menu.LN00027}</th>
					<td class="viewtop alignC">
						<select id="changeSetSts" name="changeSetSts" class="sel" disabled="disabled">
							<c:forEach var="i" items="${changeSetStsList}">
								<option value="${i.TypeCode}" <c:if test="${changeStatus == i.TypeCode}">selected</c:if>>${i.Name}</option>					
							</c:forEach>				
						</select>
					</td>
					-->
				</tr>
				
				<tr>
					<!-- 합의자/승인자 -->
					<th class="alignC">담당자 설정</th>
					<td colspan="7" class="alignL">
						<c:forEach var="i" items="${wfStepList}">
							<li>
								<span class="floatL msg"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;${i.Name}</span>&nbsp;&nbsp;
								<input type="text" class="text" readonly="readonly" id="${i.WFStepID}Name" name="${i.WFStepID}Name" onclick="searchPopup('searchPluralNamePop.do?objId=${i.WFStepID}ID&objName=${i.WFStepID}Name')">		
							</li>
						</c:forEach>	
					</td>
				</tr>
				
				<tr>
					<!-- 개요 -->
					<th class="alignC">${menu.LN00035}</th>
					<td colspan="7">
						<textarea id="description" name="description" style="height:40px;"></textarea>
					</td>
				</tr>
						
			</table>
		</div>
	
		<!-- BEGIN :: Button -->
		<div class="alignBTN">
			<span class="btn_pack medium icon"><span class="save"></span><input id="saveChangeSetInfo" value="Save" type="submit"></span>
		</div>
	<!-- END :: Button -->
	</div>
	</form>
	<!-- END :: changeInfoVeiwFrm -->

<!-- END :: DETAIL -->

<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
