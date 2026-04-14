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
		doPSearchList();		
	});	
	
	function PgridInit(){		
		var d = setPGridData();
		pp_grid = fnNewInitGrid("grdPAArea", d);
		pp_grid.setImagePath("${root}${HTML_IMG_DIR}/");
		pp_grid.setColumnHidden(5, true);
		pp_grid.setColumnHidden(6, true);
		fnSetColType(pp_grid, 1, "ch");
		
		pp_grid.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowSelect(id,ind);
		});
		
		pp_grid.enablePaging(true, 1000, null, "pagingArea", true, "recinfoArea");
		pp_grid.setPagingSkin("bricks");
		pp_grid.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	
	function setPGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "project_SQL.getPjtTaskTypeList";
		if ("Y" == listEditable) {
			result.key = "project_SQL.getTaskTypeForPjtList";
		}
		result.header = "${menu.LN00024},#master_checkbox,TaskTypeCode,Name,${menu.LN00016},ItemclassCode,Cnt,SortNum,Mandatory";
		result.cols = "CHK|TaskTypeCode|TaskTypeName|ItemClass|ItemClassCode|PjtTaskCnt|SortNum|Mandatory";
		result.widths = "30,30,100,180,120,80,80,80,80";
		result.sorting = "int,int,str,str,str,str,int,int,int";
		result.aligns = "center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		if($("#ProjectID").val() != ''){
			result.data = result.data +"&projectID="+ $("#ProjectID").val();
		}
		if($("#searchValue").val() != '' && $("#searchValue").val() != null){
			result.data = result.data +"&searchKey="+ $("#searchKey").val();
			result.data = result.data +"&searchValue="+ $("#searchValue").val();
		} 
		 			
		return result;
	}
	// END ::: GRID	
	//===============================================================================
		
	function doPSearchList(){
		var d = setPGridData();
		fnLoadDhtmlxGridJson(pp_grid, d.key, d.cols, d.data, false);
	}	
	
	function fnAddPjtTaskType(url){
		var data = "projectId=${projectId}&listEditable=Y&isNew=${isNew}&isPjtMgt=${isPjtMgt}";
		var target = "help_content";
		ajaxPage(url, data, target);
	}
	
	function fnDelPjtTaskType() {
		if(pp_grid.getCheckedRows(1).length == 0){
			alert("${WM00023}");
		} else {
			if(confirm("${CM00004}")){
				var checkedRows = pp_grid.getCheckedRows(1).split(",");	
				var taskTypeCodes = new Array;				
				for(var i = 0 ; i < checkedRows.length; i++ ){
					var pjtTaskCnt = pp_grid.cells(checkedRows[i], 6).getValue();
					if (pjtTaskCnt > 0) {
						var task = pp_grid.cells(checkedRows[i], 3).getValue()+"("+pp_grid.cells(checkedRows[i], 2).getValue()+")";
						"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00144' var='WM00144' arguments='"+ task +"'/>"
						alert("${WM00144}");
						pp_grid.cells(checkedRows[i], 1).setValue(0); 
					} else {
						taskTypeCodes[i] = pp_grid.cells(checkedRows[i], 2).getValue();
					}
				}
				if (taskTypeCodes != "") {
					var url = "deletePjtTaskTypeCode.do";
					var data = "projectId=${projectId}&taskTypeCodes=" + taskTypeCodes;
					var target = "saveFrame";
					ajaxPage(url, data, target);
				}
			}
		} 
	}
	
	// [Select] 버튼 Click
	function fnSelectNewTaskType() {
		if(pp_grid.getCheckedRows(1).length == 0){
			alert("${WM00023}");
		} else {
			if(confirm("${CM00012}")){
				var checkedRows = pp_grid.getCheckedRows(1).split(",");	
				var taskTypeCodes = new Array;	
				var itemClassCodes = new Array;	
				var j = 0;
				for(var i = 0 ; i < checkedRows.length; i++ ){
					taskTypeCodes[j] = pp_grid.cells(checkedRows[i], 2).getValue();
					itemClassCodes[j] = pp_grid.cells(checkedRows[i], 5).getValue();
					j++;
				}
				var url = "insertPjtTaskType.do";
				var data = "projectId=${projectId}&taskTypeCodes=" + taskTypeCodes+"&itemClassCodes="+itemClassCodes; 
				var target = "saveFrame";
				ajaxPage(url, data, target);
			}
		} 
	}
	
	function fnCallBack(){
		var url = "selectPjtTaskType.do";
		var data = "projectId=${projectId}&listEditable=N&isNew=${isNew}&isPjtMgt=${isPjtMgt}&screenType=${screenType}"; 
		var target = "selectPjtTaskType";
		ajaxPage(url, data, target);
	}
		
	function goBack() {
		var url = "selectPjtTaskType.do";
		var data = "projectId=${projectId}&listEditable=N&isNew=${isNew}&isPjtMgt=${isPjtMgt}";
		var target = "selectPjtTaskType";
		
		if ("N" == listEditable) {
			url = "viewProjectInfo.do";
			data = "isNew=${isNew}&s_itemID=${projectId}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&pjtMode=R&screenType=${screenType}";
		}
		ajaxPage(url, data, target);
	}
	
	//그리드ROW선택시
	function gridOnRowSelect(id, ind){ 
		$("#editTaskType").attr('style', 'display: block');	
		$("#editTaskType").attr('style', 'width: 100%');	
		$("#divSaveBtn").attr('style', 'display: block');	
		
		$("#taskTypeCode").val(pp_grid.cells(id,2).getValue());
		$("#sortNum").val(pp_grid.cells(id,7).getValue());
		$("#mandatory").val(pp_grid.cells(id,8).getValue());

		if(pp_grid.cells(id,8).getValue() == 1){
			$("#mandatory").attr('checked', 'checked');	
		}else{
			$("#mandatory").attr('checked', '');	
		}
	}
	
	function fnSetCheckBox(){			
		var chk = document.getElementsByName("mandatory");
		if(chk[0].checked == true){ $("#mandatory").val("1");
		}else{	$("#mandatory").val("0"); }
	}
	
	function fnSaveTaskTypeInfo(){
		var taskTypeCode = $("#taskTypeCode").val();
		var sortNum = $("#sortNum").val();
		var mandatory = $("#mandatory").val();
		var url = "saveTaskTypeInfo.do";
		var data = "projectId=${projectId}&taskTypeCode="+taskTypeCode+"&sortNum="+sortNum+"&mandatory="+mandatory; 
		var target = "saveFrame";
		ajaxPage(url, data, target);
		
		$("#editTaskType").attr('style', 'display: none');	
		$("#divSaveBtn").attr('style', 'display: none');	
	}
	
