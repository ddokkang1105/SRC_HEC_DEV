<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<head>
<title>${ClassName} : ${OwnerTeamName}</title>
<script src="<c:url value='/cmm/js/tinymce_v7/tinymce.min.js'/>" type="text/javascript"></script>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
	var chkReadOnly = false;
</script>
 
 <!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
 
<script type="text/javascript">

	$(document).ready(function(){		
		$("input.datePicker").each(generateDatePicker);
		document.getElementById('objectInfoDiv').style.height = (setWindowHeight() - 100)+"px";			
		window.onresize = function() {
			document.getElementById('objectInfoDiv').style.height = (setWindowHeight() - 100)+"px";	
		};
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	function saveObjInfoMain(){	
		if(confirm("${CM00001}")){	
			var mLovCode = "";
			var AttrTypeValue;
			var mLovCodeValue;
			var k; var l;
			var dataType = "";
			<c:forEach var="i" items="${getAttrList}" varStatus="iStatus">
			    AttrTypeValue = new Array;
			    mLovCodeValue = new Array;
			    k=0;
			    dataType = "${i.DataType}";
				<c:if test="${i.DataType == 'MLOV'}" >
					<c:forEach var="mLovList" items="${i.mLovList}" varStatus="status">
						mLovCode = "${mLovList.AttrTypeCode}"+"${mLovList.CODE}";
						var checkObj = document.all(mLovCode);
						if (checkObj.checked) {
							AttrTypeValue[k] = $("#"+mLovCode).val();
							mLovCodeValue[k] = $("#"+mLovCode).val();
							k++;
						}				
					</c:forEach>
					$("#"+"${i.AttrTypeCode}").val(mLovCodeValue);
				</c:if>
				
				l=0;
			    dataType = "${i.DataType2}";
				<c:if test="${i.DataType2 == 'MLOV'}" >
					<c:forEach var="mLovList2" items="${i.mLovList2}" varStatus="status">
						mLovCode = "${mLovList2.AttrTypeCode}"+"${mLovList2.CODE}";
						var checkObj = document.all(mLovCode);
						if (checkObj.checked) {
							AttrTypeValue[l] = $("#"+mLovCode).val();
							mLovCodeValue[l] = $("#"+mLovCode).val();
							l++;
						}				
					</c:forEach>
					$("#"+"${i.AttrTypeCode2}").val(mLovCodeValue);
				</c:if>
			</c:forEach>
			var instanceClass = "${instanceClass}";
			var url = "saveProcInstanceInfo.do";
			if(instanceClass == "ELM"){
				url = "saveElmInstInfo.do";
			}
			
			ajaxSubmit(document.objectInfoFrm, url);
		}
	}

	function returnSaveObj(){location.reload();}
	function searchPopup(url){	window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');}
	function setSearchName(memberID,memberName){$('#AuthorID').val(memberID);$('#AuthorName').val(memberName);}
	function setSearchTeam(teamID,teamName){$('#ownerTeamCode').val(teamID);$('#teamName').val(teamName);}

	function getAttrLovList(avg, avg2, avg3){ 
		var url    = "getSelectOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&sqlID=attr_SQL.selectAttrLovOption" //파라미터들					
					+"&s_itemID="+avg
					+"&itemID=${s_itemID}";
					
		var target = avg; // avg;             // selectBox id
		var defaultValue = avg2;              // 초기에 세팅되고자 하는 값
		var isAll  = "";                      // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}
	
	// [save] 이벤트 후 처리
	function goBack() {
		var instanceClass = "${instanceClass}";		
		
		var target = "PlmViewPjtDIV";
		var data = "instanceNo=${procInstanceInfo.ProcInstNo}"
					+"&instanceClass=${procInstanceInfo.InstanceClass}";
					
		var url = "plm_ViewProjectCharter.do";
		if(instanceClass == "ELM"){
			url = "plm_ViewProjectTask.do";
			var data = "instanceNo=${ElmInstNo}"
				+"&instanceClass=${instanceClass}";
		}
	 	ajaxPage(url, data, target);
	}
	
	//[Back] Click
	function selfClose() {
		goBack();
	}
	
	function fnGetSubAttrTypeCode(attrCode,subAttrCode,lovCode){ 
		if(subAttrCode != "" && subAttrCode != null){			
			var data = "languageID=${sessionScope.loginInfo.sessionCUrrLangType}&lovCode="+lovCode
			fnSelect(subAttrCode, data, 'getSubLovList', 'Select');
		}
	}

</script>

</head>
<div class="mgL5 mgR5" >
<form name="objectInfoFrm" id="objectInfoFrm" action="saveProcInstanceInfo.do" method="post" onsubmit="return false;">
<div class="child_search mgB10">
	<li class="shortcut">
	 	 <img src="${root}${HTML_IMG_DIR}/sc_Edit.png"></img>&nbsp;&nbsp;<b>${menu.LN00046}</b>
	</li>
	<li class="floatR pdR20">
	   <span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="saveObjInfoMain()" type="submit"></span>
	   <span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="goBack()" type="submit"></span>
	 </li>
</div>
<div id="objectInfoDiv" class="hidden" style="width:100%;overflow:auto;margin-bottom:5px;overflow-x:hidden;">
		<input type="hidden" id="s_itemID" name="s_itemID"  value="${s_itemID}" />
		<input type="hidden" id="option" name="option"  value="${option}" />		
		<input type="hidden" id="function" name="function" value="saveObjInfoMain">
		<input type="hidden" id="mLovAttrTypeCode" name="mLovAttrTypeCode" value="${mLovAttrTypeCode}" />
		
		<input type="hidden" id="processID" name="processID"  value="${procInstanceInfo.ProcessID}" />
		<input type="hidden" id="instanceNo" name="instanceNo"  value="${procInstanceInfo.ProcInstNo}" />
		<input type="hidden" id="instanceClass" name="instanceClass"  value="${instanceClass}" />
		
		<input type="hidden" id="elmItemID" name="elmItemID"  value="${elmItemID}" />
		<input type="hidden" id="ElmInstNo" name="ElmInstNo"  value="${ElmInstNo}" />
		<table style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview">	
			<colgroup>
				<col width="12%">
				<col width="38%">
				<col width="12%"> 	 	
				<col width="38%">			
			</colgroup>
			<tr>
				<!-- ID -->
				<th class="viewtop">${menu.LN00106}</th>
				<td class="viewtop pdL5 pdR5">
					<c:choose>
						<c:when test="${instanceClass eq 'PROC' }">${procInstanceInfo.ProcInstNo}</c:when>
						<c:when test="${instanceClass ne 'PROC' }">${ElmInstInfo.ElmInstNo}</c:when>
					</c:choose>
				</td>
				<!-- 명칭 -->
				<th class="viewtop">${menu.LN00028}</th>
				<td class="viewtop pdL5 pdR5">
					<c:choose>
						<c:when test="${instanceClass eq 'PROC' }">${procInstanceInfo.ItemName}</c:when>
						<c:when test="${instanceClass ne 'PROC' }">${ElmInstInfo.ElmInstName}</c:when>
					</c:choose>
				</td>
			</tr>		
					
			<tr>
			  <td colspan="4" class="hr1">&nbsp;</td>
			</tr>	
		</table>
				
		<!-- 여기부터 속성 edit -->
		<table style="table-layout:fixed;" class="tbl_preview" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="12%">
				<col width="38%">
				<col width="12%">
				<col width="38%">
			</colgroup>	
			<!-- AttrList is null -->
			<c:if test="${fn:length(attrList) eq 0 }">
				<tr>
					<td  class="alignC" colspan = 4>
						 No attribute type allocated 
					</td>
				</tr>
			</c:if>
			
			<!-- AttrList is not null -->
			<!-- First Attr Value-->			
			<c:forEach var="i" items="${attrList}" varStatus="iStatus">
					<c:if test="${i.editYN ne '1'}">
						<input type="hidden" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" value="${i.PlainText}"/>					
					</c:if>
					<c:if test="${i.editYN eq '1'}">			
					<tr>	
					<c:choose>
						<c:when test="${iStatus.count eq 1 }">					
							<th class="alignC">
								<c:if test="${i.Mandatory eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${i.Name}
							</th>
							<td  class="alignL pdL10"
							<c:if test="${i.ColumnNum eq null || i.ColumnNum ne 1 }">colspan="3"</c:if>
							>
						</c:when>
						<c:when test="${iStatus.count ne 1 }">					
							<th class="alignC">
								<c:if test="${i.Mandatory eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${i.Name}
							</th>
							<td  class="tit"
							<c:if test="${i.ColumnNum eq null || i.ColumnNum ne 1 }">colspan="3"</c:if>
							>
						</c:when>					
					</c:choose>					
					
					<!-- Attr Type :: Text, Date, URL, Select(Have Lov Code) -->
					<!-- IF Type Text HTML USE(1) WHEN TEXTAREA or NotUse THEN TEXT -->			
					<c:choose>
					<c:when test="${i.DataType eq 'Text'}">	
							<c:choose>
								<c:when test="${i.HTML eq '1'}">
									<script type="text/javascript">
										tinyMCE.EditorManager.execCommand('mceRemoveEditor', false, "${i.AttrTypeCode}");
									</script>
									<div style="width:100%;height:${i.RowHeight}px;">
										<textarea class="tinymceText" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" >${i.PlainText}</textarea>
									</div>
								</c:when>
								<c:when test="${i.HTML ne '1'}">
									<textarea class="edit" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" style="width:99%;height:${i.RowHeight}px;">${i.PlainText}</textarea>
								</c:when>
							</c:choose>
					</c:when>
					<c:when test="${i.DataType eq ''}">	
						<c:choose>
							<c:when test="${i.HTML eq '1'}">
								<div style="width:100%;height:40px;">
									<textarea class="tinymceText" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" >${i.PlainText}</textarea>
								</div>
							</c:when>
							<c:when test="${i.HTML ne '1'}">
								<input type="text" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" value="${i.PlainText}" class="text">
							</c:when>
						</c:choose>
					</c:when>
					<c:when test="${i.DataType eq 'LOV'}">			
						<select id="${i.AttrTypeCode}" name="${i.AttrTypeCode}"  class="sel" OnChange="fnGetSubAttrTypeCode('${i.AttrTypeCode}','${i.SubAttrTypeCode}',this.value);" ></select>
					<script>
						getAttrLovList('${i.AttrTypeCode}','${i.LovCode}', '${i.SubAttrTypeCode}');
					</script>					 
					</c:when>
					<c:when test="${i.DataType eq 'MLOV'}">
						<input type="hidden" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" />
						 <c:forEach var="mLovList" items="${i.mLovList}" varStatus="status">				 
						 <input type="checkbox" id="${mLovList.AttrTypeCode}${mLovList.CODE}" name="${mLovList.AttrTypeCode}${mLovList.CODE}" value="${mLovList.CODE}"
						 <c:if test="${mLovList.LovCode == mLovList.CODE}" > checked </c:if>>&nbsp;${mLovList.NAME} &nbsp;&nbsp;
						 </c:forEach>			 
					</c:when>
					<c:when test="${i.DataType eq 'Date'}">
					<!-- 2013-11-15 Datapicker확인중 -->
					<ul>
						<li>
							<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
							 <input type="text" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" value="${i.PlainText}"	class="text datePicker" size="8"
									style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
							
						</li>
					</ul>
					</c:when>
					</c:choose>			
					</td>
						
					<!-- 두번째 컬럼 START  -->
					<c:if test="${i.ColumnNum2 eq '2'}"> 
					<c:choose>
						<c:when test="${iStatus.count eq 1 }">					
							<th class="alignC">
								<c:if test="${i.Mandatory2 eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${i.Name2}
							</th>
							<td  class="alignL pdL10">
						</c:when>
						<c:when test="${iStatus.count ne 1 }">					
							<th class="alignC">
								<c:if test="${i.Mandatory2 eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${i.Name2}
							</th>
							<td  class="tit">
						</c:when>					
					</c:choose>					
					
					<!-- Attr Type :: Text, Date, URL, Select(Have Lov Code) -->
					<!-- IF Type Text HTML USE(1) WHEN TEXTAREA or NotUse THEN TEXT -->			
					<c:choose>
					<c:when test="${i.DataType2 eq 'Text'}">	
							<c:choose>
								<c:when test="${i.HTML2 eq '1'}">
									<script type="text/javascript">
										tinyMCE.EditorManager.execCommand('mceRemoveEditor', false, "${i.AttrTypeCode}");
									</script>
									<div style="width:100%;height:${i.RowHeight2}px;">
										<textarea class="tinymceText" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" >${i.PlainText2}</textarea>
									</div>
								</c:when>
								<c:when test="${i.HTML2 ne '1'}">
									<textarea class="edit" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" style="width:100%;height:${i.RowHeight2}px;">${i.PlainText2}</textarea>
								</c:when>
							</c:choose>
					</c:when>
					<c:when test="${i.DataType2 eq ''}">	
						<c:choose>
							<c:when test="${i.HTML2 eq '1'}">
								<div style="width:100%;height:40px;">
									<textarea class="tinymceText" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" >${i.PlainText2}</textarea>
								</div>
							</c:when>
							<c:when test="${i.HTML2 ne '1'}">
								<input type="text" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" value="${i.PlainText2}" class="text">
							</c:when>
						</c:choose>
					</c:when>
					<c:when test="${i.DataType2 eq 'LOV'}">		
						<select id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}"  class="sel" OnChange=fnGetSubAttrTypeCode('${i.AttrTypeCode2}','${i.SubAttrTypeCode2}',this.value);></select>
						<script>
							getAttrLovList('${i.AttrTypeCode2}','${i.LovCode2}','${i.SubAttrTypeCode2}');
						</script>					 
					</c:when>
					<c:when test="${i.DataType2 eq 'MLOV'}">
						<input type="hidden" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" />
						 <c:forEach var="mLovList2" items="${i.mLovList2}" varStatus="status">				 
						 <input type="checkbox" id="${mLovList2.AttrTypeCode}${mLovList2.CODE}" name="${mLovList2.AttrTypeCode}${mLovList2.CODE}" value="${mLovList2.CODE}"
						 <c:if test="${mLovList2.LovCode == mLovList2.CODE}" > checked </c:if>>&nbsp;${mLovList2.NAME} &nbsp;&nbsp;
						 </c:forEach>			 
					</c:when>		
					
					<c:when test="${i.DataType2 eq 'Date'}">
					<!-- 2013-11-15 Datapicker확인중 -->
					<ul>
						<li>
							<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
							 <input type="text" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" value="${i.PlainText2}"	class="text datePicker" size="8"
									style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
							
						</li>
					</ul>
					</c:when>
					</c:choose>			
					</td>	
					</c:if> 
					<!-- 두번째 컬럼 END  -->
									
					</tr>
				</c:if>		
			</c:forEach>

		</table>			

</div>	
</form>	
</div>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
	
