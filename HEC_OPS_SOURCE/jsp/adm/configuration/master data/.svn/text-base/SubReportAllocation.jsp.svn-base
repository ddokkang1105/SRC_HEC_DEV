<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:url value="/" var="root" />
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

<!-- 2. Script -->
<script type="text/javascript">

	var p_gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {
		gridOTInit();
		doOTSearchList();
	});	
	
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit(){		
		var d = setOTGridData();		
		p_gridArea = fnNewInitGrid("grdGridArea", d);	
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		
	}
	
	function setOTGridData(){	
		var result = new Object();
		result.title = "${title}";		
		result.key = "config_SQL.getClassReportLocateList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00015},Report Type,OutPut Type,${menu.LN00028},${menu.LN00035},VarFilter,SortNum";
		result.cols = "CHK|ReportCode|ReportType|OutputType|Name|Description|VarFilter|SortNum"; 		
		result.widths = "50,50,80,100,100,160,250,200,80";
		result.sorting = "int,int,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,left,left,left,center";
		result.data =  "ClassCode=${classCode}"	
			 		+ "&LanguageID=${languageID}";		 		
		//alert(result.data);
		return result;
	}
	
	function setSearchTeam(teamID,teamName){
		$('#ownerTeamCode').val(teamID);
		$('#teamName').val(teamName);
	}
	
	// END ::: GRID	
	//===============================================================================
		
	//조회
	function doOTSearchList(){
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	function AddReportTypeTab(){
		var url = "addReportCodeAlloc.do";
		var data = "&ClassCode=${classCode}" + 
					"&languageID=${languageID}" +
					"&ItemTypeCode=${ItemTypeCode}" +
					//"&ClassName=${ClassName}";
					"&ClassName=" + escape(encodeURIComponent('${ClassName}'));
		url += "?" + data;
		var option = "width=920,height=600,left=300,top=100,toolbar=no,status=no,resizable=yes";
	    window.open(url, self, option);
	}
	
	function DeleteReportType(){		
		if (p_gridArea.getCheckedRows(1).length == 0){
			alert("${WM00023}");
		} else {
			if (confirm("${CM00004}")) {
				var checkedRows = p_gridArea.getCheckedRows(1).split(",");
		
				for ( var i = 0; i < checkedRows.length; i++) {
					
					var url = "DeleteReportType.do";
	
					var data = "&ReportCode=" + p_gridArea.cells(checkedRows[i], 2).getValue() 
									+ "&ClassCode=${classCode}";
					
					if (i + 1 == checkedRows.length) {
						data = data + "&FinalData=Final";
					}
	
					var target = "ArcFrame";
			
					ajaxPage(url, data, target);	
				}
			}
		}
	}
	
	function Back(){
		var url = "ClassTypeView.do";
		var target = "classTypeDiv";
		var data = "&ItemClassCode=${classCode}&LanguageID=${languageID}"
				+ "&CategoryCode=${CategoryCode}&ItemTypeCode=${ItemTypeCode}&pageNum=${pageNum}";
		
		ajaxPage(url,data,target);
	}
	
	function urlReload(){
		var url = "SubReportAllocation.do";
		var data = "&languageID=${languageID}&classCode=${classCode}&ClassName=${ClassName}"
				+ "&CategoryCode=${CategoryCode}&ItemTypeCode=${ItemTypeCode}&pageNum=${pageNum}";
		var target = "ArcFrame";
		
		ajaxPage(url, data, target);
	}
	
	function gridOnRowSelect(id, ind){ 
		var reportCode =  p_gridArea.cells(id, 2).getValue(); 
		var varFilter =  p_gridArea.cells(id, 7).getValue().replace(/&amp;/g,"&");
		var sortNum = p_gridArea.cells(id, 8).getValue(); 
		$("#reportCode").val(reportCode);
		$("#varFilter").val(varFilter);
		$("#sortNum").val(sortNum);
		$("#varFilterTbl").attr('style', 'visibility:visible;');
	}
	
	function fnSaveVarFilter(){		
		if(!confirm("${CM00001}")){ return;}		
		var url = "updateReportAllocInfo.do?classCode=${classCode}&classCodeYN=Y"; 
		var target = "ArcFrame";
		ajaxSubmit(document.SubReportTypeList, url, "ArcFrame");
	}
	
	function fnCallBack(){
		$("#varFilterTbl").attr('style', 'visibility:hidden;');
		doOTSearchList();
	}
	
</script>
<body>
	<div id="reportAllocDiv" class="hidden" style="width:100%;height:100%;">	
	<form name="SubReportTypeList" id="SubReportTypeList" action="#" method="post" onsubmit="return false;">
	
		<div class="cfgtitle">
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;${ClassName}</li>
		</div>
		<div class="child_search mgL10 mgR10">	
			<li class="floatR pdR20">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">		
					<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="submit" onclick="Back()"></span>	
					<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="AddReportTypeTab()"></span>
					<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="DeleteReportType()"></span>			
				</c:if>
			</li>
		</div>
		<div id="gridDiv" class="mgT10 mgL10 mgR10">
			<div id="grdGridArea" style="height:300px; width:100%"></div>
		</div>
		
		<table id="varFilterTbl" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" style="visibility:hidden;" >
			<tr>
				<th class="viewtop last">VarFilter</th>
				<td class="viewtop last">
					<input type="text" class="text" id="varFilter" name="varFilter" />
					<input type="hidden" id="reportCode" name="reportCode" >
				</td>
				<th class="viewtop last">SortNum</th>
				<td class="viewtop last">
					<input type="text" class="text" id="sortNum" name="sortNum" />
				</td>
				<td class="viewtop last">
					<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnSaveVarFilter()"  type="submit"></span>&nbsp;
				</td>
			</tr>		
		</table>
	</form>
	</div>
		<!-- START :: FRAME -->
		<div class="schContainer" id="schContainer">
			<iframe name="ArcFrame" id="ArcFrame" src="about:blank"
				style="display: none" frameborder="0" scrolling='no'></iframe>
		</div>
</body>
	
</html>