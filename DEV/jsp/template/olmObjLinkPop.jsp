<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="false"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<jsp:include page="/WEB-INF/jsp/template/uiInc.jsp" flush="true"/>

<style type="text/css">body,html {overflow-y:hidden}</style>
<c:if test="${!empty htmlTitle}"><script>parent.document.title="${htmlTitle}";</script></c:if>

<script src="${pageContext.request.contextPath}/cmm/js/jquery/jquery.js" type="text/javascript"></script>
<spring:message code="${GlobalVal.DEFAULT_LANG_CODE}.WM00104" var="WM00104" />
<script type="text/javascript"> 

var loginid = "${loginid}";
var inputLoginid = document.createElement('input');
inputLoginid.setAttribute("type", "hidden");
inputLoginid.setAttribute("id", "loginid");
inputLoginid.setAttribute("name", loginid);

var languageID = "${olmLinkData.languageID}";
var inputLanguageID = document.createElement('input');
inputLanguageID.setAttribute("type", "hidden");
inputLanguageID.setAttribute("id", "languageID");
inputLanguageID.setAttribute("name", "languageID");

var scrnType = "${olmLinkData.scrnType}";
var inputScrnType = document.createElement('input');
inputScrnType.setAttribute("type", "hidden");
inputScrnType.setAttribute("id", "scrnType");
inputScrnType.setAttribute("name", "scrnType");

var keyId = "${olmLinkData.keyId}";
var inputKeyId = document.createElement('input');
inputKeyId.setAttribute("type", "hidden");
inputKeyId.setAttribute("id", "keyId");
inputKeyId.setAttribute("name", "keyId");

var object = "${olmLinkData.object}";
var inputObject = document.createElement('input');
inputObject.setAttribute("type", "hidden");
inputObject.setAttribute("id", "object");
inputObject.setAttribute("name", "object");

var linkType = "${olmLinkData.linkType}";
var inputLinkType = document.createElement('input');
inputLinkType.setAttribute("type", "hidden");
inputLinkType.setAttribute("id", "linkType");
inputLinkType.setAttribute("name", "linkType");

var linkID = "${olmLinkData.linkID}";
var inputLinkID = document.createElement('input');
inputLinkID.setAttribute("type", "hidden");
inputLinkID.setAttribute("id", "linkID");
inputLinkID.setAttribute("name", "linkID");

var iType = "${olmLinkData.iType}";
var inputIType = document.createElement('input');
inputIType.setAttribute("type", "hidden");
inputIType.setAttribute("id", "iType");
inputIType.setAttribute("name", "iType");

var aType = "${olmLinkData.aType}";
var inputAType = document.createElement('input');
inputAType.setAttribute("type", "hidden");
inputAType.setAttribute("id", "aType");
inputAType.setAttribute("name", "aType");

var option = "${olmLinkData.option}";
var inputOption = document.createElement('input');
inputOption.setAttribute("type", "hidden");
inputOption.setAttribute("id", "option");
inputOption.setAttribute("name", "option");

var type = "${olmLinkData.type}";
var inputType = document.createElement('input');
inputType.setAttribute("type", "hidden");
inputType.setAttribute("id", "type");
inputType.setAttribute("name", "type");

var changeSetID = "${olmLinkData.changeSetID}";
var inputChangeSetID = document.createElement('input');
inputChangeSetID.setAttribute("type", "hidden");
inputChangeSetID.setAttribute("id", "changeSetID");
inputChangeSetID.setAttribute("name", "changeSetID");

var projectType = "${olmLinkData.projectType}";
var inputProjectType = document.createElement('input');
inputProjectType.setAttribute("type", "hidden");
inputProjectType.setAttribute("id", "projectType");
inputProjectType.setAttribute("name", "projectType");

var searchValue = "${olmLinkData.searchValue}";
var inputSearchValue = document.createElement('input');
inputSearchValue.setAttribute("type", "hidden");
inputSearchValue.setAttribute("id", "searchValue");
inputSearchValue.setAttribute("name", "searchValue");

