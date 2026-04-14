<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<%-- <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>  --%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
	var inProgress = false;
	
	$(document).ready(function(){
		
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 420)+"px;");
		$("#layout2").attr("style","height:"+(setWindowHeight() - 420)+"px;display:none;");
		$("#layout3").attr("style","height:"+(setWindowHeight() - 420)+"px;display:none;");
		$("#layout4").attr("style","height:"+(setWindowHeight() - 420)+"px;display:none;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 420)+"px;");
			$("#layout2").attr("style","height:"+(setWindowHeight() - 420)+"px;");
			$("#layout3").attr("style","height:"+(setWindowHeight() - 420)+"px;");
			$("#layout4").attr("style","height:"+(setWindowHeight() - 420)+"px;");
		};
		
		fnSetButton("search-btn", "search", "Search");
		fnSetButton("excel", "", "Excel", "secondary");
		fnSetButton("excel2", "", "Excel 상세조회", "secondary");
		fnSetButton("excel3", "", "Excel 사용자지연율(상세)", "secondary");
		fnSetButton("excel4", "", "Excel", "secondary");
		
		// 관계사
		var selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&esType=${esType}&myCSR=Y&notCompanyIDs=${notCompanyIDs}";
		fnSelect('customerNo', selectData, 'getESPCustomerList', '${sessionScope.loginInfo.sessionClientId}', 'ALL', 'esm_SQL');
		fnSelect('customerNo2', selectData, 'getESPCustomerList', '${sessionScope.loginInfo.sessionClientId}', 'ALL', 'esm_SQL');
		$("input.datePicker").each(generateDatePicker);
		
		fnSelectTemaList("${sessionScope.loginInfo.sessionClientId}");
		// 날짜 셋팅
		setDefaultDate();		
		
	});
	
	function fnSelectTemaList(customerNo){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&getRefTeamCode="+customerNo+"&teamType=53";
		fnSelect('teamID', data, 'getTeam', '', 'ALL');
	}

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	// 기본 조회날짜 셋팅
	function setDefaultDate(){
		var dateObject = setDefaultLocalDate(7);
		var sDate = dateObject["startDate"];
		var tDate = dateObject["endDate"];
		
		$("#startDate").val(sDate);
		$("#endDate").val(tDate);
		
		$("#startDate2").val(sDate);
		$("#endDate2").val(tDate);
	}
	
	// 담당자 검색
	function searchPopupWf(){
		window.open("searchMemberPop.do?myClient=${myClient}&notCompanyIDs=22&searchValue="+$("#ReceiptUserName").val(),'searchMemberPop','width=900, height=700');
	}
	
	function searchMemberCallback(avg1,avg2,avg3,avg4){
		$("#ReceiptUserName").val(avg2+"("+avg3+"/"+avg4+")");
		$("#receiptUserID").val(avg1);
	}
	
	function doExcel(){
		var selectType = $("#selectType").val();
		const now = new Date();
		const formattedDateTime = now.getFullYear() 
		                        + String(now.getMonth() + 1).padStart(2, '0') 
		                        + String(now.getDate()).padStart(2, '0') 
		                        + String(now.getHours()).padStart(2, '0') 
		                        + String(now.getMinutes()).padStart(2, '0');
		var fileName = "IndividualMH_list_" + formattedDateTime;
		
		if(selectType == "user"){
			
			// excel 다운 시 format 처리못하는 건 강제 반올림
			let data = gridConfig1.config.data;
		    for (let i = 0; i < data.length; i++) {
		        let row = data[i];  
		        for (let j = 0; j < gridConfig1.config.columns.length; j++) {
		            let col = gridConfig1.config.columns[j];
		            if (col.type === "number" && !isNaN(row[col.id]) && col.format === "#.00") {
		                row[col.id] = parseFloat(row[col.id]).toFixed(2);
		            }
		        }
		    }
		    
			fnGridExcelDownLoad(gridConfig1, "", fileName);
			
			/*
			gridConfig1.export.xlsx({
		        url: "//export.dhtmlx.com/excel",
		        name: fileName ,
		        target: "_self"  
		    });
			*/
		} else if(selectType == "system"){
			// excel 다운 시 format 처리못하는 건 강제 반올림
			let data = gridConfig2.config.data;
		    for (let i = 0; i < data.length; i++) {
		        let row = data[i];  
		        for (let j = 0; j < gridConfig2.config.columns.length; j++) {
		            let col = gridConfig2.config.columns[j];
		            if (col.type === "number" && !isNaN(row[col.id]) && col.format === "#.00") {
		                row[col.id] = parseFloat(row[col.id]).toFixed(2);
		            }
		        }
		    }
			fileName = "IndividualMH_system_" + formattedDateTime;
			fnGridExcelDownLoad(gridConfig2, "", fileName);
			/*
			gridConfig2.export.xlsx({
		        url: "//export.dhtmlx.com/excel",
		        name: fileName ,
		        target: "_self"  
		    });
			*/
		} else if(selectType == "userDelay"){
			fileName = "IndividualMH_userDelay_" + formattedDateTime;
			fnGridExcelDownLoad(gridConfig3, "", fileName);
			/*
			gridConfig3.export.xlsx({
		        url: "//export.dhtmlx.com/excel",
		        name: fileName ,
		        target: "_self"  
		    });
			*/
		} 
	}
	
	
	
