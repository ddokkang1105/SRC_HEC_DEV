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

var OT_gridArea;				//그리드 전역변수
var skin = "dhx_skyblue";
var schCntnLayout;	//layout적용

$(document).ready(function() {	
	
	// 초기 표시 화면 크기 조정
	$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 160)+"px;");
	// 화면 크기 조정
	window.onresize = function() {
		$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 160)+"px;");
	};
	
	$("#excel").click(function(){OT_gridArea.toExcel("${root}excelGenerate");});
	if ("${CategoryCode}" != "") {
		changeObjectType("${CategoryCode}", 1);
		setTimeout(function(){
			$("#ItemTypeCode").msDropDown();
		}, 200);
	}
	
	setTimeout(function(){
		$("#CategoryCode").msDropDown();
	},100);
	
	$('#CategoryCode').change(function(){
		changeObjectType($(this).val(), 0);
		setTimeout(function(){
			$("#ItemTypeCode").msDropDown();
		}, 100);
	});
	
	//Grid 초기화
	gridOTInit();
	doOTSearchList();
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

//===============================================================================
// BEGIN ::: GRID
//그리드 초기화
function gridOTInit(){		
	var d = setOTGridData();
	OT_gridArea = fnNewInitGrid("grdOTGridArea", d);
	OT_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
	fnSetColType(OT_gridArea, 1, "ch");
	OT_gridArea.setColumnHidden(4, true);
	OT_gridArea.setColumnHidden(12, true);
	OT_gridArea.setColumnHidden(13, true);
	OT_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
	fnSetColType(OT_gridArea, 2, "img");
	
	
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
	result.key = "config_SQL.getAllocateClassList";
	result.header = "${menu.LN00024},#master_checkbox,Icon,${menu.LN00015},${menu.LN00028},${menu.LN00028},Level,File Option,Change Management,Dimension,Deactivated,${menu.LN00070},DefWFID,WorkFlow";
	result.cols = "CHK|Icon|ItemClassCode|Name|ClassName|Level|FileOption|ChangeMgt|HasDimension|Deactivated|LastUpdated|DefWFID|WorkFlow";
	result.widths = "50,50,60,100,250,*,100,100,150,100,100,100";
	result.sorting = "int,int,str,str,str,str,str,str,int,str,str,str,str,str";
	result.aligns = "center,center,center,center,center,left,center,center,center,center,center,center";
	result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&pageNum="      + $("#currPage").val();
	 			
	/* 검색 조건 선택 */
	// [Item Category]
	if($("#CategoryCode").val() != '' && $("#CategoryCode").val() != null){
		result.data = result.data +"&Category="+$("#CategoryCode").val();
	}  else {
		if ("${CategoryCode}" != "") {
			result.data = result.data +"&Category=${CategoryCode}";
		}
	}
	
	var ItemTypeCode = "${ItemTypeCode}";
	if(ItemTypeCode == null || ItemTypeCode == ''){
			result.data = result.data +"&ItemTypeCode="+$("#ItemTypeCode").val();
	} else {
		if($("#ItemTypeCode").val() != '' && $("#ItemTypeCode").val() != null ){
			result.data = result.data +"&ItemTypeCode="+$("#ItemTypeCode").val();
		} else {
			 if ($("#ItemTypeCode_title > .ddlabel").text() == 'Select'){
				 result.data = result.data;
			 } else {
				 result.data = result.data +"&ItemTypeCode="+ItemTypeCode;
			 }
		}
	}
	
	return result;
}

//그리드ROW선택시
function gridOnRowOTSelect(id, ind) {
	
	if(ind != 1)
	{
		doDetail(id);
	}

}

function doDetail(id){	
	var url = "ClassTypeView.do";
	var data = "ItemClassCode="+ OT_gridArea.cells(id, 3).getValue() + 
				"&ClassName="+ OT_gridArea.cells(id, 4).getValue() + 
				"&ItemTypeCode="+ $("#ItemTypeCode").val() +
				"&CategoryCode="+ $("#CategoryCode").val() +
				"&pageNum=" + $("#currPage").val();
	var target = "classTypeDiv";
	
	ajaxPage(url,data,target);
	
}

// END ::: GRID	
//===============================================================================

	
//조회
function doOTSearchList(){
	var d = setOTGridData();
	fnLoadDhtmlxGridJson(OT_gridArea, d.key, d.cols, d.data);
}

