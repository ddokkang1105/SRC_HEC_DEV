<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />

<!-- 2. Script -->
<script type="text/javascript">

var p_gridArea;				//그리드 전역변수
var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용

	$(document).ready(function() {	
		gridOTInit();
		doOTSearchList();
		
		var myCP;
		myCP = dhtmlXColorPicker(["fontColor","strokeColor","fillColor","labelBackgroundColor"]);
		myCP.setColor([143,235,0]);
	});	
	
	function gridOTInit(){		
		var d = setOTGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR_ARC}/");
		p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowSelect(id,ind);
		});
		
		p_gridArea.setColumnHidden(20, true);
	}
	
	function setOTGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "config_SQL.getAttrTypeDpList";
		result.header = "${menu.LN00024},#master_checkbox,Category,AttrTypeCode,DisplayType,X,Y,Width,Height,FontSize,FontColor,FontFamily,AttrTypeCode,HTML,FontStyle,StrokeWidth,StrokeColor,FillColor,LabelBackgroundColor,ScrnMode,MDPID";
		result.cols = "CHK|Category|Name|DisplayType|X|Y|Width|Height|FontSize|FontColor|FontFamily|AttrTypeCode|HTML|FontStyle|StrokeWidth|StrokeColor|FillColor|LabelBackgroundColor|ScrnMode|MDPID"; 
		result.widths = "50,50,100,100,100,70,70,70,70,70,80,100,0,0,0,0,0,0,0,0";
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&symTypeCode=${symTypeCode}&Category=${Category}";
		return result;
	}

	function doOTSearchList(){
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}

	function fnGoBack(){
		var url = "symbolTypeDetail.do";
		var target = "allocSymTypeAttrDpForm";
		var data = "&SymTypeCode=${symTypeCode}&LanguageID=${languageID}&viewType=E";
		ajaxPage(url,data,target);
	}
	
	function Back(){
		var url = "modelTypeView.do";
		var target = "ModelTypeList";
		var data = "&ModelTypeCode=${symTypeCode}&LanguageID=${LanguageID}" + "&pageNum="+ $("#CurrPageNum").val() + "&Name=${Name}"; 
		ajaxPage(url,data,target);
	}
	
	function fnAddNewAttrDp(){
		$("#editSymTypeAttrDp").attr('style', 'display: block');	
		$("#saveBtn").attr('style', 'display: block');	
		$("#attrTypeCode").attr('style', 'boder:1px');
	//	$("#attrTypeCode").attr('readonly', false);
		
		
		$("#attrTypeCode").val("");
		$("#displayType").val("");
		$("#x").val("");
		$("#y").val("");
		$("#width").val("");
		$("#height").val("");
		$("#fontSize").val("");
		$("#fontColor").val("");
		$("#fontFamily").val("");
		$("#fontStyle").val("");
		$("#strokeWidth").val("");
		$("#strokeColor").val("");
		$("#fillColor").val("");
		$("#labelBackgroundColor").val("");
		$("#html").attr("checked",false);
		$("#newYN").val("Y");
	}
	
	function gridOnRowSelect(id, ind){
		var attrTypeCode = p_gridArea.cells(id, 12).getValue();
		var displayType = p_gridArea.cells(id, 4).getValue();
		var x = p_gridArea.cells(id, 5).getValue();
		var y = p_gridArea.cells(id, 6).getValue();
		var width = p_gridArea.cells(id, 7).getValue();
		var height = p_gridArea.cells(id, 8).getValue();
		var fontSize = p_gridArea.cells(id, 9).getValue();
		var fontColor = p_gridArea.cells(id, 10).getValue();
		var fontFamily = p_gridArea.cells(id, 11).getValue();
		var fontStyle = p_gridArea.cells(id, 14).getValue();
		var strokeWidth = p_gridArea.cells(id, 15).getValue();
		var strokeColor = p_gridArea.cells(id, 16).getValue();
		var fillColor = p_gridArea.cells(id, 17).getValue();
		var labelBackgroundColor = p_gridArea.cells(id, 18).getValue();
		var html = p_gridArea.cells(id, 13).getValue();
		var scrnMode = p_gridArea.cells(id, 19).getValue();
		var mdpID = p_gridArea.cells(id, 20).getValue();
		
		$("#editSymTypeAttrDp").attr('style', 'display: block');	
		$("#saveBtn").attr('style', 'display: block');	
	
	    $("#mdpID").val(mdpID);
		$("#attrTypeCode").val(attrTypeCode);
		$("#displayType").val(displayType); //수정값
		$("#DisplayType").val(displayType); //원래값
		$("#x").val(x);
		$("#y").val(y);
		$("#width").val(width);
		$("#height").val(height);
		$("#fontSize").val(fontSize);
		$("#fontColor").val(fontColor);
		$("#fontFamily").val(fontFamily);
		$("#fontStyle").val(fontStyle);
		$("#strokeWidth").val(strokeWidth);
		$("#strokeColor").val(strokeColor);
		$("#fillColor").val(fillColor);
		$("#labelBackgroundColor").val(labelBackgroundColor);
		$("#scrnMode").val(scrnMode);
		$("#newYN").val("N");
		if(html == "1"){
			$("#html").attr("checked",true);
		}else{
			$("#html").attr("checked",false);
		}
	}
	
	function CheckBox(){
		var html = document.getElementsByName("html");
		if(html[0].checked == true){
			$("#html").val("1");
		}else{
			$("#html").val("");
		}
	}
	
	function fnDeletAttrDp(){
		if(p_gridArea.getCheckedRows(1).length == 0){
			alert("${WM00023}");
			return;
		}else{
			if(confirm("${CM00004}")){
				var mdpIDs = new Array();
				var checkedRows = p_gridArea.getCheckedRows(1).split(",");
				var j = 0;
				for ( var i = 0; i < checkedRows.length; i++) {
					mdpIDs[j] = p_gridArea.cells(checkedRows[i],20).getValue(); 				
					j++;
				}
				var url = "deleteAttrDp.do";
				var data = "&mdpIDs="+mdpIDs;
				var target = "saveFrame";
				ajaxPage(url, data, target); 
			}
		}
	}
	
	function fnCallBack(){
		$("#editSymTypeAttrDp").attr('style', 'display: none');	
		$("#saveBtn").attr('style', 'display: none');	
		gridOTInit();
		doOTSearchList();
	}
	
	function fnSaveSymbolAttrDp(){
		if(confirm("${CM00001}")){			
			var url = "saveSymbolAttrDp.do";
			var target = "saveFrame";		
			ajaxSubmitNoAdd(document.allocSymTypeAttrDpForm, url, target);
		}
	}
	
