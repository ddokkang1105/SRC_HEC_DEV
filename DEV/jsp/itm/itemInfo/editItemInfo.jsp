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

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<head>
<title>${ClassName} : ${OwnerTeamName}</title>

<script type="text/javascript">
	var chkReadOnly = false;
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
 
<script type="text/javascript">

	$(document).ready(function(){		
		$("input.datePicker").each(generateDatePicker);
		document.getElementById('objectInfoDiv').style.height = (setWindowHeight() - 140)+"px";			
		window.onresize = function() {
			document.getElementById('objectInfoDiv').style.height = (setWindowHeight() - 160)+"px";	
		};
		
		if("${autoID}" == "Y"){
			$("#Identifier").attr('disabled',true);
		}else{
			$("#Identifier").attr('disabled',false);
		}
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
				  AttrTypeValue = new Array;
				    mLovCodeValue = new Array;
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
			
			var url = "saveObjectInfo.do";	
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
		var url = "NewItemInfoMain.do";
		var target = "actFrame";
		var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&varFilter=${showVersion}"; 
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
	
	function searchPopupWf(avg){
		var searchValue = $("#ZAT4015").val();
		var url = avg + "&searchValue="+encodeURIComponent(searchValue)
		+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		
		window.open(url,'window','width=340, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSearchNameWf(avg1,avg2,avg3,avg4,avg5,avg6,avg7){
		$("#ZAT4015").val(avg2+"("+avg3+")");
		$("#ZAT4015_ID").val(avg1);
	}

</script>

</head>

<body>
<form name="objectInfoFrm" id="objectInfoFrm" enctype="multipart/form-data" action="saveObjectInfo.do" method="post" onsubmit="return false;">
<div class="child_search mgB10">
	<li class="floatR pdR20">
	   <span class=" btn_pack nobg"><a class="save" onclick="saveObjInfoMain()" title="Save"> </a></span>
	 </li>
	<span class="flex align-center">
			<span class="back" onclick="goBack()"><span class="icon arrow"></span></span>
	  <b>${menu.LN00046}</b>
	  </span>
</div>
<div id="objectInfoDiv" class="hidden" style="width:100%;overflow:auto;margin-bottom:5px;overflow-x:hidden;">
		<input type="hidden" id="s_itemID" name="s_itemID"  value="${s_itemID}" />
		<input type="hidden" id="option" name="option"  value="${option}" />		
		<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />		
		<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />		
		<input type="hidden" id="AuthorID" name="AuthorID" value="${getList.AuthorID}" />
		<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="${getList.OwnerTeamID}" />			
		<input type="hidden" id="sub" name="sub" value="${sub}" />
		<input type="hidden" id="function" name="function" value="saveObjInfoMain">
		<input type="hidden" id="mLovAttrTypeCode" name="mLovAttrTypeCode" value="${mLovAttrTypeCode}" />
		<input type="hidden" id="csrID" name="csrID"  value="${getList.ProjectID}" />
		<table style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0" border="0" class="tbl_preview">	
			<colgroup>
				<col width="12%">
				<col width="16%">
				<col width="12%">
				<col width="32%">
				<col width="12%">
				<col width="16%">				
			</colgroup>
			<tr>
				<!-- ID -->
				<th class="viewtop">${menu.LN00106}</th>
				<td class="viewtop pdL5 pdR5"><input type="text" class="text" id="Identifier" name="Identifier"  value="${getList.Identifier}"/></td>
				<!-- 명칭 -->
				<th class="viewtop">${menu.LN00028}</th>
				
				<td class="viewtop pdL5 pdR5"><input type="text" class="text" id="AT00001" name="AT00001"  value="${AttrInfo.AT00001}"/></td>
				<!-- 계층 -->
				<th class="viewtop">${menu.LN00016}</th>
				<td class="viewtop">
					<select id="classCode" name="classCode" class="sel">
						<c:forEach var="i" items="${classOption}">
							<option value="${i.ItemClassCode}" <c:if test="${ getList.ClassName == i.Name}">selected="selected"</c:if> >${i.Name}</option>						
						</c:forEach>				
						</select>
				</td>			
			</tr>		
			<tr>				
			<tr>
			  <td colspan="6" class="hr1">&nbsp;</td>
			 </tr>	
		</table>
		<!-- 여기부터 속성 edit -->
		<table style="table-layout:fixed;" class="tbl_preview" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="12%">
				<col>
				<col width="12%">
				<col>
			</colgroup>	
			<!-- AttrList is null -->
			<c:if test="${fn:length(getAttrList) eq 0 }">
				<tr>
					<td  class="alignC" colspan = 4>
						 No attribute type allocated 
					</td>
				</tr>
			</c:if>
			<!-- AttrList is not null -->
			<!-- First Attr Value-->			
			<c:forEach var="i" items="${getAttrList}" varStatus="iStatus">
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
									<!-- <script type="text/javascript">
										tinyMCE.EditorManager.execCommand('mceRemoveEditor', false, "${i.AttrTypeCode}");
									</script> -->
									<div style="width:100%;height:${i.AreaHeight}px;">
										<textarea class="tinymceText" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" >${i.PlainText}</textarea>
									</div>
								</c:when>
								<c:when test="${i.HTML ne '1'}">
									<textarea class="edit" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" style="width:99%;height:${i.AreaHeight}px;">${i.PlainText}</textarea>
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
						<li style="position:relative;">
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
									<!-- <script type="text/javascript">
										tinyMCE.EditorManager.execCommand('mceRemoveEditor', false, "${i.AttrTypeCode}");
									</script> -->
									<div style="width:100%;height:${i.AreaHeight2}px;">
										<textarea class="tinymceText" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" >${i.PlainText2}</textarea>
									</div>
								</c:when>
								<c:when test="${i.HTML2 ne '1'}">
									<c:choose>
										<c:when  test="${i.AttrTypeCode2 eq 'ZAT4015'}" >
											<input type="text" class="text" id="ZAT4015" name="ZAT4015" style="ime-mode:active;width:78%;height:${i.AreaHeight2}px;border-radius: 3px;" value="${ZAT4015Info.MemberName}" />
			 			
								 			<input type="image" class="image pdL5" id="searchMemberBtn" name="searchMemberBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" style="height:25px;padding-top:5px;" onclick="searchPopupWf('searchPluralNamePop.do?objId=memberID&objName=memberName&UserLevel=ALL')" value="Search" />
											<input type="hidden" id="ZAT4015_ID" name="ZAT4015_ID" value="${ZAT4015Info.MemberID}"/>
										</c:when>
										<c:otherwise>
											<textarea class="edit" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" style="width:100%;height:${i.AreaHeight2}px;">${i.PlainText2}</textarea>
										</c:otherwise>
									</c:choose>
									
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
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
</body>
	
