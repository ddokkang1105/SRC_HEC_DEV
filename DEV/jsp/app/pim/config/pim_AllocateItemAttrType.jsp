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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

<!-- 2. Script -->
<script type="text/javascript">

var p_gridArea;				//그리드 전역변수
var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용

$(document).ready(function() {
	//Grid 초기화
	gridOTInit();
	doOTSearchList();
	fnSelect('dicCode', "&languageID=${languageID}&category=LN", 'getDictionary', '', 'Select');
});	

$('input[type="text"]').keypress(function(e) {
    if(e.which == 13) {
       return false;
    }
});

//===============================================================================
// BEGIN ::: GRID
//그리드 초기화
function gridOTInit(){		
	var d = setOTGridData();
	p_gridArea = fnNewInitGrid("grdGridArea", d);	
	fnSetColType(p_gridArea, 1, "ch");
	p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
	p_gridArea.setColumnHidden(10, true);
	p_gridArea.setColumnHidden(12, true);
	p_gridArea.setColumnHidden(13, true);
	p_gridArea.setColumnHidden(14, true);
	p_gridArea.setColumnHidden(15, true);
	p_gridArea.setColumnHidden(16, true);
	p_gridArea.setColumnHidden(17, true);
	p_gridArea.setColumnHidden(18, true);
	p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
		gridOnRowOTSelect(id,ind);
	});
}

function setOTGridData(){
	var result = new Object();
	result.title = "${title}";
	result.key = "procConfig_SQL.getItemAttrType";
	result.header = "${menu.LN00024},#master_checkbox,Code,${menu.LN00028},Alias,Sort No.,Row No,Column No,Mandatory,Calculated,Link,Link,VarFilter,dicCode,EditLink,EditLink,EditLinkVarFilter,DefValue,Invisible";
	result.cols = "CHK|AttrTypeCode|Name|Alias|SortNum|RowNum|ColumnNum|Mandatory|Calculated|Link|LinkName|VarFilter|AttrTypeNMCode|EditLink|EditLinkName|EditLinkVarFilter|DefValue|Invisible";
	result.widths = "50,50,60,120,160,100,100,100,100,80,120,0";
	result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str";
	result.aligns = "center,center,center,center,left,left,center,center,center,center,center,center,center";
	result.data =  "ItemID=${s_itemID}"	
	 			+ "&languageID=${languageID}";
	return result;
}

function AddAttributeType(){
	var url = "pim_AddItemAttrTypeCode.do";
	var data = "&TypeCode=${s_itemID}&languageID=${languageID}" 
	url += "?" + data;
	var option = "width=920,height=600,left=300,top=100,toolbar=no,status=no,resizable=yes";
    window.open(url, self, option);
}

// END ::: GRID	
//===============================================================================
	
//조회
function doOTSearchList(){
	var d = setOTGridData();
	fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
}

function DelteAttrType(){
	if (p_gridArea.getCheckedRows(1).length == 0){
		alert("${WM00023}");
	} else {
		if (confirm("${CM00004}")) {
			var checkedRows = p_gridArea.getCheckedRows(1).split(",");
			for ( var i = 0; i < checkedRows.length; i++) {
				var url = "pim_DeleteItemAttrType.do";

				var data = "&SortNum=" + p_gridArea.cells(checkedRows[i], 5).getValue()
						+ "&AttrTypeCode=" + p_gridArea.cells(checkedRows[i], 2).getValue()
						+ "&ItemID=${s_itemID}" 
						
				if (i + 1 == checkedRows.length) {
					data = data + "&FinalData=Final";
				}

				var target = "ArcFrame";
				ajaxPage(url, data, target);	
			}
		}
	}
	
}

//그리드ROW선택시
function gridOnRowOTSelect(id, ind){
	$("#groupListDiv").attr('style', 'display: block');	
	$("#groupListDiv").attr('style', 'width: 100%');
	var data = "&languageID=${languageID}&menuCat=ATR";
	fnSelect('link', data, 'getMenuType', p_gridArea.cells(id, 10).getValue() , 'Select');
	fnSelect('editLink', data, 'getMenuType', p_gridArea.cells(id, 14).getValue() , 'Select');
	fnSelect('dicCode', "&languageID=${languageID}&category=LN", 'getDictionary', p_gridArea.cells(id,13).getValue(), 'Select');
	
	$("#varFilter").val(p_gridArea.cells(id, 12).getValue().replace(/&/gi,"%26"));
	$("#editLinkVarFilter").val(p_gridArea.cells(id, 16).getValue().replace(/&/gi,"%26"));
	$("#objsortNum").val(p_gridArea.cells(id, 5).getValue());
	$("#AttrTypeCode").val(p_gridArea.cells(id, 2).getValue());
	$("#defValue").val(p_gridArea.cells(id, 17).getValue().replace(/<br>/g,"\n"));
	$("#rowNum").val(p_gridArea.cells(id, 6).getValue());
	$("#columnNum").val(p_gridArea.cells(id, 7).getValue());
	
	if(p_gridArea.cells(id, 8).getValue()=='1'){
		$("#objMandatory").attr('checked',true);
	}else{
		$("#objMandatory").attr('checked',false);
	}
	if(p_gridArea.cells(id, 9).getValue()=='1'){
		$("#calculated").attr('checked',true);
	}else{
		$("#calculated").attr('checked',false);
	}
	if(p_gridArea.cells(id, 18).getValue()=='1'){
		$("#invisible").attr('checked',true);
	}else{
		$("#invisible").attr('checked',false);
	}
}

