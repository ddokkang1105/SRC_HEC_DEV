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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00020" var="WM00020"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00106" var="WM00106"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034"   arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_1" arguments="${menu.LN00033}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_2" arguments="${menu.LN00032}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_3" arguments="referenceModel"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00112" var="WM00112"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00123" var="WM00123"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00148" var="WM00148" />

<script>
	var itemAthId = "${selectedItemAuthorID}";
	var blocked = "${selectedItemBlocked}";
	var userId = "${sessionScope.loginInfo.sessionUserId}";
	var selectedItemStatus = "${selectedItemStatus}";
	
	$(document).ready(function(){		
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 370)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 370)+"px;");
		};
		
		$("#excel").click(function(){ fnGridExcelDownLoad(); });
		
		$('#searchKey').change(function(){
			if($(this).val() != ''){$('#search' + $(this).val()).show();}
		});
		fnReload();
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function doSearchMLList(){
		fnReload();
	}

	var checkSelect = true;
	function setSubFrame(avg){
		var ItemTypeCode = $("#ItemTypeCode").val(); 
		var data = "&ItemTypeCode="+ItemTypeCode;
		if(blocked == "0"){
			if(avg == 'newModel'){					
				$("#divTabModelAdd").removeAttr('style', 'display: none');
				$("#newModel").removeAttr('style', 'display: none');
				$("#divSaveModel").removeAttr('style', 'display: none');
				$("#modelInfo").attr('style', 'display: none');
				$("#moveOrg").attr('style', 'display: none');		
				$("#newIdentifier").focus();
				
				if(checkSelect){
					fnSelect('ModelTypeCode', data, 'getMDLTypeCode', '', 'Select'); //아이템타입에따른  모델유형
					fnSelect('MTCTypeCode', '', 'MTCTypeCode', '', 'Select');
					checkSelect = false;
				}
			}else if(avg == 'modelInfo'){
				$("#divTabModelAdd").attr('style', 'display: none');
				$("#newModel").attr('style', 'display: none');
				$("#divSaveModel").attr('style', 'display: none');					
			
			}else if(avg == 'copyModel'){
				$("#divTabModelAdd").attr('style', 'display: none');
				$("#newModel").attr('style', 'display: none');
				$("#divSaveModel").attr('style', 'display: none');		
				copyModel();
				
			}else if(avg == 'refModel'){
				$("#divTabModelAdd").attr('style', 'display: none');
				$("#newModel").attr('style', 'display: none');
				$("#divSaveModel").attr('style', 'display: none');	
				referenceModel();
			}else if(avg == 'e2eModel'){
				$("#divTabModelAdd").attr('style', 'display: none');
				$("#newModel").attr('style', 'display: none');
				$("#divSaveModel").attr('style', 'display: none');	
				createE2eModel();
			}
		}else{
			if(selectedItemStatus == "REL") {
		         alert("${WM00120}"); // [변경 요청 안된 상태]
		    } else {
		         alert("${WM00050}"); // [승인요청중]
		    }
		}
	}
	
	function delModel(){
		var ModelIDS = new Array;
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });	
	
		if(selectedCell.length == 0){
			alert("${WM00023}");
			return false;
		}else{			
			for(idx in selectedCell){					  
			  	if(selectedCell[idx].Blocked != "0"){ 
					alert("Model " + selectedCell[idx].Name +"${WM00148}");
				}else{
					ModelIDS.push(selectedCell[idx].ModelID);						
				}
			};	
			
			if(ModelIDS.length==0){
				alert("${WM00023}"); return false;
			}
			var url = "deleteModel.do";
			var target = "blankFrame";
			$("#ModelIDS").val(ModelIDS);
			ajaxSubmit(document.mdListFrm, url, target);
		}
	}
	
	
	function callbackDelete(){
		fnReload(); //reloadList();
	}
	
	function newModelInsert(){	
		if(blocked == "0"){
			if(itemAthId == userId || '${loginInfo.sessionMlvl}' == "SYS" ){
				if(confirm("${CM00009}")){	
					var url = "saveModel.do";
					var data = "?s_itemID=${s_itemID}"
								+"&ModelTypeCode="+$("#ModelTypeCode").val()
								+"&newIdentifier="+$("#newIdentifier").val()
								+"&MTCTypeCode="+$("#MTCTypeCode").val()
								+"&newModelName="+$("#newModelName").val();
					var target = "blankFrame";		
					ajaxSubmitNoAdd(document.mdListFrm, url, target);
				}
			}else{
				alert("${WM00040}");
				return;
			}
		}else{
			if(selectedItemStatus == "REL") {
		         alert("${WM00120}"); // [변경 요청 안된 상태]
		    } else {
		         alert("${WM00050}"); // [승인요청중]
		    }
		}
	}
		
	function copyModel(){ // 모델 카피 	
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });	
	
		if(blocked == "0"){		
			if(selectedCell.length != 1){
				alert("${WM00020}");
				return false;
			}else if(selectedCell.length > 1){			
				alert("${WM00106}");
				return false;
			}
			
			if(itemAthId == userId || '${loginInfo.sessionMlvl}' == "SYS" ){
				for(idx in selectedCell){	
				  	itemID = selectedCell[idx].ItemID;	
				  	var url = "openCopyModelPop.do?ModelID="+selectedCell[idx].ModelID+"&ModelName="+encodeURIComponent(selectedCell[idx].Name);
					var w = 500;
					var h = 200;
					itmInfoPopup(url,w,h);
				};	
			}else{
				alert("${WM00040}");
				return;
			}
		}else{
			if(selectedItemStatus == "REL") {
		         alert("${WM00120}"); // [변경 요청 안된 상태]
		    } else {
		         alert("${WM00050}"); // [승인요청중]
		    }
		}
	}
	
	function callbackSave(modelID){ 
		fnReload();
	
		$("#ModelTypeCode").val("");
		$("#newIdentifier").val("");
		$("#MTCTypeCode").val("");
		$("#newModelName").val("");
		
		$("#divTabModelAdd").attr('style', 'display: none');
		$("#newModel").attr('style', 'display: none');
		$("#divSaveModel").attr('style', 'display: none');
		
		$(".popup_div").hide();
		$("#mask").hide();
		
		var itemId = "${s_itemID}";
		
		var url = "popupMasterMdlEdt.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&s_itemID="+itemId+"&modelID="+modelID+"&modelName=&scrnType=edit";
		var w = 1200;
		var h = 900;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
		
	function reloadList(){
		doSearchMLList();
	}
	
	function referenceModel(){		
		var ItemTypeCode = $("#ItemTypeCode").val();
		var ItemID =  $("#s_itemID").val();
		if(blocked=="0"){	
			if(itemAthId == userId  || '${sessionScope.loginInfo.sessionMlvl}' == "SYS"){			
				var url = "openReferenceModelPop.do?ItemTypeCode="+ItemTypeCode+"&ItemID="+ItemID+"&blocked="+blocked+"&itemAuthId="+itemAthId;
				var w = 500;
				var h = 400;
				itmInfoPopup(url,w,h);
				
			}else{
				alert("${WM00040}");
				return;
			}
		}else{
			if(selectedItemStatus == "REL") {
		         alert("${WM00120}"); // [변경 요청 안된 상태]
		    } else {
		         alert("${WM00050}"); // [승인요청중]
		    }
		}
	}
	
	function createE2eModel(){
		if(blocked == "0"){
			var ItemTypeCode = $("#ItemTypeCode").val();
			var ItemID =  $("#s_itemID").val();
			if(blocked != "2" && itemAthId == userId || '${loginInfo.sessionMlvl}' == "SYS" ){
				
				var url = "createE2eModelPop.do?ItemTypeCode="+ItemTypeCode+"&ItemID="+ItemID+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
				var w = 500;
				var h = 300;
				itmInfoPopup(url,w,h);
				
			}else{
				alert("${WM00040}");
				return;
			}
		}else{
			if(selectedItemStatus == "REL") {
		         alert("${WM00120}"); // [변경 요청 안된 상태]
		    } else {
		         alert("${WM00050}"); // [승인요청중]
		    }
		}
	}
	
	// e2E모델 생성할 트리 오픈
	function openE2eTreeListPop(newModelName, MTCTypeCode, ModelTypeCode, ItemTypeCode, arcFilter){
		var ItemID =  $("#s_itemID").val();
		var url = "e2eTreeListPop.do";
		var data = "newModelName="+encodeURIComponent(newModelName)+"&MTCTypeCode="+MTCTypeCode+"&ModelTypeCode="+ModelTypeCode+"&ItemID="+ItemID+"&ItemTypeCode="+ItemTypeCode+arcFilter;

		fnOpenLayerPopup(url,data,"",617,436);
	}
		
	// [back] click
	function goNewItemInfo() {
		var url = "NewItemInfoMain.do";
		var target = "actFrame";
		var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}"; 
	 	ajaxPage(url, data, target);
	}	
	
	// 모델간 비교 
	function fnCompareModel(){
	
		var url = "modelInfoMgt.do";
		var data = "?itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&listFilterType=compareModelList";
		var w = 750;
		var h = 600;
		
		itmInfoPopup(url+data,w,h);
		//openUrlWithDhxModal(url+data, null, "", w, h);
	}	
