<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html>
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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033"/>
<!-- Dhtmlx grid  upgrade  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">

	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	var now;
	var listScale = "<%=GlobalVal.LIST_SCALE%>";
	var screenType = "${screenType}";
	var isPublic = "${isPublic}";
	var docType = "${docType}";
	var fltpCode = "";
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		};
		$("input.datePicker").each(generateDatePicker);
		$('.layout').click(function(){
			var changeLayout = $(this).attr('alt');
			setLayout(changeLayout);
		});

		fnSelect('fltp','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&docCategory=${DocCategory}','getFltpByDocCategory','${fltpCode}','Select', 'fileMgt_SQL');
		
		if(screenType != "csrDtl") fnSelect('languageID', "", 'langType', '${sessionScope.loginInfo.sessionCurrLangType}', 'Select');
		
		if("${screenType}" == "main"){
			$("#searchKey").val("${searchKey}").attr("selected", "selected");
			$("#searchValue").val("${searchValue}");
			fltpCode = "${fltpCode}";
			$("#regMemberName").val("${regMemberName}");
		}
		if(screenType == "csrDtl"){ // mainHomeLayerV3			
			$("#parent").attr('disabled', 'disabled: disabled');
			fnGetCsrCombo("${parentID}");
		}else{
			fnSelect('parent','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&isDoc=Y','getProject','${parentID}');
		}
	
		if(screenType == "csrDtl"){
			fnSelect('project','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&projectID=${projectID}','getCsrOrder','${projectID}');		
		}else{
			fnSelect('project','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID=${parentID}','getCsrOrder','${projectID}','Select');
		}
		
		$("#excel").click(function(){
			console.log("작동");
			 fnGridExcelDownLoad(grid);
		});
		
		$("#fltp").change(function() {
			fltpCode = $(this).val();
		});
		
		$('#searchClear').click(function(){
			clearSearchCon();
			return false;
		});

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
 	
	// function fnCheckedRow(id){
	// 	p_gridArea.setCheckedRows(id,0);
	// }
	
	function fnFileDownloadRow(seq){
		var url = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
	}
	
	
	function fnCheckItemArrayAccRight(seq, itemIDs){
		$.ajax({
			url: "checkItemArrayAccRight.do",
			type: 'post',
			data: "&itemIDs="+itemIDs+"&seq="+seq,
			error: function(xhr, status, error) { 
			},
			success: function(data){				
				data = data.replace("<script>","").replace(";<\/script>","");		
				fnCheckAccCtrlFileDownload(data, seq);
			}
		});	
	}
	
	function fnCheckAccCtrlFileDownload(data, seq){
		var dataArray = data.split(",");
		var accRight = dataArray[0];
		var fileName = dataArray[1];
		
		if(accRight == "Y"){
			var url  = "fileDownload.do?seq="+seq;
			var frmType = "${frmType}";
			ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
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
	
	
	
	function fnMultiUpload(){ 
		var browserType="";
		var agent = navigator.userAgent.toLowerCase();
		if ( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) ) {
			//browserType="IE";
		} 
		var url="addFilePop.do";
		var data="scrnType=ITM_M&delTmpFlg=Y&browserType="+browserType+"&mgtId="+""+"&id=${projectID}&projectID=${projectID}&docCategory=${DocCategory}&fltpCode=CSRDF&screenType="+screenType;
		
		if(browserType=="IE"){fnOpenLayerPopup(url,data,"",400,400);}
		else{openPopup(url+"?"+data,490,360, "Attach File");}
	}
	
	function fnMultiUploadV4(){ 
		var url="addFilePopV4.do";
		var data="scrnType=ITM_M&delTmpFlg=Y&mgtId="+""+"&id=${projectID}&projectID=${projectID}&docCategory=${DocCategory}&fltpCode=CSRDF&screenType="+screenType;
		openPopup(url+"?"+data,480,450, "Attach File");
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
	
	
	function fnDeleteFile(){
		var fileDatas  = grid.data.findAll(function(data){
			return data.checkbox;
		});
		var cnt = fileDatas.length;
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		var chkVal;
		var j =0;	
		
		if (cnt == 0) {
		 	alert("${WM00095}");
			return;
		 }

		 for(idx in fileDatas){
			chkVal = fileDatas[idx].checkbox;

		 	if(chkVal === true ){			
		 		sysFileName[j] = fileDatas[idx].SysFile; //sysfile
		 		filePath[j] = fileDatas[idx].FilePath; // 파일경로
		 		seq[j] = fileDatas[idx].Seq; 
		 		j++;
		 	}
		 }	

		 if(confirm("${CM00002}")){
		 	var url = "deleteFileFromLst.do";
		 	var data = "&sysFile=&filePath=&seq="+seq;
			var target = "subFrame";
		 	ajaxPage(url, data, target);	
		 }
	}
	
	
	function fnDeleteFileHtml(seq){	
		var divId = "divDownFile"+seq;
		$('#'+divId).hide();
	}
	
	function clearSearchCon() {
		$("#DocCategory").val("");
		$("#fltp").val("");
		$("#searchValue").val("");
		$("#REG_STR_DT").val("");
		$("#REG_END_DT").val("");
		$("#regMemberName").val("");
		$("#parent").val("");
		$("#project").val("");
		$("#searchValue").val("");
		$("#searchKey").val("Name");
		doSearchList();
	}

</script>
</head>
<body>
<div class="pdL10 pdR10" style="background:#fff;height:100%;">
<form name="fileMgtFrm" id="fileMgtFrm" action="#" method="post" onsubmit="return false;" >
	<input type="hidden" id="itemId" name="itemId" value="${itemId}">
	<input type="hidden" id="itemAthId" name="itemAthId" value="${itemAthId}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	
<c:if test="${screenType != 'csrDtl'}" >
<div class="cop_hdtitle">
		<h3 style="padding: 6px 0"><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png">&nbsp;&nbsp;${menu.LN00019}</h3>
</div>
<div style="width:100%">
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search mgT5" id="search">
	<colgroup>
	    <col width="9%">
		<col width="22%">
		<col width="9%">
		<col width="22%">
		<col width="9%">
		<col width="5%">
		<col width="9%">
		<col width="29%">
    </colgroup>
   
    <tr>
   		<!-- 문서유형 -->
       	<th class="alignL pdL10 ">${menu.LN00091}</th>
        <td class="alignL pdL10"> 
	       	<select id="fltp" Name="fltp" class="sel" style="width:98%;"></select>
       	</td>       	
        <!-- 수정일-->
        <th class="alignL pdL10">${menu.LN00070}</th>     
        <td class="alignL pdL10">     
            <input type="text" id="REG_STR_DT" name="REG_STR_DT" value="${beforeYmd}"	class="input_off datePicker stext" size="8"
				style="width: 39.25%;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
			
			~
			<input type="text" id="REG_END_DT" name="REG_END_DT" value="${thisYmd}"	class="input_off datePicker stext" size="8"
				style="width: 39.25%;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
			
         </td> 
         <!-- 작성자 -->
        <th class="alignL pdL10">${menu.LN00060}</th>
        <td class=" alignL pdL10" colspan=3><input type="text" id="regMemberName" name="regMemberName" class="stext"></td>   
	</tr>
    <tr>
		<!-- 프로젝트 -->
       	<th class="alignL pdL10">${menu.LN00131}</th>
        <td class="alignL pdL10"> 
        	<c:if test="${screenType != 'mainV3' && screenType != 'csrDtl'}" >
        		<select id="parent" Name="parent" onChange="fnGetCsrCombo(this.value)" class="sel" style="width:98%;"></select>
        	</c:if>
        	<c:if test="${screenType == 'pjpInfoMgt'}" >
        		 <select id="parent" Name="parent" class="sel" style="width:98%;">
	       		<option value="${projectMap.ProjectID}" selected="selected">${projectMap.ProjectName}</option>
	       	</select>
        	</c:if>
       	</td>
       	<!-- 변경오더 -->
       	<th class="alignL pdL10">${menu.LN00191}</th>
        <td class="alignL pdL10">
        	<select id="project" Name="project" class="sel" style="width:98%;">
        		<option value="">Select</option>
        	</select>
        </td>
        
        <th class="alignL pdL10">${menu.LN00147}</th>
        <td class="alignL pdL10">     
	       	<select id="languageID" Name="languageID" >
	       		<option value=''>Select</option>
	       	</select>
       	</td>
       	
        <th class="alignL pdL10">
        	<select id="searchKey" name="searchKey" class="sel">
				<option value="Name">${menu.LN00002}</option>
				<option value="Info" 
					<c:if test="${searchKey == 'Info'}"> selected="selected"</c:if>>
					${menu.LN00003}
				</option>					
			</select>
        </th>        
		<td class="pdL10 alignL ">
	   		<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="stext" style="width:96%">
	   	 </td>
	   	 
      </tr>
  	</table>  	 
  	<div class="mgT5" align="center">
   	    <input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchList()" value="Search" />&nbsp;&nbsp;
   	    <input type="image" id="searchClear" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;">
  	</div>
  </div>
  </c:if>
    	<li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR mgT2">
        	<c:if test="${screenType == 'csrDtl' && csrEditable == 'Y' }">
		   	  	<!-- <span class="btn_pack medium icon"><span class="upload"></span><input value="Upload" type="button" onclick="fnMultiUpload()"></span> -->
		   	  	<span class="btn_pack medium icon"><span class="upload"></span><input value="Upload" type="button" onclick="fnMultiUploadV4()"></span>
				<span class="btn_pack medium icon"><span class=del></span><input value="Del" type="submit" onclick="fnDeleteFile()"></span>	   	  
		   	 </c:if>	
		   		   	
        	<span class="btn_pack medium icon"><span class="download"></span>
			<input value="Download" type="button" onclick="fnFileDownload()"></span>
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span></li>
		<div id="gridDiv" class="mgB10 clear">
			<div id="grdGridArea" style="width: 100%"></div>
		<div id="pagination?"></div></div>
	</div>		
</div>
</form>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</div>
</body>

<script type="text/javascript">
		var layout = new dhx.Layout("grdGridArea", {
			rows : [ {
				id : "a",
			}, ]
		});	
		var gridData = ${gridData}; 

		var grid = new dhx.Grid(null, {
			  columns: [
			        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
			        { width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>",align: "center", htmlEnable: true}], align: "center", type: "boolean", editable: true, sortable: false},
			        { width: 150, id: "FltpName", header: [{ text: "${menu.LN00091}" , align: "center"}], align: "center"},
			        { width: 50, id: "down", header: [{ text: "File" , align: "center" }],htmlEnable: true, align: "center",
			        	template: function (text, row, col) {
			        		return '<img src="${root}${HTML_IMG_DIR}/btn_file_down.png"  width="18" height="18" onclick="fnDownload()" />';
			            }
			        },
			        { width:500, id: "FileRealName", header: [{ text: "${menu.LN00101}" , align: "center" }], align: "left"},
			        { width:500, id: "Path", header: [{ text: "${menu.LN00102}" , align: "center" }], align: "left"},
			        { width: 50, id: "LanguageCode", header: [{ text: "${menu.LN00147}" , align: "center" }], align: "center" },
			        { width: 120, id: "LastUpdated", header: [{ text: "${menu.LN00070}" , align: "center" }], align: "center" },
			        { width: 140, id: "WriteUserNM", header: [{ text: "${menu.LN00060}" , align: "center" }], align: "center" },
			        { width: 80, id: "TeamName", header: [{ text: "${menu.LN00104}" , align: "center" }], align: "center"},
			        { width: 50, id: "DownCNT", header: [{ text: "${menu.LN00030}" , align: "center" }], align: "center"},
			        { hidden:true, width: 0, id: "Seq", header: [{ text: "Seq" , align: "center" }], align: "center"},
			        { hidden:true, width: 0, id: "SysFile", header: [{ text: "SysFileWidthPath" , align: "center" }], align: "center" },
			        { hidden:true, width: 0, id: "FileName", header: [{ text: "FileRealName" , align: "center" }], align: "center" },
			        { hidden:true, width: 0, id: "FltpCode", header: [{ text: "FltpCode" , align: "center" }], align: "center" },
			        { hidden:true, width: 0, id: "FilePath", header: [{ text: "FilePath" , align: "center" }], align: "center" },
			        { hidden:true, width: 0, id: "DocumentID", header: [{ text: "DocumentID" , align: "center" }], align: "center" },
			        { hidden:true, width: 0, id: "ClassCode", header: [{ text: "ClassCode" , align: "center" }], align: "center" },
			    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    data: gridData
		});
		
		layout.getCell("a").attach(grid);
		
		var pagination = new dhx.Pagination("grdGridArea", {
		    data: grid.data,
		    pageSize: 20,
		 
		});	
		
		$("#TOT_CNT").html(grid.data.getLength());
		
		
		grid.data.sort({
		    by: "RNUM",
		    dir: "asc"
		})
		
		//row선택 이벤트
		grid.events.on("cellClick", function(row, column, e) {
		    if (column.id ==="down") {
		    	fnDownload(row);
		    }else{
		    	if(column.id !="checkbox"){
		    		
					var seq = row.Seq;
					var documentID = row.DocumentID;
	
					if('${loginInfo.sessionMlvl}'!="SYS"){
						fnCheckUserAccRight(documentID, "fnDocumentDetail("+seq+","+documentID+")", "${WM00033}");
					}else{
						fnDocumentDetail(seq, documentID );
					}
		    	}

			}
		});

		function fnDocumentDetail(seq, documentID ){
		var isNew = "N";					
		var url  = "documentDetail.do?isNew"+isNew
				+"&seq="+seq+"&DocumentID="+encodeURIComponent(documentID)
				+"&pageNum=" +$("#currPage").val()
				+"&itemTypeCode=${itemTypeCode}&fltpCode=${fltpCode}"
				+"&docType=" + encodeURIComponent(docType)
				+"&screenType=" + encodeURIComponent(screenType)
				+"&isMember=" + encodeURIComponent("${isMember}");
		var w = 1200;
		var h = 500;
		itmInfoPopup(url,w,h); 
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
				var frmType = "${frmType}";
				ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
			} 
		}

		// file upload callback
		function fnCallBack(){ 
			doSearchList();
		}

		//조회
	 	function doSearchList(){ 
	 		var screenType = "${screenType}";
	 		var isPublic = "${isPublic}";
			if($("#REG_STR_DT").val() != "" && $("#REG_END_DT").val() == ""){
				$("#REG_END_DT").val(new Date().toISOString().substring(0,10));
			}	

			var sqlID = "fileMgt_SQL.getFile";
			var myDoc = "";
			if(docType ==="myDoc"){
				myDoc = "Y";
			}	

			var param ="pageNum="+$("#currPage").val()
						+"&authLev=&authLev=${sessionScope.loginInfo.sessionAuthLev}"
						+ "&screenType="+screenType			
						+ "&isPublic="+isPublic
						+ "&DocCategory=${DocCategory}"
						+ "&showFilePath=N"
						+ "&sqlID="+sqlID
						+ "myDoc="+myDoc;    
						
			if(screenType == "csrDtl"){
				param += "&projectID=${projectID}";
				param += "&refPjtID=${refPjtID}";
			}else{
				param += "&refPjtID="+ $("#parent").val(); //프로젝트
				param += "&projectID="+ $("#project").val(); //변경오더
				param += "&updatedStartDT="+ $("#REG_STR_DT").val();
				param += "&updatedEndDT="+ $("#REG_END_DT").val();
				param += "&searchKey="+ $("#searchKey").val();
				param += "&searchValue=" + $("#searchValue").val();
				param += "&regMemberName="+$("#regMemberName").val();
				param += "&fltpCode=" + $("#fltp").val();
			}
			
			if(screenType != "csrDtl" && $("#languageID").val() != "") {
				param += "&languageID=" + $("#languageID").val();
			}else {
				param += "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
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
	 	
		function fnReloadGrid(newGridData){
	 		grid.data.parse(newGridData);
	 		grid.data.sort({
			    by: "RNUM",
			    dir: "asc"
			})
			$("#TOT_CNT").html(grid.data.getLength());
	 		fnMasterChk('');
	 	}
		
</script>
</html>