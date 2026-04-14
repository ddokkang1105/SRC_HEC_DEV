<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %> 
<c:url value="/" var="root"/>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/dhtmlxV9/codebase/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/dhtmlxV9/codebase/suite.css">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script>

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




	 var layout = new dhx.Layout("grdGridArea", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	}); 

	var gridData = "";
	 var grid = new dhx.Grid(null, {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
	        { hidden:true,id: "ItemID",  header: [{ text: "ItemID", align: "center" }], align: "center" },
	        { hidden:true,id: "ItemTypeCode",    header: [{ text: "ItemTypeCode", align: "center" }], align: "left" },
	        { width: 90,id:"ItemTypeCodeName", header: [{ text: "${menu.LN00021}", align: "center" }], align: "left" },
	        { hidden:true,id: "ClassCode",       header: [{ text: "ClassCode", align: "center" }], align: "left" },
	        { width: 90,id: "ClassCodeName",   header: [{ text: "${menu.LN00016}",             align: "center" }], align: "center" },
	        { hidden:true,id: "AttrTypeCode",        header: [{ text: "AttrTypeCode",  align: "center" }], align: "center" },
	        { width: 90,id: "AttrTypeCodeName",      header: [{ text: "${menu.LN00031}",  align: "center" }], align: "center", type: "date", dateFormat: "%Y-%m-%d" },
	        { width: 250,id: "KRValue",  header: [{ text: "KRValue",  align: "center" }], align: "center", type: "date", dateFormat: "%Y-%m-%d" },
	        { width: 250,id: "otherValue",    header: [{ text: "otherValue",  align: "center" }], align: "center", type: "date", dateFormat: "%Y-%m-%d" },
	        { width: 180,id: "LastUpdated",       header: [{ text: "LastUpdated",              align: "center" }], align: "center" }

	    ],

	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData
	});
	$("#TOT_CNT").html(grid.data.getLength());
	layout.getCell("a").attach(grid);

	var pagination = new dhx.Pagination("pagingArea", {
	    data: grid.data,
	    pageSize: 20,
	});
	
   function doSearchList(){
		let	sqlID = "report_SQL.getexportMOJWLangList";
		let param ="&selectLanguageID="+$("#selectLanguageID").val()
					+"&lastUpdated="+$("#lastUpdated").val()
					+"&sqlID="+sqlID;	
		

			$.ajax({
				url:"jsonDhtmlxListV7.do",
				type:"POST",
				data:param,
				success: function(result){
			
					fnReload(result);
				
				 
				},error:function(xhr,status,error){
					console.log("ERR :["+xhr.status+"]"+error);
				}
			});	
   }
   
 	function fnReload(newGridData){
 	 	
 	    grid.data.parse(newGridData);
 		$("#TOT_CNT").html(grid.data.getLength());
 	} 
	 
    
	function doExcel() {	
		if($('#selectLanguageID').val() == ''){
			alert('${WM00025}');
			return;			
		}
		fnGridExcelDownLoad();
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
<!-- 		<div id="recinfoArea" class="floatL pdL5"></div> -->
	</div>
</div>
</form>
<iframe name="blankFrame" id="blankFrame" style="width:0px;height:0px; display:none;"></iframe>