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

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

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
		$("#gridArea").attr("style","height:"+(setWindowHeight() - 340)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#gridArea").attr("style","height:"+(setWindowHeight() - 340)+"px;");
		};
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemTypeCode=${itemTypeCode}";
		fnSelect('languageID', data, 'langType', '${sessionScope.loginInfo.sessionCurrLangType}', 'Select');
		fnSelect('fltpCode', data, 'fltpCode', '', 'Select');
		
		$("input.datePicker").each(generateDatePicker);
		$("#excel").click(function(){
			fnGridExcelDownLoad();
		});
		
		$("#blocked").click(function(){
			if(!$(this).is(':checked')) {
				$("#filtered").val("N");
			}
			else {
				$("#filtered").val("Y");				
			}
			doSearchList();
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
		var sqlID = "fileMgt_SQL.getCxnItemFileList";
		var itemIDs = "${itemIDs}";
		itemIDs = itemIDs.replace("[","").replace("]","");
		var param = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&selectedLanguageID="+$("#languageID").val()
			+ "&fltpCode="+$("#fltpCode").val()
			+ "&startLastUpdated="+$("#startLastUpdated").val()
			+ "&endLastUpdated="+$("#endLastUpdated").val()
			+ "&itemName="+$("#itemName").val()
			+ "&fileName="+$("#fileName").val()
			+ "&regUserName="+$("#regUserName").val()
			+ "&itemIDs="+itemIDs
			+ "&filtered="+$("#filtered").val()
			+ "&sqlID="+sqlID;

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
 		fnMasterChk('');
 		$("#TOT_CNT").html(grid.data.getLength());
 	}
	
	var layout = new dhx.Layout("gridArea", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var gridData = ${gridData};
	var grid = new dhx.Grid("grid", {
	    columns: [
	        { width: 40, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
	        { width: 30, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center" }], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 120, id: "FltpName", header: [{ text: "${menu.LN00091}", align: "center" } ], align: "left" },
	        
	        { width: 40, id: "down", header: [{ text: "File", align:"center" }], htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR}/btn_file_down.png" width="24" height="24">';
	            }
	        },
	        { width: 120, id: "Identifier", header: [{ text: "${menu.LN00106}", align: "center" } ], align: "left" },
	        { width: 200,id: "ItemName", header: [{ text: "${menu.LN00087}", align: "center" } ], align: "left" },
	        { id: "FileRealName", header: [{ text: "${menu.LN00101}", align: "center" } ], align: "left" },
	        { width: 40, id: "LanguageCode", header: [{ text: "${menu.LN00147}", align: "center" } ], align: "center" },
	        { width: 70, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align: "center" } ], align: "center" },
	        { width: 70, id: "RegUserName", header: [{ text: "${menu.LN00060}", align: "center" } ], align: "center" },
	        { width: 50, id: "DownCNT", header: [{ text: "${menu.LN00030}", align: "center" } ], align: "center" },
	        { hidden: true, width: 40, id: "Seq", header: [{ text: "Seq", align: "center" } ], align: "left" },
	        { hidden: true, width: 50, id: "SysFile", header: [{ text: "SysFileWidthPath", align: "center" } ], align: "center" },
	        { hidden: true, width: 50, id: "FltpCode", header: [{ text: "FltpCode", align: "center" } ], align: "center" },
	        { hidden: true, width: 50, id: "FilePath", header: [{ text: "FilePath", align: "center" } ], align: "center" },
	        { hidden: true, width: 50, id: "DocumentID", header: [{ text: "DocumentID", align: "center" } ], align: "center" }

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
		pageSize: 50,
	});	

	
	// 상세 화면 
	grid.events.on("cellClick", function(row,column,e){
		var originalFileName = row.FileRealName;
		var sysFileName = row.SysFile;
		var filePath = row.FilePath;
		var seq = row.Seq;
		var isNew = "N";
		var DocumentID = row.DocumentID;
	if(column.id == "down"){ // 다운로드 이미지 클릭시 
		var url  = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.fileFrm, url,"subFrame");	
	}else if(column.id != "checkbox"){
		var isNew = "N";
		var url  = "documentDetail.do?isNew="+isNew+"&seq="+seq
				+"&DocumentID="+DocumentID+"&pageNum="+$("#currPage").val()
				+"&itemTypeCode=${itemTypeCode}&fltpCode=${fltpCode}";
		var w = 1200;
		var h = 500;
		itmInfoPopup(url,w,h); 	
		}
	}); 
	
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
				sysFileName[j] = row.SysFileName;
				originalFileName[j] = row.FileRealName;
				filePath[j] = row.FilePath;
				seq[j] = row.Seq;
				j++;
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
	
	function fnGoCxnItemTreeMgt() {
		var url = "cxnItemTreeMgt.do";
		var target = "actFrame";
		var data = "s_itemID=${s_itemID}"
					+ "&childCXN=${childCXN}"
					+ "&cxnTypeList=${cxnTypeList}"
					+ "&option=${option}"
					+ "&varFilter=${filter}"
					+ "&screenMode=${screenMode}"; 
		ajaxPage(url, data, target);
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
	<div class="child_search_head" >
		<span class="flex align-center">
			<span class="back" onclick="fnGoCxnItemTreeMgt();"><span class="icon arrow"></span></span>
	  <b>${menu.LN00111}</b>
	  </span>
	  </div>
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
		    	<input type="text" id="startLastUpdated" name="startLastUpdated" class="input_off datePicker stext" size="8"
					style="width: 63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				
				~
				<input type="text" id="endLastUpdated" name="endLastUpdated" class="input_off datePicker stext" size="8"
					style="width: 63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				
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
	<div class="countList pdT5 pdB20" >
	  <li class="alignC">
           	<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="doSearchList()"/>
        	<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;" onclick="fnClearSearch();" >
        </li>
        <li class="count pdT5">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR pdR10">
        	<span class="mgT5" >&nbsp;<b>The latest</b> <input type="checkbox" id="blocked" name="blocked" value="Y" checked="checked"/></span>
        	<span class="btn_pack nobg white"><a class="download"onclick="fnFileDownload()" title="Download"></a></span>
        	<span class="btn_pack nobg white"><a class="xls" id="excel" title="Excel"></a></span>
        </li>
    </div>
	<div id="gridDiv" style="width:100%;" class="clear" >
		<div id="gridArea"></div>
	</div>	
	<!-- START :: PAGING -->
	<div id="pagination"></div>
	<!-- END :: PAGING -->		
</form>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body></html>