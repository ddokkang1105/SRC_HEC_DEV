<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>


<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/jquery.timepicker.css"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00016" var="CM00016"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00054" var="CM00054"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00056" var="CM00056"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00274}"/> <!-- 도메인 입력 체크 -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00185}"/> <!-- 시스템 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="${menu.LN00272}"/> <!-- 카테고리 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_4" arguments="${menu.LN00273}"/> <!-- 서브카테고리 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_6" arguments="Comment"/> <!-- Comment 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_7" arguments="${menu.LN00221}"/> <!-- 완료예정일  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00063" var="CM00063"/>
<style>
	.dhx_navbar {
		border-bottom: 1px solid #777;
		padding-bottom: 15px;
	}
	.dhx_window-content {
		color: #000;
	}
</style>
<script type="text/javascript">
	var fileSize = "${itemFiles.size()}";
	var scrnType = "${scrnType}";
	var srType = "${srType}";
	var srArea1ListSQL = "${srArea1ListSQL}";
	var customerNo = "${srInfoMap.ClientID}";
	var srAre1 = "${srInfoMap.SRArea1}"
	
	// select list 용 parameter
	var selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&esType=${esType}&customerNo=" + customerNo;

	jQuery(document).ready(function() {
		
		// 00. input type setting
		$("input.datePicker").each(generateDatePicker);
		$('#dueDateTime').timepicker({
            timeFormat: 'H:i:s',
        });
		
		// 01. select option setting
		if(srArea1ListSQL == null || srArea1ListSQL == "") srArea1ListSQL = "getESMSRArea1";
		fnSelectSetting();
		
  		// 02. category change event
  		$("#category").on("change", function(){
  			var category = $("#category").val();
  			fnGetSubCategory(category);
  		});
  		
  		// 03. subCategory change event
  		$("#subCategory").on("change", function(){
  			var subCategory = $("#subCategory").val();
  			//fnGetSRArea1(subCategory);
  		});

  		// 04. srArea1 change event
  		$("#srArea1").on("change", function(){
  			var srArea1 = $("#srArea1").val();
  			fnGetSRArea2(srArea1);
  		});

	});
	
	/*** SR Select function start ***/
	function fnSelectSetting() {
		// 00. reset
		resetSelect();
		// 01. category setting
		fnSelect('category', selectData +"&srType=${srType}&level=1", 'getESPSRCategory', '${srInfoMap.Category}', 'Select','esm_SQL');
		fnGetSubCategory('${srInfoMap.Category}');
		// 02. srArea
		fnGetSRArea1('${srInfoMap.Category}');
		fnGetSRArea2('${srInfoMap.SRArea1}')
	}

	// subCategory setting ( * customerNo / category )
	function fnGetSubCategory(parentID){
		if(parentID == ''){
			$("#subCategory option").not("[value='']").remove();
		} else {
			fnSelect('subCategory', selectData + "&srType=${srType}&parentID="+parentID, 'getESPSRCategory', '${srInfoMap.SubCategory}', 'Select', 'esm_SQL');
		}
	}
	
	// srArea1 setting ( * customerNo / subCategory )
	function fnGetSRArea1(category){
		if(category == ''){
			$("#srArea1 option").not("[value='']").remove();
		}else{
			fnSelect('srArea1', selectData + "&category=" + category + "&srType=${esType}", srArea1ListSQL, '${srInfoMap.SRArea1}', 'Select','esm_SQL');
			fnGetSRArea2('');
		}
	}
	
	// srArea2 setting ( * customerNo / srArea1 )
	function fnGetSRArea2(SRArea1ID){
		if(SRArea1ID == ''){
			$("#srArea2 option").not("[value='']").remove();
		}else{
			fnSelect('srArea2', selectData+ "&parentID="+SRArea1ID + "&srType=${esType}", 'getSrArea2','${srInfoMap.SRArea2}', 'Select');
		}
	}
	
	// select option reset
	function resetSelect(){
		$("#srArea1").val("");
		$("#srArea2").val("");
		$("#category").val("");
		$("#subCategory").val("");
		return;
	}
	/*** SR Select function end ***/
	
	/*** SR Button function start ***/
	// [Receive]
	function fnReceive(url,varFilter){
		if(!confirm("${CM00001}")){ return;}

		var subCategory = $("#subCategory").val();
		var comment = tinyMCE.get('comment').getContent();
		
		if(subCategory == ""){ alert("${WM00034_4}"); return false;}
		if(comment == ""){ alert("${WM00034_6}"); return false;}
		
		ajaxSubmit(document.receiptSRFrm, url,"saveFrame");
	}
	function fnCheckValidation(){
		var isCheck = true;
		
		var subCategory = $("#subCategory").val() ;
		var comment = tinyMCE.get('comment').getContent();
		var dueDate = $("#dueDate").val() ; 
		if(subCategory == ""){ alert("${WM00034_4}"); isCheck = false; return isCheck;}
		if(comment == ""){ alert("${WM00034_6}"); isCheck = false; return isCheck;}
		if(dueDate == ""){ alert("${WM00034_7}"); isCheck = false; return isCheck;}

		return isCheck;
	}

	var searchData = "srType=${srType}"
					+"&esType=${esType}"
					+"&scrnType=${scrnType}"
					+"&srMode=${srMode}"
					+ "&status=${status}"
					+ "&category=${category}"
					+ "&subCategory=${subCategory}"
					+ "&srArea1=${srArea1}"
					+ "&srArea2=${srArea2}"
					+ "&customerNo=${customerNo}"
					+ "&subject=${subject}"
					+ "&receiptUser=${receiptUser}"
					+ "&requestUser=${requestUser}"
					+ "&requestTeam=${requestTeam}"
					+ "&regStartDate=${regStartDate}"
					+ "&regEndDate=${regEndDate}"
					+ "&searchSrCode=${searchSrCode}"
					+ "&stSRDueDate=${stSRDueDate}"
					+ "&endSRDueDate=${endSRDueDate}"
					+ "&srReceiptTeam=${srReceiptTeam}"
					+ "&searchStatus=${searchStatus}"
					+ "&srStatus=${srStatus}"
					+ "&srCode=${srCode}"
					+ "&srArea1ListSQL=${srArea1ListSQL}";
	
	// [LIST]
	function fnGoSRList(){
		var url = "espList.do";
		var target = "mainLayer"; 
		ajaxPage(url, searchData, target);
	}
	
	// [Save]
	function fnSaveInfo(){
		var comment = tinyMCE.get('comment').getContent();
		if(comment == ""){ alert("${WM00034_6}"); return false;}
		
		$('#srMode').val('N');
		$('#srLogType').val('N');
		
		var priority = $("#priority").val() ; if(priority == ""){ $("#priority").val("03")}
		var url  = "updateESPInfo.do";
		ajaxSubmit(document.receiptSRFrm, url,"saveFrame");
	}

	// [Review]
	function fnReqITSApproval(url,varFilter,status){
		url += "?srID=${srInfoMap.SRID}&docSubClass=${srType}"
				+ "&WFDocURL=${WFDocURL}&ProjectID=${srInfoMap.ProjectID}"
				+ "&srArea1=${srInfoMap.SRArea1}"
				+ "&srArea2=${srInfoMap.SRArea2}"
				+ "&srRequestUserID=${srInfoMap.RequestUserID}"
				+ "&isPop=Y&blockSR=Y&wfDocType=SR&actionType=create"
				+ "&speCode=" + status + varFilter;
		window.open(url,'window','width=1000, height=700, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	// [SRUpdateMaster / PGR00007]
	function fnSRUpdateMaster(url,varFilter){
		url += "?srID=${srInfoMap.SRID}" + varFilter;
		ajaxSubmit(document.receiptSRFrm, url,"saveFrame");
	}
	
	// [Complete]
	function fnCompletion(url,varFilter){		
		if(!confirm("${CM00054}")){ return;}
		if(!fnCheckValidation()){return;}
		url  += "?" + varFilter;
		ajaxSubmit(document.receiptSRFrm, url,"saveFrame");
	}
	
	// [참조]
	function addSharer(){
		var sharers = $("#sharers").val();
		var url = "selectMemberPop.do?mbrRoleType=R&projectID=${projectID}&s_memberIDs="+sharers;
		window.open(url,"","width=900 height=700");					
	}
	function setSharer(memberIds,memberNames) {
		$("#sharers").val(memberIds);
		$("#sharerNames").val(memberNames);
	}
	
	// [Create SCR]
	function fnRegisterSCR(url,varFilter){
		url += "?srID=${srInfoMap.SRID}" + varFilter;
		var w = 1100;
		var h = 650;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	
	// [Self Checkout]
	function fnSelfCheckOut(){		
		if(!confirm("${CM00054}")){ return;}
		var url  = "selfCheckOutESP.do?srID=${srID}";
		$("#srMode").val("N");
		$("#srLogType").val("P");
		ajaxSubmit(document.receiptSRFrm, url,"saveFrame");
	}
	
	/*** SR Button function end ***/

	/*** SR callback function start ***/
	function fnCallBackSR(){
		var url = "processRFCP.do";
		var data = searchData += "&srID=${srInfoMap.SRID}&receiptUserID=${srInfoMap.ReceiptUserID}";
		var target = "mainLayer";
		ajaxPage(url, data, target);
	}
	
	function fnReload(){
		fnCallBackSR();
	}
	
	function fnCallBack(){
		fnCallBackSR();
	}
	
	function fnViewScrDetail(scrID){
		var screenMode = "V";
		var url = "viewScrDetail.do";
		var data = "scrID="+scrID+"&screenMode="+screenMode+"&srID=${srInfoMap.SRID}"; 
		var w = 1100;
		var h = 800;
		window.open(url+"?"+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
		
		fnCallBackSR();
	}
	/*** SR callback function end ***/
	
	
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
	
	function fnSearchMemberPop(attrTypeCode){

		var url = "selectMemberPop.do?mbrRoleType=ATTRMBR&projectID=${projectID}&attrTypeCode="+attrTypeCode;
		window.open(url,"","width=900 height=700");					
	}
	
	function setAttrMbr(memberIds,memberNames,teamIds,attrTypeCode) {
		$("#"+attrTypeCode+"_Text").val(memberNames);
		$("#"+attrTypeCode).val(memberIds);
	}
	
</script>

<div id="processSRDIV"> 
	<form name="receiptSRFrm" id="receiptSRFrm" enctype="multipart/form-data" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="scrnType" name="scrnType" value="${scrnType}">
	<input type="hidden" id="srMode" name="srMode" value="${srMode}">
	<input type="hidden" id="srType" name="srType" value="${srType}">
	<input type="hidden" id="srID" name="srID" value="${srInfoMap.SRID}">
	<input type="hidden" id="srCode" name="srCode" value="${srInfoMap.SRCode}">
	<input type="hidden" id="receiptUserID" name="receiptUserID" value="${srInfoMap.ReceiptUserID}">
	<input type="hidden" id="receiptTeamID" name="receiptTeamID" value="${srInfoMap.ReceiptTeamID}">
	<input type="hidden" id="requestUserID" name="requestUserID" value="${srInfoMap.RequestUserID}">
	<input type="hidden" id="requestTeamID" name="requestTeamID" value="${srInfoMap.RequestTeamID}">
	<input type="hidden" id="subject" name="subject" value="${srInfoMap.Subject}">
	<input type="hidden" id="status" name="status" value="">
	<input type="hidden" id="srRoleTP" name="srRoleTP" value="${srInfoMap.ProcRoleTP}" >
	<input type="hidden" id="srLogType" name="srLogType" value="" />
	
	<div class="cop_hdtitle">
		<h3 style="padding: 8px 0"><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>&nbsp;${menu.LN00282}</h3>
	</div>
	<table class="tbl_brd" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="10%">
		    <col width="23%">
		 	<col width="10%">
		    <col width="23%">
		</colgroup>		
		<tr>
			<!-- 제목 -->
			<th class="alignL pdL10">${menu.LN00002}</th>
			<td class="sline tit last" id="subject">${srInfoMap.Subject}</td>	
			<!-- 요청자 -->
			<th class="alignL pdL10" >${menu.LN00025}</th>
			<td class="sline tit last" >${srInfoMap.ReqUserNM}(${srInfoMap.ReqTeamNM}/${srInfoMap.CompanyName})</td>
		</tr>	
		<tr>
			<td colspan="4" class="tit last"><div style="height:230px; overflow: auto;" >${srInfoMap.Description}</div></td>
		</tr>
		<tr>	
			<!-- SR No -->
			<th class="alignL pdL10">SR No.</th>
			<td class="sline tit last">${srInfoMap.SRCode}</td>
			<!-- 완료예정일 -->
			<th class="alignL pdL10">${menu.LN00221}</th>
			<td class="sline tit last" >
				<c:if test="${srInfoMap.DueDate !=  null}" >
					<input type="text" id="dueDate" name="dueDate" value="${srInfoMap.DueDate}"	class="input_off datePicker stext" size="8"
						style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
					<input type="text" id="dueDateTime" name="dueDateTime" value="${srInfoMap.DueDateTime}" class="input_off text" size="8" style="width:40%; text-align: center;" maxlength="10">
				</c:if>
				<c:if test="${srInfoMap.DueDate ==  null}" >
					<input type="text" id="dueDate" name="dueDate" value="${srInfoMap.ReqDueDate}" class="input_off datePicker stext" size="8"
						style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
					<input type="text" id="dueDateTime" name="dueDateTime" value="${srInfoMap.ReqDueDateTime}" class="input_off text" size="8" style="width:40%; text-align: center;" maxlength="10">
				</c:if>
			</td>	
		</tr>
		<tr>
			<th class="alignL pdL10">프로세스 명</th>
			<td class="sline tit last">${srInfoMap.SRTypeName}</td>	
			<!-- SR status -->		
			<th class="alignL pdL10">${menu.LN00065}</th>
			<td class="sline tit last alignL " >
				<c:choose>
					<c:when test="${fn:length(procStatusList) > 0}">
						<c:forEach var="list" items="${procStatusList}" varStatus="statusList">	
						<c:choose>					
								<c:when test="${list.TypeCode == srInfoMap.Status && list.RNUM == prSeq }">
									<span style="font-weight:bold;color:blue;font-size:14px;">${list.StsName}&nbsp;</span>				
								</c:when>
								<c:otherwise>				
									<span style="font-weight:;color:gray;">${list.StsName}&nbsp;</span>				
								</c:otherwise>				  
						</c:choose>	
						<c:if test="${statusList.last != true}">
							>&nbsp;
						</c:if>
						</c:forEach>
					</c:when>
					<c:otherwise>
						${srInfoMap.SRStatusName}
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<c:choose>
			<c:when test="${srInfoMap.Status eq 'SPE001'}">
				<tr>
					<!-- 카테고리 -->
					<th class="alignL pdL10">${menu.LN00272}</th>
					<td class="sline tit last">
						<select id="category" name="category" class="sel"  style="width:90%;"></select>
					</td>
					<!-- 서브카테고리 -->
					<th class="alignL pdL10">${menu.LN00273}</th>
					<td class="sline tit last">
						<select id="subCategory" name="subCategory" class="sel" style="width:90%;"></select>
					</td>
				 </tr>
				<tr>
					<!-- SR Area 1 -->
					<th class="alignL pdL10">${srInfoMap.SRArea1NM}</th>
					<td class="sline tit last" >
						<select id="srArea1" Name="srArea1"  style="width:90%"> <option value=''>Select</option></select>
					</td>		
					<!-- SR Area 2 -->
					<th class="alignL pdL10">${srInfoMap.SRArea2NM}</th>
					<td class="sline tit last" >
						<select id="srArea2" Name="srArea2"  style="width:90%"> <option value=''>Select</option></select>
					</td>
				</tr>
			</c:when>
			<c:otherwise>
				<tr>
					<!-- 카테고리 -->
					<th class="alignL pdL10">${menu.LN00272}</th>
					<td class="sline tit last">${srInfoMap.CategoryName eq null ? 'N/A' : srInfoMap.CategoryName}</td>
					<!-- 서브카테고리 -->
					<th class="alignL pdL10">${menu.LN00273}</th>
					<td class="sline tit last">${srInfoMap.SubCategoryName eq null ? 'N/A' : srInfoMap.SubCategoryName}</td>
				</tr>
				
				<tr>
					<!-- SRARea 1 -->
					<th class="alignL pdL10">${srInfoMap.SRArea1NM}</th>
					<td class="sline tit last" >${srInfoMap.SRArea1Name eq null ? 'N/A' : srInfoMap.SRArea1Name}</td>
					<!-- SR Area 2 -->
					<th class="alignL pdL10">${srInfoMap.SRArea2NM}</th>
					<td class="sline tit last" >${srInfoMap.SRArea2Name eq null ? 'N/A' : srInfoMap.SRArea2Name}</td>
				</tr>
			</c:otherwise>
		</c:choose>	
	</table>
	
	
	<!-- comment 테이블 -->
	<table class="tbl_brd mgT5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0" border="0">
		<colgroup>
			<col width="10%">
			<col>
		</colgroup>		
		<tr>
		  	<th class="alignL pdL10">Comment</th>		  
			<td style="height:150px;" class="tit last alignL pdL5 pdR5">
				<div style="width:100%;height:150px;">
					<textarea class="tinymceText"  id="comment" name="comment" >${srInfoMap.Comment}</textarea>
				</div>
			</td>
		</tr>
	</table>
	<c:if test="${fn:length(srAttrList) ne 0 }"><br>
	<table style="table-layout:fixed;" class="tbl_brd" width="100%" border="0" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="10%">
			<col>
			<col width="10%">
			<col>
		</colgroup>	
		<!-- First Attr Value-->			
		<c:forEach var="i" items="${srAttrList}" varStatus="iStatus">
			<c:if test="${i.Editable ne '1'}">
				<input type="hidden" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" value="${i.PlainText}"/>					
			</c:if>
			<c:if test="${i.Editable eq '1'}">			
			<tr>	
			<c:choose>
				<c:when test="${iStatus.count eq 1 }">					
				<th class="alignC">
				<c:if test="${i.Mandatory eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${i.Name}
				</th>
					<td  class="alignL pdL10 last"
					<c:if test="${i.ColumnNum eq null || i.ColumnNum ne 1 }">colspan="3"</c:if>
					>
					</c:when>
					<c:when test="${iStatus.count ne 1 }">					
					<th class="alignC">
						<c:if test="${i.Mandatory eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${i.Name}
					</th>
					<td  class="tit last"
					<c:if test="${i.ColumnNum eq null || i.ColumnNum ne 1 }">colspan="3"</c:if>
					>
					</c:when>					
					</c:choose>					
					
					<c:choose>
					<c:when test="${i.DataType eq 'Text'}">	
						<c:choose>
						<c:when test="${i.HTML eq '1'}">
							<div style="width:100%;height:${i.AreaHeight}px;">
								<textarea class="tinymceText" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" >${i.PlainText}</textarea>
							</div>
						</c:when>
						<c:when test="${i.HTML ne '1'}">
							<div style="width:99%;height:${i.AreaHeight}px;">
								<textarea class="edit" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" >${i.PlainText}</textarea>
							</div>
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
					<ul>
						<li>
							<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
							 <input type="text" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" value="${i.PlainText}"	class="text datePicker" size="8"
									style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
							
						</li>
					</ul>
					</c:when>
					
					<c:when  test="${i.DataType eq 'MBR'}" >
						<input type="text" class="text" id="${i.AttrTypeCode}_Text" name="${i.AttrTypeCode}_Text" style="ime-mode:active;width:78%;height:${i.AreaHeight}px;border-radius: 3px;" value="${i.PlainText}" readOnly />
		
			 			<input type="image" class="image pdL5" id="searchMemberBtn" name="searchMemberBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" style="height:25px;padding-top:5px;" onclick="fnSearchMemberPop('${i.AttrTypeCode}')" value="Search" />
						<input type="hidden" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" value="${i.PlainText}"/>
					</c:when>
					
					</c:choose>			
					</td>
						
					<c:if test="${i.ColumnNum2 eq '2'}"> 
					<c:choose>
						<c:when test="${iStatus.count eq 1 }">					
							<th class="alignC">
								<c:if test="${i.Mandatory2 eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${i.Name2}
							</th>
							<td  class="alignL pdL10 last">
						</c:when>
						<c:when test="${iStatus.count ne 1 }">					
							<th class="alignC">
								<c:if test="${i.Mandatory2 eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${i.Name2}
							</th>
							<td  class="tit last">
						</c:when>					
					</c:choose>					
						
					<c:choose>
					<c:when test="${i.DataType2 eq 'Text'}">	
						<c:choose>
						<c:when test="${i.HTML2 eq '1'}">
							<div style="width:100%;height:${i.AreaHeight2}px;">
								<textarea class="tinymceText" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" >${i.PlainText2}</textarea>
							</div>
						</c:when>
						<c:when test="${i.HTML2 ne '1'}">
							<c:choose>
							<c:when  test="${i.AttrTypeCode2 eq 'ZAT4015'}" >
								<input type="text" class="text" id="ZAT4015" name="ZAT4015" style="ime-mode:active;width:78%;height:${i.AreaHeight2}px;border-radius: 3px;" value="${ZAT4015Info.MemberName}" />
			 					<input type="image" class="image pdL5" id="searchMemberBtn" name="searchMemberBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" style="height:25px;padding-top:5px;" onclick="fnSearchMemberPop('${i.AttrTypeCode}')" value="Search" />
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
						<select id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}"  class="sel" OnChange="fnGetSubAttrTypeCode('${i.AttrTypeCode2}','${i.SubAttrTypeCode2}',this.value);"></select>
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
					<ul>
						<li>
							<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
							 <input type="text" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" value="${i.PlainText2}"	class="text datePicker" size="8"
									style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
							
						</li>
					</ul>
					</c:when>
					
					<c:when  test="${i.DataType2 eq 'MBR'}" >
						<input type="text" class="text" id="${i.AttrTypeCode2}_Text" name="${i.AttrTypeCode2}_Text" style="ime-mode:active;width:78%;height:${i.AreaHeight2}px;border-radius: 3px;" value="${i.PlainText2}" readOnly/>
		
			 			<input type="image" class="image pdL5" id="searchMemberBtn" name="searchMemberBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" style="height:25px;padding-top:5px;" onclick="fnSearchMemberPop('${i.AttrTypeCode2}')" value="Search" />
						<input type="hidden" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" value="${i.PlainText2}"/>
					</c:when>
										
					</c:choose>			
					</td>	
					</c:if> 
					</tr>
				</c:if>		
			</c:forEach>			
		</table>
	</c:if>
	<!-- 첨부문서 & 참조 테이블  -->
	<table class="tbl_brd mgT5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="10%">
			<col>
			<col width="10%">
			<col>
		</colgroup>	
		<tr>
			<!-- 첨부문서 -->
			<th class="alignL pdL10" style="height:53px;">${menu.LN00111}</th>
			<td colspan="3" style="height:53px;" class="alignL pdL5 last">
				<div style="height:53px;width:100%;overflow:auto;overflow-x:hidden;">
				<div id="tmp_file_items" name="tmp_file_items"></div>
				<div class="floatR pdR20" id="divFileImg">
				<c:if test="${SRFiles.size() > 0}">
					<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('attachFileCheck', 'Y')"></span><br>
					<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('attachFileCheck', 'N')"></span><br>
				</c:if>
				</div>
				<c:forEach var="fileList" items="${SRFiles}" varStatus="status">
					<div id="divDownFile${fileList.Seq}"  class="mm" name="divDownFile${fileList.Seq}">
						<input type="checkbox" name="attachFileCheck" value="${fileList.Seq}" class="mgL2 mgR2">
						<span style="cursor:pointer;" onclick="fileNameClick('${fileList.Seq}');">${fileList.FileRealName}</span>
						<c:if test="${sessionScope.loginInfo.sessionUserId == srInfoMap.RegUserID}">
						<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteSRFile('${fileList.SRID}','${fileList.Seq}','${fileList.FileName}','${srFilePath}');">
						</c:if>
						<br>
					</div>
				</c:forEach>
				</div>
			</td>
		</tr>
		<!-- 참조 -->
		<tr>
			<th class="alignL pdL10"><a onclick="addSharer();">${menu.LN00245}<img class="searchList mgL5" src="${root}${HTML_IMG_DIR}/btn_icon_sharer.png" style="cursor:pointer;"></a></th>
			<td class="sline tit last" colspan="3">
				<input type="text" class="text" id="sharerNames" name="sharerNames" value="${srSharerName}" readOnly style="border:0px;"/>			
				<input type="hidden" class="text" id="sharers" name="sharers" value="${srSharerID}" size="10"/>
			</td>
		</tr>	
	</table>
	
	<div class="alignBTN">
		
		<!-- [Attach] [Save] ::: 만족도 평가 단계가 아닐 때 가능  -->
	    <c:if test="${(srInfoMap.Status != 'SPE012' && srInfoMap.Status != 'SPE013')}" >
			<span class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="submit" onclick="doAttachFileV4();"></span>
			<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="fnSaveInfo()"></span>
		</c:if>
		<!-- [self CheckOut] :: 그룹원이 접수 -->
	   	<c:if test="${checkOutYN eq 'Y'}">
			<span class="btn_pack medium icon"><span class="confirm"></span><input value="self CheckOut" type="submit" onclick="fnSelfCheckOut()"></span>
		</c:if>
		
		<!-- ** EVENT BUTTON -->
		<c:forEach var="statusList" items="${nextStatusList}" varStatus="status">
		   	<!-- [Receive/접수] 다음 단계의 프로그램 ID = PG00001 (담당자 접수) && 다음 단계 != 마지막 단계  -->
			<c:if test="${statusList.SRNextSpePgrID eq 'PGR00001' && statusList.SRNextStatus ne srInfoMap.LastSpeCode }" >
				<span class="btn_pack medium icon"><span class="confirm"></span><input value="Receive" type="submit" onclick="fnReceive('${statusList.SRNextSpePgrURL}','${statusList.SRNextSpePgrVarFilter}')"></span>		
			</c:if>
		    
		    <!-- [Review/일반 심의] 다음 단계의 프로그램 ID = PG00003 && 다음 단계 != 마지막 단계  -->
			<c:if test="${statusList.SRNextSpePgrID eq 'PGR00003' && statusList.SRNextStatus ne srInfoMap.LastSpeCode }" >
				<span class="btn_pack medium icon"><span class="confirm"></span><input value="Review" type="submit" onclick="fnReqITSApproval('${statusList.SRNextSpePgrURL}','${statusList.SRNextSpePgrVarFilter}','${statusList.SRNextStatus}')"></span>		
			</c:if>
			
			<!-- [PGR00007/다음 단계] 다음 단계의 프로그램 ID = PG00007 && 다음 단계 != 마지막 단계  -->
			<c:if test="${statusList.SRNextSpePgrID eq 'PGR00007' && statusList.SRNextStatus ne srInfoMap.LastSpeCode }" >
				<span class="btn_pack medium icon"><span class="confirm"></span><input value="Next" type="submit" onclick="fnSRUpdateMaster('${statusList.SRNextSpePgrURL}','${statusList.SRNextSpePgrVarFilter}')"></span>		
			</c:if>
		    
			<!-- [Complete/완료] ::: 다음 단계의 프로그램 ID = PG00002 (ITS 조치완료) && 상태 != 완료   -->
			<c:if test="${statusList.SRNextSpePgrID eq 'PGR00002' && srInfoMap.SvcCompl eq 'N'}" >
				<span class="btn_pack medium icon"><span class="confirm"></span><input value="Complete" type="submit" onclick="fnCompletion('${statusList.SRNextSpePgrURL}','${statusList.SRNextSpePgrVarFilter}')"></span>
			</c:if>
			
			<!-- [Create SCR/SCR 생성] ::: 다음 단계의 프로그램 ID = PG00005 -->
			<c:if test="${statusList.SRNextSpePgrID eq 'PGR00005' && appBtn eq 'Y'}" >
				<span class="btn_pack medium icon"><span class="add"></span><input value="Create SCR" type="submit"  onclick="fnRegisterSCR('${statusList.SRNextSpePgrURL}','${statusList.SRNextSpePgrVarFilter}');" style="cursor:hand;"></span>	
			</c:if>
			
			<!-- [Request/만족도 평가 요청] ::: 다음 단계의 프로그램 ID = PG00004 (ITS 조치완료) && 상태 != 완료   -->
			<c:if test="${statusList.SRNextSpePgrID eq 'PGR00004' && srInfoMap.SvcCompl eq 'N'}" >
				<span class="btn_pack medium icon"><span class="confirm"></span><input value="Complete" type="submit" onclick="fnCompletion('${statusList.SRNextSpePgrURL}','${statusList.SRNextSpePgrVarFilter}')"></span>
			</c:if>
		</c:forEach>
		
		<c:if test="${scrnType ne 'cust' }" >
			<span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit"  onclick="fnGoSRList();"></span>
		</c:if>
		
	</div>
	
	</form>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>

<script>
//*************** addFilePop 설정 **************************//
	function fnDeleteSRFile(srID, seq, fileName, filePath){
		var url = "deleteSRFile.do";
		var data = "srID="+srID+"&Seq="+seq+"&realFile="+filePath+fileName;
		ajaxPage(url, data, "saveFrame");
		$('#divDownFile'+seq).remove();
	}
	
	//*************** addFilePop 설정 **************************//
	var fileIDMap = new Map();
	var fileNameMap = new Map();
	function fnDeleteFileHtml(seq, fileName){	
		if(fileName == "" || fileName == undefined){
			try{fileName = document.getElementById(seq).innerText;}catch(e){}
		}
		
		fileIDMap.delete(String(seq));
		fileNameMap.delete(String(seq));
		
		if(fileName != "" && fileName != null && fileName != undefined){
			$("#"+seq).remove();
			var url  = "removeFile.do";
			var data = "fileName="+fileName;
			ajaxPage(url,data,"blankFrame");
		}
	}
	
	function fnAttacthFileHtml(fileID, fileName){ 			
		fileIDMap.set(fileID,fileID);
		fileNameMap.set(fileID,fileName);
	}
	
	function fnDisplayTempFile(){
		var sampleTimestamp = Date.now(); //현재시간 타임스탬프 13자리 예)1599891939914
				
		display_scripts=$("#tmp_file_items").html(); 
		fileIDMap.forEach(function(fileID) {			  
			  display_scripts = display_scripts+
				'<div id="'+fileID+sampleTimestamp+'"  class="mm" name="'+fileID+sampleTimestamp+'">'+ fileNameMap.get(fileID) +
					'	<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteFileHtml('+fileID+sampleTimestamp+')">'+
					'	<br>'+
					'</div>';		
		});
		document.getElementById("tmp_file_items").innerHTML = display_scripts;		
		$("#tmp_file_items").attr('style', 'display: done');
	
		fileIDMap = new Map();
		fileNameMap = new Map();
	}
	
/* 첨부문서 다운로드 */
function FileDownload(checkboxName, isAll){
	var originalFileName = new Array();
	var sysFileName = new Array();
	var seq = new Array();
	var j =0;
	var checkObj = document.all(checkboxName);
	
	// 모두 체크 처리를 해준다.
	if (isAll == 'Y') {
		if (checkObj.length == undefined) {
			checkObj.checked = true;
		}
		for (var i = 0; i < checkObj.length; i++) {
			checkObj[i].checked = true;
		}
		
	}

	// 하나의 파일만 체크 되었을 경우
	if (checkObj.length == undefined) {
		if (checkObj.checked) {
			seq[0] = checkObj.value;
			j++;
		}
	};
	for (var i = 0; i < checkObj.length; i++) {
		if (checkObj[i].checked) {
			seq[j] = checkObj[i].value;
			j++;
		}
	}
	if(j==0){
		alert("${WM00049}");
		return;
	}
	j =0;
	var url  = "fileDownload.do?seq="+seq+"&scrnType=SR";
	ajaxSubmitNoAdd(document.receiptSRFrm, url,"saveFrame");
	// 모두 체크 해제
	if (isAll == 'Y') {
		if (checkObj.length == undefined) {
			checkObj.checked = false;
		}
		for (var i = 0; i < checkObj.length; i++) {
			checkObj[i].checked = false;
		}
	}
}

function fileNameClick(avg1){
	var originalFileName = new Array();
	var sysFileName = new Array();
	var filePath = new Array();
	var seq = new Array();
	seq[0] = avg1;
	var url  = "fileDownload.do?seq="+seq+"&scrnType=SR";
	ajaxSubmitNoAdd(document.receiptSRFrm, url,"saveFrame");
}	

//************** addFilePop V4 설정 START ************************//

function doAttachFileV4(){
	var url="addFilePopV4.do";
	var data="scrnType=SR&fltpCode=SRDOC";
	openPopup(url+"?"+data,490,450, "Attach File");
}

var fileIDMapV4 = new Map();
var fileNameMapV4 = new Map();
function fnAttacthFileHtmlV4(fileID, fileName){ 
	fileID = fileID.replace("u","");
	fileIDMapV4.set(fileID,fileID);
	fileNameMapV4.set(fileID,fileName);
}

// addFilePopV4에서 파일 삭제시, fileMap에서 해당파일 제거 
function fnDeleteFileMapV4(fileID){ 
	fileID = fileID.replace("u","");		
	fileIDMapV4.delete(String(fileID));
	fileNameMapV4.delete(String(fileID));
}

function fnDisplayTempFileV4(){				
	display_scripts=$("#tmp_file_items").html(); 
	fileIDMapV4.forEach(function(fileID) {			  
		  display_scripts = display_scripts+
			'<div id="'+fileID+'"  class="mm" name="'+fileID+'">'+ fileNameMapV4.get(fileID) +
				'	<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteFileHtmlV4('+fileID+')">'+
				'	<br>'+
				'</div>';		
	});
	document.getElementById("tmp_file_items").innerHTML = display_scripts;		
	$("#tmp_file_items").attr('style', 'display: done');

	fileIDMapV4 = new Map();
	fileNameMapV4 = new Map();
}
 
//  dhtmlx v 4.0 delete file  
function fnDeleteFileHtmlV4(fileID){		
	var fileName = document.getElementById(fileID).innerText;		
	fileIDMapV4.delete(String(fileID));
	fileNameMapV4.delete(String(fileID));
	
	if(fileName != "" && fileName != null && fileName != undefined){
		$("#"+fileID).remove();
		var url  = "removeFile.do";
		var data = "fileName="+fileName;	
		ajaxPage(url,data,"blankFrame");
	}
} 
//************** addFilePop V4 설정 END ************************//
</script>
