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
		/* fnSetButton("excelTest", "", "Excel test", "secondary"); */
		
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
	
	// 담당자 검색
	function searchPopupWf(){
		window.open("searchMemberPop.do?myClient=${myClient}&notCompanyIDs=22&searchValue="+$("#ReceiptUserName").val(),'searchMemberPop','width=900, height=700');
	}
	
	function searchMemberCallback(avg1,avg2,avg3,avg4){
		$("#ReceiptUserName").val(avg2+"("+avg3+"/"+avg4+")");
		$("#receiptUserID").val(avg1);
	}
	
	
	
	// 엑셀 다운로드
	function doExcel() {	
		const now = new Date();
		const formattedDateTime = now.getFullYear() 
		                        + String(now.getMonth() + 1).padStart(2, '0') 
		                        + String(now.getDate()).padStart(2, '0') 
		                        + String(now.getHours()).padStart(2, '0') 
		                        + String(now.getMinutes()).padStart(2, '0');
		
		const fileName = "MhStat_" + formattedDateTime;
		var gridType = excelGrid;
		var sheet1 = "1.MH실적집계_티켓별";
		var sheet2 = "2.MH실적집계_일자별";
		var sqlCodeSheet2 = "zDLM_SQL.selectMhStatDailyList";
		var disPlayHidden = "Y";
		
		var excelDataRow = new Array();
		var headers = new Array();
		var ids = new Array();
		var aligns = new Array();
		var widths = new Array();
		var hiddens = new Array();
		var headers2 = new Array();
		var headers3 = new Array();
		var name ="";
		var headersCols = new Array();
		var headers2Cols = new Array();
		var headers3Cols = new Array();
		
		var headersSheet2 = "아이디,성명,작업일자,MH";
		var idsSheet2 ="STEP_MNG_ID,STEP_MNG_NM,WORK_DATE,WORK_TIME_MM";
		
		if(disPlayHidden == "Y"){ // grid hidden column도 출력되도록
			for(var i2=0; i2 < gridType.config.columns.length; i2++){
				if(gridType.config.columns[i2].id != "checkbox"){
					headers.push(gridType.config.columns[i2].header[0].text);
					
					if(gridType.config.columns[i2].header[0].colspan != "" && gridType.config.columns[i2].header[0].colspan != undefined){
						headersCols.push(gridType.config.columns[i2].header[0].colspan);
					}else{
						headersCols.push("1");
					}
						
					if(gridType.config.columns[i2].header[1] != undefined){
						if (gridType.config.columns[i2].header[1].text != "" && gridType.config.columns[i2].header[1].text != undefined) {
		                    headers2.push(gridType.config.columns[i2].header[1].text);
		            	}else{
		            		headers2.push(" ");
		            	}
						if (gridType.config.columns[i2].header[1].colspan != "" && gridType.config.columns[i2].header[1].colspan != undefined) {
		                	headers2Cols.push(gridType.config.columns[i2].header[1].colspan);
		            	}else{
							headers2Cols.push("");		            		
		            	}
	            	}
	            	
	            	//header3 추가 
	            	if(gridType.config.columns[i2].header[2] != undefined){
						if (gridType.config.columns[i2].header[2].text != "" && gridType.config.columns[i2].header[2].text != undefined) {
		                    headers3.push(gridType.config.columns[i2].header[2].text);
		            	}else{
		            		headers3.push(" ");
		            	}
						if (gridType.config.columns[i2].header[2].colspan != "" && gridType.config.columns[i2].header[2].colspan != undefined) {
		                	headers3Cols.push(gridType.config.columns[i2].header[2].colspan);
		            	}else{
							headers3Cols.push("");		            		
		            	}
	            	}
					
					ids.push(gridType.config.columns[i2].id);
					//hiddens.push(gridType.config.columns[i2].hidden);
					
					if(gridType.config.columns[i2].align != ""){
						aligns.push(gridType.config.columns[i2].align);
					}else{
						aligns.push("center");
					}
					
					if(gridType.config.columns[i2].$width != ""){
						widths.push(gridType.config.columns[i2].$width);
					}
				}
			}
		}else{
			for(var i2=0; i2 < gridType.config.columns.length; i2++){
				if(!gridType.config.columns[i2].hidden){
					if(gridType.config.columns[i2].id != "checkbox"){
						headers.push(gridType.config.columns[i2].header[0].text);
											
						if(gridType.config.columns[i2].header[0].colspan != "" && gridType.config.columns[i2].header[0].colspan != undefined){
							headersCols.push(gridType.config.columns[i2].header[0].colspan);
						}else{
							headersCols.push("1");
						}
						console.log("gridType.config.columns[i2].header[1] ::"+gridType.config.columns[i2].header[1] );
						if(gridType.config.columns[i2].header[1] != undefined){
							if (gridType.config.columns[i2].header[1].text != "" && gridType.config.columns[i2].header[1].text != undefined) {
			                    headers2.push(gridType.config.columns[i2].header[1].text);
			            	}else{
			            		headers2.push(" ");
			            	}
							if (gridType.config.columns[i2].header[1].colspan != "" && gridType.config.columns[i2].header[1].colspan != undefined) {
			                	headers2Cols.push(gridType.config.columns[i2].header[1].colspan);
			            	}else{
								headers2Cols.push("");		            		
			            	}
		            	}
		            	
		            	console.log("gridType.config.columns[i2].header[2] ::"+gridType.config.columns[i2].header[2] );
		            	
		            	//header3 추가 
		            	if(gridType.config.columns[i2].header[2] != undefined){
							if (gridType.config.columns[i2].header[2].text != "" && gridType.config.columns[i2].header[2].text != undefined) {
			                    headers3.push(gridType.config.columns[i2].header[2].text);
			            	}else{
			            		headers3.push(" ");
			            	}
							if (gridType.config.columns[i2].header[2].colspan != "" && gridType.config.columns[i2].header[2].colspan != undefined) {
			                	headers3Cols.push(gridType.config.columns[i2].header[2].colspan);
			            	}else{
								headers3Cols.push("");		            		
			            	}
		            	}
	            	
					
						ids.push(gridType.config.columns[i2].id);
						if(gridType.config.columns[i2].align != "" && gridType.config.columns[i2].align != undefined){
							aligns.push(gridType.config.columns[i2].align);
						}else{
							aligns.push("center");
						}
						
						if(gridType.config.columns[i2].$width != ""){
							widths.push(gridType.config.columns[i2].$width);
						}
					}
				}
			}
		}
			
		for(var i=0; i< gridType.data._order.length; i++) {
			excelDataRow.push(gridType.data._order[i]);			
		}
				
		var jsonData = JSON.stringify(excelDataRow);	
		var excelForm = document.createElement("form");
		excelForm.setAttribute("charset", "UTF-8");
		excelForm.setAttribute("method", "Post");  
	
		var customerNo = $("#customerNo").val();
		var startDate= $("#startDate").val(); 
		var endDate= $("#endDate").val(); 
		
		var receiptUserName = $("#ReceiptUserName").val();
		var receiptUserID = (receiptUserName === undefined || receiptUserName === '' || receiptUserName === null) ? '' : $("#receiptUserID").val();
		var data = {
			gridExcelData : jsonData,
			headers : headers,
			headers2 : headers2,
			headers3 : headers3,
			
			headersCols : headersCols,
			headers2Cols : headers2Cols,
			headers3Cols : headers3Cols,
			ids : ids,
			aligns : aligns,
			widths : widths,
			hiddens : hiddens,
			fileName : fileName,
			sheet1 : sheet1,
			sheet2 : sheet2,
			sqlCodeSheet2 : sqlCodeSheet2,
			headersSheet2 : headersSheet2,
			idsSheet2 : idsSheet2,
			startDate : startDate,
			endDate : endDate,
			customerNo : customerNo,
			receiptUserID : receiptUserID,
			languageID : "${sessionScope.loginInfo.sessionCurrLangType}",
			myCSR : "Y",
			userID : "${sessionScope.loginInfo.sessionUserId}"		
		};
		
		if (data) {
	      for (var key in data) {
	        var input = document.createElement("input");
	        input.id = key;
	        input.name = key;
	        input.type = "hidden";
	        input.value = data[key];
	        excelForm.appendChild(input);
	      }
	    }
	    
	    document.body.appendChild(excelForm);
	    
	    $("#isSubmit").val('');
	    var url = "excelFileDownload.do";	        
		ajaxSubmit(excelForm, url, "blankFrame");
		
	}
	
	function excelTest() {
		$('#fileDownLoading').removeClass('file_down_off');
		$('#fileDownLoading').addClass('file_down_on');
		var url = "zdlm_test_exceldown.do";
		ajaxPage(url, "", "blankFrame");	
	}
	
	function doFileDown(avg1, avg2) {
		var url = "fileDown.do";
		$('#original').val(avg1);
		$('#filename').val(avg1);
		
		ajaxSubmitNoAlert(document.reportFrm, url);
		$('#fileDownLoading').addClass('file_down_off');
		$('#fileDownLoading').removeClass('file_down_on');
	}
	
