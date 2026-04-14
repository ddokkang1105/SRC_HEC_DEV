<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00123" var="WM00123"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<link rel="stylesheet" href="${root}cmm/common/css/materialdesignicons.min.css"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>

<style>
.context-menu-wrapper {
    position: relative;
}
.context-menu {
    position: absolute;
    z-index: 999;
    top:27px;
    left: 4px;
    background: #fff;
    border: 1px solid rgba(0, 0, 0, .1);
    box-shadow: 0 4px 10px 0 rgba(63, 64, 70, .1), 0 1px 1px 0 rgba(63, 64, 70, .05);
/*     max-width: 240px; */
    margin-top: 8px;
    border-radius: 6px;
    display:none;
}
.context-menu.open {
	display: block;
}
.context-menu .title {
    display: flex;
    align-items: center;
	border-bottom: 1px solid rgba(0, 0, 0, .1	);
    box-shadow: none;
    height: 25px;
    padding: 5px 30px 6px 16px;
    font-weight: 500;
}
.context-menu .title:empty {
    display: none;
}
.context-menu .menu {
    text-overflow: ellipsis;
    overflow: hidden;
    white-space: nowrap;
    max-width: 100%;
    word-wrap: normal;
    display: block;
    /* font-size: 13px; */
    line-height: 21px;
    color: #202124;
    padding: 5px 15px;
    text-align: left;
    position: relative;
    cursor:pointer;
}
.context-menu .menu:hover {
    background-color: #F1F3F9;
}
.context-menu .menu.selected {
	color:#0761CF;
}
.context-menu .menu .primary {
    width: 100%;
	height: 30px;
}
.right-panel-area {
	
}
.info-list {
    display: flex;
    flex-wrap: wrap;
    font-size: 13px;
    line-height: 19px;
}
.info-list dt{
	flex: none;
    width: 104px;
    padding: 7px 16px 6px 0;
    box-sizing: border-box;
    font-weight: 500;
}
.info-list dd{
    word-wrap: normal;
    flex-grow: 1;
    flex-shrink: 1;
    flex-basis: calc(100% - 104px);
    padding: 7px 0 6px;
}

#button-container {
    display: flex;
    gap: 10px;
    align-items: start; !important
}

#downTempFile {
	height: 32px; !important
}

/* file 확장자별 아이콘 css */
.file-icon {
    font-size: 22px;
    cursor: pointer;
    vertical-align: middle;
    transition: color 0.15s ease, transform 0.15s ease;
}

/* hover 공통 효과 */
.file-icon:hover {
    transform: scale(1.1);
}

/* ===============================
   파일 타입별 색상 정의  (mdi 클래스 기준 : materialdesignicons.min.css)
   =============================== */

/* PDF */
.mdi-file-pdf-box.file-icon {
    color: #E53935; /* red */
}
.mdi-file-pdf-box.file-icon:hover {
    color: #B71C1C;
}

/* EXCEL */
.mdi-file-excel-box.file-icon {
    color: #2E7D32; /* green */
}
.mdi-file-excel-box.file-icon:hover {
    color: #1B5E20;
}

/* WORD */
.mdi-file-word-box.file-icon {
    color: #1E88E5; /* blue */
}
.mdi-file-word-box.file-icon:hover {
    color: #0D47A1;
}

/* ===============================
   기타 / 알 수 없는 파일
   =============================== */
.mdi-file.file-icon {
    color: #757575; /* gray */
}
.mdi-file.file-icon:hover {
    color: #424242;
}

</style>

