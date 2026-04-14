<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="Role Category"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="RoleTypeCode"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="RoleType"/>

<!-- 2. Script -->
<script type="text/javascript">

var OT_gridArea;				//그리드 전역변수
var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용
var viewType;

$(document).ready(function() {	
	
	// 초기 표시 화면 크기 조정
	$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 340)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 340)+"px;");
	};
	fnSelect('languageID', '', 'langType', '${languageID}', 'Select');
	$('#ActorTypeCode').change(function(){fnCategory($(this).val());});
	
	$("#excel").click(function(){OT_gridArea.toExcel("${root}excelGenerate");});
	
	//Grid 초기화
	gridOTInit();
	doOTSearchList();
	
});	

function fnCategory(actorType){
	var data = "&sessionCurrLangType=${sessionScope.loginInfo.sessionCurrLangType}&Category=ROLECAT&ActorType=" + actorType;
	fnSelect('CategoryCode', data, 'getOLMRoleCat', '${resultMap.AssignmentType}', 'Select');
}

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}


function setOTLayout(type){
	if( schCntnLayout != null){
		schCntnLayout.unload();
	}
	schCntnLayout = new dhtmlXLayoutObject("schContainer",type, skin);
	schCntnLayout.setAutoSize("b","a;b"); //가로, 세로		
	schCntnLayout.items[0].setHeight(350);
}

//===============================================================================
// BEGIN ::: GRID
//그리드 초기화
function gridOTInit(){		
	var d = setOTGridData();
	OT_gridArea = fnNewInitGrid("grdOTGridArea", d);
	fnSetColType(OT_gridArea, 1, "ch");
	
	
	OT_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
		gridOnRowOTSelect(id,ind);
	});
	//START - PAGING
	OT_gridArea.enablePaging(true,10,10,"pagingArea",true,"recInfoArea");
	OT_gridArea.setPagingSkin("bricks");
	OT_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	//END - PAGING
}

function setOTGridData(){

	var result = new Object();
	result.title = "${title}";
	result.key = "config_SQL.getRoleTypeList";
	result.header = "${menu.LN00024},#master_checkbox,ActorType,Category,Name,Code,Process Type,${menu.LN00013},${menu.LN00070},${menu.LN00105},AssignmentType,Language,Deactivated";
	result.cols = "CHK|ActorType|RoleCategory|RoleType|RoleTypeCode|ProcessType|CreationTime|LastUpdated|LastUserName|AssignmentType|LanguageCode|Deactivated";
	result.widths = "50,50,80,150,100,100,100,80,120,100,0,100,100";
	result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str";
	result.aligns = "center,center,center,center,center,center,center,center,center,center,center,center,center";
	result.data = "languageID=${languageID}"
					+ "&pageNum="      + $("#currPage").val();
	/* 검색 조건 선택 */
	// [Category]
	if($("#CategoryCode").val() != '' && $("#CategoryCode").val() != null){
		result.data = result.data +"&Category="+$("#CategoryCode").val();
	}  else {
		if ("${CategoryCode}" != "") {
			result.data = result.data +"&Category=${CategoryCode}";
		}
	}
	// [ActorType]
	if($("#ActorTypeCode").val() != '' && $("#ActorTypeCode").val() != null){
		result.data = result.data +"&ActorType="+$("#ActorTypeCode").val();
	}
	
	//alert(result.data);
	return result;

}

// END ::: GRID	
//===============================================================================

	
//조회
function doOTSearchList(){
	var d = setOTGridData();
	fnLoadDhtmlxGridJson(OT_gridArea, d.key, d.cols, d.data);
}


function urlReload() {
	doOTSearchList();	
}

function addRoleType(){
	viewType = "N";
	$("#NewRoleType").attr('style', 'display: table');	
	$("#divSaveRoleType").attr('style', 'display: block');
	$(".addTd").attr('style', 'display: table-cell');
	$(".modTd").attr('style', 'display: none');
	
	$("#actorType").val("");
	$("#roleType").val("");
	$("#processType").val("");
	$("#deactivated").attr('checked',false);
	$("#roleTypeCodeNew").val("");
	$('#actorType').change(function(){
		var data = "&sessionCurrLangType=${sessionScope.loginInfo.sessionCurrLangType}&Category=ROLECAT&ActorType=" + $('#actorType').val();
		fnSelect('roleTypeCategoryNew', data, 'getOLMRoleCat', '', 'Select');
	});
	
	gridOTInit();
	doOTSearchList();
	
}

