<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<c:url value="/" var="root" />
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript">
	var chkReadOnly = false;	
</script>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00033}" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="한국어 ${menu.LN00028}" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="${menu.LN00043}" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_4" arguments="영어 ${menu.LN00028}" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_5" arguments="한국어 설명" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_6" arguments="영어  설명" />
<script type="text/javascript">
	let parentID = "";
	let termsList = "";
	var itemID = "${itemID}";
	
	jQuery(document).ready(function() {
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('Category', data+"&attrTypeCode=AT00034", 'getAttrTypeLov', '${termDetailInfo.Category}', 'Select');
		fnSelect('Abbreviation', data+"&attrTypeCode=AT00073", 'getAttrTypeLov', '${termDetailInfo.Abbreviation}', 'Select');
		
		if("${option}" == "selectHier") {
			// 등록
			if(itemID == "") fnSelect('L1', data+"&itemID=11&classCodeList='CL11001','CL11002','CL11003'", 'getChildItemNameList', '', 'Select');
			// 수정
			else {
				let target = "";
				getParentList("${itemID}").then(p => {
					$("#parentID").val(p.parentID);
					if(p.parentClassCode === "CL11003") target = "L3";
					if(p.parentClassCode === "CL11002") target = "L2";
					if(p.parentClassCode === "CL11001") target = "L1";
					fnSelect(target, data+"&classCodeList='CL11001','CL11002','CL11003'&itemID="+p.parentID, 'getParentItemNameList', p.parentID, 'Select');
					getParentList(p.parentID).then(pp => {
						if(pp.parentClassCode === "CL11002") target = "L2";
						if(pp.parentClassCode === "CL11001") target = "L1";
						if(pp.parentID !== "11") {
							fnSelect(target, data+"&classCodeList='CL11001','CL11002','CL11003'&itemID="+pp.parentID, 'getParentItemNameList', pp.parentID, 'Select');
							getParentList(pp.parentID).then(ppp => {
								if(ppp.parentID !== "11") fnSelect('L1', data+"&classCodeList='CL11001','CL11002','CL11003'&itemID="+ppp.parentID, 'getParentItemNameList', ppp.parentID, 'Select');
							});
						}
					});
				});
			}
		}
	});
	
	
	async function getParentList(itemID) {
		const res = await fetch("getParentID.do?itemID="+itemID);
		const data = await res.json();
		return data;
	}
	
	document.addEventListener('keydown', function(event) {
		  if (event.keyCode === 13) {
		    event.preventDefault();
		  };
	}, true);
	
	function fnChangeLanguage(language){		
		var url = "editTermDetail.do";
		var target = "editTermDetailDiv";
		var data = "itemID=${itemID}&csr=${csr}&languageID="+language;
	 	ajaxPage(url, data, target);
	}
	
	function fnSaveTermDetail(){
		if(validation()) {
			if(confirm("${CM00001}")){
				var url = "saveTermDetail.do";	
				if(itemID == ""){
					url = "registerTerm.do";
				}
				
				//2025-02-13 화면단 xss filter 적용
				debugger;
				var AT00056 = tinyMCE.get('AT00056').getContent();
				tinyMCE.get('AT00056').setContent(imgFilter(AT00056));
				var AT00057 = tinyMCE.get('AT00057').getContent();
				tinyMCE.get('AT00057').setContent(imgFilter(AT00057));
				var AT00058 = tinyMCE.get('AT00058').getContent();
				tinyMCE.get('AT00058').setContent(imgFilter(AT00058));
				
	 			ajaxSubmit(document.editTermFrm, url);
			}
		}
	}
	
	function validation() {
		var isValid = true;
		
		if("${option}" == "selectHier") {
			document.querySelectorAll(".childList").forEach(e => {
			    if(e.style.display !== "none") {
			    	if(!e.value) {
			    		alert("${WM00034_3}");
			    		isValid = false;
						return isValid;
			    	}
			    }
			})
		}
		
		if($("#1042_Name").val() == ""){
			alert("${WM00034_2}");
			isValid = false;
			return isValid;
		}
		
		if($("#1033_Name").val() == ""){
			alert("${WM00034_4}");
			isValid = false;
			return isValid;
		}
		
		if(tinyMCE.get('AT00056').getContent() == ""){
			alert("${WM00034_5}");
			isValid = false;
			return isValid;
		}
		
		if(tinyMCE.get('AT00057').getContent() == ""){
			alert("${WM00034_6}");
			isValid = false;
			return isValid;
		}
		
		if("${option}" !== "selectHier") {
			var category = $("#Category").val();
			if(category == "" || category == null){
				alert("${WM00034_1}");
				isValid = false;
				return isValid;
			}
		}
		
		return isValid;
	}
	
	function fnCallBack(){
		var url = "viewTermDetail.do";
		var target = "editTermDetailDiv";
		var data = "itemID=${itemID}&csr=${csr}&option=${option}";
	 	ajaxPage(url, data, target);
	}
	
	function fnCallBackAdd(itemID){
		if("${callback}") {
			opener["${callback}"](itemID);
			close();
		}
		var url = "viewTermDetail.do";
		var target = "editTermDetailDiv";
		var data = "itemID="+itemID+"&csr=${csr}&option=${option}"; 
	 	ajaxPage(url, data, target);
	}
	
	//2025-02-13 화면단 xss filter 적용
	function imgFilter(value){
		debugger;
		if(value != null){
			var check = value.indexOf("img src=\"")

			if(check == -1){
				value = value.replace("img src=","")
			}
		}
		return value;
	}
	
	function getChildList(itemID, target) {
		$("#parentID").val(itemID);
		let param = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&classCodeList='CL11001','CL11002','CL11003'&itemID="+itemID+"&menuId=getChildItemNameList";
		if(target) {
			$.ajax({
				url:"ajaxCodeSelect.do",
				type:"POST",
				data:param,
				success: function(result){
					if(result.trim()) {
						$("#"+target).css("display","inline-block");
						$("#"+target).html("<option value=''>Select</option>"+result);
					} else {
						$("#"+target).css("display","none");
					}
				},error:function(xhr,status,error){
					console.log("ERR :["+xhr.status+"]"+error);
				}
			});
		}
	}
	
	function fnCheckIdentifier(lauguageID) {
		let otherNumbers = 0;
		fetch("/olmapi/plainText/?languageID="+lauguageID+"&attrTypeCode=AT00001&itemClassCode=CL11004&searchValue="+document.getElementById(lauguageID+"_Name").value)
		.then(res => res.json())
		.then(res => {
			let message = document.getElementById(lauguageID+"_Name").value+"이(가) 포함된 단어는 ";
			if(res.length > 0) {
				message += "\n"+res.filter((e,i) =>  i < 10).map(e => e.PlainText).join("\n");
				if(res.length > 10) {
					otherNumbers = res.length - 10;
					message += "\n외 "+otherNumbers+"건이 존재합니다."
				} else {
					message += "\n입니다."
				}
			} else {
				message += "0건 입니다."
			}
			alert(message);
		})
	}
