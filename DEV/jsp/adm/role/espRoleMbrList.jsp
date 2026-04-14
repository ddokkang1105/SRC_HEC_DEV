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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>

<script>	
	
	$(document).ready(function(){	
		
		// 초기 표시 화면 크기 조정
		$("#layout").attr("style","height:"+(setWindowHeight() - 340)+"px; width:100%;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 340)+"px; width:100%;");
		};
		$("#excel").click(function (){
			fnGridExcelDownLoad();
		});
		$("#TOT_CNT").html(grid.data.getLength());
		
		// company setting (검색창)
		fnSelect('company', '', 'getESPCustomerList', '${clientID}', 'Select','esm_SQL');
		
		// clientId setting (사용자 추가)
		fnSelect('clientID', '', 'getESPCustomerList', '', 'Select','esm_SQL');
		
		// srArea setting
  		fnSRAreaLoad();
  		// role setting
  		fnSelect('selectRoleType', 'languageID=${sessionScope.loginInfo.sessionCurrLangType}&assignmentType=${assignmentType}', 'getOLMRoleType', '', 'Select');
  		
  		// 담당자 팝업 enter
  		document.getElementById('memberName').addEventListener('keydown', function(event) {
	        if (event.key === 'Enter') {
	            event.preventDefault(); // 기본 Enter 동작 방지 (필요시)
	            searchPopupWf(); // 함수 호출
	        }
    	});
  		
  		getDicData("GUIDELN", "LN0001").then(data => {
  			document.querySelector("#srAreaSearch").placeholder = data.LABEL_NM;
  		})
  		
  		getDicData("BTN", "ZLN0001").then(data => {
  			document.querySelector("#editAllBtn").title = data.LABEL_NM;
  		})
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
	
	function fnRoleCallBack(){
		doOTSearchList();
		$("#roleDetail").attr('style', 'display: none');
	}
	
	// srarea
	function searchSrArea(){
		window.open('searchSrAreaPop.do?srType=${srType}&roleFilter=${roleFilter}&clientID=${clientID}','window','width=1000, height=500, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSrArea(clientID, srArea1, srArea2, srArea2Name){
		$("#srArea1").val(srArea1);
		$("#srArea2").val(srArea2);
		$("#srAreaSearch").val(srArea2Name);
	}
	
	// 사용자 추가 팝업
	function searchPopupWf(){
		window.open("searchMemberPop.do?myClient=${myClient}&notCompanyIDs=${notCompanyIDs}&searchValue="+$("#memberName").val(),'searchMemberPop','width=900, height=700');
	}
	
	function searchMemberCallback(avg1,avg2,avg3,avg4,avg5){
		$("#memberName").val(avg2+"("+avg3+"/"+avg4+")");
		$("#memberID").val(avg1);
		$("#mbrTeamID").val(avg5);
	}
	
	function changeAddRoleType(val){
		$("#roleType").val(val);
	}
	
	// 단일 추가
	function fnAddRole(){
		$("#memberID").val("");
		$("#memberName").val("");
		$("#roleType").val("");
		$("#assignment").val("");
		$("#seq").val("");
		$("#orderNum").val("");
		$("#assigned").val("");
		$("#accessRight").val("");
		$("#path").val("");
		$("#mbrTeamID").val("");
		
		$("#memberName").removeAttr('readOnly');
		$("#path").attr('readOnly', 'true');
		$("#roleDetail").attr('style', 'display: done');
		$("#searchMemberBtn").attr('style','display : done');
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&assignmentType=${assignmentType}";
		fnSelect('assignmentType', data+'&actorType=USER', 'getAssignment', '${assignmentType}', 'Select');
		
		var selectRoleType = $("#selectRoleType").val();
		fnSelect('roleType', data, 'getOLMRoleType', selectRoleType, 'Select');
		if("${assignmentType}" != ""){ $("#assignmentType").attr('disabled', 'true'); }
		
	}
	
	// 단일 저장
	function fnSaveRoleAss(){
		if(!confirm("${CM00001}")){ return;}
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
		var clientID = $("#clientID").val();
		
		if(seq == null || seq == '' || seq === undefined){
			seq = '';
		}
		
		if(itemID == null || itemID == '' || itemID === undefined){
			getDicData("ERRTP", "ZLN0023").then(data => alert("${menu.ZLN0024}" + data.LABEL_NM));
// 			alert("서비스/파트를 선택해주세요!");
			return;
		}
		else if(roleType == null || roleType == '' || roleType === undefined){
			getDicData("ERRTP", "ZLN0023").then(data => alert("R&R (Role)" + data.LABEL_NM));

// 			alert("R&R (Role)을 선택해주세요!");
			return;
		}
		else if(memberID == null || memberID == '' || memberID === undefined){
			getDicData("ERRTP", "ZLN0023").then(data => alert("${menu.LN00004}" + data.LABEL_NM));
// 			alert("담당자를 선택해주세요!");
			return;
		}
		else {
			var url = "saveRoleAssignment.do";
			var target = "saveRoleFrame";		
			var data = "seq="+seq+"&roleType="+roleType
						+"&assigned="+assigned
						+"&assignmentType="+assignmentType
						+"&orderNum="+orderNum
						+"&itemID="+itemID
						+"&accessRight="+accessRight
						+"&memberID="+memberID
						+"&clientID="+clientID
						+"&mbrTeamID="+mbrTeamID;
			ajaxPage(url, data, target);
		}
	}
	
	// 단일삭제
	function fnDeleteRoleAss(){
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00023}");	
		} else {
			if(confirm("${CM00002}")){
				var url = "deleteRoleAssignment.do";
				var seqArr = new Array();
				for(idx in selectedCell){
					seqArr.push(selectedCell[idx].Seq);
				};
				var data =  "seqArr="+seqArr; 
				var target = "saveRoleFrame";
				ajaxPage(url, data, target);
			}
		}
	}
	
	// 일괄편집
	function fnEditAll(){
		var height = screen.height;
		window.open("editESPGroupALL.do?&s_itemID=${s_itemID}&assignmentType=${assignmentType}&clientID="+$("#company").val(),'editGroupPop','width=1000, height=' + height);
	}

</script>
<style>
	a:hover{
		text-decoration:underline;
	}
	input[type=text]::-ms-clear{
		display: done;
	}
	.autocomplete{
	    border: 1px solid #ddd;
	    display: none;
	    position: absolute;
	    width: 600px;
	    max-height: 200px;
	    background: #ffffff;
	    overflow: auto;
	    z-index: 100;
	    border-radius: 8px;
	    margin-top: 4px;
	    -webkit-box-shadow: 0 4px 10px 0 rgba(32, 33, 36, .1);
	    box-shadow: 0 4px 10px 0 rgba(32, 33, 36, .1);
   }
    .autocomplete.on {
    	display:block;
    }
    .autocomplete > div {
	    display: grid;
	    grid-template-columns: 150px 1fr 1fr;
	    background: #ffffff;
	    padding: 0 8px;
	    border-bottom: 1px solid #ddd;
    	cursor:pointer;
    }
    .autocomplete > div > span {
	    padding: 8px 0;
    }
	/* 현재 선택된 검색어 */
	.autocomplete > div.active, .autocomplete > div:hover {
    	background: #ddd;
	}
	mark {
		background: transparent;
	    color: #0761CF;
	    font-weight: bold;
	}
</style>

<body>
<div id="roleAssignDiv" >
<form name="processList" id="processList" action="#" method="post"  onsubmit="return false;">
	<input type="hidden" id="searchKey" name="searchKey" value="Name">
	<input type="hidden" id="currPage" name="currPage" value="${currPage}"></input>
	<input type="hidden" id="isLov" name="isLov" value="">
	<input type="hidden" id="defaultLang" name="defaultLang" value="${defaultLang}">
	<input type="hidden" id="isComLang" name="isComLang" value="">
	<input type="hidden" id="isSpecial" name="isSpecial" value="">
	
	<input type="hidden" id="items" name="items" >
	<input type="hidden" id="classCodes" name="classCodes" >
	<input type="hidden" id="attrIndex" value="0">
	<input type="hidden" id="beforeCode" value="">
	
	<input type="hidden" id="attrCodeSorting" value="">
		
	<div align="center">
	
	<table style="table-layout:fixed;" border="0" cellpadding="0" cellspacing="0" class="tbl_search"  id="search">
		<colgroup>
		    <col width="6%">
		    <col width="12%">
		    <col width="7%">
		    <col width="16%">
		    <col width="6%">
		    <col width="14%">
		    <col width="6%">
		    <col width="14%">
		    <col width="6%">
		    <col width="8%">
	    </colgroup>
	    <tr>
			<!-- 관계사 -->
	    	<th>${menu.LN00014}</th>
   			<td>
   				<select id="company" name="company" <c:if test="${clientID ne null and clientID != ''}">disabled</c:if>>	
					<option value=''>ALL</option>
				</select>
			</td>
			
			<!-- 서비스/파트 -->
			<th>${menu.ZLN0024}</th>
			<td class="sline tit last" style="position:relative; width:150px;">
				<input type="text" class="text" id="srAreaSearch" name="srAreaSearch" style="width:150px;" autocomplete="off"/>
				<img id="srAreaBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="searchSrArea()"/>
				<input type="hidden" id="srArea1" name="srArea1" />
				<input type="hidden" id="srArea2" name="srArea2" />
				<ul class="autocomplete"></ul>
			</td>
			
			<th>ROLE</th>
   			<td>
   				<select id="selectRoleType" name="selectRoleType" style="width:100%;" onchange="changeAddRoleType(this.value);">	
					<option value=''>ALL</option>
				</select>
			</td>
			
			<!-- 담당자 -->
  			<th>${menu.LN00004}</th>
			<td class="last" ><input type="text" id="detailAuthor" name="detailAuthor" value="" class="stext"></td>	
			
			<!-- Active -->
			<th  class="">${menu.LN00027}</th>
            <td class="alignL last ">
            	<select id="Status" name="Status">
						<option value="1">Y</option>
						<option value="0">N</option>
            	</select>
            </td>		
	    </tr>	    
	</table>
	
	<li id="buttonGroup" class="floatC mgR20 mgT5">
		<input id="btnSearch" type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" style="cursor:pointer;" onclick="doOTSearchList();">
		&nbsp;<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="cursor:pointer;" onclick="clearSearchCon();">
	</li>	
</div>		
	</form>
<form name="roleFrm" id="roleFrm" action="" method="post" onsubmit="return false;">
	<div class="countList" style="margin: 3px 0px 3px 0;" >
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
  			<c:if test="${editYN == 'Y' || sessionScope.loginInfo.sessionAuthLev == 1}" >
        		<span class="btn_pack nobg "><a class="add" onclick="fnAddRole();" title="Add"></a></span>
        	   	<span class="btn_pack nobg white"><a class="del" onclick="fnDeleteRoleAss()" title="Delete"></a></span>
        	   	<span class="btn_pack nobg "><a id='editAllBtn' class="table" onclick="fnEditAll();"></a></span>
        	</c:if>
        	<span class="btn_pack nobg white"><a class="xls"  title="Excel"  id="excel">></a></span>
       </li>
    </div>  
      
	<div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>
	
	<div  id="roleDetail" style="display:none;">
	<table class="tbl_blue01 mgT10 mgB5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
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
				<input type="text" class="text" id="memberName" name="memberName" value="" style="ime-mode:active;width:80%;" autocomplete="off" />
				<input type="hidden" id="memberID" name="memberID" value="" />
				<input type="hidden" id="mbrTeamID" name="mbrTeamID" value="" />
				<img id="searchRequestBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" / onclick="searchPopupWf()">
			</td>
			<td class="last">
				<select id="assignmentType" name="assignmentType" style="width:100%;" OnChange="fnGetRoleType(this.value);"></select>
			</td>
			<td class="last">
				<select id="roleType" name="roleType" style="width:100%;"></select>
			</td>
			<td class="last">
				<select id="accessRight" name="accessRight" style="width:100%;">
					<option value="R">Referred</option>
					<option value="U">Manage</option>
				</select>
			</td>
			<td class="last">
				<input type="text" class="text" id="orderNum" name="orderNum" />
			</td>
			<td class="last">
				<select id="assigned" name="assigned" style="width:100%;">
					<option value="1">Activated</option>
					<option value="0">Deactivated</option>
				</select>
			</td>
		</tr>
		<tr>
			<th class="last pdL10">${menu.ZLN0024}</th>				
			<td class="last" colspan=2 align="left">
				<p id="addRoleSrArea2"></p>
				<input type="hidden" id="itemID" name="itemID" value="" />
			</td>
			<!-- 관계사 -->
			<th>${menu.LN00014}</th>
			<td class="sline tit last" colspan="2" style="position:relative; width:150px;">
				<select id="clientID" name="clientID" style="width:100%;"></select>
			</td>			
		</tr>
	</table>
	<div class="pdT5 pdB5 floatR" >
        <span id="viewSave" class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="fnSaveRoleAss()"></span>&nbsp;
    </div>   
    </div> 
</form>
<iframe id="saveRoleFrame" name="saveRoleFrame" style="width:0px;height:0px;display:none;"></iframe>
</div>
</body>
<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var pagination;
	var gridData = '';
	
	var grid = new dhx.Grid("grid",  {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center"},
	        { width: 30, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" }], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 40, id: "Photo", header: [{ text: "", align:"center" }], htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		return '<img src="'+row.Photo+'" width="26" height="24">';
	            }
	        },
	        { width: 130, id: "Name", header: [{ text: "${menu.LN00004}", align:"center" }, { content: "inputFilter" }]},
	        { width: 150, id: "ProcessType", header: [{ text: "Role", align:"center" }, { content: "selectFilter" }]},
	        { id: "Path", header: [{ text: "${menu.LN00104}", align:"center" }, { content: "inputFilter" }], align:"left" },
	        { width: 150, id: "CompanyName", header: [{ text: "${menu.LN00014}", align:"center" }, { content: "selectFilter" }], align:"left" },
	        { width: 120, id: "ServiceCode", header: [{text: "${menu.ZLN0187}", align:"center"}, { content:"selectFilter"}], align:"left" },
	        { width: 150, id: "ServiceName", header: [{ text: "${menu.ZLN0188}", align:"center" }, { content: "selectFilter" }], align:"left" },
	        { width: 120, id: "PartCode", header: [{ text: "${menu.ZLN0189}", align:"center" }, { content: "selectFilter" }], align:"left" },
	        { width: 150, id: "PartName", header: [{ text: "${menu.ZLN0179}", align:"center" }, { content: "inputFilter" }], align:"left" },
	        { width: 110, id: "AssignedDate", header: [{ text: "${menu.LN00078}", align:"center" }, { content: "inputFilter" }], align:"center"},
	        { hidden: true, width: 70, id: "OrderNum", header: [{ text: "Order", align:"center" }], align:"center", htmlEnable: true},
	        { width: 80, id: "Assignment", header: [{ text: "Active", align:"center" }, { content: "selectFilter"}], align:"center" },
	        { hidden: true, width: 80, id: "Seq", header: [{ text: "Seq", align:"center" }]},
	        { hidden: true, width: 80, id: "ProjectID", header: [{ text: "ProjectID", align:"center" }]},
	        { hidden: true, width: 80, id: "MemberID", header: [{ text: "MemberID", align:"center" }]},
	        { hidden: true, width: 80, id: "LoginID", header: [{ text: "LoginID", align:"center" }]},
	        { hidden: true, width: 80, id: "ItemID", header: [{ text: "ItemID", align:"center" }]},
	        { hidden: true, width: 80, id: "RoleType", header: [{ text: "RoleType", align:"center" }]}
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    multiselection : true,	    
	});
	
	grid.events.on("cellClick", function(row,column,e){
		if(column.id != "checkbox"){
			 $("#memberID").val(row.MemberID);
			 $("#memberName").val(row.Name);
			 $("#itemID").val(row.ItemID);
			 $("#roleType").val(row.RoleType);
			 $("#seq").val(row.Seq);
			 $("#accessRight").val(row.AccessRight);
			 $("#orderNum").val(row.OrderNum);
			 $("#addRoleSrArea2").text(row.ServiceName +'/'+ row.PartName);
			 $("#mbrTeamID").val(row.TeamID);
			
			 $("#memberName").attr('readOnly', 'true');
			 $("#roleDetail").attr('style', 'display: done');
			 $("#searchMemberBtn").attr('style','display : none');
			
			 var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&assignmentType=${assignmentType}";
			 fnSelect('roleType', data, 'getOLMRoleType', row.RoleType, 'Select');
			 fnSelect('assignmentType', data+'&actorType=USER', 'getAssignment', '${assignmentType}', 'Select');
			 $("#assigned").val(row.Assigned).attr("selected", "selected");
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
	
 	function doOTSearchList(){
 		$('#loading').fadeIn(150);
 		var clientID =$("#company").val();
 		var Author =$("#detailAuthor").val();
 		var assigned =$("#Status").val();
 		var srArea = $("#srArea2").val();
 		if(srArea === "0" || srArea === "" || srArea === null || srArea === undefined) srArea = $("#srArea1").val();
 		var selectRoleType = $("#selectRoleType").val();
 		
		var sqlID = "role_SQL.getEspRoleMbrList";
		var param = "&itemID=${s_itemID}"
				+ "&assignmentType=${assignmentType}"
				+ "&isAll=N&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+ "&blankPhotoUrlPath=${blankPhotoUrlPath}"
				+ "&photoUrlPath=${photoUrlPath}"
				+ "&clientID="+clientID
				+ "&MemberName="+Author
				+ "&assigned="+assigned
				+ "&roleType="+selectRoleType
				+ "&srArea2="+srArea
				+ "&noTopOpt=Y" // top 1000옵션 제거 
				+ "&sqlID="+sqlID;
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				$('#loading').fadeOut(150);
				fnReloadGrid(result);				
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
 	}
 	
 	function fnReloadGrid(newGridData){
 		grid.data.parse(newGridData);
 		$("#TOT_CNT").html(grid.data.getLength());
 	}
 	 	
 	const changeEvent = document.createEvent("HTMLEvents");
 	changeEvent.initEvent("change", true, true);
 	
	function clearSearchCon() {
		$("#detailAuthor").val('');
		$("#Status").val('');
		if("${clientID}" == '' || "${clientID}" === undefined || "${clientID}" == null) $("#company").val('');
		$("#srAreaSearch").val('');
		$("#srArea2").val('');
	}
	
	// srarea search
	let srAreaData = [];
	function fnSRAreaLoad() {
		fetch("/olmapi/srArea/?languageID=${sessionScope.loginInfo.sessionCurrLangType}&roleFilter=${roleFilter}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&clientID=${clientID}")
		.then((response) => response.json())
		.then(data => srAreaData = data);
	}
	
	const srAreaSearch = document.querySelector("#srAreaSearch");
	const autoComplete = document.querySelector(".autocomplete");
	

	let nowIndex = 0;
	let matchDataList, findIndex = [];
	srAreaSearch.addEventListener("keyup", function(event) {
	  // 검색어
		const value = srAreaSearch.value;

		switch (event.keyCode) {
		    // UP KEY
		    case 38:
		      	nowIndex = Math.max(nowIndex - 1, 0);
		      	break;

		    // DOWN KEY
		    case 40:
		    	nowIndex = Math.min(nowIndex + 1, matchDataList.length - 1);
		      	break;

		    // ENTER KEY
		    case 13:
		    	document.querySelector("#srAreaSearch").value = matchDataList[nowIndex].SRArea2Name || matchDataList[nowIndex].SRArea1Name || "";
				document.querySelector("#srArea1").value = matchDataList[nowIndex].SRArea1 || "";
				document.querySelector("#srArea2").value = matchDataList[nowIndex].SRArea2 || "";
				
				// 초기화
				nowIndex = 0;
				matchDataList.length = 0;
				break;
	      
	    	default:
	    		// 자동완성 필터링
		    	matchDataList, findIndex = [];
				if(value) {
					if(document.querySelector("#company").value == "") matchDataList = srAreaData.filter(e => e.SRArea1Name.includes(value) || e.SRArea2Name.includes(value));
					else matchDataList = srAreaData.filter(e => e.ClientID === document.querySelector("#company").value).filter(e => e.SRArea1Name.includes(value) || e.SRArea2Name.includes(value));
					matchDataList = srAreaData.filter(e => e.SRArea1Name.match(new RegExp(value, "i")) || e.SRArea2Name.match(new RegExp(value, "i")));
				} else {
					matchDataList = []
				}
				break;
		}
		
		// 리스트 보여주기
		showList(matchDataList, value, nowIndex);
	});

	const showList = (data, value, nowIndex) => {
		// 정규식으로 변환
		const regex = new RegExp(`(\\\(${value}\\))`, "g");
		data.length > 0 ? autoComplete.classList.add("on") : autoComplete.classList.remove("on");
		autoComplete.innerHTML = data.map((e, index) => `<div class='\${nowIndex === index ? "active" : ""}' data-index='\${e.RNUM}'><span>\${e.CompanyName}</span><span>\${e.SRArea1Name}</span><span>\${e.SRArea2Name.replace(regex, "<mark>$1</mark>")}</span></div>`).join("");
	};
	
	autoComplete.addEventListener("mouseover", function(e) {
		autoComplete.childNodes.forEach(child => child.classList.remove("active"))
	});
	
	// srArea 팝업 영역 외 클릭시 팝업 닫기
	document.addEventListener("click", function(e) {
		if(autoComplete.contains(e.target)) {
			let parentIndex = e.target.parentNode.getAttribute("data-index");
			document.querySelector("#srAreaSearch").value = srAreaData.filter(e => e.RNUM == parentIndex)[0].SRArea2Name || srAreaData.filter(e => e.RNUM == parentIndex)[0].SRArea1Name;
			document.querySelector("#srArea1").value = srAreaData.filter(e => e.RNUM == parentIndex)[0].SRArea1;
			document.querySelector("#srArea2").value = srAreaData.filter(e => e.RNUM == parentIndex)[0].SRArea2 || "";
			
			// setting
			let itemID = '';
			if(document.querySelector("#srArea2").value === "" || document.querySelector("#srArea2").value === undefined || document.querySelector("#srArea2").value === null) itemID =document.querySelector("#srArea1").value;
			else itemID = document.querySelector("#srArea2").value;
			$("#itemID").val(itemID);
			
			let srAreaNM = srAreaData.filter(e => e.RNUM == parentIndex)[0].SRArea1Name;
			if(document.querySelector("#srArea2").value !== "" && document.querySelector("#srArea2").value !== undefined && document.querySelector("#srArea2").value !== null) srAreaNM += '/' + srAreaData.filter(e => e.RNUM == parentIndex)[0].SRArea2Name;
			$("#addRoleSrArea2").text(srAreaNM);
			
		}
	    if(e.target.id !== "srAreaSearch" && autoComplete.classList.contains("on")) autoComplete.classList.remove("on");
	})

</script>