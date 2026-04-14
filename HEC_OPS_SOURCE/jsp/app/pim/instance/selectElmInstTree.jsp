<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/> 
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/dhtmlx/dhtmlxgrid_treegrid.css'/>">
<script src="<c:url value='/cmm/js/dhtmlx/dhtmlxTreeGrid/codebase/dhtmlxtreegrid.js'/>" type="text/javascript" charset="utf-8"></script> 

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00046" var="WM00046"/>
 
<script type="text/javascript">
	var gridArea;

	$(document).ready(function(){
		$("#grdElmArea").attr("style","height:"+(setWindowHeight() - 50)+"px;");
		window.onresize = function() {
			$("#grdElmArea").attr("style","height:"+(setWindowHeight() - 50)+"px;");
		};
		
		setElmGridList();
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	function setElmGridList(){
		var treePData="${elmTreeXml}";
	    gridArea = new dhtmlXGridObject('grdElmArea');
	    gridArea.selMultiRows = true;
	    gridArea.imgURL = "${root}${HTML_IMG_DIR_ITEM}/";
		gridArea.setHeader("#master_checkbox,Activities,#cspan,Role,roleID,objectID");
		gridArea.setInitWidths("50,200,*,250,100,100");
		gridArea.setColAlign("center,left,left,left,left,left,left");
		gridArea.setColTypes("ch,tree,ro,ro,ro,ro");
		gridArea.setColSorting("int,str,str,str,str,str");
   	  	gridArea.init();
		gridArea.setSkin("dhx_web");
		gridArea.attachEvent("onCheck", function(rId,cInd,state){gridOnCheck(rId,cInd,state);});
// 		gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		gridArea.loadXMLString(treePData);
		gridArea.setColumnHidden(4, true);
		gridArea.setColumnHidden(5, true);
		gridArea.enableColSpan(true);
		gridArea.setColspan("1",1,5);
		gridArea.enableTreeCellEdit(false);
	}
	
	function gridOnCheck(rId,cInd,state){
		var hasChild = gridArea.hasChildren(rId);
		if(rId != "1"){
			if (hasChild != 0){
				var value = gridArea.cellById(rId,0).getValue();
				var items = [];
				items = gridArea.getSubItems(rId);
				items = items.split(',');
				if(value == '1'){
					for(var i=0; i<items.length; i++){ gridArea.cells(items[i],0).setValue(1); }
				} else {
					for(var i=0; i<items.length; i++){ gridArea.cells(items[i],0).setValue(0); }
				}
			}
		} else {
			alert("${WM00046}");
			gridArea.cells(rId,0).setValue(0);
		}
	}
	
	function fnAddElements(){
		if(gridArea.getCheckedRows(0).length == 0){
			alert("${WM00023}");
		} else {
			if(confirm("${CM00012}")){
				var checkedRows = gridArea.getCheckedRows(0).split(",");	
				var elementID = new Array();
				
				for(var i = 0 ; i < checkedRows.length; i++ ){
					var roleID =  gridArea.cells(checkedRows[i], 4).getValue();
					var itemID =  gridArea.cells(checkedRows[i], 5).getValue();
					if(itemID){
						elementID.push(roleID+"_"+itemID);
					}
				}

				$("#checkElmts").val(elementID);
				var url = "createElmInsthyModel.do";
				ajaxSubmit(document.procInstFrm, url, "saveFrame");
			}
		} 
	}
	
	function fnCallBackSubmit() {
		opener.fnReload();
		self.close();
	}
	
	function fnSearch(){
		var searchValue = $("#searchValue").val();
		var url = "selectElmInstTree.do";
		var data = "modelID=${modelID}&instanceNo=${instanceNo}&processID=${processID}&searchValue="+searchValue;
		var target = "processDIV";
		ajaxPage(url,data,target);
	}
</script>
</head>
<body>
<div id="processDIV">
<form name="procInstFrm" id="procInstFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="checkElmts" name="checkElmts"  value="" />
	<input type="hidden" id="modelList" name="modelList"  value="${modelID }" />
	<input type="hidden" id="instanceNo" name="instanceNo"  value="${instanceNo }" />
	<div class="child_search_head mgT5">
		<p class="floatL"><img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;Copy Activities</p>
		 <p class="floatR pdR20">
			<select id="searchKey" name="searchKey" style="width:85px;">
				<option value="Name">Role Name</option>
			</select>			
			<input type="text" class="text"  id="searchValue" name="searchValue" value="${searchValue}" style="width:130px;">
			<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="fnSearch()" value="Search">
			<span class="btn_pack medium icon"><span class="add"></span><input value="Copy" onclick="fnAddElements()" type="button"></span>
		 </p>
	</div>
	<div id="gridPtgDiv" class="mgB5 mgT10">
		<div id="grdElmArea" style="width:100%;"></div>
	</div>
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none;width:0px;height:0px;"></iframe>
</body></html>