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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00029" var="CM00029" arguments="${menu.LN00208}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00036" var="WM00036" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00038" var="WM00038" />

<script type="text/javascript">
	$(document).ready(function(){
		
		fnSelectNone('WfStepSel','&Category=WF','dictionyCode', '${wfStep}');
		
	});
	
	//================================================================================================================================================
	
	// [Save]
	function saveWfStepInfo(){
		// 담당자 null check
		// 각 단계별 담당자가 설정 되어 있지 않을 때 처리를 종료 한다
		<c:forEach var="i" items="${wfStepList}">
			var userId = $("#${i.WFStepID}ID").val();
			if (userId == "") {
				<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00035" var="WM00035" arguments="${i.Name}"/>
				alert("${WM00035}");
				return;
			}
		</c:forEach> 
		
		if(confirm("${CM00030}")){
			var url = "saveWfStepInfo.do";
			ajaxSubmit(document.wfStepInfoFrm, url);
		}
	}
	
	// [Previous]
	function goPrevious() {
		if(confirm("${CM00029}")){
			//var url = "newProjectInfoView.do";
			var screenType = "${screenType}";
			var url = "csrDetail.do";
			var data = "isNew=${isNew}&ProjectID=${ProjectID}&mainMenu=${mainMenu}&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}&s_itemID=${s_itemID}"
			var target = "help_content";
			if(screenType == "csrDtl"){ target = "wfStepInfoDiv"; }
			ajaxPage(url, data, target);
		}
	}
	
	// [합의 / 승인 단계 별 담당자 설정 관련 ]===========================================================================================================================
	
	// 담당자 설정 팝업창 표시
	function searchPopupWf(avg){
		getCheckedRadioVal();
		
		// 선택된 합의/승인 단계 값이 존재하지 않을때
		if ($('#wfId').val() == "") {
			alert("${WM00036}");
			return;
		}
		
		var url = avg + "&searchValue=" + encodeURIComponent($('#resultName').val()) + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSearchNameWf(memberID, memberName, teamName, teamID, objId, objName){
		$('#' + objId).val(memberID);
		$('#' + objName).val(memberName);
		
		// 함의/승인 단계별 hidden 값 설정
		addUser($('#wfId').val(), $('#wfName').val(), memberName, teamName);
		
	}	
		
	// [합의 / 승인 단계] pulldown Change 이벤트
	function changeWfStepInfo() {
		var screenType = "${screenType}";
		var url = "createWFDocCSR.do";
		var data = "isNew=${isNew}&ProjectID=${ProjectID}&mainMenu=${mainMenu}&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}&s_itemID=${s_itemID}&screenType="+screenType
			+ "&wfStep=" + $('#WfStepSel').val(); 		 // 합의/승인 단계
			
		var target = "help_content";
			if(screenType == "csrDtl"){target="wfStepInfoDiv";}
		ajaxPage(url, data, target);
	}
	
	//합의 /승인 단계 별 유저 추가
	function addUser(avg1, avg2, avg3, avg4) {
		if ($('#resultID').val() != "" && $('#resultName').val() != "") {
			
			// 다른 단계 같은 유저 중복 체크
			// 같은 단계 같은 유저 중복 체크
			<c:forEach var="list" items="${wfStepList}">
				// 유저 추가 할 해당 단계 이외의 단계의 유저 중복 체크
				var userArray = $("#${list.WFStepID}ID").val().split(',');
				for (var j in userArray) {
					if (userArray[j] == $('#resultID').val()) {
						<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00043" var="WM00043" arguments="${list.Name}"/>
						alert("${WM00043}");
						return;
					}
				}
			</c:forEach>
			
			if ($('#' + avg1 + "ID").val() == "") {
				$('#' + avg1 + "ID").val($('#resultID').val());
				$('#' + avg1 + "Name").val($('#resultName').val());
			} else {
				// 같은 단계 같은 유저 중복 체크
				/*
				var strArray = $('#' + avg1 + "ID").val().split(',');
				for (var i in strArray) {
					if (strArray[i] == $('#resultID').val()) {
						alert("이미 추가된 담당자입니다.");
						return;
					}
				}
				*/
				$('#' + avg1 + "ID").val($('#' + avg1 + "ID").val() + "," + $('#resultID').val());
				$('#' + avg1 + "Name").val($('#' + avg1 + "Name").val() + "," + $('#resultName').val());
			}
			
			// 화면표시 user 추가
			addUserRow(avg2, avg3, avg4, $('#resultID').val(), avg1);
			
		}
		
	}
	
	// 합의 /승인 단계 별 유저 삭제
	function deleteUser() {
		
		getCheckedRadioVal();
		
		// 선택된 합의/승인 단계 값이 존재하지 않을때
		if ($('#wfId').val() == "") {
			alert("${WM00036}");
			return;
		}
		
		var avg = $('#wfId').val();
		
		if ($('#' + avg + "ID").val() != "") {
			var url = "deleteNamePop.do?objId="+ $('#' + avg + "ID") + "&objName=" + $('#' + avg + "Name") + "&MemberID=" + $('#' + avg + "ID").val() + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
			window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');
		} else {
			alert("${WM00038}");
		}
	}
	
	function setDeleteName(memberID, memberName){
		var avg = $('#wfId').val();
		
		var beforeDelArray = $('#' + avg + "ID").val().split(',');
		var delArray = memberID.split(',');
		var afterDel = "";
		
		for (var i in beforeDelArray) {
			for (var j in delArray) {
				if (beforeDelArray[i] == delArray[j]) {
					beforeDelArray.splice(i,1);
				}
			}
		}
		
		for (var i in beforeDelArray) {
			if (i == 0) {
				afterDel = beforeDelArray[i];
			} else {
				afterDel = afterDel + "," +beforeDelArray[i];
			}
		}
		
		//alert(afterDel);
		$('#' + avg + "ID").val(afterDel);
		
		// 화면의 해당 리스트를 삭제
		for (var j in delArray) {
			deleteUserRow(delArray[j], avg);
		}
	}
	
	
	// 유저 검색 text clear
	function schResultClear() {
		$('#resultName').val("");
		$('#resultID').val("");
	}
	
	
	// 선택된 유저 행 추가
	function addUserRow(avg1, avg2, avg3, avg4, avg5) {
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
		    	td.innerHTML = avg1;
		    } else if (i == 1) {
		    	td.innerHTML = avg2;
		    } else if (i == 2) {
		    	td.innerHTML = avg3;
		    } else if (i == 3) {
		    	td.innerHTML = avg4;
		    	td.style.display = "none";
		    }  else if (i == 4) {
		    	td.innerHTML = avg5;
		    	td.style.display = "none";
		    }
		}
	}
	
	// 선택된 유저 행 삭제
	function deleteUserRow(avg1, avg2) {
		var tbl = document.getElementById("userListTbl");
		var rowIndex = tbl.rows.length;
		var tr = "";
		
		for (var i = 1; i < rowIndex + 1; i++) {
			//alert(tbl.rows[i]);
			if (tbl.rows[i] != undefined) {
				tr = tbl.rows[i];
				//alert(tr.cells[3].innerHTML);
				if (tr.cells[3].innerHTML == avg1 && tr.cells[4].innerHTML == avg2) {
					tbl.deleteRow(i);
				}
			}
		}
		
	}
	
	// 선택한 단계 취득
	function getCheckedRadioVal() {
		var radioObj = document.all('wfStepName');
		
		if (radioObj.length == undefined) {
			if (radioObj.checked) {
				$('#wfName').val($('label[for=wfLabel' + radioObj.value + ']').text());
				$('#wfId').val(radioObj.value);
			}
			
		} else {
			for (var i = 0; i < radioObj.length; i++) {
				if (radioObj[i].checked) {
					$('#wfName').val($('label[for=wfLabel' + radioObj[i].value + ']').text());
					$('#wfId').val(radioObj[i].value);
				}
			}
		}
	}
	
	// screenType==csrDtl 일때 저장후 callBack 
	function fnCallBack(){
		parent.opener.doSearchPjtList();
		parent.self.close();
	}
	
