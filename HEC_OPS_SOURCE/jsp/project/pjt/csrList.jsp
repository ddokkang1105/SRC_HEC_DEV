<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00039" var="WM00039"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00040" var="WM00040"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>

<script type="text/javascript">
	var p_gridArea;				// 그리드 전역변수(Project)
	var p_gridArea_Cngt;				// 그리드 전역변수(ChangeSet)
	var screenType = "${screenType}";
	var mainType = "${mainType}";
	
	var companyID = "${companyID}";
	changePjtList("${projectID}");
	$(document).ready(function() {	
		
		$("input.datePicker").each(generateDatePicker); // calendar
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 250)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 250)+"px;");
		};

		$('#ProjectGroup').change(function(){
			changePjtList($(this).val()); // 변경오더 option 셋팅
		});
		
		$("#MulStatus").change(function(){
			changeStatus($(this).val());
		});
		
		$("input[name=mbrTypeList]").change(function(){

			doSearchPjtList();
		})
		
		
		gridPjtInit();
		doSearchPjtList();
		
		if(screenType == "MYSPACE")
			changeStatus("ING");
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
	
	/* Project List */
	function gridPjtInit(){
		var d = setGridPjtData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		
		fnSetColType(p_gridArea, 1, "ch");
		p_gridArea.setColumnHidden(0, true);
		p_gridArea.setColumnHidden(1, true);
		p_gridArea.setColumnHidden(11, true);
		p_gridArea.setColumnHidden(12, true);
		p_gridArea.setColumnHidden(13, true);
		p_gridArea.setColumnHidden(14, true);
		p_gridArea.setColumnHidden(15, true);
		p_gridArea.setColumnHidden(16, true);
		p_gridArea.setColumnHidden(17, true);
		p_gridArea.setColumnHidden(18, true);
		p_gridArea.setColumnHidden(19, true);
		p_gridArea.setColumnHidden(20, true);
		p_gridArea.setColumnHidden(22, true);

		
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnPjtRowSelect(id,ind);});
		p_gridArea.enablePaging(true,30,null,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	
	function setGridPjtData(){
		var result = new Object();
		//var status = "'APRV','CLS'";
		var mainMenu = "${mainMenu}";
		
		result.title = "${title}";
		result.key = "project_SQL.getSetProjectListForCsr";
		result.header = "${menu.LN00024},#master_checkbox,CSR No.,${menu.LN00028},${menu.LN00131},${menu.LN00153},${menu.LN00266},${menu.LN00013},${menu.LN00062},${menu.LN00067},${menu.LN00027},,,,,,,,,,,${menu.LN00139},";
		result.cols = "CHK|ProjectCode|ProjectName|ParentName|AuthorTeamName|AuthorName|CreationTime|DueDate|PriorityName|StatusName|WFName|CurWFStepName|ProjectID|ProjectType|WFID|AuthorID|Creator|PjtMemberIDs|CNGT_CNT|Status|ChangeStatus|ParentID";
		result.widths = "30,30,100,*,120,100,100,80,80,100,100,0,0,0,0,0,0,0,0,0,0,50";
		result.sorting = "int,int,str,str,str,str,str,str,str,str,str,str,str,int,int,int,int,str,str,str,str,str,str";
		result.aligns = "center,center,left,left,left,left,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "filter=CSR&csrStatus=${csrStatus}"
					+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&screenType=" + screenType		
					+ "&pageNum=" + $("#currPage").val();
					
		if(screenType == "PG" || screenType == "PJT") {
			result.data = result.data + "&refID=${refID}";
		}
		
		var mbrType = $(":input:radio[name=mbrTypeList]:checked").val();

		if(mbrType != '' && mbrType != null && mbrType == "all") {
			result.data = result.data + "&memberId=${memberID}";
		}
		else if(mbrType != '' && mbrType != null && mbrType == "manager") {
			result.data = result.data + "&authorID=${memberID}";
		}
		else if(mbrType != '' && mbrType != null && mbrType == "worker") {
			result.data = result.data + "&relMemID=${memberID}";
		}

		// MainMenu에 따라 Status 조건을 분기 
		
		if($("#Status").val() != '' && $("#Status").val() != null) {
			result.data = result.data + "&Status=" + $("#Status").val();
		}
		else if($("#MulStatus").val() != '' & $("#MulStatus").val() != null){
			result.data = result.data +"&Status="+ $("#MulStatus").val();
		}		

		// 프로젝트
		if($("#Project").val() != '' & $("#Project").val() != null){
			result.data = result.data +"&projectID=" + $("#Project").val();
		}
		
		//CompanyID
		if(companyID != null && companyID != ""){
			result.data = result.data +"&companyID=" + companyID;
		}
		
		// 프로젝트 그룹
		if($("#ProjectGroup").val() != '' & $("#ProjectGroup").val() != null){
			result.data = result.data +"&pjtGRID=" + $("#ProjectGroup").val();
		}	
		
		// 요청일
		if($("#REQ_STR_DT").val() != '' & $("#REQ_STR_DT").val() != null){
			result.data = result.data + "&reqStartDt=" + $("#REQ_STR_DT").val().replace(/-/g, "");
	        result.data = result.data + "&reqEndDt=" + $("#REQ_END_DT").val().replace(/-/g, "");
		}
		// 마감일
		if($("#CLS_STR_DT").val() != '' & $("#CLS_STR_DT").val() != null){
			result.data = result.data + "&clsStartDt=" + $("#CLS_STR_DT").val().replace(/-/g, "");
	        result.data = result.data + "&clsEndDt=" + $("#CLS_END_DT").val().replace(/-/g, "");
		}
		// CSR 명
		if($("#ProjectName").val() != '' & $("#ProjectName").val() != null){
			result.data = result.data +"&ProjectName=" + $("#ProjectName").val();
		}
		
		// CSR Code
		if($("#ProjectCode").val() != '' & $("#ProjectCode").val() != null){
			result.data = result.data +"&ProjectCode=" + $("#ProjectCode").val();
		}
		
		// Author Name
		if($("#AuthorName").val() != '' & $("#AuthorName").val() != null){
			result.data = result.data +"&AuthorName=" + $("#AuthorName").val();
		}
		
		// Author Team Name
		if($("#AuthorTeamName").val() != '' & $("#AuthorTeamName").val() != null){
			result.data = result.data +"&AuthorTeamName=" + $("#AuthorTeamName").val();
		}
		
		return result;
	}
	
	function doSearchPjtList(){
		var d = setGridPjtData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data, false, "", "", "", "", "${WM00119}", 1000);
	}
	
	// 그리드ROW선택시 : 변경오더 조회 화면으로 이동
	function gridOnPjtRowSelect(id, ind){
		var projectId = p_gridArea.cells(id, 13).getValue();
		var status = p_gridArea.cells(id, 20).getValue();
		var pjtCreator = p_gridArea.cells(id, 17).getValue();
		var authorId = p_gridArea.cells(id, 16).getValue();
		
		var screenMode = "V";
		var mainMenu = "${mainMenu}";
	//	var s_itemID = "${s_itemID}";
		var parentID =  p_gridArea.cells(id, 22).getValue();
	//	if(s_itemID == ""||s_itemID == null){ s_itemID = parentID; }
		var url = "csrDetailPop.do?ProjectID=" + projectId + "&screenMode=" + screenMode + "&mainMenu=" + mainMenu;
				
		var w = 1200;
		var h = 800;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	// loginUser가 해당 프로젝트의 담당자인지 판단 
	function isPjtMember(creator, authorId) {
		var loginUser = "${sessionScope.loginInfo.sessionUserId}";
		var result = false;
		if (loginUser == creator) {
			result = true;
		}
		if (loginUser == authorId) {
			result = true;
		}
		return result;
	}
	
	// [Add][Batch] 버튼 이벤트
		
	function fnRegisterCSR() {		
		var url = "registerCSR.do?&mainMenu=${mainMenu}&refID=${refID}&screenType=${screenType}&Priority=03";
		var w = 1100;
		var h = 440;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}
	function fnReload(){
		doSearchPjtList();
	}	

	// [변경오더 option] 설정
	function changePjtList(avg){
		var url    = "getPjtListOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&screenType=myPage&projectID="+avg ; //파라미터들
		var target = "Project";             // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}
	
	// [변경오더 option] 설정
	function changeStatus(avg){
		var url    = "ajaxCodeSelect.do"; // 요청이 날라가는 주소
		
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&Category=CSRSTS&menuId=CSRSTS" ; //파라미터들
		
		if(avg == "ING") {
			data = data + "&notTypeCode='CLS','WTR'";
		}
		else if(avg == "COMPL") {
			data = data + "&typeCodeList='CLS','WTR'";
		}
		
		var target = "Status";             // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}
	function fnClearSearch(){;
	$("#ProjectGroup").val("");
	$("#Project").val("");
	
	$("#Status").val("");
	$("#MulStatus").val("");
	
	$("#ProjectName").val("");
	$("#REQ_STR_DT").val("");
	$("#REQ_END_DT").val("");
	$("#ProjectCode").val("");
	$("#AuthorName").val("");
	$("#AuthorTeamName").val("");

	$("#CLS_STR_DT").val("");
	$("#CLS_END_DT").val("");
	return;
}
	
</script>

<form name="changeReqListFrm" id="changeReqListFrm" action="#" method="post" onsubmit="return false;">
<h3 class="floatL mgT10 mgB12" style="width:100%"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png"  id="subTitle_baisic">&nbsp;&nbsp;
				${menu.LN00204}&nbsp; 
	
</h3>

<!-- BIGIN :: PROJECT_LIST_GRID -->

<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
	<colgroup>
	    <col width="9%">
	    <col width="20%">
	    <col width="9%">
	    <col width="20%">
	    <col width="9%">
	    <col width="20%">
    </colgroup>
    <tr>
   		<!-- 프로젝트 그룹 -->
       	<th class="alignL pdL10">${menu.LN00277}</th>       	
       	 <td class="alignL pdL10"> 
	       		<c:if test="${screenType != 'PJT'}">
	        		<select id="ProjectGroup" Name="ProjectGroup" style="width:80%">
			           	<c:if test="${projectID eq ''}">
		            	<option value=''>Select</option>
		            	</c:if>
			           	<c:forEach var="i" items="${pgList}">
			           		<option value="${i.CODE}" <c:if test="${i.CODE eq projectID}">Selected="Selected"</c:if> >${i.NAME}</option>
			           	</c:forEach>
			       	</select>
	        	</c:if>
	        	<c:if test="${screenType == 'PJT'}">
	        		<select id="ProjectGroup" Name="ProjectGroup" style="width:80%">
	        	    	<c:forEach var="i" items="${pgList}">
	        	    		<option value="${i.CODE}" <c:if test="${i.CODE eq projectID}">Selected="Selected"</c:if> >${i.NAME}</option>
	        	    	</c:forEach>
			       	</select> 
	        	</c:if>		       	
	       	</td>
   		<!-- 프로젝트 -->
       	<th class="alignL pdL10">${menu.LN00131}</th>       	
       	 <td class="alignL pdL10"> 
        		<select id="Project" Name="Project" style="width:80%">
		           	<option value=''>Select</option>
		       	</select>       	
	       	</td>
		     <!-- 상태 -->
		      <th class="alignL pdL10">${menu.LN00027}</th>
		     <td class="alignL pdL10">  		     
		     	<select id="MulStatus" name="MulStatus" style="width:40%;">
		            <option value=''>Select</option>
		            <option value='ING' selected="selected">${menu.LN00121}</option>
		            <option value='COMPL'>${menu.LN00351}</option>
		     	</select>
		        <select id="Status" Name="Status" style="width:40%">
		            <option value=''>Select</option>
		        </select>
		      </td>
	</tr>
	
    <tr>    
       <!-- CSR 명칭-->
        <th class="alignL pdL10">${menu.LN00191} ${menu.LN00028}</th>     
	    <td class="alignL pdL10"><input type="text" class="text" id="ProjectName" name="ProjectName" value="" style="ime-mode:active;width:80%;" /></td>
        
    	<!-- 요청일 -->
        <th class="alignL pdL10">${menu.LN00013}</th>
        <td class="alignL pdL10">     
            <font><input type="text" id="REQ_STR_DT" name="REQ_STR_DT" value="${beforeYmd}"	class="input_off datePicker stext" size="8"
				style="width: 30%;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
			</font>
			~
			<font><input type="text" id="REQ_END_DT" name="REQ_END_DT" value="${thisYmd}"	class="input_off datePicker stext" size="8"
				style="width: 30%;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
			</font>
         </td>
         
        <!-- 마감일 -->
        <th class="alignL pdL10">${menu.LN00062}</th>
        <td class="alignL pdL10 last">     
            <font><input type="text" id="CLS_STR_DT" name="CLS_STR_DT" value="${beforeYmd}"	class="input_off datePicker stext" size="8"
				style="width:30%;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
			</font>
			~
			<font><input type="text" id="CLS_END_DT" name="CLS_END_DT" value="${thisYmd}" class="input_off datePicker stext" size="8"
				style="width: 30%;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
			</font>
         </td>
    </tr> 
      <tr>    
       <!-- CSR Code-->
        <th class="alignL pdL10">${menu.LN00191} No.</th>     
	    <td class="alignL pdL10"><input type="text" class="text" id="ProjectCode" name="ProjectCode" value="" style="ime-mode:active;width:80%;" /></td>
        
    	<!-- 담당자 -->
        <th class="alignL pdL10">${menu.LN00266}</th>
        <td class="alignL pdL10"><input type="text" class="text" id="AuthorName" name="AuthorName" value="" style="ime-mode:active;width:80%;" /></td>
      
         
        <!-- 관리조직 -->
        <th class="alignL pdL10">${menu.LN00018}</th>
        <td class="alignL pdL10 last"><input type="text" class="text" id="AuthorTeamName" name="AuthorTeamName" value="" style="ime-mode:active;width:80%;" /></td>
      </tr>        
  </table>

<div class="mgT5" align="center">
	<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" onclick="doSearchPjtList()"/>
	<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;" onclick="fnClearSearch();" >
</div>
 <div class="countList">
    <li class="count">Total  <span id="TOT_CNT"></span></li> 
      	
    <li class="floatL pdL20" style="display:inline">   
		<c:if test="${screenType eq 'MYSPACE' }">
     		<input type="radio" id="mbrTypeList" name="mbrTypeList" value="manager" <c:if test="${mbrType eq 'manager' }"> checked="checked" </c:if>>&nbsp;${menu.LN00266}		
			&nbsp;&nbsp;&nbsp;<input type="radio" id="mbrTypeList" name="mbrTypeList" value="worker"  <c:if test="${mbrType eq 'worker' }"> checked="checked" </c:if>>&nbsp;${menu.LN00288}
			&nbsp;&nbsp;&nbsp;<input type="radio" id="mbrTypeList" name="mbrTypeList" value="all" <c:if test="${mbrType eq 'all' }"> checked="checked" </c:if>>&nbsp;ALL
		</c:if>
	</li>
    <li class="floatR" style="display:inline"> 
		<c:if test="${sessionScope.loginInfo.sessionAuthLev < 3 && pjtRelCnt > 0}">
       		&nbsp;<span id="btnAdd" class="btn_pack small icon"><span class="add"></span><input value="Create CSR" type="submit" onclick="fnRegisterCSR()"></span>	
   		</c:if>	
     </li>
 </div>
 
<div id="gridPjtDiv" style="width:100%;" class="clear" >
	<div id="grdGridArea" ></div>
</div>
<!-- END :: LIST_GRID -->
<!-- START :: PAGING -->
<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
<!-- END :: PAGING -->	

</form>
<!-- START :: FRAME --> 		
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" style="width:0px;height:0px; display:none;"></iframe>
</div>	
<!-- END :: FRAME -->
