<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<script type="text/javascript">
	//var chkReadOnly = true;
</script>
<script type="text/javascript">
	var chkReadOnly = true;
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
 
<script type="text/javascript">
	$(document).ready(function(){
		document.getElementById('editArea').style.height = (setWindowHeight() - 40)+"px";			
		window.onresize = function() {
			document.getElementById('editArea').style.height = (setWindowHeight() - 40)+"px";	
		};
		$("#viewer").prop('checked', true);
		$(":input:radio[name=radio]").change(function(){
			view($(":input:radio[name=radio]:checked").val());
		})
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function fnSaveEmailForm(){
		if(confirm("${CM00001}")){
			ajaxSubmit(document.emailFrm, "saveEmailForm.do");
		}
	}
	
	function selfClose(){
		self.close();
		opener.fnCallBack();
	}
	
	function view(e){	
		if(e == "viewer"){
			$("#viewerArea").css("display","table-row");
			$("#editorArea").css("display","none");
			$(".alignBTN").css("display","none");
		} else {
			$("#viewerArea").css("display","none");
			$("#editorArea").css("display","table-row");
			$(".alignBTN").css("display","block");
		}
	}
</script>
</head><body>
<form name="emailFrm" id="emailFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="emailCode" name="emailCode" value="${emailForm.EmailCode}" />
	<input type="hidden" id="viewType" name="viewType" value="EF" />
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Email Form ${menu.LN00103}</p>
	</div>
	
	<div id="editArea" style="margin:5px 10px;">
		<table class="tbl_blue01">
			<colgroup>
				<col width="12%">
				<col>
			</colgroup>
		<tr>
			<th class="viewline alignC">${menu.LN00015}</th>
			<td class="alignL last">${emailForm.EmailCode}</td>
		</tr>
		<tr>
			<th class="viewline alignC">Form</th>
			<td class="alignL last">
				<input type="radio" name="radio" value="viewer" id="viewer"/><label for="viewer" class="mgR10">&nbsp;Viewer</label>
				<input type="radio" name="radio" value="editor" id="editor"/><label for="editor">&nbsp;Editor</label>
			</td>
		</tr>
		<tr id="viewerArea">
			<td colspan = 2 class="alignL last">
				<div style="width:100%;height:400px;">
					<textarea class="tinymceText" readonly="readonly">
						<div class="">${emailForm.HTMLForm}</div>
					</textarea>
				</div>
			</td>
		</tr>
		<tr id="editorArea" style="display:none;">
			<td colspan = 2 class="alignL last">
				<textarea class="" style="width:100%;height:435px;" name="htmlForm">
					<c:out value="${emailForm.HTMLForm}" escapeXml="true" />
				</textarea>
			</td>
		</tr>
		</table>
		
		 <c:if test="${fn:length(emailForm) > 0 and sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<div class="alignBTN mgB5 mgR10" style="display:none;">
				<button class="cmm-btn2 mgR5" style="height: 30px;" onclick="fnSaveEmailForm()" value="Save">Save</button>
			</div>
		</c:if>
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none;width:0px;height:0px;"></iframe>
</body></html>