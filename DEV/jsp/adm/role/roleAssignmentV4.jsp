<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
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

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<style>
	#emptyDataMessage {
	    text-align: center;
	    padding: 30px 20px;
	    color: #999;
	    font-size: 13px;
	    font-style: italic;
	    border: 1px solid #e0e0e0;
	    background-color: #fafafa;
	}
</style>
<script>
	
	var dhxModal = null;

	// 모든 그리드 데이터 저장할 빈 배열
	var fullGridData = [];
	// 라디오버튼 통해 필터링된 결과 저장할 빈 배열
	var filterdGridData = [];
	// activated 된 애들 따로 저장 (초기 로드 시 무조건 활용되므로 저장해둠)
	var activatedGridData = [];
	
	var grid;

	$(document).ready(function(){	
	
		$("#excel").click(function(){ 
			Promise.all([
				getDicData("ERRTP", "LN0015"), // 엑셀 문서를 생성해 다운받겠습니까?
				getDicData("BTN", "LN0032"), // 확인
				getDicData("BTN", "LN0033")  // 취소
			]).then(results => {
				showDhxConfirm(results[0].LABEL_NM, () => fnGridExcelDownLoad(grid), null, results[1].LABEL_NM, results[2].LABEL_NM);
			});
		} );

		$("#memberName").keypress(function(){
			if(event.keyCode == '13') {
				searchPopupWf('searchPluralNamePop.do?objId=memberID&objName=memberName');
				return false;
			}			
		});	
		fnReload();
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
	
	// =================================================================================================
	// ======== [ 모달 ] ================================================================================
	// =================================================================================================	
		
	var roleDetailModalHtml = `
		<div  id="roleDetail" style="display:block;" class="mgT30">
		<table class="tbl_blue01 mgT30 mgB5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="15%">
			    <col width="35%">
			    <col width="15%">
			 	<col width="15%">
			 	<col width="10%">
			 	<col width="10%">
			</colgroup>		
			<tr>
				<th class="last pdL10">${menu.LN00004}</th>		
				<th class="last pdL10">Type</th>
				<th class="last pdL10">${menu.LN00163}</th>	
				<th class="last pdL10">${menu.LN00149}</th>	
				<th class="last pdL10">${menu.LN00067}</th>	
				<th class="last pdL10">Active</th>	
			</tr>
			<tr>
				<td class="last">
					<input type="text" class="text" id="memberName" name="memberName" style="ime-mode:active;width:80%;" />
					<input type="hidden" class="text" id="memberID" name="memberID" />
					<input type="hidden" class="text" id="seq" name="seq" />
					<input type="image" class="image" id="searchMemberBtn" name="searchMemberBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="searchPopupWf('searchPluralNamePop.do?objId=memberID&objName=memberName&UserLevel=ALL')" value="Search">
					<input type="hidden" class="text" id="itemID" name="itemID" />
					<input type="hidden" class="text" id="mbrTeamID" name="mbrTeamID" />
				</td>
				<td class="last">
					<select id="assignmentType" name="assignmentType" style="width:100%;" OnChange="fnGetRoleType(this.value);"></select>
				</td>
				<td class="last">
					<select id="roleType" name="roleType" style="width:100%;"></select>
				</td>
				<td class="last">
					<select id="accessRight" name="accessRight" style="width:100%;">
						<option value="">Select</option>
						<option value="U">Manage</option>
						<option value="R">Referred</option>

					</select>
				</td>
				<td class="last">
					<input type="text" class="text" id="orderNum" name="orderNum" />
				</td>
				<td class="last">
					<select id="assigned" name="assigned" style="width:100%;">
						<option value="">Select</option>
						<option value="1">Activated</option>
						<option value="0">Deactivated</option>
					</select>
				</td>
			</tr>
			
			<tr>
				<th class="last pdL10">Task</th>				
				<td class="last" colspan=5 align="left">
					<input type="text" class="text" id="memo" name="memo" style="ime-mode:active;width:96%;" />
				</td>			
			</tr>
		</table>
		<div class="pdT5 pdB5 floatR" >
	        <span id="viewSave" class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="fnSaveRoleAss()"></span>&nbsp;
	    </div>   
	    </div> 
	`

	function showAddRoleDhxModal(){
		
		// 모달이 돔에 마운트 된 후 실행시킬 콜백함수
		function showAddRoleModalCallback(){
			
	        $("#memberID").val("");
	        $("#memberName").val("");
	        $("#itemID").val("${s_itemID}");		
	        $("#roleType").val("");
	        $("#assignment").val("");
	        $("#seq").val("");
	        $("#orderNum").val("");
	        $("#assigned").val("");
	        $("#accessRight").val("");
	        $("#path").val("");
	        $("#mbrTeamID").val("");
	        $("#memo").val("");
	        
	        $("#memberName").removeAttr('readOnly');
	        $("#path").attr('readOnly', 'true');
	        $("#roleDetail").attr('style', 'display: done');
	        $("#searchMemberBtn").attr('style','display : done');
	        
	        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&assignmentType=${assignmentType}";
	        fnSelect('assignmentType', data+'&actorType=USER', 'getAssignment', '${assignmentType}', 'Select');
	        fnSelect('roleType', data, 'getOLMRoleType', '', 'Select');
	        if("${assignmentType}" != ""){ 
	            $("#assignmentType").attr('disabled', 'true'); 
	        }  
			$("#memberName").keypress(function(){
				if(event.keyCode == '13') {
					searchPopupWf('searchPluralNamePop.do?objId=memberID&objName=memberName');
					return false;
				}			
			});	
		}
        dhxModal = openHtmlWithDhxModal(roleDetailModalHtml, "${menu.LN00288}" + " " + "${menu.LN00381}", 1200, 300, showAddRoleModalCallback)
	}

	function searchPopupWf(avg){
		var searchValue = $("#memberName").val();
		var url = avg + "&searchValue="+encodeURIComponent(searchValue)
		+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&searchOption=${searchOption}&UserLevel=ALL";
		
		window.open(url,'window','width=340, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function fnGetRoleType(assignmentType){ 
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&assignmentType="+assignmentType;
		fnSelect('roleType', data, 'getOLMRoleType', '', 'Select');
	}
		
	function setSearchNameWf(avg1,avg2,avg3,avg4,avg5,avg6,avg7){
		$("#memberName").val(avg2+"("+avg3+")");
		$("#memberID").val(avg1);
		$("#path").val(avg7);
		$("#mbrTeamID").val(avg4);
	}
	
	function fnRoleCallBack(){
		fnReload();
	    if(dhxModal) {
	    	dhxModal.destructor();  
	    	dhxModal = null;
	    }
	}
	
	function fnSaveRoleAss(){
		
		Promise.all([
			getDicData("ERRTP", "LN0025"), // 저장하시겠습니까?
			getDicData("BTN", "LN0032"), // 확인
			getDicData("BTN", "LN0033")  // 취소
		]).then(results => {
			showDhxConfirm(results[0].LABEL_NM, afterConfirmSaveRoleAss, ()=> {return;}, results[1].LABEL_NM, results[2].LABEL_NM);
		});
	
		function afterConfirmSaveRoleAss () {
			var memberID = $("#memberID").val();
			var itemID = $("#itemID").val();
			var path = $("#path").val();
			var roleType = $("#roleType").val();
			var assignmentType = $("#assignmentType").val();
			var assigned = $("#assigned").val();
			var orderNum = $("#orderNum").val();
			var seq = $("#seq").val();
			var accessRight = $("#accessRight").val();
			var memo = $("#memo").val();
			var mbrTeamID = $("#mbrTeamID").val();
			
			var url = "saveRoleAssignment.do";
			var target = "saveRoleFrame";		
			var data = "seq="+seq+"&roleType="+roleType
						+"&assigned="+assigned
						+"&assignmentType="+assignmentType
						+"&orderNum="+orderNum
						+"&itemID="+itemID
						+"&accessRight="+accessRight
						+"&memberID="+memberID
						+"&memo="+memo
						+"&mbrTeamID="+mbrTeamID
						+"&alertType=DHX";
			ajaxPage(url, data, target);
		}
	}
	
	function fnChangeAuthor() {
	    var selectedItems = [];
	    grid.data.forEach(function(item) {
	        // 그룹 헤더가 아닌 실제 데이터만 확인
	        if(item.Seq !== undefined && item.checkbox) {
	            selectedItems.push(item);
	        }
	    });
		
		if(!selectedItems || selectedItems.length !== 1){
			Promise.all([
				getDicData("ERRTP", "LN0040"), // 항목을 하나만 지정해주세요.
				getDicData("BTN", "LN0034"), // 닫기
			]).then(results => {
				showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
			});
			return false;
		}

		
		$("#AuthorID").val(selectedItems[0].MemberID);
				
		function afterConfirmChangeAuthor () {
			var url = "saveOwnerInfo.do";	
			ajaxSubmit(document.roleFrm, url, "saveRoleFrame");
		}
		
		Promise.all([
			getDicData("ERRTP", "LN0025"), // 저장하시겠습니까?
			getDicData("BTN", "LN0032"), // 확인
			getDicData("BTN", "LN0033")  // 취소
		]).then(results => {
			showDhxConfirm(results[0].LABEL_NM, afterConfirmChangeAuthor, ()=> {return;}, results[1].LABEL_NM, results[2].LABEL_NM);
		});
	}
	
	function updateTotalCount(number) {
		
		if (number) {
			$("#TOT_CNT").html(number);
			return ;
		}
		
	    if(grid && grid.data) {
	        $("#TOT_CNT").html(grid.data.getLength());
	        return ;
	    }
	}
	
	var emptyIcon = '<svg xmlns="http://www.w3.org/2000/svg" height="48px" viewBox="0 -960 960 960" width="48px" fill="#CCCCCC"><path d="M480-481q-66 0-108-42t-42-108q0-66 42-108t108-42q66 0 108 42t42 108q0 66-42 108t-108 42ZM160-160v-94q0-38 19-65t49-41q67-30 128.5-45T480-420q62 0 123 15.5t127.5 44.5q31 14 50 41t19 65v94H160Z"/></svg>';
	
	function showEmptyDataPage() {
		$("#layout").attr("style","height:0px; width:100%;");
	    
		let buttonFunc = "";
		let buttonTitle = "";
		let buttonStyle = "";
		
		const elements = document.querySelectorAll('.empty-wrapper.btns');
		
		if(elements.length > 0) return;
		
		if("${myItem}" === "Y") {
			let buttonFunc = "showAddRoleDhxModal()";
			Promise.all([getDicData("ERRTP", "LN0042"), getDicData("GUIDELN", "LN0002"), getDicData("BTN", "LN0026")])
			.then(([errtp042, guideln002, btn026])=>{
				document.querySelector("#layout").insertAdjacentHTML("beforeEnd", emptyPage(emptyIcon, errtp042.LABEL_NM, guideln002.LABEL_NM, buttonFunc, btn026.LABEL_NM, ""));
			})
		} else {
			Promise.all([getDicData("ERRTP", "LN0042"), getDicData("GUIDELN", "LN0002"), getDicData("BTN", "LN0026")])
			.then(([errtp042, guideln002, btn026])=>{
				document.querySelector("#layout").insertAdjacentHTML("beforeEnd", emptyPage(emptyIcon, errtp042.LABEL_NM, guideln002.LABEL_NM, buttonFunc, "", ""));
			})
		}

	}
	
	function deleteEmptyDataPageAndPrepareLayout(){
		const elements = document.querySelectorAll('.empty-wrapper.btns');
		elements.forEach(el => el.remove());
		// 초기 표시 화면 크기 조정
		$("#layout").attr("style","height:"+(setWindowHeight() - 200)+"px; width:100%;");

		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 200)+"px; width:100%;");
		};
	}
	
