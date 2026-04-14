<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00114" var="WM00114"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00016}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="CSR"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/>

<script>
	var p_gridArea;
	var selectedItemBlocked = "${selectedItemBlocked}";
	var selectedItemStatus = "${selectedItemStatus}";
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 380)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 380)+"px;");
		};
		
		gridInit();
		doSearchList();
	
	});
	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//===============================================================================
	// BEGIN ::: GRID
	function gridInit(){		
		var d = setGridData();		
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
		//p_gridArea.setColumnHidden(1, true);
		//p_gridArea.setColumnHidden(5, true);
		p_gridArea.setColumnHidden(12, true);
		
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		
		//START - PAGING
		p_gridArea.enablePaging(true, 1000, null, "pagingArea", true, "recinfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
		//END - PAGING
	}	
	function setGridData(){
		var result = new Object();
		
		result.title = "${title}";
		result.key = "variant_SQL.getVariantItems";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00106},${menu.LN00028},${menu.LN00042},${menu.LN00131},${menu.LN00191},${menu.LN00014},${menu.LN00018},${menu.LN00004},${menu.LN00070},${menu.LN00027},ItemID";
		result.cols = "CHK|Identifier|ItemName|ClassName|ProjectName|CsrName|CompanyName|OwnerTeamNm|AuthorName|LastUpdated|ItemStatusText|ItemID";
		result.widths = "30,50,80,*,140,140,180,100,100,80,80,80";
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,left,center,center,center,center,center,center,center,center";
		result.data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&itemTypeCode=${itemTypeCode}";
			
		// 프로젝트
		if($("#Project").val() != '' & $("#Project").val() != null){
			result.data = result.data +"&ProjectID=" + $("#Project").val();
		}
		// CSR
		if($("#csr").val() != '' & $("#csr").val() != null){
			result.data = result.data +"&csrID=" + $("#csr").val();
		}
		// 입력된 검색 조건
		if($("#searchValue").val() != '' & $("#searchValue").val() != null){
			result.data = result.data +"&searchKey=" + $("#searchKey").val();
			result.data = result.data +"&searchValue=" + $("#searchValue").val();
		}
		
		return result;
	}
	
	// [Row] Click
	function gridOnRowSelect(id, ind){
		if(ind != 1) {
			doDetail(p_gridArea.cells(id, 12).getValue());
		}
	}
	
	// END ::: GRID	
	//===============================================================================
	
	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data, "", "", "", "", "", "${WM00119}", 1000);
	}
	
	function doDetail(avg){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg+"&scrnType=pop";
	
		
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg);
	}
	
	// [Del] 이벤트 후 Reload
	function thisReload(){
		var url = "varItemList.do";
		var target = "actFrame";
		var data = "s_itemID=${s_itemID}&varFilter=${varFilter}";
	 	ajaxPage(url, data, target);
	}
	
	function doReturnInsert(){
		thisReload();
	}
	
	//[Add] click 이벤트
	function addRefItem() {
		if (selectedItemBlocked == "0") {
			$("#varItemList").attr("style","height:"+(setWindowHeight() - 230)+"px;");
			$("#newItemArea").attr("style", "display:block;");
		} else {
			if (selectedItemStatus == "REL") {
				alert("${WM00120}"); // [변경 요청 안된 상태]
			} else {
				alert("${WM00050}"); // [승인요청중]
			}
		}
	}
	
	function fnCopyRefItem() {
		if (selectedItemBlocked == "0") {
			$("#varItemList").attr("style","height:"+(setWindowHeight() - 230)+"px;");
			$("#copyItemArea").attr("style", "display:block;");
			$("#createItemArea").attr("style", "display:none;");
			
			$("#cpItemID").val("${s_itemID}");
			$("#cpIdentifier").val("${itemInfoMap.Identifier}");
			$("#cpItemName").val("${itemInfoMap.ItemName}");
			$("#cpModelName").val("${modelInfo.ModelName}");
			
			var data = "&itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
			fnSelect('modelID', data, 'selectModelList', '${modelID}', '', 'model_SQL');
			
			if("${hasDimension}" == "1"){
				$("#dim1").attr('style', 'visibility:visible;');
				$("#dim2").attr('style', 'visibility:visible;');
				$("#dim3").attr('style', 'visibility:visible;');
				var data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
				fnSelect('dimTypeID', data, 'getDimensionTypeID', '', 'Select');	
				fnSelect('dimTypeValueID', data, 'getDimTypeValueId', '', 'Select');			
			}else{
				$("#dim1").attr('style', 'visibility:hidden');
				$("#dim2").attr('style', 'visibility:hidden');
				$("#dim3").attr('style', 'visibility:hidden');
			}
			
		} else {
			if (selectedItemStatus == "REL") {
				alert("${WM00120}"); // [변경 요청 안된 상태]
			} else {
				alert("${WM00050}"); // [승인요청중]
			}
		}
	}
	
	function fnCreateRefItem() {
		if (selectedItemBlocked == "0") {
			$("#varItemList").attr("style","height:"+(setWindowHeight() - 230)+"px;");
			$("#createItemArea").attr("style", "display:block;");
			$("#copyItemArea").attr("style", "display:none;");
			
			$("#newItemID").val("${s_itemID}");
			$("#newIdentifier").val("${itemInfoMap.Identifier}");
			$("#newItemName").val("${itemInfoMap.ItemName}");
			$("#newModelName").val("${modelInfo.ModelName}");
			
			//var data = "&itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
			//fnSelect('newModelID', data, 'selectModelList', '${modelID}', '', 'model_SQL');
			
		/* 	if("${hasDimension}" == "1"){
				$("#dim1").attr('style', 'visibility:visible;');
				$("#dim2").attr('style', 'visibility:visible;');
				$("#dim3").attr('style', 'visibility:visible;');
				var data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
				fnSelect('dimTypeID', data, 'getDimensionTypeID', '', 'Select');	
				fnSelect('dimTypeValueID', data, 'getDimTypeValueId', '', 'Select');			
			}else{
				$("#dim1").attr('style', 'visibility:hidden');
				$("#dim2").attr('style', 'visibility:hidden');
				$("#dim3").attr('style', 'visibility:hidden');
			} */
			
		} else {
			if (selectedItemStatus == "REL") {
				alert("${WM00120}"); // [변경 요청 안된 상태]
			} else {
				alert("${WM00050}"); // [승인요청중]
			}
		}
	}
	
	function fnGetHasDimension(classCode){ 
		var url = "getHasDimension.do";
		var data = "itemClassCode="+classCode;
		var target = "blankFrame";
		ajaxPage(url, data, target);
	}
	
	function fnSetDimension(hasDimension, autoID, preFix){ 
		if(hasDimension == "1"){
			$("#dim1").attr('style', 'visibility:visible;');
			$("#dim2").attr('style', 'visibility:visible;');
			$("#dim3").attr('style', 'visibility:visible;');
			var data =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
			fnSelect('dimTypeID', data, 'getDimensionTypeID', '', 'Select');	
			fnSelect('dimTypeValueID', data, 'getDimTypeValueId', '', 'Select');			
		}else{
			$("#dim1").attr('style', 'visibility:hidden');
			$("#dim2").attr('style', 'visibility:hidden');
			$("#dim3").attr('style', 'visibility:hidden');
		}
		
		if(autoID == "Y"){
			$("#newIdentifier").attr('disabled',true);
			$("#newIdentifier").val("");
			$("#autoID").val(autoID);
			$("#preFix").val(preFix);
		}else{
			$("#newIdentifier").attr('disabled',false);
			$("#autoID").val(autoID);
			$("#preFix").val("");
		}
	}
	
	function fnCopyItemInfo(){
		var cpIdentifier = $("#cpIdentifier").val();
		var cpItemName = $("#cpItemName").val();
		var cpCsrInfo = $("#cpCsrInfo").val();
		var modelGUBUN = "copy";
		if("${elmCopyOption}" == "Y"){
			modelGUBUN = "insertRefModel"; 
		}
		
		if(cpItemName == ""){alert("${WM00034_1}");$("#cpItemName").focus();return false;}
		
		if(confirm("${CM00009}")){		
			var url = "createItem.do";
			var data = "s_itemID=${s_itemID}&option=${option}"
						+"&itemTypeCode=${itemInfoMap.ItemTypeCode}"
						+"&newClassCode=${itemInfoMap.ClassCode}"
						+"&newIdentifier="+cpIdentifier
						+"&newItemName="+cpItemName
						+"&csrInfo="+cpCsrInfo				
						+"&addYN="
						+"&autoID="+$("#autoID").val()
						+"&preFix="+$("#preFix").val()
						+"&cpItemID="+$("#cpItemID").val()
						+"&modelID=${modelID}"
						+"&MTCTypeCode=${modelInfo.MTCategory}"
						+"&ModelTypeCode=${modelInfo.ModelTypeCode}"
						+"&newModelName="+$("#cpModelName").val()
						+"&includeItemMaster=Y"
						+"&fromItemID=${fromItemID}"
						+"&refItemID=${s_itemID}"					
						+"&mstSTR=${mstSTR}"
						+"&modelGUBUN="+modelGUBUN;	
			if("${hasDimension}" == "1"){
				data = data +"&dimTypeID="+$("#dimTypeID").val()+"&dimTypeValueID="+$("#dimTypeValueID").val();
			}
	alert("dadta :"+data);
			var target = "blankFrame";		
			ajaxPage(url, data, target);
		}
	}
	
	function fnCreateItemInfo(){
		var cpIdentifier = $("#newIdentifier").val();
		var cpItemName = $("#newItemName").val();
		var cpClassCode = $("#newClassCode").val();
		var cpCsrInfo = $("#newCsrInfo").val();
		
		var modelGUBUN = "copy";
		if("${elmCopyOption}" == "Y"){
			modelGUBUN = "insertRefModel"; 
		}
		
		if(cpItemName == ""){alert("${WM00034_1}");$("#cpItemName").focus();return false;}
		
		/* if(cpIdentifier == identifier){ alert("${WM00116_1}"); return;
		}else if(cpItemName == itemName){ alert("${WM00116_2}"); return; } */
	
		if(confirm("${CM00009}")){		
			var url = "createItem.do";
			var data = "s_itemID=${s_itemID}&option=${option}"
						+"&itemTypeCode=${itemTypeCode}"
						+"&newClassCode="+cpClassCode
						+"&newIdentifier="+cpIdentifier
						+"&newItemName="+cpItemName
						+"&csrInfo="+cpCsrInfo				
						+"&addYN="
						+"&autoID="+$("#autoID").val()
						+"&preFix="+$("#preFix").val()
						+"&cpItemID="+$("#cpItemID").val()
						+"&modelID=${modelID}"
						+"&MTCTypeCode=${modelInfo.MTCategory}"
						+"&ModelTypeCode=${modelInfo.ModelTypeCode}"
						+"&newModelName="+$("#newModelName").val()
						+"&includeItemMaster=Y"
						+"&fromItemID=${fromItemID}"
						+"&refItemID=${s_itemID}"
						+"&dimTypeID="+$("#dimTypeID").val()
						+"&dimTypeValueID="+$("#dimTypeValueID").val()
						+"&modelGUBUN="+modelGUBUN;	
			
			var target = "blankFrame";		
			ajaxPage(url, data, target);
		}
	}
	
	function urlReload() {
		thisReload();
	}
	
	function refItemDel(){
		if (selectedItemBlocked == "0") {
			if(p_gridArea.getCheckedRows(1).length == 0){
				alert("${WM00023}");
			}else{
				if(confirm("${CM00004}")){
					var checkedRows = p_gridArea.getCheckedRows(1).split(",");	
					var items = "";
					for(var i = 0 ; i < checkedRows.length; i++) {
						if (items == "") {
							items = p_gridArea.cells(checkedRows[i], 12).getValue();
						} else {
							items = items + "," + p_gridArea.cells(checkedRows[i], 12).getValue();
						}
					}
					
					var url = "delRefItems.do";
					var data = "items="+items;
					var target = "blankFrame";
					ajaxPage(url, data, target);
				}
			}
		} else {
			if (selectedItemStatus == "REL") {
				alert("${WM00120}"); // [변경 요청 안된 상태]
			} else {
				alert("${WM00050}"); // [승인요청중]
			}
		}
	}
	
	//==============================================================================================
	/* 신규항목 생성 관련 이벤트 */
	//[save] 이벤트
	function newItemInsert() {
		if($("#itemName").val() == ""){alert("${WM00034_1}");$("#itemName").focus();return false;}
		if($("#ClassCode").val() == ""){alert("${WM00034_2}");$("#ClassCode").focus();return false;}
		if($("#Csr").val() == ""){alert("${WM00034_3}");$("#Csr").focus();return false;}
		
		//if(confirm("신규 정보를 생성 하시겠습니까?")){		
		if(confirm("${CM00009}")){		
			var url = "createVariantItem.do";
			var data = "s_itemID=${s_itemID}&option=${option}"
						+"&itemTypeCode=${itemTypeCode}"
						+"&classCode="+$("#ClassCode").val()
						+"&identifier="+replaceText($("#newIdentifier").val())
						+"&itemName="+replaceText($("#itemName").val());
			var target = "blankFrame";		
			ajaxPage(url, data, target);
		}
	}
	
	function replaceText(avg) {
		var text = "<and>";
		return avg.replace(/&/gi, text);
	}
	
	function doCallBack(){}
	
	function setCheckedItems(){
		doSearchList();
		$(".popup_div").hide();
		$("#mask").hide();	
	}
	
	function fnGetCsrList(parentID){
		fnSelect('csr','&languageID=${sessionScope.loginInfo.sessionCurrLangType}&parentID='+parentID,'getCsrOrder','','Select');
	}
	
	function fnGetDimTypeValue(dimTypeID){
		var data = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&dimTypeId="+dimTypeID;
		fnSelect('dimTypeValueID', data, 'getDimTypeValueId', '', 'Select');	
	}
	
	function fnGovernance(){  	
		if(p_gridArea.getCheckedRows(1).length == 0){
			alert("${WM00023}");
			return;
		}
		var checkedRows = p_gridArea.getCheckedRows(1).split(",");	
		var items = new Array;
		var idx = 0;
		for(var i = 0 ; i < checkedRows.length; i++) {
			items[idx] = p_gridArea.cells(checkedRows[i], 12).getValue();
			idx++;
		}
		$("#items").val(items);
	
		var url = "selectOwnerPop.do"; 
		var option = "width=480, height=350, left=300, top=300,scrollbar=yes,resizble=0";
		window.open("", "SelectOwner", option);
		document.varItemList.action=url;
		document.varItemList.target="SelectOwner";
		document.varItemList.submit();
	}
	
	function fnReferenceModel(){		
		var url = "openReferenceModelPop.do?ItemID=${s_itemID}&modelID=${modelID}";
		var w = 500;
		var h = 400;
		itmInfoPopup(url,w,h);
	}
	
	function fnSetCopyModelInfo(checkElmts, newModelName){
		$("#checkElmts").val(checkElmts);
		$("#newModelName").val(newModelName);
		$("#cpModelName").val(newModelName);
	}

