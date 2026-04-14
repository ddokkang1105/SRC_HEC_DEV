<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
   $(document).ready(function(){   
      // 초기 표시 화면 크기 조정 
      $("#layout").attr("style","height:"+(setWindowHeight() - 250)+"px; width:100%;");
      // 화면 크기 조정
      window.onresize = function() {
         $("#layout").attr("style","height:"+(setWindowHeight() - 250)+"px; width:100%;");
      };
      
      $("#excel").click(function(){
      	doExcel();
  	 });

 	urlReload();
   });
   
   function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
   
</script>

<form name="downPrcFrm" id="downPrcFrm" action="" method="post"  onsubmit="return false;">
<div id="proDiv" style="overflow:auto;width:100%;height:100%;">
	<div class="floatL msg" style="width:100%;height:100%;">
		<img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;Business Process Master List</span>
	</div>	
	<div class="countList" >
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
           <span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
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
	
	var pagination;
	var grid = new dhx.Grid("grid", {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}", align: "center" }], align: "left" },
	        { width: 80, id: "L1Code", header: [{ text: "L1", align: "center" }, { content: "inputFilter" }], align: "left" },
	        { width: 170, id: "Path", header: [{ text: "Path", align: "center" }, { content: "inputFilter" }], align: "left" },
	        { width: 80, id: "Code", header: [{ text: "Process ID", align: "center" }, { content: "inputFilter" }], align: "left" },
	        { width: 100, id: "Level", header: [{ text: "Level", align: "center" }, { content: "selectFilter" }], align: "left" },
	        { width: 200, id: "Name", header: [{ text: "Name", align: "center" }, { content: "inputFilter" }], align: "left" },
	        { width: 80, id: "Frequency", header: [{ text: "Frequency", align: "center" }], align: "left" },
	        { width: 80, id: "Input", header: [{ text: "Input", align: "center" }, { content: "inputFilter" }], align: "center" },
	        { width: 80, id: "Output", header: [{ text: "Output", align: "center" }, { content: "inputFilter" }], align: "center" },
	        { width: 100, id: "SystemType", header: [{ text: "System Type", align: "center" }, { content: "selectFilter" }], align: "center"},
	        { width: 100, id: "System", header: [{ text: "System", align: "center" }, { content: "selectFilter" }], align: "center" },
	        { width: 80, id: "TCode", header: [{ text: "TCode", align: "center" }], align: "center" },
	        { width: 100, id: "EditorNM", header: [{ text: "Editor", align: "center" }, { content: "inputFilter" }], align: "center" },
	        { width: 100, id: "LastUpdated", header: [{ text: "Last Updated", align: "center" }], align: "center" },
	        { width: 100, id: "AuthorName", header: [{ text: "${menu.LN00004}", align: "center" }, { content: "inputFilter" }], align: "center" },
	        { width: 80, id: "AuthorTeamName", header: [{ text: "${menu.LN00018}", align: "center" }, { content: "selectFilter" }], align: "center" }
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	});
	
	$("#TOT_CNT").html(grid.data.getLength());
	
	 grid.events.on("filterChange", function(row,column,e,item){
			$("#TOT_CNT").html(grid.data.getLength());
		 });

		 layout.getCell("a").attach(grid);
		 

		var pagination = new dhx.Pagination("pagination", {
		    data: grid.data,
		    pageSize: 100,
		});
		 
	function urlReload(){
		var sqlID = "custom_SQL.getProcessListBase";
		var param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&sqlID="+sqlID;
		 $("#loading").fadeIn(100);
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				$("#loading").fadeOut(100);
				fnReloadGrid(result);				
			},error:function(xhr,status,error){
				$("#loading").fadeIn(100);
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
	}	
	function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
		$("#TOT_CNT").html(grid.data.getLength());
	}
	
	var delay = 0;
	function doExcel() {
		if(!confirm("Excel download 를 진행 하시겠습니까?")){ return;}
		var start = new Date().getTime();	
		if(start > delay || delay == 0){
			delay = start + 120000; // 1000 -> 1초
			fnGridExcelDownLoad();
		}else{
			alert("Excel DownLoad 가 진행 중입니다.");
			return;
		}
		
	} 


</script>
