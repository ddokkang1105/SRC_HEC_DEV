<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">
<style>
.receiptDelay {
	font-weight:bold;
	background-color:#FCDCDC; 
}
.completionDelay {
	font-weight:bold;
	background-color:#CFE4FC; 
}
</style>
<script>
   var p_gridSubArea;
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
      
     $("#excelSub").click(function(){ fnGridExcelDownLoad(p_gridSubArea); });
     
      subgridInit();
         
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
		p_gridSubArea = new dhx.Grid("grdGridSubArea",  {
			columns: [ 
		        { width: 90, id: "SRCode", header: [{text: "SR No.", align:"center"}], align: "center"},
		        { id: "Subject", header: [{ text: "${menu.LN00002}", align:"center" }], align:"center"},
		        { width: 90, id: "StatusName", header: [{ text: "${menu.LN00027}", align:"center" }], align:"center"},
		        { width: 100, id: "SRArea1Name", header: [{ text: "${menu.LN00026}", align:"center" }], align:"center"},
		        { width: 90, id: "SRArea2Name", header: [{ text: "${menu.LN00274}", align:"center" }], align:"center"},
		        { width: 90, id: "ReqTeamNM", header: [{ text: "${menu.LN00185}", align:"center" }], align:"center"},
		        { width: 90, id: "SRDueDate", header: [{ text: "SR${menu.LN00221}", align:"center" }], align:"center"},
		        { width: 90, id: "CRDueDate", header: [{ text: "CR${menu.LN00221}", align:"center" }], align:"center"},
		        { width: 90, id: "SRCompletionDT", header: [{ text: "SR${menu.LN00064}", align:"center" }], align:"center"},
		        { width: 90, id: "CRCompletionDT", header: [{ text: "CR${menu.LN00064}", align:"center" }], align:"center"},
		        { width: 90, id: "ReceiptName", header: [{ text: "${menu.LN00004}", align:"center" }], align:"center"},
		    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		});
		
		setSubGridData();
		
		p_gridSubArea.events.on("cellClick", function(row,column,e,item){
		      var screenType = "${screenType}";
		      var srCode = row.SRCode;
		      var srID = row.SRID;
		      var receiptUserID = row.ReceiptUserID;
		      var status = row.Status;
		      var srType = row.SRType;
		      
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
	 	});
   }
   
   function setSubGridData(){
		var sqlID = "esm_SQL.getEsrMSTList";
		var param =  "languageID=${sessionScope.loginInfo.sessionCurrLangType}&srType=${srType}"
			+"&srArea1=${srArea1}&srArea2=${srArea2}"
			+"&regStartDate="+$("#regStartDate").val()+"&regEndDate="+$("#regEndDate").val()
			+ "&sqlID="+sqlID;
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				p_gridSubArea.data.parse(result);				

				p_gridSubArea.data.getInitialData().filter(e => e.ReceiptDelay == "Y").forEach(e => {
			        p_gridSubArea.addRowCss(e.id, "receiptDelay");
			    });
				p_gridSubArea.data.getInitialData().filter(e => e.CompletionDelay == "Y").forEach(e => {
			        p_gridSubArea.addRowCss(e.id, "completionDelay");
			    });
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
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