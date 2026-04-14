<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>

<script>

	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 570)+"px; width:100%;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 570)+"px; width:100%;");
		};
		
		$("#excel").click(function(){ fnGridExcelDownLoad(); });
			
	});
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	
	function fnCheckOut(){
		var url = "myMgtItemTreePop.do";
		var form = document.csListBySCRForm;
		
		var w = "680"; var h = "500";
		window.open("" ,"csListBySCRForm","toolbar=no, width="+w+", height="+h+", directories=no, status=no,    scrollorbars=no, resizable=no"); 
		form.action =url; 
		form.method="post";
		form.target="csListBySCRForm";
		form.submit();
	}
	
</script>	
<form name="csListBySCRForm" id="csListBySCRForm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" name="scrID" id="scrID" value="${scrID}" />
	<input type="hidden" name="updated" id="updated" value="" />
	<input type="hidden" name="actionType" id="actionType" value="checkOut" />
	<input type="hidden" name="projectID" id="projectID" value="${csrID}" />
	<input type="hidden" name="itemTypeCodeList" id="itemTypeCodeList" value="'OJ00004'" >
	<input type="hidden" name="itemStatusList" id="itemStatusList" value="'NEW1','REL'" >
	
	<input type="hidden" name="changeSetID" id="changeSetID" />
	<input type="hidden" name="itemID" id="itemID" />
	<input type="hidden" name="id" id="id" />
	<input type="hidden" name="languageID" id="lnaguageID" value="${sessionScope.loginInfo.sessionCurrLangType}" />
	<input type="hidden" name="itemID" id="itemID" />
	
	<div style="overflow:auto;overflow-x:hidden;">
        <div class="countList">
        	<li class="count">Total  <span id="TOT_CNT"></span></li>
			<li class="floatR pdR10">
				<c:if test="${scrRegUser eq sessionScope.loginInfo.sessionUserId}" >	
				<span class="btn_pack nobg"><a class="add"onclick="fnCheckOut()" title="checkOut"></a></span>
				</c:if>
			</li>	
        </div>
		<div style="width: 100%;" id="layout"></div>
		<div id="pagination"></div>
	</div>
</form>
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>

<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid;
	var pagination;
	var gridData = ${gridData};
	
	var grid = new dhx.Grid("grid",  {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center"},
	        { hidden : true, width: 30, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" }], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 40, id: "Photo", header: [{ text: "${menu.LN00042}", align:"center" }], htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR}/item/'+row.ItemTypeImg+'" width="18" height="18">';
	            }
	        },
	        { width: 110, id: "ClassCode", header: [{text: "${menu.LN00016}", align:"center"}], align: "center"},
	        { width: 110, id: "Identifier", header: [{ text: "${menu.LN00106}", align:"center" }], align:"center"},
	        { width: 280, id: "ItemName", header: [{ text: "${menu.LN00028}", align:"center" }], htmlEnable: true, align:"left"},     
	        { width: 80, id: "ChangeType", header: [{ text: "변경구분", align:"center" }], align:"center"},
	        { width: 80, id: "AuthorName", header: [{ text: "${menu.LN00004}", align:"center" }], align:"center" },
	        { width: 140, id: "TeamName", header: [{ text: "담당조직", align:"center" }], align:"center" },	       
	        { width: 100, id: "PjtName", header: [{ text: "프로젝트", align:"center" }], align:"center", hidden: true},
	        { width: 120, id: "csrName", header: [{ text: "변경과제", align:"center" }], align:"center", hidden: true},
	        { width: 80, id: "CreationTime", header: [{ text: "등록일", align:"center" }], align:"center", htmlEnable: true},
	        { width: 100, id: "ItemStatusName", header: [{ text: "${menu.LN00027}", align:"center" }], align:"center", htmlEnable: true},
	        { hidden : true, width: 80, id: "ItemID", header: [{ text: "ItemID", align:"center" }], align:"center"},
	        { hidden : true, width: 80, id: "ItemStatus", header: [{ text: "ItemStatus", align:"center" }], align:"center"}
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    multiselection : true   
	    
	});
	
	$("#TOT_CNT").html(grid.data.getLength());
	
	var tranSearchCheck = false;
	grid.events.on("cellClick", function(row,column,e){
		if(column.id != "checkbox" ){
			if(column.id == "Photo"){
				fnViewItemInfo(row.ItemID);
			}else{
				fnViewChangeSet(row.ChangeSetID,row.ItemID);
			}
		} else { tranSearchCheck = false; }
			
	 }); 
	
	 layout.getCell("a").attach(grid);
	 
	 if(pagination){pagination.destructor();}
	 pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});
	
 	function fnReload(){ 
		var sqlID = "cs_SQL.getChangeSetList";
		var param =  "scrID=${scrID}&csrID=${csrID}&sqlID="+sqlID;
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadGrid(result);				
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
 	}
 	
 	function fnReloadGrid(newGridData){
 		grid.data.parse(newGridData);
 		$("#TOT_CNT").html(grid.data.getLength());
 	}
 	
 	function fnViewChangeSet(avg1, avg3){	
		$("#changeSetID").val(avg1);
		$("#itemID").val(avg3);
		
		var url = "viewItemChangeInfo.do";
		var form = document.csListBySCRForm;
		
		var w = "1200"; var h = "500";
		window.open("" ,"csListBySCRForm","toolbar=no, width="+w+", height="+h+", directories=no, status=no,    scrollorbars=no, resizable=no"); 
		form.action =url; 
		form.method="post";
		form.target="csListBySCRForm";
		form.submit();
	}
 	
 	function fnViewItemInfo(avg1){
 		$("#id").val(avg1);
 		$("#scrnType").val("pop");
 		
 		var url = "popupMasterItem.do";
		var form = document.csListBySCRForm;		
		var w = "1400"; var h = "900";
		window.open("" ,"csListBySCRForm","toolbar=no, width="+w+", height="+h+", directories=no, status=no,    scrollorbars=no, resizable=no"); 
		form.action =url; 
		form.method="post";
		form.target="csListBySCRForm";
		form.submit();
 	}
 	
 	function fnCallBackSR(){
 		fnReload();
 	}
 	
</script>