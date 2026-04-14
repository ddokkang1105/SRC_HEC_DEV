<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00123" var="WM00123"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00018" var="WM00018"/>

<script type="text/javascript">

	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 350)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 350)+"px;");
		};
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemTypeCode=${itemTypeCode}";
		fnSelect('languageID', data, 'langType', '${sessionScope.loginInfo.sessionCurrLangType}', 'Select');
	
		
		$("#blocked").click(function(){
			if(!$(this).is(':checked')) {
				$("#filtered").val("N");
			}
			else {
				$("#filtered").val("Y");				
			}
			fnReload();
		});
		
		$("#excel").click(function(){ fnGridExcelDownLoad(); });
		
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
	
	function fnCheckItemArrayAccRight(seq, DocumentID, id){
		$.ajax({
			url: "checkItemArrayAccRight.do",
			type: 'post',
			data: "&itemIDs="+DocumentID+"&seq="+seq,
			error: function(xhr, status, error) { 
			},
			success: function(data){				
				data = data.replace("<script>","").replace(";<\/script>","");		
				fnCheckAccCtrlFileDownload(data, seq, DocumentID, id);
			}
		});	
	}
	
	function fnCheckAccCtrlFileDownload(data, seq, DocumentID, id, strItemID){
		var dataArray = data.split(",");
		var accRight = dataArray[0];
		var fileName = dataArray[1];
		
		if(accRight == "Y"){
			if(id == "FileIcon"){ // 다운로드 이미지 클릭시 
				var url  = "fileDownload.do?seq="+seq;
					ajaxSubmitNoAdd(document.fileFrm, url,"blankFrame");			
			}else{						
				var url  = "documentDetail.do?&seq="+seq
						+"&DocumentID="+DocumentID+"strItemID="+strItemID
						+"&itemTypeCode=${itemTypeCode}&fltpCode=${fltpCode}";
				var w = 1200;
				var h = 500;
				itmInfoPopup(url,w,h); 	
			}
		}else{			
			alert(fileName + "은 ${WM00033}"); return;
		}
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
			
			$("#seq").val(seq);
			var url  = "fileDownload.do";
			ajaxSubmitNoAdd(document.fileFrm, url,"blankFrame");
		}
	}	
	
	function fnStrItemFileDownLoad(){
		
		$("#loading").fadeIn(150);
		var url  = "zSkdc_strItemfileDownload.do?strItemID=${strItemID}&s_itemID=${s_itemID}&udfSTR=${udfSTR}";
		ajaxSubmit(document.fileFrm, url,"blankFrame");
		
		setTimeout(function() { $("#loading").fadeOut(150); }, 120000);
		
	}

	function fnBlock(){
		var seq = new Array();
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		
		if(!selectedCell.length){
			alert("${WM00023}"); return;
		} else {
			for(idx in selectedCell){
				seq[idx] = selectedCell[idx].Seq;
			};
		}
		
		if(confirm("${CM00001}")){	
			var url  = "updateFileBlocked.do";
			var data = "&seq="+seq;
			ajaxPage(url,data,"blankFrame");
		}
	}
	
	function doSearchList(){
		fnReload();
	}
	
	function setSubFrame(){
		fnReload();
	}
	
	function fnClearSearch(){
		$("#identifier").val("");
		$("#itemName").val("");
		$("#AT00000").val("");
		$("#level").val("");
		$("#levelName").val("");
	}
	
	function fnEditAttr(){
		var url = "zSkdc_editSubItemFileList.do";
		var target = "subItemFileDiv";
		var data = "s_itemID=${s_itemID}&strItemID=${strItemID}&mstItemID=${mstItemID}&udfSTR=${udfSTR}"; 
	 	ajaxPage(url, data, target);
	}
	