</script>

<form name="varItemList" id="varItemList" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
	<input type="hidden" id="varFilter" name="varFilter" value="${varFilter}">		
	<input type="hidden" id="items" name="items" value="" >
	<input type="hidden" id="checkElmts" name="checkElmts" value="" >
 	<div class="child_search" >
		<li class="pdL55">${menu.LN00131}
			<select id="Project" Name="Project" onChange="fnGetCsrList(this.value)" style="width:150px;">
	           	<option value=''>Select</option>
	           	<c:forEach var="i" items="${parentPjtList}">
	               	<option value="${i.CODE}">${i.NAME}</option>
	           	</c:forEach>
	       	</select>
	       	&nbsp;${menu.LN00191} &nbsp;
	       	<select id="csr" Name="csr" class="sel" style="width:150px;">
	       		<option value="">Select</option>
	       	</select>
	       	<select id="searchKey" name="searchKey" class="pdL5">
				<option value="Name">Name</option>
				<option value="ID" 
					<c:if test="${!empty searchID}">
											selected="selected"
					</c:if>	
				>ID</option>
			</select>
			<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;">
			<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchList()" value="검색">
	       	
		</li> 
		
		<li class="floatR pdR20">
			<c:if test="${screenMode eq ''}">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
					<span class="btn_pack small icon"><span class="add"></span><input value="Create" type="submit" onclick="fnCreateRefItem();"></span>
					<span class="btn_pack small icon"><span class="copy"></span><input value="Copy" type="submit" onclick="fnCopyRefItem();"></span> 
					<span class="btn_pack small icon"><span class="gov"></span><input value="Gov" type="button" onclick="fnGovernance();"></span>
					<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="button" onclick="refItemDel();"></span>
				</c:if>	
			</c:if>		
		</li>
	</div>
	<!-- END :: SEARCH -->
	
	<div class="countList pdT5">
    	<li  class="count">Total  <span id="TOT_CNT"></span></li>
   	</div>
	<div id="gridDiv" class="mgB10 clear" align="center">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
		