</script>
<div style="display:none;" id="excelGrid"></div>

<div id="srListDiv" class="pdL10 pdR10">
	<div class="page-title">개인별 MH</div>
	
	<!-- BEGIN :: SEARCH -->
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="form-column-4 new-form" id="search">
		<tr>
			<th class="alignL">조회구분</th>
	       	<td class="alignL">
	       		<select id="selectType" Name="selectType" style="width: 60%;display: inline-block;">
		       		<option value='user'>사용자</option>  
					<option value='system'>시스템</option> 
					<option value='userDelay'>사용자지연율</option>  
		       	</select>
	       	</td>
	       	
			<th class="alignL">관계사</th>
	       	<td class="alignL">
	       		<select id="customerNo" Name="customerNo" style="width: 60%;display: inline-block;" Onchange="fnSelectTemaList(this.value);">
		       		<option value=''></option>
		       	</select>
	       	</td>
	       	
	       	<th class="alignL">부서명</th>
	       	<td class="alignL">
	       		<select id="teamID" Name="teamID" style="width: 60%;display: inline-block; ">
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
	
	<div class="btn-wrap justify-center pdT10">
		<div class="btns">
			<button id="search-btn" onclick="fnSearch();"></button>
			<button id="excel" onclick="doExcel()"></button>
			<button id="excel2" onclick="fnMHDetailExcelGrid()"></button>
			<button id="excel3" onclick="fnMHUserDelayDtlExcelGrid()"></button>
		</div>
	</div>
	
	<ul class="btn-wrap pdT20 pdB10" >
		<li class="count">Total  <span id="TOT_CNT"></span></li>
	</ul>
			
	<div style="width:100%;" id="layout"></div>
	<div style="width:100%;" id="layout2" style="display:none;"></div>
	<div style="width:100%;" id="layout3" style="display:none;"></div>
	<div style="width:100%;" id="layout4" style="display:none;height:300;"></div>
	
	<div class="page-title">개인별MH 티켓상세</div>
	
	<!-- BEGIN :: SEARCH -->
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="form-column-4 new-form" id="search">
		<tr>
			<th class="alignL">관계사 조회기준</th>
	       	<td class="alignL">
	       		<select id="userType" Name="userType" style="width: 60%;display: inline-block;">
		       		<option value='req'>요청자</option>  
					<option value='mng'>담당자</option> 
		       	</select>
	       	</td>
	       	
			<th class="alignL">관계사</th>
	       	<td class="alignL">
	       		<select id="customerNo2" Name="customerNo2" style="width: 60%;display: inline-block;" Onchange="fnSelectTemaList(this.value);">
		       		<option value=''></option>
		       	</select>
	       	</td>
	       	
	       	<c:set var="now" value="<%=new java.util.Date()%>" />
			<fmt:formatDate value="${now}" pattern="yyyy" var="nowYear"/>
			<fmt:formatDate value="${now}" pattern="MM"	var="nowMonth"/>
			
			<th class="alignL">업무처리일</th>
			<td>     
				<input type="text" id="startDate2" name="startDate2" value=""	class="input_off datePicker stext" size="8"
					onchange="this.value = makeDateType(this.value);"	maxlength="15" >
				
				-
				<input type="text" id="endDate2" name="endDate2" value=""	class="input_off datePicker stext" size="8"
					onchange="this.value = makeDateType(this.value);"	maxlength="15">
				
	        </td>
	        <th class="alignL"></th>
			<td>  
				<div class="btn-wrap justify-center">
					<div class="btns">
						<button id="excel4" onclick="fnSearchMHDetailExcelGrid()"></button>
					</div>
				</div>
	        </td>
		</tr>
	</table>
	
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>

</div>

<script>

