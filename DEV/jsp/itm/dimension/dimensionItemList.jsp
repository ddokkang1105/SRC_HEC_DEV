<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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

<!-- 담당 Item 목록 -->
<!-- 
	@RequestMapping(value="/ProcessDimensionList.do")
	* dim_SQL.xml - selectDimList_gridList
	* Action
	  - Add  :: NewDimension.do
	         :: NewSubDimension.do
	  - Del  :: DelDimension.do
	         :: DelSubDimension.do 
	* SubMenu - subChangeManagement  
-->

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00042" var="WM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00005" var="CM00005"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00024" var="WM00024"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="ClassCode"/>

<!-- Dhtmlx grid  upgrade  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
	var p_gridArea2;				//그리드 전역변수
	var dimValID;
	
	$(document).ready(function() {
		// SKON CSRF 보안 조치
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
				}
		})	
		
		// 초기 숨김 설정
		$("#grdGridArea2").hide();

		// 화면 크기 조정
	//	window.onresize = function() {
	//	    $("#grdGridArea2").hide(); // 요소를 계속 숨긴 상태로 유지
	//	};
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","width:100%;height:"+(setWindowHeight() - 400)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
		$("#grdGridArea").attr("style","width:100%;height:"+(setWindowHeight() - 400)+"px;");
		};
		$("#grdGridArea2").attr("style","width:100%;height:"+(setWindowHeight() - 500)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea2").attr("style","width:100%;height:"+(setWindowHeight() - 500)+"px;");
		};
		$('#searchValue').keypress(function(onkey){if(onkey.keyCode == 13){doSetGrid2Child();return false;}});

		$("#excel").click(function (){
			exportXlsx();
			
			
		});
		function exportXlsx() {
		    grid2.export.xlsx({
		        url: "https://export.dhtmlx.com/excel"
		    });
		};

		function exportCsv() {
		    grid.export.csv();
		}
		$("#grdGridArea2").hide();
		var griddata = ${gridData};
	
		console.log("griddata : "+griddata);
	});
	
	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//===============================================================================
	// BEGIN ::: GRID

	
	function gridOnRowSelect2(row, col){
		if(col.id != "CHK"){
		doDetail(row.ID);
		}else{
		return false;
		}
	}
	function doDetail(avg1){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
	}
	 
	function doSetGrid2(avg){
		addDim(2);
		subGridinit(avg);
		//var d = setGrid2Data(avg);
		//fnLoadDhtmlxGridJson(p_gridArea2, d.key, d.cols, d.data);
		
	}
	
	
	function addDim(avg){
		if(avg == '1'){
		  document.querySelector(".noline span").textContent = "Dimension Add";
		   $("#addNewItem").removeAttr('style', 'display: none');   
		   $("#gridDiv2").attr('style', 'display: none');
		   $("#valueInsert").attr('style', 'display: none');   
		   $("#newSearch").attr('style', 'display: none');
		   $("#dimValueName").val("");
		   $("#dimValueID").val("");
		   document.querySelector("#dimValueID").removeAttribute("disabled")
		   $("#BeforeDimValueID").val("");
		   $("#saveType").val("New");
		   $("#dimDeleted").attr("checked", false);   
		}else{
			$("#addNewItem").attr('style', 'display: none');   
			$("#gridDiv2").removeAttr('style', 'display: none');
			$("#valueInsert").removeAttr('style', 'display: none');   
			$("#newSearch").attr('style', 'display: none');
		}if(avg == '3'){
			
			// Edit 버튼 클릭 이벤트
			document.querySelector(".noline span").textContent = "Dimension Edit";
			$("#gridDiv2").attr('style', 'display: none');
			$("#valueInsert").attr('style', 'display: none');
			document.querySelector("#dimValueID").setAttribute("disabled","disabled"); // dimValueID 수정불가
			$("#newSearch").attr('style', 'display: none');
			
	
			// check된 row 
			var checked = grid.data.findAll(function (data) {
	        return data.checkbox; 
			});
	         console.log(checked);
			if(checked.length == 0 || checked.length > 1){
				alert("${WM00042}");
			} else {
			    $("#addNewItem").removeAttr('style', 'display: none');
			
			    	$("#dimValueName").val(checked[0].Name);
			     	$("#dimValueID").val(checked[0].DimValueID);
			     	$("#BeforeDimValueID").val(checked[0].DimValueID);
			    
			     
			    	if(checked[0].ParentID == '1'){
			    		$("#dimDeleted").attr("checked", true);
			    	}else{
			      		$("#dimDeleted").attr("checked", false);
			    	}
			    	
			    	var dimDel = checked[0].DeletedIMG;
			    	if (dimDel==="blank.png") {
			    	$("#dimDeleted").prop("checked", false);
					}else {
			    	$("#dimDeleted").prop("checked", true);
						
					}
			    	
					// 체크 상태 확인
					//var isChecked = $("#dimDeleted").is(":checked");
					// 결과 출력
					//console.log(isChecked); // 체크되어 있으면 true, 아니면 false
				$("#saveType").val("Edit");
			}
		}
	}	
	function newDimension(){		
		//var confirmValue = "신규 정보를 생성 하시겠습니까?";		
		var confirmValue = "${CM00009}";		
		if($("#saveType").val() == "Edit"){
			//confirmValue = "정보를 수정 하시겠습니까?";
			confirmValue = "${CM00005}";
		}		
		if(confirm(confirmValue)){
			var url = "admin/NewDimension.do";
			var data = "s_itemID=${s_itemID}"
						+"&saveType="+$("#saveType").val()
						+"&dimDeleted="+$("#dimDeleted").is(":checked")
						+"&dimValueID="+$("#dimValueID").val()
						+"&dimValueName="+encodeURIComponent($("#dimValueName").val());			
			if($("#saveType").val() == "Edit"){data = data +"&BeforeDimValueID="+$("#BeforeDimValueID").val()+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}";}
			
			var target = "blankFrame";
		
			$("#addNewItem").attr('style', 'display: none');
	
			ajaxPage(url, data, target);	
			
		}
	}
	
	function doCheckValidation(){var isCheck=true; 
		return isCheck;		
	}
	function newItemInsert(){
		if(p_gridArea2.getCheckedRows(1).length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요.");   
			alert("${WM00023}"); 
		}else{
			//if(confirm("선택된 항목을 추가 하시겠습니까?")){    
			if(confirm("${CM00012}")){    
				var checkedRows = p_gridArea2.getCheckedRows(1).split(",");
			    for(var i = 0 ; i < checkedRows.length; i++ ){
			    	var url = "admin/NewSubDimension.do";
			     	var data = "DimTypeID=${s_itemID}&DimValueID="+p_gridArea.cells(p_gridArea.getSelectedId(), 3).getValue()+"&loginID=${sessionScope.loginInfo.sessionUserId}&s_itemID="+p_gridArea2.cells(checkedRows[i], 12).getValue();
			     	var target = "blankFrame";
			     	if(i+1 == checkedRows.length){data = data +"&FinalData=Final";}
			     	
			     	ajaxPage(url, data, target);
			     	p_gridArea2.deleteRow(checkedRows[i]);
				}
			}
		}	
	}	
	function delRemove(){		
		var checkedRows = grid.data.findAll(function (data) {
	        return data.checkbox; 
			});
		
		if(checkedRows.length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요.");   
			alert("${WM00023}"); 		
		}else{			
			//if(confirm("선택된 항목을 삭제 하시겠습니까?")){		
			if(confirm("${CM00004}")){		
				//var checkedRows = p_gridArea.getCheckedRows(1).split(",");
				for(var i = 0 ; i < checkedRows.length; i++ ){
				
					if(checkedRows[i].SCount != '0'){
						//alert(p_gridArea.cells(checkedRows[i], 3).getValue()+" 프로세스는 하위항목이 있으므로 삭제할 수 없습니다.");
						alert(checkedRows[i].Name+ "${WM00024}");
						checkedRows[i].checkbox =0;
					}else{
						var url = "admin/DelDimension.do";
						var data = "DimTypeID=${s_itemID}&DimValueID="+checkedRows[i].DimValueID+"&loginID=${sessionScope.loginInfo.sessionUserId}";
						var target = "blankFrame";
						if(i+1 == checkedRows.length){data = data +"&FinalData=Final";}
						
						ajaxPage(url, data, target);
					}					
				}				
			}
		}
	}	
	function delSubDim(){
		
		var checkedRows = grid2.data.findAll(function (data) {
	        return data.CHK; 
			});
		var chkrow =  JSON.stringify(checkedRows);
	
		if(checkedRows.length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요."); 
			alert("${WM00023}");	
		}else{		
			//선택된 항목을 삭제 하시겠습니까?	
			if(confirm("${CM00004}")){		
				var dimTypeId ="${s_itemID}"; 
				// 체크된 행에서 identifier 값을 추출합니다
				var dimValueIds = dimValID;

				var items = "";
			
				  for(var i = 0 ; i < checkedRows.length; i++ ){
				    	if (items == "") {
				    		items = checkedRows[i].ID;
						} else {
							items = items + "," +checkedRows[i].ID;
						}

				     	checkedRows.forEach(function(rowId) {
				     	
				     	
				     		grid2.selection.removeCell(rowId);
				     	});
				     	
				     	
					}
				    
				    var url = "admin/DelSubDimension.do";
					var data = "items="+items+"&dimTypeId="+dimTypeId+"&dimValueId=" + dimValueIds;
					var target = "blankFrame";
					
					ajaxPage(url, data, target);
			}
		}
		
	
	
	}
	

	
	function doCallBack(){}
	// [Add popup] Close 이벤트
	function addClose(avg){
		subGridinit(avg);
		doSetGrid2(avg);
	}
	
	function grid2child(){			
		var d = setGrid2Child(p_gridArea.cells(p_gridArea.getSelectedId(), 4).getValue());		
		p_gridArea2 = fnNewInitGrid("grdGridArea2", d);
		p_gridArea2.setImagePath("${root}${HTML_IMG_DIR}/");
		fnSetColType(p_gridArea2, 1, "ch");
	}
	function setGrid2Child(avg){
		var result = new Object();
		result.title = "${menu.LN00007}";
		result.key = "dim_SQL.selectDimNewSelectList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00015},${menu.LN00028},${menu.LN00043},${menu.LN00016},${menu.LN00014},${menu.LN00018},${menu.LN00004},${menu.LN00013},${menu.LN00017}"; //5
		result.cols = "CHK|ID|ItemName|Path|ClassName|TeamName|OwnerTeamName|Name|LastUpdated|Version"; //4
		result.widths = "50,50,50,150,*,100,100,100,100,100,50"; //5
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str"; //5
		result.aligns = "center,center,center,center,left,center,center,center,left,center,center"; //5
		result.data = "dimTypeID=${s_itemID}&s_itemID="+avg+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}&mainClassCode="+$("#newClassCode").val();
		return result;
	}
	function doSetGrid2Child(){
		if($("#newClassCode").val() == ""){alert("${WM00041}");return;}		
		var d = setGrid2Child(p_gridArea.cells(p_gridArea.getSelectedId(), 3).getValue());
		fnLoadDhtmlxGridJson(p_gridArea2, d.key, d.cols, d.data);
	}	

	function selectitemType(){
		var url    = "getClassCodeOption.do"; // 요청이 날라가는 주소
		var data   = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&hasDim=1"; //파라미터들
		var target = "newClassCode";             // selectBox id	
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}	
	
	function doSearchList2(){
	
		var dimVal = $("#sDimValue").val();
		var d = fnSearchList(dimVal);
	
	}	
	
	function fnDeleteDim(){		
		var dimValueIDs = new Array;
		var checkedRows = grid.data.findAll(function (data) {
	        return data.checkbox; 
			});
	
		if(checkedRows.length == 0){
			alert("${WM00023}"); 		
		}else{			
			if(confirm("${CM00004}")){		
			
				for(var i = 0 ; i < checkedRows.length; i++ ){
					dimValueIDs[i] = checkedRows[i].DimValueID;			
				}
				var url = "admin/deleteDimension.do";
				var data = "dimTypeID=${s_itemID}&dimValueIDs="+dimValueIDs;
				var target = "blankFrame";
				
				ajaxPage(url, data, target);
			}
		}
	}
	
	function doExcel() {		
		p_gridArea2.toExcel("${root}excelGenerate");
	}
