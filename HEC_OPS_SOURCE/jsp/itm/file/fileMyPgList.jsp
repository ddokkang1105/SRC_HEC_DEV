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

<script type="text/javascript">

	var gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	var now;
	
	$(document).ready(function(){
		gridInit();		
		doSearchList();
	});
	
	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(gridArea, d.key, d.cols, d.data, false,"", $("#totalPage").val(),"","doReturnGridSet();");
	}
	
	function gridInit(){	
		var d = setGridData();
		gridArea = fnNewInitGrid("gridArea", d);
		gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		gridArea.setIconPath("${root}${HTML_IMG_DIR}/btn_file_add.png");

		fnSetColType(gridArea, 1, "ch");
		fnSetColType(gridArea, 3, "img");
		gridArea.setColumnHidden(5, true);
		gridArea.setColumnHidden(11, true);
		gridArea.setColumnHidden(12, true);
		gridArea.setColumnHidden(13, true);
		gridArea.setColumnHidden(14, true);
		gridArea.setColumnHidden(15, true);
		gridArea.setColumnHidden(16, true);
		gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		
		gridArea.enablePaging(true,10,10,"pagingArea",true,"recInfoArea");
		gridArea.setPagingSkin("bricks");
		gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	
	function setGridData(){
		var result 	= new Object();
		//var itemTypeCode = "${itemTypeCode}";
		var fltpCode = "${fltpCode}"; 
		result.title 	= "${title}";
		result.key 	= "fileMgt_SQL.getFile";
		result.header = "No,#master_checkbox,${menu.LN00091},File,${menu.LN00101},${menu.LN00102},${menu.LN00013},${menu.LN00070},${menu.LN00060},${menu.LN00104},${menu.LN00030},Seq,SysFileWidthPath,FileRealName,FltpCode,FilePath,ItemID";
		result.cols 	= "CHK|FltpName|down|FileRealName|Path|CreationTime|LastUpdated|WriteUserNM|TeamName|DownCNT|Seq|SysFile|FileName|FltpCode|FilePath|ItemID";
		result.widths = "30,30,120,30,*,250,80,80,80,60,60,50,60,80,80,80,80";
		result.sorting = "int,int,str,str,str,str,str,str,str,int,int,str,str,str,str,str,str";
		result.types = "ro,ch,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro";
		result.aligns = "center,center,left,center,center,left,center,center,center,center,left,left,center,left,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&fltpCode="+fltpCode
					+ "&page=" + $("#page").val()
					+ "&pagingArea=" + $("#totalPage").val()
					+ "&pageSize=" + $("#pageScale").val()
					+ "&pageNum=" + $("#currPage").val()
					+ "&searchValue=" + $("#searchValue").val()
					+ "&DocType=MyPg"
					+ "&searchKey=" + $("#searchKey").val();
		return result;
	}
	
	// 상세 화면 
	function gridOnRowSelect(id, ind){
		if(ind==3){ // 다운로드 이미지 클릭시 
			var originalFileName = gridArea.cells(id, 4).getValue();
			var sysFileName = gridArea.cells(id, 12).getValue();
			var seq = gridArea.cells(id, 11).getValue();
			var url  = "fileDownload.do?seq="+seq;
			var frmType = "${frmType}";
		
			if(frmType =="documentDetailFrm"){ 
				ajaxSubmitNoAdd(document.documentDetailFrm, url,"subFrame");
			}else{
				ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
			}
		}else{
			var isNew = "N";
			var seq = gridArea.cells(id, 11).getValue();
			var fileName =  gridArea.cells(id, 4).getValue();
			var fltpCode =  gridArea.cells(id, 14).getValue();
			var creationTime  =  gridArea.cells(id, 6).getValue();
			var writeUserNM = gridArea.cells(id, 8).getValue();
			var sysFile = gridArea.cells(id,12).getValue(); //sysfile 
			var fltpName = gridArea.cells(id,2).getValue();
			var itemID = gridArea.cells(id,16).getValue();
			var itemAthId = $('#itemAthId').val();
			var userId = "${sessionScope.loginInfo.sessionUserId}";
			var Blocked = "${Blocked}";
			var Authority = "${sessionScope.loginInfo.sessionAuthLev}";
			var LockOwner = "${LockOwner}";
			if(itemAthId == userId || LockOwner == userId || Authority == "1"){
				var url  = "fileDetail.do";
				var data ="&isNew="+isNew+"&seq="+seq+"&itemID="+itemID+"&pageNum=" + $("#currPage").val()+"&itemClassCode=${itemClassCode}";
				var target = "fileMgtFrm";
				ajaxPage(url,data,target);
			}else{alert("${WM00040}");return;}
		}
	}	
	function fnFileDownload(){
		var cnt  = gridArea.getRowsNum();
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
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
				filePath[j] = gridArea.cells2(i,15).getValue(); // 파일경로
				seq[j] = gridArea.cells2(i,11).getValue(); 
				j++;
			}
		}		
		var frmType = "${frmType}";
		var url  = "fileDownload.do?seq="+seq;
		if(frmType =="documentDetailFrm"){ 
			ajaxSubmitNoAdd(document.documentDetailFrm, url,"saveFrame");
		}else{
			ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
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
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url="addFilePop.do";
		var data="scrnType=ITM_M&browserType="+browserType+"&mgtId="+""+"&id="+$('#itemId').val();
		if(browserType=="IE"){fnOpenLayerPopup(url,data,"",400,400);}
		else{openPopup(url+"?"+data,410,410, "Attach File");}
	}	
	function goNewItemInfo() {
		var url = "NewItemInfoMain.do";
		var target = "actFrame";
		var data = "s_itemID=${itemId}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}"; 
	 	ajaxPage(url, data, target);
	}	
	function fnReload(){
		document.location.reload();
	}
	function fnDeleteFile(){
		var cnt  = gridArea.getRowsNum();
		var sysFileName = new Array();
		var filePath = new Array();
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
				filePath[j] = gridArea.cells2(i,15).getValue(); // 파일경로
				seq[j] = gridArea.cells2(i,11).getValue(); 
				j++;
			}
		}	

		if(confirm("${CM00002}")){
			var url = "deleteFileFromLst.do";
			var data = "&itemId=${itemId}&sysFile="+sysFileName+"&filePath="+filePath+"&seq="+seq;
			var target = "subFrame";
			ajaxPage(url, data, target);	
		}
		
	}