//그리드ROW선택시
function gridOnRowOTSelect(id, ind){
	viewType = "E";
	$("#NewRoleType").attr('style', 'display: table');	
	$("#divSaveRoleType").attr('style', 'display: block');
	$(".addTd").attr('style', 'display: none');
	$(".modTd").attr('style', 'display: table-cell');
	
	$("#actorTypeTd").text(OT_gridArea.cells(id,2).getValue());
	$("#roleCategoryTd").text(OT_gridArea.cells(id,3).getValue());
	$("#roleType").val(OT_gridArea.cells(id, 4).getValue());
	$("#roleTypeCode").val(OT_gridArea.cells(id, 5).getValue());
	$("#roleTypeCategory").val(OT_gridArea.cells(id, 10).getValue());
	$("#processType").val(OT_gridArea.cells(id, 6).getValue());
	if(OT_gridArea.cells(id, 12).getValue()=='1'){
		$("#deactivated").attr('checked',true);
	}else{
		$("#deactivated").attr('checked',false);
	}
	
}

function saveRoleType(){
	var roleType = $("#roleType").val();
	var roleTypeCategory = $("#roleTypeCategory").val();
	var roleTypeCode = $("#roleTypeCode").val();
	var roleTypeCategoryNew = $("#roleTypeCategoryNew").val();
	var roleTypeCodeNew = $("#roleTypeCodeNew").val();
	var processType = $("#processType").val();
	var actorType = $("#actorType").val();
	if($("#deactivated").is(":checked") == true){
		$("#deactivated").val("1");
	}else{
		$("#deactivated").val("0");
	}
	var deactivated = $("#deactivated").val();
	
	// [OBJECT 필수 체크]		
	if(roleType == ""){
		alert("${WM00034_3}");
		return false;
	}
	if(viewType == "N" ){
		if(roleTypeCategoryNew == ""){
			alert("${WM00034_1}");
			return false;
		}
		if(roleTypeCodeNew == ""){
			alert("${WM00034_2}");
			return false;
		}
	}
		
	var url = "saveRoleType.do";
	var data = "viewType="+viewType+"&roleType="+roleType+"&roleTypeCategory="+roleTypeCategory+"&roleTypeCode="+roleTypeCode
			   +"&roleTypeCategoryNew="+roleTypeCategoryNew+"&roleTypeCodeNew="+roleTypeCodeNew + "&actorType=" + actorType
			   +"&processType="+processType+"&deactivated="+deactivated+"&languageID=${languageID}&lastUser=${sessionScope.loginInfo.sessionUserId}"; 
	var target = "ArcFrame";
	ajaxPage(url, data, target);
}

function fnCallBack(){ 
	$("#NewRoleType").attr('style', 'display: none');
	$("#divSaveRoleType").attr('style', 'display: none');
	$("#roleType").val("");
	$("#processType").val("");
	$("#deactivated").attr('checked',false);
	
	gridOTInit();
	doOTSearchList();
	
}

function delRoleType(){
	if (OT_gridArea.getCheckedRows(1).length == 0) {
		alert("${WM00023}");
		return;
	}
	var cnt  = OT_gridArea.getRowsNum();
	var roleTypeCode = new Array;
	var roleCategory = new Array;
	var j = 0;
	for ( var i = 0; i < cnt; i++) { 
		chkVal = OT_gridArea.cells2(i,1).getValue();
		if(chkVal == 1){
			roleTypeCode[j]= OT_gridArea.cells2(i, 5).getValue();
			roleCategory[j]= OT_gridArea.cells2(i, 10).getValue();
			j++;
		}
	}
	if(confirm("${CM00004}")){
		var url = "deleteRoleType.do";
		var data = "&roleTypeCode="+roleTypeCode+"&roleCategory="+roleCategory+"&languageID=${languageID}";
		var target = "ArcFrame";
		ajaxPage(url, data, target);	
	}
}

function thisReload(){
	fnCallBack();
	var url    = "olmRoleConfigMgt.do"; // 요청이 날라가는 주소
	var data   = "&languageID="+$("#languageID").val()
				+ "&pageNum=${pageNum}"
				+ "&ActorTypeCode="+$("#ActorTypeCode").val()
				+ "&CategoryCode="+$("#CategoryCode").val();
	var target = "classTypeDiv";
	ajaxPage(url,data,target);	
}
	
