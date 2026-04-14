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
		$("#layout").attr("style","height:"+(setWindowHeight() - 480)+"px;");
		$("#layout2").attr("style","height:"+(setWindowHeight() - 480)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 480)+"px;");
			$("#layout2").attr("style","height:"+(setWindowHeight() - 480)+"px;");
		};
		
		fnSetButton("search-btn", "search", "Search");
		fnSetButton("excel", "", "Excel", "secondary");
		fnSetButton("excel2", "", "Excel", "secondary");
		
		var selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&esType=${esType}&myCSR=Y&notCompanyIDs=${notCompanyIDs}";
		fnSelect('customerNo', selectData, 'getESPCustomerList', '${customerNo}', 'ALL', 'esm_SQL');
		
		// 날짜 셋팅
		setDefaultDate();
		
		$("input.datePicker").each(generateDatePicker);
		
		//fnSearch("${customerNo}");
		if("${customerNo}" != ""){
			fnGetSRArea1("${customerNo}");
		}	
		
		$("#customerNo").on("change", function(){			
  			var customerNo = $("#customerNo").val();
  			fnGetSRArea1(customerNo);
  		});
		
		$("#srArea1").on("change", function(){
  			var srArea1 = $("#srArea1").val();
  			fnGetSRArea2(srArea1);
  		});
		
	});
	
	function fnGetSRArea1(customerNo){
		selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&customerNo="+customerNo+"&myCSR=Y&&userID=${sessionScope.loginInfo.sessionUserId}";
		fnSelect('srArea1', selectData, "getESMSRArea1", '', 'ALL','esm_SQL');
		//fnGetSRArea2('');
	}
	
	// srArea2 setting ( * customerNo / srArea1 )
	function fnGetSRArea2(SRArea1ID){
		selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&customerNo="+$("#customerNo").val()+"&myCSR=Y&userID=${sessionScope.loginInfo.sessionUserId}";
		if(SRArea1ID == ''){
			$("#srArea2 option").not("[value='']").remove();
		}else{
			fnSelect('srArea2', selectData+ "&parentID="+SRArea1ID, 'getSrArea2','${srInfoMap.SRArea2}', 'Select');
		}
	}
	

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	// 기본 조회날짜 셋팅
	function setDefaultDate(){
		var dateObject = setDefaultLocalDate(7);
		var sDate = dateObject["startDate"];
		var tDate = dateObject["endDate"];
		
		$("#startDate").val(sDate);
		$("#endDate").val(tDate);
	}
	
	function doExcel() {
		const now = new Date();
		const formattedDateTime = now.getFullYear() 
		                        + String(now.getMonth() + 1).padStart(2, '0') 
		                        + String(now.getDate()).padStart(2, '0') 
		                        + String(now.getHours()).padStart(2, '0') 
		                        + String(now.getMinutes()).padStart(2, '0');
		
		const fileName = "ProcessStat_" + formattedDateTime;
		fnGridExcelDownLoad(grid, "", fileName);
	}
	
	function doExcelDetail() {
		const now = new Date();
		const formattedDateTime = now.getFullYear() 
		                        + String(now.getMonth() + 1).padStart(2, '0') 
		                        + String(now.getDate()).padStart(2, '0') 
		                        + String(now.getHours()).padStart(2, '0') 
		                        + String(now.getMinutes()).padStart(2, '0');
		
		const fileName2 = "ProcessStatDetail_" + formattedDateTime;
		fnGridExcelDownLoad(grid2, "", fileName2);
	
	}
	
	
	
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid = new dhx.Grid("grid", {
	    columns: [
	        { width: 100, id: "DS_DEPT", header: [{ text: "관계사", rowspan: 2, align: "center" }], footer: [{ text: "총계", colspan:4, align:"center" }], align: "center" },
	        { width: 120, id: "svc_ci_name1", header: [{ text: "서비스", rowspan: 2, align: "center" }], align: "center" },
	        { width: 120, id: "svc_ci_name", header: [{ text: "파트", rowspan: 2, align: "center" }], align: "center" },
	        { width: 120, id: "REQ_companyNAME", header: [{ text: "요청회사", rowspan: 2, align: "center" }], align: "center" },
	        { width: 80, id: "TOT", type: "number", header: [{ text: "합계", rowspan: 2, align: "center" }], footer: [{ content: "sum", align:"center" }], format: "#", align: "center"},
	        { width: 80, id: "DS_REQ1", header: [{ text: "요청", colspan: 3, align: "center" },{ text: "단순문의", align: "center" }], footer: [{ content: "sum", align:"center" }], format: "#", type: "number", align: "center"},
	        { width: 80, id: "DS_REQ2", header: [{ text: "", align: "center" }, { text: "서비스요청", align: "center" }], footer: [{ content: "sum", align:"center" }], format: "#", type: "number", align: "center" },
	        { width: 80, id: "DS_REQ3", header: [{ text: "", align: "center" }, { text: "오류", align: "center" }], footer: [{ content: "sum", align:"center" }], format: "#", type: "number", align: "center" },
	        // 변경관리 
	        { width: 80, id: "DS_APP", header: [{ text: "변경관리", align: "center",colspan: 4}, { text: "AP변경", align: "center" }], footer: [{ content: "sum", align:"center" }], format: "#", type: "number", align: "center" },
	       
	        { width: 80, id: "DS_DATA", header: [{ text: "", align: "center" },{ text: "데이터변경", align: "center" }], footer: [{ content: "sum", align:"center" }], format: "#", type: "number", align: "center" },
	        
	        { width: 80, id: "DS_INFRA", header: [{ text: "", align: "center" },{ text: "인프라변경", align: "center" }], footer: [{ content: "sum", align:"center" }], format: "#", type: "number", align: "center"},
	        { width: 80, id: "DS_SECURITY", header: [{ text: "", align: "center" },{ text: "보안변경", align: "center" }], footer: [{ content: "sum", align:"center" }], format: "#", type: "number", align: "center"},
	        // 장애 
	        { width: 80, id: "DS_INC", header: [{ text: "장애", rowspan: 2, align: "center" }], footer: [{ content: "sum", align:"center" }], format: "#", type: "number", align: "center" },
	        // 내부요청/작업
	        { width: 80, id: "DS_WORK", header: [{ text: "내부요청/작업", rowspan: 2, align: "center" }], footer: [{ content: "sum", align:"center" }], format: "#", type: "number", align: "center" },
	        // 완료건수 
	        { width: 80, id: "CNTCOMPLETE", header: [{ text: "완료건수", rowspan: 2, align: "center" }], footer: [{ content: "sum", align:"center" }], format: "#", type: "number", align: "center" },
	        { width: 80, id: "CNTCOMPLETE_DUE", header: [{ text: "기안내 완료건수", rowspan: 2, align: "center" }],footer: [{ content: "sum", align:"center" }], format: "#", type: "number", align: "center" },
	        { width: 80, id: "FIRST_RCPT", header: [{ text: "1차 접수건수", rowspan: 2, align: "center" }], footer: [{ content: "sum", align:"center" }], format: "#", type: "number", align: "center" },
	        { width: 80, id: "FIRST_SOLVE", header: [{ text: "1차 처리건수", rowspan: 2, align: "center" }], footer: [{ content: "sum", align:"center" }], format: "#", type: "number", align: "center" },
	        { width: 80, id: "FIRST_RATE", header: [{ text: "1차 해결율", rowspan: 2, align: "center" }], type: "number", align: "center" },
	       
	        { width: 120, id: "svc_ci_id1", hidden:true, header: [{ text: "SRArea1", align: "center" }]},
	        { width: 120, id: "svc_ci_id2", hidden:true, header: [{ text: "SRArea2", align: "center" }]},
	        { width: 120, id: "REQ_companycode", hidden:true, header: [{ text: "ReqCompanyID", align: "center" }]},
	        { width: 120, id: "RequestTeamID", hidden:true, header: [{ text: "RequestTeamID", align: "center" }]}
	    ],
	    
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: false,
	    footer: false
	  
	});


	layout.getCell("a").attach(grid);
	
	function fnCallSearch(){
		var startDate= $("#startDate").val(); 
		var endDate= $("#endDate").val(); 
		
		if (!startDate || !endDate) {
		    alert("조회기간을 모두 입력해주세요.");
		    return false;
		}
		if (!checkDateYear(startDate, endDate,365,"12개월")){
			return false;
		}
		
		fnSearch();
		var initJson ="[{}]";
		fnReloadGrid2(initJson);
	}
	
	function fnSearch(userCustomerNo){ 		
		var customerNo = $("#customerNo").val();

		if(userCustomerNo != '' && userCustomerNo != undefined){
			customerNo = userCustomerNo;
		}
		var stSRReqDT= $("#startDate").val(); 
		var endSRReqDT= $("#endDate").val(); 
		var srArea1= $("#srArea1").val(); 
		var srArea2= $("#srArea2").val(); 
		var compType= $("#compType").val(); 
		var sqlID = "zDLM_SQL.getProcessStatisticsReportList";
		var param = "sqlID="+sqlID+"&stSRReqDT="+stSRReqDT+"&endSRReqDT="+endSRReqDT+"&customerNo="+customerNo
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}"
					+ "&myCSR=Y"
					+ "&srArea1="+srArea1
					+ "&srArea2="+srArea2
					+ "&compType="+compType;
					
		
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
			    fnReloadGrid(result);  // 응답을 처리하는 함수 호출
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
	
	function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
		$("#TOT_CNT").html(grid.data.getLength());
	}
	
	grid.events.on("cellClick", function(row,column,e){
		
		var customerNo = row.CORP_ID;		
		var srArea1 = row.svc_ci_id1;
		var srArea2 = row.svc_ci_id2;
		var requestTeamID = row.RequestTeamID;
		var reqCompanyID = row.REQ_companycode;
		fnSearchDetail(customerNo,srArea1,srArea2,reqCompanyID,requestTeamID);
			
	}); 
	
	
	//------------- 그리드 2 상세 ---------------------------------------------------------------------------------------------------------------------------------
	
	var layout2 = new dhx.Layout("layout2", {
	    rows: [
	        {
	            id: "b",
	        },
	    ]
	});
	
	// StatIntegration_SQL_Oracle.xml  statIntegraionDAO.selectStatProcTypeDetailList
	var grid2 = new dhx.Grid("grid2", {
	    columns: [
	    	{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center", template: function (text, row, col) { return row.RNUM;}},
	        { width: 120, id: "SRCode", header: [{ text: "${menu.LN00396}" , align: "center" }], align: "center" },
	        { width: 120, id: "ReqCompanyName", header: [{ text: "요청회사" , align: "center" }], align: "center" },
	        { width:120, id: "SRTypeNM", header: [{ text: "구분" , align: "center" }], align: "center" },
	        { width: 120, id: "SRArea2Name", header: [{ text: "구성항목" , align: "center" }], align: "center" },
	        { id: "Subject", header: [{ text: "티켓${menu.LN00002}" , align: "center" }], align: "left" },
	        
	        
	        //{ width: 120, id: "SRArea1Name", header: [{ text: "서비스" , align: "center" }], align: "center" },
	        //{ width: 120, id: "SRArea2Name", header: [{ text: "파트" , align: "center" }], align: "center" },
	        
	        { width: 120,  id: "SubCategoryNM", header: [{ text: " ${menu.LN00272}" , align: "center" }], align: "center" },
	        
	        //{ width: 120,  id: "CategoryNM", header: [{ text: "${menu.LN00272}" , align: "center" }], align: "center" },
	        
	        { width: 90, id: "RegDT", header: [{ text: "${menu.LN00093}" , align: "center" }], align: "center" },
	        { width: 180, id: "RequestUserNM", header: [{ text: "의뢰자" , align: "center" }], align: "center" },
	        
	        { width: 120, id: "RCPT_DATE", header: [{ text: "접수일자" , align: "center" }], align: "center" }, 
	        { width: 120, id: "RCPT_NM", header: [{ text: "접수자" , align: "center" }], align: "center" }, 
	        { width: 120, id: "ReceiptName", header: [{ text: "담당자" , align: "center" }], align: "center" }, 
	        { width: 90, id: "DueDate", header: [{ text: "${menu.LN00221}" , align: "center" }], align: "center" },
	        { width: 120, id: "CompletionDT", header: [{ text: "${menu.LN00223}" , align: "center" }], align: "center" },
	        { width: 90, id:  "DelayCNT", header: [{ text: "지연일수" , align: "center" }], align: "center" },
	        { width: 120, id: "StatusName", header: [{ text: "티켓${menu.LN00027}" , align: "center" }], align: "center" },
	    ],
	    
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: false,
	    footer: false
	  
	});


	layout2.getCell("b").attach(grid2);
	
	function fnSearchDetail(customerNo,srArea1,srArea2,reqCompanyID,requestTeamID){
		
		var stSRReqDT= $("#startDate").val(); 
		var endSRReqDT= $("#endDate").val(); 
		if (reqCompanyID == undefined) reqCompanyID = "";
		var sqlID = "zDLM_SQL.getProcessStatisticsDetailList";
		var param = "sqlID="+sqlID+"&regStartDate="+stSRReqDT+"&regEndDate="+endSRReqDT+"&clientID="+customerNo
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&srArea1="+srArea1+"&srArea2="+srArea2
					+ "&reqCompanyID="+reqCompanyID		
					+ "&sessionUserID=${sessionScope.loginInfo.sessionUserId}"
					+ "&myCSR=Y";
					
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
	        	fnReloadGrid2(result);  // 정상 응답 처리
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
					fnReloadGrid2(result);	
					inProgress = false;
					$('#loading').fadeOut(150);
				},error:function(xhr,status,error){
					$('#loading').fadeOut(150);
					console.log("ERR :["+xhr.status+"]"+error);
				}
			});
			*/
		}
	}
	
	function fnReloadGrid2(newGridData){
		grid2.data.parse(newGridData);
	}

