<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!-- 관리자 : 사용자/그릅 관리  -->
<!-- 
	@RequestMapping(value="/UserGroupList.do")
	* user_SQL.xml - groupList_gridList
	* Action
	  - View     :: groupInfoView.do
	  - Update   :: memberUpdate.do
 -->

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="${menu.LN00106}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
$(document).ready(function(){
	// SKON CSRF 보안 조치
	$.ajaxSetup({
		headers: {
			'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			}
	})	
	
	fnSelectNone('Authority','&Category=MLVL','getDicWord', 'VIEWER');
	fnSelect('companyID','', 'getCompany', '', '','');
});


//===============================================================================
// BEGIN ::: GRID
function doSearchList(){
	var sqlID = "user_SQL.groupList";
	var param =  "s_itemID=${s_itemID}"				
        + "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
        + "&searchKey="     + $("#searchKey").val()
        + "&searchValue="     	+ $("#searchValue").val()
        + "&userType=2"
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

var layout = new dhx.Layout("grdGridArea", {
    rows: [
        {
            id: "a",
        },
    ]
});
;
var gridData = ${gridData};
var grid = new dhx.Grid("grid", {
    columns: [
        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
        { width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
        { width: 150, id: "LoginID", header: [{ text: "${menu.LN00106}", align: "center" } ], align: "left" },
        { width: 180, id: "GroupNAME", header: [{ text: "Name", align: "center" } ], align: "left" },
        { width: 150, id: "CompanyName", header: [{ text: "${menu.LN00014}", align: "center" } ], align: "left" },
        { width: 180, id: "Email", header: [{ text: "Email", align: "center" } ], align: "left" },
        { width: 300, id: "AuthorityNm", header: [{ text: "Authority", align: "center" } ], align: "left" },
        { width: 100, id: "RegDate", header: [{ text: "${menu.LN00013}", align: "center" } ], align: "center" },
        { hidden: true, id: "MemberID", header: [{ text: "MemberID", align: "center" } ], align: "center" },

    ],
    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    data: gridData
});

layout.getCell("a").attach(grid);

var pagination = new dhx.Pagination("pagination", {
    data: grid.data,
    pageSize: 20,
});

$("#TOT_CNT").html(grid.data.getLength());

grid.events.on("cellClick", function(row,column,e){
	if(column.id != "checkbox"){
		doDetail(row.MemberID);
	}
}); 

function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
		fnMasterChk('');
		$("#TOT_CNT").html(grid.data.getLength());
}
//셀렉트 이벤트 :: 상세페이지로 이동
function doDetail(id){
	var url    = "groupInfoView.do"; // 요청이 날라가는 주소
	var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"		
				+"&s_itemID="+id
				+"&currPage=" + $("#currPage").val(); //파라미터들
	var target = "groupList";
	ajaxPage(url,data,target);
}

//그릅 추가 폼 생성
function addGroup(){
	$("#addGroupInfo").removeAttr('style', 'display: none');
}

function newGroupInsert(){
	// [LoginID] 필수 체크
	if($("#UserID").val() == ""){
		alert("${WM00034}");
		$("#UserID").focus();
		return;
	}
	
	if(confirm("${CM00009}")){
		var url = "admin/memberUpdate.do";
		var data = "regID=${sessionScope.loginInfo.sessionUserId}&userType=2&type=insert"
					+"&companyID="+$("#companyID").val()
					+"&Name="+$("#Name").val()
					+"&loginID="+$("#UserID").val()
					+"&Email="+$("#Email").val()
					+"&Authority="+$("#Authority").val()
					+"&currPage=" + $("#currPage").val();
		var target = "blankFrame";
		
		$("#UserID").val('');
		$("#Name").val('');
		$("#Email").val('');
		$("#companyID").val('');
		$("#Authority").val('');
		
		ajaxPage(url, data, target);
	}
}

// END ::: GRID	
//===============================================================================

//삭제처리 실행	
function groupDel(){
	var selectedCell = grid.data.findAll(function (data) {
        return data.checkbox;
    });

	if(!selectedCell.length){
		//alert("항목을 한개 이상 선택하여 주십시요.");	
		alert("${WM00023}");
	}else{
		//if(confirm("선택된 항목를 삭제하시겠습니까?")){
		if(confirm("${CM00004}")){
			var items = selectedCell.map(function(cell) {
		    	return cell.MemberID;
			}).join(",");
			console.log(items);
			var url = "admin/memberUpdate.do";
			var data = "userMenu=userGroup&type=delete&s_itemID=${s_itemID}&items="+items;
			var target = "blankFrame";
			ajaxPage(url, data, target);
		}
	}
}
</script>
<form name="groupList" id="groupList" action="#" method="post" onsubmit="return false;">
	<div id="groupListDiv" class="hidden" style="width:100%;height:100%;">
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}"/>
	<input type="hidden" id="currPage" name="currPage" value="${currPage}"></input> 	
	<div>
		<div class="msg"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;${menu.LN00098}</div>
		<div class="child_search">
		<li  class="count">Total  <span id="TOT_CNT"></span></li>
			<li class="pdL55">
				<select id="searchKey" name="searchKey">
					<option value="Name">Name</option>
					<option value="ID">ID</option>
				</select>
				
				<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;">
				<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchList();" value="검색">
			</li>
			<li class="floatR pdR20">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
					<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="addGroup('')"></span>
					<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="groupDel()"></span>
				</c:if>			
			</li>
        </div>
		
		<!-- BIGIN :: LIST_GRID -->
		<div id="gridDiv" class="mgB10 mgT5">
			<div id="grdGridArea" style="height:278px; width:100%"></div>
		</div>
		<!-- END :: LIST_GRID -->
		
		<!-- START :: PAGING -->
		<div id="pagination"></div>
		<!-- END :: PAGING -->	
		
	</div>
	<div id="addGroupInfo" style="display: none;">
		<table class="tbl_blue01 mgT5" width="100%" border="0" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="7%">
			<col width="13%">
			<col width="7%">
			<col width="13%">
			<col width="7%">
			<col width="13%">
			<col width="7%">
			<col width="13%">
			<col width="7%">
			<col>
		</colgroup>
		<tr>
			<th  class="viewtop">ID</th>
			<td  class="viewtop"><input type="text" class="text" id="UserID" name="UserID"  value="${getData.UserID}"/></td>
			<th  class="viewtop">${menu.LN00028}</th>
			<td  class="viewtop"><input type="text" class="text" id="Name" name="Name"  value="${getData.UserNAME}"/></td>
			<th  class="viewtop">E-mail</th>
			<td  class="viewtop"><input type="text"class="text" id="Email" name="Email"  value="${getData.Email}"/></td>				
			<th  class="viewtop">${menu.LN00014}</th>
			<td  class="viewtop">
				<select id="companyID" name="companyID"></select>
			</td>
			<th  class="viewtop">Authority</th>
			<td  class="viewtop">
				<select id="Authority" name="Authority"></select>
			</td>
		</tr>			
	</table>
	<div class="alignBTN" id="saveGrp">
		<span class="btn_pack medium icon">
			<span  class="save"></span>
			<input value="Save" onclick="newGroupInsert()"  type="submit">
		</span>
	</div>
	
	</div>					
		
	</div>
</form>
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>		