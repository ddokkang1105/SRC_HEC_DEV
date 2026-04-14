<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

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
	
	// 화면 크기 조정
	$("#gridArea").attr("style","height:"+(setWindowHeight() - 240)+"px;");
	window.onresize = function() {
		$("#gridArea").attr("style","height:"+(setWindowHeight() - 240)+"px;");
	};	
	
	fnSelectNone('Authority','&Category=MLVL','getDicWord', 'VIEWER');

	$("#excel").click(function(){ fnGridExcelDownLoad(); });
	
	fnSelect('client','&teamType=1&languageID=${sessionScope.loginInfo.sessionCurrLangType}','getTeam','${clientID}','Select');
	fnSelect('authority','&Category=MLVL','getDicWord', '','Select');
	
	if("${clientID}" != '' & "${clientID}" != null) fnGetCompany("${clientID}");
	else fnSelect('company','&teamType=2&languageID=${sessionScope.loginInfo.sessionCurrLangType}','getTeam','${companyID}','Select');
	
	if("${companyID}" != '' & "${companyID}" != null){
		fnSelect('company','&teamType=2&languageID=${sessionScope.loginInfo.sessionCurrLangType}','getTeam','${companyID}','Select');
		fnSelect('team','&teamType=4&languageID=${sessionScope.loginInfo.sessionCurrLangType}&companyID=${companyID}','getTeam','${teamID}','Select');
	}
	
	if("${searcheckboxey}" != '' & "${searcheckboxey}" != null) {$("#searcheckboxey").val("${searcheckboxey}");}
	if("${active}" != '' & "${active}" != null) $("#active").val("${active}");
		
	doSearchList();
});

//===============================================================================
	
function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
		
function doSearchList(){
	var gridConfig = setGridConfig();

	var param = "";
	param += gridConfig.data + "&sqlID="+gridConfig.key
	
	$.ajax({
		url:"jsonDhtmlxListV7.do",
		type:"POST",
		data:param,
		success: function(result){
			fnReloadGrid(result);
			$('#loading').fadeOut(150);
		},error:function(xhr,status,error){
			console.log("ERR :["+xhr.status+"]"+error);
		}
	});
	
	function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
			$("#TOT_CNT").html(grid.data.getLength());
	}	
		
}

function gridOUGInit(){	
	var d = setGridConfig();
	p_gridOUGArea = fnNewInitGrid("grdOUGGridArea", d);
	p_gridOUGArea.setImagePath("${root}${HTML_IMG_DIR}/");
	p_gridOUGArea.setColumnHidden(2, true);
	p_gridOUGArea.setColumnHidden(11, true);
	p_gridOUGArea.setColumnHidden(14, true);
	p_gridOUGArea.setColumnHidden(15, true);
	fnSetColType(p_gridOUGArea, 1, "ch");
	p_gridOUGArea.attachEvent("onRowSelect", function(id,ind){handleGridRowSelect(id,ind);});
	
	p_gridOUGArea.enablePaging(true,50,10,"pagingArea",true,"recInfoArea");
	p_gridOUGArea.setPagingSkin("bricks");
	p_gridOUGArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
}
function setGridConfig(){
	var result = new Object();
	result.title = "${title}";
	result.key = "user_SQL.userList";
	result.data = "UserType=1&isRole=Y"
				+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
				
				/* 검색 조건 */
				if($("#client").val() != '' & $("#client").val() != null){
					result.data = result.data + "&ClientID="+$("#client").val();
				} else if("${clientID}" != '' & "${clientID}" != null){
					result.data = result.data + "&ClientID=${clientID}";
				}
				
				if($("#company").val() != '' & $("#company").val() != null){
					result.data = result.data + "&CompanyID="+$("#company").val();
				}else if("${companyID}" != '' & "${companyID}" != null){
					result.data = result.data + "&CompanyID=${companyID}";
				}else if("${companyNM}" != '' & "${companyNM}" != null){
					result.data = result.data + "&CompanyNM=${companyNM}";
				}
				
				if($("#team").val() != '' & $("#team").val() != null){
					result.data = result.data + "&TeamID="+$("#team").val();
				}else if("${teamID}" != '' & "${teamID}" != null){
					result.data = result.data + "&TeamID=${teamID}";
				}else if("${teamNM}" != '' & "${teamNM}" != null){
					result.data = result.data + "&TeamNM=${teamNM}";
				}
				
				if($("#active").val() != '' & $("#active").val() != null){
					result.data = result.data + "&active="+$("#active").val();
				} else if("${active}" != '' & "${active}" != null){
					result.data = result.data + "&active=${active}";
				}

				if($("#authority").val() != '' & $("#authority").val() != null){
					result.data = result.data + "&authority="+$("#authority").val();
				} 

				if($("#position").val() != '' & $("#position").val() != null){
					result.data = result.data + "&position="+$("#position").val();
				} 

				result.data = result.data + "&searcheckboxey="+$("#searcheckboxey").val();
				result.data = result.data + "&searchValue="+$("#searchValue").val();
				result.data = result.data + "&pageNum=" + $("#currPage").val();
	return result;
}