</script>

<div id="selectPjtTaskType">
<form name="taskTypeListFrm" id="taskTypeListFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="ProjectID" name="ProjectID" value="${projectId}" />
	<div class="msg mgT5" style="width:100%;">
	   <c:if test="${listEditable == 'N'}">
       	   <img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Manager project task type
       </c:if>
       <c:if test="${listEditable == 'Y'}">
           <img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Add New TaskType
       </c:if>
    </div>
	<div class="child_search">
		<li class="pdL20 pdR5">			
			&nbsp;
			<select id="searchKey" name="searchKey" class="pdL5">
				<option value="name">Name</option>
				<option value="code">ID</option>
			</select>
			<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="stext" style="width:150px;ime-mode:active;">
			<input type="image" class="image searchPList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색">&nbsp;
		</li>
		<li class="floatR pdR20">
			<c:if test="${listEditable == 'N'}">
				<c:if test="${getMap.Status != 'CLS'}"> 
	               	<c:if test="${sessionScope.loginInfo.sessionUserId == getMap.AuthorID || sessionScope.loginInfo.sessionAuthLev == 1}">
						<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="fnAddPjtTaskType('selectPjtTaskType.do')" ></span>
						&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDelPjtTaskType()"></span>
					</c:if>
				</c:if>
			</c:if>
			
			<c:if test="${listEditable == 'Y'}">
				<span class="btn_pack small icon"><span class="add"></span><input value="Select" type="submit" onclick="fnSelectNewTaskType()" ></span>
			</c:if>
			&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>			
			<c:if test="${isPjtMgt != 'Y'}">
				&nbsp;<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="goBack()" type="submit"></span>
			</c:if>
		</li>
    </div>
  	
	<div class="countList pdT5">
    	<li  class="count">Total  <span id="TOT_CNT"></span></li>
   	</div>
	<div id="gridDiv" class="mgB10 clear" align="center">
		<div id="grdPAArea" style="height:200px;width:100%"></div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>	
	<div class="mgT5 mgL10 mgR10">
	<table id="editTaskType" class="tbl_blue01" width="100%"   cellpadding="0" cellspacing="0" style="display:none">
		<colgroup>
			<col width="20%">
			<col width="30%">
			<col width="20%">
			<col width="30%">
		</colgroup>
		<tr>
			<th>SortNum</th>
			<td class="last">
				<input type="text" id="sortNum" name="sortNum" class="text" value="" />
				<input type="hidden" id="taskTypeCode" name="taskTypeCode" >
			</td>
			<th>Mandatory</th>
			<td class="last">
				<input type="checkbox" id="mandatory" name="mandatory" onClick="fnSetCheckBox()"/>
			</td>
		</tr>
	</table>
	</div>
	<div  class="alignBTN" id="divSaveBtn" style="display: none;">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<span class="btn_pack medium icon"><span  class="save"></span><input value="Save" onclick="fnSaveTaskTypeInfo()"  type="submit"></span>
		</c:if>		
	</div>
</form>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;" frameborder="0"></iframe>
