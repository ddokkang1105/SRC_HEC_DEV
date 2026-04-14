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
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00123" var="WM00123"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00120" var="WM00120"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00050" var="WM00050"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/> 
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00021" var="WM00021" arguments="Mod "/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00021" var="WM00021D" arguments="Delete "/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00021" var="WM00021B" arguments="Block "/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>

<script type="text/javascript">

	var gridArea;				//그리드 전역변수
	var skin = "dhx_skyblue";
	var fileOption = "${fileOption}";
	var itemFileOption = "${itemFileOption}";
	var schCntnLayout;	//layout적용
	var now;
	
	var userId = "${sessionScope.loginInfo.sessionUserId}";
	
	var Authority = "${sessionScope.loginInfo.sessionAuthLev}";
	var selectedItemLockOwner = "${selectedItemLockOwner}";
	var selectedItemAuthorID = "${selectedItemAuthorID}";
	var selectedItemBlocked = "${selectedItemBlocked}";
	var selectedItemStatus = "${selectedItemStatus}";
	var varFilter = "${varFilter}";
	var itemFileOption = "${itemFileOption}";
	
	$(document).ready(function(){
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 270)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 270)+"px;");
		};		
		
		$("#excel").click(function (){
			fnGridExcelDownLoad();
		});
		
		$("#TOT_CNT").html(grid.data.getLength());
	});
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	function doSearchList(){
		fnReload();
	}
	
	function fnFileDownload(){
		var seq = new Array();
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		
		if(!selectedCell.length){
			alert("${WM00049}");	
		} else {
			for(idx in selectedCell){
				seq[idx] = selectedCell[idx].Seq;
			};
			
			
			fetch("checkDRM.do?seq="+seq+"%type=CHK")
			.then(res => res.text())
			.then(result => {
			   if(result ==="secret"){
				   alert("이 파일은 보안 설정(예: 비밀 레이블)으로 인해 접근이 불가합니다. 파일 소유자에게 문의 해주세요.")
			   }
			   //MIP 확인 후 다운로드 실행 
				var frmType = "${frmType}";
				var url  = "fileDownload.do?seq="+seq;
				if(frmType =="documentDetailFrm"){ 
					ajaxSubmitNoAdd(document.documentDetailFrm, url,"saveFrame");
				}else{
					ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
				}
			  
			}).catch(error =>{
				console.error("DRM 확인 실패:",error);
				alert("DRM 확인 중 오류가 발생했습니다.");
			});
	
		}
	}	
	
	function fnFileUpload(){		
	    var fileCount = document.getElementById("files_upload").files.length;
	    var fileSize = new Array();
	    var fileName = new Array();	
	 	for(var i=0; i<fileCount; i++){
	 		fileSize[i] = document.getElementById("files_upload").files[i].size;
	 		fileName[i] = document.getElementById("files_upload").files[i].name;
	 	}		  
		var files =  $("#files-upload").val();
		var url  = "fileUpload.do?files="+files+"&fileSize="+fileSize+"&fileName="+fileName;
		ajaxSubmit(document.fileMgtFrm, url);
	}	
	
	function fnMultiUpload(){ 
			var browserType="";
			var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
			if(IS_IE11){browserType="IE11";}
			var url="addFilePop.do";
			var data="scrnType=ITM_M&delTmpFlg=Y&docCategory=ITM&browserType="+browserType+"&mgtId="+""+"&id="+$('#DocumentID').val();
			if(browserType=="IE"){fnOpenLayerPopup(url,data,"",400,400);}
			else{openPopup(url+"?"+data,490,410, "Attach File");}
	}
	
	function fnMultiUploadV4(){ 
		var url="addFilePopV4.do";
		var data="scrnType=ITM_M&docCategory=ITM&id="+$('#DocumentID').val();
		openPopup(url+"?"+data,480,510, "Attach File");
	}	

	function goNewItemInfo() {
		var url = "NewItemInfoMain.do";
		var target = "actFrame";
		var data = "s_itemID=${DocumentID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}"; 
		
		ajaxPage(url, data, target);
	}
	
	function fnDeleteFile(){
		if(selectedItemBlocked == "0"){
			var sysFileName = new Array();
			var filePath = new Array();
			var seq = new Array();
			
			var selectedCell = grid.data.findAll(function (data) {
		        return data.checkbox;
		    });
			if(!selectedCell.length){
				alert("${WM00021D}");	
			} else {			
				var chkBlock = "";
				var documentID = "";
				var itemID = "${DocumentID}";
				for(idx in selectedCell){					
					chkBlock = selectedCell[idx].Blocked;
					documentID = selectedCell[idx].DocumentID;
					itemID = "${DocumentID}";
					
					if(chkBlock != "Y" && documentID == itemID){				
						sysFileName[idx] =  selectedCell[idx].SysFile;
						filePath[idx] = selectedCell[idx].FilePath;
						seq[idx] = selectedCell[idx].Seq;
					}
					else if(documentID != itemID) {
						var fileName = selectedCell[idx].FileRealName;						
						var msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00112' var='WM00112' arguments='"+fileName+"'/>";
						alert("${WM00112}"); return;
					}else {
						var fileName = selectedCell[idx].FileRealName;						
						var msg = "<spring:message code='${sessionScope.loginInfo.sessionCurrLangCode}.WM00125' var='WM00125' arguments='${menu.LN00134},Blocked'/>";
						alert("${WM00125}"); return;
					}
					
				}
				if(confirm("${CM00002}")){
					var url = "deleteFileFromLst.do";
					var data = "&itemId=${s_itemID}&sysFile="+sysFileName+"&filePath="+encodeURIComponent(filePath)+"&seq="+seq;
					var target = "subFrame";
					ajaxPage(url, data, target);	
				}
			}
			
		}else{
			if(selectedItemStatus == "REL"){
				 alert("${WM00120}"); // [변경 요청 안된 상태]
		     } else {
		         alert("${WM00050}"); // [승인요청중]
		     }
		}
		
	}
	
	function fnDeleteFileHtml(seq){	
		var divId = "divDownFile"+seq;
		$('#'+divId).hide();
	}
	
	function fnExtFileUpdateCount(seq){
		var url = "extFileUpdateCount.do";
		var data = "&fileSeq="+seq+"&scrnType=ITEM";
		var target = "subFrame";
		ajaxPage(url, data, target);	
	}
	
	function fnAddExtFile() {
		var browserType="";
		//if($.browser.msie){browserType="IE";}
		var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
		if(IS_IE11){browserType="IE11";}
		var url="modExtFilePop.do";
		var data="isNew=Y&browserType="+browserType+"&itemClassCode=${itemClassCode}&DocumentID=${DocumentID}";
		if(browserType=="IE"){fnOpenLayerPopup(url,data,"",1000,400);}
		else{openPopup(url+"?"+data,1000,410, "Modify File");}
	}
	
	function fdModExtFile() {
		if(selectedItemBlocked == "0"){
			var seq = new Array();
			
			var selectedCell = grid.data.findAll(function (data) {
		        return data.checkbox;
		    });
			
			for(idx in selectedCell){		
				seq[idx] = selectedCell[idx].Seq;				
			}
			if(selectedCell.length < 1) {
				alert("${WM00023}");
				return;
			}
			else if(selectedCell.length > 10) {
				alert("${WM00021}");
				return;
			}
		
			var browserType="";
			//if($.browser.msie){browserType="IE";}
			var IS_IE11=!!navigator.userAgent.match(/Trident\/7\./);
			if(IS_IE11){browserType="IE11";}
			var url="modExtFilePop.do";
			var data="seqList="+seq+"&browserType="+browserType;
			if(browserType=="IE"){fnOpenLayerPopup(url,data,"",1000,400);}
			else{openPopup(url+"?"+data,1000,410, "Modify File");}
		
		}
	}
	
	function fnChangeRegMember(){		
		var fileSeqs = new Array();
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedCell.length){
			alert("${WM00023}");	
		} else {
			for(idx in selectedCell){
				fileSeqs[idx] = selectedCell[idx].Seq;
			};
		}
		
		$("#fileSeqs").val(fileSeqs);
		if(fileSeqs != ""){
			var url = "searchPluralNamePop.do?objId=resultID&objName=resultName&UserLevel=ALL"
						+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
			window.open(url,'window','width=340, height=300, left=300, top=300,scrollbar=yes,resizble=0');
		}
	}
	
	function setSearchNameWf(avg1, avg2, avg3, avg4){
		if(confirm("${CM00001}")){
			var url = "updateFileRegMember.do";
			var target = "subFrame";
			var data = "fileSeqs="+$("#fileSeqs").val()+"&memberID="+avg1; 
		 	ajaxPage(url, data, target);
		}
	}

	function fnBlock(){
		var seq = new Array();
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		
		if(!selectedCell.length){
			alert("${WM00021B}");	
		} else {
			for(idx in selectedCell){
				seq[idx] = selectedCell[idx].Seq;
			};
		}
		
		if(confirm("${CM00001}")){	
			var url  = "updateFileBlocked.do";
			var data = "&seq="+seq;
			ajaxPage(url,data,"subFrame");
		}
	}
	
	function editFileName(){		
	    var url = "editFileNamePop.do"; 
	    var option = "width=550, height=570, left=100, top=100,scrollbar=yes,resizble=0";
	    window.open("editFileNamePop.do?DocumentID="+$("#DocumentID").val(), "SelectOwner", option);	 
   }
	
	function fnExtFileDownload(){
		var seq = new Array();
		var selectedCell = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		
		if(!selectedCell.length){
			alert("${WM00049}");	
		} else {
			for(idx in selectedCell){
				seq[idx] = selectedCell[idx].Seq;
			};
		}
		var frmType = "${frmType}";
		var url  = "downloadExtLinkFile.do?seq="+seq;
		if(frmType =="documentDetailFrm"){ 
			ajaxSubmitNoAdd(document.documentDetailFrm, url,"saveFrame");
		}else{
			ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
		}
	}	
	
