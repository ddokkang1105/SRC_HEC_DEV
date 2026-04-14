<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="true"%>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
    <link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css" />
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
  </head>
  <body>
  	<div class="pdL20 pdR20">
	    <div class="new-form">
	    	<div class="btn-wrap page-title btns">
				전화 정보 팝업
				<button onclick="openRegisterPage()" class="primary">서비스 요청 등록</button>
			</div>
	    	<table class="form-column-8 new-form" style="table-layout:fixed;" cellpadding="0" cellspacing="0" width=100%>
	    		<colgroup>
					<col width="100px">
					<col width="*">
				</colgroup>
				<tr>
					<th class="alignL">전화번호</th>
					<td>
						<c:choose>
							<c:when test="${userInfo.TelNum ne ''}">${userInfo.TelNum}</c:when>
							<c:otherwise>${userInfo.MTelNum}</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<th class="alignL">이름</th>
					<td>${userInfo.UserNAME}</td>
				</tr>
				<tr>
					<th class="alignL">부서</th>
					<td>${userInfo.TeamName}</td>
				</tr>
	    	</table>
	    </div>
	    <div class="mgT10">
		    <div class="page-title">티켓 이력</div>
	    	<div id="layout" style="width: 100%"></div>
	    </div>
	   	
   	</div>
    <script>
    	setData();
    
	    document.querySelector("#layout").style.height = setWindowHeight() - 253+"px";
		window.onresize = function() {
			document.querySelector("#layout").style.height = setWindowHeight() - 253+"px"
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
	  	        { width: 120, id: "SRCode", header: [{ text: "${menu.LN00396}" , align: "center" },{content : "inputFilter"}], align: "center" },
	  	        { id: "Subject", header: [{ text: "${menu.LN00002}" , align: "center" },{content : "inputFilter"}], align: "left" },
	  	        { width: 120, id: "StatusName", header: [{ text: "${menu.LN00027}" , align: "center" },{content : "selectFilter"}], align: "center" },
	  	        { width: 90, id: "RegDate", header: [{ text: "${menu.LN00093}" , align: "center" }], align: "center" },
	  	        { hidden: true, id: "SRID", header: [{ text: "SRID"}]},
	  	        { hidden: true, id: "Status", header: [{ text: "Status"}]},
	  	        { hidden: true, id: "SRType", header: [{ text: "SRType"}]},
	  	        { hidden: true, id: "ReceiptUserID", header: [{ text: "ReceiptUserID"}]},
	  	        { hidden: true, id: "ESType", header: [{ text: "ESType"}]},
	  	    ],
	  	    autoWidth: true,
	  	    resizable: true,
	  	    selection: "row",
	  	    tooltip: false,
	  	});
	    
	  	layout.getCell("a").attach(grid);
	  	
	  	function setData() {
	  		fetch("/jsonDhtmlxListV7.do?sessionUserID=${userInfo.MemberID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&esType=ITSP&srMode=myReq&sqlID=esm_SQL.getESPSearchList")
	  		.then(res => res.json())
	  		.then(data => grid.data.parse(data))
	  	}
	  	
		grid.events.on("cellClick", function(row, column, e) {
			var receiptUserID = row.ReceiptUserID;
			if(receiptUserID == undefined) receiptUserID = "";
			window.open("esrInfoMgt.do?srCode="+ row.SRCode + "&srID="+row.SRID + "&status=" +row.Status + "&srType=" +row.SRType + "&receiptUserID=" + receiptUserID + "&esType=" + row.ESType +"&isPopup=true", row.SRID,"width=1400 height=800 resizable=yes");
		});
		
		function openRegisterPage() {
			opener.openRegisterPage();
			self.close();
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