</script>
<script type="text/javascript">
	
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	var layout2 = new dhx.Layout("layout2", {
	    rows: [
	        {
	            id: "b",
	        },
	    ]
	});
	
	var grid = new dhx.Grid("grdOTGridArea", {
	    columns: [
			{ width: 80, id: "RowNum", header: [{ text: "번호", align: "center" }], align: "center", hidden:false,
			footer: [ { text: '총 계', align: "center"  },]},
	        { width: 180, id: "ClientName", header: [{ text: "관계사", align: "center" }], align: "center" , hidden:false },
	        { width: 100, id: "TypeName", header: [{ text: "프로세스", align: "center" }], align: "center" , hidden:false },
	        { width: 200, id: "SRCode", header: [{ text: "티켓ID", align: "center" }], align: "center" , hidden:false },
	        { hidden: true, width:200, id: "CategoryNM", header: [{ text: "의뢰유형", align: "center" }], align: "center"},
	        { id: "Subject", header: [{ text: "제목", align: "center" }], align: "center" , hidden:false },
	        { hidden: true, width:300, width:200, id: "Description", header: [{ text: "내용", align: "center" }], align: "center"},
	        { width: 120, id: "ReceiptUserName", header: [{ text: "담당자", align: "center" }], align: "center" , hidden:false },
	        { width: 300, id: "SRStatusName", header: [{ text: "프로세스 단계", align: "center" }], align: "center" , hidden:false },
	        { width: 120, id: "WORK_DATE", header: [{ text: "처리일자", align: "center" }], align: "center" , hidden:false },
	        { hidden: true, width:120, id: "DueDate", header: [{ text: "완료예정일", align: "center" }], align: "center"},
	        { hidden: true, width:120, id: "CompletionDT", header: [{ text: "완료일", align: "center" }], align: "center"},
	        { hidden: true, width:120, id: "BUSINESS_HOUR", header: [{ text: "시간내", align: "center" }], align: "center"},
	        { hidden: true, width:120, id: "OVERTIME", header: [{ text: "시간외", align: "center" }], align: "center"},
	        { width: 120, id: "PROCESS_DATE", header: [{ text: "처리시간 [시간내/외]", align: "center" }], align: "center", footer: [{ text: "0", align:"center" }] , hidden:false },
	    ],
	    
	    autoWidth: true,
	    //autoHeight: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: false
	  
	});
	
	var excelGrid = new dhx.Grid("grdOTGridArea", {
	    columns: [
			{ width: 80, id: "RowNum", header: [{ text: "번호", align: "center" }], align: "center", hidden:false,footer: [ { text: '총 계', align: "center"  },]},
			{ width: 200, id: "SRCode", header: [{ text: "티켓ID", align: "center" }], align: "center" , hidden:false },
			{ width: 180, id: "ClientName", header: [{ text: "관계사", align: "center" }], align: "center" , hidden:false },
	        { width: 100, id: "TypeName", header: [{ text: "구분", align: "center" }], align: "center" , hidden:false },
	        { hidden: true, width:200, id: "CategoryNM", header: [{ text: "의뢰유형", align: "center" }], align: "center"},
	        { id: "Subject", header: [{ text: "제목", align: "center" }], align: "center" , hidden:false },
	        { hidden: true, width:300, width:200, id: "Description", header: [{ text: "내용", align: "center" }], align: "center"},
	        { width: 120, id: "ReceiptUserName", header: [{ text: "담당자", align: "center" }], align: "center" , hidden:false },
	        { width: 300, id: "SRStatusName", header: [{ text: "프로세스 단계", align: "center" }], align: "center" , hidden:false },
	        { width: 120, id: "WORK_DATE", header: [{ text: "처리일자", align: "center" }], align: "center" , hidden:false },
	        { hidden: true, width:120, id: "DueDate", header: [{ text: "완료예정일", align: "center" }], align: "center"},
	        { hidden: true, width:120, id: "CompletionDT", header: [{ text: "완료일", align: "center" }], align: "center"},
	        { hidden: true, width:120, id: "BUSINESS_HOUR", header: [{ text: "시간내", align: "center" }], align: "center"},
	        { hidden: true, width:120, id: "OVERTIME", header: [{ text: "시간외", align: "center" }], align: "center"}
	    ],
	    
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: false
	  
	});

	function updateFooter() {
	    const data = grid.data.serialize();
	    let total = data.reduce((sum, item) => sum + (item.WORK_TIME_MM || 0), 0);
	    total = total.toFixed(2);
	    
	    grid.config.columns[14].footer[0].text = total;
	}


	layout.getCell("a").attach(grid);
	layout2.getCell("b").attach(excelGrid);
	
	function fnSearch(){ 		
		var customerNo = $("#customerNo").val();
		var startDate= $("#startDate").val(); 
		var endDate= $("#endDate").val(); 
		
		if (!startDate || !endDate) {
		    alert("조회기간을 모두 입력해주세요.");
		    return false;
		}
		if (!checkDateYear(startDate, endDate, 365,"12개월")){
			return false;
		}
		
		var receiptUserName = $("#ReceiptUserName").val();
		var receiptUserID = (receiptUserName === undefined || receiptUserName === '' || receiptUserName === null) ? '' : $("#receiptUserID").val();
		
		var sqlID = "zDLM_SQL.getMHStatList";
		var param = "sqlID="+sqlID+"&startDate="+startDate+"&endDate="+endDate+"&customerNo="+customerNo+"&receiptUserID="+receiptUserID
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&myCSR=Y&userID=${sessionScope.loginInfo.sessionUserId}";
		
		if(inProgress) {
			alert("목록을 불러오고 있습니다.");
		} else {
			inProgress = true;
			$('#loading').fadeIn(150);
			
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
				fnReloadGrid(result);				
			})
			.catch(error => {
				alert('조회 시간이 오래 걸려서 요청을 중단하였습니다.\n시스템 담당자에게 연락 부탁 드립니다.');
			})
			.finally(() => {
				inProgress = false;
			    $('#loading').fadeOut(150);  // 로딩 화면 숨기기
			});
			
			/*
			$.ajax({
				url:"jsonDhtmlxListV7.do",
				type:"POST",
				data:param,
				success: function(result){
					fnReloadGrid(result);				
				},error:function(xhr,status,error){
					$('#loading').fadeOut(150);
					console.log("ERR :["+xhr.status+"]"+error);
				}
			});
			*/
		}
	}
	
	function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
		excelGrid.data.parse(newGridData);
		updateFooter();
		$("#TOT_CNT").html(grid.data.getLength());
		//inProgress = false;
		//$('#loading').fadeOut(150);
	}
	
	