</script>
</head>
<body>
<form name="fileMgtFrm" id="fileMgtFrm" action="" method="post" onsubmit="return false">
	<input type="hidden" id="itemId" name="itemId" value="${itemId}">
	<input type="hidden" id="itemAthId" name="itemAthId" value="${selectedItemAuthorID}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}"></input> 
	<input type="hidden" id="Blocked" name="Blocked" value="${selectedItemBlocked}" />
	<input type="hidden" id="LockOwner" name="LockOwner" value="${selectedItemLockOwner}" />
	<input type="hidden" id="DocumentID" name="DocumentID" value="${DocumentID}" />
	<input type="hidden" id="fileSeqs" name="fileSeqs" >

   	<c:if test="${backBtnYN != 'N'}" >
	<div class="child_search" >
		<span class="flex align-center">
			<span class="back" onclick="goNewItemInfo()"><span class="icon arrow"></span></span>
	  <b>${menu.LN00019}</b>
	  </span>
	  </div>
	</c:if>
	<div class="countList">
          <li class="count">Total  <span id="TOT_CNT"></span></li>
          <li class="floatR pdR20">			   
	 		<c:if test="${fileOption == 'OLM' or (myItem == 'Y' &&  fileOption != 'ExtLink') }">
				<span class="btn_pack nobg white"><a class="download" onclick="fnFileDownload()" title="Download"></a></span>
			</c:if>	
	   		
			<c:if test="${myItem == 'Y' && itemBlocked ne '2'}">			
				<c:if test="${fileOption != 'ExtLink' and uploadYN != null and uploadYN ne ''}">
					<!-- <span class="btn_pack medium icon"><span class="upload"></span><input value="Upload" type="button" onclick="fnMultiUpload()"></span> -->
					<span class="btn_pack nobg"><a class="upload" onclick="fnMultiUploadV4()" title="Upload"></a></span>
				</c:if>
					<c:if test="${loginInfo.sessionMlvl == 'SYS'}" >
	 		<span class="btn_pack nobg"><a class="gov" onclick="fnChangeRegMember();" title="Ownership"></a></span>
	 		</c:if>
			<c:if test="${fileOption == 'ExtLink'}">				
				<span class="btn_pack nobg"><a class="download" onclick="fnExtFileDownload()" title="Download"></a></span>
				<span class="btn_pack nobg"><a class="add" onclick="fnAddExtFile()" title="Add"></a></span>					
				<span class="btn_pack nobg"><a class="edit" onclick="fdModExtFile()" title="Edit"></a></span>
			</c:if>	
				<span class="btn_pack nobg"><a class="list" onclick="editFileName();" title="Rename"></a></span>
				<span class="btn_pack nobg"><a class="block" onclick="fnBlock()" title="Block"></a></span>				
				<span class="btn_pack nobg white"><a class="del" onclick="fnDeleteFile()" title="Delete"></a></span>
			</c:if>					   
	 		<span class="btn_pack nobg white"><a class="xls"  id="excel" title="Excel"></a></span>
	   		<c:if test="${backBtnYN != 'N'}" >
			</c:if>
		</li>	
     </div>
	 <div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>	
