<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root" />

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
		
		fnSelect('DataType', '', 'AttpopupType', '', 'All');
		$("#excel").click(function(){OT_gridArea.toExcel("${root}excelGenerate");});
		
		gridOTInit();
		doOTSearchList();
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//===============================================================================
	//BEGIN ::: GRID
	//그리드 초기화
	function gridOTInit() {
		var d = setOTGridData();
		OT_gridArea = fnNewInitGrid("grdOTGridArea", d);
		OT_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		fnSetColType(OT_gridArea, 1, "ch");
		OT_gridArea.setColumnHidden(5, true);
		OT_gridArea.setColumnHidden(6, true);
		OT_gridArea.setColumnHidden(7, true);
		OT_gridArea.setColumnHidden(8, true);		
		OT_gridArea.setColumnHidden(12, true);
		OT_gridArea.setColumnHidden(13, true);					
		OT_gridArea.attachEvent("onRowSelect", function(id, ind) { //id : ROWNUM, ind:Index
			gridOnRowOTSelect(id, ind);
		});
		//START - PAGING
		//OT_gridArea.enablePaging(true, df_pageSize, null, "pagingArea", true, "recinfoArea");
		OT_gridArea.enablePaging(true,20,10,"pagingArea",true, "recinfoArea");
		OT_gridArea.setPagingSkin("bricks");
		
		OT_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
		//END - PAGING
	}

	function setOTGridData() {
		var result = new Object();
		result.title = "${title}";
		result.key = "AttributeType_SQL.getDefineAttrList";
		result.header = "${menu.LN00024},#master_checkbox,${menu.LN00015},${menu.LN00028},Data Type,${menu.LN00035},${menu.LN00060},${menu.LN00060},${menu.LN00064},Customizable,HTML,IsComLang,Category,LanguageID,Editable,${menu.LN00070},CNT";
		result.cols = "CHK|AttrTypeCode|Name|DataType|Description|Creator|CreateName|CreationTime|Customizable|HTML|IsComLang|Category|LanguageID|Editable|LastUpdated|CNT";
		result.widths = "50,50,100,150,80,290,100,100,90,100,90,80,70,100,100,100,0";
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
						+ "&searchKey="     + $("#searchKey").val()
						+ "&searchValue="     	+ $("#searchValue").val()
						+ "&pageNum="      + $("#currPage").val();
		
		if($("#DataType").val() != '' && $("#DataType").val() != null){
			result.data = result.data +"&DataType="+$("#DataType").val();
		}

		return result;
	}
	
	function doOTSearchList() {
		var d = setOTGridData();
		fnLoadDhtmlxGridJson(OT_gridArea, d.key, d.cols, d.data);
	}
	
	//그리드ROW선택시
	function gridOnRowOTSelect(id, ind) {
		if(ind != 1) {
			var url = "AttributeTypeView.do"; // 요청이 날라가는 주소
			var data = "itemID="+ OT_gridArea.cells(id, 2).getValue() 
					+ "&isComLang="+ OT_gridArea.cells(id, 12).getValue() 
					+ "&pageNum=" + $("#currPage").val();
			var target = "attributeTypeDiv";
			ajaxPage(url,data,target);
		}
	}
	
	//popup 창 띄우기, 창 크기 부분
	function AddPopup() {
		var url = "AddAttributePopup.do";
		var option = "width=510,height=260,left=500,top=300,toolbar=no,status=no,resizable=yes";
	    window.open(url, self, option);
	}
	
	// [Del] Click
	function delAttributeType() {

		if (OT_gridArea.getCheckedRows(1).length == 0) {
			//alert("항목을 한개 이상 선택하여 주십시요.");	
			alert("${WM00023}");
		} else {
			//if (confirm("선택된 항목을 삭제하시겠습니까?")) {
			if (confirm("${CM00004}")) {
				var checkedRows = OT_gridArea.getCheckedRows(1).split(",");
				var attrTypeCodes = "";
				for ( var i = 0; i < checkedRows.length; i++) {
					var cnt = OT_gridArea.cells(checkedRows[i], 16).getValue();
					var id = OT_gridArea.cells(checkedRows[i], 2).getValue();
					
					if (cnt > 0 || id == 'AT00001') {
						id = "ID:" + id;
						"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00112' var='WM00112' arguments='"+ id +"'/>"
						alert("${WM00112}");
						OT_gridArea.cells(checkedRows[i], 1).setValue(0); 
					} else {
						if (attrTypeCodes == "") {
							attrTypeCodes = id;
						} else{ 
							attrTypeCodes = attrTypeCodes + "," + id;
						}
					}
				}
				
				if (attrTypeCodes != "") {
					var url = "delAttributeType.do";
					var data = "attrTypeCodes=" + attrTypeCodes;
					var target = "blankFrame";
					ajaxPage(url, data, target);
				}
			}
		}
		
	}
	
	function urlReload() {
		var url = "DefineAttributeType.do";
		var target = "attributeTypeDiv";
		var data = "pageNum=" + $("#currPage").val(); 	
	 	ajaxPage(url,data,target);
	}
	
</script>
</head>
<body>
<div id="attributeTypeDiv">
	<form name="objectTypeList" id="objectTypeList" action="saveObject.do" method="post" onsubmit="return false;"> 
	<div id="processListDiv">   
		<input type="hidden" id="SaveType" name="SaveType" value="New" />
		<input type="hidden" id="s_itemID" name="s_itemID" value="${s_itemID}">
		<input type="hidden" id="loginID" name="loginID" value="${sessionScope.loginInfo.sessionUserId}"/>
		<input type="hidden" id="currPage" name="currPage" value="${pageNum}"/> 
		<div class="cfgtitle" >			
			<ul>
				<li><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;Attribute Type</li>
			</ul>
		</div>
		<div class="child_search01 mgL10 mgR10">
			<li class="pdL10">Data Type 
				<select id="DataType" name="DataType"  onchange="doOTSearchList();" style="margin-left:5px;"></select>
			</li>
			<li>
				<select id="searchKey" name="searchKey" style="width:60px;">
					<option value="Name">${menu.LN00028}</option>
					<option value="ID" <c:if test="${!empty searcgID}">selected = "selected"</c:if>>ID</option>
				</select>
				<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:150px;ime-mode:active;">
				<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="doOTSearchList();" value="검색">
			</li>
			<li class="floatR pdR10">
<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<!-- 엑셀 다운 아이콘  -->
				&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
				<!-- ADD 버튼  -->
				&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" alt="신규" onclick="AddPopup()"></span>
				<!-- DEL 버튼 -->
				&nbsp;<span class="btn_pack small icon"><span class="del"></span><input value="Del" type="submit" onclick="delAttributeType()"></span>
</c:if>
			</li>
		</div>
		</div>
		
	 	<div class="countList pdL10">
        <li class="count">Total <span id="TOT_CNT"></span></li>
        <li class="floatR">&nbsp;</li>
        </div>
		<div id="gridOTDiv" class="mgB10 clear mgL10 mgR10">
			<div id="grdOTGridArea" style="width: 100%"></div>
		</div>
		<!-- START :: PAGING -->
		<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
		<!-- END :: PAGING -->	
</form>
</div>	
 
		<!-- START :: FRAME -->
		<div class="schContainer" id="schContainer">
			<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
		</div>
</body>
</html>