var mainMenu = "${olmLinkData.mainMenu}";
var inputMainMenu = document.createElement('input');
inputMainMenu.setAttribute("type", "hidden");
inputMainMenu.setAttribute("id", "mainMenu");
inputMainMenu.setAttribute("name", "mainMenu");



function ajaxPage(ajaxUrl, data, target, preHtml, debug, debugTarget) {
	$.ajax({
		url: ajaxUrl,type: 'post',data: data,async: true,error: function(xhr, status, error) {alert(status+"||"+error);$('#loading').fadeOut(150); },beforeSend: function(x) {$('#loading').fadeIn(150);if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}}
		,success: function(data){$('#loading').fadeOut(10);if(debug){if(debugTarget==null){	alert(data);}else {	$("#debugMod").val(data);$("#debugMod").show();}} $("#" + target).hide();if(preHtml!=null){data=preHtml+data;}$("#" + target).html(data);$("#" + target).fadeIn(10);}
	});
}

function fnReload() {
	var msg = "${WM00104}";	
	
	if(object==null||object==undefined||object==""){
		alert(msg);
	}else{
		if(scrnType == "TMPL"){ // Item Link Templet view			
			var returnUrl = "${root}mainpage.do";
			
			inputScrnType.setAttribute("value", scrnType);
			dfForm.append(inputScrnType);
			inputLanguageID.setAttribute("value", languageID);
			dfForm.append(inputLanguageID);
			inputObject.setAttribute("value", object);
			dfForm.append(inputObject);
			inputLinkType.setAttribute("value", linkType);
			dfForm.append(inputLinkType);
			inputLinkID.setAttribute("value", linkID);
			dfForm.append(inputLinkID);

			var inputItemTypeCode = document.createElement('input');
			inputItemTypeCode.setAttribute("type", "hidden");
			inputItemTypeCode.setAttribute("id", "itemTypeCode");
			inputItemTypeCode.setAttribute("name", "itemTypeCode");
			inputItemTypeCode.setAttribute("value", iType);
			dfForm.append(inputItemTypeCode);
					
		}else{
			if(object.toUpperCase()=="ITM"){
				if(linkType.toUpperCase()=="ID" || linkType.toUpperCase()=="ATR" || linkType.toUpperCase()=="CODE"){
					returnUrl = "/olmPopupMasterItem.do";
					
					inputLanguageID.setAttribute("value", languageID);
					dfForm.append(inputLanguageID);
					inputScrnType.setAttribute("value", "pop");
					dfForm.append(inputScrnType);
					
					var inputID = document.createElement('input');
					inputID.setAttribute("type", "hidden");
					inputID.setAttribute("id", "id");
					inputID.setAttribute("name", "id");
					inputID.setAttribute("value", keyId);
					dfForm.append(inputID);
					
					inputObject.setAttribute("value", object);
					dfForm.append(inputObject);
					inputLinkType.setAttribute("value", linkType);
					dfForm.append(inputLinkType);
					inputLinkID.setAttribute("value", linkID);
					dfForm.append(inputLinkID);
					inputIType.setAttribute("value", iType);
					dfForm.append(inputIType);
					inputAType.setAttribute("value", aType);
					dfForm.append(inputAType);
					inputOption.setAttribute("value", option);
					dfForm.append(inputOption);
					inputChangeSetID.setAttribute("value", changeSetID);
					dfForm.append(inputChangeSetID);
					
				}else if(linkType.toUpperCase()=="JOBNO"){
					returnUrl = "/olmPopupMasterItemByProcPjt.do";
					
					inputLanguageID.setAttribute("value", languageID);
					dfForm.append(inputLanguageID);
					inputScrnType.setAttribute("value", "pop");
					dfForm.append(inputScrnType);
					inputObject.setAttribute("value", object);
					dfForm.append(inputObject);
					inputLinkType.setAttribute("value", linkType);
					dfForm.append(inputLinkType);
					inputLinkID.setAttribute("value", linkID);
					dfForm.append(inputLinkID);
					inputIType.setAttribute("value", iType);
					dfForm.append(inputIType);
					inputAType.setAttribute("value", aType);
					dfForm.append(inputAType);
					inputOption.setAttribute("value", option);
					dfForm.append(inputOption);
					inputProjectType.setAttribute("value", projectType);
					dfForm.append(inputProjectType);
				}
				
			}else if(object.toUpperCase()=="PROCINST"){
				if(linkType.toUpperCase()=="JOBNO"){
					returnUrl = "/olmProcInstLink.do";

					inputLanguageID.setAttribute("value", languageID);
					dfForm.append(inputLanguageID);
					inputScrnType.setAttribute("value", "pop");
					dfForm.append(inputScrnType);

					var inputID = document.createElement('input');
					inputID.setAttribute("type", "hidden");
					inputID.setAttribute("id", "id");
					inputID.setAttribute("name", "id");
					inputID.setAttribute("value", keyId);
					dfForm.append(inputID);

					inputObject.setAttribute("value", object);
					dfForm.append(inputObject);
					inputLinkType.setAttribute("value", linkType);
					dfForm.append(inputLinkType);
					inputLinkID.setAttribute("value", linkID);
					dfForm.append(inputLinkID);
					inputIType.setAttribute("value", iType);
					dfForm.append(inputIType);
					inputAType.setAttribute("value", aType);
					dfForm.append(inputAType);
					inputOption.setAttribute("value", option);
					dfForm.append(inputOption);
					inputProjectType.setAttribute("value", projectType);
					dfForm.append(inputProjectType);
				}
			}else if(object.toUpperCase()=="ELMINST"){
				returnUrl = "/olmelmInstLink.do";
						
				inputLanguageID.setAttribute("value", languageID);
				dfForm.append(inputLanguageID);
				inputScrnType.setAttribute("value", "pop");
				dfForm.append(inputScrnType);

				var inputID = document.createElement('input');
				inputID.setAttribute("type", "hidden");
				inputID.setAttribute("id", "id");
				inputID.setAttribute("name", "id");
				inputID.setAttribute("value", keyId);
				dfForm.append(inputID);

				inputObject.setAttribute("value", object);
				dfForm.append(inputObject);
				inputLinkType.setAttribute("value", linkType);
				dfForm.append(inputLinkType);
				inputLinkID.setAttribute("value", linkID);
				dfForm.append(inputLinkID);
				inputIType.setAttribute("value", iType);
				dfForm.append(inputIType);
				inputAType.setAttribute("value", aType);
				dfForm.append(inputAType);
				inputOption.setAttribute("value", option);
				dfForm.append(inputOption);
				inputChangeSetID.setAttribute("value", changeSetID);
				dfForm.append(inputChangeSetID);
				
			}else if(object.toUpperCase()=="CSR"){
				returnUrl = "/csrDetailPop.do";
				inputScrnType.setAttribute("value", "pop");
				dfForm.append(inputScrnType);
				
				var inputProjectID = document.createElement('input');
				inputProjectID.setAttribute("type", "hidden");
				inputProjectID.setAttribute("id", "ProjectID");
				inputProjectID.setAttribute("name", "ProjectID");
				inputProjectID.setAttribute("value", keyId);
				dfForm.append(inputProjectID);

				var inputScreenMode = document.createElement('input');
				inputScreenMode.setAttribute("type", "hidden");
				inputScreenMode.setAttribute("id", "screenMode");
				inputScreenMode.setAttribute("name", "screenMode");
				inputScreenMode.setAttribute("value", "V");
				dfForm.append(inputScreenMode);
			}else if(object.toUpperCase()=="CS"){
				url = "/viewItemChangeInfo.do";
				
				inputChangeSetID.setAttribute("value", linkID);
				dfForm.append(inputChangeSetID);
				inputLanguageID.setAttribute("value", languageID);
				dfForm.append(inputLanguageID);
				
				var inputStatusCode = document.createElement('input');
				inputStatusCode.setAttribute("type", "hidden");
				inputStatusCode.setAttribute("id", "StatusCode");
				inputStatusCode.setAttribute("name", "StatusCode");
				inputStatusCode.setAttribute("value", iType);
				dfForm.append(inputStatusCode);
				
				inputMainMenu.setAttribute("value", mainMenu);
				dfForm.append(inputMainMenu);

				var inputSeletedTreeId = document.createElement('input');
				inputSeletedTreeId.setAttribute("type", "hidden");
				inputSeletedTreeId.setAttribute("id", "seletedTreeId");
				inputSeletedTreeId.setAttribute("name", "seletedTreeId");
				inputSeletedTreeId.setAttribute("value", keyId);
				dfForm.append(inputSeletedTreeId);
				
				var inputScreenMode = document.createElement('input');
				inputScreenMode.setAttribute("type", "hidden");
				inputScreenMode.setAttribute("id", "screenMode");
				inputScreenMode.setAttribute("name", "screenMode");
				inputScreenMode.setAttribute("value", "view");
				dfForm.append(inputScreenMode);
				
				var inputIsMyTask = document.createElement('input');
				inputIsMyTask.setAttribute("type", "hidden");
				inputIsMyTask.setAttribute("id", "isMyTask");
				inputIsMyTask.setAttribute("name", "isMyTask");
				inputIsMyTask.setAttribute("value", "Y");
				dfForm.append(inputIsMyTask);
				
			}else if(object.toUpperCase()=="CSItem"){
				returnUrl = "/olmChangeSetLink.do";

				inputLanguageID.setAttribute("value", languageID);
				dfForm.append(inputLanguageID);
				inputScrnType.setAttribute("value", "pop");
				dfForm.append(inputScrnType);
				inputKeyId.setAttribute("value", keyId);
				dfForm.append(inputKeyId);

				inputObject.setAttribute("value", object);
				dfForm.append(inputObject);
				inputLinkType.setAttribute("value", linkType);
				dfForm.append(inputLinkType);
				inputLinkID.setAttribute("value", linkID);
				dfForm.append(inputLinkID);
				inputIType.setAttribute("value", iType);
				dfForm.append(inputIType);
				inputAType.setAttribute("value", aType);
				dfForm.append(inputAType);
				inputOption.setAttribute("value", option);
				dfForm.append(inputOption);
				inputChangeSetID.setAttribute("value", changeSetID);
				dfForm.append(inputChangeSetID);

			}else if(object.toUpperCase()=="TERM"){
				returnUrl = "/termsMgt.do";
				
				/* var inputArcCode = document.createElement('input');
				inputArcCode.setAttribute("type", "hidden");
				inputArcCode.setAttribute("id", "arcCode");
				inputArcCode.setAttribute("name", "arcCode");
				inputArcCode.setAttribute("value", "PAL11");
				dfForm.append(inputArcCode); */

				
				inputLanguageID.setAttribute("value", languageID);
				dfForm.append(inputLanguageID);
				inputScrnType.setAttribute("value", "pop");
				dfForm.append(inputScrnType);
				inputKeyId.setAttribute("value", keyId);
				dfForm.append(inputKeyId);

				inputObject.setAttribute("value", object);
				dfForm.append(inputObject);
				inputLinkType.setAttribute("value", linkType);
				dfForm.append(inputLinkType);
				inputLinkID.setAttribute("value", linkID);
				dfForm.append(inputLinkID);
				inputIType.setAttribute("value", iType);
				dfForm.append(inputIType);
				inputAType.setAttribute("value", aType);
				dfForm.append(inputAType);
				inputOption.setAttribute("value", option);
				dfForm.append(inputOption);
				inputChangeSetID.setAttribute("value", changeSetID);
				dfForm.append(inputChangeSetID);
				inputSearchValue.setAttribute("value", searchValue);
				dfForm.append(inputSearchValue);
				
			}else if(object.toUpperCase()=="FSEARCH"){
				returnUrl = "/searchItemWFile.do";
				
				/* var inputArcCode = document.createElement('input');
				inputArcCode.setAttribute("type", "hidden");
				inputArcCode.setAttribute("id", "arcCode");
				inputArcCode.setAttribute("name", "arcCode");
				inputArcCode.setAttribute("value", "MN172");
				dfForm.append(inputArcCode); */

				
				inputLanguageID.setAttribute("value", languageID);
				dfForm.append(inputLanguageID);
				inputScrnType.setAttribute("value", "pop");
				dfForm.append(inputScrnType);
				inputKeyId.setAttribute("value", keyId);
				dfForm.append(inputKeyId);

				inputObject.setAttribute("value", object);
				dfForm.append(inputObject);
				inputLinkType.setAttribute("value", linkType);
				dfForm.append(inputLinkType);
				inputLinkID.setAttribute("value", linkID);
				dfForm.append(inputLinkID);
				inputIType.setAttribute("value", iType);
				dfForm.append(inputIType);
				inputAType.setAttribute("value", aType);
				dfForm.append(inputAType);
				inputOption.setAttribute("value", option);
				dfForm.append(inputOption);
				inputSearchValue.setAttribute("value", searchValue);
				dfForm.append(inputSearchValue);
			}else if(object.toUpperCase()=="VER"){
				returnUrl = "/viewVersionItemInfo.do";

				inputScrnType.setAttribute("value", "pop");
				dfForm.append(inputScrnType);
				
				var inputS_itemID = document.createElement('input');
				inputS_itemID.setAttribute("type", "hidden");
				inputS_itemID.setAttribute("id", "s_itemID");
				inputS_itemID.setAttribute("name", "s_itemID");
				inputS_itemID.setAttribute("value", keyId);
				dfForm.append(inputS_itemID);
				
				inputChangeSetID.setAttribute("value", linkID);
				dfForm.append(inputChangeSetID);				
			}
			
			
			if(returnUrl.length>0){

				//window.open ("", "popupOpener", "popup"+(new Date()).valueOf(),"status=1,toolbar=0,menubar=0,resizable=0,width=1014,height=680,padding=10px");
				$("#dfForm").attr("action",returnUrl);
				$("#dfForm").submit();
				
				/* //main.location = url;
				var dsWindow=window.open (url,'_self', "popup"+(new Date()).valueOf(),"status=1,toolbar=0,menubar=0,resizable=0,width=1014,height=680,padding=10px");
				dsWindow.moveTo(0, 0);	
				//closeThis(); */
			}else{
				alert(msg);
			}
		}
	}
}
function closeThis() {
	//window.close();
	if(/MSIE/.test(navigator.userAgent)) {
		if(navigator.appVersion.indexOf("MSIE 8") >= 0 ||
				navigator.appVersion.indexOf("MSIE 7") >= 0 ) {
			window.open('about:blank','_self').close();
		} else {
			window.opener = self;
			self.close();
		}
	} else {
		window.close();
	}
}

