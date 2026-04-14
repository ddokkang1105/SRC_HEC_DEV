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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용

	$(document).ready(function() {
		// 초기 표시 화면 크기 조정
		$("#layout").attr("style","height:"+(setWindowHeight() - 85)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 85)+"px;");
		};
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	//popup 창 띄우기, 창 크기 부분
	function AddObjectTypePop() {
	
		var url = "objectTypeView.do";
		var data = "&Category=" + $("#CategoryCode").val()+"&selectedCat="+$("#CategoryCode").val()+"&selectedItemType="+$("#itemTypeCode").val()
					+"&viewType=N";
	    var target = "objectTypeDiv";
	    
	    console.log("data: "+data);
	    ajaxPage(url, data, target); 
	    
	
	}
	
	//popup 창 띄우기, 창 크기 부분
	function AddClassPopup() {

		
		var url = "objectTypeView.do";
		var data = "&categories='OJ','REF','TXT','VAR','XOJ'"
			      +"&viewType=C";
		var target = "objectTypeDiv";
		ajaxPage(url, data, target);  
		
	}

	function fnEditObject(itemTypeCode){
		var url = "objectTypeView.do";
		var data = "cfgCode=${cfgCode}&ItemTypeCode="+ itemTypeCode+"&selectedCat="+$("#CategoryCode").val()+"&selectedItemType="+$("#itemTypeCode").val()
					+"viewType=Y";
		var target = "objectTypeDiv";
		ajaxPage(url, data, target);
	}
	
	function fnEditClass(classCode, itemTypeCode){
		var url = "subTab.do"; // 요청이 날라가는 주소
		var data = "url=AllocationListMenu&filter="+classCode
				+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&cfgCode=${cfgCode}"
				+"&selectedCat="+$("#CategoryCode").val()+"&selectedItemType="+$("#itemTypeCode").val()+"&ItemTypeCode="+itemTypeCode;
		var target = "objectTypeDiv";
		ajaxPage(url,data,target);
	}
	
	function exportXlsx() {
		fnGridExcelDownLoad(treeGrid);
	}
	
</script>
<style>
	.group_row {
		background: rgba(65, 152, 247, 0.15);
	}
	.dhx_layout-rows {
		flex: 1 auto;
	}
	.dhx_layout-columns .dhx_layout-rows:first-child .dhx_form-element {
		padding-right:20px;
	}
	.icon-bg {
		background: #525252;
	}
	.dhx_grid-row:hover {
		background: rgba(65, 152, 247, 0.15);
	    cursor: pointer;
	    box-shadow: 2px 0px 0px 0px #4265ee inset;
	    transition: background-color .2s ease-out;
	}
	.font-bold * {
		font-weight: 600;
	}
</style>
</head>
<body>
<div id="objectTypeDiv" style="display: block;height: 100%;overflow: hidden auto;">
<form name="objectTypeList" id="objectTypeList" action="saveObject.do" method="post" onsubmit="return false;">
	<div class="cfgtitle" >
				<span id="cfgPath">
					<c:forEach var="path" items="${path}" varStatus="status">
						<c:choose>
							<c:when test="${status.last}">
							<span style="font-weight: bold;">${path.cfgName}</span>
							</c:when>
							<c:otherwise>
							<span>${path.cfgName}&nbsp;>&nbsp;</span>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</span>
	</div>
	<div class="child_search01 mgL10 mgR10">
		<li class="">
			Category
			<select id="CategoryCode" name="CategoryCode" onchange="fnGetCategoryList(this.value)" style="margin-left:10px;margin-right: 20px;">
				<option value="">Select</option>
				<option value="OJ">Object</option>
				<option value="REF">Reference</option>
				<option value="TXT">Text</option>
				<option value="VAR">Variant</option>
				<option value="XOJ">Extra Object</option>
			</select>
			Item Type 
			<select id="itemTypeCode" name="itemTypeCode" onchange="fnGetItemTypeList(this.value)" style="margin-left:10px; width:150px;">
				<option value="">Select</option>
			</select>
		</li>
		<li class="floatR pdR10">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<button class="cmm-btn mgR5" style="height: 30px;" onclick="AddObjectTypePop()" value="Object" >Add Object Type</button>
				<button class="cmm-btn mgR5" style="height: 30px;" onclick="AddClassPopup()"  value="Class">Add Class</button>
				<button class="cmm-btn mgR5" style="height: 30px;" onclick="exportXlsx()" value="Down">Download List</button>
				<!-- 			<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit"  alt="삭제" onclick="delObjType()" ></span> -->
			</c:if>
		</li>
	</div>
	<div id="treeGridArea" style="width: 100%"></div>
	<div style="width: 100%;" id="layout"></div>
	</form>
