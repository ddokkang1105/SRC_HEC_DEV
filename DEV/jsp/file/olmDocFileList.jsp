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
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00095" var="WM00095"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<link rel="stylesheet" href="${root}cmm/common/css/materialdesignicons.min.css"/>

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
	var screenType = "${screenType}";
	var isPublic = "${isPublic}";
	var myDoc = "${myDoc}";
	var fltpCode = "";
	var DocCategory = "${DocCategory}";
	var USE_FILE_LOG = "${USE_FILE_LOG}";	
	var sessionAuthLevel = "${sessionScope.loginInfo.sessionMlvl}";	
	var myItemYN = "${myItem}";	
	var refFileID = '';
	var fileID = '';	
	var multiFileUploadEnabled = true;
	var fileListYN = '${fileListYN}';
	
	$(document).ready(function(){
		$("#DocCategory").change(function(){
			DocCategory = $("#DocCategory").val();
			fltpCode = "";
			fnSelect('fltp','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&docCategory='+DocCategory,'getFltpByDocCategory','','Select', 'fileMgt_SQL');
		});
		
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 300)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 300)+"px;");
		};
		$("input.datePicker").each(generateDatePicker);
		$('.layout').click(function(){
			var changeLayout = $(this).attr('alt');
			setLayout(changeLayout);
		});
		
		if("${screenType}" == "main"){
			$("#searchKey").val("${searchKey}").attr("selected", "selected");
			$("#searchValue").val("${searchValue}");
			$("#fltp").val("${fltpCode}").attr("selected", "selected");
		}
		fnSelect('fltp','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&docCategory='+DocCategory,'getFltpByDocCategory','${fltpCode}','Select', 'fileMgt_SQL');
		
		fnSelect('DocCategory','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&dicCategory=${dicCategory}','getDicTypeCodeByDocCategory','${DocCategory}','Select', 'fileMgt_SQL');
		
		if(screenType == "mainV3" || screenType == "csrDtl"){ // mainHomeLayerV3			
			$("#parent").attr('disabled', 'disabled: disabled');
			fnGetCsrCombo("${parentID}");
		}else{
			fnSelect('parent','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&isDoc=Y','getProject',${parentID}'','Select');
		}
	
		if(screenType == "csrDtl"){
			fnSelect('project','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&projectID=${projectID}','getCsrOrder','${projectID}');		
		}else{
			fnSelect('project','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID=${parentID}','getCsrOrder','${projectID}','Select');
		}

		$("#excel").click(function(){
			fnGridExcelDownLoad();
		});
		
		$("#fltp").change(function() {
			fltpCode = $(this).val();
		});
		
		$('#searchClear').click(function(){
			clearSearchCon();
			return false;
		});
		
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
	
	function fnMultiUpload(){ 
		var browserType="";
		var agent = navigator.userAgent.toLowerCase();
		if ( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) ) {
			//browserType="IE";
		} 
		var url="addFilePop.do";
		var data="scrnType=ITM_M&browserType="+browserType+"&mgtId="+""+"&DocumentID=${projectID}&projectID=${projectID}&DocCategory=${DocCategory}&screenType="+screenType;
		
		if(browserType=="IE"){fnOpenLayerPopup(url,data,"",400,400);}
		else{openPopup(url+"?"+data,490,360, "Attach File");}
	}
	
	function fnGetCsrCombo(parentID){
		fnSelect('project','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID='+parentID,'getCsrOrder','${projectID}');
	}
		
	function fnDeleteFile(){
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		var chkVal;
		var j =0;	
		
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00095}");
			return;
		}
		
		grid.data.forEach(function(row){
			if(row.checkbox){
				sysFileName[j] = row.SysFile;
				filePath[j] = row.FilePath; // 파일경로
				seq[j] = row.Seq;
				j++
			}
		});	

		if(confirm("${CM00002}")){
			var url = "deleteFileFromLst.do";
			var data = "&sysFile=&filePath=&seq="+seq;
			var target = "subFrame";
			ajaxPage(url, data, target);	
		}
	}
	
	function clearSearchCon() {
		$("#DocCategory").val("");
		$("#fltp").val("");
		$("#REG_STR_DT").val("");
		$("#REG_END_DT").val(""); 
		$("#regMemberName").val("");
		$("#parent").val("");
		$("#project").val("");
		$("#searchValue").val("");
		$("#path").val("");
	}
</script>
</head>
<body>
<div class="pdL10 pdR10">
<form name="fileMgtFrm" id="fileMgtFrm" action="#" method="post" onsubmit="return false;" >
<c:if test="${screenType != 'csrDtl'}" >
<div class="cop_hdtitle">
		<h3 style="padding: 6px 0"><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png">&nbsp;&nbsp;${menu.LN00019}</h3>
