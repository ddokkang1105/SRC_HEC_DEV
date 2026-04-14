<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00009" var="CM00009"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_1" arguments="${menu.LN00033}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_2" arguments="${menu.LN00032}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041_3" arguments="referenceModel"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>

<%@ include file="/WEB-INF/jsp/template/aesJsInc.jsp" %>
<script>

	$(document).ready(function(){	
	});
	
	var pwdEncodeYN = "${pwdEncoding}";
	var pwdTextCheckYN = "${pwdTextCheck}";
	
	function fnCheckRePwd(rePwd){
		
		var newPwd = $("#newPwd").val();
		if(newPwd != rePwd){
			alert("Password is not identical!");  
			return false;
		}
	}
	
	function fnCheckCurrPwd(obj){
		//var orgPwd = "${currentPwd}";
		if(obj == "Y"){
			alert("Current password is wrong!"); 
			$("#orgPwd").focus();
			return false;
		}
		else if(obj == "NONE") {
			alert("Please use a normal route.");
			return false;
		}
		else if(obj == "C"){
			alert("You cannot use the same password as the previous five passwords.");
			return false;	
		}
	}
	
	function changePwd(){
		var url = "changePwd.do";
		var target = "blankFrame";

		if(!passwordCheck()) 
			return false;
		
		
		if(confirm("${CM00001}")){	
			
		    if(pwdEncodeYN == "Y") {
				var aesUtil = new AesUtil(KEYSIZE, ITERATIONCOUNT);
	
				var tempPWD = aesUtil.encrypt(SALT, IV, PASSPHARSE, $("#newPwd").val());
				$("#newPwd").val(tempPWD);
				
				tempPWD = aesUtil.encrypt(SALT, IV, PASSPHARSE, $("#orgPwd").val());
				$("#orgPwd").val(tempPWD);
				
				$("#iv").val(IV);
				$("#salt").val(SALT);
				
				$("#reNewPwd").val("");
		    }
		    
			ajaxSubmitNoAdd(document.changePwdFrm, url, target);
		}
	}
	
	function callbackSave(){
		self.close();
	}
	
	function passwordCheck() {
        
        var userID = $("#loginID").val();
        var password = $("#orgPwd").val();
        var newPassword1 = $("#newPwd").val();
        var newPassword2 = $("#reNewPwd").val();
         
        // 재입력 일치 여부
        if (newPassword1 != newPassword2) {
            alert("The two new password are not identical!");
            return false;
        }

        // 기존 비밀번호와 새 비밀번호 일치 여부
        if (password == newPassword2) {
            alert("The new password should be different from the current password!");
            return false;
        }
        
	    if(pwdTextCheckYN == "Y") {
	        // 길이
	        if(!/^[a-zA-Z0-9!@#$%^&*()?_~]{8,15}$/.test(newPassword1))
	        {
	            alert("Password should be composed of numbers, alpahbet and special characters in 8 ~ 15 length!");
	            return false;
	        }
	        /*
	        // 아이디 포함 여부
	        if(newPassword1.search(userID)>-1)
	        {
	            alert("ID should not be included in the password.");
	            return false;
	        }
	        */
	        var chk1 = 0;
	        var exceptionPw = /[~#$%^&|\'\"<>?:{}]/; // 특수문자

	        // 첫글자 알파벳 소문자/대문자
	    	if(newPassword1.substring(1,1).search(/^[a-zA-Z]+$/) != -1 ){
	    		alert("The first letter of the password must start with a lowercase alphabetic or uppercase letter.");
	            return false;
	    	}
	        // 특수문자 #% =; ~-& $ \'\"| \ <> 사용 불가
	    	if(exceptionPw.test(newPassword1)){
	    		alert("Special characters #% =; ~-& $ \'\"| \ <> Cannot be included.");
	            return false;
	    	}
	    	// 동일한 문자/숫자 5이상, 연속된 문자
	        //if(/(\w)\1\1\1\1/.test(newPassword1) || isContinuedValue(newPassword1,5))
	        if(/(\w)\1\1\1\1/.test(newPassword1))
	        {
	            alert("More than 5  consequent identical letters or numbers are not allowed!");
	            return false;
	        }
	    	
	        if(newPassword1.search(/[0-9]/g) != -1 ) chk1 ++;
	    	if(newPassword1.search(/[a-z]/g)  != -1 ) chk1 ++;
	    	if(newPassword1.search(/[A-Z]/g)  != -1 ) chk1 ++;
	    	if(newPassword1.search(/[!@*()?_]/g)  != -1  ) chk1 ++;
	    	
			if(chk1 < 4){
				alert("The password must contain at least one special character and at least one uppercase and lowercase alphabetic character.");
			    return false;
			}
	         
	    }else{
	        
	    }
        
        return true;

    }
     
    function isContinuedValue(value) {
        var intCnt1 = 0;
        var intCnt2 = 0;
        var temp0 = "";
        var temp1 = "";
        var temp2 = "";
        var temp3 = "";
 
        for (var i = 0; i < value.length-3; i++) {
            temp0 = value.charAt(i);
            temp1 = value.charAt(i + 1);
            temp2 = value.charAt(i + 2);
            temp3 = value.charAt(i + 3);
 
            if (temp0.charCodeAt(0) - temp1.charCodeAt(0) == 1
                    && temp1.charCodeAt(0) - temp2.charCodeAt(0) == 1
                    && temp2.charCodeAt(0) - temp3.charCodeAt(0) == 1) {
                intCnt1 = intCnt1 + 1;
            }
 
            if (temp0.charCodeAt(0) - temp1.charCodeAt(0) == -1
                    && temp1.charCodeAt(0) - temp2.charCodeAt(0) == -1
                    && temp2.charCodeAt(0) - temp3.charCodeAt(0) == -1) {
                intCnt2 = intCnt2 + 1;
            }
        }
        return (intCnt1 > 0 || intCnt2 > 0);
    }
    
    function isContinuedValue(value, maxLength) {
        var intCnt1 = 0;
        var intCnt2 = 0;
        var temp = new Array();
        var check1F = "T";
        var check2F = "T";
 
        for (var i = 0; i < value.length-(maxLength-1); i++) {
            check1F = "T";
            check2F = "T";
        	for(var k=0; k<maxLength; k++){
        		temp[k] = value.charAt(i+k);
        	}
        	for(var k=0; k<maxLength-1; k++){
        		if(temp[k].charCodeAt(0) - temp[k+1].charCodeAt(0) != 1){
        			check1F = "F";
        		}
        		if (temp[k].charCodeAt(0) - temp[k+1].charCodeAt(0) != -1){
        			check2F = "F";
        		}
        	}
            if (check1F == "T") {
                intCnt1 = intCnt1 + 1;
            }
            if (check2F == "T") {
            	intCnt2 = intCnt2 + 1;
            }
        }
        return (intCnt1 > 0 || intCnt2 > 0);
    }
		
</script>
	
<body>
	<form name="changePwdFrm" id="changePwdFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" name="salt" id="salt" value="" />
	<input type="hidden" name="openPWD" id="openPWD" value="${openPWD}" />
	<input type="hidden" name="iv" id="iv" value="" />
	<input type="hidden" id="userID" name="userID" value="${sessionScope.loginInfo.sessionUserId}">
	<input type="hidden" id="pwdTextCheck" name="pwdTextCheck" value= "${pwdTextCheck}">
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;Change Password</p>
	</div>
	<div id="objectInfoDiv"  style="width:100%;overflow:auto;overflow-x:hidden;">
		<table class="tbl_preview mgT10"  width="80%" border="0" cellpadding="0" cellspacing="0"  >
			<tr>
				<th width="30%" style="word-break:break-all">Login ID</th>
				<td width="70%" align="left" class="last">
					<input type="text" id="loginID" name="loginID" value="${sessionScope.loginInfo.sessionLoginId}"  class="text" readOnly  style="width:250px;margin-left=5px;border:0px">	
				</td>
			</tr>
			<tr>
				<th width="30%" style="word-break:break-all">Current Password</th>
				<td width="70%" align="left"  class="last">
					<input type="password" id="orgPwd" name="orgPwd" value="" class="text"  style="width:250px;margin-left=5px;">	
				</td>
			</tr>
			<tr>
				<th width="30%" style="word-break:break-all">New Password</th>
				<td width="70%" align="left" class="last">
					<input type="password" id="newPwd" name="newPwd" value=""  class="text"  style="width:250px;margin-left=5px;">	
				</td>
			</tr>
			<tr>
				<th width="30%" style="word-break:break-all">Confirm Password</th>
				<td width="70%" align="left" class="last">
					<input type="password" id="reNewPwd" name="reNewPwd" value=""  class="text" style="width:250px;margin-left=5px;">	
				</td>
			</tr>
		</table>
	</div>	
	<div  class="alignBTN" id="divUpdateModel" >
			<span class="btn_pack medium icon mgR10"><span class="save"></span>
				<input value="Save" type="submit" onclick="changePwd()"></span>
	</div>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
	</form>
</body>
</html>