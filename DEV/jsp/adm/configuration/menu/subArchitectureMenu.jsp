<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

<!-- 2. Script -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">

var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용

	$(document).ready(function() {	
		
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			},
		});	
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 280)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 280)+"px;");
		};
	});	
	
	function setWindowHeight(){
		
	var size = window.innerHeight;var height = 0;
	if( size == null || size == undefined){height = document.body.clientHeight;}
	else{height=window.innerHeight;}return height;
	}
	
	//===============================================================================
	// BEGIN ::: GRID


	function fnGoBack(){
		var url = "defineTemplateView.do";
		var target = "tempListDiv";
		var data = "&templCode=${templCode}&languageID=${languageID}" 
					+"&pageNum=${pageNum}&viewType=${viewType}";
		ajaxPage(url,data,target);
	}
	
	function fnOpenArcListPop(){
		var url = "openArcListPop.do?templCode=${templCode}";
		var option = "width=600,height=500,left=500,top=100,toolbar=no,status=no,resizable=yes";
	    window.open(url, self, option);
	}
	

	function fnDeletArcTempl(){
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox; 
		});
			if(!selectedCell.length){ //배열의 길이가 0   => !FALSE == TRUE
			alert("${WM00023}");	
			} else {
				   // 배열의 길이가 하나이상 있음 1 => !TRUE ==FALSE
				if(confirm("${CM00004}")){ 
					var arcCode = new Array();
					for(idx in selectedCell){
						arcCode[idx] = selectedCell[idx].ArcCode;
					}
					var url = "admin/deleteArcTemplAlloc.do";
					var data = "&arcCode="+arcCode+"&templCode=${templCode}&pageNum=${pageNum}";
					var target = "subFrame";
					ajaxPage(url, data, target);
				}
			}
	}
	 
	
 	function gridOnRowSelect(row){
		var arcCode = row.ArcCode;
		var arcName = row.ArcName;
		var sortNum = row.SortNum;
	
		$("#modSortNum").attr('style', 'display: block');	
		$("#modSortNum").attr('style', 'width: 100%');	
		$("#divSaveTemplArc").attr('style', 'display: block');	
		
		$("#sortNum").val(sortNum);
		$("#arcCode").val(arcCode);
		$("#arcName").val(arcName); 
	}
	 
 	
 	
	function fnSaveSortNum(){
		if(confirm("${CM00001}")){
			var arcCode = $("#arcCode").val();
			var sortNum = $("#sortNum").val();
			var arcName = $("#arcName").val();
			
			var url = "admin/saveTemplArcSortNum.do";
			var data = "arcCode=" + arcCode + "&templCode=${templCode}&sortNum=" + sortNum + "&arcName="+arcName + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"; 
			var target = "subFrame";
			ajaxPage(url, data, target);
		}
	}
	
</script>
<body>
<form name="architectureAlloc" id="architectureAlloc" action="*" method="post" onsubmit="return false;">
	<input type="hidden" id="CurrPageNum" name="CurrPageNum" value="${pageNum}">	
	</form>
	<div class="countList pdT5">
        <li class="count">Total  <span id="TOT_CNT"></span></li>
         <li class="floatR">
			<button class="cmm-btn mgR5" style="height:30px;" onclick="fnOpenArcListPop()"  value="Add">Add Architecture</button>
			<button class="cmm-btn mgR5" style="height:30px;" onclick="fnDeletArcTempl()" value="Del">Delete</button>
         </li>
    </div>		
	<div id="gridDiv" style="width:100%;" class="clear">
	<div id="grdGridArea" style="width:100%"></div>
	</div>
	
	<div class="mgT10">
	<table id="modSortNum" class="tbl_blue01" width="100%"   cellpadding="0" cellspacing="0" style="display:none">
		<tr>
			<th class="viewtop last">Architecture Name</th>
			<th class="viewtop last">SortNum</th>
		</tr>
		<tr>
			<td class="last"><input type="text" class="text" id="arcName" name="arcName" />
							 <input type="hidden" class="text" id="arcCode" name="arcCode" /></td>
			<td class="last"><input type="text" class="text" id="sortNum" name="sortNum" /></td>
		</tr>
	</table>
	</div>
	
	
	<div  class="alignBTN" id="divSaveTemplArc" style="display: none;">
		<span class="btn_pack medium icon mgR20"><span  class="save"></span><input value="Save" onclick="fnSaveSortNum()"  type="submit"></span>
	</div>
	<div class="schContainer" id="schContainer">
		<iframe name="subFrame" id="subFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
	
	<!-- END :: FRAME -->
	
	<script type="text/javascript">
		var layout = new dhx.Layout("grdGridArea", {
			rows : [ {
				id : "a",
			}, ]
		});	
		var gridData = ${gridData};
		var grid = new dhx.Grid("grdGridArea", {
		    columns: [
		         { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				 { width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
		        { width: 100, id: "ArcCode", header: [{ text: "Code" , align: "center" }], align: "center" },
		        { width: 150, id: "ArcName", header: [{ text: "Name", align: "center" }] },
		        { width: 60, id: "SortNum", header: [{ text: "Sort No", align: "center" }], align: "center" },
		        { width: 80, id: "ProjectID", header: [{ text: "ProjectID", align: "center" }], align: "center" },
		        { width: 70, id: "Type", header: [{ text: "Type", align: "center" }], align: "center" }
		    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    data: gridData
		});
		layout.getCell("a").attach(grid);
		$("#TOT_CNT").html(grid.data.getLength());

		grid.events.on("cellClick", function(row, column, e) {
		    if (column.id != "checkbox") {
		    	gridOnRowSelect(row);
		    }
		});
		
		function fnCallBack(){
			$("#modSortNum").attr('style', 'display: none');		
			$("#divSaveTemplArc").attr('style', 'display: none');	
			
			var sqlID = "config_SQL.getArcTemplList";
			var param = "templCode=${templCode}"
			           +"&languageID=&{languageID}"
			           +"&sqlID="+sqlID;
			           
			   	$.ajax({
						url:"jsonDhtmlxListV7.do",
						type:"POST",
						data:param,
						success: function(result){
							console.log("result: "+result);
							fnReloadGrid(result);				
						},error:function(xhr,status,error){
							console.log("ERR :["+xhr.status+"]"+error);
						}
					});	
		}
		 
	 	function fnReloadGrid(newGridData){
	 		grid.data.parse(newGridData);
			$("#TOT_CNT").html(grid.data.getLength());
			fnMasterChk('');
	 	}	
	</script>
	
	
</body>
</html>