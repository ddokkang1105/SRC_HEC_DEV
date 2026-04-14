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

<style>
	.marginT {
		margin-top: 38px !important;
	}
</style>

<!-- 2. Script -->
<script type="text/javascript">

	$(document).ready(function() {
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			},
		});	
	});

	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

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
		var grid = new dhx.Grid(null, {
			columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ width: 50, id: "checkbox", header: [{htmlEnable:true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
				{ width: 140, id: "FltpCode", header: [{ text: "FltpCode" , align: "center" }], align: "center" },
				{ width: 200, id: "Name", header: [{ text: "Name", align: "center" }], align: "center" },
				{ fillspace: true, id: "FilePath", header: [{ text: "FilePath", align: "center" }], align: "left"},
				{ width: 200, id: "LinkType", header: [{ text: "LinkType", align: "center" }] , align: "center"},				
				{ hidden: true, width: 80, id: "ItemClassCode", header: [{ text: "ItemClassCode", align: "center" }], align: "center" }	
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data: gridData
		});
		layout.getCell("a").attach(grid);

		//그리드ROW선택시
		grid.events.on("cellClick", function(row,column,e){
			if(column.id != "checkbox"){
				gridOnRowSelect(row);
			}
		}); 

		//그리드ROW선택시
		function gridOnRowSelect(row){
			var fltpCode = row.FltpCode;
			var fltpName = row.Name;
			var linkType = row.LinkType;
			var itemClassCode = row.ItemClassCode;
		
			$("#fltpCode").val(fltpCode);
			$("#fltpName").val(fltpName);
			$("#linkType").val(linkType);
			$("#itemClassCode").val(itemClassCode);		
			$("#linkTypeDiv").attr("style","visibility:visible");
		}

	// END ::: GRID	
	//===============================================================================

	function setSearchTeam(teamID,teamName){
		$('#ownerTeamCode').val(teamID);
		$('#teamName').val(teamName);
	}

	//조회
	function doOTSearchList(){
		var sqlID = "config_SQL.SubFileTab";
		var param = "&languageID=${languageID}&ItemClassCode=${s_itemID}&ClassName=${ClassName}"
				  + "&CategoryCode=${CategoryCode}&ItemTypeCode=${ItemTypeCode}&pageNum=${pageNum}"
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
	
	function AddFileType(){	
		var url = "addFileAllocPop.do";
		var data = "&TypeCode=${s_itemID}" + 
					"&languageID=${languageID}"+ 
					"&ItemTypeCode=${ItemTypeCode}" +
					"&ClassName=" + escape(encodeURIComponent('${ClassName}'));
		url += "?" + data;
		var option = "width=920,height=600,left=300,top=100,toolbar=no,status=no,resizable=yes";
	    window.open(url, self, option);
	}

	function DeleteFileType(){		
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){
			alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
		}else{
			if (confirm("${CM00004}")) {
				for (idx in selectedCell) {
					var url = "admin/DeleteFileType.do";
					var data = "&FltpCode=" + selectedCell[idx].FltpCode
					         + "&ItemClassCode=${s_itemID}";	
					var i = Number(idx) + 1;				
					if (i == selectedCell.length) {
						data = data + "&FinalData=Final";
					}
					var target = "ArcFrame";
					ajaxPage(url, data, target);
					grid.data.remove(selectedCell[idx].id);		
				}
			}
		}
	}

	function Back(){
		var url = "ClassTypeView.do";
		var target = "classTypeDiv";
		var data = "&ItemClassCode=${s_itemID}&LanguageID=${languageID}"
				 + "&CategoryCode=${CategoryCode}&ItemTypeCode=${ItemTypeCode}&pageNum=${pageNum}";
		ajaxPage(url,data,target);
	}
	
	function fnSaveLinkType(){
		if(confirm("${CM00001}")){	
			var fltpCode = $("#fltpCode").val();
			var linkType = $("#linkType").val();
			var itemClassCode = $("#itemClassCode").val();
			
			var url = "admin/updateFltpAlloc.do";
			var data = "&itemClassCode="+itemClassCode
						+ "&fltpCode="+fltpCode
						+ "&linkType="+linkType;
			var target = "ArcFrame";
			ajaxPage(url, data, target);
		}
	}
		
	function fnCallBack(){
		$("#linkTypeDiv").attr('style', 'visibility:hidden;');
		$("#alignBTN").attr('style', 'visibility:hidden;');
		doOTSearchList();
	}
</script>
</head>
<body>
	<form name="FileTypeList" id="FileTypeList" action="*" method="post" onsubmit="return false;">
		<div class="floatR pdR10 mgB7">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="AddFileType()"></span>
				<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="DeleteFileType()"></span>
			</c:if>
		</div>		
		<div id="gridDiv" class="mgT10">
			<div id="grdGridArea" style="width:100%; height:300px;"></div>
		</div>	
		<div class="marginT mgL10 mgR10" id="linkTypeDiv" style="visibility:hidden;">
			<table class="tbl_blue01" width="100%" border="0">
				<colgroup>
					<col width="10%">
					<col width="20%">
					<col width="10%">
					<col width="20%">
					<col width="10%">
					<col width="30%">
				</colgroup>
				<tr>
					<th class="viewtop">FltpCode</th> 
					<td class="viewtop">
						<input type="text" id="fltpCode" name="fltpCode" value="" style="width: 80%;border:0px;"/> 
						<input type="hidden" id="itemClassCode" name="itemClassCode" value=""/>
					</td>
					<th class="viewtop">FileName</th>
					<td class="viewtop"><input type="text" id="fltpName" name="fltpName" value="" style="width: 80%;border:0px;"/></td>
					<th class="viewtop">LinkType</th>
					<td class="viewtop last">
						<select class="sel" id="linkType" name="linkType">
							<option value="01">01</option>
							<option value="02">02</option>
						</select>
					</td>					
				</tr>
			</table>
			<div class="alignBTN">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				&nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="fnSaveLinkType();"></span>
			</c:if>
		</div>	
		</div>
		
	</form>
		<div class="schContainer" id="schContainer">
			<iframe name="ArcFrame" id="ArcFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
		</div>
	
	</body>
</html>