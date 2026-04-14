<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<%-- <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%> --%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
	
	var scrnType = "${scrnType}";
	var srMode = "${srMode}";
	var esType = "${esType}";
	var srType = "${srType}";
	var itemID = "${itemID}";
	var multiComp = "${multiComp}";
	var itemTypeCode = "${itemTypeCode}";
	var menuStyle = "${menuStyle}";
	var srStatus = "${srStatus}";
	var status = "${status}";
	var searchStatus = "${searchStatus}";
	var srArea1ListSQL = "${srArea1ListSQL}";
	
	// search data 셋팅
	var searchData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=" + srType;
	var srArea1Data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}";
	if(esType != "" && esType !== null && esType !== undefined){
		srArea1Data += "&srType=" + esType;
	} else {
		srArea1Data += "&srType=" + srType;
	}
	
	$(document).ready(function(){
			// 초기 표시 화면 크기 조정
			$("#layout").attr("style","height:"+(setWindowHeight() - 300)+"px;");
			// 화면 크기 조정
			window.onresize = function() {
				$("#layout").attr("style","height:"+(setWindowHeight() - 300)+"px;");
			};
			
			// 메뉴 스타일 조절
			if(menuStyle != null && menuStyle != ""){
				$("#srListDiv").addClass("mgT10 mgB10 mgR10 mgL10");
			}
			if("${itemID}" != null && "${itemID}" != ""){
				$("#actFrame").css("overflow-y","");
			}
			
			// 초기값 셋팅 및 검색 옵션 list 출력
			if(srArea1ListSQL == null || srArea1ListSQL == "") srArea1ListSQL = "getESMSRArea1";
			
			//fnSelect('srStatus', searchData+"&itemClassCode=CL03004", 'getSRStatusList', '${searchStatus}', 'Select', 'esm_SQL');
			fnSelect('requestTeam', searchData, 'getESMSRReqTeamID', '${requestTeam}', 'Select','esm_SQL');	
	  		fnSelect('srReceiptTeam', searchData, 'getESMSRReceiptTeamID', '${srReceiptTeam}', 'Select', 'esm_SQL');	
			
	  		// 우선 로그인 한 고객의 customerNo가 들어가기
	  		fnSelect('customerNo', searchData, 'getESPCustomerList', '', 'Select', 'esm_SQL');
	  		// customerNo가 지정되어야 선택 가능
	  		fnSelect('srArea1', srArea1Data + "&itemTypeCode=${itemTypeCode}&customerNo=${customerNo}", srArea1ListSQL, '${srArea1}', 'Select','esm_SQL');
	  		fnSelect('category', searchData +"&level=1&customerNo=${customerNo}", 'getESMSRCategory', '${category}', 'Select','esm_SQL');
	  		
			// customerNo change event
	  		$("#customerNo").on("change", function(){
	  			fnClearSearchSR('C');
	  			var customerNo = $("#customerNo").val();
	  			doSearchList('${srMode}');
	  			fnGetSRArea1(customerNo);
	  		});
			
	  		// category change event
	  		$("#srArea1").on("change", function(){
	  			var customerNo = $("#customerNo").val();
	  			var srArea1 = $("#srArea1").val();
	  			fnGetSRArea2(srArea1,customerNo);
	  		});
			
	  		// category change event
	  		$("#category").on("change", function(){
	  			var customerNo = $("#customerNo").val();
	  			var category = $("#category").val();
	  			fnGetSubCategory(category,customerNo);
	  		});
	  		
	  		
	  		
			$("input.datePicker").each(generateDatePicker);
			
			// 버튼제어
			$('#searchValue').keypress(function(onkey){
				if(onkey.keyCode == 13){
					doSearchList('${srMode}');
					return false;
				}
			});		
			$("#excel").click(function(){
				exportXlsx();
				return false;
			});
			
			// 외부 Link 설정
			parent.top.$('#mainType').val("");
			if(srMode == "REG"){
				fnRegistSR();
			}else if("${srID}" != "" && parent.$("#scrnType").val() == "srRcv"){ // 외부에서 접수 페이지 바로가기 
				fnGoDetail();
				parent.$("#scrnType").val("");
			}else if("${mainType}"=="SRDtl" || "${mainType}" == "mySRDtl" || "${mainType}" == "SRDtlView"){
				if("${srID}" != ""){ fnGoDetail();
				}else{ setTimeout(function() { /*doSearchList('');*/},500 );}
			}else{
				setTimeout(function() { /*doSearchList('');*/ },500 );
			}
			
			if("${itemID}" != null && "${itemID}" != ""){
				$("#actFrame").css("overflow-y","");
			}
			
	});
	
	// 높이 조절	
	function setWindowHeight(){
		var size = window.innerHeight;
		var height = 0;
		if( size == null || size == undefined){
			height = document.body.clientHeight;
		}else{
			height=window.innerHeight;
		}return height;
	}
	
	// 외부 Link 접속 시 detail 페이지 이동
	function fnGoDetail(){
		var scrnType = "${scrnType}";
		var mainType = "${mainType}";
		var srID = "${srID}";
		var customerNo = $("#customerNo").val();
		var url = "processVOCP.do";
		var data = "&customerNo="+customerNo
					+"&srMode=${srMode}&esType=${esType}&srType=${srType}&scrnType=${scrnType}&itemProposal=${itemProposal}&srID="+srID
					+"&mainType="+mainType+"&itemID="+itemID+"&srStatus="+srStatus+"&projectID=${projectID}";
		var target = "srListDiv";
		ajaxPage(url, data, target);
	}
	
	function setSearchData(){
		
		var srStatus = "";
		if("${srStatus}" != "")	srStatus = "${srStatus}";
		
		var srType = "REQ";
		
		var searchData = "&customerNo="+customerNo
		+"&srMode=${srMode}"
		+"&esType=${esType}"
		+"&srType=" + srType
		+"&scrnType=${scrnType}"
		+"&mainType=${mainType}"
		+"&srStatus=${srStatus}"
		+ "&category="+$("#category").val()
		+ "&subCategory="+$("#subCategory").val()
		+ "&srArea1=" + $("#srArea1").val()
		+ "&srArea2=" + $("#srArea2").val()
		+ "&status=" + $("#status").val()
		+ "&searchSrCode=" + $("#srCode").val()
		+ "&subject=" + $("#subject").val()
		+ "&searchStatus=" +$("#srStatus").val()
		+ "&srReceiptTeam=" + $("#srReceiptTeam").val()
		+ "&requestUser=" +$("#requestUser").val()
		+ "&requestTeam=" +$("#requestTeam").val()
		+ "&regStartDate=" +$("#regStartDate").val()
		+ "&regEndDate=" +$("#regEndDate").val()
		+ "&searchSrCode=" +$("#srCode").val()
		+ "&defCategory=${defCategory}"
		+ "&startEventCode=${startEventCode}";
		
		return searchData;
		
	}
	
	// SR 등록
	function fnRegistSR(){
		var sysCode = parent.parent.$('#sysCode').val();
		var proposal = parent.parent.$('#proposal').val();
		var url = "registerVOCP.do";
		var target = "srListDiv";
		if(srMode == "REG"){srMode = "";}
		ajaxPage(url, setSearchData(), target);
	}
	
	// SR 등록 [ CallCenter ]
	function fnRegist(){
		var url = "registerESP.do";
		var target = "srListDiv";
		ajaxPage(url, setSearchData(), target);
	}
	
	// customerNo에 따른 검색 폼 setting
	function fnGetSRArea1(customerNo){
		fnSelect('srArea1', srArea1Data + "&itemTypeCode=${itemTypeCode}&customerNo=" + customerNo , srArea1ListSQL, '${srArea1}', 'Select','esm_SQL');
  		fnSelect('category', searchData + "&level=1&customerNo=" + customerNo, 'getESMSRCategory', '${category}', 'Select','esm_SQL');
	}
	
	// srArea2 설정
	function fnGetSRArea2(SRArea1ID,customerNo){
		srArea2 = null;
		if(SRArea1ID == ''){
			$("#srArea2 option").not("[value='']").remove();
		} else {
			var data = srArea1Data + "&parentID="+SRArea1ID+"&itemTypeCode=${itemTypeCode}" + "&customerNo=" + customerNo;
			fnSelect('srArea2', data, 'getSrArea2', '${srArea2}', 'Select');
		}
	}
	// subCategory 설정
	function fnGetSubCategory(parentID,customerNo){
		subCategory = null;
		if(parentID == ''){
			$("#subCategory option").not("[value='']").remove();
		} else {
			fnSelect('subCategory', searchData + "&parentID="+parentID + "&customerNo=" + customerNo, 'getESMSRCategory', '${subCategory}', 'Select', 'esm_SQL');
		}
	}
		
	// 검색 조건 초기화 
	function fnClearSearchSR(mode){;
		$("#srArea1").val("");
		$("#srArea2").val("");
		$("#category").val("");
		$("#subCategory").val("");
		
		if(mode != 'C'){
		$("#srStatus").val("");
		$("#regStartDate").val("");
		$("#regEndDate").val("");
		$("#requestUser").val("");
		$("#receiptUser").val("");
		$("#srCode").val("");
		$("#subject").val("");
		$("#requestTeam").val("");
		$("#srReceiptTeam").val("");
		$("#customerNo").val("");
		}
		
		return;
	}
	
	//===============================================================================
	// BEGIN ::: EXCEL ( + Comment )
	function exportXlsx() {
		fnGridExcelDownLoad(excelGrid);
	};
	
