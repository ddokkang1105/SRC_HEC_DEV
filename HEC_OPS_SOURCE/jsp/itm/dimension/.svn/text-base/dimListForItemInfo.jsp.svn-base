<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/> 

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>

<style type="text/css">
div.gridbox_dhx_web table.obj tr td{
    height: 17px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    max-width: 150px;
    max-height: 100px;
}
}
</style>

<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수

	$(document).ready(function() {	
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 260)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 260)+"px;");
		};
		gridInit();
		doSearchList();
	});		
	//===============================================================================
	// BEGIN ::: GRID
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	//그리드 초기화
	function gridInit(){		
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");
		fnSetColType(p_gridArea, 1, "ch");
		fnSetColType(p_gridArea, 7, "img");
		p_gridArea.setColumnHidden(5, true);
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		p_gridArea.attachEvent("onMouseOver", function (id, ind){ imgOnMouseOver();});
	}
	
	function imgOnMouseOver(){
		$(".row20px").find("img").attr("title", "View detail");
	}

	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "dim_SQL.selectDim";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00088},Code,Value,DimTypeID,Description,#cspan";	//5
		result.cols = "CHK|DimTypeName|DimValueID|DimValueName|DimTypeID|DescAbrv|ImgView";
		result.widths = "50,50,100,100,200,0,550,40";
		result.sorting = "str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,left,center";
		result.data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		
		/* 검색 조건 설정 */			
		// DimTypeID
		if($("#dimTypeId").val() != '' & $("#dimTypeId").val() != null){
			result.data = result.data +"&dimTypeId="+ $("#dimTypeId").val();
		}
		
		return result;
	}
	
	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data, false);
	}
	
	function gridOnRowSelect(id, ind){
		if(ind == 7){
			var dimTypeId = p_gridArea.cells(id, 5).getValue();
			var dimValueId = p_gridArea.cells(id, 3).getValue();
			var url = "viewItemDimDesc.do";
			var data = "?s_itemID=${s_itemID}&dimValueId=" + dimValueId+"&dimTypeId="+dimTypeId;
			window.open(url+data,'window','width=500, height=300, left=300, top=300,scrollbar=yes,resizble=0');
		}
	}
	
	// END ::: GRID	
	//===============================================================================
		
	// [Assign] click 이벤트	
	function assignOrg(){
		var url = "dimAssignTreePop.do";
		var data = "s_itemID=${s_itemID}";
		fnOpenLayerPopup(url,data,doCallBack,617,436);
	}
	function doCallBack(){}
	
	// [Assign popup] Close 이벤트
	function assignClose(){
		doSearchList();
	}
	
	// [Del] Click
	function delDimension() {
		if(p_gridArea.getCheckedRows(1).length == 0){
			//alert("항목을 한개 이상 선택하여 주십시요.");	
			alert("${WM00023}");	
		}else{
			if(confirm("${CM00004}")){
				var checkedRows = p_gridArea.getCheckedRows(1).split(",");
				var dimValueIds =""; 
				var dimTypeIds =""; 
				for(var i = 0 ; i < checkedRows.length; i++ ){
					if (dimTypeIds == "") {
						dimTypeIds = p_gridArea.cells(checkedRows[i], 5).getValue();
						dimValueIds = p_gridArea.cells(checkedRows[i], 3).getValue();
					} else {
						dimTypeIds = dimTypeIds + "," + p_gridArea.cells(checkedRows[i], 5).getValue();
						dimValueIds = dimValueIds + "," + p_gridArea.cells(checkedRows[i], 3).getValue();
					}
				}
				
				var url = "delDimensionForItem.do";
				var data = "s_itemID=${s_itemID}&dimTypeIds="+dimTypeIds+"&dimValueIds=" + dimValueIds;
				var target = "blankFrame";
				ajaxPage(url, data, target);			
			}
		}	
	}
	
	// [Back] click
	function goBack() {
		var url = "NewItemInfoMain.do";
		var target = "actFrame";
		var data = "s_itemID=${s_itemID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}"; 
		ajaxPage(url, data, target);
	}
	
</script>
<div>
	<div class="child_search">
	   <li class="shortcut">
	 	 <img src="${root}${HTML_IMG_DIR_ITEM}/img_cube.png"></img>&nbsp;&nbsp;<b>${menu.LN00088}</b>
	   </li>
	</div>
	<div class="countList">
		<li class="count">Total  <span id="TOT_CNT"></span></li>
	    <li class="floatR">&nbsp;</li>
	    
	   <li style="padding-left:100px !important;float:left;">
           <select id="dimTypeId" Name="dimTypeId">
               <option value=''>Select</option>
           	   <c:forEach var="i" items="${dimTypeList}">
                   <option value="${i.DimTypeID}">${i.DimTypeName}</option>
           	    </c:forEach>
       	   </select> 
       	   <input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doSearchList();" value="검색" style="cursor:pointer;">   
	   </li>
	   <li class="floatR pdR20">
			<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor' and myItem == 'Y'}">
				&nbsp;<span class="btn_pack small icon"><span class="assign"></span><input value="Assign" type="submit" onclick="assignOrg();"></span>
				&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delDimension();"></span>
			</c:if>
			<c:if test="${backBtnYN != 'N'}" >
			&nbsp;<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" type="submit" onclick="goBack()"></span>
			</c:if>
		</li>	
	</div>
	
	<div id="gridDiv" class="mgB10 clear">
		<div id="grdGridArea" style="width:100%"></div>
	</div>		
	
</div>	
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>	
