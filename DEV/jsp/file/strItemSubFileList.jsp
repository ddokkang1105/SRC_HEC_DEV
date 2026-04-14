<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
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

<script type="text/javascript">

	var gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	
	var userId = "${sessionScope.loginInfo.sessionUserId}";	
	var Authority = "${sessionScope.loginInfo.sessionAuthLev}";
	var selectedItemLockOwner = "${selectedItemLockOwner}";
	var selectedItemAuthorID = "${selectedItemAuthorID}";
	var selectedItemBlocked = "${selectedItemBlocked}";
	var selectedItemStatus = "${selectedItemStatus}";
	var showVersion = "${showVersion}";
	var showValid = "${showValid}";
	var showPath = "${showPath}";
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 320)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 320)+"px;");
		};
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&itemTypeCode=${itemTypeCode}&docCategory=${docCategory}";
		fnSelect('languageID', data, 'langType', '${sessionScope.loginInfo.sessionCurrLangType}', 'Select');
		fnSelect('fltpCode', data, 'fltpCode', '', 'Select');
		
		$("input.datePicker").each(generateDatePicker);
		
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
	
	function fnCheckItemArrayAccRight(seq, DocumentID, id, strItemID){
		$.ajax({
			url: "checkItemArrayAccRight.do",
			type: 'post',
			data: "&itemIDs="+DocumentID+"&seq="+seq+"&strItemID="+strItemID,
			error: function(xhr, status, error) { 
			},
			success: function(data){				
				data = data.replace("<script>","").replace(";<\/script>","");		
				fnCheckAccCtrlFileDownload(data, seq, DocumentID, id, strItem);
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
						+"&DocumentID="+DocumentID
						+"&itemTypeCode=${itemTypeCode}&fltpCode=${fltpCode}"
						+"&strItemID="+strItemID;
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

	function fnClearSearch(){
		$("#languageID").val("");
		$("#fltpCode").val("");
		$("#startLastUpdated").val("");
		$("#endLastUpdated").val("");
		$("#itemName").val("");
		$("#fileName").val("");
		$("#regUserName").val("");
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
	
</script>
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
	  <b style="margin:10px 0;">${menu.LN00111}</b>
	  </span>
	  </div>
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_blue01 mgT10" id="search">
		<colgroup>
		    <col width="10%">
		    <col width="20%">
		 	<col width="10%">
		    <col width="20%">
		 	<col width="10%">
		    <col width="30%">	
			   		
	    </colgroup>
	    <tr>
	       	
	       	<!-- 문서유형 -->
	        <th class="alignL pdL5">${menu.LN00091}</th>
	        <td class="alignL">      
	        <select id="fltpCode" Name="fltpCode" style="width:90%">
	            <option value=''>Select</option>
	        </select>
	        </td>
	        <th class="alignL pdL5">${menu.LN00147}</th>
	        <td class="alignL">     
		       	<select id="languageID" Name="languageID" style="width:90%">
		       		<option value=''>Select</option>
		       	</select>
	       	</td>
	       	<!-- 수정일 -->
	       	<th class="alignL pdL5">${menu.LN00070}</th>
	        <td class="alignL last">  
		    	<input type="text" id="startLastUpdated" name="startLastUpdated" class="input_off datePicker stext" size="8"
					style="width: 100px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				
				~
				<input type="text" id="endLastUpdated" name="endLastUpdated" class="input_off datePicker stext" size="8"
					style="width: 100px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				
	       	</td>     	
	    </tr>
	    <tr>
	   		<!-- 프로세스명칭 -->
	       	<th class="alignL pdL5">${itemTypeName}&nbsp;${menu.LN00028}</th>
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
	        <td class="alignL last">       
		     	<input type="text" class="text" id="regUserName" name="regUserName" style="ime-mode:active;width:70%;" />
		     	 &nbsp; &nbsp; <input type="checkbox" id="blocked" name="blocked" value="Y" checked="checked"/> &nbsp;<b>The latest</b>
		    </td>       	
	    </tr>
   	</table>
	<div class="countList pdT5 flex" >
	  <li class="count mgT10">Total  <span id="TOT_CNT"></span></li>
	 <li class="floatC">
            <input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="fnReload()"/>
         	<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;" onclick="fnClearSearch();" >
         	 </li>
      
        <li class="floatR mgR20">
        	<span class="btn_pack nobg white "><a class="download" OnClick="fnFileDownload()" title="Download" ></a></span>
        	<c:if test="${loginInfo.sessionMlvl == 'SYS'}" >
        	        	<span class="btn_pack nobg "><a class="block"  onclick="fnBlock()" title="Block" ></a></span>
        	</c:if>
        	<span class="btn_pack nobg white"><a class="xls" title="List Down" id="excel"></a></span>
        
     
        </li>
    </div>
	<div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>
</form>

<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
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
	
	var grid = new dhx.Grid("grid",  {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center"},
	        { width: 30, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" }], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 120, id: "FltpName", header: [{ text: "${menu.LN00091}", align:"center"}], align:"center"},
	        { width: 40, id: "FileIcon", header: [{ text: "File", align:"center" }], htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR}/btn_file_down.png" width="18" height="18">';
	            }
	        },
	        { width: 300, id: "FileRealName", header: [{ text: "${menu.LN00101}", align:"center" }], align:"left"},
	        
	        { width: 110, id: "ClassName", header: [{text: "${menu.LN00016}", align:"center"}], align: "center"},
	        { width: 90, id: "Identifier", header: [{text: "ID", align:"center"}], align: "center"},
	        { width: 150, id: "ItemName", header: [{ text: "${menu.LN00028}", align:"center" }], htmlEnable: true, align:"left"},	
	        { width: 520, id: "ItemPath", header: [{ text: "${menu.LN00043}", align:"center" }], htmlEnable: true, align:"left"},	
	        
	        { width: 80, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align:"center" }], align:"center"},
	        { width: 80, id: "RegUserName", header: [{ text: "${menu.LN00060}", align:"center" }], align:"center"},
	        { width: 60, id: "LanguageCode", header: [{ text: "${menu.LN00147}", align:"center" }], align:"center"},
	        { width: 70, id: "DownCNT", header: [{ text: "${menu.LN00030}", align:"center" }], align:"center"},
	        { width: 70, id: "StrItemID", header: [{ text: "StrItemID" }], hidden: true, align:"center"},
	      
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    multiselection : true   
	    
	});
	
	$("#TOT_CNT").html(grid.data.getLength());
	
	//var tranSearchCheck = false;
	grid.events.on("cellClick", function(row,column,e){
		var seq = row.Seq;
		var isNew = "N";
		var DocumentID = row.DocumentID;	
		var strItemID = row.StrItemID;
		if(column.id != "checkbox"){
			if( '${loginInfo.sessionMlvl}' != "SYS"){
				fnCheckItemArrayAccRight(seq, DocumentID, column.id, strItemID); // 접근권한 체크후 DownLoad
			}else{
				if(column.id == "FileIcon"){ // 다운로드 이미지 클릭시 
					var url  = "fileDownload.do?seq="+seq;
						ajaxSubmitNoAdd(document.fileFrm, url,"blankFrame");			
				}else{						
					var url  = "documentDetail.do?isNew="+isNew+"&seq="+seq
							+"&DocumentID="+DocumentID
							+"&itemTypeCode=${itemTypeCode}&fltpCode=${fltpCode}"
							+"&strItemID="+strItemID;
					var w = 1200;
					var h = 500;
					itmInfoPopup(url,w,h); 	
				}
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
		var sqlID = "fileMgt_SQL.getStrItemSubFileList";
		var param =  "strItemID=${strItemID}"	
			 	+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+ "&selectedLanguageID="+$("#languageID").val()
				+ "&fltpCode="+$("#fltpCode").val()
				+ "&startLastUpdated="+$("#startLastUpdated").val()
				+ "&endLastUpdated="+$("#endLastUpdated").val()
				+ "&itemName="+$("#itemName").val()
				+ "&fileName="+$("#fileName").val()
				+ "&regUserName="+$("#regUserName").val()
				+ "&filtered="+$("#filtered").val()
				+ "&showVersion="+showVersion
				+ "&s_itemID=${s_itemID}"
				+ "&sqlID="+sqlID;
				if(classCode != ""){
					result.data = result.data + "&classCode="+classCode;
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
 		fnMasterChk('');
 		$("#TOT_CNT").html(grid.data.getLength());
 	}
 	
</script>

</html>