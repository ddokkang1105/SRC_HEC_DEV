<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root" />

<!--1. Include JSP -->
<!-- <script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script> -->

<!-- 화면 표시 메세지 취득    -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="Mgt User ID"/>


<!-- Script -->
<script type="text/javascript">

	$(document).ready(function() {
		fnSelect('getLanguageID', '', 'langType', '${languageID}', 'Select');
		fnSelect('companyID', '', 'getCompany', '${resultMap.CompanyID}', 'Select');
		var data = "&boardMgtID=${resultMap.BoardMgtID}"; 
		fnSelect('parentID', data, 'getBoardMgtParentID', '${resultMap.ParentID}', 'Select');
		fnSelect('mgtGRID', '&wfadmin=Y&active=0', 'getUserGroupList', '${resultMap.MgtGRID}', 'Select');
		fnSelect('boardTypeCD', '&languageID=${languageID}&menuCat=BRD', 'getMenuType', '${resultMap.BoardTypeCD}', 'Select');
		
		var chk1 = document.getElementsByName("mgtOnlyYN");
		if(chk1[0].checked == true){ 
			$('#mgtUserIDTxt').attr('onClick',"searchPopup('searchNamePop.do');");
		}
	});

	function fnSaveBoardMgt() {
		var chk1 = document.getElementsByName("mgtOnlyYN");
		if(chk1[0].checked == true && $('#mgtUserIDTxt').val() == ""){ 
			alert("${WM00034}");
			return false;
		}
		if (confirm("${CM00001}")) {
			var url = "saveBoardMgt.do?viewType=${viewType}";
			ajaxSubmit(document.boardMgtDetail, url,"saveFrame");			
		}
	}

	function fnCallBack(){
		var url = "boardManagement.do";
		var data = "&pageNum=" + $("#CurrPageNum").val(); 
		var target = "boardMgtDiv";
		ajaxPage(url, data, target);
	}
	
	function checkBox1(){			
		var chk1 = document.getElementsByName("deactivated");
		if(chk1[0].checked == true){ $("#deactivated").val("1");
		}else{	$("#deactivated").val("0"); }
	}
	
	function checkBox2(){			
		var chk1 = document.getElementsByName("likeYN");
		if(chk1[0].checked == true){ $("#likeYN").val("Y");
		}else{	$("#likeYN").val("N"); }
	}
	
	function checkBox3(){			
		var chk1 = document.getElementsByName("pointYN");
		if(chk1[0].checked == true){ $("#pointYN").val("Y");
		}else{	$("#pointYN").val("N"); }
	}
	