<script type="text/javascript">

	var gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	
	var userId = "${sessionScope.loginInfo.sessionUserId}";	
	var Authority = "${sessionScope.loginInfo.sessionAuthLev}";
	var sessionAuthLevel = "${sessionScope.loginInfo.sessionMlvl}";
	var selectedItemLockOwner = "${selectedItemLockOwner}";
	var selectedItemAuthorID = "${selectedItemAuthorID}";
	var selectedItemBlocked = "${selectedItemBlocked}";
	var selectedItemStatus = "${selectedItemStatus}";
	//var showVersion = "${showVersion}";
	var showValid = "${showValid}";
	var showPath = "${showPath}";
	var GRID_PAGE_SIZE = 100;
	var LAYOUT_BOTTOM_GAP = 120;
	var MIN_LAYOUT_HEIGHT = 320;
	var myItemYN = "${myItem}";
	var itemFileOption = "${itemFileOption}";
	var USE_FILE_LOG = "${USE_FILE_LOG}";
	
	$(document).ready(function(){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemTypeCode=${itemTypeCode}&docCategory=${docCategory}";
		fnSelect('languageID', data, 'langType', '${sessionScope.loginInfo.sessionCurrLangType}', 'Select');
		fnSelect('fltpCode', data, 'fltpCode', '', 'Select');
		
		$("input.datePicker").each(generateDatePicker);
		resizeGridLayout();
		window.onresize = resizeGridLayout;
		
		$("#blocked").click(function(){
			if(!$(this).is(':checked')) {
				$("#filtered").val("N");
			}
			else {
				$("#filtered").val("Y");				
			}
		});
		
		$("#excel").click(function(){
			fnGridExcelDownLoad();
		});
		
		// list 호출
		fnSearchList();
		
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

	function getLayoutHeight() {
		var layoutTop = $("#layout").offset() ? $("#layout").offset().top : 0;
		return Math.max(setWindowHeight() - layoutTop - LAYOUT_BOTTOM_GAP, MIN_LAYOUT_HEIGHT);
	}

	function resizeGridLayout() {
		$("#layout").css("height", getLayoutHeight() + "px");
		if (grid) {
			grid.paint();
		}
	}
	
 
	function fnCheckItemArrayAccRight(seq, DocumentID, ind){
		$.ajax({
			url: "checkItemArrayAccRight.do",
			type: 'post',
			data: "&itemIDs="+DocumentID+"&seq="+seq,
			error: function(xhr, status, error) { 
			},
			success: function(data){				
				data = data.replace("<script>","").replace(";<\/script>","");		
				fnCheckAccCtrlFileDownload(data, seq, DocumentID, ind);
			}
		});	
	}
	
	function fnCheckAccCtrlFileDownload(data, seq, DocumentID, ind){
		var dataArray = data.split(",");
		var accRight = dataArray[0];
		var fileName = dataArray[1];
		
		if(accRight == "Y"){
			if(ind==3){ // 다운로드 이미지 클릭시 
				var url  = "fileDownload.do?seq="+seq;
					ajaxSubmitNoAdd(document.fileFrm, url,"subFrame");			
			}else{						
				var url  = "documentDetail.do?&seq="+seq
						+"&DocumentID="+DocumentID+"&pageNum="+$("#currPage").val()
						+"&itemTypeCode=${itemTypeCode}&fltpCode=${fltpCode}";
				var w = 1200;
				var h = 500;
				itmInfoPopup(url,w,h); 	
			}
		}else{			
			alert(fileName + "은 ${WM00033}"); return;
		}
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
	
	
	function fnFileDownload(){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		var chkVal;
		var j =0;	
		
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00049}");
			return;
		}
		
		grid.data.forEach(function(row){
			if(row.checkbox){
				sysFileName[j] = row.SysFile;
				originalFileName[j] = row.FileRealName;
				filePath[j] = row.FilePath;
				seq[j] = row.Seq;
				j++
			}
		});	
		
		$("#sysFileName").val("");
		$("#originalFileName").val("");
		$("#seq").val(seq);
		var url  = "fileDownload.do";
		ajaxSubmitNoAdd(document.fileFrm, url,"subFrame");
	}	
	
	function fnClearSearch(){
		$("#languageID").val("");
		$("#fltpCode").val("");
		$("#startLastUpdated").val("");
		$("#endLastUpdated").val("");
		$("#itemName").val("");
		$("#fileName").val("");
		$("#regUserName").val("");
	}

	function fnBlock(){
		var seq = "";

		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00049}");
			return;
		}
		
		grid.data.forEach(function(row){
			if(row.checkbox){
				chkVal = row.checkbox;
				if(chkVal == 1){		
					if(seq == "")
						seq = row.Seq; 
					else 
						seq = seq + "," + row.Seq; 
				}
			}
		});	
		
		if(confirm("${CM00001}")){	
			var url  = "updateFileBlocked.do";
			var data = "&seq="+seq;
			ajaxPage(url,data,"subFrame");
		}
	}
	
