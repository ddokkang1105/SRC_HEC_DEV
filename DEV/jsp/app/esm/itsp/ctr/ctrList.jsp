<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
  
<script type="text/javascript">
	var srID ="${srID}";
	var scrID ="${scrID}";
	$(document).ready(function() {	

		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 570)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 570)+"px;");
		};

		$('.layout').click(function(){
			var changeLayout = $(this).attr('alt');
			setLayout(changeLayout);
		});
		
	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
	/* CTS 신규 화면 */
	/* function fnOpenctrNewPopup() {
		var url = "registerCTR.do?srID="+srID+"&scrID="+scrID;
	    window.open(url,'ctsNew','width=850, height=615, left=300, top=100,scrollbars=yes,resizable=yes');
	} */
	
	/* CTS 상세 화면 */
	function fnOpenctrDetailPopup(ctrID) {
	    var url = "ctrDetail.do?ctrID="+ctrID;
	    window.open(url,'ctrDetail','width=850, height=750, left=300, top=150,scrollbars=yes,resizable=yes');
	}
	
</script>

</head>

<form name="changeReqListFrm" id="changeReqListFrm" action="#" method="post" onsubmit="return false;" >	
	<div style="overflow:auto;overflow-x:hidden;">
		<div class="countList">
		    <li class="count">Total  <span id="TOT_CNT"></span></li>
			<%-- <div class="floatR mgR10">
			<c:if test="${scrInfo.Status eq 'APREL' && scrInfo.FinTestYN ne 'Y' && scrInfo.RegUserID eq sessionScope.loginInfo.sessionUserId}" >	
			&nbsp;<span id="btnAdd"  class="btn_pack small icon"> <span class="add"></span><input value="Create CTS" type="submit" onclick="fnOpenctrNewPopup()"></span>
			</c:if>	
		  	<c:if test="${(scrInfo.Status eq 'TSCMP' or scrInfo.Status eq 'CTR') && scrInfo.RegUserID eq sessionScope.loginInfo.sessionUserId}" >	
				&nbsp;<span id="btnAdd"  class="btn_pack small icon"> <span class="add"></span><input value="Create CTS" type="submit" onclick="fnOpenctrNewPopup()"></span>
			</c:if>
			</div> --%>
		</div>
	</div>
	
	<div style="width:100%;" id="layout"></div>
	<div id="pagination" style="margin-top: 60px;"></div>
</form>


<script type="text/javascript">

var layout = new dhx.Layout("layout", {
    rows: [
        {
            id: "a",
        },
    ]
});

var gridData = ${gridData};
var grid = new dhx.Grid("grdOTGridArea", {
    columns: [
        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
        { hidden: true, id: "ctrID", header: [{ text: "ctrID" , align: "center" }], align: "center" },
        { width: 100, id: "ctrCode", header: [{ text: "CTS No." , align: "center" }, { content: "inputFilter" }], align: "left" },
        { width: 100, id: "sysArea1NM", header: [{ text: "${sysArea1LabelNM}" , align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 100, id: "sysArea2NM", header: [{ text: "${sysArea2LabelNM}" , align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 120, id: "statusNM", header: [{ text: "상태" , align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 50,id: "urgencyYN", header: [{ text: "긴급" , align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 120,id: "regTName", header: [{ text: "요청자" , align: "center" }, { content: "inputFilter" }], align: "center" },
        { width: 100, id: "regDT", header: [{ text: "요청일" , align: "center" }, { content: "inputFilter" }], align: "center" },
        { width: 120, id: "reviewerTName", header: [{ text: "검토자" , align: "center" }, { content: "inputFilter" }], align: "center" },
        { width: 100, id: "reviewDT", header: [{ text: "검토일" , align: "center" }, { content: "inputFilter" }], align: "center" },
        { width: 120,  id: "approverTName", header: [{ text: "승인자" , align: "center" }, { content: "inputFilter" }], align: "center" },
        { width: 100,  id: "approvalDT", header: [{ text: "승인일" , align: "center" }, { content: "inputFilter" }], align: "center" },
        { width: 100,  id: "aprvStatusNM", header: [{ text: "승인상태" , align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 120,  id: "CTUserNM2", header: [{ text: "실행자" , align: "center" }, { content: "inputFilter" }], align: "center" },
        { width: 100,  id: "CTExeDT", header: [{ text: "실행일" , align: "center" }, { content: "inputFilter" }], align: "center" },
        { width: 50,  id: "ifStatus", header: [{ text: "IF" , align: "center" }], align: "center" },
    ],
    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    data: gridData
});
layout.getCell("a").attach(grid);

// excel 일반
function doExcel() {
	fnGridExcelDownLoad(grid);
}

//row click event
grid.events.on("cellClick", function (row,column,e) {
	fnOpenctrDetailPopup(row.ctrID);
});

// filer search 시 total 값 변경
grid.events.on("filterChange", function(value,colId,filterId){
	$("#TOT_CNT").html(grid.data.getLength());
});

//페이징
var pagination = new dhx.Pagination("pagination", {
    data: grid.data,
    pageSize: 20,
});

$("#TOT_CNT").html(grid.data.getLength());

function urlReload() {
	
	var sqlID = "ctr_SQL.getCTRMst";
	var param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
    + "&srID="+srID
    + "&scrID="+scrID
	+ "&sqlID="+sqlID;
	
	$.ajax({
		url: "jsonDhtmlxListV7.do",
		data: param,
		type:"POST",
		cotentType:"application/json",
		success: function(result){				
			if(grid != ""){
				grid.data.parse(result);
			}
		},error:function(xhr,status,error){
			console.log("ERR :["+xhr.status+"]"+error);
		}
	});
}

function doSearchctrList(){
	urlReload();	
}

</script>