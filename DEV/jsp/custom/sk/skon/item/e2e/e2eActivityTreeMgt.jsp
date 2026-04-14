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
<style>
.dhx_grid-cell__content:has(.link) {
     flex-direction: column;
}

.link {
	color: #193598;
	text-decoration: underline;
	cursor:pointer;
}

/* phase */
div[dhx_class="CL14003"]{
	background: #d5ebfb;
}
/* step */
div[dhx_class="CL14004"]{
	background: #bbdefb;
}
/* gate */
div[dhx_class="CL14004G"]{
	background: #95cbf8;
}
</style>
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
     
      $.ajax({
	        url: "/zSKON_cxnItemList.do",
	        type: "GET",
	        data: {
	        	itemID: ${s_itemID},
	        	languageID: ${sessionScope.loginInfo.sessionCurrLangType}
	        },
	        dataType: "json",
	        success: function (response) {
	  
	            itemListData = response.list; 
	            console.log("itemListData : ", itemListData);
	        },
	    });      
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
 	var treeGrid = new dhx.Grid("treegrid", {
		type: "tree",
	    columns:[
	    	// Activity명 / Activity 관계 / 선행 / 후행 / 적용<br/>구분 / 입력물 (Input) / 입력물 / 입력물 주관 / 출력물 (Output) / 출력물 / 출력물 주관 / RASI / R / A / S / I / 관련 상세절차서
			{ id: "ItemTypeImg", header: [{ text: "${menu.ZLN0109}", align:"center", rowspan : 2}], htmlEnable: true,
	        	template: function (text, row, col) {
	        		return "<span onclick='doDetail("+row.id+")' style='font-weight: bold;'>"+row.Identifier + '&nbsp;' + row.Activity+"</span>";
	        	 }
	        }, 
			{ width: 70, id: "pre_Identifier", header: [{ text: "${menu.ZLN0121}", align: "center", colspan : 2 }, { text: "${menu.ZLN0122}", align: "center" }], align: "center", htmlEnable: true },
	    	{ width: 70, id: "later_Identifier", header: ["", { text: "${menu.ZLN0123}", align: "center"}], align: "center", htmlEnable: true},
	    	{ width: 40, id: "ApplicationCategory", header: [{ text: "${menu.ZLN0124}<br/>${menu.LN00042}", align: "center", rowspan : 2 }], align: "center"},
	    	{ width: 220, id: "Input", header: [{ text: "${menu.ZLN0110} (Input)", align: "center", colspan : 2 }, { text: "${menu.ZLN0110}", align: "center" }]},
	    	{ width: 125, id: "Responsible_Input", header: ["", { text: "${menu.ZLN0110} ${menu.ZLN0106}", align: "center"}], align: "center" },
	    	{ width: 220, id: "Output", header: [{ text: "${menu.ZLN0111} (Output)", align: "center", colspan : 2 }, { text: "${menu.ZLN0111}", align: "center" }]},
	    	{ width: 125, id: "Responsible_Output", header: ["", { text: "${menu.ZLN0111} ${menu.ZLN0106}", align: "center"}], align: "center" },
	    	{ width: 85, id: "r_text", header: [{ text: "${menu.ZLN0125}", align: "center", colspan : 4 }, { text: "${menu.ZLN0126}", align: "center" }], align: "center", htmlEnable: true},
	    	{ width: 85, id: "a_text", header: ["", { text: "${menu.ZLN0127}", align: "center" }] , align: "center", htmlEnable: true},
	    	{ width: 85, id: "s_text", header: ["", { text: "${menu.ZLN0128}", align: "center" }] , align: "center", htmlEnable: true},
	    	{ width: 85, id: "i_text", header: ["", { text: "${menu.ZLN0129}", align: "center" }], align: "center", htmlEnable: true },
	    	{ width: 130, id: "prc_text", header: [{ text: "${menu.ZLN0130}", align: "center", rowspan : 2 }], align: "center", htmlEnable: true },
	    	
	    ],
		resizable: true,
	    selection: "row",
	    data: gridData,   
	    autoHeight: true,
	    autoWidth: true,
	}); 
 	
	treeGrid.data.sort({
	    by: "parent",
	    dir: "asc",
	    as: function (value) { return value ? value : "" }
	});
	
	layout.getCell("a").attach(treeGrid);
	
	var tranSearchCheck = false;
	
	// 셀 각 각 이벤트 
	treeGrid.events.on("cellClick", function(row,column,e){

	 }); 

	$("#TOT_CNT").html(treeGrid.data.getLength());
	
	function doDetail(itemID) {
		var popupUrl = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemID+"&scrnType=pop&&screenMode=pop";
        window.open(popupUrl, "popupMasterItem", 'width=2000, height=700, left=400, top=100, scrollbar=yes, resizable=0');
	}

</script>

<form name="downPrcFrm" id="downPrcFrm" action="" method="post"  onsubmit="return false;">
<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
<input type="hidden" id="currPage" name="currPage" value="${pageNum}">

<div id="proDiv" >

	<div class="countList" ></div>

	<div id="gridDiv" style="width:100%;" class="clear">
		<div id="grdGridArea" style="width:100%; overflow:auto;"></div>

	</div>

</div>
</form>
<iframe name="blankFrame" id="blankFrame" style="width:0px;height:0px; display:none;"></iframe>