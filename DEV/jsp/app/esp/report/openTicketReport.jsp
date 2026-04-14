<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<%-- <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%> --%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.js?v=7.1.8"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.css?v=7.1.8">

<script>
	var inProgress = false; // main
	var inProgress2 = false; // detail
	const regionManager = '${regionManager}';
	
	$(document).ready(function(){
		
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:72px;");
		$("#layout2").attr("style","height:"+(setWindowHeight() - 480)+"px;");
		
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout2").attr("style","height:"+(setWindowHeight() - 480)+"px;");
		};
		
		// 버튼 셋팅
		fnSetButton("search-btn", "search", "Search");
		getDicData("BTN", "LN0003").then(data => fnSetButton("clear", "clear", data.LABEL_NM,"secondary"));
		fnSetButton("excel2", "", "Excel", "secondary");
		
		// 관계사 셋팅
		const customerSelect = document.getElementById("customerNo");
		var selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&companyIDs=${companyIDs}";
		if (regionManager === "Y") selectData += "&myWorkspace=Y";
		fnSelect('customerNo', selectData, 'getESPCustomerList', '${sessionScope.loginInfo.sessionClientId}', 'false', 'esm_SQL');
		
		if (regionManager === "N") {
			customerSelect.disabled = true;
			const hidden = document.createElement("input");
		    hidden.type = "hidden";
		    hidden.name = customerSelect.name;   
		    hidden.value = customerSelect.value; 
		    document.getElementById("search").appendChild(hidden);
		}
		
		
	});
	
	// title 셋팅
	getArcName("${arcCode}", ".page-title");
	
	// 화면 크기 조정
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	// 엑셀다운 (상세)
	function doExcelDetail() {
		const now = new Date();
		const formattedDateTime = now.getFullYear() 
		                        + String(now.getMonth() + 1).padStart(2, '0') 
		                        + String(now.getDate()).padStart(2, '0') 
		                        + String(now.getHours()).padStart(2, '0') 
		                        + String(now.getMinutes()).padStart(2, '0');
		
		const fileName2 = "openTicketDetail_" + formattedDateTime;
		fnGridExcelDownLoad(grid2, "", fileName2);
	
	}
	
	// 조회결과 셋팅
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	// 조회 결과
	var grid = new dhx.Grid("grid", {
	    columns: [
	        { id: "Total", header: [{ text: "${menu.ZLN0215}",align: "center" }], type: "number", align: "center" },
	        { id: "Unassigned", header: [{ text: "${menu.ZLN0212 }", align: "center" }], type: "number", align: "center" },
	        { id: "Completed", header: [{ text: "${menu.ZLN0213 }", align: "center" }], type: "number", align: "center" },
	        { id: "Delayed", header: [{ text: "${menu.ZLN0214 }",align: "center" }], type: "number", align: "center" },
	    ],
	    
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: false,
	    footer: false
	  
	});


	layout.getCell("a").attach(grid);
	
	// 통계 검색
	function fnCallSearch(){
		fnSearch();
		var initJson ="[{}]";
		fnReloadGrid2(initJson);
	}
	
	// 통계 검색
	function fnSearch(){ 		
		var customerNo = $("#customerNo").val();
		var teamID = $("#teamID").val();
		var receiptUserID = $("#receiptUserID").val();

		var sqlID = "esmReport_SQL.getOpenTicketList";
		var param = "sqlID="+sqlID
					+"&receiptTeamID="+teamID
					+"&receiptUserID="+receiptUserID
					+"&blocked=0"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&userID=${sessionScope.loginInfo.sessionUserId}";
		
		// 영원무역 custom
		if(customerNo === "0000000064"){
			// TVL : 방글라데시
			param += "&custGRNo='0000000004','0000000005','0000000007'";
			
		} else if (customerNo === "0000000031"){
			// YOH : YOH, YOK
			param += "&custGRNo='0000000020','0000000021'";
		} else {
			param += "&clientID="+customerNo;
		}
		
		if(inProgress) {
			getDicData("ERRTP", "LN0002").then(data => alert(data.LABEL_NM));
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
				document.getElementById("Total").checked = true;
			    fnReloadGrid(result);  // 응답을 처리하는 함수 호출
			    $("#detailBox").show(); // 상세 open
			    fnSearchDetail('Total');
			})
			.catch(error => {
				getDicData("ERRTP", "ZLN0002").then(data => alert(data.LABEL_NM));
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
	
	//------------- 그리드 2 상세 ---------------------------------------------------------------------------------------------------------------------------------
	
	var layout2 = new dhx.Layout("layout2", {
	    rows: [
	        {
	            id: "b",
	        },
	    ]
	});
	
	var grid2 = new dhx.Grid("grid2", {
	    columns: [
	    	{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center", template: function (text, row, col) { return row.RNUM;}},
	        { width: 120, id: "SRCode", header: [{ text: "${menu.LN00396}" , align: "center" }], align: "center" },
	        { width: 120, id: "CompanyName", header: [{ text: "${menu.ZLN0225}" , align: "center" }], align: "center" },
	        { width: 120, id: "SRArea2Name", header: [{ text: "${menu.ZLN0188}" , align: "center" }], align: "center" },
	        { width: 120, id: "SRArea1Name", header: [{ text: "${menu.ZLN0079}" , align: "center" }], align: "center" },
	        { width: 120,  id: "CategoryNM", header: [{ text: " ${menu.LN00272}" , align: "center" }], align: "center" },
	        { width: 120,  id: "SubCategoryNM", header: [{ text: " ${menu.LN00273}" , align: "center" }], align: "center" },
	        { id: "Subject", header: [{ text: "${menu.LN00002}" , align: "center" }], align: "left" },
	        { width: 90, id: "RegDate", header: [{ text: "${menu.LN00093}" , align: "center" }], align: "center", template: function(value) { return value && typeof value === 'string' && value.includes(' ') ? value.split(' ')[0] : null; }  },
	        { width: 180, id: "ReqUserNM", header: [{ text: "${menu.LN00025}" , align: "center" }], align: "center" },
	        { width: 120, id: "RCPT_DATE", header: [{ text: "${menu.LN00077}" , align: "center" }], align: "center", template: function(value) { return value && typeof value === 'string' && value.includes(' ') ? value.split(' ')[0] : null; }  }, 
	        { width: 120, id: "ReceiptName", header: [{ text: "${menu.LN00004}" , align: "center" }], align: "center" }, 
	        { width: 90, id: "DueDate", header: [{ text: "${menu.LN00221}" , align: "center" }], align: "center", template: function(value) { return value && typeof value === 'string' && value.includes(' ') ? value.split(' ')[0] : null; }  },
	        { hidden:true, width: 120, id: "SRType", header: [{ text: "srType" , align: "center" }], align: "center" },
	        { hidden:true, width: 120, id: "ESType", header: [{ text: "esType" , align: "center" }], align: "center" },
	        { hidden:true, width: 120, id: "SRID", header: [{ text: "srID" , align: "center" }], align: "center" },
	        { hidden:true, width: 120, id: "Status", header: [{ text: "status" , align: "center" }], align: "center" },
	        { hidden:true, width: 120, id: "ReceiptUserID", header: [{ text: "receiptUserID" , align: "center" }], align: "center" },
	    ],
	    
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: true,
	    footer: false
	});


	layout2.getCell("b").attach(grid2);
	
	function fnSearchDetail(status){
		
		var customerNo = $("#customerNo").val();
		var teamID = $("#teamID").val();
		var receiptUserID = $("#receiptUserID").val();
		
		var sqlID = "esmReport_SQL.getOpenTicketDetailList";
		var param = "sqlID="+sqlID
					+"&receiptTeamID="+teamID
					+"&receiptUserID="+receiptUserID
					+"&status="+status
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&userID=${sessionScope.loginInfo.sessionUserId}";
		
		// 영원무역 custom
		if(customerNo === "0000000064"){
			// TVL : 방글라데시
			param += "&custGRNo='0000000004','0000000005','0000000007'";
			
		} else if (customerNo === "0000000031"){
			// YOH : YOH, YOK
			param += "&custGRNo='0000000020','0000000021'";
		} else {
			param += "&srClientID="+customerNo;
		}			
					
		if(inProgress2) {
			getDicData("ERRTP", "LN0002").then(data => alert(data.LABEL_NM));
		} else {
			inProgress2 = true;
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
				getDicData("ERRTP", "ZLN0002").then(data => alert(data.LABEL_NM));
			})
			.finally(() => {
				inProgress2 = false;
			    $('#loading').fadeOut(150);  // 로딩 화면 숨기기
			});
		}
	}
	
	function fnReloadGrid2(newGridData){
		grid2.data.parse(newGridData);
	}
	
	document.querySelectorAll('input[name="Status"]').forEach(function(radio) {
    	radio.addEventListener('click', function() {
        	fnSearchDetail(this.value);
    	})
    });
	
	
	// 팝업 화면 위치
	function setPopupPosition(popupWidth,popupHeight){
		var screenLeft = window.screenLeft !== undefined ? window.screenLeft : screen.left;
		var screenTop = window.screenTop !== undefined ? window.screenTop : screen.top;

		var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth;
		var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight;

		var left = screenLeft + (width - popupWidth) / 2;
		var top = screenTop + (height - popupHeight) / 2;
		
		return [left,top];
	}
	
	
	// 부서 검색
	function searchPopup(url){
		const customerSelect = document.getElementById("customerNo").value;
		var searchValue = $("#teamName").val();
		
		var [left, top] = setPopupPosition(800, 630);
		url += "?viewOption=ALL&languageID=${sessionScope.loginInfo.sessionCurrLangType}&clientID=" + customerSelect + '&searchValue=' + searchValue;
		window.open(url ,'',`width=800, height=630, left=` + left + `, top=` + top + `, scrollbars=yes, resizable=0`);
	}
	function setSearchTeam(teamID,teamName){$('#teamID').val(teamID);$('#teamName').val(teamName);}
	
	document.getElementById('teamName').addEventListener('keydown', function(event) {
       if (event.key === 'Enter') {
           event.preventDefault(); // 기본 Enter 동작 방지 (필요시)
           searchPopup('searchTeamPop.do');
       }
	});
	
	document.getElementById("searchTeamBtn").addEventListener("click", function() {
		searchPopup('searchTeamPop.do');
	})
	
	
	// 담당자 검색
	function searchPopupWf(){
		var customerNo = $("#customerNo").val();
		var teamID = $("#teamID").val();
		var searchValue = $("#receiptUserNM").val();
		var url = "searchPluralNamePop.do?objId=memberID&objName=memberName&UserLevel=ALL&teamID=" + teamID + "&clientID=" + customerNo + "&searchValue=" + searchValue;
		
		var [left, top] = setPopupPosition(400, 330);
		window.open(url,'searchMemberPop',`width=400, height=330, left=` + left + `, top=` + top + `, scrollbars=yes, resizable=0`);
	}
	
	function setSearchNameWf(avg1,avg2,avg3,avg4,avg5,avg6){
		$("#receiptUserNM").val(avg2+"("+avg3+"/"+avg4+")");
		$("#receiptUserID").val(avg1);
	}
	
	// 요청자 팝업 enter
	document.getElementById('receiptUserNM').addEventListener('keydown', function(event) {
       if (event.key === 'Enter') {
           event.preventDefault(); // 기본 Enter 동작 방지 (필요시)
           searchPopupWf(); // 함수 호출
       }
	});
	
	document.getElementById("searchRequestBtn").addEventListener("click", function() {
		searchPopupWf();
	})
	
	
	// 페이징
	var pagination = new dhx.Pagination("pagination", {
	    data: grid2.data,
	    pageSize : 30
	});

	function changePageSize(e) {
		pagination.setPageSize(parseInt(e));
	}
	
	grid2.events.on("cellClick", function (row,column,e) {
 		doDetail(row);
 	});
	
	// 상세 페이지 이동
	function doDetail(data){
		var srCode = data.SRCode;
		var srID = data.SRID;
		var status = data.Status;
		var srType = data.SRType;
		var esType = data.ESType;
		var receiptUserID = data.ReceiptUserID;
		if(receiptUserID == undefined) receiptUserID = "";
		
		var url = "esrInfoMgt.do";
		var data = "&srCode="+srCode + "&srID="+srID + "&status=" +status + "&srType=" +srType + "&receiptUserID=" + receiptUserID + "&esType=" + esType + "&isPopup=true";
		
		window.open(url+"?"+data,srID,"width=1400 height=800 resizable=yes");

	}
	
	function fnSearchClear(){
		$("#teamID").val('');
		$("#teamName").val('');
		$("#receiptUserNM").val('');
		$("#receiptUserID").val('');
	}
	
</script>

<div id="srListDiv" class="pdL10 pdR10">
<div class="page-title"></div>
<table border="0" cellpadding="0" cellspacing="0" width="100%" class="form-column-4 new-form" id="search">
	<tr>
       	<th class="alignL">${menu.ZLN0211}</th>
       	<td class="alignL">
       		<select id="customerNo" Name="customerNo" style="width: 60%;display: inline-block;">
	       		<option value=''></option>
	       	</select>
       	</td>
       	<th class="alignL">${menu.ZLN0129}</th>
       	<td class="alignL">
			<input type="text" class="text" style="width: 250px; " autocomplete="off" id="teamName" name="teamName" />
			<input type="hidden" class="text" readonly="readonly" id="teamID" name="teamID" value="" />
			<img id="searchTeamBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" />
       	</td>
       	<th class="alignL">${menu.LN00004}</th>
       	<td class="alignL">
	       	<input type="text" class="text" id="receiptUserNM" name="receiptUserNM" value="" style="width:250px;"  autocomplete="off" />
			<input type="hidden" id="receiptUserID" name="receiptUserID" value="" />
			<img id="searchRequestBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" />
       	</td>
    </tr>
</table>

<div class="btn-wrap justify-center pdT10">
	<div class="btns">
		<button id="search-btn" onclick="fnCallSearch();"></button>
		<button id="clear" onclick="fnSearchClear();"></button>
	</div>
</div>
	
<ul class="btn-wrap pdT10 pdB10" >
	<li class="count">Total  <span id="TOT_CNT"></span></li>
</ul>

<div style="width:100%; " id="layout"></div>


<div id="detailBox" style="display:none;">
	<div class="title-wrap" style="display: flex; justify-content: space-between; align-items: center; margin-top: 20px; padding-bottom: 10px;">
		<div class="page-title">${menu.LN00108}</div>
		<div class="btns">
			<button id="excel2" onclick="doExcelDetail()"></button>
		</div>
	</div>
	
	<div class="new-form mgB10">
		<input type="radio" value="Total" id="Total" name="Status" checked />
		<label for="Total">${menu.LN00346 }</label>
	
		<input type="radio" value="Unassigned" id="Unassigned" name="Status" />
		<label for="Unassigned">${menu.ZLN0212 }</label>
		
		<input type="radio" value="Completed" id="Completed" name="Status" />
		<label for="Completed">${menu.ZLN0213 }</label>
		
		<input type="radio" value="Delayed" id="Delayed" name="Status" />
		<label for="Delayed">${menu.ZLN0214 }</label>
	</div>
	
	<div id="layout2" style="width:100%;height:100%;"></div>
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
</div>


<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>
</div>


