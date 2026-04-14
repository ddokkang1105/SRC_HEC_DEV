<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<script>
   var p_gridSubArea;   
   var p_gridDownArea;
   var screenType = "${screenType}";
   var srMode = "${srMode}";
   var srType = "${srType}";
   var itemID = "${itemID}";
   var srArea1 = "${srArea1}";
   var srArea2 = "${srArea2}";
   var regStartDate = "${regStartDate}";
   var regEndDate = "${regEndDate}";
   var stSRDueDate = "${stSRDueDate}";
   var endSRDueDate = "${endSRDueDate}";
   var stCRDueDate = "${stCRDueDate}";
   var endCRDueDate = "${endCRDueDate}";

   $(document).ready(function(){   
      // 초기 표시 화면 크기 조정 
      $("#grdGridSubArea").attr("style","height:200px;");

     $("#excelSub").click(function(){doExcelSub();return false;});
           
      subgridInit();   
      doSearchSubList();
         
      //gridDownInit();   
      //doSearchDownList();      
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
   function subgridInit(){      
      var d = setSubGridData();
      p_gridSubArea = fnNewInitGrid("grdGridSubArea", d);
      p_gridSubArea.setImagePath("${root}${HTML_IMG_DIR}/");
      p_gridSubArea.setIconPath("${root}${HTML_IMG_DIR}/");   
      p_gridSubArea.attachEvent("onRowSelect", function(id,ind){subgridOnRowSelect(id,ind);});      
      p_gridSubArea.enablePaging(true,20,null,"pagingArea",true,"recInfoArea");
      p_gridSubArea.setPagingSkin("bricks");
      p_gridSubArea.setColumnHidden(0, true);      
      p_gridSubArea.setColumnHidden(12, true);
      p_gridSubArea.setColumnHidden(13, true);
      p_gridSubArea.setColumnHidden(14, true);
      p_gridSubArea.setColumnHidden(15, true);
      p_gridSubArea.setColumnHidden(16, true);
      p_gridSubArea.setColumnHidden(17, true);
      p_gridSubArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
   }
   function setSubGridData(){
      var projectID;
      var result = new Object();
      result.title = "${title}";
      result.key = "";
      result.header = "${menu.LN00024},SR No.,${menu.LN00002},${menu.LN00027},${menu.LN00026},${menu.LN00274},${menu.LN00185},SR${menu.LN00221},CR${menu.LN00221},SR${menu.LN00064},CR${menu.LN00064},${menu.LN00004},srID,ReceiptUserID,Status,ReceiptDelay,CompletionDelay,SRType";
      result.cols = "RNUM|SRCode|Subject|StatusName|SRArea1Name|SRArea2Name|ReqTeamNM|SRDueDate|CRDueDate|SRCompletionDT|CRCompletionDT|ReceiptName|SRID|ReceiptUserID|Status|ReceiptDelay|CompletionDelay|SRType";
      result.widths = "50,90,*,90,100,90,90,90,90,90,90,150,100,100";
      result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str";
      result.aligns = "left,left,left,center,center,center,center,center,center,center,center,center,center,center";
               
      return result;
   }
   
   // Excel DownLoad 용~ 
    function gridDownInit(){	
		var d = setGridDownData();
		p_gridDownArea = fnNewInitGrid("grdGridDownArea", d);
		p_gridDownArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridDownArea.setIconPath("${root}${HTML_IMG_DIR}/");	
		//p_gridDownArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});		
		//p_gridDownArea.enablePaging(true,30,null,"pagingArea",true,"recInfoArea");
		p_gridDownArea.setPagingSkin("bricks");
		p_gridDownArea.setColumnHidden(0, true);
		//p_gridDownArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	function setGridDownData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "sr_SQL.getSrMSTList";
		result.header = "${menu.LN00024},SR No.,${menu.LN00002},${menu.LN00027},${menu.LN00025},${menu.LN00274},${menu.LN00185},${menu.LN00272},${menu.LN00273},${menu.LN00153},${menu.LN00004},요청일,${menu.LN00222},${menu.LN00221},완료일";
		result.cols = "SRCode|Subject|StatusName|ReqUserNM|SRArea1Name|SRArea2Name|CategoryNM|SubCategoryNM|ReceiptTeamName|ReceiptName|RegDT|ReqDueDate|SRDueDate|CompletionDT";
		result.widths = "30,90,*,80,80,90,80,80,80,110,80,100,100,100,100";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,left,left,center,center,center,center,center,center,center,center,center,left,center,left";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
						+ "&pageNum=" + $("#currPage").val()
						+ "&screenType=" + screenType
						+ "&srMode=" + srMode
						+ "&srType=" + srType
						+ "&regStartDate = "+regStartDate
						+ "&regEndDate = "+regEndDate
						+ "&stSRDueDate = "+stSRDueDate
						+ "&endSRDueDate = "+endSRDueDate
						+ "&stCRDueDate = "+stCRDueDate
						+ "&endCRDueDate = "+endCRDueDate
						;
		return result;
	}
	
	function doSearchDownList(){ 
		var d = setGridDownData();
		fnLoadDhtmlxGridJson(p_gridDownArea, d.key, d.cols, d.data);
	}
	
	function fnDownData() {		
		p_gridDownArea.toExcel("${root}excelGenerate");
	}
   
   function subgridOnRowSelect(id, ind){
      var screenType = "${screenType}";
      var srCode = p_gridSubArea.cells(id, 1).getValue();
      var srID = p_gridSubArea.cells(id, 12).getValue();
      var receiptUserID = p_gridSubArea.cells(id, 13).getValue();
      var status = p_gridSubArea.cells(id, 14).getValue();
      var srType = p_gridSubArea.cells(id, 17).getValue();
      
      if(srType == "ITSP"){
  		url = "processItsp.do?";
  	} else if(srType == "ISP"){
  		url = "processIsp.do?";
  	}
      
      var data = "srCode="+srCode+"&pageNum="+$("#currPage").val()
				+"&srMode=srRqst&srType=${srType}&screenType=${screenType}&srID="+srID
				+"&receiptUserID="+receiptUserID+"&status="+status+"&projectID=${projectID}&itemID="+itemID
				+"&isPopup=Y";
	  var w = 1280;
	  var h = 710;
	  var spec = "width="+w+", height="+h+",top=100,left=100,toolbar=no,location=no,status=yes,resizable=yes,scrollbars=yes";
	  var popup = window.open(url+data, '_blank', spec);
   }
   
   function doSearchSubList(){
      p_gridSubArea.enableRowspan();
      p_gridSubArea.enableColSpan(true);
      p_gridSubArea.loadXML("${root}" + "${xmlFilName}");
   }
   
   function fnRegistSR(){
      var url = "registSR.do";
      var target = "srListDiv";
      if(srMode == "REG"){srMode = "";}
      var data = "srType=ITSP&srMode="+srMode+"&screenType=${screenType}";
      ajaxPage(url, data, target);
   }
   
   function fnRegistSRCR(){
      var url = "registSRCR.do";
      var target = "srListDiv";
      var data = "srType=ITSP&srMode=${srMode}&screenType=${screenType}";
      ajaxPage(url, data, target);
   }
  	
	//===============================================================================
	// BEGIN ::: EXCEL
	function doExcelSub() {		
		p_gridSubArea.toExcel("${root}excelGenerate");
	}
	// END ::: EXCEL
	//===============================================================================
   
</script>
<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
<div class="countList">
		<li class="floatL"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;SR List</li>
       <li class="floatR">
          <span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excelSub"></span>
       </li>
</div>
<div id="srListDiv">
	<div id="gridDiv" style="width:100%;" class="clear">
		<div id="grdGridSubArea" style="width:100%"></div>
	</div>
	<div style="width:100%;" class="paginate_regular">
		<div id="pagingArea" style="display:inline-block;"></div>
	   <div id="recinfoArea" class="floatL pdL10"></div>
	</div>
	
	<div id="gridDownDiv" style="width:100%;visibility:hidden;" >
		 <li class="count">Total <span id="TOT_CNT"></span></li>
		<div id="grdGridDownArea" style="width:100%;"></div>
	</div>
</div>