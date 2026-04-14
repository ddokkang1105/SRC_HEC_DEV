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


<style>
	#classTypeDiv {
		overflow: auto;
		max-height: 100vh;
	}
</style>

<!-- 2. Script -->
<script type="text/javascript">

var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용

$(document).ready(function() {	
	
	// 초기 표시 화면 크기 조정
	$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 200)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 200)+"px;");
	};
	
	$("#excel").click(function(){ fnGridExcelDownLoad(); });		

	if ("${CategoryCode}" != "") {
		changeObjectType("${CategoryCode}", 1);
		setTimeout(function(){
			$("#ItemTypeCode").msDropDown();
		}, 200);
	}
	
	setTimeout(function(){
		$("#CategoryCode").msDropDown();
	},100);
	
	$('#CategoryCode').change(function(){
		changeObjectType($(this).val(), 0);
		setTimeout(function(){
			$("#ItemTypeCode").msDropDown();
		}, 100);
	});
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

function setOTLayout(type){
	if( schCntnLayout != null){
		schCntnLayout.unload();
	}
	schCntnLayout = new dhtmlXLayoutObject("schContainer",type, skin);
	schCntnLayout.setAutoSize("b","a;b"); //가로, 세로		
	schCntnLayout.items[0].setHeight(350);
}
	
