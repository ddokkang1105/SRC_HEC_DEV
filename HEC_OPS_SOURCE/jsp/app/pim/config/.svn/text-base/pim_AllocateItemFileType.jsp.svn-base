<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

<!-- 2. Script -->
<script type="text/javascript">

	var p_gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용

	$(document).ready(function() {
		gridOTInit();
		doOTSearchList();
	});	
	
	function gridOTInit(){		
		var d = setOTGridData();		
		p_gridArea = fnNewInitGrid("grdGridArea", d);	
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.setColumnHidden(6, true);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});	
	}

	function setOTGridData(){
		var result = new Object();
		result.title = "${title}";	
		result.key = "procConfig_SQL.getItemFileType";
		result.header = "${menu.LN00024},#master_checkbox,FltpCode,Name,FilePath,LinkType,ItemID,Mandatory,Authority";	
		result.cols = "CHK|FltpCode|Name|FilePath|LinkType|ItemID|Mandatory|Authority"; 
		result.widths = "50,50,150,150,200,80,80,80,80"; 
		result.sorting = "int,int,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,center,center";	
		result.data = "&languageID=${languageID}&s_itemID=${s_itemID}";		
		return result;
	}
	
	function setSearchTeam(teamID,teamName){
		$('#ownerTeamCode').val(teamID);
		$('#teamName').val(teamName);
	}

	//조회
	function doOTSearchList(){
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
		$("#linkTypeDiv").attr("style","visibility:hidden");
	}
	
	function AddFileType(){	
		var url = "pim_AddAllocItemFilePop.do";
		var data = "&s_itemID=${s_itemID}" + 
				    "&varFilter=${varFilter}" +
					"&languageID=${languageID}";
		url += "?" + data;
		var option = "width=920,height=600,left=300,top=100,toolbar=no,status=no,resizable=yes";
	    window.open(url, self, option);
	}

	function DeleteFileType(){		
		if (p_gridArea.getCheckedRows(1).length == 0){
			alert("${WM00023}");	
		} else {
			if (confirm("${CM00004}")) {
				var checkedRows = p_gridArea.getCheckedRows(1).split(",");
				for ( var i = 0; i < checkedRows.length; i++) {
					var url = "pim_DeleteAllocItemFileType.do";
					var data = "&FltpCode=" + p_gridArea.cells(checkedRows[i], 2).getValue()+ "&s_itemID=${s_itemID}";					
					if (i + 1 == checkedRows.length) {
						data = data + "&FinalData=Final";
					}
					var target = "ArcFrame";
					ajaxPage(url, data, target);	
				}
			}
		}
	}

	function urlReload(){
		var url = "pim_AllocateItemFileType.do";
		var data = "&languageID=${languageID}&s_itemID=${s_itemID}&pageNum=${pageNum}&varFilter=${varFilter}";
		var target = "ArcFrame";
		ajaxPage(url, data, target);
	}
	
	function gridOnRowSelect(id, ind){
		var fltpCode = p_gridArea.cells(id, 2).getValue();
		var fltpName = p_gridArea.cells(id, 3).getValue();
		var linkType = p_gridArea.cells(id, 5).getValue();
	
		$("#fltpCode").val(fltpCode);
		$("#fltpName").val(fltpName);
		$("#linkType").val(linkType);
		$("#linkTypeDiv").attr("style","visibility:visible");
		
		if(p_gridArea.cells(id, 7).getValue()=='1'){
			$("#objMandatory").attr('checked',true);
		}else{
			$("#objMandatory").attr('checked',false);
		}
	}
	
	function fnSaveLinkType(){
		if(confirm("${CM00001}")){	
			var fltpCode = $("#fltpCode").val();
			var linkType = $("#linkType").val();
			if($("#objMandatory").is(":checked") == true){
				$("#objMandatory").val("1");
			}else{
				$("#objMandatory").val("0");
			}
			
			var url = "pim_UpdateAllocItemFileType.do";
			var data = "&s_itemID=${s_itemID}"
						+ "&fltpCode="+fltpCode
						+ "&linkType="+linkType
						+"&objMandatory="+$("#objMandatory").val();
			var target = "ArcFrame";
			ajaxPage(url, data, target);
		}
	}
	
	

</script>
</head>
<body>
	<form name="FileTypeList" id="FileTypeList" action="*" method="post" onsubmit="return false;">
		<div class="child_search">	
			<li class="floatR pdR20">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor' && configSTS != 'CLS'}">			
				<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="AddFileType()"></span>
				<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="DeleteFileType()"></span>
				</c:if>
			</li>
		</div>		
		<div id="gridDiv" class="mgT10">
			<div id="grdGridArea" style="height:130px; width:100%"></div>
		</div>	
		<div class="mgT10" id="linkTypeDiv" style="visibility:hidden;">
			<table class="tbl_blue01" width="100%" border="0">
				<colgroup>
					<col width="10%">
					<col width="15%">
					<col width="10%">
					<col width="15%">
					<col width="10%">
					<col width="20%">
					<col width="10%">
					<col width="10%">
				</colgroup>
				<tr>
					<th class="viewtop">FltpCode</th> 
					<td class="viewtop">
						<input type="text" id="fltpCode" name="fltpCode" value="" style="width: 80%;border:0px;"/> 
					</td>
					<th class="viewtop">FileName</th>
					<td class="viewtop"><input type="text" id="fltpName" name="fltpName" value="" style="width: 80%;border:0px;"/></td>
					<th class="viewtop">LinkType</th>
					<td class="viewtop last"><input type="text" id="linkType" name="linkType" value="" style="width: 80%;"></td>
					<th class="viewtop">Mandatory</th>
					<td class="viewtop"><input type="checkbox" id="objMandatory" name="objMandatory"
						<c:if test="${Mandatory == '1'}">
						checked="checked" 
						</c:if> />
					</td>					
				</tr>
			</table>
			<div class="alignBTN">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor' && configSTS != 'CLS'}">
				&nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="fnSaveLinkType();"></span>
			</c:if>
		</div>	
		</div>
		
	</form>
		<div class="schContainer" id="schContainer">
			<iframe name="ArcFrame" id="ArcFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
		</div>
	
	</body>
</html>