<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />

<script type="text/javascript">
	
	var gridData = "";
	var grid = "";
	$.ajax({
		url:"getRestApiData.do",
		type:"POST",
		cotentType:"application/json",
		data:"",
		success: function(result){
			console.log("rest api result :"+result);
			gridData = result;
			if(gridData != ""){
				fnLoadGridList(gridData);
			}
		},error:function(xhr,status,error){
			console.log("ERR :["+xhr.status+"]"+error);
		}
	});	
	
	var grid = "";
	function fnLoadGridList(gridData){				
		var gridData = eval(gridData);		
		grid = new dhx.Grid("grid", {
		    columns: [
		        { width: 180, id: "ID", header: [{ text: "ID" }] },
		        { width: 200, id: "Name", header: [{ text: "Name" }] },
		        { width: 300, id: "Description", header: [{ text: "Description" }] }
		    ],
		   
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    editable: true,
		    data: gridData
		});
	}
	
	function fnLoadGridListDhtmlx(gridData){				
		var gridData = eval(gridData);		
		grid = new dhx.Grid("grid", {
		    columns: [
		        { width: 300, id: "title", header: [{ text: "Title" }] },
		        { width: 200, id: "authors", header: [{ text: "Authors" }] },
		        { width: 80, id: "average_rating", header: [{ text: "Rating" }] },
		        { width: 150, id: "publication_date", header: [{ text: "Publication date" }] },
		        { width: 150, id: "isbn13", header: [{ text: "isbn" }] },
		        { width: 90, id: "language_code", header: [{ text: "Language" }] },
		        { width: 90, id: "num_pages", header: [{ text: "Pages" }] },
		        { width: 120, id: "ratings_count", header: [{ text: "Raiting count" }] },
		        { width: 100, id: "text_reviews_count", header: [{ text: "Text reviews count" }] },
		        { width: 200, id: "publisher", header: [{ text: "Publisher" }] }
		    ],
		   
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    editable: true,
		    data: gridData
		});
	}

	// [Row Click] 이벤트
	function goInfoView(avg1, avg2, avg3){	
		var url = "viewItemChangeInfo.do?changeSetID="+avg1+"&StatusCode="+avg2+"&itemID="+avg3
				+ "&ProjectID=${ProjectID}&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&isNew=${isNew}&mainMenu=${mainMenu}"
				+ "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}&isFromPjt=${isFromPjt}&s_itemID=${s_itemID}";
		var w = 1200;
		var h = 500; 
		itmInfoPopup(url,w,h);
	}
	
	
	$(document).ready(function() {
		// 초기 표시 화면 크기 조정 
		$("#grid").attr("style","height:"+(setWindowHeight() - 180)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grid").attr("style","height:"+(setWindowHeight() - 180)+"px;");
		};
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

</script>
<style>
	.edit {
		background: #4CAF50;
		color: #FFF
	}
	.my_сustom_сlass {
		background: greenyellow;
	}
</style>
<body>
<div class="mgL20" style="width:100%;height:100%;">
<form name="changeInfoLstFrm" id="changeInfoLstFrm" method="post" action="#" onsubmit="return false;">
	<div class="title-section">ITEM LIST (REST API) </div>
	<div id="gridDiv" class="mgB10 clear">
		<div id="grid" style="width:100%"></div>
	</div>
	<div id="pagination"></div>
</form>
</div>
</body>
<!-- START :: FRAME --> 		
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>
