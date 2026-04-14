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

<script type="text/javascript">
	var now;
	var listScale = "<%=GlobalVal.LIST_SCALE%>";
	var screenType = "${screenType}";
	var isPublic = "${isPublic}";
	var myDoc = "${myDoc}";
	var fltpCode = "";
	var DocCategory = "${DocCategory}";
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
			fnSelect('parent','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&isDoc=Y','getProject','Select');
		}
	
		if(screenType == "csrDtl"){
			fnSelect('project','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&projectID=${projectID}','getCsrOrder','${projectID}');		
		}else{
			fnSelect('project','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID=${parentID}','getCsrOrder','${projectID}','Select');
		}
		/* gridInit();		
		doSearchList(); */
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
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
			
	function doSearchList(){ 
		if($("#REG_STR_DT").val() != "" && $("#REG_END_DT").val() == "")		$("#REG_END_DT").val(new Date().toISOString().substring(0,10));
		
		var sqlID = "fileMgt_SQL.getFile";
		var param = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&pageNum=" + $("#currPage").val()
			+ "&authLev=${sessionScope.loginInfo.sessionAuthLev}"
			//+ "&parentID="+ $("#parent").val()				
			+ "&screenType="+screenType			
			+ "&isPublic="+isPublic
			+ "&myDoc="+myDoc
			+ "&DocCategory="+ DocCategory
			+ "&regMemberName="+$("#regMemberName").val()
			+ "&sqlID="+sqlID;
		if(screenType == "csrDtl"){
			param += "&projectID=${projectID}";
			param += "&refPjtID=${refPjtID}";
		}else{
			param += "&projectID="+ $("#project").val();
			param += "&refPjtID="+ $("#parent").val();
			param += "&updatedStartDT="+ $("#REG_STR_DT").val();
			param += "&updatedEndDT="+ $("#REG_END_DT").val();
			param += "&path="+ $("#path").val();
		}
		
		if(screenType != "csrDtl"){
			param += "&searchKey="+ $("#searchKey").val();
			param += "&searchValue=" + $("#searchValue").val();
			param += "&fltpCode="+ $("#fltp").val();
		}
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){		
				fnReloadGrid(result);		
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
	}
	
	function fnFileDownload(){
		var originalFileName = new Array();
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
				originalFileName[j] = row.FileRealName;
				seq[j] = row.Seq;
				j++
			}
		});	
		
		var url  = "fileDownload.do?seq="+seq;
		var frmType = "${frmType}";
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
	
	function goNewItemInfo() {
		var url = "NewItemInfoMain.do";
		var target = "actFrame";
		var data = "s_itemID=${DocumentID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}"; 
	 	ajaxPage(url, data, target);
	}
	
	function fnGetCsrCombo(parentID){
		fnSelect('project','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID='+parentID,'getCsrOrder','${projectID}');
	}
	
	// file upload callback
	function fnCallBack(){ 
		doSearchList();
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
	<input type="hidden" id="itemId" name="itemId" value="${itemId}">
	<input type="hidden" id="itemAthId" name="itemAthId" value="${itemAthId}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
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
       	<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search"  onclick="doSearchList()"/>
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
	<!-- START :: PAGING -->
	<div id="pagination"></div>
	<!-- END :: PAGING -->		
</form>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</div>
<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var gridData = ${gridData};
		var grid = new dhx.Grid("", {
		    columns: [
		        { width: 40, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
		        { width: 30, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center" }], align: "center", type: "boolean", editable: true, sortable: false},
		        { width: 140, id: "FltpName", header: [{ text: "${menu.LN00091}", align: "center" } ], align: "left" },
	        
		        { width: 40, id: "down", header: [{ text: "File", align:"center" }], htmlEnable: true, align: "center",
		        	template: function (text, row, col) {
		        		return '<img src="${root}${HTML_IMG_DIR}/btn_file_down.png" width="24" height="24">';
		            }
		        },
		        { width: 440, id: "FileRealName", header: [{ text: "${menu.LN00101}", align: "center" } ], align: "left" },
		        { id: "Path", header: [{ text: "${menu.LN00102}", align: "center" } ], align: "left" },
		        { width: 60, id: "LanguageCode", header: [{ text: "${menu.LN00147}", align: "center" } ], align: "center" },
		        { width: 80, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align: "center" } ], align: "center" },
		        { width: 120, id: "WriteUserNM", header: [{ text: "${menu.LN00060}", align: "center" } ], align: "center" },
		        { width: 100, id: "TeamName", header: [{ text: "${menu.LN00104}", align: "center" } ], align: "center" },
		        { width: 60, id: "DownCNT", header: [{ text: "${menu.LN00030}", align: "center" } ], align: "center" },
		        { hidden: true, width: 50, id: "Seq", header: [{ text: "Seq", align: "center" } ], align: "left" },
		        { hidden: true, width: 60, id: "SysFile", header: [{ text: "SysFileWidthPath", align: "center" } ], align: "center" },
		        { hidden: true, width: 80, id: "FileName", header: [{ text: "FileRealName", align: "center" } ], align: "left" },
		        { hidden: true, width: 80, id: "FltpCode", header: [{ text: "FltpCode", align: "center" } ], align: "center" },
		        { hidden: true, width: 80, id: "FilePath", header: [{ text: "FilePath", align: "center" } ], align: "center" },
		        { hidden: true, width: 80, id: "DocumentID", header: [{ text: "DocumentID", align: "center" } ], align: "center" },
		        { hidden: true, width: 80, id: "ClassCode", header: [{ text: "ClassCode", align: "center" } ], align: "center" },
	       
	
		    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    data: gridData
		});
	
		layout.getCell("a").attach(grid);
		$("#TOT_CNT").html(grid.data.getLength());
	
		var pagination = new dhx.Pagination("pagination", {
			data: grid.data,
			pageSize: listScale,
		});
		
		grid.events.on("cellClick", function(row,column,e){
		if(column.id == "down"){ // 다운로드 이미지 클릭시 
			var originalFileName = row.FileRealName;
			var sysFileName = row.SysFile;
			var seq = row.Seq;
			var url  = "fileDownload.do?seq="+seq;
			var frmType = "${frmType}";		
			ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
		}else if(column.id != "checkbox"){
			var isNew = "N";
			var seq = row.Seq;
			var fileName =  row.FileName;
			var fltpCode =  row.FltpCode;
			var creationTime  =  row.CreationTime;
			var writeUserNM = row.WriteUserNM;
			var sysFile = row.SysFile; //sysfile 
			var fltpName = row.FltpName;
			var DocumentID = row.DocumentID;
			var classCode = row.ClassCode;
			var path = row.Path;
			var itemAthId = $('#itemAthId').val();
			var userId = "${sessionScope.loginInfo.sessionUserId}";
			var Blocked = "${Blocked}";
			var Authority = "${sessionScope.loginInfo.sessionAuthLev}";
			var LockOwner = "${LockOwner}";
			var parentID = "${parentID}";
		
			var url  = "documentDetail.do?isNew"+isNew+"&seq="
					+seq+"&DocumentID="+DocumentID+"&pageNum="+$("#currPage").val()
					+"&itemTypeCode=${itemTypeCode}&fltpCode="+fltpCode+"&classCode="+classCode+"&myDoc="+myDoc+"&screenType="+screenType+"&parentID="+parentID+"&isMember=${isMember}&path="+encodeURIComponent(path);
	
			var w = 1200;
			var h = 500;
			itmInfoPopup(url,w,h); 
		}
	});
	
	function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
		fnMasterChk('');
		$("#TOT_CNT").html(grid.data.getLength());
	}
</script>
</body>
</html>