<%--
function fnWindowOpen(){
	window.open (dfForm.action,'_self', "popup"+(new Date()).valueOf(),"status=1,toolbar=0,menubar=0,resizable=0,width=1014,height=680,padding=10px");
}
--%>

jQuery(document).ready(function() {
	var dfForm = document.dfForm;
	var returnUrl = "";
	
	loginid = "${olmI}" == "" ? loginid : "${olmI}";
	if(loginid != "" ) {
		var returnUrl = "/login/loginCheck.do";
		var data="loginid="+loginid+"&languageID="+languageID;
		ajaxPage(returnUrl, data, "divResult");
	}
	else {
		var returnUrl="${pageContext.request.contextPath}/login/login"+type+"Form.do";
		var data = "?lng="+languageID+"&mainType=linkPop";
		$("#linkMain").attr("src",returnUrl+data);
	}
});
</script>
</head>
	<body>
		<div id="divResult"></div>
		<!-- <form id="dfForm" name="dfForm" action="" method="post" target="linkMain" onsubmit="fnWindowOpen()"> -->
		<form id="dfForm" name="dfForm" action="" method="post">
		</form>
		
		<iframe name="linkMain" id="linkMain" width="100%" height="100%" frameborder="0" scrolling="no" marginwidth="0" marginheight="0">
		</iframe>
	</body>
</html>