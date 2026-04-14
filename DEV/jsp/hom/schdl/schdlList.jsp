<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">
<html>
<!-- 2. Dhtmlx 7.1.8  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
	var searchViewFlag = "${searchViewFlag}";
	var schdlType = "${schdlType}";
	var mySchdl = "${mySchdl}";
	var SC_STR_DT_FROM = "${SC_STR_DT_FROM}";
	var SC_STR_DT_TO = "${SC_STR_DT_TO}";
	var SC_END_DT_FROM = "${SC_END_DT_FROM}";
	var SC_END_DT_TO = "${SC_END_DT_TO}";
	var p_gridArea;				//그리드 전역변수
	var screenType = "${screenType}";
	var categoryData = "&category=DOCCAT&languageID=${sessionScope.loginInfo.sessionCurrLangType}&selectedCode='CSR','SR','PJT','ITM'";
	fnSelect('docCategory',categoryData,'getDictionary','','Select');
	
	if("${screenType == pjtInfoMgt}"){
		var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('project', data, 'getProject', '${projectMap.ProjectID}','Select'); 
	}else{
		$("#project").attr('disabled', 'disabled: disabled');
	}

	$(document).ready(function(){
		//doSearchList();
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		};
	
		$("input.datePicker").each(generateDatePicker);
		$('.searchList').click(function(){
			doSearchList();
			return false;
		});
		$('#searchClear').click(function(){
			clearSearchCon();
			return false;
		});
		$('#searchValue').keypress(function(onkey){
			if(onkey.keyCode == 13){
				doSearchList();
				return false;
			}
		});		
		$('#new').click(function(){
			doClickSchedlNew();
			return false;
		});		
		
		$('#scheduleCalandar').click(function(){
			goScheduler();
			return false;
		});		
		
		
		var timer = setTimeout(function() {
			$('#docCategory option:eq(0)').after("<option value='CMM'>General</option");
			$('#searchValue').focus();
			//doSearchList();
		
		}, 250); //1000 = 1초
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
	

	//그리드 Check시
	function gridOnCheck(rId,cInd,state){
		if( state ) p_gridArea.selectRow(rId);
	}
	
	//그리드ROW선택시
	function gridOnRowSelect(row, col){
		var scheduleId = row.ScheduleID;
		var pageNum = $("#currPage").val();
		if(screenType=="mainV3"){
			var url = "selectSchedulDetail.do";
			var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&scheduleId="+scheduleId+"&pageNum="+pageNum+"&screenType="+screenType+"&parentID=${parentID}";
			data += "&schdlType="+schdlType+"&mySchdl="+mySchdl;
			var target = (mySchdl == "Y" ? "help_content" : "schdlListFrm");
			ajaxPage(url, data, target);
		}else{
			goSchdlDetail(scheduleId);
		}
	}
	

	
	function doClickSchedlNew(){
		var target, pageNum, url, data;
	
		if(screenType == "mainV3"){
			pageNum = $("#currPage").val();
			url = "selectSchedulDetail.do";
			data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&pageNum="+pageNum+"&screenType="+screenType+"&parentID=${parentID}";
			target = (mySchdl == "Y" ? "help_content" : "schdlListFrm");
			ajaxPage(url, data, target);
		}else{
			url = "registerSchdl.do?";
			data="languageID=${sessionScope.loginInfo.sessionCurrLangType}&screenType="+screenType;
			data += "&searchViewFlag=${searchViewFlag}&documentID=${documentID}&docCategory=${docCategory}&schdlType="+schdlType+"&mySchdl="+mySchdl
					+"&projectID=${projectID}";
			//target = (mySchdl == "Y" ? "help_content" : "subBFrame");
	
			var w = 880;
			var h = 500;
			window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
		}



	}

	function goScheduler(){
		if(screenType == "mainV3"){ // mainHomLayer_V3일경우 
			var url = "schedulMgtMaster.do";
			var data = "screenType=mainV3&projectID=${parentID}&pageNum=${pageNum}";
			var target = "help_content";
			ajaxPage(url, data, target); 
		}else{
			document.location.href = "schedulMgt.do";
		}
	}
	
	function fnCallSheduleList(projectID,screenType,pageNum){
		var url = "goSchdlList.do";
		var data = "screenType="+screenType+"&parentID="+projectID+"&pageNum="+pageNum;
		var target = "help_content";
		ajaxPage(url, data, target); 
	}
	
	//스케쥴 상세화면 이동
	function goSchdlDetail(scheduleId){ 
		var url = "selectSchedulDetail.do?";
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&scheduleId="+scheduleId;
		data += "&schdlType="+schdlType+"&mySchdl="+mySchdl;
		var w = 880;
		var h = 500;
		window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	

	

</script>
<body>
<form name="schdlListFrm" id="schdlListFrm" action="" method="post" >
	<input type="hidden" id="NEW" name="NEW" value="">
	<input type="hidden" id="userId" name="userId" value="${sessionScope.loginInfo.sessionUserId}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<input type="hidden" id="documentID" name="documentID" value="${documentID}">
	<div class="cop_hdtitle mgT5" <c:if test="${ searchViewFlag eq ''}">style="border-bottom:1px solid #ccc;"</c:if> >
		<h3 style="padding-bottom:6px;"><img src="${root}${HTML_IMG_DIR}/icon_schedule.png">&nbsp;&nbsp;Schedule&nbsp;</h3>
	</div>
	<div <c:if test="${searchViewFlag ne ''}">style="display:none;"</c:if> >
		<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
			<colgroup>
			    <col width="10.3%">
			    <col width="23%">
			 	<col width="10.3%">
			    <col width="23%">
			 	<col width="10.3%">
			    <col width="23%">
		    </colgroup>
		    <tr>
		     	<!-- 시작일 -->
		        <th class="alignL">${menu.LN00063}</th> 
		        <td class="alignL">      
			       	 
						<input type="text" id="SC_STR_DT_FROM" name="SC_STR_DT_FROM" value="${SC_STR_DT_FROM}"	class="text datePicker" size="8"
						style="width:42%;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
					~
					 
						<input type="text" id="SC_STR_DT_TO" name="SC_STR_DT_TO" value="${SC_STR_DT_TO}"	class="text datePicker" size="8"
						style="width:42%;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
		       	</td>
		        <!-- 종료일 -->
		        <th class="alignL">${menu.LN00233}</th>    
		        <td class="alignL">     
		             
						<input type="text" id="SC_END_DT_FROM" name="SC_END_DT_FROM" value="${SC_END_DT_FROM}"	class="text datePicker" size="8"
						style="width:42%;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					
					~
					 
						<input type="text" id="SC_END_DT_TO"	name="SC_END_DT_TO" value="${SC_END_DT_TO}"	class="text datePicker" size="8"
						style="width:42%;" onchange="this.valu0e = makeDateType(this.value);"	maxlength="10">
					
		        </td>
		        <th class="alignL">${menu.LN00237}</th>    
		        <td class="alignL">     
		            <input type="text" id="location" name="location" value="" class="stext" style="width:95%;">
		        </td>
			</tr>    
		    <tr>
				<!-- 검색어 -->
		        <th class="alignL">
					<select id="searchKey" name="searchKey" class="sel" style="padding: 0px 5px;">
						<option value="Name">${menu.LN00002}</option>
						<option value="Info" 
							<c:if test="${searchKey == 'Info'}"> selected="selected"</c:if>>
							${menu.LN00003}
						</option>					
					</select>
				</th>
				<td class="alignL">     
		            <input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="stext" style="width:95%;">
		        </td>
		       	<th class="alignL">${menu.LN00131}</th>
		        <td class="alignL">      
			       	<select id="project" name="project" class="sel" style="padding: 0px 5px;">
						 <option value="${projectMap.ProjectID}" selected="selected">${projectMap.ProjectName}</option> 
					</select>
		       	</td>
				<!-- 참조문서 -->
		        <th class="alignL">${menu.LN00033}</th>     
		        <td class="alignL">     
		            <select id="docCategory" name="docCategory" class="sel" style="padding: 0px 5px;"></select>
		        </td>
			</tr>
	   	</table>
	   	<div class="mgT5" align="center">
	       	<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="search" />
	       	<input type="image" id="searchClear" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;">
		</div>
   	</div>
	<div class="countList">
		<ul>
          <li  class="count">Total  <span id="TOT_CNT"></span></li>
          <li class="floatR">&nbsp;</li>
          <li class="floatR pdR10">
          	<c:if test="${sessionScope.loginInfo.sessionAuthLev<3 || pjtMember == 'Y'}">
			&nbsp;<span class="btn_pack medium icon"><span class="add"></span><input value="ADD" type="submit" id="new"></span>&nbsp;&nbsp;
			</c:if>
			&nbsp;<span class="btn_pack medium icon"><span class="sche"></span><input value="Calendar" type="submit" id="scheduleCalandar"></span>&nbsp;&nbsp;
		</li>
		
         </ul>
    </div>
	<div id="gridDiv" class="mgB10 clear">
		<div id="grdGridArea" style="width:100%"></div>
		<div id="pagination"></div>
	</div>
	
<!-- 	<div id="subBFrame" name="subBFrame" style="padding:0 0 0 20px;width:95%;height:85%;overflow-x:hidden;overflow-y:auto;margin:0 auto;"></div> -->
</form>


<script type="text/javascript">
		var layout = new dhx.Layout("grdGridArea", {
			rows : [ {
				id : "a",
			}, ]
		});	
		var gridData = ${gridData}; 
		
		var grid = new dhx.Grid("grdGridArea", {
		    columns: [
		    	//		result.widths = "50,*,250,150,150,120,120,120,70,70";
		        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
		 
		        { id: "Subject", header: [{ text: "${menu.LN00002}" , align: "center" }, { content: "inputFilter" }], align: "center"},
		        { width: 250, id: "Location", header: [{ text: "${menu.LN00237}" , align: "center" }, { content: "inputFilter" }],align:"center"},
		        { width: 150, id: "start_date", header: [{ text: "${menu.LN00324}" , align: "center" }, { content: "inputFilter" }],align:"left"},
		        { width: 150, id: "end_date", header: [{ text: "${menu.LN00325}" , align: "center" }, { content: "inputFilter" }],align: "center" },
		        { width: 120, id: "WriteUserNM", header: [{ text: "${menu.LN00212}" , align: "center" }, { content: "inputFilter" }],align: "center"},
		        { width: 120, id: "ProjectName", header: [{ text: "${menu.LN00131}" , align: "center" }, { content: "selectFilter" }],align: "center" },
		        { width: 120, id: "docCategoryName", header: [{ text: "${menu.LN00033}" , align: "center" }, { content: "selectFilter" }],align: "center" },
		        { width: 70, id: "IsNew", header: [{ text: "${menu.LN00068}" , align: "center"}],htmlEnable:true, align: "center",
		        	template:function (text,row,col){
		        		return  '<img src="${root}${HTML_IMG_DIR}/'+row.IsNew+'" width="15" height="15">';
		        	}	
		        },
		        { hidden:true,width: 70, id: "ScheduleID", header: [{ text: "ScheduleID" , align: "center" }, { content: "" }], align: "" },

        
		       
		    ],
		    eventHandlers: {
		        onclick: {
		           
		        }
		    },
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		    data: gridData
		});
		
		$("#TOT_CNT").html(grid.data.getLength());
		layout.getCell("a").attach(grid);

	
		var pagination = new dhx.Pagination("pagination", {
		    data: grid.data,
		    pageSize: 40,
		 
		});	
		
		pagination.setPage(0);
		
		grid.events.on("cellClick", function(row,column,e){
			gridOnRowSelect(row,column);
		 }); 
		
		function doSearchList(){
			var documentID = parseInt($("#documentID").val(), 10);
			var	sqlID = "schedule_SQL.getSchdlList";	
		
			var param = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			 	        +"&userID="+$('#userId').val()
			 	        +"&pageNum="+$("#currPage").val()
						+"&endDTCheck=N"
						+ "&scStartDtFrom="+ $("#SC_STR_DT_FROM").val()
						+"&scStartDtTO=" + $("#SC_STR_DT_TO").val()
						+"&scEndDtFrom="+$("#SC_END_DT_FROM").val()
						+"&scEndDtTo=" + $("#SC_END_DT_TO").val()
						+"&searchKey=" + $("#searchKey").val()
						+"&searchValue="+ $("#searchValue").val()
						+"&docCategory=" + $("#docCategory").val()
						    // documentID 값이 비어있지 않다면 param에 추가합니다.
				    if ($("#documentID").val() != "" && $("#documentID").val() != null) {
				        var docID = $("#documentID").val();
				        param += "&documentID=" + encodeURIComponent(docID);
				    }
				
				    // projectID 값이 비어있지 않다면 param에 추가합니다.
				    if ($("#project").val() != "" && $("#project").val() != null) {
				        var prjID = $("#project").val();
				        param += "&projectID=" + encodeURIComponent(prjID);
				    }
				
				    // 나머지 파라미터를 추가합니다.
				    param += "&location=" + $("#location").val()
				            + "&mySchdl=" + mySchdl
				            + "&sqlID=" + sqlID;	 		
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
	 		fnClearFilter("Subject");
	 		fnClearFilter("Location");
	 		fnClearFilter("start_date");
	 	    fnClearFilter("end_date");
	 	    fnClearFilter("WriteUserNM");
	 	    fnClearFilter("ProjectName");
	 	    fnClearFilter("docCategoryName");
	
	 	    grid.data.parse(newGridData);
			$("#TOT_CNT").html(grid.data.getLength());
			fnMasterChk('');
	 	}
		
	 	function fnClearFilter(columnID) {
	 		var headerFilter = grid.getHeaderFilter(columnID);
	 		if(headerFilter){
	 	    var changeEvent = document.createEvent("HTMLEvents");
	 	    changeEvent.initEvent("change");
	 	    var selectFilter = grid.getHeaderFilter(columnID).querySelector('select');
	 	    var inputFilter = grid.getHeaderFilter(columnID).querySelector('input');
	 	    if(selectFilter){
	 	     	selectFilter.value = " ";
	 	    	selectFilter.dispatchEvent(changeEvent);
	 	    }else if (inputFilter) {
	 	     	inputFilter.value = " ";
	 	     	inputFilter.dispatchEvent(changeEvent);
			}else{
				console.error("해당filter에 select요소 없음");
	 	    	}
	 		}else{
	 			console.error("해당 열의 필터를 찾을 수 없음");
	 		}
	 	}
		
	 	
		function clearSearchCon() {
			$("#docCategory").val("");
			$("#project").val("");
			$("#searchValue").val("");
			$("#SC_STR_DT_FROM").val("");
			$("#SC_STR_DT_TO").val("");
			$("#SC_END_DT_FROM").val("");
			$("#SC_END_DT_TO").val("");
			$("#searchKey").val("Name");
		}
	 	
</script>
</body>
</html>