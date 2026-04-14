<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>		
	$(document).ready(function(){	
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 354)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 354)+"px;");
		};
		
		$("#excel").click(function(){fnGridExcelDownLoad();});
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('requestTeam', data, 'getReqTeamID', '', 'Select');	
		
  		
		$("input.datePicker").each(generateDatePicker);
		$('#searchValue').keypress(function(onkey){
			if(onkey.keyCode == 13){
				doSearchList();
				return false;
			}
		});
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
	
	function doSearchMyTRList(){
		$("#srMode").val("myTR");
		doSearchList();
	}	
</script>

<div id="srListDiv">
<form name="srFrm" id="srFrm" action="" method="post"  onsubmit="return false;">
	
	<div class="floatL mgT10 mgB12">
		<h3><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;SR 처리현황</h3>
	</div>	
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
	<colgroup>
	    <col width="10%">
	    <col width="40%">
	 	<col width="10%">
	    <col width="40%">
    </colgroup>
     <tr> 
     	<!-- 요청부서  -->
       	<th class="alignL">${menu.LN00026}</th>
        <td class="alignL">     
	        <select id="requestTeam" Name="requestTeam" style="width:250px;">
	            <option value=''>Select</option>
	        </select>
        </td> 
   		<!-- 요청일-->
        <th class="alignL pdL5">${menu.LN00093}</th>     
        <td>     
            <input type="text" id="REG_STR_DT" name="REG_STR_DT" value="${startRegDT}"	class="input_off datePicker stext" size="8"
				style="width:63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="15" >
			
			~
			<input type="text" id="REG_END_DT" name="REG_END_DT" value="${endRegDT}"	class="input_off datePicker stext" size="8"
				style="width: 63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="15">
			
        </td> 
     </tr>
   </table>
	<div class="countList pdT5 pdB5" >
        <li class="count">Total  <span id="TOT_CNT"></span></li>      
        <li class="floatR">
           	&nbsp;<span id="viewSearch" class="btn_pack medium icon"><span class="search"></span><input value="Search" type="submit" onclick="doSearchList();" style="cursor:hand;"></span>
        	<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
        </li>
    </div>
    
	<div id="gridDiv" class="mgB10 clear" class="clear" >
		<div id="grdGridArea"></div>
	</div>
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL5"></div></div>
</form>
</div>
<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid = new dhx.Grid("grid",  {
		columns: [
	        { width: 100, id: "SRCode", header: [{ text: "SR No.", align:"center"}], align:"center" },
	        { width: 150, id: "Subject", header: [{ text: "${menu.LN00002}", align:"center" }]},
	        { width: 100, id: "SRSTSNM", header: [{text: "${menu.LN00027}", align:"center"}], align:"center"},
	        { width: 120, id: "Domain", header: [{ text: "Domain", align:"center" }], align:"center"},
	        { width: 120, id: "System", header: [{ text: "System", align:"center" }], align:"center"},
	        { width: 100, id: "CategoryNM", header: [{ text: "${menu.LN00272}", align:"center" }], align:"center"},
	        { width: 110, id: "SubCategoryNM", header: [{ text: "${menu.LN00273}", align:"center" }], align:"center"},
	        { width: 110, id: "ClassificationName", header: [{ text: "Classification", align:"center" }], align:"center"},
	        { width: 110, id: "SRREGUSERNM", header: [{ text: "${menu.LN00025}", align:"center" }], align:"center"},
	        { width: 120, id: "SRREGTMNM", header: [{ text: "${menu.LN00026}", align:"center" }], align:"center"},
	        { width: 120, id: "SRReqTeamNM", header: [{ text: "등록 ${menu.LN00247}", align:"center" }], align:"center"},
	        { width: 90, id: "SRReceiptTeamNM", header: [{ text: "SR ${menu.LN00227}", align:"center" }], align:"center"},
	        { width: 90, id: "CRReceiptTeamNM", header: [{ text: "CR ${menu.LN00227}", align:"center" }], align:"center"},
	        { width: 90, id: "SRRegDT", header: [{ text: "SR ${menu.LN00093}", align:"center" }], align:"center"},
	        { width: 90, id: "SRRDD", header: [{ text: "${menu.LN00222}", align:"center" }], align:"center"},
	        { width: 90, id: "SRDueDate", header: [{ text: "SR ${menu.LN00221}", align:"center" }], align:"center"},
	        { width: 90, id: "SRCompletionDT", header: [{ text: "SR ${menu.LN00064}", align:"center" }], align:"center"},
	        { width: 90, id: "MinSRRCVDT", header: [{ text: "최초 SR ${menu.LN00077}", align:"center" }], align:"center"},
	        { width: 90, id: "MaxSRRCVDT", header: [{ text: "최종 SR ${menu.LN00077}", align:"center" }], align:"center"},
	        { width: 90, id: "SRRCVCount", header: [{ text: "SR 접수회수", align:"center" }], align:"center"},
	        { width: 100, id: "SRPOINT", header: [{ text: "SR평가 접수", align:"center" }], align:"center"},
	        { width: 90, id: "MinCSRDT", header: [{ text: "결재 ${menu.LN00013}", align:"center" }], align:"center"},
	        { width: 90, id: "MaxAPRVDT", header: [{ text: "결재 ${menu.LN00064}", align:"center" }], align:"center"},
	        { width: 90, id: "CSRCount", header: [{ text: "결재건수", align:"center" }], align:"center"},
	        { width: 90, id: "APRVCount", header: [{ text: "승인건수", align:"center" }], align:"center"},
	        { width: 90, id: "MinCRRegDT", header: [{ text: "최초 CR 생성일", align:"center" }], align:"center"},
	        { width: 90, id: "MaxCRRDD", header: [{ text: "최종 CR 생성일", align:"center" }], align:"center"},
	        { width: 90, id: "MaxCRDueDate", header: [{ text: "CR DueDate", align:"center" }], align:"center"},
	        { width: 90, id: "MinCRReceiptDT", header: [{ text: "CR ${menu.LN00077}", align:"center" }], align:"center"},
	        { width: 90, id: "maxCRCompletionDT", header: [{ text: "CR ${menu.LN00233}", align:"center" }], align:"center"},
	        { width: 90, id: "CRCount", header: [{ text: "CR 회수", align:"center" }], align:"center"},
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false
	});
	
	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 30,
	});
	
	grid.events.on("cellClick", function(row, column, event) {
	    const id = row.id; // 클릭된 행의 ID
	    const ind = column.id; // 클릭된 컬럼 ID (index 대신 id 사용)
	    
	    if (ind !== "1") {
	        if (ind === "11") {
	            goReportList(grid.data.getItem(id).ItemID);
	        } else {
	            if ('${loginInfo.sessionMlvl}' !== "SYS") {
	                fnCheckUserAccRight(
	                    grid.data.getItem(id).ItemID, 
	                    `doDetail(${grid.data.getItem(id).ItemID})`, 
	                    "${WM00033}"
	                );
	            } else {
	                doDetail(grid.data.getItem(id).ItemID);
	            }
	        }
	    }
	});
	
	
	layout.getCell("a").attach(grid);
	
	function doSearchList(){
		var sqlID = "sr_SQL.getProcessingSRStatusList";
		var param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&reqTeamID=" + $("#requestTeam").val()
			+ "&regStartDate=" + $("#REG_STR_DT").val()
			+ "&regEndDate=" + $("#REG_END_DT").val()
			+ "&sqlID="+sqlID;
		
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				grid.data.parse(result);
				$("#TOT_CNT").html(grid.data.getLength());
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	}
</script>