</script>
</head>
<body>
<form name="fileFrm" id="fileFrm" action="" method="post" onsubmit="return false">
	<input type="hidden" id="itemAthId" name="itemAthId" value="${selectedItemAuthorID}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<input type="hidden" id="Blocked" name="Blocked" value="${selectedItemBlocked}" />
	<input type="hidden" id="LockOwner" name="LockOwner" value="${selectedItemLockOwner}" />	
	<input type="hidden" id="sysFileName" name="sysFileName">
	<input type="hidden" id="originalFileName" name="originalFileName">
	<input type="hidden" id="filePath" name="filePath" >
	<input type="hidden" id="seq" name="seq" >	
	<input type="hidden" id="filtered" value="Y"> 
	<div class="child_search_head" ><span class="flex align-center"><b style="margin:10px 0;">${menu.LN00111}</b></span></div>
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_blue01 mgT10" id="search">
		<colgroup>
		    <col width="10%">
		    <col width="20%">
		 	<col width="10%">
		    <col width="20%">
		 	<col width="10%">
		    <col width="30%">	
			   		
	    </colgroup>
	    <tr>
	       	
	       	<!-- 문서유형 -->
	        <th class="alignL viewtop pdL5">${menu.LN00091}</th>
	        <td class="viewtop alignL">      
	        <select id="fltpCode" Name="fltpCode" style="width:90%">
	            <option value=''>Select</option>
	        </select>
	        </td>
	        <th class="alignL viewtop pdL5">${menu.LN00147}</th>
	        <td class="viewtop alignL">     
		       	<select id="languageID" Name="languageID" style="width:90%">
		       		<option value=''>Select</option>
		       	</select>
	       	</td>
	       	<!-- 수정일 -->
	       	<th class="alignL viewtop pdL5">${menu.LN00070}</th>
	        <td class="viewtop alignL">  
		    	<input type="text" id="startLastUpdated" name="startLastUpdated" class="input_off datePicker stext" size="8"
					style="width: 100px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				
				~
				<input type="text" id="endLastUpdated" name="endLastUpdated" class="input_off datePicker stext" size="8"
					style="width: 100px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				
	       	</td>     	
	    </tr>
	    <tr>
	   		<!-- 프로세스명칭 -->
	       	<th class="alignL pdL5">${itemTypeName}&nbsp;${menu.LN00028}</th>
	        <td class="alignL">     
		    	<input type="text" class="text" id="itemName" name="itemName" style="ime-mode:active;width:90%;" />
	       	</td>
	       	<!-- 문서명 -->
	        <th class="alignL pdL5">${menu.LN00101}</th>
	        <td class="alignL">      
	        	<input type="text" class="text" id="fileName" name="fileName" style="ime-mode:active;width:90%;" />
	        </td>
	       	<!-- 작성자 -->
	       	<th class="alignL pdL5">${menu.LN00060}</th>
	        <td class="alignL">       
		     	<input type="text" class="text" id="regUserName" name="regUserName" style="ime-mode:active;width:70%;" />
		     	 &nbsp; &nbsp; <input type="checkbox" id="blocked" name="blocked" value="Y" checked="checked"/> &nbsp;<b>The latest</b>
		    </td>       	
	    </tr>
   	</table>
	<div class="countList pdT5 flex" >
	  <li class="count mgT10">Total  <span id="TOT_CNT"></span></li>
	  <li class="floatC">
      	<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="fnSearchList()"/>
        <input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;" onclick="fnClearSearch();" />
      </li>
      
      <li class="floatR mgR20">
      	<span class="btn_pack nobg white "><a class="download" OnClick="fnFileDownload()" title="Download" ></a></span>
        <c:if test="${loginInfo.sessionMlvl == 'SYS'}" >
        <span class="btn_pack nobg "><a class="block"  onclick="fnBlock()" title="Block" ></a></span>
        </c:if>
        <span class="btn_pack nobg white"><a class="xls" OnClick="fnDownload();" title="List Down" id="excel"></a></span>
     </li>
    </div>
	<div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>	
