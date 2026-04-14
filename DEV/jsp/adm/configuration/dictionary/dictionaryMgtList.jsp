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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00006" var="CM00006" />

<!-- 2. Script -->
<script type="text/javascript">
	
	var OT_gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	

	$(document).ready(function() { 
		
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			},
		});	
		
		$("#layout").attr("style","height:"+(setWindowHeight() - 350)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 350)+"px;");
		};

		$("#excel").click(function(){ fnGridExcelDownLoad(); });		

		fnSelect('getLanguageID', '', 'langType', '${sessionScope.loginInfo.sessionCurrLangType}', 'Select');
		fnSelect('CategoryCode', '', 'dicCategory', '', 'Select');
		fnSelect('categoryType', '', 'dicCategory', '', 'Select');
		
		$('.searchList').click(function(){
			doOTSearchList();
			return false;
		});
		$('#searchValue').keypress(function(onkey){
			if(onkey.keyCode == 13){
				doOTSearchList();
				return false;
			}
		});		
		setTimeout(function() {$('#searchValue').focus();}, 0);	
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}


	function setOTLayout(type){
		if( schCntnLayout != null){
			schCntnLayout.unload();
		}
		schCntnLayout = new dhtmlXLayoutObject("schContainer",type, skin);
		schCntnLayout.setAutoSize("b","a;b"); //가로, 세로		
		schCntnLayout.items[0].setHeight(350);
	}

	function checkBox(){			
		var chk1 = document.getElementsByName("Editable");
		if(chk1[0].checked == true){ $("#Editable").val("1");
		}else{	$("#Editable").val("0"); }
	}
	
	//조회
	function doOTSearchList(){
		var sqlID = "dictionary_SQL.selectDictionaryCode";

		var param = 
			 "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&sqlID="+sqlID;

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
 		$("#TOT_CNT").html(grid.data.getLength());
 		fnMasterChk('');
 	}

	function saveDictionary(){
		if(confirm("${CM00001}")){			
			var checkConfirm = false;
			if('${sessionScope.loginInfo.sessionCurrLangType}' != $("#getLanguageID").val()){
				if(confirm("${CM00006}")){
					checkConfirm = true;
				}
			}else{
				checkConfirm = true;
			}
			if(checkConfirm){
				var url = "/admin/saveDictionary.do";
				ajaxSubmit(document.DictionaryList, url,"saveDFrame");
			}
		}
	}


	function fnDeleteDictionary(){
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){ //배열의 길이가 0   => !FALSE == TRUE
			alert("${WM00023}");	
		}

		if(confirm("${CM00004}")){
			var typeCodeArr = [];
			var categoryCodeArr = [];
			
			for(idx in selectedCell){
				typeCodeArr.push(selectedCell[idx].CODE);
				categoryCodeArr.push(selectedCell[idx].Category);
			}
			var url = "deleteDictinary.do";
			var data = "&typeCode="+typeCodeArr+"&categoryCode="+categoryCodeArr;
			var target = "saveFrame";
			ajaxPage(url, data, target);	
		}
		fnCallBack();
	}

	
	function fnCallBack(stat){ 
		doOTSearchList();
		if(stat == "del"){
			$("#objType").val("");
			$("#objName").val("");
			$("#getLanguageID").val("");
			$("#orgTypeCode").val("");
			$("#categoryType").val("");
			$("#Description").val("");
			$("#sortNum").val("");	 
		}
	}

	function fnOnlyEnNum(obj){
		var regType = /^[A-Za-z0-9*]+$/;
        if(!regType.test(obj.value)) {
            obj.focus();
            $(obj).val( $(obj).val().replace(/[^A-Za-z0-9]/gi,"") );
            return false;
        }
    }