var layout = new dhx.Layout("layout", {
	    rows: [{id: "a",},]
	});
	
	var layout2 = new dhx.Layout("layout2", {
	    rows: [{id: "b",},]
	});
	
	var layout3 = new dhx.Layout("layout3", {
	    rows: [{id: "c",},]
	});
	
	
	var layout4 = new dhx.Layout("layout4", {
	    rows: [{id: "d",},]
	});
	
	var gridConfig1 = new dhx.Grid("grdOTGridArea", {
	    columns: [
	    	{ width: 40, id: "RowNum", header: [{ text: "번호", align: "center" , rowspan:3}], align: "center", footer: [{ text: "총계", colspan:6, align:"center" }], align: "center" },
	        { width: 120, id: "ClientName", header: [{ text: "관계사명", align: "center", rowspan:3  }], align: "center"},
	        { width: 120, id: "TeamName", header: [{ text: "부서명", align: "center" , rowspan:3 }], align: "center" },
	        { width: 130, id: "BIZName", header: [{ text: "업체명", align: "center", rowspan:3  }], align: "center"},
	        { width: 80, id: "EmployeeNum", header: [{ text: "사번", align: "center", rowspan:3  }], align: "center"},
	        { width: 80, id: "MemberName", header: [{ text: "성명", align: "center", rowspan:3  }], align: "center"},
	       
	        
	        { width:80, id: "TicketCount", header: [{ text: "TOTAL", align: "center", colspan:3 },{ text: "티켓건수", align: "center", rowspan:2},{ text: "", align: "center" }], align: "center" , format: "#", type: "number" , footer: [{ content: "sum", align:"center" }]},
	        { width:80, id: "MSR_VAL", header: [{ text: "", align: "center" },{ text: "투입시간(M/H)", align: "center", rowspan:2},{ text: "", align: "center" }], align: "center", format: "#.00", type: "number", footer: [{ content: "sum", align:"center" }] },
	        { width:80, id: "AVG_YN", header: [{ text: "", align: "center" },{ text: "평균이하여부", align: "center", rowspan:2},{ text: "", align: "center" }], align: "center"},
	        
	        //서비스요청
	        { width: 80, id: "REQTicketCount1", header: [{ text: "서비스요청", align: "center", colspan:6 },{ text: "단순문의", align: "center",colspan:2 },{ text: "티켓건수", align: "center" }], align: "center", format: "#", type: "number" , footer: [{ content: "sum", align:"center" }] },
	        { width: 80, id: "REQTime1", header: [{ text: "", align: "center" },{ text: "", align: "center",},{ text: "시간(M/H)", align: "center" }], align: "center", format: "#.00", type: "number", footer: [{ content: "sum", align:"center" }] },
	        { width: 80, id: "REQTicketCount2", header: [{ text: "", align: "center" },{ text: "서비스요청", align: "center" ,colspan:2},{ text: "티켓건수", align: "center" }], align: "center" , format: "#", type: "number", footer: [{ content: "sum", align:"center" }] },
	        { width: 80, id: "REQTime2", header: [{ text: "", align: "center" },{ text: "", align: "center" },{ text: "시간(M/H)", align: "center" }], align: "center", format: "#.00", type: "number", footer: [{ content: "sum", align:"center" }] },
	        { width: 80, id: "REQTicketCount3", header: [{ text: "", align: "center" },{ text: "오류", align: "center",colspan:2 },{ text: "티켓건수", align: "center" }], align: "center", format: "#", type: "number" , footer: [{ content: "sum", align:"center" }] },
	        { width: 80, id: "REQTime3", header: [{ text: "", align: "center" },{ text: "", align: "center" },{ text: "시간(M/H)", align: "center" }], align: "center" , format: "#.00", type: "number", footer: [{ content: "sum", align:"center" }] },
	        
	        //변경관리
	        { width: 100, id: "ACMTicketCount", header: [{ text: "변경관리", align: "center", colspan:8},{ text: "AP변경(M/H)", align: "center",colspan:2 },{ text: "티켓건수", align: "center" }], align: "center", format: "#", type: "number", footer: [{ content: "sum", align:"center" }] },
	        { width: 100, id: "ACMTime", header: [{ text: "", align: "center" },{ text: "", align: "center" },{ text: "시간(M/H)", align: "center" }], align: "center" , format: "#.00", type: "number", footer: [{ content: "sum", align:"center" }] },
	        { width: 100, id: "DCMTicketCount", header: [{ text: "", align: "center" },{ text: "데이터변경(M/H)", align: "center",colspan:2  },{ text: "티켓건수", align: "center" }], align: "center" , format: "#", type: "number", footer: [{ content: "sum", align:"center" }] },
	        { width: 100, id: "DCMTime", header: [{ text: "", align: "center" },{ text: "", align: "center" },{ text: "시간(M/H)", align: "center" }], align: "center", format: "#.00", type: "number" , footer: [{ content: "sum", align:"center" }] },
	        { width: 100, id: "SCMTicketCount", header: [{ text: "", align: "center" },{ text: "보안변경(M/H)", align: "center" ,colspan:2 },{ text: "티켓건수", align: "center" }], align: "center", format: "#", type: "number", footer: [{ content: "sum", align:"center" }] },
	        { width: 100, id: "SCMTime", header: [{ text: "", align: "center" },{ text: "", align: "center" },{ text: "시간(M/H)", align: "center" }], align: "center", format: "#.00", type: "number", footer: [{ content: "sum", align:"center" }] },
	        { width: 100, id: "ICMTicketCount", header: [{ text: "", align: "center" },{ text: "인프라변경(M/H)", align: "center",colspan:2  },{ text: "티켓건수", align: "center" }], align: "center", format: "#", type: "number" , footer: [{ content: "sum", align:"center" }] },
	        { width: 100, id: "ICMTime", header: [{ text: "", align: "center" },{ text: "", align: "center" },{ text: "시간(M/H)", align: "center" }], align: "center", format: "#.00", type: "number" , footer: [{ content: "sum", align:"center" }] },
	        
	        //장애 
	        { width: 120, id: "INCTicketCount", header: [{ text: "장애", align: "center", rowspan:2, colspan:2 },{ text: "", align: "center" },{ text: "티켓건수", align: "center" }], align: "center", format: "#", type: "number" , footer: [{ content: "sum", align:"center" }] },
	        { width: 120, id: "INCTime", header: [{ text: "", align: "center" },{ text: "", align: "center" },{ text: "시간(M/H)", align: "center" }], align: "center", format: "#.00", type: "number", footer: [{ content: "sum", align:"center" }] },
	        
	      	//내부요청/작업 
	        { width: 120, id: "WRKTicketCount", header: [{ text: "내부요청/작업", align: "center", rowspan:2, colspan:2},{ text: "", align: "center" },{ text: "티켓건수", align: "center" }], align: "center", format: "#", type: "number" , footer: [{ content: "sum", align:"center" }] },
	        { width: 120, id: "WRKTime", header: [{ text: "", align: "center" },{ text: "", align: "center" },{ text: "시간(M/H)", align: "center" }], align: "center", format: "#.00", type: "number", footer: [{ content: "sum", align:"center" }] },	
			
	    	//배포  
	        { width: 120, id: "DPLTicketCount", header: [{ text: "배포", align: "center", rowspan:2, colspan:2},{ text: "", align: "center" },{ text: "티켓건수", align: "center" }], align: "center", format: "#", type: "number" , footer: [{ content: "sum", align:"center" }] },
	        { width: 120, id: "DPLTime", header: [{ text: " ", align: "center" },{ text: "", align: "center" },{ text: "시간(M/H)", align: "center" }], align: "center", format: "#.00", type: "number", footer: [{ content: "sum", align:"center" }] },	
	     
	        { width: 80, id: "MemberID", hidden:"true",header: [{ text: "MemberID", align: "center" }]}
	    ],
	    
	    autoWidth: true,
	    autoHeight: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: false
	  
	});
	
	gridConfig2 = new dhx.Grid("grdOTGridArea", {
	    columns: [
	    	{ width: 40, id: "RowNum", header: [{ text: "번호", align: "center" , rowspan:3}], align: "center", footer: [{ text: "총계", colspan:5, align:"center" }], align: "center" },
	        { width: 180, id: "SRAreaName", header: [{ text: "서비스명", align: "center", rowspan:3  }], align: "center"},
	        { width: 120, id: "BIZName", header: [{ text: "업체명", align: "center" , rowspan:3 }], align: "center" },
	        { width: 80, id: "EmployeeNum", header: [{ text: "사번", align: "center", rowspan:3  }], align: "center"},
	        { width: 80, id: "MemberName", header: [{ text: "성명", align: "center", rowspan:3  }], align: "center"},
	       
	        { width:80, id: "DaeCoTicketCount", header: [{ text: "업체별", align: "center", colspan:4 },{ text: "대림코퍼레이션", align: "center", colspan : 2},{ text: "티켓건수", align: "center" }], align: "center" , format: "#", type: "number" , footer: [{ content: "sum", align:"center" }]},
	        { width:80, id: "DaeCoTime", header: [{ text: "", align: "center" },{ text: "", align: "center"},{ text: "시간(M/H)", align: "center" }], align: "center" , format: "#.00", type: "number" , footer: [{ content: "sum", align:"center" }]},
	        { width:80, id: "NoDaeCoTicketCount", header: [{ text: "", align: "center"},{ text: "협력사", align: "center", colspan : 2},{ text: "티켓건수", align: "center" }], align: "center" , format: "#", type: "number" , footer: [{ content: "sum", align:"center" }]},
	        { width:80, id: "NoDaeCoTime", header: [{ text: "", align: "center" },{ text: "", align: "center"},{ text: "시간(M/H)", align: "center" }], align: "center" , format: "#.00", type: "number" , footer: [{ content: "sum", align:"center" }]},
	        
	        { width:80, id: "TicketCount", header: [{ text: "TOTAL", align: "center", colspan:2, rowspan:2 },{ text: "", align: "center"},{ text: "티켓건수", align: "center" }], align: "center" , format: "#", type: "number" , footer: [{ content: "sum", align:"center" }]},
	        { width:80, id: "MSR_VAL", header: [{ text: "", align: "center"},{ text: "", align: "center"},{ text: "시간(M/H)", align: "center" }], align: "center", format: "#.00", type: "number", footer: [{ content: "sum", align:"center" }] },
      
	        //서비스요청
	        { width: 80, id: "REQTicketCount1", header: [{ text: "서비스요청", align: "center", colspan:6 },{ text: "단순문의", align: "center",colspan:2 },{ text: "티켓건수", align: "center" }], align: "center", format: "#", type: "number" , footer: [{ content: "sum", align:"center" }] },
	        { width: 80, id: "REQTime1", header: [{ text: "", align: "center" },{ text: "", align: "center",},{ text: "시간(M/H)", align: "center" }], align: "center", format: "#.00", type: "number", footer: [{ content: "sum", align:"center" }] },
	        { width: 80, id: "REQTicketCount2", header: [{ text: "", align: "center" },{ text: "서비스요청", align: "center" ,colspan:2},{ text: "티켓건수", align: "center" }], align: "center" , format: "#", type: "number", footer: [{ content: "sum", align:"center" }] },
	        { width: 80, id: "REQTime2", header: [{ text: "", align: "center" },{ text: "", align: "center" },{ text: "시간(M/H)", align: "center" }], align: "center", format: "#.00", type: "number", footer: [{ content: "sum", align:"center" }] },
	        { width: 80, id: "REQTicketCount3", header: [{ text: "", align: "center" },{ text: "오류", align: "center",colspan:2 },{ text: "티켓건수", align: "center" }], align: "center", format: "#", type: "number" , footer: [{ content: "sum", align:"center" }] },
	        { width: 80, id: "REQTime3", header: [{ text: "", align: "center" },{ text: "", align: "center" },{ text: "시간(M/H)", align: "center" }], align: "center" , format: "#.00", type: "number", footer: [{ content: "sum", align:"center" }] },
	        
	        //변경관리
	        { width: 100, id: "ACMTicketCount", header: [{ text: "변경관리", align: "center", colspan:8},{ text: "AP변경(M/H)", align: "center",colspan:2 },{ text: "티켓건수", align: "center" }], align: "center", format: "#", type: "number", footer: [{ content: "sum", align:"center" }] },
	        { width: 100, id: "ACMTime", header: [{ text: "", align: "center" },{ text: "", align: "center" },{ text: "시간(M/H)", align: "center" }], align: "center" , format: "#.00", type: "number", footer: [{ content: "sum", align:"center" }] },
	        { width: 100, id: "DCMTicketCount", header: [{ text: "", align: "center" },{ text: "데이터변경(M/H)", align: "center",colspan:2  },{ text: "티켓건수", align: "center" }], align: "center" , format: "#", type: "number", footer: [{ content: "sum", align:"center" }] },
	        { width: 100, id: "DCMTime", header: [{ text: "", align: "center" },{ text: "", align: "center" },{ text: "시간(M/H)", align: "center" }], align: "center", format: "#.00", type: "number" , footer: [{ content: "sum", align:"center" }] },
	        { width: 100, id: "SCMTicketCount", header: [{ text: "", align: "center" },{ text: "보안변경(M/H)", align: "center" ,colspan:2 },{ text: "티켓건수", align: "center" }], align: "center", format: "#", type: "number", footer: [{ content: "sum", align:"center" }] },
	        { width: 100, id: "SCMTime", header: [{ text: "", align: "center" },{ text: "", align: "center" },{ text: "시간(M/H)", align: "center" }], align: "center", format: "#.00", type: "number", footer: [{ content: "sum", align:"center" }] },
	        { width: 100, id: "ICMTicketCount", header: [{ text: "", align: "center" },{ text: "인프라변경(M/H)", align: "center",colspan:2  },{ text: "티켓건수", align: "center" }], align: "center", format: "#", type: "number" , footer: [{ content: "sum", align:"center" }] },
	        { width: 100, id: "ICMTime", header: [{ text: "", align: "center" },{ text: "", align: "center" },{ text: "시간(M/H)", align: "center" }], align: "center", format: "#.00", type: "number" , footer: [{ content: "sum", align:"center" }] },
	        
	        //장애 
	        { width: 120, id: "INCTicketCount", header: [{ text: "장애", align: "center", rowspan:2, colspan:2 },{ text: "", align: "center" },{ text: "티켓건수", align: "center" }], align: "center", format: "#", type: "number" , footer: [{ content: "sum", align:"center" }] },
	        { width: 120, id: "INCTime", header: [{ text: "", align: "center" },{ text: "", align: "center" },{ text: "시간(M/H)", align: "center" }], align: "center", format: "#.00", type: "number", footer: [{ content: "sum", align:"center" }] },
	        
	      	//내부요청/작업 
	        { width: 120, id: "WRKTicketCount", header: [{ text: "내부요청/작업", align: "center", rowspan:2, colspan:2},{ text: "", align: "center" },{ text: "티켓건수", align: "center" }], align: "center", format: "#", type: "number" , footer: [{ content: "sum", align:"center" }] },
	        { width: 120, id: "WRKTime", header: [{ text: "", align: "center" },{ text: "", align: "center" },{ text: "시간(M/H)", align: "center" }], align: "center", format: "#.00", type: "number", footer: [{ content: "sum", align:"center" }] },	
			
	    	//배포  
	        { width: 120, id: "DPLTicketCount", header: [{ text: "배포", align: "center", rowspan:2, colspan:2},{ text: "", align: "center" },{ text: "티켓건수", align: "center" }], align: "center", format: "#", type: "number" , footer: [{ content: "sum", align:"center" }] },
	        { width: 120, id: "DPLTime", header: [{ text: " ", align: "center" },{ text: "", align: "center" },{ text: "시간(M/H)", align: "center" }], align: "center", format: "#.00", type: "number", footer: [{ content: "sum", align:"center" }] },	
	    ],
	    
	    autoWidth: true,
	    autoHeight: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: false
	});
		
	var gridConfig3 = new dhx.Grid("grdOTGridArea", {
	    columns: [
	    	{ width: 80, id: "RowNum", header: [{ text: "번호", align: "center"}], align: "center", footer: [{ text: "총계", colspan:3, align:"center" }], align: "center" },
	        { width: 180, id: "CODE_NM", header: [{ text: "관계사", align: "center"}], align: "center"},
	        { width: 120, id: "EmployeeNum", header: [{ text: "사번", align: "center"}], align: "center"},
	        { width: 120, id: "STEP_MNG_NM", header: [{ text: "성명", align: "center"}], align: "center"},
	        { width:200, id: "TOT_CNT", header: [{ text: "전체티켓(단계별)", align: "center" }], align: "center" , format: "#", type: "number" , footer: [{ content: "sum", align:"center" }]},
	        { width:200, id: "DELAY_CNT", header: [{ text: "지연티켓(단계별)", align: "center" }], align: "center" , format: "#", type: "number" , footer: [{ content: "sum", align:"center" }]},
	        { width:200, id: "DELAY_RATE", header: [{ text: "지연율(%)", align: "center" }], align: "center" , format: "#", type: "number" , footer: [{ content: "avg", align:"center" }]},
	    ],
	    
	    autoWidth: true,
	    autoHeight: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: false
	  
	});

	function fnSearch(){ 
		var selectType = $("#selectType").val();
		
		document.getElementById('layout').style.display = "none";
		document.getElementById('layout2').style.display = "none";
		document.getElementById('layout3').style.display = "none";		
		document.getElementById('layout4').style.display = "none";		
		
		var sqlID = "zDLM_SQL.getStatMhTypeList";
		
		if(selectType == "user"){
			document.getElementById('layout').style.display = "block";
			layout.getCell("a").attach(gridConfig1);
		}else if(selectType == "system"){
			document.getElementById('layout2').style.display = "block";
			layout2.getCell("b").attach(gridConfig2);
			sqlID = "zDLM_SQL.getStatMhUserSystemList";
		}else{
			document.getElementById('layout3').style.display = "block";
			layout3.getCell("c").attach(gridConfig3);
			sqlID = "zDLM_SQL.getStatMhUserDelayList";
		}
		
		var customerNo = $("#customerNo").val();
		var startDate= $("#startDate").val(); 
		var endDate= $("#endDate").val(); 
		
		if (!startDate || !endDate) {
		    alert("조회기간을 모두 입력해주세요.");
		    return false;
		}
		if (!checkDateYear(startDate, endDate,365,"12개월")){
			return false;
		}
		
		var teamID= $("#teamID").val(); 
		var receiptUserName = $("#ReceiptUserName").val();
		var receiptUserID = (receiptUserName === undefined || receiptUserName === '' || receiptUserName === null) ? '' : $("#receiptUserID").val();
		
		var param = "sqlID="+sqlID+"&startDate="+startDate+"&endDate="+endDate+"&customerNo="+customerNo+"&receiptUserID="+receiptUserID
					+ "&teamID="+teamID					
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&myCSR=Y&userID=${sessionScope.loginInfo.sessionUserId}";
					
		
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
 					fnReloadGrid(result);				
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
				fnReloadGrid(result);
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
		var selectType = $("#selectType").val();
		if(selectType == "user"){
			gridConfig1.data.parse(newGridData);
			$("#TOT_CNT").html(gridConfig1.data.getLength());
		}else if(selectType == "system"){
			gridConfig2.data.parse(newGridData);
			$("#TOT_CNT").html(gridConfig2.data.getLength());
		}else{
			gridConfig3.data.parse(newGridData);
			$("#TOT_CNT").html(gridConfig3.data.getLength());
		}
		//inProgress = false;
		//$('#loading').fadeOut(150);
	}
	
	gridConfig1.events.on("cellClick", function(row,column,e){
		
		var customerNo = $("#customerNo").val();
		var startDate = $("#startDate").val();
		var endDate = $("#endDate").val();
		var memberID = row.MemberID;
		var memberName = row.MemberName;
		
		var url = "zdlm_viewIndividualMHWorkList.do";
		var data = "customerNo="+customerNo+"&startDate="+startDate+"&endDate="+endDate+"&memberID="+memberID+"&memberName="+memberName; 
		var w = 1100;
		var h = 600;
		window.open(url+"?"+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
			
	}); 
	
	gridConfig2.events.on("cellClick", function(row,column,e){
		
		var customerNo = $("#customerNo").val();
		var startDate = $("#startDate").val();
		var endDate = $("#endDate").val();
		var memberID = row.MemberID;
		var memberName = row.MemberName;
		var srArea2 = row.SRArea2;
		
		var url = "zdlm_viewIndividualMHWorkList.do";
		var data = "customerNo="+customerNo+"&startDate="+startDate+"&endDate="+endDate+"&memberID="+memberID
					+"&memberName="+memberName+"&srArea2="+srArea2; 
		
		var w = 1100;
		var h = 600;
		window.open(url+"?"+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
			
	}); 
	
	var gridConfig4 = new dhx.Grid("grdOTGridArea", {
	    columns: [	       
	    ],
	    
	    autoWidth: true,
	    autoHeight: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: false
	  
	});
	
	//상단 엑셀 버튼 개인별MH [상세조회]통계현황 엑셀 다운로드 상세
	function fnMHDetailExcelGrid(){
		layout4.getCell("d").attach(gridConfig4);
		
		gridConfig4 = new dhx.Grid("grdOTGridArea", {
		    columns: [
		    	
		        { hidden:false, width: 180, id: "CD_COMPANY",       header: [{ text: "관계사명", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "CD_COMPANY_NM",    header: [{ text: "그룹", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "NAME_LV1", header: [{ text: "서비스/파트", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "USER_NM", header: [{ text: "성명", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "TBL_NM", header: [{ text: "구분", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "CAT_NAME", header: [{ text: "의뢰유형", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "ID", header: [{ text: "티켓ID", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "STATUS_NAME", header: [{ text: "단계", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "WORK_DATE", header: [{ text: "작업일자", align: "center"}], align: "center"},
		        
		        { hidden:false, width: 180, id: "MSR_VAL", header: [{ text: "MH", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "TITLE", header: [{ text: "제목", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "NOTICE", header: [{ text: "내용", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "SOLVNT", header: [{ text: "처리내용", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "REQ_USR_NAME", header: [{ text: "요청자명", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "REQ_USR_DEPT_NAME", header: [{ text: "요청자부서", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "STEP_MNG_ID", header: [{ text: "작업자ID", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "STEP_MNG_NM", header: [{ text: "작업자명", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "REG_DATE", header: [{ text: "요청일", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "COMP_CHANGE_DUE_DATE", header: [{ text: "단계완료예정일", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "CLOSE_DATE", header: [{ text: "단계완료일", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "COMP_CHANGE_DUE_DATE_TICKET", header: [{ text: "티켓완료예정일", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "CLOSE_DATE_TICKET", header: [{ text: "티켓완료일", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "DELAY_YN", header: [{ text: "지연일", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "BUSINESS_HOUR", header: [{ text: "근무시간내", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "OVERTIME", header: [{ text: "근무시간외", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "HOLYDAY", header: [{ text: "공휴일여부", align: "center"}], align: "center"},
		       
		    ],
		    
		    autoWidth: true,
		    autoHeight: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    sortable: false
		  
		});
		
		
		var sqlID = "zDLM_SQL.selectStatMhExcelList";
		var customerNo = $("#customerNo").val();
		var startDate= $("#startDate").val(); 
		var endDate= $("#endDate").val(); 
		var teamID= $("#teamID").val(); 
		
		var param = "sqlID="+sqlID+"&startDate="+startDate+"&endDate="+endDate+"&customerNo="+customerNo			
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&myCSR=Y&userID=${sessionScope.loginInfo.sessionUserId}"
					+ "&teamID="+teamID;
		
		$('#loading').fadeIn(150);
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadExcelGrid(result,"IndividualMH_ticket_");
				$('#loading').fadeOut(150);
			},error:function(xhr,status,error){
				//$('#loading').fadeOut(150);
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	}
	
	// [사용자지연율(상세)] EXCEL 다운로드 
	function fnMHUserDelayDtlExcelGrid(){
		layout4.getCell("d").attach(gridConfig4);
		
		gridConfig4 = new dhx.Grid("grdOTGridArea", {
		    columns: [
		    	
		        { hidden:false, width: 180, id: "CD_COMPANY",       header: [{ text: "관계사명", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "CD_COMPANY_NM",    header: [{ text: "그룹", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "NAME_LV1", header: [{ text: "서비스/파트", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "USER_NM", header: [{ text: "성명", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "TBL_NM", header: [{ text: "구분", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "CAT_NAME", header: [{ text: "의뢰유형", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "ID", header: [{ text: "티켓ID", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "STATUS_NAME", header: [{ text: "단계", align: "center"}], align: "center"},
		        
		        { hidden:false, width: 180, id: "MSR_VAL", header: [{ text: "MH", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "TITLE", header: [{ text: "제목", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "NOTICE", header: [{ text: "내용", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "SOLVNT", header: [{ text: "처리내용", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "REQ_USR_NAME", header: [{ text: "요청자명", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "REQ_USR_DEPT_NAME", header: [{ text: "요청자부서", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "STEP_MNG_ID", header: [{ text: "작업자ID", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "STEP_MNG_NM", header: [{ text: "작업자명", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "REG_DATE", header: [{ text: "요청일", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "COMP_CHANGE_DUE_DATE", header: [{ text: "단계완료예정일", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "CLOSE_DATE", header: [{ text: "단계완료일", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "DELAY_YN", header: [{ text: "지연일", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "COMP_CHANGE_DUE_DATE_TICKET", header: [{ text: "티켓완료예정일", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "CLOSE_DATE_TICKET", header: [{ text: "티켓완료일", align: "center"}], align: "center"},
		       
		    ],
		    
		    autoWidth: true,
		    autoHeight: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    sortable: false
		  
		});
		 
		var sqlID = "zDLM_SQL.selectStatMhUserDelayDtlList";
		var customerNo = $("#customerNo").val();
		var startDate= $("#startDate").val(); 
		var endDate= $("#endDate").val(); 
		var teamID= $("#teamID").val(); 
		
		var param = "sqlID="+sqlID+"&startDate="+startDate+"&endDate="+endDate+"&customerNo="+customerNo			
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&myCSR=Y&userID=${sessionScope.loginInfo.sessionUserId}"
					+ "&teamID="+teamID;
		$('#loading').fadeIn(150);			
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadExcelGrid(result,"IndividualMH_UserDelayDtl_");
				$('#loading').fadeOut(150);
			},error:function(xhr,status,error){
				//$('#loading').fadeOut(150);
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	}

	// 하단  관계사 조회기준별 개인별MH 상세조회 엑셀 다운로드
	function fnSearchMHDetailExcelGrid(){
		layout4.getCell("d").attach(gridConfig4);
		
		gridConfig4 = new dhx.Grid("grdOTGridArea", {
		    columns: [
		    	
		        { hidden:false, width: 180, id: "CD_COMPANY",       header: [{ text: "관계사명", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "CD_COMPANY_NM",    header: [{ text: "그룹", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "NAME_LV1", header: [{ text: "서비스/파트", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "USER_NM", header: [{ text: "성명", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "TBL_NM", header: [{ text: "구분", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "CAT_NAME", header: [{ text: "의뢰유형", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "ID", header: [{ text: "티켓ID", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "STATUS_NAME", header: [{ text: "단계", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "WORK_DATE", header: [{ text: "작업일자", align: "center"}], align: "center"},
		        
		        { hidden:false, width: 180, id: "MSR_VAL", header: [{ text: "MH", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "TITLE", header: [{ text: "제목", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "NOTICE", header: [{ text: "내용", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "SOLVNT", header: [{ text: "처리내용", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "REQ_USR_NAME", header: [{ text: "요청자명", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "REQ_USR_DEPT_NAME", header: [{ text: "요청자부서", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "STEP_MNG_ID", header: [{ text: "작업자ID", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "STEP_MNG_NM", header: [{ text: "작업자명", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "REG_DATE", header: [{ text: "요청일", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "COMP_CHANGE_DUE_DATE", header: [{ text: "단계완료예정일", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "CLOSE_DATE", header: [{ text: "단계완료일", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "COMP_CHANGE_DUE_DATE_TICKET", header: [{ text: "티켓완료예정일", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "CLOSE_DATE_TICKET", header: [{ text: "티켓완료일", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "DELAY_YN", header: [{ text: "지연일", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "BUSINESS_HOUR", header: [{ text: "근무시간내", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "OVERTIME", header: [{ text: "근무시간외", align: "center"}], align: "center"},
		        { hidden:false, width: 180, id: "HOLYDAY", header: [{ text: "공휴일여부", align: "center"}], align: "center"},
		       
		    ],
		    
		    autoWidth: true,
		    autoHeight: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    sortable: false
		  
		});
		
		var sqlID = "zDLM_SQL.selectReqStatMhExcelList";
		var customerNo = $("#customerNo2").val();
		var startDate2= $("#startDate2").val(); 
		var endDate2= $("#endDate2").val(); 
		var userType= $("#userType").val(); 
		
		var param = "sqlID="+sqlID+"&startDate="+startDate2+"&endDate="+endDate2+"&customerNo="+customerNo			
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&myCSR=Y&userID=${sessionScope.loginInfo.sessionUserId}"
					+ "&userType="+userType;
		$('#loading').fadeIn(150);
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadExcelGrid(result,"IndividualMH_ticket_");		
				$('#loading').fadeOut(150);
			},error:function(xhr,status,error){
				//$('#loading').fadeOut(150);
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	}
	
	function fnReloadExcelGrid(newGridData, excelFileName){
		
		
		 
		gridConfig4.data.parse(newGridData);
		//$('#loading').fadeOut(150);
		const now = new Date();
		const formattedDateTime = now.getFullYear() 
		                        + String(now.getMonth() + 1).padStart(2, '0') 
		                        + String(now.getDate()).padStart(2, '0') 
		                        + String(now.getHours()).padStart(2, '0') 
		                        + String(now.getMinutes()).padStart(2, '0');
		const fileName = excelFileName + formattedDateTime;
		fnGridExcelDownLoad(gridConfig4, "Y", fileName);
	}
	
	</script>
