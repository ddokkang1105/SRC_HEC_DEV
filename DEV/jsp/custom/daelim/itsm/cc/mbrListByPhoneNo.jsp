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
    		<div class="page-title">사용자 정보</div>
	    	<div class="btn-wrap flex justify-between mgB15">
		    	<table class="new-form" style="table-layout:fixed;" cellpadding="0" cellspacing="0">
		    		<colgroup>
						<col width="60px">
						<col width="120px">
					</colgroup>
					<tr>
						<th class="alignL">전화번호</th>
						<td><input type="text" id="telNum" value="${telNum}" class="text"/></td>
					</tr>
		    	</table>
		    	<div class="btns">
			    	<button onclick="searchUser()" class="tertiary">검색</button>
			    	<button id="answer" class="primary">전화받기</button>
		    	</div>
	    	</div>
	    </div>
	   	<div id="layout" style="width: 100%"></div>
   	</div>
    <script>
    	searchUser();
    
	    document.querySelector("#layout").style.height = setWindowHeight() - 123+"px";
		window.onresize = function() {
			document.querySelector("#layout").style.height = setWindowHeight() - 123+"px"
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
	  	        { width: 120, id: "UserNAME", header: [{ text: "이름" , align: "center" }], align: "center" },
	  	        { width: 120, id: "EmployeeNum", header: [{ text: "사번" , align: "center" }], align: "center" },
	  	        { width: 90, id: "CompanyNM", header: [{ text: "관계사" , align: "center" }], align: "center" },
	  	        { width: 90, id: "TeamNM", header: [{ text: "부서" , align: "center" }], align: "center" },
	  	      	{ hidden:true, width: 0, id: "MemberID", header: [{ text: "MemberID"}]},
	  	    ],
	  	    autoWidth: true,
	  	    resizable: true,
	  	    selection: "row",
	  	    tooltip: false,
	  	});
	    
	  	layout.getCell("a").attach(grid);
	  	
	  	function searchUser() {
	  		let telNum = document.querySelector("#telNum").value;
	  		fetch("jsonDhtmlxListV7.do?sqlID=user_SQL.userList&telNum="+telNum)
	  		.then(res => res.json())
	  		.then(data => {
	  			if(data.length === 1) openMbrInfoPop(data[0].MemberID);
	  			else grid.data.parse(data)
	  		})
	  	}
	  	
		grid.events.on("cellClick", function(row, column, e) {
			openMbrInfoPop(row.MemberID);
		});
		
		function openMbrInfoPop(memberID) {
			opener.viewMbrInfoPop(memberID);
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
	    
 	    document.getElementById("answer").addEventListener("click", function(e) {
 	    	window.opener.answer();
	    })	
    </script>
  </body>
</html>
