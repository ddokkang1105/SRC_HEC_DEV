<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">


<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

<!-- 2. Script -->
<script type="text/javascript">

	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용

	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 480)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 480)+"px;");
		};
	});	
	
//===============================================================================
// BEGIN ::: GRID

	var layout = new dhx.Layout("grdGridArea", { 
			rows: [
				{
					id: "a",
				},
			]
		});
	
		var gridData = ${gridData};
		var grid = new dhx.Grid("grdGridArea", {
			columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
				{ width: 80, id: "SortNum", header: [{ text: "SortNum" , align: "center" }], align: "center" },
				{ width: 100, id: "ArcCode", header: [{ text: "ArcCode", align: "center" }], align: "center" },
				{ width: 300, id: "ArcName", header: [{ text: "ArcName", align: "center" }], align: "center" },
				{ width: 300, id: "Style", header: [{ text: "Style", align: "center" }], align: "center" },	
				{ width: 120, id: "Icon", header: [{ text: "Icon", align:"center" }], htmlEnable: true, align: "center",
					template: function (text, row, col) {
						return '<img src="${root}${HTML_IMG_DIR_ARC}/'+row.Icon+'" width="18" height="18">';
						}
				},
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data: gridData
		});
		layout.getCell("a").attach(grid);

		grid.events.on("cellClick", function(row,column,e){
			if(column.id != "checkbox"){
				gridOnRowOTSelect(row);
			}
		}); 

		//그리드ROW선택시
		function gridOnRowOTSelect(row){ 
			$("#editStNum").attr('style', 'display: block');	
			$("#editStNum").attr('style', 'width: 100%');	
			$("#divSaveStNum").attr('style', 'display: block');	
			$("#sortNum").val(row.SortNum);
			$("#sortNum").focus();
			$("#arcCode").val(row.ArcCode);
		}
		
// END ::: GRID	
//===============================================================================
	

	//조회
	function doOTSearchList(){
		var sqlID = "config_SQL.getAllocatedArchitectureList";
		var param = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&ArcCode=${ArcCode}"
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

	function fnReloadGrid(newGridData){
 		grid.data.parse(newGridData);
 		fnMasterChk('');
 	}

	function fnAddArc(){
		var url = "addArcListPop.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&ArcCode=${ArcCode}";
		var w = 700;
		var h = 700;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function fnDeleteArc(){
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){ //배열의 길이가 0   => !FALSE == TRUE
			alert("${WM00023}");	
		}
		var arcArr = [];
		var j = 0;
		for (idx in selectedCell) { 
				arcArr.push(selectedCell[idx].ArcCode);
		}
		
		if(confirm("${CM00004}")){
			var url = "deleteParentArc.do";
			var data = "&arcCode="+arcArr;
			var target = "ArcFrame";
			ajaxPage(url, data, target);	
		}
	}
	
	function fnGoBack(){
		var url = "architectureView.do";
		var target = "ArchitecturDetail";
		var data = "&ArcCode=${ArcCode}&pageNum=${pageNum}&languageID=${languageID}&viewType=${viewType}";		
		ajaxPage(url,data,target);
	}
	
	function fnSaveStNum(){
		if(confirm("${CM00001}")){
			var sortNum = $("#sortNum").val();
			var arcCode = $("#arcCode").val();
			var url = "updateArcStNum.do";
			var data = "&arcCode="+arcCode+"&sortNum="+sortNum; 
			var target = "ArcFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnCallBack(){ 
		$("#editStNum").attr('style', 'display: none');	
		$("#divSaveStNum").attr('style', 'display: none');
		$("#sortNum").val("");
		$("#arcCode").val("");
		
		doOTSearchList();
	}

	function goBack() {
		var url = "DefineArchitecture.do";
		var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&cfgCode=${cfgCode}";
		var target = "processListDiv";
		ajaxPage(url, data, target);
	}
</script>
</head>
<body>
	<form name="AllocArcList" id="AllocArcList" action="*" method="post" onsubmit="return false;">
		<input type="hidden" id="ItemTypeCode" name="ItemTypeCode" value="${ItemTypeCode}">
		<input type="hidden" id="ItemClassCode" name="ItemClassCode" value="${s_itemID}">
		<input type="hidden" id="AttrTypeCode" name="AttrTypeCode">
		<div class="floatR pdR10 mgB7">
			<button class="cmm-btn mgR10 floatR" style="height: 30px;" onclick="fnAddArc()"  value="Add">Add</button>
			<button class="cmm-btn mgR10 floatR" style="height: 30px;" onclick="fnDeleteArc()" value="Del">Delete</button>
		</div>
	
		<div id="gridDiv" class="mgT10" >
			<div id="grdGridArea" style="width:100%" class="clear"></div>	
		</div>
		<div class="mgT10" >
			<table id="editStNum" class="tbl_blue01" width="100%"   cellpadding="0" cellspacing="0" style="display:none">
				<tr>
					<th>SortNum</th>
					<td class="last">
						<input type="text" id="sortNum" name="sortNum" class="text" value="" />
						<input type="hidden" id="arcCode" name="arcCode" >
					</td>
				</tr>
			</table>
		</div>
		<div  class="alignBTN" id="divSaveStNum" style="display: none;">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<button class="cmm-btn2 mgR20 floatR" style="height: 30px;" onclick="fnSaveStNum()"  value="Save">Save</button>
			</c:if>		
		</div>
	</form>
		<!-- START :: FRAME -->
		<div class="schContainer" id="schContainer">
			<iframe name="ArcFrame" id="ArcFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
		</div>
</body>

</html>