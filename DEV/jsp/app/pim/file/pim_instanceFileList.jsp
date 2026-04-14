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
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00123" var="WM00123"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00021" var="WM00021" arguments="Mod "/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>


<script type="text/javascript">

	var gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	var fileOption = "${fileOption}";
	var itemFileOption = "${itemFileOption}";
	var schCntnLayout;	//layout적용
	var now;
	
	var userId = "${sessionScope.loginInfo.sessionUserId}";
	
	var Authority = "${sessionScope.loginInfo.sessionAuthLev}";
	var selectedItemLockOwner = "${selectedItemLockOwner}";
	var selectedItemAuthorID = "${selectedItemAuthorID}";
	var selectedItemBlocked = "${selectedItemBlocked}";
	var selectedItemStatus = "${selectedItemStatus}";
	var varFilter = "${varFilter}";
	var itemFileOption = "${itemFileOption}";
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#gridArea").attr("style","height:"+(setWindowHeight() - 160)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#gridArea").attr("style","height:"+(setWindowHeight() - 160)+"px;");
		};		
		gridInit();		
		doSearchList();
		$("#excel").click(function(){
			doExcel();
		});
	});
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	function doSearchList(){
		var d = setGridData();
		//fnLoadDhtmlxGridJson(gridArea, d.key, d.cols, d.data, false,"", $("#totalPage").val(),"","doReturnGridSet();");
		fnLoadDhtmlxGridJson(gridArea, d.key, d.cols, d.data);
	}
	
	function gridInit(){	
		var d = setGridData();
		var varFilter = "${varFilter}";
		gridArea = fnNewInitGrid("gridArea", d);
		gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		gridArea.setIconPath("${root}${HTML_IMG_DIR}/btn_file_down.png");

		fnSetColType(gridArea, 1, "ch");
		fnSetColType(gridArea, 3, "img");
		gridArea.setColumnHidden(5, true);
		gridArea.setColumnHidden(11, true);
		gridArea.setColumnHidden(12, true);
		gridArea.setColumnHidden(13, true);
		gridArea.setColumnHidden(14, true);
		gridArea.setColumnHidden(15, true);
		gridArea.setColumnHidden(16, true);
		gridArea.setColumnHidden(17, true);
		gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind,varFilter);});						
		gridArea.enablePaging(true,10,10,"pagingArea",true,"recInfoArea");
		gridArea.setPagingSkin("bricks");
		gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	
	function setGridData(){
		var result 	= new Object();
		var itemTypeCode = "${itemTypeCode}";
		var DocCategory = "${DocCategory}";
		var fltpCode = "${fltpCode}"; 
		result.title = "${title}";
		result.key= "instanceFile_SQL.getInstanceFileList";
		result.header = "No,#master_checkbox,${menu.LN00091},File,${menu.LN00101},${menu.LN00102},${menu.LN00147},${menu.LN00070},${menu.LN00060},${menu.LN00018},${menu.LN00030},Seq,SysFileWidthPath,FileRealName,FltpCode,FilePath,DocumentID,ExtFileURL";
		result.cols 	= "CHK|FltpName|down|FileRealName|Path|LanguageCode|LastUpdated|WriteUserNM|TeamName|DownCNT|FileID|SysFile|FileName|FltpCode|FilePath|DocumentID|ExtFileURL";
		result.widths = "30,30,120,30,*,250,60,80,80,130,60,50,60,80,80,80,80";
		result.sorting = "int,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		//result.types = "ro,ch,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro";
		result.aligns = "center,center,left,center,left,left,center,center,center,center,center,left,center,left,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&itemTypeCode="+itemTypeCode
					+ "&fltpCode="+fltpCode
					+ "&page=" + $("#page").val()
					+ "&pagingArea=" + $("#totalPage").val()
					+ "&pageSize=" + $("#pageScale").val()
					+ "&pageNum=" + $("#currPage").val()
					+ "&searchValue=" + $("#searchValue").val()
					+ "&itemID=${processID}"
					+ "&searchKey=" + $("#searchKey").val()
					+ "&isPublic=N"
					+ "&docCategory=PIM"
					+ "&instanceClass=${instanceClass}"
					+ "&instanceNo=${instanceNo}";
    	return result;
    	
	}
	
	// 상세 화면 
	function gridOnRowSelect(id, ind,varFilter){
		if(fileOption=="ExtLink"){
			var extFileURL = gridArea.cells(id,17).getValue();
			var url  = extFileURL;						
			var w = 1200;
			var h = 900;
			url = url.replace(/&amp;/gi,"&");
			itmInfoPopup(url,w,h); 
			
			//여기다 AjaxPage개발
			fnExtFileUpdateCount(gridArea.cells(id, 11).getValue());

		}
		
		else if("${sessionScope.loginInfo.sessionMlvl}" != "SYS" && "${myItem}" != 'Y' && itemFileOption == "VIEWER"){
			
			var extFileURL = gridArea.cells(id,17).getValue();
			var sysFileName = gridArea.cells(id, 13).getValue();
			var seq = gridArea.cells(id, 11).getValue();
			var url = "openViewerPop.do?seq="+seq;
			var w = 1200;
			var h = 900;
			if(extFileURL != "") { 
				w = screen.availWidth-38;
				h = screen.avilHeight;
				url = url + "&isNew=N";	
			}
			else {
				url = url + "&isNew=Y";
			}
			
			itmInfoPopup(url,w,h); 
			
		}else{
				if(ind==3){ // 다운로드 이미지 클릭시 
					var originalFileName = gridArea.cells(id, 4).getValue();
					var sysFileName = gridArea.cells(id, 12).getValue();
					var seq = gridArea.cells(id, 11).getValue();
					var url  = "fileDownload.do?seq="+seq+"&scrnType=INST";					
					ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
				}
		}
	}	
	function fnFileDownload(){
		var cnt  = gridArea.getRowsNum();
		var originalFileName = new Array();
		var sysFileName = new Array();
		var seq = new Array();
		var chkVal;
		var j =0;	
		
		if (gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00049}");
			return;
		}
		
		for(var i=0; i<cnt; i++){
			chkVal = gridArea.cells2(i,1).getValue();
			if(chkVal == 1){				
				sysFileName[j] =  gridArea.cells2(i,12).getValue(); //sysfile
				originalFileName[j] =  gridArea.cells2(i,4).getValue(); // orignalfile
				seq[j] = gridArea.cells2(i,11).getValue(); 
				j++;
			}
		}		
		var url  = "fileDownload.do?seq="+seq+"&scrnType=INST";	
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
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url="addFilePop.do";
		var id = "${processID}";
		var instanceClass = "${instanceClass}";		
		if(instanceClass == "ELM"){
			id = "${elmItemID}";
		}
		var data="scrnType=INST&screenType=INST&browserType="+browserType+"&id="+id+"&instanceNo=${instanceNo}&instanceClass=${instanceClass}"; 
		if(browserType=="IE"){fnOpenLayerPopup(url,data,"",400,400);}
		else{openPopup(url+"?"+data,490,410, "Attach File");}
	
	}	
	
	function setSubFrame(){
		doSearchList();
	}
	
	function goNewItemInfo() {
		var url = "NewItemInfoMain.do";
		var target = "actFrame";
		var data = "s_itemID=${DocumentID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}"; 
		
		ajaxPage(url, data, target);
	}	
	function fnReload(){
		document.location.reload();
	}
	function fnDeleteFile(){
		//if(selectedItemBlocked == "0"){
			var cnt  = gridArea.getRowsNum();
			var sysFileName = new Array();
			var filePath = new Array();
			var seq = new Array();
			var chkVal;
			var j =0;	
			
			if (gridArea.getCheckedRows(1).length == 0) {
				alert("${WM00023}");
				return;
			}
			
			for(var i=0; i<cnt; i++){
				chkVal = gridArea.cells2(i,1).getValue();
				if(chkVal == 1){				
					sysFileName[j] =  gridArea.cells2(i,13).getValue(); //sysfile
					filePath[j] = gridArea.cells2(i,15).getValue(); // 파일경로
					seq[j] = gridArea.cells2(i,11).getValue(); 
					j++;
				}
			}	
	
			if(confirm("${CM00002}")){
				var url = "deleteFileFromLst.do";
				var data = "&itemId=${itemId}&sysFile="+sysFileName+"&filePath="+encodeURIComponent(filePath)+"&seq="+seq+"&scrnType=INST";
				var target = "subFrame";
				ajaxPage(url, data, target);	
			}
		/* }else{
			if(selectedItemStatus == "REL"){
				 alert("${WM00120}"); // [변경 요청 안된 상태]
		     } else {
		         alert("${WM00050}"); // [승인요청중]
		     }
		} */
		
	}

	function doExcel() {
		gridArea.toExcel("${root}excelGenerate");
	}
	
	function fnDeleteFileHtml(seq){	
		var divId = "divDownFile"+seq;
		$('#'+divId).hide();
	}
	
	function fnExtFileUpdateCount(seq){
		var url = "extFileUpdateCount.do";
		var data = "&fileSeq="+seq+"&scrnType=ITEM";
		var target = "subFrame";
		ajaxPage(url, data, target);	
	}
	
	function fnAddExtFile() {
		var browserType="";
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url="modExtFilePop.do";
		var data="isNew=Y&browserType="+browserType+"&itemClassCode=${itemClassCode}&DocumentID=${DocumentID}";
		if(browserType=="IE"){fnOpenLayerPopup(url,data,"",1000,400);}
		else{openPopup(url+"?"+data,1000,410, "Modify File");}
	}
	
	function fdModExtFile() {
		if(selectedItemBlocked == "0"){
			var cnt = gridArea.getRowsNum();
			var sCnt = 0;
			var seq = new Array();
			var j = 0;
			
			for(var i=0; i<cnt; i++){
				chkVal = gridArea.cells2(i,1).getValue();
				if(chkVal == 1){				
					sCnt++;
					seq[j] = gridArea.cells2(i,11).getValue(); 
					j++;
				}
			}
			
			if(sCnt < 1) {
				alert("${WM00023}");
				return;
			}
			else if(sCnt > 10) {
				alert("${WM00021}");
				return;
			}
		
			var browserType="";
			//if($.browser.msie){browserType="IE";}
			var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
			if(IS_IE11){browserType="IE11";}
			var url="modExtFilePop.do";
			var data="seqList="+seq+"&browserType="+browserType;
			if(browserType=="IE"){fnOpenLayerPopup(url,data,"",1000,400);}
			else{openPopup(url+"?"+data,1000,410, "Modify File");}
		
		}
	}
	
