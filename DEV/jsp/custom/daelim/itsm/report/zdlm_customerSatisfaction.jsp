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
		
		fnSetButton("search-btn", "search", "Search");
		fnSetButton("excel", "", "Excel", "secondary");
		fnSetButton("excel2", "", "Excel(고객의견)", "secondary");
		
		// 관계사
		var selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&esType=${esType}&myCSR=Y&notCompanyIDs=${notCompanyIDs}";
		fnSelect('customerNo', selectData, 'getESPCustomerList', '${sessionScope.loginInfo.sessionClientId}', 'ALL', 'esm_SQL');
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
	function doExcel(type) {	
		const now = new Date();
		const formattedDateTime = now.getFullYear() 
		                        + String(now.getMonth() + 1).padStart(2, '0') 
		                        + String(now.getDate()).padStart(2, '0') 
		                        + String(now.getHours()).padStart(2, '0') 
		                        + String(now.getMinutes()).padStart(2, '0');
		
		if(type == "score"){
			const fileName = "SATISFACTION_SCORE_" + formattedDateTime;
			
			grid.showColumn("RequestUserID");
			grid.showColumn("RequestUserEmail");
						
			fnGridExcelDownLoad(grid, "", fileName);
			grid.hideColumn("RequestUserID");
			grid.hideColumn("RequestUserEmail");
		} else {
			grid2.showColumn("RequestUserEmail");
			const fileName = "SATISFACTION_OPINION_" + formattedDateTime;
			fnGridExcelDownLoad(grid2, "", fileName);
			grid2.hideColumn("RequestUserEmail");
		}
	}
	
	function doDetail(data){
		const isPopup = true;
		var srCode = data.SRCode;
		var srID = data.SRID;
		var status = data.Status;
		var srType = data.SRType;
		var esType = data.ESType;
		var receiptUserID = data.ReceiptUserID;
		if(receiptUserID == undefined) receiptUserID = "";
		
		var url = "esrInfoMgt.do";
		var data = "&srCode="+srCode + "&srID="+srID + "&status=" +status + "&srType=" +srType + "&receiptUserID=" + receiptUserID + "&esType=" + esType + "&isPopup="+isPopup;
		window.open(url+"?"+data,srID,"width=1400 height=800 resizable=yes");
		
	}
	
</script>

<style>
	.difi {
		border:1px solid #ddd;
		background : #fff;
		padding: 20px 30px;
		margin-bottom:20px;
	}
	
	.difi li {
		display: block;
		margin: 15px 0;
	}
	
	.difi li span {
		display:inline-block;
		width:150px;
	}
	
	.new-form input[type=checkbox]+label {
	    -webkit-box-sizing: border-box;
	    box-sizing: border-box;
	    color: #222;
	    display: inline-block;
	    line-height: 20px;
	    min-height: 20px;
	    padding-left: 22px;
	    position: relative;
	    vertical-align: top;
	    margin-right: 16px;
	    padding-right: 0
	}
	.new-form input[type=checkbox]+label:before {
		    content: "";
		    display: inline-block;
		    width: 16px;
		    height: 16px;
		    left: 0;
		    position: absolute;
		    top: 2px;
		    border: 1px solid #ddd;
		    box-sizing: border-box;
	}
	
	
</style>

<div style="display:none;" id="excelGrid"></div>

