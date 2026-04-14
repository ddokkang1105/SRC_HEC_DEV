<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<script type="text/javascript">
	var chkReadOnly = true;	
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<head>

<script type="text/javascript">
	
	$(document).ready(function(){		
		
	});
	
	function updateModel(){
		var blocked = "${Blocked}";
		var itemAthId = "${itemAthId}";
		var userId = "${sessionScope.loginInfo.sessionUserId}";
		var modelBlocked = "${modelInfo.ModelBlocked}";
	
		if(blocked != "2" && itemAthId == userId && modelBlocked == "0" || '${loginInfo.sessionMlvl}' == "SYS"){
			if(confirm("${CM00001}")){
				doBlockedChecked();
				doIsPublicChecked();
				var url  = "updateModel.do";
				ajaxSubmit(document.objectInfoFrm, url,"subFrame");
			}
		}else{			
			alert("${WM00040}"); return;
		}
		
	}
	
	function callbackUpdate(){
		self.close();
		opener.reloadList();
	}
	
	function doBlockedChecked(){		
		if ($("input:checkbox[id='Blocked']").is(":checked") == true){
			$("#Blocked").val(1);
		}else{
			$("#Blocked").val(0);
		}
	}
	
	function doIsPublicChecked(){		
		if ($("input:checkbox[id='IsPublic']").is(":checked") == true){
			$("#IsPublic").val(1);
		}else{
			$("#IsPublic").val(0);
		}
	}
	
	function fnpopupMaterMdlEdt() {
		var url = "popupMasterMdlEdt.do?"
			+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+"&s_itemID=${s_itemID}"
			+"&modelID=${modelInfo.RefModelID}"
			+"&scrnType=view";
			
		var w = 1200;
		var h = 900;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}

	 $('#FD_FILE_PATH').change(function(){
	        var upfile = $(this).val();
	        
	    	var strKind=upfile.substring(upfile.lastIndexOf(".")+1).toLowerCase();
	    	var isCheck = false;
	    	if(strKind == "xml"){
	    		isCheck = true;
	    		}
	    	
	    	if(!isCheck){
	    		confirm("xml파일이 아닙니다.");
	    		$('#txtFilePath').val(""); $('#FD_FILE_PATH').val("");
	    	}else{
	    		$('#txtFilePath').val( upfile );
	    	}
		 });
	 
		$("#send").click(function() {
			fnImportModelXml();
		});
</script>
</head>
<body >	
	<div id="objectInfoDiv" class="hidden" style="padding:0 10px;">
		<table class="tbl_blue01 mgT10" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="8%">
				<col width="17%">
				<col width="8%">
				<col width="17%">
				<col width="8%">
				<col width="17%">
				<col width="8%">
				<col width="17%">
			</colgroup>		
			<tr>
				<th>${menu.LN00367}</th>
				<td>${modelInfo.ModelName}</td>
				<th>${menu.LN00032}</th>
				<td>${modelInfo.ModelTypeName}</td>
				<th>${menu.LN00033}</th>
				<td>${modelInfo.MTCategoryName}</td>			
				<th>${menu.LN00027}</th>
				<td class="last">${modelInfo.StatusName}</td>		
			</tr>		
			<tr>
				<th>Version</th>
				<td>${modelInfo.Version}</td>
				<th>${menu.LN00368}</th>
				<td <c:if test="${modelInfo.RefModelName ne 'N/A'}"> style="text-decoration: underline; cursor:pointer;" onClick="fnpopupMaterMdlEdt()"</c:if>>
					${modelInfo.RefModelName}
				</td>				
				<th>Valid From/To</th>
				<td>${modelInfo.ValidFrom}&nbsp;&nbsp;~&nbsp;&nbsp;${modelInfo.ValidTo}</td>
				<th>Is Model</th>
				<td class="last">
					<c:if test="${modelInfo.IsModel == 1}">Y</c:if>
					<c:if test="${modelInfo.IsModel == 0}">N</c:if>
					<c:if test="${modelInfo.IsModel == 2}">2</c:if>
				</td>
			</tr>
				<tr>
				<th>${menu.LN00105}</th>
				<td>${modelInfo.LastUserNm}</td>
				<th>${menu.LN00070}</th>
				<td>${modelInfo.LastUpdated}</td>
				<th>${menu.LN00200}</th>
				<td>${modelInfo.CreatorNm}</td>
				<th>${menu.LN00013}</th>
				<td class="last">${modelInfo.CreationTime}</td>
			</tr>			
			<tr>
				<th>${menu.LN00035}</th>
				<td colspan="7" class="last">
					<textarea id='description' name='description' style="width:100%;height:130px;" readOnly >${modelInfo.Description}</textarea>
				</td>
			</tr>
		</table>
<div class="alignBTN" id="divUpdateModel" style="display: flex; align-items: center; justify-content: flex-end; gap: 10px;">
    <c:if test="${modelInfo.IsModel == '0' && (myItem eq 'Y' || loginInfo.sessionMlvl == 'SYS')}">
        <th class="pdB5" style="text-align:left;">Select File</th>
        <form name="commandMap" id="commandMap" enctype="multipart/form-data" method="post" onsubmit="return false;" style="display: flex; align-items: center;">
            <input type="text" id="txtFilePath" readonly onfocus="this.blur()" class="txt_file_upload" style="margin-right: 10px;"/>
            <span style="vertical-align:middle; position:relative; width:13px; height:13px; overflow:hidden; cursor:pointer; background:url('${root}${HTML_IMG_DIR}/btn_file_attach.png') no-repeat; margin-right: 10px;">
                <input type="file" name="FD_FILE_PATH" id="FD_FILE_PATH" class="file_upload2">
            </span>
            <span class="btn_pack medium icon" style="margin-right: 10px;">
                <span class="upload"></span>
                <input value="XML Import" type="submit" id="send">
            </span>
            <input type="hidden" id="FILE_NM" name="FILE_NM"/>
        </form>
    </c:if>  

    <c:if test="${modelInfo.IsModel == '0' && (myItem eq 'Y' || loginInfo.sessionMlvl == 'SYS')}">
        <span class="btn_pack medium icon"><span class="download"></span><input value="XML Export" onclick="fnExportModelXml();" type="submit"></span>
    </c:if>  

    <c:if test="${modelInfo.ModelBlocked eq '0' && ( modelInfo.IsPublic eq '1' || myItem eq 'Y') }">
        <span class="btn_pack medium icon"><span class="edit"></span><input value="Edit" onclick="fnGoModelInfo('edit')" type="submit"></span>
    </c:if>  
</div>

	</div>
	<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
</html>