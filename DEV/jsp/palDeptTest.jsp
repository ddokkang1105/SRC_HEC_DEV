<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico" />
<%-- <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/style.css"/> --%>
<script src="${pageContext.request.contextPath}/cmm/js/jquery/jquery.js" type="text/javascript"></script>
<style type="text/css">html,body {overflow-y:hidden;width:100%;height:100%;margin:0;}</style>
<script type="text/javascript">


jQuery(document).ready(function() {	
	
	var data =  `[
	    {
        "DEPT_CD" : "OLM",
        "PDEPT_CD" : "OLM",
        "CDEPT_CD" : "OLM",
        "CDEPT_NM" : "OLM",
        "DEPT_NM" : "OLM",
        "DEPT_NM_E" : "OLM",
        "MGT_EMP_NO" : "OLM",
        "ACTIVE" : "00",
        "SORT_NO" : "1"
    },
    {
        "DEPT_CD" : "OLM2",
        "PDEPT_CD" : "OLM2",
        "CDEPT_CD" : "OLM2",
        "CDEPT_NM" : "OLM2",
        "DEPT_NM" : "OLM2",
        "DEPT_NM_E" : "OLM2",
        "MGT_EMP_NO" : "OLM2",
        "ACTIVE" : "00",
        "SORT_NO" : "2"
    },
    {
        "DEPT_CD" : "OLM3",
        "PDEPT_CD" : "OLM3",
        "CDEPT_CD" : "OLM3",
        "CDEPT_NM" : "OLM3",
        "DEPT_NM" : "OLM3",
        "DEPT_NM_E" : "OLM3",
        "MGT_EMP_NO" : "OLM3",
        "ACTIVE" : "00",
        "SORT_NO" : "3"
    }
]`;
	document.getElementById("jsonData").value = data;
		
});

function sendRequest(){
	var jsonData = document.getElementById("jsonData").value;
	//var apiKey = document.getElementById("apiKey").value;
	
    document.getElementById("jsonResult").value = "Requesting....";

    var sURL = "http://localhost:8094/olmPalDept.do";
	//var sURL = "https://gsdmdev.sk-on.com/olmapi/bplm0001";
	$.ajax({
		url: sURL,
		type: "POST",
        contentType: "application/json; charset=utf-8",
        headers: {
        	"x-API-key": "123123"
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

</script>

</head>
<body>
	<div>
		<div style="display: flex; flex-direction: row; justify-content: space-around; align-items: center; margin: 70px;">
			<div>
				<div> API URI : /olmPalDept.do </div>
				<!--  <div> API KEY :  <input type=text id="apiKey" style="width:200px;";></input></div>-->
			</div>
			<div>
				<button type=button style="cursor:pointer" onclick="sendRequest()">Send</span>
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

	</div>

</body>
</html>