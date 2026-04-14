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
	var p_gridArea_Issue;				// 그리드 전역변수(Project)
	var issueMode = "${issueMode}";
	
	$(document).ready(function() {	
		$("input.datePicker").each(generateDatePicker); // calendar
		
		// 초기 표시 화면 크기 조정 
		$("#grdIssueGridArea").attr("style","height:"+(setWindowHeight() - 300)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdIssueGridArea").attr("style","height:"+(setWindowHeight() - 300)+"px;");
		};
		
		// [상태] 리스트 설정
		fnSelect('Status','&Category=ISSTS','dictionyCode','Select');
		
		if (issueMode == "ARC" || issueMode == "Admin") { // 전체 ISSUE 조회 화면 일 경우
			$('#Project').change(function(){
				changeCsrList($(this).val()); // 변경오더 option 셋팅
			});
			changeCsrList(''); // 변경오더 option 셋팅
		}
		
		if (issueMode == "PjtMgt") {
			changeCsrList('${parentId}'); // 변경오더 option 셋팅
		}
		
		gridIssueInit();
		doSearchIssueList();
		
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
	
	function gridIssueInit(){
		var d = setGridIssueData();
		p_gridArea_Issue = fnNewInitGrid("grdIssueGridArea", d);
		p_gridArea_Issue.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea_Issue.setColumnHidden(13, true);
		p_gridArea_Issue.attachEvent("onRowSelect", function(id,ind){gridOnIssueRowSelect(id,ind);});
		p_gridArea_Issue.enablePaging(true,20,null,"pagingArea",true,"recInfoArea");
		p_gridArea_Issue.setPagingSkin("bricks");
		p_gridArea_Issue.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPageI").val(ind);});
	}
	
	function setGridIssueData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "issue_SQL.getIssueInfo";
										//ID              //제목                         //프로젝트                    //유형                          //요청조직                     //요청자                       //접수자                         //처리자                       //요청일                        //완료예정일                  //처리완료일                        //상태
		result.header = "${menu.LN00024},${menu.LN00106},${menu.LN00002},${menu.LN00131},${menu.LN00217},${menu.LN00026},${menu.LN00025},${menu.LN00219},${menu.LN00220},${menu.LN00093},${menu.LN00221},${menu.LN00223},${menu.LN00027},issueId";
		result.cols = "IssueCode|Subject|pjtCsrName|ItemTypeName|ReqTeamName|RequestorName|ReceiverName|ActorName|CreationTime|DueDate|ActionDate|StatusName|IssueID";
		result.widths = "30,100,130,130,100,100,100,100,100,80,80,80,80,0";
		result.sorting = "int,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,left,left,center,center,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&pageNum=" + $("#currPageI").val();
					
		/* 검색 조건 설정 */
		if (issueMode == "ARC" || issueMode == "Admin") { // 전체 ISSUE 조회 화면 일 경우
			// 프로젝트
			if($("#Project").val() != '' & $("#Project").val() != null){
				result.data = result.data +"&ProjectID=" + $("#Project").val();
			}
			// 변경오더
			if($("#CsrList").val() != '' & $("#CsrList").val() != null){
				result.data = result.data +"&CSRID=" + $("#CsrList").val();
			}
			if (issueMode == "ARC") {
				result.data = result.data + "&loginUserId=${sessionScope.loginInfo.sessionUserId}";
			}
		} else if(issueMode == "PjtMgt") {
			// 변경오더
			result.data = result.data +"&ProjectID=" + $("#Project").val();
			if($("#CsrList").val() != '' & $("#CsrList").val() != null){
				result.data = result.data +"&CSRID=" + $("#CsrList").val();
			}else{
				result.data = result.data +"&CSRID=${ProjectID}" ;
			}
		} else {
			result.data = result.data +"&CSRID=${ProjectID}";
		}
		
		// 유형
		if($("#ItemType").val() != '' & $("#ItemType").val() != null){
			result.data = result.data +"&ItemTypeCode=" + $("#ItemType").val();
		}
		// 상태
		if($("#Status").val() != '' & $("#Status").val() != null){
			result.data = result.data +"&Status=" + $("#Status").val();
		}
		// 요청자
		if($("#Requestor").val() != '' & $("#Requestor").val() != null){
			result.data = result.data +"&Requestor=" + $("#Requestor").val();
		}
		// 접수자
		if($("#Receiver").val() != '' & $("#Receiver").val() != null){
			result.data = result.data +"&Receiver=" + $("#Receiver").val();
		}
		// 처리자
		if($("#Actor").val() != '' & $("#Actor").val() != null){
			result.data = result.data +"&Actor=" + $("#Actor").val();
		}
		// 처리조직
		if($("#ActTeamID").val() != '' & $("#ActTeamID").val() != null){
			result.data = result.data +"&ActTeamID=" + $("#ActTeamID").val();
		}
		// 요청일
		if($("#REQ_STR_DT").val() != '' & $("#REQ_STR_DT").val() != null){
			result.data = result.data + "&REQ_STR_DT=" + $("#REQ_STR_DT").val().replace(/-/g, "");
	        result.data = result.data + "&REQ_END_DT=" + $("#REQ_END_DT").val().replace(/-/g, "");
		}
		// 완료요청일
		if($("#REQDUE_STR_DT").val() != '' & $("#REQDUE_STR_DT").val() != null){
			result.data = result.data + "&REQDUE_STR_DT=" + $("#REQDUE_STR_DT").val().replace(/-/g, "");
	        result.data = result.data + "&REQDUE_END_DT=" + $("#REQDUE_END_DT").val().replace(/-/g, "");
		}
		// 완료예정일
		if($("#DUE_STR_DT").val() != '' & $("#DUE_STR_DT").val() != null){
			result.data = result.data + "&DUE_STR_DT=" + $("#DUE_STR_DT").val().replace(/-/g, "");
	        result.data = result.data + "&DUE_END_DT=" + $("#DUE_END_DT").val().replace(/-/g, "");
		}
		// 처리완료일
		if($("#ACT_STR_DT").val() != '' & $("#ACT_STR_DT").val() != null){
			result.data = result.data + "&ACT_STR_DT=" + $("#ACT_STR_DT").val().replace(/-/g, "");
	        result.data = result.data + "&ACT_END_DT=" + $("#ACT_END_DT").val().replace(/-/g, "");
		}
		return result;
	}
	
	function doSearchIssueList(){
		var d = setGridIssueData();
		fnLoadDhtmlxGridJson(p_gridArea_Issue, d.key, d.cols, d.data, false, "", "", "", "", "${WM00119}", 1000);
	}
	
	// 그리드ROW선택시 : 변경오더 조회 화면으로 이동
	function gridOnIssueRowSelect(id, ind){
		var issueId = p_gridArea_Issue.cells(id, 13).getValue();
		var url = "issueInfoDetail.do";
		var data = "ProjectID=${ProjectID}&isNew=${isNew}&mainMenu=${mainMenu}&s_itemID=${s_itemID}" 
			+ "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}"
			+ "&Creator=${Creator}&ParentID=${ParentID}&issueMode=${issueMode}&issueId=" + issueId
			+ "&currPageI=" + $("#currPageI").val()+"&screenType=${screenType}";
		var target = "help_content";
		if("${screenType}" == "csrDtl"){ target = "tabFrame";}
		ajaxPage(url, data, target);
	}
	
	// [Add] 버튼 이벤트
	function goAddIssue() {
		var screenType = "${screenType}";
		var url = "addNewIssue.do"; // 변경 오더 등록 화면
		var data = "issueMode=${issueMode}&isIssueEdit=N"
			+ "&currPageI=" + $("#currPageI").val()
			+ "&ParentID=${ParentID}"
			+ "&screenType="+screenType
			+ "&ProjectID=${ProjectID}";		
		var target = "help_content";
		if(screenType == "csrDtl"){ // change order Tab 으로  들어온경우 
			target = "tabFrame";
		}
		ajaxPage(url, data, target);
	}
	
	
	// [back]:Project Info로 이동
	function goPjtInfo() {
		var url = "newProjectInfoView.do";
		var data = "ProjectID=${ProjectID}&isNew=${isNew}&mainMenu=${mainMenu}&s_itemID=${s_itemID}"
					+"&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}";
		var target = "help_content";
		ajaxPage(url, data, target);
	}
	
	// [변경오더 option] 설정
	function changeCsrList(avg){
		var url    = "getCsrListOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&isIssue=Y&parentPjtID="+avg; //파라미터들
		var target = "CsrList";             // selectBox id
		var defaultValue = "${ProjectID}";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}
	
	
</script>

<form name="issueListFrm" id="issueListFrm" action="#" method="post" onsubmit="return false;">
<input type="hidden" id="currPageI" name="currPageI" value="${currPageI}" />
<c:if test="${screenType != 'csrDtl' }" >
<!-- 화면 타이틀 : Issue 목록-->
<div class="cop_hdtitle" style="border-bottom:1px solid #ccc">
	<h3 style="padding: 6px 0 6px 0">
		<img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;
			${menu.LN00216}
	</h3>
</div><div style="height:10px"></div>
</c:if>
<!-- BIGIN :: PROJECT_LIST_GRID -->
<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
	<colgroup>
	    <col width="8%">
		<col width="15%">
		<col width="8%">
		<col width="15%">
		<col width="8%">
		<col width="15%">
		<col width="8%">
		<col width="15%">
		<col width="8%">
    </colgroup>
    <tr>
   		<!-- 프로젝트 -->
       	<th class="viewtop">${menu.LN00131}</th>
        <td class="viewtop"> 
	        <c:if test="${issueMode == 'ARC' || issueMode == 'Admin'}">    
		       	<select id="Project" Name="Project">
		           	<option value=''>Select</option>
		           	<c:forEach var="i" items="${parentPjtList}">
		               	<option value="${i.CODE}">${i.NAME}</option>
		           	</c:forEach>
		       	</select>
	       	</c:if>
	       	<c:if test="${issueMode == 'CSR' || issueMode == 'PjtMgt'}">
	       		<input type="hidden" id="Project" name="Project" value="${ParentID}" />
	       		<input type="text" class="text" id="ProjectName" name="ProjectName" value="${parentName}" readonly="readonly"/>	
	       	</c:if>
       	</td>
       	
       	<!-- 변경 오더 -->
       	<th class="viewtop">${menu.LN00191}</th>
        <td class="viewtop"> 
	        <c:if test="${issueMode == 'ARC' || issueMode == 'Admin' || issueMode == 'PjtMgt'}">        
		       	<select id="CsrList" Name="CsrList">
		           	<option value=''>Select</option>
		       	</select>
	       	</c:if>
	       	<c:if test="${issueMode == 'CSR'}">
	       		<input type="hidden" id="CsrList" name="CsrList" value="${ProjectID}" />
	       		<input type="text" class="text" id="CsrName" name="CsrName" value="${csrName}" readonly="readonly"/>	
	       	</c:if>
       	</td>
       	
       	<!-- 유형 -->
       	<th class="viewtop">${menu.LN00217}</th>
        <td class="viewtop">     
       	<select id="ItemType" Name="ItemType">
           	<option value=''>Select</option>
           	<c:forEach var="i" items="${itemTypeList}">
               	<option value="${i.ItemTypeCode}">${i.Name}</option>
           	</c:forEach>
       	</select>
       	</td>
       	
       	<!-- 상태 -->
        <th class="viewtop">${menu.LN00027}</th>
        <td class="viewtop last alignL">     
        <select id="Status" Name="Status">
            <option value=''>Select</option>
        </select>
        </td>
        
        <td class="viewtop last alignC" rowspan="4">
			<li class="floatC" style="display:inline">
				<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="검색" onclick="doSearchIssueList()"/>
			</li>
		</td>
	</tr>
	
    <tr>
    	<!-- 요청자 -->
        <th>${menu.LN00025}</th>
        <td>     
        <select id="Requestor" Name="Requestor">
            <option value=''>Select</option>
            <c:forEach var="i" items="${Requestor}">
               	<option value="${i.CODE}">${i.NAME}</option>
           	</c:forEach>
        </select>
        </td>
        
        <!-- 접수자 -->
        <th>${menu.LN00219}</th>
        <td>     
        <select id="Receiver" Name="Receiver">
            <option value=''>Select</option>
            <c:forEach var="i" items="${Receiver}">
               	<option value="${i.CODE}">${i.NAME}</option>
           	</c:forEach>
        </select>
        </td>
        
        <!-- 처리자 -->
        <th>${menu.LN00220}</th>
        <td>     
        <select id="Actor" Name="Actor">
            <option value=''>Select</option>
            <c:forEach var="i" items="${Actor}">
               	<option value="${i.CODE}">${i.NAME}</option>
           	</c:forEach>
        </select>
        </td>
        
        <!-- 처리조직 -->
        <th>${menu.LN00218}</th>
        <td class="last">     
        <select id="ActTeamID" Name="ActTeamID">
            <option value=''>Select</option>
            <c:forEach var="i" items="${actTeamList}">
               	<option value="${i.TeamID}">${i.TeamName}</option>
           	</c:forEach>
        </select>
        </td>
        
      </tr>
      <tr>   
        <!-- 요청일 -->
        <th>${menu.LN00093}</th>
        <td colspan="3">     
            <font><input type="text" id="REQ_STR_DT" name="REQ_STR_DT" value="${beforeYmd}"	class="input_off datePicker stext" size="8"
				style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
			</font>
			~
			<font><input type="text" id="REQ_END_DT" name="REQ_END_DT" value="${thisYmd}" class="input_off datePicker stext" size="8"
				style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
			</font>
         </td>
         
        <!-- 완료요청일 -->
        <th>${menu.LN00222}</th>
        <td colspan="3" class="last">     
            <font><input type="text" id="REQDUE_STR_DT" name="REQDUE_STR_DT" value="${beforeYmd}"	class="input_off datePicker stext" size="8"
				style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
			</font>
			~
			<font><input type="text" id="REQDUE_END_DT" name="REQDUE_END_DT" value="${thisYmd}" class="input_off datePicker stext" size="8"
				style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
			</font>
         </td>
        </tr>
        <tr> 
        <!-- 완료예정일 -->
        <th>${menu.LN00221}</th>
        <td colspan="3">     
            <font><input type="text" id="DUE_STR_DT" name="DUE_STR_DT" value="${beforeYmd}"	class="input_off datePicker stext" size="8"
				style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
			</font>
			~
			<font><input type="text" id="DUE_END_DT" name="DUE_END_DT" value="${thisYmd}" class="input_off datePicker stext" size="8"
				style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
			</font>
         </td>
         
        <!-- 처리완료일 -->
        <th>${menu.LN00223}</th>
        <td colspan="3" class="last">     
            <font><input type="text" id="ACT_STR_DT" name="ACT_STR_DT" value="${beforeYmd}"	class="input_off datePicker stext" size="8"
				style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
			</font>
			~
			<font><input type="text" id="ACT_END_DT" name="ACT_END_DT" value="${thisYmd}" class="input_off datePicker stext" size="8"
				style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
			</font>
         </td>         
     </tr>       
  </table>
	   
 <!-- PROJECT_LIST_GRID(ISSUE) -->
 <div class="countList pdT10">
     <li class="count">Total <span id="TOT_CNT"></span></li>
     <li class="floatR">
     	<c:if test="${issueMode == 'ARC'}">     
	     	<c:if test="${pjtRelCnt > 0}">       
	     	&nbsp;<span id="btnAdd" class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="goAddIssue()"></span>
	     	</c:if>
     	</c:if>&nbsp;
     	<c:if test="${issueMode == 'PjtMgt'}">
     		<c:if test="${parentSts != 'CLS'}">
     			<c:if test="${pjtRelCnt > 0}">      
			     	<c:if test="${csrCnt > 0}">       
			     	&nbsp;<span id="btnAdd" class="btn_pack small icon"><span class="add"></span><input value="Add" type="submit" onclick="goAddIssue()"></span>
			     	</c:if>
		     	</c:if>
	     	</c:if>
     	</c:if>
     	<c:if test="${issueMode == 'CSR' && screenType != 'csrDtl'}">      
	    	&nbsp;<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="goPjtInfo()" type="submit"></span>
	    </c:if>
     </li>
 </div>
 
<div id="gridIssueDiv" style="width:100%;" class="clear" >
	<div id="grdIssueGridArea" ></div>
</div>
<!-- END :: LIST_GRID -->
<!-- START :: PAGING -->
<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
<!-- END :: PAGING -->	

</form>
<!-- START :: FRAME --> 		
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>
<!-- END :: FRAME -->
