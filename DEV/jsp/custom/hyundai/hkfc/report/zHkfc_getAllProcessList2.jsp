<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %> 
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script>
   var p_gridArea;   

   $(document).ready(function(){   
      // 초기 표시 화면 크기 조정 
      $("#grdGridArea").attr("style","height:"+(setWindowHeight() - 180)+"px;");
      // 화면 크기 조정
      window.onresize = function() {
         $("#grdGridArea").attr("style","height:"+(setWindowHeight() - 180)+"px;");
      };
      
     $("#excel").click(function(){
    	doExcel();
		return false;
	 });
      
     $("#Search").click(function(){
    	doSearchList();
		return false;
	 });
     
      gridInit();   
      doSearchList();
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
   function gridInit(){      
      var d = setGridData();
      p_gridArea = fnNewInitGrid("grdGridArea", d);
      p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
      p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");   
      p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});      
      p_gridArea.enablePaging(true,50,null,"pagingArea",true,"recInfoArea");
      p_gridArea.setPagingSkin("bricks");   
      //p_gridArea.setColumnHidden(0, true);
      //p_gridArea.enableUTFencoding(true);
      p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
   }
   function setGridData(){
      var projectID;
      var result = new Object();
      result.title = "${title}";
      result.key = "custom_SQL.zHkfc_getAllProcessList";
      result.header = "${menu.LN00024}, L1, ID, Level, ${attrMap.AT00001},${attrMap.AT00003},${attrMap.AT00017},${attrMap.AT00015},${attrMap.AT00016},${attrMap.AT00009},${attrMap.ZAT0004},${attrMap.ZAT0005},${attrMap.AT00080},${attrMap.ZAT3013},${attrMap.AT00008},${attrMap.AT00013},${menu.LN00004},${menu.LN00018},${menu.LN00105},${menu.LN00070},RASIC,connectionOutbound Number of validation checks,connectionOutbound Inconsistent,connectionInbound Number of validation checks,connectionInbound Inconsistent,L4Status";
      result.cols = "L1Code|Identifier|Level|AT01|AT03|AT17|AT15|AT16|AT09|ZAT04|LOVZAT05|AT80|ZAT3013|AT08|AT13|Owner|OwnerTeamName|LastUpdateUser|LastUpdated|RASIC|connectionOutbound|connectionOutboundInconsistent|connectionInbound|connectionInboundInconsistent|L4Status";
      result.widths = "30,80,120,80,80,90,180,180,80,80,80,80,80,80,180,180,80,80,100,120,80,100,120,120,120,50";
      result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
      result.aligns = "center,center,left,left,left,left,left,left,left,left,left,left,left,left,left,left,left,left,left,left,left,left,left,left,left,left";
      result.data = "itemTypeCode=OJ00001";   
      return result;
   }
   
   
   
   
   function doSearchList(){
	   	var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
   }
   
   var delay = 0;
	function doExcel() {
		if(!confirm("Excel download 를 진행 하시겠습니까?")){ return;}
		var start = new Date().getTime();	
		if(start > delay || delay == 0){
			delay = start + 300000; // 1000 -> 1초
			//console.log("start :"+start+", delay :"+delay);
			p_gridArea.toExcel("${root}excelGenerate");
		}else{
			alert("Excel DownLoad 가 진행 중입니다.");
			return;
		}
		
	}
	
   function goBack() {
		var url = "objectReportList.do";
		var data = "s_itemID=${s_itemID}"; 
		var target = "proDiv";
	 	ajaxPage(url, data, target);
	}
   
</script>
<form name="downPrcFrm" id="downPrcFrm" action="" method="post"  onsubmit="return false;">
<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
<input type="hidden" id="currPage" name="currPage" value="${pageNum}">

<div id="proDiv" style="overflow:auto;">
	<div class="floatL msg" style="width:100%">
		<img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;Business Process Master List with Rule/To Check/Role </span>
	</div>	
	<div class="countList" >
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
           <span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
         </li>
	</div>
	<div id="gridDiv" style="width:100%;" class="clear">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL5"></div></div>
</div>
</form>
<iframe name="blankFrame" id="blankFrame" style="width:0px;height:0px; display:none;"></iframe>