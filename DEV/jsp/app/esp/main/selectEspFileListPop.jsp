<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>
<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<!-- Dhtmlx grid  upgrade  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 100)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 100)+"px;");
		};

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
	
	function fnSelectFile(){
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		
		if(!selectedCell.length){
			alert("${WM00023}");
			return false;
		}
		var seqs = new Array();	
		var fileNames = new Array();
		
		for(idx in selectedCell){
			seqs.push(selectedCell[idx].Seq);
			fileNames.push("<BR>" + selectedCell[idx].FileRealName);
		};
		
		opener.fnSetSelectedFile(seqs,fileNames);
		self.close();
		
	}
 	
</script>
</head>
<body>
<div style="djustify-content: center;width: 98%" class="mgL10">
	<div class="child_search" >
		<span class="flex align-center">
			<span class="back"><span class="icon arrow"></span></span>
	  <b>${menu.LN00019}</b>
	  </span>
	</div>
	<div class="countList">
		<div>
			<li class="count">Total  <span id="TOT_CNT"></span></li>
          	<li class="floatR">		
				<span class="btn_pack nobg"><a class="add" onclick="fnSelectFile()" title="Add"></a></span>		
			</li>
		</div>
	</div>
	<div style="width: 88%;" id="layout"></div>
</div>
</body>

<script type="text/javascript">
		var layout = new dhx.Layout("layout", {
			rows : [ {
				id : "a",
			}, ]
		});	
		var gridData = ${gridData}; 

		var grid = new dhx.Grid(null, {
			  columns: [
			        { width: 40, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
			        { width: 50, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
			        { minWidth: 100, id: "FileRealName", header: [{ text: "파일명" , align: "center"}], align: "left"},
			      
			        { width:120, id: "FltpNM", header: [{ text: "${menu.LN00091}" , align: "center" }], align: "center"},
			        { width:120, id: "CompanyName", header: [{ text: "${menu.ZLN0173}" , align: "center" }], align: "center"},
			        { width:120, id: "SpeCodeNM", header: [{ text: "Activity" , align: "center" }], align: "center"},
			        { width:100, hidden: true, id: "Seq", header: [{ text: "Seq" , align: "center" }], align: "center"}
			  
			    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    data: gridData
		});
		
		layout.getCell("a").attach(grid);
		
		$("#TOT_CNT").html(grid.data.getLength());
		
		
		grid.data.sort({
		    by: "RNUM",
		    dir: "asc"
		})
		
		//row선택 이벤트
		grid.events.on("cellClick", function(row, column, e) {
		    if (column.id ==="down") {
		    	fnDownload(row);
		    }else{
		    	if(column.id ==="SRCode"||column.id ==="Subject"){
		    		var srID = row.DocumentID;
		    		doDetail(srID);
		    		
				/* 	var seq = row.Seq;
					var documentID = row.DocumentID;
	
					if('${loginInfo.sessionMlvl}'!="SYS"){
						fnCheckUserAccRight(documentID, "fnDocumentDetail("+seq+","+documentID+")", "${WM00033}");
					}else{
						fnDocumentDetail(seq, documentID );
					} */
		    	}

			}
		});

/* 		function fnDocumentDetail(seq, documentID ){
		var isNew = "N";					
		var url  = "documentDetail.do?isNew"+isNew
				+"&seq="+seq+"&DocumentID="+encodeURIComponent(documentID)
				+"&pageNum=" +$("#currPage").val()
				+"&itemTypeCode=${itemTypeCode}&fltpCode=${fltpCode}"
				+"&docType=" + encodeURIComponent(docType)
				+"&screenType=" + encodeURIComponent(screenType)
				+"&isMember=" + encodeURIComponent("${isMember}");
		var w = 1200;
		var h = 500;
		itmInfoPopup(url,w,h); 
	} */
	function doDetail(srID){
		const isPopup = 'true';
		var url = "esrInfoMgt.do";
		var data = "&srID="+srID + "&isPopup=true";
		
		isPopup ? window.open(url+"?"+data,srID,"width=1400 height=800 resizable=yes") : ajaxPage(url, data, "srListDiv");
	}
		
		function fnDownload(row){
		   var seq = row.Seq;
			var url  = "fileDownload.do?seq="+seq;
		
			 if( '${loginInfo.sessionMlvl}' != "SYS"){
				fnCheckUserAccRight(documentID, "fnFileDownloadRow("+seq+")", "${WM00033}");
			}else{
				fnFileDownloadRow(seq);
			} 
		}
		
		
		function fnFileDownload(){
			var cnt  = grid.data.findAll(function (data) {
				return data.RNUM; 
			});
			var originalFileName = new Array();
			var seq = new Array();
			var chkVal;
			var j =0;
			var itemIDs = new Array();
			var checkLength  = grid.data.findAll(function (data) {
				return data.checkbox; 
			});

			if (checkLength == 0) {
				alert("${WM00049}");
				return;
			}

				for(idx in checkLength){
					chkVal = checkLength[idx].checkbox;
					
					if(chkVal === true){
						originalFileName[j] = checkLength[idx].FileRealName; // orignalfile
						seq[j] =  checkLength[idx].Seq; 
						itemIDs[j] = checkLength[idx].DocumentID; 
						j++;
					}
				}
	
			if( '${loginInfo.sessionMlvl}' != "SYS"){
				fnCheckItemArrayAccRight(seq, itemIDs); // 접근권한 체크후 DownLoad
			}else{
				var url  = "fileDownload.do?seq="+seq;
				var frmType = "${frmType}";
				ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
			} 
		}

		// file upload callback
		function fnCallBack(){ 
			doSearchList();
		}

		//조회
	 	function doSearchList(){ 
			var sqlID="esm_SQL.espFile";

			var param =
/* 						+"&authLev=&authLev=${sessionScope.loginInfo.sessionAuthLev}"
						+ "&screenType="+screenType			
						+ "&isPublic="+isPublic
						+ "&DocCategory=${DocCategory}"
						+ "&showFilePath=N" */
						"&sqlID="+sqlID;    
						
				param += "&reg_STR_DT="+ $("#REG_STR_DT").val();
				param += "&reg_END_DT="+ $("#REG_END_DT").val();
				param += "&fileNM="+ $("#FileName").val();
				param += "&projectID="+ $("#parent").val();
				param += "&searchValue=" + $("#searchValue").val();
				param += "&SRCode="+$("#ticketNo").val();
				param += "&fltpCode=" + $("#fltp").val();
		
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
	 		grid.data.sort({
			    by: "RNUM",
			    dir: "asc"
			})
			$("#TOT_CNT").html(grid.data.getLength());
	 		fnMasterChk('');
	 	}
		
		function fnTicketNoHideShow(){
			if( document.all("ticketNoHideShow").checked == true){			
				grid.showColumn("SRCode");
				grid.showColumn("Subject");
			}else{
				grid.hideColumn("SRCode");
				grid.hideColumn("Subject");
			}
		}
		
</script>
</html>