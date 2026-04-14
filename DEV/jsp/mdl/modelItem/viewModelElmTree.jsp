<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/> 
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00124" var="WM00124"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00020" var="WM00020"/>
<style>
	.row-css {
		background: #eef1f7;
	}
</style>
<script type="text/javascript">
	var ptg_gridArea;
	var modelID = "${ModelID}";
	var gridChk = "${gridChk}";
	$(document).ready(function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 180)+"px;");
			window.onresize = function() {
				$("#layout").attr("style","height:"+(setWindowHeight() - 180)+"px;");
			};
		
		$("#excel").click(function(){ fnGridExcelDownLoad(grid); });
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID=${s_itemID}&modelID=${ModelID}&classCode=${groupClassCode}";
		fnSelect('classCode', data, 'getElementClassCode', '${classCode}', 'Select');
		fnSelect('groupClassCode', data, 'getGroupElementClassCode', '${groupClassCode}', 'Select');
		fnSelect('groupElementCode', data, 'getGroupElementCode', '${groupElementCode}', 'Select');
		
		if(gridChk == "group"){
			$("#group").prop('checked', true);
		} else if(gridChk == "connection"){
			$("#connection").prop('checked', true);
		} else {
			$("#element").prop('checked', true);
		}
		
		$(":input:radio[name=gridChk]").change(function(){
			view($(":input:radio[name=gridChk]:checked").val());
		})
		
		$("#searchKey").val("${searchKey}").attr("selected","selected");
		
		if("${showChild}" == "true") {$("#showChild").attr("checked","checked");}
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function fnGetGroupElementList(classCode){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&modelID=${ModelID}&classCode="+classCode;
		fnSelect('groupElementCode', data, 'getGroupElementCode', '', 'Select');
	}
		
	function modelPopDetail(mdlID){
		var url = "popupMasterMdlEdt.do?"
			+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+"&s_itemID=${s_itemID}"
			+"&modelID="+mdlID
			+"&scrnType=view"
			+"&selectedTreeID=${s_itemID}";
	var w = 1200;
	var h = 900;
	window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function itemPopDetail(itmID){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itmID+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,itmID);
	}
	
	function view(e){	
		gridChk = e;
		var url = "viewModelElmTree.do";
		var data = "s_itemID="+ "${s_itemID}" + 
							"&modelID=" + modelID +
							"&gridChk="+gridChk +
							"&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		if(gridChk == "element"){
			var classCode = $("#classCode").val();
			var searchKey = $("#searchKey").val();
			var searchValue = $("#searchValue").val();
			if(classCode != undefined & classCode != '' & classCode != null) data += "&classCode="+$("#classCode").val();
			if(searchKey != undefined & searchKey != '' & searchKey != null) data += "&searchKey="+$("#searchKey").val();
			if(searchValue != undefined & searchValue != '' & searchValue != null) data += "&searchValue="+$("#searchValue").val();
			data += "&showChild="+ $("#showChild").is(":checked");
			var target = "processDIV";
			ajaxPage(url,data,target);
		}
		if(gridChk == "group"){
			var groupClassCode = $("#groupClassCode").val();
			var groupElementCode = $("#groupElementCode").val();
			if(groupClassCode != undefined & groupClassCode != '' & groupClassCode != null) data += "&groupClassCode="+$("#groupClassCode").val();
			if(groupElementCode != undefined & groupElementCode != '' & groupElementCode != null) data += "&groupElementCode="+$("#groupElementCode").val();
			var target = "processDIV";
			ajaxPage(url,data,target);
		}
		if(gridChk == "connection"){
			document.querySelector(".child_search01.mgB5").remove();
	        grid.destructor();
			
			gridConfig = {
				columns: [
					{ width: 50, id: "RNUM", type: "string", header: [{ text: "No", align:"center" }], align: "center"},
			    	{ width: 50, id: "FromItemTypeImg", type: "string", header: [{ text: "${menu.LN00042}", align:"center" }], align: "center", htmlEnable : true,
			            template: (value, row, col) => {
			            	return  "<img src='${root}${HTML_IMG_DIR_ITEM}/"+row.FromItemTypeImg+"'>"
			            }
			        },
			    	{ width: 100, id: "SourceClassName", type: "string", header: [{ text: "${menu.LN00016}", align:"center" }, { content: "selectFilter" }], align: "center"},
			    	{ width: 70, id: "SourceID", type: "string", header: [{ text: "ID", align:"center" }, { content: "inputFilter" }], align: "center"},
			    	{ id: "SourceName", type: "string", header: [{ text: "Source Name", align:"center" }, { content: "inputFilter" }]},
			    	{ width: 50, id: "ToItemTypeImg", type: "string", header: [{ text: "${menu.LN00042}", align:"center" }], align: "center", htmlEnable : true,
			            template: (value, row, col) => {
			            	return  "<img src='${root}${HTML_IMG_DIR_ITEM}/"+row.ToItemTypeImg+"'>"
			            }
			        },
			    	{ width: 100, id: "TargetClassName", type: "string", header: [{ text: "${menu.LN00016}", align:"center" }, { content: "selectFilter" }], align: "center"},
			    	{ width: 70, id: "TargetID", type: "string", header: [{ text: "ID", align:"center" }, { content: "inputFilter" }], align: "center"},
			    	{ id: "TargetName", type: "string", header: [{ text: "Target Name", align:"center" }, { content: "inputFilter" }]},
			    	{ width: 130, id: "ConnectionName", type: "string", header: [{ text: "Connection Name", align:"center" }, { content: "inputFilter" }], align: "center"},
			    	{ hidden: true, id: "ObjectID", type: "string", header: [{ text: "ObjectID", align:"center" }, { content: "inputFilter" }]},
			    	{ hidden: true, id: "SourceItemID", type: "string", header: [{ text: "SourceItemID", align:"center" }, { content: "inputFilter" }]},
			    	{ hidden: true, id: "TargetItemID", type: "string", header: [{ text: "TargetItemID", align:"center" }, { content: "inputFilter" }]},
			    ],
			    autoWidth: true,
			    resizable: true
			}
			
			grid = new dhx.Grid("", gridConfig);
			layout.getCell("a").attach(grid);
			
			var param =  "&sqlID=model_SQL.getElementCxnItemList&languageID=${sessionScope.loginInfo.sessionCurrLangType}&modelID=${ModelID}";
		        
			$.ajax({
				url:"jsonDhtmlxListV7.do",
				type:"POST",
				data:param,
				success: function(result){
					grid.data.parse(result);
				},error:function(xhr,status,error){
					console.log("ERR :["+xhr.status+"]"+error);
				}
			});
			
			grid.events.on("cellClick", (row, column) => {
		    	if(column.id == "FromItemTypeImg" || column.id == "SourceClassName" || column.id == "SourceID" || column.id == "SourceName" ) itemPopDetail(row.SourceItemID);
		    	if(column.id == "ToItemTypeImg" || column.id == "TargetClassName" || column.id == "TargetID" || column.id == "TargetName" ) itemPopDetail(row.TargetItemID);
		    	if(column.id == "ConnectionName") itemPopDetail(row.ObjectID);
			});
		}
	}
	
	function fnEditAttr(){
		var checkedRows = grid.data.getInitialData().filter(e => e.checkbox);
		if(checkedRows.length == 0){	
			alert("${WM00023}");		
			return;
		}
		
		var itemIDs = new Array;
		var classCodes = new Array;
		var sessionUserID = "${sessionScope.loginInfo.sessionUserId}";
		var sessionAuthLev = "${sessionScope.loginInfo.sessionAuthLev}";
		
		for(var i = 0 ; i < checkedRows.length; i++ ){
			if(checkedRows[i].parent == "1" || checkedRows[i].id == "1"){}
			else {
				var blocked = checkedRows[i].Blocked;
				if(blocked != "0"){ // 
					alert("${WM00124}");
					return;
				} else if(sessionAuthLev != "1"&& sessionUserID != checkedRows[i].AuthorID){
					alert("${WM00040}");
					return;
				}
				
				if(checkedRows[i].ItemID) itemIDs.push(checkedRows[i].ItemID)
				if(checkedRows[i].ChildItemID) itemIDs.push(checkedRows[i].ChildItemID)
				classCodes.push(checkedRows[i].ClassCode)
			}
		}
		
		var url = "selectAttributePop.do?classCodes="+classCodes+"&items="+itemIDs+"&gridChk="+ $(":input:radio[name=gridChk]:checked").val();
		$("#items").val(itemIDs);
		var w = 600;
		var h = 600;
		itmInfoPopup(url,w,h);
	}
	
	function urlReload(){
		var gridChk = "${gridChk}";
// 		if(gridChk == "group"){
// 			$("#group").prop('checked', true);
// 			setPtgGridList();
// 		} else {
// 			$("#element").prop('checked', true);
// 			setPtgGridList();
// 		}
	}
	
	function fnEditSortNum(){
		var itemIDs = grid.data.getInitialData().filter(e => e.checkbox).map(e => e.ItemID).filter(e => e).join(",");
		if(itemIDs.length == 0){	
			alert("${WM00020}");		
			return;
		}
	
		var modelID = "${ModelID}";
		var url = "openEditModelSortNum.do?modelID="+modelID+"&itemIDs="+itemIDs;
		var w = 600;
		var h = 600;
		itmInfoPopup(url,w,h);
	}
	
	function fnShowChild(){
		view("element");
	}