</script>
</head>
<body>
<form name="fileMgtFrm" id="fileMgtFrm" action="" method="post" onsubmit="return false">
	<input type="hidden" id="itemId" name="itemId" value="${itemId}">
	<input type="hidden" id="itemAthId" name="itemAthId" value="${selectedItemAuthorID}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
	<input type="hidden" id="Blocked" name="Blocked" value="${selectedItemBlocked}" />
	<input type="hidden" id="LockOwner" name="LockOwner" value="${selectedItemLockOwner}" />
	<input type="hidden" id="fileSeqs" name="fileSeqs" >
	<input type="hidden" id="fileOption" name="fileOption" value="${fileOption}">
	<div class="child_search mgT10" >
		<li class="shortcut">
	 	 <img src="${root}${HTML_IMG_DIR}/sc_file.png"></img>&nbsp;&nbsp;<b>${menu.LN00019}</b>
	   </li>
	   <li style="padding-left:100px !important;">
	   		<select id="searchKey" name="searchKey" style="width:150px;">
				<option value="Name">${menu.LN00002}</option>
				<option value="Info" 
					<c:if test="${searchKey == 'Info'}"> selected="selected"</c:if>>
					${menu.LN00003}
				</option>					
			</select>
	   		<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;">
			<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchList()" value="Search"  style="cursor:pointer;" />
		  </li>
	   <li class="floatR pdR20">
				<span class="btn_pack medium icon"><span class="upload"></span><input value="Upload" type="button" onclick="fnMultiUpload()"></span>
				
				<c:if test="${fileOption == 'ExtLink'}"> 
					<span class="btn_pack medium icon"><span class="add"></span><input value="Add" type="button" onclick="fnAddExtFile()"></span>
					<span class="btn_pack medium icon"><span class="edit"></span><input value="Mod" type="button" onclick="fdModExtFile()"></span>
				</c:if>
				<span class="btn_pack medium icon"><span class=del></span><input value="Del" type="submit" onclick="fnDeleteFile()"></span>
			
			<%-- <c:if test="${fileOption == 'PLM' or (myItem == 'Y' &&  fileOption != 'ExtLink') }"> --%>
				<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="fnFileDownload()"></span>
			<%-- </c:if> --%>
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</li>	
	</div>
	<div class="countList">
              <li class="count">Total  <span id="TOT_CNT"></span></li>
              <li class="floatR">&nbsp;</li>
     </div>
	<div id="gridDiv" class="mgB10 clear">
		<div id="gridArea" style="width: 100%"></div>
	</div>	
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->		
</form>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body></html>