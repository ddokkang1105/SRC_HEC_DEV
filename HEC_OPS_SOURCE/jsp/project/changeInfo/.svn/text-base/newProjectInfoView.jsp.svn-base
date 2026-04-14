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
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00086" var="WM00086_1" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00086" var="WM00086_2" arguments="${menu.LN00004}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00086" var="WM00086_3" arguments="${menu.LN00201}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00026" var="CM00026" arguments="${menu.LN00082}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00028" var="CM00028"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00131" var="WM00131"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00051" var="CM00051"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00015" var="CM00015" />

<!-- <script src="<c:url value='/cmm/js/xbolt/tinyEditorHelper.js'/>" type="text/javascript"></script> -->
<script type="text/javascript">
	
	$(document).ready(function(){
		$("input.datePicker").each(generateDatePicker);
		
		fnSelect('Reason','&Category=CR','dictionyCode','${getMap.Reason}', 'Select');
		fnSelect('Priority', '&Category=PRT', 'dictionyCode', '${getMap.Priority}', 'Select');
		
		// 기존의 담당자 화면 표시
		if ('${isNew}' == 'N' || '${isNew}' == 'R') {
			var pjtMemberInfos = '${getMap.PjtMemberInfos}';
			$('#memberIds').val('${getMap.PjtMemberIDs}');
			var curMemberArray = $('#memberIds').val().split(', ');
			var memberInfoArray = pjtMemberInfos.split(', ');
			
			for (var i in curMemberArray) {
				var memberId = curMemberArray[i];
				var memberInfo = memberInfoArray[i];
				var display_script = '<a href="#" id=user_'+memberId+' onclick=removeMember('+memberId+')>'+ memberInfo + ', '  + '</a>';
				if ('${isNew}' == 'R') {
					display_script = '<span id=user_'+memberId+'>'+ memberInfo + ', '  + '</span>';
				}
				$('#membersDiv').append(display_script);
			}
			
			$('#ParentID').val("${getMap.ParentID}");
		} else {
			// 신규등록
			$('#ParentID').val($("#ParentPjt").val());
		}
		
		// 개요 입력창 제어 : 변경오더 조회 화면인 경우 편집 불가
		//if ('${isNew}' == 'R') {
		//	chkReadOnly = true;
		//}
		
	});
	
	//================================================================================================================================================
	
	// [Save]
	function savePrj() {
		// 명칭 , 사유, 담당자 필수 Check
		if ($('#ProjectName').val() == "") {
			alert("${WM00086_1}");
			return;
		}
		if ($('#Reason').val() == "") {
			alert("${WM00086_3}");
			return;
		}
		if ($('#memberIds').val() == "") {
			alert("${WM00086_2}");
			return;
		}
		
		if(confirm("${CM00001}")){
			var url = "saveCSRInfo.do";
			ajaxSubmit(document.projectInfoFrm, url);
		}
	}
	
	// [after Save]
	function goEdit(pjtId) {
		if ("batch" == "${btn}") {
			goBack(); // 변경오더 목록 화면 표시
		} else {
			goChangeInfoEdit(pjtId); // 편집 화면으로 이동
		}
	}
	
	function searchPopup(url){
		var param = "?csrId=${ProjectID}&parentId=" + $("#ParentID").val();
		window.open(url + param,'window','width=650, height=500, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	// 추가된 담당자 화면 표시 및 중복 담당자 체크 
	function setMembers(memberIds, memberInfoList){
		var memberArray = memberIds.split(',');
		var memberInfoArray = memberInfoList.split(',');
		var curMemberArray = $('#memberIds').val().split(',');
		var cngCountArray = $('#cngCount').val().split(',');
		
		var newMemberIds = $('#memberIds').val();
		var newCngCount = $('#cngCount').val();
		
		for (var i in memberArray) {
			var memberId = memberArray[i];
			var cngCount = cngCountArray[i];
			var memberInfo = memberInfoArray[i];
			
			if( $.inArray( memberId ,  curMemberArray) != -1 ) {
				var msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00127' var='WM00127' arguments='"+ memberInfo +"'/>";
				alert("${WM00127}");
			} else {
				var display_script = '<a href="#" id=user_'+memberId+' onclick=removeMember('+memberId+')>'+ memberInfo + ', '  + '</a>';
				$('#membersDiv').append(display_script);
				if (newMemberIds == "") {
					newMemberIds = memberId;
					newCngCount = cngCount;
				} else {
					newMemberIds = newMemberIds + "," + memberId;
					newCngCount = newCngCount + "," + cngCount;
				}
			}
		}
		$('#memberIds').val(newMemberIds);
		$('#cngCount').val(newCngCount);
	}
	
	// [추가된 담당자 정보] click 이벤트 : 클릭된 담당자정보를 삭제
	function removeMember(removeMemberId) {
		if(confirm("${CM00002}")){
			// DB처리 할 memberId에서 해당 memberId를 삭제
			var curMemberArray = $('#memberIds').val().split(',');
			var cngCountArray = $('#cngCount').val().split(',');
			var newMemberIds = "";
			var newCngCount = "";
			
			for (var i in curMemberArray) {
				var memberId = curMemberArray[i];
				var cngCount = cngCountArray[i];
				
				if (removeMemberId == memberId) {
					if (cngCount != 0) {
						alert("${WM00131}");
						return false;
					}
				}
				
				if(removeMemberId != memberId) {
					if (newMemberIds == "") {
						newMemberIds = memberId;
						newCngCount = cngCount;
					} else {
						newMemberIds = newMemberIds + "," + memberId;
						newCngCount = newCngCount + "," + cngCount;
					}
				}
			}
			$('#memberIds').val(newMemberIds);
			$('#cngCount').val(newCngCount);
			
			$('#user_'+removeMemberId).html(''); // 화면 표시 삭제
			
		}
	}
	
	// [List]
	function goBack() {
		var isItemInfo = "${isItemInfo}";
		var url = "csrList.do";
		var mainMenu = "${mainMenu}";
		
		if (mainMenu == 2) {
			mainMenu = 1;
		}
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&mainMenu="+  mainMenu +"&s_itemID=${s_itemID}";
		
		if (isItemInfo == "Y") {
			url = "itemHistory.do"; // 변경이력
			data = "s_itemID=${seletedTreeId}";
		}
		
		var target = "help_content";
		ajaxPage(url, data, target);
	}
	
	// [Attach] 버튼 클릭
	function fnMultiUpload(){
		var browserType="";
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url="addFilePop.do";
		var data="scrnType=BRD&browserType="+browserType;//+"&mgtId="+$("#BoardMgtID").val()+"&id="+$('#BoardID').val();
		if(browserType=="IE"){fnOpenLayerPopup(url,data,"",400,400);}
		else{openPopup(url+"?"+data,360,360, "Attach File");}
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
		
		// 하나의 파일만 체크 되었을 경우
		if (checkObj.length == undefined) {
			if (checkObj.checked) {
				var checkObjVal = checkObj.value.split(',');
				sysFileName[0] =  checkObjVal[2] + checkObjVal[0];
				originalFileName[0] =  checkObjVal[1];
				filePath[0] = checkObjVal[2];
				seq[0] = checkObjVal[3];
				j++;
			}
		};
		for (var i = 0; i < checkObj.length; i++) {
			if (checkObj[i].checked) {
				var checkObjVal = checkObj[i].value.split(',');
				sysFileName[j] =  checkObjVal[2] + checkObjVal[0];
				originalFileName[j] =  checkObjVal[1];
				filePath[j] = checkObjVal[2];
				seq[j] = checkObjVal[3];
				j++;
			}
		}
		if(j==0){
			alert("${WM00049}");
			return;
		}
		j =0;
		var url  = "fileDownload.do?seq="+seq;
		//alert(url);
		ajaxSubmitNoAdd(document.projectInfoFrm, url,"saveFrame");
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
		var seq = new Array();
		sysFileName[0] =  avg3 + avg1;
		originalFileName[0] =  avg3;
		seq[0] = avg4;
		var url  = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.projectInfoFrm, url,"saveFrame");
	}
	
	function fnDeleteItemFile(ProjectID, seq, fileName, filePath){
		var url = "pjtFileDelete.do";
		var data = "ProjectID="+ProjectID+"&Seq="+seq+"&realFile="+filePath+fileName;
		ajaxPage(url, data, "saveFrame");
		$('#divDownFile'+seq).hide();
	}
	function fnDeleteFileHtml(seq, fileName){
		var url = "pjtDirFileDel.do"; // 임시 저장된 디렉토리의 파일 삭제
		var data = "fileName="+fileName;
		ajaxPage(url, data, "saveFrame");
		$('#divDownFile'+seq).hide();
	}
	
	// [Edit] click : 변경오더 조회 화면 일때
	function goChangeInfoEdit(avg) {
		// login user가 Creator 인경우 : [변경오더 편집] 화면으로 이동
		var projectId = avg;
		var isNew ="N";
		var url = "newProjectInfoView.do";
		var data = "ProjectID=" + projectId + "&isNew=" + isNew + "&mainMenu=${mainMenu}&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}&s_itemID=${s_itemID}";
		var target = "help_content";
		ajaxPage(url, data, target);
	}
	
	// [Request] click : 변경오더 조회 화면 일때
	function goSetWfStepInfo() {
		var url = "createWFDocCSR.do";
		var data = "ProjectID=${ProjectID}&isNew=${isNew}&mainMenu=${mainMenu}&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}&s_itemID=${s_itemID}";
		var target = "help_content";
		ajaxPage(url, data, target);
	}
	
	// [Menu 아이콘]Click : 변경오더 조회, 편집 화면인 경우
	function goMenu(avg) {
		if (avg == "changeInfo") {
			// 변경항목 목록으로 이동
			var url = "changeInfoList.do";
			var data = "ProjectID=${ProjectID}&isNew=${isNew}&mainMenu=${mainMenu}&s_itemID=${s_itemID}" 
					+ "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}&isFromPjt=Y";
			var target = "help_content";
			ajaxPage(url, data, target);
		}
		
		if (avg == "issueInfo") {
			// Issue 목록으로 이동
			var url = "issueSearchList.do";
			var data = "ProjectID=${ProjectID}&isNew=${isNew}&mainMenu=${mainMenu}&s_itemID=${s_itemID}" 
					+ "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}"
					+ "&Creator=${getMap.Creator}&ParentID=${getMap.ParentID}&issueMode=CSR";
			var target = "help_content";
			ajaxPage(url, data, target);
		}
		
		if (avg == "approveInfo") {
			// 변경 승인 내역 화면으로 이동
			var url = "csrAprvHistory.do";
			var data = "ProjectID=${ProjectID}&isNew=${isNew}&mainMenu=${mainMenu}&s_itemID=${s_itemID}" 
					+ "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}";
			var target = "help_content";
			ajaxPage(url, data, target);
		}
		
	}
	
	// [프로젝트] : parent 프로젝트 선택시 추가된 담당자 정보를 clear (변경오더 등록인 경우만)
	function clearMember() {
		if ($('#memberIds').val() != "") {
			if(confirm("${CM00051}")){
				$('#memberIds').val('');
				$('#cngCount').val('');
				$('#membersDiv').html('');
				$('#ParentID').val($("#ParentPjt").val());
			} else {
				// 선택 바꾸기전의 프로젝트 값으로 재설정
				$("#ParentPjt").val($('#ParentID').val()).attr("selected", "selected");
			}
		} else {
			$('#ParentID').val($("#ParentPjt").val());
		}
	}
	
	// [Approve] click
	function approve() {
		if (confirm("${CM00015}")) {
			var url = "argAprMultiUpdate.do";
			var data = "pjtIds=${ProjectID}";
			var target = "saveFrame";			
			ajaxPage(url, data, target);
		}
	}
	
</script>
</head>
<body>
<form name="projectInfoFrm" id="projectInfoFrm" enctype="multipart/form-data" method="post" action="#" onsubmit="return false;">
	<input type="hidden" id="ProjectID" name="ProjectID"  value="${ProjectID}" />
	<input type="hidden" id="ParentID" name="ParentID"  value="" />
	<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
	<input type="hidden" id="ProjectCode" name="ProjectCode" value="${ProjectCode}" />
	<input type="hidden" id="isNew" name="isNew" value="${isNew}"/>
	<input type="hidden" id="btn" name="btn" value="${btn}"/>
	<input type="hidden" id="memberIds" name="memberIds"  value="${memberIds}" />
	<input type="hidden" id="cngCount" name="cngCount"  value="${cngCountOfmember}" />
	
	<!-- 화면 타이틀(변경 오더) : N - 편집, Y - 등록, R - 조회 -->
	<!-- 화면 타이틀(승인 요청) : 승인 요청 -->
	<!-- 화면 타이틀(변경 승인) : 변경 승인 -->
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 6px 0 6px 0">
			<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;
			<c:if test="${mainMenu == 1 || mainMenu == 4}">
				<c:if test="${isNew == 'N'}"> 
					${menu.LN00181}   
				</c:if>
				<c:if test="${isNew == 'Y'}">
					${menu.LN00180}    
				</c:if>
				<c:if test="${isNew == 'R'}">
					${menu.LN00203}    
				</c:if>
			</c:if>
			<c:if test="${mainMenu == 2}">
				${menu.LN00208}
			</c:if>
			<c:if test="${mainMenu == 3}">
				${menu.LN00137}
			</c:if>
			<c:if test="${mainMenu == 0}">
				${menu.LN00203}
			</c:if>
		</h3>
	</div>
	
	<div id="objectInfoDiv" class="hidden floatC" style="width:100%;overflow-x:hidden;overflow-y:auto;">
		
		
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;">
			<colgroup>
				<col width="10%">
				<col width="17%">
				<col width="8%">
				<col width="17%">
				<col width="8%">
				<col width="17%">
				<col width="8%">
				<col width="15%">
			</colgroup>
			<tr>
				<!-- 명칭  -->
				<th class="viewtop">${menu.LN00028}</th>
				<td class="viewtop">
					<c:if test="${isNew == 'Y' || isNew == 'N'}">
						<input type="text" class="text" id="ProjectName" name="ProjectName" value="${getMap.ProjectName}"/> 
					</c:if>
					<c:if test="${isNew == 'R'}">${getMap.ProjectName}</c:if>
				</td>
				
				<!-- Project 선택 -->
				<th class="viewtop">${menu.LN00131}</th>
				<td class="viewtop">
					<c:if test="${isNew == 'Y'}">  
						<select id="ParentPjt" name="ParentPjt" style="width:80%" onchange="clearMember();">
							<c:forEach var="i" items="${parentPjtList}">
								<option value="${i.CODE}">${i.NAME}</option>
							</c:forEach>
						</select>
					</c:if>
					<c:if test="${isNew == 'N' || isNew == 'R'}">  
						${getMap.ParentName}
					</c:if>
				</td>
				<!-- 담당자 -->
				<th class="viewtop">${menu.LN00266}</th>
				<td class="viewtop">${getMap.AuthorName}</td> 
				
				<!-- 담당조직  -->
				<th class="viewtop">담당조직</th>
				<td class="viewtop last">${getMap.AuthorTeamName}</td>
			</tr>
			<tr>
				<!-- 사유 -->
				<th>${menu.LN00201}</th>
				<td class="alignL pdL5">
					<c:if test="${isNew == 'Y' || isNew == 'N'}"> 
						<select id="Reason" name="Reason" class="sel" style="width:80%"></select>
					</c:if>
					<c:if test="${isNew == 'R'}">  
						<select id="Reason" name="Reason" class="sel" style="width:80%" disabled="disabled"></select>
					</c:if>
				</td>
				
				<!-- 우선순위 -->
		       <th >${menu.LN00067}</th>
		       <td class="alignL pdL5" > 
			       <c:if test="${isNew == 'Y' || isNew == 'N'}">     
						<select id="Priority" Name="Priority" style="width:80%"></select>
			       </c:if>
			       <c:if test="${isNew == 'R'}">  
						<select id="Priority" Name="Priority" style="width:80%" disabled="disabled"></select>
				   </c:if>
			   </td>	
			   <!-- 생성자  -->
				<th>${menu.LN00200}</th>
				<td>${getMap.CreatorName}	</td>
				
				<!-- 상태  -->
				<th>${menu.LN00027}</th>
				<td class="last">${getMap.StatusName}</td>
			</tr>
			
			<tr>
				<!-- 등록일 -->
				<th>${menu.LN00013}</th>
				<td class="pdL5">	${getMap.CreationTime}</td>
				
				<!-- 시작일 -->
				<th>${menu.LN00063}</th>
				<td class="pdL5">
					<c:if test="${isNew == 'N'}"> 
						<input type="text" id="StartDate" name="StartDate" value="${getMap.StartDate}" class="text datePicker" style="width: 70px;" onchange="this.value = makeDateType(this.value);" maxlength="10">
					</c:if>
					<c:if test="${isNew == 'Y'}"> 
						<input type="text" id="StartDate" name="StartDate" value="${thisYmd}" class="text datePicker" style="width: 70px;" onchange="this.value = makeDateType(this.value);" maxlength="10"> 
					</c:if>
					<c:if test="${isNew == 'R'}"> 	${getMap.StartDate}
					</c:if>
				</td>
				<!-- 마감일 -->
				<th>${menu.LN00062}</th>
				<td  class=" pdL5">
					<c:if test="${isNew == 'N'}"> 
						<input type="text" id="DueDate" name="DueDate" value="${getMap.DueDate}" class="text datePicker" style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</c:if>
					<c:if test="${isNew == 'Y'}"> 
						<input type="text" id="DueDate" name="DueDate" value="${dueYmd}" class="text datePicker" style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</c:if>
					<c:if test="${isNew == 'R'}">${getMap.DueDate}
					</c:if>
				</td>
				
				<!-- 완료일 -->
				<th>${menu.LN00064}</th>
				<td class="last">${getMap.EndDate}</td>
			</tr>
			<!-- 담당자 -->	
			<tr>
				<c:if test="${isNew == 'Y' || isNew == 'N'}">     
					<th>${menu.LN00004}&nbsp;<img onclick="searchPopup('selectPjtAuthor.do');" src="${root}${HTML_IMG_DIR}icon_open.png"></img></th>
				</c:if>
				<c:if test="${isNew == 'R'}">     
					<th>${menu.LN00004}</th>
				</c:if>
				<td colspan="7" class="last">
					<div id="membersDiv" class="alignL">
					</div> 
				</td> 
			</tr>
			<!-- 개요 -->			
			<tr>
				<th>${menu.LN00035}</th>
				<td colspan="7" class="last">
					<c:if test="${isNew == 'Y' || isNew == 'N'}"> 
						<textarea class="textgrow" id="Description" name="Description" style="width:100%;height:200px;">${getMap.Description}</textarea>
					</c:if>
					<c:if test="${isNew == 'R'}"> 
						<textarea class="textgrow" id="Description" name="Description" style="width:100%;height:200px;" readonly="readonly">${getMap.Description}</textarea>
					</c:if>
				</td>
			</tr>
			
			<!-- 첨부파일 -->	
			<c:if test="${isNew == 'N' || isNew == 'R' || btn == 'add'}">
				<tr>
					<th>${menu.LN00111}</th>
					<td colspan="7" class="alignL pdL5 last">
						<div style="height:100px;width:100%;overflow:auto;overflow-x:hidden;">
						<div id="tmp_file_items" name="tmp_file_items"></div>
						<div class="floatR pdR20" id="divFileImg">
						<c:if test="${pjtFiles.size() > 0}">
							<span class="btn_pack medium icon mgB2"><span class="download"></span><input value="&nbsp;Save All&nbsp;&nbsp;" type="button" onclick="FileDownload('attachFileCheck', 'Y')"></span><br>
							<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="FileDownload('attachFileCheck', 'N')"></span><br>
						</c:if>
						</div>
						<c:forEach var="fileList" items="${pjtFiles}" varStatus="status">
							<div id="divDownFile${fileList.Seq}"  class="mm" name="divDownFile${fileList.Seq}">
								<input type="checkbox" name="attachFileCheck" value="${fileList.FileName},${fileList.FileRealName},,${fileList.Seq}" class="mgL2 mgR2">
								<span style="cursor:pointer;" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.Seq}');">${fileList.FileRealName}</span>
								<c:if test="${isNew == 'N' || btn == 'add'}"> 
									<c:if test="${sessionScope.loginInfo.sessionUserId == fileList.RegMemberID}">
										<img src="${root}${HTML_IMG_DIR}/btn_filedel.png" style="cursor:pointer;width:13;height:13;padding-left:10px" alt="파일삭제" align="absmiddle" onclick="fnDeleteItemFile('${fileList.ProjectID}','${fileList.Seq}','${fileList.FileName}','${pjtFilePath}')">
									</c:if>
								</c:if>
								<br>
							</div>
						</c:forEach>
						</div>
					</td>
				</tr>
			</c:if>
		</table>
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;">
        <tr>
           <%-- <c:if test="${isNew == 'N' || isNew == 'R'}">
	           <td class="alignL pdL20" bgcolor="#f9f9f9">
	               <span class="icon" alt="${menu.LN00082}" title="${menu.LN00082}" onclick="goMenu('changeInfo');" style="cursor:pointer;_cursor:hand">
	               		<img src="${root}${HTML_IMG_DIR}/sc_item.png"></img></span>&nbsp;<font><b>(${getMap.CNGT_CNT})</b></font>
	            		&nbsp;&nbsp;&nbsp;<span class="icon" alt="Issue" title="Issue" onclick="goMenu('issueInfo');" style="cursor:pointer;_cursor:hand">
	               		<img src="${root}${HTML_IMG_DIR}/sc_issue.png"></img></span>&nbsp;<font><b>(${getMap.ISSUE_CNT})</b></font>
	               		
	               <c:if test="${getMap.Status == 'APRV' || getMap.Status == 'CLS'}">
		               &nbsp;&nbsp;&nbsp;<span class="icon" alt="CHANGEMGT" title="${menu.LN00135}" onclick="goMenu('approveInfo');" style="cursor:pointer;_cursor:hand">
		               		<img class="topIconImg" alt="imgCHANGEMGT" src="${root}${HTML_IMG_DIR}/sc_confirm_list.png"></img>
		               </span>
	               </c:if>
	           </td>
           </c:if> --%>
           <td class="alignR pdR20 last" bgcolor="#f9f9f9">
           		<c:if test="${(mainMenu == 1 || mainMenu == 4) && isNew == 'R'}">
	        		<c:if test="${isMember == 'Y'}">
		        	 	<c:if test="${getMap.Status != 'APRV' && getMap.Status != 'CLS' && getMap.Status != 'CNGCL'}">
		        			&nbsp;<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="submit" onclick="goChangeInfoEdit(${ProjectID});"></span>   
		            	</c:if>
	            	</c:if>
	            </c:if>
           		<c:if test="${isNew == 'N' || isNew == 'R'}">		            
           			<span class="btn_pack medium icon"><span class="list" tyle="cursor:pointer;_cursor:hand"></span><input value="Change set(${getMap.CNGT_CNT})" type="submit"  onclick="goMenu('changeInfo');"></span>
	                <span class="btn_pack medium icon"><span class="list" tyle="cursor:pointer;_cursor:hand"></span><input value="Issus(${getMap.ISSUE_CNT})" type="submit"  onclick="goMenu('issueInfo');"></span>
        		</c:if>
        		<c:if test="${isNew == 'N' || btn == 'add'}">    
        			&nbsp;<span class="btn_pack medium icon"><span class="upload"></span><input value="Attach" type="button" onclick="fnMultiUpload()"></span> 
        		</c:if> 
        		<c:if test="${isNew == 'Y' || isNew == 'N'}">        
	            	&nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="savePrj()" type="submit"></span> 
	            </c:if>
	        	<c:if test="${mainMenu == 2}">
	            	&nbsp;<span class="btn_pack medium icon"><span class="confirm"></span><input value="Request" type="submit" onclick="goSetWfStepInfo();"></span>   
	            </c:if>
	            <c:if test="${isNew == 'N' || isNew == 'R'}">
	            	<c:if test="${getMap.Status == 'APRV' || getMap.Status == 'CLS'}">
	            		<span class="btn_pack medium icon"><span class="list" tyle="cursor:pointer;_cursor:hand"></span><input value="${menu.LN00135}" type="submit"  onclick="goMenu('approveInfo');"></span>
	            	</c:if>
	            </c:if>
	            <c:if test="${mainMenu == 3}">
	            	&nbsp;<span class="btn_pack medium icon"><span class="confirm"></span><input value="Approve" type="submit" onclick="approve();"></span>   
	            </c:if>
	            
	            <span class="btn_pack medium icon"><span class="list"></span><input value="List" type="submit"  onclick="goBack()"></span>
      		</td>
      	</tr>
      	</table>
	</div>
	
	</form>
	
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;"></iframe>
</body>
</html>