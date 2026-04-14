<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<title>${menu.LN00262}</title>
</head>

<body>
<script type="text/javascript">
var itemFileOption = "${itemFileOption}";

	$(document).ready(function(){	
		$('.sem001').click(function(){
			$('.sem001').css('background-color', '#ffffff');
			$('.sem001').attr('alt', '');
			$(this).css('background-color', '#eafafc');
			$(this).attr('alt', '1');
		}).mouseover(function(){
			$(this).css('background-color', '#eafafc');
		}).mouseout(function(){
			if($(this).attr('alt') != 1) 
				$(this).css('background-color', '#ffffff');
		});

		var downYN = "${downYN}";
		
		if(downYN != "") {
			var url  = "fileDownload.do?seq=${Seq}";
			ajaxSubmitNoAdd(document.fileFrm, url,"subFrame");	
		}
	});

	function downFile(avg, extFileURL) {
		if("${sessionScope.loginInfo.sessionMlvl}" != "SYS" && "${myItem}" != 'Y' && itemFileOption == "VIEWER" ) {
			var url = "openViewerPop.do?seq="+avg;
			var w = 1200;
			var h = 900;
			if(extFileURL != "") { 
				w = screen.availWidth-38;
				h = screen.avilHeight;
				url = url + "&isNew=N";	
			}
			else {
				url = url + "&isNew=Y";
			}
			
			itmInfoPopup(url,w,h); 
		}else{
			var url  = "fileDownload.do?seq="+avg;
			ajaxSubmitNoAdd(document.fileFrm, url,"blankFrame");	
		}
	}
	

	function fnFileDownload(avg){
		var cnt  = $("input:checkbox[name='fileChk']:checked").length;
		var originalFileName = new Array();
		var sysFileName = new Array();
		var seq = new Array();
		var chkVal;
		var j =0;	
		
		if (cnt == 0 && avg != "ALL") {
			alert("${WM00049}");
			return;
		}
		
		$("input:checkbox[name='fileChk']").each(function() {
		      if(this.checked || avg == "ALL"){
		    	  seq[j] = this.value;
		    	  j++;
		      }
		});
		
		var url  = "fileDownload.do?seq="+seq;

		ajaxSubmitNoAdd(document.fileFrm, url,"blankFrame");
	}	

</script>
<form name="fileFrm" id="fileFrm" action="" method="post" onsubmit="return false;">
	
<div id="objectInfoDiv" class="hidden" style="height:320px; overflow-y:auto;">
	<ul id="breadcrumb">
        <li><span>${menu.LN00262}</span></li>
    </ul>
    <div class="alignR mgR10">
    <c:if test="${itemFileOption == 'OLM' or (myItem == 'Y' &&  itemFileOption != 'ExtLink') }">
	    <span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="fnFileDownload('')"></span>
		<span class="btn_pack medium icon"><span class="download"></span><input value="Save ALL" type="button" onclick="fnFileDownload('ALL')"></span>
	</c:if>			
    </div>	
	<div id="selAttr" style="overflow:auto;overflow-x:hidden;">			
		<table class="tbl_blue01 mgT5" width="90%" cellpadding="0" cellspacing="0" border="0">
	        <colgroup>
	        	<col width="5%">
	        	<col width="20%">
	        	<col width="75%">
	        </colgroup>
	        <tr>
	            <th class="viewtop"></th>
	            <th class="viewtop">${menu.LN00091}</th>
	            <th class="viewtop">${menu.LN00101}</th>
	        </tr>
			<c:forEach var="i" items="${fileList}" varStatus="listStatus">
            <tr class="sem001">
                <td><input type="checkbox" name="fileChk" value="${i.Seq}"/></td>                
                <td onclick="downFile('${i.Seq}','${i.ExtFileURL}')">${i.FltpName}</td>
                <td onclick="downFile('${i.Seq}','${i.ExtFileURL}')" class="alignL">${i.FileRealName}</td>
            </tr>
			</c:forEach>			
	     </table>
	</div>	
</div>	
</form>
<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>
</body>
</html>