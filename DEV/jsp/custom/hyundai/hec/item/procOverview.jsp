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
		
		gridTcInit();		
		doTcSearchList();
		
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
				filePath[0] = checkObjVal[2];
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
	
	function gridTcInit(){	
		var tcd = setTcGridData();
		tc_gridArea = fnNewInitGrid("grdChildGridArea", tcd);
		//tc_gridArea.enableHeaderImages(true);
		tc_gridArea.setImagePath("${root}${HTML_IMG_DIR}/item/");
		tc_gridArea.setIconPath("${root}${HTML_IMG_DIR}/item/");

		fnSetColType(tc_gridArea, 20, "img");
		fnSetColType(tc_gridArea, 2, "img");
// 		fnSetColType(tc_gridArea, 1, "ch");
		
		tc_gridArea.enableRowsHover(true,'grid_hover');
		tc_gridArea.enableMultiselect(true);
		
		tc_gridArea.setColumnHidden(1, true);
		tc_gridArea.setColumnHidden(6, true);
		tc_gridArea.setColumnHidden(8, true);
		tc_gridArea.setColumnHidden(10, true);
		tc_gridArea.setColumnHidden(11, true);
		tc_gridArea.setColumnHidden(12, true);
		tc_gridArea.setColumnHidden(14, true);
		tc_gridArea.setColumnHidden(15, true);
		tc_gridArea.setColumnHidden(16, true);
		tc_gridArea.setColumnHidden(17, true);

		tc_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		tc_gridArea.attachEvent("onCheckbox",fnOnCheck);
	}

	function fnOnCheck(rowId,cellInd,state){
		if(state){
			tc_gridArea.setRowColor(rowId, "#f2f8ff");
		}else{
			tc_gridArea.setRowColor(rowId, "#ffffff");
		}
	}

	function setTcGridData(){
		var tcResult = new Object();
		tcResult.title = "${title}";
		tcResult.key = "item_SQL.getSubItemList";
		tcResult.header = "${menu.LN00024},#master_checkbox,${menu.LN00042},${menu.LN00106},${menu.LN00028},${menu.LN00016},${menu.LN00131},${menu.LN00018},${menu.LN00004},${menu.LN00070},${menu.LN00042},SCOUNT,ClassCode,${menu.LN00027},Status,ItemID,AuthorID,Blocked,ItemTypeCode,ChangeMgt,File";
		tcResult.cols = "CHK|ItemTypeImg|Identifier|ItemName|ClassName|PjtName|OwnerTeamName|Name|LastUpdated|GUBUN|SCOUNT|ClassCode|ItemStatusText|Status|ItemID|AuthorID|Blocked|ItemTypeCode|ChangeMgt|FileIcon";
		tcResult.widths = "30,30,30,130,*,100,120,140,140,110,0,0,0,100,0,0,0,0,0,0,40";
		tcResult.sorting = "int,int,str,str,str,str,str,str,str,str,str,int,str,str,str,str,str,str,str,str,str";
		tcResult.aligns = "center,center,center,left,left,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center";
		tcResult.data = "s_itemID=${itemID}"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"				
			        + "&option="     + $("#option").val()
			        + "&filterType=${filterType}"
			        + "&TreeDataFiltered=${TreeDataFiltered}"  
			        + "&defDimTypeID=${defDimTypeID}"
			        + "&defDimValueID=${defDimValueID}"      
			        + "&searchKey="     + $("#searchKey").val()
			        + "&searchValue="     	+ $("#searchValue").val()
			        + "&showTOJ=${showTOJ}"
			        +"&showElement=${showElement}";
		return tcResult;
	}
	function gridOnRowSelect(id, ind){
		if(ind != 1 && ind != 20){
			doDetail(tc_gridArea.cells(id, 15).getValue(), tc_gridArea.cells(id, 12).getValue());
		}
		else if(ind == 20) {
			var fileCheck = tc_gridArea.cells(id,20).getValue();

			if(fileCheck.indexOf("blank.gif") < 1) {
				var url = "selectFilePop.do";
				var data = "?s_itemID="+tc_gridArea.cells(id, 15).getValue(); 
			   
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
	
	
</script>
<!-- BIGIN :: -->
<form name="frontFrm" id="frontFrm" action="#" method="post" onsubmit="return false;" style="height: 100%;"> 
	<div id="htmlReport" style="width:100%;overflow-y:auto;overflow-x:hidden;">
		<div id="itemDiv">
			<div style="height: 22px; padding-top: 10px; width: 100%;">
				<ul>
					<li class="floatR pdR20">
						<input type="checkbox" class="mgR3 chkbox" name="process" id="process_chk" checked><label for="process_chk" class="mgR3">기본정보</label>
						<input type="checkbox" class="mgR3 chkbox" name="subItem" id="subItem_chk" checked><label for="subItem_chk" class="mgR3">${menu.LN00006 }</label>
						<input type="checkbox" class="mgR3 chkbox" name="note" id="note_chk" checked><label for="note_chk" class="mgR3">참고사항</label>
						<input type="checkbox" class="mgR3 chkbox" name="fileList" id="file_chk" checked><label for="file_chk" class="mgR3">첨부파일</label>
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
						<th>Rev. No.</th>
						<td class="alignL pdL10">${maxVersion}</td>
						<th>Rev. Date</th>
						<td class="alignL pdL10">${prcList.LastUpdated}</td>
						<th>${menu.LN00018}</th>
						<td class="alignL pdL10">${prcList.CurOwnerTeamName}</td>
					</tr>
				</table>
				<p class="cont_title">프로세스 정의</p>
				<table class="tbl_preview">
					<tr>
						<div style="height:150px;">
							<textarea class="tinymceText" id="description" name="description"  >${attrMap.AT00003}</textarea>
						</div>
					</tr>
				</table>
			</div>
			
			<!-- 하위항목 --> 
			<div id="subItem" class="mgB30">
				<p class="cont_title">${menu.LN00006 }</p>
				<div id="gridDiv" class="mgB10 clear">
					<div id="grdChildGridArea" style="width:100%"></div>
				</div>
			</div>
			
			<!-- 참고사항 --> 
			<div id="note" class="mgB30">
				<p class="cont_title">참고사항</p>
				<table class="tbl_preview">
					<tr>
						<div style="height:150px;">
							<textarea class="tinymceText" id="AT00006" name="AT00006"  >${attrMap.AT00006}</textarea>
						</div>
					</tr>
				</table>
			</div>
			
				<!-- 첨부 및 관련 문서 --> 
			<div id="fileList" class="mgB30">
				<p class="cont_title">참고파일</p>
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
									<span class="btn_pack small icon mgR20" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.Seq}','${fileList.ExtFileURL}');">
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
									<span style="cursor:pointer;margin-left:10px;" onclick="fileNameClick('${fileList.FileName}','${fileList.FileRealName}','','${fileList.Seq}','${fileList.ExtFileURL}');">${fileList.FileRealName}</span>
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