</form>


<!-- :: 신규항목 생성 -->
<!-- 
<div id="newItemArea" style="display:none;">
	<div id="divTapItemAdd" class="ddoverlap mgB5 mgT5">
		<ul>
			<li class="selected" ><a><span>${menu.LN00096}</span></a></li>
		</ul>
	</div>
	
	<table id="addNewItem" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" >
		<tr>
			<th>${menu.LN00016}</th>
			<th>${menu.LN00106}</th>
			<th>${menu.LN00028}</th>
		</tr>
		<tr>
			<td class="alignL last">
				<select id="ClassCode" name="ClassCode" class="sel">
				<option value=""></option>
				<c:forEach var="i" items="${classOption}">
					<option value="${i.ItemClassCode}">${i.Name}</option>						
				</c:forEach>				
				</select>
			</td>
			<td><input type="text" class="text" id="newIdentifier" name="newIdentifier"/></td>
			<td class="last"><input type="text" class="text" id="itemName" name="itemName"/></td>
		</tr>	
	</table>
	
	<div class="alignBTN" >
		&nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="newItemInsert();" type="submit"></span>
	</div>
</div>
 -->

<div id="copyItemArea" style="display:none;">
	<div id="divTapItemAdd" class="ddoverlap mgB5 mgT5">
		<ul>
			<li class="selected" ><a><span>Copy Item</span></a></li>
		</ul>
	</div>
	<table id="copyItem" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" >
		<tr>
			<th>${menu.LN00106}</th>
			<th>${menu.LN00028}</th>
			<th>${menu.LN00191}</th>
			<th  class="last">${menu.LN00125}</th>
		</tr>
		<tr>
			<td style="width:15%;">
				<input type="text" class="text" id="cpIdentifier" name="cpIdentifier" value="" />
				<input type="hidden" id="cpItemID" name="cpItemID" value="" />	
			</td>
			<td style="width:17%;"><input type="text" class="text" id="cpItemName" name="cpItemName"  value=""/></td>		
			<td style="width:18%">
				<select id="cpCsrInfo" name="cpCsrInfo" class="sel">
				<option value="">Select</option>
				<c:forEach var="i" items="${csrOption}">
					<option value="${i.CODE}">${i.NAME}</option>						
				</c:forEach>				
				</select>
			</td>
			<td style="width:30%" class="last">  
				<input type="text" class="text" id="cpModelName" name="cpModelName" value="" style="width:150px;">&nbsp;
				<input type="hidden" id="newModelID" name="newModelID" value="">
	   			<c:if test="${elmCopyOption eq 'Y'}" >
					<span class="btn_pack small icon"><span class="ref"></span><input value="Reference Copy" onclick="fnReferenceModel()"  type="button"></span>&nbsp;
				</c:if>
			</td>
		</tr>
		<tr>
			<th id="dim1" style="visibility:hidden;">Dimension</th>
			<td id="dim2" style="visibility:hidden;"><select id="dimTypeID" name="dimTypeID" class="sel" OnChange="fnGetDimTypeValue(this.value);" ></select></td>
			<td id="dim3" style="visibility:hidden;"><select id="dimTypeValueID" name="dimTypeValueID" class="sel"></select></td>
			<td class="last" align="right">
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnCopyItemInfo()"  type="submit"></span>&nbsp;
			</td>
		</tr>						
	</table>
