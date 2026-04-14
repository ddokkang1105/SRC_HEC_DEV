<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_1" arguments="${menu.LN00131}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_2" arguments="${menu.LN00191}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_3" arguments="${menu.LN00217}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_4" arguments="${menu.LN00221}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025_5" arguments="${menu.LN00220}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00015" var="WM00015" arguments="${menu.LN00221}"/>

<script type="text/javascript">
	chkReadOnly = false;
</script>
<script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script>
<script type="text/javascript">
	
	$(document).ready(function(){
		$("input.datePicker").each(generateDatePicker);
		
		fnSelect('Priority', '&Category=PRT', 'getDicWord', '${getMap.Priority}', 'Select');
		
		$('#Project').change(function(){
			changeCsrList($(this).val()); // 변경오더 option 셋팅
		});
		changeCsrList("${getMap.ProjectID}", "${getMap.CSRID}"); // 변경오더 option 셋팅
		
	});
	
	//================================================================================================================================================
	
	// [Save]
	function saveReceiveInfo() {
		// 프로젝트, 변경오더, 유형, 완료예정일, 처리자 필수 Check
		if ($('#Project').val() == "") {
			alert("${WM00025_1}");
			return;
		}
		if ($('#CsrList').val() == "") {
			alert("${WM00025_2}");
			return;
		}
		if ($('#ItemType').val() == "") {
			alert("${WM00025_3}");
			return;
		}
		if ($('#DueDate').val() == "") {
			alert("${WM00025_4}");
			return;
		}
		if ($('#Actor').val() == "") {
			alert("${WM00025_5}");
			return;
		}
		
		// 완료예정일 check : 시스템 날짜보다과거 이면 안됨
		var sysDate = "${thisYmd}";
		var dueDate = $('#DueDate').val();
		if (fnDateCompare(dueDate, sysDate) > 0) {
			alert("${WM00015}");
			return;
		}
		
		if(confirm("${CM00001}")){
			var url = "saveReceiveInfo.do";
			ajaxSubmit(document.receiveIssueFrm, url);
		}
	}
	
	// [after Save][List]
	function goDetail(issueId) {
		// Issue 상세 화면으로 이동
		var url = "issueInfoDetail.do";
		var data = "issueMode=${issueMode}&issueId=" + issueId
					+ "&currPageI=${currPageI}"
					+ "&ParentID=${ParentID}"
					+ "&screenType=${screenType}";
		var target = "help_content"; if("${screenType}"=="csrDtl"){ target="tabFrame"; }
		ajaxPage(url, data, target);
	}
	
	// [변경오더 option] 설정
	function changeCsrList(avg, defaultValue){
		var url    = "getCsrListOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&isIssue=Y&parentPjtID="+avg+"&Creator=${getMap.Receiver}"; //파라미터들
		var target = "CsrList";             // selectBox id
		ajaxSelect(url, data, target, defaultValue);
		setTimeout(changeActorList,1000);
	}
	
	// [처리자 option] 설정
	function changeActorList(){
		var url    = "getActorListOption.do"; // 요청이 날라가는 주소
		var data   = "CsrID="+$('#CsrList').val(); //파라미터들
		var target = "Actor";             // selectBox id
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, "", isAll);
	}
	
	//================================================================================================================================================
		
	// [Attach] 버튼 클릭
	function fnMultiUpload(){
		var browserType="";
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url="addFilePop.do";
		var data="scrnType=BRD&browserType="+browserType;//+"&mgtId="+$("#BoardMgtID").val()+"&id="+$('#BoardID').val();
		if(browserType=="IE"){fnOpenLayerPopup(url,data,"",400,400);}
		else{openPopup(url+"?"+data,490,360, "Attach File");}
	}
	function fnAttacthFileHtml(seq, fileName){
		display_scripts=$("#tmp_file_items").html();
		display_scripts = display_scripts+
			'<div id="divDownFile'+seq+'"  class="mm" name="divDownFile'+seq+'">'+fileName+
			'	<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteFileHtml('+seq+','+ "'" + fileName + "'"+')">'+
			'	<br>'+
			'</div>';		
		document.getElementById("tmp_file_items").innerHTML = display_scripts;		
	}
	
	// [편집 모드 일때] 첨부파일 다운로드 관련
	function FileDownload(checkboxName, isAll){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
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
		var url  = "fileDownload.do?seq="+seq+"&scrnType=ISSUE";
		ajaxSubmitNoAdd(document.receiveIssueFrm, url,"saveFrame");
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
	function fileNameClick(avg1, avg2, avg3, avg4){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		sysFileName[0] =  avg3 + avg1;
		originalFileName[0] =  avg3;
		filePath[0] = avg3;
		seq[0] = avg4;
		var url  = "fileDownload.do?seq="+seq+"&scrnType=ISSUE";
		ajaxSubmitNoAdd(document.receiveIssueFrm, url,"saveFrame");
	}
	
	function fnDeleteItemFile(IssueID, seq, fileName, filePath){
		var url = "issueFileDelete.do";
		var data = "IssueID="+IssueID+"&Seq="+seq+"&realFile="+filePath+fileName;
		ajaxPage(url, data, "saveFrame");
		$('#divDownFile'+seq).hide();
	}
	function fnDeleteFileHtml(seq, fileName){
		var url = "pjtDirFileDel.do"; // 임시 저장된 디렉토리의 파일 삭제
		var data = "fileName="+fileName;
		ajaxPage(url, data, "saveFrame");
		$('#divDownFile'+seq).hide();
	}
	
</script>

<form name="receiveIssueFrm" id="receiveIssueFrm" enctype="multipart/form-data" method="post" action="#" onsubmit="return false;">
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
	<input type="hidden" id="isIssueEdit" name="isIssueEdit" value="${isIssueEdit}" />
	<input type="hidden" id="IssueID" name="IssueID" value="${getMap.IssueID}" />
	<input type="hidden" id="IssueCode" name="IssueCode" value="${getMap.IssueCode}" />
	
	<!-- 화면 타이틀 : Issue 접수 -->
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 0 0 6px 0">
			<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;
				${menu.LN00230}  
		</h3>
	</div>
	
	<div id="objectInfoDiv" class="hidden floatC" style="width:100%;overflow-x:hidden;overflow-y:auto;">
		<!-- button table  -->
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;">
        <tr>
           <td class="alignR pdR20 last" bgcolor="#f9f9f9">
	        	&nbsp;<span class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="button" onclick="fnMultiUpload()"></span> 
	            &nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="saveReceiveInfo()" type="submit"></span> 
	            &nbsp;<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="goDetail(${getMap.IssueID})" type="submit"></span>
      		</td>
      	</tr>
      	</table>
		
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;">
			<colgroup>
				<col width="8%">
				<col width="17%">
				<col width="8%">
				<col width="17%">
				<col width="8%">
				<col width="17%">
			</colgroup>
			<tr>
				<!-- 프로젝트 -->
		       	<th>${menu.LN00131}</th>
		        <td class="alignL pdL10"> 
			        <select id="Project" Name="Project">
			        	<c:if test="${issueMode != 'PjtMgt'}">
			           		<option value=''>Select</option>
			           	</c:if>
			           	<c:forEach var="i" items="${projectList}">
			               	<option value="${i.CODE}" <c:if test="${i.CODE == getMap.ProjectID}">selected="selected"</c:if>>${i.NAME}</option>
			           	</c:forEach>
			       	</select>
		       	</td>
		       	
		       	<!-- 변경 오더 -->
		       	<th>${menu.LN00191}</th>
		        <td class="alignL pdL10"> 
			        <select id="CsrList" Name="CsrList">
			       	</select>
		       	</td>
					
				<!-- 유형  -->
				<th>${menu.LN00217}</th>
				<td class="alignL pdL10 last">
					<select id="ItemType" Name="ItemType">
			           	<option value=''>Select</option>
			           	<c:forEach var="i" items="${itemTypeList}">
			               	<option value="${i.ItemTypeCode}" <c:if test="${i.ItemTypeCode == getMap.ItemTypeCode}">selected="selected"</c:if>>${i.Name}</option>
			           	</c:forEach>
			       	</select>
				</td>
			</tr>
			<tr>
				<!-- 완료예정일 -->
				<th>${menu.LN00221}</th>
				<td class="alignL pdL10">
					<input type="text" id="DueDate" name="DueDate" value="" class="text datePicker" style="width: 70px;" onchange="this.value = makeDateType(this.value);" maxlength="10">
				</td>
				
				<!-- 처리자 -->
				<th>${menu.LN00220}</th>
				<td class="alignL pdL10">
					<select id="Actor" Name="Actor">
				    	<option value=''>Select</option>
				    </select>
			    </td>
			    
			    <!-- 우선순위 -->
				<th>${menu.LN00067}</th>
				<td class="alignL pdL10">
					<select id="Priority" Name="Priority">
				    </select>
			    </td>
			</tr>
			<!-- 첨부파일 -->	
			<tr>
				<th>${menu.LN00111}</th>
				<td colspan="5" class="alignL pdL5 last">
					<div style="height:100px;width:100%;overflow:auto;overflow-x:hidden;">
						<div id="tmp_file_items" name="tmp_file_items"></div>
						<div class="floatR pdR20" id="divFileImg">
						<c:if test="${issueFiles.size() > 0}">
							<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('attachFileCheck', 'Y')"></span><br>
							<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('attachFileCheck', 'N')"></span><br>
						</c:if>
						</div>
						<c:forEach var="fileList" items="${issueFiles}" varStatus="status">
							<div id="divDownFile${fileList.Seq}" class="mm" name="divDownFile${fileList.Seq}">
								<input type="checkbox" name="attachFileCheck" value="${fileList.Seq}" class="mgL2 mgR2">
								<span style="cursor:pointer;" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.Seq}');">${fileList.FileRealName}</span>
								<c:if test="${isIssueEdit == 'Y'}"> 
									<c:if test="${sessionScope.loginInfo.sessionUserId == fileList.RegMemberID}">
										<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteItemFile('${fileList.IssueID}','${fileList.Seq}','${fileList.FileName}','${issueFilePath}')">
									</c:if>
								</c:if>
								<br>
							</div>
						</c:forEach>
					</div>
				</td>
			</tr>
			
			<!-- 대응방안 -->			
			<tr>
				<th>${menu.LN00229}</th>
				<td colspan="5" class="last">
					<textarea class="textgrow" id="Response" name="Response" style="width:100%;height:100px;"></textarea>
				</td>
			</tr>
			
			
		</table>
	</div>
	
	</form>
	
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;"></iframe>
