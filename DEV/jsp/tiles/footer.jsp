<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>

 <input type="hidden" id="sessionTimeOut" name="sessionTimeOut" value=<%=session.getMaxInactiveInterval() %>>
<!-- 1. Include JSP -->

<%--  <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%> --%>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00188" var="WM00188"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00189" var="WM00189"/>
<div id="footersection" align = "center">
	<div class="footerL mgL30" >
	<span style="font-size:20px;font-color:#ECECEC;font-weight:500;">남은시간 </span>	 
 	<span id = "sessionTimer" style="font-size:20px;font-color:#ECECEC;font-weight:500; margin-right:10px;"></span> 
		<span style="font-size:20px;font-color:#ECECEC;font-weight:700;">SFOLM</span>		
		<span style="font-size:10px;font-color:#465866;vertical-align:baseline;">
			&nbsp;&nbsp;&copy;
			<span id="currentYear" style="font-size:10px;font-color:#465866;vertical-align:baseline;"></span>
			Smartfactory Inc. All rights reserved.
		</span>
		
	</div>
</div>
<script>
var timer;
var curYear = new Date().getFullYear();
var sessionTime = document.getElementById('sessionTimeOut').value;
let confirmShown = false;

document.getElementById("currentYear").innerHTML = curYear;

$(document).ready(function(){
    doTimer(sessionTime);
});

$(document).on('click', function(event){
	// dhtmlx-confirm 창 내부 클릭은 무시
    if ($(event.target).closest(".dhtmlx_modal_box").length > 0) {
        return; // confirm 창 내부 클릭이면 패스
    }
	
   	renewSession();
   	reset(sessionTime);
});

function getRemainingSessionTime() {
    return new Promise(function(resolve, reject) {
        $.ajax({
            url: '/login/getRemainingSessionTime.do', 
            type: 'GET',
            success: function(response) {
             
                let remainingTime = response.remainingTime; 
               // console.log("남은 세션 시간: " + remainingTime + "초");
                resolve(remainingTime);  // 남은 시간 반환
            },
            error: function(error) {
                reject("Error fetching remaining session time");
            }
        });
    });
}


function sessionTimeOut() {
    return new Promise(function(resolve, reject) {
        $.ajax({
            url: '/sessionTimeOutLogOut.do',
            type: 'GET',
            success: function(response) {
                resolve(response);  // 세션 타임아웃 후 응답을 반환
            },
            error: function(xhr, textStatus, errorThrown) {
                alert("${WM00188}");	// 세션시간이 만료되었습니다.
                window.location.href = "/custom/sk/loginAuth.do"; // 로그아웃
            }
        });
    });
}

function doTimer(time) {

    var date = new Date(null);
    if (time >= 0) {
        date.setSeconds(time);
        document.getElementById("sessionTimer").innerHTML = date.toISOString().substr(11, 8);
        
        if (time === 0) {
            sessionTimeOut().then(function(data) {
                clearTimeout(timer);
                alert("${WM00188}");	// 세션시간이 만료되었습니다.
                window.location.href = "/custom/sk/loginAuth.do"; // 로그아웃
                return;
            }).catch(function(err) {
                console.error(err);
                alert("${WM00188}");	// 세션시간이 만료되었습니다.
                window.location.href = "/custom/sk/loginAuth.do"; // 로그아웃
            });
            return;
        }
        
        if (time === 60) { // 세션 1분 남았을 때 체크
        	getRemainingSessionTime().then(function(remainingTime) {
                  remainingTime = parseInt(remainingTime, 10);  // 정수로 변환
                  if (remainingTime > 60) {
                      reset(remainingTime);  // 타이머 리셋
                  } else {
                      --time; 
                      timer = setTimeout(doTimer, 1000, time); 
                  }
              }).catch(function(error) {
                  console.error("세션 시간 가져오기 실패:", error);
                  --time; 
                  timer = setTimeout(doTimer, 1000, time); 
              });
        	return;
        }
        
        if(time === 30 && !confirmShown){
        	confirmShown = true;
        	
        	dhtmlx.confirm({
        	    title: "Confirmation",
        	    text: "Service connection time is 30 seconds left. Would you like to renew?",
        	    callback: function(result) {
        	        if (result) {
        	        	 getRemainingSessionTime().then(function(remainingTime) {
        	                  remainingTime = parseInt(remainingTime, 10);  // 정수로 변환
        	                  if (remainingTime > 0) {
        	                	  renewSession();
        	                	  reset(sessionTime);
        	                	  confirmShown = false; // 연장 후 재사용 가능
        	                  } else {
        	                      location.href = "/login/logout.do"; // 로그아웃
        	                  }
        	              }).catch(function(error) {
        	                  console.error("세션 연장 실패:", error);
        	              });
        	        }
        	        confirmShown = false;
        	    }
        	});
        } 
        --time; // time을 감소
        timer = setTimeout(doTimer, 1000, time); // 다음 호출
    }
    return;
}

function reset(sessionTime) {
	  clearTimeout(timer);
      doTimer(sessionTime);
}

function renewSession() {
    $.ajax({
        url: '/login/renewSession.do', 
        type: 'POST',   
        data: {
            sessionTime: sessionTime  // sessionTime 값을 서버로 전송
        },
        success: function(response) {

            let data = JSON.parse(response); 
            if (data.newSessionTime) {
               // alert("세션이 갱신되었습니다. 새로운 세션 시간: " + data.newSessionTime + "초");
                sessionTime =data.newSessionTime;
            } else if (data.message) {
                alert(data.message);
            }
        },
        error: function(xhr, status, error) {
            // 오류 처리
            alert("${WM00189}");	// 세션 갱신 중 오류가 발생했습니다.
        }
    });
}
</script>