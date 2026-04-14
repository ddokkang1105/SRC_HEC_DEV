<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %> 
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
   $(document).ready(function(){   
      // 초기 표시 화면 크기 조정 
      $("#grdGridArea").attr("style","height:"+(setWindowHeight() - 170)+"px;");
      // 화면 크기 조정
      window.onresize = function() {
         $("#grdGridArea").attr("style","height:"+(setWindowHeight() - 270)+"px;");
      };
      
	  $("#excel").click(function (){
		  doExcel();
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
	var gridData = ${gridData};
	var grid = null;
	
	if ('${systemtype}' == 'NCO') {
		grid = new dhx.Grid("grid", {
			    columns:[
			    	{ width: 69, id: "SYS", header: [{ text: "시스템", align: "center" }], align: "center" },
			    	{ width: 200, id: "ID", header: [{ text: "Func/Module명", align: "center" },{ content: "inputFilter" }], align: "left"},
			    	{ width: 200, id: "ATNCO91", header: [{ text: "Func. 매개변수 Table 명", align: "center"},{ content: "inputFilter" }], align: "left" },
			    	{ width: 220, id: "ATNCO93", header: [{ text: "Func. 설명", align: "center" },{ content: "inputFilter" }], align: "left" },
			    	{ width: 80, id: "ATNCO01", header: [{ text: "사용여부", align: "center" },{content:"selectFilter"}], align: "center" },
			    	{ width: 80, id: "ATNCO02", header: [{ text: "생성자 사번", align: "center" },{ content: "inputFilter" }], align: "center" },
			    	{ width: 83, id: "ATNCO03", header: [{ text: "수정자 사번", align: "center" },{ content: "inputFilter" }], align: "center" },
			    	{ width: 150, id: "ATNCO04", header: [{ text: "생성일", align: "center" }], align: "left" },
			    	{ width: 150, id: "ATNCO05", header: [{ text: "수정일", align: "center" }], align: "left" },
			    	{ width: 80, id: "ATNCO06", header: [{ text: "시스템 코드", align: "center" }], align: "center" },
			    	{ width: 95, id: "ATNCO07", header: [{ text: "배치수행 여부", align: "center" },{content:"selectFilter"}], align: "center" },
			    	{ width: 50, id: "Action", header: [{ text: "상태", align: "center" },{content:"selectFilter"}], align: "center" },
			    	{ 
			    		width: 60, id: "ICON", header: [{ text: "자세히", align: "center" }], 
			            htmlEnable: true, align: "center",
			            template: function () {
			            	return '<img src="/cmm/sf/images//btn_view.png" border="0" style="max-height:27px" title="View detail">';
			            }
			    	},
			    	{ width: 98, id: "UpdatedOnDate", header: [{ text: "호출일자", align: "center" }], align: "center" },
			    	{ width: 98, id: "UpdatedOnTime", header: [{ text: "호출시각", align: "center" }], align: "center" },
			 		{ width: 0, id: "ItemID", header: [{ text: "ItemID", align: "center" }], align: "center", hidden: true }
			    ],
			    autoWidth: true,
			    resizable: true,
			    selection: "row",
			    tooltip: false,
			    data: gridData
			});

	} else if ('${systemtype}' == 'EAI') {
		grid = new dhx.Grid("grid", {
			    columns:[
			    	{ width: 69, id: "SYS", header: [{ text: "시스템", align: "center" }], align: "center" },
			    	{ width: 120, id: "ID", header: [{ text: "I/F ID", align: "center" },{ content: "inputFilter" }], align: "left" },
			    	{ width: 85, id: "ATEAI92", header: [{ text: "SERIAL 번호", align: "center" },{ content: "inputFilter" }], align: "center" },
			    	{ width: 315, id: "ATEAI91", header: [{ text: "I/F 명", align: "center"},{ content: "inputFilter" }], align: "left" },
			    	{ width: 110, id: "ATEAI04", header: [{ text: "Legacy 담당자명", align: "center" },{ content: "inputFilter" }], align: "center" },
			    	{ width: 100, id: "ATEAI05", header: [{ text: "ERP 담당자명", align: "center" },{ content: "inputFilter" }], align: "center" },
			    	{ width: 85, id: "ATEAI01", header: [{ text: "개발유형", align: "center" },{ content: "inputFilter" }], align: "center" },
			    	{ width: 250, id: "ATEAI02", header: [{ text: "RFC 명", align: "center" },{ content: "inputFilter" }], align: "left" },
			    	{ width: 250, id: "ATEAI03", header: [{ text: "LEGACY TABLE", align: "center" },{ content: "inputFilter" }], align: "left" },
			    	{ width: 50, id: "Action", header: [{ text: "상태", align: "center" },{content:"selectFilter"}], align: "center" },
			    	{ 
			    		width: 60, id: "ICON", header: [{ text: "자세히", align: "center" }], 
			            htmlEnable: true, align: "center",
			            template: function () {
			            	return '<img src="/cmm/sf/images//btn_view.png" border="0" style="max-height:27px" title="View detail">';
			            }
			    	},
			    	{ width: 98, id: "UpdatedOnDate", header: [{ text: "호출일자", align: "center" }], align: "center" },
			    	{ width: 98, id: "UpdatedOnTime", header: [{ text: "호출시각", align: "center" }], align: "center" },
			 		{ width: 0, id: "ItemID", header: [{ text: "ItemID", align: "center" }], align: "center", hidden: true }
			    ],
			    autoWidth: true,
			    resizable: true,
			    selection: "row",
			    tooltip: false,
			    data: gridData
			});

	} else if ('${systemtype}' == 'SAP') {
		grid = new dhx.Grid("grid", {
			    columns:[
			    	{ width: 69, id: "SYS", header: [{ text: "시스템", align: "center" }], align: "center" },
			    	{ width: 320, id: "ID", header: [{ text: "T-CODE", align: "center" },{ content: "inputFilter" }], align: "left" },
			    	{ width: 70, id: "ATSAP90", header: [{ text: "메뉴레벨", align: "center"},{content:"selectFilter"}], align: "center" },
			    	{ width: 275, id: "ATSAP91", header: [{ text: "T_Code 명칭", align: "center"},{ content: "inputFilter" }], align: "left" },
			    	{ width: 213, id: "ATSAP93", header: [{ text: "T_Code 등록유무, 담당자 등록정보", align: "center" },{ content: "inputFilter" }], align: "left" },
			    	{ width: 80, id: "ATSAP01", header: [{ text: "담당자명", align: "center" },{ content: "inputFilter" }], align: "center" },
			    	{ width: 80, id: "ATSAP02", header: [{ text: "직급", align: "center" },{ content: "inputFilter" }], align: "center" },
			    	{ width: 83, id: "ATSAP03", header: [{ text: "사번", align: "center" },{ content: "inputFilter" }], align: "center" },
			    	{ width: 90, id: "ATSAP04", header: [{ text: "프로그램 구분", align: "center" },{ content: "inputFilter" }], align: "center" },
			    	{ width: 70, id: "ATSAP05", header: [{ text: "배치유무", align: "center" },{ content: "inputFilter" }], align: "center" },			    	
			    	{ width: 50, id: "Action", header: [{ text: "상태", align: "center" },{content:"selectFilter"}], align: "center" },
			    	{ 
			    		width: 60, id: "ICON", header: [{ text: "자세히", align: "center" }], 
			            htmlEnable: true, align: "center",
			            template: function () {
			            	return '<img src="/cmm/sf/images//btn_view.png" border="0" style="max-height:27px" title="View detail">';
			            }
			    	},
			    	{ width: 98, id: "UpdatedOnDate", header: [{ text: "호출일자", align: "center" }], align: "center" },
			    	{ width: 98, id: "UpdatedOnTime", header: [{ text: "호출시각", align: "center" }], align: "center" },
			 		{ width: 0, id: "ItemID", header: [{ text: "ItemID", align: "center" }], align: "center", hidden: true }
			    ],
			    autoWidth: true,
			    resizable: true,
			    selection: "row",
			    tooltip: false,
			    data: gridData
			});

	} else if ('${systemtype}' == 'BATCH') {
		grid = new dhx.Grid("grid", {
			    columns:[
			    	{ width: 69, id: "SYS", header: [{ text: "시스템", align: "center" }], align: "center" },
			    	{ width: 215, id: "ID", header: [{ text: "백그라운드작업이름", align: "center" },{ content: "inputFilter" }], align: "left" },
			    	{ width: 110, id: "ATPRD90", header: [{ text: "배치프로그램 순서", align: "center"},{content:"selectFilter"}], align: "center" },
			    	{ width: 55, id: "ParentID", header: [{ text: "모듈", align: "center" },{content:"selectFilter"}], align: "center" },
			    	{ width: 120, id: "ATPRD91", header: [{ text: "프로그램 이름", align: "center"},{ content: "inputFilter" }], align: "left" },
			    	{ width: 213, id: "ATPRD93", header: [{ text: "개요", align: "center" },{ content: "inputFilter" }], align: "left" },
			    	{ width: 80, id: "ATPRD09", header: [{ text: "담당자명", align: "center" },{ content: "inputFilter" }], align: "center" },
			    	{ width: 80, id: "ATPRD10", header: [{ text: "직급", align: "center" },{ content: "inputFilter" }], align: "center" },
			    	{ width: 80, id: "ATPRD11", header: [{ text: "사번", align: "center" },{ content: "inputFilter" }], align: "center" },
			    	{ width: 80, id: "ATPRD01", header: [{ text: "변형 이름", align: "center" },{ content: "inputFilter" }], align: "left" },
			    	{ width: 80, id: "ATPRD02", header: [{ text: "작업 시작일", align: "center" }], align: "center" },
			    	{ width: 83, id: "ATPRD03", header: [{ text: "작업 시작시간", align: "center" }], align: "center" },
			    	{ width: 40, id: "ATPRD04", header: [{ text: "월", align: "center" }], align: "center" },
			    	{ width: 40, id: "ATPRD05", header: [{ text: "주", align: "center" }], align: "center" },
			    	{ width: 40, id: "ATPRD06", header: [{ text: "일", align: "center" }], align: "center" },
			    	{ width: 40, id: "ATPRD07", header: [{ text: "시", align: "center" }], align: "center" },
			    	{ width: 40, id: "ATPRD08", header: [{ text: "분", align: "center" }], align: "center" },
			    	{ width: 50, id: "Action", header: [{ text: "상태", align: "center" },{content:"selectFilter"}], align: "center" },
			    	{ 
			    		width: 60, id: "ICON", header: [{ text: "자세히", align: "center" }], 
			            htmlEnable: true, align: "center",
			            template: function () {
			            	return '<img src="/cmm/sf/images//btn_view.png" border="0" style="max-height:27px" title="View detail">';
			            }
			    	},
			    	{ width: 98, id: "UpdatedOnDate", header: [{ text: "호출일자", align: "center" }], align: "center" },
			    	{ width: 98, id: "UpdatedOnTime", header: [{ text: "호출시각", align: "center" }], align: "center" },
			 		{ width: 0, id: "ItemID", header: [{ text: "ItemID", align: "center" }], align: "center", hidden: true }
			    ],
			    autoWidth: true,
			    resizable: true,
			    selection: "row",
			    tooltip: false,
			    data: gridData
			});

	} else if ('${systemtype}' == 'NF') {
		grid = new dhx.Grid("grid", {
			    columns:[
			    	{ width: 69, id: "SYS", header: [{ text: "시스템", align: "center" }], align: "center" },
			    	{ width: 160, id: "ID", header: [{ text: "메뉴ID", align: "center" },{ content: "inputFilter" }], align: "left" },
			    	{ width: 100, id: "ATNF092", header: [{ text: "APP ID", align: "center" },{content:"selectFilter"}], align: "left" },
			    	{ width: 220, id: "ParentID", header: [{ text: "상위 메뉴ID", align: "center" },{ content: "inputFilter" }], align: "left" },
			    	{ width: 150, id: "ATNF094", header: [{ text: "프로그램ID", align: "center"},{ content: "inputFilter" }], align: "left" },
			    	{ width: 300, id: "ATNF091", header: [{ text: "메뉴명", align: "center"},{ content: "inputFilter" }], align: "left" },
			    	{ width: 80, id: "ATNF001", header: [{ text: "USE YN", align: "center" },{content:"selectFilter"}], align: "center" },
			    	{ width: 80, id: "ATNF002", header: [{ text: "담당자 사번", align: "center" },{ content: "inputFilter" }], align: "center" },
			    	{ width: 150, id: "ATNF003", header: [{ text: "SAP TCODE", align: "center" },{ content: "inputFilter" }], align: "left" },
			    	{ 
			    		width: 60, id: "ICON", header: [{ text: "자세히", align: "center" }], 
			            htmlEnable: true, align: "center",
			            template: function () {
			            	return '<img src="/cmm/sf/images//btn_view.png" border="0" style="max-height:27px" title="View detail">';
			            }
			    	},			    	
			    	{ width: 50, id: "Action", header: [{ text: "상태", align: "center" },{content:"selectFilter"}], align: "center" },
			    	{ width: 98, id: "UpdatedOnDate", header: [{ text: "호출일자", align: "center" }], align: "center" },
			    	{ width: 98, id: "UpdatedOnTime", header: [{ text: "호출시각", align: "center" }], align: "center" },
			 		{ width: 0, id: "ItemID", header: [{ text: "ItemID", align: "center" }], align: "center", hidden: true }
			    	
			    ],
			    autoWidth: true,
			    resizable: true,
			    selection: "row",
			    tooltip: false,
			    data: gridData
			});

	} 
		
		

	layout.getCell("a").attach(grid);
	
	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});

	$("#TOT_CNT").html(grid.data.getLength());
   
	grid.events.on("cellClick", function(row,column,e){
		if(column.id != "ICON" || (column.id == "ICON" && row.Action != 'U')){
			var url = "popupMasterItem.do";
			var data = "?languageID=${sessionScope.loginInfo.sessionCurrLangType}" 
				+ "&id="+row.ItemID
				+ "&scrnType=pop"
				+ "&accMode="; 
		   
		    var w = "1400";
			var h = "900";
		    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		} else if (column.id == "ICON" && row.Action == 'U') {
			/* compareAttribute.do?s_itemID=262276 */
			var url = "custom/zhdhi_compareAttribute.do";
			var data = "?s_itemID="+row.ItemID
					+ "&systemtype=${systemtype}"
					+ "&updatedOnDate=" + row.UpdatedOnDate; 
		   
		    var w = "1400";
			var h = "900";
		    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
		}
	 }); 
	
   
   function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
		//fnMasterChk('');
		$("#TOT_CNT").html(grid.data.getLength());
	}
   
	//var delay = 0;
	function doExcel() {
 		if(confirm("Excel download 를 진행 하시겠습니까?")){
			fnGridExcelDownLoad();
 		}
		
	} 
	
	function goEAIList() {
		var url = "/custom/zHdhi_getEAIList.do";
		var target = "actFrame";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&systemtype=${systemtype}"; 
		
		ajaxPage(url, data, target);
	}	

   
</script>
<form name="downPrcFrm" id="downPrcFrm" action="" method="post"  onsubmit="return false;">
<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
<input type="hidden" id="currPage" name="currPage" value="${pageNum}">

<div id="proDiv" style="overflow:auto;">
	<div class="floatL msg" style="width:100%">
		<img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;변경 리스트</span>
	</div>	
	<div class="countList" >
        <li class="count">
			<span class="flex align-center">
				<span class="back" onclick="goEAIList()"><span class="icon arrow"></span>
			</span>
		</li>
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
           <span class="btn_pack nobg white"><a class="xls"  id="excel" title="Excel"></a></span>
         </li>
	</div>
	<div id="gridDiv" style="width:100%;" class="clear">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
			<!-- START :: PAGING -->
		<div id="pagination"></div>
		<!-- END :: PAGING -->	
</div>
</form>
<iframe name="blankFrame" id="blankFrame" style="width:0px;height:0px; display:none;"></iframe>