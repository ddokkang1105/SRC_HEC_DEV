<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<script>
	var p_gridArea;	
	var authLev =  "${sessionScope.loginInfo.sessionAuthLev}";
	var UserId = "${sessionScope.loginInfo.sessionUserId}";
		
	$(document).ready(function(){	
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		};
				
		$("input.datePicker").each(generateDatePicker);
		$('.searchList').click(function(){
			doSearchRoleList();
			return false;
		});
		
		$("#memberName").keypress(function(){
			if(event.keyCode == '13') {
				searchPopupWf('searchPluralNamePop.do?objId=memberID&objName=memberName');
				
				return false;
			}			
		});
		
		gridInit();	
		doSearchRoleList();
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
	
	//===============================================================================
	// BEGIN ::: GRID
	function gridInit(){		
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");	
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});		
		p_gridArea.setPagingSkin("bricks");
		fnSetColType(p_gridArea, 2, "img");		
		
		p_gridArea.setColumnHidden(11, true);
		p_gridArea.setColumnHidden(12, true);
		p_gridArea.setColumnHidden(13, true);
		p_gridArea.setColumnHidden(14, true);
		p_gridArea.setColumnHidden(15, true);
		p_gridArea.setColumnHidden(16, true);
		p_gridArea.setColumnHidden(17, true);	
		
		fnSetColType(p_gridArea, 1, "ch");
	}
	function setGridData(avg){
		var result = new Object();
		result.title = "${title}";
		result.key = "role_SQL.getAssignedRoleList";
		result.header = "${menu.LN00024},#master_checkbox,,${menu.LN00004},Role type,Role,${menu.LN00149},${menu.LN00247},${menu.LN00078},Order,Active,MemberID,ItemID,RoleTypeCode,Assigned,Seq,AssignmentType,AccessRight";
		result.cols = "CHK|Photo|Name|AssignmentTypeName|RoleTypeTxt|AccessRightName|Path|AssignedDate|OrderNum|Assignment|MemberID|ItemID|RoleType|Assigned|Seq|AssignmentType|AccessRight";
		result.widths = "30,30,60,150,130,80,80,*,90,60,60,70,70,70,70,70,70";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,left,center,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&assignmentType=${assignmentType}"
					+ "&blankPhotoUrlPath=${root}${HTML_IMG_DIR}/blank_photo.png"
					+ "&photoUrlPath=<%=GlobalVal.EMP_PHOTO_URL%>"
					+ "&itemID=${itemID}&isAll=N";
		return result;
	}
	
	function doSearchRoleList(avg){
		var d = setGridData(avg);
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	function gridOnRowSelect(id, ind){
		if( UserId != "${itemIDAuthorID}" && authLev != 1){return;}
		var assignmentTypeName = p_gridArea.cells(id, 4).getValue();
		var assignmentType = p_gridArea.cells(id, 16).getValue();
		var memberID = p_gridArea.cells(id, 11).getValue();
		var memberName = p_gridArea.cells(id, 3).getValue();
		var itemID = p_gridArea.cells(id, 12).getValue();
		var path = p_gridArea.cells(id, 7).getValue();
		var roleType = p_gridArea.cells(id, 13).getValue();
		var assignment = p_gridArea.cells(id, 10).getValue();
		var seq = p_gridArea.cells(id, 15).getValue();
		var orderNum = p_gridArea.cells(id, 9).getValue();
		var assigned = p_gridArea.cells(id, 14).getValue();
		var accessRight = p_gridArea.cells(id, 17).getValue();
		
		$("#memberID").val(memberID);
		$("#memberName").val(memberName);
		$("#itemID").val(itemID);
		$("#path").val(path);
		$("#roleType").val(roleType);
		$("#seq").val(seq);
		$("#accessRight").val(accessRight);
		$("#orderNum").val(orderNum);
		
		$("#memberName").attr('readOnly', 'true');
		$("#path").attr('readOnly', 'true');
		$("#path").attr('style', 'display: done');
		$("#roleDetail").attr('style', 'display: done');
		$("#searchMemberBtn").attr('style','display : none');
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&assignmentType="+assignmentType;
		fnSelect('roleType', data, 'getOLMRoleType', roleType, 'Select');
		fnSelect('assignmentType', data+'&actorType=USER', 'getAssignment', assignmentType, 'Select');
		$("#assigned").val(assigned).attr("selected", "selected");
	}

	function fnAddRole(){		
		$("#memberID").val("");
		$("#memberName").val("");
		$("#itemID").val("${itemID}");		
		$("#roleType").val("");
		$("#assignment").val("");
		$("#seq").val("");
		$("#orderNum").val("");
		$("#assigned").val("");
		$("#accessRight").val("");
		$("#path").val("");
		
		$("#memberName").removeAttr('readOnly');
		$("#path").attr('readOnly', 'true');
		$("#roleDetail").attr('style', 'display: done');
		$("#searchMemberBtn").attr('style','display : done');
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&assignmentType=${assignmentType}";
		fnSelect('assignmentType', data+'&actorType=USER', 'getAssignment', '${assignmentType}', 'Select');
		fnSelect('roleType', data, 'getOLMRoleType', '', 'Select');
		if("${assignmentType}" != ""){ $("#assignmentType").attr('disabled', 'true'); }
		
	}
	
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
		
		var url = "saveRoleAssignment.do";
		var target = "saveRoleFrame";		
		var data = "seq="+seq+"&roleType="+roleType
					+"&assigned="+assigned
					+"&assignmentType="+assignmentType
					+"&orderNum="+orderNum
					+"&itemID="+itemID
					+"&accessRight="+accessRight
					+"&memberID="+memberID;
		ajaxPage(url, data, target);
	}
	
	function fnDeleteRoleAss(){	
		var checkedRows = p_gridArea.getCheckedRows(1).split(",").length;		
		if (p_gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00023}");
			return;
		}
		if(confirm("${CM00002}")){
			var cnt  = p_gridArea.getRowsNum();
			var seqArr =  new Array;			
			var chkVal;
			
			var j = 0;		
			for ( var i = 0; i < cnt; i++) { 
				chkVal = p_gridArea.cells2(i,1).getValue();
				if(chkVal == 1){
					seqArr[j] = p_gridArea.cells2(i, 15).getValue();
					j++;
				}
			}
			var url = "deleteRoleAssignment.do";
			var target = "saveRoleFrame";		
			var data = "seqArr="+seqArr; 
			ajaxPage(url, data, target);
		}
	}
	
	function fnRoleCallBack(){
		gridInit();	
		doSearchRoleList();
		$("#roleDetail").attr('style', 'display: none');
	}
	
	function searchPopupWf(avg){
		var searchValue = $("#memberName").val();
		var url = avg + "&searchValue="+encodeURIComponent(searchValue)
		+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		
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
	}
	
	
