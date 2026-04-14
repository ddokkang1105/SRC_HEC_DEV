<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico" />
<%-- <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/style.css"/> --%>
<script src="${pageContext.request.contextPath}/cmm/js/jquery/jquery.js" type="text/javascript"></script>
<style type="text/css">html,body {overflow-y:hidden;width:100%;height:100%;margin:0;}</style>
<script type="text/javascript">


jQuery(document).ready(function() {	
	
	var data =  `{
	    "DOC_NO" : "BPLM DOC",
	    "REV_NO" : "0",
	    "REV_DESC" : "rev upgrade",
	    "DOC_AREA" : "M",
	    "DOC_TYP" : "WS",
	    "DOC_PROC" : "E",
	    "DOC_LVL" : "4",
	    "DOC_NAME" : "GSDM DOC",
	    "DOC_DOMAIN" : "CR",
	    "DOC_SITE" : "HQ",
	    "DOC_REG_ID" : "op01320",
	    "NCT_TYP" : "Y",
	    "DOC_SUB_PROC" : "123123123",
	    "DOC_SUMMARY" : "DOC",
	    "OP_TYP" : "C",
	    "MODEL" : "BPLM_2025",
	    "LINE_NO" : "1(1)",
	    "PLANTS" : [{
	        "PLANT_ID" : "SCO1",
	        "PLANT_NAME" : "SCO1"
	    }],
	    "FILES" : [{
	        "FILE_PATH" : "11111",
	        "SND_FILE_NAME" : "11111.txt",
	        "ORG_FILE_NAME" : "3.xlsx"
	    }]
	}`;
	document.getElementById("jsonData").value = data;
		
});

function sendRequest(){
	var jsonData = document.getElementById("jsonData").value;
	//var apiKey = document.getElementById("apiKey").value;
	
    try {
        var jsonObject = JSON.parse(jsonData);
        console.log("Converted JSON Object:", jsonObject);
    } catch (e) {
        console.error("Invalid JSON format:", e);
        alert("Invalid JSON format!"); 
        return; 
    }
    document.getElementById("jsonResult").value = "Requesting....";

    //var sURL = "http://localhost:8094/olmapi/bplm0001";
	var sURL = "https://gsdmdev.sk-on.com/olmapi/bplm0001";
	$.ajax({
		url: sURL,
		type: "POST",
        contentType: "application/json; charset=utf-8",
        headers: {
        	"x-API-key": "123123"
        },
		data: JSON.stringify(jsonObject),
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
				<div> API URI : /olmapi/bplm0001 </div>
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