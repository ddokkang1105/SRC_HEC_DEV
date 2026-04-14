<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<jsp:include page="/WEB-INF/jsp/template/tagInc.jsp" flush="true"/>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/language.css" />
<!-- dhtmlx7  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<head>
<style>
	#itemDiv > div {
		padding : 0 10px;
	}
	.cont_title{
		border: 1px solid #dfdfdf;
	    border-bottom: 0;
	    padding: 5px 0px;
	    width: 20%;
	    text-align: center;
	    border-radius: 0 10px 0 0;
	}
	#refresh:hover {
		cursor:pointer;
	}
	.tdhidden{display:none;}
	#itemNameAndPath, #functions{
		display:inline;
	}
	

 	.new {
		color:blue;
		font-weight:bold
	}
	.mod {
		color:orange;
		font-weight:bold
	}
	.remain{
	color:#000000;
	}

</style>
<script type="text/javascript">
	var chkReadOnly = true;	
</script>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
<script type="text/javascript">
	$(document).ready(function(){				
		$(".chkbox").click(function() {
		    if( $(this).is(':checked')) {
		        $("#"+this.name).show();
		    } else {
		        $("#"+this.name).hide(300);
		    }
		});
		
		$("#frontFrm input:checkbox:not(:checked)").each(function(){
			$("#"+$(this).attr("name")).css('display','none');
		});
		
		// 초기 표시 화면 크기 조정 
		$("#grdChildGridArea").attr("style","height:"+(setWindowHeight() - 550)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdChildGridArea").attr("style","height:"+(setWindowHeight() - 550)+"px;");
		};
		
//		gridTcInit();	//old	
//		doTcSearchList(); //old 
		var gridData = ${gridData};
		console.log("gridData: "+gridData);
// 		var height = setWindowHeight();
// 		document.getElementById("htmlReport").style.height = (height - 95)+"px";
// 		window.onresize = function() {
// 			height = setWindowHeight();
// 			document.getElementById("htmlReport").style.height = (height - 95)+"px";	
// 		};
	});
	

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	/* 첨부문서, 관련문서 다운로드 */
	function FileDownload(checkboxName, isAll){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		var j =0;
		var checkObj = document.all(checkboxName);
		
		// 모두 체크 처리를 해준다.
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = true;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = true;
			}
		}
		
		// 하나의 파일만 체크 되었을 경우
		if (checkObj.length == undefined) {
			if (checkObj.checked) {
				var checkObjVal = checkObj.value.split(',');
				sysFileName[0] =  checkObjVal[2] + checkObjVal[0];
				originalFileName[0] =  checkObjVal[1];
				filePath[0] = checkObjVal[2]
				seq[0] = checkObjVal[3];
				j++;
			}
		};
		for (var i = 0; i < checkObj.length; i++) {
			if (checkObj[i].checked) {
				var checkObjVal = checkObj[i].value.split(',');
				sysFileName[j] =  checkObjVal[2] + checkObjVal[0];
				originalFileName[j] =  checkObjVal[1];
				filePath[j] = checkObjVal[2];
				seq[j] = checkObjVal[3];
				j++;
			}
		}
		if(j==0){
			alert("${WM00049}");
			return;
		}
		j =0;
		var url  = "fileDownload.do?seq="+seq;
		ajaxSubmitNoAdd(document.frontFrm, url,"blankFrame");
		// 모두 체크 해제
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = false;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = false;
			}
		}
	}
	
	function fileNameClick(avg1, avg2, avg3, avg4, avg5){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		sysFileName[0] =  avg3 + avg1;
		originalFileName[0] =  avg3;
		filePath[0] = avg3;
		seq[0] = avg4;
		
		if(avg3 == "VIEWER") {
			var url = "openViewerPop.do?seq="+seq[0];
			var w = screen.width;
			var h = screen.height;
			
			if(avg5 != "") { 
				url = url + "&isNew=N";
			}
			else {
				url = url + "&isNew=Y";
			}
			window.open(url, "openViewerPop", "width="+w+", height="+h+",top=0,left=0,resizable=yes");
			//window.open(url,1316,h); 
		}
		else {
	
			var url  = "fileDownload.do?seq="+seq;
			ajaxSubmitNoAdd(document.frontFrm, url,"blankFrame");
		}
	}
	
	function fnChangeMenu(menuID,menuName) {
		if(menuID == "management"){
			parent.fnGetMenuUrl("${itemID}", "Y");
		}
	}
	
	function doTcSearchList(){
		var tcd = setTcGridData();fnLoadDhtmlxGridJson(tc_gridArea, tcd.key, tcd.cols, tcd.data,false,false,"","","selectedTcListRow()");
	}
	
	function selectedTcListRow(){	
		var s_itemID = $('#itemID').val();$('#itemID').val("");
		if(s_itemID != ""){tc_gridArea.forEachRow(function(id){ if(s_itemID == tc_gridArea.cells(id, 14).getValue()){tc_gridArea.selectRow(id-1);}
		});}
	}
	
	
	function fnOnCheck(rowId,cellInd,state){
		if(state){
			tc_gridArea.setRowColor(rowId, "#f2f8ff");
		}else{
			tc_gridArea.setRowColor(rowId, "#ffffff");
		}
	}




	
	//===============================================================================
	// BEGIN ::: GRID
	var layout = new dhx.Layout("grdChildGridArea", { 
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
			{ hidden:true, width: 30, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
			{ width: 50, id: "ItemTypeImg", header: [{ text: "${menu.LN00042}" , align: "center"}],htmlEnable:true, align: "center",
	        	template:function (text,row,col){
	        		return  '<img src="${root}${HTML_IMG_DIR_ITEM}/'+row.ItemTypeImg+'" width="18" height="18">';
	        	}	
	        },
			{ width: 100, id: "Identifier", header: [{ text: "${menu.LN00106}", align: "center" },{ content: "inputFilter" }], align: "center" },
			{ width: 600, id: "ItemName", header: [{ text: "${menu.LN00028}" ,align: "center" },{ content: "inputFilter" }], align: "left"},
			{ width: 100, id: "ClassName", header: [{ text: "${menu.LN00016}" ,align: "center" }], align: "center"},
			{ hidden:true,width: 180, id: "PjtName", header: [{ text: "${menu.LN00131}" ,align: "center" }], align: "center"},
			{ width: 180, id: "OwnerTeamName", header: [{ text: "${menu.LN00018}" ,align: "center" }], align: "center"},
			{ hidden:true,width: 180, id: "Name", header: [{ text: "${menu.LN00004}" ,align: "center" }], align: "center"},
			{ width: 150, id: "LastUpdated", header: [{ text: "${menu.LN00070}" ,align: "center" }], align: "center"},
			{ hidden:true,width: 180, id: "GUBUN", header: [{ text: "${menu.LN00042}" ,align: "center" }], align: "center"},
			{ hidden:true,width: 180, id: "SCOUNT", header: [{ text: "SCOUNT", align: "center" }], align: "center" },
		    { hidden:true, width: 180, id: "ClassCode", header: [{ text: "ClassCode", align: "center" }], align: "center" },

		    { width: 100, id: "ItemStatusText", header: [{ text: "${menu.LN00027}" , align: "center" }, { content: "selectFilter" }], htmlEnable: true, 
	        	 mark: function (cell, data) { 
	        		 if(cell==='신규(작업 중)'){return "new";}
	        		 else if (cell==='변경 중') {
						return "mod"; }
	        		 else 
	        			 return "remain";
	        		  },align: "center"},
		    { hidden:true,width: 180, id: "Status", header: [{ text: "Status", align: "center" }], align: "center" },
		    { hidden:true,width: 180, id: "ItemID", header: [{ text: "ItemID", align: "center" }], align: "center" },
		    { hidden:true,width: 180, id: "AuthorID", header: [{ text: "AuthorID", align: "center" }], align: "center" },
		    { hidden:true,width: 180, id: "Blocked", header: [{ text: "Blocked", align: "center" }], align: "center" },
		    { hidden:true,width: 180, id: "ItemTypeCode", header: [{ text: "ItemTypeCode", align: "center" }], align: "center" },
		    { hidden:true,width: 180, id: "ChangeMgt", header: [{ text: "ChangeMgt", align: "center" }], align: "center" },
	
			{ width: 50, id: "FileIcon", header: [{ text: "File" , align: "center"}],htmlEnable:true, align: "center",
	        	template:function (text,row,col){
	        		return  '<img src="${root}${HTML_IMG_DIR_ITEM}/'+row.FileIcon+'" width="8" height="13">';
	        	}	
	        },
		],
		autoWidth: true,
		resizable: true,
		selection: "row",
		tooltip: false,
		data: gridData
	});
	layout.getCell("a").attach(grid);
	grid.events.on("cellClick", function(row, column, e) {
	
	    	gridOnRowSelect(row,column);
	    
	});
