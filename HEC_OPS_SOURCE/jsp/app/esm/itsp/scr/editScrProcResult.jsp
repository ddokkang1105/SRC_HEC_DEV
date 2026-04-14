<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00163" var="WM00163" arguments='"+headerNM+"'/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>

<style>
	.tdhidden{display:none;}
</style>
<script>
	var p_gridArea; //그리드 전역변수

	$(document).ready(function(){
		fnSelectNone('closingCode', '&Category=SCRCLSCD', 'CategroyTypeCode', '${scrInfo.ClosingCode}');
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 540)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 540)+"px;");
		};
		
		gridInit();		
		doSearchList();
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	function gridInit(){	
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);	
		fnSetColType(p_gridArea, 1, "ch");
				
		dp = new dataProcessor("updateSCRMembers.do?scrId=${scrId}&scrnType=A"); // lock feed url
		dp.enableDebug(true);
		//dp.enableDataNames(true); // will use names instead of indexes
		dp.setTransactionMode("POST",true); // set mode as send-all-by-post
		dp.setUpdateMode("off"); // disable auto-update
		
		dp.init(p_gridArea); // link dataprocessor to the grid  
	}
	
	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key =  "scr_SQL.getSCRMbrRoleList";
		result.header = "${menu.LN00024},#master_checkbox,Name,Position,${menu.LN00202},MemberID,CNT,공수(M/D),업무설명";
		result.cols = "CHK|UserName|Position|TeamPath|MemberID|CNT|ActualManDay|RoleDescription";
		result.widths = "30,30,100,100,200,0,0,120,400";
		result.sorting = "int,int,str,str,str,str,str,int,str";
		result.aligns = "center,center,center,center,left,center,left,center,left";
		result.types = "ro,ro,ro,ro,ro,ro,ro,ed,ed";
		result.data = "scrId=${scrId}";
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
	
	function fnSaveScrProcResult() {
		var headerNM = $(".tbl_preview tr th:nth-child(5)").text();
		if (confirm("${CM00001}")) {
			var res = /^[0-9]+$/;
			var size = $("input[name^='actualMD']").size();
			for (var i = 0; i < size; i ++) {
				var actualManDay = $("input[name^='actualMD']").eq(i).val();
				if (!res.test(actualManDay)) {
					alert("${WM00163}");
					$("input[name^='actualMD']").eq(i).val("");
					$("input[name^='actualMD']").eq(i).focus();
					return false;
				}
			}
			fnSaveGridData();
			var url = "saveScrProcResult.do?scrId=${scrId}";
			ajaxSubmit(document.scrResultFrm, url,"saveFrame");
		}
	}
	
	function fnAddSCRMbr(){
		var url = "searchSCRMbrPop.do?srId=${srID}&scrId=${scrId}";
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
	
	function fnCallBack(){
		var url = "viewScrProcResult.do";
		var data = "scrID=${scrId}&scrUserID=${scrInfo.RegUserID}&scrStatus=${scrInfo.Status}";
		var target = "scrResultFrm";
		ajaxPage(url, data, target);
	}
</script>
<form name="scrResultFrm" id="scrResultFrm" action="#" method="post" onsubmit="return false;">
	<div class="floatC" style="overflow:auto;overflow-x:hidden;">
		<div class="floatR mgR10 mgB10">
			<span class="btn_pack small icon"><span class="save"></span><input value="Save" type="submit" onclick="fnSaveScrProcResult()"></span>
		</div>
		<table class="cb_module tbl_blue01 mgT10" style="table-layout:fixed;" width="98%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="15%">
				<col width="35%">
				<col width="15%">
				<col width="35%">
			</colgroup>
			<tr>
				<th class="alignL pdL10 viewline">종료코드</th>
				<td class="last">
					<select name="closingCode" id="closingCode" style="width:100%;"></select>
				</td>
				<th class="alignL pdL10 viewline">실제투입공수(M/D)</th>
				<td class="last"><input type="text" class="text" name="actualMD" value="${scrInfo.ActualManDay}"></td>
			</tr>
			<tr>
				<th class="alignL pdL10 viewline">처리내용</th>
				<td colspan=3 class="last"><textarea class="edit" name="changeNotice" style="width:100%;height:50px;background: #fff;">${scrInfo.ChangeNotice}</textarea></td>
			</tr>
		</table>
		<div class="countList">
			<li class="floatL mgL10" style="font-weight:700;">실제투입인력</li>
        	<li class="floatR mgR10">
				<span class="btn_pack medium icon"><span class="add"></span><input value="Add" onclick="fnAddSCRMbr()" type="submit"></span>&nbsp;
				<span class="btn_pack medium icon"><span class="del"></span><input value="Del" onclick="fnDelSCRMbr()" type="submit"></span>
			</li>
		</div>
		<div id="gridDiv" class="mgB10 clear" align="center">
			<div id="grdGridArea" style="width:100%;"></div>
		</div>
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display: none;" ></iframe>