</script>
</head>
<body>
	<form name="dimList" id="dimList" action="#" method="post" onsubmit="return false;">
	</form>		
	<input type="hidden" id="sDimValue" value="" />
	<input type="hidden" id="currPage" name="currPage" value="${currPage}"></input>
	<!-- BIGIN :: LIST_GRID -->
	<div class="child_search mgB10">
	
		<li class="floatL pdR20">
		 <c:forEach var="prcList" items="${prcList}" varStatus="status">
		  	<c:choose>
		   		<c:when test="${prcList.CategoryCode eq 'MCN' || prcList.CategoryCode eq 'CN' || prcList.CategoryCode eq 'CN1' }" >
		   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${prcList.FromItemTypeImg}" OnClick="fnOpenParentItemPop();" style="cursor:pointer;">&nbsp;${prcList.FromItemName}
		   		 --> 
		   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${prcList.ToItemTypeImg}" OnClick="fnOpenParentItemPop();" style="cursor:pointer;">&nbsp;${prcList.ToItemName}
				 <c:if test="${prcList.ItemName ne '' && prcList.ItemName != null}">/<font color="#3333FF"><b>${prcList.ItemName}</b></font> </c:if>
		   		</c:when>
		   		<c:otherwise>
		   		 <img src="${root}${HTML_IMG_DIR_ITEM}/${prcList.ItemTypeImg}" OnClick="fnOpenParentItemPop();" style="cursor:pointer;">&nbsp;${prcList.Path}
				  	<c:if test="${prcList.ItemName ne '' && prcList.ItemName != null}">/<font color="#3333FF"><b>${prcList.ItemName}</b></font> </c:if>
		   		</c:otherwise>
		   	</c:choose>
		   		
		  	
		  </c:forEach>
		</li>
		<li class="floatR pdR20">
			&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" id="newButton"  onclick="addDim(1)"></span>&nbsp;
			&nbsp;<span class="btn_pack small icon"><span class="edit"></span><input value="Edit" type="submit" id="newButton"  onclick="addDim(3)"></span>&nbsp;
			&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Remove" type="submit" onclick="delRemove()"></span>
			<c:if test="${loginInfo.sessionMlvl == 'SYS'}" >
			&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDeleteDim()"></span>
			</c:if>
		</li>
	</div>
		
	<div id="gridDiv" class="mgB10">
		<div id="grdGridArea" style="height:250px; width:100%"></div>
	</div>
	<table id="addNewItem" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" style="display: none;">
		<tr>
			<td colspan="4" class="noline"><img src="${root}${HTML_IMG_DIR}/icon_mark.png"><span>Dimension Add</span></td>
		</tr>
		<tr>
			<th class="viewtop">${menu.LN00015}</th>				
			<td class="viewtop"><input type="text" class="text" id="dimValueID" name="dimValueID"  value=""/></td>			
			<th class="viewtop">${menu.LN00028}</th>				
			<td class="viewtop"><input type="text" class="text" id="dimValueName" name="dimValueName"  value=""/></td>
			<th class="viewtop">Deleted</th>				
			<td class="viewtop"><input type="checkbox" id="dimDeleted" name="dimDeleted" /></td>
		</tr>
		<tr>
			<td colspan="6" class="btnlast">
				<input type="hidden" id="saveType" name="saveType" value="New">
				<input type="hidden" id="BeforeDimValueID" name="BeforeDimValueID" value="">					
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="newDimension()"></span>
			</td>
		</tr>	
	</table>
	<div id="valueInsert" class="child_search mgB10" style="display:none;">
		<li  class="count">Total  <span id="TOT_CNT"></span></li>
		<%-- <li class="L">
			&nbsp;${menu.LN00016}
			<select id="newClassCode" name="newClassCode" style="width:150px;" >
				<option value="">select</option>
			</select>	
		</li>
		<li>
			<select id="searchKey" name="searchKey" style="width:150px;">
				<option value="Name">Name</option>
			</select>
			<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;">
			<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="doSearchList2()" value="검색">
		</li> --%>
		<li class="floatR">	
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" id="newButton1"  onclick="assignDim2Item()" ></a></span>&nbsp;
			&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delSubDim()"></span>
		</li>
	<div id="gridDiv2" class="mgB10" style="margin-top: 5px;">
		<div id="grdGridArea2" style="width:100%;height:100%; display: none;"></div>
	</div>
		<div id="pagination"  style="width: 100%;height:80%; margin-top: 2%;"></div>
	</div>	
	
	
	
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>
<script type="text/javascript">
var layout = new dhx.Layout("grdGridArea", {
	rows : [ {
		id : "a",
	}, ]
});	
var gridData = ${gridData}; 