</script>
<form name="mdListFrm" id="mdListFrm" action="#" method="post" onsubmit="return false;">
	<div id="divMDList" class="hidden" style="width:100%;height:100%;">
	<input type="hidden" id="itemID" name="itemID">
	<input type="hidden" id="ItemID" name="ItemID">
	<input type="hidden" id="checkIdentifierID" name="checkIdentifierID">
	<input type="hidden" id="itemDelCheck" name="itemDelCheck" value="N">
	<input type="hidden" id="option" name="option" value="${option}">
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
	<input type="hidden" id="level" name="level" value="${request.level}">
	<input type="hidden" id="Auth" name="Auth" value="${sessionScope.loginInfo.sessionLogintype}">	
	<input type="hidden" id="ownerTeamID" name="ownerTeamID" />	
	<input type="hidden" id="fromItemID" name="fromItemID" >	
	<input type="hidden" id="loginID" name="loginID" value="${sessionScope.loginInfo.sessionUserId}">
	<input type="hidden" id="itemAuthID" name="itemAuthID" value="${itemAthId}">
	<input type="hidden" id="ItemTypeCode" name="ItemTypeCode" value="${ItemTypeCode}" >
	<input type="hidden" id="languageID" name="languageID" value="${sessionScope.loginInfo.sessionCurrLangType}" >
	<input type="hidden" id="ModelIDS" name="ModelIDS" >
	<input type="hidden" id="projectID" name="projectID" value="${itemInfo.ProjectID}" >
	<input type="hidden" id="changeSetID" name="changeSetID" value="${itemInfo.CurChangeSet}" >
	<div style="overflow:auto;overflow-x:hidden;">			
		<div class="child_search">
		 <li class="shortcut">
		 	<img src="${root}${HTML_IMG_DIR}/img_folderClosed.png"></img>&nbsp;&nbsp;<b>${menu.LN00058}</b>&nbsp;&nbsp;&nbsp;
		 	<select id="searchKey" name="searchKey" style="width:80px;">
				<option value="Name">Name</option>
				<option value="ID" <c:if test="${!empty searchID}"> selected="selected" </c:if> >ID</option>
			</select>			
			<input type="text" class="text"  id="searchValue" name="searchValue" value="${searchValue}" style="width:150px;">
			<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchMLList()" value="검색">
	   	 </li>
			<li class="floatR pdR20">
			<c:if test="${myItem == 'Y' && itemBlocked == '0'}">
				<span class="btn_pack small icon"><span class="add"></span><input value="Create" type="submit" onclick="setSubFrame('newModel')"></span>&nbsp;
				<span class="btn_pack small icon"><span class="copy"></span><input value="Copy" type="submit" onclick="setSubFrame('copyModel')"></span>&nbsp;
				<span class="btn_pack small icon"><span class="ref"></span><input value="Reference Copy" type="submit" onclick="setSubFrame('refModel')"></span>&nbsp;				
				<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delModel()"></span>&nbsp;
			</c:if>
				<span class="btn_pack small icon"><span class="model"></span><input value="Compare" type="submit" onclick="fnCompareModel();"></span>
			</li>			

		</div>
		<div class="countList" style="margin-bottom:0px; ">
             <li class="count">Total  <span id="TOT_CNT"></span></li>
             <li class="floatR">&nbsp;</li>
        </div>
		<div style="width: 100%;" id="layout"></div>
		<div id="pagination"></div>
	</div>
	<div id="divTabModelAdd" class="ddoverlap" style="display: none;">
		<ul>
			<li class="selected" ><a><span>Create Model</span></a></li>
		</ul>
	</div>
	<table id="newModel" class="tbl_blue01 mgT5" width="100%"  cellpadding="0" cellspacing="0" style="display: none;">
		<tr>
			<!-- <th>${menu.LN00008}${menu.LN00015}</th> -->
			<th>${menu.LN00028}</th>
			<th>${menu.LN00033}</th>
			<th>${menu.LN00032}</th>
		</tr>
		<tr>
			<!-- <td><input type="text" class="text" id="newIdentifier" name="newIdentifier"  value=""/></td> -->
			<td><input type="text" class="text" id="newModelName" name="newModelName"  value=""/></td>
			<td><select id="MTCTypeCode" name="MTCTypeCode" class="sel"></select></td>
			<td><select id="ModelTypeCode" name="ModelTypeCode" class="sel"></select></td>
		</tr>	
	</table>
	<div id="modelInfo"></div>	
	<div  class="alignBTN" id="divSaveModel" style="display: none;">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<span class="btn_pack medium icon"><span  class="save"></span><input value="Save" onclick="newModelInsert()"  type="submit"></span>
		</c:if>		
	</div>	
	</div>
	</form>
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>	
	
