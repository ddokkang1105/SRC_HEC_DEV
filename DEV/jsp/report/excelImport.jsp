<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 1. Include CSS/JS -->

<style type="text/css">
	#framecontent{border:1px solid #e4e4e4;overflow: hidden; background: #f9f9f9;padding:10px;width:95%;margin:0 auto;}
</style>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_1" arguments="${menu.LN00144}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_2" arguments="${menu.LN00145}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_3" arguments="${menu.LN00146}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_4" arguments="${menu.LN00147}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_5" arguments="CSR"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00071" var="WM00071"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00020" var="CM00020"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00021" var="CM00021"/>


<script type="text/javascript">
	var p_excelGrid;				//그리드 전역변수

	var imgKind = "asp jsp php war cer cdx asa html htm js aspx exe dll txt";    
	
	$(document).ready(function(){
		$("#send").click(function() {
			doFileUpload();
		});
		
		$("#save").click(function() {
			doSave();
		});
		
		 $('#FD_FILE_PATH').change(function(){
	        var upfile = $(this).val();
	        
	    	var strKind=upfile.substring(upfile.lastIndexOf(".")+1).toLowerCase();
	    	var isCheck = false;
	    	var imgKinds = imgKind.split(' ');
	    	for(var i=0; i<imgKinds.length; i++){if(strKind == imgKinds[i]){ isCheck = true;}}
	    	
	    	if(isCheck){
	    		$('#txtFilePath').val(""); $('#FD_FILE_PATH').val("");
	    	}else{
	    		$('#txtFilePath').val( upfile );
	    	}
		 });
		 
		 $('#reportLanguage').change(function(){
			 changeLanguage($(this).val());
		 });
		 
		 fnSelect('reportLanguage', '', 'langType', '${sessionScope.loginInfo.sessionCurrLangType}', 'Select Language');
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridInit(aCnt, type, headerName){
		var d;
		if (type == 1 || type == 2) {
			d = setGridDataForAddNew(aCnt);
		} else if (type == 3) {
			d = setGridDataForConnection();
		} else if (type == 4) {
			d = setGridDataForDimension(aCnt, headerName);
		} else if (type == 5) {
			d = setGridDataForCboList();
		} else if (type == 6) {
			d = setGridDataForIfMater();
		} else if (type == 7) {
			d = setGridDataForCboProgramStatus();
		} else if (type == 8) {
			d = setGridDataForIFProgramStatus();
		} else if (type == 9) {
			d = setGridDataWholeCompanySystemItem();
		} else if (type == 10) {
			d = setGridDataForTeamMapping();
		} else if (type == 11) {
			d = setGridDataForMemberMapping();
		}
		
// 		p_excelGrid = fnNewInitGrid("excelGridArea", d);
// 		p_excelGrid.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		
		//p_excelGrid.setColumnHidden(0, true);				//RNUM
	}
	
	// [새로운 구조 업로드][속성 업데이트] GridData 설정
	function setGridDataForAddNew(aCnt){
		var result = new Object();
		
		var config = [
	        { width: 50, id: "RNUM", header: [{ text: "번호"}] },
	        { width: 80, id: "newParentIdentifier", header: [{ text: "Parent"}] },
	        { width: 80, id: "newItemId", header: [{ text: "ItemId"}] },
	        { width: 80, id: "newIdentifier", header: [{ text: "Identifier"}] },
	        { width: 80, id: "newClassCode", header: [{ text: "ClassCode"}] }
	    ];
		
		for (var i = 1; i < aCnt; i++) {
			config.push({width: 80, id: "newPlainText"+i, header: [{ text: "PlainText"+i}]})
		}
		
	 	if(p_excelGrid) p_excelGrid.destructor();
		p_excelGrid = new dhx.Grid("excelGridArea", {
		    columns: config
		});
	}
	
	// [Team 매핑] GridData 설정
	function setGridDataForTeamMapping(){		
		var config = [
	        { width: 50, id: "RNUM", header: [{ text: "번호"}] },
	        { width: 80, id: "Identifier", header: [{ text: "Identifier"}] },
	        { width: 80, id: "ClassCode", header: [{ text: "ClassCode"}] },
	        { width: 200, id: "ItemName", header: [{ text: "Item Name"}] },
	        { width: 80, id: "TeamCode", header: [{ text: "Team Code"}] },
	        { width: 80, id: "TeamName", header: [{ text: "Team Name"}] },
	        { width: 200, id: "TeamRoleCategory", header: [{ text: "TeamRoleCategory"}] },
	        { width: 120, id: "RoleTypeCode", header: [{ text: "RoleTypeCode"}] }
	    ];
		
		if(p_excelGrid) p_excelGrid.destructor();
		p_excelGrid = new dhx.Grid("excelGridArea", {
		    columns: config
		});
	}
	
	// [Member 매핑] GridData 설정
	function setGridDataForMemberMapping(){
		var config = [
	        { width: 50, id: "RNUM", header: [{ text: "번호"}] },
	        { width: 80, id: "Identifier", header: [{ text: "Identifier"}] },
	        { width: 80, id: "ClassCode", header: [{ text: "ClassCode"}] },
	        { width: 200, id: "ItemName", header: [{ text: "Item Name"}] },
	        { width: 80, id: "EmployeeNum", header: [{ text: "EmployeeNum"}] },
	        { width: 80, id: "MemberName", header: [{ text: "MemberName"}] },
	        { width: 200, id: "AssignmentType", header: [{ text: "AssignmentType"}] },
	        { width: 120, id: "RoleType", header: [{ text: "RoleType"}] },
	        { width: 120, id: "Order", header: [{ text: "Order"}] },
	        { width: 120, id: "ClientID", header: [{ text: "ClientID"}] }
	    ];
		
		if(p_excelGrid) p_excelGrid.destructor();
		p_excelGrid = new dhx.Grid("excelGridArea", {
		    columns: config
		});
	}
	
	
	// [CBO List] GridData 설정
	function setGridDataForCboList(){
		var config = [
	        { width: 50, id: "RNUM", header: [{ text: "번호"}] },
	        { width: 80, id: "newParentIdentifier", header: [{ text: "ParentId"}] },
	        { width: 80, id: "newProcessID", header: [{ text: "Process ID"}] },
	        { width: 80, id: "newItemName", header: [{ text: "Process 명"}] },
	        { width: 80, id: "newName", header: [{ text: "개발항목"}] },
	        { width: 80, id: "newCBOType", header: [{ text: "CBO Type"}] },
	        { width: 80, id: "newCBOId", header: [{ text: "CBO ID"}] },
	        { width: 80, id: "newCatagory", header: [{ text: "개발 유형"}] },
	        { width: 80, id: "newDSAP", header: [{ text: "개발대상SAP"}] },
	        { width: 80, id: "newPeriod", header: [{ text: "사용 기간"}] },
	        { width: 80, id: "newDifficulty", header: [{ text: "난이도"}] },
	        { width: 80, id: "newImportance", header: [{ text: "중요도"}] },
	        { width: 80, id: "newPriority", header: [{ text: "우선순위"}] },
	        { width: 80, id: "newProductionCosts", header: [{ text: "개발공수"}] },
	        { width: 80, id: "newSystem", header: [{ text: "관련시스템"}] },
	        { width: 80, id: "newModule", header: [{ text: "연관모듈"}] },
	        { width: 80, id: "newProgramID", header: [{ text: "Program ID"}] },
	        { width: 80, id: "newTCode", header: [{ text: "T-Code"}] },
	        { width: 80, id: "newNote", header: [{ text: "비고"}] },
	    ];
		
		if(p_excelGrid) p_excelGrid.destructor();
		p_excelGrid = new dhx.Grid("excelGridArea", {
		    columns: config
		});
	}
	
	// [IF Master] GridData 설정
	function setGridDataForIfMater(){
		var config = [
	        { width: 50, id: "RNUM", header: [{ text: "번호"}] },
	        { width: 80, id: "newParentIdentifier", header: [{ text: "ParentId"}] },
	        { width: 80, id: "newInterfaceID", header: [{ text: "Interface ID"}] },
	        { width: 80, id: "newGroupName", header: [{ text: "그룹명"}] },
	        { width: 80, id: "newKanri", header: [{ text: "관리주체"}] },
	        { width: 80, id: "newTani", header: [{ text: "단위시스템"}] },
	        { width: 80, id: "newSub", header: [{ text: "서브시스템"}] },
	        { width: 80, id: "newIfName", header: [{ text: "IF 항목명"}] },
	        { width: 80, id: "newCboId", header: [{ text: "CBO ID"}] },
	        { width: 80, id: "newProgramID", header: [{ text: "Program ID"}] },
	        { width: 80, id: "newProcessId", header: [{ text: "Process ID"}] },
	        { width: 80, id: "newItemName", header: [{ text: "Process Name"}] },
	        { width: 80, id: "newVariant", header: [{ text: "Variant"}] },
	        { width: 80, id: "newGapId", header: [{ text: "Gap ID"}] },
	        { width: 80, id: "newDSAP", header: [{ text: "개발대상 SAP"}] },
	        { width: 80, id: "newPeriod", header: [{ text: "사용 기간"}] },
	        { width: 80, id: "newInOut", header: [{ text: "In/Out"}] },
	        { width: 80, id: "newOnLineOrBatch", header: [{ text: "OnLine or Batch"}] },
	        { width: 80, id: "newIfPeriod", header: [{ text: "I/F 주기"}] },
	        { width: 80, id: "newErp", header: [{ text: "ERP"}] },
	        { width: 80, id: "newRfcDestination", header: [{ text: "RFC Destination"}] },
	        { width: 80, id: "newMw", header: [{ text: "M/W"}] },
	        { width: 80, id: "newLegacy", header: [{ text: "Legacy"}] },
	        { width: 80, id: "newErpType", header: [{ text: "ERP TYPE"}] },
	        { width: 80, id: "newMwType", header: [{ text: "M/W Type"}] },
	        { width: 80, id: "newLegacyType", header: [{ text: "Legacy Type"}] },
	        { width: 80, id: "newErpTanto", header: [{ text: "ERP담당"}] },
	        { width: 80, id: "newMwTanto", header: [{ text: "M/W담당"}] },
	        { width: 80, id: "newLegacyTanto", header: [{ text: "Legacy 담당"}] },
	        { width: 80, id: "newErpStatus", header: [{ text: "ERP Status"}] },
	        { width: 80, id: "newMwStatus", header: [{ text: "M/W Status"}] },
	        { width: 80, id: "newLegacyStatus", header: [{ text: "Legacy Status"}] },
	        { width: 80, id: "newTotalStatus", header: [{ text: "Total Status"}] },
	        { width: 80, id: "newTestPeriod", header: [{ text: "통합테스트 시기"}] },
	        { width: 80, id: "newIssue", header: [{ text: "고려사항"}] },
	        { width: 80, id: "newNote", header: [{ text: "비고"}] },
	    ];
		
		if(p_excelGrid) p_excelGrid.destructor();
		p_excelGrid = new dhx.Grid("excelGridArea", {
		    columns: config
		});
	}
	
	// [관련항목 매핑] GridData 설정
	function setGridDataForConnection(){
		var config = [
	        { width: 50, id: "RNUM", header: [{ text: "번호"}] },
	        { width: 80, id: "newFromItemId", header: [{ text: "From ItemID"}] },
	        { width: 80, id: "newFromClassCode", header: [{ text: "ClassCode"}] },
	        { width: 80, id: "newFromName", header: [{ text: "Name"}] },
	        { width: 80, id: "newToItemId", header: [{ text: "To ItemID"}] },
	        { width: 80, id: "newToClassCode", header: [{ text: "ClassCode"}] },
	        { width: 80, id: "newToName", header: [{ text: "Name"}] },
	        { width: 80, id: "newConnectionClassCode", header: [{ text: "Connection Class"}] },
	    ];
		
		if(p_excelGrid) p_excelGrid.destructor();
		p_excelGrid = new dhx.Grid("excelGridArea", {
		    columns: config
		});
	}
	
	// [Dimension Mapping] GridData 설정
	function setGridDataForDimension(aCnt, headerName){
		var config = [
	        { width: 50, id: "RNUM", header: [{ text: "번호"}] },
	        { width: 80, id: "newItemTypeId", header: [{ text: "Item Type ID"}] },
	        { width: 80, id: "newDimTypeIdItemName", header: [{ text: "Dimensin Type ID/ Item Name"}] },
	    ];
		
		for (var i = 1; i < aCnt; i++) {
			config.push({width: 80, id: "newDimValue"+i, header: [{ text: headerName.split(",")[i]}]})
		}
		
	 	if(p_excelGrid) p_excelGrid.destructor();
		p_excelGrid = new dhx.Grid("excelGridArea", {
		    columns: config
		});
	}
	
	// [CBO Program Status] GridData 설정
	function setGridDataForCboProgramStatus(){
		var config = [
	        { width: 50, id: "RNUM", header: [{ text: "번호"}] },
	        { width: 80, id: "newItemId", header: [{ text: "ItemId"}] },
	        { width: 80, id: "newFDTanto", header: [{ text: "FD담당자"}] },
	        { width: 80, id: "newFDPlannedStart", header: [{ text: "FD시작일(Planned)"}] },
	        { width: 80, id: "newFDPlannedEnd", header: [{ text: "FD완료일(Planned)"}] },
	        { width: 80, id: "newFDStatus", header: [{ text: "FD상태"}] },
	        { width: 80, id: "newFDActualStart", header: [{ text: "FD시작일(Actual)"}] },
	        { width: 80, id: "newFDActualEnd", header: [{ text: "FD완료일(Actual)"}] },
	        { width: 80, id: "newPGTanto", header: [{ text: "PG담당자"}] },
	        { width: 80, id: "newPGPlannedStart", header: [{ text: "PG시작일(Planned)"}] },
	        { width: 80, id: "newPGPlannedEnd", header: [{ text: "PG완료일(Planned)"}] },
	        { width: 80, id: "newPGStatus", header: [{ text: "PG상태"}] },
	        { width: 80, id: "newPGActualStart", header: [{ text: "PG시작일(Actual)"}] },
	        { width: 80, id: "newPGActualEnd", header: [{ text: "PG완료일(Actual)"}] },
	        { width: 80, id: "newUTTanto", header: [{ text: "UT담당자"}] },
	        { width: 80, id: "newUTPlannedStart", header: [{ text: "UT시작일(Planned)"}] },
	        { width: 80, id: "newUTPlannedEnd", header: [{ text: "UT완료일(Planned)"}] },
	        { width: 80, id: "newUTStatus", header: [{ text: "UT상태"}] },
	        { width: 80, id: "newUTActualStart", header: [{ text: "UT시작일(Actual)"}] },
	        { width: 80, id: "newUTActualEnd", header: [{ text: "UT시작일(Actual)"}] },
	        { width: 80, id: "newTDTanto", header: [{ text: "TD담당자"}] },
	        { width: 80, id: "newTDPlannedStart", header: [{ text: "TD시작일(Planned)"}] },
	        { width: 80, id: "newTDPlannedEnd", header: [{ text: "TD완료일(Planned)"}] },
	        { width: 80, id: "newTDStatus", header: [{ text: "TD상태"}] },
	        { width: 80, id: "newTDActualStart", header: [{ text: "TD시작일(Actual)"}] },
	        { width: 80, id: "newTDActualEnd", header: [{ text: "TD완료일(Actual)"}] },
	    ];
		
		if(p_excelGrid) p_excelGrid.destructor();
		p_excelGrid = new dhx.Grid("excelGridArea", {
		    columns: config
		});
	}
	
	// [I/F Program Status] GridData 설정
	function setGridDataForIFProgramStatus(){
		var config = [
	        { width: 50, id: "RNUM", header: [{ text: "번호"}] },
			{ width: 100, id: "newItemId", header: [{"text": "ItemId"}]},
			{ width: 100, id: "newIMPlannedStart", header: [{"text": "작성시작일(Planned)"}]},
			{ width: 100, id: "newIMPlannedEnd", header: [{"text": "작성완료일(Planned)"}]},
			{ width: 100, id: "newIMActualStart", header: [{"text": "작성시작일(Actual)"}]},
			{ width: 100, id: "newIMActualEnd", header: [{"text": "작성완료일(Actual)"}]},
			{ width: 100, id: "newIMLegacyActualEndDate", header: [{"text": "Legacy 작성완료일"}]},
			{ width: 100, id: "newIfMappingName", header: [{"text": "정의서 명"}]},
			{ width: 100, id: "newIPPlannedStart", header: [{"text": "개발시작일(Planned)"}]},
			{ width: 100, id: "newIPPlannedEnd", header: [{"text": "개발완료일(Planned)"}]},
			{ width: 100, id: "newIPActualStart", header: [{"text": "개발시작일(Actual)"}]},
			{ width: 100, id: "newIPActualEnd", header: [{"text": "개발완료일(Actual)"}]},
			{ width: 100, id: "newIPEAIEndDate", header: [{"text": "개발EAI완료일(Actual)"}]},
			{ width: 100, id: "newIPLegacyPlannedEndDate", header: [{"text": "개발Legacy완료일(Planned)"}]},
			{ width: 100, id: "newIPLegacyActualEndDate", header: [{"text": "개발Legacy완료일(Actual)"}]},
			{ width: 100, id: "newUtPlannedStart", header: [{"text": "UT시작일(Planned)"}]},
			{ width: 100, id: "newUtPlannedEnd", header: [{"text": "UT완료일 (Planned)"}]},
			{ width: 100, id: "newUtActualStart", header: [{"text": "UT시작일(Actual)"}]},
			{ width: 100, id: "newUtActualEnd", header: [{"text": "UT완료일(Actual)"}]},
			{ width: 100, id: "newUtMWUtEndDate", header: [{"text": "UT M/W완료일"}]},
			{ width: 100, id: "newUtLegacyActualEndDate", header: [{"text": "UT Legacy완료일"}]},
			{ width: 100, id: "newITPlannedStart", header: [{"text": "IT시작일(Planned)"}]},
			{ width: 100, id: "newITPlannedEnd", header: [{"text": "IT완료일 (Planned)"}]},
			{ width: 100, id: "newITActualStart", header: [{"text": "IT시작일(Actual)"}]},
			{ width: 100, id: "newITActualEnd", header: [{"text": "IT완료일(Actual)"}]}
	    ];
		
		if(p_excelGrid) p_excelGrid.destructor();
		p_excelGrid = new dhx.Grid("excelGridArea", {
		    columns: config
		});
	}
	
	// [전사 시스템 목록] GridData 설정
	function setGridDataWholeCompanySystemItem(){
		var config = [
	        { width: 50, id: "RNUM", header: [{ text: "번호"}] },
	        {width: "80", id: "newParentIdentifier", header: [{text: "번호"}]},
	        {width: "100", id: "newTaniSystemE", header: [{text: "시스템그룹"}]},
	        {width: "100", id: "newTaniSystemK", header: [{text: "단위시스템영문"}]},
	        {width: "100", id: "newSystemOverview", header: [{text: "단위시스템한글"}]},
	        {width: "100", id: "newDate", header: [{text: "시스템 설명"}]},
	        {width: "100", id: "newGenPart", header: [{text: "구축시기"}]},
	        {width: "100", id: "newUserNum", header: [{text: "현업 부서"}]},
	        {width: "100", id: "newHidm", header: [{text: "사용자 수"}]},
	        {width: "100", id: "newSso", header: [{text: "HIDM 적용"}]},
	        {width: "100", id: "newSubSystemE", header: [{text: "서브시스템 영문"}]},
	        {width: "100", id: "newSubSystemK", header: [{text: "서브시스템 한글"}]},
	        {width: "100", id: "newWorkArea", header: [{text: "업무영역"}]},
	        {width: "100", id: "newGroup", header: [{text: "그룹"}]},
	        {width: "100", id: "newUneiTeam", header: [{text: "운영팀"}]},
	        {width: "100", id: "newUneiPart", header: [{text: "운영파트"}]},
	        {width: "100", id: "newPL", header: [{text: "PL"}]},
	        {width: "100", id: "newItTanto", header: [{text: "IT담당자"}]},
	        {width: "100", id: "newNewSmTanto", header: [{text: "신규SM담당자"}]},
	        {width: "100", id: "newOldSmTamto", header: [{text: "기존SM담당자"}]},
	        {width: "100", id: "newService1", header: [{text: "서비스 범위(본사)"}]},
	        {width: "100", id: "newService2", header: [{text: "서비스 범위(법인)"}]},
	        {width: "100", id: "newService3", header: [{text: "서비스 범위(기타)"}]},
	        {width: "100", id: "newUrl", header: [{text: "URL"}]},
	    ];
		
		if(p_excelGrid) p_excelGrid.destructor();
		p_excelGrid = new dhx.Grid("excelGridArea", {
		    columns: config
		});
	}
	// END ::: GRID	
	//===============================================================================
	
		
	//===================================================================
	//템플릿 다운로드
	function doFileDown() {
		var url = "${root}dsFileDown.do";
		ajaxSubmitNoAdd(document.fileDown, url);
	}

	//===================================================================
	//타겟 데이타 업로드
	function doFileUpload() {
		var url = "itemExcelUpload.do";
		
		// 선택된 라디오 버튼 value 취득
		fnGetRadioValue('radioUpload', 'uploadTemplate');
		fnGetRadioValue('radioOption', 'uploadOption');
		
		// 화면에서 선택된 업로드 내용, 옵션 , 파일 패스 등을 체크
		if (!checkInputValue()) {
			return;
		}
		
		//if( confirm('업로드 하시겠습니까?') ) {
		if( confirm('${CM00020}') ) {			
			$('#fileDownLoading').removeClass('file_down_off');
			$('#fileDownLoading').addClass('file_down_on');
			ajaxSubmitNoAdd(document.commandMap, url, "blankFrame");
		}
	}
	
	function checkInputValue() {
		if( $('#txtFilePath').val() == '') {
			//alert('파일을 선택해 주세요');
			alert('${WM00041_1}');
			return false;
		}
		
		if($('#uploadTemplate').val() == 0) {
			//alert('업로드할 내용을 선택해 주세요');
			alert('${WM00041_2}');
			return false;
		} else if($('#uploadTemplate').val() == 1) {
			if( $('#csrInfo').val() == "") {
				alert("${WM00041_5}");
				return false;
			}
		} else if($('#uploadTemplate').val() == 2 || $('#uploadTemplate').val() == 3 || $('#uploadTemplate').val() == 4 || $('#uploadTemplate').val() == 10) {
			if( $('#uploadOption').val() == 0) {
				//alert('업로드 Option을 선택해 주세요');
				alert('${WM00041_3}');
				return false;
			} else {
				if ($('#uploadTemplate').val() == 2 && $('#reportLanguage option:selected').text() == "Select Language") {
					//alert('업로드 언어를 선택해 주세요');
					alert('${WM00041_4}');
					return false;
				}
			}
		}
		
		return true;
	}

	function doCntReturn(tCnt, vCnt, aCnt, type, fileId, result, headerName, errMsgYN, fileName, downFile){ 
		$('#fileDownLoading').removeClass('file_down_on');
		$('#fileDownLoading').addClass('file_down_off');
		$("#TOT_CNT").val(tCnt);
		$("#FILE_VALD_CNT").val(vCnt);
		$("#FILE_NM").val(fileId);
		$("#ATTR_CNT").val(aCnt);
		$("#headerName").val(headerName);
		if(errMsgYN=="Y"){ 
			$('#original').val(fileName);
			$('#filename').val(fileName);
			$('#downFile').val(downFile);
			$('#errMsgYN').val(errMsgYN);
		}
		if(result.length > 0){	
			gridInit(aCnt, type, headerName);
			p_excelGrid.data.removeAll();
			var result = eval('(' + result + ')');
			const newData = result.rows.map(row => {
			    const newRow = { id: row.id };
			    const columns = p_excelGrid.config.columns;
			    row.data.forEach((value, index) => {
			        if (columns[index]) {
			            const columnId = columns[index].id;
			            newRow[columnId] = value;
			        }
			    });
			
			    return newRow;
			});
			
			p_excelGrid.data.parse(newData);
			doSave();
		}else{
			if(errMsgYN=="Y"){
				errorTxtDown();
			}
		}
	}
	
	function errorTxtDown(fileName, downFile) {
		var url = "fileDown.do";
		ajaxSubmitNoAlert(document.commandMap, url);
	}
	
	//===================================================================
	//타겟 데이타 저장
	function doSave() {	
		fnFetchSelectedCol(p_excelGrid, 0, document.commandMap);
		var url = "itemExcelSave.do";
		if( confirm("${WM00071}" + "${CM00021}")) {
			$('#selectedLang').val($('#reportLanguage option:selected').val());

			$('#fileDownLoading').removeClass('file_down_off');
			$('#fileDownLoading').addClass('file_down_on');
			ajaxSubmitNoAdd(document.commandMap, url);	
		}		
	}
	
	function doSaveReturn(){
		$('#fileDownLoading').addClass('file_down_off');
		$('#fileDownLoading').removeClass('file_down_on');
		$("#divSave").attr("style", "display:none");
		var errMsgYN = $("#errMsgYN").val();
		
		if(errMsgYN=="Y"){
			errorTxtDown();
		}
	}
	
	//===================================================================
	//선택된 라디오 버틈 value 취득
	function fnGetRadioValue(radioName, hiddenName) {
		var radioObj = document.all(radioName);
		var isChecked = false;
		for (var i = 0; i < radioObj.length; i++) {
			if (radioObj[i].checked) {
				$('#' + hiddenName).val(radioObj[i].value);
				isChecked = true;
				break;
			}
		}
		
		if (!isChecked) {
			$('#' + hiddenName).val(0);
		}
	}
	
	function radioOnChangeEvent(value) {
		if (value == 2) {
			document.getElementById("reportLanguage").disabled = false;
		} else {
			document.getElementById("reportLanguage").disabled = true;
		}
	}
	
</script>

<div id="fileDownLoading" class="file_down_off">
	<img src="${root}${HTML_IMG_DIR}img_circle.gif"/>
</div>
<form name="commandMap" id="commandMap" enctype="multipart/form-data" action="itemExcelSave.do" method="post" onsubmit="return false;">
<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}"/>
<input type="hidden" id="option" name="option" value="${option}"/>
<input type="hidden" id="userId" name="userId" value="${sessionScope.loginInfo.sessionUserId}">
<input type="hidden" id="selectedLang" name="selectedLang" value=""/>
<input type="hidden" id="uploadTemplate" name="uploadTemplate" value=""/>
<input type="hidden" id="uploadOption" name="uploadOption" value=""/>
<input type="hidden" id="ATTR_CNT" name="ATTR_CNT" value="">
<input type="hidden" id="headerName" name="headerName" value="">

<input type="hidden" id="original" name="original" value="">
<input type="hidden" id="filename" name="filename" value="">
<input type="hidden" id="downFile" name="downFile" value="">
<input type="hidden" id="errMsgYN" name="errMsgYN" value="">
<input type="hidden" id="scrnType" name="scrnType" value="excel">
	
	<!-- start -->
	<div id="framecontent" class="mgT10 mgB10">	
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="font-size:12px;">
			<colgroup>
				<col width="15%">
				<col width="35%">
				<col width="15%">
				<col width="35%">
			</colgroup>
			<tr>
				<!-- 업로드 내용 -->
				<th class="pdB5" style="text-align:left;">${menu.LN00145}</th>
				<td colspan="3" class="pdB5">
					<input type="radio" name="radioUpload" value=1 onchange="radioOnChangeEvent(1)">&nbsp;Create Items&nbsp;&nbsp;
					<input type="radio" name="radioUpload" value=2 onchange="radioOnChangeEvent(2)">&nbsp;Update attributes&nbsp;&nbsp;
					<input type="radio" name="radioUpload" value=3 onchange="radioOnChangeEvent(3)">&nbsp;Create connection&nbsp;&nbsp;
					<input type="radio" name="radioUpload" value=4 onchange="radioOnChangeEvent(4)">&nbsp;Assign dimension&nbsp;&nbsp;
					<input type="radio" name="radioUpload" value=10 onchange="radioOnChangeEvent(10)">&nbsp;Assign Teams&nbsp;&nbsp;
					<input type="radio" name="radioUpload" value=11 onchange="radioOnChangeEvent(11)">&nbsp;Assign Members&nbsp;&nbsp;
				</td>
			</tr>
			<!-- <tr>
				<th class="pdB5" style="text-align:left;"></th>
				<td colspan="3" class="pdB5">
					<input type="radio" name="radioUpload" value=5 onchange="radioOnChangeEvent(5)">&nbsp;CBO List 업로드&nbsp;&nbsp;
					<input type="radio" name="radioUpload" value=6 onchange="radioOnChangeEvent(6)">&nbsp;IF Master 업로드&nbsp;&nbsp;
					<input type="radio" name="radioUpload" value=7 onchange="radioOnChangeEvent(7)">&nbsp;CBO Program Status&nbsp;&nbsp;
					<input type="radio" name="radioUpload" value=8 onchange="radioOnChangeEvent(8)">&nbsp;IF Program Status&nbsp;&nbsp;
					<input type="radio" name="radioUpload" value=9 onchange="radioOnChangeEvent(9)">&nbsp;전사 시스템 목록&nbsp;&nbsp;
				</td>
			</tr> -->
			<tr>
				<!-- 업로드 Option -->
				<th class="pdB5" style="text-align:left;">${menu.LN00146}</th>
				<td class="pdB5">
					<input type="radio" name="radioOption" value=1>&nbsp;With ItemID&nbsp;&nbsp;
					<input type="radio" name="radioOption" value=2>&nbsp;With Identifier&nbsp;&nbsp;
				</td>
			</tr>
			<tr>
				<!-- 업로드 언어 -->
				<th class="pdB5" style="text-align:left;">CSR</th>
				<td class="pdB5">
					<select id="csrInfo" name="csrInfo" class="sel" style="height:22px;width:180px">
						<option value=""></option>
						<c:forEach var="i" items="${csrOption}">
							<option value="${i.CODE}">${i.NAME}</option>						
						</c:forEach>				
					</select>
				</td>
				<th style="text-align:left;">${menu.LN00147}</th>
				<td>
					<select name="reportLanguage" id="reportLanguage" class="text" onchange="changeLanguage($(this).val())" style="height:22px;width:120px" disabled="disabled"></select>
				</td>
			</tr>
			<tr>
				<th class="pdB5" style="text-align:left;">Select File</th>
				<td colspan="3" class="pdB5">
					<input type="text" id="txtFilePath" readonly onfocus="this.blur()" class="txt_file_upload"/>
					<span style="vertical-align:middle; position:relative; width:13px; height:13px; overflow:hidden; cursor:pointer; background:url('${root}${HTML_IMG_DIR}/btn_file_attach.png') no-repeat;">
						<input type="file" name="FD_FILE_PATH" id="FD_FILE_PATH" class="file_upload2">
					</span>	
					<span class="btn_pack medium icon"><span class="upload"></span><input value="Upload" type="submit" id="send"></span>
					<input type="hidden" id="FILE_NM" name="FILE_NM"/>
				</td>
			</tr>
			<tr>
				<th style="text-align:left;">Total Count</th>
				<td>
					<input type="text" class="text" readonly onfocus="this.blur()" id="TOT_CNT" name="TOT_CNT"/>
				</td>
				<th style="text-align:left;">Valid Item Count</th>
				<td>
					<input type="text" class="text" readonly onfocus="this.blur()" id="FILE_VALD_CNT" name="FILE_VALD_CNT"/>
				</td>
			</tr>
		</table>
	</div>
	<!-- 타겟 end -->
</form>	

	<!-- BIGIN :: LIST_GRID -->
	<div id="maincontent">
		<div class="file_search_list" style="display:none;">
			<div id="excelGridArea" style="height:190px;width:100%"></div>
		</div>
		<div id="divSave" class="alignBTN" style="display:none">
			<input type="image" id="save" class="image" src="${root}${HTML_IMG_DIR}/btn_add01.png"/>
		</div>
	</div>		
	<!-- END :: LIST_GRID -->

<!-- 
<form name="fileDown" method="post">
	<input name="original" type="hidden" value="template.xls">
	<input name="filename" type="hidden" value="template_file/template.xls">
</form>
 -->
 
 <iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
 
 <div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
