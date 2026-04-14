<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />

<!-- 2. Script -->
<script type="text/javascript">
	var skin = "dhx_skyblue";
	var schCntnLayout; //layout적용
	var screenType = "${screenType}";

	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	//===============================================================================
	// BEGIN ::: GRID

	var layout = new dhx.Layout("grdGridAreaWF", { 
			rows: [
				{
					id: "a",
				},
			]
		});
	
		var gridData = ${gridData};
		var grid = new dhx.Grid(null, {
			columns: [
				{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ hidden: true, width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
				{ hidden: true, width: 100, id: "WFDocType", header: [{ text: "${menu.LN00091}" , align: "center" }], align: "center" },
				{ hidden: true, width: 100, id: "WFInstanceID", header: [{ text: "${menu.LN00134} No.", align: "center" }], align: "center" },
				{ fillspace: true, id: "Subject", header: [{ text: "${menu.LN00002}", align: "center" }], align: "left" },
				{ width: 200, id: "CreatorName", header: [{ text: "${menu.LN00060}", align: "center" }], align: "center" },
				{ hidden: true, width: 110, id: "CreatorTeamPath", header: [{ text: "${menu.LN00104}", align: "center" }], align: "center" },
				{ hidden: true,width: 90, id: "CreationTime", header: [{ text: "${menu.LN00013}", align: "center" }] , align: "center"},				
				{ width: 90, id: "Status", header: [{ text: "${menu.LN00065}", align: "center" }], align: "center" },				
				{ hidden: true, width: 80, id: "ProjectID", header: [{ text: "ProjectID", align: "center" }], align: "center" },
				{ hidden: true, width: 80, id: "WFID", header: [{ text: "WFID", align: "center" }], align: "center" },
				{ hidden: true, width: 80, id: "StepInstID", header: [{ text: "StepInstID", align: "center" }], align: "center" },
				{ hidden: true, width: 80, id: "ActorID", header: [{ text: "ActorID", align: "center" }], align: "center" },
				{ hidden: true, width: 80, id: "StepSeq", header: [{ text: "StepSeq", align: "center" }], align: "center" },
				{ hidden: true, width: 80, id: "WFInstanceID", header: [{ text: "WFInstanceID", align: "center" }], align: "center" },
				{ hidden: true, width: 80, id: "LastSeq", header: [{ text: "LastSeq", align: "center" }], align: "center" },
				{ hidden: true, width: 80, id: "SRID", header: [{ text: "SRID", align: "center" }], align: "center" },
				{ hidden: true, width: 80, id: "DocumentID", header: [{ text: "DocumentID", align: "center" }], align: "center" },
				{ hidden: true, width: 80, id: "StatusCode", header: [{ text: "", align: "center" }], align: "center" },
				{ hidden: true, width: 80, id: "DocCategory", header: [{ text: "", align: "center" }], align: "center" }
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data: gridData
		});
		layout.getCell("a").attach(grid);

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
			var statusCode = row.StatusCode;
			var url = "wfDocMgt.do?&docCategory=CS&actionType=view";
			var data = "&projectID="+projectID
						+"&stepInstID="+stepInstID
						+"&actorID="+actorID
						+"&stepSeq="+stepSeq
						+"&wfInstanceID="+wfInstanceID
						+"&wfID="+wfID
						+"&documentID="+documentID
						+"&wfMode=${wfMode}"
						+"&screenType="+screenType
						+"&lastSeq="+lastSeq;
					
			var w = 1200;
			var h = 800; 
			itmInfoPopup(url+data,w,h);
		}
	
	// END ::: GRID	
	//===============================================================================

	//http://192.168.0.10:8090/wfDocMgt.do?y=CS&actionType=view&isPop=Y&isMulti=N&actionType=view
	
	//조회
	function doSearchList(){
	var sqlID = "wf_SQL.getWFInstList";
	var param = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&wfMode=${wfMode}"
			+ "&filter=myWF"
			+ "&sqlID="+sqlID;

		if(screenType != "csrDtl"){
			param += "&actorID=${sessionScope.loginInfo.sessionUserId}";
		}
		
		if("${wfMode}" == "REC") {
			var Now = new Date(); 

			var toDate = Now.getFullYear() + (Now.getMonth() +1 < 10? "0" +  (Now.getMonth() +1): Now.getMonth() +1 ) 
			+ (Now.getDate() < 10? "0" +  Now.getDate(): Now.getDate());

			var Old = new Date(Now.getFullYear(),Now.getMonth() - 3,Now.getDate())
			var fromDate = Old.getFullYear() + (Old.getMonth() +1 < 10? "0" +  (Old.getMonth() +1): Old.getMonth() +1 ) 
			+ (Old.getDate() < 10? "0" +  Old.getDate(): Old.getDate());
			
			param += "&period=1&beforeYmd=" + fromDate + "&thisYmd=" + toDate;			
		}

		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){	
			grid.data.parse(result);	
		},error:function(xhr,status,error){
			console.log("ERR :["+xhr.status+"]"+error);
		}
	});	
	}	

</script>

</head>
<body>
<div id="mainWFList"  style="height:100%;">     
	<div id="gridOTDiv" class="mgB10 clear" style="height:100%; display:flex;">
		<div id="grdGridAreaWF" style="width:100%;height:100%"></div>
	</div>	
</div>	
</body>
</html>
