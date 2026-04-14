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


<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00123" var="WM00123"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00021" var="WM00021" arguments="Mod "/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00021" var="WM00021D" arguments="Delete "/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00021" var="WM00021B" arguments="Block "/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>


<script type="text/javascript">

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
		$("#gridArea").attr("style","height:"+(setWindowHeight() - 240)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#gridArea").attr("style","height:"+(setWindowHeight() - 240)+"px;");
		};		
		fnSelect('languageID', '', 'langType', '${sessionScope.loginInfo.sessionCurrLangType}', 'Select');
	
		doSearchList();
		
		$("#excel").click(function(){
			doExcel();
		});
	});
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function fnReloadGrid(targetGrid, newGridData){
		targetGrid.data.parse(newGridData);
 		$("#TOT_CNT").html(targetGrid.data.getLength());
	}
	
	function handleHeaderCheckboxClick(state, targetGrid, checkboxName, headerCheckboxID) {
		    event.stopPropagation();
		    targetGrid.data.forEach(function(row) {
		        targetGrid.data.update(row.id, {
		            [checkboxName]: state
		        });
		    });  
	    }

	
	function doSearchList(){
		const param = "&DocumentID=${DocumentID}"
			+ "&s_itemID=${DocumentID}&rltdItemId=${rltdItemId}"
			+ "&isPublic=N"
			+ "&DocCategory=ITM"
			+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&sqlID=fileMgt_SQL.getFile"
		
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(newGridData){
 				fnReloadGrid(grid, newGridData);
				$('#loading').fadeOut(150);
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
	}
	
	// 상세 화면 
	function gridOnRowSelect (row,column,e){
		var extFileURL = row.ExtFileURL;	
		if(column.id == "CHK") return;
		if(fileOption=="ExtLink"){
			var url  = row.ExtFileURL;						
			var w = 1200;
			var h = 900;
			url = url.replace(/&amp;/gi,"&");
			itmInfoPopup(url,w,h); 
			
			fnExtFileUpdateCount(row.Seq);
		}
		else if("${sessionScope.loginInfo.sessionMlvl}" != "SYS" && "${myItem}" != 'Y' && itemFileOption == "VIEWER"){
			var url = "openViewerPop.do?seq="+row.Seq;
			var w = 1200;
			var h = 900;
			if(extFileURL != "") { 
				w = screen.availWidth-38;
				h = screen.avilHeight;
				url = url + "&isNew=N";	
			} else { url = url + "&isNew=Y"; }			
			itmInfoPopup(url,w,h); 			
		}else{
			if(column.id == "down"){ // 다운로드 이미지 클릭시 					
				var url  = "fileDownload.do?seq="+row.Seq;
				var frmType = "${frmType}";
				ajaxSubmitNoAdd(document.fileFrm, url,"fileFrame");
			}else{
				var isNew = "N";								
				var url  = "fileDetail.do?&isNew="+isNew
						+"&seq="+row.Seq
						+"&DocumentID="+row.DocumentID
						+"&itemClassCode=${itemClassCode}"
						+"&selectedItemBlocked="+selectedItemBlocked
						+"&selectedItemAuthorID="+selectedItemAuthorID
						+"&selectedItemLockOwner="+selectedItemLockOwner;
				var w = 1200;
				var h = 500;
				itmInfoPopup(url,w,h); 				
			}
		}
	 }
	
	function fnExtFileUpdateCount(seq){
		var url = "extFileUpdateCount.do";
		var data = "&fileSeq="+seq+"&scrnType=ITEM";
		var target = "fileFrame";
		ajaxPage(url, data, target);	
	}
	
// 	================= [[여기서부터 아래는 미사용 함수임]]============================

	// 미사용 함수
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
				sysFileName[j] =  gridArea.cells2(i,13).getValue(); //sysfile
				originalFileName[j] =  gridArea.cells2(i,5).getValue(); // orignalfile
				seq[j] = gridArea.cells2(i,12).getValue(); 
				j++;
			}
		}		
		var frmType = "${frmType}";
		var url  = "fileDownload.do?seq="+seq;
		if(frmType =="documentDetailFrm"){ 
			ajaxSubmitNoAdd(document.documentDetailFrm, url,"saveFrame");
		}else{
			ajaxSubmitNoAdd(document.fileFrm, url,"fileFrame");
		}
	}
	
	// 미사용 함수
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
		ajaxSubmit(document.fileFrm, url);
	}	
	
	// 미사용 함수
	function fnMultiUpload(){ 
			var browserType="";
			var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
			if(IS_IE11){browserType="IE11";}
			var url="addFilePop.do";
			var data="scrnType=ITM_M&delTmpFlg=Y&docCategory=ITM&browserType="+browserType+"&mgtId="+""+"&id="+$('#DocumentID').val();
			if(browserType=="IE"){fnOpenLayerPopup(url,data,"",400,400);}
			else{openPopup(url+"?"+data,490,410, "Attach File");}
	}
	
	// 미사용 함수
	function fnMultiUploadV4(){ 
		var url="addFilePopV4.do";
		var data="scrnType=ITM_M&docCategory=ITM&id="+$('#DocumentID').val();
		openPopup(url+"?"+data,480,450, "Attach File");
	}	

	// 미사용 함수
	function goNewItemInfo() {
		var url = "NewItemInfoMain.do";
		var target = "actFrame";
		var data = "s_itemID=${DocumentID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}"; 
		
		ajaxPage(url, data, target);
	}
	
	// 미사용 함수
	function fnDeleteFile(){
		if(selectedItemBlocked == "0"){
			var cnt  = gridArea.getRowsNum();
			var sysFileName = new Array();
			var filePath = new Array();
			var seq = new Array();
			var chkVal;
			var chkBlock;
			var itemID = "${DocumentID}";
			var documentID;
			var j =0;	
			
			if (gridArea.getCheckedRows(1).length == 0) {
				alert("${WM00021D}");
				return;
			}
			
			for(var i=0; i<cnt; i++){
				chkVal = gridArea.cells2(i,1).getValue();
				chkBlock = gridArea.cells2(i,19).getValue();
				documentID = gridArea.cells2(i,17).getValue();
				
				if(chkVal == 1 && chkBlock != "Y" && documentID == itemID){				
					sysFileName[j] =  gridArea.cells2(i,14).getValue(); //sysfile
					filePath[j] = gridArea.cells2(i,16).getValue(); // 파일경로
					seq[j] = gridArea.cells2(i,12).getValue(); 
					j++;
				}
				else if(chkVal == 1 && documentID != itemID) {
					var fileName = gridArea.cells2(i,5).getValue();
					
					var msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00112' var='WM00112' arguments='"+fileName+"'/>";
					alert("${WM00112}"); return;
				}else if(chkVal == 1) {
					var fileName = gridArea.cells2(i,5).getValue();
					
					var msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00125' var='WM00125' arguments='${menu.LN00134},Blocked'/>";
					alert("${WM00125}"); return;
				}
			}	
	
			if(confirm("${CM00002}")){
				var url = "deleteFileFromLst.do";
				var data = "&itemId=${itemId}&sysFile="+sysFileName+"&filePath="+encodeURIComponent(filePath)+"&seq="+seq;
				var target = "fileFrame";
				ajaxPage(url, data, target);	
			}
		}else{
			if(selectedItemStatus == "REL"){
				 alert("${WM00120}"); // [변경 요청 안된 상태]
		     } else {
		         alert("${WM00050}"); // [승인요청중]
		     }
		}
		
	}
	
	// 미사용 함수
	function doExcel() {
		gridArea.toExcel("${root}excelGenerate");
	}
	
	// 미사용 함수
	function fnDeleteFileHtml(seq){	
		var divId = "divDownFile"+seq;
		$('#'+divId).hide();
	}
	
	// 미사용 함수
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
	
	// 미사용 함수
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
					seq[j] = gridArea.cells2(i,12).getValue(); 
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
	
	// 미사용 함수
	function fnChangeRegMember(){
		var cnt  = gridArea.getRowsNum();
		var fileSeqs = new Array();
		var j =0;
		
		
		if (gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00023}");
			return;
		}
				
		for(var i=0; i<cnt; i++){
			chkVal = gridArea.cells2(i,1).getValue();
			if(chkVal == 1){
				fileSeqs[j] = gridArea.cells2(i,12).getValue(); 
				j++;
			}
		}
		$("#fileSeqs").val(fileSeqs);
		if(fileSeqs != ""){
			var url = "searchPluralNamePop.do?objId=resultID&objName=resultName&UserLevel=ALL"
						+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
			window.open(url,'window','width=340, height=300, left=300, top=300,scrollbar=yes,resizble=0');
		}
	}
	
	// 미사용 함수
	function setSearchNameWf(avg1, avg2, avg3, avg4){
		if(confirm("${CM00001}")){
			var url = "updateFileRegMember.do";
			var target = "fileFrame";
			var data = "fileSeqs="+$("#fileSeqs").val()+"&memberID="+avg1; 
		 	ajaxPage(url, data, target);
		}
	}
	
	// 미사용 함수
	function fnBlock(){
		var cnt  = gridArea.getRowsNum();
		var seq = "";
		
		if (gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00021B}");
			return;
		}
		
		for(var i=0; i<cnt; i++){
			chkVal = gridArea.cells2(i,1).getValue();
			
			if(chkVal == 1){		
				if(seq == "")
					seq = gridArea.cells2(i,12).getValue(); 
				else 
					seq = seq + "," + gridArea.cells2(i,12).getValue(); 
			}
		}		
		
		if(confirm("${CM00001}")){	
			var url  = "updateFileBlocked.do";
			var data = "&seq="+seq;
			ajaxPage(url,data,"fileFrame");
		}
	}
	
	// 미사용 함수
	function editFileName(){
		
	    var url = "editFileNamePop.do"; 
	    var option = "width=550, height=570, left=100, top=100,scrollbar=yes,resizble=0";
	    window.open("editFileNamePop.do?DocumentID="+$("#DocumentID").val(), "SelectOwner", option);	 
   }
	
	// 미사용 함수
	function fnExtFileDownload(){
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
				sysFileName[j] =  gridArea.cells2(i,13).getValue(); //sysfile
				originalFileName[j] =  gridArea.cells2(i,5).getValue(); // orignalfile
				seq[j] = gridArea.cells2(i,12).getValue(); 
				j++;
			}
		}		
		var frmType = "${frmType}";
		var url  = "downloadExtLinkFile.do?seq="+seq;
		if(frmType =="documentDetailFrm"){ 
			ajaxSubmitNoAdd(document.documentDetailFrm, url,"saveFrame");
		}else{
			ajaxSubmitNoAdd(document.fileFrm, url,"fileFrame");
		}
	}	
	
