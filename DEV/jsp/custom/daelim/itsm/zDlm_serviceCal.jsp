<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script>
	var screenType = "${screenType}";
	var baseURL = "${baseUrl}";
	var templProjectID = "${templProjectID}";
	var projectType = "${projectType}";
	var projectCategory = "${projectCategory}";
	var projectID = "${projectID}";
	var projectIDs = "${projectIDs}";
	
	$(document).ready(function(){

		// 초기 표시 화면 크기 조정 
		if(screenType == 'cust' && projectIDs == ''){projectIDs = "0";}
		$("#layout").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		};
		
		// project select
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}";
		if(templProjectID != undefined && templProjectID != '') {
			/* data = data + "&templProjectID="+templProjectID+"&projectType="+projectType; */
			data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&myCSR=${myCSR}&notCompanyIDs=${notCompanyIDs}"+"&projectType="+projectType;
		}
		fnSelect('corpId', data, 'getSerCustomerList', projectID, 'Select', 'zDLMserviceCal_SQL');
		//fnSelect('year', data, 'getYear', projectID, 'Select', 'zDLMserviceCal_SQL');
		//fnSelect('mon', data, 'getMon', projectID, 'Select', 'zDLMserviceCal_SQL');
		
		
		//fnSelect('fyear', data, 'getYear', projectID, 'Select', 'zDLMserviceCal_SQL');
		//fnSelect('tyear', data, 'getYear', projectID, 'Select', 'zDLMserviceCal_SQL');
		//fnSelect('fmon', data, 'getMon', projectID, 'Select', 'zDLMserviceCal_SQL');
		//fnSelect('tmon', data, 'getMon', projectID, 'Select', 'zDLMserviceCal_SQL');
		
		// on Click
		$('.searchList').click(function(){
			doSearchList();
			return false;
		});
		
		// on Click
		$('.exeSvcAdmPkg').click(function(){
			doExeSvcAdmPkg();
			return false;
		});
		
		// on Click
		$('.excelDown').click(function(){
			doExcelDown("zDlm_selectServiceCalExcel.do");
			return false;
		});
		
		// on Click
		$('.excelDown2').click(function(){
			doExcelDown("zDlm_selectServiceCalExcel2.do");
			return false;
		});
		
		// on Click
		$('.excelDown3').click(function(){
			doExcelDown2("zDlm_selectServiceCalExcel3.do");
			return false;
		});
		
		$('#searchValue').keypress(function(onkey){
			if(onkey.keyCode == 13){
				
				doSearchList();
				return false;
			}
		});	
		

		
		//setTimeout(function() {$('#searchValue').focus();}, 0);		
		//setTimeout(function() {doSearchList(); }, 100);
		
		// 예를 들어 2020년부터 현재년도 + 1년까지
		const thisYear = new Date().getFullYear();
		for (let y = 2018; y <= thisYear; y++) {
		  $("#year").append("<option value="+y+">"+y+"</option>");
		  $("#fyear").append("<option value="+y+">"+y+"</option>");
		  $("#tyear").append("<option value="+y+">"+y+"</option>");
		  
		  //console.log(y);
		}
		
		// 1~12월
		for (let m = 1; m <= 12; m++) {
		  const mm = String(m).padStart(2, '0');
		  $("#mon").append("<option value="+mm+">"+mm+"</option>");
		  $("#fmon").append("<option value="+mm+">"+mm+"</option>");
		  $("#tmon").append("<option value="+mm+">"+mm+"</option>");
		  
		  //console.log(m);
		}
		
		//setTimeout(function() {doPreMon(); }, 100);
		const today = new Date();
	  	today.setMonth(today.getMonth() - 1); // 저번달로 이동

		const year = today.getFullYear();
		const month = String(today.getMonth() + 1).padStart(2, '0'); // 월은 0~11로 표시되므로 +1 필요

		$("#year").val(year);
		$("#mon").val(month);
		
		$("#fyear").val(year);
		$("#fmon").val(month);
		$("#tyear").val(year);
		$("#tmon").val(month);	
	});
	
	function doPreMon(){
			
	}

	//조회
	function doSearchList(){
		
		
		var year = $("#year").val();
		var mon = $("#mon").val();
		var corpId = $("#corpId").val();
		
		if(year == "" || mon == "" || corpId == ""){
			alert("관계사 및 년 월을 선택 후 조회해 주시기 바랍니다.");
			return false;
		}

		$('#loading').fadeIn(150);
		
		var sqlID = "zDLMserviceCal_SQL.zDlm_selectServiceCalExcel";
		
		var param = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}" 
			+ "&userID=${sessionScope.loginInfo.sessionLoginId}"
			+ "&CORP_ID="+corpId
			+ "&APPLY_YM="+year+""+mon
			+ "&sqlID="+sqlID; 

		$.ajax({
			
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				$('#loading').fadeOut(150);
				
				fnReloadGrid(result);
			
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
	}
	
	function doExeSvcAdmPkg(){
		
		var year = $("#year").val();
		var mon = $("#mon").val();
		var corpId = $("#corpId").val();
		
		if(year == "" || mon == "" || corpId == ""){
			alert("관계사 및 년,월을 선택 후 집계해 주시기 바랍니다.");
			return false;
		}
		
		if(!confirm("집계하시겠습니까?(약 15초정도 소요됩니다.)")){
			return false;
		}
		
		$('#loading').fadeIn(150);
		
		var url = "exeSvcAdmPkg.do";
		var data = "&applyYm="+year+""+mon+"&corpId="+corpId;
		var target = "help_content";
		//ajaxPage(url, data, target);
		
		$.ajax({
			
			url:url,
			type:"POST",
			data:data,
			success: function(result){
				$('#loading').fadeOut(150);
				//fnReloadGrid(result);
				doSearchList();
				alert("집계가 성공하였습니다.");
			
			},error:function(xhr,status,error){
				alert("집계에 실패하였습니다. 관리자에게 문의하여 주시기 바랍니다.");
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});		
	}
	
	function doExcelDown(url){
		
		
		
		var year = $("#year").val();
		var mon = $("#mon").val();
		var corpId = $("#corpId").val();
		
		
		if(year == "" || mon == "" || corpId == ""){
			alert("관계사 및 년 월을 선택 후 엑셀 다운로드 받아 주시기 바랍니다.");
			return false;
		}

		var data = "&applyYm="+year+""+mon+"&corpId="+corpId;
		
		
		var iframe, iframe_doc, iframe_html;
		
		if((iframe = $('#download_iframe')).length === 0){
			iframe = $("<iframe id='download_iframe'" + " style='display: none' src='about:blank'></iframe>").appendTo("body");
		}

		iframe_doc = iframe[0].contentWindow || iframe[0].contentDocument;
		if (iframe_doc.document) {
			iframe_doc = iframe_doc.document;
		}
		
		iframe_html = "<html><head></head><body><form method='POST' action='" + url +"'>";
		//iframe_html += "<input type=hidden name='applyYm' value='" + SEARCH_APPLY_YM +"'/>";
		//iframe_html += "<input type=hidden name='corpId' value='" + $("#select_corp").val() +"'/>";
		iframe_html += "<input type=hidden name='applyYm' value='"+year+""+mon+"'/>";
		iframe_html += "<input type=hidden name='corpId' value='"+corpId+"'/>";
		iframe_html += "</form></body></html>";
		
		iframe_doc.open();
		iframe_doc.write(iframe_html);
		iframe_doc.close();
		$(iframe_doc).find('form').submit();
	}
	
	function doExcelDown2(url){
		
		
		
		var fyear = $("#fyear").val();
		var tyear = $("#tyear").val();
		var fmon = $("#fmon").val();
		var tmon = $("#tmon").val();
		var corpId = $("#corpId").val();
		
		
		if(fyear == "" || tyear == "" || fmon == "" || tmon == "" || corpId == ""){
			alert("관계사 및 년 월을 선택 후 엑셀 다운로드 받아 주시기 바랍니다.");
			return false;
		}

		//var data = "&applyYm="+year+""+mon+"&corpId="+corpId;
		
		
		var iframe, iframe_doc, iframe_html;
		
		if((iframe = $('#download_iframe')).length === 0){
			iframe = $("<iframe id='download_iframe'" + " style='display: none' src='about:blank'></iframe>").appendTo("body");
		}

		iframe_doc = iframe[0].contentWindow || iframe[0].contentDocument;
		if (iframe_doc.document) {
			iframe_doc = iframe_doc.document;
		}
		
		iframe_html = "<html><head></head><body><form method='POST' action='" + url +"'>";
		//iframe_html += "<input type=hidden name='applyYm' value='" + SEARCH_APPLY_YM +"'/>";
		//iframe_html += "<input type=hidden name='corpId' value='" + $("#select_corp").val() +"'/>";
		iframe_html += "<input type=hidden name='fapplyYm' value='"+fyear+""+fmon+"'/>";
		iframe_html += "<input type=hidden name='tapplyYm' value='"+tyear+""+tmon+"'/>";
		iframe_html += "<input type=hidden name='corpId' value='"+corpId+"'/>";
		iframe_html += "</form></body></html>";
		
		iframe_doc.open();
		iframe_doc.write(iframe_html);
		iframe_doc.close();
		$(iframe_doc).find('form').submit();
	}
	
	
	function fnReloadGrid(newGridData){
	    //console.log("newGridData :"+newGridData);
		grid.data.parse(newGridData);
		$("#TOT_CNT").html(grid.data.getLength());
		fnMasterChk('');
	}
	
	var grid = new dhx.Grid("grdOTGridArea", 
			{
	    columns: [
			{ width: 80, id: "APPLY_YM", header: [{ text: "기준년월", align: "center" }], align: "center", 
				template: function(data) {
		            var year = data.substring(0, 4); // 첫 4자리 연도 추출
		            var month = data.substring(4, 7); // 5번째에서 7번째까지 월 추출
		            return year + '-' + month; // yyyy-mm 형식으로 결합
		          }
			  },
  	        { width: 100, id: "CORP_NAME", header: [{ text: "관계사" , align: "center" }], align: "center" },
  	        { width: 80, id: "SVC_TYPE_NAME", header: [{ text: "서비스종류" , align: "center" }], align: "center" },
  	        { width: 120, id: "SVS00001_VAL", header: [{ text: "기본규모(ⓐ)" , align: "center" }], align: "center" },
  	        { width: 120, id: "SVS00002_VAL", header: [{ text: "특정규모(ⓑ)" , align: "center" }], align: "center" },
	        { width: 120, id: "TOT_V", header: [{ text: "서비스규모(ⓐ+ⓑ)" , align: "center" }], align: "center" },
	        { width: 120, id: "PRICE", header: [{ text: "단가(원)(ⓒ)", align: "center" }], align: "right", 
	        	template: function(data) {
                // 3자리마다 콤마를 추가하는 함수
                return data ? data.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") : data;
              }
	        },
	        { width: 180, id: "TOT_P", header: [{ text: "서비스대가산정(원)((ⓐ+ⓑ)xⓒ)" , align: "center" }], align: "right" ,
	        	template: function(data) {
                // 3자리마다 콤마를 추가하는 함수
                return data ? data.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") : data;
              }
	        },
	        { width: 700, id: "REMARK", header: [{ text: "비고", align: "center" }], align: "left"} 
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false
        //data: gridData
	});
	
	// 높이 조절	
	function setWindowHeight(){
		var size = window.innerHeight;
		var height = 0;
		if( size == null || size == undefined){
			height = document.body.clientHeight;
		}else{
			height=window.innerHeight;
		}return height;
	}
	
</script>
<div id="help_content" class="mgL10 mgR10">
<form name="boardForm" id="boardForm" action="" method="post" >
	<input type="hidden" id="NEW" name="NEW" value="">
	<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<input type="hidden" id="categoryCode" name="categoryCode" value="${category}">
	<input type="hidden" id="categoryIndex" name="categoryIndex" value="">
	<input type="hidden" id="categoryCnt" name="categoryCnt" value="">
	
	<c:if test="${screenType != 'cust'}">
		<div class="cop_hdtitle">
			<h3 style="padding: 6px 0;">서비스대가산정 집계 및 조회</h3>
		</div>
	</c:if>
	
	<!-- BEGIN :: SEARCH -->
	<table style="table-layout:fixed;" border="0" cellpadding="0" cellspacing="0" class="tbl_search mgT5"  id="search">
		
	    <tr>
	    	<th class="alignR" >관계사 : </th>
	    	<td class="alignL" ><select id="corpId" name="corpId" class="sel"></select></td>

	    	<th class="alignR" >년도 : </th>
	    	<td class="alignL">
	    		<select id="year" name="year" class="sel"></select>
	    	</td>
	    	<th class="alignR" >월 : </th>
	    	<td class="alignL">
	    		<select id="mon" name="mon" class="sel"></select>
	    	</td>
	    	<td style="width:500px">
	    		&nbsp;
	    	</td>
	    	<td class="alignR">
	    	
		    	<button class="cmm-btn2 searchList" style="height: 30px;" value="Search">Search</button>
		    	
	    	</td>
	    </tr>
	</table>
	<div class="pdT10 alignR" style="border: 0px solid black;">
		<div class="">
			<button class="cmm-btn2 exeSvcAdmPkg" style="height: 30px;" value="Search">수동집계</button>
	    	<button class="cmm-btn2 excelDown" style="height: 30px;" value="Search">EXCEL</button>
	    	<button class="cmm-btn2 excelDown2" style="height: 30px;" value="Search">EXCEL(서비스대가산정)</button>
		</div>
    </div>
    <ul class="btn-wrap pdT20 pdB10" style="border: 0px solid black;">
		<li class="count">Total  <span id="TOT_CNT"></span></li>
	</ul>
	<div id="grdOTGridArea" style="display: flex; align-items: flex-start;border: 0px solid black;">
		<div id="layout"></div>
		<div id="pagination"></div>
	</div>
	
	
	
	
	
	
	
	
	
	
	
	<table style="table-layout:fixed;" border="0" cellpadding="0" cellspacing="0" class="tbl_search mgT5"  id="search">
		
	    <tr>
	    	<th class="alignR" >실적예외 티켓 년월 : </th>
	    	<td class="alignL" style="width:150px;">
	    		<select id="fyear" name="fyear" class="sel"></select>
	    	</td>
	    	<td class="alignL" style="width:150px;">
	    		<select id="fmon" name="fmon" class="sel"></select>
	    	</td>
	    	<td style="width:20px;align:right;">
	    		&nbsp;&nbsp;&nbsp;~
	    	</td>
	    	<td class="alignL" style="width:150px;">
	    		<select id="tyear" name="tyear" class="sel"></select>
	    	</td>
	    	<td class="alignL" style="width:150px;">
	    		<select id="tmon" name="tmon" class="sel"></select>
	    	</td>
	    	<td style="width:300px">
	    		&nbsp;
	    	</td>
	    	<td class="alignR">	    	
		    	<button class="cmm-btn2 excelDown3" style="height: 30px;" value="Search">EXCEL(실적수동집계예외티켓)</button>
	    	</td>
	    </tr>
	</table>
	
	
</form>
</div>