</script>
<body>
<div id="processDIV">
	<input type="hidden" id="items" name="items" >
	<div class="child_search01">
		<li class="floatL pdL20">
			<input type="radio" name="gridChk" value="element" id="element"/><label for="element">&nbsp;Object</label>
			<input type="radio" name="gridChk" value="group" id="group" class="mgL10"/><label for="group">&nbsp;Group</label>
			<input type="radio" name="gridChk" value="connection" id="connection" class="mgL10"/><label for="connection">&nbsp;Connection</label>
<%-- 			<input type="image" class="image searchList mgL10" src="${root}${HTML_IMG_DIR}/btn_view2.png" value="View" onclick="view()"/> --%>
		</li>			
	</div>
	<c:if test="${gridChk eq 'element'}">
		<div class="child_search01 mgB5">		
			 <li class="floatL pdL20">
			 	${menu.LN00016}&nbsp;
				<select id="classCode" name="classCode" class="sel" style="width:130px;margin-left=5px;"></select>
		 	 	&nbsp;&nbsp;&nbsp;
		 	 	<select id="searchKey" name="searchKey" style="width:80px;">
					<option value="Name">Name</option>
					<option value="ID" >ID</option>
				</select>			
				<input type="text" class="text"  id="searchValue" name="searchValue" value="${searchValue}" style="width:250px;">
				<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="view('element')" value="Search">
				
				<input type="checkbox" id="showChild" name="showChild" OnClick="fnShowChild();" class="mgL20">&nbsp;<label for="showChild">Show Child</label>
		   	 </li>
			<li class="floatR pdR20">
				<c:if test="${sessionScope.loginInfo.sessionAuthLev < 4}">	
				<span class="btn_pack medium icon"><span class="edit"></span><input value="Attribute" onclick="fnEditAttr()" type="submit"></span>
				<span class="btn_pack medium icon"><span class="edit"></span><input value="Sequence" onclick="fnEditSortNum()" type="submit"></span>
				</c:if>
				<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>	
			</li>	
		</div>	
	</c:if>
	<c:if test="${gridChk eq 'group'}">
		<div class="child_search01 mgB5">		
			<li class="floatL pdL20">
			 	Element Group Class
				<select id="groupClassCode" name="groupClassCode" class="sel" OnChange="fnGetGroupElementList(this.value);" style="width:150px; margin:0 5px;"></select>
				 	&nbsp;Element Group
				<select id="groupElementCode" name="groupElementCode" class="sel" style="width:150px; margin:0 5px;"></select>
				<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="view('group')" value="Search">
			</li>
			<li class="floatR pdR20">
				<c:if test="${sessionScope.loginInfo.sessionAuthLev < 4}">	
				<span class="btn_pack medium icon"><span class="edit"></span><input value="Attribute" onclick="fnEditAttr()" type="submit"></span>
				</c:if>
				<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>	
			</li>		
		</div>
	</c:if>
	<div id="gridPtgDiv" class="mgB10 mgT10">
		<div id="grdPtgArea" style="width:100%;"></div>
	</div>
	
	<div style="width: 100%;" id="layout"></div>
