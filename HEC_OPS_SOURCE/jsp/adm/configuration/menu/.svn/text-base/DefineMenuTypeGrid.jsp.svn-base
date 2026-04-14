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
	var OT_gridArea;
	
	$(document).ready(function() {
		// 초기 표시 화면 크기 조정
		$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 160)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdOTGridArea").attr("style","height:"+(setWindowHeight() - 160)+"px;");
		};
		
		fnSelect('menuCategory', '', 'getMenuCat', '', 'Select');
		$("#excel").click(function(){OT_gridArea.toExcel("${root}excelGenerate");});
		gridOTInit();
		doOTSearchList();
	});
	//===============================================================================
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
		
	//BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit(){		
		var d = setOTGridData();	
		OT_gridArea = fnNewInitGrid("grdOTGridArea", d);
		OT_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		fnSetColType(OT_gridArea, 1, "ch");
		OT_gridArea.setColumnHidden(8, true); // CNT
		OT_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowOTSelect(id,ind);
		});
		//START - PAGING
		OT_gridArea.enablePaging(true,50,10,"pagingArea",true, "recinfoArea");
		OT_gridArea.setPagingSkin("bricks");
		
		OT_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
		//END - PAGING
	}  
	
	function setOTGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "config_SQL.getDefineMenutypeCode";
		result.header = "No,#master_checkbox,MenuID,MenuName,URL,VarFilter,Category,Deactivated,CNT";	//7
		result.cols = "CHK|MenuID|MenuName|URL|VarFilter|Category|Deactivated|CNT"; //7-1
		result.widths = "50,50,100,200,*,200,150,70,0"; //7
		result.sorting = "int,int,str,str,str,str,str,str,str"; //7
		result.aligns = "center,center,center,left,left,left,center,center,center"; //7
		result.data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&menuCat=" + $("#menuCategory").val()
					+ "&searchKey="     + $("#searchKey").val()
					+ "&searchValue="     	+ $("#searchValue").val()
					+ "&pageNum=" + $("#currPage").val();
		
		return result;
	}
	
	//그리드ROW선택시
	function gridOnRowOTSelect(id, ind){
		if(ind != 1) {
			var url = "menuTypeDetailView.do"; // 요청이 날라가는 주소
			var data = "menuID="+ OT_gridArea.cells(id, 2).getValue() 
					+ "&pageNum=" + $("#currPage").val();
			var target = "menuTypeDiv";
			ajaxPage(url,data,target);
		}
		
	}
	
	function doOTSearchList(){
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(OT_gridArea, d.key, d.cols, d.data);
	}
	
	//END ::: GRID
	//===============================================================================
	
	//popup 창 띄우기, 창 크기 부분
	function addMenuPopup() {
		var url = "addMenuPopup.do";
		var option = "width=570,height=260,left=500,top=300,toolbar=no,status=no,resizable=yes";
	    window.open(url, self, option);
	}
		
	// [Del] Click
	function deleteMenu() {
		if (OT_gridArea.getCheckedRows(1).length == 0) {
			alert("${WM00023}");
		} else {
			if (confirm("${CM00004}")) {
				var checkedRows = OT_gridArea.getCheckedRows(1).split(",");
				var menuIds = "";
				for ( var i = 0; i < checkedRows.length; i++) {
					var menuCat = OT_gridArea.cells(checkedRows[i], 6).getValue();
					var cnt = OT_gridArea.cells(checkedRows[i], 8).getValue();
					var id = OT_gridArea.cells(checkedRows[i], 2).getValue();
					
					if (Number(cnt) > 0) {
						id = "ID:" + id;
						"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00112' var='WM00112' arguments='"+ id +"'/>"
						alert("${WM00112}");
						OT_gridArea.cells(checkedRows[i], 1).setValue(0); 
					} else {
						if (menuIds == "") {
							menuIds = id;
						} else{ 
							menuIds = menuIds + "," + id;
						}
					}
				}

				if (menuIds != "") {
					var url = "deleteMenu.do";
					var data = "menuIds=" + menuIds + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
					var target = "blankFrame";
					ajaxPage(url, data, target);
				}
			}
		}
		
	}
	
	function urlReload() {
		var url = "DefineMenuTypeGrid.do";
		var data = "pageNum="+ $("#currPage").val();
		var target = "menuTypeDiv";
		ajaxPage(url, data, target);
	}
	
	function fnOnChangeCategory(){		
		doOTSearchList();
	}
			
</script>

</head>
<body>
<div id="menuTypeDiv">
	<form name="processList" id="processList" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="currPage" name="currPage" value="${pageNum}"/> 
		<div class="cfgtitle" >					
			<ul>
				<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Menu</li>
			</ul>
		</div>	
		<div class="child_search01 mgL10 mgR10">
			<li class="pdL10">Category
			<select id="menuCategory" name="menuCategory" OnChange="fnOnChangeCategory()" style="width:120px;margin-left:5px;"></select>
			</li>			
			<li>
				<select id="searchKey" name="searchKey" style="width:60px;">
					<option value="Name">Name</option>
					<option value="URL">URL</option>
				</select>
				<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;">
				<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="doOTSearchList();" value="검색">
			</li>
			<li class="floatR pdR10">
					<!-- 엑셀 다운 아이콘  -->
					&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
					<!-- 생성 아이콘 -->
					&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="addMenuPopup();" ></span>
					<!-- 삭제 아이콘 -->
					&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="deleteMenu()" ></span>
				</c:if>	
			</li>
		</div>	
		<div class="countList pdL10">
	        <li class="count">Total  <span id="TOT_CNT"></span></li>
	        <li class="floatR">&nbsp;</li>
	    </div>
	</form>

	<div id="gridOTDiv"  class="mgB10 clear mgL10 mgR10">
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