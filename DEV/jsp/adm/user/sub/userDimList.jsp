	<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
	<c:url value="/" var="root"/>
	<!-- 관리자 : 사용자 -My Dimension 관리 -->
	
	<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
	<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">


	<!-- 화면 표시 메세지 취득  -->
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
	
	<script type="text/javascript">

		$(document).ready(function() {	
			// SKON CSRF 보안 조치
			$.ajaxSetup({
				headers: {
					'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
					}
			})			
			
			if("${scrnType}" == "mySpace"){
				$("#layout").innerHeight(document.body.clientHeight - 560);
				$("#layout2").attr("style","width:100%;height:"+(document.body.clientHeight - 540)+"px;");
				$("#layout3").attr("style","width:100%;height:"+(document.body.clientHeight - 540)+"px;");
				window.onresize = function() {
					$("#layout").innerHeight(document.body.clientHeight - 560);
					$("#layout2").attr("style","width:100%;height:"+(document.body.clientHeight - 540)+"px;");
					$("#layout3").attr("style","width:100%;height:"+(document.body.clientHeight - 540)+"px;");
				};
			} else {
				$("#layout").innerHeight(document.body.clientHeight - 540);
				$("#layout2").attr("style","width:100%;height:"+(document.body.clientHeight - 500)+"px;");
				$("#layout3").attr("style","width:100%;height:"+(document.body.clientHeight - 500)+"px;");
				window.onresize = function() {
					$("#layout").innerHeight(document.body.clientHeight - 540);
					$("#layout2").attr("style","width:100%;height:"+(document.body.clientHeight - 500)+"px;");
					$("#layout3").attr("style","width:100%;height:"+(document.body.clientHeight - 500)+"px;");
				};
			}

			doSearchList();
			$("#myDimTabs").attr('style', 'display: none');
		});	
		
		//===============================================================================
		// BEGIN ::: GRID1
		var layout = new dhx.Layout("layout", { 
			rows: [	
				{
					id: "a",
				},
			]
		});

		var gridData = ${gridData};
		var grid = new dhx.Grid(null, {
			columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center"},
				{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
				{ width: 150, id: "DimTypeName", header: [{ text: "${menu.LN00088}" , align: "center" }], align: "center"},
				{ width: 100, id: "DimValueID", header: [{ text: "${menu.LN00015}" , align: "center" }], align: "center"},
				{ width: 200, id: "DimValueName", header: [{ text: "Value" , align: "center" }], align: "center"},
				{ hidden: true, width: 60, id: "DimTypeID", header: [{ text: "DimTypeID" , align: "center" }], align: "center"},
				{ width: 100, id: "IsDefault", header: [{ text: "Set Default" , align: "center" }], align: "center", type: "boolean", editable: true, sortable: false}
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data:gridData
		});
		layout.getCell("a").attach(grid);

		function setDefaultCheckbox() {  
			for (let i = 0; i < grid.data.getLength(); i++) {
				var rowId = grid.data.getId(i);
        		var rowData = grid.data.getItem(rowId);

				if (rowData) {
					if(rowData.IsDefault == true || rowData.IsDefault == 1 ){
						grid.data.update(rowId, { IsDefault: true });
					} else {
						grid.data.update(rowId, { IsDefault: false });
					}
				}
			}
		}

		//조회1
		function doSearchList(){
			var sqlID = "user_SQL.userDimList";
			var param =  "memberID=${memberID}&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&Category=${Category}" 
						+ "&dimTypeId=" + $("#dimTypeId").val()
						+ "&sqlID="+sqlID;
			$.ajax({
				url:"jsonDhtmlxListV7.do",
				type:"POST",
				data:param,
				success: function(result){
					fnReloadGrid1(result);		
				},error:function(xhr,status,error){
					console.log("ERR :["+xhr.status+"]"+error);
				}
			});	
		}	
		function fnReloadGrid1(newGridData){
			grid.data.parse(newGridData);
			setDefaultCheckbox();
			fnMasterChk('');
		}


		//그리드1 ROW선택시 
		grid.events.on("cellClick", function(row,column,e){
			if(column.id != "checkbox" && column.id !== "IsDefault"){
				gridOnRowSelect(row);
			}
			if (column.id === "IsDefault") {
				gridOnCheckEvent(row);
			}
		}); 

		function gridOnCheckEvent(row){
			var chekedDefaultCell = grid.data.findAll(function (data) {
				return data.IsDefault; 
			});
			var dimTypeID = row.DimTypeID;
			
			for(var i = 0 ; i < chekedDefaultCell.length; i++ ){
				var chkValue = chekedDefaultCell[i].DimTypeID;
				if(dimTypeID == chkValue){
					chekedDefaultCell[i].IsDefault = false;
					row.IsDefault = true; 
				}
			}
		}
		
		//그리드1 ROW선택시 
		function gridOnRowSelect(row){
			var dimTypeId = row.DimTypeID;
			var dimValueId = row.DimValueID;
		
			doSetGrid2(dimValueId,dimTypeId);
			$("#sDimValue").val(dimValueId);
			$("#sDimType").val(dimTypeId);
			selectitemType();
			
			$("#myDimTabs").attr('style', 'display: block');
			myDimRole();
			myDimItem();
		}
		
		// END ::: GRID1
		//===============================================================================
		
		//===============================================================================
		// BEGIN ::: GRID2

		var layout2 = new dhx.Layout("layout2", { 
			rows: [    
				{
					id: "b",
				},
			]
		});

		var grid2Data = ${grid2Data};
		var grid2 = new dhx.Grid(null, {
			columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center"},
				{ width: 30, id: "Check", header: [{ text: "<input type='checkbox' onclick='fnCheckBox(checked)'></input>" }], align: "center", type: "boolean",  editable: true, sortable: false},
				{ width: 50, id: "ItemTypeImg", header: [{ text: "${menu.LN00042}" , align: "center" }], align: "center",editable: false, htmlEnable: true,	
						template: function (text, row, col) {
							return '<img src="${root}${HTML_IMG_DIR}/item/'+row.ItemTypeImg+'" width="18" height="18">';
				}},
				{ width: 70, id: "Identifier", header: [{ text: "${menu.LN00015}" , align: "center" }, { content: "inputFilter" }], align: "center"},
				{ width: 150, id: "ItemName", header: [{ text: "${menu.LN00028}" , align: "center" },{ content: "inputFilter" }], align: "center"},
				{ fillspace: true, id: "Path", header: [{ text: "${menu.LN00043}" , align: "center" },{ content: "inputFilter" }], align: "center"},
				{ width: 90, id: "ClassName", header: [{ text: "${menu.LN00016}" , align: "center" },{ content: "selectFilter" }], align: "center"},
				{ width: 80, id: "TeamName", header: [{ text: "${menu.LN00014}" , align: "center" },{ content: "selectFilter" }], align: "center"},
				{ width: 80, id: "OwnerTeamName", header: [{ text: "${menu.LN00018}" , align: "center" },{ content: "selectFilter" }], align: "center"},
				{ width: 80, id: "Name", header: [{ text: "${menu.LN00004}" , align: "center" },{ content: "inputFilter" }], align: "center"},
				{ hidden: true, width: 80, id: "LastUpdated", header: [{ text: "${menu.LN00013}" , align: "center" },{ content: "inputFilter" }], align: "center"},		
				{ hidden: true, width: 50, id: "Version", header: [{ text: "${menu.LN00017}" , align: "center" },{ content: "inputFilter" }], align: "center"},		
				{ hidden: true, width: 0, id: "ID", header: [{ text: "ItemID" , align: "center" },{ content: "inputFilter" }], align: "center"},		
				{ hidden: true, width: 0, id: "SCOUNT", header: [{ text: "SCOUNT" , align: "center" },{ content: "inputFilter" }], align: "center"},				
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data:grid2Data
		});

		layout2.getCell("b").attach(grid2);
		$("#TOT_CNT").html(grid2.data.getLength());

		var pagination = new dhx.Pagination("pagination", {
			data: grid2.data,
			pageSize: 50,
		});	


		//조회2
		function doSearchList2(avg,avg2){
			var sqlID = "dim_SQL.selectDimPertinentDetailList";
			var param = "dimTypeID="+avg2+"&s_itemID="+avg+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}&ItemClassCode="+$("#newClassCode").val()
						+"&searchValue="+$("#searchValue").val()
						+ "&sqlID="+sqlID;
			$.ajax({
				url:"jsonDhtmlxListV7.do",
				type:"POST",
				data:param,
				success: function(result){
					fnReloadGrid2(result);		
				},error:function(xhr,status,error){
					console.log("ERR :["+xhr.status+"]"+error);
				}
			});	
		}	
		function fnReloadGrid2(newGridData){
			grid2.data.parse(newGridData);
			$("#TOT_CNT").html(grid2.data.getLength());
			fnCheckBox('');
		}

		//그리드2 ROW선택시
		grid2.events.on("cellClick", function(row,column,e){
			if(column.id != "Check"){
				gridOnRowSelect2(row);
			}
		}); 
		
		function gridOnRowSelect2(row){
			var avg1 = row.ID;
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";
			var w = 1200;
			var h = 900;
			itmInfoPopup(url,w,h,avg1);
		}
		// END ::: GRID2
		//===============================================================================

		//===============================================================================
		// BEGIN ::: GRID3

		var layout3 = new dhx.Layout("layout3", { 
			rows: [    
				{
					id: "c",
				},
			]
		});

		var grid3Data = ${grid3Data}; 
		var grid3 = new dhx.Grid(null, {
			columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center"},
				{ hidden: true, width: 50, id: "CHK", header: [{ text: "" }], align: "center", type: "boolean",  editable: true, sortable: false},
				{ width: 100, id: "Name", header: [{ text: "${menu.LN00004}" , align: "center" }, { content: "inputFilter" }], align: "center"},
				{ width: 500, id: "Path", header: [{ text: "${menu.LN00247}" , align: "center" }, { content: "inputFilter" }], align: "center"},
				{ width: 150, id: "CreationTime", header: [{ text: "${menu.LN00078}" , align: "center" },{ content: "inputFilter" }], align: "center"},
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data:grid3Data
		});

		layout3.getCell("c").attach(grid3);

		//조회3 
		function doSearchList3(avg,avg2){
			var sqlID = "user_SQL.getMyDimRoleList";
			var param = "dimTypeID="+avg2+"&dimValueId="+avg+"&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&sqlID="+sqlID;
			$.ajax({
				url:"jsonDhtmlxListV7.do",
				type:"POST",
				data:param,
				success: function(result){
					fnReloadGrid3(result);		
				},error:function(xhr,status,error){
					console.log("ERR :["+xhr.status+"]"+error);
				}
			});	
		}	
		function fnReloadGrid3(newGridData){
			grid3.data.parse(newGridData);
		}

		// END ::: GRID3
		//===============================================================================

		function fnCheckBox(state) {
			event.stopPropagation();
			grid2.data.forEach(function (row) {
				grid2.data.update(row.id, {"Check": state})
			})
		}
	
		function myDimItem(){
			$("#myDimItem").addClass("on");
			$("#myDimRole").removeClass("on");
			$("#myDimRoleGrid").attr('style', 'display: none');
			$("#myDimItemGrid").attr('style', 'display:block;');
		}
		
		function myDimRole(){
			$("#myDimItem").removeClass("on");
			$("#myDimRole").addClass("on");
			$("#myDimRoleGrid").attr('style', 'display:block; height:200px;');
			$("#myDimItemGrid").attr('style', 'display:none;');
			
		}
		
		// [Assign] click 이벤트	
		function assignOrg(){
			var url = "myDimAssignTreePop.do";
			var data = "memberID=${memberID}";
			fnOpenLayerPopup(url,data,doCallBack,617,436);
		}

		function doCallBack(){}
		
		// [Assign popup] Close 이벤트
		function assignClose(){
			doSearchList();
		}
		
		function saveDimension(){
			var selectedData = grid.data.findAll(function (data) {
				if(data.IsDefault === true || data.IsDefault === 1){
					data.IsDefault = 1
				}else{data.IsDefault = 0};
				return {
					isDeaultIds: data.IsDefault,
					dimTypeIds: data.DimTypeID,
					dimValueIds: data.DimValueID
				};
			});
			var isDeaultIds = "";
			var dimValueIds =""; 
			var dimTypeIds =""; 

			for(var i=0;i<selectedData.length;i++){
				if (dimTypeIds == "") {
					isDeaultIds = selectedData[i].IsDefault;
					dimTypeIds = selectedData[i].DimTypeID;
					dimValueIds = selectedData[i].DimValueID;
				} else {
					isDeaultIds = isDeaultIds + "," + selectedData[i].IsDefault;
					dimTypeIds = dimTypeIds + "," + selectedData[i].DimTypeID;
					dimValueIds = dimValueIds + "," + selectedData[i].DimValueID;
				}
			}

			var url = "admin/saveDimensionForUser.do";
			var data = "memberID=${memberID}&isDeaultIds="+isDeaultIds+"&dimTypeIds="+dimTypeIds+"&dimValueIds=" + dimValueIds;
			var target = "blankFrame";
			ajaxPage(url, data, target);
		}
		
		// [Del] Click
		function delDimension() {
			var selectedCell = grid.data.findAll(function (data) {
				return data.checkbox; 
			});
			if(!selectedCell.length){ //배열의 길이가 0   => !FALSE == TRUE
				alert("${WM00023}");	
			}else{
				if(confirm("${CM00004}")){
					var dimValueIds =""; 
					var dimTypeIds =""; 
					for(idx in selectedCell){
						if (dimTypeIds == "") {
							dimTypeIds = selectedCell[idx].DimTypeID;
							dimValueIds = selectedCell[idx].DimValueID;
						} else {
							dimTypeIds = dimTypeIds + "," + selectedCell[idx].DimTypeID;
							dimValueIds = dimValueIds + "," + selectedCell[idx].DimValueID;
						}
					}
					
					var url = "admin/delDimensionForUser.do";
					var data = "memberID=${memberID}&dimTypeIds="+dimTypeIds+"&dimValueIds=" + dimValueIds;
					var target = "blankFrame";
					ajaxPage(url, data, target);			
				}
			}	
		}
		
		
		function doSetGrid2(avg,avg2){
			addDim(2);
			doSearchList2(avg,avg2);
			doSearchList3(avg,avg2);
		}	

		function addDim(avg){
			if(avg == '1'){
			$("#addNewItem").removeAttr('style', 'display: none');   
			$("#gridDiv2").attr('style', 'display: none');
			$("#valueInsert").attr('style', 'display: none');   
			$("#newSearch").attr('style', 'display: none');
			$("#dimValueName").val("");
			$("#dimValueID").val("");
			$("#dimValueID").attr('disabled', '');
			$("#BeforeDimValueID").val("");
			$("#saveType").val("New");
			$("#dimDeleted").attr("checked", false);   
			}else{
				$("#addNewItem").attr('style', 'display: none');   
				$("#gridDiv2").removeAttr('style', 'display: none');
				$("#valueInsert").removeAttr('style', 'display: none');   
				$("#newSearch").attr('style', 'display: none');
			}if(avg == '3'){
				// Edit 버튼 클릭 이벤트
				$("#gridDiv2").attr('style', 'display: none');
				$("#valueInsert").attr('style', 'display: none');
				$("#dimValueID").attr('disabled', 'disabled'); // dimValueID 수정불가
				$("#newSearch").attr('style', 'display: none');
				

				var selectedCell = grid.data.findAll(function (data) {
					return data.checkbox; 
				});
				if(!selectedCell.length){ 
					alert("${WM00042}");
				} else {
					$("#addNewItem").removeAttr('style', 'display: none'); 
					$("#dimValueName").val(selectedCell[0].DimValueName);
					$("#dimValueID").val(selectedCell[0].DimValueID);
					$("#BeforeDimValueID").val(selectedCell[0].DimValueID);
					
					if(selectedCell[0].DimTypeID == '1'){ 
						$("#dimDeleted").attr("checked", true);
					}else{
						$("#dimDeleted").attr("checked", false);
					}
					$("#saveType").val("Edit");
				}
			}
		}

		function selectitemType(){
			var url    = "getClassCodeOption.do"; 	 // 요청이 날라가는 주소
			var data   = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&hasDim=1"; //파라미터들
			var target = "newClassCode";             // selectBox id	
			var defaultValue = "";                   // 초기에 세팅되고자 하는 값
			var isAll  = "select";                   // "select" 일 경우 선택, "true" 일 경우 전체로 표시
			ajaxSelect(url, data, target, defaultValue, isAll);
		}
			

		function assignDim2Item(){	
			var sDimValue = $("#sDimValue").val();
			var sDimType = $("#sDimType").val();
			var url = "searchNewDimItemPop.do";
			var data = "dimTypeID="+sDimType+"&dimValueID="+sDimValue;
			fnOpenLayerPopup(url,data,doCallBack,617,436);
		}

		// [Add popup] Close 이벤트
		function addClose(avg){		
			var sDimValue = $("#sDimValue").val();
			var sDimType = $("#sDimType").val();
			doSearchList2(avg,sDimType);
			doSetGrid2(avg,sDimType);
		}


		function delSubDim(){
			var selectedCell2 = grid2.data.findAll(function (data) {
				return data.Check; 
			});
			if(!selectedCell2.length){ 
				alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
			} else {
				if(confirm("${CM00004}")){		//if(confirm("선택된 항목을 삭제 하시겠습니까?"))
					var sDimValue = $("#sDimValue").val();
					var sDimType = $("#sDimType").val();
					var items = "";
						for(idx in selectedCell2){
							if (items == "") {
								items = selectedCell2[idx].ID;
							} else {
								items = items + "," + selectedCell2[idx].ID;
							}				
						}
						
					var url = "admin/DelSubDimension.do";
					var data = "items="+items+"&dimTypeId="+sDimType+"&dimValueId=" + sDimValue;
					var target = "blankFrame";
					ajaxPage(url, data, target);
					grid.data.remove(selectedCell2[idx].id);
				}
			}
		}

		function doCallBack(){}


	</script>
	<input type="hidden" id="sDimValue" value="" />
	<input type="hidden" id="sDimType" value="" />
	<c:if test="${scrnType eq 'mySpace' }">
		<h3 class="pdT10 pdB10" style="border-bottom:1px solid #ccc;  "><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic" />&nbsp;Dimension</h3>
	</c:if>
	<div class="child_search01 pdT10 pdB10">
		<li class="mgL10">
		<select id="dimTypeId" Name="dimTypeId">
			<option value=''>Select</option>
			<c:forEach var="i" items="${dimTypeList}">
				<option value="${i.DimTypeID}">${i.DimTypeName}</option>
				</c:forEach>
		</select> 
		<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchList();" value="검색" style="cursor:pointer;">   
		</li>
		<c:if test="${authLev eq '1' }">
		<li class="floatR pdR20">
			<span class="btn_pack small icon"><span class="assign"></span><input value="Assign" type="submit" onclick="assignOrg()"></span>&nbsp;
			<span class="btn_pack small icon"><span class="save"></span><input value="Save" type="submit" onclick="saveDimension()"></span>&nbsp;
			<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delDimension();"></span>
		</li>
		</c:if>
	</div>
	<!-- BIGIN :: LIST_GRID -->
	<div id="gridDiv">
		<div style="width: 100%;" id="layout"></div> <!--layout1 추가한 부분-->
	</div>
	<!-- END :: LIST_GRID -->

	<div class="SubinfoTabs mgT15" id="myDimTabs">
		<ul>
			<li id="myDimItem"><a href="javascript:myDimItem();"><span>${menu.LN00087}</span></a></li>
			<li id="myDimRole" ><a href="javascript:myDimRole();"><span>${menu.LN00004}</span></a></li>
		</ul>
	</div>

	<div class="mgT10">
		<div id="myDimItemGrid" style="width:100%;">	
			<div id="valueInsert" class="child_search01 mgB10" style="display:none;">
				<li  class="count">Total  <span id="TOT_CNT"></span></li>
				<li class="L">
					&nbsp;${menu.LN00016}
					<select id="newClassCode" name="newClassCode" style="width:150px;" >
						<option value="">select</option>
					</select>	
				</li>
				<li>
					<select id="searchKey" name="searchKey" style="width:150px;">
						<option value="Name">Name</option>
					</select>
					<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;">
					<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="doSearchList2($('#sDimValue').val(),$('#sDimType').val())" value="검색">
				</li>
				<c:if test="${authLev eq '1' }">
				<li class="floatR">	
					&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" id="newButton1"  onclick="assignDim2Item()" ></a></span>&nbsp;
					&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delSubDim()"></span>
				</li>
				</c:if>
			</div>
				<div id="gridDiv2" class="mgB10" style="width:100%; display: none;">
						<div style="width: 100%;" id="layout2"></div> <!--layout2 추가한 부분-->
						<div id="pagination"></div>
				</div>
			</div>
		<div id="myDimRoleGrid" style="width:100%; display: none;">
			<div style="width: 100%;" id="layout3"></div> <!--layout3 추가한 부분-->
		</div>
	</div>

	<!-- START :: FRAME --> 		
	<div class="schContainer" id="schContainer">
		<iframe name="blankFrame" id="blankFrame" src="about:blank" frameborder="0" style="display:none"></iframe>
	</div>	
	<!-- END :: FRAME -->
