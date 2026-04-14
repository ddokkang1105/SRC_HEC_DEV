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

<script type="text/javascript">

	var gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	
	var userId = "${sessionScope.loginInfo.sessionUserId}";	
	var Authority = "${sessionScope.loginInfo.sessionAuthLev}";
	var selectedItemLockOwner = "${selectedItemLockOwner}";
	var selectedItemAuthorID = "${selectedItemAuthorID}";
	var selectedItemBlocked = "${selectedItemBlocked}";
	var selectedItemStatus = "${selectedItemStatus}";
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#gridArea").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#gridArea").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		};
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemTypeCode=${itemTypeCode}";
		fnSelect('languageID', data, 'langType', '${sessionScope.loginInfo.sessionCurrLangType}', 'Select');
		fnSelect('fltpCode', data, 'fltpCode', '', 'Select');
		
		$("input.datePicker").each(generateDatePicker);
		
		gridInit();				
		setTimeout(function() {doSearchList();}, 500);
		$("#excel").click(function(){
			doExcel();
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
	
	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(gridArea, d.key, d.cols, d.data);
	}
	
	function gridInit(){	
		var d = setGridData();
		gridArea = fnNewInitGrid("gridArea", d);
		gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		gridArea.setIconPath("${root}${HTML_IMG_DIR}/btn_file_add.png");

		fnSetColType(gridArea, 1, "ch");
		fnSetColType(gridArea, 3, "img");
		gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		
		gridArea.setColumnHidden(11, true);
		gridArea.setColumnHidden(12, true);
		gridArea.setColumnHidden(13, true);
		gridArea.setColumnHidden(14, true);
		gridArea.setColumnHidden(15, true);
		
		gridArea.enablePaging(true,50,10,"pagingArea",true,"recInfoArea");
		gridArea.setPagingSkin("bricks");
		gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	
	function setGridData(){
		var result 	= new Object();
		var itemIDs = "${itemIDs}";
		itemIDs = itemIDs.replace("[","");
		itemIDs = itemIDs.replace("]","");
		result.title 	= "${title}";
		result.key 	= "fileMgt_SQL.getCxnItemFileList";
		result.header = "No,#master_checkbox,${menu.LN00091},File,${menu.LN00106},${menu.LN00087},${menu.LN00101},${menu.LN00147},${menu.LN00070},${menu.LN00060},${menu.LN00030},Seq,SysFile,FltpCode,FilePath,DocumentID";
		result.cols 	= "CHK|FltpName|down|Identifier|ItemName|FileRealName|LanguageCode|LastUpdated|RegUserName|DownCNT|Seq|SysFile|FltpCode|FilePath|DocumentID";
		result.widths = "30,30,120,30,90,200,*,30,70,70,40,40,50,50,50,50";
		result.sorting = "int,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,left,center,left,left,left,center,center,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&selectedLanguageID="+$("#languageID").val()
					+ "&fltpCode="+$("#fltpCode").val()
					+ "&startLastUpdated="+$("#startLastUpdated").val()
					+ "&endLastUpdated="+$("#endLastUpdated").val()
					+ "&itemName="+$("#itemName").val()
					+ "&fileName="+$("#fileName").val()
					+ "&regUserName="+$("#regUserName").val()
					+ "&itemIDs="+itemIDs;
					
    	return result;
	}
	
	// 상세 화면 
	function gridOnRowSelect(id, ind){
		var originalFileName = gridArea.cells(id, 6).getValue();
		var sysFileName = gridArea.cells(id, 12).getValue();
		var filePath = gridArea.cells(id,14).getValue();
		var seq = gridArea.cells(id, 11).getValue();
		var isNew = "N";
		
		var DocumentID = gridArea.cells(id,15).getValue();	
		
		if(ind==3){ // 다운로드 이미지 클릭시 
			var url  = "fileDownload.do?seq="+seq;
				ajaxSubmitNoAdd(document.fileFrm, url,"subFrame");			
		}else{						
			var url  = "documentDetail.do?isNew="+isNew+"&seq="+seq
					+"&DocumentID="+DocumentID+"&pageNum="+$("#currPage").val()
					+"&itemTypeCode=${itemTypeCode}&fltpCode=${fltpCode}";
			var w = 1200;
			var h = 500;
			itmInfoPopup(url,w,h); 	
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
				originalFileName[j] =  gridArea.cells2(i,6).getValue(); // orignalfile
				filePath[j] = gridArea.cells2(i,14).getValue(); // 파일경로
				seq[j] = gridArea.cells2(i,11).getValue(); 
				j++;
			}
		}		
		
		$("#sysFileName").val("");
		$("#originalFileName").val("");
		$("#seq").val(seq);
		var url  = "fileDownload.do";
		ajaxSubmitNoAdd(document.fileFrm, url,"subFrame");
	}	
		
	function doExcel() {
		gridArea.toExcel("${root}excelGenerate");
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
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_blue01" id="search">
		<colgroup>
		    <col width="13%">
		    <col width="20%">
		 	<col width="13%">
		    <col width="20%">
		 	<col width="13%">
		    <col width="21%">			   		
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
		    	<font><input type="text" id="startLastUpdated" name="startLastUpdated" class="input_off datePicker stext" size="8"
					style="width: 63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				</font>
				~
				<font><input type="text" id="endLastUpdated" name="endLastUpdated" class="input_off datePicker stext" size="8"
					style="width: 63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				</font>
	       	</td>     	
	    </tr>
	    <tr>
	   		<!-- 프로세스명칭 -->
	       	<th class="alignL pdL5">${menu.LN00087}</th>
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
		     	<input type="text" class="text" id="regUserName" name="regUserName" style="ime-mode:active;width:90%;" />
		     </td>       	
	    </tr>
   	</table>
	<div class="countList pdT5 pdB5" >
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
           	&nbsp;<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="doSearchList()"/>
        	<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;" onclick="fnClearSearch();" >
        	<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="fnFileDownload()"></span>
        	<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
        </li>
    </div>
	<div id="gridDiv" style="width:100%;" class="clear" >
		<div id="gridArea"></div>
	</div>	
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->		
</form>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body></html>