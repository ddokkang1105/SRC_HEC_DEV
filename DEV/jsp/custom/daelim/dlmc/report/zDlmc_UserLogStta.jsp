<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00095" var="WM00095"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>

<style>
 table {
 		 
         border-collapse: collapse;
       
       }

 table th,
 table td {
        padding: 5px 5px 5px 5px;
        border: 0px solid #ccc;
       }
       
</style>

<script type="text/javascript">
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 230)+"px;margin-top: 5%;");
	     
		
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 230)+"px;margin-top: 5%;");
			
		};
		$("input.datePicker").each(generateDatePicker);
		$("#excel").click(function (){
			fnGridExcelDownLoad();
			addLayoutGrid();
			
			
		});
		
		$("#TOT_CNT").html(grid.data.getLength());
	});
	
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
</head>
<body>
<div class="pdL10 pdR10">
<form name="fileMgtFrm" id="fileMgtFrm" action="#" method="post" onsubmit="return false;" >
	<div class="cop_hdtitle pdT10" style="border-bottom:1px solid #ccc">
			<div class="msg"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png">&nbsp;사용자 활용 통계 리포트</div>
	</div>
	<div class="countList">
        
        <table>
        	<tr>
       
           			<th class="alignL">기준일</th>
           			<td class="alignL">     
		            <input type="text" id="REQ_STR_DT" name="REQ_STR_DT" value="${beforeYmd}"	class="input_off datePicker text" size="8"
						style="width:calc((100% - 40px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
					
					~
					<input type="text" id="REQ_END_DT" name="REQ_END_DT" value="${thisYmd}"	class="input_off datePicker text" size="8"
						style="width:calc((100% - 40px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
		         </td>
		           
		           <td >
		           <input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="fnSearch()" value="Search" style="cursor:pointer;">
		           </td>
		           <td >
		           <input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;" onclick="clearload()">
		           </td>
		           
       		</tr>
        </table>
  	<div class="countList" >
		<li class="count">Total<span id="TOT_CNT"></span></li>
		<li class="floatR">				
				&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>		    
			
		</li>
		</div>
    </div> 
    
	<div  id="layout" style="width:100%;"></div>
	<div  id="layout2" style="width:100%;"></div>
	<div id="pagination"></div>		
</form>
<iframe name="subFrame" id="subFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</div>
</body>

<script>


	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid;
	var pagination;
	var gridData = ${gridData};
	
	grid = new dhx.Grid("grid",  {
		 columns: [
		        { width: 50, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center", template: function (text, row, col) { return row.RNUM;} },
		        { id: "CompanyID", header: [{ text: "CompanyID" } ], hidden:true},
		        { id: "TeamType", header: [{ text: "TeamType" }],hidden:true},
		        { id: "MemberID", header: [{ text: "MemberID"}], hidden:true},	        
		        { id: "LoginID", header: [{text: "LoginID"}], hidden:true },	          
		       	{ id: "EmployeeNum", header: [{ text: "${menu.LN00070}"}], hidden:true },
		        { width: 180, id: "TeamName", header: [{ text: "${menu.LN00104}", align:"center" },{ content: "selectFilter"}], align:"center" },
		        { width: 120, id: "UserName", header: [{ text: "${menu.LN00072}", align:"center" },{content:"inputFilter"}], align:"center" },	 
		        { id: "TeamID", header: [{ text: "TeamID"}], hidden:true },
		        { id: "TeamCode", header: [{text: "TeamCode"}], hidden:true},
		        { id: "Authority", header: [{text: "Authority"}], hidden:true},
		        { width:100, id: "AuthorityName", header: [{text: "${menu.LN00149}" , align:"center"},{ content: "selectFilter"}] , align:"center"},
		        { width:80, id: "ManagerCheck", header: [{text: "담당자여부" , align:"center"},{ content: "selectFilter"}] , align:"center"},
		        { width:100,id: "ProcNewCnt", header: [{text: "프로세스 제정", align:"center"}], align:"center"},
		        { width:100,id: "ProcModCnt", header: [{text: "프로세스 개정", align:"center"}], align:"center"},
		        { width:100,id: "BrdCnt", header: [{text: "${menu.LN00376}",align:"center"}], align:"center" },
		        { width:100,id: "L4Visit", header: [{text: "프로세스 방문" ,align:"center"}], align:"center" },
		        { width:100,id: "ProcUpdcnt", header: [{text: "프로세스 수정" ,align:"center"}], align:"center" }
		          
		    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,   
	   
	});
	

	 grid.events.on("filterChange", function(row,column,e,item){
		$("#TOT_CNT").html(grid.data.getLength());
	 });

	 layout.getCell("a").attach(grid);
	 
	 if(pagination){pagination.destructor();}
	 pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});
	 	  
		
	 
	function clearload(){
		 fnClearFilter("ManagerCheck");
		 fnClearFilter("TeamName");
	 	 fnClearFilter("AuthorityName");
	 	
/* 	 	// input 요소 가져오기
	 	var inputFilter = grid.getHeaderFilter("UserName").querySelector('input');

	 	// input 이벤트에 대한 이벤트 리스너 등록
	 	inputFilter.addEventListener('input', function () {
	 	    // 값이 변경될 때마다 "customReset" 이벤트 발생
	 	    var customResetEvent = new Event('customReset');
	 	    inputFilter.dispatchEvent(customResetEvent);
	 	});

	 	// "customReset" 이벤트에 대한 이벤트 리스너 등록
	 	inputFilter.addEventListener('customReset', function () {
	 	    // 값 초기화 또는 다른 초기화 작업 수행
	 	    inputFilter.value = "";
	 	    // 필요한 초기화 로직 추가 가능
	 	}); */
	}
 	function fnReloadGrid(newGridData){
 	    fnClearFilter("TeamName");
 	    fnClearFilter("AuthorityName");
 	    fnClearFilter("ManagerCheck");
 		grid.data.parse(newGridData);
 		
 
 		//console.log(grid.data.parse(newGridData));
 		$("#TOT_CNT").html(grid.data.getLength());
 	
 	}
	
 	function fnClearFilter(columnID) {
 	    var changeEvent = document.createEvent("HTMLEvents");
 	    changeEvent.initEvent("change");
 	    var selectFilter = grid.getHeaderFilter(columnID).querySelector('select');

 	    selectFilter.value = " ";
 
 	
 	    selectFilter.dispatchEvent(changeEvent);
 	   
 	 
 	}
 	
	function fnSearch(){
		let sqlID = "custom_SQL.zDlmc_getLUserLogStta";
		let StartDt = $("#REQ_STR_DT").val();
		let EndDt = $("#REQ_END_DT").val();
		
	 	let param = "&UserType=1&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+ "&StartDt="+StartDt
				+ "&EndDt="+EndDt
				+ "&sqlID="+sqlID;	 		
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadGrid(result);				
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
	}
	

</script>
</html>