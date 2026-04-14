<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 관리자 : 사용자 -그릅 연동 관리 -->
<!-- 
	@RequestMapping(value="/UserGroup.do")
	* user_SQL.xml - UserGroup_gridList
	* Action
	  - Update :: setAllocateUserGroup.do
 -->
 
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00019" var="CM00019"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00036" var="CM00036"/>
 
<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
	$(document).ready(function() {	
		gridInit();
		doSearchList();
	});	
	function gridInit(){		
		var d = setGridData();		
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowSelect(id,ind);
		});	
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
		result.key = "user_SQL.UserGroup";
		result.header = "${menu.LN00024},선택,ID,Name,${menu.LN00013}";//4
		result.cols = "CHK|MemberID|Name|RegDate";
		result.widths = "30,50,100,200,120";
		result.sorting = "int,int,str,str,str";
		result.aligns = "center,center,center,left,center";
		result.data = "memberID=${memberID}" //"s_itemID=${getMap.OwnerTeamID}"
//					+ "&category=${category}"
//					+ "&getCode="+getCode
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		//alert(result.data);			
		return result;
	}
	function gridOnRowSelect(id, ind){
		//(ind);
		//doDetail(p_gridArea.cells(id, 5).getValue());
		//objectExport(id);
	}
	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}	
	function setAllocateUser(){		
		if(p_gridArea.getCheckedRows(1).length == 0){
			//if(confirm("사용자에 할당 된 그릅이 없습니다. \n기존에 할당 되었던 그릅은 모두 지워 집니다.")){
			if(confirm("${CM00036}")){
				var url = "setAllocateUserGroup.do";
				var data = "memberID=${memberID}";
				var target = "blankFrame";
				ajaxPage(url, data, target);
				//alert(data);
			}
		}else{
			//if(confirm("선택된 그릅을 사용자에 할당 하시겠습니까?")){
			if(confirm("${CM00019}")){
				//$("#blankFrame").attr("action","").submit();				
				var checkedRows = p_gridArea.getCheckedRows(1).split(",");
				//grid의 check된 사용자 items에 id추가하기
				var items = p_gridArea.cells(checkedRows[0], 2).getValue();
				for(var i = 1 ; i < checkedRows.length; i++ ){
					items += ","+ p_gridArea.cells(checkedRows[i], 2).getValue();
				}				
				var url = "setAllocateUserGroup.do";
				var data = "memberID=${memberID}&items="+items;
				var target = "blankFrame";
				ajaxPage(url, data, target);
			}
		}
	}
	
</script>
<!-- BIGIN :: LIST_GRID -->
<div id="gridDiv" class="mgT10 mgB10">
	<div id="grdGridArea" style="height:250px; width:100%"></div>
	<span class="btn_pack small icon mgT10"><span class="assign"></span><input value="Assign" type="submit" onclick="setAllocateUser()"></span>
</div>
<!-- END :: LIST_GRID -->
<!-- START :: FRAME --> 		
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" frameborder="0" style="display:none"></iframe>
</div>	
<!-- END :: FRAME -->