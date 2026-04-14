<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00029" var="WM00029"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

<!-- 2. Script -->
<script type="text/javascript">
	var gridArea1;
	var gridArea2;
	
	$(document).ready(function() { 		
		gridInit1();
		gridInit2();
		doSearchList1();
		doSearchList2();		
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function gridInit1(){		
		var d = setGridData1();		
		gridArea1 = fnNewInitGrid("gridArea1", d);
		gridArea1.setImagePath("${root}${HTML_IMG_DIR}/");
		//gridArea1.setIconPath("${root}${HTML_IMG_DIR_MEMBER}/");
		gridArea1.setColumnHidden(0, true);	
		//gridArea1.setColumnHidden(2, true);
		gridArea1.setColumnHidden(4, true);	
		gridArea1.setColumnHidden(5, true);		
		fnSetColType(gridArea1, 1, "ch");
		fnSetColType(gridArea1, 2, "img");
	}
	function gridInit2(){		
		var d = setGridData2();
		
		gridArea2 = fnNewInitGrid("gridArea2", d);
		gridArea2.setImagePath("${root}${HTML_IMG_DIR}/"); //path to images required by grid
		gridArea2.setColumnHidden(0, true);
		gridArea2.setColumnHidden(3, true);
		gridArea2.setColumnHidden(4, true);
		gridArea2.setColumnHidden(5, true);
		fnSetColType(gridArea2, 1, "ch");
	}
	
	function setGridData1(){// 선택할 멤버 
		var result = new Object();
		result.title = "${title}";
		result.key = "project_SQL.getMemberList";		
		result.header = "${menu.LN00024},#master_checkbox,,${menu.LN00037},MemberID,MemberName";
		result.cols = "CHK|Photo|MemberInfo|MemberID|MemberName";
		result.widths = "30,30,70,*,0,0";
		result.sorting = "int,int,str,str,str,str";
		result.aligns = "center,center,center,left,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&UserLevel=ALL"
					+ "&teamID=${teamID}&projectID=${projectID}"
					+ "&blankPhotoUrlPath=${root}${HTML_IMG_DIR}/blank_photo.png"
					+ "&photoUrlPath=<%=GlobalVal.EMP_PHOTO_URL%>"
					+ "&assignmentYN=Y";
					if($("#searchValue").val() != '' && $("#searchValue").val() != null){
						result.data = result.data +"&searchKey="+ $("#searchKey").val();
						result.data = result.data +"&searchValue="+ $("#searchValue").val();
					}
		return result;
	}
	
	function setGridData2(){// 선택된 멤버
		var result = new Object();
		result.title = "${title}";
		result.key = "project_SQL.getPjtWorkerList"; 
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00037},MemberID,Photo,MemberInfo";
		result.cols = "CHK|MemberName|MemberID|Photo|MemberInfo";
		result.widths = "30,30,*,80,80,80";
		result.sorting = "int,int,str,str,str,str";
		result.aligns = "center,center,left,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&UserLevel=ALL"
						+ "&teamId=${teamID}&projectID=${projectID}"
						+ "&blankPhotoUrlPath=${root}${HTML_IMG_DIR}/blank_photo.png"
						+ "&photoUrlPath=<%=GlobalVal.EMP_PHOTO_URL%>"
						+ "&assignmentYN=Y";
		return result;
	}
	
	function doSearchList1(){
		var d = setGridData1();
		fnLoadDhtmlxGridJson(gridArea1, d.key, d.cols, d.data);
	}
	
	function doSearchList2(){
		var d = setGridData2();
		fnLoadDhtmlxGridJson(gridArea2, d.key, d.cols, d.data);
	}
	
	function doClickMove(toRight){ 
		var sourceGrid, targetGrid;
		if(toRight){
			sourceGrid = gridArea1;
			targetGrid = gridArea2;
		}else{	
			sourceGrid = gridArea2;
			targetGrid = gridArea1; 
		}		
		var moveRowStr = sourceGrid.getCheckedRows(1);
		if(moveRowStr == null || moveRowStr.length == 0){alert("${WM00029}");return;}
		var moveRowArray = moveRowStr.split(',');
		
		if(toRight){
			for(var i = 0 ; i < moveRowArray.length ; i++){			
				var newId = (new Date()).valueOf();
				targetGrid.addRow(newId, [newId
				                          ,"0"
				                          ,sourceGrid.cells(moveRowArray[i],5).getValue()
				                          ,sourceGrid.cells(moveRowArray[i],4).getValue() 
				                          ,sourceGrid.cells(moveRowArray[i],2).getValue()
				                          ,sourceGrid.cells(moveRowArray[i],3).getValue()		                          
				                          ]				
										  , targetGrid.getRowsNum());
			}
		}else{			
			for(var i = 0 ; i < moveRowArray.length ; i++){			
				var newId = (new Date()).valueOf();
				targetGrid.addRow(newId, [newId
				                          ,"0"
				                          ,sourceGrid.cells(moveRowArray[i],4).getValue() 
				                          ,sourceGrid.cells(moveRowArray[i],5).getValue() 
				                          ,sourceGrid.cells(moveRowArray[i],3).getValue() 
				                          ,sourceGrid.cells(moveRowArray[i],2).getValue()
				                          ], targetGrid.getRowsNum());
			}
		}
		for(var i = 0 ; i < moveRowArray.length ; i++){
			sourceGrid.deleteRow(moveRowArray[i]);
		}
	}	
	
	function fnAssignMember() {		
		if(confirm("${CM00001}")){
			var rowsCnt  = gridArea2.getRowsNum();
			var memberIds ="";
			for(var i = 0 ; i < rowsCnt; i++ ){
				if (memberIds == "") {
					memberIds = gridArea2.cells2(i, 3).getValue();
				} else {
					memberIds = memberIds + "," + gridArea2.cells2(i, 3).getValue();
				}
			}
			
			var url = "admin/assignMembers.do";
			var data = "projectID=${projectID}&teamID=${teamID}&memberIds="+memberIds; 
			var target = "saveFrame";
			ajaxPage(url, data, target);
		}		
	}
		
	function fnCallBack(){
		//doSearchList1();
		//doSearchList2();
		parent.opener.doPSearchList();
		parent.self.close();
	}
	
</script>
<div style="width:98%; margin:auto;">
<form name="userNameListFrm" id="userNameListFrm" action="#" method="post" onsubmit="return false;">
	<div class="child_search mgT5">
		<li class="pdL20 pdR5">	
			<select id="searchKey" name="searchKey" class="pdL5">
				<option value="Name">Name</option>
				<option value="ID">ID</option>
			</select>
			<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="stext" style="width:150px;ime-mode:active;">
			<input type="image" class="image searchPList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" OnClick="doSearchList1();">&nbsp;
			<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;" onclick="clearSearchCon();">	
		</li>
		<li class="floatR pdR10">
			<!-- &nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span> -->
		</li>
    </div>    
    <table style="width:100%;height:500px;overflow:hidden;" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="45%" align="left" class="pdT10" >
				<div id="gridArea1" style="height:450px;width:100%"></div>
			</td>
			<td width="10%" align="center">
				<img src="${root}${HTML_IMG_DIR}/btn_add_attr.png" onclick="doClickMove(true);" title="추가" style="cursor:pointer;_cursor:hand"><br><br>				
				<img src="${root}${HTML_IMG_DIR}/btn_remove_attr.png"  onclick="doClickMove(false);" title="삭제" style="cursor:pointer;_cursor:hand">
			</td>				
			<td width="45%" align="left" class="pdT10" >
				<div id="gridArea2" style="height:450px;width:100%"></div>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="right" class="pdR20">
				<span id="save" class="btn_pack medium icon"><span class="save"></span>
					<input value="Save" type="submit" onclick="fnAssignMember()">
				</span>&nbsp;
			</td>
		</tr>
	</table>
</form>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;" frameborder="0"></iframe>
