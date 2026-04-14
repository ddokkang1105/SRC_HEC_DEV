<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>

<script type="text/javascript">
	var fileData = ${fileData};
	var checkHeader = '<label class="dhx_checkbox dhx_cell-editor__checkbox"><input type="checkbox" dhx_id="cell_editor" class="dhx_checkbox__input allCheck" style="user-select: none;"><span class="dhx_checkbox__visual-input" onclick="fnAllchecked()"></span></label>'
	
	var fileGrid = new dhx.Grid("fileGrid", {
	    columns: [
	        { width: 60, id: "RNUM", header: [{ text: "${menu.LN00024}", align:"center" }], align: "center" },
	        { width:70, id: "check", header: [{ text: checkHeader, align:"center" }], align:"center",type: "boolean", editable: true},
	        { id: "FileRealName", header: [{ text: "${menu.LN00091}" }] },

	    ],
	    autoWidth: true,
	    selection: "row",
	    tooltip: false,
	    resizable:true,
	    data: fileData
	});
	
	function fnAllchecked() {
		if ($('.allCheck').is(':checked')) {
			fileData.forEach(function(element, index, array) {
				fileGrid.data.update(element.id, { check: false});
		    });
		} else {
			fileData.forEach(function(element, index, array) {
				fileGrid.data.update(element.id, { check: true});
		    });
		}
	}
	
	fileGrid.events.on("cellClick", function(row,column,e) {
		if("${sessionScope.loginInfo.sessionMlvl}" != "SYS" && "${myItem}" != 'Y') {
			var extFileURL = row.ExtFileURL;
			var sysFileName = row.FileName;
			var seq = row.Seq;
			
			var url = "openViewerPop.do?seq="+seq;
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
			var originalFileName = row.FileRealName;
			var sysFileName = row.FileName;
			var seq = row.Seq;
			var url  = "fileDownload.do?seq="+seq;

			ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
		}
	});
	
	function fnFileDownload(){
		var seq = new Array();
		var checked = fileGrid.data.findAll(function (item) {
		    if(item.check) {
		    	seq.push(item.Seq);
		    }
		});
		
		var url  = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
	}
</script>
</head>
<body>
<form name="fileMgtFrm" id="fileMgtFrm" action="fileDownloadDev.do" method="post" onsubmit="return false">
	<c:if test="${sessionScope.loginInfo.sessionMlvl == 'SYS'  or myItem == 'Y'}">
	<div class="floatR pdR20">
		<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="fnFileDownload()"></span>
		</div>
	</c:if>
	<div style="width: 100%;height:600px;" id="fileGrid"></div>
</form>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body></html>