function SaveItemAttrType(){
	if($("#objMandatory").is(":checked") == true){
		$("#objMandatory").val("1");
	}else{
		$("#objMandatory").val("0");
	}
	
	if($("#calculated").is(":checked") == true){
		$("#calculated").val("1");
	}else{
		$("#calculated").val("0");
	}
	
	if($("#invisible").is(":checked") == true){
		$("#invisible").val("1");
	}else{
		$("#invisible").val("0");
	}
	
	if(confirm("${CM00001}")){	
		var varFilter = $("#varFilter").val().replace(/&/g,"%26")
		var url = "pim_SaveItemAttrType.do";
		var data = "s_itemID="+$("#s_itemID").val()+"&AttrTypeCode="+$("#AttrTypeCode").val()+"&dicCode="+$("#dicCode").val()
					+"&link="+$("#link").val()+"&varFilter="+varFilter+"&objsortNum="+$("#objsortNum").val() + "&languageID=${languageID}"
		   			+"&objMandatory="+$("#objMandatory").val()+"&calculated="+$("#calculated").val()
		   			+"&editLink="+$("#editLink").val()+"&editLinkVarFilter="+$("#editLinkVarFilter").val()+"&defValue="+$("#defValue").val()
		   			+"&rowNum="+$("#rowNum").val()+"&columnNum="+$("#columnNum").val()+"&invisible="+$("#invisible").val();
		ajaxPage(url,data,"ArcFrame");
	}
}

function fnCallBack(){
	$("#groupListDiv").attr('style', 'display: none');	
	gridOTInit();
	doOTSearchList();
}

</script>

</head>
<body>
	<form action="*" method="post" onsubmit="return false;">
		<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
		<input type="hidden" id="AttrTypeCode" name="AttrTypeCode" value="${AttrTypeCode}">
		
		<div class="child_search">	
			<li class="floatR pdR20">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor' && configSTS != 'CLS'}">
					<span class="btn_pack medium icon"><span class="add"></span><input value="Add" type="submit" onclick="AddAttributeType()"></span>	
					<span class="btn_pack medium icon"><span class=del></span><input value="Del" type="submit" onclick="DelteAttrType()"></span>
				</c:if>
			</li>		
		</div>
		<div id="gridDiv" class="mgT10">
			<div id="grdGridArea" style="height:130px;width:100%"></div>
		</div>
	
		<div id="groupListDiv" style="width: 100%; height: 100%; display:none;">
			<div class="mgT10">
				<table id="newObject" class="tbl_blue01" width="100%" border="0" >
					<colgroup>
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">				
					</colgroup>
					<tr>
						<th class="viewtop">Alias</th>
						<td class="viewtop"><select id="dicCode" name="dicCode" class="sel" ></select></td>
						<th class="viewtop">Sort No.</th>
						<td class="viewtop"><input type="text" class="text" id="objsortNum" name="objsortNum" /></td>
						<th class="viewtop">Row No.</th>
						<td class="viewtop"><input type="text" class="text" id="rowNum" name="rowNum" /></td>
						<th class="viewtop">Column No.</th>
						<td class="viewtop last"><input type="text" class="text" id="columnNum" name="columnNum" /></td>
					</tr>
					<tr>
						<th>Status</th>
						<td><input type="text" class="text" id="status" name="status" /></td>
						<th>Mandatory</th>
						<td><input type="checkbox" id="objMandatory" name="objMandatory"
							<c:if test="${Mandatory == '1'}">
								checked="checked" 
							</c:if> />
						</td>
						<th>Calculated</th>
						<td><input type="checkbox" id="calculated" name="calculated"
							<c:if test="${Calculated == '1'}">
								checked="checked" 
							</c:if> />
						</td>
						<th>Invisible</th>
						<td class="last"><input type="checkbox" id="invisible" name="invisible"
							<c:if test="${Invisible == '1'}">
								checked="checked" 
							</c:if> />
						</td>
					</tr>
					<tr>
						<th>Link</th>
						<td><select id="link" name="link" style="width:100%;" ></select></td>
						<th>VarFilter</th>
						<td><input type="text" class="text" id="varFilter" name="varFilter"/></td>
						<th>EditLink</th>
						<td><select id="editLink" name="editLink" style="width:100%;" ></select></td>
						<th>EditLink VarFilter</th>
						<td class="last"><input type="text" class="text" id="editLinkVarFilter" name="editLinkVarFilter"/></td>
					</tr>
					<tr>
						<th>DefValue</th>
						<td colspan="7" class="last">
							<textarea class="edit" id="defValue" name="defValue" style="width:100%; resize:none;"></textarea>
						</td>
					</tr>
				</table>	
			</div>
			<div class="alignBTN">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor' && configSTS != 'CLS'}">
					&nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="SaveItemAttrType()"></span>
				</c:if>
			</div>
		</div>
	</form>
	
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer" style="height:0;">
		<iframe name="ArcFrame" id="ArcFrame" src="about:blank"style="display: none; height:0px;" frameborder="0" scrolling='no'></iframe>
	</div>
</body>
</html>