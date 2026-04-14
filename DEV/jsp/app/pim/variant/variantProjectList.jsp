 <%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxToolbar/codebase/skins/dhtmlxtoolbar_dhx_skyblue.css'/>">
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

<script type="text/javascript">
	var p_gridArea;		
	var screenType = "${screenType}"; //그리드 전역변수
	
	$(document).ready(function(){
		$("input.datePicker").each(generateDatePicker); // calendar

		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 220)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 220)+"px;");
		};
		$('#btnSearch').click(function(){
			doSearchClassList();
			return false;
		});
		gridClassInit();
		doSearchClassList();
	});
	function setWindowHeight(){
		var size = window.innerHeight;
		var height = 0;
		if( size == null || size == undefined){
			height = document.body.clientHeight;
		}else{
			height=window.innerHeight;
		}return height;
	}
	
	function gridClassInit(){
		var d = setGridClassData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
	//	p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.setColumnHidden(10, true);
		p_gridArea.setColumnHidden(11, true);

		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnClassRowSelect(id,ind);});
		p_gridArea.attachEvent("onCheck",function(id){
			var ids = p_gridArea.getCheckedRows(1).split(",");
			for (var i=0; i<ids.length; i++)  {
				
				if (ids[i]!=id) {
					p_gridArea.cells(ids[i],1).setValue(0);
				}
				else {
					p_gridArea.cells(id,1).setValue(1);
				}
			}	
			
		});

		p_gridArea.enablePaging(true,20,null,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	function setGridClassData(){
		var result = new Object();
		var loginUserId = "${sessionScope.loginInfo.sessionUserId}";
		var loginUserAuthLev = "${sessionScope.loginInfo.sessionAuthLev}";
		var mainVersion = "${mainVersion}";
		
		result.title = "${title}";
		result.key = "variant_SQL.getVariantProjectList";
		result.header = "${menu.LN00024},#master_checkbox,Code,${menu.LN00028},${menu.LN00027},${menu.LN00004},${menu.LN00018},${menu.LN00063},${menu.LN00221},${menu.LN00064},projectid,statuscode";
		result.cols = "CHK|ProjectCode|ProjectName|StatusName|CreatorName|TeamName|StartDate|DueDate|EndDate|ProjectID|StatusCode";
		result.widths = "30,30,150,*,100,100,150,100,100,100,0,0";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,left,left,center,center,center,center,center,center,center,center";
		result.data = "ProjectCategory=VAR"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&screenType=${screenType}&refPGID=${refPGID}&myProject=${myProject}"		
					+ "&variantProjectType=${variantProjectType}&pageNum=" + $("#currPage").val();

		if ($("#SC_STR_DT1").val() != "" && $("#SC_END_DT1").val() != "" ) { // 생성일
			result.data = result.data+ "&CreationTime=Y";
			result.data = result.data+ "&scStartDt1=" + $("#SC_STR_DT1").val().replace(/-/g, "");;
			result.data = result.data+ "&scEndDt1=" + $("#SC_END_DT1").val().replace(/-/g, "");;
		}
		if ($("#SC_STR_DT2").val() != "" && $("#SC_END_DT2").val() != "" ) { // 수정일
			result.data = result.data+ "&LastUpdated=Y";
			result.data = result.data+ "&scStartDt2=" + $("#SC_STR_DT2").val().replace(/-/g, "");
			result.data = result.data+ "&scEndDt2=" + $("#SC_END_DT2").val().replace(/-/g, "");;
		}
		if ($("#ProjectCode").val() != "" && $("#ProjectCode").val() != undefined) { // 프로젝트 코드
			result.data = result.data+ "&ProjectCode=" + $("#ProjectCode").val();
		}			

		if ($("#ProjectName").val() != "" && $("#ProjectName").val() != undefined) { // 프로젝트 명
			result.data = result.data+ "&ProjectName=" + $("#ProjectName").val();
		}			

		if ($("#detailOwnerTeam").val() != "" && $("#detailOwnerTeam").val() != undefined) { // 관리조직
			result.data = result.data+ "&detailOwnerTeam=" + $("#ProjectName").val();
		}			


		if ($("#Status").val() != "" ) { // 상태
			result.data = result.data+ "&Status=" + $("#Status").val();
		}			
							
		return result;
	}
	
	function gridOnClassRowSelect(id, ind){
		if(ind != '1'){
			//goInfoView(p_gridArea.cells(id,9).getValue(), p_gridArea.cells(id,2).getValue());
			//goInfoView(p_gridArea.cells(id,9).getValue());
		}
	}
	
	function doSearchClassList(){		
		if($("#SC_STR_DT1").val() != "" && $("#SC_END_DT1").val() == "")		$("#SC_END_DT1").val(new Date().toISOString().substring(0,10));
		if($("#SC_STR_DT2").val() != "" && $("#SC_END_DT2").val() == "")		$("#SC_END_DT2").val(new Date().toISOString().substring(0,10));
		
		var d = setGridClassData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data, false);
	}

	function searchPopup(url){window.open(url,'window','width=300, height=300, left=300, top=300,scrollbar=yes,resizble=0');}
	function setSearchName(memberID,memberName){$('#AuthorID').val(memberID);$('#AuthorName').val(memberName);}
	function setSearchTeam(teamID,teamName){$('#ownerTeamCode').val(teamID);$('#teamName').val(teamName);}

	// [Clear] click
	function clearSearchCon() {

		$("#ProjectCode").val('');
		$("#ProjectName").val('');
		$("#SC_STR_DT1").val('');
		$("#SC_END_DT1").val('');
		$("#SC_STR_DT2").val('');
		$("#SC_END_DT2").val('');
		$("#detailOwnerTeam").val('');
		$("#Status").val('');

	}

	// [Add][Batch] 버튼 이벤트
	function addNewPjt(avg) {
		
		var varPjtType = "${variantProjectType}";
		
		if(varPjtType == 'CSR') {
			addVariantCSR(varPjtType);
		}
		else {
			addVariantPjt();
		}
		
	}
	function addVariantPjt() {

		var ids = p_gridArea.getCheckedRows(1);
		
		if(ids != "" && ids != undefined ) {

			var status = p_gridArea.cells(ids,11).getValue();
			
			if(status != 'RDY') {
				alert("선택 할 수 없는 항목입니다.");
				return;
			}
			
			var projectID = p_gridArea.cells(ids,10).getValue();
			var projectCode = p_gridArea.cells(ids,2).getValue();
			var url = "registerVariantProject.do"; // 변경 오더 등록 화면
			var data = "myProject=${myProject}&projectID="+projectID+"&parentItemID=${parentItemID}&variantClass=${variantClass}&refPGID=${refPGID}&projectCode="+projectCode;
			var target = "projectDiv";
			ajaxPage(url, data, target); 
		}
		else {
			alert("Select a project!");
		}
		
	}
	
	function addVariantCSR(avg1) {		
			
		var url = "registerVariantProject.do"; // 변경 오더 등록 화면
		var data = "myProject=${myProject}&projectID=${projectID}&parentItemID=${parentItemID}&variantClass=${variantClass}&refPGID=${refPGID}&variantPjtType="+avg1;
		var target = "projectDiv";
		ajaxPage(url, data, target); 
		
	}
	
