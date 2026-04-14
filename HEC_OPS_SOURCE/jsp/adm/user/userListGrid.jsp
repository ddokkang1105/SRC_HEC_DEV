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

<script>
var p_gridOUGArea;
$(document).ready(function(){
	gridOUGInit();		
	doSearchOUGList();
	
	fnSelectNone('Authority','&Category=MLVL','dictionyCode', 'VIEWER');
	fnSelect('company','&teamType=2&languageID=${sessionScope.loginInfo.sessionCurrLangType}','getTeam','${companyID}','Select');
	
	if("${companyID}" != '' & "${companyID}" != null){
		fnSelect('team','&teamType=4&languageID=${sessionScope.loginInfo.sessionCurrLangType}&companyID=${companyID}','getTeam','${teamID}','Select');
	}
});
//===============================================================================
function doSearchOUGList(){
	var d = setGridOUGData();
	fnLoadDhtmlxGridJson(p_gridOUGArea, d.key, d.cols, d.data);
}
function gridOUGInit(){	
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
}
function setGridOUGData(){
	var result = new Object();
	result.title = "${title}";
	result.key = "user_SQL.userList";
	result.header = "${menu.LN00024},#master_checkbox,LoginID,Name,English Name,Employee No.,City,Team,Position,Authority,Email,Company,Tel,Mobile,Type,MemberID,Active";
	result.cols = "CHK|LoginID|UserNAME|EnName|EmployeeNum|City|TeamNM|Position|Authority|Email|CompanyNM|TelNum|MTelNum|AuthorityName|MemberID|Active";
	result.widths = "50,50,100,80,100,100,100,120,120,80,200,0,100,100,0,0,80";
	result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str,int,int,str,str";
	result.aligns = "center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center";
	result.data = "UserType=1"
				+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&checkAuth=1";
	
				/* 검색 조건 */
				if($("#searchValue").val() != '' & $("#searchValue").val() != null){
					result.data = result.data +"&searchValue="+$("#searchValue").val();
					result.data = result.data +"&searchKey="+$("#searchKey").val();
					result.data = result.data + "&pageNum=1";
				} else {
					result.data = result.data + "&pageNum=" + $("#currPage").val();
				}
				
				if($("#company").val() != '' & $("#company").val() != null){
					result.data = result.data + "&CompanyID="+$("#company").val();
				}else if("${companyNM}" != '' & "${companyNM}" != null){
					result.data = result.data + "&CompanyNM=${companyNM}";
				}
				
				if($("#team").val() != '' & $("#team").val() != null){
					result.data = result.data + "&TeamID="+$("#team").val();
				}else if("${teamNM}" != '' & "${teamNM}" != null){
					result.data = result.data + "&TeamNM=${teamNM}";
				}
				
				if($("#active").val() != '' & $("#active").val() != null){
					result.data = result.data + "&active="+$("#active").val();
				}
				
	return result;
}
function gridOUGOnRowSelect(id, ind){initControl(false);if(ind != 1)doDetail(id);}
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
	if(p_gridOUGArea.getCheckedRows(1).length == 0){
		//alert("항목을 한개 이상 선택하여 주십시요.");	
		alert("${WM00023}");
	}else{
		//if(confirm("선택된 항목를 삭제하시겠습니까?")){
		if(confirm("${CM00004}")){
			var checkedRows = p_gridOUGArea.getCheckedRows(1).split(",");
			var items = "";
			for(var i = 0 ; i < checkedRows.length; i++ ){
				if (i == 0) {
					items = p_gridOUGArea.cells(checkedRows[i], 15).getValue();
				} else {
					items = items + "," + p_gridOUGArea.cells(checkedRows[i], 15).getValue();
				}
			}
			
			var url = "memberUpdate.do";
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
	var url  = "saveUser.do";
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
				+"&memberID="+p_gridOUGArea.cells(id, 15).getValue()
				+"&currPage=" + $("#currPage").val()
				+"&companyID="+ $("#company").val()
				+"&teamID="+ $("#team").val()
				+"&searchKey="+ $("#searchKey").val()
				+"&searchValue="+ $("#searchValue").val()
				+"&teamTypeYN=${teamTypeYN}";
	var target = "userList";

	ajaxPage(url,data,target);
}

function searchPopup(url){	window.open(url,'window','width=400, height=300, left=300, top=300,scrollbar=yes,resizble=0');}
function setSearchTeam(teamID,teamName){$('#ownerTeamCode').val(teamID);$('#teamName').val(teamName);}

function fnGetTeam(company){
	fnSelect('team','&teamType=4&languageID=${sessionScope.loginInfo.sessionCurrLangType}&companyID='+company,'getTeam', 'Select');
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
		<div class="child_search">
			<li class="pdL10">
				Company &nbsp;
				<select id="company" Name="company" OnChange="fnGetTeam(this.value);" style="width:120px;"></select>
				&nbsp; Team &nbsp;
				<select id="team" Name="team" style="width:170px;"><option value="">Select</option></select>
				&nbsp;&nbsp;
				<select id="searchKey" name="searchKey" style="width:70px;">
					<option value="Name">Name</option>
					<option value="ID">ID</option>
				</select>
				<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:120px;ime-mode:active;">
				&nbsp; Active&nbsp;
				<select id="active" name="active" style="width:60px;">
					<option value="">Select</option>
					<option value="1" selected>Y</option>
					<option value="0">X</option>
				</select>&nbsp;
				<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchOUGList()" value="검색">
			</li>
			<li class="floatR pdR20">
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
					<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" id="newButton"  onclick="clickNewBtn()"></span>&nbsp;
					&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" id="delButton"  onclick="userDel()"></span>
					</c:if>
			</li>
			</div>
		
		<div id="gridDiv" class="mgB10 mgT5">
			<div id="grdOUGGridArea" style="height:400px; width:100%"></div>
		</div>
		
		<!-- START :: PAGING -->
		<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
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