</div>	
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var treeGridData = ${treeGridData};
	
	var treeGrid = new dhx.Grid("treeGridArea", {
		type: "tree",
	    columns: [
	    	{ id: "Name", type: "string", header: [{ text: "Name", align:"center" }, { content: "inputFilter" }], fillspace: true, htmlEnable: true,
	    		template: function (text, row, col) {
	            	var result = "";
	            	if(text) result += "<img src='${root}${HTML_IMG_DIR_ITEM}/" + row.Icon + "'>";
	            	if(row.parent) result += "<span class='font-bold mgL5'>"+text+"</span>";
	                return result;
	            }
	        },
	        { id: "Action", type: "string", header: [{ text: "Action", align:"center" }], width:150, htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		if(row.parent == "treeGridArea") return '<span class="btn_pack small icon mgR10"><span class="config"></span><input value="Config." type="submit" onclick="fnEditObject(\'' + row.id + '\')" ></span>';
	        		else return '<span class="btn_pack small icon mgR10"><span class="config"></span><input value="Config." type="submit" onclick="fnEditClass(\'' + row.id + '\', \'' + row.parent + '\')" ></span>';
	            },
	        },
// 	        { id: "checkbox", type: "boolean", header: [{ text: "" }], editable: true, width:70 },
	        { id: "id", type: "string", header: [{ text: "Code", align:"center" }, { content: "inputFilter" }], width:150, align:"center"},
	        { id: "Level", type: "string", header: [{ text: "Level", align:"center" }, { content: "selectFilter" }], width:150, align:"center" },
	        { id: "FileOption", type: "string", header: [{ text: "File Option", align:"center" }, { content: "selectFilter" }], width:150, align:"center"},
	        { id: "ChangeMgt", type: "string", header: [{ text: "Change Mgt", align:"center" }, { content: "selectFilter" }], width:150, align:"center"},
	        { id: "CheckInOption", type: "string", header: [{ text: "Check In Option", align:"center" }, { content: "selectFilter" }], width:150, align:"center" },
	        { id: "HasDimension", type: "string", header: [{ text: "Dimension", align:"center" }, { content: "selectFilter" }], width:150, align:"center" },
	        { id: "Deactivated", type: "string", header: [{ text: "Deactivated", align:"center" }, { content: "selectFilter" }], width:150, align:"center" },
	        { id: "Category", type: "string", header: [{ text: "Category" },{content :"selectFilter"}], width:100, hidden:true },
	    ],
	    autoWidth: true,
	    resizable: true,
	    data : treeGridData
	});

	layout.getCell("a").attach(treeGrid);
	
	treeGridData.filter(function (item) {
		if(item.parent != "treeGridArea") treeGrid.collapse(item.parent);
    });
	
	if("${selectedCat}" != "") {
		$("#CategoryCode").val("${selectedCat}");
		fnGetCategoryList("${selectedCat}");
		if("${selectedItemType}" != "") {
			fnGetItemTypeList("${selectedItemType}");
		}
	}
	

	function fnGetCategoryList(category){
		var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&option="+category;
		fnSelect('itemTypeCode', data, 'getObjectCodeFromClass', '${selectedItemType}', 'Select','config_SQL');
		treeGrid.data.findAll(function (item) {
			if(category == "") {
				treeGrid.data.findAll(function (item) {
					treeGrid.showRow(item.id);
				});
			}
			
			if(item.parent == "treeGridArea") {
				if(item.Category != category) treeGrid.hideRow(item.id);
				if(item.Category == category) treeGrid.showRow(item.id);
			}
		});
	}
	
	function fnGetItemTypeList(itemTypeCode){
		treeGrid.data.findAll(function (item) {
			if(itemTypeCode == "") {
				var category = document.getElementById("CategoryCode").value;
				if(item.parent == "treeGridArea") {
					if(item.Category != category) treeGrid.hideRow(item.id);
					if(item.Category == category) treeGrid.showRow(item.id);
				}
			} else {
				if(item.parent == "treeGridArea") {
					if(item.id != itemTypeCode) treeGrid.hideRow(item.id);
					if(item.id == itemTypeCode) treeGrid.showRow(item.id);
				}
			}
		});
	}
	
	
	function fnCallBack(){
		$.ajax({
			url: "getObjectAndClassList.do",
			data:"",
			type:"POST",
			cotentType:"application/json",
			success: function(result){				
				if(treeGrid != ""){
					treeGrid.data.parse(result);
					treeGridData.filter(function (item) {
						if(item.parent != "treeGridArea") treeGrid.collapse(item.parent);
				    });
				}
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	}
</script>
</body>
</html>
