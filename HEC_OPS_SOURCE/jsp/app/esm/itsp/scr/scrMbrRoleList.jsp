<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00163" var="WM00163" arguments='"+headerNM+"'/>

<script>
	var p_gridArea; //그리드 전역변수
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 540)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 540)+"px;");
		};
		
		gridInit();		
		doSearchList("roleList");
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
		
	function doSearchList(scrnType){
		var d = setGridData(scrnType);
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	function gridInit(){	
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);	
		fnSetColType(p_gridArea, 1, "ch");
		
		//START - PAGING
// 		p_gridArea.enablePaging(true, 10, null, "pagingArea", true, "recinfoArea");
// 		p_gridArea.setPagingSkin("bricks");
// 		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
		//END - PAGING
		
		dp = new dataProcessor("updateSCRMembers.do?scrId=${scrId}&scrnType=P"); // lock feed url
		dp.enableDebug(true);
		//dp.enableDataNames(true); // will use names instead of indexes
		dp.setTransactionMode("POST",true); // set mode as send-all-by-post
		dp.setUpdateMode("off"); // disable auto-update
		
		dp.init(p_gridArea); // link dataprocessor to the grid  
	}
	
	function setGridData(scrnType){
		var result = new Object();
		result.title = "${title}";
		result.key =  "scr_SQL.getSCRMbrRoleList";
		result.header = "${menu.LN00024},#master_checkbox,Name,Position,${menu.LN00202},MemberID,CNT,공수(M/D),업무설명";
		result.cols = "CHK|UserName|Position|TeamPath|MemberID|CNT|PlanManDay|RoleDescription";
		result.widths = "30,30,100,100,250,0,0,120,*";
		result.sorting = "int,int,str,str,str,str,str,int,str";
		result.aligns = "center,center,center,center,left,center,left,center,left";
		<c:choose>
			<c:when test="${scrUserID eq sessionScope.loginInfo.sessionUserId && scrStatus eq 'EDT'}">
				result.types = "ro,ro,ro,ro,ro,ro,ro,ed,ed";
			</c:when>
			<c:otherwise>
				result.types = "ro,ro,ro,ro,ro,ro,ro,ro,ro";
			</c:otherwise>
		</c:choose>
		result.data = "scrId=${scrId}";
		
		if(scrnType == "" || scrnType == "undefined" || scrnType == null ){
			result.data += "&scrnType=P";
		}
		return result;
	}
	
	function fnSaveGridData(){
		var res = /^[0-9]+$/;
		for (var rid = 1; rid  <= p_gridArea.getRowsNum(); rid ++) {
			var planManDays = p_gridArea.cells(rid,7).getValue();
			if (planManDays != ''){
				if (!res.test(planManDays)) {
					var headerNM = p_gridArea.getColLabel(7);
					alert("${WM00163}");
					p_gridArea.cells(rid,7).setValue("");
					return false;
				}
			}
		}
		dp.sendData(); 
	}
	
	function fnAfterUpdateSendData(){
		alert("${WM00067}");
		gridInit();
		doSearchList();
	}
	
	function fnAddSCRMbr(){
		var url = "searchSCRMbrPop.do?srId=${srID}&scrId=${scrId}&scrnType=new";
		window.open(url,'','width=800, height=700, left=100, top=200,scrollbar=yes,resizble=0');
	}
	

	// [Del] 버튼 Click
	function fnDelSCRMbr() {
		if(p_gridArea.getCheckedRows(1).length == 0){
			alert("${WM00023}");
		} else {
			if(confirm("${CM00004}")){
				var checkedRows = p_gridArea.getCheckedRows(1).split(",");	
				var memberIds =""; 
				
				for(var i = 0 ; i < checkedRows.length; i++ ){
					var count = p_gridArea.cells(checkedRows[i], 6).getValue();
					if (count > 0) {
						var id = "LoginID : " + p_gridArea.cells(checkedRows[i], 2).getValue();
						"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00134' var='WM00134' arguments='"+ id +"'/>"
						alert("${WM00134}");
						p_gridArea.cells(checkedRows[i], 1).setValue(0); 
					} else {
						if (memberIds == "") {
							memberIds = p_gridArea.cells(checkedRows[i], 5).getValue();
						} else {
							memberIds = memberIds + "," + p_gridArea.cells(checkedRows[i], 5).getValue();
						}
					}
				}
				if (memberIds != "") {
					var url = "delSCRMembers.do";
					var data = "memberIds=" + memberIds+"&scrId=${scrId}";
					var target = "saveFrame";
					ajaxPage(url, data, target);
				}
			}
		} 
	}
	
</script>
<form name="scrMbrFrm" id="scrMbrFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="memberIds" name="memberIds"  value="${memberIds}" />
	<input type="hidden" id="cngCount" name="cngCount"  value="${cngCountOfmember}" />
	<div style="overflow:auto;overflow-x:hidden;">
		<div class="countList">
        	<li class="count">Total  <span id="TOT_CNT"></span></li>
        	<c:if test="${scrUserID eq sessionScope.loginInfo.sessionUserId && scrStatus eq 'EDT'}">
        	<li class="floatR mgR10">
				<span class="btn_pack medium icon"><span class="add"></span><input value="Add" onclick="fnAddSCRMbr()" type="submit"></span>&nbsp;
				<span class="btn_pack small icon"><span class="save"></span><input value="Save" type="submit" onclick="fnSaveGridData()"></span>&nbsp;
				<span class="btn_pack medium icon"><span class="del"></span><input value="Del" onclick="fnDelSCRMbr()" type="submit"></span>
			</li>
			</c:if>
        </div>
		<div id="gridDiv" class="mgB10 clear" align="center">
			<div id="grdGridArea" style="width:100%;"></div>
		</div>
		<!-- START :: PAGING -->
<!-- 		<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>	 -->
	</div>
</form>