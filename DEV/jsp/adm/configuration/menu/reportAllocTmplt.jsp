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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

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
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 270)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 270)+"px;");
		};
	});	
	
	function setWindowHeight(){
		var size = window.innerHeight;
		var height = 0;
		if( size == null || size == undefined){height = document.body.clientHeight;}
		else{height=window.innerHeight;}
		return height;}
	
	//그리드ROW선택시
	function gridOnRowOTSelect(row){ 
		$("#editStNum").attr('style', 'display: block');	
		$("#editStNum").attr('style', 'width: 100%');	
		$("#divSaveBtn").attr('style', 'display: block');	
	
		var sortNum = row.SortNum;
		var reportCode = row.ReportCode;
		var varFilter = row.VarFilter;

		$("#sortNum").val(sortNum);
		$("#reportCode").val(reportCode);
		$("#varFilter").val(varFilter);
	}
	
	function fnGoBack(){
		var url = "defineTemplateView.do";
		var target = "tempListDiv";
		var data = "&templCode=${templCode}&languageID=${languageID}" 
					+"&pageNum=${pageNum}&viewType=${viewType}";
		
		ajaxPage(url,data,target);
	}
	
	function fnOpenReportMgtPop(){
		var url = "openReportMgtPop.do?templCode=${templCode}&projectID=${projectID}";
		var option = "width=480,height=500,left=600,top=100,toolbar=no,status=no,resizable=yes";
	    window.open(url, self, option);
	}
	
	

	function fnDeleteReportMgt(){
		var selectedCell = grid.data.findAll(function (data){
			return data.checkbox
		});
		if(!selectedCell.length){
			alert("${WM00023}");
			return;
		}else{
			if(confirm("${CM00004}")){
				var reportCode = new Array();
				for(idx in selectedCell){
					reportCode[idx] = selectedCell[idx].ReportCode;
				}
		
				var url = "admin/deleteReportAlloc.do";
				var data = "&reportCode="+reportCode+"&templCode=${templCode}&projectID=${projectID}";
				var target = "subFrame";
				ajaxPage(url, data, target); 
			}
		}
	}
	
	function fnSaveRptInfo(){
 		if(!confirm("${CM00001}")){ return;}		
		var url = "updateReportAllocInfo.do?templCode=${templCode}&templateCodeYN=Y"; 
		var target = "subFrame";
		ajaxSubmit(document.AddClassTypeList, url, "subFrame");
	}
	
</script>

<body>
<div id="templReportAlloc">
<form name="AddClassTypeList" id="AddClassTypeList"	action="*" method="post" onsubmit="return false;">
	<input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />
	<div class="countList pdT5">
         <li class="count"> Total <span id="TOT_CNT"></span></li>
         <li class="floatR">
   			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnOpenReportMgtPop()" value="Add">Add Report</button>
			<button class="cmm-btn mgR5" style="height: 30px;"  onclick="fnDeleteReportMgt()" value="Del">Delete</button>	
			</c:if>
         </li>
    </div>	
	<div id="gridDiv" class="clear">
	<div id="grdGridArea" style="width:100%"></div>
	</div>
	
	<div class="mgT10">
	<table id="editStNum" class="tbl_blue01" width="100%"   cellpadding="0" cellspacing="0" style="display:none">
		<colgroup>
			<col width="15%">
			<col width="60%">
			<col width="15%">
			<col width="10%">
		</colgroup>
		<tr>
			<th>VarFilter</th>
			<td class="last">
				<input type="text" class="text" id="varFilter" name="varFilter" />
				<input type="hidden" id="reportCode" name="reportCode" >
			</td>
			<th>SortNum</th>
			<td class="last">
				<input type="text" id="sortNum" name="sortNum" class="text"/>
			</td>
		</tr>
	</table>
    </div>
	<div  class="alignBTN" id="divSaveBtn" style="display: none;">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<button class="cmm-btn2 mgR5 mgT10 floatR" style="height: 30px;" onclick="fnSaveRptInfo()"  value="Save">Save</button>
		</c:if>		
	</div>
</form>
</div>
<!-- START :: FRAME -->
<div class="schContainer" id="schContainer">
	<iframe name="subFrame" id="subFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
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
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
			{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 100, id: "ReportCode", header: [{ text: "Code" , align: "center" }], align: "center" },
	        { width: 400, id: "ReportName", header: [{ text: "Name", align: "center" }], align: "left" },
	        { hidden:true,width: 60, id: "ProjectID", header: [{ text: "ProjectID", align: "center" }], align: "center" },
	        { hidden:true,width: 80, id: "ProjectName", header: [{ text: "ProjectName", align: "center" }], align: "center" },
	        { fillspace: true, id: "VarFilter", header: [{ text: "VarFilter", align: "center" }], align: "left" },
	        { width: 120, id: "SortNum", header: [{ text: "Sort No", align: "center" }], align: "center" }
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData
	});
	layout.getCell("a").attach(grid);
	$("#TOT_CNT").html(grid.data.getLength());
	
	grid.events.on("cellClick",function(row, column, e){
		  if(column.id !="checkbox"){
			  gridOnRowOTSelect(row);
		  }
	});
	function fnCallBack(){
		$("#editStNum").attr('style', 'display: none');	
		$("#divSaveBtn").attr('style', 'display: none');
	
		var sqlID = "config_SQL.getReportAllocList";		
		var param = "languageID=${languageID}&templCode=${templCode}"
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