</script>


<div style="display:none;" id="excelGrid"></div>
<form name="reportFrm" id="reportFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="original" name="original" value="">
	<input type="hidden" id="filename" name="filename" value="">
	<input type="hidden" id="scrnType" name="scrnType" value="excel">
</form>
<div id="srListDiv" class="pdL10 pdR10">
	<div class="page-title">개인별 MH 실적집계</div>
	
	<!-- BEGIN :: SEARCH -->
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="form-column-4 new-form" id="search">
		<tr>
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
	        
			<th class="alignL">담당자</th>
	       	<td class="alignL">
				<input type="text" class="text" id="ReceiptUserName" name="ReceiptUserName" value="${sessionScope.loginInfo.sessionUserNm}" style="width:250px;" autocomplete="off" />
				<input type="hidden" id="receiptUserID" name="receiptUserID" value="${sessionScope.loginInfo.sessionUserId}" />
				<img id="searchRequestBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" / onclick="searchPopupWf()">
	       	</td>
		</tr>
	</table>
	<span style="color: #0761cf;display: inline-block;margin-top: 10px;">* 관계사 "전체"로 조회가 필요한 경우 시스템 관리자에게 요청 해 주시기 바랍니다</span>
	<div class="btn-wrap justify-center pdT10">
		<div class="btns">
			<button id="search-btn" onclick="fnSearch();"></button>
			<button id="excel" onclick="doExcel()"></button>
			<!-- <button id="excelTest" onclick="excelTest()"></button> -->
		</div>
	</div>
	
	<ul class="btn-wrap pdT20 pdB10" >
		<li class="count">Total  <span id="TOT_CNT"></span></li>
	</ul>
			
	<div style="width:100%;" id="layout"></div>
	<div style="width:100%; display:none;" id="layout2"></div>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>

</div>

