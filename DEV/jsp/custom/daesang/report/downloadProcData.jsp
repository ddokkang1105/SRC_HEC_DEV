<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %> 
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script>
   var p_gridArea;   

   $(document).ready(function(){   
      // 초기 표시 화면 크기 조정 
      $("#grdGridArea").attr("style","height:"+(setWindowHeight() - 250)+"px;");
      // 화면 크기 조정
      window.onresize = function() {
         $("#grdGridArea").attr("style","height:"+(setWindowHeight() - 250)+"px;");
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
      p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
   }
   function setGridData(){
      var projectID;
      var result = new Object();
      result.title = "${title}";
      result.key = "custom_SQL.getCJProcessList";
      result.header = "${menu.LN00024},L1,Path,ID,Level,Name,Description,Guideline,Organization,System Type,TCODE,Input,Output,Editor,Last Updated";
      result.cols = "L1Code|Path|Code|Level|Name|Description|Guideline|ORG|SYSTP|TCODE|Input|Output|EditorNM|LastUpdated";
      result.widths = "30,50,120,100,80,100,180,180,80,80,80,100,100,80,100";
      result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
      result.aligns = "center,center,left,left,center,left,left,left,left,left,left,left,left,center,center";
               
      return result;
   }
   
   
   
   
   function doSearchList(){
	   	var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
   }
   
	function doExcel() {	
    	p_gridArea.toExcel("${root}excelGenerate");
   	}

   
</script>
<form name="downPrcFrm" id="downPrcFrm" action="" method="post"  onsubmit="return false;">
<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
<input type="hidden" id="currPage" name="currPage" value="${pageNum}">

<div id="proDiv" style="overflow:auto;width:100%">
	<div class="floatL msg" style="width:100%">
		<img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;Business Process Master List</span>
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