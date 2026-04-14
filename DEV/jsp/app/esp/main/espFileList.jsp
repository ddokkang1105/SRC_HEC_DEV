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
<%-- <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%> --%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%-- <%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%> --%>

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
	var fltpCode = "";
	var inProgress = false;
	
	$(document).ready(function(){
		
		// 검색조건 없을 경우 초기 등록일 2주로 검색
		if(!"${REG_STR_DT}" && !"${REG_END_DT}") {
			setDeafultDay();
		}
		
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

		fnSelect('srType', '&languageID=${sessionScope.loginInfo.sessionCurrLangType}&esType=${srType}', 'getSRTypeList', "ACM" , 'false', 'esm_SQL');
		fnSelect('SRAT0004','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=SRAT0004','selectAttrLovOption','','Select','attr_SQL');
		
// 		$("#excel").click(function(){
// 			 fnGridExcelDownLoad(grid);
// 		});
		
		$("#fltp").change(function() {
			fltpCode = $(this).val();
		});
		
		$('#searchClear').click(function(){
			clearSearchCon();
			return false;
		});
		
		if("${srID}" === "") {
			getDicData("BTN", "LN0001").then(data => fnSetButton("Search", "search", data.LABEL_NM,"primary"));
			getDicData("BTN", "LN0003").then(data => fnSetButton("searchClear", "clear", data.LABEL_NM,"secondary"));
			
			getDicData("GUIDELN", "ZLN0002").then(data => {
				document.querySelector("#srAreaSearch").placeholder = data.LABEL_NM;
				document.querySelector("#receiptUserNM").placeholder = data.LABEL_NM;
			})
			
			document.getElementById("srAreaBtn").addEventListener("click", function() {
				searchSrArea();
			});
			
			function searchSrArea(){
				window.open('searchSrAreaPop.do?srType=${esType}&roleFilter=${roleFilter}&myCSR=${myCSR}','window','width=1000, height=500, left=300, top=300,scrollbar=yes,resizble=0');
			}
			
			function setSrArea(clientID, srArea1, srArea2, srArea2Name){
				$("#srArea1").val(srArea1);
				$("#srArea2").val(srArea2);
				$("#srAreaSearch").val(srArea2Name);
			}
			
		}
		if("${screenType}" === "csrDtl" && "${csrEditable}" === "Y") {
			getDicData("BTN", "LN0001").then(data => fnSetButton("upload", "upload", data.LABEL_NM,"primary"));
			getDicData("BTN", "LN0002").then(data => fnSetButton("del", "delete", data.LABEL_NM,"primary"));
		}
		/* fnSetButton("download", "download", "Download","secondary"); */
// 		fnSetButton("excel", "", "Excel","secondary");
		
		
		doSearchFileList();
	});
	
	<c:if test="${empty srID}">
	getArcName("${arcCode}", ".page-title");
	</c:if>
	
	function setWindowHeight(){
		var size = window.innerHeight;
		var height = 0;
		if( size == null || size == undefined){
			height = document.body.clientHeight;
		}else{
			height=window.innerHeight;
		}return height;
	}
	
	function fnFileDownloadRow(seq){
		var url = "fileDownload.do?seq="+seq+"&scrnType=ITSM";
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
			var url  = "fileDownload.do?seq="+seq+"&scrnType=ITSM";
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
		$("#fltp").val("");
		$("#ticketNo").val("");
		$("#searchValue").val("");
		$("#parent").val("");
		$("#searchValue").val("");
		$("#FileName").val("");
		
		// 날짜 초기화
		setDeafultDay();
		// 요청자 초기화
		$("#requestUserNM").val("");
		$("#requestUserID").val("");
		// 담당자 초기화
		$("#receiptUserNM").val("");
		$("#receiptUserID").val("");
		// 서비스/파트 초기화
		$("#srAreaSearch").val("");
		$("#srArea1").val("");
		$("#srArea2").val("");
		// 중요도 초기화
		$("#SRAT0004").val("");
		// srType 초기화
		$("#srType").val("${srType}");
		
		doSearchFileList();
	}
	
	function setDeafultDay(){
		
		var period = "${period}";
		if(period === null || period === '' || period === undefined) period = 14;
		
		var dateObject = setDefaultLocalDate(period);
		var regEndDate = dateObject["endDate"];
		var regStartDate = dateObject["startDate"];
		
		$("#REG_END_DT").val(regEndDate);
		$("#REG_STR_DT").val(regStartDate);
	}
	
	let clickBtn = "";
	if("${srID}" == ""){
		document.getElementById("requestUserBtn").addEventListener("click", function() {
			clickBtn = "requestUserBtn";
			searchPopupWf();
		});
		
		<c:if test="${myActivity ne 'Y'}">
		document.getElementById("receiptUserBtn").addEventListener("click", function() {
			clickBtn = "receiptUserBtn";
			searchPopupWf();
		});
		</c:if>
	}
	function searchPopupWf(){
		window.open("searchMemberPop.do?myClient=${myClient}&notCompanyIDs=22",'searchMemberPop','width=900, height=700');
	}
	
	function searchMemberCallback(avg1,avg2,avg3,avg4){
		if(clickBtn == "requestUserBtn") {
			$("#requestUserNM").val(avg2+"("+avg3+"/"+avg4+")");
			$("#requestUserID").val(avg1);
		}
		if(clickBtn == "receiptUserBtn") {
			$("#receiptUserNM").val(avg2+"("+avg3+"/"+avg4+")");
			$("#receiptUserID").val(avg1);
		}
	}
	
	function fnClear(e1, e2, e3) {
		if(e1) $("#"+e1).val("");
		if(e2) $("#"+e2).val("");
		if(e3) $("#"+e3).val("");
	}
	
	var layout = new dhx.Layout("grdGridArea", {
		rows : [ {
			id : "a",
		}, ]
	});	

	var grid = new dhx.Grid(null, {
		  columns: [
		        { width: 40, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
		        /* { width: 50, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false}, */
		        { hidden:true, width:140, id: "SRCode", header: [{ text: "${menu.ZLN0041}" , align: "center" },{content: "inputFilter"}], align: "left"},
		        { hidden:true, width:200, id: "Subject", header: [{ text: "${menu.LN00002}" , align: "center" },{content: "inputFilter"}], align: "left"},
		        { minWidth: 150, id: "FileRealName", header: [{ text: "${menu.ZLN0063}" , align: "center"},{content: "inputFilter"}], align: "left"},
		        { width: 50, id: "down", header: [{ text: "${menu.LN00144}" , align: "center" }],htmlEnable: true, align: "center",
		        	template: function (text, row, col) {
		        		return '<img src="${root}${HTML_IMG_DIR}/btn_file_down.png"  width="18" height="18" style="cursor:pointer;" />';
		            }
		        },
		        { width:120, id: "SRAT0004", header: [{ text: "${menu.ZLN0064}" , align: "center" },{content: "selectFilter"}], align: "center"},
		        { width:120, id: "FltpNM", header: [{ text: "${menu.LN00091}" , align: "center" },{content: "selectFilter"}], align: "center"},
		        { width:120, id: "CompanyName", header: [{ text: "${menu.ZLN0018}" , align: "center" },{content: "selectFilter"}], align: "center"},
		        { width:120, id: "SRTypeNM", header: [{ text: "${menu.LN00011}" , align: "center" },{content: "selectFilter"}], align: "center"},
		        { width:120, id: "SpeCodeNM", header: [{ text: "${menu.ZLN0060}" , align: "center" },{content: "selectFilter"}], align: "center"},
		        { width:150, id: "SRService", header: [{ text: "${menu.ZLN0024}" , align: "center" },{content: "inputFilter"}], align: "left"},
		       	{ width:120, id: "CreationTime", header: [{ text: "${menu.ZLN0065}" , align: "center" },{content: "inputFilter"}], align: "center",
		        	template: function (text, row, col){
		        		if(row.CreationTime){
		        			let date = new Date(row.CreationTime);
		        			return date.toISOString().split('T')[0];
		        		} else {
		        			return "";
		        		}
		        	}},
		        { width: 140, id: "WriteUserNM", header: [{ text: "${menu.LN00060}" , align: "center" },{content: "inputFilter"}], align: "center" },
		        { width: 80, id: "TeamName", header: [{ text: "${menu.LN00104}" , align: "center" },{content: "selectFilter"}], align: "center"},
		        { hidden:true, width: 120, id: "LastUpdated", header: [{ text: "${menu.LN00070}" , align: "center" },{content: "inputFilter"}], align: "center" },
		       
		        { hidden:true, width: 0, id: "Seq", header: [{ text: "Seq" , align: "center" }], align: "center"},
		        { hidden:true, width: 0, id: "SysFile", header: [{ text: "SysFileWidthPath" , align: "center" }], align: "center" },
		        { hidden:true, width: 0, id: "FileName", header: [{ text: "FileRealName" , align: "center" }], align: "center" },
		        { hidden:true, width: 0, id: "FltpCode", header: [{ text: "FltpCode" , align: "center" }], align: "center" },
		        { hidden:true, width: 0, id: "FilePath", header: [{ text: "FilePath" , align: "center" }], align: "center" },
		        { hidden:true, width: 0, id: "DocumentID", header: [{ text: "DocumentID" , align: "center" }], align: "center" },
		        { hidden:true, width: 0, id: "SpeCode", header: [{ text: "SpeCode" , align: "center" }], align: "center" },
		    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	});
	
	layout.getCell("a").attach(grid);
	
	var pagination = new dhx.Pagination("pagination", {
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
		if (column.id !== "checkbox" && column.id !== "RNUM") {
			 if (column.id ==="down") {
		    	fnDownload(row);
		    } else if (column.id ==="SRCode"||column.id ==="Subject") {
		    	var srID = row.DocumentID;
	    		doDetail(srID);
			} else {
				// * eclick 반영 시 주석해제
				//window.open("/zDLM_changeFile.do?srID="+row.DocumentID+"&status="+row.SpeCode+"&srType="+row.SRType+"&customerNo="+row.ClientID+"&projectID="+row.ProjectID,"changeFile", "width=1000, height=400, left=300, top=300,scrollbar=yes,resizble=0");
			}
		}
	    /* else {
			if("${myActivity}" === "Y") {
				var url  = "fileDetail.do?&isNew=N"
					+"&seq="+row.Seq
					+"&DocumentID="+row.DocumentID
					+"&selectedItemBlocked=0"
					+"&selectedItemAuthorID=${sessionScope.loginInfo.sessionUserId}"
				var w = 1200;
				var h = 500;
				itmInfoPopup(url,w,h);
			}
			
		} */
	});


	function doDetail(srID){
		const isPopup = 'true';
		var url = "esrInfoMgt.do";
		var data = "&srID="+srID + "&isPopup=true";
		
		isPopup ? window.open(url+"?"+data,srID,"width=1400 height=800 resizable=yes") : ajaxPage(url, data, "srListDiv");
	}
		
	function fnDownload(row){
	   var seq = row.Seq;
		var url  = "fileDownload.do?seq="+seq+"&scrnType=ITSM";
	
		fnFileDownloadRow(seq);
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
		doSearchFileList();
	}
	
	//조회
 	function doSearchFileList(){ 
 		
 		<c:if test="${empty srID}">
			var REG_STR_DT = document.getElementById("REG_STR_DT").value;
	 	    var REG_END_DT = document.getElementById("REG_END_DT").value;
	 	    var srType = document.getElementById("srType").value; 
	 	    
	 		// [eClick 전용 소스 : eclick 배포시 주석 해제 ]
			/*
	 	    if(srType === '' || srType === null || srType === undefined){
	 	    	srType = 'ACM';
	 	    }
	 	    */
	 	    
	 	    if (!REG_STR_DT || !REG_END_DT) {
// 	 	        alert("등록일을 모두 입력해주세요.");
	 	       getDicData("ERRTP", "LN0001").then(data => alert("${menu.LN00078}"+data.LABEL_NM));
	 	        return;
	 	    }
	 	    
	 	    if (!checkDateYear(REG_STR_DT, REG_END_DT)){
	 	    	return;
	 	    }
 	    </c:if>
		
 		$('#loading').fadeIn(150);
		var sqlID="esm_SQL.espFile";

		var param = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srID=${srID}&sqlID="+sqlID;
			param += "&myCSR=${myCSR}&myWorkspace=${myWorkspace}"
			param += "&myActivity=${myActivity}";
			
			var srCode = $("#ticketNo").val();
			
			if(srCode!== undefined && srCode !== '' && srCode !== null){
				srCode = removeEmojisAndSpecialChars(srCode);
				$("#ticketNo").val(srCode);
				param += "&SRCode="+ srCode;
			} else {
				if($("#REG_STR_DT").val() != "" & $("#REG_STR_DT").val() != null ) param += "&reg_STR_DT="+ $("#REG_STR_DT").val();
				if($("#REG_END_DT").val() != "" & $("#REG_END_DT").val() != null ) param += "&reg_END_DT="+ $("#REG_END_DT").val();
				if($("#FileName").val() != "" & $("#FileName").val() != null ) param += "&fileNM="+ $("#FileName").val();
				if($("#searchValue").val() != "" & $("#searchValue").val() != null ) param += "&searchValue="+ $("#searchValue").val();
				if($("#parent").val() != "" & $("#parent").val() != null) param += "&projectID=" + $("#parent").val();
				if($("#fltp").val() != "" & $("#fltp").val() != null) param += "&fltpCode=" + $("#fltp").val();
				if($("#srArea1").val() != "" & $("#srArea1").val() != null ) param += "&srArea1="+ $("#srArea1").val();
				if($("#srArea2").val() != "" & $("#srArea2").val() != null ) param += "&srArea2="+ $("#srArea2").val();
				param += "&requestUserID=" + $("#requestUserID").val();
				param += "&receiptUserID=" + $("#receiptUserID").val();
				<c:if test="${empty srID}"> param += "&SRAT0004=" + $("#SRAT0004").val(); </c:if>
				param += "&searchSrType=" + srType;
			}
		
		if(inProgress) {
// 			alert("목록을 불러오고 있습니다.");
	 	       getDicData("ERRTP", "LN0002").then(data => alert(data.LABEL_NM));
		} else {
			inProgress = true;
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
	} 
	
	function fnReloadGrid(newGridData){
		$('#loading').fadeOut(150);
 		grid.data.parse(newGridData);
 		grid.data.sort({
		    by: "RNUM",
		    dir: "asc"
		})
		$("#TOT_CNT").html(grid.data.getLength());
 		fnMasterChk('');
		$('#loading').fadeOut(150);
		inProgress = false;
 	}
	
	if(!"${srID}") {
		grid.showColumn("SRCode");
		grid.showColumn("Subject");
	}
	
	function removeEmojisAndSpecialChars(str) {
		return str.replace(/[^a-zA-Z0-9]/g, "");   
	}
</script>
</head>
<body>
	<form name="fileMgtFrm" id="fileMgtFrm" action="#" method="post" onsubmit="return false;" >
		<input type="hidden" id="itemId" name="itemId" value="${itemId}">
		<input type="hidden" id="itemAthId" name="itemAthId" value="${itemAthId}">
		<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	
		<c:if test="${empty srID}">
			<div class="page-title"></div>
			<table border="0" cellpadding="0" cellspacing="0" width="100%" class="form-column-4 new-form" id="search">	   
		    <tr>
		        <!-- Ticket No. -->
		        <th class="alignL pdL10">Ticket No.</th>
		        <td class="alignL pdL10">
		        	<input type="text" id="ticketNo" name="ticketNo" class="text">
		        </td>
			   	<th class="alignL pdL10">${menu.LN00025}</th>
	         	<td class="alignL pdL10">
		         	<input type="text" class="text" id="requestUserNM" name="requestUserNM" value="${requestUserNM}" style="width: calc(100% - 24px);" disabled autocomplete="off" />
		         	<img src="${root}${HTML_IMG_DIR}/btn_close.png" style="position: absolute; top: 10px; right: 34px; width: 17px; cursor: pointer;" onclick="fnClear('requestUserNM', 'requestUserID')"/>
		         	<img id="requestUserBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" style="cursor: pointer;"/>
		         	<input type="hidden" id="requestUserID" name="requestUserID" value="${requestUserID}" />
		         </td>
		         <!-- 프로세스 -->
		       	<th class="alignL pdL10">${menu.LN00011}</th>
		        <td class="alignL pdL10">
			       	<select id="srType" Name="srType" style="width: 100%;display: inline-block;">
			       		<option value=''></option>
			       	</select>
		       	</td>
	       	  	<!-- srArea-->
				<th class="alignL pdL10">${menu.ZLN0024}</th>
			    <td class="alignL pdL10">
			    	<input type="text" class="text" id="srAreaSearch" name="srAreaSearch" style="width: calc(100% - 24px);" disabled autocomplete="off" />
			    	<img src="${root}${HTML_IMG_DIR}/btn_close.png" style="position: absolute; top: 10px; right: 34px; width: 17px; cursor: pointer;" onclick="fnClear('srAreaSearch', 'srArea1', 'srArea2')"/>
			    	<img id="srAreaBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" style="cursor: pointer;"/>
					<input type="hidden" id="srArea1" name="srArea1" />
					<input type="hidden" id="srArea2" name="srArea2" />
					<ul class="autocomplete"></ul>
			    </td>
		    </tr>
		    <tr>
		   	 <!--등록일 -->
		        <th class="alignL pdL10">${menu.LN00078}</th> <!-- 등록일 -->
		        <td class="alignL pdL10">
		            <input type="text" id="REG_STR_DT" name="REG_STR_DT" value="${beforeYmd}" class="input_off datePicker stext" size="8"
						style="width: 39.25%;text-align: center;" onchange="this.value = makeDateType(this.value);" maxlength="10">
					-
					<input type="text" id="REG_END_DT" name="REG_END_DT" value="${thisYmd}" class="input_off datePicker stext" size="8"
						style="width: 39.25%;text-align: center;" onchange="this.value = makeDateType(this.value);" maxlength="10">
		        <th class="alignL pdL10">${menu.LN00002}</th>
		        <td class="alignL pdL10">
			   		<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text">
			   	</td>
			   	<th class="alignL pdL10">${menu.ZLN0064}</th>
			   	<td class="alignL pdL10">
			   		<select id="SRAT0004" Name="SRAT0004" class="sel">
			   			<option value=''></option>
			   		</select>
			   	</td>
			   	<!-- 담당자 -->
			   	<c:if test="${myActivity ne 'Y'}">
			        <th class="alignL pdL10">${menu.LN00004}</th>
			        <td class="alignL pdL10">
			         	<input type="text" class="text" id="receiptUserNM" name="receiptUserNM" value="${receiptUserNM}" style="width: calc(100% - 24px);" disabled autocomplete="off" />
			         	<img src="${root}${HTML_IMG_DIR}/btn_close.png" style="position: absolute; top: 10px; right: 34px; width: 17px; cursor: pointer;" onclick="fnClear('receiptUserNM', 'receiptUserID')"/>
			         	<img id="receiptUserBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" style="cursor: pointer;"/>
			        </td>
		        </c:if>
			    <input type="hidden" id="receiptUserID" name="receiptUserID" value="${receiptUserID}" />
		    </tr>
		  	</table>
		</c:if>
		<c:if test="${not empty srID}">
			<div class="border-section pdB10">
		</c:if>
		<div class="btn-wrap justify-center pdT10">
			<div class="btns">
				<c:if test="${empty srID}">
					<button id="Search" onclick="doSearchFileList()"></button>
					<button id="searchClear"></button>
				</c:if>
				<c:if test="${screenType == 'csrDtl' && csrEditable == 'Y' }">
					<button id="upload" onclick="fnMultiUploadV4()"></button>
					<button id="del" onclick="fnDeleteFile()"></button>
				</c:if>
			</div>
   	 	</div>
		
		<ul class="btn-wrap pdT20 pdB10" >
			<li class="count">Total  <span id="TOT_CNT"></span></li>
		</ul>
		
		<div id="grdGridArea" style="width: 100%"></div>
		<div id="pagination"></div>
		<c:if test="${not empty srID}">
			</div>
		</c:if>
	</form>
	<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>

</html>