</script>

<div id="srListDiv" style="display: block;height: 100%;overflow: hidden auto;">

<form name="srFrm" id="srFrm" action="" method="post"  onsubmit="return false;">
	<input type="hidden" id="NEW" name="NEW" value="">
	<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<input type="hidden" id="srMode" name="srMode">
	<input type="hidden" id="startEventCode" name="startEventCode" value="${startEventCode}" />
	
	<div class="floatL mgT10 mgB12"><h3><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;요청 목록</div></h3>
	
	<!-- customer list -->
	<div class="floatR mgT10 mgB10">
        	Company
        	<span id="customerSelect">&nbsp;&nbsp;<select id="customerNo" Name="customerNo" style="width:150px;"></select></span>    
	</div>
	
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
		<colgroup>
		    <col width="8%">
		    <col width="17%">
		 	<col width="8%">
		    <col width="17%">
		 	<col width="8%">
		    <col width="17%">
		    <col width="8%">
		    <col width="17%">
	    </colgroup> 
	    <tr>
	   		<!-- 도메인 -->
	       	<th class="alignL">${srAreaLabelNM1}</th>
	        <td class="alignL">     
		       	<select id="srArea1" Name="srArea1" style="width: 100%;display: inline-block;">
		       		<option value=''>Select</option>
		       	</select>
	       	</td>
	       	<!-- 시스템 -->
	        <th class="alignL">${srAreaLabelNM2}</th>
	        <td class="alignL">      
	        <select id="srArea2" Name="srArea2" onchange="fnSetValueInit(this.id)" style="width: 100%;display: inline-block;">
	            <option value=''>Select</option>
	        </select>
	        </td>
	       	<!-- 카테고리 -->
	       	<th class="alignL">${menu.LN00272}</th>
	        <td class="alignL">       
		       	<select id="category" Name="category" style="width: 100%;display: inline-block;">
		       		<option value=''>Select</option>
		       	</select>
	       	</td>       	
	       	<!-- 서브 카테고리 -->
	       <th class="alignL">${menu.LN00273}</th>
	       <td class="alignL">      
		        <select id="subCategory" Name="subCategory" onchange="fnSetValueInit(this.id)" style="width: 100%;display: inline-block;">
		            <option value=''>Select</option>
		        </select>
	        </td>     
	    </tr>
		<tr> 
			<!-- 요청자 -->
			<th class="alignL">${menu.LN00025}</th>
			<td><input type="text" class="text" id="requestUser" name="requestUser" value="${requestUser}" style="ime-mode:active; width:98%;" /></td>
			<!-- 요청 부서 -->
			<th class="alignL">${menu.LN00026}</th>
			<td  class= "alignL">     
				<select id="requestTeam" Name="requestTeam" style="width:100%">
					<option value=''>Select</option>
				</select>
			</td>
			<!-- 담당자 -->
			<th class="alignL">${menu.LN00219}</th>
			<td><input type="text" class="text" id="receiptUser" name="receiptUser" value="${receiptUser}" style="ime-mode:active;  width:98%;" />
			<!-- 담당 부서 -->
			<th class="alignL">${menu.LN00153}</th>
			<td class= "alignL">     
				<select id="srReceiptTeam" Name="srReceiptTeam" style="width:100%">
					<option value=''>Select</option>
				</select>
			</td>
		</tr>
		<tr>
			<!-- 요청일-->
			<th class="alignL">${menu.LN00093}</th>     
	        <td>     
	            <input type="text" id="regStartDate" name="regStartDate" value="${regStartDate}"	class="input_off datePicker stext" size="8"
					style="width:calc((100% - 74px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="15" >
				
				~
				<input type="text" id="regEndDate" name="regEndDate" value="${regEndDate}"	class="input_off datePicker stext" size="8"
					style="width: calc((100% - 74px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="15">
				
	        </td> 		      
			<!-- 제목-->
	        <th class="alignL" >${menu.LN00002}</th>     
		    <td colspan=3><input type="text" class="text" id="subject" name="subject" value="${subject}" style="ime-mode:active; width:99.2%;" /></td>
		    
		    <!-- 상태 -->
			<th class="alignL">${menu.LN00027}</th>
			<td>      
				<select id="srStatus" Name="srStatus" style="width:100%">
					<option value='ALL'>ALL</option>
					<option value='ING'>Processing</option>
					<option value='COMPL'>Complete</option>
				</select>
			</td> 
		</tr>
	</table>
	
	<div class="countList pdT5 pdB5" >
		<li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
           	&nbsp;<span id="viewSearch" class="btn_pack medium icon"><span class="search"></span><input value="Search" type="submit" onclick="doSearchList('${srMode}');" style="cursor:hand;"></span>
           	<c:if test="${scrnType != 'srRqst' &&( itemID eq '' || itemID eq null) }" >
		      	<span id="viewSave" class="btn_pack medium icon"><span class="search"></span><input value="Transfered" type="submit" onclick="doSearchList('myTR');" style="cursor:hand;"></span>
           	</c:if>
           	<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="cursor:pointer;" onclick="fnClearSearchSR();">
        	&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Register" type="submit" id="new" style="cursor:hand;" onclick="fnRegistSR();"></span>&nbsp;
        	&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Register CC" type="submit" id="new2" style="cursor:hand;" onclick="fnRegist();"></span>&nbsp;
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
        </li>
    </div>
