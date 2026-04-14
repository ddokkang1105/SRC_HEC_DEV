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
      $("#grdGridArea").attr("style","height:"+(setWindowHeight() - 180)+"px;");
      // 화면 크기 조정
      window.onresize = function() {
         $("#grdGridArea").attr("style","height:"+(setWindowHeight() - 180)+"px;");
      };
      
     $("#excel").click(function(){
    	doExcel();
	 });
      
     $("#Search").click(function(){
    	doSearchList();
		return false;
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
	//var gridData = ${gridData};
	var grid = new dhx.Grid("grid", {
	    columns:[
	    	{ width: 80, id: "L1Code", header: [{ text: "프로세스 계층", align: "center", colspan : 5 }, { text: "L1", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 80, id: "L2Code", header: ["", { text: "L2", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 80, id: "L3Code", header: ["", { text: "L3", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 80, id: "L4Code", header: ["", { text: "L4", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 80, id: "L5Code", header: ["", { text: "L5", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 80, id: "L1Name", header: [{ text: "프로세스 명", align: "center", colspan : 5 }, { text: "L1", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 80, id: "L2Name", header: ["", { text: "L2", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 80, id: "L3Name", header: ["", { text: "L3", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 80, id: "L4Name", header: ["", { text: "L4", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 80, id: "L5Name", header: ["", { text: "L5", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 180, id: "Description", header: ["", { text: "프로세스 정의", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 90, id: "CHAN", header: ["", { text: "변화사항", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 150, id: "USRMENU1", header: ["", { text: "사용자매뉴얼-하림", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 150, id: "USRMENU2", header: ["", { text: "사용자매뉴얼-올품", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 150, id: "USRMENU3", header: ["", { text: "사용자매뉴얼-한강식품", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 150, id: "USRMENU4", header: ["", { text: "사용자매뉴얼-주원산오리", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 150, id: "USRMENU5", header: ["", { text: "사용자매뉴얼-선진", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 150, id: "USRMENU6", header: ["", { text: "사용자매뉴얼-팜스코", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 150, id: "USRMENU7", header: ["", { text: "사용자매뉴얼-제일사료", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 80, id: "INPUTID", header: [{ text: "Input/Out Process", align: "center", colspan : 4 }, { text: "Input 번호", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 80, id: "INPUTNM", header: ["", { text: "Input 명", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 80, id: "OUTPUTID", header: ["", { text: "Output 번호", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 80, id: "OUTPUTNM", header: ["", { text: "Output 명", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	
	    	{ width: 80, id: "PI", header: [{ text: "담당자", align: "center", colspan : 2 }, { text: "담당 PI", align: "center" }, { content: "inputFilter" }], align: "center" },
	    	{ width: 100, id: "CONSULT", header: ["", { text: "담당 컨설턴트", align: "center" }, { content: "inputFilter" }], align: "center" },
	    	{ width: 80, id: "B00", header: [{ text: "업종분야", align: "center", colspan : 3 },{text :"그룹공통"}, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "B01", header: ["", { text: "업종공통(가금)", align: "center" }, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "B02", header: ["", { text: "업종공통(축산)", align: "center" }, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "C01", header: [{ text: "사별특화", align: "center", colspan : 11 },{ text: "하림", align: "center" }, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "C02", header: ["", { text: "올품", align: "center" }, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "C03", header: ["", { text: "한강식품", align: "center" }, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "C04", header: ["", { text: "주원산오리", align: "center" }, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "C05", header: ["", { text: "싱그린FS", align: "center" }, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "C06", header: ["", { text: "선진", align: "center" }, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "C07", header: ["", { text: "팜스코", align: "center" }, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "C08", header: ["", { text: "NS홈쇼핑", align: "center" }, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "C09", header: ["", { text: "팬오션", align: "center" }, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "C10", header: ["", { text: "하림산업", align: "center" }, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "C11", header: ["", { text: "제일사료", align: "center" }, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "D01", header: [{ text: "사업영역", align: "center", colspan : 10 },{ text: "곡물", align: "center" }, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "D02", header: ["", { text: "해운", align: "center" }, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "D03", header: ["", { text: "사료", align: "center" }, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "D04", header: ["", { text: "축산(양돈)", align: "center" }, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "D05", header: ["", { text: "축산(가금)", align: "center" }, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "D06", header: ["", { text: "축산(한우&기타)", align: "center" }, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "D07", header: ["", { text: "도축가공(신선&식육)", align: "center" }, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "D08", header: ["", { text: "식품제조(육가공)", align: "center" }, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "D09", header: ["", { text: "유통판매", align: "center" }, { content: "selectFilter" }], align: "center" },
	    	{ width: 80, id: "D10", header: ["", { text: "기타", align: "center" }, { content: "selectFilter" }], align: "center" },
		    
	    	{ width: 90, id: "ORG", header: ["", { text: "주수행부서", align: "center" }, { content: "selectFilter" }], align: "left" },
	    	{ width: 90, id: "APPLTYPE", header: ["", { text: "시스템", align: "center" }, { content: "selectFilter" }], align: "left" },
	    	{ width: 90, id: "ITSYS", header: ["", { text: "시스템명", align: "center" }, { content: "selectFilter" }], align: "left" },
	    	{ width: 100, id: "FITGAP", header: ["", { text: "Fit/GAP", align: "center" }, { content: "selectFilter" }], align: "left" },
	    	
	    	{ width: 80, id: "MODULE", header: ["", { text: "모듈", align: "center" }, { content: "selectFilter" }], align: "left" },
	 		{ width: 80, id: "TCODE", header: ["", { text: "화면코드", align: "center" }, { content: "selectFilter" }], align: "left" },
	 		{ width: 80, id: "NOTE", header: ["", { text: "비고", align: "center" }, { content: "inputFilter" }], align: "left" },
	 		
	 		{ width: 120, id: "GAPID", header: ["", { text: "GAP ID", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 100, id: "GAPSOL", header: ["", { text: "GAP 상세내역", align: "center" }, { content: "inputFilter" }], align: "left" },
			{ width: 100, id: "RuleIdentifiers", header: [{ text: "Rule-Set", align: "center", colspan : 2 }, { text: "Rule-SetID", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 100, id: "RULENAME", header: ["", { text: "Rule-Set 설명", align: "center" }, { content: "inputFilter" }], align: "left" },
      		{ width: 100, id: "CONTROLIdentifiers", header: [{ text: "내부통제", align: "center", colspan : 2 }, { text: "통제 ID", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 100, id: "CONTROLNAME", header: ["", { text: "내부통제 설명", align: "center" }, { content: "inputFilter" }], align: "left" },
	    	{ width: 100, id: "PROGRESS", header: ["", { text: "PROGRESS", align: "center" }, { content: "selectFilter" }], align: "left" },
	    	{ width: 100, id: "Version", header: ["", { text: "Version", align: "center" }, { content: "selectFilter" }], align: "left" },
 			{ width: 100, id: "Owner", header: ["", { text: "Owner", align: "center" }, { content: "selectFilter" }], align: "center" },
		    { width: 100, id: "CreationTime", header: ["", { text: "생성일", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { width: 100, id: "LastUpdated", header: ["", { text: "수정일", align: "center" }, { content: "inputFilter" }], align: "center" },
		    { hidden : true, width: 0, id: "ItemID", header: ["", { text: "ItemID", align: "center" }], align: "center" }
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    
	    
	});

	layout.getCell("a").attach(grid);
	

	$("#TOT_CNT").html(grid.data.getLength());
   
	var delaySearch = 0;

	function getJSONFormatClean(s) {
	    if (!s) return s;

	    // HTML 엔티티 일부 변환
	    let cleanedString = s
	        .replace(/&lt;br\s*\/?&gt;/gi, ' ')
	        .replace(/&amp;/g, '&')
	        .replace(/&#10;/g, '');

	    // HTML 디코딩
	    let txt = document.createElement("textarea");
	    txt.innerHTML = cleanedString;
	    cleanedString = txt.value;

	    // img 태그 제거
	    cleanedString = cleanedString.replace(/<img[^>]*>/gi, '');

	    // 나머지 HTML 태그 및 주석 제거
	    cleanedString = cleanedString.replace(/<[^>]+>|<!--[\s\S]*?-->/g, '');

	    return cleanedString;
	}

	function doSearchList() {
	    var startSearch = new Date().getTime();    
	    if (startSearch > delaySearch || delaySearch == 0) {
	        delaySearch = startSearch + 120000; // 1000 -> 1초
	        var sqlID = "custom_SQL.zharim_getAllExcelProcessList";
	        var param = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
	                  + "&sqlID=" + sqlID;

	        $("#loading").fadeIn(100);
	        $.ajax({
	            url: "jsonDhtmlxListV7.do",
	            type: "POST",
	            data: param,
	            success: function(result) {
	                $("#loading").fadeOut(100);

	                // JSON 문자열이면 파싱
	                if (typeof result === 'string') {
	                    try {
	                        result = JSON.parse(result);
	                    } catch(e) {
	                        console.error("JSON 파싱 오류:", e);
	                        return;
	                    }
	                }

	                // Description만 클린 처리
	                result.forEach(function(item) {
	                    if (item.Description) {
	                        item.Description = getJSONFormatClean(item.Description);
	                    }
	                });

	                fnReloadGrid(result);                
	            },
	            error: function(xhr, status, error) {
	                console.log("ERR :[" + xhr.status + "]" + error);
	                $("#loading").fadeIn(100);
	            }
	        });    
	    } else {
	        alert("All Process List 생성 중입니다.");
	        return;
	    }
	}

   
   function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
		//fnMasterChk('');
		$("#TOT_CNT").html(grid.data.getLength());
	}
   
	var delay = 0;
	function doExcel() {
		if(!confirm("Excel download 를 진행 하시겠습니까?")){ return;}
		var start = new Date().getTime();	
		if(start > delay || delay == 0){
			delay = start + 120000; // 1000 -> 1초
			//console.log("start :"+start+", delay :"+delay);
			fnGridExcelDownLoad('','Y','하림그룹 To-Be Process 체계도', 'custom_SQL.zharim_getAllExcelProcessList_gridList');
/* 			grid.export.xlsx({
			        url: "//export.dhtmlx.com/excel"
			        ,name: "하림그룹 To-Be Process 체계도" 
			    }); */
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
   grid.events.on("cellClick", function(row,column,e){
			doDetail(row.ItemID);
   }); 
   
    function doDetail(avg1){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop"+"&accMode=${accMode}";
		var w = 1400;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
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
        <input id="Search" type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" style="display:inline-block;">
           <span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
         </li>
	</div>
	<div id="gridDiv" style="width:100%;" class="clear">
		<div id="grdGridArea" style="width:100%"></div>
	</div>

</div>
</form>
<iframe name="blankFrame" id="blankFrame" style="width:0px;height:0px; display:none;"></iframe>