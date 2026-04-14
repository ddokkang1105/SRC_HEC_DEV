<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>

<script type="text/javascript">

	var gridArea;				//그리드 전역변수
	var myDataProcessor;
	
	$(document).ready(function(){

		$('.searchList').click(function(){
			doSearchList();
			return false;
		});
		$('#searchValue').keypress(function(onkey){
			if(onkey.keyCode == 13){
				doSearchList();
				return false;
			}
		});		
		
		gridInit();		
		doSearchList();
		
		var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";	
		fnSelect('classCode', data, 'classCodeFile', 'All');
	});
	
	function fnSeletFltpCode(){
		var itemClassCode = $('#classCode').val();
		var data = "&itemClassCode="+itemClassCode;
		fnSelectNone('fltpCode', data, 'fltpCode', 'Select'); 
	}
	
	function doSearchList(){
			var d = setGridData();
			fnLoadDhtmlxGridJson(gridArea, d.key, d.cols, d.data);
	}
	
	function gridInit(){	
		var d = setGridData();
		gridArea = fnNewInitGrid("gridArea", d);
		gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		gridArea.setIconPath("${root}${HTML_IMG_DIR}/btn_edit01.png");
		fnSetColType(gridArea, 1, "ch");
		//gridArea.setColumnHidden(4, true);
		gridArea.setColumnHidden(10, true);
		gridArea.setColumnHidden(11, true);
		gridArea.setColumnHidden(12, true);
		gridArea.setColumnHidden(13, true);
		gridArea.setColumnHidden(14, true);
		
		//gridArea.enablePaging(true, df_pageSize, null, "pagingArea", true, "recinfoArea");
		gridArea.enablePaging(true,10,10,"pagingArea",true);

		gridArea.setPagingSkin("bricks");
		fnSetColType(gridArea, 11, "img");
		
		gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
	}
	
	function setGridData(){
		//+ "&rltdItemId1= ${sqlItemID}"
		var result 	= new Object();
		result.title 	= "${title}";
		result.key 	= "fileMgt_SQL.getFile";
		result.header = "No,#master_checkbox,${menu.LN00091},${menu.LN00101},${menu.LN00102},${menu.LN00013},${menu.LN00070},${menu.LN00060},${menu.LN00104},${menu.LN00030},Seq,${menu.LN00103},FileRealName,파일타입코드,FilePath";
		result.cols 	= "CHK|FltpName|FileRealName|Path|CreationTime|LastUpdated|WriteUserNM|TeamName|DownCNT|Seq|수정|FileName|FltpCode|FilePath";
		result.widths = "30,30,120,*,220,90,90,90,80,50,60,100,100,100,100";
		result.sorting = "int,int,str,str,str,str,str,str,int,int,str,str,str,str,str,str";
		result.types = "ro,ch,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro";
		result.aligns = "center,center,left,left,left,center,center,center,center,center,left,left,center,left,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
						+ "&itemClassCode=" + $("#classCode").val()
				        + "&fltpCode="+ $("#fltpCode").val()
				        + "&searchValue="+ $("#searchValue").val()					
						+ "&rltdItemId=${rltdItemId}"
						+ "&s_itemID="+ $("#itemID").val();
		return result;
	}
	
	// 상세 화면 
	function gridOnRowSelect(id, ind){
	
		if(ind == 11){
			var isNew = "N";
			var seq = gridArea.cells(id, 10).getValue();
			var fileName =  gridArea.cells(id, 3).getValue();
			var fltpCode =  gridArea.cells(id, 13).getValue();
			var creationTime  =  gridArea.cells(id, 5).getValue();
			var writeUserNM = gridArea.cells(id, 7).getValue();
			var sysFile = gridArea.cells(id,14).getValue() + gridArea.cells(id,12).getValue(); //sysfile
			var fltpName = gridArea.cells(id,2).getValue();

			goFileGrpDetail(isNew,seq,fileName,fltpCode,creationTime,writeUserNM,sysFile,fltpName); 
		}else{
			
			var originalFileName = gridArea.cells(id, 3).getValue();
			var sysFileName = gridArea.cells(id, 12).getValue();
			var seq = gridArea.cells(id, 10).getValue();
			
			fnClickedFileDownload(originalFileName,sysFileName,"",seq);
		}
	}
	
	function fnClickedFileDownload(originalFileName,sysFileName,filePath,seq){
		
		var url  = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
	}
	
	function fnFileDownload(){
		var cnt  = gridArea.getRowsNum();

		var originalFileName = new Array();
		var sysFileName = new Array();
		var seq = new Array();
		var chkVal;
		var j =0;
	
		for(var i=0; i<cnt; i++){

			chkVal = gridArea.cells2(i,1).getValue();
			 
			if(chkVal == 1){
				
				j++;
			}
		}
	
		if(j==0){
			alert("${WM00049}");
			return;
		}
		
		j =0;
		for(var i=0; i<cnt; i++){
			chkVal = gridArea.cells2(i,1).getValue();
			if(chkVal == 1){
				
				sysFileName[j] =  gridArea.cells2(i,14).getValue() + gridArea.cells2(i,12).getValue(); //sysfile
				originalFileName[j] =  gridArea.cells2(i,14).getValue() + gridArea.cells2(i,3).getValue(); // orignalfile
				seq[j] = gridArea.cells2(i,10).getValue(); 
				j++;
			}
		}
		
		var url  = "fileDownload.do?seq="+seq;

		ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
	}
	
	function fnFileUpload(){
		
	    var fileCount = document.getElementById("files_upload").files.length;
	
	    var fileSize = new Array();
	    var fileName = new Array();
	
	 	for(var i=0; i<fileCount; i++){
	 		fileSize[i] = document.getElementById("files_upload").files[i].size;
	 		fileName[i] = document.getElementById("files_upload").files[i].name;
	 	}
		  
		var files =  $("#files-upload").val();
		var url  = "fileUpload.do?files="+files+"&fileSize="+fileSize+"&fileName="+fileName;
		ajaxSubmit(document.fileMgtFrm, url);

	}
	
</script>
<form name="fileMgtFrm" id="fileMgtFrm" action="fileDownloadDev.do" method="post" onsubmit="return false">
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}" /> 
	<input type="hidden" id="itemID" name="itemID" value="${itemID}" />
	<input type="hidden" id="itemClassCode" name="itemClassCode" value="${itemClassCode}" />
	<div class="child_search">
        <li class="pdL55">
			${menu.LN00016}
			<select id=classCode name="classCode" style="width:150px;" OnChange="fnSeletFltpCode()"></select>
		</li>
		<li>
			${menu.LN00091}
			<select id=fltpCode name="fltpCode" style="width:150px;"></select>
			<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;">
			<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" />
		</li>
		<li class="floatR pdR20">
			<span class="btn_pack medium icon"><span class="reload"></span><input value="Reload" type="button" onclick="doSearchList()"></span>&nbsp;&nbsp;
			<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="fnFileDownload()"></span>
		</li>
	</div>
	<div class="countList">
              <li class="count">Total <span id="TOT_CNT"></span></li>
              <li class="floatR">&nbsp;</li>
    </div>
	<div id="gridDiv" class="mgB10 clear">
		<div id="gridArea" style="height: 300px; width: 100%"></div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->	
</form>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