// 	function checkBox4(){			
// 		var chk1 = document.getElementsByName("postEmailYN");
// 		if(chk1[0].checked == true){ $("#postEmailYN").val("Y");
// 		}else{	$("#postEmailYN").val("N"); }
// 	}
	
	function checkBox5(){			
		var chk1 = document.getElementsByName("mgtOnlyYN");
		if(chk1[0].checked == true){ 
			$("#mgtOnlyYN").val("Y");
			$('#mgtUserIDTxt').attr('onClick',"searchPopup('searchNamePop.do');");
		}else{
			$("#mgtOnlyYN").val("N");
			document.getElementById('mgtUserIDTxt').onclick = null;
		}
	}
	
	
	function fnAllocTempl(){
		var url = "subTab.do";
		var data ="url=defineTemplateMenu&templCode=${templCode}&languageID=${languageID}" 
						+"&pageNum=${pageNum}&viewType=${viewType}"; 
		var target = "templateList";
		ajaxPage(url, data, target);
	}
	
	function searchPopup(url){
		window.open(url,'window','width=350, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSearchTeam(teamID,teamName){$('#companyID').val(teamID);$('#teamName').val(teamName);}
	
	function fnAllocBoardMgt(){
		var url = "allocateBoardMgt.do";
		var data ="boardMgtID=${resultMap.BoardMgtID}&languageID=${languageID}" 
						+"&pageNum=${pageNum}&viewType=${viewType}";
		var target = "boardMgtDetail";
		ajaxPage(url, data, target);
	}
	function setSearchName(memberID,memberName){$('#mgtUserID').val(memberID);$('#mgtUserIDTxt').val(memberName);}
		
</script>

<div id="groupListDiv">
	<form name="boardMgtDetail" id="boardMgtDetail" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="CurrPageNum" name="CurrPageNum" value="${pageNum}">	
		<input type="hidden" id="mgtUserID" name="mgtUserID" value="${resultMap.MgtUserID}">	
		<div class="cfg">
			<li class="cfgtitle"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Edit BoardManagement</li>
			<li class="floatR pdR20 pdT10"><span><select id="getLanguageID" name="getLanguageID"></select></span>
			</li>
		</div><br>
		<table style="table-layout:fixed;" class="tbl_blue01" width="100%">
			<colgroup>
				<col width="6%">
				<col width="10%">
				<col width="6%">
				<col width="10%">
				<col width="6%">
				<col width="10%">
			</colgroup>
			<tr>
				<th class="viewtop">${menu.LN00015}</th>
				<td class="viewtop">
					<input type="Text"  class="text" id="boardMgtID" name="boardMgtID" value="${resultMap.BoardMgtID}" >	
				</td>
				<th class="viewtop">${menu.LN00028}</th>
				<td class="viewtop"><input type="text" class="text" id="boardMgtName" name="boardMgtName" value="${resultMap.BoardMgtName}"/>
					<input type="hidden" class="text" id="dicTypeCode" name="dicTypeCode" value="${resultMap.DicTypeCode}"/>
				</td>
				<th class="viewtop">Board Menu</th>
				<td class="viewtop">
					<select style="width:100%;" id="boardTypeCD" name="boardTypeCD"></select>
				</td>				
			</tr>
			<tr>	
				<th>Company</th>
				<td><select id="companyID" name="companyID" style="width:100%;"></select></td>
				<th>ParentID</th>
				<td><select id="parentID" name="parentID" style="width:100%;"></select></td>
				<th>Category option</th>
				<td class="last"><select id="categoryYN" name="categoryYN" style="width:100%;">
						<option value="">Select</option>
						<option value="Y" <c:if test="${resultMap.CategoryYN == 'Y'}">selected</c:if>>YES</option>
						<option value="N" <c:if test="${resultMap.CategoryYN == 'N'}">selected</c:if>>NO</option>
				</select></td>
				
			</tr>
			<tr>
				
				<th>Email option</th>
				<td>
					<select id="postEmailYN" name="postEmailYN" style="width:100%;">
						<option value="Y" <c:if test="${resultMap.PostEmailYN == 'Y'}">selected</c:if>>Y</option>
						<option value="N" <c:if test="${resultMap.PostEmailYN == 'N' || resultMap.PostEmailYN == '' || resultMap.PostEmailYN == null}">selected</c:if>>N</option>
						<option value="M" <c:if test="${resultMap.PostEmailYN == 'M'}">selected</c:if>>M</option>
					</select>
				</td>
				<th>Like option</th>
				<td><input type="checkbox" name="likeYN" id="likeYN" 
					<c:if test="${resultMap.LikeYN == 'Y'}">checked="checked"</c:if>
					value="${resultMap.likeYN}" onclick="checkBox2()"></td>
				<th>Point option</th>
				<td class="last"> <input type="checkbox" name="pointYN" id="pointYN" 
					<c:if test="${resultMap.PointYN == 'Y'}">checked="checked"</c:if>
					value="${resultMap.pointYN}" onclick="checkBox3()"></td>				
			</tr>
			
			<tr>
				<th>Mgt. only write</th>
				<td><input type="checkbox" name="mgtOnlyYN" id="mgtOnlyYN" 
					<c:if test="${resultMap.MgtOnlyYN == 'Y'}">checked="checked"</c:if>
					value="${resultMap.MgtOnlyYN}" onclick="checkBox5()"></td>
				<th >Mgt User ID</th>
				<td>
				<input type="text" class="text" id="mgtUserIDTxt" name="mgtUserIDTxt" readonly="readonly" value="${resultMap.MgtUserIDTxt}"/></td>				
				<th>Mgt Group ID</th>
				<td><select id="mgtGRID" name="mgtGRID" style="width:100%"></select>	
				</td>
			</tr>
			
			<tr>
				<th>Deactivated</th>
				<td><input type="checkbox" name="deactivated" id="deactivated" 
						<c:if test="${resultMap.Deactivated == '1'}">checked="checked"</c:if>
						value="${resultMap.Deactivated}" onclick="checkBox1()">
				</td> 
				
				<th>Reply option</th>
				<td>
					<select id="replyOption" name="replyOption" style="width:100%;">
						<option value="0" <c:if test="${resultMap.ReplyOption == '0'}">selected</c:if>>0</option>
						<option value="1" <c:if test="${resultMap.ReplyOption == '1'}">selected</c:if>>1</option>
						<option value="2" <c:if test="${resultMap.ReplyOption == '2'}">selected</c:if>>2</option>
					</select>
				</td>	
				<th>${menu.LN00070}</th>
				<td class="last">${resultMap.ModDT}</td>				
			</tr>
			
			<tr>
				<td colspan="6" style="height:180px;" class="last">
				<textarea class="edit" id="description" name="description" rows="12" cols="50" style="width: 100%; height: 98%;">${resultMap.BoardMgtDES}</textarea></td>
			</tr>
			<tr>
				<td class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="6">
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
						<c:if test="${viewType == 'E' }">
						<span class="btn_pack medium icon"><span class="allocation"></span><input value="Allocation" type="submit" onclick="fnAllocBoardMgt()"></span>
						</c:if>
						<span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit" onclick="fnCallBack()"></span>
						<span class="btn_pack medium icon"> <span class="save"></span><input value="Save" type="submit" onclick="fnSaveBoardMgt()"></span>
					</c:if>
				</td>
			</tr>
		</table>
	</form>
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>
</div>