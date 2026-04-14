<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="true"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:url value="/" var="root" />

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
    <%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
	<script type="text/javascript" src="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.js?v=7.1.8"></script>
	<link rel="stylesheet" href="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.css?v=7.1.8">
    <link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css" />
    <link rel="stylesheet" type="text/css" href="${root}cmm/daelim/css/callCenter.css" />

    <script>
    	var sessionLoginId="${sessionScope.loginInfo.sessionLoginId}";
    	var inProgress = false;
    	let pageNo = 1;
 	    setInterval(loadData, 60000);
 	    
 	    let telNum = "";
 	   	let today = new Date();
 		let weekAgo = new Date(); 
 		
 		weekAgo.setDate(today.getDate() - 7);
 		
 		today = today.getFullYear() +
 		'-' + ( (today.getMonth()+1) <= 9 ? "0" + (today.getMonth()+1) : (today.getMonth()+1) )+
 		'-' + ( (today.getDate()) <= 9 ? "0" + (today.getDate()) : (today.getDate()) );
	    
 		weekAgo = weekAgo.getFullYear() + 
 		'-' + ( (weekAgo.getMonth()+1) <= 9 ? "0" + (weekAgo.getMonth()+1) : (weekAgo.getMonth()+1)) +
 		'-' + ( (weekAgo.getDate()) <= 9 ? "0" + (weekAgo.getDate()) : (weekAgo.getDate()));

    	let preValue = "";
    	window.onload = function(){
	    	 document.getElementsByName("others").forEach(other => {
				    other.addEventListener("change", function(e) {
// 				    	if(e.target.id !== "4" && e.target.id !== "13") 
				    	callUpdateFunc(e.target.id, e.target.labels[0].textContent, e.target.dataset.index, "Y");
				    })
				})
			
		 	// 콜센터 상태 UI 표시
    		getStatus();
	    	 
	    	 if("${logoutFunc}" !== "") parent.${logoutFunc}(callCenterLogout);
	    	 
	 	    document.getElementById("registerREQ").addEventListener("click", function(e) {
		        //window.top[0].parent.closeAllPopup();
// 	 	       parent.clickMainMenu('ITS10','프로세스','','','','','arcMenuMgt.do?','','','','','','','','','Y');
		     // 등록화면 팝업으로 띄우기
	 	    	window.open("/registerESP.do?&esType=ITSP&srType=REQ&url=/custom/daelim/itsm/registerREQ&procPathID=&actionParameter=resultParameter&resultParameter=completeESP.do&startEventCode=REQ0002&startSortNum=02&isPopUp=Y&isCallCenter=Y",(new Date()).getTime(),'width=1560, height=800,,scrollbar=yes,resizble=0');
		    })	
	    }
	    
	    function callCenterLogout() {
	    	// CTI 서버 로그아웃
	    	window.top[0].parent.CTILogout("${sessionScope.loginInfo.sessionEmployeeNm}", preValue);
	    }
	    
	    function callUpdateFunc(statusCode, statusName, pbxStatus, confirmYN) {
	    	if(confirmYN === "Y") {
	    		if(window.top[0].parent.etc) {
		    		if(confirm("상담 상태를 변경 하시겠습니까?")) {
		    			updateStatus(statusCode, statusName, pbxStatus);
		    			
		    			// 2026-02-04 교육/휴가/식사/휴식/면담 상태로 바꿀 경우 - CTI 휴식 중 상태로 설정
		    			if(statusCode == "22" || statusCode == "23" || statusCode == "24" || statusCode == "25" || statusCode == "26") {
		    				// CTI BREAK 함수 호출 - 휴식 설정
		    				window.top[0].parent.setBreak();
		    			} else {
		    				// CTI ETC 함수 호출 - 기타업무 설정
			    	    	window.top[0].parent.etc(statusCode);
		    			}
		    		} else {
		    			if(preValue) document.getElementById(preValue).checked = true;
		    			else document.getElementsByName("others").forEach(other => other.checked = false)
		    		}
	    		} else {
	    			alert("현재창에서는 상태 변경이 불가능합니다.")
	    			if(preValue) document.getElementById(preValue).checked = true;
	    			else document.getElementsByName("others").forEach(other => other.checked = false)
	    		}
	    	}
	    	else updateStatus(statusCode, statusName, pbxStatus);
	    }
	    
	    function updateUIStatus(status) {
	    	 document.getElementById(status).checked = true;
	    }
	    
	    
	    function updateStatus(statusCode, statusName, pbxStatus, confirmYN) {
	    	preValue = statusCode;
    		let data = {
	        		STATUS_CD : statusCode,
	        		STATUS_NAME : statusName,
	        		PBX_CC_USER_STATUS_CD : pbxStatus,
	        		memberID : "${sessionScope.loginInfo.sessionUserId}"
	        }
	        
	        fetch('/zDLM_saveCCUserSts.do', {
				method: 'POST',
				body : JSON.stringify(data),
				headers: {
					'Content-type': 'application/json; charset=UTF-8',
				},
			})
			.then((res) => res.json())
			.then((data) => {
				if(confirmYN === "Y") alert(data.message);
			});
	    }
	    
	    function getStatus() {
	        fetch('/zDLM_getCCUserSts.do?memberID=${sessionScope.loginInfo.sessionUserId}')
			.then((res) => res.json())
			.then((data) => {
				telNum = data.telNum;
				loadData();
				
				if(data.status !== "27") {
					document.getElementById(data.status).checked = true;
					preValue = data.status;
				}
				
				// 로그인 후, 첫 화면 로딩이면서 Menu varfilter에 loginFunc 변수가 있는 경우
		    	if("${initialLoad}" === "Y" && "${loginFunc}" !== "") {
			    	// CTI 함수 호출 
 			    	if(window.top[0].parent.initCTIFunc) window.top[0].parent.initCTIFunc("${sessionScope.loginInfo.sessionEmployeeNm}", data.telNum, "${sessionScope.loginInfo.sessionUserId}");
 			    	//preValue = "3";
		    	}
			});
	    }
	    
	    
	   function loadTabPage(index) {
	    	$('#loading').fadeIn(150);
	        let sqlName = "";
	        let param = "";
	        
	        
	        if(index === 1) {
	        	sqlName = "esm_SQL.getESPSearchList"; // 나의 업무
	        	param = "&srMode=myRes&srType=REQ&sessionUserID=${sessionScope.loginInfo.sessionUserId}&inProgress=ING&SRBlocked=0&srStatus=REQ0002";
	        	
	        	showGrid('grid_container1');
	        	hideGrid('grid_container2');
	        	$("#grid1_page").show();
	        	
				// 페이징 삭제
				param += "&pageNo="+pageNo+"&pageRow="+$("#pageRow").val() + "&sqlID="+sqlName;
				
				if(inProgress) {
					alert("목록을 불러오고 있습니다.");
				} else {
					getCount(param);
				}
				
	        }
	        else if(index === 2) {
	        	//shkim
	        	
	            sqlName = "callback_SQL.selectCallbackList";
	            param = "&sessionLoginId=" + sessionLoginId ;
	            
	            hideGrid('grid_container1');
	        	showGrid('grid_container2');
	        	$("#grid1_page").hide();
	        	
	        	fetch("/callbackGetList.do?sessionUserID=${sessionScope.loginInfo.sessionUserId}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&sqlID="+sqlName + param, {})
				.then(res => res.json())
				.then(data => {
					grid2.data.parse(data);
					$('#loading').fadeOut(150);
				})
	        }
	        else if(index === 3) {
	        	sqlName = "esm_SQL.getESPSearchList"; // 전체 업무
	        	param = "&inProgress=ING&SRBlocked=0&subRelationsYN=N&srType=REQ&regStartDate=" + weekAgo + "&regEndDate=" + today;
	        	
	        	showGrid('grid_container1');
	        	hideGrid('grid_container2');
	        	$("#grid1_page").hide();
	        	
	        	fetch("/jsonDhtmlxListV7.do?sessionUserID=${sessionScope.loginInfo.sessionUserId}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&sqlID="+sqlName + param, {})
				.then(res => res.json())
				.then(data => {
					grid1.data.parse(data);
					$('#loading').fadeOut(150);
				})
	        }
	        
			
			
	        // 선택된 메뉴에 class 추가
	        const tabs = document.querySelectorAll(".tab");
	        tabs.forEach((e) => e.classList.contains("on") && e.classList.remove("on"));
	        const clickedTab = document.querySelector(".tab[data-index='" + index + "']");
	        clickedTab.classList.add("on");
	      }
	   
	    function loadData() {
	    	$('#loading').fadeIn(150);
			fetch("/zDLM_callCenterMainData.do?memberID=${sessionScope.loginInfo.sessionUserId}&telNum="+telNum, {})
			.then(res => res.json())
			.then(data => {
				Object.keys(data.status).forEach(e => {
				    document.querySelector("#"+e).textContent = data.status[e];
				});
				if(data.ctiData) {
					Object.keys(data.ctiData).forEach(e => {
					    document.querySelector("#"+e).textContent = data.ctiData[e];
					});
				}
				if(data.myData) {
					Object.keys(data.myData).forEach(e => {
					    document.querySelector("#"+e).textContent = data.myData[e];
					});
				}
				$('#loading').fadeOut(150);
			})
	    }
	    
	    // 새로고침 막기
	    function doNotReload(event){
	        if ((event.ctrlKey && (event.keyCode === 78 || event.keyCode === 82)) || event.keyCode === 116) {
	            event.preventDefault();
	            return false;
	        }
	    }
	    document.addEventListener("keydown", doNotReload);
	    
    </script>
  </head>
  <body id="call-center-main">
    <div class="main-container">
      <section class="section-wrapper-1">
        <div class="left-side">
          <div class="register" id="registerREQ" >
          	<svg xmlns="http://www.w3.org/2000/svg" height="26px" viewBox="0 -960 960 960" width="26px" fill="#FFFFFF"><path d="M560-80v-123l221-220q9-9 20-13t22-4q12 0 23 4.5t20 13.5l37 37q8 9 12.5 20t4.5 22q0 11-4 22.5T903-300L683-80H560Zm300-263-37-37 37 37ZM620-140h38l121-122-18-19-19-18-122 121v38ZM240-80q-33 0-56.5-23.5T160-160v-640q0-33 23.5-56.5T240-880h320l240 240v120h-80v-80H520v-200H240v640h240v80H240Zm280-400Zm241 199-19-18 37 37-18-19Z"/></svg>
            <span>서비스 요청 등록</span>
          </div>
          <div class="cti">
            <h1>CTI 상태</h1>
            <div class="new-form flex">
              <div class="cti-left">
                <h2>상담업무</h2>
                <ul>
                  <li><input name="others" id="4" type="radio" data-index="4"/><label for="4">상담중</label></li>
                  <li><input name="others" id="13" type="radio" data-index="13"/><label for="13">상담후 작업</label></li>
                  <li><input name="others" id="20" type="radio" data-index="14"/><label for="20">기타업무 처리</label></li>
                  <li><input name="others" id="3" type="radio"  data-index="3"/><label for="3">상담 대기중</label></li>
                  <li><input name="others" id="21" type="radio"  data-index="14"/><label for="21">원격 연결</label></li>
                </ul>
              </div>
              <div class="cti-right">
                <h2>기타</h2>
                <ul>
                  <li><input name="others" id="22" type="radio" data-index="14"/><label for="22">교육</label></li>
                  <li><input name="others" id="23" type="radio" data-index="14"/><label for="23">휴가</label></li>
                  <li><input name="others" id="24" type="radio" data-index="14"/><label for="24">식사</label></li>
                  <li><input name="others" id="25" type="radio" data-index="14"/><label for="25">휴식</label></li>
                  <li><input name="others" id="26" type="radio" data-index="14"/><label for="26">면담</label></li>
                </ul>
              </div>
            </div>
          </div>
        </div>
        <div class="right-side">
          <ul>
            <li>
              <div>
                <svg id="message" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
				  <path id="패스_40027" data-name="패스 40027" d="M0,0H24V24H0Z" fill="none"/>
				  <path id="패스_40028" data-name="패스 40028" d="M8,9h8" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				  <path id="패스_40029" data-name="패스 40029" d="M8,13h6" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				  <path id="패스_40030" data-name="패스 40030" d="M18,4a3,3,0,0,1,3,3v8a3,3,0,0,1-3,3H13L8,21V18H6a3,3,0,0,1-3-3V7A3,3,0,0,1,6,4Z" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				</svg>
                <span>응대</span>
              </div>
              <p id="response"></p>
            </li>
            <li>
              <div>
                <svg xmlns="http://www.w3.org/2000/svg" id="phone-pause" width="24" height="24" viewBox="0 0 24 24">
				  <path id="패스_40011" data-name="패스 40011" d="M0,0H24V24H0Z" fill="none"/>
				  <path id="패스_40012" data-name="패스 40012" d="M5,4H9l2,5L8.5,10.5a11,11,0,0,0,5,5L15,13l5,2v4a2,2,0,0,1-2,2A16,16,0,0,1,3,6,2,2,0,0,1,5,4" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				  <path id="패스_40013" data-name="패스 40013" d="M17,3V8" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				  <path id="패스_40014" data-name="패스 40014" d="M21,3V8" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				</svg>
                <span>통화대기</span>
              </div>
              <p>0</p>
            </li>
            <li>
              <div>
                <svg xmlns="http://www.w3.org/2000/svg" id="phone-outgoing" width="24" height="24" viewBox="0 0 24 24">
				  <path id="패스_40015" data-name="패스 40015" d="M0,0H24V24H0Z" fill="none"/>
				  <path id="패스_40016" data-name="패스 40016" d="M5,4H9l2,5L8.5,10.5a11,11,0,0,0,5,5L15,13l5,2v4a2,2,0,0,1-2,2A16,16,0,0,1,3,6,2,2,0,0,1,5,4" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				  <path id="패스_40017" data-name="패스 40017" d="M15,5h6" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				  <path id="패스_40018" data-name="패스 40018" d="M18.5,7.5,21,5,18.5,2.5" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				</svg>
                <span>콜백대기</span>
              </div>
              <p id="callback"></p>
            </li>
            <li>
              <div>
               <svg xmlns="http://www.w3.org/2000/svg" id="flag" width="24" height="24" viewBox="0 0 24 24">
				  <path id="패스_40019" data-name="패스 40019" d="M0,0H24V24H0Z" fill="none"/>
				  <path id="패스_40020" data-name="패스 40020" d="M5,5a5,5,0,0,1,7,0,5,5,0,0,0,7,0v9a5,5,0,0,1-7,0,5,5,0,0,0-7,0Z" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				  <path id="패스_40021" data-name="패스 40021" d="M5,21V14" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				</svg>
                <span>포기</span>
              </div>
              <p id="giveup"></p>
            </li>
          </ul>
          <ul>
            <li>
              <div>
				<svg xmlns="http://www.w3.org/2000/svg" id="headset" width="23.954" height="24" viewBox="0 0 23.954 24">
				  <path id="패스_40006" data-name="패스 40006" d="M0,0H23.954V24H0Z" fill="none"/>
				  <path id="패스_40007" data-name="패스 40007" d="M4,14V11a7.977,7.977,0,1,1,15.954,0v3" transform="translate(0)" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				  <path id="패스_40008" data-name="패스 40008" d="M18,19c0,1.657-2.686,3-6,3" transform="translate(-0.031)" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				  <path id="패스_40009" data-name="패스 40009" d="M4,14a2,2,0,0,1,2-2H7a2,2,0,0,1,2,2v3a2,2,0,0,1-2,2H6a2,2,0,0,1-2-2Z" transform="translate(-0.01)" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				  <path id="패스_40010" data-name="패스 40010" d="M15,14a2,2,0,0,1,2-2h1a2,2,0,0,1,2,2v3a2,2,0,0,1-2,2H17a2,2,0,0,1-2-2Z" transform="translate(-0.036)" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				</svg>
                <span>상담중</span>
              </div>
              <p id="callings"></p>
            </li>
            <li>
              <div>
                <svg xmlns="http://www.w3.org/2000/svg" id="tool" width="24" height="24" viewBox="0 0 24 24">
				  <path id="패스_40031" data-name="패스 40031" d="M0,0H24V24H0Z" fill="none"/>
				  <path id="패스_40032" data-name="패스 40032" d="M7,10h3V7L6.5,3.5a6,6,0,0,1,8,8l6,6a2.121,2.121,0,0,1-3,3l-6-6a6,6,0,0,1-8-8L7,10" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				</svg>
                <span>작업중</span>
              </div>
              <p id="working"></p>
            </li>
            <li>
              <div>
				<svg xmlns="http://www.w3.org/2000/svg" id="clock-pause" width="24" height="24" viewBox="0 0 24 24">
				  <path id="패스_40033" data-name="패스 40033" d="M0,0H24V24H0Z" fill="none"/>
				  <path id="패스_40034" data-name="패스 40034" d="M20.942,13.018a9,9,0,1,0-7.909,7.922" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				  <path id="패스_40035" data-name="패스 40035" d="M12,7v5l2,2" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				  <path id="패스_40036" data-name="패스 40036" d="M17,17v5" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				  <path id="패스_40037" data-name="패스 40037" d="M21,17v5" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				</svg>
                <span>대기중</span>
              </div>
              <p id="standby"></p>
            </li>
            <li>
              <div>
				<svg xmlns="http://www.w3.org/2000/svg" version="1.0" width="24" height="24" viewBox="0 0 24 24" >
				<g transform="translate(0,24) scale(0.1,-0.1)" fill="#000000" stroke="none">
				<path d="M94 213 c-67 -13 -92 -110 -41 -160 71 -72 194 6 158 100 -16 41 -71 69 -117 60z m81 -38 c33 -32 33 -78 0 -110 -49 -50 -135 -15 -135 55 0 41 39 80 80 80 19 0 40 -9 55 -25z"/>
				<path d="M70 120 c0 -5 5 -10 10 -10 6 0 10 5 10 10 0 6 -4 10 -10 10 -5 0 -10 -4 -10 -10z"/>
				<path d="M110 120 c0 -5 5 -10 10 -10 6 0 10 5 10 10 0 6 -4 10 -10 10 -5 0 -10 -4 -10 -10z"/>
				<path d="M150 120 c0 -5 5 -10 10 -10 6 0 10 5 10 10 0 6 -4 10 -10 10 -5 0 -10 -4 -10 -10z"/>
				</g>
				</svg>
                <span>기타</span>
              </div>
              <p id="others"></p>
            </li>
            <li>
              <div>
				<svg xmlns="http://www.w3.org/2000/svg" id="receipt" width="24" height="24" viewBox="0 0 24 24">
				  <path id="패스_40043" data-name="패스 40043" d="M0,0H24V24H0Z" fill="none"/>
				  <path id="패스_40044" data-name="패스 40044" d="M5,21V5A2,2,0,0,1,7,3H17a2,2,0,0,1,2,2V21l-3-2-2,2-2-2-2,2L8,19,5,21M9,7h6M9,11h6m-2,4h2" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				</svg>
                <span>토탈</span>
              </div>
              <p id="total"></p>
            </li>
          </ul>
          <ul>
            <li>
              <div>
				<svg xmlns="http://www.w3.org/2000/svg" id="clock" width="24" height="24" viewBox="0 0 24 24">
				  <path id="패스_40045" data-name="패스 40045" d="M0,0H24V24H0Z" fill="none"/>
				  <path id="패스_40046" data-name="패스 40046" d="M3,12a9,9,0,1,0,9-9,9,9,0,0,0-9,9" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				  <path id="패스_40047" data-name="패스 40047" d="M12,7v5l3,3" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				</svg>
                <span>평균통화시간</span>
              </div>
              <p id="avgcalltime"></p>
            </li>
            <li>
              <div>
				<svg xmlns="http://www.w3.org/2000/svg" id="hourglass-high" width="24" height="24" viewBox="0 0 24 24">
				  <path id="패스_40048" data-name="패스 40048" d="M0,0H24V24H0Z" fill="none"/>
				  <path id="패스_40049" data-name="패스 40049" d="M6.5,7h11" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				  <path id="패스_40050" data-name="패스 40050" d="M6,20V18a6,6,0,0,1,12,0v2a1,1,0,0,1-1,1H7A1,1,0,0,1,6,20Z" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				  <path id="패스_40051" data-name="패스 40051" d="M6,4V6A6,6,0,1,0,18,6V4a1,1,0,0,0-1-1H7A1,1,0,0,0,6,4Z" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				</svg>
                <span>평균통화대기시간</span>
              </div>
              <p id="avgstanbytime"></p>
            </li>
            <li>
              <div>
                <svg xmlns="http://www.w3.org/2000/svg" id="rosette-discount-check" width="24" height="24" viewBox="0 0 24 24">
				  <path id="패스_40052" data-name="패스 40052" d="M0,0H24V24H0Z" fill="none"/>
				  <path id="패스_40053" data-name="패스 40053" d="M5,7.2A2.2,2.2,0,0,1,7.2,5h1a2.2,2.2,0,0,0,1.55-.64l.7-.7a2.2,2.2,0,0,1,3.12,0l.7.7A2.2,2.2,0,0,0,15.82,5h1a2.2,2.2,0,0,1,2.2,2.2v1a2.2,2.2,0,0,0,.64,1.55l.7.7a2.2,2.2,0,0,1,0,3.12l-.7.7a2.2,2.2,0,0,0-.64,1.55v1a2.2,2.2,0,0,1-2.2,2.2h-1a2.2,2.2,0,0,0-1.55.64l-.7.7a2.2,2.2,0,0,1-3.12,0l-.7-.7a2.2,2.2,0,0,0-1.55-.64h-1A2.2,2.2,0,0,1,5,16.82v-1a2.2,2.2,0,0,0-.64-1.55l-.7-.7a2.2,2.2,0,0,1,0-3.12l.7-.7A2.2,2.2,0,0,0,5,8.2v-1" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				  <path id="패스_40054" data-name="패스 40054" d="M9,12l2,2,4-4" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				</svg>
                <span>1차 해결율</span>
              </div>
              <p id="endper"></p>
            </li>
            <li>
              <div>
               <svg xmlns="http://www.w3.org/2000/svg" id="flag-discount" width="24" height="24" viewBox="0 0 24 24">
				  <path id="패스_40055" data-name="패스 40055" d="M0,0H24V24H0Z" fill="none"/>
				  <path id="패스_40056" data-name="패스 40056" d="M12.8,14.641A5.02,5.02,0,0,1,12,14a5,5,0,0,0-7,0V5a5,5,0,0,1,7,0,5,5,0,0,0,7,0v8" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				  <path id="패스_40057" data-name="패스 40057" d="M5,21V14" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				  <path id="패스_40058" data-name="패스 40058" d="M16,21l5-5" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				  <path id="패스_40059" data-name="패스 40059" d="M21,21v.01" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				  <path id="패스_40060" data-name="패스 40060" d="M16,16v.01" fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/>
				</svg>
                <span>콜 포기율</span>
              </div>
              <p>0</p>
            </li>
          </ul>
          <div class="statistics">
				<h1>MY콜 처리현황  <a style="cursor: pointer;float: right; font-weight:bold; font-size:13px; background: #0761cf; color:#fff; padding: 8px; border-radius:14px;  " onClick="loadData();">RELOAD</a></h1>
		  		<table>
					<colgroup>
						<col width="25%">
						<col width="25%">
						<col width="25%">
						<col width="25%">
					</colgroup>
					<tr>
						<th>총응대</th>
						<th>1차 처리율</th>
						<th>총 통화시간</th>
						<th>평균 통화시간</th>
					</tr>
					<tr>
						<td class="last" id="totalresponsecnt"></td>
						<td class="last" id="ftper">0%</td>
						<td class="last" id="mysumcalltime"></td>
						<td class="last" id="myavgcalltime"></td>
					</tr>
		  		</table>
			</div>
        </div>
      </section>
      <section class="section-wrapper-2">
        <ul class="tabs">
          <li onclick="loadTabPage(1)" class="tab" data-index="1">나의 업무 내역</li>
          <li onclick="loadTabPage(2)" class="tab" data-index="2">나의 콜백 대상</li>
          <li onclick="loadTabPage(3)" class="tab" data-index="3">전체 업무 내역</li>
        </ul>
        <div class="border-section mgB30">
        	<div class="pdT20 pdB10"></div>
        	<div id="grid_container1" style="width: 100%; height: 300px;"></div>
        	<div id="grid1_page" class="align-center flex">
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
        	
    		<div id="grid_container2" style="width: 100%; height: 300px;"></div>
			
        </div>
      </section>
    </div>
    
   
    
    <script>
	    loadTabPage(1);
	      
	    const grid1 = new dhx.Grid("grid_container1", {
	    	columns: [
	  	  	        { width:120, id: "SRTypeNM", header: [{ text: "구분" , align: "center" }], align: "center" },
	  	  	        { id: "Subject", header: [{ text: "${menu.LN00002}" , align: "center" }], align: "left" },
	  	  	        { width: 180, id: "ReqUserNM", header: [{ text: "${menu.LN00025}" , align: "center" }], align: "center" },
	  	  	        { width: 90, id: "RegDate", header: [{ text: "${menu.LN00093}" , align: "center" }], align: "center" },
	  	  	        { width: 120, id: "StatusName", header: [{ text: "${menu.LN00027}" , align: "center" }], align: "center" },
	  	  	      	{ width: 120, id: "ResponseInfo", header: [{ text: "현재수행자" , align: "center" }], align: "center" },
	  	  	        { width: 120, id: "ProcRoleTypeMemberList", header: [{ text: "작업그룹멤버" , align: "center" }], align: "center" },
	  	  	        { hidden: true, width: 120, id: "SRCode", header: [{ text: "${menu.LN00396}" , align: "center" }], align: "center" },
	  	  	        { hidden: true, width: 120, id: "ProcRoleTypeName", header: [{ text: "${menu.LN00109}" , align: "center" }], align: "center" },
	  	  	        { hidden: true, width: 90,  id: "CompanyName", header: [{ text: "${menu.LN00014}" , align: "center" }], align: "center" },
	  	  	        { hidden: true, width: 120, id: "SRArea1Name", header: [{ text: "서비스" , align: "center" }], align: "center" },
	  	  	        { hidden: true, width: 120, id: "SRArea2Name", header: [{ text: "파트" , align: "center" }], align: "center" },
	  	  	        { hidden: true, width: 120,  id: "CategoryNM", header: [{ text: "${menu.LN00272}" , align: "center" }], align: "center" },
	  	  	        { hidden: true, width: 120,  id: "SubCategoryNM", header: [{ text: "하위 ${menu.LN00272}" , align: "center" }], align: "center" },
	  	  	        { hidden: true, width: 90, id: "ReqDueDate", header: [{ text: "${menu.LN00222}" , align: "center" }], align: "center" },
	  	  	        { hidden: true, width: 90, id: "SRDueDate", header: [{ text: "${menu.LN00221}" , align: "center" }], align: "center" },
	  	  	        { hidden: true, width: 120, id: "SRCompletionDT", header: [{ text: "${menu.LN00223}" , align: "center" }], align: "center" },
	  	  	        
	  	  	      	{ hidden: true,width: 90, id: "", header: [{ text: "완료여부" , align: "center" }], align: "center", template: function (text, row, col) {
	  	          	var result = "";
	  	          	var comp = "";
	  	          	comp = row.SRCompletionDT;
	  	          	result = (comp !== undefined && comp !== null && comp.trim() !== '') ? "완료" : "진행 중";
	  	          	
	  	              return result;
	  	          } },
	  	  	        { hidden: true,width: 90, id: "CompletionDelay", header: [{ text: "지연여부" , align: "center" }], align: "center" },
	  	  	    ],
	  	  	    autoWidth: true,
	  	  	    resizable: true,
	  	  	    selection: "row",
	  	  	    tooltip: false,
	  	  	});
	    
	  	
	  	grid1.events.on("cellClick", function (row,column,e) {
	  		var srCode = row.SRCode;
	  		var srID = row.SRID;
	  		var status = row.Status;
	  		var srType = row.SRType;
	  		var esType = row.ESType;
	  		var receiptUserID = row.ReceiptUserID;
	  		if(receiptUserID == undefined) receiptUserID = "";
	  		
	  		var data = "&srCode="+srCode + "&srID="+srID + "&status=" +status + "&srType=" +srType + "&receiptUserID=" + receiptUserID + "&esType=" + esType +"&isPopup=true";
	  		
	  		window.open("/esrInfoMgt.do?"+data,srID,"width=1400 height=800 resizable=yes");
	  	});
	  	
	  	const grid2 = new dhx.Grid("grid_container2", {
	  		 columns: [
		             { width: 150, id: "CallBackKey", header: [{ text: "콜백번호" , align: "center" }], align: "center" },
			  	     { width: 300, id: "RegDayTime", header: [{ text: "콜백등록일시" , align: "center" }], align: "center" },
		  	         { width: 203, id: "ReqNm", header: [{ text: "의뢰자" , align: "center" }], align: "center" },
		  	         { width: 200, id: "Seq", header: [{ text: "통화시도횟수" , align: "center" }], align: "center" },
		  	         { width: 300, id: "CreationTime", header: [{ text: "최종통화시도시간" , align: "center" }], align: "center" },
		  	         { hidden: true, width: 90, id: "LastUser", header: [{ text: "LastUser" , align: "center" }], align: "center" },
		  	         { width: 203, id: "NAME", header: [{ text: "최종등록자" , align: "center" }], align: "center" },
		         ],
		  	    autoWidth: true,
		  	    resizable: true,
		  	    selection: "row",
		  	    tooltip: false,
		  	});
		    
	  	
	  	grid2.events.on("cellClick", function (row,column,e) {
	  		var CallBackKey = row.CallBackKey;
	  		var AgentID = row.AgentID;
	  		var srID = row.SRID;
	  		
	  		var data = "&CallBackKey="+CallBackKey + "&AgentID="+AgentID +"&isPopup=true";
	  		
	  		window.open("/callBackPop.do?"+data,srID,"width=1400 height=800 resizable=yes");
	  	});
	  	
	  	function test(reqNum) {
	  		window.top[0].parent.callCTI(reqNum);
	  	}
	 	// Grid 숨기기 함수
        function hideGrid(gridId) {
            document.getElementById(gridId).style.display = "none";
        }

        // Grid 보이기 함수
        function showGrid(gridId) {
            document.getElementById(gridId).style.display = "block";
        }
        
     // 페이징
	    var pagination = new dhx.Pagination("pagination", {
	        data: grid1.data,
	        pageSize : 30
	    });

	    // 페이징 삭제
	    pagination.events.on("change", function(index, previousIndex) {
	    	pageNo = index + 1;
	    	loadTabPage(1);
	    });


	    function changePageSize(e) {
	    	pagination.setPageSize(parseInt(e));
	    }

	    async function getCount(data) {
	    	inProgress = true;
	    	await fetch("/getSrCount.do?"+data)
	    	.then(res => res.json())
	    	.then(res => {
	    		$('#loading').fadeOut(150);
	    		
	    		let arr = [];
	    		for(var i=1; i <= res.total; i++) {
	    			arr.push({$empty : true, id: i});
	    		}
	    		grid1.data.parse(arr);
	    		
	    		res.list.forEach( e => {
	    			if(!grid1.data.getItem(e.RNUM).RNUM)  grid1.data.update(e.RNUM, e);
	    		});

	    		$('#loading').fadeOut(150);
	    		inProgress = false;
	    	});
	    }

	    function fnReloadGrid(newGridData, excel, count){
   			let res = JSON.parse(newGridData);
   			res.forEach( e => {
   				if(!grid1.data.getItem(e.RNUM).RNUM)  grid1.data.update(e.RNUM, e);
   			})
	    }
    </script>
	  
    </script>
  </body>
</html>