</form>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>

<script type="text/javascript">

		var grid = null;
		var pagination;
		var fileOption = "${fileOption}";
		
		var layout = new dhx.Layout("layout", {
		    cols: [
		        {
		        	id: "a"
		        },
		        {
		            html: "This cell was hidden",
		            id: "show",
		            hidden: true,
		            width : "350px",
		            css : "right-panel-area"
		        },
		    ]
		});
		
		function fnReloadGrid(newGridData){
			if (!grid) {
				return;
			}
			
			grid.data.removeAll();
	 		grid.data.parse(newGridData);
	 		layout.getCell("a").attach(grid);
	 		grid.paint();
	 		$("#TOT_CNT").html(newGridData.length);
	 		previousAddedFileNames = getGridFileNames();
	 		
	 		if (pagination) {
	 			pagination.destructor();
	 			pagination = null;
	 		}
	 		
	 		if (newGridData.length > GRID_PAGE_SIZE) {
	 			pagination = new dhx.Pagination("pagination", {
	 			    data: grid.data,
	 			    pageSize: GRID_PAGE_SIZE,
	 			});
	 		}
	 	}
		
	 	const changeEvent = document.createEvent("HTMLEvents");
		changeEvent.initEvent("change", true, true);
		
		// file list reload
		var sqlID = "fileMgt_SQL.getSubItemFileList";	 
		var languageID = '${sessionScope.loginInfo.sessionCurrLangType}';
		async function fnSearchList(){
			let requestData = null;
			requestData = { 
				sqlID: sqlID,	
				languageID: languageID,
				selectedLanguageID: $("#languageID").val(),
				fltpCode: $("#fltpCode").val(),
				startLastUpdated: $("#startLastUpdated").val(),
				endLastUpdated: $("#endLastUpdated").val(),
				itemName: $("#itemName").val(),
				fileName: $("#fileName").val(),
				regUserName: $("#regUserName").val(),
				filtered: $("#filtered").val(),
				//showVersion: showVersion,
				itemID: "${s_itemID}"
			};
			
			try {
		        
				const params = new URLSearchParams(requestData).toString();
			    const url = "getData.do?" + params; 
			    const response = await fetch(url, { method: 'GET' });
		        
				if (!response.ok) {
					// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
					throw throwServerError(response.statusText, response.status);
				}
		      
				const result = await response.json();
				if (!result.success) {
					throw throwServerError(result.message, result.status);
				}
				var resultCount =  result.data.length;
				if(result && result.data.length > 0) {
		        	resizeGridLayout();
		        	
		        	if(!grid) {	
						grid = new dhx.Grid(null, {	
							 columns: [
								 	{ width: 40, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center", template: function (text, row, col) { return row.RNUM;} },
								 	{ width: 30, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center", htmlEnable: true}], editorType: "checkbox", align: "center", type: "boolean",  editable: true, sortable: false}, 
							        { width: 40, id: "File", header: [{ text: "", align:"center" }], htmlEnable: true, align: "center",
							        	template: function (text, row, col) {
							        		//return '<img src="${root}${HTML_IMG_DIR}/btn_file_down.png" width="24" height="24">';					        		
							        		let iconClass = "mdi-file";
							        		const fmt = (row.FileFormat || "").toLowerCase().trim(); 
							        		if (fmt === "pdf") {
							        	        iconClass = "mdi-file-pdf-box";
							        	    } else if (fmt === "xlsx" || fmt === "xls") {
							        	        iconClass = "mdi-file-excel-box";
							        	    } else if (fmt === "docx" || fmt === "doc") {
							        	        iconClass = "mdi-file-word-box";
							        	    }
							        	    return '<span class="mdi  ' + iconClass + ' file-icon"></span>';
							            }
							        },	   
							        { width: 350, id: "FileRealName", header: [{ text: "${menu.LN00101}", align: "center" } ], align: "left" },
							        { width: 130, id: "FltpName", header: [{ text: "${menu.LN00091}", align: "center" } ], align: "center" },
							        { width: 50, id: "Version", header: [{ text: "${menu.LN00017}", align: "center" } ], align: "center" },
							        { width: 100, id: "ItemClassNM", header: [{ text: "${menu.LN00016}", align: "center" } ], align: "center" },
							        { width: 120, id: "Identifier", header: [{ text: "${menu.LN00106}", align: "center" } ], align: "left" },
							        { width: 150, id: "ItemName", header: [{ text: "${menu.LN00087}", align: "center" } ], align: "center" },
							        { width: 250, id: "ItemPath", header: [{ text: "${menu.LN00043}", align: "center" } ], align: "left" },
							       
							        { width: 70, id: "ValidFrom", header: [{ text: "${menu.LN00296}", align: "center" } ], align: "left", hidden: showValid != "Y" },
							        
							        { width: 100, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align: "center" } ], align: "left" },
							        { width: 130, id: "RegUserName", header: [{ text: "${menu.LN00060}", align: "center" } ], align: "left" },
							        { width: 60, id: "LanguageCode", header: [{ text: "${menu.LN00147}", align: "center" } ], align: "center" },
							        { width: 60, id: "DownCNT", header: [{ text: "${menu.LN00030}", align: "center" } ], align: "center" },
							        { width: 80, id: "FileStatus", header: [{ text: "${menu.LN00027}", align: "center" } ], align: "center" },
							        
							       
							        { width: 60, id: "Seq", header: [{ text: "Seq", align: "center" } ], align: "center", hidden: true },
							        { width: 60, id: "SysFile", header: [{ text: "SysFile", align: "center" } ], align: "center", hidden: true  },
							        { width: 60, id: "FltpCode", header: [{ text: "FltpCode", align: "center" } ], align: "center", hidden: true },
							        { width: 60, id: "FilePath", header: [{ text: "FilePath", align: "center" } ], align: "center", hidden: true  },
							        { width: 60, id: "DocumentID", header: [{ text: "DocumentID", align: "center" } ], align: "center", hidden: true  }
							    ],
							
							
						    autoWidth: true,
						    resizable: true,
						    selection: "row",
						    tooltip: false,
						    height: "100%",
						});
						
						grid.events.on("cellClick", function(row,column,e){
							
							// 체크박스 클릭 시 체크박스 토글 외 동작 X
							if (column.id == "checkbox") {
								return;
							}
							
							// 다운로드 아이콘 클릭 시 다운로드 실행
							if(column.id == "File"){
								var url  = "fileDownload.do?seq="+row.Seq+"&alertType=DHX";
								ajaxSubmitNoAdd(document.fileFrm, url,"subFrame"); 
							}
							
							var extFileURL = row.ExtFileURL;	
		
							// 파일 옵션이 ExtLink인 경우에 대한 처리 (현재는 테스트 중인 DB에선 OLM으로 되어있음)
							if(fileOption=="ExtLink"){
								var url  = row.ExtFileURL;						
								var w = 1200;
								var h = 900;
								url = url.replace(/&amp;/gi,"&");
								
								itmInfoPopup(url,w,h); 
								fnExtFileUpdateCount(row.Seq);
							} else {
								if(sessionAuthLevel != "SYS" && myItemYN != 'Y' && itemFileOption == "VIEWER"){
									showFileDetailPanel();	
								} else{
									showFileDetailPanel();					
								}
							}
							
							
							// 우측 파일 상세정보 패널 여는 함수
							async function showFileDetailPanel() {
								let html = '';
								html += '<div class="tabbar pdB20 pdL20 pdR20 border-section mgL20 h-100">'
								html += '<div class="align-center flex">'
								html += '<ul class="pdL0">';
								html += '<li class="flex align-center"><a class="tab--active flex align-center" onclick="selectFileTab(\'detail\', this)">상세 정보</a></li>';
								if(USE_FILE_LOG == "Y") html += '<li class="flex align-center"><a onClick="selectFileTab(\'log\', this)" class="flex align-center">활동</a></li>';
								html += '</ul>';
								html += '<svg xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 -960 960 960" width="20px" fill="#666666" onclick="hideFileDetailPanel()" class="cur-po"><path d="m291-240-51-51 189-189-189-189 51-51 189 189 189-189 51 51-189 189 189 189-51 51-189-189-189 189Z"/></svg>'
								html += '</div>'
								
								// api 호출
								const requestData = { seq : row.Seq , languageID };
								const params = new URLSearchParams(requestData).toString();
								const detailUrl = "getItemFileInfo.do?" + params;
								const logUrl = "getFileLog.do?" + params;
								let finalHtml = html;
								
								try {
							        const [detailRes, logRes] = await Promise.all([
							            fetch(detailUrl).then(r => r.json()),
							            USE_FILE_LOG == "Y" ? fetch(logUrl).then(r => r.json()) : Promise.resolve({data: []})
							        ]);
									
							        // 1. file detail
									finalHtml += '<div style="height: calc(100% - 61px);display: flex;flex-direction: column;justify-content: space-between;" id="detail-list" class="mgT10">';
									finalHtml += '<dl class="info-list">';
									finalHtml += '<dt>${menu.LN00101}</dt>';
									finalHtml += '<dd>'+detailRes.data.FileRealName+'</dd>';
									if(DocCategory == "ITM"){
										finalHtml += '<dt>${menu.LN00043}</dt>';
										finalHtml += '<dd style="color:#0054FF;text-decoration:underline;cursor:pointer;" onClick="fnOpenItemDetail(' +detailRes.data.DocumentID +')">'+detailRes.data.Path+'</dd>';
									}
									finalHtml += '<dt>${menu.LN00091}</dt>';
									finalHtml += '<dd>'+detailRes.data.FltpName+'</dd>';
									finalHtml += '<dt>${menu.LN00131}</dt>';
									if(DocCategory == "ITM"){
										finalHtml += '<dd>'+detailRes.data.ProjectName +'/'+ detailRes.data.CsrName+'</dd>';
									}
									finalHtml += '<dt>${menu.LN00060}</dt>';
									finalHtml += '<dd>'+detailRes.data.WriterName+'('+detailRes.data.TeamName+')'+'</dd>';
									finalHtml += '<dt>${menu.LN00017}</dt>';
									finalHtml += '<dd>'+detailRes.data.CSVersion+'</dd>';
									finalHtml += '<dt>${menu.LN00078}</dt>';
									finalHtml += '<dd>'+detailRes.data.CreationTime+'</dd>';
									finalHtml += '<dt>${menu.LN00070}</dt>';
									finalHtml += '<dd>'+detailRes.data.LastUpdated+'</dd>';		
									
									finalHtml += '<dt>${menu.LN00035}</dt>';
									
									if(selectedItemBlocked == '0' && detailRes.data.Blocked !== '2' && (selectedItemAuthorID == sessionUserId || sessionAuthLev == '1'))
										finalHtml += '<dd><textarea class="edit" id="Description" name="Description" style="width: 100%; height: 160px;" >' + (detailRes.data?.Description ?? '') + '</textarea></dd>';
									else
										finalHtml += '<dd>' + (detailRes.data?.Description ?? '') + '</dd>';								
									finalHtml += '</dl>';
									
									if(selectedItemBlocked == '0' && detailRes.data.Blocked !== '2' && (selectedItemAuthorID == sessionUserId || sessionAuthLev == '1')){
										finalHtml += '<div class="btn-wrap">';
										finalHtml += '<div class="btns">';
										
										if(detailRes.data.RevisionYN == 'Y') finalHtml += "<button class='secondary' onclick=\"saveNewFile('" + detailRes.data.RefFileID + "', '" + detailRes.data.FltpCode + "')\">Update</button>";
										else finalHtml += "<button class='secondary' onclick=\"modifyFile('"+ detailRes.data.Seq + "', '" +  detailRes.data.FltpCode + "')\">Update</button>";
										
										finalHtml += "<button class='secondary' onclick=\"saveFileDescription('" + detailRes.data.Seq + "', '" + detailRes.data.FltpCode + "')\">Save</button>";
										finalHtml += '</div>';
										finalHtml += '</div>';
									}
									
									finalHtml += '</div>';
									
							        // 2. log detail
							        if(USE_FILE_LOG == "Y") {
							            finalHtml += '<div id="log-list" style="display:none;" class="info-list">';
							            logRes.data.forEach(logItem => {
							            	finalHtml += '<div class="mem_list flex align-center mgT10">'
							  	    		finalHtml += '<div class="thumb mgR10" style="width: 30px;height: 30px;">'
							  	    		finalHtml += '<div class="initial_profile" style="background-color: rgb(134, 164, 212);">'
							  	    		finalHtml += '<em style="font-size: 15px;">'+logItem.Name.substring(0,1)+'</em>'
							  	    		finalHtml += '</div>'
							  	    		finalHtml += '</div>'
							  	    		finalHtml += '<div class="address_item_info">'
							  	    		finalHtml += '<p class="company_info">'+logItem.Time+'</p>'
							  	    		finalHtml += '<div class="name_info">'
							  	    		finalHtml += '<div class="name_txt">'
							  	    		finalHtml += '<font class="name">'+logItem.Name+'</font>'+'('+logItem.TeamName+')'+'님이 '+logItem.FileOption+'했습니다.'
							  	    		finalHtml += '</div>'
							  	    		finalHtml += '</div>'
							  	    		finalHtml += '</div>'
							  	    		finalHtml += '</div>'
							            });
							            finalHtml += '</div>';
							        }
									
							        // final
							        finalHtml += '</div>';

							        layout.getCell("show").attachHTML(finalHtml);
							        layout.getCell("show").show();

							    } catch (error) {
							        finalHtml += '</div>';
							        layout.getCell("show").attachHTML(finalHtml);
							        layout.getCell("show").show();
							    }
							}
						});
						
						 grid.events.on("filterChange", function(row,column,e,item){
							$("#TOT_CNT").html(grid.data.getLength());
						 });
						 
						 layout.getCell("a").attach(grid);
						 
						 if(pagination){pagination.destructor();}
						 pagination = new dhx.Pagination("pagination", {
						    data: grid.data,
						    pageSize: GRID_PAGE_SIZE,
						});
		        	}
					
					fnReloadGrid(result.data);
					
//	 				if(contextMenuOpener){
//	 					contextMenuOpener.addEventListener("click", (e) => {
//	 						document.querySelector(".context-menu").classList.toggle("open");
//	 				    })
//	 				}
					
					//if(document.querySelector(".empty-wrapper")) document.querySelector(".empty-wrapper").remove();
					document.querySelectorAll(".empty-wrapper").forEach(el => el.remove());
				} else {					
					if (pagination) {
					    pagination.destructor();
					    pagination = null;
					}
					
					if (grid) {
						grid.destructor();
						grid = null;
					}
					
					const emptyIcon = '<svg xmlns="http://www.w3.org/2000/svg" height="48px" viewBox="0 -960 960 960" width="48px" fill="#CCCCCC"><path d="M220-80q-24 0-42-18t-18-42v-680q0-24 18-42t42-18h361l219 219v521q0 24-18 42t-42 18H220Zm331-554v-186H220v680h520v-494H551ZM220-820v186-186 680-680Z"/></svg>'
					let buttonFunc = "";
					let buttonTitle = "";
					let buttonStyle = "";
					
					if("${myItem}" === "Y") {
						//buttonFunc = "uploadFile()";
						//buttonTitle = "Add File";
						//buttonStyle = "context-menu-opener primary";
					}
					
					$("#TOT_CNT").html(resultCount);		
					
					// document.querySelector("#layout").insertAdjacentHTML("beforeEnd", emptyPage(emptyIcon, "파일이 없습니다.", "파일을 등록해주세요.", buttonFunc, buttonTitle, buttonStyle));
					layout.getCell("a").attachHTML(
					  emptyPage(emptyIcon, "파일이 없습니다.", "", buttonFunc, buttonTitle, buttonStyle)
					);
					layout.getCell("show").hide();
					
				}
		        
			 } catch (error) {    	
				 console.log("fnFileReload error :"+error);
			    	handleAjaxError(error, "LN0014"); // 서버 내부 오류가 발생했습니다. 관리자에게 문의해주세요.
			 }
		}
		
		function handleAjaxError(err, errDicTypeCode) {
			console.error("handleAjaxError err :"+err);
			Promise.all([getDicData("ERRTP", errDicTypeCode), getDicData("BTN", "LN0034")])
					.then(([errDic, btnDic]) => showDhxAlert(errDic.LABEL_NM, btnDic.LABEL_NM));
		}
		
		function hideFileDetailPanel() {
			layout.getCell("show").hide();
		}
		
		function fnDownload(row){
		   var seq = row.Seq;
			var url  = "fileDownload.do?seq="+seq;
		
			 if( '${loginInfo.sessionMlvl}' != "SYS"){
				fnCheckUserAccRight(documentID, "fnFileDownloadRow("+seq+")", "${WM00033}");
			}else{
				fnFileDownloadRow(seq);
			} 
		}
		
		function fnFileDownload(){
			var cnt  = grid.data.findAll(function (data) {
				return data.RNUM; 
			});
			var originalFileName = new Array();
			var seq = new Array();
			var chkVal;
			var j =0;
			var itemIDs = new Array();
			var checkLength  = grid.data.findAll(function (data) {
				return data.checkbox; 
			});

			if (checkLength == 0) {
				alert("${WM00049}");
				return;
			}

			for(idx in checkLength){
				chkVal = checkLength[idx].checkbox;
				
				if(chkVal === true){
					originalFileName[j] = checkLength[idx].FileRealName; // orignalfile
					seq[j] =  checkLength[idx].Seq; 
					itemIDs[j] = checkLength[idx].DocumentID; 
					j++;
				}
			}
	
			if( '${loginInfo.sessionMlvl}' != "SYS"){
				fnCheckItemArrayAccRight(seq, itemIDs); // 접근권한 체크후 DownLoad
			}else{
				var url  = "fileDownload.do?seq="+seq;
				ajaxSubmitNoAdd(document.fileFrm, url,"subFrame");
			} 
		}

		// file upload callback
		function fnCallBack(){ 
			fnSearchList();
		}
		
	 	// 그리드에 표시되는 파일의 이름을 반환하는 함수
		// 새 파일 첨부 시도 시 프론트 딴 중복검사 위한 데이터를 구성해 previousAddedFileNames에 할당하는 용도로 사용됨
		function getGridFileNames() {
		    const allData = grid.data.serialize();
		    const fileNames = new Set(allData.map(item => item.FileRealName));
		    return fileNames;
		}

</script> 	

</html>
