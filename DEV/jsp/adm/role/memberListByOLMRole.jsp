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
		
		$("#memberName").keypress(function(){
			if(event.keyCode == '13') {
				searchPopupWf('searchPluralNamePop.do?objId=memberID&objName=memberName');
				
				return false;
			}			
		});
		$("#TOT_CNT").html(grid.data.getLength());
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

/* 	function fnAddRole(){		
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
		if("${assignmentType}" != ""){ $("#assignmentType").attr('disabled', 'true'); }
		
	} */
	
	function fnRoleCallBack(){
		fnReload();
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
		$("#mbrTeamID").val(avg4);
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
					+"&mbrTeamID="+mbrTeamID;
		ajaxPage(url, data, target);
	}
	
	
</script>
<body>
<div id="roleAssignDiv" >
<form name="roleFrm" id="roleFrm" action="" method="post" onsubmit="return false;">
	<div class="countList" style="margin: 3px 0px 3px 0;" >
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
        	<c:if test="${itemIDAuthorID == sessionScope.loginInfo.sessionUserId || sessionScope.loginInfo.sessionAuthLev == 1}" >
        	<!-- <span class="btn_pack nobg "><a class="add" onclick="fnAddRole();" title="Add"></a></span> -->
        	   	<span class="btn_pack nobg white"><a class="del" onclick="fnDeleteRoleAss()" title="Delete"></a></span>
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
	
	var grid;
	var pagination;
	var gridData = ${gridData};
	
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
	        { width: 150, id: "AssignmentTypeName", header: [{ text: "Role Category", align:"center" }, { content: "selectFilter" }]},
	        { width:110, id: "ProcessType", header: [{text: "Role Type", align:"center"}, { content:"selectFilter"}]},
	        { width: 80, id: "AccessRightName", header: [{ text: "${menu.LN00149}", align:"center" }, { content: "selectFilter" }], align:"center"},
	        { width: 200, id: "Path", header: [{ text: "조직 경로", align:"center" }, { content: "inputFilter" }], align:"left" },
	        { width: 80, id: "ClassName", header: [{ text: "클래스", align:"center" }, { content: "selectFilter" }], align:"left" },
	        { width: 100, id: "ProcessCode", header: [{ text: "코드", align:"center" }, { content: "inputFilter" }], align:"left" },
	        { width: 150, id: "ProcessNM", header: [{ text: "명칭", align:"center" }, { content: "inputFilter" }], align:"left" },
	        { id: "ProcessPath", header: [{ text: "경로", align:"center" }, { content: "inputFilter" }], align:"left" },
	        { width: 110, id: "AssignedDate", header: [{ text: "${menu.LN00078}", align:"center" }, { content: "selectFilter" }], align:"center"},
	        { width: 70, id: "OrderNum", header: [{ text: "Order", align:"center" }, { content: "selectFilter" }], align:"center", htmlEnable: true},
	        { width: 80, id: "Assignment", header: [{ text: "Active", align:"center" }, { content: "selectFilter"}], align:"center" },
	        { width: 80, id: "Seq", header: [{ text: "Seq", align:"center" }, { content: "selectFilter" }], hidden:true }
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
			 $("#memo").val(row.Memo);
			 $("#mbrTeamID").val(row.TeamID);
			
			 $("#memberName").attr('readOnly', 'true');
			 $("#roleDetail").attr('style', 'display: done');
			 $("#searchMemberBtn").attr('style','display : none');
			
			 var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&assignmentType="+row.AssignmentType;
			 fnSelect('roleType', data, 'getOLMRoleType', roleType, 'Select');
			 fnSelect('assignmentType', data+'&actorType=USER', 'getAssignment', row.AssignmentType, 'Select');
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
	
 	function fnReload(){ 
		var sqlID = "role_SQL.getOlmRoleMbrList";
		var param = "&itemID=${s_itemID}"
				+ "&assignmentType=${assignmentType}"
				+ "&isAll=N&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+ "&blankPhotoUrlPath=${blankPhotoUrlPath}"
				+ "&photoUrlPath=${photoUrlPath}"
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
 		grid.data.parse(newGridData);
 		$("#TOT_CNT").html(grid.data.getLength());
 	}
 	 	
 	const changeEvent = document.createEvent("HTMLEvents");
 	changeEvent.initEvent("change", true, true);
 	
	var headerFilter = grid.getHeaderFilter("Assignment");
    var element;
    
    element = headerFilter.querySelector("select");
    element.value = "Y";
    element.dispatchEvent(changeEvent);
 		
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
 	
</script>