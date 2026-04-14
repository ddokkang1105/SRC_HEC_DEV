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

	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {
		// 초기 표시 화면 크기 조정
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 340)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 340)+"px;");
		};
		doOTSearchList();
		$('#saveAllBtn').hide();
		$('#backBtn').hide();
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
</script>
</head>
<body>
	<form name="FileTypeList" id="FileTypeList" action="*" method="post" onsubmit="return false;">
		<c:if test="${empty s_itemID}">
			<div class="cfgtitle" >				
				<ul>
					<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;ESP File Type</li>
				</ul>
			</div>
		</c:if>
		<div class="floatR pdR10 mgB7">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<span id="backBtn" class="btn_pack nobg white"><a class="clear" onclick="fnBack()" title="Back"></a></span>
				<c:if test="${!empty s_itemID}">
					<button class="cmm-btn mgR5" style="height: 30px;" id ="add" onclick="AddEsmFileType()" type = "hidden">Add</button>
				</c:if>
				<button class="cmm-btn mgR5" style="height: 30px;" id ="saveAllBtn" onclick="fnSaveAll()" type = "hidden">Save All</button>
				<button class="cmm-btn mgR5" style="height: 30px;" id = "editBtn" onclick="fnEdit()">Edit</button>
				<button class="cmm-btn mgR5" style="height: 30px;" onclick="DeleteEsmFileType()" value="Del">Delete</button>
			</c:if>
		</div>		
		<div id="gridDiv" class="mgT10">
			<div id="grdGridArea" style="width:100%; height:300px;"></div>
		</div>	
		
	</form>
		<div class="schContainer" id="schContainer">
			<iframe name="ArcFrame" id="ArcFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
		</div>
	
	</body>
	<script>
	//===============================================================================
	// BEGIN ::: GRID

	var layout = new dhx.Layout("grdGridArea", { 
			rows: [
				{
					id: "a",
				},
			]
		});
	
		var gridData;
		var grid = new dhx.Grid(null, {
			columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
				{ width: 140, id: "FltpCode", header: [{ text: "FltpCode" , align: "center" }, { content: "selectFilter" }], align: "center" },
				{ width: 200, id: "Name", header: [{ text: "Name", align: "center" }, { content: "selectFilter" }], align: "center" },
				{ width: 200, id: "SpeCode", header: [{ text: "SpeCode", align: "center" }, { content: "inputFilter" }], align: "center" },
				{ fillspace: true, id: "FilePath", header: [{ text: "FilePath", align: "center" }, { content: "inputFilter" }], align: "left"},
				{ width: 200, id: "Mandatory", header: [{ text: "Mandatory", align: "center" }, { content: "selectFilter" }] , align: "center", editorType: "combobox", options: ['0', '1']},	
				{ width: 200, id: "Remark", header: [{ text: "Remark", align: "center" }, { content: "selectFilter" }] , align: "center"},
				{ width: 200, id: "LinkType", header: [{ text: "LinkType", align: "center" }, { content: "selectFilter" }] , align: "center", editorType: "combobox", options: ['01', '02']}		
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data: gridData
		});
		layout.getCell("a").attach(grid);

		function fnEdit() {	
			//grid.config.editable = true; 
			$('#editBtn').hide();
			$('#saveAllBtn').show();
			$('#backBtn').show();
			grid.getColumn("Mandatory").editable = true;
			grid.getColumn("Remark").editable = true;
			grid.getColumn("LinkType").editable = true;
		}
		
		
		function fnBack() {	
			$('#editBtn').show();
			$('#saveAllBtn').hide();
			$('#backBtn').hide();
			grid.getColumn("Mandatory").editable = false;
			grid.getColumn("Remark").editable = false;
			grid.getColumn("LinkType").editable = false;
		}

	// END ::: GRID	
	//===============================================================================

	function setSearchTeam(teamID,teamName){
		$('#ownerTeamCode').val(teamID);
		$('#teamName').val(teamName);
	}

	//조회
	function doOTSearchList(){
		var sqlID = "config_SQL.espFileAllocList";
		var param = "&languageID=${languageID}&s_itemID=${s_itemID}"
				  + "&sqlID="+sqlID;
			$.ajax({
				url:"jsonDhtmlxListV7.do",
				type:"POST",
				data:param,
				success: function(result){		
					grid.data.parse(result);
					fnMasterChk('');
				},error:function(xhr,status,error){
					console.log("ERR :["+xhr.status+"]"+error);
				}
			});	
		}	


	function AddEsmFileType(){	
		var url = "addEsmFileAllocPop.do";
		var data = "&TypeCode=${s_itemID}" + 
				   "&languageID=${languageID}"+ 
				   "&s_itemID=${s_itemID}" +
				   "&ClassName=" + escape(encodeURIComponent('${ClassName}'));
		url += "?" + data;
		var option = "width=920,height=600,left=300,top=100,toolbar=no,status=no,resizable=yes";
	    window.open(url, self, option);
	}

	function DeleteEsmFileType(){		
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){
			alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
		}else{
			if (confirm("${CM00004}")) {
				for (idx in selectedCell) {
					var url = "DeleteEsmFileType.do";
					var data = "&FltpCode=" + selectedCell[idx].FltpCode
					         + "&s_itemID=${s_itemID}";	
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
	

	function fnSaveAll(){
		var selectedData = grid.data.findAll(function (data) {
			return {
				fltpCodes: data.FltpCode,
				filepaths: data.FilePath,
				mandatories: data.Mandatory,
				remarks: data.Remark,
				linkTypes: data.LinkType,
				speCode : data.SpeCode
			};
		});
		
		var fltpCodes = "";
		var mandatories = "";
		var remarks = "";
		var linkTypes = "";
		var speCode = "";
		
		for(var i=0;i<selectedData.length;i++){
			if (i > 0) {
				fltpCodes += ",";
				mandatories += ",";
				remarks += ",";
				linkTypes += ",";
			}
			fltpCodes += selectedData[i].FltpCode;
			mandatories += (selectedData[i].Mandatory || '').trim() === '' ? '0' : selectedData[i].Mandatory;
			remarks += selectedData[i].Remark;
			linkTypes += selectedData[i].LinkType;
			speCode = selectedData[i].SpeCode;
		}

		var url = "updateEsmFltpAlloc.do?SpeCode="+speCode+"&fltpCodes="+fltpCodes+"&mandatories="+mandatories+"&remarks="+remarks+ "&linkTypes="+linkTypes;
		ajaxSubmit(document.FileTypeList, url,"ArcFrame");
	}
		
	function fnCallBack(){
		doOTSearchList();
	}
	
    var s_itemID = "${s_itemID}"; 
    if (s_itemID) {
        grid.hideColumn("SpeCode");
    }
	</script>
</html>