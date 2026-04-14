<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00163" var="WM00163" arguments='"+headerNM+"'/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>

<style>
	.tdhidden{display:none;}
</style>
<script>
	$(document).ready(function(){
		fnSelectNone('closingCode', '&Category=SCRCLSCD', 'CategroyTypeCode', '${scrInfo.ClosingCode}');
		
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 540)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 540)+"px;");
		};
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
</script>
<form name="scrResultFrm" id="scrResultFrm" action="#" method="post" onsubmit="return false;">
	<div class="floatC" style="overflow:auto;overflow-x:hidden;">
		<div class="floatR mgR10 mgB10">
			<span class="btn_pack small icon"><span class="save"></span><input value="Save" type="submit" onclick="fnSaveScrProcResult()"></span>
		</div>
		<table class="cb_module tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="15%">
				<col width="35%">
				<col width="15%">
				<col width="35%">
			</colgroup>
			<tr>
				<th class="alignL pdL10 viewline">종료코드</th>
				<td class="last">
					<select name="closingCode" id="closingCode" style="width:100%;"></select>
				</td>
				<th class="alignL pdL10 viewline">실제투입공수(M/D)</th>
				<td class="last"><input type="text" class="text" name="actualMD" value="${scrInfo.ActualManDay}"></td>
			</tr>
			<tr>
				<th class="alignL pdL10 viewline">처리내용</th>
				<td colspan=3 class="last"><textarea class="edit" name="changeNotice" style="width:100%;height:50px;background: #fff;">${scrInfo.ChangeNotice}</textarea></td>
			</tr>
		</table>
		<div class="countList">
			<li class="floatL mgL10" style="font-weight:700;">실제투입인력</li>
        	<li class="floatR mgR10">
				<span class="btn_pack medium icon"><span class="add"></span><input value="Add" onclick="fnAddSCRMbr()" type="submit"></span>&nbsp;
				<span class="btn_pack medium icon"><span class="del"></span><input value="Del" onclick="fnDelSCRMbr()" type="submit"></span>
			</li>
		</div>
		<div id="layout" style="width:100%;"></div>
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>

<script type="text/javascript">
var layout = new dhx.Layout("layout", {
    rows: [
        {
            id: "a",
        },
    ]
});

var gridData = ${gridData};
var grid = new dhx.Grid("grdOTGridArea", {
    columns: [
        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center", editable:false },
        { width: 50, id: "checkbox", header: [{ text: "" }], align: "center", type: "boolean",  editable: true},
        { width: 120, id: "UserName", header: [{ text: "Name" , align: "center" }, { content: "inputFilter" }], align: "center", editable:false },
        { width: 120, id: "Position", header: [{ text: "Position" , align: "center" }, { content: "selectFilter" }], align: "center", editable:false },
        { id: "TeamPath", header: [{ text: "${menu.LN00202}" , align: "center" }], align: "center", editable:false },
        { hidden: true, id: "MemberID", header: [{ text: "MemberID" , align: "center" }], align: "center" },
        { hidden: true,id: "CNT", header: [{ text: "CNT" , align: "center" }], align: "center" },
        { width: 120, id: "ActualManDay", header: [{ text: "공수(M/D)" , align: "center" }], align: "center"},
        { width: 200, id: "RoleDescription", header: [{ text: "업무설명" , align: "center" }], align: "center" },
    ],
    autoWidth: true,
    resizable: true,
    selection: "cell",
    multiselection: true,
    tooltip: false,
    editable: true,
    data: gridData
});
layout.getCell("a").attach(grid);

//filer search 시 total 값 변경
grid.events.on("filterChange", function(value,colId,filterId){
	$("#TOT_CNT").html(grid.data.getLength());
});

$("#TOT_CNT").html(grid.data.getLength());

function doSearchList(scrnType){
	var sqlID = "scr_SQL.getSCRMbrRoleList";
	var param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
		+ "&scrId=${scrId}"
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
	$("#TOT_CNT").html(grid.data.getLength());
}

//scrnType=A
var editedRow = [];
var editIds = [];

grid.events.on("AfterEditStart", function (row, col, editorType) {
	if(col.id == "ActualManDay")
    	dhx.awaitRedraw().then(function () {
        var element = document.querySelector(".dhx_cell-editor")
        element.type = "number"
    });
	
	// 수정 항목 추가
    if(!editIds.includes(row.id)) {
    	editIds.push(row.id);
		editedRow.push(row);
	}
});

function fnSaveScrProcResult() {
	var headerNM = $(".tbl_preview tr th:nth-child(5)").text();
	if (confirm("${CM00001}")) {
		var res = /^[0-9]+$/;
		var size = $("input[name^='actualMD']").size();
		for (var i = 0; i < size; i ++) {
			var actualManDay = $("input[name^='actualMD']").eq(i).val();
			if (!res.test(actualManDay)) {
				alert("${WM00163}");
				$("input[name^='actualMD']").eq(i).val("");
				$("input[name^='actualMD']").eq(i).focus();
				return false;
			}
		}
		fnSaveGridData();
	}
}

function fnSaveGridData(){
	if (editedRow.length == 0 ){
		fnAfterUpdateSendData();
	} else {
		var jsonData = JSON.stringify(editedRow);
		$.ajax({
	        type: "POST",
	        data: {"editedRow" : jsonData, "scrId" : "${scrId}", "scrnType" : "A" },
	        url: "updateSCRMembers.do",
	        async: false,
	        success: function(data) {
	        	editedRow = [];		        	
	        	fnAfterUpdateSendData();		        	
	        }, error:function(request,status,error){
	        	alert("${WM00068}");
	        }
	    });
	}
}

function fnAfterUpdateSendData() {
	var url = "saveScrProcResult.do?scrId=${scrId}";
	ajaxSubmit(document.scrResultFrm, url,"saveFrame");
}

function fnAddSCRMbr(){
	var url = "searchSCRMbrPop.do?srId=${srID}&scrId=${scrId}";
	window.open(url,'','width=800, height=700, left=100, top=200,scrollbar=yes,resizble=0');
}

// [Del] 버튼 Click
function fnDelSCRMbr() {
	
	var selectedCell = grid.data.findAll(function (data) {
        return data.checkbox;
    });
	
	if(selectedCell.length == 0){
		alert("${WM00023}");
	} else {
		if(confirm("${CM00004}")){
			var memberIds =""; 
			
			for(idx in selectedCell){
				var count = selectedCell[idx].CNT;
				if (count > 0) {
					var id = "LoginID : " + selectedCell[idx].UserName;
					"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00134' var='WM00134' arguments='"+ id +"'/>"
					alert("${WM00134}");
					selectedCell[idx].checkbox = false;
				} else {
					if (memberIds == "") {
						memberIds = selectedCell[idx].MemberID;
					} else {
						memberIds = memberIds + "," + selectedCell[idx].MemberID;
					}
				}
			}
			if (memberIds != "") {
				var url = "delSCRMembers.do";
				var data = "memberIds=" + memberIds+"&scrId=${scrId}&scrnType=${scrnType}";
				var target = "saveFrame";
				ajaxPage(url, data, target);
			}
		}
	} 
}

function fnCallBack(){
	var url = "viewScrProcResult.do";
	var data = "scrID=${scrId}&scrUserID=${scrInfo.RegUserID}&scrStatus=${scrInfo.Status}";
	var target = "scrResultFrm";
	ajaxPage(url, data, target);
}

</script>