</script>
</head>
<body>
<div id="wfStepInfoDiv" name="wfStepInfoDiv">
<form name="wfStepInfoFrm" id="wfStepInfoFrm" method="post" action="#" onsubmit="return false;">
	<input type="hidden" id="ProjectID" name="ProjectID"  value="${ProjectID}" />
	<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}" />
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
	
	<input type="hidden" id="resultID" name="resultID" value=""/>
	<input type="hidden" id="wfId" name="wfId" value=""/>
	<input type="hidden" id="wfName" name="wfName" value=""/>
	<input type="hidden" id="isNew" name="isNew" value="${isNew}"/>
	<input type="hidden" id="screenType" name="screenType" value="${screenType}"/>
	
	<!-- 화면 타이틀 : 결재경로 생성-->
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 6px 0 6px 0">
			<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;${menu.LN00211}
		</h3>
	</div>
	
	<c:forEach var="i" items="${wfStepList}">
		<input type="hidden" id="${i.WFStepID}ID" name="${i.WFStepID}ID" value="" />
	</c:forEach>
	<table class="tbl_blue01" style="table-layout:fixed;">
		  <tr>
          <td class="pd"></td>
          </tr>
          <tr>
        	<td class="btn">
               	<span class="btn_pack medium icon"><span class="save"></span><input value="Submit" onclick="saveWfStepInfo()" type="submit"></span> 
               	&nbsp;<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="goPrevious()" type="submit"></span>   
            </td>
        </tr>
	</table>
	
	<div id="objectInfoDiv" class="hidden floatC" style="width:100%;overflow-x:hidden;overflow-y:auto;" >
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;">
			<colgroup>
				<col width="10%">
				<col width="15%">
				<col width="10%">
				<col width="15%">
				<col width="5%">
				<col>
				
			</colgroup>
			
			<tr>
				<!-- WF 선택 -->
				<th class="viewtop">${menu.LN00140}</th>
				<td class="viewtop" style="height:50px;">
					<select id="WfStepSel" name="WfStepSel" class="sel" onchange="changeWfStepInfo()">
					</select>
				</td>
				
				<!-- 개요 -->
				<th class="viewtop">${menu.LN00035}</th>
				<td colspan="3" class="viewtop alignL last">
					${wfDescription}
				</td>
			</tr>
			
			<tr>
				<!-- 담당자 설정 -->
				<th>${menu.LN00141}</th>
				<td colspan="4" class="alignL alignT" style="height:100px;">
					<input type="text" class="text_searchInfo mgB5 mgL5" id="resultName" name="resultName" onclick="schResultClear()">
					
					<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="searchPopupWf('searchPluralNamePop.do?objId=resultID&objName=resultName')" value="검색">
					&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="deleteUser()"></span>
					<br>
					<div class="floatL">
					<table id="userListTbl" class="tbl_coplist mgT5 mgL5">
						<colgroup>
							<col width="100px"/>
							<col width="100px"/>
							<col width="100px"/>
							<col width="0px"/>
							<col width="0px"/>
						</colgroup>
					 	<tr>
					 		<th>${menu.LN00069}</th>
					 		<th>${menu.LN00004}</th>
					 		<th>${menu.LN00104}</th>
					 		<th></th>
					 		<th></th>
					 	</tr>
					</table>
					</div>
					<div class="floatR mgT20">
					<c:forEach var="i" items="${wfStepList}">
						<input type="radio" name="wfStepName" value="${i.WFStepID}" id="wfLabel${i.WFStepID}">
							<span style="color:#0d65b7;font-weight:bold;"><label for="wfLabel${i.WFStepID}">${i.Name}</label></span>
						<br>
					</c:forEach>
					</div>	
				</td>
				<td colspan="1" class="last"></td>
			</tr>

		</table>
	</div>
	
	</form>
	
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</body>
</div>
</html>