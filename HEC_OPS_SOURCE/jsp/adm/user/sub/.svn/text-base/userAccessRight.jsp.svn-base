<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 관리자 : 사용자 연관 Templet(ArcCode) 관리 -->
<!-- 
	@RequestMapping(value="/userAccessRight.do")
	* user_SQL.xml - userAccessRight_gridList
	* Action
	  - Update :: setUserGroupAccessRight.do
 -->
 
 <!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00028" var="WM00028"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00018" var="CM00018"/>

<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
	$(document).ready(function() {	
		gridInit();
		doSearchList();
	});	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridInit(){		
		var d = setGridData();		
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		fnSetColType(p_gridArea, 3, "ch");
		fnSetColType(p_gridArea, 4, "ch");
		fnSetColType(p_gridArea, 5, "ch");
		p_gridArea.setColumnHidden(6, true);
		p_gridArea.attachEvent("onCheck", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnCheckEvent(id,ind);
		});
	}	
	function setGridData(){	
		var result = new Object();
		result.title = "${title}";
		result.key = "user_SQL.userAccessRight";
		result.header = "${menu.LN00024},Template ID,Template Name,User,Group,Is Default,MemberID";
		result.cols = "TemplCode|TemplName|userChk|groupChk|IsDefault|MemberID";
		result.widths = "50,150,100,70,70,70,80";
		result.sorting = "int,int,str,str,str,int,str";
		result.aligns = "center,center,center,center,center,center,center";
		result.data = "memberID=${memberID}"
					+ "&userType=2"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";		
		return result;
	}
	
	function gridOnCheckEvent(id, ind){
		if(ind==5){ //is Default
			if(p_gridArea.cells(id, 3).getValue()=='0' && p_gridArea.cells(id, 4).getValue()=='1'){
				alert('${WM00028}');				
				p_gridArea.cells(id,5).setValue(0);
			}else{
				if(p_gridArea.getCheckedRows(ind) == "" || p_gridArea.getCheckedRows(ind) == null){
					p_gridArea.setCheckedRows(5,0);
				}else{
					p_gridArea.setCheckedRows(5,0);
					p_gridArea.cells(id,5).setValue(1);
				}
				
				var memberID = p_gridArea.cells(id, 6).getValue();	
				var templCode = p_gridArea.cells(id, 1).getValue();		
				var isDefault = p_gridArea.cells(id, 5).getValue();		
				$("#memberID").val(memberID);
				$("#templCode").val(templCode);
				$("#isDefault").val(isDefault);
			}
		}else if(ind==3){
			if(p_gridArea.cells(id, 3).getValue()=='0' && p_gridArea.cells(id, 5).getValue()=='1'){
				p_gridArea.cells(id,5).setValue(0);
			}
		}else if(ind==4){ //Group 수정 불가
			alert('${WM00028}');
			if(p_gridArea.cells(id,4).getValue() == 0){
				p_gridArea.cells(id,4).setValue(1);
			}else{
				p_gridArea.cells(id,4).setValue(0);
			}
			return false;
		}
	}
	
	//조회
	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	//Asign
	function setGroupAccessRight(){
		
		var templCode = $("#templCode").val();
		var isDefault = $("#isDefault").val();
		
		var url = "setUserGroupAccessRight.do";
		var data = "memberID=${memberID}";
		var target = "blankFrame";
		
		if(p_gridArea.getCheckedRows(3).length == 0 && p_gridArea.getCheckedRows(5).length == 0){
			if(confirm("${CM00018}")){
				ajaxPage(url, data, target);
			}
		}else if(p_gridArea.getCheckedRows(3).length == 0 && p_gridArea.getCheckedRows(5).length != 0){
			if(confirm("저장 하시겠습니까?")){
				data = data + "&defaultTemplCode="+templCode + "&isDefault="+isDefault;
				ajaxPage(url, data, target);
			}
		}
		else{
			if(confirm("저장 하시겠습니까?")){
				var checkedRows = p_gridArea.getCheckedRows(3).split(",");
				var items = "";
				for(var i = 0 ; i < checkedRows.length; i++ ){
					if(items == ""){
						items = p_gridArea.cells(checkedRows[i], 1).getValue(); //templCode
					}else{
						items += ","+ p_gridArea.cells(checkedRows[i], 1).getValue();
					}
				}
				if(p_gridArea.getCheckedRows(5).length == 0){
					data = data + "&items="+items;
				} else{
					data = data + "&items="+items + "&defaultTemplCode="+templCode + "&isDefault="+isDefault;
				}
				ajaxPage(url, data, target);
			}
		}
	}	
	
</script>
<!-- BIGIN :: LIST_GRID -->
<div id="gridDiv" class="mgT10 mgB10">
	<input type="hidden" id="memberID" name="memberID" value="" >
	<input type="hidden" id="templCode" name="templCode" value="" >
	<input type="hidden" id="isDefault" name="isDefault" value="" >
	<div id="grdGridArea" style="height:250px; width:100%"></div>
	<span class="btn_pack small icon mgT10"><span class="assign"></span><input value="Assign" type="submit" onclick="setGroupAccessRight()"></span>	
	<!-- <span class="btn_pack small icon mgT10"><span class="assign"></span><input value="isDefault" type="submit" onclick="fnClickedIsDefault()"></span> -->	
</div>
<!-- END :: LIST_GRID -->
<!-- START :: FRAME --> 		
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" frameborder="0" style="display:none"></iframe>
</div>	
<!-- END :: FRAME -->