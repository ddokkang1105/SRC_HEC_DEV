<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
			//그리드 전역변수
$(document).ready(function(){	
	// 초기 표시 화면 크기 조정 
	$("#layout").attr("style","height:"+(setWindowHeight() - 220)+"px; width:100%;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#layout").attr("style","height:"+(setWindowHeight() - 220)+"px; width:100%;");
	};
	
	$("#excel").click(function(){ fnGridExcelDownLoad(); });	
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

function urlReload() {
	fnReload();
}

function fnCheckItemArrayAccRight(itemIDs){
	$.ajax({
		url: "checkItemArrayAccRight.do",
		type: 'post',
		data: "&itemIDs="+itemIDs,
		error: function(xhr, status, error) { 
		},
		success: function(data){	
			data = data.replace("<script>","").replace(";<\/script>","");		
			fnCheckAccCtrlFilePopOpen(data,itemIDs);
		}
	});	
}

function fnCheckAccCtrlFilePopOpen(data,itemIDs){
	var dataArray = data.split(",");
	var accRight = dataArray[0];
	var fileName = dataArray[1];
	
	if(accRight == "Y"){
		var url = "selectFilePop.do";
		var data = "?s_itemID="+itemIDs; 
	   
	    var w = "400";
		var h = "350";
	    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}else{			
		alert("${WM00033}"); return;
	}
}

function doDetail(avg1){
	var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop"+"&accMode=${accMode}&option=PAL015&loadEdit=Y";
	var w = 1400;
	var h = 900;
	itmInfoPopup(url,w,h,avg1);
	
}
function fnCallBack(){doTcSearchList();}
function doCallBackMove(){}
function doCallBackRef(){doPPSearchList();}

</script>	
<form name="processList" id="processList" action="#" method="post" onsubmit="return false;">
	<div id="subItemListDiv" name="subItemListDiv" style="margin-bottom:5px;">		
        <div class="countList">
        	<li class="count">Total  <span id="TOT_CNT"></span></li>            
			<li class="floatR pdR10">
				<c:if test="${s_itemClassCode eq 'CL15003' }" ><span class="floatR btn_pack nobg mgR6"><a class="add" id="Input" OnClick="fnAddCerti();" title="Input"></a></span></c:if>
        		<span class="btn_pack nobg white"><a class="xls" id="excel" title="Excel"></a></span>
			</li>	
        </div>
		<div style="width: 100%;" id="layout"></div>
		<div id="pagination"></div>
	</div>
</form>
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>

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
	        
	        { width: 130, id: "AT15001", header: [{text: "대분류(제품군)", align:"center"},{content : "selectFilter"}], align: "center"},	 
	        { width: 130, id: "AT15002", header: [{text: "중분류(제품명)", align:"center"},{content : "selectFilter"}], align: "center"},	 
	        { width: 130, id: "ZAT4008", header: [{text: "소분류(품번)", align:"center"},{content : "inputFilter"}], align: "center"},	 
	        
	        { width: 110, id: "AT15003", header: [{text: "인증종류", align:"center"},{content : "inputFilter"}], align: "center"},	 
	        { width: 110, id: "ZAT4003", header: [{text: "인증규격", align:"center"},{content : "inputFilter"}], align: "center"},
	        { width: 110, id: "ZAT4009", header: [{text: "생산공장", align:"center"},{content : "inputFilter"}], align: "center"},	  
	        { width: 110, id: "ZAT4014", header: [{text: "갱신대상", align:"center"},{content : "inputFilter"}], align: "center"},
	        { width: 110, id: "ZAT4005", header: [{text: "차기 갱신일", align:"center"},{content : "inputFilter"}], align: "center"},	
	        { width: 110, id: "ZAT4006", header: [{text: "차기 시험일", align:"center"},{content : "inputFilter"}], align: "center"},
	        { width: 80, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align:"center" },{content : "inputFilter"}], align:"center"},
	        { width: 100, id: "StatusName", header: [{ text: "${menu.LN00027}", align:"center" },{content : "selectFilter"}], align:"center", htmlEnable: true},
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    multiselection : true   
	    
	});
	
	$("#TOT_CNT").html(grid.data.getLength());
	
	var tranSearchCheck = false;
	grid.events.on("cellClick", function(row,column,e){
		if(column.id != "checkbox" && column.id != "FileIcon"){
			//doDetail(row.ItemID);
			fnEditCertiItm(row.ItemID);
		}else if(column.id == "FileIcon") {
			var fileCheck = row.FileIcon;

			if(fileCheck.indexOf("blank.gif") < 1) {
				if( '${loginInfo.sessionMlvl}' != "SYS"){
					fnCheckItemArrayAccRight(row.ItemID);
				}else{
					var url = "selectFilePop.do";
					var data = "?s_itemID="+row.ItemID; 
				   
				    var w = "650";
					var h = "350";
				    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");	
				}
			}
		}else{ tranSearchCheck = false; }
			
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
		var sqlID = "custom_SQL.getCertiList";
		var param =  "s_itemID=${s_itemID}"				
	        + "&classCode=CL15004"
	        + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
	        + "&defaultLang=${sessionScope.loginInfo.sessionDefLanguageId}"
	        + "&sqlGridList=N"
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
 	
 	//fnFilter("${filterName}", "${filterValue}");
 	
 	function fnReloadGrid(newGridData){
 		grid.data.parse(newGridData);
 		$("#TOT_CNT").html(grid.data.getLength());
 		//fnFilter("${filterName}", "${filterValue}");
 	}
 	
 	function fnAddCerti(){
 		var url = "registerCertiItem.do?s_itemID=${s_itemID}&classCode=CL15004&fltpCode=FLTP015";
 		var w = 1500;
 		var h = 700;
 		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
 	}
 	
 	function doSearchList(){
 		fnReload();
 	}
 	
 	function fnFilter(columnID, filterValue) {
 		if(columnID == "") return;
 		const changeEvent = document.createEvent("HTMLEvents");
 		changeEvent.initEvent("change", true, true);
 		var headerFilter = grid.getHeaderFilter(columnID);
 		var element = headerFilter.querySelector("select");
 		element.value = filterValue;
 		element.dispatchEvent(changeEvent);
 	}
 	
 	/* const changeEvent = document.createEvent("HTMLEvents");
	changeEvent.initEvent("change", true, true);
	var headerFilter = grid.getHeaderFilter("ZAT4010");
	var element = headerFilter.querySelector("select");
	element.value = "CE";
	element.dispatchEvent(changeEvent); */
	
	
	function fnEditCertiItm(itemID){
		var url = "editCertiItem.do?s_itemID="+itemID+"&classCode=CL15004&fltpCode=FLTP015";
 		var w = 1500;
 		var h = 700;
 		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
		
 	
</script>