</script>

<body>
<div id="classTypeDiv">
<form name="classTypeList" id="classTypeList" action="#" method="post" onsubmit="return false;">
	<div id="processListDiv">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}" />
	<input type="hidden" id="roleTypeCategory" name="roleTypeCategory" />
	<input type="hidden" id="roleTypeCode" name="roleTypeCode" />
	</div>
	<div class="cfgtitle" >					
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Role Type</li>
			<li class="floatR pdR10" style="padding-top:20px;">
              <select id="languageID" name="languageID" onchange="thisReload();"></select></span>
            </li>
		</ul>
	</div>
	<div class="child_search01 mgL10 mgR10" >
		<li class="pdL10">Actor Type
			<select id="ActorTypeCode" name="ActorTypeCode" style="width:100px;margin-left:5px;">
				<option value="">Select</option>
				<option value="USER">USER</option>
				<option value="TEAM">TEAM</option>			
			</select>
		</li>
		<li class="pdL10">Category
			<select id="CategoryCode" name="CategoryCode" style="width:130px;margin-left:5px;">
				<option value="">Select</option>
				<%-- <c:forEach var="i" items="${CategoryOption}">
					<option value="${i.Category}" <c:if test="${i.Category eq CategoryCode}"> selected="selected"</c:if>>${i.Category}</option>						
				</c:forEach>	 --%>			
			</select>
		</li>			
		<li class="pdL5">
			<input id="btnSearch" type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doOTSearchList();" value="검색">
		</li>	
		<li class="floatR pdR10">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<!-- 엑셀 다운 아이콘  -->
				&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
				<!-- ADD 버튼  -->
				<c:if test="${languageID == sessionScope.loginInfo.sessionDefLanguageId}">
				&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" alt="신규" onclick="addRoleType()"></span>
				</c:if>
				<!-- DEL 버튼 -->
				&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delRoleType()"></span>
			</c:if>
		</li>
	</div>
    <div class="countList pdL10">
         <li class="count">Total  <span id="TOT_CNT"></span></li>
         <li class="floatR">&nbsp;</li>
     </div>
</form>
	<div id="gridOTDiv" class="mgB10 clear mgL10 mgR10">
		<div id="grdOTGridArea" style="height:400px; width:100%"></div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->	
</div>	
	
<div class="mgT10 mgL10 mgR10">
	<table id="NewRoleType" class="tbl_blue01" width="100%" cellpadding="0" cellspacing="0" style="display:none">

		<colgroup>
		</colgroup>
		
		<tr>
			<th width="20%" class="viewtop last">Actor Type</th>
			<th width="20%" class="viewtop last">Category</th>
			<th width="10%" class="viewtop last addTd">Code</th>
			<th width="20%" class="viewtop last">Name </th>
			<th width="20%" class="viewtop last">Process Type</th>
			<th width="10%" class="viewtop last modTd">Deactivated</th>
		</tr>
		<tr>
			<td width="" class="last addTd addTd">
				<select id="actorType" name="actorType" class="sel">
					<option value="">Select</option>
					<option value="USER">USER</option>
					<option value="TEAM">TEAM</option>
				</select>
			</td>
			<td width="" class="last modTd" id="actorTypeTd"></td>
			<td width="" class="last addTd"><select id="roleTypeCategoryNew" name="roleTypeCategoryNew" class="sel" ></select></td>
			<td width="" class="last modTd" id="roleCategoryTd"></td>
			<td width="" class="last addTd"><input type="text" id="roleTypeCodeNew" name="roleTypeCodeNew" class="text" style="text-align:center;" /></td>
			<td width="" class="last"><input type="text" id="roleType" name="roleType" class="text" /></td>
			<td width="" class="last"><input type="text" id="processType" name="processType" class="text" /></td>
			<td width="" class="last modTd"><input type="checkbox" id="deactivated" name="deactivated" value="" /></td>
		</tr>
	</table>
</div>
<div class="alignBTN" id="divSaveRoleType" style="display: none;">
	<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
		<span class="btn_pack medium icon mgR20"><span  class="save"></span><input value="Save" onclick="saveRoleType()"  type="submit"></span>
	</c:if>		
</div>	

<!-- START :: FRAME -->
<div class="schContainer" id="schContainer">
	<iframe name="ArcFrame" id="ArcFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
</div>

</body>
</html>