//조회
function doOTSearchList(){
	var sqlID = "config_SQL.getAllocateClassList";
	var param = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
		      + "&sqlID="+sqlID;

	/* 검색 조건 선택 */
	// [Item Category]
	if($("#CategoryCode").val() != '' && $("#CategoryCode").val() != null){
		param += "&categories='"+$("#CategoryCode").val()+"'";
	}  else {
		if ("${CategoryCode}" != "") {
			param += "&categories='${CategoryCode}'";
		}
	}
	
	var ItemTypeCode = "${ItemTypeCode}";
	if(ItemTypeCode == null || ItemTypeCode == ''){
			param += "&ItemTypeCode="+$("#ItemTypeCode").val();
	} else {
		if($("#ItemTypeCode").val() != '' && $("#ItemTypeCode").val() != null ){
			param += "&ItemTypeCode="+$("#ItemTypeCode").val();
		} else {
			 if ($("#ItemTypeCode_title > .ddlabel").text() == 'Select'){
				param  = param;
			 } else {
				 param += "&ItemTypeCode="+ItemTypeCode;
			 }
		}
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
	$("#TOT_CNT").html(grid.data.getLength());
	fnMasterChk('');
}

//popup 창 띄우기, 창 크기 부분
function AddClassPopup() {
	var url = "addClassPop.do";
	var option = "width=510,height=250,left=300,top=300,toolbar=no,status=no,resizable=yes";
	window.open(url, self, option);
}

function fnCallBack() {
	doOTSearchList();	
}

function delClassType() {  //미사용
	if (OT_gridArea.getCheckedRows(1).length == 0) {
		//alert("항목을 한개 이상 선택하여 주십시요.");	
		alert("${WM00023}");	
	} else {
		//if (confirm("선택된 항목을 삭제하시겠습니까?")) {
		if (confirm("${CM00004}")) {
			var checkedRows = OT_gridArea.getCheckedRows(1).split(",");
			var classCodes = "";
			for ( var i = 0; i < checkedRows.length; i++) {
				var cnt = OT_gridArea.cells(checkedRows[i], 20).getValue(); //존재x
				if (cnt > 0) {
					var id = "ID:" + OT_gridArea.cells(checkedRows[i], 3).getValue();
					"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00112' var='WM00112' arguments='"+ id +"'/>"
					alert("${WM00112}");
					OT_gridArea.cells(checkedRows[i], 1).setValue(0); 
				} else {
					if (classCodes == "") {
						classCodes = OT_gridArea.cells(checkedRows[i], 3).getValue();
					} else{ 
						classCodes = classCodes + "," + OT_gridArea.cells(checkedRows[i], 3).getValue();
					}
				}
				
			}
			
			if (classCodes != "") {
				var url = "delClassType.do";
				var data = "classCodes=" + classCodes;
				var target = "ArcFrame";
				ajaxPage(url, data, target);
			}
			
		}
	}
	
}
	
function changeObjectType(avg1, avg2){
	var url    = "getObjectTypeList.do"; // 요청이 날라가는 주소
	var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&option="+avg1; //파라미터들
	var target = "ItemTypeCode";        // selectBox id
	var defaultValue = "";              // 초기에 세팅되고자 하는 값
	var isAll  = "select";              // "select" 일 경우 선택, "true" 일 경우 전체로 표시
	
	if (avg2 == 1) {
		defaultValue = "${ItemTypeCode}";  
	}
	
	ajaxSelect(url, data, target, defaultValue, isAll);
}


</script>

<body>
<div id="classTypeDiv">
<form name="classTypeList" id="classTypeList" action="#" method="post" onsubmit="return false;">
	<div id="processListDiv">
	<input type="hidden" id="setId" name="setId">
	<input type="hidden" id="LanguageID" name="LanguageID" value="${LanguageID}"/>
	<input type="hidden" id="SaveType" name="SaveType" value="New">
	<input type="hidden" id="orgClassCode" name="orgClassCode">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	</div>
	<div class="cfgtitle" >					
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Class Type</li>
		</ul>
	</div>
	<div class="child_search01 mgL10 mgR10" >
		<li class="pdL10">Item Category
			<select id="CategoryCode" name="CategoryCode" style="width:100px;margin-left:5px;">
				<option value="">Select</option>
				<c:forEach var="i" items="${CategoryOption}">
					<option value="${i.Category}" <c:if test="${i.Category eq CategoryCode}"> selected="selected"</c:if>>${i.Category}</option>						
				</c:forEach>				
			</select>
		</li>			
		<li class="pdL10">Item Type
			<select id="ItemTypeCode" name="ItemTypeCode" style="width:160px;margin-left:5px;">
				<option value="">Select</option>			
			</select>
		</li>
		<li class="pdL5">
			<input id="btnSearch" type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doOTSearchList();" value="검색">
		</li>	
		<li class="floatR pdR10">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<!-- 엑셀 다운 아이콘  -->
				&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
				<!-- ADD 버튼  -->
				&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" alt="신규" onclick="AddClassPopup()"></span>
				<!-- DEL 버튼, 현재 display:none; -->
				&nbsp;<span class="btn_pack small icon" style="display:none;"><span class="del"></span><input value="Del" type="submit" onclick="delClassType()"></span>
			</c:if>
		</li>
	</div>
    <div class="countList pdL10">
         <li class="count">Total  <span id="TOT_CNT"></span></li>
         <li class="floatR">&nbsp;</li>
     </div>
</form>
	<div id="gridOTDiv" class="mgB10 clear mgL10 mgR10">
		<div id="grdOTGridArea" style="height:400px; width:100%;"></div>
		<div id="pagination"></div></div>
	</div>
</div>	
<!-- START :: FRAME -->
<div class="schContainer" id="schContainer">
	<iframe name="ArcFrame" id="ArcFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
</div>
</body>

<script type="text/javascript">	
//===============================================================================
// BEGIN ::: GRID

var layout = new dhx.Layout("grdOTGridArea", { 
		rows: [
			{
				id: "a",
			},
		]
	});

	var gridData = ${gridData};
	var grid = new dhx.Grid("grdOTGridArea", {
		columns: [
			{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
			{ width: 60, id: "Icon", header: [{ text: "Icon", align:"center" }], htmlEnable: true, align: "center",
				template: function (text, row, col) {
					return '<img src="${root}${HTML_IMG_DIR_ITEM}/'+row.Icon+'" width="18" height="18">';
					}
			},
			{ width: 100, id: "id", header: [{ text: "${menu.LN00015}", align: "center" }], align: "center" },
			{ width: 550, id: "Name", header: [{ text: "${menu.LN00028}", align: "center" }], align: "left" },
			{ hidden: true, width: 250, id: "ClassName", header: [{ text: "${menu.LN00028}", align: "center" }], align: "center" },
			{ width: 100, id: "Level", header: [{ text: "Level", align: "center"  }], align: "center" },
			{ width: 100, id: "FileOption", header: [{ text: "File Option", align: "center" }] , align: "center"},				
			{ width: 150, id: "ChangeMgt", header: [{ text: "Change Management", align: "center"  }], align: "center" },				
			{ width: 100, id: "HasDimension", header: [{ text: "Dimension", align: "center" }], align: "center" },
			{ width: 100, id: "Deactivated", header: [{ text: "Deactivated", align: "center" }], align: "center" },
			{ hidden: true,width: 100, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align: "center" }], align: "center" },
			{ hidden: true, width: 80, id: "DefWFID", header: [{ text: "DefWFID", align: "center" }], align: "center" },
			{ hidden: true, width: 80, id: "WorkFlow", header: [{ text: "WorkFlow", align: "center" }], align: "center" },
			{ hidden: true, width: 80, id: "parent", header: [{ text: "parent", align: "center" }], align: "center" }
		],
		autoWidth: true,
		resizable: true,
		selection: "row",
		tooltip: false,
		data: gridData
	});
	layout.getCell("a").attach(grid);
	$("#TOT_CNT").html(grid.data.getLength());

	var pagination = new dhx.Pagination("pagination", {
		data: grid.data,
		pageSize: 20,
	});	

	//그리드ROW선택시
	grid.events.on("cellClick", function(row,column,e){
		if(column.id != "checkbox"){
			gridOnRowOTSelect(row);
		}
	}); 

	//그리드ROW선택시 -> ClassTypeView화면에서 뒤로가기 하면 DefineConnectionType.jsp로 이동하게 됨
	function gridOnRowOTSelect(row){		
		var url = "ClassTypeView.do";
		var data = "classCode="+ row.id		
				 + "&ClassName="+ row.Name		
				 + "&ItemTypeCode="+ row.parent;
		var target = "classTypeDiv";
		ajaxPage(url,data,target);
	}

	
// END ::: GRID	
//===============================================================================

</script>
</html>