</div>
<div style="width:100%">
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search mgT5 mgB5" id="search">
	<colgroup>
		<col width="6%">
	    <col width="18%">
		<col width="6%">
	    <col width="18%">
		<col width="6%">
	    <col width="18%">
		<col width="6%">
	    <col width="18%">
    </colgroup>
    <tr>
    	<!-- 범주 -->
       	<th class="alignL pdL10">${menu.LN00099}</th>
        <td class="alignL pdL10"> 
	       	<select id="DocCategory" Name="DocCategory" class="sel" style="width:98%;"></select>
       	</td>       
   		<!-- 문서유형 -->
       	<th class="alignL pdL10">${menu.LN00091}</th>
        <td class="alignL pdL10"> 
	       	<select id="fltp" Name="fltp" class="sel" style="width:98%;"></select>
       	</td>       	
        <!-- 수정일-->
        <th class="alignL pdL10">${menu.LN00070}</th>     
        <td class="alignL pdL10">     
            <input type="text" id="REG_STR_DT" name="REG_STR_DT" value="${beforeYmd}"	class="input_off datePicker stext" size="8"
				style="width: 35%;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
			
			~
			<input type="text" id="REG_END_DT" name="REG_END_DT" value="${thisYmd}"	class="input_off datePicker stext" size="8"
				style="width: 35%;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
			
         </td> 
         <!-- 작성자 -->
        <th class="alignL pdL10">${menu.LN00060}</th>
        <td class=" alignL pdL10"><input type="text" id="regMemberName" name="regMemberName" class="text" style="width:98%;ime-mode:active;" ></td>      
	</tr>
    <tr>     
		<!-- 프로젝트 -->
       	<th class="alignL pdL10 ">${menu.LN00131}</th>
        <td class="alignL pdL10 "> 
        	<c:if test="${screenType != 'mainV3' && screenType != 'csrDtl'}" >
        		<select id="parent" Name="parent" onChange="fnGetCsrCombo(this.value)" class="sel" style="width:98%;"></select>
        	</c:if>
        	<c:if test="${screenType == 'mainV3'}" >
        		 <select id="parent" Name="parent" class="sel" style="width:98%;">
	       		<option value="${projectMap.ProjectID}" selected="selected">${projectMap.ProjectName}</option>
	       	</select>
        	</c:if>
       	</td>
       	<!-- 변경오더 -->
       	<th class="alignL pdL10 ">${menu.LN00191}</th>
        <td class="alignL pdL10 ">
        	<select id="project" Name="project" class="sel" style="width:98%;">
        		<option value="">Select</option>
        	</select>
        </td>
        <th class="alignL pdL10 ">
        	<select id="searchKey" name="searchKey" class="sel">
				<option value="Name">${menu.LN00101}</option>
				<option value="Info" 
					<c:if test="${searchKey == 'Info'}"> selected="selected"</c:if>>
					${menu.LN00003}
				</option>					
			</select>
        </th>
		<td class="pdL10 alignL">	
	   		<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text">
	   	 </td>
	   	 <th class="alignL pdL10">${menu.LN00043}</th>
	   	 <td class="alignL pdL10">
	   	 	<input type="text" id="path" name="path" class="text">
	   	 </td>
      </tr>
  	</table>  	 
  	<div class="mgT5" align="center">
       	<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search"  onclick="fnSearchList()"/>
       	<input type="image" id="searchClear" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;">
	</div>
  </div>
  </c:if>
  <div class="countList">
    	<li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR mgT2">
        	<c:if test="${screenType == 'csrDtl' && csrEditable == 'Y' }">
		   	  	<span class="btn_pack medium icon"><span class="upload"></span><input value="Upload" type="button" onclick="fnMultiUpload()"></span>
				<span class="btn_pack medium icon"><span class=del></span><input value="Del" type="submit" onclick="fnDeleteFile()"></span>	   	  
		   	 </c:if>	
		   		   	
        	<span class="btn_pack medium icon"><span class="download"></span>
			<input value="Download" type="button" onclick="fnFileDownload()"></span>
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span></li>
    </div>
	<div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>	
