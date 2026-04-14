<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 1. Include CSS/JS -->

<style type="text/css">
	#framecontent{border:1px solid #e4e4e4;overflow: hidden; background: #f9f9f9;padding:10px;width:95%;margin:0 auto;}
</style>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

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
        
	$(document).ready(function(){
		
		
		$("#send").click(function() {
			doFileUpload();
		});
		
		$("#save").click(function() {
			doSave();
		});
		
		 $('#FD_FILE_PATH').change(function(){
		        var upfile = $(this).val();
		        $('#txtFilePath').val( upfile );
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
		}
		
		p_excelGrid = fnNewInitGrid("excelGridArea", d);
		p_excelGrid.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		
		//p_excelGrid.setColumnHidden(0, true);				//RNUM
	}
	
	// [새로운 구조 업로드][속성 업데이트] GridData 설정
	function setGridDataForAddNew(aCnt){
		var result = new Object();
		var header = "";
		var cols = "";
		var widths = "";
		var sorting = "";
		var aligns = "";
		
		for (var i = 1; i < aCnt; i++) {
			header = header + ",PlainText" + i;
			cols = cols + "|newPlainText" + i; 
			widths = widths + ",200";
			sorting = sorting + ",str";
			aligns = aligns + ",left";
		}
		
		result.title = "${title}";
		result.key = "aa";
		result.header = "번호,Parent,ItemId,Identifier,ClassCode" + header;
		result.cols = "newParentIdentifier|newItemId|newIdentifier|newClassCode" + cols;
		result.widths = "50,80,80,80,80" + widths;
		result.sorting = "str,str,str,str" + sorting;
		result.aligns = "center,center,center,center" + aligns;
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+"&ArcCode="+$("#ArcCode").val()
			+"&s_itemID="+$("#s_itemID").val();

		return result;
	}
	
	// [CBO List] GridData 설정
	function setGridDataForCboList(){
		var result = new Object();
		
		result.title = "${title}";
		result.key = "aa";
		result.header = "번호,ParentId,Process ID,Process 명,개발항목,CBO Type,CBO ID,개발 유형,개발대상SAP," 
						+ "사용 기간,난이도,중요도,우선순위,개발공수,관련시스템,연관모듈,Program ID,T-Code,비고";
		result.cols = "newParentIdentifier|newProcessID|newItemName|newName|newCBOType|newCBOId|" 
					+ "newCatagory|newDSAP|newPeriod|newDifficulty|newImportance|newPriority|newProductionCosts|" 
					+ "newSystem|newModule|newProgramID|newTCode|newNote";
		result.widths = "50,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+"&ArcCode="+$("#ArcCode").val()
			+"&s_itemID="+$("#s_itemID").val();

		return result;
	}
	
	// [IF Master] GridData 설정
	function setGridDataForIfMater(){
		var result = new Object();
		
		result.title = "${title}";
		result.key = "aa";
		result.header = "번호,ParentId,Interface ID,그룹명,관리주체,단위시스템,서브시스템,IF 항목명,CBO ID,Program ID,Process ID,Process Name,"
						+ "Variant,Gap ID,개발대상 SAP,사용 기간,In/Out,OnLine or Batch,I/F 주기,ERP,RFC Destination,M/W,Legacy,"
						+ "ERP TYPE,M/W Type,Legacy Type,ERP담당,M/W담당,Legacy 담당,ERP Status,M/W Status,Legacy Status,Total Status,통합테스트 시기,고려사항,비고";
		result.cols = "newParentIdentifier|newInterfaceID|newGroupName|newKanri|newTani|newSub|" 
					+ "newIfName|newCboId|newProgramID|newProcessId|newItemName|newVariant|newGapId|" 
					+ "newDSAP|newPeriod|newInOut|newOnLineOrBatch|newIfPeriod|newErp|newRfcDestination|newMw|newLegacy|" 
					+ "newErpType|newMwType|newLegacyType|newErpTanto|newMwTanto|newLegacyTanto|"
					+ "newErpStatus|newMwStatus|newLegacyStatus|newTotalStatus|newTestPeriod|newIssue|newNote";
		result.widths = "50,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,"
					+ "center,center,center,center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+"&ArcCode="+$("#ArcCode").val()
			+"&s_itemID="+$("#s_itemID").val();

		return result;
	}
	
	// [관련항목 매핑] GridData 설정
	function setGridDataForConnection(){
		var result = new Object();
		
		result.title = "${title}";
		result.key = "aa";
		result.header = "번호,From ItemID,ClassCode,Name,To ItemID,ClassCode,Name,Connection Type";
		result.cols = "newFromItemId|newFromClassCode|newFromName|newToItemId|newToClassCode|newToName|newConnectionType";
		result.widths = "50,80,80,200,80,80,200,120";
		result.sorting = "str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,left,center,center,left,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+"&ArcCode="+$("#ArcCode").val()
			+"&s_itemID="+$("#s_itemID").val();

		return result;
	}
	
	// [Dimension Mapping] GridData 설정
	function setGridDataForDimension(aCnt, headerName){
		var result = new Object();
		var cols = "";
		var widths = "";
		var sorting = "";
		var aligns = "";
		
		for (var i = 1; i < aCnt; i++) {
			cols = cols + "|newDimValue" + i; 
			widths = widths + ",100";
			sorting = sorting + ",str";
			aligns = aligns + ",center";
		}
		
		result.title = "${title}";
		result.key = "aa";
		result.header = "번호,Item Type ID,Dimensin Type ID/ Item Name" + headerName;
		result.cols = "newItemTypeId|newDimTypeIdItemName" + cols;
		result.widths = "50,100,250" + widths;
		result.sorting = "str,str,str" + sorting;
		result.aligns = "center,center,left" + aligns;
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+"&ArcCode="+$("#ArcCode").val()
			+"&s_itemID="+$("#s_itemID").val();

		return result;
	}
	
	// [CBO Program Status] GridData 설정
	function setGridDataForCboProgramStatus(){
		var result = new Object();
		
		result.title = "${title}";
		result.key = "aa";
		result.header = "번호,ItemId,FD담당자,FD시작일(Planned),FD완료일(Planned),FD상태,FD시작일(Actual),FD완료일(Actual),"
			 			+ "PG담당자,PG시작일(Planned),PG완료일(Planned),PG상태,PG시작일(Actual),PG완료일(Actual),"
			 			+ "UT담당자,UT시작일(Planned),UT완료일(Planned),UT상태,UT시작일(Actual),UT완료일(Actual),"
			 			+ "TD담당자,TD시작일(Planned),TD완료일(Planned),TD상태,TD시작일(Actual),TD완료일(Actual)";
		result.cols = "newItemId|newFDTanto|newFDPlannedStart|newFDPlannedEnd|newFDStatus|newFDActualStart|newFDActualEnd|" 
					+ "newPGTanto|newPGPlannedStart|newPGPlannedEnd|newPGStatus|newPGActualStart|newPGActualEnd|" 
					+ "newUTTanto|newUTPlannedStart|newUTPlannedEnd|newUTStatus|newUTActualStart|newUTActualEnd|"
					+ "newTDTanto|newTDPlannedStart|newTDPlannedEnd|newTDStatus|newTDActualStart|newTDActualEnd";
		result.widths = "30,80,80,100,100,80,100,100,80,100,100,80,100,100,80,100,100,80,100,100,80,100,100,80,100,100";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,center,center,center,center,center,"
					+ "center,center,center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+"&ArcCode="+$("#ArcCode").val()
			+"&s_itemID="+$("#s_itemID").val();

		return result;
	}
	
	// [I/F Program Status] GridData 설정
	function setGridDataForIFProgramStatus(){
		var result = new Object();
		
		result.title = "${title}";
		result.key = "aa";
		result.header = "번호,ItemId,작성시작일(Planned),작성완료일(Planned),작성시작일(Actual),작성완료일(Actual),Legacy 작성완료일,정의서 명,"
				+ "개발시작일(Planned),개발완료일(Planned),개발시작일(Actual),개발완료일(Actual),개발EAI완료일(Actual),개발Legacy완료일(Planned),개발Legacy완료일(Actual),"
				+ "UT시작일(Planned),UT완료일 (Planned),UT시작일(Actual),UT완료일(Actual),UT M/W완료일,UT Legacy완료일,"
				+ "IT시작일(Planned),IT완료일 (Planned),IT시작일(Actual),IT완료일(Actual)";
		result.cols = "newItemId|newIMPlannedStart|newIMPlannedEnd|newIMActualStart|newIMActualEnd|newIMLegacyActualEndDate|newIfMappingName|"
				+ "newIPPlannedStart|newIPPlannedEnd|newIPActualStart|newIPActualEnd|newIPEAIEndDate|newIPLegacyPlannedEndDate|newIPLegacyActualEndDate|"
				+ "newUtPlannedStart|newUtPlannedEnd|newUtActualStart|newUtActualEnd|newUtMWUtEndDate|newUtLegacyActualEndDate|"
				+ "newITPlannedStart|newITPlannedEnd|newITActualStart|newITActualEnd";
		result.widths = "50,80,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,center,center,center,center,center,center,"
					+ "center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+"&ArcCode="+$("#ArcCode").val()
			+"&s_itemID="+$("#s_itemID").val();

		return result;
	}
	
	// [전사 시스템 목록] GridData 설정
	function setGridDataWholeCompanySystemItem(){
		var result = new Object();
		
		result.title = "${title}";
		result.key = "aa";
		result.header = "번호,시스템그룹,단위시스템영문,단위시스템한글,시스템 설명,구축시기,현업 부서,사용자 수,HIDM 적용,SSO 적용,"
			 			+ "서브시스템 영문,서브시스템 한글,업무영역,그룹,운영팀,운영파트,PL,IT담당자,신규SM담당자,기존SM담당자,"
			 			+ "서비스 범위(본사),서비스 범위(법인),서비스 범위(기타),URL";
		result.cols = "newParentIdentifier|newTaniSystemE|newTaniSystemK|newSystemOverview|newDate|newGenPart|newUserNum|newHidm|newSso|"
					+ "newSubSystemE|newSubSystemK|newWorkArea|newGroup|newUneiTeam|newUneiPart|newPL|newItTanto|newNewSmTanto|"
					+ "newOldSmTamto|newService1|newService2|newService3|newUrl";
		result.widths = "50,80,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,center,center,center,center,center,"
					+ "center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+"&ArcCode="+$("#ArcCode").val()
			+"&s_itemID="+$("#s_itemID").val();

		return result;
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
		fnGetRadioValue('radioOption', 'uploadOption');
		var url = "taskExcelUpload.do";		
		if( confirm('${CM00020}') ) {
			ajaxSubmitNoAdd(document.taskUpdateFrm, url);
		}
	}
	
	function doCntReturn(){
		var url = "goTaskUpdate.do";
		var target = "taskSearchFrm";
		var data = "";
		ajaxPage(url, data, target);
	}
	
	function errorTxtDown(fileName, downFile) { 
		var url = "fileDown.do";
		$('#original').val(fileName);
		$('#filename').val(fileName);
		$('#downFile').val(downFile);
		
		ajaxSubmitNoAlert(document.taskUpdateFrm, url);
	}
	
	//===================================================================
	//타겟 데이타 저장
	function doSave() {		
		fnFetchSelectedCol(p_excelGrid, 0, document.commandMap);
		var url = "itemExcelSave.do";
		//if( confirm("해당되는 리스트이 정보를 저장 하겠습니까?")) {
		if( confirm("${WM00071}" + "${CM00021}")) {
			$('#selectedLang').val($('#reportLanguage option:selected').val());
			ajaxSubmitNoAdd(document.taskUpdateFrm, url);	
		}		
	}
	
	function doSaveReturn(){
		$("#divSave").attr("style", "display:none");
	}
	
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
	
	
	
</script>

<form name="taskUpdateFrm" id="taskUpdateFrm" enctype="multipart/form-data" action="taskExcelSave.do" method="post" onsubmit="return false;">
<input type="hidden" id="uploadOption" name="uploadOption" value=""/>
<input type="hidden" id="original" name="original" value=""/>
<input type="hidden" id="filename" name="filename" value=""/>
<input type="hidden" id="downFile" name="downFile" value=""/>
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
	<h3 style="padding: 6px 0 6px 0">
		<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp; Update task progress data
	</h3>
	</div><div style="height:10px"></div>
	<!-- start -->
	<div id="framecontent" class="mgT10 mgB10">	
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="font-size:12px;">		
			<tr>
				<!-- 업로드 Option -->
				<th class="pdB5" style="text-align:left;">${menu.LN00146}</th>
				<td class="pdB5">
					<input type="radio" name="radioOption" value="csrID" checked>&nbsp;With Revision ID&nbsp;&nbsp;
					<input type="radio" name="radioOption" value="identfier" >&nbsp;With Identifier&nbsp;&nbsp;
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
 <iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
 
 <div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
 