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

<!-- 2. Script -->
<script type="text/javascript">
$(document).ready(function() {	
	// 초기 표시 화면 크기 조정
	$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 160)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 160)+"px;");
	};
	$("#excel").click(function(){OT_gridArea.toExcel("${root}excelGenerate");});
	gridOTInit();
	doOTSearchList();
});

function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

//===============================================================================
//BEGIN ::: GRID
//그리드 초기화
function gridOTInit(){		
	var d = setOTGridData();	
	OT_gridArea = fnNewInitGrid("grdOTGridArea", d);
	OT_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
	fnSetColType(OT_gridArea, 1, "ch");
	
	OT_gridArea.setColumnHidden(6, true);
	OT_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
		gridOnRowOTSelect(id,ind);
	});
	//START - PAGING
	//OT_gridArea.enablePaging(true, df_pageSize, null, "pagingArea", true, "recinfoArea");
	OT_gridArea.enablePaging(true,20,10,"pagingArea",true,"recInfoArea");
	OT_gridArea.setPagingSkin("bricks");
	OT_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	//END - PAGING
}  

function setOTGridData(){
	
	var result = new Object();
	result.title = "${title}";
	
	result.key = "config_SQL.FileType";
	result.header = "${menu.LN00024},#master_checkbox,FltpCode,Name,Is public, FilePath,CNT";
	result.cols = "CHK|FltpCode|Name|IsPublic|FilePath|CNT";
	result.widths = "50,50,150,200,100,*,0";
	result.sorting = "int,int,str,str,str,str,str";
	result.aligns = "center,center,center,center,center,left,left";
	result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
		+ "&TypeCode=${s_itemID}" + "&pageNum=" + $("#currPage").val();
	return result;

}

//그리드ROW선택시
function gridOnRowOTSelect(id, ind){
	if(ind != 1){
		var url = "fileTypeView.do";
		var data = "FltpCode="+ OT_gridArea.cells(id, 2).getValue() + "&pageNum=" + $("#currPage").val();		 
		var target = "fileTypeDiv";
		ajaxPage(url, data, target);
	}
}

function doOTSearchList(){
	var d = setOTGridData();
	fnLoadDhtmlxGridJson(OT_gridArea, d.key, d.cols, d.data);
}

//END ::: GRID
//===============================================================================
	
//[Add Click] popup 창 띄우기, 창 크기 부분
function AddFltpTypePop() {
	var url = "addFileTypePop.do";
	var option = "width=510,height=240,left=500,top=300,toolbar=no,status=no,resizable=yes";
    window.open(url, self, option);
}

//[Del Click]
function delFileType() {
	if (OT_gridArea.getCheckedRows(1).length == 0) {
		//alert("항목을 한개 이상 선택하여 주십시요.");	
		alert("${WM00023}");
		return false;
	}
	
	if (confirm("${CM00004}")) {
		var checkedRows = OT_gridArea.getCheckedRows(1).split(",");
		var itemTypeCodes = "";
		for ( var i = 0; i < checkedRows.length; i++) {
			var cnt = OT_gridArea.cells(checkedRows[i], 5).getValue();
			if (cnt > 0) {
				var id = "ID:" + OT_gridArea.cells(checkedRows[i], 2).getValue();
				"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00112' var='WM00112' arguments='"+ id +"'/>"
				alert("${WM00112}");
				OT_gridArea.cells(checkedRows[i], 1).setValue(0); 
			} else {
				if (itemTypeCodes == "") {
					itemTypeCodes = OT_gridArea.cells(checkedRows[i], 2).getValue();
				} else{ 
					itemTypeCodes = itemTypeCodes + "," + OT_gridArea.cells(checkedRows[i], 2).getValue();
				}
			}
		}
		
		if (itemTypeCodes != "") {
			var url = "delFileType.do";
			var data = "fltpCodes=" + itemTypeCodes;
			var target = "blankFrame";
			ajaxPage(url, data, target);
		}
	}
}

function urlReload() {
	doOTSearchList();
}


</script>

</head>

<body>
<div id="fileTypeDiv">
<form name="processList" id="processList" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<div class="cfgtitle" >					
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;File Type</li>
		</ul>
	</div>

	<div class="child_search01 mgL10 mgR10">
		<ul>
		<li class="floatR pdR10">
<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
		<!-- 엑셀 다운 아이콘  -->
		&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		<!-- 생성 아이콘 -->
		&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="AddFltpTypePop();" ></span>
		<!-- 삭재 아이콘 -->
		&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delFileType();" ></span>
</c:if>	
		</li>
		</ul>
	</div>
	<div class="countList pdL10">
         <li class="count">Total  <span id="TOT_CNT"></span></li>
         <li class="floatR">&nbsp;</li>
     </div>
</form>
	<div id="gridOTDiv" class="mgB10 clear mgL10 mgR10">
		<div id="grdOTGridArea" style="width:100%"></div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->	
</div>
	
<!-- START :: FRAME --> 		
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>	
<!-- END :: FRAME -->	
		
</body>
</html>