<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid;
	var pagination;

	
	var grid = new dhx.Grid("grid",  {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center"},
	        { width: 30, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", htmlEnable: true }], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 110, id: "ModelID", header: [{ text: "Model No.", align:"center" }], align:"center"},
	        { width: 100, id: "CSVersion", header: [{ text: "Version", align:"center" }], align:"center"},
	        {             id: "Name", header: [{ text: "${menu.LN00028}", align:"center" }], align:"left", htmlEnable: true},	        
	        { width: 150, id: "ModelTypeName", header: [{ text: "${menu.LN00032}", align:"center" }], align:"center"},
	        { width: 120, id: "MTCName", header: [{ text: "${menu.LN00033}", align:"center" }], align:"center"},
	        { width: 110, id: "StatusName", header: [{ text: "${menu.LN00027}", align:"center" }], htmlEnable: true, align:"center"},	        
	        { width: 90, id: "Creator", header: [{text: "${menu.LN00060}", align:"center"}], align: "center"},
	        { width: 100, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align:"center" }], align:"center", htmlEnable: true},
	        { width: 80, id: "BtnControl", header: [{ text: "${menu.LN00125}", align:"center" }], htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR}/'+row.BtnControl+'" width="55" height="24">';
	            }
	        }
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    multiselection : true   
	    
	});
	
	$("#TOT_CNT").html(grid.data.getLength());
	
	grid.events.on("cellClick", function(row,column,e){
		if(column.id != "checkbox" && column.id != "BtnControl"){
			var param = {           
							s_itemID : row.ItemID,
							modelID : row.ModelID,
							scrnType : "modelBasicInfoPop",
							filter : "${filter}"
						};
				
			fnPostWindowOpen('POST', '/modelInfoMain.do', param , 'pop');
			
		}else if(column.id == "BtnControl") { // popup model
			if(row.MTCategory == "VER" || row.Blocked != "0"){// 카테고리가 vsersion 이면 model viewr open		
				   scrnType =  "view";
			}else{	
				if(row.IsPublic == 1){
					scrnType = "edit";					
				} else{
					if(row.Blocked == "0" && "${myItem}" == "Y" ){
						scrnType = "edit";	
					} else{
						scrnType = "view";
					}
				}					
			}
			var url = "popupMasterMdlEdt.do?"
				+"languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+"&s_itemID="+row.ItemID
				+"&modelID="+row.ModelID
				+"&scrnType="+scrnType
				+"&MTCategory="+row.MTCategory
				+"&modelName="+encodeURIComponent(row.Name)
			    +"&modelTypeName="+encodeURIComponent(row.ModelTypeName)
				+"&menuUrl="+row.URL
				+"&changeSetID="+row.ChangeSetID
				+"&selectedTreeID=${s_itemID}";
			var w = 1200;
			var h = 900;
			window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		}
			
	 }); 
	 
	 grid.events.on("filterChange", function(row,column,e,item){
		$("#TOT_CNT").html(grid.data.getLength());
	 });

	 layout.getCell("a").attach(grid);
	 
	 if(pagination){pagination.destructor();}
	 pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});
		
	var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
	var viewYN = "${viewYN}";
	var searchKey = $("#searchKey").val()
	var searchValue = $("#searchValue").val()
	var s_itemID = "${s_itemID}";

	
	async function fnReload() { 
		var sqlID = "model_SQL.getModelList";
	    const requestData = { 
	        s_itemID, 
	        languageID, 
	        viewYN, 
	        searchKey, 
	        searchValue, 
	        sqlID 
	    };
	
	    const params = new URLSearchParams(requestData).toString();
	    const url = "jsonDhtmlxListV7.do?" + params;
	
	    try {
	        const response = await fetch(url, { method: 'GET' });
	
	        if (!response.ok) {
	            throw new Error("Server response error");
	        }
	        const result = await response.json();
/*	        if (!result.success) {
	            throw new Error(result.message);
	        }*/
	        if (result) {
	            fnReloadGrid(grid, result);
	        } else {
	            fnReloadGrid(grid, []);
	        }
	
	    } catch (error) {
	        handleAjaxError(error, "LN0014");
	    }
	}
	
	function handleAjaxError(err, errDicTypeCode) {
		console.error(err);
		Promise.all([getDicData("ERRTP", errDicTypeCode), getDicData("BTN", "LN0034")])
		.then(([errDic, btnDic]) => showDhxAlert(errDic.LABEL_NM, btnDic.LABEL_NM));
	}
	
 	function fnReloadGrid(targetGrid, newGridData){
		targetGrid.data.parse(newGridData);
 		$("#TOT_CNT").html(targetGrid.data.getLength());
 	}
	
    function fnPostWindowOpen(verb, url, data, target) {     
		window.open("",target,"toolbar=no, width=1200, height=900, directories=no, status=no,scrollorbars=no, resizable=no"); 
        var form = document.createElement("form");
        form.action = url;
        form.method = verb;
        form.target = target;
        if (data) {
          for (var key in data) {
            var input = document.createElement("input");
            input.id = key;
            input.name = key;
            input.type = "hidden";
            input.value = typeof data[key] === "object" ? JSON.stringify(data[key]) : data[key];
            form.appendChild(input);
          }
        }
        form.style.display = 'none';
        document.body.appendChild(form);
        form.submit();
	}
 	
</script>
	
	
	