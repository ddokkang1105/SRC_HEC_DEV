<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00021" var="WM00021" arguments="Assign "/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<script>

	var type = `${type}`; // role | team
	var s_itemID = `${s_itemID}`; // cmm
	var languageID = `${sessionScope.loginInfo.sessionCurrLangType}`; // cmm
	var elmClassList = `${elmClassList}`; // cmm
	var activityOnly = `${activityOnly}`; // role 에서만 사용
	var attrTypeCode = `${attrTypeCode}`; // role 에서만 사용
	var accMode = `${accMode}`; // team 에서만 사용
	var gridOption = `${grid}`; // role 에서만 사용

	$(document).ready(function(){
		// 초기 표시 화면 크기 조정
		$("#layout").attr("style","height:"+(setWindowHeight() - 200)+"px; width:100%;");

		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 200)+"px; width:100%;");
		};
		
      	LoadAllRnRData();
		window.parent.closeMaskLayer();
	});
	 
	function setWindowHeight(){
      var size = window.innerHeight;
      var height = 0;
      if( size == null || size == undefined){
         height = document.body.clientHeight;
      }else{
         height=window.innerHeight;
      }return height;
	}
	 
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var pagination;
	
	// 기본 grid columns
	var columns = [
		{ width: 200, id: "value",  header: [{ text: "${menu.LN00028}" , align:"center"}, { content: "inputFilter"}], htmlEnable: true,
			template: function (text, row, col){
				let rs = '';
				if(row.ItemID == s_itemID) rs += "<img src=/cmm/common/images/item/img_process.png>";
				rs += "<span onclick=fnOpenItemPop('"+row.ItemID+"')><span class='identifier'>"+(row.Identifier ?? '')+"</span> "+row.TREE_NM+"</span>";
				
				return rs; 
			}},
		{ width: 100, id: "assign", header: [{ text: "" , align:"center"}], htmlEnable: true, align: "center",
        	template: function (text, row, col) {
        		let result = '<img src="${root}${HTML_IMG_DIR}/item/icon_link.png" width="7" height="11" onclick="assignProcess('+row.ItemID+')">';
        		return result;
            }
		},
		{  hidden: true, width: 100, id: "parent",  type: "string",  header: [{ text: "PREE TREE ID"}] },
		{  hidden: true, width: 100, id: "id", type: "string",  header: [{ text: "TREE ID" }] },
		{  hidden: true, width: 100, id: "ItemID",  type: "string",  header: [{ text: "ItemID"}] },
	];
	
	// excel grid columns
	var EXcolumns = [
		{ width: 200, id: "Identifier",  header: [{ text: "ID" , align:"center"}],
			template: function (text, row, col){
				return row.Identifier + row.TREE_NM;
		}},
		{  width: 100, id: "TREE_NM",  type: "string",  header: [{ text: "${menu.LN00028}"}] },
	];
	
	// 기본 grid header setting
	const baseSettings = {
            width: 200, 
            type: "string", 
            align: "center", 
            tooltipTemplate: rowDataTemplate, 
        };
	
	// tooltipTemplate
	function rowDataTemplate(value, row, col) {		
		var desccol = col.id.replaceAll('T','D');
		 if (!value) {
	        return;
	    }else{
	    	if(row[String(desccol)] == undefined){return;}
	    	var roleDesc = row[String(desccol)].replaceAll("&lt;","<").replaceAll("&gt;",">");
	    	return roleDesc;
	    }
	}
	
	// 기본 grid 출력 템플릿
    const columnTemplateFunction = function (text, row, col) {
    	if (text) {
    		
    		let result = '';
    		
    		if(gridOption == "Y") result += '<span onclick=\'editPopup(' + row[col.id + '_CxnItemID'] + ',' + JSON.stringify(row[col.id]) + ')\' style=\'cursor:pointer;\'>' + text;
    		else result += '<span>' + text;
    		
    	    if (row[col.id + '_Attr']) {
    	        result += '(' + row[col.id + '_Attr'] + ')';
    	    }

    	    result += '</span><img class=\'mgL8 none\' name=\'del-btn\' src=\'/cmm/common/images/btn_file_del.png\' style=\'width:12px; cursor:pointer;\' onclick=\'delConnection(' + col.id + ', ' + row.ItemID + ')\'>';

    	    return result;
    	}
    };
    
    // header setting
	function generateGirdColumns(data){
		
		const checkNull = (value) => value == null || value === 'null' ? '' : String(value);
		
		let columns = []; // 일반 헤더
	    let columnsEx = []; // 엑셀 헤더
	    let cols = "";
	    let cxnCols = "";
	    let attrCols = "";
	    
	    // by Role
	    if(type == "role"){
		    for (let i = 0; i < data.length; i++) {
		        const roleItemInfo = data[i];
		        
		        const roleItemID = checkNull(roleItemInfo.RoleItemID);
		        const roleItemNM = checkNull(roleItemInfo.RoleItemNM);
				
		        // 일반
		        const columnObject = {
		            ...baseSettings, 
		            id: roleItemID, 
		            htmlEnable: true,
		            header: [{
		            	text: '<span onClick="fnOpenItemPop(\'' + roleItemID + '\')">' + roleItemNM + '<img class="mgL3 mgR10" src="/cmm/common/images/detail.png" id="popup" style="width:12px; cursor:pointer;" alt="새창열기"></span>', 
		                align: "center"
		            }], 
		            template: columnTemplateFunction // 공통 함수 사용
		        };
	
		        columns.push(columnObject); // 일반 header
		        
		     	// excel
		        const columnEXObject = {
		            ...baseSettings, 
		            id: roleItemID, 
		            htmlEnable: true,
		            header: [{
		            	text: roleItemNM, 
		                align: "center"
		            }]
		        };
	
		        columnsEx.push(columnEXObject); // 일반 header
		        
		        cols += "|" + roleItemID;
		        cxnCols += "|" + roleItemID + "_CxnItemID";
		        attrCols += "|" + roleItemID + "_Attr";
		    }
	    }
		// by Team
		else {
		    for (let i = 0; i < data.length; i++) {
		        const TeamInfo = data[i];
		        
		        const TeamID = checkNull(TeamInfo.TeamID);
		        const TeamNM = checkNull(TeamInfo.TeamNM);
		        const RoleDesc = checkNull(TeamInfo.RoleDesc);
				
		        // 일반
		        const columnObject = {
		            ...baseSettings, 
		            id: 'T' + TeamID, 
		            htmlEnable: true,
		            header: [{
		            	text: '<span onClick="fnOpenTeamPop(\'' + TeamID + '\')">' + TeamNM + '<img class="mgL3 mgR10" src="/cmm/common/images/detail.png" id="popup" style="width:12px; cursor:pointer;" alt="새창열기"></span>', 
		                align: "center"
		            },{ content: "selectFilter" }]
		        };
				
	            const descColumn = {
	            	...baseSettings, 
	                hidden: true,
	                id: 'D' + TeamID,
	                header: [{
	                    text: RoleDesc,
	                    align: "center"
	                }],
	                htmlEnable: true
	            };
	
		        columns.push(columnObject);
		        columns.push(descColumn); 
		        
		     	// excel
		        const columnEXObject = {
		            ...baseSettings, 
		            id: 'T' + TeamID, 
		            htmlEnable: true,
		            header: [{
		            	text: TeamNM, 
		                align: "center"
		            }]
		        };
		        columnsEx.push(columnEXObject);
		        
		        cols += "|" + "T" + TeamID + "|" + "D" + TeamID;
		    }
	    }

	    return {
	        columns: columns, 
	        columnsEx : columnsEx,
	        cols: cols,
	        cxnCols: cxnCols,
	        attrCols: attrCols
	    };
		
	}
	
	var grid = new dhx.Grid("grid",  {
		adjust: true,
		selection: "row",
		resizable: true
		//autoWidth: true
	});
	
	var excelRnRGrid = new dhx.Grid("grid",  {
		adjust: true,
		selection: "row",
		resizable: true
		//autoWidth: true
	});
	
	async function LoadAllRnRData() {
		
	    const promiseAllResults = await Promise.allSettled([
	    	LoadRnRHeaderList(),
	    	LoadRnRGrid()
	    ]);


	    const rnrHeaderResult = promiseAllResults[0].status === 'fulfilled' 
	        ? promiseAllResults[0].value 
	        : []; 
	    
	    const rnrSubItemList = promiseAllResults[1].status === 'fulfilled' 
	        ? promiseAllResults[1].value 
	        : [];

	    if (promiseAllResults[0].status === 'rejected') console.error("rnr 헤더 로딩 에러:", promiseAllResults[0].reason);
	    if (promiseAllResults[1].status === 'rejected') console.error("rnr 서브 리스트 로딩 에러:", promiseAllResults[1].reason);
		
	    // header setting
	    const dynamicColumns = rnrHeaderResult ? rnrHeaderResult.columns : null;
	    if (dynamicColumns && Array.isArray(dynamicColumns)) {
	        const updatedColumns = [...columns, ...dynamicColumns]; 
	        
	        layout.getCell("a").attach(grid);
	        
	        grid.setColumns(updatedColumns);
	        grid.hideColumn("assign");
	    	layout.getCell("a").attach(grid);
	    }
	    
	    // excel header setting
	    const dynamicEXColumns = rnrHeaderResult ? rnrHeaderResult.columnsEx : null;
	    if (dynamicEXColumns && Array.isArray(dynamicEXColumns)) {
	        const updatedEXColumns = [...EXcolumns, ...dynamicEXColumns]; 
	    	excelRnRGrid.setColumns(updatedEXColumns);
	    }
	    
	    // grid setting
	    if (rnrSubItemList && Array.isArray(rnrSubItemList)) {
	        grid.data.parse(rnrSubItemList.filter(e => e.ItemID != "${s_itemID}"));
	        // excel grid
	        excelRnRGrid.data.parse(rnrSubItemList);
	        
	        
	        // 명칭 컬럼 값 사이즈 조절
            const vCol = grid.config.columns.find(c => c.id === "value");
            if (vCol) {
                vCol.width = 300;
                vCol.$width = 300;
                vCol.$fixedWidth = true;
            }
            grid.adjustColumnWidth(); 
            grid.paint();
	        
	        
	    } else {
	        console.error("Grid Sub Item List is invalid or not an array. Reloading with empty data.");
	        fnReloadRnRGrid([], []);
	    }
	}
	
	async function LoadRnRHeaderList(){
		// RnR Header 출력
		const requestData = { s_itemID, languageID, elmClassList, activityOnly, accMode };
	    const params = new URLSearchParams(requestData).toString();
	    
	    // url setting
	    let url = 'getRnRHeaderByTeamList.do?';
	    if(type == 'role') url = "getRnRHeaderByRoleList.do?";
	    url += params;
		
	    // start
	    const response = await fetch(url, { method: 'GET' });

	    if (!response.ok) {
	    	// 서버와 연결은 됐으나 서버 자체가 오류를 반환한 경우 => 치명적 오류이므로 상위함수의 catch에서 잡을 수 있도록 error throwing
	        throw new Error(`HTTP error! status: ${response.status}`);
	    }

	    const data = await response.json();

	    if (data && data.data) {
	        return generateGirdColumns(data.data);
	    } else {
	        // 데이터가 유효하지 않을 경우엔 경고와 함께 빈 배열 반환
	        console.warn("ConnectedProcessReload: No data found inside response");
	        return []; 
	    }
	}
	
	async function LoadRnRGrid(){
		
		
		// RnR sub List 출력
		const requestData = { s_itemID, languageID, elmClassList, activityOnly, attrTypeCode, accMode };
	    const params = new URLSearchParams(requestData).toString();
	    
	 	// url setting
	    let url = 'getRnrMatrixByTeamSubDataList.do?';
	    if(type == 'role') url = "getRnrMatrixByRoleSubDataList.do?";
	    url += params;

	    const response = await fetch(url, { method: 'GET' });

	    if (!response.ok) {
	    	// 서버와 연결은 됐으나 서버 자체가 오류를 반환한 경우 => 치명적 오류이므로 상위함수의 catch에서 잡을 수 있도록 error throwing
	        throw new Error(`HTTP error! status: ${response.status}`);
	    }

	    const data = await response.json();

	    if (data && data.data) {
	    	
	    	if(type == 'team') return generateTeamRoleList(data.data);
	    	else return data.data;
	    	
	    } else {
	        // 데이터가 유효하지 않을 경우엔 경고와 함께 빈 배열 반환
	        console.warn("ConnectedProcessReload: No data found inside response");
	        return []; 
	    }
		
	}
	
	
	function generateTeamRoleList(data){
		
		const result = data.tree.map(item => {
			
		    const treeInfo = data.info.filter(infoItem => infoItem.ItemID === item.ItemID);

		    const teamRoles = {};
		    const teamRoleDesc = {};
		    treeInfo.forEach(infoItem => {
		        const key = "T" + infoItem.TeamID;
		        teamRoles[key] = infoItem.TeamRoleTypeNm;
		        
		        const key2 = "D" + infoItem.TeamID;
		        teamRoleDesc[key2] = infoItem.RoleDescription;
		    });

		    return {
		        ...item,
		        ...teamRoles,
		        ...teamRoleDesc
		    };
		});
		
		return result;
		
	}
	
	function fnOpenItemPop(itemID){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop";
		var w = 1200;
		var h = 900; 
		itmInfoPopup(url,w,h,itemID);
	}
	
	function fnOpenTeamPop(teamID){		
		var w = "1200";
		var h = "800";
		var url = "orgMainInfo.do?id="+teamID;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	let activityItemID = "";
	function assignActivate() {
		grid.showColumn("assign");
		
		// 삭제 버튼 활성화
		document.getElementsByName("del-btn").forEach(e => e.classList.remove("none"));
		
		// 명칭 컬럼 값 사이즈 조절
        const vCol = grid.config.columns.find(c => c.id === "value");
        if (vCol) {
            vCol.width = 300;
            vCol.$width = 300;
            vCol.$fixedWidth = true;
        }
        grid.adjustColumnWidth(); 
        grid.paint();
	}
	
	// 연관항목 생성
	function assignProcess(itemID){
		activityItemID = itemID;
		var url = "selectCxnItemTypePop.do?s_itemID="+activityItemID+"&varFilter=${varFilter}&cxnTypeList=${cxnTypeList}&screenMode="; 
		var w = 500;
		var h = 300;
		itmInfoPopup(url,w,h);
	}
	
	function fnOpenItemTree(itemTypeCode, searchValue, cxnClassCode){
		$("#cxnTypeCode").val(itemTypeCode);
		$("#cxnClassCode").val(cxnClassCode);
		var url = "itemTypeCodeTreePop.do";
		var data = "ItemTypeCode="+itemTypeCode+"&searchValue="+searchValue
			+"&openMode=assign&s_itemID="+activityItemID;

		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}
	
	function doCallBack(){
		//alert(1);
	}
	
	//After [Assign -> Assign]
	function setCheckedItems(checkedItems){
		var cxnTypeCode = $("#cxnTypeCode").val();
		var cxnClassCode = $("#cxnClassCode").val();
		var url = "createCxnItem.do";
		var data = "s_itemID="+activityItemID+"&cxnTypeCode="+cxnTypeCode+"&items="+checkedItems
					+ "&cxnTypeCodes=${varFilter}"
					+ "&cxnClassCode="+cxnClassCode;
		var target = "blankFrame";
		
		ajaxPage(url, data, target);
		
		$("#cxnTypeCode").val("");
		$("#cxnClassCode").val("");
		$(".popup_div").hide();
		$("#mask").hide();	
	}
	
	//[Assign] 이벤트 후 Reload
	function thisReload(){
		var url = "rnrMatrixByRole.do";
		var target = "actFrame";
		var data = "s_itemID=${s_itemID}&varFilter=${varFilter}&option=${option}"
					+"&filter=${filter}&screenMode=${screenMode}&showTOJ=${showTOJ}"
					+"&frameName=${frameName}&showElement=${showElement}&cxnTypeList=${cxnTypeList}&grid=${gridOption}&activityOnly=${activityOnly}&attrTypeCode=${attrTypeCode}";
		
	 	ajaxPage(url, data, target);
	}
	
	function delConnection(activityItemID, itemID){
		if("${myItem}" == "Y") {
			if(confirm("${CM00004}")){
				var url = "DELCNItems.do";
				var data = "isOrg=Y&s_itemID="+itemID+"&items="+activityItemID;
				var target = "blankFrame";
				ajaxPage(url, data, target);
			}
		}
	}
	
	function urlReload() {
		thisReload();
	}
	
	function editPopup(id,cxnClassName){
		/* grid가 Y인 경우에만 사용 */
		if(gridOption == "Y"){
			$("#items").val(id);
			var url = "editAttrOfItemsPop.do?items="+id+"&attrCode='${attrTypeCode}'";
		    var w = 940;
			var h = 700;
			window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");	
		}
		
	}
	
	function selfClose() {
		thisReload();
	}
	
</script>

<style>
  	body {
      margin: 0;
    }

    .custom-tooltip {
        display: flex;
    }
    
    .custom-tooltip > *:last-child {
        margin-left: 12px;
    }
    
    .custom-tooltip img {
        width: 62px;
        height: 62px;
    }

</style>

<body>
	<div class="countList">
		<ul>
	        <li class="floatR">
	        	<c:if test="${myItem == 'Y' && type == 'role' }">
		        	<span class="btn_pack nobg" alt="Assign" title="Assign"  style="cursor:pointer;_cursor:hand"><a onclick="assignActivate();"class="assign" ></a></span>
		        </c:if>
			    <span class="btn_pack nobg white"><a class="xls" OnClick="fnGridExcelDownLoad(excelRnRGrid);" title="Excel" id="excel"></a></span>
	       </li>
       </ul>
  	</div>   
   
	<div style="width: 100%;" id="layout"></div>
	<form name="cxnItemTreeFrm" id="cxnItemTreeFrm" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="cxnTypeCode" name="cxnTypeCode" >
		<input type="hidden" id="cxnClassCode" name="cxnClassCode" >
	</form>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</body>