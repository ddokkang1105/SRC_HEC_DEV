<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00087" var="WM00087"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00042" var="WM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00012" var="CM00012"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>


<!-- 2. Script -->
<script type="text/javascript">	
	$(document).ready(function() {			
		// 초기 표시 화면 크기 조정 
		$("#grdPAArea").attr("style","height:"+(setWindowHeight() - 80)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdPAArea").attr("style","height:"+(setWindowHeight() - 80)+"px;");
		};
	});	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
</script>

</head>
<link rel="stylesheet" type="text/css" href="cmm/css/style.css"/>
<body style="width:100%;">
<form name="allItemFrm" id="allItemFrm" action="checkOutItem.do" method="post" onsubmit="return false;">
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;&nbsp;Element list</p>
	</div>
	<div class="mgL10 mgR10">
		<div class="countList">	
			<li class="count">Total  <span id="TOT_CNT"></span></li>
	         <li class="floatR">
	         <span class="btn_pack small icon"><span class="add"></span><input value="Select" type="submit" onclick="fnAddObject()" ></span>
	         </li>
		</div>
	    <div id="grdPAArea" style="width:100%;" class="clear"></div>
	</div>
</form>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
<!-- END::POPUP BOX-->
<script>
	doPSearchList();

	var grid = new dhx.Grid("grdPAArea",  {
		columns: [
	        { width: 50, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center"},
	        { width: 50, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", htmlEnable: true,align: "center" }], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 80, id: "SymbolIcon", header: [{ text: "${menu.LN00169}", align:"center" }], align:"center", htmlEnable: true,
  		        template: function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR_MODEL_SYMBOL}/symbol/'+text+'" />';
	            }
	        },
	        { width: 70, id: "Identifier", header: [{ text: "Identifier", align:"center" }], htmlEnable: true, align:"left"},	        
	        { id: "PlainText", header: [{text: "Item", align:"center"}]},
	        { width: 100, id: "ClassName", header: [{ text: "${menu.LN00016}", align:"center" }], align:"center"},
	        { width: 80, id: "ItemStatus", header: [{ text: "${menu.LN00027}", align:"center" }], align:"center" },
	        { width: 80, id: "AuthorName", header: [{ text: "${menu.LN00004}", align:"center" }], align:"center"},
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    multiselection : true
	});
	
	function doPSearchList(){ 
		var sqlID = "model_SQL.getElmtsObjectList";
		var param =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&refModelID=${refModelID}"
			+ "&sqlID="+sqlID;
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				grid.data.parse(result);
				$("#TOT_CNT").html(grid.data.getLength());
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
 	}
	
	function fnAddObject(){
		if(grid.data.findAll(e => e.checkbox).length == 0){
			alert("${WM00023}");
		} else {
			if(confirm("${CM00012}")){
				var elementID = grid.data.findAll(e => e.checkbox).map(e => e.ElementID).join(",")
				
				opener.$("#checkElmts").val(elementID);
				self.close();
			}
		}
	}
</script>
</body>
</html>