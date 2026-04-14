<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="false"%>
<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico" />
<%-- <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/style.css"/> --%>
<script src="${pageContext.request.contextPath}/cmm/js/jquery/jquery.js" type="text/javascript"></script>
<style type="text/css">html,body {overflow-y:hidden;width:100%;height:100%;margin:0;}</style>
<script type="text/javascript">


jQuery(document).ready(function() {	
	
	var data =  `[
    {
	    "DEPTCODE" : "OLM_BU",						
	    "DEPTNAME" : "OLM_BU",						
	    "PARENTDEPTCODE" : "OLM",						
	    "PARENTDEPTNAME" : "OLM Company",						
	    "FULLDEPTCODE" : "OLM_Business",						
	    "FULLDEPTNAME" : "OLM_Business",						
	    "DEPTORDER" : "1",						
	    "STATUS" : "0",						
	    "COMPANYCODE" : "001",						
	    "COMPANYNAME" : "COM",
	    "COUNTRYCODE" : "001",						
	    "COUNTRYNAME" : "COM"
    },
    {
        "USERID" : "111111@111111.111111",						
        "USERNAME" : "KIM",						
        "EMAIL" : "111111@111111.111111",						
        "MOBILE" : "010-1234-5678",						
        "DEPTCODE" : "OLM_BU",						
        "DEPTNAME" : "OLM_BU",						
        "EMPNO" : "EMP111",						
        "GRADECODE" : "1",						
        "GRADENAME" : "ADMIN",						
        "POSITIONCODE" : "789",						
        "POSITIONNAME" : "대리",						
        "RETIREDATE" : "2099-12-31",						
        "COMPANYCODE" : "001",						
        "COMPANYNAME" : "COM", 						
        "TITCODE" : "TIT",						
        "TITNAME" : "TITLE",						
        "COMPTEL" : "007-007-007",						
        "STATUS" : "0",
		"SORTNUM" : "20",
		"JOBTYPE" : "ORIGIN"

    }
]`;
	document.getElementById("jsonData").value = data;
		
});

function sendRequest(){
	var jsonData = document.getElementById("jsonData").value;
	//var apiKey = document.getElementById("apiKey").value;
	var type = document.getElementById("typeInput").value;
	
    document.getElementById("jsonResult").value = "Requesting....";

    // URL
    var sURL = "/olmapi/imSyncMGT.do";
	$.ajax({
		url: sURL,
		type: "POST",
        contentType: "application/json; charset=utf-8",
        headers: {
        	"x-API-key": "123123",
        	"type": type
        },
		data: jsonData,
		success: function(result){
			console.log(result);
			document.getElementById("jsonResult").value = JSON.stringify(result, null, 2);
		},error:function(error){
			//console.log("ERR :["+xhr.status+"]"+error);
		}
	});
}

//Login base64
function base64Encode(str) {
    return btoa(unescape(encodeURIComponent(str)));
}

function submitFormWithBase64() {
	
	const olmI = document.getElementById("olmI_raw").value;
	const teamCode = document.getElementById("teamCode_raw").value;
	const companyCode = document.getElementById("companyCode_raw").value;
	
	// Base64로 인코딩
	const encodedData = {
	    olmI: base64Encode(olmI),
	    teamCode: base64Encode(teamCode),
	    companyCode: base64Encode(companyCode)
	};
	
	const form = document.getElementById("base64Form");
	const jsonInput = document.createElement("input");
	jsonInput.type = "hidden";
	jsonInput.name = "jsonData";
	jsonInput.value = JSON.stringify(encodedData);
	form.appendChild(jsonInput);

	// 폼 제출
	form.submit();
}
</script>

</head>
<body>
	<div>
		<div style="display: flex; flex-direction: row; justify-content: space-around; align-items: center; margin: 70px; gap: 20px;">
			<div style="display: flex; align-items: center; gap: 10px;">
			    <div>API URI : /olmapi/imSyncMGT.do</div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    /&nbsp;Type : <input type="text" id="typeInput" style="width: 200px;" />
			</div>
			<div>
				<button type="button" style="cursor: pointer;" onclick="sendRequest()">Send</button>
			</div>
		</div>

		<div style="display: flex; flex-direction: row; justify-content: space-evenly;">
			<div style="display: flex; flex-direction: column;">
				<span style="margin-bottom : 10px;">Request : </span>
				<textarea id="jsonData" rows="40" cols="70"></textarea>
			</div>
			<div style="display: flex; flex-direction: column;">
				<span style="margin-bottom : 10px;">Response : </span>
				<textarea id="jsonResult" rows="40" cols="70" readonly></textarea>
			</div>
		</div>
		
		<div style="margin-top:50px; text-align:center;">
			<div>API URI : /custom/youngone/index.do</div>
			<form id="base64Form" action="/custom/youngone/index.do" method="post" enctype="application/json">
			    <!-- 사용자 입력값 또는 서버 변수값 -->
			    <input type="text" id="olmI_raw" value="2" placeholder="사번" />
			    <input type="text" id="teamCode_raw" value="YCL_IT" placeholder="팀 코드"  />
			    <input type="text" id="companyCode_raw" value="YCL" placeholder="회사 코드"  />
			
			    <button type="button" onclick="submitFormWithBase64()">Base64 POST 전송</button>
			</form>
		</div>
	</div>

</body>
</html>