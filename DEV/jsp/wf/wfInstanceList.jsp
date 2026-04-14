<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<c:url value="/" var="root"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<script>

	var screenType = "${screenType}";
	$(document).ready(function(){	
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 260)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 260)+"px;");
		};
		
		$("#excel").click(function(){fnGridExcelDownLoad();})

		if("${wfInstanceID}" != ""){
			fnWFDetail();
		}
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
	
	//===============================================================================
	// BEGIN ::: GRID

	var layout = new dhx.Layout("grdGridArea", { 
			rows: [
				{
					id: "a",
				},
			]
		});
	
		var gridData = ${gridData};
		var grid = new dhx.Grid(null, {
			columns: [
				{ width: 130, id: "WFInstanceID", header: [{ text: "No." , align: "center" }], align: "center" },
				{ fillspace: true, id: "Subject", header: [{ text: "${menu.LN00002}", align: "center" }], align: "left" },
				{ width: 120, id: "WFDocType", header: [{ text: "${menu.LN00091}", align: "center" }], align: "center" },
				{ width: 120, id: "DocumentNo", header: [{ text: "${menu.LN00134} No.", align: "center" }], align: "center" },
				{ width: 150, id: "CreatorName", header: [{ text: "${menu.LN00060}", align: "center" }], align: "center" },
				{ width: 150, id: "CreatorTeamNM", header: [{ text: "${menu.LN00104}", align: "center" }] , align: "center"},				
				{ width: 150, id: "CreationTime", header: [{ text: "${menu.LN00013}", align: "center" }], align: "center" },				
				{ width: 100, id: "Status", header: [{ text: "${menu.LN00065}", align: "center" }], align: "center" },
				{ hidden: true, width: 100, id: "ProjectID", header: [{ text: "ProjectID", align: "center" }], align: "center" },
				{ hidden: true, width: 100, id: "WFID", header: [{ text: "WFID", align: "center" }], align: "center" },
				{ hidden: true, width: 50, id: "StepInstID", header: [{ text: "StepInstID", align: "center" }], align: "center" },
				{ hidden: true, width: 50, id: "ActorID", header: [{ text: "ActorID", align: "center" }], align: "center" },
				{ hidden: true, width: 50, id: "StepSeq", header: [{ text: "StepSeq", align: "center" }], align: "center" },
				{ hidden: true, width: 50, id: "WFInstanceID", header: [{ text: "WFInstanceID", align: "center" }], align: "center" },
				{ hidden: true, width: 50, id: "LastSeq", header: [{ text: "LastSeq", align: "center" }], align: "center" },
				{ hidden: true, width: 50, id: "SRID", header: [{ text: "SRID", align: "center" }], align: "center" },	
				{ hidden: true, width: 50, id: "DocumentID", header: [{ text: "DocumentID", align: "center" }], align: "center" },	
				{ hidden: true, width: 50, id: "StatusCode", header: [{ text: "", align: "center" }], align: "center" },	
				{ hidden: true, width: 50, id: "DocCategory", header: [{ text: "", align: "center" }], align: "center" },
				{ hidden: true, width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ hidden: true, width: 50, id: "Inhouse", header: [{ text: "inhouse" , align: "center" }], align: "center" },
				{ hidden: true, width: 50, id: "checkbox", header: [{ text: "" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false}
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data: gridData
		});
		layout.getCell("a").attach(grid);
		$("#TOT_CNT").html(grid.data.getLength());

		var pagination = new dhx.Pagination("pagination", {
			data: grid.data,
			pageSize: 50,
		});	

		//그리드ROW선택시
		grid.events.on("cellClick", function(row,column,e){
			if(column.id != "checkbox"){
				gridOnRowSelect(row);
			}
		}); 

		//그리드ROW선택시
		function gridOnRowSelect(row){	
			var status = row.Status;
			var projectID = row.ProjectID;
			var wfID = row.WFID;
			var stepInstID = row.StepInstID;
			var actorID = row.ActorID;
			var stepSeq = row.StepSeq;
			var wfInstanceID = row.WFInstanceID;
			var lastSeq = row.LastSeq;
			var documentID = row.DocumentID;
			var documentNo = row.DocumentNo;
			var statusCode = row.StatusCode;
			var docCategory = row.DocCategory;
			var inhouse = row.Inhouse;
			//var url = "wfDocMgt.do?";
			var url = "${wfURL}.do?";
			var data = "projectID="+projectID+"&pageNum="+$("#currPage").val()
						+"&stepInstID="+stepInstID
						+"&actorID="+actorID
						+"&stepSeq="+stepSeq
						+"&wfInstanceID="+wfInstanceID
						+"&wfID="+wfID
						+"&documentID="+documentID
						+"&documentNo="+documentNo
						+"&wfMode=${wfMode}"
						+"&screenType="+screenType
						+"&lastSeq="+lastSeq
						+"&srID="+documentID
						+"&docCategory="+docCategory
						+"&inhouse="+inhouse
						+"&actionType=view";
						
			if(statusCode == "0") {
				url = "${wfURL}.do?";
				data += "&isPop=Y&isMulti=N&actionType=create&changeSetID="+documentID;
			}
			else if(statusCode == "1") {
				url = "${wfURL}.do?";
				data += "&isPop=Y&isMulti=N&actionType=view";
			}

			var w = 1200;
			var h = 650; 
			itmInfoPopup(url+data,w,h);
		}
	
	// END ::: GRID	
	//===============================================================================

	//조회
	function doSearchList(){
		var period = $('input[name="period"]:checked').val();
		var sqlID = "wf_SQL.getWFInstList";
		var param =  "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"					
					+ "&wfStepID=${wfStepID}"
					+ "&period="+period
					+ "&beforeYmd=${beforeYmd}"
					+ "&thisYmd=${thisYmd}" 
					+ "&wfMode=${wfMode}"
					+ "&filter=${filter}"
					+ "&projectID=${projectID}"
					+ "&sqlID="+sqlID;

		if(screenType != "csrDtl"){
			param += "&actorID=${sessionScope.loginInfo.sessionUserId}";
		}
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

	function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
		$("#TOT_CNT").html(grid.data.getLength());
		fnMasterChk('');
	}
    
    function fnWFDetail(){
		var projectID = "${wfInfoMap.ProjectID}";
		var wfID = "${wfInfoMap.WFID}";	
		var stepInstID = "${wfInfoMap.StepInstID}";;
		var actorID = "${wfInfoMap.ActorID}";
		var stepSeq = "${wfInfoMap.StepSeq}";
		var wfInstanceID = "${wfInfoMap.WFInstanceID}";
		var lastSeq = "${wfInfoMap.LastSeq}";
		var documentID = "${wfInfoMap.DocumentID}";
		var docCategory = "${wfInfoMap.DocCategory}";
		var statusCode = "${wfInfoMap.StatusCode}";
		var url = "wfDocMgt.do?";
		var data = "projectID="+projectID
					+"&stepInstID="+stepInstID
					+"&actorID="+actorID
					+"&stepSeq="+stepSeq
					+"&wfInstanceID="+wfInstanceID
					+"&wfID="+wfID
					+"&documentID="+documentID
					+"&documentNo=${wfInfoMap.documentNo}"
					+"&wfMode=${wfMode}"
					+"&screenType="+screenType
					+"&lastSeq="+lastSeq
					+"&srID="+documentID
					+"&docCategory="+docCategory
					+"&actionType=view";
					
		if(statusCode == "0") {
			url = "${wfURL}.do?";
			data += "&isPop=Y&isMulti=N&actionType=create&changeSetID="+documentID;
		}
		else if(statusCode == "1") {
			url = "${wfURL}.do?";
			data += "&isPop=Y&isMulti=N&actionType=view";
		}

		var w = 1200;
		var h = 650; 
		itmInfoPopup(url+data,w,h);
    }

	// [Approval Request] click : 변경오더 조회 화면 일때
	function goApprovalPop() {
		var url = "getWFCategoryList.do?";
		var data = "isPop=Y";
		var w = 1200;
		var h = 550; 
		itmInfoPopup(url+data,w,h);
	}
	
	// [Approval Request] click : 변경오더 조회 화면 일때
	function goWfStepInfo(wfDocType,wfUrl,wfInstanceID) {
		var loginUser = "${sessionScope.loginInfo.sessionUserId}";
		var url = wfUrl;
		var data = "isNew=Y&wfDocType="+wfDocType+"&isMulti=Y&isPop=Y&categoryCnt=1&wfInstanceID="+wfInstanceID;
		ajaxPage(url,data,"wfInstListDiv");
	}
	
	
</script>

<div id="wfInstListDiv">
<form name="wfIsntFrm" id="wfIstFrm" action="" method="post"  onsubmit="return false;">
	<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<c:if test="${screenType !='csrDtl' }" >
   	<div class="cop_hdtitle mgB10 pdT10" style="border-bottom:1px solid #ccc">
		<h3><img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp; ${title}</h3>
	</div>	
	</c:if>
	<div class="countList">
        <li class="count">Total  <span id="TOT_CNT"></span></li>   
      <li class="floatR pdR20"> 
			<input type="radio" id="all" name="period" value="0" checked OnClick="doSearchList();">&nbsp;All&nbsp;&nbsp;&nbsp;&nbsp; 
    		<input type="radio" id="week" name="period" value="1" OnClick="doSearchList();"> &nbsp;Last 1 week &nbsp;&nbsp;&nbsp;&nbsp;
    		<input type="radio" id="today" name="period" value="2" OnClick="doSearchList();"> &nbsp;Today&nbsp;&nbsp;  
    		&nbsp;<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
	   	 </li>
    </div>   
	<div id="gridDiv" style="width:100%;" class="clear mgB10" >
		<div id="grdGridArea" style="width:100%"></div>
		<div id="pagination"></div>
	</div>
</form>
</div>