<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="Name"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 2. Script -->
<script type="text/javascript">
	var pp_grid;				//그리드 전역변수
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	var listEditable = "${listEditable}";
	
	$(document).ready(function() {
		// SKON CSRF 보안 조치
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
				}
		})			
		
		$('.searchPList').click(function(){doPSearchList();});
		$("#searchValue").focus();	
		$('#searchValue').keypress(function(onkey){if(onkey.keyCode == 13){doPSearchList();return false;}});
		
		$("#excel").click(function(){ fnGridExcelDownLoad(); });		
	});	
	
	// BEGIN ::: GRID
	var layout = new dhx.Layout("grdPAArea", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});

	var gridData = ${gridData};
	var grid = new dhx.Grid("grid", {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
	        { width: 30, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center" }], align: "center", type: "boolean", editable: true, sortable: false},
	    	{ hidden : true, width: 120, id: "LoginID", header: [{ text: "${menu.LN00106}", align: "center" } ], align: "center" },
	        { width: 80, id: "UserName", header: [{ text: "Name", align: "center" } ], align: "center" },
	        { width: 100, id: "Position", header: [{ text: "Position", align: "center" } ], align: "center" },
	        { id: "TeamPath", header: [{ text: "${menu.LN00202}", align: "center" } ], align: "left" },
	        { width: 180, id: "Email", header: [{ text: "E-Mail", align: "center" } ], align: "center" },
	        { width: 95, id: "MTelNum", header: [{ text: "Mobile", align: "center" } ], align: "center" },
	        { width: 80, id: "MLVL", header: [{ text: "Type", align: "center" } ], align: "center" },
	        { hidden : true, id: "MemberID", header: [{ text: "MemberID", align: "center" } ], align: "center" },
	        { hidden : true, id: "Authority", header: [{ text: "Authority", align: "center" } ], align: "center" },
	        { hidden : true, id: "CNT", header: [{ text: "CNT", align: "center" } ], align: "center" },
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
	    pageSize: 1000,
	});
	
	$("#TOT_CNT").html(grid.data.getLength());
	// END ::: GRID	
	//===============================================================================
		
	//조회
	function doPSearchList(){
		var sqlID = "project_SQL.searchNewMember";
		var param =  "s_itemID=${s_itemID}"				
	        + "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"	
	        + "&userType=1&groupID=${groupID}&screenType=user"
	        + "&teamId="+ $("#ownerTeamCode").val()
	        + "&searchKey=" + $("#searchKey").val()
	        + "&searchValue=" + $("#searchValue").val()
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
 		grid.data.parse(newGridData);
 		fnMasterChk('');
 		$("#TOT_CNT").html(grid.data.getLength());
 	}
 	
	// [Add] 버튼 Click
	function addPjtMember(url){
		var data = "projectID=${projectID}&isNew=${isNew}&isPjtMgt=${isPjtMgt}";
		var target = "help_content";
		ajaxPage(url, data, target);
	}
	
	// [Del] 버튼 Click
	function delPjtMember() {
		if(pp_grid.getCheckedRows(1).length == 0){
			alert("${WM00023}");
		} else {
			if(confirm("${CM00004}")){
				var checkedRows = pp_grid.getCheckedRows(1).split(",");	
				var memberIds =""; 
				
				for(var i = 0 ; i < checkedRows.length; i++ ){
					var count = pp_grid.cells(checkedRows[i], 12).getValue();
					if (count > 0) {
						var id = "LoginID : " + pp_grid.cells(checkedRows[i], 2).getValue();
						"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00134' var='WM00134' arguments='"+ id +"'/>"
						alert("${WM00134}");
						pp_grid.cells(checkedRows[i], 1).setValue(0); 
					} else {
						if (memberIds == "") {
							memberIds = pp_grid.cells(checkedRows[i], 10).getValue();
						} else {
							memberIds = memberIds + "," + pp_grid.cells(checkedRows[i], 10).getValue();
						}
					}
				}
				if (memberIds != "") {
					var url = "admin/delPjtMembers.do";
					var data = "projectID=${projectID}&memberIds=" + memberIds;
					var target = "saveFrame";
					ajaxPage(url, data, target);
				}
			}
		} 
	}
	
	// [Select] 버튼 Click
	function selectNewMember() {
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
		});
		if(!selectedCell.length){
			alert("${WM00023}");
		}else{
			if(confirm("${CM00012}")){
				var csrfToken = document.getElementById("csrfToken").value;

				var memberIds = selectedCell.map(function(cell) {
			    	return cell.MemberID;
				}).join(",");
				var url = "admin/insertUserGroup.do";
				var data = "groupID=${groupID}&memberIds=" + memberIds + "&csrfToken=" + csrfToken;
				var target = "saveFrame";
				ajaxPage(url, data, target);
			}
		} 
	}
	
	// [Del][Select] Click 이벤트 후 처리
	function fnGoBack(){
		var url = "allocateUsers.do";
		var data = "s_itemID=${groupID}&currPage=${currPage}";
		var target = "userNameListFrm";
		ajaxPage(url, data, target);
	}
	
	// [조직] text Click 이벤트
	function searchPopup(url){
		window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	function setSearchTeam(teamID,teamName){
		$('#ownerTeamCode').val(teamID);
		$('#txtTeam').val(teamName);
	}
	
	// [Clear] click
	function clearSearchCon() {
		// User Type
		$("#userType").val("1").attr("selected", "selected");
		// 조직
		$("#selTeam").val("").attr("selected", "selected");
		$("#ownerTeamCode").val('');
		$("#txtTeam").val('');
		// 입력 검색조건
		$("#searchKey").val("Name").attr("selected", "selected");
		$("#searchValue").val('');
	}
	

</script>

<form name="userNameListFrm" id="userNameListFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="" />

	<!-- skon 보안 취약점 csrf -->
	<input type="hidden" id="csrfToken" name="csrfToken"  value="${csrfToken}">

	<div class="msg" style="width:100%;">
	   <img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Add new members
    </div>
	<div class="child_search">
		<li class="pdL20 pdR5">				
			&nbsp;&nbsp;${menu.LN00247}&nbsp;
			<input type="text" id="txtTeam" name="txtTeam" value="" class="stext" readonly="readonly" onclick="searchPopup('searchTeamPop.do')" style="width:200px;">
			&nbsp;
			<select id="searchKey" name="searchKey" class="pdL5">
				<option value="Name">Name</option>
				<option value="ID">ID</option>
			</select>
			<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="stext" style="width:150px;ime-mode:active;">
			<input type="image" class="image searchPList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색">&nbsp;
			<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;" onclick="clearSearchCon();">	
		</li>
		<li class="floatR pdR20">		
			<span class="btn_pack small icon"><span class="add"></span><input value="Select" type="submit" onclick="selectNewMember()" ></span>
			&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			&nbsp;<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="fnGoBack()" type="submit"></span>
		</li>
    </div>
  	
	<div class="countList pdT5">
    	<li  class="count">Total  <span id="TOT_CNT"></span></li>
   	</div>
	<div id="gridDiv" class="mgB10 clear" align="center">
		<div id="grdPAArea" style="width:100%; height:350px;"></div>
	</div>
		<!-- START :: PAGING -->
		<div id="pagination"></div>
		<!-- END :: PAGING -->	
</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;" frameborder="0"></iframe>
