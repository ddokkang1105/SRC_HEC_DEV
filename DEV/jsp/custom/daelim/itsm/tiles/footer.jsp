<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:url value="/" var="root"/>
 <input type="hidden" id="sessionTimeOut" name="sessionTimeOut" value=<%=session.getMaxInactiveInterval() %>>
<!-- 1. Include JSP -->
<%--  <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%> --%>
<div id="footersection" align = "center">
	<div class="footerL mgL30" >
	<span style="font-size:20px;font-color:#ECECEC;font-weight:500;">남은시간 </span>	 
 	<span id = "sessionTimer" style="font-size:20px;font-color:#ECECEC;font-weight:500; margin-right:10px;"></span> 
		<span style="font-size:20px;font-color:#ECECEC;font-weight:700;">eClick</span>		
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

document.getElementById("currentYear").innerHTML = curYear;




$(document).ready(function(){
    
    doTimer(sessionTime);
    $(document).on('click', function(){
        clearTimeout(timer);
        doTimer(sessionTime);
    });
});
function sessionTimeOut() {
    return new Promise(function(resolve, reject) {
        $.get('/sessionTimeOutLogOut.do', function(response) {
            if (response) {
                resolve(response);
            } else {
                reject(new Error("No response received"));
            }
        }).fail(function(jqXHR, textStatus, errorThrown) {
            reject(new Error("AJAX request failed: " + textStatus));
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
            	
                alert("세션시간이 만료되었습니다");
                location.href = "/login/logout.do"; // 로그아웃
               // location.href= /custom/sk/loginAuth.do // skon 전용 로그아웃
                return;
            }).catch(function(err) {
                console.error(err);
            });
            return;
        }
  /*  
        if (time === resetTime) {
            clearTimeout(timer);
           // console.log("Session will be refreshed, resetting timer");
            // 세션을 갱신하고 타이머를 다시 설정
            doTimer(sessionTime); // 새로운 세션 타이머로 다시 시작
            return;
        } */

        --time; // time을 감소
        timer = setTimeout(doTimer, 1000, time); // 다음 호출
    }
    return;
}



</script>