<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
$(function(){
	
	gridOTInit();
	doOTSearchList();
});


//===============================================================================
//BEGIN ::: GRID
//그리드 초기화
function gridOTInit(){		
	var d = setOTGridData();	
	OT_gridArea = fnNewInitGrid("grdOTGridArea", d);
	OT_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
	fnSetColType(OT_gridArea, 1, "ch");
	OT_gridArea.setColumnHidden(3, true);
	OT_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
		gridOnRowOTSelect(id,ind);
	});
	//START - PAGING
	//OT_gridArea.enablePaging(true, df_pageSize, null, "pagingArea", true, "recinfoArea");
	OT_gridArea.enablePaging(true,20,10,"pagingArea",true, "recinfoArea");
	OT_gridArea.setPagingSkin("bricks");
	OT_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	//END - PAGING
}  

function setOTGridData(){

	var result = new Object();
	result.title = "${title}";
	result.key = "config_SQL.SelectModelType";
	result.header = "${menu.LN00024},#master_checkbox,${menu.LN00015},ItemTypeCode,${menu.LN00028},${menu.LN00035},ArisTypeNum,IsModel,ZoomOption,ZoomOption";	
	result.cols = "CHK|ModelTypeCode|ItemTypeCode|Name|Description|ArisTypeNum|IsModel|ZoomOptionName|ZoomOption"; 
	result.widths = "50,50,100,100,200,350,100,100,100,0";
	result.sorting = "int,int,str,str,str,str,str,str,str,str";
	result.aligns = "center,center,center,center,center,center,center,center,center,center";
	result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&pageNum=" + $("#currPage").val();
							
	
	//alert(result.data);			
	return result;

}

//그리드ROW선택시

function gridOnRowOTSelect(id, ind) {
	
	var url = "modelTypeView.do";
	var data = "&ModelTypeCode="+ OT_gridArea.cells(id,2).getValue() + 
				"&ItemTypeCode="+ OT_gridArea.cells(id,3).getValue() + 
				"&Name="+ OT_gridArea.cells(id,4).getValue() + 
				"&languageID=${sessionScope.loginInfo.sessionCurrLangType}" +
				 "&pageNum=" + $("#currPage").val();
	var target = "ModelTypeList";
	
	ajaxPage(url,data,target);
	
}

// END ::: GRID	
//===============================================================================


function doOTSearchList(){
	var d = setOTGridData();
	fnLoadDhtmlxGridJson(OT_gridArea, d.key, d.cols, d.data);
}

//popup 창 띄우기, 창 크기 부분
function addModelTypePop() {

	var url = "addModelTypePop.do";

	var data = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}" +
				"&pageNum=" + $("#currPage").val();
	
	var option = "width=510,height=360,left=300,top=100,toolbar=no,status=no,resizable=yes";
	url += "?"+ data;
	
    window.open(url, self, option);

}

function delModelFLow() {

	if (OT_gridArea.getCheckedRows(1).length == 0) {
		//alert("항목을 한개 이상 선택하여 주십시요.");	
		alert("${WM00023}");	
	} else {
		//if (confirm("선택된 항목을 삭제하시겠습니까?")) {
		if (confirm("${CM00004}")) {
			var checkedRows = OT_gridArea.getCheckedRows(1).split(",");
			for ( var i = 0; i < checkedRows.length; i++) {
				var url = "DelModelType.do";

				var data = "&ModelTypeCode=" + OT_gridArea.cells(checkedRows[i], 2).getValue()
						+ "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}";
				
				if (i + 1 == checkedRows.length) {
					data = data + "&FinalData=Final";
				}

				var target = "ModelFrame";
				ajaxPage(url, data, target);
				OT_gridArea.deleteRow(checkedRows[i]);
			}
		}
	}
}

function urlReload() {
	var url = "modelType.do";
	var target = "ModelFrame";
	var data = "LanguageID=${sessionScope.loginInfo.sessionCurrLangType}" +
					"&pageNum=" + $("#currPage").val(); 
 	ajaxPage(url,data,target);
}

</script>
</head>
<body>
<div id="modelTypeDiv">
<form name="ModelTypeList" id="ModelTypeList" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="SaveType" name="SaveType" value="New" />
		<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
		<div class="cfgtitle" >					
			<ul>
				<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Model Type</li>
	
			</ul>
		</div>
		<div class="child_search01 mgL10 mgR10">
			<ul>
				<li class="floatR pdR10">
					<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
					
							<!-- 엑셀 다운 아이콘  -->
							&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
								
							<!-- 생성 아이콘 -->
							&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit"  alt="신규" onclick="addModelTypePop()" ></span>
				
							<!-- 삭제 아이콘 -->
							&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delModelFLow()" ></span>
					</c:if>	
				</li>
			</ul>
		</div>
	
	   <div id="processListDiv" class="hidden"	style="width: 100%; height: 100%;">
            <div class="countList pdL10">
                 <li class="count">Total  <span id="TOT_CNT"></span></li>
            	 <li class="floatR">&nbsp;</li>
         </div>
                
			<div id="gridOTDiv" class="mgB10 clear mgL10 mgR10">
				<div id="grdOTGridArea" style="height: 360px; width: 100%"></div>
			</div>
		</div>
	<!-- START :: PAGING -->
		<div style="width:100%;" class="paginate_regular">
			<div id="pagingArea" style="display:inline-block;"></div>
			<div id="recinfoArea" class="floatL pdL10"></div>
	<!-- END :: PAGING -->
	     </div>
	</form>
	<div id="testDiv"></div>
	</div>
	<!-- START :: FRAME --> 		
	<div class="schContainer" id="schContainer">
		<iframe name="ModelFrame" id="ModelFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	</div>		
</body>
</html>