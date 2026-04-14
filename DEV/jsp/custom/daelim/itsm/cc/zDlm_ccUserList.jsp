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
	<form name="CCUserList" id="CCUserList" action="*" method="post" onsubmit="return false;">
		<div class="cfgtitle" >				
			<ul>
				<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;CC USER STS</li>
			</ul>
		</div>
		<div class="floatR pdR10 mgB7">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<span id="backBtn" class="btn_pack nobg white"><a class="clear" onclick="fnBack()" title="Back"></a></span>
				<button class="cmm-btn mgR5" style="height: 30px;" id ="add" onclick="AddCCUser()" type = "hidden">Add</button>
				<button class="cmm-btn mgR5" style="height: 30px;" id ="saveAllBtn" onclick="fnSaveAll()" type = "hidden">Save All</button>
				<button class="cmm-btn mgR5" style="height: 30px;" id = "editBtn" onclick="fnEdit()">Edit</button>
				<button class="cmm-btn mgR5" style="height: 30px;" onclick="DeleteCCUser()" value="Del">Delete</button>
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
		var grid = new dhx.Grid("grdGridArea", {
			columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
				{ width: 140, id: "CNAME", header: [{ text: "이름" , align: "center" }], align: "center" },
				{ width: 200, id: "CEMPNO", header: [{ text: "사번", align: "center" }], align: "center" },
				{ width: 200, id: "STSNAME", header: [{ text: "상태", align: "center" }], align: "center" },
				{ width: 200, id: "TELNUM", header: [{ text: "내선번호", align: "center" }] , align: "center", editorType: "number"},
				{ width: 80, id: "USEYN", header: [{ text: "사용유무", align: "center" }] , align: "center", editorType: "combobox", options: ['Y', 'N']},		
				{ width: 80, id: "ISMANAGER", header: [{ text: "isManager", align: "center" }],align: "center", type: "boolean", editable: true, editorType: "checkbox"},							
				{ width: 200, id: "MEMBERID", header: [{ text: "memberId", align: "center" }] , align: "center",hidden:true},
				{ width: 200, id: "STSCD", header: [{ text: "상태코드", align: "center" }] , align: "center",hidden:true}
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data: gridData
		});
		layout.getCell("a").attach(grid);

		

		function fnEdit() {	
			$('#editBtn').hide();
			$('#saveAllBtn').show();
			$('#backBtn').show();
			grid.getColumn("TELNUM").editable = true;
			grid.getColumn("USEYN").editable = true;  
			grid.getColumn("ISMANAGER").editable = true;
			
			isEditing = true;
		}
		
		let searchCheck = false; // doSearchList 실행시 true
		let sharedValue = null;	 // 클릭 했을 때 값
		let isEditing = false;   // 편집 모드 여부 
		
		grid.events.on("cellClick", function(row, column, e) {
			sharedValue = { row, column, e };
		    // 클릭된 엘리먼트가 체크박스 엘리먼트인 경우에만 반응
	 	    if ($(e.target).hasClass("dhx_checkbox__input")) {
	 	    	sharedValue = { row, column, e };
		    } 
		});		
		
		// ISMANAGER 컬럼이 변경될 때		
		grid.events.on("change", function () {
		    if (!searchCheck) { 
		        let { row, column, e } = sharedValue;
			        if (column.id == "ISMANAGER") {
			            if (isEditing == false) {
			                alert("[EDIT] 버튼을 눌러서 수정하십시오."); 
			                if(row.ISMANAGER ==''){
				        		row.ISMANAGER = 1;
				        	}else{
				        		row.ISMANAGER = 0;
				        	}
				        	return false;
			            }

			            if (isEditing == true) {
			                if (row.ISMANAGER == 0) {
			                    fnUnselectAllIsManager();
			                }
			                if (row.ISMANAGER == 1) {
			                    fnUnselectAllIsManager();
			                    row.ISMANAGER = 1;
			                }
			            }
		       		}
		    	}
		});

		
		function fnUnselectAllIsManager() {
		    grid.data.forEach(function (row) {
		    	row.ISMANAGER=false;
		    });
		}

		
		function fnBack() {	
			$('#editBtn').show();
			$('#saveAllBtn').hide();
			$('#backBtn').hide();
			doOTSearchList();		
		}
	// END ::: GRID	
	//===============================================================================

	//조회
	function doOTSearchList(){
		var sqlID = "zDLM_SQL.getCCUserSTS";
		var param = "&languageID=${languageID}"
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
		searchCheck = true;
 		grid.data.parse(newGridData);
 		searchCheck = false;
 		isEditing = false;
		grid.getColumn("TELNUM").editable = false;  
		grid.getColumn("USEYN").editable = false;  
		
	    grid.data.forEach(function(item) {
	        let isManagerValue = String(item.ISMANAGER).trim(); 
	        if (isManagerValue === '1' || isManagerValue === true ) {
	            item.ISMANAGER = true;  
	        } else {
	            item.ISMANAGER = false; 
	        }
	    });
 	}
		
	function AddCCUser(){	
		var url = "addCCUser.do";
		var data = "&TypeCode=${s_itemID}" + 
				   "&languageID=${languageID}";
		url += "?" + data;
		var option = "width=520,height=450,left=600,top=100,toolbar=no,status=no,resizable=yes";
	    window.open(url, self, option);
	}

	
	function DeleteCCUser(){		
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){
			alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
		}else{
			if (confirm("${CM00004}")) {
				for (idx in selectedCell) {
					var url = "DeleteCCUser.do";
					var data = "&memberId=" + selectedCell[idx].MEMBERID 
							  +"&statusCD=" + selectedCell[idx].STSCD ;
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
	
	
	function fnSaveAll(){
		var selectedData = grid.data.findAll(function (data) {
			return {
				isManager: data.ISMANAGER,
				memberId: data.MEMBERID,
				useYN: data.USEYN,
				TelNum: data.TELNUM
			};
		});
	    
		var memberIds = "";
		var useYNList = "";
		var isManagerList = "";
		var TelNums = "";
		
		for(var i=0;i<selectedData.length;i++){
			if(selectedData[i].ISMANAGER == true){
				selectedData[i].ISMANAGER = 1;
			}else {
				selectedData[i].ISMANAGER = 0;
			}
			
			if (i > 0) {
				memberIds += ",";
				useYNList += ",";
				isManagerList += ",";
				TelNums += ",";
			}
			isManagerList += selectedData[i].ISMANAGER;
			memberIds += selectedData[i].MEMBERID;
			useYNList += selectedData[i].USEYN;
			TelNums += selectedData[i].TELNUM
		}
		var url = "updateAllCCUser.do?memberIds="+memberIds+"&useYNList="+useYNList+"&isManagerList="+isManagerList+"&TelNums="+TelNums;
		ajaxSubmit(document.CCUserList, url,"ArcFrame");
	}
		
	function fnCallBack(){
		doOTSearchList();
		$('#editBtn').show();
		$('#saveAllBtn').hide();
		$('#backBtn').hide();	
	}


	
	</script>
</html>