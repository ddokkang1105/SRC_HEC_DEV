<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00030" var="CM00030" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00029" var="CM00029" arguments="${menu.LN00203}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00038" var="WM00038" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00116" var="WM00116" arguments="결재자"/>

<script type="text/javascript">
	$(document).ready(function(){
		fnSetWfStep('AREQ', '상신');
		
		var wfID = "${wfID}";
		var memberID = "${sessionScope.loginInfo.sessionUserId}";
		var memberName = "${sessionScope.loginInfo.sessionUserNm}";
		var teamName = "${sessionScope.loginInfo.sessionTeamName}";
		var teamID = "${sessionScope.loginInfo.sessionTeamId}";
		var objId = "resultID";
		var objName = "resultName";
		var teamPath = "${teamPath}";
		var wfStepID = "AREQ";
		var wfStepTxt = "상신";
		var createWF = "${createWF}";
		$("#wfStepInfo").val(memberName+"("+teamName+")");
		if(createWF == "1"){
			setSearchNameWf(memberID, memberName, teamName, teamID, objId, objName, teamPath, wfStepID, wfStepTxt);
			schResultClear();
		}
		if(wfID == "WF001"){ // 수작업일경우
			<c:forEach var="i" items="${wfStepInstList}" varStatus="iStatus">
				memberID = "${i.ActorID}";
				memberName = "${i.ActorName}";
				teamName = "${i.TeamName}";
				teamID = "${i.TeamID}";
				objId = "resultID";
				objName = "resultName";
				teamPath = "${i.TeamPath}";
				wfStepID = "${i.WFStepID}";
				wfStepTxt = "${i.WFStepName}";
				setSearchNameWf(memberID, memberName, teamName, teamID, objId, objName, teamPath, wfStepID, wfStepTxt);
			</c:forEach>
		}
	});
	
	// 담당자 설정 팝업창 표시
	function searchPopupWf(avg){		
		var url = avg + "&searchValue=" + encodeURIComponent($('#resultName').val()) + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSearchNameWf(memberID, memberName, teamName, teamID, objId, objName, teamPath, wfStepID, wfStepTxt){ 
		$('#' + objId).val(memberID);
		$('#' + objName).val(memberName);
		
		if(wfStepID == "" || wfStepID == undefined){
			addUser($('#wfStep').val(), $('#wfStepTxt').val(), memberName, teamName, teamPath);
		}else{
			addUser(wfStepID, wfStepTxt, memberName, teamName, teamPath);
		}
	}	
	
	//합의 /승인 단계 별 유저 추가
	function addUser(avg1, avg2, avg3, avg4, avg5) {
		var wfStepInfo = "";
		if ($('#resultID').val() != "" && $('#resultName').val() != "") {
			
			// 다른 단계 같은 유저 중복 체크
			// 같은 단계 같은 유저 중복 체크
			// 유저 추가 할 해당 단계 이외의 단계의 유저 중복 체크
			var userArray = $("#actor").val().split(',');
			
			for (var j in userArray) {
				if (userArray[j] == $('#resultID').val()) {					
					alert("${WM00116}");
					return;
				}
			}
			
			
			if ($('#actor').val() == "") {
				$('#actor').val($('#resultID').val());
				$('#wfStepID').val(avg1);
			} else {				
				$('#actor').val($('#actor').val() + "," + $('#resultID').val());
				$('#wfStepID').val($('#wfStepID').val()+ "," + avg1 );
				wfStepInfo = $('#wfStepInfo').val()+ ">>"+avg3+"("+avg4+")";
				$('#wfStepInfo').val(wfStepInfo);
			}
			// 화면표시 user 추가
			addUserRow(avg2, avg3, avg4, $('#resultID').val(), avg1, avg5);
		}		
	}
	
	// 선택된 유저 행 추가
	function addUserRow(avg1, avg2, avg3, avg4, avg5, avg6) {
		var tbl = document.getElementById("userListTbl");
		var rowIndex = tbl.rows.length;
		var tr = tbl.insertRow(rowIndex);
		var td = "";
		var cellIndex = 0;
		var maxCellIndex = tbl.rows[0].cells.length;
	
		for (var i = 0; i < maxCellIndex; i++) {
			td = tr.insertCell(cellIndex++);
		    td.style.textAlign = "center";
		    
		    if (i == 0) {
		    	td.innerHTML = rowIndex;
		    }else if (i == 1) {
		    	td.innerHTML = avg2;
		    } else if (i == 2) {
		    	td.style.textAlign = "left";
		    	td.innerHTML = avg6;
		    } else if (i == 3) {
		    	td.innerHTML = avg1;		    	
		    } else if (i == 4) {
		    	td.innerHTML = avg4;
		    	td.style.display = "none";
		    }  else if (i == 5) {
		    	td.innerHTML = avg5;
		    	td.style.display = "none";
		    }
		}
		if($("#wfStep").val() == "AREQ"){
			fnSetWfStep('APRV', '승인');
		}
	}
	
	function fnSetWfStepInfo(){
		var wfStepMemberIDs = $("#actor").val();
		var wfStepRoleTypes = $("#wfStepID").val();
		var wfStepInfo = $("#wfStepInfo").val();
		
		opener.fnSetWFStepInfo(wfStepInfo,wfStepMemberIDs,wfStepRoleTypes);
		self.close();
	}
	
	// 합의 /승인 단계 별 유저 삭제
	function deleteUser() {		
		var actor = $('#actor').val();
		if(actor == ""){
			alert("${WM00038}"); return;
		}
		
		var url = "deleteNamePop.do?MemberID="+actor+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setDeleteName(memberID, memberName){
		var beforeDelArray = $('#actor').val().split(',');
		var beforeWfStepArray = $('#wfStepID').val().split(',');
		var delArray = memberID.split(',');
		var afterDel = "";
	
		for (var i in beforeDelArray) {
			for (var j in delArray) {
				if (beforeDelArray[i] == delArray[j]) {
					beforeDelArray.splice(i,1);
					beforeWfStepArray.splice(i,1);
				}
			}
		}
		$('#actor').val(beforeDelArray);
		$('#wfStepID').val(beforeWfStepArray);
		
		// 화면의 해당 리스트를 삭제
		for (var j in delArray) {
			deleteUserRow(delArray[j]);
		}
	}
	
	// 선택된 유저 행 삭제
	function deleteUserRow(avg1) {
		var tbl = document.getElementById("userListTbl");
		var rowIndex = tbl.rows.length;
		var tr = "";
		for (var i = 1; i < rowIndex + 1; i++) {
			//alert(tbl.rows[i]);
			if (tbl.rows[i] != undefined) {
				tr = tbl.rows[i];
				if (tr.cells[4].innerHTML == avg1) {
					tbl.deleteRow(i);
				}
			}
		}
	}
	
	// 유저 검색 text clear
	function schResultClear() {
		$('#resultName').val("");
		$('#resultID').val("");
	}
	
	function fnCallBack(){
		opener.fnCallBack();
		self.close();
	}
	
	function fnSetWfStep(wfStep, wfStepTxt){ 
		$("#wfStep").val(wfStep);
		$("#wfStepTxt").val(wfStepTxt);
	}
	
</script>
</head>
<body>
<div id="wfStepInfoDiv" style="padding: 0 6px 6px 6px; height:400px;"> 
<form name="wfStepInfoFrm" id="wfStepInfoFrm" method="post" action="#" onsubmit="return false;">
	<input type="hidden" id="projectID" name="projectID"  value="${projectID}" />
	<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />	
	<input type="hidden" id="resultID" name="resultID" value=""/>
	<input type="hidden" id="wfID" name="wfID" value="1"/>
	<input type="hidden" id="wfName" name="wfName" value=""/>
	<input type="hidden" id="wfStep" name="wfStep" value=""/>
	<input type="hidden" id="wfStepID" name="wfStepID" value=""/>
	<input type="hidden" id="wfStepTxt" name="wfStepTxt" value=""/>
	<input type="hidden" id="actor" name="actor" />
	<input type="hidden" id="createWF" name="createWF" value="${createWF}" />
	<input type="hidden" id="wfStepInfo" name="wfStepInfo" >
	
	<!-- 화면 타이틀 : 결재경로 생성-->
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 6px 0 6px 0">
			<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp; CSR 결재선 생성
		</h3>
	</div>
	
	<div id="objectInfoDiv" class="hidden floatC" style="width:100%;overflow-x:hidden;overflow-y:auto;" >
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>	
				<td  class="alignL alignT last" style="height:200px;">
					&nbsp; 승인 &nbsp; <input type="radio" id="" name="wfStep" value="APRV" checked Onclick="fnSetWfStep(this.value, '승인');">&nbsp;
					&nbsp; 합의 &nbsp; <input type="radio" id="" name="wfStep" value="AGR" Onclick="fnSetWfStep(this.value, '합의');" >&nbsp;
					<input type="text" class="text_searchInfo mgB5 mgL5" id="resultName" name="resultName" onclick="schResultClear()">					
					<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="searchPopupWf('searchPluralNamePop.do?objId=resultID&objName=resultName')" value="검색">
					&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="deleteUser()"></span>
					<span class="alignR" ><span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnSetWfStepInfo()" type="submit"></span></span>
					<br>
					<table id="userListTbl"  class="tbl_blue01 mgT10" style="table-layout:fixed;" width="100%" border="0" cellpadding="0" cellspacing="0">
						<colgroup>
							<col width="5%">
							<col width="15%">
							<col width="60%">
							<col width="20%">
							<col width="0%">
							<col width="0%">
						</colgroup>
					 	<tr>
					 		<th>No.</th>
					 		<th>${menu.LN00004}</th>
					 		<th>${menu.LN00202}</th>
					 		<th class="last">${menu.LN00120}</th>
					 		<th></th>
					 		<th></th>
					 	</tr>
					</table>			
				</td>	
			</tr>
		</table>
		</div>
	</form>
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</body>
</div>
</html>