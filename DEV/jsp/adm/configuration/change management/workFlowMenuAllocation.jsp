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
	
	var skin = "dhx_skyblue";
	var schCntnLayout;	//layout적용
	
	$(document).ready(function() {	
		fnSelect('categoryType', '&Category=DOCCAT', 'getDicWord', '${resultMap.Category}', 'Select');
		
		// 초기 표시 화면 크기 조정 
		$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 330)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 330)+"px;");
		};

		$("#excel").click(function(){fnGridExcelDownLoad();})
	});	


	//조회
	function doOTSearchList(){
		var sqlID = "wf_SQL.getWFAllocationList";
		var param =  "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&wfID=${wfID}"
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
			var url = "saveWfMNAlloc.do";
			ajaxSubmit(document.DictionaryList, url,"saveDFrame");
		}
	}


	function fnDeleteDictionary(){
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){ 
		alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
		} else {	
			if(confirm("${CM00004}")){
				for(idx in selectedCell){
					var url = "deleteWfMNAlloc.do";
					var data = "&menuID="+selectedCell[idx].MenuID+"&categoryCode="+selectedCell[idx].DocCategoryCode+"&wfID="+selectedCell[idx].WFID;
					var i = Number(idx) + 1;
					if (i == selectedCell.length) {
						data = data + "&FinalData=Final";
					}
					var target = "saveDFrame";
					ajaxPage(url, data, target);	
					grid.data.remove(selectedCell[idx].id);	
				}
			}
		}
	}
	
	function fnCallBack(stat){ 
		doOTSearchList();
		if(stat == "del"){
			$("#menuID").val("");
			$("#menuName").val("");
			$("#categoryType option:eq(0)").attr("selected",true);
		}
	}
	
	function fnOpenMenuListPop(){
		var url = "menuListPop.do?languageID=${languageID}";
		var w = 500;
		var h = 400;
		itmInfoPopup(url,w,h);
	}
	
	function fnSetMenu(menuId, menuName){
		$("#menuID").val(menuId);
		$("#menuName").val(menuName);
	}
	
	

</script>
<body>
<div id="DictionaryMgtList"  style="margin:0 10px;" >

	<!-- BEGIN :: BOARD_ADMIN_FORM -->
	<form name="DictionaryList" id="DictionaryList" action="admin/saveDictionary.do" method="post" onsubmit="return false;">
	<input type="hidden" id="orgTypeCode" name="orgTypeCode" />
	<input type="hidden" id="orgCategoryCode" name="orgCategoryCode" />
	<input type="hidden" id="menuID" name="menuID" />
	<input type="hidden" id="wfID" name="wfID" value="${wfID}"/>
	
	<div class="cfgtitle" >				
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Dictionary</li>

		</ul>
	</div>	
	<div class="child_search">
		<li class="floatR pdR20">
			&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
			&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="fnDeleteDictionary()" ></span>
		</li>
	</div>	
        <div class="countList">
               <li class="count">Total <span id="TOT_CNT"></span></li>
             <li class="floatR">&nbsp;</li>
         </div>
		<div id="gridOTDiv" class="mgB10 clear">
			<div id="grdOTGridArea" style="width:100%"></div>
			<div id="pagination"></div>
		</div>
		<table id="newObject" class="tbl_blue01" width="100%"  cellpadding="0" cellspacing="0" >
			<tr>
				<th class="viewtop last">Document Category</th>
				<th class="viewtop last">${menu.LN00124}</th>
			</tr>
			<tr>
				<td class="last">
					<select id="categoryType" name="categoryType" style="width:100%;"></select>
				</td>
				<td class="last"><input type="text" id="menuName" name="menuName" OnClick="fnOpenMenuListPop()" class="text" ></td>
			</tr>	
		</table>
		<div class="alignBTN">
				&nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Save" type="submit" onclick="saveDictionary()"></span>
		</div>	
	</form>
</div>
	<iframe name="saveDFrame" id="saveDFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
	<!-- END :: BOARD_ADMIN_FORM -->
</body>
<script type="text/javascript">	//그리드 자바스크립트
	var layout = new dhx.Layout("grdOTGridArea", { 
			rows: [
				{
					id: "a",
				},
			]
		});
	
		var gridData = ${gridData};
		var grid = new dhx.Grid("grdOTGridArea", {
			columns: [
				{ width: 80, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ width: 80, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},			
				{ width: 230, id: "CategoryName", header: [{ text: "Document Category" , align: "center" }], align: "center" },
				{ fillspace: true, id: "MenuName", header: [{ text: "Menu Name", align: "center" }], align: "center" },
				{ hidden: true, width: 10, id: "DocCategoryCode", header: [{ text: "", align: "center" }], align: "center" },
				{ hidden: true,width: 10, id: "MenuID", header: [{ text: "", align: "center" }], align: "left" },
				{ hidden: true,width: 10, id: "WFID", header: [{ text: "", align: "center" }], align: "center" }				
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data: gridData
		});
		layout.getCell("a").attach(grid);
		$("#TOT_CNT").html(grid.data.getLength());

		//그리드ROW선택시
		grid.events.on("cellClick", function(row,column,e){
			if(column.id != "checkbox"){
				gridOnRowOTSelect(row);
			}
		}); 
	
		function gridOnRowOTSelect(row) {
			$("#menuName").val(row.MenuName);
			$("#menuID").val(row.MenuID);	
			$("#categoryType").val(row.DocCategoryCode).prop("selected",true);
		}
		
		
</script>

</html>