<div id="srListDiv" class="pdL10 pdR10">
	<div class="page-title">고객만족도 조사</div>
	
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
		</tr>
		<tr style="grid-template-columns:none;">
			<th class="alignL">점수</th>
	       	<td class="alignL">
	       		<input type="checkbox" name="score" value="5" id="score5" />
	       		<label for="score5">매우만족</label>
	       		<input type="checkbox" name="score" value="4" id="score4" />
	       		<label for="score4">만족</label>
	       		<input type="checkbox" name="score" value="3" id="score3" />
	       		<label for="score3">보통</label>
	       		<input type="checkbox" name="score" value="2" id="score2" checked />
	       		<label for="score2">불만족</label>
	       		<input type="checkbox" name="score" value="1" id="score1" checked />
	       		<label for="score1">매우불만족</label>
	       		<input type="checkbox" name="score" value="0" id="score0" />
	       		<label for="score0">답변없음</label>
	       	</td>
		</tr>
	</table>
	
	<div class="btn-wrap justify-center pdT10">
		<div class="btns">
			<button id="search-btn" onclick="fnSearch();"></button>
			<button id="excel" onclick="doExcel('score')"></button>
			<button id="excel2" onclick="doExcel('opinion')"></button>
		</div>
	</div>
	
	<ul class="btn-wrap pdT20 pdB10" >
		<li class="count">Total  <span id="TOT_CNT"></span></li>
	</ul>
			
	<div style="width:100%; height:400px;" id="layout"></div>
	<div class="align-center flex">
		<select id="pageRow" onchange="changePageSize(this.value)">
			<option value=10>10</option>
			<option value=20>20</option>
			<option value=30 selected>30</option>
			<option value=40>40</option>
			<option value=50>50</option>
			<option value=100>100</option>
		</select>
		<div id="pagination" style="position: relative;margin: 0 auto;"></div>
	</div>

	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
	
	
	<div class="page-title mgT30">고객만족도 조사(고객의견)</div>
	<ul class="btn-wrap pdT20 pdB10" >
		<li class="count">Total  <span id="TOT_CNT2"></span></li>
	</ul>
	<div style="width:100%; height:400px;" id="layout2"></div>
	<div class="align-center flex">
		<select id="pageRow2" onchange="changePageSize2(this.value)">
			<option value=10>10</option>
			<option value=20>20</option>
			<option value=30 selected>30</option>
			<option value=40>40</option>
			<option value=50>50</option>
			<option value=100>100</option>
		</select>
		<div id="pagination2" style="position: relative;margin: 0 auto;"></div>
	</div>
	
	<div class="page-title mgT30">용어정의</div>
	<div>
		<ul class="difi">
		 	<li>
		 		<span>* 점수</span>
		 		<b>:</b> 만족도 조사에서 체크된 항목의 점수를 받은 항목만 조회합니다.
		 	</li>
		</ul>
	</div>