</script>
<body>
<div id="roleAssignDiv">
<form name="roleFrm" id="roleFrm" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="items" name="items"  value="${s_itemID}" />
	<input type="hidden" id="AuthorID" name="AuthorID" value="" />
	<input type="hidden" id="alertType" name="alertType" value="DHX" />
	<input type="hidden" id="checkAuthor" name="checkAuthor" value="1" />
	<input type="hidden" id="checkOwnerTeam" name="checkOwnerTeam" value="1" />
	<input type="hidden" id="checkCompany" name="checkCompany" value="1" />
	<input type="hidden" id="includeChildItems" name="includeChildItems" value="1" />

	<div class="countList flex align-center justify-between">
        <div style="height:100%; display:flex; align-items:center; column-gap: 40px;">
        	<div class="count">Total  <span id="TOT_CNT"></span></div>
        	<div id="activatedFilterRadioBtns" style="display:flex; gap:4px; align-items:center; height: 32px;">
      			<label style="cursor: pointer;">
      				<input type="radio" name="activatedYN" value="Y" checked> Activated
			    </label>
			    <label style="cursor: pointer;">
			    	<input type="radio" name="activatedYN" value="N"> Deactivated
			    </label>
			    <label style="cursor: pointer;">
			    	<input type="radio" name="activatedYN" value="All"> All
			    </label>
		    </div>
        </div>
	        <div>
	        	<button class="btn_pack nobg"><a class="gov" onclick="fnChangeAuthor()" title="Ownership"></a></button>
	        	<c:if test="${itemIDAuthorID == sessionScope.loginInfo.sessionUserId || sessionScope.loginInfo.sessionAuthLev == 1}" >
	        		<button class="btn_pack nobg "><a class="add" onclick="showAddRoleDhxModal();" title="Add"></a></button>
	       			<button class="btn_pack nobg white"><a class="del" onclick="fnDeleteRoleAss()" title="Delete"></a></button>
	        	</c:if>
	        	<button class="btn_pack nobg white"><a class="xls"  title="Excel"  id="excel">></a></button>
	       </div>
    </div>  
	<div style="width: 100%; overflow-y:auto;" id="layout"></div>
