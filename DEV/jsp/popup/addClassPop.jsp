<%@page import="java.sql.PreparedStatement"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00065" var="WM00065"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="Object"/>

<title>${menu.LN00096}</title>
</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>

<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용

	$(document).ready(function() {
		//fnSelect('getLanguageID', '', 'langType', '${sessionScope.loginInfo.sessionCurrLangType}','Select');
		$('#CategoryCode').change(function(){changeObjectType($(this).val());});
		
	});

	function saveClassType() {
		// [OBJECT 필수 체크]
		/*
		if('${sessionScope.loginInfo.sessionCurrLangType}' != $("#getLanguageID").val()){
			//alert("선택된 언어와 로그인된 언어가 다릅니다.");
			alert("${WM00065}");
			return false;
		}*/
				
		if($("#ItemTypeCode").val() == ""){
			//alert("Object을 선택하세요.");
			alert("${WM00041}");
			return false;
		}
		
		//if(confirm("저장하시겠습니까?")){
		if(confirm("${CM00001}")){
            var url = "admin/saveClassType.do";
			ajaxSubmit(document.AttributeTypeList, url, "saveFrame");
		}	
	}

	// [save] 이벤트 후 처리
	function selfClose() {
		opener.fnCallBack();
		self.close();
	}
	
	// [OBJECT] 값 설정
	function changeObjectType(avg1){
		var url    = "getObjectTypeList.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&option="+avg1; //파라미터들
		var target = "ItemTypeCode";             // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		
		ajaxSelect(url, data, target, defaultValue, isAll);
	}
	
	function fnOnlyEnNum(obj){
		var regType = /^[A-Za-z0-9*]+$/;
        if(!regType.test(obj.value)) {
            obj.focus();
            $(obj).val( $(obj).val().replace(/[^A-Za-z0-9]/gi,"") );
            return false;
        }
    }
</script>
<body>
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;${menu.LN00005}</p>
	</div>
	<form name="AttributeTypeList" id="AttributeTypeList" action="saveAttributeType.do" method="post" onsubmit="return false;">
	 <input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />
	 <div class="mgT5 mgL5 mgR5">	 
		<table id="newObject" class="tbl_blue01" width="100%;">
			<colgroup>
				<col width="20%">
				<col width="20%">
				<col width="20%">
				<col width="38%">
			</colgroup>
			<!-- 항목유형 -->
			<tr>
				<th class="viewtop">Category</th>
				<td class="viewtop last">
					<select id="CategoryCode" name="CategoryCode" style="width: 100%">
						<option value=""></option>
						<c:forEach var="i" items="${CategoryOption}">
							<option value="${i.Category}">${i.Category}</option>						
						</c:forEach>				
					</select>
				</td>
				<th class="viewtop">OBJECT</th>
				<td class="last viewtop">
					<select id="ItemTypeCode" name="ItemTypeCode" style="width: 100%"></select>
				</td>
			</tr>
			<!-- ID -->		
			<tr>
				<th>${menu.LN00015}</th>
				<td colspan="3" class="last">
					<input type="text" class="text" id="objType" name="objType" maxlength="10" STYLE='IME-MODE:DISABLED'  onkeyup="fnOnlyEnNum(this);" onchange="fnOnlyEnNum(this);"/>
				</td>
			</tr>
			<!-- 명칭 -->
			<tr>
				<th>${menu.LN00028}</th>
				<td colspan="3" class="last">
					<input type="text" class="text" id="objName" name="objName" />
				</td>
			</tr>
			<!-- 개요 -->
			<tr>
				<th>${menu.LN00035}</th>
				<td colspan="3" class="last">
					<input type="text" class="text" id="objDescription" name="objDescription">
				</td>
			
			<!-- 언어 
			<tr>
				<th>LanguageID</th>
				<td colspan="3">
					<select id="getLanguageID" name="getLanguageID" onchange="saveAttrribute"  style="width:100%;"> 
					</select>
				</td>
			</tr>-->
		</table>
</div>
		<div class="alignBTN">
			&nbsp;<span class="btn_pack medium icon mgR10"><span class="save"></span><input value="Save" type="submit" onclick="saveClassType()"></span>
		</div>

	</form>
	<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display: none" frameborder="0"></iframe>
</body>
</html>