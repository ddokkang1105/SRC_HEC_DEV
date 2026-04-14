<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 관리자 : 그릅  변경관리항목(Project) 연동 관리  -->
<!-- 
	@RequestMapping(value="/userGroupProject.do")
	* user_SQL.xml - userGroupProject_gridList
	* Action
	  - Save  :: setUserGroupChangeSet.do
 -->
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00037" var="CM00037"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

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
//		p_gridArea.setColumnHidden(0, true);
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowSelect(id,ind);
		});
	}	
	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "user_SQL.userGroupProject";
		result.header = "${menu.LN00024},#master_checkbox,ParentProject,${menu.LN00028},${menu.LN00018},${menu.LN00013},${menu.LN00027},,";
		result.cols = "CHK|ParentName|ProjectName|TeamName|CreationTime|StatusName|ProjectID|ChildCount";
		result.widths = "50,50,300,200,100,100,50,0,0";
		result.sorting = "int,int,str,str,str,str,str,int,int";
		result.aligns = "center,center,left,left,center,center,center,center,center";
		result.data = "s_itemID=${s_itemID}"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		return result;
	}	
	//그리드ROW선택시
	function gridOnRowSelect(id, ind){
		//(ind);
		//doDetail(p_gridArea.cells(id, 5).getValue());
		//objectExport(id);
	}
	//조회
	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}	
	//Asign
	function setGroupAccessRight(){
				var url = "setUserGroupChangeSet.do";
		var data = "s_itemID=${s_itemID}";
		var target = "blankFrame";
		
		if(p_gridArea.getCheckedRows(1).length == 0){
			//if(confirm("그릅에 할당 된 ChangeSet이 없습니다. \n기존에 할당 되었던 ChangeSet이 모두 지워 집니다.")){
			if(confirm("${CM00037}")){
				//alert(data);
				ajaxPage(url, data, target);
			}
		}else{
			//if(confirm("저장 하시겠습니까?")){
			if(confirm("${CM00001}")){
				
				var checkedRows = p_gridArea.getCheckedRows(1).split(",");

				//grid의 check된 사용자 items에 id추가하기
				var items = p_gridArea.cells(checkedRows[0], 7).getValue();
				for(var i = 1 ; i < checkedRows.length; i++ ){
					items += ","+ p_gridArea.cells(checkedRows[i], 7).getValue();
				}
				
				data = data + "&items="+items;
				
				ajaxPage(url, data, target);
			}
		}
	}
	
</script>
<!-- BIGIN :: LIST_GRID -->
<div id="gridDiv" class="mgT10 mgB10">
	<div id="grdGridArea" style="height:250px; width:100%"></div>
	<span class="btn_pack small icon mgT10"><span class="assign"></span><input value="Assign" type="submit" onclick="setGroupAccessRight()"></span>
</div>
<!-- END :: LIST_GRID -->
<!-- START :: FRAME --> 		
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" frameborder="0" src="about:blank" style="display:none"></iframe>
</div>	
<!-- END :: FRAME -->