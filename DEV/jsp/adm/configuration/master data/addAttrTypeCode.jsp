<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<% request.setCharacterEncoding("utf-8"); %>
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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00034" var="CM00034" />

<style>
	.dhx_grid-cell {
		color: rgba(0, 0, 0, 0.95);
	}
</style>

<!-- 2. Script -->
<script type="text/javascript">
	$(document).ready(function() {
		$.ajaxSetup({
			headers: {
				'X-CSRF-TOKEN': "${sessionScope.CSRF_TOKEN}"
			},
		});
	});
	

	
	//[save] 이벤트 후 처리
	function selfClose() {
		//var opener = window.dialogArguments;
		opener.doOTSearchList();
		self.close();
	}
	
</script>
<body>
	<div class="title-section">
		Attribute Type
		<span class="floatR btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="fnAdd()"></span>
	</div>
	<div id="layout" style="width:100%;height:530px;"></div>
	<!-- START :: FRAME -->
	<div class="schContainer" id="schContainer">
		<iframe name="ArcFrame" id="ArcFrame" src="about:blank"
			style="display: none" frameborder="0" scrolling='no'></iframe>
	</div>
</body>
<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});

	var gridData = ${gridData};
	var grid = new dhx.Grid("gridArea", {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}",align:"center"}], align: "center" },
	        { width: 50, id: "checkbox", header: [{ htmlEnable:true,  text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 150, id: "AttrTypeCode", header: [{ text: "${menu.LN00015}",align:"center"  }, { content: "inputFilter" }], align: "center" },
	        { width: 150,  id: "DataType", header: [{ text: "Category" ,align:"center" }, { content: "selectFilter" }],align:"center"  },
	        { id: "Name", header: [{ text: "${menu.LN00028}",align:"center"  }, { content: "inputFilter" }],align:"center"  },
	        { id: "Description", header: [{ text: "${menu.LN00035}",align:"center"  }, { content: "inputFilter" }],align:"center"  }
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    multiselection : true,
	});

	layout.getCell("a").attach(grid);
	
	function fnAdd(){
		
		var selectedCell = grid.data.findAll(function (data) {
			return data.checkbox; 
		});
		if(!selectedCell.length){
			alert("${WM00023}");	//alert("항목을 한개 이상 선택하여 주십시요.");	
		}else{
			if (confirm("${CM00034}")) {  //if (confirm("선택된 항목을 저장하시겠습니까?"))
				var attrCodes = "";
				for (idx in selectedCell) {
					if (attrCodes == "") {
						attrCodes = selectedCell[idx].AttrTypeCode;
					} else {
						attrCodes = attrCodes + "," + selectedCell[idx].AttrTypeCode;
					}
				}
				var Category = "${Category}";
				var target = "ArcFrame";
				if(Category == "ESM"){
					var url = "SaveSRAttrType.do";
					var target = "ArcFrame";
					var data = "attrCodes=" + attrCodes
							+ "&s_itemID=${s_itemID}" 
							+ "&languageID=${languageID}";
				}else{
					var url = "admin/SaveAttrType.do";				
					var data = "attrCodes=" + attrCodes
							+ "&ItemClassCode=${TypeCode}" 
							+ "&ItemTypeCode=${ItemTypeCode}";
				}
	 			ajaxPage(url, data, target);
				grid.data.remove(selectedCell[idx].id);	
			}
		}
		
	
	}
</script>

</html>