</form>
<iframe id="saveRoleFrame" name="saveRoleFrame" style="width:0px;height:0px;display:none;"></iframe>
</div>
</body>
<script>

// ===========================================================================================================
// ===== [ 라됴버튼 ] ==========================================================================================
// ===========================================================================================================
	
const radios = document.querySelectorAll('input[type="radio"][name="activatedYN"]');

radios.forEach(radio => {
    radio.addEventListener('change', (e) => {
    	
    	$('#loading').fadeIn(150);
    	
        var selectedValue = e.target.value;
        var filteredListData = [];
        
        if(selectedValue === 'Y') {
            filteredListData = fullGridData.filter(function(item) {
                return item.Assigned === "1";
            });
        } else if(selectedValue === 'N') {
            filteredListData = fullGridData.filter(function(item) {
                return item.Assigned === "0";
            });
        } else {
            filteredListData = fullGridData;
        }
        
     	// 데이터가 없을 때 grid 초기화 통한 열 너비 깨지는 현상 방지
        if (filteredListData.length === 0) {
        	showEmptyDataPage();
            grid.data.parse([]);
            updateTotalCount(0);
            $('#loading').fadeOut(150);
            return; 
        }
     	
        deleteEmptyDataPageAndPrepareLayout();

        grid.data.parse(filteredListData);
        grid.data.group([
            { by: "AssignmentType" }
        ]);
        
        updateTotalCount();
        $('#loading').fadeOut(150);
    });
});