//popup 창 띄우기, 창 크기 부분
function AddClassPopup() {
	var url = "addClassPop.do";
	var option = "width=510,height=250,left=300,top=300,toolbar=no,status=no,resizable=yes";
	window.open(url, self, option);
}

function urlReload() {
	doOTSearchList();	
}

function delClassType() {
	if (OT_gridArea.getCheckedRows(1).length == 0) {
		//alert("항목을 한개 이상 선택하여 주십시요.");	
		alert("${WM00023}");	
	} else {
		//if (confirm("선택된 항목을 삭제하시겠습니까?")) {
		if (confirm("${CM00004}")) {
			var checkedRows = OT_gridArea.getCheckedRows(1).split(",");
			var classCodes = "";
			for ( var i = 0; i < checkedRows.length; i++) {
				var cnt = OT_gridArea.cells(checkedRows[i], 20).getValue();
				if (cnt > 0) {
					var id = "ID:" + OT_gridArea.cells(checkedRows[i], 3).getValue();
					"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00112' var='WM00112' arguments='"+ id +"'/>"
					alert("${WM00112}");
					OT_gridArea.cells(checkedRows[i], 1).setValue(0); 
				} else {
					if (classCodes == "") {
						classCodes = OT_gridArea.cells(checkedRows[i], 3).getValue();
					} else{ 
						classCodes = classCodes + "," + OT_gridArea.cells(checkedRows[i], 3).getValue();
					}
				}
				
			}
			
			if (classCodes != "") {
				var url = "delClassType.do";
				var data = "classCodes=" + classCodes;
				var target = "ArcFrame";
				ajaxPage(url, data, target);
			}
			
		}
	}
	
}
	
function changeObjectType(avg1, avg2){
	var url    = "getObjectTypeList.do"; // 요청이 날라가는 주소
	var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&option="+avg1; //파라미터들
	var target = "ItemTypeCode";             // selectBox id
	var defaultValue = "";              // 초기에 세팅되고자 하는 값
	var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
	
	if (avg2 == 1) {
		defaultValue = "${ItemTypeCode}";  
	}
	
	ajaxSelect(url, data, target, defaultValue, isAll);
}

</script>

<body>
<div id="classTypeDiv">
<form name="classTypeList" id="classTypeList" action="#" method="post" onsubmit="return false;">
	<div id="processListDiv">
	<input type="hidden" id="setId" name="setId">
	<input type="hidden" id="LanguageID" name="LanguageID" value="${LanguageID}"/>
	<input type="hidden" id="SaveType" name="SaveType" value="New">
	<input type="hidden" id="orgClassCode" name="orgClassCode">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	</div>
	<div class="cfgtitle" >					
		<ul>
			<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Class Type</li>
		</ul>
	</div>
	<div class="child_search01 mgL10 mgR10" >
		<li class="pdL10">Item Category
			<select id="CategoryCode" name="CategoryCode" style="width:100px;margin-left:5px;">
				<option value="">Select</option>
				<c:forEach var="i" items="${CategoryOption}">
					<option value="${i.Category}" <c:if test="${i.Category eq CategoryCode}"> selected="selected"</c:if>>${i.Category}</option>						
				</c:forEach>				
			</select>
		</li>			
		<li class="pdL10">Item Type
			<select id="ItemTypeCode" name="ItemTypeCode" style="width:160px;margin-left:5px;">
				<option value="">Select</option>			
			</select>
		</li>
		<li class="pdL5">
			<input id="btnSearch" type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doOTSearchList();" value="검색">
		</li>	
		<li class="floatR pdR10">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<!-- 엑셀 다운 아이콘  -->
				&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
				<!-- ADD 버튼  -->
				&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" alt="신규" onclick="AddClassPopup()"></span>
				<!-- DEL 버튼 -->
				&nbsp;<span class="btn_pack small icon" style="display:none;"><span class="del"></span><input value="Del" type="submit" onclick="delClassType()"></span>
			</c:if>
		</li>
	</div>
    <div class="countList pdL10">
         <li class="count">Total  <span id="TOT_CNT"></span></li>
         <li class="floatR">&nbsp;</li>
     </div>
</form>
	<div id="gridOTDiv" class="mgB10 clear mgL10 mgR10">
		<div id="grdOTGridArea" style="height:400px; width:100%"></div>
	</div>
	<!-- START :: PAGING -->
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	<!-- END :: PAGING -->	
</div>	
<!-- START :: FRAME -->
<div class="schContainer" id="schContainer">
	<iframe name="ArcFrame" id="ArcFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
</div>
</body>
</html>