</div>		


<div id="createItemArea" style="display:none;">
	<div id="divTapItemAdd" class="ddoverlap mgB5 mgT5">
		<ul>
			<li class="selected" ><a><span>Create Item</span></a></li>
		</ul>
	</div>
	<table id="newItem" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" >
		<tr>
			<th>${menu.LN00106}</th>
			<th>${menu.LN00028}</th>
			<th>${menu.LN00016}</th>
			<th>${menu.LN00191}</th>
			<th  class="last">${menu.LN00125}</th>
		</tr>
		<tr>
			<td style="width:12%;">
				<input type="text" class="text" id="newIdentifier" name="newIdentifier" value="" />
				<input type="hidden" id="newItemID" name="newItemID" value="" />	
			</td>
			<td style="width:20%;"><input type="text" class="text" id="newItemName" name="newItemName"  value=""/></td>	
			<td style="width:20%;">
				<select id="newClassCode" name="newClassCode" class="sel" OnChange="fnGetHasDimension(this.value);">
				<option value="">Select</option>
				<c:forEach var="i" items="${classOption}">
					<option value="${i.ItemClassCode}"  >${i.Name}</option>						
				</c:forEach>				
				</select>
			</td>	
			<td style="width:18%;">
				<select id="newCsrInfo" name="newCsrInfo" class="sel">
				<option value="">Select</option>
				<c:forEach var="i" items="${csrOption}">
					<option value="${i.CODE}">${i.NAME}</option>						
				</c:forEach>				
				</select>
			</td>
			<td style="width:32%;" class="last">  
				<input type="text" class="text" id="newModelName" name="newModelName" value="" style="width:150px;">&nbsp;
				<input type="hidden" id="newModelID" name="newModelID" value="">
	   			<c:if test="${elmCopyOption eq 'Y'}" >
					<span class="btn_pack small icon"><span class="ref"></span><input value="Reference Copy" onclick="fnReferenceModel()"  type="button"></span>&nbsp;
				</c:if>
			</td>
		</tr>
		<tr>
			<th id="dim1" style="visibility:hidden;">Dimension</th>
			<td id="dim2" style="visibility:hidden;"><select id="dimTypeID" name="dimTypeID" class="sel" OnChange="fnGetDimTypeValue(this.value);" ></select></td>
			<td id="dim3" style="visibility:hidden;"><select id="dimTypeValueID" name="dimTypeValueID" class="sel"></select></td>
			<td class="last" align="right" colspan="2">
				<span class="btn_pack medium icon"><span class="save"></span><input value="Save" onclick="fnCreateItemInfo()"  type="submit"></span>&nbsp;
			</td>
		</tr>				
					
	</table>
</div>	

<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>		
