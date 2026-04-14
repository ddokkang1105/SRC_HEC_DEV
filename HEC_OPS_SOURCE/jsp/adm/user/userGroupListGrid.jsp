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

<script>
var p_gridArea;				//그리드 전역변수
$(document).ready(function(){
	gridInit();		
	doSearchList();
	
	fnSelectNone('Authority','&Category=MLVL','dictionyCode', 'VIEWER');
	fnSelect('companyID','', 'getCompany', '', '','');
});
//===============================================================================
// BEGIN ::: GRID
function doSearchList(){
	var d = setGridData();
	fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
}
//그리드 초기화
function gridInit(){	
	var d = setGridData();
	p_gridArea = fnNewInitGrid("grdGridArea", d);
	p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");	
	p_gridArea.setColumnHidden(8, true);
	fnSetColType(p_gridArea, 1, "ch");	
	p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
		gridOnRowSelect(id,ind);
	});
	
	p_gridArea.enablePaging(true,10,10,"pagingArea",true,"recInfoArea");
	p_gridArea.setPagingSkin("bricks");
	p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
}
function setGridData(){
	var result = new Object();
	result.title = "${title}";
	result.key = "user_SQL.groupList";
	result.header = "${menu.LN00024},#master_checkbox,ID,Name,${menu.LN00014},Email,Authority,${menu.LN00013},MemberID";
	result.cols = "CHK|LoginID|GroupNAME|CompanyName|Email|AuthorityNm|RegDate|MemberID";
	result.widths = "50,50,150,180,150,180,300,100,0";
	result.sorting = "int,int,str,str,str,str,str,str,str";
	result.aligns = "center,center,left,left,left,left,left,center,center";
	result.data = "UserType=2&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
	
	/* 검색 조건 */
	if($("#searchValue").val() != '' & $("#searchValue").val() != null){
		result.data = result.data +"&searchValue="+$("#searchValue").val();
		result.data = result.data +"&searchKey="+$("#searchKey").val();
		result.data = result.data + "&pageNum=1";
	} else {
		result.data = result.data + "&pageNum=" + $("#currPage").val();
	}	
	
	return result;
}

//그리드ROW선택시
function gridOnRowSelect(id, ind){
	if(ind != 1){
		doDetail(id);
	}
}

//셀렉트 이벤트 :: 상세페이지로 이동
function doDetail(id){
	var url    = "groupInfoView.do"; // 요청이 날라가는 주소
	var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"		
				+"&s_itemID="+p_gridArea.cells(id, 8).getValue()
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
		var url = "memberUpdate.do";
		var data = "regID=${sessionScope.loginInfo.sessionUserId}&UserType=2&type=insert"
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
	if(p_gridArea.getCheckedRows(1).length == 0){
		//alert("항목을 한개 이상 선택하여 주십시요.");	
		alert("${WM00023}");
	}else{
		//if(confirm("선택된 항목를 삭제하시겠습니까?")){
		if(confirm("${CM00004}")){
			var checkedRows = p_gridArea.getCheckedRows(1).split(",");	
			var items = "";
			for(var i = 0 ; i < checkedRows.length; i++ ){
				if (i == 0) {
					items = p_gridArea.cells(checkedRows[i], 8).getValue();
				} else {
					items = items + "," + p_gridArea.cells(checkedRows[i], 8).getValue();
				}
			}
			var url = "memberUpdate.do";
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
		<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
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