</div>
<script>
	var gridConfig;
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var treeData = ${treeGridData};
	
	if(gridChk == "element") {
		gridConfig = {
			type: "tree",
			columns: [
		    	{ width: 350, id: "ItemName", type: "string", header: [{ text: "${menu.LN00028}", align:"center" }, { content: "inputFilter" }], htmlEnable : true,
		            template: (value, row, col) => {
		            	let result;
		            	if(row.id == "1") result = "<span style='font-weight: bold;'><img src='${root}${HTML_IMG_DIR_ITEM}/img_sitemap.png'>"+row.ItemName+"</span>";
		            	else if(row.ICON) result = "<span style='font-weight: bold;'><img src='${root}${HTML_IMG_DIR_ITEM}/"+row.ICON+"'>"+row.ItemName+"</span>";
		            	else result = row.ItemName;
		                return result;
		            }
		        },
		        { width: 30, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", htmlEnable: true }], align: "center", type: "boolean", editable: true, sortable: false},
		    	{ id: "Path", type: "string", header: [{ text: "${menu.LN00043}", align:"center" }, { content: "inputFilter" }]},
		    	{ width: 90, id: "OwnerTeamName", type: "string", header: [{ text: "${menu.LN00018}", align:"center" }, { content: "inputFilter" }], align: "center"},
		    	{ width: 80, id: "AuthorName", type: "string", header: [{ text: "${menu.LN00004}", align:"center" }, { content: "inputFilter" }], align: "center"},
		    	{ width: 90, id: "LastUpdated", type: "string", header: [{ text: "${menu.LN00070}", align:"center" }, { content: "inputFilter" }], align: "center"},
		    	{ width: 80, id: "StatusName", type: "string", header: [{ text: "${menu.LN00027}", align:"center" }, { content: "inputFilter" }], align: "center",	htmlEnable : true,
		    		template: (value, row, col) => {
		            	let result;
		            	if(row.Status == "NEW1") result = "<span style='color:blue;font-weight:bold'>"+value+"</span>";
		            	if(row.Status == "MOD1") result = "<span style='color:orange;font-weight:bold'>"+value+"</span>";
		            	else result = value;
		                return result;
	            	}
		    	},
		    	{ hidden: true, id: "ItemID", type: "string", header: [{ text: "ItemID", align:"center" }, { content: "inputFilter" }]},
		    	{ hidden: true, id: "ClassCode", type: "string", header: [{ text: "ClassCode", align:"center" }, { content: "inputFilter" }]},
		    	{ hidden: true, id: "AuthorID", type: "string", header: [{ text: "AuthorID", align:"center" }, { content: "inputFilter" }]},
		    	{ hidden: true, id: "Blocked", type: "string", header: [{ text: "Blocked", align:"center" }, { content: "inputFilter" }]},
		    	{ hidden: true, id: "ElementID", type: "string", header: [{ text: "ElementID", align:"center" }, { content: "inputFilter" }]},
		    ],
		    autoWidth: true,
		    resizable: true,
		    data : treeData
		}
	}
	
	if(gridChk == "group") {
		gridConfig = {
			type: "tree",
			columns: [
		    	{ width: 350, id: "ItemName", type: "string", header: [{ text: "${menu.LN00028}", align:"center" }, { content: "inputFilter" }], htmlEnable : true,
		            template: (value, row, col) => {
		            	let result;
		            	if(row.id == "1") result = "<span style='font-weight: bold;'><img src='${root}${HTML_IMG_DIR_ITEM}/img_sitemap.png'>"+row.ItemName+"</span>";
		            	else if(row.ICON) result = "<img src='${root}${HTML_IMG_DIR_ITEM}/"+row.ICON+"'>"+row.ItemName;
		            	else if(row.ItemTypeImg) result = "<img src='${root}${HTML_IMG_DIR_ITEM}/"+row.ItemTypeImg+"'> "+row.ItemName;
		            	else result = row.ItemName;
		                return result;
		            }
		        },
		        { width: 30, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", htmlEnable: true }], align: "center", type: "boolean", editable: true, sortable: false},
		    	{ width: 90, id: "ChildClassName", type: "string", header: [{ text: "${menu.LN00016}", align:"center" }, { content: "selectFilter" }], align: "center"},
		    	{ id: "Path", type: "string", header: [{ text: "${menu.LN00043}", align:"center" }, { content: "inputFilter" }]},
		    	{ width: 90, id: "OwnerTeamName", type: "string", header: [{ text: "${menu.LN00018}", align:"center" }, { content: "inputFilter" }], align: "center"},
		    	{ width: 80, id: "AuthorName", type: "string", header: [{ text: "${menu.LN00004}", align:"center" }, { content: "inputFilter" }], align: "center"},
		    	{ width: 90, id: "LastUpdated", type: "string", header: [{ text: "${menu.LN00070}", align:"center" }, { content: "inputFilter" }], align: "center"},
		    	{ width: 80, id: "StatusName", type: "string", header: [{ text: "${menu.LN00027}", align:"center" }, { content: "inputFilter" }], align: "center",	htmlEnable : true,
		    		template: (value, row, col) => {
		            	let result;
		            	if(row.Status == "NEW1") result = "<span style='color:blue;font-weight:bold'>"+value+"</span>";
		            	if(row.Status == "MOD1") result = "<span style='color:orange;font-weight:bold'>"+value+"</span>";
		            	else result = value;
		                return result;
	            	}
		    	},
		    	{ hidden: true, id: "ItemID", type: "string", header: [{ text: "ItemID", align:"center" }, { content: "inputFilter" }]},
		    	{ hidden: true, id: "ClassCode", type: "string", header: [{ text: "ClassCode", align:"center" }, { content: "inputFilter" }]},
		    	{ hidden: true, id: "AuthorID", type: "string", header: [{ text: "AuthorID", align:"center" }, { content: "inputFilter" }]},
		    	{ hidden: true, id: "Blocked", type: "string", header: [{ text: "Blocked", align:"center" }, { content: "inputFilter" }]},
		    	{ hidden: true, id: "ElementID", type: "string", header: [{ text: "ElementID", align:"center" }, { content: "inputFilter" }]},
		    ],
		    autoWidth: true,
		    resizable: true,
		    data : treeData
		}
	}
	
	var grid = new dhx.Grid("", gridConfig);
	
	grid.data.getInitialData().filter(e => e.parent == "1")?.forEach(e => {
	    grid.addRowCss(e.id, "row-css");
	})
	
	layout.getCell("a").attach(grid);
	 
	grid.events.on("afterEditEnd", (value, row, column) => {
	    if (column.type === "boolean") checkChildren(row.id, value);
	});
	
	grid.events.on("cellClick", (row, column) => {
		if(column.type !== "boolean"){
			if(row.id == "1") modelPopDetail(row.ModelID);
			else if(row.parent !== "1") {
		    	if(row.ItemID) itemPopDetail(row.ItemID);
		    	if(row.ChildItemID) itemPopDetail(row.ChildItemID);
		    }
		}
	});

	function checkChildren(parentId, value) {
	    grid.data.getInitialData().forEach(item => {
	        if (item.parent === parentId) {
	            grid.data.update(item.id, { checkbox: value });
	            if (item.id) {
	                checkChildren(item.id, value);
	            }
	        }
	    });
	}
</script>
</body>