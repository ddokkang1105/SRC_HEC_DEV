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

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

<style>
.dhx_grid-cell {
	color: rgba(0, 0, 0, 0.95);
}
.dhx_grid-cell .edit-button, .dhx_grid-cell .save-button {
	padding: 0 25px;
}
.dhx_layout-rows {
	flex: 1 auto;
}
.dhx_layout-columns .dhx_layout-rows:first-child .dhx_form-element {
	padding-right:20px;
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

		// 초기 표시 화면 크기 조정
		$("#layout").attr("style","height:"+(setWindowHeight() - 140)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 140)+"px;");
		};
		
		$("#excel").click(function (){
			fnGridExcelDownLoad();
		});
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	//그리드ROW선택시
	function gridOnRowOTSelect(data) {
		var url = "AttributeTypeView.do"; // 요청이 날라가는 주소
		var data = "itemID="+ data.row.AttrTypeCode + "&isComLang="+ data.row.IsComLang + "&pageNum="+pagination.getPage();
		var target = "attributeTypeDiv";
		ajaxPage(url,data,target);
	}
	
	//popup 창 띄우기, 창 크기 부분
	function AddPopup() {
		var url = "AddAttributePopup.do";
		var option = "width=510,height=260,left=500,top=300,toolbar=no,status=no,resizable=yes";
	    window.open(url, self, option);
	}
	
	// [Del] Click
	function delAttributeType() {
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00023}");
		} else {
			if (confirm("${CM00004}")) {
				var attrTypeCodes = "";
				for(idx in selectedCell){
					if(selectedCell[idx].CNT > 0 || selectedCell[idx].AttrTypeCode === "AT00001") {
						var id = "ID:" + selectedCell[idx].AttrTypeCode;
						"<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00112' var='WM00112' arguments='"+ id +"'/>"
						alert("${WM00112}");
						grid.data.update(selectedCell[idx].id, { checkbox: false });
					} else {
					    if (attrTypeCodes == "") {
					    	attrTypeCodes = selectedCell[idx].AttrTypeCode;
						} else {
							attrTypeCodes += ","+selectedCell[idx].AttrTypeCode;
						}
					}
				};
				
				if (attrTypeCodes != "") {
					var url = "admin/delAttributeType.do";
					var data = "attrTypeCodes=" + attrTypeCodes;
					var target = "blankFrame";
					ajaxPage(url, data, target);
				}
			}
		}
		
	}
	
	function urlReload() {
		$.ajax({
			url: "getAttrTypeList.do",
			data:"",
			type:"POST",
			cotentType:"application/json",
			success: function(result){				
				if(grid != ""){
					grid.data.parse(result);
				}
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
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
				<li style="font-size:14px;"><a style="font-weight:400;font-size:14px;">Master data&nbsp;></a>&nbsp;&nbsp;Attribute Type</li>
			</ul>
		</div>
		<div class="child_search01 mgL10 mgR10">
			<ul>
				<li class="floatR pdR10">
				<c:if test="${sessionScope.loginInfo.sessionLogintype == 'editor'}">
				<button class="cmm-btn mgR5" style="height: 30px;" onclick="AddPopup()" value="Add" >Add Attribute Type</button>
				<button class="cmm-btn mgR5" style="height: 30px;" id="excel" value="Down" >Download List</button>
				<button class="cmm-btn mgR5" style="height: 30px;" onclick="delAttributeType()" value="Del">Delete</button>
				</c:if>
				</li>
			</ul>
		</div>
		</div>
		
		<div style="width: 100%;" id="layout"></div>
		<div id="pagination"></div>
</form>
</div>	
 
		<!-- START :: FRAME -->
		<div class="schContainer" id="schContainer">
			<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display: none" frameborder="0" scrolling='no'></iframe>
		</div>
		
	<script>
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
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}", align:"center" }], align: "center" },
	        { width: 50, id: "checkbox", type: "boolean", header: [{ text: "", align:"center" }], editable: true },
	        { width: 130, id: "AttrTypeCode", header: [{ text: "${menu.LN00015}", align:"center" }, { content: "inputFilter" }], align: "center" },
	        { fillspace: true, id: "Name", header: [{ text: "${menu.LN00028}", align:"center" }, { content: "inputFilter" }] },
	        {
	            id: "action", width: 200, header: [{ text: "Actions", align: "center" }],
	            htmlEnable: true, align: "center",
	            template: function () {
	                return '<span class="btn_pack small icon mgR10 edit"><span class="config"></span><input value="Config." type="submit"></span>';
	            }
	        },
	        { width: 120,  id: "DataType", header: [{ text: "Data Type", align:"center" }, { content: "selectFilter" }], align: "center" },
	        { width: 120,  id: "Customizable", header: [{ text: "Customizable", align:"center" }], align: "center" },
	        { width: 120,  id: "HTML", header: [{ text: "HTML", align:"center" }], align: "center" },
	        { width: 120,  id: "IsComLang", header: [{ text: "IsComLang", align:"center" }], align: "center" },
	        { width: 120,  id: "Editable", header: [{ text: "Editable", align:"center" }], align: "center" },
	        { width: 120,  id: "LastUpdated", header: [{ text: "${menu.LN00070}", align:"center" }], align: "center" },
	        { hidden: true,  id: "CNT", header: [{ text: "CNT" }]},
       	 	
	    ],
	    eventHandlers: {
	        onclick: {
	            "edit": function (e, data) {
	            	gridOnRowOTSelect(data);
	            }
	        }
	    },
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	});
	
	layout.getCell("a").attach(grid);
	
	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 20,
	});	

	pagination.setPage(document.getElementById('currPage').value);
	
	</script>
</body>
</html>