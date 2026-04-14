<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 1. Include CSS/JS -->
<style type="text/css">
	#framecontent{border:1px solid #e4e4e4;overflow: hidden; background: #f9f9f9;padding:10px;margin:10px}
	/*#maincontent{position: fixed;top: 0; left: 200px; right: 0;bottom: 0;overflow: auto; background: #fff;padding:10px}
	*/
</style>

<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/css/dhtmlx/dthmlxgrid_search.css'/>">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00095" var="WM00095"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00020" var="CM00020"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00021" var="CM00021"/>

<script>
	var p_excelGrid;				//그리드 전역변수
        
	$(document).ready(function(){
		
		$("#save").click(function(){
			doSave();
		});
	
		//gridInit();
	});
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridInit(){		
		var d = setGridData();
		
		p_excelGrid = fnNewInitGrid("excelGridArea", d);
		p_excelGrid.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		
		//p_excelGrid.setColumnHidden(0, true);				//RNUM
	}

	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "aa";
		result.header = "번호,ParentID,ItemID,명칭,Code,ClassCode,조직코드,회사코드,작성자ID";
		result.cols = "newParentID|newItemID|newItemName|newIdentifier|newClassCode|newOwnerTeamID|newCompanyID|newCreator";
		result.widths = "50,80,80,300,100,100,100,100,100";
		result.sorting = "str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,left,center,center,center,center,center";
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
		var d = setGridData();
		
		var url = "itemExcelUpload.do?cols="+d.cols;
		var totNum = 0;
		if( $('#FD_FILE_PATH').val() == ''){
			//alert('파일을 선택해 주세요');
			alert('${WM00095}');
			return;
		}
		
		//if( confirm('업로드 하시겠습니까?') ) {
		if( confirm('${CM00020}') ) {
			//uploadYn = 'Y';
			ajaxSubmitNoAdd(document.commandMap, url);
		}
	}

	function doCntReturn(tCnt, vCnt, fileId, result){
		$("#TOT_CNT").val(tCnt);
		$("#FILE_VALD_CNT").val(vCnt);
		$("#FILE_NM").val(fileId);
		
		if(result.length > 0){			
			gridInit();
			
			p_excelGrid.clearAll();
			var result = eval('(' + result + ')');
			p_excelGrid.parse(result,"json");
		
			$("#divSave").attr("style", "display:block");
		}
	}
	
	//===================================================================
	//타겟 데이타 저장
	function doSave()
	{		
		fnFetchDHTMLXAllColToInsert(p_excelGrid, document.commandMap);

		var url = "itemExcelSave.do";
		//if( confirm("해당되는 리스트이 정보를 저장 하겠습니까?")) {
		if( confirm('${CM00021}') ) {
			ajaxSubmitNoAdd(document.commandMap, url);
		}		
	}
	
	function doSaveReturn(){
		$("#divSave").attr("style", "display:none");
	}
	
</script>

<form name="commandMap" enctype="multipart/form-data" method="post" onsubmit="return false;">
<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}"/>
<input type="hidden" id="option" name="option" value="${option}"/>
	<!-- start -->
	<div id="framecontent">
		<table  width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col>
				<col width="100">
				<col width="100">
				<col width="120">
				<col width="100">
			</colgroup>
			<!-- 
			<tr>
				<td class="td03" rowspan="2"><img src="${root}${HTML_IMG_DIR}/bullet_gray.gif" widtd="2" height="2" /> 파일명</td>
				<td class="tdend" colspan="5">
					<a href="javascript:doFileDown();"><img src="${root}${HTML_IMG_DIR}/btn_fileadd.png" title="템플릿 다운로드"></a>
				</td>
			</tr> -->
			<tr>
				<td><font color="#fe7f14"><b>*</b></font> <b>업로드할 파일 선택 </b>
					<input type="file" name="FD_FILE_PATH" id="FD_FILE_PATH" size="40"/>
					<a href="javascript:doFileUpload();"><img src="${root}${HTML_IMG_DIR}/btn_file_attach.png" title="파일업로드"></a>
					<input type="hidden" id="FILE_NM" name="FILE_NM"/>
				</td>
				<td class="alignR"><b>등록한 전체수</b></td>
				<td style="padding:0 5px">
					<input type="text" style="widtd:65px;background-color:#f0eeee;"  class="text" readonly onfocus="tdis.blur()" id="TOT_CNT" name="TOT_CNT"/>
				</td>
				<td  class="alignR"><b>업로드 가능 유효수</b></td>
				<td  style="padding:0 5px">
					<input type="text" style="widtd:65px;background-color:#f0eeee;" class="text" readonly onfocus="tdis.blur()" id="FILE_VALD_CNT" name="FILE_VALD_CNT"/>
				</td>
			</tr>
		</table>
	</div>
	<!-- 타겟 end -->
	
	<!-- BIGIN :: LIST_GRID -->
	<div id="maincontent">
		<div class="file_search_list">
			<div id="excelGridArea" style="height:150px;width:100%"></div>
		</div>
		<div id="divSave" class="alignBTN" style="display:none">
			<input type="image" id="save" class="image" src="${root}${HTML_IMG_DIR}/btn_add01.png"/>
		</div>
	</div>		
	<!-- END :: LIST_GRID -->
</form>
<!-- 
<form name="fileDown" method="post">
	<input name="original" type="hidden" value="template.xls">
	<input name="filename" type="hidden" value="template_file/template.xls">
</form>
 -->
 
 <iframe name="saveFrame" id="saveFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
 