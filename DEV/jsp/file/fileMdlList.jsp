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
<%-- <%@ include file="/WEB-INF/jsp/cmm/ui/dhtmlxJsInc.jsp" %> --%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">

	var skin = "dhx_skyblue";
	var now;
	var itemFileOption = "${itemFileOption}";
	
	$(document).ready(function(){ 
		// 초기 표시 화면 크기 조정 
		$("#gridArea").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#gridArea").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		};
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function doSearchList(){
		var sqlID = "fileMgt_SQL.getFile";
		var itemIDs = "${itemIDs}";
		itemIDs = itemIDs.replace("[","").replace("]","");
		var param = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+"&rltdItemId=${rltdItemId}"
			+"&hideBlocked=Y"
			+"&DocCategory=${DocCategory}"
			+"&s_itemID=${s_itemID}"
			+"&DocumentID=${s_itemID}"
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
	        { width: 30, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center", htmlEnable : true }], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 45, id: "CSVersion", header: [{ text: "Ver.", align: "center" } ], align: "center" },
	        { id: "FileRealName", header: [{ text: "${menu.LN00101}", align: "center" } ], align: "left" },
	        { hidden: true, width: 50, id: "Seq", header: [{ text: "Seq", align: "center" } ], align: "left" },
	        { hidden: true, width: 50, id: "ExtFileURL", header: [{ text: "ExtFileURL", align: "center" } ], align: "center" }
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
		pageSize: 20,
	});	
	
	// 상세 화면 
	grid.events.on("cellClick", function(row,column,e){
		
		var seq = row.Seq;
		if((column.id != "checkbox")){
			if("${sessionScope.loginInfo.sessionMlvl}" != "SYS" && "${myItem}" != 'Y' && itemFileOption == "VIEWER" ) {
				var extFileURL = row.ExtFileURL;
				
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
				var url  = "fileDownload.do?seq="+seq;
				ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
			}
		}
	}); 
	
	function fnFileDownload(){
		var originalFileName = new Array();
		var sysFileName = new Array();
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
				seq[j] = row.Seq;
				j++;
			}
		});
		
		var url  = "fileDownload.do?seq="+seq;
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
		goMultiUpload();
	}
	
	function goNewItemInfo() {
		var url = "NewItemInfoMain.do";
		var target = "actFrame";
		var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}"; 
	 	ajaxPage(url, data, target);
	}
	
</script>
</head>
<body>
<div class="pdL10 pdR10">
<form name="fileMgtFrm" id="fileMgtFrm" action="fileDownloadDev.do" method="post" onsubmit="return false">
	<input type="hidden" id="itemId" name="itemId" value="${s_itemID}">
	<input type="hidden" id="itemAthId" name="itemAthId" value="${itemAthId}">
	
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
	<div class="child_search" style="padding:10px 10px 0 0;">
	   <li class="floatR pdR20"> 
			<c:if test="${itemFileOption == 'OLM' or (myItem == 'Y' &&  itemFileOption != 'ExtLink') }">
				<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="fnFileDownload()"></span>
			</c:if>
		</li>	
	</div>
	<div class="countList" style="padding:0 0 0 10px;" >
              <li class="count">Total  <span id="TOT_CNT"></span></li>
              <li class="floatR">&nbsp;</li>
    </div>
	<div id="gridDiv" class="mgB10 clear">
		<div id="gridArea" style="width: 100%;"></div>
	</div>	
	<!-- START :: PAGING -->
	<div id="pagination"></div>
	<!-- END :: PAGING -->		
</form>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</div>
</body></html>