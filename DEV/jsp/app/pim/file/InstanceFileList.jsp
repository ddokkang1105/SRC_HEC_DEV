<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033" />

<script type="text/javascript">

	var procInstNo = "${procInstNo}";
	var elmInstNo = "${elmInstNo}";
	var elmItemID = "${elmItemID}";
	var instanceClass = "${instanceClass}";
	var uploadFlag = "${uploadFlag}";
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 540)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 540)+"px;");
		};
		$("#TOT_CNT").text($("#fileMgtFrm tr").length-1);
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
	
	function fnFileDownLoad(seq,scrnType){
		var url  = "fileDownload.do?scrnType="+scrnType+"&seq="+seq;
		ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
	}
	
	// [Attach] 버튼 클릭
	function fnUploadPop(seq, FltpCode){
		if(uploadFlag == "T"){
				var url  = "addElmInstFilePop.do?elmInstNo="+elmInstNo+"&elmItemID="+elmItemID+"&instanceClass="+instanceClass+"&seq="+seq+"&FltpCode="+FltpCode;
				window.open(url,'window','width=600, height=300, left=300, top=300,scrollbar=no,resizble=0');
		} else {
			alert("${WM00033}");
			return false;
		}
	}
	
	function fnCallBack(){
		var url = "InstanceFileList.do";
		var data = "instanceNo="+procInstNo+"&elmInstNo="+elmInstNo+"&elmItemID="+elmItemID+"&instanceClass="+instanceClass;
		var target="cfgFrame";
		ajaxPage(url, data, target);
		
		//location.reload();
	}
	
	function fnInstfileDelete(fileID){
		var url = "instfileDelete.do"; // 임시 저장된 디렉토리의 파일 삭제
		var data = "fileID="+fileID;
		ajaxPage(url, data, "subFrame");
	}
</script>
<form name="fileMgtFrm" id="fileMgtFrm" action="#" method="post" onsubmit="return false;" >
	<div style="width:100%;overflow:auto;overflow-x:hidden;margin: 0;">
		<div class="countList">
        	<li class="count">Total  <span id="TOT_CNT"></span></li>
        </div>
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="3%">
				<col width="12%">
				<col width="20%">
				<col width="5%">
				<col width="25%">
				<col width="15%">
				<col width="10%">
				<col width="10%">
			</colgroup>
			<tr>
				<th class="viewline">No</th>
				<th class="viewline">${menu.LN00091}</th>
				<th class="viewline">샘플파일명</th>
				<th class="viewline">Upload</th>
				<th class="viewline">업로드파일명</th>
				<th class="viewline">comments</th>
				<th class="viewline">수정일</th>
				<th class="viewline last">작성자</th>
			</tr>
			<c:forEach var="fileList" items="${fileList}" varStatus="status">
			<tr>
				<td class="last" style="border-left: 1px solid #ddd;">${fileList.RNUM}</td>
				<td class="last">${fileList.ItemName}</td>
				<td class="alignL pdL10 last"><span onclick="fnFileDownLoad('${fileList.Seq}','')" style="color:#1236b7; font-weight:bold; cursor:pointer;">${fileList.FileRealName}</span></td>
				<td class="last"><img src="${root}${HTML_IMG_DIR}/icon_attach.png" style="cursor:pointer;" alt="업로드" onclick="fnUploadPop('${fileList.Seq}','${fileList.FltpCode}')"></td>
				<td class="alignL pdL10 last">
					<c:if test="${!empty(fileList.instFlie.FileID)}">
					<span onclick="fnFileDownLoad('${fileList.instFlie.FileID}','INST')" style="color:#1236b7; font-weight:bold; cursor:pointer;">${fileList.instFlie.FileRealName}</span>
					<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" onclick="fnInstfileDelete('${fileList.instFlie.FileID}')">
					</c:if>
				</td>
				<td class="alignL pdL10 last"><span>${fileList.instFlie.Description}</span></td>
				<td class="last">${fileList.LastUpdated}</td>
				<td class="last">${fileList.LastUser}</td>
			</tr>
			</c:forEach>
		</table>
	</div>	
</form>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>