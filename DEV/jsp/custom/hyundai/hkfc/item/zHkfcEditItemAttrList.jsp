<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagIncV7.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00174" var="WM00174" arguments="${title} ${menu.LN00031}" />

<script>
			//그리드 전역변수
	$(document).ready(function(){
		
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 120)+"px; width:100%;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 120)+"px; width:100%;");
		};
		
		$("#excel").click(function(){ fnGridExcelDownLoad(); });
		$("#excelAll").click(function(){ allGridExcel(); });
		
		const L1Data =${L1Data};
		
		const selectElement = document.getElementById('L1');

		L1Data.forEach(item => {
		  const optionElement = document.createElement('option');
		  optionElement.value = item.Identifier;
		  optionElement.text = item.Identifier + " " + item.NAME;
		  selectElement.appendChild(optionElement);
		});
		
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
	
	function doDetail(avg1){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop"+"&accMode=${accMode}";
		var w = 1400;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
	}
	
	function fnResetData(){
		if(confirm("${WM00174}")){
			var url = "zhkfc_resetItemAttr.do";
			var target = "blankFrame";
			var data = "itemAttrTypeCodes=ZAT0004,ZAT0005,ZAT0006";
			ajaxPage(url, data, target);	
		}
	}
	
	

</script>	

<form name="attrFrm" id="attrFrm" action="" method="post" onsubmit="return false">
	<input type="hidden" id="updateData" name="updateData" value="">
</form>
	<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 3px 0 3px 0"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;&nbsp;${title}</h3>
	</div>
	<div id="subItemListDiv" name="subItemListDiv" style="margin-bottom:5px;">		
	<div class="countList">
    	<li class="count">Total  <span id="TOT_CNT"></span></li>
    	<li class="pdL55 floatL"><select id="L1" name="L1" style="width:80px;" OnChange=fnReload(); ></select></li>
		<li class="floatR pdR20">	
			<c:if test="${sessionScope.loginInfo.sessionMlvl eq 'SYS' }" >
			<span id="resetBtn" class="btn_pack nobg white"><a class="clear" onclick="fnResetData();" title="Reset"></a></span>
			<span id="editBtn" class="btn_pack nobg white"><a class="edit" onclick="fnEditAttrData();" title="Attribute"></a></span>
			<span id="saveBtn" class="btn_pack nobg" style="display:none;"><a class="save" onclick="fnSaveItemAttr()" title="Save"></a></span>
			</c:if>
     		<span class="btn_pack nobg white"><a class="xls" id="excel" title="Excel"></a></span>
     		<span class="btn_pack nobg white"><a class="download" id="excelAll" title="Download All List"></a></span>
		</li>	
    </div>
	<div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>
</div>
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
	        { width: 30, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" }], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 40, id: "ItemTypeImg", header: [{ text: "${menu.LN00042}", align:"center" }], htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR}/item/'+row.ItemTypeImg+'" width="18" height="18">';
	            }
	        },
	        { width: 100, id: "Identifier", header: [{ text: "${menu.LN00106}", align:"center" }, { content: "selectFilter"}], align:"center"},
	        { 			  id: "ItemName", header: [{ text: "프로세스 ${menu.LN00028}", align:"center" }, { content: "inputFilter"}], htmlEnable: true, align:"left"},	        
	        { width: 160, id: "OwnerTeamName", header: [{text: "${menu.LN00018}", align:"center"}, { content: "inputFilter"}], align: "center"},
	        { width: 140, id: "AuthorName", header: [{text: "프로세스 ${menu.LN00004}", align:"center"}, { content: "selectFilter"}], align: "center"},
	       
	        { width: 240, id: "ZAT0004", header: [{ text: "정기검토일", align: "center"}, { content: "inputFilter"}], align: "center" ,type: "date", format: "%Y-%m-%d"}, 
	        { width: 240, id: 'ZAT0005', header: [{ text: '정기검토현황', align: "center"}, { content: "inputFilter"}], align: "center", editorType: "select", options: ${AT5Options} },
	        { width: 240, id: 'ZAT0006', header: [{ text: '정기검토결과', align: "center"}, { content: "inputFilter"}], align: "center" },
	        
	        { width: 100, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align:"center" }], align:"center"},
	        { width: 100, id: "StatusNM", header: [{ text: "${menu.LN00027}", align:"center" }], align:"center", htmlEnable: true}
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    //multiselection : true   
	    
	});
	
	// all L4 down excel grid
	var allgrid = new dhx.Grid(allgrid, {
        columns: grid.config.columns
    });
	
	$("#TOT_CNT").html(grid.data.getLength());
	
	var tranSearchCheck = false;
	grid.events.on("cellClick", function(stage,row,column,e){
		if(column.id == "ItemTypeImg" || column.id == "Identifier" || column.id == "ItemName"){
			doDetail(row.ItemID);
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
		var sqlID = "custom_SQL.zkpal_getEditItemAttrList";
		var param = "sessionUserID=${sessionScope.loginInfo.sessionUserId}"				
	        + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}" 
	        + "&classCode=CL01005"
	        + "&defaultLang=${sessionScope.loginInfo.sessionDefLanguageId}"	     
			+ "&sqlID="+sqlID
			+ "&sqlGridList=N"
			+ "&L1="+$("#L1").val();
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
	
	function allGridExcel(){
		var sqlID = "custom_SQL.zkpal_getEditItemAttrList";
		var param = "sessionUserID=${sessionScope.loginInfo.sessionUserId}"				
	        + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}" 
	        + "&classCode=CL01005"
	        + "&defaultLang=${sessionScope.loginInfo.sessionDefLanguageId}"	     
			+ "&sqlID="+sqlID
			+ "&sqlGridList=N";
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				allgrid.config.editable = false;
				allgrid.data.parse(result);
				fnGridExcelDownLoad(allgrid)
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
	}
 	
 	function fnReloadGrid(newGridData){
 		grid.config.editable = false;
 		grid.data.parse(newGridData);
 		$("#TOT_CNT").html(grid.data.getLength());
 	}
 	
 	function fnSaveItemAttr(){ 
		var editedRow = [];
		if(!confirm("${CM00001}")){ return;}
		
		for(var i=0; i< grid.data._order.length; i++) {
			editedRow.push(grid.data._order[i]);	
		}	
		
		var jsonData = JSON.stringify(editedRow);		
		$("#updateData").val(jsonData);		
		
		var url = "zHkfc_updateItemAttr.do";	
		ajaxSubmitNoAdd(document.attrFrm, url, "blankFrame");
		$("#saveBtn").attr('style', 'display:none;');
		$("#editBtn").attr('style', 'display:done;');
	}
 	
 	function fnEditAttrData(){
 		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
 		
 		if(!selectedCell.length){
 			alert("${WM00023}");
 			return;
 		}
 		
 		$("#saveBtn").attr('style', 'display:done;');
 		$("#editBtn").attr('style', 'display:none;');
 		
	 	fnReloadGrid(selectedCell);
	 	
	 	grid.config.editable = true;
 	}
 	
</script>