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
<!--  DHTMLX7 업그레이드  -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
	var p_gridArea;				// 그리드 전역변수(Project)
	var p_gridArea_Cngt;				// 그리드 전역변수(ChangeSet)
	var screenType = "${screenType}";
	var mainType = "${mainType}";
	
	var companyID = "${companyID}";
	changePjtList("${refPGID}");
	$(document).ready(function() {	
		
		$("input.datePicker").each(generateDatePicker); // calendar
		
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 280)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 280)+"px;");
		};

		$('#ProjectGroup').change(function(){
			changePjtList($(this).val()); // 변경오더 option 셋팅
		});
		
		$("#MulStatus").change(function(){
			changeStatus($(this).val());
		});
		
		$("input[name=mbrTypeList]").change(function(){

		//	doSearchPjtList();
		})
		
		if(screenType == "MYSPACE")
			changeStatus("ING");
		
		setTimeout(function() { 

		},1000 );
		
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

	

	// 그리드ROW선택시 : 변경오더 조회 화면으로 이동
	function gridOnPjtRowSelect(projectID){
		
		
		var screenMode = "V";
		var mainMenu = "${mainMenu}";

		var url = "csrDetailPop.do?ProjectID=" + projectID + "&screenMode=" + screenMode + "&mainMenu=" + mainMenu;
				
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
		var url = "registerCSR.do?&mainMenu=${mainMenu}&refPjtID=${refPjtID}&screenType=${screenType}&Priority=03";
		var w = 1100;
		var h = 440;
		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
	}

	// [변경오더 option] 설정
	function changePjtList(avg){
		var url    = "getPjtListOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&screenType=myPage&projectID="+avg ; //파라미터들
		var target = "Project";             // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		if("${screenType}" == "pjtInfoMgt")defaultValue = "${projectID}";
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
	function fnClearSearch(){
	$("#ProjectGroup").val("");
	$("#Project").val("");
	$("#Status").val("");
	$("#MulStatus").val("");
	$("#REQ_STR_DT").val("");
	$("#REQ_END_DT").val("");
	$("#ProjectCode").val("");

	$("#CLS_STR_DT").val("");
	$("#CLS_END_DT").val("");
    fnClearFilter("ProjectName");
	fnClearFilter("ParentName");
	fnClearFilter("AuthorTeamName");
	fnClearFilter("AuthorName");
	fnClearFilter("StatusName");
    fnClearFilter("PriorityName");
    fnClearFilter("ChangeStatus");
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
       	 <c:choose>
       	  	<c:when test="${screenType eq 'pjtInfoMgt' }" >
	       		<select id="ProjectGroup" Name="ProjectGroup" style="width:80%" onchange="doSearchPjtList()" >
		            	<option value=''>Select</option>
			           	<c:forEach var="i" items="${pgList}">
			           		<option value="${i.CODE}" <c:if test="${i.CODE eq refPGID}">Selected="Selected"</c:if> >${i.NAME}</option>
			           	</c:forEach>
			       	</select>
	        </c:when>
	        <c:otherwise>
	        	<c:if test="${screenType != 'PJT'}">
	        		<select id="ProjectGroup" Name="ProjectGroup" style="width:80%" onchange="doSearchPjtList()">
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
	        </c:otherwise>	
	       </c:choose>	       	
	       </td>

        
    	<!-- 요청일 -->
        <th class="alignL pdL10">${menu.LN00013}</th>
        <td class="alignL pdL10">     
        <input type="hidden" id="currPage" name="currPage" value="${currPage}" />
            <input type="text" id="REQ_STR_DT" name="REQ_STR_DT" value="${beforeYmd}"	class="input_off datePicker stext" size="8"
				style="width: 30%;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
			
			~
			<input type="text" id="REQ_END_DT" name="REQ_END_DT" value="${thisYmd}"	class="input_off datePicker stext" size="8"
				style="width: 30%;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
			
         </td>
        
         
        <!-- 마감일 -->
        <th class="alignL pdL10">${menu.LN00062}</th>
        <td class="alignL pdL10 last">     
            <input type="text" id="CLS_STR_DT" name="CLS_STR_DT" value="${beforeYmd}"	class="input_off datePicker stext" size="8"
				style="width:30%;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
			
			~
			<input type="text" id="CLS_END_DT" name="CLS_END_DT" value="${thisYmd}" class="input_off datePicker stext" size="8"
				style="width: 30%;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
			
         </td>
         
      
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
 
<div id="gridPjtDiv" style="width:100%;" class="clear mgB10" >
	<div id="grdGridArea" ></div>
</div>
<!-- END :: LIST_GRID -->
<!-- START :: PAGING -->
<div style="width:100%;" class="paginate_regular">
<div id="pagination" ></div>
</div>
<!-- END :: PAGING -->	

</form>
<!-- START :: FRAME --> 		
<div class="schContainer" id="schContainer">
	<iframe name="blankFrame" id="blankFrame" style="width:0px;height:0px; display:none;"></iframe>
</div>	
<!-- END :: FRAME -->

<!-- DHTML 7 Grid init -->

<script type="text/javascript">


var layout = new dhx.Layout("grdGridArea", {
			rows : [ {
				id : "a",
			}, ]
		});	
		var gridData = ${gridData}; 
		
		var grid = new dhx.Grid("grdGridArea", {
		    columns: [
		        { fillspace :true,width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
		        { hidden:true, fillspace : true, id: "CHK", 
		        	header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>", align:"center"}]
		                  , align: "center", type: "boolean", editable: true, sortable: false   },
		        
		        { fillspace : true, id: "ProjectCode", header: [{ text: "${menu.LN00129}" , align: "center" }, { content: "" }],align: "center" },
		        { fillspace : true,width: 300, id: "ProjectName", header: [{ text: "${menu.LN00028}" , align: "center" }, { content: "inputFilter" }],align: "left" },
		        { fillspace : true, id: "ParentName", header: [{ text: "${menu.LN00131}" , align: "center" }, { content: "selectFilter" }],align: "center" },
		        { fillspace : true, id: "AuthorTeamName", header: [{ text: "${menu.LN00153}" , align: "center" }, { content: "inputFilter" }], align: "center" },
		        { fillspace : true, id: "AuthorName", header: [{ text: "${menu.LN00266}" , align: "center" }, { content: "inputFilter" }],align: "center"  },
		        { fillspace : true, id: "CreationTime", header: [{ text: "${menu.LN00013}" , align: "center" }],align: "center" },
		        { fillspace : true, id: "DueDate", header: [{ text: "${menu.LN00062}" , align: "center" }],align: "center" },
		        { fillspace : true, id: "PriorityName", header: [{ text: "${menu.LN00067}" , align: "center" }, { content: "selectFilter" }],align: "center" },
		        { fillspace : true, id: "StatusName", header: [{ text: "${menu.LN00027}" , align: "center" }, { content: "selectFilter" }],align: "center" },
		        { hidden:true, fillspace : true, id: "WFName", header: [{ text: " "  }, { content: "" }], align: "" },
		        { hidden:true, fillspace : true, id: "CurWFStepName", header: [{ text: " "}, { content: "" }], align: "" },
		        { hidden:true, fillspace : true, id: "ProjectID", header: [{ text: " " , align: "center" }, { content: "" }], align: "" },
		        { hidden:true,fillspace : true, id: "ProjectType", header: [{ text: " " , align: "" }, { content: "" }], align: "" },
		        { hidden:true,fillspace : true, id: "WFID", header: [{ text: " " , align: "" }, { content: "" }], align: "" },
		        { hidden:true,fillspace : true, id: "AuthorID", header: [{ text: "" , align: "" }, { content: "" }], align: "" },
		        { hidden:true,fillspace : true, id: "Creator", header: [{ text: " " , align: "" }, { content: "" }], align: "" },
		        { hidden:true,fillspace : true, id: "PjtMemberIDs", header: [{ text: "" , align: "" }, { content: "" }], align: "" },
		        { hidden:true,fillspace : true, id: "CNGT_CNT", header: [{ text: "" , align: "" }, { content: "" }], align: "" },
		        { hidden:true,fillspace : true, id: "Status", header: [{ text: " " , align: "" }, { content: "" }], align: "" },
		        { fillspace : true, id: "ChangeStatus", header: [{ text: "${menu.LN00139}" , align: "center" }, { content: "selectFilter" }],align:"center" },
		        { hidden:true,fillspace : true, id: "ParentID", header: [{ text: " "  }, { content: "" }], align: "" },
		       
		    ],
		    eventHandlers: {
		        onclick: {
		           /*   "Action": function (e, data) {
		            	fnEditTmp(data.row);
		            } 
		             */
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
		
		
		pagination.setPage(document.getElementById('currPage').value);
	
		function doSearchPjtList(){
			
			let	sqlID = "project_SQL.getSetProjectListForCsr";

			let param ="&filter=CSR" 
				        +"&csrStatus=${csrStatus}"
				        +"&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			 	        +"&screenType="+screenType
			 	        +"&pageNum="+$("#currPage").val()
			 	        +"&pjtGRID=" + $("#ProjectGroup").val()
			 	        +"&reqStartDt="+$("#REQ_STR_DT").val()
						+"&reqEndDt="+$("#REQ_END_DT").val()
						+"&clsStartDt=" +$("#CLS_STR_DT").val()
						+"&clsEndDt="+$("#CLS_END_DT").val()
						+"&sqlID="+sqlID;	 		
				$.ajax({
					url:"jsonDhtmlxListV7.do",
					type:"POST",
					data:param,
					success: function(result){
				
						fnReload(result);
					
					 
					},error:function(xhr,status,error){
						console.log("ERR :["+xhr.status+"]"+error);
					}
				});	
		
		}
		

	

	 	function fnReload(newGridData){
	 	
	 	    fnClearFilter("ProjectName");
	 	    fnClearFilter("ParentName");
	 	    fnClearFilter("AuthorTeamName");
	 	    fnClearFilter("AuthorName");
	 	    fnClearFilter("StatusName");
	 	    fnClearFilter("PriorityName");
	        fnClearFilter("ChangeStatus");
	 	
	 	
	 	    grid.data.parse(newGridData);
	 		$("#TOT_CNT").html(grid.data.getLength());
	 	} 

		function fnClearFilter(columnID) {
	 		var headerFilter = grid.getHeaderFilter(columnID);
	 		
	 		
	 		if(headerFilter){
	 			grid.getHeaderFilter(columnID).clear();
	 		}
	 	}
		
		
		
		grid.events.on("cellClick", function(row, column, e) {
		    var projectId  = row.ProjectID;
		   // var status = row.Status;
		   // var pjtCreator = row.Creator;
		   // var authorId = row.AuthorID;
		   // var parentID = row.ParentID;
		    
		   gridOnPjtRowSelect(projectId);
		    
		});
		
</script>

