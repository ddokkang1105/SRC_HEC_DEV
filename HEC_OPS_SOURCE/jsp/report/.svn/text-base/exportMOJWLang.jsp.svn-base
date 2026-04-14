<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %> 
<c:url value="/" var="root"/>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script>
   var p_gridArea;   
	fnSelect('selectLanguageID', '&otherLangType=${sessionScope.loginInfo.sessionCurrLangType}', 'langType');

	$(document).ready(function(){   
		$("input.datePicker").each(generateDatePicker);
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
      //doSearchList();
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
      p_gridArea.enablePaging(true,50,10,"pagingArea",true,"recInfoArea");
      p_gridArea.setPagingSkin("bricks");   
      //p_gridArea.setColumnHidden(0, true);
      p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
   }
   function setGridData(){
      var projectID;
      var result = new Object();
      result.title = "${title}";
      result.key = "report_SQL.getexportMOJWLangList";
      result.header = "${menu.LN00024},ItemID, ItemTypeCode, ${menu.LN00021}, ClassCode, ${menu.LN00016}, AttrTypeCode, ${menu.LN00031}, KRValue, otherValue, LastUpdated";
      result.cols = "ItemID|ItemTypeCode|ItemTypeCodeName|ClassCode|ClassCodeName|AttrTypeCode|AttrTypeCodeName|KRValue|otherValue|LastUpdated";
      result.widths = "50,0,0,90,0,90,0,90,250,250,180";
      result.sorting = "str,str,str,str,str,str,str,str,str,str,str";
      result.aligns = "center,center,center,center,center,center,center,center,left,left,center";
      result.data = "selectLanguageID="+$("#selectLanguageID").val()+"&lastUpdated="+$("#lastUpdated").val();
      return result;
   }
   
   
   
   
   function doSearchList(){
	   	var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
   }
   
	function doExcel() {	
		if($('#selectLanguageID').val() == ''){
			alert('${WM00025}');
			return;			
		}
    	p_gridArea.toExcel("${root}excelGenerate");
   	}

   
</script>
<form name="downPrcFrm" id="downPrcFrm" action="" method="post"  onsubmit="return false;">
<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
<input type="hidden" id="currPage" name="currPage" value="${pageNum}">

<div id="proDiv" style="overflow:auto;">
	<div class="floatL msg" style="width:100%">
		<img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;Title</span>
	</div>	
	<div class="floatL msg" style="width:100%">
		<span>언어 선택: </span><select id="selectLanguageID" Name="selectLanguageID" style="width:110px;"></select>
		<span>날짜 : </span><input type="text" id="lastUpdated" name="lastUpdated" value="" class="stext datePicker" style="width:150px;">
		
		<input type="image" class="image searchList floatR" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" id="Search" value="Search" />
	</div>	
	<div class="countList" >
		<ul>
	        <li class="count">Total  <span id="TOT_CNT"></span></li>
	        <li class="floatR">
	           <span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
	         </li>
         </ul>
	</div>
	<div id="gridDiv" style="width:100%;" class="clear">
		<div id="grdGridArea" style="width:100%"></div>
	</div>
	<div style="width:100%;" class="paginate_regular">
		<div id="pagingArea" style="display:inline-block;"></div>
		<div id="recinfoArea" class="floatL pdL5"></div>
	</div>
</div>
</form>
<iframe name="blankFrame" id="blankFrame" style="width:0px;height:0px; display:none;"></iframe>