<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>

<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">
<html>
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
	var categoryData = "&category=DOCCAT&languageID=${sessionScope.loginInfo.sessionCurrLangType}&selectedCode='CSR','SR','PJT'";
	fnSelect('docCategory',categoryData,'getDictionary','','Select');
	
	if(screenType != "mainV3"){
		var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('project', data, 'getProject', '${resultMap.ProjectID}','Select'); 
	}else{
		$("#project").attr('disabled', 'disabled: disabled');
	}
	
	$(document).ready(function(){
		
		
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
			gridInit();	
			doSearchList();
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
	
	//===============================================================================
	// BEGIN ::: GRID
	//그리드 초기화
	function gridInit(){		
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");//path to images required by grid
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");	

		fnSetColType(p_gridArea, 8, "img");
		p_gridArea.setColumnHidden(9, true);		
		p_gridArea.attachEvent("onRowSelect", function(id,ind){
						gridOnRowSelect(id,ind);
		});
		
		p_gridArea.enablePaging(true,10,10,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}

	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "schedule_SQL.getSchdlList";
		result.header = "${menu.LN00024},${menu.LN00002},${menu.LN00237},${menu.LN00324},${menu.LN00325},${menu.LN00212},${menu.LN00131},${menu.LN00091},${menu.LN00068},ScheduleID";
		result.cols = "Subject|Location|start_date|end_date|WriteUserNM|ProjectName|docCategoryName|IsNew|ScheduleID";
		result.widths = "50,*,250,150,150,120,120,120,70,70";
		result.sorting = "int,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,left,center,center,center,center,center,center,center,center"; 
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
						+ "&userID="+$('#userId').val()						
				        + "&pageNum="     	+ $("#currPage").val()				        				        
				        + "&endDTCheck=N";
		if(searchViewFlag == ""){
			result.data += "&scStartDtFrom="     + $("#SC_STR_DT_FROM").val()
			result.data += "&scStartDtTO="     + $("#SC_STR_DT_TO").val()			        
			result.data +=  "&scEndDtFrom="     	+ $("#SC_END_DT_FROM").val()			        
			result.data +=  "&scEndDtTo="     	+ $("#SC_END_DT_TO").val()
			result.data +=  "&searchKey="    	+ $("#searchKey").val()
			result.data +=  "&searchValue="  	+ $("#searchValue").val()
		}
		if($("#docCategory").val() != ""){
        	result.data += "&docCategory=" + $("#docCategory").val();	
        }
		if($("#documentID").val() != ""){
        	result.data += "&documentID=" + $("#documentID").val();	
        }
		if($("#project").val() != ""){
			result.data += "&projectID=" + $("#project").val();	
		}		
		if($("#location").val() != ""){
			result.data += "&location=" + $("#location").val();	
		}		
		if(mySchdl != ""){
			result.data += "&mySchdl=" + mySchdl;	
		}		
		return result;
	}

	//그리드 Check시
	function gridOnCheck(rId,cInd,state){
		if( state ) p_gridArea.selectRow(rId);
	}
	
	//그리드ROW선택시
	function gridOnRowSelect(id, ind){
		var scheduleId = p_gridArea.cells(id, 9).getValue();
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
	
	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
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
			data += "&searchViewFlag=${searchViewFlag}&documentID=${documentID}&docCategory=${docCategory}&schdlType="+schdlType+"&mySchdl="+mySchdl;
			//target = (mySchdl == "Y" ? "help_content" : "subBFrame");
			var w = 880;
			var h = 420;
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
		var h = 420;
		window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
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
			       	<font> 
						<input type="text" id="SC_STR_DT_FROM" name="SC_STR_DT_FROM" value="${SC_STR_DT_FROM}"	class="text datePicker" size="8"
						style="width:42%;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</font>
					~
					<font> 
						<input type="text" id="SC_STR_DT_TO" name="SC_STR_DT_TO" value="${SC_STR_DT_TO}"	class="text datePicker" size="8"
						style="width:42%;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</font>
		       	</td>
		        <!-- 종료일 -->
		        <th class="alignL">${menu.LN00233}</th>    
		        <td class="alignL">     
		            <font> 
						<input type="text" id="SC_END_DT_FROM" name="SC_END_DT_FROM" value="${SC_END_DT_FROM}"	class="text datePicker" size="8"
						style="width:42%;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</font>
					~
					<font> 
						<input type="text" id="SC_END_DT_TO"	name="SC_END_DT_TO" value="${SC_END_DT_TO}"	class="text datePicker" size="8"
						style="width:42%;" onchange="this.valu0e = makeDateType(this.value);"	maxlength="10">
					</font>
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
						<%-- <option value="${projectMap.ProjectID}" selected="selected">${projectMap.ProjectName}</option> --%>
					</select>
		       	</td>
				<!-- 참조문서 -->
		        <th class="alignL">${menu.LN00091}</th>     
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
	</div>
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
<!-- 	<div id="subBFrame" name="subBFrame" style="padding:0 0 0 20px;width:95%;height:85%;overflow-x:hidden;overflow-y:auto;margin:0 auto;"></div> -->
</form>
</body>
</html>