//===========================================================================================================
// ===== [ 그룹 그리드 ] =======================================================================================
//===========================================================================================================
	
var layout = new dhx.Layout("layout", {
    rows: [
        {
            id: "a",
        },
    ]
});
		
const columns = [
	// 체크박스
    { id: "checkbox", width: 40,  type: "boolean", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", align: "center" }], align: "center", editable: true, sortable: false},
    
    // 이름
    { id: "Name", width: 150, type: "string", header: [{ text: "${menu.LN00004}", align: "center" }], align: "left" },
    
    // 경로
    { id: "Path", type: "string", header: [{ text: "${menu.LN00043}", align: "center" }], align: "left" },
    
    // Role
    { id: "RoleTypeTxt", width: 100, type: "string", header: [{ text: "Role", align: "center" }], align: "center" },
    
    // 권한
    { id: "AccessRightName", width: 100, type: "string", header: [{ text: "${menu.LN00149}", align: "center" }], align: "center" },
    
    // 등록일
    { id: "AssignedDate", width: 100, type: "string", header: [{ text: "${menu.LN00078}", align: "center" }], align: "center" },
    
    // Order
    { id: "OrderNum", width: 80, type: "string", header: [{ text: "Order", align: "center" }], align: "center" }, 
];

grid = new dhx.Grid(null, {
    columns: columns,
    group: {
        panel: false,
        column: {
            header: [{ text: "Category" }],
            template: (value, row) => {
                if (row.$group) {
                	
                	const currentGridData = grid.data.serialize()
                	
                	const targetAssignmentTypeNameItem = currentGridData.find((gridItem) => {
                		return (gridItem.$level == 1 && gridItem.AssignmentType == value)
                	})
                	
                    return targetAssignmentTypeNameItem.AssignmentTypeName || value;
                }
                return value;
            }
            
        }
    },
    groupable: true,
    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false
});

layout.getCell("a").attach(grid);
	
grid.events.on("cellClick", function(row, column, e) {	
    if(column.id === "checkbox") {
        return;
    }
    
    // 그룹 헤더 클릭 방지
    if(row.Seq === undefined) {
        return;
    }

    function showRoleDetailModalCallback() {
        $("#memberID").val(row.MemberID);
        $("#memberName").val(row.Name);
        $("#itemID").val("${s_itemID}");
        $("#roleType").val(row.RoleType);
        $("#seq").val(row.Seq);
        $("#accessRight").val(row.AccessRight);
        $("#orderNum").val(row.OrderNum);
        $("#memo").val(row.Memo);
        $("#mbrTeamID").val(row.TeamID);
        
        $("#memberName").attr('readOnly', 'true');
        $("#roleDetail").attr('style', 'display: block');
        $("#searchMemberBtn").attr('style','display: none');
        
        var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&assignmentType="+row.AssignmentType;
        fnSelect('roleType', data, 'getOLMRoleType', row.RoleType, 'Select');
        fnSelect('assignmentType', data+'&actorType=USER', 'getAssignment', row.AssignmentType, 'Select');
        $("#assigned").val(row.Assigned).attr("selected", "selected");
    }
    
    dhxModal = openHtmlWithDhxModal(roleDetailModalHtml, "${menu.LN00288} ${menu.LN01013}", 1200, 300, showRoleDetailModalCallback);
});
	
grid.events.on("filterChange", function(row, column, e, item) {
    updateTotalCount();
});

// 체크박스 변경 핸들러
function fnMasterChk(state) {
    event.stopPropagation();
    grid.data.forEach(function (row) {
        // 그룹 헤더 행은 제외하고 확인
        if(row.Seq !== undefined) {  
            grid.data.update(row.id, { "checkbox": state });
        }
    });
}

function handleAjaxError(err, errDicTypeCode) {
	console.error(err);
	Promise.all([getDicData("ERRTP", errDicTypeCode), getDicData("BTN", "LN0034")])
			.then(([errDic, btnDic]) => showDhxAlert(errDic.LABEL_NM, btnDic.LABEL_NM));
}

async function fnReload(){ 
	
	$('#loading').fadeIn(150);
	
    const sqlID = "role_SQL.getAssignedRoleList";
    const param = new URLSearchParams({
        itemID: "${s_itemID}",
        assignmentType: "${assignmentType}",
        isAll: "N",
        languageID: "${sessionScope.loginInfo.sessionCurrLangType}",
        blankPhotoUrlPath: "${blankPhotoUrlPath}",
        photoUrlPath: "${photoUrlPath}",
        sqlID: sqlID
    });
    
    const url = "getData.do?" + param;
    
    try {
    	const response = await fetch(url, { method: 'GET' });
    
		if (!response.ok) {
			// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
			throw throwServerError(response.statusText, response.status);
		}
    	
    	const result = await response.json();
	    
		if (!result.success) {
			throw throwServerError(result.message, result.status);
		}
	    
	    if (result && result.data) {
	    	
	    	const finalData = result.data;
	        
	     	// 라디오버튼 Activated 설정
	        document.querySelector('input[name="activatedYN"][value="Y"]').checked = true;
	        fnReloadGrid(finalData);
 	
	    } else {
	        // 서버가 반환한 데이터가 유효하지 않을 경우
	        const error = new Error("서버가 반환한 데이터가 유효하지 않음");
	        error.type = 'INVALID_DATA';
	        throw error;
	    }
  
    } catch (error) {
    	handleAjaxError(error, "LN0014"); // 서버 내부 오류가 발생했습니다. 관리자에게 문의해주세요.  
    } finally {
    	$('#loading').fadeOut(150);
    }
}
 	
function fnReloadGrid(newGridData) {
    // 데이터가 없는 경우 처리
    if (!newGridData || newGridData.length === 0) {
    	
    	activatedGridData = [];
    	fullGridData = [];
    	filterdGridData = [];
    	showEmptyDataPage();
        grid.data.parse([]);     
        updateTotalCount(0);
        return;
    }
    
    deleteEmptyDataPageAndPrepareLayout();

    fullGridData = newGridData;

    activatedGridData = fullGridData.filter(function(item) {
        return item.Assigned === "1";
    });
    
    if (activatedGridData.length === 0) {
        showEmptyDataPage();
        updateTotalCount(0);
        return;
    }
   
    grid.data.parse(activatedGridData);
    grid.data.group([
        { by: "AssignmentType" }
    ]);
    updateTotalCount();
}

// role assignment 삭제 함수
function fnDeleteRoleAss(){
    var selectedItems = [];
    grid.data.forEach(function(item) {
        // 그룹 헤더가 아닌 실제 데이터만 확인
        if(item.Seq !== undefined && item.checkbox) {
            selectedItems.push(item);
        }
    });
    
    if(selectedItems.length === 0){
    	showDhxAlert("${WM00023}");
    } else {
    	async function afterConfirmDeletion() {
    	    const url = "deleteRoleAssignment.do";
    	    const seqArr = selectedItems.map(item => item.Seq);
    	    const data = "seqArr=" + seqArr.join(',');
    	    
    	    $('#loading').fadeIn(150);
    	    
    	    try {
    	        const response = await fetch(url, {
    	            method: "POST",
    	            headers: {
    	                "Content-Type": "application/x-www-form-urlencoded"
    	            },
    	            body: data
    	        });
    	        
    			if (!response.ok) {
    				// 서버와 연결은 됐으나 서버 자체가 HTTP 상태 코드 상 오류를 반환한 경우
    				throw throwServerError(response.statusText, response.status);
    			}

    	        await fnReload();
    	    	Promise.all([
    				getDicData("ERRTP", "LN0041"), // 삭제되었습니다.
    				getDicData("BTN", "LN0034"), // 닫기
    			]).then(results => {
    				showDhxAlert(results[0].LABEL_NM, results[1].LABEL_NM);
    			});
    	        
    	    } catch (error) {
    	    	handleAjaxError(error, "LN0014"); // 서버 내부 오류가 발생했습니다. 관리자에게 문의해주세요.
    	    } finally {
    	    	$('#loading').fadeOut(150);
    	    }
    	}
    	
		Promise.all([
			getDicData("ERRTP", "LN0021"), // 선택된 문서를 정말로 삭제하시겠습니까?
			getDicData("BTN", "LN0032"), // 확인
			getDicData("BTN", "LN0033")  // 취소
		]).then(results => {
			showDhxConfirm(results[0].LABEL_NM, afterConfirmDeletion, null, results[1].LABEL_NM, results[2].LABEL_NM);	
		});
	
    }
}
</script>