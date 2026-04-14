<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<c:url value="/" var="root" />

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

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<style>
.dhx_grid-cell {
	color: rgba(0, 0, 0, 0.95);
}
.dhx_grid-cell .edit-button, .dhx_grid-cell .save-button {
	padding: 0 25px;
}
.dhx_layout-rows {
	flex: 1 auto;
}

.dhx_layout-columns .dhx_layout-rows:not(:last-child) .dhx_form-element {
    padding-right: 20px;
}

.dhx_input {
	background-color: transparent;
}
.dhx_widget .dhx_toolbar  {
    border-bottom: 1px solid #ccc;
    padding-bottom: 10px;
}


</style>

<!-- 2. Script -->
<script type="text/javascript">
var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용

	$(document).ready(function() {
		
		$(document).ready(function() {
			$.ajaxSetup({
				headers: {
					'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
				},
			});	
		});
		
		
		var height = 360;
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:" + (setWindowHeight() - height) + "px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:" + (setWindowHeight() - height) + "px;");
		};
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	var formConfig = {
	        padding: 0,
	        rows: [
	        	{
	        		cols: [
	        			 {
	        				 rows: [
								 	{
										type: "text",
										readonly: true ,
	        			                name: "Category",
	        			                label: "Category",
										value: "${Category}", 
	        			            },
	        			            {
	        			                type: "input",
	        			                name: "X",
	        			                label: "X",
										inputType: "number",
	        			            },
									{
	        			                type: "input",
	        			                name: "FontSize",
	        			                label: "Font Size",
										inputType: "number",
	        			            },
									{
	        			                type: "input",
	        			                name: "StrokeWidth",
	        			                label: "Stroke Width",
										inputType: "number",
	        			            },
									{
										type: "select",
										options: [
											{ value: "C", content: "C" },
											{ value: "E", content: "E" },
											{ value: "V", content: "V" },
											{ value: "I", content: "I" }
										],
										name: "ScrnMode",
										label: "ScrnMode",
									},
	        				 ]
	        			 },
	        			 {
	        				 rows: [
									{
	        			                type: "input",
	        			                name: "AttrTypeCode",
	        			                label: "Attribute Type",
	        			            },
									{
	        			                type: "input",
	        			                name: "Y",
	        			                label: "Y",
										inputType: "number",
	        			            },
									{
										type: "colorpicker",
	        			                name: "FontColor",
	        			                label: "Font Color",
										inputType: "colorpicker"
	        			            },
									
									{
	        			                type: "colorpicker",
	        			                name: "StrokeColor",
	        			                label: "Stroke Color",
										inputType: "colorpicker"
	        			            },
	        			            {
	        			                type: "select",
	        			                name: "RefPoint",
	        			                label: "RefPoint",
	        			                options: [
											{ value: "1", content: "Top Left" },
											{ value: "2", content: "Top Right" },
											{ value: "3", content: "Bottom Right" },
											{ value: "4", content: "Bottom Left" },
											{ value: "5", content: "Top Middle" }
										],
										
	        			            },
								]
							},
							{
								rows: [
									{
	        			                type: "select",
	        			                name: "DisplayType",
	        			                label: "Display Type",
										options: [
											{ value: "", content: "Select" },
											{ value: "ID", content: "ID" },
											{ value: "Image", content: "Image" },
											{ value: "Text", content: "Text" },
											{ value: "Animation", content: "Animation" },
											{ value: "MOT", content: "MOT" }
										],
	        			            },
									{
	        			                type: "input",
	        			                name: "Width",
	        			                label: "Width",
										inputType: "number",
	        			            },
									{
	        			                type: "input",
	        			                name: "FontStyle",
	        			                label: "Font Style",
	        			            },
									{
										type: "colorpicker",
										name: "FillColor",
										label: "Fill Color",
										inputType: "colorpicker"
									},
									{
	        			                type: "input",
	        			                name: "MaxTextLen",
	        			                label: "MaxTextLen",
										inputType: "number"
	        			            }
	        				 ]
	        			 },
						 {
							padding: 4, 
							rows: [ 
									{
										type: "checkbox",
	        			                name: "HTML",
	        			                label: "HTML",
										value: "1",
										onchange: function(event) {
											if (event.target.checked) {
												form.setValue({ HTML: "1" });
											} else {
												form.setValue({ HTML: "0" });
											}
										}
	        			            },
									{
	        			                type: "input",
	        			                name: "Height",
	        			                label: "Height",
										inputType: "number"
	        			            },
									{
	        			                type: "input",
	        			                name: "FontFamily",
	        			                label: "FontFamily"
	        			            },
									{
										type: "colorpicker",
										name: "LabelBackgroundColor",
										label: "Label Background Color",
										inputType: "colorpicker"
									}	
							] 
						}
					]
	        	},
	            {
	                align: "end",
	                cols: [
	                    {
	                        id: "save-button",
	                        type: "button",
	                        text: "Save",              
	                        circle: true,
	                        submit: true,
	                    }
	                ]
	            }
	        ]
	    }
	
	var form;

	function fnAddNewAttrDp(data) {
		form = new dhx.Form(null, formConfig);

		if(data) { //edit pop
			editWindow.show();
			editWindow.attach(form);
			form.setValue(data);
			$("#mdpID").val(data.MDPID);
			$("#newYN").val('N');
		} else { //add pop
			addWindow.show();
			addWindow.attach(form);
			$("#mdpID").val('');
			$("#newYN").val('Y');
		}
		
		form.getItem("save-button").events.on("click", function (value) {
			if(form.validate(false, value)){
				var newData = form.getValue();
				var url = "admin/saveSymbolAttrDp.do";
				var data = "&symTypeCode=${symTypeCode}" 
						+ "&Category=${Category}" 
						+ "&Name=${Name}"
						+ "&attrTypeCode="+ (newData.AttrTypeCode || "")
						+ "&displayType="+ (newData.DisplayType || "")
						+ "&html="+ (newData.HTML || "")
						+ "&x="+ (newData.X || "")
						+ "&y=" + (newData.Y || "")
						+ "&width="+ (newData.Width || "")
						+ "&height="+ (newData.Height || "")
						+ "&fontSize="+ (newData.FontSize || "")
						+ "&fontColor="+ (newData.FontColor || "")
						+ "&fontFamily="+ (newData.FontFamily || "")
						+ "&fontStyle="+ (newData.FontStyle || "")
						+ "&strokeWidth="+ (newData.StrokeWidth || "")
						+ "&strokeColor="+ (newData.StrokeColor || "")
						+ "&fillColor="+ (newData.FillColor || "")
						+ "&labelBackgroundColor="+ (newData.LabelBackgroundColor || "")
						+ "&scrnMode="+ (newData.ScrnMode || "")
						+ "&mdpID=" + $("#mdpID").val()
						+ "&newYN=" + $("#newYN").val()
						+ "&refPoint="+ (newData.RefPoint || "")
						+ "&maxTextLen="+ (newData.MaxTextLen || "");
				var target = "sFrame";
				ajaxPage(url, data, target);
				closeEditor();
			}
		});
	}

	var addWindow = new dhx.Window({
		title: "Add Symbole Display",
	    width: 580,
	    height: 520,
	    modal: true,
	    movable: true
	});
	
	var editWindow = new dhx.Window({
		title: "Edit Symbole Display",
	    width: 580,
	    height: 520,
	    modal: true,
	    movable: true
	});
		
	function closeEditor() {
		form.clear();
		addWindow.hide();
	    editWindow.hide();
	}	
	
	function CheckBox(){
		var html = document.getElementsByName("HTML");
		if(html[0].checked == true){
			$("#html").val("1");
		}else{
			$("#html").val("");
		}
	}

	function fnDeletAttrDp(){
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox; 
		});
		if(!selectedCell.length){ //배열의 길이가 0   => !FALSE == TRUE
			alert("${WM00023}");	
		} else {
				// 배열의 길이가 하나이상 있음 1 => !TRUE ==FALSE
			if(confirm("${CM00004}")){ 
				var mdpIDs = new Array();
				for(idx in selectedCell){
					mdpIDs[idx] = selectedCell[idx].MDPID;
				}
				var url = "admin/deleteAttrDp.do";
				var data = "&mdpIDs="+mdpIDs;
				var target = "sFrame";
				ajaxPage(url, data, target);
				
			}
		}
}

