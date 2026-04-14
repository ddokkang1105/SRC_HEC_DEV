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

<!-- 2. Script -->
<script type="text/javascript">
	var pp_grid;				//그리드 전역변수
    var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	var listEditable = "${listEditable}";
	
	$(document).ready(function() {
			
		$('.searchPList').click(function(){doPSearchList();});
		$("#searchValue").focus();	
		$('#searchValue').keypress(function(onkey){if(onkey.keyCode == 13){doPSearchList();return false;}});
		
		$("#excel").click(function(){pp_grid.toExcel("${root}excelGenerate");});
		
		PgridInit();
		//doPSearchList();
		
	});	
	
	// BEGIN ::: GRID
	//그리드 초기화
	function PgridInit(){		
		var d = setPGridData();
		pp_grid = fnNewInitGrid("grdPAArea", d);
		pp_grid.setImagePath("${root}${HTML_IMG_DIR}/");
		pp_grid.setColumnHidden(10, true);
		pp_grid.setColumnHidden(11, true);
		pp_grid.setColumnHidden(12, true);
		fnSetColType(pp_grid, 1, "ch");
		
		//START - PAGING
		pp_grid.enablePaging(true, 1000, null, "pagingArea", true, "recinfoArea");
		pp_grid.setPagingSkin("bricks");
		pp_grid.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
		//END - PAGING
	}
	
	function setPGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "project_SQL.searchNewMember";
		result.header = "${menu.LN00024},#master_checkbox,LoginID,Name,Position,${menu.LN00202},E-Mail,Mobile,${menu.LN00013},Type,MemberID,Authority,CNT";
		result.cols = "CHK|LoginID|UserName|Position|TeamPath|Email|MTelNum|RegDate|MLVL|MemberID|Authority|CNT";
		result.widths = "30,30,120,80,100,*,180,95,80,80,0,0,0";
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,left,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userType=1&groupID=${groupID}&screenType=user";
				
		if($("#ownerTeamCode").val() != '' && $("#ownerTeamCode").val() != null){
			result.data = result.data +"&teamId="+ $("#ownerTeamCode").val();
		}
		
		// 입력 검색 조건
		if($("#searchValue").val() != '' && $("#searchValue").val() != null){
			result.data = result.data +"&searchKey="+ $("#searchKey").val();
			result.data = result.data +"&searchValue="+ $("#searchValue").val();
		}
		 			
		return result;
	}
	// END ::: GRID	
	//===============================================================================
		
	//조회
	function doPSearchList(){
		var d = setPGridData();
		fnLoadDhtmlxGridJson(pp_grid, d.key, d.cols, d.data, false);
	}	
	
	// [Add] 버튼 Click
	function addPjtMember(url){
		var data = "projectId=${projectId}&isNew=${isNew}&isPjtMgt=${isPjtMgt}";
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
					var url = "delPjtMembers.do";
					var data = "projectId=${projectId}&memberIds=" + memberIds;
					var target = "saveFrame";
					ajaxPage(url, data, target);
				}
			}
		} 
	}
	
	// [Select] 버튼 Click
	function selectNewMember() {
		if(pp_grid.getCheckedRows(1).length == 0){
			alert("${WM00023}");
		} else {
			if(confirm("${CM00012}")){
				var checkedRows = pp_grid.getCheckedRows(1).split(",");	
				var memberIds = new Array; 
				
				for(var i = 0 ; i < checkedRows.length; i++ ){
					memberIds[i] = pp_grid.cells(checkedRows[i], 10).getValue();
				}
				
				var url = "insertUserGroup.do";
				var data = "groupID=${groupID}&memberIds=" + memberIds;
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
		<div id="grdPAArea" style="width:100%; height:200px;"></div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>	
</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;" frameborder="0"></iframe>