</script>
<body>
<form name="allocSymTypeAttrDpForm" id="allocSymTypeAttrDpForm" action="*" method="post" onsubmit="return false;">
	<input type="hidden" id="symTypeCode" name="symTypeCode" value="${symTypeCode}">
	<input type="hidden" id="DisplayType" name="DisplayType" />
	<input type="hidden" id="newYN" name="newYN" >
	<input type="hidden" id="mdpID" name="mdpID" >
	<div class="cfgtitle" >					
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Allocation Symbol Display</li>
		</ul>
	</div>
	<div class="child_search mgB5 mgL10 mgR10">
		<ul>
			<li class="floatR pdR20">
			<c:if test="${sessionScope.loginInfo.sessionAuthLev == '1'}">
			&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit"  alt="New" onclick="fnAddNewAttrDp()" ></span>
			&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDeletAttrDp()" ></span>
			<c:if test="${Category == 'ELM'}">
				<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="submit" onclick="fnGoBack()"></span>
			</c:if>
			<c:if test="${Category == 'MDL'}">
				<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="submit" onclick="Back()"></span>
			</c:if>
					
			</c:if>	
			</li>
		</ul>
	</div>
	
	<div class="countList">
        <li class="count">Total  <span id="TOT_CNT"></span></li>
         <li class="floatR">&nbsp;</li>
    </div>		
	<div id="gridDiv" class="mgB10 mgL10 mgR10"">
	<div id="grdGridArea" style="height:210px; width:100%"></div>
	</div>
	
	<div id="editSymTypeAttrDp" name="editSymTypeAttrDp" class="mgT5 mgL10 mgR10" style="display:none">
	<table id="modSortNum" class="tbl_blue01" width="100%"   cellpadding="0" cellspacing="0">
		<tr>
			<th class="viewtop">${menu.LN00033}</th>
			<td class="viewtop">
				<input type="text" class="text" id="Category" name="Category" style="border:0px;background-color:#ffffff;" value="${Category}" readonly=true/>
			</td>
			<th class="viewtop">Attribute Type</th>
			<td class="viewtop"><input type="text" class="text" id="attrTypeCode" name="attrTypeCode"  /></td>
			<th class="viewtop">Display Type</th>
			<td class="viewtop">
				<select id="displayType" name="displayType" class="sel">
					<option value="">Select</option>
					<option value="ID">ID</option>
					<option value="Image">Image</option>
					<option value="Text">Text</option>
					<option value="Animation">Animation</option>
					<option value="MOT">MOT</option>
				</select>
			</td>
			<th class="viewtop">HTML</th>
			<td class="viewtop last"><input type="checkbox" name="html" id="html" onclick="CheckBox()" /></td>
		</tr>
		<tr>
			<th>X</th>
			<td><input type="number" class="text" id="x" name="x" /></td>
			<th>Y</th>
			<td><input type="number" class="text" id="y" name="y" /></td>
			<th>Width</th>
			<td><input type="number" class="text" id="width" name="width" /></td>
			<th>Height</th>
			<td class="last"><input type="number" class="text" id="height" name="height" /></td>
		</tr>
		<tr>
			<th>Font Size</th>
			<td><input type="number" class="text" id="fontSize" name="fontSize" /></td>
			<th>Font Color</th>
			<td><input type="text" class="text" id="fontColor" name="fontColor" /></td>
			<th>Font Style</th>
			<td><input type="number" class="text" id="fontStyle" name="fontStyle" /></td>
			<th>Font Family</th>
			<td class="last"><input type="text" class="text" id="fontFamily" name="fontFamily" /></td>
		</tr>
		<tr>
			<th>StrokeWidth</th>
			<td><input type="number" class="text" id="strokeWidth" name="strokeWidth" /></td>
			<th>StrokeColor</th>
			<td><input type="text" class="text" id="strokeColor" name="strokeColor" /></td>
			<th>FillColor</th>
			<td><input type="text" class="text" id="fillColor" name="fillColor" /></td>
			<th>LabelBackgroundColor</th>
			<td class="last"><input type="text" class="text" id="labelBackgroundColor" name="labelBackgroundColor" /></td>
		</tr>
		<tr>
			<th>ScrnMode</th>
			<td>
				<select id="scrnMode" name="scrnMode" class="sel">
					<option value="C">C</option>
					<option value="E">E</option>
					<option value="V">V</option>
				</select>
			</td>
			<td colspan=6 class="last"></td>
		</tr>
	</table>
	</div>	
	<div class="alignBTN pdR10" id="saveBtn" style="display: none;">
		<span class="btn_pack medium icon"><span  class="save"></span><input value="Save" onclick="fnSaveSymbolAttrDp()"  type="submit"></span>
	</div>
	<div class="schContainer" id="schContainer">
		<iframe name="saveFrame" id="saveFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
	</form>
</body>
</html>