</script>

<div id="srListDiv" class="pdL10 pdR10">
<div class="page-title">프로세스별 통계현황</div>
<table border="0" cellpadding="0" cellspacing="0" width="100%" class="form-column-4 new-form" id="search">
	<tr>
       	<th class="alignL">관계사</th>
       	<td class="alignL">
       		<select id="customerNo" Name="customerNo" style="width: 60%;display: inline-block;">
	       		<option value=''></option>
	       	</select>
       	</td>
		 <th class="alignL">서비스</th>
       	<td class="alignL">
       		<select id="srArea1" Name="srArea1" style="width: 60%;display: inline-block;">
	       		<option value=''></option>
	       	</select>
       	</td>
       	 <th class="alignL">파트</th>
       	<td class="alignL">
       		<select id="srArea2" Name="srArea2" style="width: 60%;display: inline-block;">
	       		<option value=''>ALL</option>
	       	</select>
       	</td>
       </tr>
       <tr>
       	<c:set var="now" value="<%=new java.util.Date()%>" />
			<fmt:formatDate value="${now}" pattern="yyyy" var="nowYear"/>
			<fmt:formatDate value="${now}" pattern="MM"	var="nowMonth"/>
		<th class="alignL">요청일자</th>
		<td>     
			<input type="text" id="startDate" name="startDate" value="" class="input_off datePicker stext" size="8"
				onchange="this.value = makeDateType(this.value);"	maxlength="15" >
			
			-
			<input type="text" id="endDate" name="endDate" value=""	class="input_off datePicker stext" size="8"
				onchange="this.value = makeDateType(this.value);"	maxlength="15">
			
        </td>
        <th class="alignL">처리구분</th>
       	<td class="alignL">
       		<select id="compType" Name="compType" style="width: 60%;display: inline-block;">
	       		<option value=''>ALL</option>
	       		<option value='fl'>1선처리</option>
	       		<option value='sl'>2선처리</option>
	       	</select>
       	</td>
	</tr>
</table>
<div class="btn-wrap justify-center pdT10">
	<div class="btns">
		<button id="search-btn" onclick="fnCallSearch();"></button>
		<button id="excel" onclick="doExcel()"></button>
	</div>
</div>
	
<ul class="btn-wrap pdT10 pdB10" >
	<li class="count">Total  <span id="TOT_CNT"></span></li>
</ul>

<div style="width:100%;" id="layout"></div>

<div class="title-wrap" style="display: flex; justify-content: space-between; align-items: center; margin-top: 20px; padding-bottom: 10px;">
	<div class="page-title">통계현황 상세</div>
	<div class="btns">
		<button id="excel2" onclick="doExcelDetail()"></button>
	</div>
</div>
<div id="layout2" style="width:100%;height:100%;"></div>

<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>


