<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root" />

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>
	
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<title>Edit SortNum</title>

<!-- 2. Script -->
<script type="text/javascript">

	$(document).ready(function(){
		$("#grid").attr("style","height:650px;");
	});

	// [save] 이벤트 후 처리
	function selfClose() {
		//var opener = window.dialogArguments;
		opener.objReload();
		self.close();
	}
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	
	
	// move up버튼 함수 
	function fnMoveRowUp() {
	  var selectedId = grid.selection.getCell().row.id; // 현재 선택된 행의 ID 가져오기

	  if (!selectedId) {
	    alert("Please select a row to move.");
	    return;
	  }
	  
	  //현재위치 찾는법
	  var data = grid.data.serialize();
	  var currentIndex = -1;
	
	  for (var i = 0; i < data.length; i++) {
		if (data[i].id === selectedId) {
			currentIndex = i;
			break;
		}
		}


		
		
		var newIndex = currentIndex - 1; // 현재 위치보다 1 적게 이동
	
		if (currentIndex === -1 || newIndex === -1) {
			newIndex = 0;
			return;
		}
		grid.data.move(selectedId,newIndex); //id값과  옮길위치
	}

	
	//Down 버튼 함수 
	function fnMoveRowDown(){
		

	var selectedId = grid.selection.getCell().row.id; // 현재 선택된 행의 ID 가져오기
	
	  
	  if (!selectedId) {
	    alert("Please select a row to move.");
	    return;
	  }
	  
	  //현재위치 찾는법
	  var data = grid.data.serialize();
	  var currentIndex = -1;
	
	  for (var i = 0; i < data.length; i++) {
		if (data[i].id === selectedId) {
			currentIndex = i;
			break;
		}
		}
		
		
		var newIndex = currentIndex + 1; // 현재 위치보다 1 많게 이동 
	
		
		if (currentIndex === data.length || newIndex === data.length) {
			console.error("Index over");
			newIndex = currentIndex;
			return;
		}
		grid.data.move(selectedId,newIndex); //id값과  옮길위치
	}

	
	function fnSaveAttrTypeCodeSortNum() {   
		
	    if (confirm("${CM00001}")) {
	    	 var data = grid.data.serialize();	
			var rowIds = data.map(function(obj){
			    return obj.id;
			});
					
			var ids = rowIds.join(',')
		
			var attrArray = [];
			var sortArray = [];
		
			for(var i=0; i < rowIds.length; i++){
				
				grid.data.update(rowIds[i], { GSortNum: i ,RNUM: i });			
				
				var updatedData = grid.data.serialize()
				attrArray.push(updatedData[i].AttrTypeCode);
				sortArray.push(updatedData[i].GSortNum);
		
				}   
			var AttrTypeCodes = attrArray.join(',');
			var Sorts = sortArray.join(',');

			var url = "saveAttrSortNum.do";
			var data = "&ItemTypeCode=${itemTypeCode}"+"&ids="+ids+"&AttrTypeCode="+AttrTypeCodes+"&GSortNum="+Sorts;				
			var target = "editAttrSortNumPop";	
			ajaxPage(url,data,target);	
		     
		      
	    }
	}

</script>

<div style="width:98%;height:100%;">
<form name="attrSortNumFrm" id="attrSortNumFrm" action="#" method="post" onsubmit="return false;">
	<div class="msg" style="width:100%;"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;Edit SortNum</div>
    <div class="countList">
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
       		&nbsp;<span class="btn_pack medium icon"><span class="upload"></span><input value="&nbsp;Up" type="submit" id="file" onclick="fnMoveRowUp();"></span>
 			&nbsp;<span class="btn_pack medium icon"><span class="download"></span><input value="&nbsp;Down" type="submit" id="file" onclick="fnMoveRowDown();"></span>
 			&nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" id="file" onclick="fnSaveAttrTypeCodeSortNum();"></span>
        </li>
    </div>
	<div class="mgL5" id="grid" style="width:98%;"></div>
</form>
</div>
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
</div>
<script>

 var gridData = ${gridData};
 var grid = new dhx.Grid("grid", {
    columns: [
        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" , selected:true },
        { width: 150, id: "AttrTypeCode", header: [{ text: "CODE" , align: "center" }, { content: "inputFilter" }], align: "center" },
        { fillspace: true, id: "AttrTypeName", header: [{ text: "${menu.LN00028}" , align: "center" },{ content: "inputFilter" }], align:"left" },
        { width: 100, id: "GSortNum", header: [{ text: "Sort Num", align: "center" }, { content: "inputFilter" }], align: "center" },     
    ],

    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    data: gridData
});
 
$("#TOT_CNT").html(grid.data.getLength());

</script>