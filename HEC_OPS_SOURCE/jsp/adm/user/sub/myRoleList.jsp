<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 관리자 : 사용자 -My Dimension 관리 -->
 
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
 
<script type="text/javascript">
	var p_gridArea, role_gridArea;				//그리드 전역변수
	var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
	fnSelect('assignmentType', '&actorType=USER&languageID='+languageID, 'getAssignment', "", 'Select');
	$(document).ready(function() {
		if("${scrnType}" == "mySpace"){
			$("#grdGridArea").innerHeight(document.body.clientHeight - 120);
			window.onresize = function() {
				$("#grdGridArea").innerHeight(document.body.clientHeight - 120);
			};
		} else {
			$("#grdGridArea").innerHeight(document.body.clientHeight - 340);
			window.onresize = function() {
				$("#grdGridArea").innerHeight(document.body.clientHeight - 340);
			};
		}
		
		$("#assigned").change(function(){
	        var chk = $(this).is(":checked");
	        if(chk){ $(this).prop('checked', true); 
	        }else{  $(this).prop('checked', false); }
	        
	        doSearchList();
	    });
		gridInit();
		doSearchList();
	});	
	
	function gridInit(){		
		var d = setGridData();		
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.attachEvent("onRowSelect", function(id,ind){
			gridOnRowSelect(id,ind);
		});
	}	
	
	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "role_SQL.getMyAssignedRoleList";
		result.header = "${menu.LN00024},Role Category,Role,${menu.LN00149},${menu.LN00016},${menu.LN00087},${menu.LN00078},Order,Active,ItemID";
		result.cols = "AssignmentTypeName|RoleTypeTxt|AccessRightName|className|itemPath|AssignedDate|OrderNum|Assignment|ItemID";
		result.widths = "50,160,110,130,100,*,130,80,80,0";
		result.sorting = "str,str,str,str,str,str,str,str,str,int";
		result.aligns = "center,center,center,center,center,left,center,center,center,left";
		result.data = "memberId=${memberID}&languageID="+languageID;
		
		if($("#assignmentType").val() != '' & $("#assignmentType").val() != null){
			result.data += "&assignmentType="+ $("#assignmentType").val();
		}
		if($("#assigned").is(":checked") == true){
			result.data += "&assigned=1";
		}
		
		
		return result;
	}
	
	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}	
	
	//그리드ROW선택시
	function gridOnRowSelect(id, ind){
		var itemId = p_gridArea.cells(id, 9).getValue();
		if(itemId=="" || itemId=="0"){return;}
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId+"&scrnType=pop&screenMode=pop";
		var w = 1200;
		var h = 850;
		itmInfoPopup(url,w,h,itemId);
	}
	
	
	
	function doCallBack(){}
	
	
</script>
<c:if test="${scrnType eq 'mySpace' }">
	<h3 class="pdT10 pdB10" style="border-bottom:1px solid #ccc;  "><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic" />&nbsp;${menu.LN00119}</h3>
</c:if>
<div class="child_search01 pdT10 pdB10">
	<ul>
		<li class="mgL10" style="font-weight:bold;">Role Category</li>
		<li class="mgL10">
		      <select id="assignmentType" Name="assignmentType"></select> 
		  	  <input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchList();" value="검색" style="cursor:pointer;">   
		</li>
		<li class="mgL10 floatR">
			<input type="checkbox" id="assigned" name="assigned" checked >&nbsp;Active
		</li>
	</ul>
</div>
<!-- BIGIN :: LIST_GRID -->
<div id="gridDiv">
	<div id="grdGridArea" style="width:100%;"></div>
</div>
<!-- END :: LIST_GRID -->

<!-- START :: FRAME --> 		
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" frameborder="0" style="display:none"></iframe>
</div>	
<!-- END :: FRAME -->