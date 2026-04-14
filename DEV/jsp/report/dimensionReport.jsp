<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<!-- 1. Include CSS/JS -->
<style type="text/css">
	#framecontent{border:1px solid #e4e4e4;overflow: hidden; background: #f9f9f9;padding:10px;}
</style>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00029" var="WM00029"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00030" var="WM00030"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00031" var="WM00031"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="${menu.LN00021}"/>

<script>
	var p_excelGrid;				//그리드 전역변수
	var dimTypeID = "${dimTypeID}";
	const  dimValName = "";
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#excelGridArea").attr("style","height:"+(setWindowHeight() - 210)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#excelGridArea").attr("style","height:"+(setWindowHeight() - 210)+"px;");
		};
		
	/* 	$("#excel").click(function(){
			p_excelGrid.toExcel("${root}excelGenerate");
			return false;
		});	 */
		$("#excel").click(function(){
			fnGridExcelDownLoad();
		});

	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	

	// [Search] Click
	function getDimensionInfo(){
		if($("#ItemTypeCode").val() == ""){alert("${WM00041}");return false;}
		var itemTypeCode = $("#ItemTypeCode").val();
			
		var url = "getDimensionInfo.do";		
		var data = "itemTypeCode="+itemTypeCode+"&dimTypeID="+dimTypeID;
		var target="blankFrame";
		ajaxPage(url, data, target);
	}
	
	
 /* ========================dhtmlx9 ===============================*/
 var layout = new dhx.Layout("excelGridArea", { rows: [{ id: "a" }] });


  const baseCols = [
    { width: 50, id: "RNUM",       header: [{ text: "${menu.LN00024}", align: "center" }], align: "center" },
    { width: 80, id: "Identifier", header: [{ text: "${menu.LN00015}", align: "center" }], align: "center" },
    { width: 200, id: "ItemName",  header: [{ text: "${menu.LN00028}", align: "center" }], align: "left" },
    { width: 300, id: "Path",       header: [{ text: "${menu.LN00043}", align: "center" }], align: "left" },
    { width: 100, id: "ClassName",  header: [{ text: "${menu.LN00016}", align: "center" }], align: "left" },
  ];


  var gridData = [];


  var grid = new dhx.Grid(null, {
    columns: baseCols,
    autoWidth: false,
    resizable: true,
    selection: "row",
    tooltip: false,
    data: gridData
  });


  layout.getCell("a").attach(grid);





 

function doSearchList(dimValueName, dimValueId, idCnt){


		let	sqlID = "report_SQL.itemDimValueProcessInfo";
		let param ="&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&s_itemID="+dimTypeID	
					+"&ID="+dimValueId
					+"&itemTypeCode="+$("#ItemTypeCode").val()
					+"&sqlID="+sqlID;	
	
		$.ajax({
			url:"dimensionReportGridJson.do",
			type:"POST",
			data:param,
			success: function(result){

				fnReload(result);
				$("#divExcelDownBtn").attr("style", "display:block;"); // excel다운로드 버튼 활성화
			 
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
		
		

	    const tokens = (dimValueName || "")
	      .replace(/^\s*,+/, "")
	      .split(",")
	      .map(s => s.trim())
	      .filter(Boolean); // ["Cell(70)","Module(71)","Package(72)"]


	    const dynCols = tokens.slice(0, idCnt).map((tok, i) => ({
	      id: 'DimValueName'+(i+1),            
	      width: 100,
	      header: [{ text: tok, align: "center" }], 
	      align: "center",
	      sortable: true,
	      // 체크박스 
	      type: "boolean",
	      editorType: "checkbox",
	      editable: true,      
	    }));
	      
	      //checkbox 비활성화 
	    grid.events.on("beforeEditStart", (row, col) => {
	    	
	    	  if (/^DimValueName\d+$/.test(col.id)) return false;
	    	  return true;
	    	});
	    
	    // 최종 컬럼 
	    const newColumns = baseCols.concat(dynCols);

	    // attach 이후에 setColumns 호출 
	    grid.setColumns(newColumns);
	  
			var dimValueIdArray = dimValueId.split(',');		
			for(var i = 0 ; i < dimValueIdArray.length ; i++){	
				if (i == 0) {
					dimValueId = "'" + dimValueIdArray[i] + "'";
				} else {
					dimValueId = dimValueId + ",'" + dimValueIdArray[i] + "'";
				}
			}
			
		
	}
	
	
 	function fnReload(newGridData){
 	 	
 	    grid.data.parse(newGridData);

 	} 
 	

	
	// END ::: GRID	
	//===============================================================================
		
</script>

<div id="framecontent" class="mgT10">	
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="font-size:12px;">
			<colgroup>
				<col width="15%">
				<col>
			</colgroup>
			<tr>
				<!-- Download Option -->
				<th class="pdB5" style="text-align:left;">&nbsp;&nbsp;${menu.LN00021}</th>
				<td colspan="3" class="pdB5">
					<select id="ItemTypeCode" name="ItemTypeCode">
						<option value="">Select</option>
						<c:forEach var="i" items="${itemTypeCodeList}">
							<option value="${i.CODE}">${i.NAME}</option>						
						</c:forEach>	
					</select>
					<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="getDimensionInfo();" value="검색">
				</td>
			</tr>
		</table>
	</div>

<!-- BIGIN :: LIST_GRID -->
<div id="maincontent">
	<div id="divExcelDownBtn" class="alignBTN mgB5" style="display:none;">
		<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
	</div>
	<div class="file_search_list">
		<div id="excelGridArea" style="width:100%"></div>
	</div>
</div>	

<div id="blankFrame" name="blankFrame" width="0" height="0" style="display:none"></div>	
<!-- END :: LIST_GRID -->
