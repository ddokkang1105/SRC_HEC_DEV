<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 관리자 : 그릅 사용자 연관 관리 -->
<!-- 
	@RequestMapping(value="/allocateUsers.do")
	* user_SQL.xml - allocateUsers_gridList
	* Action
	  - Save  :: setUserGroupAllocateUser.do
 -->

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00038" var="CM00038"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00039" var="CM00039"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
 
<script type="text/javascript">
	var au_gridArea;	//그리드 전역변수
	$(document).ready(function() {	
		gridInit();
		doSearchList();
	});	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridInit(){		
		var d = setGridData();		
		au_gridArea = fnNewInitGrid("grdAUArea", d);
		au_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		fnSetColType(au_gridArea, 1, "ch");
		au_gridArea.setColumnHidden(2, true);	
				
		au_gridArea.enablePaging(true,100,10,"pagingArea",true,"recInfoArea");
		au_gridArea.setPagingSkin("bricks");
		au_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});		
		
	}	
	function setGridData(){
		var getCode = "TMPL001";
		/*
		if($("#getCode").val() != ''){
			getCode = $("#getCode").val();
		}
		*/		
		var result = new Object();
		result.title = "${title}";
		result.key = "user_SQL.allocateUsers";
		result.header = "${menu.LN00024},#master_checkbox,MemberID,ID,Name,${menu.LN00018},${menu.LN00014},${menu.LN00042}";//10
		result.cols = "CHK|MemberID|LoginID|UserName|TeamName|CompanyName|AuthorityName";
		result.widths = "30,50,100,100,120,80,90,90,90,90";
		result.sorting = "int,int,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,left,center,left,left,left,center,center";
		result.data = "s_itemID=${s_itemID}" //"s_itemID=${getMap.OwnerTeamID}"
//					+ "&category=${category}"
//					+ "&getCode="+getCode
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		//alert(result.data);			
		return result;
	}	
	function gridOnRowSelect(id, ind){
		//(ind);
		//doDetail(au_gridArea.cells(id, 5).getValue());
		//objectExport(id);
	}
	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(au_gridArea, d.key, d.cols, d.data);
	}	
	function setAllocateUser(){		
		if(au_gridArea.getCheckedRows(1).length == 0){
			//if(confirm("그릅에 할당 된 사용자가 없습니다. \n기존에 할당 되었던 사용자는 모두 지워 집니다.")){
			if(confirm("${CM00038}")){
				var url = "setUserGroupAllocateUser.do";
				var data = "s_itemID=${s_itemID}";
				var target = "blankFrame";
				ajaxPage(url, data, target);
				//alert(data);
			}
		}else{
			//if(confirm("선택된 사용자를 그릅에 할당 하시겠습니까?")){
			if(confirm("${CM00039}")){
				//$("#blankFrame").attr("action","").submit();				
				var checkedRows = au_gridArea.getCheckedRows(1).split(",");
				//grid의 check된 사용자 items에 id추가하기
				var items = au_gridArea.cells(checkedRows[0], 2).getValue();
				for(var i = 1 ; i < checkedRows.length; i++ ){
					items += ","+ au_gridArea.cells(checkedRows[i], 2).getValue();
				}				
				var url = "setUserGroupAllocateUser.do";
				var data = "s_itemID=${s_itemID}&items="+items;
				var target = "blankFrame";				
				//alert(data);				
				ajaxPage(url, data, target);
			}
		}
	}
			
	function fnSearchUser(){
		var data = "groupID=${s_itemID}"; 
		var url = "searchUser.do";
		var target = "allocUserDiv";
		ajaxPage(url, data, target);
	}
	
	function fnDeleteUser() {
		if(au_gridArea.getCheckedRows(1).length == 0){
			alert("${WM00023}");
		} else {
			if(confirm("${CM00004}")){
				var checkedRows = au_gridArea.getCheckedRows(1).split(",");	
				var memberIds = new Array; 
				
				for(var i = 0 ; i < checkedRows.length; i++ ){
					memberIds[i] = au_gridArea.cells(checkedRows[i], 2).getValue();
				}
				
				var url = "deleteUserGroup.do";
				var data = "groupID=${s_itemID}&memberIds=" + memberIds;
				var target = "blankFrame";
				ajaxPage(url, data, target);
			}
		} 
	}
	
	function fnCallBack(){ 
		gridInit();
		doSearchList();
	}
	
	function fnChangeAuthority(){
		if(au_gridArea.getCheckedRows(1).length == 0){
			alert("${WM00023}");
			return;
		}
		
		var checkedRows = au_gridArea.getCheckedRows(1).split(",");
		var memberIDs = new Array;
		for(var i = 0 ; i < checkedRows.length; i++ ){
			memberIDs[i] = au_gridArea.cells(checkedRows[i], 2).getValue();
		}
		
		var url  = "setUserAuthority.do?memberIDs="+memberIDs;
		window.open(url,'window','width=400, height=250, left=300, top=300,scrollbar=no,resizble=0');
	}
</script>
<div id="allocUserDiv" >
	<div class="countList">
    	<li  class="count">Total  <span id="TOT_CNT"></span></li>     
    	<li class="floatR pdR20 mgB10">	
    		<!-- <span class="btn_pack small icon mgT10"><span class="assign"></span><input value="Assign" type="submit" onclick="setAllocateUser()"></span>  -->
    		<span class="btn_pack medium icon"><span class="reload"></span><input value="Change Authority" onclick="fnChangeAuthority();" type="submit"></span>
			&nbsp;<span class="btn_pack medium icon"><span class="add"></span><input value="User" onclick="fnSearchUser();" type="submit"></span>
			&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDeleteUser()"></span>
    	</li>  	
   	</div>
	<div id="gridDiv" class="mgB10">
		<div id="grdAUArea" style="height:330px; width:100%"></div>
	</div>	
	
		<!-- START :: PAGING -->
		<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
		<!-- END :: PAGING -->	
			
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" frameborder="0" style="display:none"></iframe>
	</div>	
</div>