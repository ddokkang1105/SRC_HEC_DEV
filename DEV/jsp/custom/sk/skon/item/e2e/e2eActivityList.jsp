<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>

<script>
   $(document).ready(function(){
	   var gridData;
	
	  // 초기 표시 화면 크기 조정 
      $("#grdGridArea").attr("style","height:"+(setWindowHeight() - 185)+"px;");
      // 화면 크기 조정
      window.onresize = function() {
        $("#grdGridArea").attr("style","height:"+(setWindowHeight() - 185)+"px;");
      };
      
      $("#excel").click(function(){ doExcel(); });
     
      
 
   });
   
   function setWindowHeight(){
      var size = window.innerHeight;
      var height = 0;
      if( size == null || size == undefined){
         height = document.body.clientHeight;
      }else{
         height=window.innerHeight;
      }return height;
   }
	
	
	function doDetail(avg1){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop"+"&accMode=${accMode}";
		var w = 1400;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
		
	}
	
	var delay = 0;
	function doExcel() {
		if(!confirm("Excel download 를 진행 하시겠습니까?")){ return;}
		var start = new Date().getTime();	
		if(start > delay || delay == 0){
			delay = start + 300000;

			fnGridExcelDownLoad('','','SKON_E2E Process Master List');
			// fnGridExcelDownLoad('','','SKON_E2E Process Master List', 'zSK_SQL.getE2EActvityList_gridList');

		}else{
			alert("Excel DownLoad 가 진행 중입니다.");
			return;
		}
		
	} 
	
   //===============================================================================
   // BEGIN ::: GRID
  
   
 	var layout = new dhx.Layout("grdGridArea", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	gridData = ${gridData};

 	var grid = new dhx.Grid("grid", {
	    columns:[
	    	/* { width: 50, id: "NewRNUM", header: [{ text: "No", align:"center", rowspan : 2 }]},*/
	        { width: 40, id: "Photo", header: [{ text: "${menu.LN00042}", align:"center", rowspan : 2}], htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR}/item/'+row.ItemTypeImg+'" width="18" height="18">';
	            }
	        }, 
	        { width: 80, id: "Identifier", header: [{ text: "Activity ID", align: "center", rowspan : 2 }], align: "center"},
	    	{ width: 200, id: "Activity", header: [{ text: "Activity 명", align: "center", rowspan : 2 }] },
	    	{ width: 70, id: "PreProcess", header: [{ text: "Activity 관계", align: "center", colspan : 2 }, { text: "선행", align: "center" }] },
	    	{ width: 70, id: "LaterProcess", header: ["", { text: "후행", align: "center"}]},
	    	{ width: 40, id: "ApplicationCategory", header: [{ text: "적용<br/>구분", align: "center", rowspan : 2 }]},
	    	{ width: 50, id: "Period", header: [{ text: "시점<br/>(기간)", align: "center", rowspan : 2 }] },
	    	{ width: 250, id: "Input", header: [{ text: "입력물 (Input)", align: "center", colspan : 2 }, { text: "입력물", align: "center" }] },
	    	{ width: 150, id: "Responsible_Input", header: ["", { text: "입력물 주관", align: "center"}] },
	    	{ width: 250, id: "Output", header: [{ text: "출력물 (Output)", align: "center", colspan : 2 }, { text: "출력물", align: "center" }]},
	    	{ width: 150, id: "Responsible_Output", header: ["", { text: "출력물 주관", align: "center"}] },
	    	{ width: 60, id: "RnR", header: [{ text: "수행 부문<br/>(R&R)", align: "center", rowspan : 2 }]},
	    	{ width: 100, id: "R", header: [{ text: "RASIC", align: "center", colspan : 5 }, { text: "R", align: "center" }], align: "center"},
	    	{ width: 100, id: "A", header: ["", { text: "A", align: "center" }] , align: "center"},
	    	{ width: 100, id: "S", header: ["", { text: "S", align: "center" }] , align: "center"},
	    	{ width: 100, id: "I", header: ["", { text: "I", align: "center" }], align: "center" },
	    	{ width: 100, id: "C", header: ["", { text: "C", align: "center" }] , align: "center" },
			{ width: 150, id: "DetailedProcedure", header: [{ text: "관련 상세절차서", align: "center", rowspan : 2 }], align: "center" },
	    	
	    ],
		resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    multiselection : true,   
	    autoHeight: true,
	    autoWidth: true,
	}); 

	layout.getCell("a").attach(grid);
	
	// 셀 각 각 이벤트 
	grid.events.on("cellClick", function(row,column,e){
		if(column.id === 'R'){	
			if (row.Identifier === '01.01.01') {  
	            var popupUrl = "popupMasterItem.do?languageID=1042&id=100538&scrnType=pop&screenMode=pop";
	            window.open(popupUrl, "popupMasterItem", 'width=1200, height=700, left=400, top=100, scrollbar=yes, resizable=0');
	        }
		}		
		else if(column.id === 'DetailedProcedure'){		
			if (row.Identifier === '01.01.01') {  
			       var popupUrl = "popupMasterItem.do?languageID=1042&id=100454&scrnType=pop&screenMode=pop";
			       window.open(popupUrl, "popupMasterItem", 'width=1200, height=700, left=400, top=100, scrollbar=yes, resizable=0');
		       }
		}
		else
			{
			doDetail(row.ItemID);
			console.log("column.id  : " + column.id );
		}
	
	 }); 

	$("#TOT_CNT").html(grid.data.getLength());
	
</script>

<form name="downPrcFrm" id="downPrcFrm" action="" method="post"  onsubmit="return false;">
<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
<input type="hidden" id="currPage" name="currPage" value="${pageNum}">

<div id="proDiv" >
	<!-- <div class="floatL msg" style="width:100%">
		<img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;E2E List </span>
	</div>  -->	
	<div class="countList" >
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
           <span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel" ></span>
         </li>
	</div>

	<div id="gridDiv" style="width:100%;" class="clear">
		<div id="grdGridArea" style="width:100%; overflow:auto;"></div>

	</div>

</div>
</form>
<iframe name="blankFrame" id="blankFrame" style="width:0px;height:0px; display:none;"></iframe>