<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!-- 관리자 : 사용자 목록  -->
<!-- 
	@RequestMapping(value="/UserList.do")
	* user_SQL.xml - userList_gridList
	* Action
	  - Update :: saveUser.do
	  - Del    :: memberUpdate.do
	  - View   :: userInfoView.do
 -->
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="${menu.LN00072}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00106}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00148}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="Name"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_4" arguments="${menu.LN00018}"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
$(document).ready(function(){
	// SKON CSRF 보안 조치
	$.ajaxSetup({
		headers: {
			'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			}
	})
	
	fnSelectNone('Authority','&Category=MLVL','getDicWord', 'VIEWER');
	fnSelect('authority','&Category=MLVL','getDicWord', '','Select');
	fnSelect('client','&teamType=1&languageID=${sessionScope.loginInfo.sessionCurrLangType}','getTeam','${clientID}','Select');
	if("${clientID}" != '' & "${clientID}" != null) fnGetCompany("${clientID}");
	else fnSelect('company','&teamType=2&languageID=${sessionScope.loginInfo.sessionCurrLangType}','getTeam','${companyID}','Select');
	
	if("${companyID}" != '' & "${companyID}" != null){
		fnSelect('company','&teamType=2&languageID=${sessionScope.loginInfo.sessionCurrLangType}','getTeam','${companyID}','Select');
		fnSelect('team','&teamType=4&languageID=${sessionScope.loginInfo.sessionCurrLangType}&companyID=${companyID}','getTeam','${teamID}','Select');
	}
	
	if("${searchKey}" != '' & "${searchKey}" != null) {$("#searchKey").val("${searchKey}");}
	if("${active}" != '' & "${active}" != null) $("#active").val("${active}");
	
	$("#excel").click(function(){ fnGridExcelDownLoad(); });
});
//===============================================================================
function doSearchOUGList(){
	var sqlID = "user_SQL.userList";
	var param =  "s_itemID=${s_itemID}"				
        + "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"	
        + "&userType=1"
        + "&ClientID="+ document.querySelector("#client").value
        + "&CompanyID=" + document.querySelector("#company").value
        + "&TeamID=" + document.querySelector("#team").value
        + "&active=" + document.querySelector("#active").value
        + "&authority=" + document.querySelector("#authority").value
        + "&position=" + document.querySelector("#position").value
        + "&mType=" + document.querySelector("#mType").value
        + "&searchValue=" + document.querySelector("#searchValue").value
        + "&searchKey=" + document.querySelector("#searchKey").value
        + "&sqlID="+sqlID;
        
	$.ajax({
		url:"jsonDhtmlxListV7.do",
		type:"POST",
		data:param,
		success: function(result){
			fnReloadGrid(result);				
		},error:function(xhr,status,error){
			console.log("ERR :["+xhr.status+"]"+error);
		}
	});	
}
function fnReloadGrid(newGridData){
	    
	
	  if (userInfoMasking === "Y") {
 
		  // 문자열로 오면 JSON 파싱
		  if (typeof newGridData === "string") {
		    var text = newGridData.trim();
		    if (text.charAt(0) === "[" || text.charAt(0) === "{") {
		      try { newGridData = JSON.parse(text); }
		      catch (e) { console.error("JSON parse error:", e, newGridData); return; }
		    } else {
		      console.error("Unexpected response (not JSON):", newGridData);
		      return;
		    }
		  }

		      newGridData = maskAllRows(newGridData);
	
		  }
	  

		grid.data.parse(newGridData);
		
		fnMasterChk('');
		$("#TOT_CNT").html(grid.data.getLength());
}

/* function gridOUGInit(){	
	var d = setGridOUGData();
	p_gridOUGArea = fnNewInitGrid("grdOUGGridArea", d);
	p_gridOUGArea.setImagePath("${root}${HTML_IMG_DIR}/");
	p_gridOUGArea.setColumnHidden(11, true);
	p_gridOUGArea.setColumnHidden(14, true);
	p_gridOUGArea.setColumnHidden(15, true);
	fnSetColType(p_gridOUGArea, 1, "ch");
	p_gridOUGArea.attachEvent("onRowSelect", function(id,ind){gridOUGOnRowSelect(id,ind);});
	
	p_gridOUGArea.enablePaging(true,50,10,"pagingArea",true,"recInfoArea");
	p_gridOUGArea.setPagingSkin("bricks");
	p_gridOUGArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
} */
var layout = new dhx.Layout("grdOUGGridArea", {
	rows: [
    	{
        	id: "a",
    	},
	]
});


var userInfoMasking = "${userInfoMasking}";


var gridData = ${gridData};
if(userInfoMasking === "Y"){
	
	gridData = maskAllRows(gridData);
}

function maskAllRows(list){
	  if (!Array.isArray(list) || !list.length) return list;

	  return list.map(item => ({
	    ...item,


	    LoginID: item.LoginID && item.LoginID.length > 3
	      ? item.LoginID.slice(0, -3) + "***"
	      : item.LoginID && item.LoginID.length > 1
	        ? item.LoginID[0] + "*".repeat(item.LoginID.length - 1)
	        : "*".repeat(item.LoginID.length),

	    UserNAME: item.UserNAME && item.UserNAME.length === 2
	      ? item.UserNAME[0] + "*" + item.UserNAME[1]
	      : item.UserNAME && item.UserNAME.length > 2
	        ? item.UserNAME[0] + "*".repeat(item.UserNAME.length - 2) + item.UserNAME[item.UserNAME.length - 1]
	        : item.UserNAME,

	    EnName: item.EnName && item.EnName.split(" ").length === 2
	      ? item.EnName.split(" ")[0] + " " + "*".repeat(item.EnName.split(" ")[1].length)
	      : item.EnName && item.EnName.split(" ").length > 2
	        ? item.EnName.split(" ")[0] + " " + "*".repeat(item.EnName.split(" ")[1].length) + " " + item.EnName.split(" ")[2]
	        : item.EnName,

	    EmployeeNum: item.EmployeeNum && item.EmployeeNum.length > 3
	      ? item.EmployeeNum.slice(0, -3) + "***"
	      : item.EmployeeNum && item.EmployeeNum.length > 1
	        ? item.EmployeeNum[0] + "*".repeat(item.EmployeeNum.length - 1)
	        : "*".repeat(item.EmployeeNum.length),

	    MTelNum: item.MTelNum && item.MTelNum.replace(/[^0-9]/g, "").length === 11
	      ? (function(){
	          var num = item.MTelNum.replace(/[^0-9]/g, "");
	          return num.substring(0,3) + "-" + "*".repeat(4) + "-" + num.substring(7);
	        })()
	      : item.MTelNum && item.MTelNum.split("-").length === 3
	        ? item.MTelNum.split("-")[0] + "-" + "*".repeat(item.MTelNum.split("-")[1].length) + "-" + item.MTelNum.split("-")[2]
	        : item.MTelNum,

	    Email: item.Email && item.Email.includes("@")
	      ? (function(){
	          var parts = item.Email.split("@");
	          var local = parts[0], domain = parts[1];
	          if (local.length === 1) return local + "@" + domain;
	          if (local.length === 2) return local[0] + "*" + "@" + domain;
	          return local[0] + "*".repeat(local.length - 2) + local[local.length - 1] + "@" + domain;
	        })()
	      : item.Email
	  }));
	}


var grid = new dhx.Grid("grid", {
	columns: [
    	{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
    	{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center" }], align: "center", type: "boolean", editable: true, sortable: false},
		{ width: 100 , id: "LoginID", header: [{ text: "Login ID", align: "center" } ], align: "center" },
    	{ width: 80, id: "UserNAME", header: [{ text: "Name", align: "center" } ], align: "center" },
    	{ width: 100, id: "EnName", header: [{ text: "English Name", align: "center" } ], align: "left" },
    	{ width: 100, id: "EmployeeNum", header: [{ text: "Employee No.", align: "center" } ], align: "center" },
    	{ width: 100, id: "City", header: [{ text: "Site", align: "center" } ], align: "center" },
    	{ width: 100, id: "CompanyNM", header: [{ text: "${menu.LN00014}", align: "center" } ], align: "center" },
    	{ width: 120, id: "TeamNM", header: [{ text: "Team", align: "center" } ], align: "center" },
    	{ width: 120, id: "Position", header: [{ text: "Position", align: "center" } ], align: "center" },
    	{ width: 80, id: "Authority", header: [{ text: "Authority", align: "center" } ], align: "center" },
    	{ width: 200, id: "Email", header: [{ text: "Email", align: "center" } ], align: "left" },
    	{ width: 100, id: "TelNum", header: [{ text: "Tel", align: "center" } ], align: "center" },
    	{ width: 100, id: "MTelNum", header: [{ text: "Mobile", align: "center" } ], align: "center" },
    	{ hidden : true, id: "AuthorityName", header: [{ text: "Type", align: "center" } ], align: "center" },
    	{ hidden : true, id: "MemberID", header: [{ text: "MemberID", align: "center" } ], align: "center" },
    	{ width: 80, id: "Active", header: [{ text: "Active", align: "center" } ], align: "center" },
    	{ width: 90, id: "RoleManagerYN", header: [{ text: "RoleManager", align: "center" } ], align: "center" },
    	{ width: 80, id: "ManagerYN", header: [{ text: "Manager", align: "center" } ], align: "center" },
    	{ width: 80, id: "ItemCnt", header: [{ text: "${menu.LN00190}", align: "center" } ], align: "center" },
	],
	autoWidth: true,
	resizable: true,
	selection: "row",
	tooltip: false,
	data: gridData
});

layout.getCell("a").attach(grid);

var pagination = new dhx.Pagination("pagination", {
	data: grid.data,
	pageSize: 50,
});

$("#TOT_CNT").html(grid.data.getLength());

grid.events.on("cellClick", function(row,column,e){
	if(column.id != "checkbox"){
		doDetail(row.MemberID);
	}
}); 

//===============================================================================

function infoEdit(){	
	if(p_gridOUGArea.getSelectedId() == null){alert("${WM00041}");return;}
	//if(!confirm("수정하겠습니까?")){ return;}
	if(!confirm("${CM00001}")){ return;}
	var url  = "editUser.do";
	var data   = "MemberID="+p_gridOUGArea.cells(p_gridOUGArea.getSelectedId(), 15).getValue()
				+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}"	
				+"&currPage=" + $("#currPage").val(); //파라미터들
	var target = "userList";
	ajaxPage(url,data,target);	
}

function userDel(){
	var selectedCell = grid.data.findAll(function (data) {
        return data.checkbox;
	});
	if(!selectedCell.length){
		//alert("항목을 한개 이상 선택하여 주십시요.");	
		alert("${WM00023}");
	}else{
		//if(confirm("선택된 항목를 삭제하시겠습니까?")){
		if(confirm("${CM00004}")){
			var items = selectedCell.map(function(cell) {
		    	return cell.MemberID;
			}).join(",");
			
			var url = "admin/memberUpdate.do";
			var data = "userMenu=user&type=delete&s_itemID=${s_itemID}&items="+items;
			var target = "blankFrame";
			ajaxPage(url, data, target);
			
		}
	}
}

function clickNewBtn(){$("#MemberID").val('');initControl(true);}
function clickSaveBtn(){
	if(!checkValidation()){return;}
	if(!confirm("${CM00001}")){ return;}
	var url  = "admin/saveUser.do";
	var target = "blankFrame";
	var data = "LoginID="+$('#LoginID').val()
				+"&EmployeeNum="+$('#EmployeeNum').val()
				+"&Email="+$('#Email').val()
				+"&Name="+$('#Name').val()
				+"&MTelNum="+$("#MTelNum").val()
				+"&Authority="+$('#Authority').val()
				+"&TeamID="+$('#ownerTeamCode').val()
				+"&Position="+$("#Position").val()
				+"&loginID="+$('#loginID').val()
				+"&currPage=" + $("#currPage").val();
	
	ajaxPage(url,data,target);	
	//ajaxSubmit(document.userList, url);
}
function checkValidation(){
	var isCheck = true;
	// [LoginID] 필수 체크
	if($("#LoginID").val() == ""){
		alert("${WM00034_1}");
		$("#LoginID").focus();
		return false;
	}
	// [Name] 필수 체크
	if($("#Name").val() == ""){
		alert("${WM00034_3}");
		$("#Name").focus();
		return false;
	}
	// [사번] 필수 체크
	if($("#EmployeeNum").val() == ""){
		alert("${WM00034_2}");
		$("#EmployeeNum").focus();
		return false;
	}
	// [관리조직] 필수 체크
	if($("#teamName").val() == ""){
		alert("${WM00034_4}");
		$("#teamName").focus();
		return false;
	}
	
	return isCheck;
}

function initControl(isClear){
	if(isClear){
		$("#divTabUserAdd").removeAttr('style', 'display: none');	
		$("#userInfo").removeAttr('style', 'display: none');
	}else{
		$("#divTabUserAdd").attr('style', 'display: none');
		$("#userInfo").attr('style', 'display: none');
	}
	$('.isnew').each(function(){$(this).val('');});
	$("#MemberID").val('');
	$("#Name").val('');
	$("#LoginID").val('');
	$("#Email").val('');
	$("#MTelNum").val('');
	$("#Position").val('');
	$("#EmployeeNum").val('');
	$("#ownerTeamCode").val('');
	$("#teamName").val('');
	//$("#Authority").val('');
}

function doDetail(id){	
	var url    = "userInfoView.do"; // 요청이 날라가는 주소
	var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&memberID="+id
				+"&currPage=" + $("#currPage").val()
				+"&clientID="+ $("#client").val()
				+"&companyID="+ $("#company").val()
				+"&teamID="+ $("#team").val()
				+"&searchKey="+ $("#searchKey").val()
				+"&searchValue="+ $("#searchValue").val()
				+"&active="+ $("#active").val()
				+"&teamTypeYN=${teamTypeYN}";
	var target = "userList";

	ajaxPage(url,data,target);
}

function searchPopup(url){	window.open(url,'window','width=400, height=300, left=300, top=300,scrollbar=yes,resizble=0');}
function setSearchTeam(teamID,teamName){$('#ownerTeamCode').val(teamID);$('#teamName').val(teamName);}

function fnGetCompany(client,companyID){
	fnSelect('company','&teamType=2&languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID='+client,'getTeam', 'Select');
}

function fnGetTeam(company){
	fnSelect('team','&teamType=4&languageID=${sessionScope.loginInfo.sessionCurrLangType}&companyID='+company,'getTeam', 'Select');
}

function fnChangeAuthority(){
	var selectedCell = grid.data.findAll(function (data) {
        return data.checkbox;
	});
	if(!selectedCell.length){
		alert("${WM00023}");
		return;
	}
	var memberIDs = selectedCell.map(function(cell) {
    	return cell.MemberID;
	}).join(",");
	
	var employeeNums = selectedCell.map(function(cell) {
    	return cell.EmployeeNum;
	}).join(",");
	
	var url  = "setUserAuthority.do?memberIDs="+memberIDs+"&employeeNums="+employeeNums;
	window.open(url,'window','width=500, height=250, left=300, top=300,scrollbar=no,resizble=0');
}

//
function fnChangeClientID(){
	var selectedCell = grid.data.findAll(function (data) {
        return data.checkbox;
	});
	if(!selectedCell.length){
		alert("${WM00023}");
		return;
	}
	var memberIDs = selectedCell.map(function(cell) {
    	return cell.MemberID;
	}).join(",");
	
	var employeeNums = selectedCell.map(function(cell) {
    	return cell.EmployeeNum;
	}).join(",");
	
	var url  = "setUserClientID.do?memberIDs="+memberIDs+"&employeeNums="+employeeNums;
	window.open(url,'window','width=500, height=250, left=300, top=300,scrollbar=no,resizble=0');
}

function fnCallBack(){
	doSearchOUGList();
}

function clearSearchCon() {

	// 기본정보 상세
	$("#position").val('');
	$("#client").val('');
	$("#company").val('');
	$("#searchKey").val('Name');
	$("#searchValue").val('');	
	$("#mType").val('');
	$("#authority").val('');
	$("#active").val('');

	fnResetSelectBox("team","");

}

function fnResetSelectBox(objName,defaultValue)
{
	$("select[name='"+ objName +"'] option").not("[value='"+defaultValue+"']").remove(); 
}

</script>
<form name="userList" id="userList" action="#" method="post" onsubmit="return false;">
	<div id="userListDiv" class="hidden" style="width:100%;height:100%;">
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
	<input type="hidden" id="Category" name="Category" value="${Category}">
	<input type="hidden" id="loginID" name="loginID" value="${sessionScope.loginInfo.sessionAuthId}">
	<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="" />
	<input type="hidden" id="currPage" name="currPage" value="${currPage}"></input>
	<div class="msg"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;${menu.LN00072}</div>
	<div>	  	
		<div>
			
		<table style="table-layout:fixed;" border="0" cellpadding="0" cellspacing="0" class="tbl_search mgT5"  id="search">
			<colgroup>
			    <col width="7%">
			    <col width="18%">
			    <col width="7%">
			    <col width="18%">
			    <col width="7%">
			    <col width="18%">
			    <col width="7%">
			    <col width="18%">
		    </colgroup>
		    
		    <!-- 항목유형, 계층, ID -->
		    <tr>
		    	<!-- [Client] -->
	            <th class="alignL">${labelNM}</th>
	            <td class="alignL">
					<select id="client" name="client" OnChange="fnGetCompany(this.value);" style="width:180px;">
						<option value="">Select</option>
					</select>
	            </td>
	            <th class="alignL">Company</th>
	            <td  class="alignL">
				<select id="company" Name="company" OnChange="fnGetTeam(this.value);" style="width:180px;"></select>
				</td>
				<th  class="alignL">Team</th>
	            <td  class="alignL">
					<select id="team" Name="team" style="width:180px;"><option value="">Select</option></select>
				</td>
				 <th class="alignL">Position</th>
	            <td class="alignL">					
				<input type="text" id="position" name="position" value="" class="text" style="width:180px;ime-mode:active;">								
	            </td>
		    </tr>
		    <tr>
		    	<th  class="alignL">				
					<select id="searchKey" name="searchKey" style="width:80px;">
						<option value="Name">Name</option>
						<option value="ID">ID</option>
					</select>
				</th>
	            <td  class="alignL">
	           		<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:180px;ime-mode:active;">
				</td>	
				<th  class="alignL">Role Type</th>
	            <td  class="alignL">
					<select id="mType" Name="mType" style="width:180px;">
					<option value="">Select</option>
					<option value="RMBR">Role Manager</option>
					<option value="MMBR">Team Manager</option>
					<option value="AMBR">Author</option>
					</select>
				</td>
	            <th class="alignL">Authority</th>
	            <td  class="alignL">				
					<select id="authority" name="authority" style="width:180px;">
				</td>	
				<th  class="alignL">Active</th>
	            <td  class="alignL">
					<select id="active" name="active" style="width:180px;">
						<option value="">Select</option>
						<option value="1" selected>Y</option>
						<option value="0">N</option>
					</select>&nbsp;
				</td>
		    </tr>
		</table>
		</div>	
		<li style="margin-top:20px !important;">
			<div align="center">			
				<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchOUGList()" value="Search">
				&nbsp;<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;" onclick="clearSearchCon();">
			</div>
		</li>
		<div class="countList" >
		<li class="count">Total  <span id="TOT_CNT"></span></li>
		<li class="floatR">	
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			    &nbsp;<span class="btn_pack medium icon"><span class="reload"></span><input value="Change Site Code" onclick="fnChangeClientID();" type="submit"></span>
				&nbsp;<span class="btn_pack medium icon"><span class="reload"></span><input value="Change Authority" onclick="fnChangeAuthority();" type="submit"></span>
				&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" id="newButton"  onclick="clickNewBtn()"></span>
				&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" id="delButton"  onclick="userDel()"></span>
				&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>		    
			</c:if>
		</li>
		</div>
		<div id="gridDiv" class="mgB10"  style="height:440px">
			<div id="grdOUGGridArea" style="height:400px; width:100%"></div>
		</div>
		
		<!-- START :: PAGING -->
		<div id="pagination"></div>
		<!-- END :: PAGING -->	
		
	    </div>
		
		<table id="userInfo" name="userInfo" class="tbl_blue01 mgT10" style="display:none;width:100%;border:0;cellpadding:0;cellspacing:0" >
			<tr>
				<!-- ID -->
				<th class="viewtop">${menu.LN00106}</th>
				<td class="viewtop"><input type="text" class="text isnew" id="LoginID" name="LoginID" title="ID" maxlength="40"></td>
				<!-- Name -->
				<th class="viewtop">${menu.LN00028}</th>
				<td class="viewtop"><input type="text" class="text isnew" id="Name" name="Name" title="Name"></td>			
				<!-- 사번 -->
				<th class="viewtop">${menu.LN00148}</th>
				<td class="viewtop"><input type="text" class="text isnew" id="EmployeeNum" name="EmployeeNum" title="${menu.LN00148}" maxlength="20"></td>	
				<th class="viewtop">Position</th>
				<td class="viewtop last"><input type="text" class="text" id="Position" name="Position"  value="${getData.Position}"/></td>	
			</tr>
			<tr>
				<th>E-mail</th>
				<td><input type="text" class="text isnew" id="Email" name="Email" title="Email" maxlength="100"></td>	
				<th>Mobile</th>
				<td><input type="text" class="text" id="MTelNum" name="MTelNum"  value="${getData.MTelNum}"/></td>		
				<th>${menu.LN00104}</th>
				<td><input type="text"class="text" id="teamName" name="teamName" readonly="readonly" onclick="searchPopup('searchTeamPop.do?teamTypeYN=${teamTypeYN}')" title="${menu.LN00104}" value="" /></td>		
				<!-- 권한 -->
				<th>${menu.LN00149}</th>
				<td class="alignL pdR20 last">
					<select id="Authority" name="Authority"></select>
				</td>	
			</tr>
			
			<tr>
				<td colspan="8" class="alignR pdR20 last" bgcolor="#f9f9f9">
					<input type="hidden" id="MemberID" name="MemberID" class="isnew"/>					
					<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="clickSaveBtn()"></span>
				</td>
			</tr>			
		</table>
</div>
</form>
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none;border: 0;" ></iframe>