var grid = new dhx.Grid("grdGridArea", {
	columns: [

		  	{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center",rowspan:2 }], align: "center" },
			{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center", rowspan: 2}], align: "center", type: "boolean", editable: true, sortable: false},
			{ hidden:true,width: 50, id: "PlainText", header: [{ text: "Dimension" , align: "center"}]},
			{ width: 150, id: "DimValueID", header: [{ text: "Code" , align: "center" },{ content: "selectFilter" }],align: "center"},
			{ width: 150, id: "Name", header: [{ text: "Value" , align: "center" },{ content: "inputFilter" }],align: "center"},
			{ hidden:true,width: 80, id: "ParentID", header: [{ text: "ParentDimID" , align: "center" }], align: "" },
			{ hidden:true,width: 80, id: "SCount", header: [{ text: "SCount" , align: "center" }], align: "" },
			
			{ width: 100, id: "DeletedIMG", header: [{ text: "Deleted" , align: "center"}],htmlEnable:true, align: "center",
	        	template:function (text,row,col){
	        		return  '<img src="${root}${HTML_IMG_DIR_ITEM}/'+row.DeletedIMG+'" width="18" height="18">';
	        	}	
	        },
			{ hidden:true,width: 80, id: "MaxLevel", header: [{ text: "MaxLevel" , align: "center" }], align: "" },
			{ width: 100, id: "MLBtn", header: [{ text: "Sub Dimension" , align: "center"}],htmlEnable:true, align: "center",
	        	template:function (text,row,col){
	        		return  '<img src="${root}${HTML_IMG_DIR_ITEM}/'+row.MLBtn+'" width="18" height="18">';
	        	}	
	        },
			{ hidden:true,width: 80, id: "Deleted", header: [{ text: "Deleted" , align: "center" }], align: "" },
		],
	eventHandlers: {
		onclick: {
		
		}
	},
	autoWidth: true,
	resizable: true,
	selection: "row",
	tooltip: false,
	data: gridData
});

layout.getCell("a").attach(grid);




function fnReload(){		
	
	var	sqlID = "dim_SQL.selectDimList";	
	var param = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
	 	        +"&s_itemID=${s_itemID}"
				+"&sqlID="+sqlID;	 		
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){

			    grid.data.parse(result);
			    fnClearFilter("DimValueID");
		 	    fnClearFilter("Name");
		 		
			 
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
	   
	}
function fnClearFilter(columnID) {
		var headerFilter = grid.getHeaderFilter(columnID);
		if(headerFilter){
 	    var changeEvent = document.createEvent("HTMLEvents");
 	    changeEvent.initEvent("change");
 	    var selectFilter = grid.getHeaderFilter(columnID).querySelector('select');
 	    var inputFilter = grid.getHeaderFilter(columnID).querySelector('input');
 	    if(selectFilter){
 	     	selectFilter.value = " ";
 	    	selectFilter.dispatchEvent(changeEvent);
 	    }else{
 	     	inputFilter.value = " ";
 	     	inputFilter.dispatchEvent(changeEvent);
		}
 	    		
		}	    	 
	}

grid.events.on("cellClick", function(row, column, e) {

    gridOnRowSelect(row,column);

});



var layout = new dhx.Layout("grdGridArea2", {
	rows : [ {
		id : "b",
	}, ]
});	
var gridSubData =  ${gridSubData}; 

 var grid2 = new dhx.Grid("grdGridArea2", {
	 columns: [

		  	{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center",rowspan:2 }], align: "center" },
			{ width: 50, id: "CHK", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnChk(checked)'></input>" , align: "center", rowspan: 2}], align: "center", type: "boolean", editable: true, sortable: false},
			
			{ width: 70, id: "ItemTypeImg", header: [{ text: "${menu.LN00042}" , align: "center"}],htmlEnable:true, align: "center",
	        	template:function (text,row,col){
	        		return  '<img src="${root}${HTML_IMG_DIR_ITEM}/'+row.ItemTypeImg+'" width="18" height="18">';
	        	}},	
			{ width: 100, id: "Identifier", header: [{ text: "${menu.LN00015}" , align: "center" },{ content: "selectFilter" }],align: "center"},
			{ width: 200, id: "ItemName", header: [{ text: "${menu.LN00028}" , align: "center" },{ content: "inputFilter" }]},
			{ width: 250, id: "Path", header: [{ text: "${menu.LN00043}" , align: "center" }], align: "" },
			{ width: 100, id: "ClassName", header: [{ text: "${menu.LN00016}" , align: "center" },{ content: "selectFilter" }], align: "" },	
			{ width: 80, id: "TeamName", header: [{ text: "${menu.LN00014}" , align: "center" }], align: "" },
			{ width: 120, id: "OwnerTeamName", header: [{ text: "${menu.LN00018}" , align: "center" }], align: "" },
			{ width: 150, id: "Name", header: [{ text: "${menu.LN00004}" , align: "center" }], align: "" },
			{ hidden:true,width: 80, id: "LastUpdated", header: [{ text: "${menu.LN00013}" , align: "center" }], align: "" },
			{ hidden:true,width: 80, id: "Version", header: [{ text: "${menu.LN00017}" , align: "center" }], align: "" },
			{ hidden:true,width: 80, id: "ID", header: [{ text: "ItemID" , align: "center" }], align: "" },
			{ hidden:true,width: 80, id: "SCOUNT", header: [{ text: "SCOUNT" , align: "center" }], align: "" },
			
		],
	eventHandlers: {
		onclick: {
		
		}
	},
	autoWidth: true,
	resizable: true,
	selection: "row",
	tooltip: false,
	data: gridSubData
});
 
 layout.getCell("b").attach(grid2);

 grid2.events.on("cellClick", function(row, column, e) {

		gridOnRowSelect2(row,column);

		});

 function fnChk(state) {
	    event.stopPropagation();
	    grid2.data.forEach(function (row) {
	        grid2.data.update(row.id, { "CHK" : state })
	    })
	}
 
function gridOnRowSelect(row, col){ 

		var maxLevel = row.MaxLevel;
		dimValID = row.DimValueID;
		
		if (col.id!="checkbox") {
			
   		  $("#valueInsert").attr('style', 'display: block');
		}
	
		
		if(col.id =="MLBtn" &&(maxLevel*1) > 1){
			var url ="getDimensionSubLevel.do"
			var data = "&dimValueID="+row.DimValueID+"&dimTypeID=${s_itemID}";
			url += "?" + data;
			var option = "width=920,height=600,left=300,top=100,toolbar=no,status=no,resizable=yes";
		    window.open(url, self, option);
		}else if(col.id!="checkbox" && maxLevel!=2){
  
	
		
		  $("#grdGridArea2").show();

	 		subGridinit(dimValID);
	 		fnSearchList(row.DimvalueID);

		
			$("#sDimValue").val(row.DimvalueID);
			selectitemType();
	}
}
	


	function subGridinit(dimValID) {
		
	
		var	sqlID = "dim_SQL.selectDimPertinentDetailList";	
		var param = "dimTypeID=${s_itemID}&s_itemID="+dimValID+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}&v="
					//+$("#newClassCode").val()+"&searchValue="+$("#searchValue").val()
					+"&sqlID="+sqlID;	 		
		
	
			$.ajax({
				url:"jsonDhtmlxListV7.do",
				type:"POST",
				data:param,
				success: function(result){
				
				    grid2.data.parse(result);
				$("#TOT_CNT").html(grid2.data.getLength());
			 
				},error:function(xhr,status,error){
					console.log("ERR :["+xhr.status+"]"+error);
				}
			});
				
	}
	
	
	var pagination = new dhx.Pagination("pagination", {
	    data: grid2.data,
	    pageSize: 40,
	 
	});	
	pagination.setPage(document.getElementById('currPage').value);
	
	
	function fnSearchList(avg){
		 addDim(2);
		 subGridinit(avg);

	}	
		
	function assignDim2Item(){
		 console.log("dmValueID: "+dimValID);
		 var url = "searchNewDimItemPop.do";
		 var data = "dimTypeID=${s_itemID}&dimValueID="+dimValID;
		           
		 fnOpenLayerPopup(url,data,doCallBack,617,436);
			
		}
		
</script>
</body>
</html>