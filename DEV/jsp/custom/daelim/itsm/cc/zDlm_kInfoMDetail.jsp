<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root"/>
<script type="text/javascript">
var sessionAuthLev="${sessionScope.loginInfo.sessionAuthLev}";
var sessionUserId="${sessionScope.loginInfo.sessionUserId}";

var isManager = "${isManager}" 
var RegUserId = "${resultMap.RegUserID}";
var NEW = "${NEW}";
var screenType = "${screenType}";




</script><!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>

<!-- 관리자에게 삭제권한 부여  -->
<c:if test="${sessionScope.loginInfo.sessionLoginId == 'sys'}">
    <c:set var="isManager" value="1" />
</c:if>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>

<script type="text/javascript">
	var fileSize = "${itemFiles.size()}";
	var screenType = "${screenType}";
	var templProjectID = "${templProjectID}";
	var projectType = "${projectType}";
	var projectCategory = "${projectCategory}";

	
	jQuery(document).ready(function() {
	
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&BoardMgtID=${BoardMgtID}&projectType=${projectType}&templProjectID=${templProjectID}";
		fnSelect('project', data, 'getPjtMbrRl', templProjectID, 'Select');
		fnSelect('category', data, 'getBoardMgtCategory', '${resultMap.Category}', 'Select');
	});
	
	
	function doDelete(){
		//$add("BoardID", "${resultMap.BoardID}", boardFrm);
		if(confirm("${CM00002}")){
			var url = "zDlm_deleteKInfoM.do";
			ajaxSubmit(document.boardFrm, url,"blankFrame");
		}
	}
	
	var back = "&scStartDt=${scStartDt}"
		+"&projectID=${searchOrg}"
		+"&searchKey=${searchKey}"
		+"&searchValue=${searchValue}"
		+"&searchOrg=${searchOrg}"
		+"&scEndDt=${scEndDt}"
		+"&projectCategory="+projectCategory;
		
				
	function fnGoList(){
			
		if(screenType == "Admin"){
			goList(false, screenType, "${projectID}","${category}","${categoryIndex}","${categoryCnt}",back);
		}else{
			var url = "boardList.do";
			var data = "pageNum=${pageNum}"
						+"&url="+ encodeURIComponent("${url}")
						+"&screenType="+encodeURIComponent("${screenType}")
						+"&s_itemID="+encodeURIComponent("${projectID}")
						+"&defBoardMgtID="+encodeURIComponent("${defBoardMgtID}") 
						+"&category="+encodeURIComponent("${category}")
						+"&boardTypeCD=MN196"
						+ back
						+"&categoryIndex="+encodeURIComponent("${categoryIndex}")
						+"&categpryCnt=${categoryCnt}"
						+"&projectIDs="+ encodeURIComponent("${projectIDs}");
						
			if(screenType != "cust"){
				data = data + "&BoardMgtID="+encodeURIComponent("${BoardMgtID}");
			}
			var target = "help_content";
			ajaxPage(url, data, target);
		}
	}
	
	function doEdit(){
		var url = "zDlm_kInfoMEdit.do"; 
		var data = "NEW=N&"
			+"&categoryIndex=${categoryIndex}"
			+back
			+"&categpryCnt=${categoryCnt}"
			+"&templProjectID=${templProjectID}"
			+"&knoId="+$("#knoId").val()
			+"&searchKey="+$("#searchKey").val()
			+"&searchValue="+$("#searchValue").val();
			
					
		var target = "help_content";
		
		ajaxPage(url, data, target);
	}
	
	
	/* 첨부문서 다운로드 */
	function FileDownload(checkboxName, isAll){
		var seq = new Array();
		var j =0;
		var checkObj = document.all(checkboxName);
		
		// 모두 체크 처리를 해준다.
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = true;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = true;
			}
		}
		
		// 하나의 파일만 체크 되었을 경우
		if (checkObj.length == undefined) {
			if (checkObj.checked) {
				seq[0] = checkObj.value;
				j++;
			}
		};
		for (var i = 0; i < checkObj.length; i++) {
			if (checkObj[i].checked) {
				seq[j] = checkObj[i].value;
				j++;
			}
		}
		if(j==0){
			alert("${WM00049}");
			return;
		}
		j =0;
		var url  = "zDlm_kinfoMFileDownload.do?seq="+seq+"&scrnType=BRD&sqlId=zDLM_KINFOM.selectKnoDetail";
		//alert(url);
		ajaxSubmitNoAdd(document.boardFrm, url,"blankFrame");
		// 모두 체크 해제
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = false;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = false;
			}
		}
	}
	
	function fileNameClick(avg1){
		var seq = new Array();
		seq[0] = avg1;
		var url  = "zDlm_kinfoMFileDownload.do?seq="+seq+"&scrnType=BRD";
		ajaxSubmitNoAdd(document.boardFrm, url,"blankFrame");
	}
	
