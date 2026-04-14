<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033" />

<script type="text/javascript">

	var scrID = "${scrId}"; 
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:60px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:60px;");
		};
	});
	
	function setWindowHeight(){
		var size = window.innerHeight;
		var height = 0;
		if( size == null || size == undefined){
			height = document.body.clientHeight;
		}else{
			height=window.innerHeight;
		}return height;
	}
	
	function fnFileDownLoad(seq){	
		var url  = "fileDownload.do?seq="+seq;

		ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
	}
	
	// [Attach] 버튼 클릭
	function fnUploadPop(fltpCode,fileID,roleType){
		var finTestor = "${finTestor}";
		var scrUserID = "${scrUserID}";
		var scrStatus = "${scrStatus}";
		if(scrStatus != "APREQ" && scrStatus != "APRJT" && scrStatus != "CLS" && scrUserID == "${sessionScope.loginInfo.sessionUserId}"){
				var url  = "addScrFilePop.do?scrId="+scrID+"&fltpCode="+fltpCode+"&fileID="+fileID+"&srID=${srID}";
				window.open(url,'window','width=600, height=300, left=300, top=300,scrollbar=no,resizble=0');
		} else {
			alert("${WM00033}");
			return false;
		}
	}
	
	function fnCallBack(scrId,scrStatus){
		var url = "scrFileList.do";
		var data = "scrID="+scrId;
		var target="tabFrame";
		ajaxPage(url, data, target);
	}
</script>
<form name="fileMgtFrm" id="fileMgtFrm" action="#" method="post" onsubmit="return false;" >
	<div style="width:100%;overflow:auto;overflow-x:hidden;margin: 0;">
		<div class="countList">
        	<li class="count">Total  <span id="TOT_CNT"></span></li>
        </div>
		
		<div style="width:100%;" id="layout"></div>
		<div id="pagination" style="margin-top: 60px;"></div>
		
	</div>	
</form>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>


<script type="text/javascript">
var layout = new dhx.Layout("layout", {
    rows: [
        {
            id: "a",
        },
    ]
});

var gridData = ${gridData};
var grid = new dhx.Grid("layout", {
    columns: [
        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
        { width: 120, id: "FltpName", header: [{ text: "${menu.LN00091}" , align: "center" }, { content: "inputFilter" }], align: "center" },
        { id: "FileRealName1", header: [{ text: "샘플파일명", align: "center"  }, { content: "inputFilter" }],htmlEnable: true,
       		template: function (text, row, col) {
       			return `<span onclick="fnFileDownLoad('` + row.Seq + `')" style="color:#1236b7; font-weight:bold; cursor:pointer;">` + text + `</span>`;
        }},
        
        { width: 60, id: "upload", header: [{ text: "Upload" , align: "center" }], align: "center",htmlEnable: true,
			template: function (text, row, col) {
				<c:if test="${scrStatus ne 'APREQ' && scrStatus ne 'APRJT' && scrStatus ne 'CLS' && scrUserID eq sessionScope.loginInfo.sessionUserId}">
					var fileID = row.FileID;
					if(fileID == undefined) fileID = "";
		    		return `<img src="${root}${HTML_IMG_DIR}/icon_attach.png" style="cursor:pointer;" alt="업로드" onclick="fnUploadPop('` + row.FltpCode + `','` + fileID + `')">`;
		    	</c:if>
		}},
        { id: "FileRealName2", header: [{ text: "업로드파일명" , align: "center" }, { content: "inputFilter" }],htmlEnable: true,
       		template: function (text, row, col) {
       			if(text!= "" && text != undefined){
       				return `<span onclick="fnFileDownLoad('` + row.FileID + `')" style="color:#1236b7; font-weight:bold; cursor:pointer;">` + text + `</span>`;
       			}
        }},
        { id: "", header: [{ text: "comments" , align: "center" }, { content: "inputFilter" }],htmlEnable: true,
       		template: function (text, row, col) {
       			var code = row.FltpCode;
       			var val = "";
       			if(code != 'SCR002'){
       				val = row.Description;
       			}else{
       				val = row.FinTestResult;
       			}
       			if(val != undefined) {
	       			return `<td class="alignL pdL10 last"><span>` + val + `</span></td>`;
       			}
        }},
        { width: 120,id: "LastUpdated", header: [{ text: "수정일" , align: "center" }, { content: "inputFilter" }], align: "center" },
        { width: 100,id: "LastUser", header: [{ text: "작성자" , align: "center" }, { content: "inputFilter" }], align: "center" },
    ],
    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    data: gridData
});
layout.getCell("a").attach(grid);

$("#TOT_CNT").html(grid.data.getLength());

</script>