// END ::: GRID	
//===============================================================================
	
	function gridOnRowSelect(row,col){
	
	
		if(col.id != "checkbox" && col.id != "FileIcon"){
			doDetail(row.ItemID, row.ClassCode);
		}
		else if(col.id == "FileIcon") {
			var fileCheck = row.FileIcon;
            console.log(fileCheck);
			if(fileCheck.indexOf("blank.gif") < 1) {
				var url = "selectFilePop.do";
				var data = "?s_itemID="+row.ItemID; 
			   
			    var w = "650";
				var h = "350";
			    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");	
			}
		}
		else{
			tranSearchCheck = false;
		}
	}
	
	
	
	
	
	function doDetail(avg1, avg2){
		var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+avg1+"&scrnType=pop";
		var w = 1200;
		var h = 900;
		itmInfoPopup(url,w,h,avg1);
		
	}
	
	function fnOpenTeamInfoMain(teamID){
		var w = "1200";
		var h = "800";
		var url = "orgMainInfo.do?id="+teamID;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function fnOpenAuthorInfo(authorID) {
		var url = "viewMbrInfo.do?memberID="+authorID;		
		window.open(url,'window','width=1200, height=700, left=400, top=100,scrollbar=yes,resizble=0');
	}
</script>
<!-- BIGIN :: -->
<form name="frontFrm" id="frontFrm" action="#" method="post" onsubmit="return false;" style="height: 100%;"> 
	<div id="htmlReport" style="width:100%;overflow-y:auto;overflow-x:hidden;">
		<div id="itemDiv">
			<div style="height: 22px; padding-top: 10px; width: 100%;">
				<ul>
					<li class="floatR pdR20">
						<input type="checkbox" class="mgR3 chkbox" name="process" id="process_chk" checked><label for="process_chk" class="mgR3">${menu.LN00005 }</label>
						<input type="checkbox" class="mgR3 chkbox" name="subItem" id="subItem_chk" checked><label for="subItem_chk" class="mgR3">${menu.LN00006 }</label>
						<input type="checkbox" class="mgR3 chkbox" name="note" id="note_chk" checked><label for="note_chk" class="mgR3">${attrNameMap.AT00008}</label>
						<input type="checkbox" class="mgR3 chkbox" name="file" id="file_chk" checked><label for="file_chk" class="mgR3">${menu.LN00019 }</label>
					</li>
				</ul>
			</div>
			<!-- BIGIN :: 기본정보 -->
			<div id="process" class="mgB30">
				<p class="cont_title">기본 정보</p>
				<table class="tbl_preview mgB30">
					<colgroup>
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col width="15%">
					</colgroup>
					<tr>
						<th>프로세스 No.</th>
						<td class="alignL pdL10">${prcList.Identifier}</td>
						<th>${menu.LN00016 }</th>
						<td class="alignL pdL10">${prcList.ClassName}</td>
						<th>Version</th>
						<td class="alignL pdL10">${prcList.Version}</td>
						<th>${menu.LN00070 }</th>
						<td class="alignL pdL10">${prcList.LastUpdated}</td>
					</tr>
					<tr>
						<th>${menu.LN00352}</th>
						<td class="alignL pdL10">${prcList.TeamName}</td>
						<th>${menu.LN00018}</th>
						<td class="alignL pdL10" style="cursor:pointer;color: #0054FF;text-decoration: underline;"  OnClick="fnOpenTeamInfoMain(
						<c:if test="${accMode eq 'OPS' || accMode eq '' }">${prcList.AuthorTeamID}</c:if>
						<c:if test="${accMode eq 'DEV'}">${prcList.OwnerTeamID}</c:if>
						)" >${prcList.OwnerTeamName}</td>
						<th>${menu.LN00004}</th>
						<td class="alignL pdL10" id="authorInfo" style="cursor:pointer;_cursor:hand;color: #0054FF;text-decoration: underline;" onclick="fnOpenAuthorInfo(${prcList.AuthorID})">${prcList.Name} </td>
						<th>${menu.LN00027}</th>
						<td class="alignL pdL10">${prcList.StatusName}</td>
					</tr>
					<tr>
						<th>${menu.LN00036 }</th>
						<td class="alignL pdL10" colspan="7">
							<c:set value="1" var="no"/>
							<c:forEach var="list" items="${roleList}">
								<c:if test="${accMode eq 'OPS' || accMode eq '' }">
									<c:if test="${list.Assigned eq '2'}">
									<c:if test="${no ne 1}">&#44; </c:if><span style="cursor:pointer;_cursor:hand;color: #0054FF;text-decoration: underline;" onclick="fnOpenTeamInfoMain(${list.TeamID})">${list.TeamNM}</span><c:set var="no" value="${no+1}"/>
									</c:if>
								</c:if>
								<c:if test="${accMode eq 'DEV'}">
									<c:if test="${list.Assigned ne '0'}">
									<c:if test="${no ne 1}">&#44; </c:if><span style="cursor:pointer;_cursor:hand;color: #0054FF;text-decoration: underline;" onclick="fnOpenTeamInfoMain(${list.TeamID})">${list.TeamNM}</span><c:set var="no" value="${no+1}"/>
									</c:if>
								</c:if>
							</c:forEach>
						</td>
					</tr>
					<c:if test="${dimResultList.size() > 0}">
						<c:forEach var="dimList" items="${dimResultList}" varStatus="status">
							<tr>
								<th>${dimList.dimTypeName}</th>
								<td class="alignL pdL10" colspan="7">
									${dimList.dimValueNames}
								</td>
							</tr>
						</c:forEach>
					</c:if>
				</table>
				<p class="cont_title">프로세스 정의</p>
				<table class="tbl_preview">
					<tr>
						<div style="height:150px;">
							<textarea class="tinymceText" id="description" name="description" readonly="readonly">${attrMap.AT00003}</textarea>
						</div>
					</tr>
				</table>
			</div>
			
			<!-- 하위항목 --> 
			<div id="subItem" class="mgB30">
				<p class="cont_title">Activity</p>
				<div id="gridDiv" class="mgB10 clear">
					<div id="grdChildGridArea" style="width:100%"></div>
				</div>
			</div>
			
			<!-- 참고사항 --> 
			<div id="note" class="mgB30">
				<p class="cont_title">${attrNameMap.AT00008}</p>
				<table class="tbl_preview">
					<tr>
						<div style="height:150px;">
							<textarea class="tinymceText" id="AT00008" name="AT00008" readonly="readonly" >${attrMap.AT00008}</textarea>
						</div>
					</tr>
				</table>
			</div>
			
				<!-- 첨부 및 관련 문서 --> 
			<div id="file" class="mgB30">
				<p class="cont_title">${menu.LN00019 }</p>
				<table class="tbl_preview">
					<colgroup>
						<col width="5%">
						<col width="15%">
						<col width="60%">
						<col width="10%">
						<col width="10%">
					</colgroup>	
					<tr>
						<th>No</th>
						<th>문서유형</th>
						<th>문서명</th>
						<th>작성자</th>
						<th>등록일</th>
					</tr>
					<c:set value="1" var="no" />
					<c:forEach var="fileList" items="${attachFileList}" varStatus="status">
						<tr>
							<td>${no }</td>
							<td>${fileList.FltpName}</td>
							<td class="alignL pdL10 flex align-center">
									<span class="btn_pack small icon mgR20"  onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.Seq}','${fileList.ExtFileURL}');">
									<c:set var="FileFormat" value="${fileList.FileFormat}" />
										<span class="
												<c:choose>
													<c:when test="${fn:contains(FileFormat, 'do')}">doc</c:when>
													<c:when test="${fn:contains(FileFormat, 'xl')}">xls</c:when>
													<c:when test="${fn:contains(FileFormat, 'pdf')}">pdf</c:when>
													<c:when test="${fn:contains(FileFormat, 'hw')}">hwp</c:when>
													<c:when test="${fn:contains(FileFormat, 'pp')}">ppt</c:when>
													<c:otherwise>log</c:otherwise>
												</c:choose>
														"></span>
									</span>
									<span style="cursor:pointer;margin-left: 10px;" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.Seq}','${fileList.ExtFileURL}');">${fileList.FileRealName}</span>
									(<span id="fileSize">${fileList.FileSize}</span>)
							</td> 
							<td>${fileList.WriteUserNM}</td>
							<td>${fileList.LastUpdated}</td>
						</tr>
					<c:set var="no" value="${no+1}"/>
					</c:forEach>
				</table>
			</div>
		</div>
	</div>
</form>
</div>
</head>
<iframe id="saveFrame" name="saveFrame" style="display:none" frameborder="0"></iframe>
