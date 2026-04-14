<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<%-- <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%> --%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
	var inProgress = false;
	
	$(document).ready(function(){
		
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 190)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 190)+"px;");
		};
		
		fnSetButton("search-btn", "search", "Search");
		fnSetButton("excel", "", "Excel", "secondary");
		
		// 관계사
		var selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&esType=${esType}&myCSR=Y&notCompanyIDs=${notCompanyIDs}";
		fnSelect('customerNo', selectData, 'getESPCustomerList', '${sessionScope.loginInfo.sessionClientId}', 'false', 'esm_SQL');
		$("input.datePicker").each(generateDatePicker);
		
		// 날짜 셋팅
		setDefaultDate();
		
		//fnSearch();
		
	});

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	// 기본 조회날짜 셋팅
	function setDefaultDate(){
		var dateObject = setDefaultLocalDate(7);
		var sDate = dateObject["startDate"];
		var tDate = dateObject["endDate"];
		
		$("#startDate").val(sDate);
		$("#endDate").val(tDate);
	}
	
	
	// 엑셀 다운로드
	function doExcel() {	
		var searchType = $("#searchType").val();
		
		const now = new Date();
		const formattedDateTime = now.getFullYear() 
		                        + String(now.getMonth() + 1).padStart(2, '0') 
		                        + String(now.getDate()).padStart(2, '0') 
		                        + String(now.getHours()).padStart(2, '0') 
		                        + String(now.getMinutes()).padStart(2, '0');
		
		if(searchType == "totalSearchType"){ // 접수자 asis reg_usr_name 으로 정의 해놨지만 쿼리에는 없으므로 tobe 에서 접수자 컬럼 제외시킴
			const fileName = "ReqStat_" + formattedDateTime;
			fnGridExcelDownLoad(grid, "Y", fileName);
		} else {
			const fileName = "ErrorReqStat_" + formattedDateTime;
			fnGridExcelDownLoad(errGrid, "Y", fileName);
		}
	}
	
	
</script>
<div style="display:none;" id="excelGrid"></div>

