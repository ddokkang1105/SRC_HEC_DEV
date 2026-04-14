<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용

	$(document).ready(function() {
		// 초기 표시 화면 크기 조정
		$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 340)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 340)+"px;");
		};
		$('#saveAllBtn').hide();
		$('#backBtn').hide();
		$("#excel").click(function(){ fnGridExcelDownLoad(); });
		doOTSearchList();
	});
	
	
function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
</script>

</head>

<body>
<div id="srActDiv">
	<form name="srActList" id="srActList" action="" method="post" onsubmit="return false;">	
	<input type="hidden" id="espAttrData" name="espAttrData" >
		<input type="hidden" id="ItemTypeCode" name="ItemTypeCode" value="${ItemTypeCode}">
	<input type="hidden" id="ItemClassCode" name="ItemClassCode" value="${s_itemID}">
	<input type="hidden" id="AttrTypeCode" name="AttrTypeCode">	
	<c:if test="${empty s_itemID}"><div class="cfgtitle" >				
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;SR Attribute Type</li>
		</ul>
	</div></c:if>
	<div class="child_search01 mgL10 mgR10">
		<li class="floatR pdR10">
		<span id="backBtn" class="btn_pack nobg white"><a class="clear" onclick="fnBack()" title="Back"></a></span>	<span></span>
		<c:if test="${!empty s_itemID}"><button class="cmm-btn mgR5" style="height: 30px;" onclick="AddSRAttributeType()" value="Add" >Add SR Attribute</button></c:if>	
		
			<button class="cmm-btn mgR5" style="height: 30px;" id ="saveAllBtn" onclick="fnSaveAll()" type = "hidden">Save All</button>
			<button class="cmm-btn mgR5" style="height: 30px;" id = "editBtn" onclick="fnEdit()">Edit</button>
			<button class="cmm-btn mgR5" style="height: 30px;" onclick="DelteSRAttrType()" value="Del">Delete</button>
						<button class="cmm-btn mgR5" style="height: 30px;" id="excel" value="Down">Download List</button>
		</li>
	</div>
	<div id="gridDiv" class="mgT10">
		<div id="grdOTGridArea" style="width:100%;"></div>
	</div>
	<div id="testDiv" style="margin-top: 3%"></div>
	</form>
		<div class="schContainer" id="schContainer">
		<iframe name="ArcFrame" id="ArcFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
	
</div>
</body>

