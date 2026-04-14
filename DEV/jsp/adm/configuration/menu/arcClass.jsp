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

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00016" var="CM00016" />

<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용

	
	function fnAddArcClass(){
		$("#divUpdateArcClass").attr('style', 'display: none');
		$("#newArcClass").attr('style', 'display: block');	
		$("#newArcClass").attr('style', 'height: 100px');
		$("#newArcClass").attr('style', 'width: 100%');	
		$("#divSaveArcClass").attr('style', 'display: block');
		$("input[name=chkbox]:checkbox").each(function() {
			$(this).attr('checked',false);
		});
		
		var data = "&LanguageID=${languageID}";		
		fnSelect('itemTypeCode', data, 'itemTypeCode', '', 'Select');
		fnGetClassCode();
	}
		
	
	
	function fnSaveArcClass(){
		if(confirm("${CM00012}")){
			document.getElementsByName("chkbox").forEach(e => {
			    e.value = e.checked ? 'Y':'N';
			})
			var ClassCode = $("#ClassCode").val();
			var IncludedCode = $("#IncludedCode").val();
			var IsSecondaryCode = $("#IsSecondaryCode").val();
			
			var url = "saveArcClass.do";
			var data = "ClassCode=" + ClassCode + "&IncludedCode="+IncludedCode+"&IsSecondaryCode="+IsSecondaryCode+"&arcCode=${arcCode}"; 
			
			var target = "ArcFrame";
			ajaxPage(url, data, target);
		}
	}
	
	function fnUpdateArcClass(){
		if(confirm("${CM00016}")){
			$("input[name=chkbox]:checkbox").each(function() {
				if($(this).is(":checked") == true){
					$(this).val('Y');
				}else{
					$(this).val('N');
				};
			});
			var ClassCode = $("#ClassCode").val();
			var IncludedCode = $("#IncludedCode").val();
			var IsSecondaryCode = $("#IsSecondaryCode").val();
			var ItemClassCode = $("#ItemClassCode").val();
			
			var url = "updateArcClass.do";
			var data = "ClassCode=" + ClassCode + "&ItemClassCode="+ItemClassCode+"&IncludedCode="+IncludedCode+"&IsSecondaryCode="+IsSecondaryCode+"&arcCode=${arcCode}"; 
			
			var target = "ArcFrame";
			ajaxPage(url, data, target);
		}
	}
	
	//조회
	function doOTSearchList(){
		var sqlID = "config_SQL.getArcFilterClsList";
		var param = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&arcCode=${arcCode}"+"&sqlID="+sqlID;
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
 		fnMasterChk('');
 	}

	function fnCallBack(){ 
		$("#newArcClass").attr('style', 'display: none');	
		$("#divSaveArcClass").attr('style', 'display: none');	
		$("#divSaveArcClass").attr('style', 'display: none');	
		doOTSearchList();
		var itemTypeCode = $("#ItemTypeCode").val();
		var data1 = "&languageID=${languageID}&arcCodeClass=${arcCode}&itemTypeCode="+itemTypeCode;
		fnSelect('ClassCode', data1, 'classCode', '', 'Select'); 
	}

	function fnDeleteArcClass(){
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){
			alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시오.");	
		}else{
			if(confirm("${CM00004}")){
				var ClassCode = "";
				for(idx in selectedCell){
					var url = "deleteArcClass.do";
					var data = "&arcCode=${arcCode}&ClassCode="+selectedCell[idx].ItemClassCode;
					var i = Number(idx) + 1;
					if (i == selectedCell.length) {
						data = data + "&FinalData=Final";
					}
					var target = "ArcFrame";
					ajaxPage(url, data, target);
					grid.data.remove(selectedCell[idx].id);	
				}
			}
		}
	}
	
	function fnGetClassCode(){		
		var itemTypeCode = $("#itemTypeCode").val();
		var data1 = "&languageID=${languageID}&arcCodeClass=${arcCode}&itemTypeCode="+itemTypeCode;
		fnSelect('ClassCode', data1, 'classCode', '', 'Select'); 
		
	}
	
	