<div id="srListDiv" class="pdL10 pdR10">
	<div class="page-title">서비스요청 통계</div>
	<!-- BEGIN :: SEARCH -->
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="form-column-4 new-form" id="search">
		<tr>
		
			<th class="alignL">조회구분</th>
	       	<td class="alignL">
	       		<select id="searchType" Name="searchType" style="width: 60%;display: inline-block;">
		       		<option value='totalSearchType'>전체티켓</option>
		       		<option value='errorSearchType'>장애오류티켓</option>
		       	</select>
	       	</td>
	       	
	       	<th class="alignL">관계사</th>
	       	<td class="alignL">
	       		<select id="customerNo" Name="customerNo" style="width: 60%;display: inline-block;">
		       		<option value=''></option>
		       	</select>
	       	</td>
	       	
	       	<c:set var="now" value="<%=new java.util.Date()%>" />
			<fmt:formatDate value="${now}" pattern="yyyy" var="nowYear"/>
			<fmt:formatDate value="${now}" pattern="MM"	var="nowMonth"/>
			
			<th class="alignL">조회기간</th>
			<td>     
				<input type="text" id="startDate" name="startDate" value=""	class="input_off datePicker stext" size="8"
					onchange="this.value = makeDateType(this.value);"	maxlength="15" >
				
				-
				<input type="text" id="endDate" name="endDate" value=""	class="input_off datePicker stext" size="8"
					onchange="this.value = makeDateType(this.value);"	maxlength="15">
				
			</td>
		</tr>
	</table>
	<span style="color: #0761cf;display: inline-block;margin-top: 10px;">* 관계사 "전체"로 조회가 필요한 경우 시스템 관리자에게 요청 해 주시기 바랍니다</span>
	
	<div class="btn-wrap justify-center pdT10">
		<div class="btns">
			<button id="search-btn" onclick="fnSearch();"></button>
			<button id="excel" onclick="doExcel()"></button>
		</div>
	</div>
	
	<ul class="btn-wrap pdT20 pdB10" >
		<li class="count">Total  <span id="TOT_CNT"></span></li>
	</ul>
			
	<div style="width:100%;" id="layout"></div>
	<div style="width:100%; display:none;" id="errlayout"></div>
	
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	
</div>
<script type="text/javascript">
	
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var errlayout = new dhx.Layout("errlayout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	

	// 전체 grid
	var grid = new dhx.Grid("grdOTGridArea", {
	    columns: [
	        {  width: 150, id: "SRCode", header: [{ text: "티켓아이디", align: "center" }], align: "center" , hidden: false, },
	        {  width: 100, id: "gubun", header: [{ text: "구분", align: "center" }], align: "center" ,hidden: false, },
	        {  width: 150, id: "StatusNM", header: [{ text: "상태", align: "center" }], align: "center" ,hidden: false, },
	        {  width: 200, id: "CategoryNM", header: [{ text: "의뢰유형1", align: "center" }], align: "center" ,hidden: false, },
	        {  width: 200, id: "fl_cat_name", header: [{ text: "의뢰유형2", align: "center" }], align: "center" ,hidden: false, },
	        {  width: 80, id: "cat_chg_yn", header: [{ text: "변경여부", align: "center" }], align: "center", hidden: true, },
	        {  width: 80, id: "l1_name", header: [{ text: "대분류", align: "center" }], align: "center",hidden: false, },
	        {  width: 150,id: "l2_name", header: [{ text: "중분류", align: "center" }], align: "center",hidden: false, },
	        {  width: 200, id: "srAreaNM", header: [{ text: "대상서비스", align: "center" }], align: "center",hidden: false, },
	        {  width: 300, id: "Subject", header: [{ text: "제목", align: "center" }], align: "center" , hidden: false,},
	        {  width: 300, id: "Description", header: [{ text: "내용", align: "center" }], align: "center" , hidden: true,},
	        {  width: 300, id: "fl_desc", header: [{ text: "1선해결방법", align: "center" }], align: "center" , hidden: true,},
	        {  width: 300, id: "sl_desc", header: [{ text: "2선해결방법", align: "center" }], align: "center" , hidden: true,},
	        {  width: 100, id: "regDT", header: [{ text: "요청일자", align: "center" }], align: "center" , hidden: false,},
	        {  width: 100, id: "requestUserTeamNM", header: [{ text: "요청부서", align: "center" }], align: "center" , hidden: false,},
	        {  width: 100, id: "requestUserNM", header: [{ text: "요청자", align: "center" }], align: "center" ,hidden: false, },
	        {  width: 100, id: "fl_usr_name", header: [{ text: "1선담당자", align: "center" }], align: "center", hidden: false,},
	        {  width: 100, id: "sl_usr_name", header: [{ text: "2선담당자", align: "center" }], align: "center" , hidden: false,},
	        {  width: 100, id: "mng_usr_name", header: [{ text: "담당자", align: "center" }], align: "center" , hidden: false,},
	        {  width: 90, id: "regUserNM", header: [{ text: "등록자", align: "center" }], align: "center" , hidden: false,},
	    ],
	    
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: false
	});
	
	// 오류 그리드
	var errGrid = new dhx.Grid("grdOTGridArea", {
	    columns: [
	        {  width: 120, id: "CompanyNM", header: [{ text: "관계사", align: "center" }], align: "center" , hidden: false,},
	        {  width: 150, id: "SRCode", header: [{ text: "티켓아이디", align: "center" }], align: "center" , hidden: false,},
	        {  width: 200, id: "CategoryNM", header: [{ text: "의뢰유형", align: "center" }], align: "center" ,hidden: false, },
	        {  width: 200, id: "srAreaNM", header: [{ text: "서비스구분", align: "center" }], align: "center" , hidden: false,},
	        {  width: 100, id: "requestUserNM", header: [{ text: "요청자", align: "center" }], align: "center" ,hidden: false, },
	        {  width: 100, id: "fl_usr_name", header: [{ text: "1선담당자", align: "center" }], align: "center", hidden: false,},
	        {  width: 100, id: "sl_usr_name", header: [{ text: "2선담당자", align: "center" }], align: "center",  hidden: false,},
	        {  width: 120, id: "cellName", header: [{ text: "쎌명", align: "center" }], align: "center" ,hidden: false, },
	        {  width: 100, id: "RegDT", header: [{ text: "등록일", align: "center" }], align: "center" , hidden: false,},
	        {  width: 300, id: "Subject", header: [{ text: "제목", align: "center" }], align: "center" ,hidden: false, },
	        {  width: 300, id: "Description", header: [{ text: "요청사항", align: "center" }], align: "center" ,hidden: false, },
	        {  width: 300, id: "dfcontent", header: [{ text: "처리내용", align: "center" }], align: "center" , hidden: false,},
	        {  width: 150, id: "StatusNM", header: [{ text: "처리상태", align: "center" }], align: "center" , hidden: false,},
	    ],
	    
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: false
	});


	layout.getCell("a").attach(grid);
	errlayout.getCell("a").attach(errGrid);
	
	function fnSearch(){ 		
		var startDate= $("#startDate").val(); 
		var endDate= $("#endDate").val();
		
		if (!startDate || !endDate) {
		    alert("조회기간을 모두 입력해주세요.");
		    return false;
		}
		if (!checkDateYear(startDate, endDate, 365, "12개월")){
			return false;
		}
		
		var customerNo= $("#customerNo").val();
		
		var searchType = $("#searchType").val();
		
		if(searchType == "totalSearchType"){
			var sqlID = "zDLM_SQL.getReqStatReport";
		} else {
			var sqlID = "zDLM_SQL.getErrorReqStatReport";
		}
		
		var param = "sqlID="+sqlID+"&customerNo=" + customerNo + "&startDate="+startDate+"&endDate=" + endDate + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&myCSR=Y&userID=${sessionScope.loginInfo.sessionUserId}";
		
		if(inProgress) {
			alert("목록을 불러오고 있습니다.");
		} else {
			inProgress = true;
			$('#loading').fadeIn(150);
			
			/*
			$.ajax({
				url:"jsonDhtmlxListV7.do",
				type:"POST",
				data:param,
				success: function(result){
					fnReloadGrid(result,searchType,excel);				
				},error:function(xhr,status,error){
					$('#loading').fadeOut(150);
					console.log("ERR :["+xhr.status+"]"+error);
				}
			});	
			*/
			
			fetch("zDlm_jsonDhtmlxListV7.do", {
			    method: "POST",
			    body: new URLSearchParams(param),
			    headers: {
			        "Content-Type": "application/x-www-form-urlencoded" 
			    }
			})
			.then(response => {
			    if (!response.ok) {
			        throw new Error('서버 오류가 발생했습니다.'); 
			    }
			    return response.json();  // JSON 응답으로 처리
			})
			.then(result => {
				fnReloadGrid(result,searchType,excel);				
			})
			.catch(error => {
				alert('조회 시간이 오래 걸려서 요청을 중단하였습니다.\n시스템 담당자에게 연락 부탁 드립니다.');
			})
			.finally(() => {
				inProgress = false;
			    $('#loading').fadeOut(150);  // 로딩 화면 숨기기
			});
			
			
		}
	}
	
	function fnReloadGrid(newGridData,searchType){
		if(searchType === "totalSearchType"){
			$("#layout").show();
			$("#errlayout").hide();
			grid.data.parse(newGridData);
			$("#TOT_CNT").html(grid.data.getLength());
			//inProgress = false;
			//$('#loading').fadeOut(150);
			
		} else {
			$("#layout").hide();
			$("#errlayout").show();
			errGrid.data.parse(newGridData);
			$("#TOT_CNT").html(errGrid.data.getLength());
			//inProgress = false;
			//$('#loading').fadeOut(150);
			
		}
	}
	
	

</script>