</form>

<div style="width:100%;" id="layout"></div>
<div id="pagination" style="margin-top: 60px;"></div>

</div>


<div style="display:none;" id="excelGrid"></div>

<script type="text/javascript">
var layout = new dhx.Layout("layout", {
    rows: [
        {
            id: "a",
        },
    ]
});

var gridData = ${gridData};
var grid = new dhx.Grid("grdOTGridArea", {
    columns: [
        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
        { width:120, id: "SRTypeNM", header: [{ text: "${menu.LN00011}" , align: "center" }], align: "center" },
        { width: 120, id: "SRCode", header: [{ text: "${menu.LN00396}" , align: "center" }, { content: "inputFilter" }], align: "center" },
        { id: "Subject", header: [{ text: "${menu.LN00002}" , align: "center" }, { content: "inputFilter" }], align: "left" },
        { hidden: true,  id: "Description", header: [{ text: "${menu.LN00003}" , align: "center"}], align: "center" },
        { width: 90, id: "StatusName", header: [{ text: "${menu.LN00027}" , align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 180, id: "RequestInfo", header: [{ text: "${menu.LN00025}" , align: "center" }, { content: "inputFilter" }], align: "center" },
        { width: 90,  id: "CompanyName", header: [{ text: "${menu.LN00014}" , align: "center" }], align: "center" },
        { hidden: true,  id: "ResponseTeamName", header: [{ text: "본부" , align: "center" }], align: "center" },
        { hidden: true,  id: "ItemTypeCodeNM", header: [{ text: "${menu.LN00021}" , align: "center" }], align: "center" },
        { hidden: true,  id: "SubCategoryNM", header: [{ text: "${menu.LN00272}" , align: "center" }], align: "center" },
        { width: 90, id: "SRArea1Name", header: [{ text: "${srAreaLabelNM1}" , align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 90, id: "SRArea2Name", header: [{ text: "${srAreaLabelNM2}" , align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 120, id: "ReceiptInfo", header: [{ text: "${menu.LN00219}" , align: "center" }, { content: "inputFilter" }], align: "center" },
        { width: 120, id: "ProcRoleTypeName", header: [{ text: "${menu.LN00109}" , align: "center" }, { content: "inputFilter" }], align: "center" },
        { width: 120, id: "ProcRoleTypeMemberList", header: [{ text: "작업그룹멤버" , align: "center" }, { content: "inputFilter" }], align: "center" },
        { width: 120, id: "RegDate", header: [{ text: "${menu.LN00093}" , align: "center" }], align: "center" },
        { hidden: true, id: "SRDueDate", header: [{ text: "${menu.LN00221}" , align: "center" }], align: "center" },
        { hidden: true,  id: "SRID", header: [{ text: "srID" , align: "center" }], align: "center" },
        { hidden: true,  id: "ReceiptUserID", header: [{ text: "ReceiptUserID" , align: "center" }], align: "center" },
        { hidden: true, id: "Status", header: [{ text: "Status" , align: "center" }], align: "center" },
        { width: 120, id: "SRCompletionDT", header: [{ text: "${menu.LN00223}" , align: "center" }], align: "center" },
        { hidden: true,  id: "ReceiptTeamName", header: [{ text: "ReceiptTeamName" , align: "center" }], align: "center" },
        { hidden: true,  id: "Comment", header: [{ text: "Comment" , align: "center" }], align: "center" },
    ],
    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    data: gridData
});
layout.getCell("a").attach(grid);

// excel용 grid 제작
var excelheader = JSON.parse(JSON.stringify(grid.config.columns));
excelheader[2].$width = 500;
excelheader[3].hidden = false;
excelheader[3].$width = 500;
excelheader[19].hidden = false;
excelheader[19].$width = 500;
var excelGrid = new dhx.Grid("excelGrid", {
	 columns: excelheader,
	 data: gridData
});

// row click event
grid.events.on("cellClick", function (row,column,e) {
	doDetail(row);
});

// filer search 시 total 값 변경
grid.events.on("filterChange", function(value,colId,filterId){
	$("#TOT_CNT").html(grid.data.getLength());
});

// 페이징
var pagination = new dhx.Pagination("pagination", {
    data: grid.data,
    pageSize: 20,
});

$("#TOT_CNT").html(grid.data.getLength());

// 상세 페이지 이동
function doDetail(data){
	var scrnType = "${scrnType}";
	var srCode = data.SRCode;
	var srID = data.SRID;
	var status = data.Status;
	
	var srStatus = "";
	if("${srStatus}" != "")	srStatus = "${srStatus}";
	
	var itemTypeCode = "";
	if("${itemTypeCode}" != "")	itemTypeCode = "${itemTypeCode}";
	else itemTypeCode = $("#itemTypeCode").val();
	if(itemTypeCode == undefined) itemTypeCode = "";
	
	var receiptUserID = data.ReceiptUserID;
	if(receiptUserID == undefined) receiptUserID = "";
	
	var url = "processVOCP.do";
	var data = "srCode="+srCode+"&customerNo="+$("#customerNo").val()
				+ "&srMode=${srMode}&esType=${esType}&srType=${srType}&scrnType=${scrnType}&itemProposal=${itemProposal}&srID="+srID
				+ "&receiptUserID="+receiptUserID+"&projectID=${projectID}"
				+ "&category=" + $("#category").val()
				+ "&subCategory=" + $("#subCategory").val()
				+ "&srArea1=" + $("#srArea1").val()
				+ "&srArea2=" + $("#srArea2").val()
				+ "&srCode=" + $("#srCode").val()
				+ "&subject=" + $("#subject").val()
				+ "&srStatus=" +srStatus
				+ "&status=" +status
				+ "&searchStatus=" +$("#srStatus").val()
				+ "&receiptUser=" + receiptUserID
				+ "&srReceiptTeam=" + $("#srReceiptTeam").val()
				+ "&requestUser=" +$("#requestUser").val()
				+ "&requestTeam=" +$("#requestTeam").val()
				+ "&regStartDate=" +$("#regStartDate").val()
				+ "&regEndDate=" +$("#regEndDate").val()
				+ "&searchSrCode=" +$("#srCode").val()
				+ "&itemID="+itemID
				+ "&multiComp=${multiComp}"
				+ "&itemTypeCode="+itemTypeCode
				+ "&defCategory=${defCategory}";
	var target = "srListDiv";		
	ajaxPage(url, data, target);
}

// 검색
function doSearchList(srMode){
	if(srMode == null && srMode == ""){
		srMode = "${srMode}";	
	}
	var sqlID = "esm_SQL.getEsrMSTList";
	var param = $("#srFrm").serialize(); // 폼 데이터 직렬화
	param += "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
	+ "&scrnType=" + scrnType
	+ "&srMode=" +srMode
	+ "&srType=" +srType
	+ "&itemID=" +itemID
	+ "&sqlID="+sqlID;
	
	if((searchStatus != '' && searchStatus != null) || ($("#srStatus").val() != '' && $("#srStatus").val() != null)) {
		param = param + "&srStatus=" + $("#srStatus").val();
	} else 	if(srStatus != '' & srStatus != null ){
		param = param + "&srStatus="+srStatus;
	} else if(status != '' & status != null ){
		param = param + "&srStatus="+status;
	} 
	if (srMode == "mySR" || srMode == "myVOC" || srMode == "myTR" || srMode == "myRole" || srMode == "myClient" || srMode == "myPJT") {
		param = param + "&loginUserId=${sessionScope.loginInfo.sessionUserId}";
	}else if(srMode == "PG" || srMode == "PJT") {
		param = param + "&refID=${refID}";
	}else if (srMode == "myTeam") {
		param = param + "&myTeamId=${sessionScope.loginInfo.sessionTeamId}";
	}
	
	if($("#customerNo").val() != "" & $("#customerNo").val() != null){
		param = param + "&clientID=" + $("#customerNo").val();
	}
	
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
		$("#TOT_CNT").html(grid.data.getLength());
}

</script>