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
<%-- <script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>  --%>

<link rel="stylesheet" href="${root}cmm/common/css/materialdesignicons.min.css"/>

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
	#refresh:hover {
		cursor:pointer;
	}
	.tdhidden{display:none;}
	#maintext table {
	border: 1px solid #ccc;
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
      height: 430px;
      border: 1px solid #ccc;
    }
    
    .wrap_sbj2 {width: calc(100% - 300px);} 
	.wrap_sbj2 input {border: 0;border-bottom: 1px solid #dfdfdf;width: 100%;height: 30px;cursor: pointer;transition: all 0.2s ease-out;}
	.wrap_sbj2 input:hover {border-color: #000000;}
	.wrap_sbj2 input:focus {border-color: #4265EE;}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$("#tdClass").attr("colspan",3);
		$("#dimY1").attr('style', 'display:none');
		$("#dimY2").attr('style', 'display:none');
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${s_itemID}&AuthorID=${sessionScope.loginInfo.sessionUserId}";
		// fnSelect('classCode', data, 'getClassOption', '', 'Select', "item_SQL");	
		fnSelect('csrID', data, 'getCsrListWithMember', '', 'Select', "project_SQL");	
		
		var hasSubDimension = "${hasSubDimension}";
		if(hasSubDimension == "N"){
			fnSelect('dimTypeID', data, 'getDimensionTypeID', '', 'Select');	
			fnSelect('dimTypeValueID', data, 'getDimTypeValueId', '', 'Select');	
		}else{
			fnGetDimTypeValue("${dimTypeID}");
		}
		fnLoadAttrTypeFrame();
		
	});
	
	function fnCheckIdentifier(){
		var identifier = $("#identifier").val();
		if(identifier == ""){alert("${WM00034_1}");$("#identifier").focus();return false;}
		var url = "checkIdentifier.do";
		var data = "identifier="+identifier+"&itemTypeCode=${itemTypeCode}";
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
		fnSelect('dimTypeValueID', data, 'getDimValue', '', 'Select');	
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
		var url = "registerItemAttrFrame.do";	
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
		var csrID = $("#csrID").val();
		//var classCode = $("#classCode").val();
		var identifier = $("#identifier").val();
		var idCheckYN = $("#idCheckYN").val();
		var itemName = $("#itemName").val();
		var autoID = $("#autoID").val();
		
		if(csrID == ""){alert("${WM00041_2}");$("#csrID").focus();return false;}		
		//if(classCode == ""){alert("${WM00041_1}");$("#classCode").focus();return false;}		
		if(autoID != "Y"){ if(identifier == ""){alert("${WM00034_1}");$("#identifier").focus();return false;}
						   if(idCheckYN != "Y"){alert("${WM00139}");return false;} 
						 }
		if(itemName == ""){alert("${WM00034_2}");$("#itemName").focus();return false;}
		
		if(confirm("${CM00001}")){	
		  	$('#attrFrame').get(0).contentWindow.fnCreateItemMst('${s_itemID}');
		}
	}
	
	function fnCallBackCreateItemMST(s_itemID){
// 		if("pop" == "pop"){
// 			opener.doSearchList();
// 			self.close();
// 		}else{
			parent.fnRefreshTree(s_itemID,true);
// 		}
	}
	
</script>
</head>
<form name="frontFrm" id="frontFrm" action="#" method="post" onsubmit="return false;"> 
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
	<input type="hidden" id="autoID" name="autoID">
	<input type="hidden" id="preFix" name="preFix">
 	<div id="htmlReport" style="width:100%;overflow-y:auto;overflow-x:hidden;">
		<div id="itemDiv">
			<div id="process" class="mgT10 mgB20">
				<p class="cont_title">${menu.LN00096}</p>
				 <ul>
					 <li class="flex align-center pdB5">
						<div style="flex: 1 1 0;" class="align-center flex">
					 		<h3 class="tx">${menu.LN00016 }</h3>
					 			${className}
					 			<input type="hidden" id="classCode" name="classCode" value="${classCode}" >
								<!-- <select id="classCode" name="classCode" OnChange="fnSelectHasDimension(this.value)" class="form-sel mgR5" style="width:290px;flex: 0 1 auto;"></select> -->
						</div>				 		
						<div style="flex: 1 1 0;" class="align-center flex">
							<h3 class="tx">${menu.LN00358 }</h3>
							<span class="wrap_sbj2">${itemPath}</span>
						</div>
					 </li>
					  <li class="flex align-center pdB5">
				 		<div style="flex: 1 1 0;" class="align-center flex">
				 			<h3 class="tx">Code</h3>
							<span class="wrap_sbj2 pdR5">
								<input type="text" id="identifier" name="identifier" style="width:287px">
								<span id="idCheck" name="idCheck"  class="btn_pack medium icon"><span class="confirm"></span><input value="중복체크" onclick="fnCheckIdentifier()" type="submit"></span>
							</span>					
							<input type="hidden" id="idCheckYN" name="idCheckYN">
							<font id="checkID" size=2></font>
						</div>
						<div style="flex: 1 1 0;" class="align-center flex">
							<h3 class="tx">${menu.LN00028 }</h3>
							<span class="wrap_sbj2"><input type="text" id="itemName" name="itemName" style="width:400px;"></span>
						</div>
					 </li>
					 
					 <li class="flex align-center pdB5">
				 		<div style="flex: 1 1 0;" class="align-center flex">
					 		<h3 class="tx">${menu.LN00191 }</h3>
							<select id="csrID" name="csrID" class="form-sel" style="width:290px;flex: 0 1 auto;"></select>
						</div>
				
						<div style="flex: 1 1 0;" class="align-center flex">
							<h3 class="tx">Dimension</h3>
							<select id="dimTypeValueID" name="dimTypeValueID" OnChange="fnGetSubDimvVlue(this.value);" style="width:180px;flex: 0 1 auto;"  class="form-sel"></select>
					
					 </li>
					
					 <li class="flex pdT5 pdB5">
						<h3 class="tx mgT12">${menu.LN00111 }</h3>
						<div style="width:calc(100% - 100px);">
							<button class="cmm-btn" onclick="doAttachFileV4()">Attach</button>
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
					</li>
				 </ul>
			</div>
			
			<div id="maintext" class="mgB10">
				<p class="cont_title">${menu.LN00031}</p>
				 <div id="attr_content">
			        <iframe name="attrFrame" id="attrFrame" style="width:100%;height:100%;" frameborder="0"></iframe> 
			     </div>			     
			</div>
			
			<div class="floatR pdB5">	
<!-- 				<span id="viewFile" class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="submit" onclick="doAttachFileV4()"></span>&nbsp;&nbsp; -->
				<span class="btn_pack medium icon"><span class="save"></span><input value="Register" type="submit" onclick="fnRegistItem();"></span>&nbsp;&nbsp;
				<span class="btn_pack medium icon"><span class="confirm"></span><input value="Cancel" onclick="fnMenuReload()"  type="submit"></span>
			</div>
		</div>
	</div>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</form>