</script>

<div id="roleAssignDiv">
<form name="roleFrm" id="roleFrm" action="" method="post" onsubmit="return false;">
	<div class="countList pdB5 " >
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
        	<c:if test="${itemIDAuthorID == sessionScope.loginInfo.sessionUserId || sessionScope.loginInfo.sessionAuthLev == 1}" >
        	<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onClick="fnAddRole();" ></span>
        	   	&nbsp;
        	   	<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDeleteRoleAss()" ></span>
        	</c:if>
       </li>
    </div>    
	<div id="gridDiv" style="width:100%;" class="clear" >
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<div  id="roleDetail" style="display:none;">
	<table class="tbl_blue01 mgT10 mgB5" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
		<colgroup>
			<col width="15%">
		    <col width="35%">
		    <col width="15%">
		 	<col width="15%">
		 	<col width="10%">
		 	<col width="10%">
		 	<col width="10%">
		</colgroup>		
		<tr>
			<th class="last pdL10">${menu.LN00004}</th>			
			<th class="last pdL10">${menu.LN00202}</th>
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
			</td>
			<td class="last">
				<input style= "border:0px;"  type="text" class="text" id="path" name="path" readOnly />
				<input type="hidden" class="text" id="itemID" name="itemID" />
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
	</table>
	<div class="countList pdT5 pdB5 " >
        <li class="floatR">
         	   	<span id="viewSave" class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="fnSaveRoleAss()"></span>&nbsp;
       	</li>
        </li>
    </div>   
    </div> 
</form>
<div style="width:0px;height:0px;display:none;">
<iframe id="saveRoleFrame" name="saveRoleFrame" style="width:0px;height:0px;display:none;"></iframe>
</div>
</div>