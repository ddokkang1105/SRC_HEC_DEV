<%@ page import="xbolt.cmm.framework.val.GlobalVal"%> <%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="true"%> <%@
taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:url value="/" var="root" />

<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <%-- <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%> --%>
    <link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css" />
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
    <script>
		
    </script>
    <style>
    .main-container {
    	padding:30px;
    }
    .main-container p {
        font-size: 17px;
    }
    .main-container p > span {
        font-size: 17px;
		font-weight: 900;
    }
    </style>
  </head>
  <body>
    <div class="main-container">
    	<p>이클릭 콜센터<span>(1588 - 7514)</span></p>
    	<div class="section-wrapper" style="display: flex;gap:30px;">
    		<div class="left-side" style="flex: 1 0 auto;">
    			<ul class="tabs listTabs">
		          <li onclick="loadTabPage(1)" class="tab" data-index="1">요청한 업무</li>
		          <li onclick="loadTabPage(2)" class="tab" data-index="2">고객 테스트</li>
		          <li onclick="loadTabPage(3)" class="tab" data-index="3">만족도 조사</li>
		          <li onclick="loadTabPage(4)" class="tab" data-index="4">완료</li>
		        </ul>
		        <div class="border-section">
		        	<div class="pdT20 pdB10"></div>
	    			<div style="width:100%;" id="layout"></div>
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
    		</div>
    		<div class="right-side">
    			<ul class="tabs">
		          <li onclick="loadTabBoard(1)" class="tab board" data-index="1">FAQ</li>
		          <li onclick="loadTabBoard(2)" class="tab board" data-index="2">소프트웨어 자료</li>
		          <li onclick="loadTabBoard(3)" class="tab board" data-index="3">시스템 매뉴얼</li>
		        </ul>
		        <div class="border-section">
		        	<div class="pdT20 pdB10"></div>
	    			<div id="boardFrame"></div>	
	    		</div>
    		</div>
    	</div>
    </div>
    <script>
    	let pageNo = 1;	
    	var inProgress = false;
    
    	let selectedIndex = "";
    	let data = "";
        let boardMgtID = "";
    
	    loadTabPage(1);
	    loadTabBoard(1);
	    
	    document.querySelector("#layout").style.height = setWindowHeight() - 217+"px";
	    document.querySelector("#boardFrame").style.height = setWindowHeight() - 217+"px";
		window.onresize = function() {
			document.querySelector("#layout").style.height = setWindowHeight() - 217+"px"
			document.querySelector("#boardFrame").style.height = setWindowHeight() - 217+"px"
		};
	    
	    const layout = new dhx.Layout("layout", {
	  	    rows: [
	  	        {
	  	            id: "a",
	  	        },
	  	    ]
	  	});
	    
	    const grid = new dhx.Grid("", {
	  	    columns: [
	  	        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
	  	        { width: 120, id: "SRCode", header: [{ text: "${menu.LN00396}" , align: "center" }], align: "center" },
	  	        { id: "Subject", header: [{ text: "${menu.LN00002}" , align: "center" }], align: "left" },
	  	        { width: 110, id: "StatusName", header: [{ text: "${menu.LN00027}" , align: "center" }], align: "center" },
	  	        { width: 90, id: "RegDate", header: [{ text: "${menu.LN00093}" , align: "center" }], align: "center" },
	  	        { width: 90, id: "SRDueDate", header: [{ text: "${menu.LN00221}" , align: "center" }], align: "center" },
	  	    ],
	  	    autoWidth: true,
	  	    resizable: true,
	  	    selection: "row",
	  	    tooltip: false,
	  	});
	    
	 	// 페이징
	    var pagination = new dhx.Pagination("pagination", {
	        data: grid.data,
	        pageSize : 30
	    });

	    // 페이징 삭제
	    pagination.events.on("change", function(index, previousIndex) {
	    	pageNo = index + 1;
	    	var tabElement = document.querySelector('li.tab.on');
	    	var dataIndex = tabElement ? tabElement.getAttribute('data-index') : null;
	    	loadTabPage(dataIndex);
	    });


	    function changePageSize(e) {
	    	pagination.setPageSize(parseInt(e));
	    }
	    
		grid.events.on("cellClick", function(row, column, e) {
			var srCode = row.SRCode;
			var srID = row.SRID;
			var status = row.Status;
			var srType = row.SRType;
			var esType = row.ESType;
			var receiptUserID = row.ReceiptUserID;
			if(receiptUserID == undefined) receiptUserID = "";
			
			//setTab(selectedIndex);
			window.open("/esrInfoMgt.do?srCode="+srCode + "&srID="+srID + "&status=" +status + "&srType=" +srType + "&receiptUserID=" + receiptUserID + "&esType=" + esType + "&isPopup=true",srID,"width=1400 height=800 resizable=yes");
		});
	    
	  	layout.getCell("a").attach(grid);

        
	    function loadTabPage(index) {
	    	$('#loading').fadeIn(150);
	    	selectedIndex = index;
	        if(index === 1) data = "&inProgress=ING"; // 티켓의 요청자가 로그인한 사용자 && 완료되지 않은 티켓
	        if(index === 2) data = "&inProgress=ING&srStatus=ACM0009"; // 티켓의 요청자가 로그인한 사용자 && 완료되지 않은 티켓 && 현재 티켓의 단계가 [고객만족도 조사]
	        if(index === 3) data = "&SRBlocked=1&srStatus=ZSPE00"; // 티켓의 요청자가 로그인한 사용자 && 처리완료되었으나 만족도 평가가 실행되지 않은 티켓 && 현재 티켓의 단계가 [만족도 조사]
	        if(index === 4) data = "&SRBlocked=2&inProgress=COMPL"; // 티켓의 요청자가 로그인한 사용자 && 티켓이 최종 완료된 티켓 ( 만족도가 있을경우 조사까지 완료된 티켓 )
	        
	     	// 페이징 삭제
	    	data += "&sessionUserID=${sessionScope.loginInfo.sessionUserId}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&esType=ITSP&srMode=myReq&sqlID=esm_SQL.getESPSearchList"
	    	+"&pageNo="+pageNo+"&pageRow="+$("#pageRow").val()+"&subRelationsYN=N";
	     	
	    	if(inProgress) {
	    		alert("목록을 불러오고 있습니다.");
	    	} else {
	    		getCount(data);
	    	}
			
	        // 선택된 메뉴에 class 추가
	        const tabs = document.querySelectorAll(".listTabs .tab");
	        tabs.forEach((e) => e.classList.contains("on") && e.classList.remove("on"));
	        const clickedTab = document.querySelector(".listTabs .tab[data-index='" + index + "']");
	        clickedTab.classList.add("on");
		}

	    async function getCount(data) {
	    	inProgress = true;
	    	await fetch("/getSrCount.do?"+data)
	    	.then(res => res.json())
	    	.then(res => {
	    		$('#loading').fadeOut(150);
	    		
	    		let arr = [];
	    		$("#TOT_CNT").html(res.total);
	    		for(var i=1; i <= res.total; i++) {
	    			arr.push({$empty : true, id: i});
	    		}
	    		grid.data.parse(arr);
	    		
	    		res.list.forEach( e => {
	    			if(!grid.data.getItem(e.RNUM).RNUM)  grid.data.update(e.RNUM, e);
	    		});

	    		$('#loading').fadeOut(150);
	    		inProgress = false;
	    	});
	    }
	    
	    function loadTabBoard(index) {
	        if(index === 1) boardMgtID = "BRD3001";
	        if(index === 2) boardMgtID = "BRD3002";
	        if(index === 3) boardMgtID = "BRD3003";
	        
			var url = "zDlm_mainBoardList.do";
			var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&BoardMgtID="+boardMgtID+"&listSize=5";
			ajaxPage(url, data, "boardFrame");
			
	        // 선택된 메뉴에 class 추가
	        const tabs = document.querySelectorAll(".board");
	        tabs.forEach((e) => e.classList.contains("on") && e.classList.remove("on"));
	        const clickedTab = document.querySelector(".board[data-index='" + index + "']");
	        clickedTab.classList.add("on");
		}
	    
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
  </body>
</html>
