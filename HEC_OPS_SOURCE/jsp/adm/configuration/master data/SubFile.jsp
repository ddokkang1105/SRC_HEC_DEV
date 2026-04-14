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
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 260)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 260)+"px;");
		};
		gridOTInit();
		doOTSearchList();
	});	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

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
		result.key = "config_SQL.SubFileTab";
		result.header = "${menu.LN00024},#master_checkbox,FltpCode,Name,FilePath,LinkType,ItemClassCode";	
		result.cols = "CHK|FltpCode|Name|FilePath|LinkType|ItemClassCode"; 
		result.widths = "50,50,150,150,200,80,80"; 
		result.sorting = "int,int,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center";	
		result.data = "&languageID=${languageID}&ItemClassCode=${s_itemID}";		
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
		var url = "addFileAllocPop.do";
		var data = "&TypeCode=${s_itemID}" + 
					"&languageID=${languageID}"+ 
					"&ItemTypeCode=${ItemTypeCode}" +
					"&ClassName=" + escape(encodeURIComponent('${ClassName}'));
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
					var url = "DeleteFileType.do";
					var data = "&FltpCode=" + p_gridArea.cells(checkedRows[i], 2).getValue()+ "&ItemClassCode=${s_itemID}";					
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
		var data = "&ItemClassCode=${s_itemID}&LanguageID=${languageID}"
					+ "&CategoryCode=${CategoryCode}&ItemTypeCode=${ItemTypeCode}&pageNum=${pageNum}";
		ajaxPage(url,data,target);
	}

	function urlReload(){
		var url = "SubFile.do";
		var data = "&languageID=${languageID}&s_itemID=${s_itemID}&ClassName=${ClassName}"
					+ "&CategoryCode=${CategoryCode}&ItemTypeCode=${ItemTypeCode}&pageNum=${pageNum}";
		var target = "ArcFrame";
		ajaxPage(url, data, target);
	}
	
	function gridOnRowSelect(id, ind){
		var fltpCode = p_gridArea.cells(id, 2).getValue();
		var fltpName = p_gridArea.cells(id, 3).getValue();
		var linkType = p_gridArea.cells(id, 5).getValue();
		var itemClassCode = p_gridArea.cells(id, 6).getValue();
	
		$("#fltpCode").val(fltpCode);
		$("#fltpName").val(fltpName);
		$("#linkType").val(linkType);
		$("#itemClassCode").val(itemClassCode);		
		$("#linkTypeDiv").attr("style","visibility:visible");
	}
	
	function fnSaveLinkType(){
		if(confirm("${CM00001}")){	
			var fltpCode = $("#fltpCode").val();
			var linkType = $("#linkType").val();
			var itemClassCode = $("#itemClassCode").val();
			
			var url = "updateFltpAlloc.do";
			var data = "&itemClassCode="+itemClassCode
						+ "&fltpCode="+fltpCode
						+ "&linkType="+linkType;
			var target = "ArcFrame";
			ajaxPage(url, data, target);
		}
	}
	
	

</script>
</head>
<body>
	<form name="FileTypeList" id="FileTypeList" action="*" method="post" onsubmit="return false;">
		<div class="cfgtitle">
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;${ClassName}</li>
		</div>
		<div class="child_search mgL10 mgR10">	
			<li class="floatR pdR20">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">			
				<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="submit" onclick="Back()"></span>
				<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="AddFileType()"></span>
				<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="DeleteFileType()"></span>
				</c:if>
			</li>
		</div>		
		<div id="gridDiv" class="mgT10 mgL10 mgR10">
			<div id="grdGridArea" style="width:100%"></div>
		</div>	
		<div class="mgT10 mgL10 mgR10" id="linkTypeDiv" style="visibility:hidden;">
			<table class="tbl_blue01" width="100%" border="0">
				<colgroup>
					<col width="10%">
					<col width="20%">
					<col width="10%">
					<col width="20%">
					<col width="10%">
					<col width="30%">
				</colgroup>
				<tr>
					<th class="viewtop">FltpCode</th> 
					<td class="viewtop">
						<input type="text" id="fltpCode" name="fltpCode" value="" style="width: 80%;border:0px;"/> 
						<input type="hidden" id="itemClassCode" name="itemClassCode" value=""/>
					</td>
					<th class="viewtop">FileName</th>
					<td class="viewtop"><input type="text" id="fltpName" name="fltpName" value="" style="width: 80%;border:0px;"/></td>
					<th class="viewtop">LinkType</th>
					<td class="viewtop last">
						<select class="sel" id="linkType" name="linkType">
							<option value="01">01</option>
							<option value="02">02</option>
						</select>
					</td>					
				</tr>
			</table>
			<div class="alignBTN">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
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