</script>
</head>
<body>
<form name="fileFrm" id="fileFrm" action="" method="post" onsubmit="return false">
	<input type="hidden" id="itemId" name="itemId" value="${itemId}">
	<input type="hidden" id="itemAthId" name="itemAthId" value="${selectedItemAuthorID}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<input type="hidden" id="Blocked" name="Blocked" value="${selectedItemBlocked}" />
	<input type="hidden" id="LockOwner" name="LockOwner" value="${selectedItemLockOwner}" />
	<input type="hidden" id="DocumentID" name="DocumentID" value="${DocumentID}" />
	<input type="hidden" id="fileSeqs" name="fileSeqs" >
	<div class="countList">
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">&nbsp;</li>
     </div>
	<div id="gridDiv" class="mgB10 clear">
		<div id="gridArea" style="width: 100%"></div>
	</div>	
	<!-- START :: PAGING -->
	<div id="pagination"></div>	
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->		
</form>
<iframe name="fileFrame" id="fileFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>
<script>

	var pagination;
	
	const gridArea = new dhx.Layout("gridArea", {
		rows: [ { id: "a" } ] });
	
	var grid = new dhx.Grid("gridArea", {
	    columns: [
	    	{ width: 40, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center"},
	        { width: 40, id: "CHK",
	        	header: [{ htmlEnable: true,
	        		id: 'CHKHeader1',
	        		text: "<input type='checkbox' onclick=\"handleHeaderCheckboxClick(checked, grid, 'CHK')\"></input>",
	        		align: "center",
	        		htmlEnable: true}],
	    		align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 120, id: "FltpName", header: [{ text: "${menu.LN00091}", align: "center" },], align: "left"},
	        { width: 60, id: "CSVersion", header: [{ text: "Version", align: "center" },], align: "left"},
	        { width: 40, id: "down", header: [{ text: "File", align:"center" }], htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR}/btn_file_down.png" width="24" height="24">';
       		}},	 
	        { id: "FileRealName", header: [{ text: "${menu.LN00101}", align: "center" },], align: "left"},
	        { width: 300, id: "Path", header: [{ text: "${menu.LN00102}", align: "center" },], align: "left"},
	        { width: 60, id: "LanguageCode", header: [{ text: "${menu.LN00147}", align: "center" },], align: "left"},
	        { width: 80, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align: "center" },], align: "left"},
	        { width: 160, id: "WriteUserNM", header: [{ text: "${menu.LN00060}", align: "center" },], align: "left"},
	        { width: 130, id: "TeamName", header: [{ text: "${menu.LN00018}", align: "center" },], align: "left"},
	        { width: 60, id: "DownCNT", header: [{ text: "${menu.LN00030}", align: "center" },], align: "left"},
	        { hidden: true, width: 50, id: "Seq", header: [{ text: "Seq", align: "center" },], align: "left"},
	        { hidden: true, width: 60, id: "SysFile", header: [{ text: "SysFile", align: "center" },], align: "left"},
	        { hidden: true, width: 80, id: "FileName", header: [{ text: "FileName", align: "center" },], align: "left"},
	        { hidden: true, width: 80, id: "FltpCode", header: [{ text: "FltpCode", align: "center" },], align: "left"},
	        { hidden: true, width: 80, id: "FilePath", header: [{ text: "FilePath", align: "center" },], align: "left"},
	        { hidden: true, width: 80, id: "DocumentID", header: [{ text: "DocumentID", align: "center" },], align: "left"},
	        { hidden: true, width: 60, id: "ExtFileURL", header: [{ text: "ExtFileURL", align: "center" },], align: "left"},
	        { hidden: true, width: 60, id: "Blocked", header: [{ text: "Blocked", align: "center" },], align: "left"},
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	});
	
	gridArea.getCell("a").attach(grid);
	
	grid.events.on("cellClick", (row,column,e) => gridOnRowSelect(row,column,e)); 
	
	 if(pagination){pagination.destructor();}
	 
	 pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});
</script>
</html>