</script>
</head>

<body>
<div id="projectDiv" style="margin:5px 10px 0 10px !important;">
	<form name="projectListFrm" id="projectListFrm" method="post" onsubmit="return false;">
		<input type="hidden" id="UserID" name="UserID" value="${sessionScope.loginInfo.sessionUserId}"/>
		<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}">
		<input type="hidden" id="saveType" name="saveType" value="New">		
		<input type="hidden" id="AuthorID" name="AuthorID">
		<input type="hidden" id="ownerTeamCode" name="ownerTeamCode">
		<input type="hidden" id="currPage" name="currPage" value="${currPage}" />
				
	<div class="floatL msg" style="width:100%">
	<img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;${menu.LN00052}
	</div>		
	<table style="table-layout:fixed;" border="0" cellpadding="0" cellspacing="0" class="tbl_search"  id="search">
		<colgroup>
		    <col width="7%">
		    <col width="10%">
		    <col width="7%">
		    <col width="10%">
		    <col width="7%">
		    <col width="10%">
	    </colgroup>
	    <!-- 계층, ID, 상태 -->
	    <tr>
	    	<th class="alignL pdL10 viewtop">Project code</th>
 			<td class="viewtop">
 				<input type="text" id="ProjectCode" name="ProjectCode" value="" class="text" style="width:150px;ime-mode:active;">
 			</td>
  			<th class="alignL pdL10 viewtop">Project name</th>
  			<td class="viewtop">
  				<input type="text" id="ProjectName" name="ProjectName" value="" class="text" style="width:150px;ime-mode:active;">
  			</td>
  			<!-- [상태] -->
            <th  class="alignL pdL10 viewtop">${menu.LN00027}</th>
            <td class="alignL last viewtop"">
            	<select id="Status" name="Status" style="width:150px;">
            	<option value="">Select</option>
            	<c:forEach var="i" items="${statusList}">
						<option value="${i.CODE}" >${i.NAME}</option>
            	</c:forEach>
            	</select>
            </td>		
	    </tr>
	    
	    <!-- 시작일, 수정일 -->
	    <tr>
	    	<th class="alignL pdL10">${menu.LN00063}</th>	
	    	<td>
   				<input type="text" id="SC_STR_DT1" name="SC_STR_DT1" value=""	class="input_off datePicker stext" size="8"
					style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
					~
				<input type="text" id=SC_END_DT1	name="SC_END_DT1" value="" class="input_off datePicker stext" size="8"
					style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
   			</td>
   			<th class="alignL pdL10">${menu.LN00221}</th>	
   			<td>
   				<input type="text" id="SC_STR_DT2" name="SC_STR_DT2" value=""	class="input_off datePicker stext" size="8"
					style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
					~
				<input type="text" id=SC_END_DT2	name="SC_END_DT2" value="" class="input_off datePicker stext" size="8"
					style="width: 70px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
   			</td>		
			<th class="alignL pdL10">${menu.LN00018}</th>
			<td class="last">
            	<select id="detailOwnerTeam" name="detailOwnerTeam" style="width:150px;">
            	<option value="">Select</option>
            	<c:forEach var="i" items="${teamList}">
						<option value="${i.CODE}" >${i.NAME}</option>
            	</c:forEach>
            	</select>
            </td>	
	    </tr>
	    
	    
	    
	</table>
	
   <div class="countList pdT10">
        <li class="floatR"> 
        	<input id="btnSearch" type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" style="cursor:pointer;">
        	&nbsp;<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="cursor:pointer;" onclick="clearSearchCon();">
        	<c:if test="${authorCnt > 0 }">
				&nbsp;<span id="btnAdd" class="btn_pack small icon"><span class="add"></span><input value="Create process" type="submit" onclick="addNewPjt()"></span>	
        	</c:if>	
			&nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			&nbsp;&nbsp;&nbsp;&nbsp;
        </li>
   </div>		
	</form>
	
	<div id="gridDiv" style="width:100%;height:600px;" class="clear">
		<div id="grdGridArea"></div>	
		<!-- START :: PAGING -->
		<div style="width:100%;" class="paginate_regular">
			<div id="pagingArea" style="display:inline-block;"></div>
			<div id="recinfoArea" class="floatL pdL10"></div>
		</div>
	</div>
	<!-- END :: PAGING -->
		
	<!-- START :: FRAME --> 		
	<div class="schContainer" id="schContainer" ><iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe></div>	
	<!-- END :: FRAME -->	
	</div>
</body>
</html>