</form>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</div>
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
	 		grid.data.parse(newGridData);
	 		$("#TOT_CNT").html(grid.data.getLength());
	 		previousAddedFileNames = getGridFileNames();
	 		if (pagination && grid.data.getInitialData().length < 50) {
 			  pagination.destructor();
 			  pagination = null;
 			}
	 	}
		
	 	const changeEvent = document.createEvent("HTMLEvents");
		changeEvent.initEvent("change", true, true);
		
		// file list reload
		var sqlID = "fileMgt_SQL.getFile";	 
		var languageID = '${sessionScope.loginInfo.sessionCurrLangType}';
		async function fnSearchList(){
			let requestData = null;
			if(screenType == "csrDtl"){
				requestData = { 
					languageID : languageID,
					authLev: '${sessionScope.loginInfo.sessionAuthLev}',
					screenType : screenType,
					isPublic : isPublic,
					myDoc : myDoc,
					DocCategory : DocCategory,
					regMemberName : $("#regMemberName").val(),
					sqlID : sqlID,
					projectID: '${projectID}',
					refPjtID: '${refPjtID}',
				}
			}else{
				requestData = { 
					languageID : languageID,
					authLev: '${sessionScope.loginInfo.sessionAuthLev}',
					screenType : screenType,
					isPublic : isPublic,
					myDoc : myDoc,
					DocCategory : DocCategory,
					regMemberName : $("#regMemberName").val(),
					fltpCode : $("#fltp").val(),
					sessionUserId : '${sessionScope.loginInfo.sessionUserId}',
					sqlID : sqlID,	
					
					projectID: $("#project").val(),
					refPjtID: $("#parent").val(),
					updatedStartDT: $("#REG_STR_DT").val(),
					updatedEndDT: $("#REG_END_DT").val(),
					path: $("#path").val(),
					searchKey: $('#searchKey').val(),
					searchValue: $('#searchValue').val(),
					
				}
			};
			
			try {
		        
				const params = new URLSearchParams(requestData).toString();
			    //const url = "getItemFileListInfo.do?" + params; // jsonDhtmlxListJson
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
		        	$("#layout").attr("style","height:"+(setWindowHeight() - 230)+"px;");
		        	
		        	if(!grid) {	
						grid = new dhx.Grid(null, {
						    columns: [
						        { width: 50, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center", template: function (text, row, col) { return row.RNUM;} },
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
						        { id: "FileRealName", header: [{text: "${menu.LN00101}", align:"center"},{content : "inputFilter"}], align:"left" },	  					       
						        { width: 100, id: "CSVersion", header: [{ text: "Version", align:"center" },{content: "selectFilter"}], align: "center"},
						        { width: 140, id: "FltpName", header: [{ text: "${menu.LN00091}", align:"center" },{ content: "selectFilter"} ], align: "center"},
						        { width: 180, id: "FilePath", header: [{ text: "${menu.LN00171}", align:"center" },{ content: "selectFilter"} ], align: "left"},
						        { width: 90, id: "LanguageCode",   header: [{ text: "${menu.LN00147}", align:"center"},{ content : "selectFilter" }], align:"center" },	        
						        { width: 90, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align:"center" }], align:"center" },
						        { width: 150, id: "WriteUserNM", header: [{ text: "${menu.LN00060}", align:"center" }], align:"center" },
						        { width: 120, id: "TeamName", header: [{ text: "${menu.LN00018}", align:"center" }], align:"center" },
						        { width: 80, id: "DownCNT", header: [{ text: "${menu.LN00030}", align:"center" }], align:"center" },
						        { width: 80, id: "FileStatus", header: [{text: "${menu.LN00027}", align:"center" },{content : "selectFilter"}], align:"center"},
						        { width: 80, id: "Seq", header: [{ text: "Seq", align:"center" }], align:"center" , hidden:true},
						        { width: 80, id: "RefFileID", header: [{text: "ROOT", align:"center"},{content : "selectFilter"}], align:"center", hidden:true},
						        
						        { id: "Blocked", header: [{text: "Blocked"}], align:"center" ,hidden:true },	 	        
						        { id: "SysFile", header: [{text: "SysFile"}], hidden:true},
						        { id: "FileName", header: [{text: "FileName"}], hidden:true},
						        { id: "FltpCode", header: [{text: "FltpCode"}], hidden:true},
						        { id: "FilePath", header: [{text: "FilePath"}], hidden:true},
						        { id: "DcumentID", header: [{text: "DocumentID"}], hidden:true},
						        { id: "ExtFileURL", header: [{text: "ExtFileURL"}], hidden:true}
						          
						    ],
						    autoWidth: true,
						    resizable: true,
						    selection: "row",
						    tooltip: false,
						    height: "auto",
						});
						
						grid.events.on("cellClick", function(row,column,e){
							
							// 체크박스 클릭 시 체크박스 토글 외 동작 X
							if (column.id == "checkbox") {
								return;
							}
							
							// 다운로드 아이콘 클릭 시 다운로드 실행
							if(column.id == "File"){
								var url  = "fileDownload.do?seq="+row.Seq+"&alertType=DHX";
								ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
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
						    pageSize: 50,
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
				ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
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