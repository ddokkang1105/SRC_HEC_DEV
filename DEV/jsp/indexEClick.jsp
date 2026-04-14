<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.rathontech.sso.sp.agent.web.WebAgent"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.net.URL"%>
<%@page import="java.util.regex.*"%>
<%@ page import="xbolt.cmm.framework.util.StringUtil"%>

<%String type = request.getParameter("type") == null ? "" : request.getParameter("type");%>
<%String srID = request.getParameter("srID") == null ? "" : request.getParameter("srID");%> 
<%String srType = request.getParameter("srType") == null ? "" : request.getParameter("srType");%> 
<%String esType = request.getParameter("esType") == null ? "" : request.getParameter("esType");%> 

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge; charset=utf-8" />
<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/style.css"/>
<script src="${pageContext.request.contextPath}/cmm/js/jquery/jquery.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/cmm/js/WSKCTI.js" type="text/javascript"></script>
<style type="text/css">html,body {overflow-y:hidden;width:100%;height:100%}</style>
<script type="text/javascript">
var lgnUrl="${pageContext.request.contextPath}/custom/daelim/logindlmForm.do";

let main = "";
let callCenterMain = "";
let seesionMemberID = "";

jQuery(document).ready(function() {
	var olmI = '${olmI}';	// 사번
	var submitForm = document.mainForm;
		
	if(olmI == ""){
		alert("Identification failed");
	}
	
	submitForm.action=lgnUrl;
	submitForm.target="main";
	submitForm.submit();
});