</script>
<style>
	strong,em{font-size:inherit;}
</style>
<!-- BEGIN :: DETAIL -->
<div class="mgL10 mgR10">
	<!-- BEGIN :: BOARD_FORM -->
	<form name="boardFrm" id="boardFrm" enctype="multipart/form-data" action="saveBoard.do" method="post" onsubmit="return false;">
		<input type="hidden" id="currPage" name="currPage" value="${currPage}">
		<input type="hidden" id="knoId" name="knoId" value="${resultMap.knoId}" >
		<input type="hidden" id="ATCH_FILE_ID" name="ATCH_FILE_ID" value="${resultMap.ATCH_FILE_ID}" >
		<div class="cop_hdtitle">
			<h3 style="padding: 8px 0;"><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png"></img>지식정보 상세조회</h3>
		</div>
		<div id="boardDiv" class="hidden" style="width:100%;">
		<table class="tbl_brd" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		
			<!-- 신규 등록 일때, 작성자 등록일 화면 표시 안함 -->
			<tr>
				<th width="12%"  >${menu.ZLN0018}</th>
				<td id="companyName"  class="alignL pdL5 last">
					${resultMap.companyName}
				</td>
			</tr>
			 <tr>
		        <th width="12%" >${menu.ZLN0024}</th>
		        <td id="srarea2Name" class="alignL pdL5 last">
		            ${resultMap.srarea2Name}
		        </td>
   			 </tr>
		    
		    <tr>
		        <th width="12%" >${menu.LN00212}</th>
		        <td id="userNm" class="alignL pdL5 last">
		         <c:out value="${resultMap.userNm}" escapeXml="false" />         
		        </td>
		    </tr>
		    <tr>
		        <th width="12%" >${menu.LN00002}</th>
		        <td id="knoNm" class="alignL pdL5 last">
		        	 <c:out value="${resultMap.knoNm}" escapeXml="false" />          
		        </td>
		    </tr>
   		    <tr>
		        <th width="12%" >${menu.ZLN0025}</th>
		        <td id="symtonDesc" class="alignL pdL5 last"  style = "height : 100px">
		        	<c:out value="${resultMap.symtonDesc} " escapeXml="false" />        
		        </td>
		    </tr>
   		    <tr>
		        <th width="12%" >${menu.ZLN0026}</th>
		        <td id="rootCauseDesc" class="alignL pdL5 last" style = "height : 100px">
		        	<c:out value="${resultMap.rootCauseDesc}" escapeXml="false" />
		        </td>
		    </tr>
		    <tr>
		        <th width="12%"  >${menu.ZLN0027}</th>
		        <td id="knoCn" class="alignL pdL5 last" style = "height : 100px">
		          <c:out value="${resultMap.knoCn}" escapeXml="false" />
		        </td>
		    </tr>
	

			<tr>
				<!-- 첨부문서 -->
				<th >${menu.LN00111}</th>
				<td  style="height:53px;" class="alignL pdL5 last">
					<!-- <div style="height:53px;overflow:auto;overflow-x:hidden;"> -->
					<div id="tmp_file_items" name="tmp_file_items"></div>
					<div class="floatR pdR20" id="divFileImg">
					<c:if test="${itemFiles.size() > 0}">
						<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('attachFileCheck', 'Y')"></span><br>
						<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('attachFileCheck', 'N')"></span><br>
					</c:if>
					</div>
					<c:forEach var="fileList" items="${itemFiles}" varStatus="status">
						<div id="divDownFile${fileList.fileSn}"  class="mm" name="divDownFile${fileList.fileSn}">
							<input type="checkbox" name="attachFileCheck" value="${fileList.fileSn}" class="mgL2 mgR2">
							<span style="cursor:pointer;" onclick="fileNameClick('${fileList.fileSn}');">${fileList.orignlFileNm}</span>
							<br>
						</div>
					</c:forEach>
					<!-- </div> -->
				</td>
			</tr>
			</table>
			
	<!-- END :: BOARD_FORM -->
	<!-- BEGIN :: Button -->
	<div class="alignBTN">
		
		<span id="viewEdit" class="btn_pack medium icon"><span class="edit"></span><input value="Edit" type="submit" onclick="doEdit()"></span>&nbsp;
		
		<c:if test="${isManager == '1'}">				
			<span id="viewDel" class="btn_pack medium icon"><span class="delete"></span><input value="Delete" type="submit" onclick="doDelete()"></span>&nbsp;
		</c:if>
		<span id="viewList" class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit"  onclick="fnGoList();"></span>
	</div>
	<!-- END :: Button -->
	</div>
	</form>

</div>
<!-- END :: DETAIL -->
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>