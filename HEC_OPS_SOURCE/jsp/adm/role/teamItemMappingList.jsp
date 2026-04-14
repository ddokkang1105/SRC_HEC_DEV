<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
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

<!-- 2. Script -->
<script type="text/javascript">
	
	var gridArea; //그리드 전역변수
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용

	$(document).ready(function() {
		// 초기 표시 화면 크기 조정
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		};
		
		$("#excel").click(function(){gridArea.toExcel("${root}excelGenerate");});
		$("input.datePicker").each(generateDatePicker);
		$('.searchList').click(function(){
			doSearchList();
			return false;
		});
		
		var data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}&teamType=2&assignmentType=TEAMROLETP";
		fnSelect('companyID', data, 'getTeam', '', 'Select');	
		fnSelect('teamRoleType', data, 'getOLMRoleType', '', 'Select');
		
		gridInit();
		doSearchList();
		
	});
	
	function fnGetTeamList(companyID){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&teamType=4&companyID="+companyID;
		fnSelect('teamID', data, 'getTeam', '', 'Select');
	}
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	function gridInit() {
		var d = setOTGridData();
		gridArea = fnNewInitGrid("grdGridArea", d);
		gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		gridArea.attachEvent("onRowSelect", function(id, ind) { //id : ROWNUM, ind:Index
			gridOnRowOTSelect(id, ind);
		});
		
		//START - PAGING
		gridArea.enablePaging(true,20,20,"pagingArea",true,"recInfoArea");
		gridArea.setPagingSkin("bricks");
		gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
		//END - PAGING
	}

	function setOTGridData() {
		var result = new Object();
		result.title = "${title}";
		result.key = "role_SQL.getTeamRoleItemMappingList";
		result.header = "${menu.LN00024},${menu.LN00164},${menu.LN00247},${menu.LN00162},${menu.LN00119},${menu.LN00106},${menu.LN00028},${menu.LN00016},${menu.LN00070},${menu.LN00027}";
		result.cols = "TeamCode|TeamNM|TeamPath|TeamRoleNM|ID|ItemName|ClassName|LastUpdated|StatusNM";
		result.widths = "50,120,120,370,200,80,200,180,80,100";
		result.sorting = "str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,left,center,center,center,center,center,center";
		result.data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
						+ "&companyID="+$("#companyID").val()
						+ "&teamID="+$("#teamID").val()
						+ "&assigned="+$("#assigned").val()
						+ "&teamRoleType="+$("#teamRoleType").val()
						+ "&pageNum="+ $("#currPage").val();	
		return result;
	}
	
	function gridOnRowOTSelect(id, ind) {
	
	}

	function doSearchList(){
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(gridArea, d.key, d.cols, d.data);
	}

</script>

</head>
<body>
<div style="width:100%">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"/> 
	<div class="msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;${reportName}</div>
	<div style="overflow:auto;margin-bottom:5px;overflow-x:hidden;">	
	<div class="child_search">
		<li>
			<span style="font-weight:bold;">${menu.LN00014}&nbsp;</span>
			<select class="sel" id="companyID" name="companyID" style="width:120px;" OnChange="fnGetTeamList(this.value);">
				<option value="">Select</option>
			</select>
		</li>
		
		<li>
			<span style="font-weight:bold;">Team&nbsp;</span>
			<select class="sel" id="teamID" name="teamID" style="width:120px;">
				<option value="">Select</option>
			</select>
		</li>
		<li>
			<span style="font-weight:bold;">Status&nbsp;</span>
			<select id="assigned" name="assigned" class="sel" style="width:120px;">
				<option value="1">Active</option>
				<option value="0">Removed</option>
				<option value="">All</option>
			</select>
		</li>
		<li>
			<span style="font-weight:bold;">${menu.LN00119}&nbsp;</span>
			<select id="teamRoleType" name="teamRoleType" class="sel" style="width:120px;">
				<option value="">Select</option>
			</select>
		</li>
		<li>
			<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" />
			&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</li>
	</div>
    <div class="countList mgT8 mgB5">
         <li class="count">Total  <span id="TOT_CNT"></span></li>
     </div>      
	
	<div id="gridDiv" class="mgB10 clear" style="width: 100%">
		<div id="grdGridArea" style="width: 100%"></div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->
	</div>	
</div>
</html>