</script>
<body>
<form name="allocSymTypeAttrDpForm" id="allocSymTypeAttrDpForm" action="*" method="post" onsubmit="return false;">
	<input type="hidden" id="symTypeCode" name="symTypeCode" value="${symTypeCode}">
	<input type="hidden" id="DisplayType" name="DisplayType" />
	<input type="hidden" id="newYN" name="newYN" >
	<input type="hidden" id="mdpID" name="mdpID" >
	<!-- <c:if test="${Category ne 'MDL'}">
 	<div class="SubinfoTabs mgL1 mgT20">
		<ul>
			<li id="pliug1" class="on"><a><span>Symbol Display</span></a></li>
		</ul>
	</div> 
	</c:if> -->
	<div class="child_search01 mgB5 mgL10 mgR10">
		<ul>
			<li class="floatR pdR10">
			<c:if test="${sessionScope.loginInfo.sessionAuthLev == '1'}">
			
			<button class="cmm-btn mgR5 floatR " style="height: 30px;" onclick="fnDeletAttrDp()" value="Del">Del</button>
			<button class="cmm-btn mgR5 floatR " style="height: 30px;" onclick="fnAddNewAttrDp()" value="Add">Add</button>
			</c:if>	
			</li>
		</ul>
		
	<div style="width: 100%;" id="layout">
	</div>
	
	<!-- <div id="editSymTypeAttrDp" name="editSymTypeAttrDp" class="mgT5 mgL10 mgR10" style="display:none">
	<table id="modSortNum" class="tbl_blue01" width="100%"   cellpadding="0" cellspacing="0">
		<tr>
			<th class="viewtop">${menu.LN00033}</th>
			<td class="viewtop">
				<input type="text" class="text" id="Category" name="Category" style="border:0px;background-color:#ffffff;" value="${Category}" readonly=true/>
			</td>
			<th class="viewtop">Attribute Type</th>
			<td class="viewtop"><input type="text" class="text" id="attrTypeCode" name="attrTypeCode"  /></td>
			<th class="viewtop">Display Type</th>
			<td class="viewtop">
				<select id="displayType" name="displayType" class="sel">
					<option value="">Select</option>
					<option value="ID">ID</option>
					<option value="Image">Image</option>
					<option value="Text">Text</option>
					<option value="Animation">Animation</option>
					<option value="MOT">MOT</option>
				</select>
			</td>
			<th class="viewtop">HTML</th>
			<td class="viewtop last"><input type="checkbox" name="html" id="html" onclick="CheckBox()" /></td>
		</tr>
		<tr>
			<th>X</th>
			<td><input type="number" class="text" id="x" name="x" /></td>
			<th>Y</th>
			<td><input type="number" class="text" id="y" name="y" /></td>
			<th>Width</th>
			<td><input type="number" class="text" id="width" name="width" /></td>
			<th>Height</th>
			<td class="last"><input type="number" class="text" id="height" name="height" /></td>
		</tr>
		<tr>
			<th>Font Size</th>
			<td><input type="number" class="text" id="fontSize" name="fontSize" /></td>
			<th>Font Color</th>
			<td><input type="text" class="text" id="fontColor" name="fontColor" /></td>
			<th>Font Style</th>
			<td><input type="number" class="text" id="fontStyle" name="fontStyle" /></td>
			<th>Font Family</th>
			<td class="last"><input type="text" class="text" id="fontFamily" name="fontFamily" /></td>
		</tr>
		<tr>
			<th>StrokeWidth</th>
			<td><input type="number" class="text" id="strokeWidth" name="strokeWidth" /></td>
			<th>StrokeColor</th>
			<td><input type="text" class="text" id="strokeColor" name="strokeColor" /></td>
			<th>FillColor</th>
			<td><input type="text" class="text" id="fillColor" name="fillColor" /></td>
			<th>LabelBackgroundColor</th>
			<td class="last"><input type="text" class="text" id="labelBackgroundColor" name="labelBackgroundColor" /></td>
		</tr>
		<tr>
			<th>ScrnMode</th>
			<td>
				<select id="scrnMode" name="scrnMode" class="sel">
					<option value="C">C</option>
					<option value="E">E</option>
					<option value="V">V</option>
					<option value="I">I</option>
				</select>
			</td>
			<td colspan=6 class="last"></td>
		</tr>
	</table>
	</div>	 
	<div class="alignBTN pdR10" id="saveBtn" style="display: none;">

		<button class="cmm-btn2 mgR10 floatR " style="height: 30px;" onclick="fnSaveSymbolAttrDp()"  value="save">Save</button>
	</div>-->
	<div class="schContainer" id="schContainer">
		<iframe name="sFrame" id="sFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
	</form>
	