</script>
</head>

<body>
	<div id="editTermDetailDiv">
		<form name="editTermFrm" id="editTermFrm" action="#" method="post" onsubmit="return false;">
			<div id="editTermDetailStyle" style="height: 100vh; overflow: auto; overflow-x: hidden; padding: 6px; 6px; 6px; 6px;">
				<input type="hidden" id="itemID" name="itemID" value="${itemID}">
				<input type="hidden" id="csr" name="csr" value="${csr}">
				<input type="hidden" id="mgt" name="mgt" value="${mgt}">
				<input type="hidden" id="parentID" name="parentID" value="">
				<div class="cop_hdtitle">
					<h3>
						<img src="${root}${HTML_IMG_DIR}/icon_csr.png">
						<c:if test="${itemID != '' }">&nbsp;&nbsp;Edit ${menu.LN00300}</c:if>
						<c:if test="${itemID == '' }">&nbsp;&nbsp;Add ${menu.LN00300}</c:if>
					</h3>
				</div>
				<div id="tblChangeSet" style="width: 99%">
					<table class="tbl_blue01 mgT10" style="table-layout: fixed;" width="100%" border="0" cellpadding="0" cellspacing="0">
						<colgroup>
							<col width="12%" />
							<col width="38%" />
							<col width="12%" />
							<col width="38%" />
						</colgroup>
						<c:if test="${option ne 'selectHier'}">
							<tr>
								<!-- Category -->
								<th class="viewtop">${menu.LN00033}</th>
								<td class="viewtop alignL">
									<select id="Category" name="Category" style="width: 90%">
										<option value=''>Select</option>
									</select>
									<!-- 약어 -->
								<th class="viewtop">${menu.LN00080}</th>
								<td class="viewtop alignL last">
									<input type="text" class="text" id="Abbreviation" name="Abbreviation" value="${termDetailInfo.Abbreviation}" />
								</td>
							</tr>
						</c:if>
						<c:if test="${option eq 'selectHier'}">
							<tr>
								<th>${menu.LN00043}</th>
								<td class="alignL last" colspan="3">
									<select id="L1" name="L1" class="childList" onchange="getChildList(this.value, 'L2')" style="width:150px;"></select>
									<select id="L2" name="L2" class="childList" onchange="getChildList(this.value, 'L3')" style="display:none;width:150px;"></select>
									<select id="L3" name="L3" class="childList" onchange="getChildList(this.value)" style="display:none;width:150px;"></select>
								</td>
							</tr>
						</c:if>
						<tr>
							<th>한국어 ${menu.LN00028}</th>
							<td class="alignL pdL5 last" colspan="3">
								<input type="text" class="text" id="1042_Name" name="1042_Name" style="width: calc(100% - 100px);" value="${termDetailInfo.Name}" />
								<span id="1042_idCheck" name="1042_idCheck"  class="btn_pack medium icon mgT3"><span class="confirm"></span><input value="중복체크" onclick="fnCheckIdentifier(1042)" type="submit"></span>
							</td>
						</tr>
						<tr>
							<th>영어 ${menu.LN00028}</th>
							<td class="alignL pdL5 last" colspan="3">
								<input type="text" class="text" id="1033_Name" name="1033_Name" style="width: calc(100% - 100px);" value="${termDetailInfo.enName}" />
								<span id="1033_idCheck" name="1033_idCheck"  class="btn_pack medium icon mgT3"><span class="confirm"></span><input value="중복체크" onclick="fnCheckIdentifier(1033)" type="submit"></span>
							</td>
						</tr>
						<tr>
							<th>중국어 ${menu.LN00028}</th>
							<td class="alignL pdL5 last" colspan="3">
								<input type="text" class="text" id="2052_Name" name="2052_Name" style="width: calc(100% - 100px);" value="${termDetailInfo.cnName}" />
								<span id="2052_idCheck" name="2052_idCheck"  class="btn_pack medium icon mgT3"><span class="confirm"></span><input value="중복체크" onclick="fnCheckIdentifier(2052)" type="submit"></span>
							</td>
						</tr>
						<!-- 
			<tr>				
				<th class="pdL10">English Name</th>
				<td class="alignL pdL5 last" colspan="3"><input type="text" class="text" id="EnglishNM" name="EnglishNM"  value="${termDetailInfo.EnglishNM}"/></td>				
			</tr>	
			 -->
					</table>

					<table class="tbl_blue01 mgT10" style="table-layout: fixed;" width="100%" border="0" cellpadding="0" cellspacing="0">
						<colgroup>
							<col width="12%" />
							<col width="88%" />
						</colgroup>
						<!-- 
			<tr>				
				<th class="pdL10">${menu.LN00035}</th>
				<td class="alignL pdL5 last" id="TD_AT00003_1042" name="TD_AT00003_1042">
					<textarea class="tinymceText" style="width:100%;height:150px;" id="Overview" name="Overview">${termDetailInfo.Overview}</textarea>
				</td>			
			</tr>
			<tr>				
				<th class="pdL10">${menu.LN00145}</th>
				<td class="alignL pdL5 last" id="TD_AT00056_1042" name="TD_AT00056_1042" >
					<textarea class="tinymceText" style="width:100%;height:150px;" id="Content" name="Content">${termDetailInfo.Content}</textarea>
				</td>				
			</tr>
			 -->
						<tr>
							<th>한국어 설명</th>
							<td class="alignL pdL5 last">
								<div style="width: 100%; height: 150px;">
									<textarea class="tinymceText" id="AT00056" name="AT00056">${termDetailInfo.KoreanText}</textarea>
								</div>
							</td>
						</tr>
						<tr>
							<th>영어 설명</th>
							<td class="alignL pdL5 last">
								<div style="width: 100%; height: 150px;">
									<textarea class="tinymceText" id="AT00057" name="AT00057">${termDetailInfo.EnglishText}</textarea>
								</div>
							</td>
						</tr>
						<tr>
							<th>중국어 설명</th>
							<td class="alignL pdL5 last">
								<div style="width: 100%; height: 150px;">
									<textarea class="tinymceText" id="AT00058" name="AT00058">${termDetailInfo.ChineseText}</textarea>
								</div>
							</td>
						</tr>
					</table>
					<c:if test="${itemID != ''}">
						<table class="tbl_blue01 mgT10" style="table-layout: fixed;" width="100%" border="0" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="12%" />
								<col width="88%" />
							</colgroup>
							<tr>
								<th class="pdL10">${menu.LN00136}</th>
								<td class="alignL pdL5 last">
									<textarea class="edit" style="width: 100%; height: 50px;" id="changeSetDescription" name="changeSetDescription"></textarea>
								</td>
							</tr>
						</table>
					</c:if>
					<div class="alignBTN pdB20">
						<span class="btn_pack medium icon"><span class="save"></span>
						<input value="Save" onclick="fnSaveTermDetail()" type="submit"></span>
					</div>
				</div>
			</div>
		</form>
	</div>
	<iframe name="saveFrame" id="saveFrame" src="about:blank" style="display: none" frameborder="0"></iframe>
</body>
</html>