</script>
<body>
<div id="DictionaryMgtList"  style="margin:0 10px;" >

	<!-- BEGIN :: BOARD_ADMIN_FORM -->
	<form name="DictionaryList" id="DictionaryList" action="admin/saveDictionary.do" method="post" onsubmit="return false;">
	<input type="hidden" id="X-CSRF-TOKEN" name="X-CSRF-TOKEN" value="${sessionScope.CSRF_TOKEN}" />
	<input type="hidden" id="orgTypeCode" name="orgTypeCode" />
	<input type="hidden" id="orgCategoryCode" name="orgCategoryCode" />
	
	<div class="cfgtitle" >				
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Dictionary</li>

		</ul>
	</div>	
	<!-- <li>
			Code Category
			<select class="mgL10" id="CategoryCode" name="CategoryCode" onchange="doOTSearchList()">
			</select>
		</li>
		<li>
			<select id="searchKey" name="searchKey" style="width:150px;">
				<option value="CODE">Code</option>
				<option value="NAME" 
					<c:if test="${searchKey == 'NAME'}"> selected="selected"</c:if>>
					Name
				</option>					
			</select>
		</li>
		<li>
			<input type="text" class="stext"  id="searchValue" name="searchValue" value="${searchValue}" style="width:200px; height:28px; margin-right:5px;border-radius:2px; ime-mode:active;">
				<button class="cmm-btn2 mgR20 floatR searchList" style="height: 30px;" onclick="fnSaveStNum()" value="Search">Search</button>
		</li>
		 -->	
		<div id="processListDiv" class="hidden" style="width:100%;height:100%;">
			<div class="countList pdL10">
				<li class="count">Total <span id="TOT_CNT"></span></li>
				<li class="floatR pdR20">
					<button class="cmm-btn mgR5" style="height: 30px;" id="excel" value="Add">Download List</button>
					<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnDeleteDictionary()" value="Del">Delete</button>
				</li>
		  </div>
	
			<div id="gridOTDiv" class="mgB10 clear mgL10 mgR10">
				<div id="grdOTGridArea" style="width:100%">
					<div style="width: 100%;" id="layout"></div> <!--layout 추가한 부분-->
					<div id="pagination"></div></div>
				</div>
			</div>
		</div>

		<table id="newObject" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" >
			<tr>
				<th class="viewtop last">Category</th>
				<th class="viewtop last">${menu.LN00015}</th>
				<th class="viewtop last" colspan=2>${menu.LN00028}</th>
			</tr>
			<tr>
				<td class="last">
					<select id="categoryType" name="categoryType" style="width:100%;"></select>
				</td>
				<td class="last"><input type="text" class="text" id="objType" name="objType"  onkeyup="fnOnlyEnNum(this);" onchange="fnOnlyEnNum(this);"/></td>
				<td class="last" colspan=2><input type="text" class="text" id="objName" name="objName" /></td>
			</tr>
			<tr>
				<th class="last">LanguageID</th>
				<th class="last">SortNum</th>
				<th class="last">${menu.LN00035}</th>
				<th class="last">Editable</th>
			</tr>
			<tr>
				<td class="last">
					<select id="getLanguageID" name="getLanguageID" style="width:100%;"></select>
				</td>
				<td class="last"><input type="text" class="text" id="sortNum" name="sortNum" /></td>
				<td class="last"><input type="text" class="text" id="Description" name="Description" /></td>
				<td class="last"><input type="checkbox" class="checkbox" id="Editable" name="Editable" checked value="1"/></td>
			</tr>	
		</table>
		<div class="alignBTN">
				<button class="cmm-btn2 mgR5" style="height: 30px;" onclick="saveDictionary()" value="Save">Save</button>
		</div>	
	</form>
</div>
	<iframe name="saveDFrame" id="saveDFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
	<!-- END :: BOARD_ADMIN_FORM -->
</body>

<script type="text/javascript">	//그리드 자바스크립트
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
		var grid = new dhx.Grid("grdOTGridArea", {
			columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ width: 50, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center", htmlEnable: true}], align: "center", type: "boolean", editable: true, sortable: false},
				{ width: 100, id: "Category", header: [{ text: "Category Code" , align: "center" }, { content: "selectFilter" }], align: "center" },
				{ width: 150, id: "CategoryName", header: [{ text: "Category", align: "center" }, { content: "selectFilter" }], align: "center" },
				{ width: 150, id: "CODE", header: [{ text: "Code", align: "center" }, { content: "inputFilter" }], align: "center" },
				{ fillspace: true, id: "NAME", header: [{ text: "Name", align: "center" }, { content: "inputFilter" }], align: "left" },
				{ width: 110, id: "LanguageCode", header: [{ text: "Language Code" }, { content: "inputFilter" }], align: "center" },
				{ width: 90, id: "SortNum", header: [{ text: "SortNum", align: "center" }] , align: "center"},				
				{ hidden: true, width: 80, id: "Description", header: [{ text: "Description" }, { content: "inputFilter" }], align: "center" },				
				{ hidden: true, width: 80, id: "LanguageID", header: [{ text: "LanguageID", align: "center" }, { content: "inputFilter" }], align: "center" },
				{ hidden: true, width: 80, id: "Editable", header: [{ text: "Editable", align: "center" }, { content: "selectFilter" }], align: "center" },
							
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data: gridData
		});
		layout.getCell("a").attach(grid);
		$("#TOT_CNT").html(grid.data.getLength());

		var pagination = new dhx.Pagination("pagination", {
			data: grid.data,
			pageSize: 50,
		});	

		//그리드ROW선택시
		grid.events.on("cellClick", function(row,column,e){
			if(column.id != "checkbox"){
				gridOnRowOTSelect(row);
			}
		}); 

		//그리드ROW선택시
		function gridOnRowOTSelect(row){		
			$("#objType").val(row.CODE);
			$("#objName").val(row.NAME);
			$("#getLanguageID").val(row.LanguageID);
			$("#orgTypeCode").val(row.Category);
			$("#categoryType").val(row.Category);
			$("#Description").val(row.Description);
			$("#sortNum").val(row.SortNum);		

			if(row.Editable == 1){
			document.getElementById("Editable").checked = true;
			} else {
				document.getElementById("Editable").checked = false;
			}
		}
	
	// END ::: GRID	
	//===============================================================================


</script>
</html>