<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var gridData = ${gridData};
	
	var grid = new dhx.Grid("grid",  {
	    columns: [
			{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}", align:"center"}], align:"center"},
	        { width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", align:"center"}], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 200, id: "Category", header: [{ text: "Category", align:"center" }], align: "center"},
	        { fillspace: true, id: "Name", header: [{text: "AttrType Code", align:"center"}], align: "center"},
	        { width: 200, id: "DisplayType", header: [{text: "Display Type", align:"center"}], align: "center"},
	        { width: 100, id: "X", header: [{ text: "X", align:"center" }], align:"center"},	
	        { width: 100, id: "Y", header: [{ text: "Y", align:"center"}], align:"center"},     
	        { width: 100, id: "Width", header: [{ text: "Width", align:"center" }], align:"center"},
	        { width: 100, id: "Height", header: [{ text: "Height", align:"center" }], align:"center"},
	        { width: 100, id: "FontSize", header: [{ text: "FontSize", align:"center" }], align:"center"},
	        { width: 100, id: "FontColor", header: [{ text: "FontColor", align:"center" }], align:"center"},
	        { width: 100, id: "FontFamily", header: [{ text: "FontFamily", align:"center" }], align:"center"},
	        { width: 50, id: "AttrTypeCode", header: [{ text: "AttrType Code", align:"center" }], align:"center", hidden: true},
	        { width: 50, id: "HTML", header: [{ text: "HTML", align:"center" }], align:"center", hidden: true},
	        { width: 50, id: "FontStyle", header: [{ text: "Font Style", align:"center" }], align:"center", hidden: true},
	        { width: 50, id: "StrokeWidth", header: [{ text: "Stroke Width", align:"center" }], align:"center", hidden: true},
	        { width: 50, id: "StrokeColor", header: [{ text: "Stroke Color", align:"center" }], align:"center", hidden: true},
	        { width: 50, id: "FillColor", header: [{ text: "Fill Color", align:"center" }], align:"center", hidden: true},
	        { width: 50, id: "LabelBackgroundColor", header: [{ text: "Label Background Color", align:"center" }], align:"center", hidden: true},
	        { width: 100, id: "ScrnMode", header: [{ text: "Scrn Mode", align:"center" }], align:"center"},
	        { width: 50, id: "MDPID", header: [{ text: "MDPID", align:"center" }], align:"center", hidden: true},
	        { width: 50, id: "RefPoint", header: [{ text: "RefPoint", align:"center" }], align:"center", hidden: true},
	        { width: 50, id: "MaxTextLen", header: [{ text: "MaxTextLen", align:"center" }], align:"center", hidden: true}

	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    multiselection : true   
	    
	});
	layout.getCell("a").attach(grid);
	
	grid.events.on("cellClick", function(row, column, e) {
	    if (column.id != "checkbox") {
			fnAddNewAttrDp(row);
	    }
	});
	
 	function urlReload(){
 		var sqlID = "config_SQL.getAttrTypeDpList";
		var param =  "symTypeCode=${symTypeCode}"				
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"				
					+ "&Category=${Category}"
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
		CheckBox();
 	}	
	 
</script>
</body>
</html>