function handleGridRowSelect(row, column, e){

	if(column.id != "checkbox"){
		doDetail(row.MemberID);
	}
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
				+"&searcheckboxey="+ $("#searcheckboxey").val()
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
	console.log(company)
	fnSelect('team','&teamType=4&languageID=${sessionScope.loginInfo.sessionCurrLangType}&companyID='+company,'getTeam', 'Select');
}


function handleHeaderCheckboxClick(state, targetGrid, checkboxName) {
	    event.stopPropagation();
	    targetGrid.data.forEach(function(row) {
	        targetGrid.data.update(row.id, {
	            checkbox: state
	        });
	    });  
    }

// =============================== [[미사용 함수]] ===============================================================================

// 미사용 함수
function fnChangeAuthority(){
	
    var checkedRows = [];
    grid.data.forEach(function(row) {
        if (row.checkbox) { 
        	checkedRows.push(row.id);
        }
    });
	
	if(checkedRows.length == 0){
		alert("${WM00023}");
		return;
	}

	var memberIDs = [];
	for(var i = 0 ; i < checkedRows.length; i++ ){
        const rowId = checkedRows[i];
        const rowData = grid.data.getItem(rowId);
        memberIDs.push(rowData.MemberID);
	}
	
	// 시스템 관리자 제외
	var url  = "setUserAuthority.do?groupManagerYN=Y&memberIDs="+memberIDs;
	window.open(url,'window','width=400, height=250, left=300, top=300,scrollbar=no,resizble=0');
}	
	
// 미사용 함수
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

// 미사용 함수
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
			
			var url = "admin/memberUpdate.do";
			var data = "userMenu=user&type=delete&s_itemID=${s_itemID}&items="+items;
			var target = "blankFrame";
			ajaxPage(url, data, target);
			
		}
	}
}

// 미사용 함수
function clickNewBtn(){$("#MemberID").val('');initControl(true);}

// 미사용 함수
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

// 미사용 함수
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

// 미사용 함수
function fnCallBack(){
	doSearchList();
}

