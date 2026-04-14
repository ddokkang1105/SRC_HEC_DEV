<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>

<link rel="stylesheet" href="${root}cmm/common/css/materialdesignicons.min.css"/>
<%@ include file="/WEB-INF/jsp/template/autoCompText.jsp"%>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00106}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_1" arguments="${menu.LN00016}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_2" arguments="${menu.LN00191}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00139" var="WM00139" arguments="${menu.LN00106}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<head>
<style>
	
	#itemDiv > div {
		padding : 0 10px;
	}
	#itemDiv li > div > label {
		margin-top: 10px;
		width: 100px !important;
	}
	
	#refresh:hover {
		cursor:pointer;
	}
	.tdhidden{display:none;}
	#maintext table {
	/* border: 1px solid #ccc; */
	width:100%;
	}
	#maintext th{
	    text-align: left;
    padding: 10px;
        color: #000;
    font-weight: bold;
	}
	#maintext td{
	 width: 97%;
    border: 1px solid #ccc;
    display: block;
    padding-top: 10px;
    padding-left: 10px;
    margin: 0px auto 15px;
    overflow-x: auto;
    line-height: 18px;
	}
	#maintext  textarea {
	width: 100%;
	resize:none;
	}
	
	#attr_content {
      width: 100%;
      height: 240px;
      padding-right: 30px;
     /*  border: 1px solid #ccc; */
    }
    
    .wrap_sbj2 {width: calc(100% - 300px);} 
	.wrap_sbj2 input {border: 0;border-bottom: 1px solid #dfdfdf;width: 100%;height: 30px;cursor: pointer;transition: all 0.2s ease-out;}
	.wrap_sbj2 input:hover {border-color: #000000;}
	.wrap_sbj2 input:focus {border-color: #4265EE;}
	
	.frame_title {
    border-bottom: 1px solid #ccc;
    color: #193598 !important;
    font-weight:700;
    margin-bottom:10px;
    text-align:left !important; 
    font-size:14px !important;
    margin-left:10px;
    padding: 0 !important;
    height: 25px;
    }
    
</style>
<script type="text/javascript">
	$(document).ready(function(){
		
		$("input.datePicker").each(generateDatePicker);			
		
		$("#ZAT4015").keypress(function(){
			if(event.keyCode == '13') {
				searchPopupWf('searchPluralNamePop.do?objId=memberID&objName=memberName');
				
				return false;
			}			
		});
		
	});
	
	function fnCheckIdentifier(){
		var identifier = $("#identifier").val();
		if(identifier == ""){alert("${WM00034_1}");$("#identifier").focus();return false;}
		var url = "checkIdentifier.do";
		var data = "identifier="+identifier+"&itemTypeCode=${itemTypeCode}&itemID=";
		var target = "blankFrame";
		ajaxPage(url, data, target);
	}
	
	function fnReturnCheckID(CNT){
		if(CNT == "0"){			
			$('#idCheckYN').val('Y');
			$("#checkID").html("사용할 수 있는 ID 입니다.");
			$("#checkID").attr("color","green");
		}else{
			$('#idCheckYN').val('N');
			$("#checkID").html("사용할 수 없는 ID 입니다.");
			$("#checkID").attr("color","red");
		}
		return;
	}
	
	function fnSelectHasDimension(classCode){ 
		if(classCode == "") return;
		fnLoadAttrTypeFrame(classCode);
		var url = "getHasDimension.do";
		var data = "itemClassCode="+classCode;
		var target = "blankFrame";
		ajaxPage(url, data, target);
	}
	
	function fnGetDimTypeValue(dimTypeID){
		var data = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&dimTypeID="+dimTypeID+"&level=1";
		fnSelect('ZAT4011', data, 'getDimValue', '', 'Select');	
	}
	
	function fnGetSubDimvVlue(dimValueID){
		let dimTypeID = $("#dimTypeID").val();
		let data = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&dimTypeID="+dimTypeID+"&parentID="+dimValueID;
		fnSelect('subDimTypeValueID', data, 'getDimValue', '', 'Select');	
	}

	function fnSetDimension(hasDimension, autoID, preFix){ 
		$("#autoID").val(autoID);
		$("#preFix").val(preFix);
		if(autoID == "Y"){
			$("#identifier").attr('readOnly', true);
			$("#idCheck").attr('style', 'display:none');
		}else{
			$("#identifier").attr('readOnly', false);
			$("#idCheck").attr('style', 'display:done');
		}
		
		if(hasDimension == "1"){
			$("#tdClass").attr("colspan",0);
			$("#dimY1").attr('style', 'display:done;');
			$("#dimY2").attr('style', 'display:done;');
			
			var data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
			fnSelect('dimTypeID', data, 'getDimensionTypeID', '', 'Select');	
			fnSelect('dimTypeValueID', data, 'getDimTypeValueId', '', 'Select');			
		}else{
			$("#tdClass").attr("colspan",3);
			$("#dimY1").attr('style', 'display:none');
			$("#dimY2").attr('style', 'display:none');
		}
	}
	
	function fnLoadAttrTypeFrame() {
		$('#isSubmit').remove();
		var url = "registerCertiItemAttrFrame.do";	
		var data = "";
		var target = "attrFrame";
		ajaxSubmit(document.frontFrm, url,target);
	}
	
	//************** addFilePop V4 설정 START ************************//
	function doAttachFileV4(){
		var url="addFilePopV4.do";
		var data="scrnType=SR&fltpCode=${fltpCode}"; // &fltpCode=SRDOC
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
		document.getElementById("tmp_file_items").style.display = "block";
		display_scripts=$("#tmp_file_items").html();
		
		let fileFormat = "";
		fileIDMapV4.forEach(function(fileID) {
			fileFormat = fileNameMapV4.get(fileID).split(".")[1];
			switch (true) {
				case fileFormat.includes("do") : fileFormat = "doc"; break;
				case fileFormat.includes("xl") : fileFormat = "xls"; break;
				case fileFormat.includes("pdf") : fileFormat = "pdf"; break;
				case fileFormat.includes("hw") : fileFormat = "hwp"; break;
				case fileFormat.includes("pp") : fileFormat = "ppt"; break;
				default : fileFormat = "log"
			}
			  display_scripts = display_scripts+
			  '<li id="'+fileID+'"  class="flex icon_color_inherit justify-between mm align-center" name="'+fileID+'">'+ 
				'<span><span class="btn_pack small icon mgR25">'+
				'	<span class="'+fileFormat+'"></span></span>' +
				'	<span style="line-height:24px;">'+fileNameMapV4.get(fileID) + '</span></span>' +
				'<i class="mdi mdi-window-close" onclick="fnDeleteFileHtmlV4('+fileID+')"></i>'+
				'</li>';
		});
		
		document.querySelector("#tmp_file_items").innerHTML = display_scripts;

		fileIDMapV4 = new Map();
		fileNameMapV4 = new Map();
	}
	 
	//  dhtmlx v 4.0 delete file  
	function fnDeleteFileHtmlV4(fileID){
		var fileName = fileName = document.getElementById(fileID).innerText;
		//console.log("fnDeleteFileHtml fileID : "+fileID+" , fileName  :"+fileName); // fileID.textContent
		
		fileIDMapV4.delete(String(fileID));
		fileNameMapV4.delete(String(fileID));
		
		if(fileName != "" && fileName != null && fileName != undefined){
			$("#"+fileID).remove();
			var url  = "removeFile.do";
			var data = "fileName="+fileName;	
			ajaxPage(url,data,"blankFrame");
		}
		
		if(document.querySelector("#tmp_file_items").innerText.replaceAll("\n","").replaceAll("\t","") == "") {
			document.querySelector("#tmp_file_items").style.display = "";
		}
	}
	//************** addFilePop V4 설정 END ************************//
	
	function fnRegistItem(){	
		var identifier = $("#identifier").val();
		var idCheckYN = $("#idCheckYN").val();
		var itemName = $("#itemName").val();
		var autoID = $("#autoID").val();
		var ZAT4014 = $("#ZAT4014").val(); //갱신대상
		var ZAT4005 = $("#ZAT4005").val(); //차기갱신일
		
		//필수값 check
		if(autoID != "Y"){ if(identifier == ""){alert("${WM00034_1}");$("#identifier").focus();return false;}
						  if(idCheckYN != "Y"){alert("${WM00139}");return false;} 
						 }
		if(itemName == ""){alert("${WM00034_2}");$("#itemName").focus();return false;}
		// 갱신대상이 Y일 경우 차기갱신일은 필수값으로
		if(ZAT4014 != "" && ZAT4014 != null && ZAT4014 == "ZLV4141") {
			if(ZAT4005 == ""){
				var alertMsg = '<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" arguments="###" />';  
				var name = $("#ZAT4005").parents("div").children("label").text();
				alertMsg = alertMsg.replace('###', name);
				alert(alertMsg);$("#ZAT4005").focus();return false;
			}
		}
		
		
		if(confirm("${CM00001}")){	
		  	
			var mLovCode = "";
			var AttrTypeValue;
			var mLovCodeValue;
			var k; var l;
			var dataType = "";
			<c:forEach var="i" items="${attrAllocList}" varStatus="iStatus">
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
			
			var url = "createItemMst.do";	
			ajaxSubmit(document.certiFrm, url,"blankFrame");
		}
	}
	
	function fnCallBack(s_itemID){
		opener.doSearchList();
		self.close();
	}
	
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
		
	function fnClose(){
		self.close();
	}
	
	function fnGetSubAttrTypeCode(attrCode,subAttrCode,lovCode){ 
		if(subAttrCode != "" && subAttrCode != null){			
			var data = "languageID=${sessionScope.loginInfo.sessionCUrrLangType}&lovCode="+lovCode
			fnSelect(subAttrCode, data, 'getSubLovList', 'Select');
		}
	}
	
</script>
</head>
<form name="certiFrm" id="certiFrm" action="#" method="post" onsubmit="return false;"> 
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
	<input type="hidden" id="classCode" name="classCode" value="${classCode}" >
	<input type="hidden" id="csrID" name="csrID" value="${csrID}">	
	<input type="hidden" id="fltpCode" name="fltpCode" value="${fltpCode}">	
	<input type="hidden" id="autoID" name="autoID">
	<input type="hidden" id="preFix" name="preFix">
 	<div id="htmlReport" style="width:100%;overflow-y:auto;overflow-x:hidden;">
		<div id="itemDiv">
			<div id="process" class="mgT10">
				<p class="frame_title">제품인증</p>
				 <ul>
					 <li class="flex align-center pdB10">
				 		<div style="flex: 1 1 0;" class="align-center flex pdL20">
				 			<span class="tx">인증번호</span>
							<span class="wrap_sbj2 pdR5">
								<input type="text" id="identifier" name="identifier" style="width:280px;">
								<span id="idCheck" name="idCheck"  class="btn_pack medium icon"><span class="confirm"></span><input value="중복체크" onclick="fnCheckIdentifier()" type="submit"></span>
							</span>					
							<input type="hidden" id="idCheckYN" name="idCheckYN">
							<font id="checkID" size=2></font>
						</div>
						<div style="flex: 1 1 0;" class="align-center flex pdL20">
							<span class="tx">${menu.LN00028 }</span>
							<span class="wrap_sbj2"><input type="text" id="itemName" name="itemName"   style="width:84%;flex: 0 1 auto;" class="form-input"></span>							
						</div>
					 </li>
				 </ul>
			 </div>

		     <div id="itemDiv">			
				<div>
					<ul>
					<c:forEach var="i" items="${attrAllocList}" varStatus="iStatus">
						<li class="pdL10 pdR10 mgB15 <c:if test="${i.ColumnNum2 eq '2'}">flex</c:if>">
							<div style="flex: 1 1 0;" class="flex">
							<label for="${i.AttrTypeCode}"><c:if test="${i.Mandatory eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${i.Name}</label>
							<c:choose>
								<c:when test="${i.DataType eq 'Text'}">	
									<c:choose>
										<c:when test="${i.HTML eq '1'}">
											<div style="width:100%;height:${i.AreaHeight}px;">
												<textarea class="tinymceText" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" ></textarea>
											</div>
										</c:when>
										<c:when test="${i.HTML ne '1'}">
											<textarea class="form-input" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" class="form-input" rows="1" style="flex: 1 1 0;width:100%;height:${i.AreaHeight}px;<c:if test="${i.AreaHeight < 100 }">max-height:100px;</c:if>"></textarea>
										</c:when>
									</c:choose>
								</c:when>
								<c:when test="${i.DataType eq ''}">	
									<c:choose>
										<c:when test="${i.HTML eq '1'}">
											<div style="width:100%;height:40px;">
												<textarea class="tinymceText" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" ></textarea>
											</div>
										</c:when>
										<c:when test="${i.HTML ne '1'}">
											<input type="text" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" class="form-input" value="${i.PlainText}" class="text">
										</c:when>
									</c:choose>
								</c:when>
								<c:when test="${i.DataType eq 'LOV'}">
									<select id="${i.AttrTypeCode}" name="${i.AttrTypeCode}"  class="form-sel" style="width:100%;" onchange="fnGetSubAttrTypeCode('${i.AttrTypeCode}','${i.SubAttrTypeCode}',this.value);" ></select>
								<script>
									getAttrLovList('${i.AttrTypeCode}','${i.LovCode}', '${i.SubAttrTypeCode}');
								</script>
								</c:when>
								<c:when test="${i.DataType eq 'MLOV'}">
									<input type="hidden" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" />
									<div class="hgt40 flex align-center">
									<c:forEach var="mLovList" items="${i.mLovList}" varStatus="status">
									<input type="checkbox" id="${mLovList.AttrTypeCode}${mLovList.CODE}" name="${mLovList.AttrTypeCode}${mLovList.CODE}" value="${mLovList.CODE}"
									<c:if test="${mLovList.LovCode == mLovLis.CODE}" > checked </c:if> class="mgR5">
									<label for="${mLovList.AttrTypeCode}${mLovList.CODE}" class="mgR20">${mLovList.NAME}</label>
									</c:forEach>
									</div>
								</c:when>	
								<c:when test="${i.DataType eq 'Date'}">
								<ul>
									<li>
										<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
										<span class="wrap_sbj">
										<input type="text" id="${i.AttrTypeCode}" name="${i.AttrTypeCode}" value="${i.PlainText}"	class="text datePicker" size="8"
												style="width: 180px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
										</span>
									</li>
								</ul>
								</c:when>	
							</c:choose>
						</div>
						<c:if test="${i.ColumnNum2 eq '2'}">
							<div class="pdL35 flex" style="flex:1 1 0;">
								<label for="${i.AttrTypeCode2}"><c:if test="${i.Mandatory2 eq '1'}"><p style="display:inline;color:#FF0000;">*</p></c:if> ${i.Name2}</label>
								<c:choose>
								<c:when test="${i.DataType2 eq 'Text'}">
										<c:choose>
											<c:when test="${i.HTML2 eq '1'}">
												<script type="text/javascript">
													tinyMCE.EditorManager.execCommand('mceRemoveEditor', false, "${i.AttrTypeCode}");
												</script>
												<div style="width:100%;height:${i.AreaHeight}px;">
													<textarea class="tinymceText" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" >${i.PlainText2}</textarea>
												</div>
											</c:when>
											<c:when test="${i.HTML2 ne '1'}">
												<c:choose>
												<c:when  test="${i.AttrTypeCode2 eq 'ZAT4015'}" >
													<input type="text" class="text" id="ZAT4015" name="ZAT4015" style="ime-mode:active;width:78%;height:40px;border-radius: 3px;" />
					 			
										 			<input type="image" class="image pdL5" id="searchMemberBtn" name="searchMemberBtn" style="height:25px;padding-top:5px;" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="searchPopupWf('searchPluralNamePop.do?objId=memberID&objName=memberName&UserLevel=ALL')" value="Search" />
													<input type="hidden" id="ZAT4015_ID" name="ZAT4015_ID" />
												</c:when>
												<c:otherwise>
													<textarea class="form-input" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" class="form-input" rows="1" style="flex: 1 1 0;width:100%;height:${i.AreaHeight2}px;<c:if test="${i.AreaHeight2 < 100 }">max-height:100px;</c:if>">${i.PlainText2}</textarea>
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
											<input type="text" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" class="form-input" value="${i.PlainText2}" class="text">
										</c:when>
									</c:choose>
								</c:when>
								<c:when test="${i.DataType2 eq 'LOV'}">		
									<select id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}"  class="form-sel" style="width:100%;" onchange=fnGetSubAttrTypeCode('${i.AttrTypeCode2}','${i.SubAttrTypeCode2}',this.value);></select>
									<script>
										getAttrLovList('${i.AttrTypeCode2}','${i.LovCode2}','${i.SubAttrTypeCode2}');
									</script>					 
								</c:when>
								<c:when test="${i.DataType2 eq 'MLOV'}">
									<input type="hidden" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" />
									<div class="hgt40 flex align-center">
								 	<c:forEach var="mLovList2" items="${i.mLovList2}" varStatus="status">
									<input type="checkbox" id="${mLovList2.AttrTypeCode}${mLovList2.CODE}" name="${mLovList2.AttrTypeCode}${mLovList2.CODE}" value="${mLovList2.CODE}"
									<c:if test="${mLovList2.LovCode == mLovList2.CODE}" > checked </c:if> class="mgR5">
									<label for="${mLovList2.AttrTypeCode}${mLovList2.CODE}" class="mgR20">${mLovList2.NAME}</label>
									</c:forEach>
									</div>
								</c:when>	
								
								<c:when test="${i.DataType2 eq 'Date'}">
								<ul>
									<li>
										<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>
										<span class="wrap_sbj">
										<input type="text" id="${i.AttrTypeCode2}" name="${i.AttrTypeCode2}" value="${i.PlainText2}"	class="text datePicker" size="8"
												style="width: 180px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
										</span>
									</li>
								</ul>
								</c:when>
								</c:choose>
							</div>
							</c:if>
						</li>
					</c:forEach>
					</ul>
				</div>
			</div>	     
			
			 <div class="flex pdB5 pdL20">
				<span class="tx mgT12 mgL10">${menu.LN00111 }</span>
				<div style="width:calc(100% - 100px);">
					<button class="cmm-btn" onclick="doAttachFileV4()">Attach</button><span class="pdL5" >* 최초 인증서, 시험 성적서, 갱신심사 인증서 등 첨부 </spnan>
					<ul id="tmp_file_items" name="tmp_file_items" class="file_box mgB5 mgT10 tmp_file_items">
					<c:forEach var="fileList" items="${itemFiles}" varStatus="status">
						<li class="flex icon_color_inherit justify-between mm align-center" id="divDownFile${fileList.Seq}">
							<span>
								<span class="btn_pack small icon mgR25">
								<c:set var="fileName" value="${fn:split(fileList.FileRealName,'.')}" />
								<c:forEach var="FileFormat" items="${fileName}" varStatus="seq">
									<c:if test="${seq.count == 2}">
									<span class="
											<c:choose>
												<c:when test="${fn:contains(FileFormat, 'do')}">doc</c:when>
												<c:when test="${fn:contains(FileFormat, 'xl')}">xls</c:when>
												<c:when test="${fn:contains(FileFormat, 'pdf')}">pdf</c:when>
												<c:when test="${fn:contains(FileFormat, 'hw')}">hwp</c:when>
												<c:when test="${fn:contains(FileFormat, 'pp')}">ppt</c:when>
												<c:otherwise>log</c:otherwise>
											</c:choose>
									"></span>
									</c:if>
								</c:forEach>
								</span>
								<span style="line-height:24px;" onclick="fileNameClick('${fileList.Seq}');">${fileList.FileRealName}</span>
							</span>
							<i class="mdi mdi-window-close" onclick="fnDeleteItemFile('${fileList.BoardID}','${fileList.Seq}')"></i>
						</li>
					</c:forEach>
					</ul>
				</div>
			</div>
			
			<div class="floatR pdB5 pdR30">	
				<span class="btn_pack medium icon"><span class="save"></span><input value="Register" type="submit" onclick="fnRegistItem();"></span>&nbsp;&nbsp;
				<span class="btn_pack medium icon"><span class="confirm"></span><input value="Cancel" onclick="fnClose()"  type="submit"></span>
			</div>
		</div>
	</div>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</form>