function fnLoginForm() {window.close();}

 /*shkim cti정보 세팅하는곳 */
	function initCTIFunc(employeeNum, telNum, memberID) {
		console.log(employeeNum, telNum);
		seesionMemberID = memberID;
		SetCTIServer("172.18.192.156", "5659",true);
		Login(employeeNum, telNum);
	}
	
	//CTI 에서 호출에 사용하는 함수
	function CloseToServer(){
		 alert("CTI 서버와 연결이 끊어졌습니다.");
	}
	
	function OnLogIn(bSuccess) { 
        var nRet = 0; 
        var strRet = ""; 
        if (bSuccess) { 
            ETC(true);
            console.log("로그인 성공");
            } else { 
            nRet = GetLastErrorCode(); 
            console.log(nRet); 
            strRet = GetLastError(); 
            console.log(strRet); 
                switch (nRet) { 
                    case 1: 
                        alert(strRet); 
                        break; 
                    case 2: 
                        alert(strRet); 
                        break; 
                    case 3: 
                        var bForcedLogout = false; 
                        bForcedLogout = confirm(strRet); 
                        if (bForcedLogout) { 
                            ForceLogout("${sessionScope.loginInfo.sessionEmployeeNm}");
                            break; 
                        } else { 
                            alert("취소하셨습니다."); 
                            break; 
                        } 
                    case 4: 
                        alert(strRet); 
                        break; 
                    default: 
                        alert(strRet); 
                        break; 
                } 
            } 
    } 
	
	function OnConnected() {
	 console.log("OnConnected 호출 / 전화가 연결된 상태");
	// 상담원 상태 '상담중'으로 변경
	 changeStatus("4", "상담중", "4");
	}
	
	function OnDialing(){
		console.log("OnDialing 호출 / 전화를 거는 상태");
		// 상담원 상태 '상담중'으로 변경
		changeStatus("4", "상담중", "4");
	}
	
	let status = "";
	function CTILogout(id, preValue) {
		
		console.log("CTILogout 호출", id);
		status = preValue;

		// 기타 상태일 경우 로그아웃 하지 않음
		if(status !== "22" && status !== "23" && status !== "24" && status !== "25" && status !== "26") {
			// 상담원 상태 '로그아웃'으로 변경
			updateStatus(27, "로그아웃", 15);
		}
		
		Logout(id);
	}
	
	function OnLogout() {
		console.log("OnLogout 호출");
	}
	
	function OnOffHooked() {
		console.log("OnOffHooked 호출");
	}
	
	function OnOnHooked() {
		console.log("OnOnhooked 호출");
	}
	
	function OnDisConnected() {
		console.log("OnDisConnected 호출");
	}
	
	function OnStartTask() {
		console.log("OnStartTask 호출");
		// 상담원 상태 '상담후작업'으로 변경
		changeStatus("13", "상담후 작업", "13");
	}
	
	function completeTask() {
		console.log("completeTask 호출");
// 		CompleteTask();

		// 상담원 상태 '상담대기중'으로 변경
// 		changeStatus("3", "상담 대기중", "3");
	}
	
	function etc(statusCode) {
		// 2026-02-04 콜센터에서 사용할 CTI 상태 '휴식 중' 해제
		Break(false);
		console.log("etc 호출");
		if(statusCode === "3") {
			CompleteTask();
			ETC(false);
		} else {
			ETC(true);
		}
	}
	
	
	// 2026-02-04 콜센터에서 사용할 CTI 상태 '휴식 중' 설정
	function setBreak() {
		console.log("Break 호출");
		ETC(false);
		Break(true);
	}
	
	function answer() {
		if (Answer()) {
		     console.log("패킷전송성공"); 
		    } else { 
		      console.log("패킷전송실패"); 
		    } 
	}
	
	let requestUserID = "";
	let mbrListPop = "";
	let mbrInfoPop = "";
	
	 // 전화받을때, PBX에서 호출하는 함수
	 function OnOffering(_,_,telNum) {
		 console.log("OnOffering 호출");
	 	// 브라우저에서 window.top.mbrListByPhoneNo('010-1234-1234') 로 테스트
		 mbrListPop = window.open("/zDLM_mbrListByPhoneNo.do?telNum="+telNum, telNum,'width=550, height=300, left=300, top=300,scrollbar=yes,resizble=0');
	 }
	
	 function viewMbrInfoPop(memberID) {
	 	requestUserID = memberID;
	 	mbrInfoPop = window.open("/zDLM_viewMbrInfoPop.do?memberID="+memberID,'viewMbrInfoPop','width=550, height=600, left=300, top=300,scrollbar=yes,resizble=0');
	 }
	
	 function openRegisterPage() {
	 	// 등록화면 팝업으로 띄우기
		 window.open("/registerESP.do?&esType=ITSP&srType=REQ&url=/custom/daelim/itsm/registerREQ&procPathID=&actionParameter=resultParameter&resultParameter=completeESP.do&startEventCode=REQ0002&startSortNum=02&isPopUp=Y&isCallCenter=Y&requestUserID="+requestUserID,(new Date()).getTime(),'width=1560, height=800,,scrollbar=yes,resizble=0');
	 }
	 
	 function closeAllPopup() {
		 if(mbrListPop) mbrListPop.close();
		 if(mbrInfoPop) mbrInfoPop.close();
	 }
	 
	 function changeStatus(statusCode, statusName, pbxStatus) {
		main = document.getElementById("main").contentDocument;
		callCenterMain = main.getElementById("zDLM_callCenterMain") && main.getElementById("zDLM_callCenterMain").contentDocument;
		if(callCenterMain) callCenterMain.getElementById(statusCode).checked = true;
		updateStatus(statusCode, statusName, pbxStatus);
	 }
	 
    function updateStatus(statusCode, statusName, pbxStatus) {
   		let data = {
        		STATUS_CD : statusCode,
        		STATUS_NAME : statusName,
        		PBX_CC_USER_STATUS_CD : pbxStatus,
        		memberID : seesionMemberID
        }
        
        fetch('/zDLM_saveCCUserSts.do', {
			method: 'POST',
			body : JSON.stringify(data),
			headers: {
				'Content-type': 'application/json; charset=UTF-8',
			},
		})
		.then((res) => res.json());
    }
    
    function srPopUp() {
    	window.open("esrInfoMgt.do?&srID="+srID+"&srType=" +srType+"&esType="+esType+"&isPopup=true", srID,"width=1400 height=800 resizable=yes");
    }
    
    //운영반영소스 -> 이거 전달 shkim
    function callCTI(reqNum) {
		//console.log(reqNum);
		
		//if (MakeCall('01067010326')) { 
		if (MakeCall(reqNum)) { 
			console.log("패킷전송성공");
			
			//호출한뒤에 cc_user_sts 에서 상태값 확인
			changeStatus("4","상담중","4");
			
		}else{ console.log("패킷전송실패"); } 
	}
</script>
</head><body>

	<form name="mainForm" action="#" method=post target='main'>
		<input type="hidden" id="loginid" name="loginid" value="${olmI}"/>
		<input type="hidden" id="pwd" name="pwd" value="${olmP}"/> 
		<input type="hidden" id="lng" name="lng" value="${olmLng}"/>
		<input type="hidden" id="loginIdx" name="loginIdx" value="${loginIdx}"/>
		<input type="hidden" id="screenType" name="screenType" value="${screenType}"/>	
		<input type="hidden" id="mainType" name="mainType" value="${mainType}"/>	
		<input type="hidden" id="srID" name="srID" value="${srID}"/>
		<input type="hidden" id="srType" name="srType" value="${srType}"/>
		<input type="hidden" id="esType" name="esType" value="${esType}"/>
		<input type="hidden" id="sysCode" name="sysCode" value="${sysCode}"/>	
		<input type="hidden" id="proposal" name="proposal" value="${proposal}"/>
		<input type="hidden" id="status" name="status" value="${status}"/>		
	</form>
	<iframe name="main" id="main" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
</body>
</html>