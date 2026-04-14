<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>

<script>
	$(document).ready(function(){	
		$("#udfStrClassSortNameCNT").val("${udfStrClassSortNameCNT}");
		var data = "&categoryCode=ST3&languageID=${sessionScope.loginInfo.sessionCurrLangType}&sessionUserId=${sessionScope.loginInfo.sessionUserId}";
		fnSelect('udfStructureIDs', data, 'getUdfStrClassSort','${defaultUdfClassSortCode}', 'Select', 'item_SQL');
	});
	
	function fnAfterUpdateSendData(){
		alert("${WM00067}");
		thisReload();
	}

	function fnMoveRowUp(){
		const selectedRow = grid.selection.getCell().row;
		const rowId = selectedRow.id;
		const index = grid.data.getIndex(rowId);
		if (index > 0) {
			grid.data.move(rowId, index - 1);
		}
	}
	
	function fnMoveRowDown(){
		const selectedRow = grid.selection.getCell().row;
		const rowId = selectedRow.id;
		const index = grid.data.getIndex(rowId);
		const rowCount = grid.data.getLength();
		if (index < rowCount - 1) {
			grid.data.move(rowId, index + 1);
		}
	}
	
	function fnCreateUdfStrMgt(){	
		var udfStrClassSortNameCNT =  Number($("#udfStrClassSortNameCNT").val());
		
		if(confirm("${CM00009} ")){
			showLoadingMessage();
			if(udfStrClassSortNameCNT >= 10){
				alert("UDF BEDP 구조 설정은 10개까지 가능합니다. 기존 구조를 삭제후 생성하세요.");
				return;
			}
			
			if( grid.data.getInitialData().filter(e => e.CHK).length == 0){
				alert("${WM00023}");
				return;
			}
	
			var checkedRows = grid.data._order.filter(e => e.CHK);
			var classCodes = checkedRows.map(e => e.CODE).join(",");
			var levels = checkedRows.map(e => e.Level).join(",");
			var classNames = checkedRows.map(e => e.NAME).join(",");
			
			var sorceArcCode = "BEDP002";
			var url = "createUdfStrMgt.do";
			var target = "blankFrame";
			var data = "arcCode=${arcCode}&classCodes="+classCodes+"&levels="+levels
					+"&classNames="+classNames
					+"&defaultClassCodes=${defaultClassCodes}"
					+"&myCSR=${myCSR}"
					+"&csrIDs=${csrIDs}"
					+"&sortOption=${sortOption}"
					+"&udfSTR=${udfSTR}"
					+"&sorceArcCode="+sorceArcCode;
					
			ajaxPage(url, data, target);
			
		}
	}	
	
	function fnGoUdfStr(udfStructureID, nodeStrID){	
		opener.fnGetCategory("${arcCode}", udfStructureID, nodeStrID);
		self.close();
	}
	
	function fnGetNodeStrID(){
		var udfStructureID = $("#udfStructureIDs").val();
		if(udfStructureID == ""){
			alert("UDF BEDP를 선택하세요.");
			return;
		}
		var url = "getNodeStrID.do";
		var data = "structureID="+udfStructureID;
					
		var target = "blankFrame";		
		ajaxPage(url, data, target);
	}
	
	function fnDeleteUdfStr(){
		var udfStructureIDs = $("#udfStructureIDs").val();
		var udfStrClassSortName =  $("#udfStructureIDs option:selected").text();
		
		if(udfStructureIDs == ""){
			alert("삭제할 UDF BEDP를 선택하세요.");
			return;
		}
		if(confirm("선택된 "+ udfStrClassSortName +"을 삭제 하시겠습니까?")){
			var url = "deleteUdfStrClassSort.do";
			var data = "categoryCode=ST3&udfStructureIDs="+udfStructureIDs
						
			var target = "blankFrame";		
			ajaxPage(url, data, target);
		}
	}
	
	function fnCallback(udfStrClassSortNameCNT, defaultUdfClassSortCode, defaultUdfClassSortName){
		hideLoadingMessage();
		$("#udfStrClassSortNameCNT").val(udfStrClassSortNameCNT);
		var data = "&categoryCode=ST3";
		fnSelect('udfStructureIDs', data, 'getUdfStrClassSort', defaultUdfClassSortCode, 'Select', 'item_SQL');	
		
		fnGetClassList(defaultUdfClassSortName);
	}
	
	function fnClose(){
		if(confirm("저장 없이 창을 닫으시겠습니까?")){	
			self.close();
		}
	}
	
	function fnGetClassList(defaultUdfClassSortName){
		var udfStrClassSortName =  $("#udfStructureIDs option:selected").text();
		if(defaultUdfClassSortName != "" && defaultUdfClassSortName != undefined){
			udfStrClassSortName = defaultUdfClassSortName;
		}
		var param =  "udfStrClassSortName="+udfStrClassSortName;
		$.ajax({
			url:"getMakeUdfStrClassSort.do",
			type:"POST",
			data:param,
			success: function(result){
				doSearchList(result);	
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
	}

</script>	
</head>
<body>
<div class="mgL5 mgR5">
<input type="hidden" id="udfStrClassSortNameCNT" name="udfStrClassSortNameCNT" value="">
	<div class="msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;UDF BEDP Management</div>
	 <div class="child_search02 mgL10">
    	<select id="udfStructureIDs" name="udfStructureIDs" style="width:89%;" OnChange="fnGetClassList();"></select>
    	<button class="cmm-btn" style="height:30px;background:#000080;color:#fff" id="go" onclick="fnGetNodeStrID();" value="Go">Go</button>
    </div>
	<div class="child_search02 mgT5 mgB5">
		 <li class="floatL">
	    	<button class="cmm-btn" style="height: 30px;" id="up" onclick="fnMoveRowUp();">Up</button>
			<button class="cmm-btn" style="height: 30px;" id="down" onclick="fnMoveRowDown();">Down</button>
		</li>
		<li class="floatR" >
			<button class="cmm-btn" style="height: 30px;" id="delete" onclick="fnDeleteUdfStr();">Delete</button>
			<button class="cmm-btn" style="height: 30px;" id="go" onclick="fnCreateUdfStrMgt();">Save</button>
		 </li> 
	</div>
	<div id="layout" class="mgB10 mgT5 mgL10" style="height:220px; width:96%;" ></div>
	<div style="height:35px;width:97%;vertical-align:middle;" class="mgL10 mgB15">
		- 원하는 순서 항목을 선택 후 UP, DOWN 버튼으로 순서를 변경할수 있습니다. <br>
		- 순서를 제외할 경우 체크박스를 해제해 주시기 바랍니다
	</div>
	<div style="height:32px;width:100%;background:#000000;cursor:pointer;text-align: middle;vertical-align:middle" class="alignC">
		<span style="color:#ffffff;font-weight:bold;vertical-align:middle;" class="mgT5" onClick="fnClose();" >닫기</span>
	</div>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
	<div id="loadingMessage" class="loadingMessage" >
	    <p>저장되는 동안 창을 닫지 마시고 <br> 잠시만 기다려 주세요.</p>
	</div>
</body>

<style>
  .loadingMessage {
	  display: none;
	  position: fixed;
	  top: 50%;
	  left: 50%;
	  transform: translate(-50%, -50%);
	  background: rgba(255, 255, 255, 0.9);
	  padding: 20px;
	  border: 1px solid #ccc;
	  box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
	  z-index: 1000;
	  text-align: center;
	}
	
	.loadingMessage p {
	  margin: 0;
	}
	
	.gridbox_dhx_web.gridbox {
		border-right: 0px !important;
    	border-bottom:  0px !important;
    	
    }
</style>

<script>
	doSearchList();

	function hideLoadingMessage(){
	  document.getElementById('loadingMessage').style.display = 'none';
	}
	
	function showLoadingMessage(){
	   document.getElementById('loadingMessage').style.display = 'block';
	}
  
	function doSearchList(avg){
		var sorting = "";
		if(avg != "" && avg != undefined){
			sorting = avg; 
		}else{
			sorting = "${sorting}"; 
		}

		var sqlID = "item_SQL.getRefClassCodeList";
		var param =  "itemTypeCode=ST00016"
			+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&exceptLevel='0','6'"
			+ "&sorting="+sorting
			+ "&sqlID="+sqlID;
			
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				grid.data.parse(result);
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	}
		
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid = new dhx.Grid("grid",  {
		columns: [
	        { width: 50, id: "RNUM", header: [{ text: "No.", align:"center"}], align:"center" },
	        { id: "NAME", header: [{ text: "Name", align:"center"}], align:"center" },
	        { width: 120, id: "CHK", header: [{ text: "선택", align:"center", htmlEnable: true }], align: "center", type: "boolean", editable: true, sortable: false},
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false
	});
	
	layout.getCell("a").attach(grid);
</script>

</html>