</script>
</head>
<body>
	<form name="SubAttrTypeList" id="SubAttrTypeList" action="*" method="post" onsubmit="return false;" class="mgL10 mgR10">
	<%-- <input type="hidden" id="ItemClassCode" name="ItemClassCode" value="${s_itemID}"> --%>
	<input type="hidden" id="AttrTypeCode" name="AttrTypeCode">
	<div class="floatR pdR10 mgB7">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<button class="cmm-btn mgR5" style="height: 30px;"  onclick="fnAddArcClass()" value="Add">Add Class</button>
			<button class="cmm-btn mgR5" style="height: 30px;"  onclick="fnDeleteArcClass()" value="Del">Delete</button>
		</c:if>
	</div>
	<div id="gridDiv" class="mgT10">
		<div id="layout" style="height:250px; width:100%; margin-bottom: 50px;"></div><!--layout 추가한 부분-->
	</div>
	
	<div class="mgT10">
	<table id="newArcClass" class="tbl_blue01" width="100%" cellpadding="0" cellspacing="0" style="display:none">
		<tr>
			<th class="viewtop last">ItemType</th>
			<th class="viewtop last">Class</th>
			<th class="viewtop last">Included</th>
			<th class="viewtop last">IsSecondary</th>
		</tr>
		<tr>
			<input type="hidden" value="" name="ItemClassCode" id="ItemClassCode" />
			<td class="last"><select id="itemTypeCode" name="itemTypeCode" class="sel" OnChange="fnGetClassCode()" style="width:100%;" ></select></td>
			<td class="last"><select id="ClassCode" name="ClassCode" class="sel" style="width:100%;" ></select></td>
			<td class="last"><input type="checkbox" id="IncludedCode" name="chkbox" class="sel"></td>
			<td class="last"><input type="checkbox" id="IsSecondaryCode" name="chkbox" class="sel"></td>
		</tr>
	</table>
	</div>
	
	<div  class="alignBTN" id="divSaveArcClass" style="display: none;">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<span class="btn_pack medium icon mgR20"><span  class="save"></span><input value="Save" onclick="fnSaveArcClass()" type="submit"></span>
		</c:if>		
	</div>
	
	<div  class="alignBTN" id="divUpdateArcClass" style="display: none;">
		<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
			<span class="btn_pack medium icon mgR20"><span  class="save"></span><input value="Save" onclick="fnUpdateArcClass()" type="submit"></span>
		</c:if>		
	</div>	
	</form>
	
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="ArcFrame" id="ArcFrame" src="about:blank"style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
</body>

<script type="text/javascript">	
	//===============================================================================
	// BEGIN ::: GRID
	var layout = new dhx.Layout("layout", { 
		rows: [	
			{
				id: "a",
			},
		]
	});

	var gridData = ${gridData};
	var grid = new dhx.Grid(null, {
		columns: [
			{ width: 80, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center"},
			{ width: 80, id: "checkbox", header: [{ htmlEnable: true,  text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
			{ fillspace: true, id: "Class", header: [{ text: "Class" , align: "center" }], align: "center"},
			{ width: 200, id: "Included", header: [{ text: "Included" , align: "center" }], align: "center"},
			{ width: 200, id: "IsSecondary", header: [{ text: "IsSecondary" , align: "center" }], align: "center"},
			{ hidden:true, id: "ItemClassCode", header: [{ text: "ItemClassCode" , align: "center" }], align: "center"},
			{ hidden:true, id: "ItemTypeCode", header: [{ text: "ItemTypeCode" , align: "center" }], align: "center"}
		],
		autoWidth: true,
		resizable: true,
		selection: "row",
		tooltip: false,
		data:gridData
	});
	layout.getCell("a").attach(grid);

	// END ::: GRID	
	//===============================================================================

	//그리드ROW선택시
	grid.events.on("cellClick", function(row,column,e){
		if(column.id != "checkbox"){
			gridOnRowOTSelect(row);
		}
	}); 

	function gridOnRowOTSelect(row) { //그리드ROW선택시
		$("#divSaveArcClass").attr('style', 'display: none');
		$("#newArcClass").attr('style', 'display: block');	
		$("#newArcClass").attr('style', 'width: 100%');	
		$("#divUpdateArcClass").attr('style', 'display: block');
		var ClassCode = row.ItemClassCode;
		var Included = row.Included;
		var IsSecondary = row.IsSecondary;
		var ItemTypeCode = row.ItemTypeCode;
		
		$("#ItemClassCode").val(ClassCode);
		
		var data = "&LanguageID=${languageID}";		
		fnSelect('itemTypeCode', data, 'itemTypeCode',ItemTypeCode, 'Select');
		var data1 = "&languageID=${languageID}&arcCodeClass=${arcCode}&itemTypeCode="+ItemTypeCode;
		fnSelect('ClassCode', data1, 'classCode', ClassCode, 'Select'); 
		
		if(Included == 'Y'){
			$("input[id=IncludedCode]:checkbox").attr("checked",true);
		} else{
			$("input[id=IncludedCode]:checkbox").attr("checked",false);
		}
		if(IsSecondary == 'Y'){
			$("input[id=IsSecondaryCode]:checkbox").attr("checked",true);
		} else{
			$("input[id=IsSecondaryCode]:checkbox").attr("checked",false);
		}
		
		console.log(ItemTypeCode + "/" + ClassCode);
	}
</script>

</html>