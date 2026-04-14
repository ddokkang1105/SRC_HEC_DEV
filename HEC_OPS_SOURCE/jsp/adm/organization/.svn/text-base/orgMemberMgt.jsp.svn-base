<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00025" var="WM00025" arguments="${menu.LN00072}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="ID"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>


<script>
var p_gridOUGArea;				//그리드 전역변수
$(document).ready(function(){
	// 초기 표시 화면 크기 조정 
	$("#grdOUGGridArea").attr("style","height:"+(setWindowHeight() - 425)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#grdOUGGridArea").attr("style","height:"+(setWindowHeight() - 425)+"px;");
	};
	gridOUGInit();		
	doSearchOUGList();
	fnSelect('userCompanyID', '', 'getCompany', '', '','');
	fnSelectNone('userAuthority','&Category=MLVL','dictionyCode');
	$("#excel").click(function(){p_gridOUGArea.toExcel("${root}excelGenerate");});	
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

//===============================================================================
//BEGIN ::: GRID
function doSearchOUGList(){
	var d = setGridOUGData();
	fnLoadDhtmlxGridJson(p_gridOUGArea, d.key, d.cols, d.data);
}
//그리드 초기화
function gridOUGInit(){	
	var d = setGridOUGData();
	p_gridOUGArea = fnNewInitGrid("grdOUGGridArea", d);
	p_gridOUGArea.setIconPath("${root}cmm/common/images/");
	p_gridOUGArea.setImagePath("${root}${HTML_IMG_DIR}/");    
    p_gridOUGArea.setColumnHidden(0, true);              //RowNum
	p_gridOUGArea.setColumnHidden(11, true);
	p_gridOUGArea.setColumnHidden(12, true);
	p_gridOUGArea.setColumnHidden(13, true);
	fnSetColType(p_gridOUGArea, 1, "ch");
    fnSetColType(p_gridOUGArea, 2, "img");
	p_gridOUGArea.attachEvent("onRowSelect", function(id,ind){gridOUGOnRowSelect(id,ind);});
}
function setGridOUGData(){
	var result = new Object();
	result.title = "${title}";
	result.key = "organization_SQL.getOrgMemberList";
	result.header = "${menu.LN00024},#master_checkbox,${menu.LN00042},Name,Position,LoginID,Email,Employee No.,Tel, Company,Type,MemberID,MLVL,MTelNum";
	result.cols = "CHK|OrgTypeImg|UserNAME|Position|LoginID|Email|EmployeeNo|TelNum|CompanyNM|AuthorityNm|MemberID|MLVL|MTelNum";
	result.widths = "50,50,50,*,120,110,180,110,120,120,110,0,0,0";
	result.sorting = "int,int,str,str,str,str,str,str,str,str,str,int,int,str";
	result.aligns = "center,center,center,center,center,center,left,center,left,center,left,center,center,left";
	result.data = "s_itemID=${s_itemID}&ActiveMemberYN=Y"
				+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";	
	return result;
}

// [Click row]
function gridOUGOnRowSelect(id, ind){ 
	if(ind != 1) {
		infoEdit();
	}
}
function infoEdit(){
	$("#editArea").attr('style', 'display:block;');
	var mlvl = p_gridOUGArea.cells(p_gridOUGArea.getSelectedId(), 12).getValue();
	$("#MemberID").val(p_gridOUGArea.cells(p_gridOUGArea.getSelectedId(), 11).getValue());
	$("#userLoginID").val(p_gridOUGArea.cells(p_gridOUGArea.getSelectedId(), 5).getValue());
	$("#userName").val(p_gridOUGArea.cells(p_gridOUGArea.getSelectedId(), 3).getValue());
	$("#Position").val(p_gridOUGArea.cells(p_gridOUGArea.getSelectedId(), 4).getValue());
	$("#userEmail").val(p_gridOUGArea.cells(p_gridOUGArea.getSelectedId(), 6).getValue());
	$("#employeeNum").val(p_gridOUGArea.cells(p_gridOUGArea.getSelectedId(), 7).getValue());
	$("#telNum").val(p_gridOUGArea.cells(p_gridOUGArea.getSelectedId(), 8).getValue());
	$("#mTelNum").val(p_gridOUGArea.cells(p_gridOUGArea.getSelectedId(), 13).getValue());
	$("#userAuthority").val(mlvl).attr("selected", "selected");
}

// [Save] button Click
function saveOrgMemberInfo() {
	// [LoginID] 필수 체크
	if($("#userLoginID").val() == ""){alert("${WM00034}");$("#userLoginID").focus();return false;}
	
	if(confirm("${CM00001}")){ 
		var url    = "saveOrgMemberInfo.do"; 
		var data   = "MemberID="+$("#MemberID").val()
					+"&userLoginID="+$("#userLoginID").val()
					+"&userName="+$("#userName").val()
					+"&Position="+$("#Position").val()	
					+"&userEmail="+$("#userEmail").val()	
					+"&mTelNum="+$("#mTelNum").val()	
					+"&telNum="+$("#telNum").val()	
					+"&employeeNum="+$("#employeeNum").val()	
					+"&userAuthority="+$("#userAuthority").val(); //파라미터들
		var target = "blankFrame";
		ajaxPage(url, data, target);	
	}
}

//[Move] button Click
function searchOrgPopUp(){
	if(p_gridOUGArea.getCheckedRows(1).length == 0){
		alert("${WM00023}");
	}else{
		var url = "orgUserTreePop.do";
		var data = "s_itemID=${s_itemID}";
		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}	
}
function doCallBack(avg){
 	var newTeamId = avg;
 	var checkedRows = p_gridOUGArea.getCheckedRows(1).split(",");
 	var items = p_gridOUGArea.cells(checkedRows[0], 11).getValue();
 	for(var i = 1 ; i < checkedRows.length; i++ ){
 		items += ","+ p_gridOUGArea.cells(checkedRows[i], 11).getValue();
 	}
 	var url = "transOrg.do";
 	var data = "s_itemID=${s_itemID}&isMember=Y&parentID="+newTeamId +"&items="+items;
 	var target = "blankFrame";
 	ajaxPage(url,data,target);
 }
 
 function thisReload() {
	 $("#editArea").attr('style', 'display:none;');
	 doSearchOUGList();
 }
 
 function updateManager(gubun){
	var checkedRows = p_gridOUGArea.getCheckedRows(1);
	var ManagerID = p_gridOUGArea.cells(checkedRows, 11).getValue();
	var url = "updateOrgManager.do";
	var data = "s_itemID=${s_itemID}&ManagerID="+ManagerID+"&gubun=" + gubun;
	var target = "blankFrame";
 	ajaxPage(url,data,target);
 }
	
</script>
<form name="userList" id="userList" action="#" method="post" onsubmit="return false;">
	<div id="userListDiv" class="hidden" style="width:100%;height:100%;">
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
	<input type="hidden" id="Category" name=Category value="${Category}">
	<input type="hidden" id="MemberID" name="MemberID"/>
	<div style="overflow:auto;margin-bottom:10px;overflow-x:hidden;">	
	<div>
      <li class="floatR pdR20">
		<c:if test="${loginInfo.sessionMlvl == 'SYS' || teamManagerID == sessionScope.loginInfo.sessionUserId}">
		&nbsp;<span class="btn_pack small icon"><span class="assign"></span><input value="Assign Role Manager" type="submit" onclick="updateManager('R')"></span>
		</c:if>
		<c:if test="${loginInfo.sessionMlvl == 'SYS'}">
		&nbsp;<span class="btn_pack small icon"><span class="assign"></span><input value="Assign Manager" type="submit" onclick="updateManager('T')"></span>
		</c:if>
		<c:if test="${loginInfo.sessionMlvl == 'SYS'}">
		&nbsp;<span class="btn_pack small icon"><span class="move"></span><input value="Move" type="submit" onclick="searchOrgPopUp()"></span>
	   	&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</c:if>
       
       </li>
	</div>
     <div class="countList">
              <li  class="count">Total  <span id="TOT_CNT"></span></li>
              <li class="floatR">&nbsp;</li>
          </div>
		<div id="gridOUGDiv" class="mgT10 clear">
			<div id="grdOUGGridArea" style="width:100%"></div>
		</div>
	</div>
<c:if test="${loginInfo.sessionMlvl == 'SYS'}">
	<div id="editArea" style="display:none;">
		<table class="tbl_blue01 mgT10" width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<th class="viewtop">ID</th>
				<td class="viewtop"><input type="text" class="text" id="userLoginID" name="userLoginID"></td>			
				<th class="viewtop">Name</th>
				<td class="viewtop"><input type="text" class="text" id="userName" name="userName"></td>				
				<th class="viewtop">Position</th>
				<td class="viewtop Last"><input type="text" class="text" id="Position" name="Position"></td>		
			</tr>
			<tr>
				<th>Email</th>
				<td><input type="text" class="text" id="userEmail" name="userEmail"></td>		
				<th>Mobile</th>
				<td><input type="text" class="text" id="mTelNum" name="mTelNum"></td>	
				<th>Tel</th>
				<td class="Last"><input type="text" class="text" id="telNum" name="telNum"></td>				
							
			</tr>
			<tr>
				<th>Employee No</th>
				<td class="alignL"><input type="text" class="text" id="employeeNum" name="employeeNum"></td>	
				<th>Authority</th>
				<td class="alignL pdR20">
					<select id="userAuthority"></select>
				</td>
				<td class="alignR pdR20 last" bgcolor="#f9f9f9" colspan="4">
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
						<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="saveOrgMemberInfo()" type="submit"></span>
					</c:if>
				</td>
			</tr>
		</table>	
	</div>
</c:if>	
	
</div>
</form>

<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>