</script>
</head>
<body>
<form name="fileMgtFrm" id="fileMgtFrm" action="" method="post" onsubmit="return false">
	<input type="hidden" id="itemId" name="itemId" value="${itemId}">
	<input type="hidden" id="itemAthId" name="itemAthId" value="${itemAthId}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
	<input type="hidden" id="Blocked" name="Blocked" value="${Blocked}" />
	<input type="hidden" id="LockOwner" name="LockOwner" value="${LockOwner}" />
	<div class="child_search" >
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
			<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchList()" value="검색" />
			<!-- &nbsp;
			<span class="btn_pack medium icon"><span class="reload"></span><input value="Reload" type="button" onclick="doSearchList()"></span>&nbsp;&nbsp; -->
	   </li>
	   <li class="floatR pdR20">	
				<span class="btn_pack medium icon"><span class="upload"></span><input value="Upload" type="button" onclick="fnMultiUpload()"></span>
				<span class="btn_pack medium icon"><span class=del></span><input value="Del" type="submit" onclick="fnDeleteFile()"></span>
				<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="fnFileDownload()"></span>
				<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="goNewItemInfo()" type="submit"></span>
		</li>	
	</div>
	<div class="countList">
              <li class="count">Total  <span id="TOT_CNT"></span></li>
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
</body></html>