</form>
<iframe name="subFrame" id="subFrame" src="about:blank" style="width:0px;height:0px;display:none" frameborder="0"></iframe>
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
	
	var grid = new dhx.Grid("grid",  {
	    columns: [
	        { width: 50, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center", template: function (text, row, col) { return row.RNUM;} },
	        { width: 30, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], editorType: "checkbox", align: "center", type: "boolean",  editable: true, sortable: false}, 
	        { width: 140, id: "FltpName", header: [{ text: "${menu.LN00091}", align:"center" },{ content: "selectFilter"} ], align: "center"},
	        { width: 100, id: "CSVersion", header: [{ text: "Version", align:"center" },{content: "selectFilter"}], align: "center"},
	        { width: 40, id: "File", header: [{ text: "", align:"center" }], htmlEnable: true, align: "center",
	        	template: function (text, row, col) {
	        		return '<img src="${root}${HTML_IMG_DIR}/btn_file_down.png" width="24" height="24">';
	            }
	        },	        
	        { id: "FileRealName", header: [{text: "${menu.LN00101}", align:"center"},{content : "inputFilter"}], align:"left" },	      
	        { width: 90, id: "LanguageCode",   header: [{ text: "${menu.LN00147}", align:"center"},{ content : "selectFilter" }], align:"center" },	        
	        { width: 90, id: "LastUpdated", header: [{ text: "${menu.LN00070}", align:"center" }], align:"center" },
	        { width: 150, id: "WriteUserNM", header: [{ text: "${menu.LN00060}", align:"center" }], align:"center" },
	        { width: 120, id: "TeamName", header: [{ text: "${menu.LN00018}", align:"center" }], align:"center" },
	        { width: 80, id: "DownCNT", header: [{ text: "${menu.LN00030}", align:"center" }], align:"center" },
	        { width: 80, id: "FileStatus", header: [{text: "${menu.LN00027}", align:"center" },{content : "selectFilter"}], align:"center"},
	        { width: 80, id: "Seq", header: [{ text: "Seq", align:"center" }], align:"center" , hidden:true},
	        { width: 80, id: "RefFileID", header: [{text: "ROOT", align:"center"},{content : "selectFilter"}], align:"center", hidden:true},
	        
	        { id: "Blocked", header: [{text: "Blocked"}], align:"center" ,hidden:true },	 	        
	        { id: "SysFile", header: [{text: "SysFile"}], hidden:true},
	        { id: "FileName", header: [{text: "FileName"}], hidden:true},
	        { id: "FltpCode", header: [{text: "FltpCode"}], hidden:true},
	        { id: "FilePath", header: [{text: "FilePath"}], hidden:true},
	        { id: "DcumentID", header: [{text: "DocumentID"}], hidden:true},
	        { id: "ExtFileURL", header: [{text: "ExtFileURL"}], hidden:true}
	          
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,   
	});
	
	grid.events.on("cellClick", function(row,column,e){
		var extFileURL = row.ExtFileURL;	
		if(column.id == "checkbox") return;
		if(fileOption=="ExtLink"){
			var url  = row.ExtFileURL;						
			var w = 1200;
			var h = 900;
			url = url.replace(/&amp;/gi,"&");
			itmInfoPopup(url,w,h); 
			
			fnExtFileUpdateCount(row.Seq);
		}
		else if("${sessionScope.loginInfo.sessionMlvl}" != "SYS" && "${myItem}" != 'Y' && itemFileOption == "VIEWER"){
			var url = "openViewerPop.do?seq="+row.Seq;
			var w = 1200;
			var h = 900;
			if(extFileURL != "") { 
				w = screen.availWidth-38;
				h = screen.avilHeight;
				url = url + "&isNew=N";	
			} else { url = url + "&isNew=Y"; }			
			itmInfoPopup(url,w,h); 			
		}else{
			if(column.id == "File"){ // 다운로드 이미지 클릭시 					
				var url  = "fileDownload.do?seq="+row.Seq;
				var frmType = "${frmType}";
			
				if(frmType =="documentDetailFrm"){ 
					ajaxSubmitNoAdd(document.documentDetailFrm, url,"subFrame");
				}else{
					ajaxSubmitNoAdd(document.fileMgtFrm, url,"subFrame");
				}
			}else{
				var isNew = "N";								
				var url  = "fileDetail.do?&isNew="+isNew
						+"&seq="+row.Seq
						+"&DocumentID="+row.DocumentID
						+"&itemClassCode=${itemClassCode}"
						+"&selectedItemBlocked="+selectedItemBlocked
						+"&selectedItemAuthorID="+selectedItemAuthorID
						+"&selectedItemLockOwner="+selectedItemLockOwner;
				var w = 1200;
				var h = 500;
				itmInfoPopup(url,w,h); 				
			
			}
		}
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
	 	  	
 	function fnReloadGrid(newGridData){
 		grid.data.parse(newGridData);
 		$("#TOT_CNT").html(grid.data.getLength());
 	}
		
 	const changeEvent = document.createEvent("HTMLEvents");
	changeEvent.initEvent("change", true, true);
	 
	//var headerFilter = grid.getHeaderFilter("Blocked");
	//var element = headerFilter.querySelector("select");
	// element.value = "-";
	//element.dispatchEvent(changeEvent);
		 	
	function fnReload(){
		var sqlID = "fileMgt_SQL.getFile";
		var param = "&DocumentID=${DocumentID}&s_itemID=${DocumentID}&hideBlocked=N"
				+ "&fileListYN=${fileListYN}&rltdItemId=${rltedItemID}"
				+ "&isPublic=N&DocCategory=ITM&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
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