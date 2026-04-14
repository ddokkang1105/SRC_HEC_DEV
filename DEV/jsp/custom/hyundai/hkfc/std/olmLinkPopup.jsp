<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="false"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<% String loginid = request.getParameter("olmI") == null ? request.getParameter("olmLoginid") : request.getParameter("olmI");
String languageID = request.getParameter("languageID") == null ? GlobalVal.DEFAULT_LANGUAGE: request.getParameter("languageID");
//String languageID = request.getParameter("languageID");
String scrnType = request.getParameter("scrnType") == null ? "" : request.getParameter("scrnType");
String keyId = request.getParameter("keyId") == null ? "" : request.getParameter("keyId");

String object = request.getParameter("object") == null ? "" : request.getParameter("object");
String linkType = request.getParameter("linkType") == null ? "" : request.getParameter("linkType");
String linkID = request.getParameter("linkID") == null ? "" : request.getParameter("linkID");
String iType = request.getParameter("iType") == null ? "" : request.getParameter("iType");
String aType = request.getParameter("aType") == null ? "" : request.getParameter("aType");
String option = request.getParameter("option") == null ? "" : request.getParameter("option");
String type = request.getParameter("type") == null ? "" : request.getParameter("type");
String changeSetID = request.getParameter("changeSetID") == null ? "" : request.getParameter("changeSetID");
String projectType = request.getParameter("projectType") == null ? "" : request.getParameter("projectType");
String searchValue = request.getParameter("searchValue") == null ? "" : request.getParameter("searchValue");
String focusedObjID = request.getParameter("focusedObjID") == null ? "" : request.getParameter("focusedObjID");
/* 공지사항 추가  */
String boardID = request.getParameter("boardID") == null ? "" : request.getParameter("boardID");
String boardMgtID = request.getParameter("boardMgtID") == null ? "" : request.getParameter("boardMgtID");
String urlParam = request.getParameter("urlParam") == null ? "" : request.getParameter("urlParam");
String currPage = request.getParameter("currPage") == null ? "" : request.getParameter("currPage");
String searchKey = request.getParameter("searchKey") == null ? "" : request.getParameter("searchKey");
String scEndDt =  request.getParameter("scEndDt") == null ? "" : request.getParameter("scEndDt");


%> 
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

function ajaxPage(url, data, target, preHtml, debug, debugTarget) {
	$.ajax({
		url: url,type: 'post',data: data,async: true,error: function(xhr, status, error) {alert(status+"||"+error);$('#loading').fadeOut(150); },beforeSend: function(x) {$('#loading').fadeIn(150);if(x&&x.overrideMimeType) {x.overrideMimeType("application/html;charset=UTF-8");}}
		,success: function(data){$('#loading').fadeOut(10);if(debug){if(debugTarget==null){	alert(data);}else {	$("#debugMod").val(data);$("#debugMod").show();}} $("#" + target).hide();if(preHtml!=null){data=preHtml+data;}$("#" + target).html(data);$("#" + target).fadeIn(10);}
	});
}

var object = "<%=object%>";
var linkType = "<%=linkType%>";
jQuery(document).ready(function() {
	var loginid = "${olmI}" == "" ? "<%=loginid%>" : "${olmI}";
	
	if(loginid != "" ) {

		var url="/login/loginCheck.do";
		var data="loginid="+loginid+"&languageID=<%=languageID%>";
		ajaxPage(url, data, "divResult");
	}
	else {

		var url="${pageContext.request.contextPath}/login/login<%=type%>Form.do";
		var data = "?lng=<%=languageID%>&mainType=linkPop";
		
		$("#linkMain").attr("src",url+data);
	}
});