<script type="text/javascript">	//그리드7 자바스크립트
//===============================================================================
// BEGIN ::: GRID
var layout = new dhx.Layout("grdOTGridArea", { 
		rows: [
			{
				id: "a",
			},
		]
	});
	var Link = ${Link};
	var LinkNames = ${LinkNames};
	var gridData;
	var grid = new dhx.Grid("grdOTGridArea", {
		columns: [
			{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
			{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
			{ width: 100, id: "DocCategory", header: [{ text: "DocCategory" , align: "center" }, { content: "inputFilter" }], align: "center" },
			{ hidden: true, width: 80, id: "SRType", header: [{ text: "SRType" , align: "center" }, { content: "selectFilter" }], align: "center" },
			{ width: 100, id: "SRTypeNM", header: [{ text: "SR Type" , align: "center" }, { content: "selectFilter" }], align: "center" },
			{ width: 100, id: "SpeCode", header: [{ text: "SpeCode", align: "center" }, { content: "inputFilter" }], align: "center" },
			{ width: 150, id: "SpeName", header: [{ text: "SpeName", align: "center" }, { content: "inputFilter" }], align: "center" },
			{ width: 100, id: "AttrTypeCode", header: [{ text: "AttrTypeCode", align: "center" }, { content: "inputFilter" }], align: "center" }, 
			{ width: 150, id: "Name", header: [{ text: "명칭", align: "center" }, { content: "inputFilter" }], align: "center" }, 
			{ width: 100, id: "SortNum", header: [{ text: "Sort No.", align: "center" }, { content: "inputFilter" }], align: "center" }, 
			{ width: 100, id: "Mandatory", header: [{ text: "Mandatory", align: "center" }, { content: "inputFilter" }], align: "center", editorType: "combobox", options:["0", "1"]}, 
			{ width: 100, id: "Invisible", header: [{ text: "Invisible", align: "center" }, { content: "inputFilter" }], align: "center", editorType: "combobox", options:["0", "1"]}, 
			{ width: 100, id: "Link", header: [{ text: "Link", align: "center" }, { content: "inputFilter" }], align: "center", editorType: "select", options: LinkNames}, 
			{ hidden: true, width: 100, id: "LinkCode", header: [{ text: "LinkCode", align: "center" }, { content: "inputFilter" }], align: "center" }, 
			{ width: 100, id: "RowNum", header: [{ text: "RowNum", align: "center" }, { content: "inputFilter" }], align: "center" }, 
			{ width: 100, id: "ColumnNum", header: [{ text: "ColumnNum", align: "center" }, { content: "inputFilter" }], align: "center" }, 
			{ width: 100, id: "AreaHeight", header: [{ text: "Height", align: "center" }, { content: "inputFilter" }], align: "center" }, 
			{ id: "VarFilter", header: [{ text: "VarFilter", align: "center" }, { content: "inputFilter" }], align: "center" }, 
			{ width: 100, id: "DefaultValue", header: [{ text: "Default Value", align: "center" }, { content: "inputFilter" }], align: "center" }, 
			{ width: 100, id: "Editable", header: [{ text: "Editable", align: "center" }, { content: "inputFilter" }], align: "center" }, 
			{ hidden: true, width: 100, id: "Seq", header: [{ text: "Seq", align: "center" }, { content: "inputFilter" }], align: "center" }, 
			{ hidden: true, width: 100, id: "ProcRoleTP", header: [{ text: "ProcRoleTP", align: "center" }, { content: "inputFilter" }], align: "center" }, 
			/* { width: 150, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align: "center" }, { content: "selectFilter" }], align: "center" },
			{ width: 150, id: "LastUserName", header: [{ text: "${menu.LN00105}", align: "center" }, { content: "selectFilter" }], align: "center" },
			{ hidden: true, width: 100, id: "ItemTypeCode", header: [{ text: "ItemTypeCode" }] }		 */
			
		],
		autoWidth: true,
		resizable: true,
		selection: "row",
		tooltip: false,
		data: gridData,
/* 		 eventHandlers: {
		        onclick: {
		            "save-button": function (e, data) {
		           		fnEditAttrType(data.row);
		            },
		            "edit-button": function (e, data) {
		            	fnEditAttrPop(data.row);
		            }
		        }
		    }, */
	});
	layout.getCell("a").attach(grid);

	grid.hideColumn("action");
    var s_itemID = "${s_itemID}"; //
    if (s_itemID) {
        grid.hideColumn("SpeCode");
    }

	grid.events.on("AfterEditEnd", function(value,row,column){
	    if(column.id == "Link") {
	    	if(value==""){
	    		grid.data.update(row.id, { LinkCode: " " }); //null로 update
	    	}else{
	    		var link = Link[Link.findIndex(function(obj){
			        return obj.NAME == value
			    })].CODE;
				grid.data.update(row.id, { LinkCode: link });
	    	}
	    }
	});
	
	function AddSRAttributeType(){
		var url = "addSRAttrTypeCode.do";
		var data = "s_itemID=${s_itemID}"+ 
					"&languageID=${languageID}"+ 
					"&ItemTypeCode=OJ00003"+
					"&ClassName=" + escape(encodeURIComponent('${ClassName}'));			
		url += "?" + data;
		var option = "width=920,height=600,left=300,top=100,toolbar=no,status=no,resizable=yes";
	    window.open(url, self, option);
	}
	
	function doOTSearchList(){
		var sqlID = "config_SQL.getEspActivityAttrTypeList";
		var param = "&s_itemID=${s_itemID}"
		+"&SpeCode=${SpeCode}"
		+"&ItemTypeCode=${ItemTypeCode}"
		+"&menuCat=ATR"
 					+ "&languageID=${languageID}"
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
	
	function DelteSRAttrType(){
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){
			alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
		}else{
			if (confirm("${CM00004}")) {
				for (idx in selectedCell) {
					console.log(typeof idx);
					var url = "DeleteSRAttrType.do";
					var data = "SpeCode=" + selectedCell[idx].SpeCode
							+ "&AttrTypeCode=" + selectedCell[idx].AttrTypeCode
					if (Number(idx) + 1 == selectedCell.length) {
						data = data + "&FinalData=Final"; }

					var target = "ArcFrame";
					ajaxPage(url, data, target);
					grid.data.remove(selectedCell[idx].id);
				}
			}
		}
	}
	function fnEdit() {	
		//grid.config.editable = true;
		$('#editBtn').hide();
		$('#saveAllBtn').show();
		$('#backBtn').show();
		//$('#backrBtn').show();
		grid.getColumn("SortNum").editable = true;
		grid.getColumn("Mandatory").editable = true;
		grid.getColumn("Invisible").editable = true;
		grid.getColumn("Link").editable = true;
		grid.getColumn("RowNum").editable = true;
		grid.getColumn("ColumnNum").editable = true;
		grid.getColumn("AreaHeight").editable = true;
		grid.getColumn("VarFilter").editable = true;
		grid.getColumn("DefaultValue").editable = true;
		grid.getColumn("Editable").editable = true;

	}
	function fnBack(){
		$('#editBtn').show();
		$('#saveAllBtn').hide();
		$('#backBtn').hide();
		doOTSearchList();
		grid.getColumn("SortNum").editable = false;
		grid.getColumn("Mandatory").editable = false;
		grid.getColumn("Invisible").editable = false;
		grid.getColumn("Link").editable = false;
		grid.getColumn("RowNum").editable = false;
		grid.getColumn("ColumnNum").editable = false;
		grid.getColumn("AreaHeight").editable = false;
		grid.getColumn("VarFilter").editable = false;
		grid.getColumn("DefaultValue").editable = false;
		grid.getColumn("Editable").editable = false;
	}
	var editedRow = [];
	function fnSaveAll(data){
		//if(!confirm("${CM00001}")){ return;}
		for(var i=0; i< grid.data._order.length; i++) {
			editedRow.push(grid.data._order[i]);	
		}

		var jsonData = JSON.stringify(editedRow);
		$("#espAttrData").val(jsonData);
		 
 		var url = "saveChildItemEspAttr.do";	
		ajaxSubmit(document.srActList, url, "blankFrame");
	}
	
	// END ::: GRID	
	//===============================================================================	
</script>
</html>