</script>
<style>
	.cmm-btn {border: 1px solid #dfdfdf; background: #fff;border-radius: 3px;height: 33px;transition: all .2s ease-out;}
</style>
<body>
<div id="subItemFileDiv" name="subItemFileDiv" >
<form name="fileFrm" id="fileFrm" action="" method="post" onsubmit="return false">
	<input type="hidden" id="itemAthId" name="itemAthId" value="${selectedItemAuthorID}">
	<input type="hidden" id="Blocked" name="Blocked" value="${selectedItemBlocked}" />
	<input type="hidden" id="LockOwner" name="LockOwner" value="${selectedItemLockOwner}" />	
	<input type="hidden" id="sysFileName" name="sysFileName">
	<input type="hidden" id="originalFileName" name="originalFileName">
	<input type="hidden" id="filePath" name="filePath" >
	<input type="hidden" id="seq" name="seq" >	
	<input type="hidden" id="filtered" value="Y"> 
	
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_blue01 mgT10" id="search">
		<colgroup>
		    <col width="20%">
		    <col width="30%">
		 	<col width="20%">
		    <col width="30%">
	    </colgroup>
	    <tr>
	        <th class="alignL pdL5">ID</th>
	        <td class="alignL">      
		       <input type="text" class="text" id="identifier" name="identifier" style="ime-mode:active;width:90%;" />
	        </td>
	        <th class="alignL pdL5">${menu.LN00028}</th>
	        <td class="alignL last">     
		       <input type="text" class="text" id="itemName" name="itemName" style="ime-mode:active;width:90%;" />
	       	</td>
	    </tr>
	     <tr>
	       	<th class="alignL pdL5">Level</th>
	        <td class="alignL">     
		    	<select id="level" name="level" style="width:80px;">
		    		<!-- <option value="">Select</option> -->
					<option value="L1">L1</option>
					<option value="L2">L2</option>
					<option value="L3">L3</option>
					<option value="L4">L4</option>
					<option value="L5">L5</option>
				</select>
				<input type="text" id="levelName" name="levelName" value="" class="text" style="width:250px;ime-mode:active;">
	       	</td>
	       	<th class="alignL pdL5">설비 Item No.</th>
	        <td class="last alignL">  
		    	<input type="text" class="text" id="AT00000" name="AT00000" style="ime-mode:active;width:90%;" />
	       	</td>     	
	    </tr>
   	</table>
   	
	<div class="countList pdT5 flex" >
	  	<li class="count mgT10 floatL">Total  <span id="TOT_CNT"></span></li>
	  	<li class="floatC">
            <input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="doSearchList()"/>
         	<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;" onclick="fnClearSearch();" >
        </li>
    	<li class="floatR mgR20">
			<span id="editBtn" class="btn_pack nobg white"><a class="edit" onclick="fnEditAttr();" title="Edit"></a></span>
        	<span class="btn_pack nobg white "><a class="download" OnClick="fnFileDownload()" title="Download" ></a></span>   
        	<button class="cmm-btn" onclick="fnStrItemFileDownLoad()">Download All</button>   
        	<span class="btn_pack nobg white"><a class="xls" title="List Down" id="excel"></a></span>
        </li>
    </div>
	<div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>
</form>

<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>
</body>

<style>

	.dhx_grid-body{
		cursor : default !important;
	}
	
	.cell-pointer {
    	cursor: pointer !important;
	}
	
</style>

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
	
	var grid = new dhx.Grid("grid",  {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center"},
	        { width: 30, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" }], align: "center", type: "boolean", editable: true, sortable: false},
	        
	        { width: 40, id: "FileIcon", header: [{ text: "File", align:"center" }], htmlEnable: true, align: "center", mark: () => ("cell-pointer"),
	        	template: function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR}/btn_file_down.png" width="18" height="18">';
	            }
	        },
	        { width: 40, id: "FileDetail", header: [{ text: "상세", align:"center" }], htmlEnable: true, align: "center",mark: () => ("cell-pointer"),
	        	template: function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR}/icon_docu.png" width="18" height="18">';
	            }
	        },
	        { width: 110, id: "Identifier", header: [{text: "ID", align:"center"}], align: "center", mark: () => ("cell-pointer")},
	        { width: 280, id: "ItemName", header: [{ text: "${menu.LN00028}", align:"center" }], htmlEnable: true, align:"left", mark: () => ("cell-pointer")},
	        { width: 300, id: "FileRealName", header: [{ text: "${menu.LN00101}", align:"center"},{content : "inputFilter"}], align:"left" , hidden: true, mark: () => ("cell-pointer")},
	        
	        { width: 125, id: "L0ItemName", header: [{text: "L0", align:"center"},{content : "selectFilter"}], align: "center", mark: () => ("cell-pointer"),},
	        { width: 125, id: "L1ItemName", header: [{text: "L1", align:"center"},{content : "selectFilter"}], align: "center", mark: () => ("cell-pointer"),},
	        { width: 125, id: "L2ItemName", header: [{text: "L2", align:"center"},{content : "selectFilter"}], align: "center", mark: () => ("cell-pointer"),},
	        { width: 125, id: "L3ItemName", header: [{text: "L3", align:"center"},{content : "selectFilter"}], align: "center", mark: () => ("cell-pointer"),},
	        { width: 125, id: "L4ItemName", header: [{text: "L4", align:"center"},{content : "selectFilter"}], align: "center", mark: () => ("cell-pointer"),},
	        { width: 125, id: "L5ItemName", header: [{text: "L5", align:"center"},{content : "selectFilter"}], align: "center", mark: () => ("cell-pointer"),},
	        { width: 140, id: "ItemNo", header: [{text: "설비 Item No.", align:"center"},{content : "inputFilter"}], align: "center"},
	        { width: 60, id: "ClassName", header: [{text: "${menu.LN00016}", align:"center"}], align: "center"},
	        { width: 80, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align:"center" }], align:"center"},
	        { width: 80, id: "RegUserName", header: [{ text: "${menu.LN00060}", align:"center" }], align:"center"},
	        { width: 60, id: "LanguageCode", header: [{ text: "${menu.LN00147}", align:"center" }], align:"center" , hidden: true},
	        { width: 60, id: "StrItemID", header: [{ text: "${menu.LN00030}", align:"center" }], align:"center", hidden: true},
	        { width: 60, id: "ExtFileURL", header: [{ text: "ExtFileURL", align:"center" }], align:"center", hidden: true},
	      
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    multiselection : true//,
	   // autoEmptyRow: true
	    
	});
	
	var htmlCode = "<div class='dhx_grid_data2'><p style='text-align:center;font-size:14px;margin:10px;'>${WM00018}</p></div>";
	 $(".dhx_data-wrap").append(htmlCode);
	if(grid.data.getLength() == 0){
        $(".dhx_grid_data").hide(); 
		$(".dhx_data-wrap").css("height","400px");
	}

	$("#TOT_CNT").html(grid.data.getLength());
	
	//var tranSearchCheck = false;
	grid.events.on("cellClick", function(row,column,e){
		var seq = row.Seq;
		var isNew = "N";
		var DocumentID = row.DocumentID;	
		var strItemID = row.StrItemID;
		var extFileURL = row.ExtFileURL;	
		
		if(column.id != "checkbox" && column.id != "RNUM" && column.id != "ClassName" && column.id != "ItemNo" && column.id != "LastUpdated" && column.id != "RegUserName" ){
			if(column.id == "FileIcon"){ // 다운로드 이미지 클릭시 
				var url  = "fileDownload.do?seq="+seq;
					ajaxSubmitNoAdd(document.fileFrm, url,"blankFrame");
					
			} else if(column.id == "FileDetail"){
				var url  = "documentDetail.do?isNew="+isNew+"&seq="+seq
						+"&DocumentID="+DocumentID+"&strItemID="+strItemID
						+"&itemTypeCode=${itemTypeCode}";
				var w = 1200;
				var h = 700;
				itmInfoPopup(url,w,h); 
				
			} else if(column.id == "L0ItemName"){
				var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+row.L0StrItemID+"&scrnType=pop&option=${arcCode}";
				var w = 1400;
				var h = 900;
				itmInfoPopup(url,w,h,row.L0ItemID);
				
			} else if(column.id == "L1ItemName"){
				
				var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+row.L1StrItemID+"&scrnType=pop&option=${arcCode}";
				var w = 1400;
				var h = 900;
				itmInfoPopup(url,w,h,row.L1ItemID);
				
			} else if(column.id == "L2ItemName"){
				
				var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+row.L2StrItemID+"&scrnType=pop&option=${arcCode}";
				var w = 1400;
				var h = 900;
				itmInfoPopup(url,w,h);
				
			} else if(column.id == "L3ItemName"){
				
				var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+row.L3StrItemID+"&scrnType=pop&option=${arcCode}";
				var w = 1400;
				var h = 900;
				itmInfoPopup(url,w,h,row.L3ItemID);
			
			} else if(column.id == "L4ItemName"){
				
				var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+row.L4StrItemID+"&scrnType=pop&option=${arcCode}";
				var w = 1400;
				var h = 900;
				itmInfoPopup(url,w,h,row.L4ItemID);
			
			} else if(column.id == "L5ItemName"){
				
				var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+row.L5StrItemID+"&scrnType=pop&option=${arcCode}";
				var w = 1400;
				var h = 900;
				itmInfoPopup(url,w,h,row.L5ItemID);
				
			} else if(column.id == "ItemNo"){
				
				var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+row.ToItemID+"&scrnType=pop&option=${arcCode}";
				var w = 1400;
				var h = 900;
				itmInfoPopup(url,w,h,row.ToItemID);
			} else if(column.id == "Identifier"){
				
				var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+row.StrItemID+"&scrnType=pop&option=${arcCode}";
				var w = 1400;
				var h = 900;
				itmInfoPopup(url,w,h,row.StrItemID);
				
			} else if(column.id == "ItemName"){
				
				var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+row.StrItemID+"&scrnType=pop&option=${arcCode}";
				var w = 1400;
				var h = 900;
				itmInfoPopup(url,w,h,row.ToItemID);
				
			}
			else{						
				var url = "openViewerPop.do?seq="+row.Seq;
				var w = 1200;
				var h = 900;
				if(extFileURL != "") { 
					w = screen.availWidth-38;
					h = screen.avilHeight;
					url = url + "&isNew=N";	
				} else { url = url + "&isNew=Y"; }
				
				itmInfoPopup(url,w,h); 			
			}
			
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
	
 	function fnReload(){ 
 		$(".dhx_data-wrap").css("height","400px");
 		var varFilter ="${classCode}";
		var classCode = "";
		if(varFilter != ""){
			var classCodeSpl = varFilter.split(",");				
				if(classCodeSpl.length >0){
					for(var i=0; i<classCodeSpl.length; i++){
					if(i==0){
						classCode += "'"+classCodeSpl[i]+"'";
					}else{
			  			classCode += ",'"+classCodeSpl[i]+"'";
					}
				}
			}
		}
		if($("#startLastUpdated").val() != "" && $("#endLastUpdated").val() == "")	$("#endLastUpdated").val(new Date().toISOString().substring(0,10));
		
		var level = $("#level").val();
		var levelName = $("#levelName").val();
		var categoryCode = "ST2";
		if("${udfSTR}"=="Y"){
			categoryCode = "ST3";
		}
		
		var sqlID = "custom_SQL.zSkdc_getSubItemFileList";
		var param =  "strItemID=${strItemID}"	
				+ "&s_itemID=${mstItemID}"
			 	+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			 	+ "&identifier="+$("#identifier").val()
				+ "&itemName="+$("#itemName").val()
				+ "&AT00000="+$("#AT00000").val()
				+ "&udfSTR=${udfSTR}"
				+ "&categoryCode="+categoryCode
				+ "&sqlID="+sqlID;
				
				if(level == "L1"){
					param = param + "&L1="+levelName;
				} else if(level == "L2"){
					param = param + "&L2="+levelName;
				} else if(level == "L3"){
					param = param + "&L3="+levelName;
				} else if(level == "L4"){
					param = param + "&L4="+levelName;
				} else if(level == "L5"){
					param = param + "&L5="+levelName;
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
 		const obj = JSON.parse(newGridData); 		
 		if(obj.length == 0){
 			$("#TOT_CNT").html(obj.length);
 	        $(".dhx_grid_data").hide(); 
 	        $(".dhx_grid_data2").show();
 		}else{
 	 		$(".dhx_grid_data").show();
 	 		$(".dhx_grid_data2").hide();
 	 		
 	 		var rowCount = obj.length; 
 	        var rowHeight = 32; 
 	        var gridHeight = rowCount * rowHeight; 
 	        
 	        $(".dhx_grid_data").css("height", gridHeight + "px");
 	 		
 	 		grid.data.parse(newGridData);
 	 		fnMasterChk('');
 	 		$("#TOT_CNT").html(obj.length);
 		}
 	}
 	
</script>

</html>