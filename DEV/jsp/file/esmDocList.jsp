<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00095" var="WM00095"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>

<script type="text/javascript">
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 200)+"px;");
		};
		$("input.datePicker").each(generateDatePicker);
		$("#excel").click(function (){
			fnGridExcelDownLoad();
		});
		
		$("#TOT_CNT").html(grid.data.getLength());
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
	
	function fnFileDownload(){
		var seq = new Array();
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		
		if(!selectedCell.length){
			alert("${WM00049}");	
		} else {
			for(idx in selectedCell){
				seq[idx] = selectedCell[idx].Seq;
			};
			
			var url  = "fileDownload.do?seq="+seq;
			ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
		}
	}	

</script>
</head>
<body>
<div class="pdL10 pdR10">
<form name="fileMgtFrm" id="fileMgtFrm" action="#" method="post" onsubmit="return false;" >
	<div class="cop_hdtitle pdT10" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 6px 0"><img src="${root}${HTML_IMG_DIR}/icon_folder_upload_title.png">&nbsp;&nbsp;SCR&nbsp;${menu.LN00019}</h3>
	</div>
	<div class="countList">
    	<li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="pdL55 floatL">
        	<input type="text" id="UP_STR_DT" name="UP_STR_DT" value=""	class="input_off datePicker stext" size="8"
				style="width:63px;text-align: center;" onchange="this.value = makeDateType(this.value);" maxlength="15" >
			
			~
			<input type="text" id="UP_END_DT" name="UP_END_DT" value=""	class="input_off datePicker stext" size="8"
				style="width: 63px;text-align: center;" onchange="this.value = makeDateType(this.value);" maxlength="15">
			
			<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="fnReload()" value="Search" style="cursor:pointer;">
		</li>
		<li class="floatR pdR20">	
			<span class="btn_pack medium icon"><span class="download"></span><input value="Download" type="button" onclick="fnFileDownload()"></span>
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</li>	
    </div> 
	<div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>		
</form>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</div>
</body>

<script>
	
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid;
	var pagination;
	var gridData = ${gridData};
	
	grid = new dhx.Grid("grid",  {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center", template: function (text, row, col) { return row.RNUM;} },
	        { width: 30, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], editorType: "checkbox", align: "center", type: "boolean",  editable: true, sortable: false}, 
	        { width: 140, id: "FltpName", header: [{ text: "${menu.LN00091}", align:"center" },{ content: "selectFilter"} ], align: "center"},
	        { width: 110, id: "DocCode", header: [{ text: "DocCode", align:"center" },{content: "inputFilter"}], align: "center"},
	        { width: 40, id: "File", header: [{ text: "", align:"center" }], htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR}/btn_file_down.png" width="24" height="24">';
	            }
	        },	        
	        { id: "FileRealName", header: [{text: "${menu.LN00101}", align:"center"},{content : "inputFilter"}], align:"left" },	          
	       	{ width: 90, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align:"center" }], align:"center" },
	        { width: 100, id: "WriteUserNM", header: [{ text: "${menu.LN00060}", align:"center" }], align:"center" },
	        { width: 120, id: "TeamName", header: [{ text: "${menu.LN00018}", align:"center" }], align:"center" },
	        { width: 80, id: "DownCNT", header: [{ text: "${menu.LN00030}", align:"center" }], align:"center" },	 
	        { id: "Seq", header: [{ text: "Seq", align:"center" }], hidden:true },
	        { id: "SysFile", header: [{text: "SysFile"}], hidden:true},
	        { id: "FileName", header: [{text: "FileName"}], hidden:true},
	        { id: "FltpCode", header: [{text: "FltpCode"}], hidden:true},
	        { id: "FilePath", header: [{text: "FilePath"}], hidden:true},
	        { id: "DcumentID", header: [{text: "DocumentID"}], hidden:true},
	        { id: "ExtFileURL", header: [{text: "ExtFileURL"}], hidden:true},
	        { id: "DocCategory", header: [{text: "DocCategory"}], hidden:true}
	          
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,   
	   
	});
	
	grid.events.on("cellClick", function(row,column,e){	
		if(column.id == "File"){ // 다운로드 이미지 클릭시 					
			let url  = "fileDownload.do?seq="+row.Seq;
			ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
		} else if(column.id == "DocCode"){
			fnItspDetail(row.DocCode,row.DocCategory,row.DocumentID,row.SRID);
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
	 	  
		
 	function fnReloadGrid(newGridData){
 	    fnClearFilter("FltpName");
 		
 		grid.data.parse(newGridData);
 		
 		$("#TOT_CNT").html(grid.data.getLength());
 	
 	}
	
 	function fnClearFilter(columnID) {
 	    var changeEvent = document.createEvent("HTMLEvents");
 	    changeEvent.initEvent("change");
 	    var filter = grid.getHeaderFilter(columnID).querySelector('select');
 	    filter.value = "";
 	    filter.dispatchEvent(changeEvent);
 	}
 	
	function fnReload(){
		let sqlID = "fileMgt_SQL.getFile";
		let updatedStartDT = $("#UP_STR_DT").val();
		let updatedEndDT = $("#UP_END_DT").val();
		
		let param = "&isPublic=N&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+ "&DocCategory=${docCategory}&docDomain=${docDomain}"
				+ "&updatedStartDT="+updatedStartDT
				+ "&updatedEndDT="+updatedEndDT
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
	
	function fnItspDetail(DocCode,DocCategory,DocID){		
		if(DocCategory == "SR"){
			let scrnType = "";
			let isPopup = "Y";
			let url = "processItsp.do?scrnType="+scrnType+"&srID="+DocID+"&isPopup="+isPopup;
			window.open(url,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizable=yes');
		}else{
			let scrnType = "${scrnType}";
			let screenMode = "V";
			let url = "viewScrDetail.do";		
			let data = "&scrID="+DocID+"&screenMode="+screenMode; 
			let w = 1100;
			let h = 800;
			window.open(url+"?"+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
		}
	}
 	
</script>
</html>