function fnReload() {
	linkType = "<%=linkType%>";
	var msg = "${WM00104}";	
	var url="";
	var scrnType = "<%=scrnType%>";
	if(object==null||object==undefined||object==""){alert(msg);}
	else{
		
		if(scrnType == "TMPL"){ // Item Link Templet view			
			var url = "${root}mainpage.do?scrnType="+scrnType
					+ "&languageID=<%=languageID%>"
					+ "&object=<%=object%>"
					+ "&linkType=<%=linkType%>"
					+ "&linkID=<%=linkID%>"
					+ "&itemTypeCode=<%=iType%>";
					
			var form = $("form")[0];
			form.action = url;
			form.submit();
			
		}else{
			if(object.toUpperCase()=="ITM"){
				if(linkType.toUpperCase()=="ID" || linkType.toUpperCase()=="ATR" || linkType.toUpperCase()=="CODE"){
					url="/olmPopupMasterItem.do?languageID=<%=languageID%>"
						+ "&scrnType=pop&id=<%=keyId%>&object=<%=object%>"
						+ "&linkType=<%=linkType%>&linkID=<%=linkID%>"
						+ "&iType=<%=iType%>&aType=<%=aType%>&option=<%=option%>"
						+ "&changeSetID=<%=changeSetID%>&focusedObjID=<%=focusedObjID%>";
				}else if(linkType.toUpperCase()=="JOBNO"){
					url="/olmPopupMasterItemByProcPjt.do?languageID=<%=languageID%>"
						+ "&scrnType=pop&id=<%=keyId%>&object=<%=object%>"
						+ "&linkType=<%=linkType%>&linkID=<%=linkID%>"
						+ "&iType=<%=iType%>&aType=<%=aType%>&option=<%=option%>"
						+ "&changeSetID=<%=changeSetID%>"
						+ "&projectType=<%=projectType%>";
				}
				
			}
	
			if(object.toUpperCase()=="PROCINST"){
				if(linkType.toUpperCase()=="JOBNO"){
					url="/olmProcInstLink.do?languageID=<%=languageID%>"
						+ "&scrnType=pop&id=<%=keyId%>&object=<%=object%>"
						+ "&linkType=<%=linkType%>&linkID=<%=linkID%>"
						+ "&iType=<%=iType%>&aType=<%=aType%>&option=<%=option%>"
						+ "&changeSetID=<%=changeSetID%>"
						+ "&projectType=<%=projectType%>";
				}
			}
			if (object.toUpperCase() == "BRD") {
				
				url = "/boardDetail.do?NEW=N"
					+ "&BoardID=101"              // 게시물 ID
					+ "&BoardMgtID=1"      // 게시판 관리 ID
					+ "&url=<%=urlParam%>"               // 필요시 추가
					+ "&currPage=<%=currPage%>"          // 현재 페이지 번호
					+ "&screenType=pop"
					+ "&searchKey=Name"
					+ "&searchValue=<%=searchValue%>"
					
			}
			if (object.toUpperCase() == "MANUAL") {
						
						url = "/boardDetail.do?NEW=N"
							+ "&BoardID=<%=boardID%>"              // 게시물 ID
							+ "&BoardMgtID=<%=boardMgtID%>"      // 게시판 관리 ID
							+ "&url=<%=urlParam%>"               // 필요시 추가
							+ "&currPage=<%=currPage%>"          // 현재 페이지 번호
							+ "&screenType=pop"
							+ "&searchKey=Name"
							+ "&searchValue=<%=searchValue%>"
							
				}
			if(object.toUpperCase()=="ELMINST"){
				url="/olmelmInstLink.do?languageID=<%=languageID%>"
						+ "&scrnType=pop&id=<%=keyId%>&object=<%=object%>"
						+ "&linkType=<%=linkType%>&linkID=<%=linkID%>"
						+ "&iType=<%=iType%>&aType=<%=aType%>&option=<%=option%>"
						+ "&changeSetID=<%=changeSetID%>";
			}
			else if(object.toUpperCase()=="CSR"){url="/csrDetailPop.do?scrnType=pop&ProjectID=<%=linkID%>&screenMode=V";}
			else if(object.toUpperCase()=="CS"){
				url="/viewItemChangeInfo.do?scrnType=pop&ProjectID=<%=linkID%>&screenMode=V";
	
				url = "/viewItemChangeInfo.do?changeSetID=<%=linkID%>&StatusCode=<%=iType%>"
				+ "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&mainMenu=${mainMenu}&seletedTreeId=<%=keyId%>"
				+ "&screenMode=view&isMyTask=Y";
			}
			else if(object.toUpperCase()=="CSItem"){
				url="/olmChangeSetLink.do?languageID=<%=languageID%>"
					+ "&scrnType=pop&keyID=<%=keyId%>&object=<%=object%>"
					+ "&linkType=<%=linkType%>&linkID=<%=linkID%>"
					+ "&iType=<%=iType%>&aType=<%=aType%>&option=<%=option%>"
					+ "&changeSetID=<%=changeSetID%>";
			}
			else if(object.toUpperCase()=="TERM"){
				url="/termsMgt.do?"
					+ "&languageID=<%=languageID%>"
					+ "&scrnType=pop&keyID=<%=keyId%>&object=<%=object%>"
					+ "&linkType=<%=linkType%>&linkID=<%=linkID%>"
					+ "&iType=<%=iType%>&aType=<%=aType%>&option=<%=option%>"
					+ "&changeSetID=<%=changeSetID%>"
					+ "&searchValue=<%=searchValue%>";
			}
			else if(object.toUpperCase()=="FSEARCH"){
				url="/searchItemWFile.do?"
					+ "&languageID=<%=languageID%>"
					+ "&scrnType=pop&keyID=<%=keyId%>&object=<%=object%>"
					+ "&linkType=<%=linkType%>&linkID=<%=linkID%>"
					+ "&iType=<%=iType%>&aType=<%=aType%>&option=<%=option%>"
					+ "&searchValue=<%=searchValue%>";
			}
			else if(object.toUpperCase()=="VER"){url="/viewVersionItemInfo.do?scrnType=pop&s_itemID=<%=keyId%>&changeSetID=<%=linkID%>";}
			else if(object.toUpperCase()=="WFLIST"){
				url="/olmAprvDueLink.do?"
					+ "&language=<%=languageID%>"
					+ "&empNo=<%=loginid%>";
			}
			else if(object.toUpperCase()=="FILE"){
				var linkType = "<%=linkType%>";
				if(linkType.toUpperCase() == "FILEID"){
					url="/fileDownload.do?"
						+ "&language=<%=languageID%>"
						+ "&seq=<%=linkID%>";
					
				}else{
					url="/selectFilePop.do?"
						+ "&language=<%=languageID%>"
						+ "&linkType=<%=linkType%>&linkID=<%=linkID%>"
						+ "&iType=<%=iType%>";
				}
				
			}
			
			
			if(url.length>0){
				//main.location = url;
				var dsWindow=window.open (url,'_self', "popup"+(new Date()).valueOf(),"status=1,toolbar=0,menubar=0,resizable=0,width=1014,height=680,padding=10px");
				dsWindow.moveTo(0, 0);	
				//closeThis();
			}else{alert(msg);}
		} // scrnType
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
</script>
</head>
<body><div id="divResult"></div>
 <form id="dfForm" name="dfForm" action="" method="post" target="linkMain"></form>
 <iframe name="linkMain" id="linkMain" width="100%" height="100%" frameborder="0" scrolling="no" marginwidth="0" marginheight="0"></iframe>
 </body>
</html>