</div>
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
	            id: "a",
	        },
	    ]
	});
	
	var grid = new dhx.Grid("grdOTGridArea", {
	    columns: [
	        { hidden:false, width: 180, id: "GUBUN", header: [{ text: "구분", align: "center" }], align: "center"  },
	        { hidden:false, width: 150, id: "SRCode", header: [{ text: "티켓번호", align: "center" }], align: "center" ,  },
	        { hidden:false, width: 200, id: "srAreaNM", header: [{ text: "서비스/파트", align: "center" }], align: "center" ,  },
	        { hidden:true, width: 100, id: "RequestUserID", header: [{ text: "요청자ID", align: "center" }], align: "center", },
	        { hidden:false, width:100, id: "RequserUserNM", header: [{ text: "요청자", align: "center" }], align: "center", },
	        { hidden:true, width:150, id: "RequestUserEmail", header: [{ text: "요청자 Email", align: "center" }], align: "center", },
	        { hidden:false, width:400, id: "Subject", header: [{ text: "제목", align: "center" }], align: "center" ,  },
	        { hidden:false, width:100, id: "RCPTDATE", header: [{ text: "접수일", align: "center" }], align: "center", },
	        { hidden:false, width: 100, id: "ReqDueDate", header: [{ text: "완료예정일", align: "center" }], align: "center" ,  },
	        { hidden:false, width: 100, id: "CompletionDT", header: [{ text: "처리완료일", align: "center" }], align: "center" ,  },
	        { hidden:false, width: 60, id: "SCORE1", header: [{ text: "신뢰성", align: "center" }], align: "center" , },
	        { hidden:false, width: 60, id: "SCORE2", header: [{ text: "정확성", align: "center" }], align: "center" , },
	        
	        { hidden:true, width: 60, id: "SRID", header: [{ text: "SRID", align: "center" }], align: "center" , },
	        { hidden:true, width: 60, id: "SRType", header: [{ text: "SRType", align: "center" }], align: "center" , },
	        { hidden:true, width: 60, id: "ESType", header: [{ text: "ESType", align: "center" }], align: "center" , },
	        { hidden:true, width: 60, id: "Status", header: [{ text: "Status", align: "center" }], align: "center" , },
	        { hidden:true, width: 60, id: "receiptUserID", header: [{ text: "receiptUserID", align: "center" }], align: "center" , },
	        ],
	    
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: false
	  
	});
	
	
	var grid2 = new dhx.Grid("grdOTGridArea", {
	    columns: [
	        { hidden:false, width: 150, id: "SRCode", header: [{ text: "티켓번호", align: "center" }], align: "center" ,  },
	        { hidden:false, width: 200, id: "srAreaNM", header: [{ text: "서비스/파트", align: "center" }], align: "center" ,  },
	        { hidden:false, width:100, id: "RequserUserNM", header: [{ text: "요청자", align: "center" }], align: "center", },
	        { hidden:true, width:150, id: "RequestUserEmail", header: [{ text: "요청자 Email", align: "center" }], align: "center", },
	        { hidden:false, width:400, id: "Subject", header: [{ text: "제목", align: "center" }], align: "center" ,  },	        
	        { hidden:false, width:780, id: "saSurveyDesc", header: [{ text: "만족도 의견", align: "center" }], align: "center", },
	        
	        { hidden:true, width: 60, id: "SRID", header: [{ text: "SRID", align: "center" }], align: "center" , },
	        { hidden:true, width: 60, id: "SRType", header: [{ text: "SRType", align: "center" }], align: "center" , },
	        { hidden:true, width: 60, id: "ESType", header: [{ text: "ESType", align: "center" }], align: "center" , },
	        { hidden:true, width: 60, id: "Status", header: [{ text: "Status", align: "center" }], align: "center" , },
	        { hidden:true, width: 60, id: "receiptUserID", header: [{ text: "receiptUserID", align: "center" }], align: "center" , },
	        ],
	    
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: false
	  
	});


	layout.getCell("a").attach(grid);
	layout2.getCell("a").attach(grid2);
	
	// 페이징
	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize : 30
	});

	function changePageSize(e) {
		pagination.setPageSize(parseInt(e));
	}
	
	// 페이징
	var pagination2 = new dhx.Pagination("pagination2", {
	    data: grid2.data,
	    pageSize : 30
	});

	function changePageSize2(e) {
		pagination2.setPageSize(parseInt(e));
	}
	
	function fnSearch(){ 		
		var startDate= $("#startDate").val(); 
		var endDate= $("#endDate").val(); 
		
		if (!startDate || !endDate) {
		    alert("조회기간을 모두 입력해주세요.");
		    return false;
		}
		if (!checkDateYear(startDate, endDate, 365,"12개월" )){
			return false;
		}
		
		var customerNo= $("#customerNo").val();
		var happyTypeList = '';
		
		// happyTypeList
		const checkboxes = document.querySelectorAll('input[name="score"]');
	    checkboxes.forEach((checkbox) => {
	            selectedScores = Array.from(checkboxes)
	                .filter((cb) => cb.checked)
	                .map((cb) => cb.value);
	    });
		
		var sqlID = "zDLM_SQL.getCustomerSatisfaction";
		var param = "sqlID="+sqlID+"&customerNo=" + customerNo + "&startDate="+startDate+"&endDate="+endDate + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&myCSR=Y&userID=${sessionScope.loginInfo.sessionUserId}";
		param += "&happyTypeList=" + selectedScores;
		
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
					fnReloadGrid(result,'score');				
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
				fnReloadGrid(result,'score');				
			})
			.catch(error => {
				alert('조회 시간이 오래 걸려서 요청을 중단하였습니다.\n시스템 담당자에게 연락 부탁 드립니다.');
			})
			.finally(() => {
				inProgress = false;
			    $('#loading').fadeOut(150);  // 로딩 화면 숨기기
			});
			
			
			// 의견
			var sqlID = "zDLM_SQL.getCustomerSatisfactionOpinion";
			var param = "sqlID="+sqlID+"&customerNo=" + customerNo + "&startDate="+startDate+"&endDate="+endDate + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&myCSR=Y&userID=${sessionScope.loginInfo.sessionUserId}";
			
			/*
			$.ajax({
				url:"jsonDhtmlxListV7.do",
				type:"POST",
				data:param,
				success: function(result){
					fnReloadGrid(result,'opinion');				
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
				fnReloadGrid(result,'opinion');		
			})
			.catch(error => {
				alert('조회 시간이 오래 걸려서 요청을 중단하였습니다.\n시스템 담당자에게 연락 부탁 드립니다.');
				$('#loading').fadeOut(150);
			})
			.finally(() => {
				//inProgress = false;
			    //$('#loading').fadeOut(150);  // 로딩 화면 숨기기
			});
		}
	}
	
	function fnReloadGrid(newGridData,type){
		if(type == "score"){
			grid.data.parse(newGridData);
			$("#TOT_CNT").html(grid.data.getLength());
		} else {
			grid2.data.parse(newGridData);
			$("#TOT_CNT2").html(grid2.data.getLength());
		}
		//inProgress = false;
		//$('#loading').fadeOut(150);
	}
	
	grid.events.on("cellClick", function (row,column,e) {
		doDetail(row);
	});
	grid2.events.on("cellClick", function (row,column,e) {
		doDetail(row);
	});
	

</script>