</script>
<form name="userList" id="userList" action="#" method="post" onsubmit="return false;">
	<div id="userListDiv" class="hidden" style="width:100%;height:100%;">
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
	<input type="hidden" id="Category" name="Category" value="${Category}">
	<input type="hidden" id="loginID" name="loginID" value="${sessionScope.loginInfo.sessionAuthId}">
	<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="" />
	<input type="hidden" id="currPage" name="currPage" value="${currPage}"></input>
	<div class="msg"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Role Manager List</div>
	<div>	  	
		<div class="child_search">
			<li class="pdL10">

				&nbsp; Company &nbsp;
				<select id="company" Name="company" OnChange="fnGetTeam(this.value);" style="width:120px;"></select>
				&nbsp; Team &nbsp;
				<select id="team" Name="team" style="width:170px;"><option value="">Select</option></select>
				
				&nbsp;Position&nbsp;
				<input type="text" id="position" name="position" value="" class="text" style="width:120px;ime-mode:active;">
								
				&nbsp; Authority&nbsp;
				<select id="authority" name="authority" style="width:120px;">
				</select>&nbsp;
				
				&nbsp; Active&nbsp;
				<select id="active" name="active" style="width:60px;">
					<option value="">Select</option>
					<option value="1">Y</option>
					<option value="0">X</option>
				</select>&nbsp;
				<select id="searcheckboxey" name="searcheckboxey" style="width:70px;">
					<option value="Name">Name</option>
					<option value="ID">ID</option>
				</select>
				<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:120px;ime-mode:active;">
				
				<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchList()" value="검색">
			</li>
			<li class="floatR pdR20">
				<!--<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<span class="btn_pack medium icon"><span class="reload"></span><input value="Change Authority" onclick="fnChangeAuthority();" type="submit"></span>
				&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" id="newButton"  onclick="clickNewBtn()"></span>
				&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" id="delButton"  onclick="userDel()"></span>
				</c:if>-->
				&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			</li> 
			</div>
		
		<div id="gridDiv" style="clear: both;">
			<div id="gridArea" style="width:100%"></div>
		</div>	
		
		<!-- START :: PAGING -->
		<div id="pagination" class="mgT20"></div>	
		<!-- END :: PAGING -->	
		
	    </div>
		
		<!-- 사용자 추가하기 기능과 연관된 영역. 추가하기 기능 자체가 미사용처리되어있음 -->
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
<script>

//=============================== [[그리드 생성]] ===============================================================================

const gridArea = new dhx.Layout("gridArea", {
	rows: [ { id: "a" } ] });

var grid = new dhx.Grid("grid", {
	columns: [

    	{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
    	{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='handleHeaderCheckboxClick(checked, grid)'></input>", align: "center" }], align: "center", type: "boolean", editable: true, sortable: false},
		{ hidden: true, id: "LoginID", header: [{ text: "Login ID", align: "center" } ], align: "center" },
    	{ width: 80, id: "UserNAME", header: [{ text: "Name", align: "center" } ], align: "center" },
    	{ id: "EnName", header: [{ text: "English Name", align: "center" } ], align: "left" },
    	{ width: 100, id: "EmployeeNum", header: [{ text: "Employee No.", align: "center" } ], align: "center" },
    	{ width: 100, id: "City", header: [{ text: "City", align: "center" } ], align: "center" },
    	{ width: 120, id: "TeamNM", header: [{ text: "Team", align: "center" } ], align: "center" },
    	{ width: 120, id: "Position", header: [{ text: "Position", align: "center" } ], align: "center" },
    	{ width: 80, id: "Authority", header: [{ text: "Authority", align: "center" } ], align: "center" },
    	{ width: 200, id: "Email", header: [{ text: "Email", align: "center" } ], align: "left" },
    	{ hidden: true, id: "CompanyNM", header: [{ text: "Company", align: "center" } ], align: "left" },
    	{ width: 100, id: "TelNum", header: [{ text: "Tel", align: "center" } ], align: "center" },
    	{ width: 100, id: "MTelNum", header: [{ text: "Mobile", align: "center" } ], align: "center" },
    	{ hidden : true, id: "AuthorityName", header: [{ text: "Type", align: "center" } ], align: "center" },
    	{ hidden : true, id: "MemberID", header: [{ text: "MemberID", align: "center" } ], align: "center" },
    	{ width: 80, id: "Active", header: [{ text: "Active", align: "center" } ], align: "center" }
	],
	autoWidth: true,
	resizable: true,
	selection: "row",
	tooltip: false,
});

gridArea.getCell("a").attach(grid);

var pagination = new dhx.Pagination("pagination", {
	data: grid.data,
	pageSize: 50,
});

$("#TOT_CNT").html(grid.data.getLength());

grid.events.on("cellClick", (row, column, e) => handleGridRowSelect(row, column, e)); 


</script>

<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none;border: 0;" ></iframe>