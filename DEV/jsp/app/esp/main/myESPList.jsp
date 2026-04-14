<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 1. Include JSP -->
<%-- <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%> --%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>

<script type="text/javascript">
	
	var srArea1ListSQL = "${srArea1ListSQL}";
	var scrnType = "${scrnType}";
	var srMode = "${srMode}";
	var srType = "${srType}";
	var itemTypeCode = "${itemTypeCode}";
	var srStatus = "${srStatus}";
	var searchStatus = "${searchStatus}";
	var customerNo = "${customerNo}";
	var searchSrType = "${searchSrType}";
	var searchStatus = "${searchStatus}";
	var inProgress = false;
	
	var selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&esType=${esType}&myCSR=${myCSR}&myWorkspace=${myWorkspace}&procRoleTPGroup=${procRoleTPGroup}";
	
	$(document).ready(function(){
		// 검색조건 없을 경우 초기 요청일 2주로 검색
		if(!"${regStartDate}" && !"${regEndDate}") {
			
			var period = "${period}";
			if(period === null || period === '' || period === undefined) bDay = period = 180;
			
			var dateObject = setDefaultLocalDate(period);
			var regEndDate = dateObject["endDate"];
			var regStartDate = dateObject["startDate"];
			
			$("#regEndDate").val(regEndDate);
			$("#regStartDate").val(regStartDate);
		}
		
		// 초기 표시 화면 크기 조정
		$("#layout").attr("style","height:"+(setWindowHeight() - 320)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 320)+"px;");
		};
		
		// 초기값 셋팅 및 검색 옵션 list 출력
		if(srArea1ListSQL == null || srArea1ListSQL == "") srArea1ListSQL = "getESMSRArea1";
		
  		// sr Type
		fnSelect('srType', selectData, 'getSRTypeList', "${searchSrType}" , 'Select', 'esm_SQL');
		// 우선 로그인 한 고객의 customerNo가 들어가기
  		fnSelect('customerNo', selectData, 'getESPCustomerList', '${customerNo}', 'Select', 'esm_SQL');
  		
  		// sr Type change event
  		$("#srType").on("change", function(){
  			searchSrType = "";
  			fnGetSetting();
  		});
  		
  		$("#inProgress").on("change", function(){
  			//$("#srStatus").val("");
  			//searchStatus = "";
  		});
  		
  		$("#srStatus").on("change", function(){
  			//$("#inProgress").val("ALL");
  			searchStatus = "";
  		});
  		
		$("input.datePicker").each(generateDatePicker);
		
		// 버튼제어
		$('#searchValue').keypress(function(onkey){
			if(onkey.keyCode == 13){
				//doSearchList('${srMode}');
				doSearchList('${srMode}', '', 'Y');
				return false;
			}
		});
				
		getDicData("BTN", "LN0001").then(data => fnSetButton("search-btn", "search", data.LABEL_NM));
		getDicData("BTN", "LN0003").then(data => fnSetButton("clear", "clear", data.LABEL_NM,"secondary"));
		
		getDicData("BTN", "LN0005").then(data => document.querySelector('label[for="popup"]').innerText = data.LABEL_NM);
		getDicData("BTN", "LN0006").then(data => document.querySelector('label[for="companyNameHideShow"]').innerText = data.LABEL_NM);
		
		getDicData("GUIDELN", "ZLN0002").then(data => {
			document.querySelector("#srAreaSearch").placeholder = data.LABEL_NM;
			document.querySelector("#requestUser").placeholder = data.LABEL_NM;
		})
		
		doSearchList('${srMode}', '', 'Y');
		//doSearchList('${srMode}');
	});
	
	getArcName("${arcCode}", ".page-title");
	
	
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
	
	// 초기 검색 폼 setting
	function fnGetSetting(){
		fnSelect('srStatus', selectData+"&itemClassCode=CL03004&srType=" + $("#srType").val(), 'getSRStatusList', '${searchStatus}', 'Select', 'esm_SQL');
		//fnSelect('requestTeam', selectData + "&customerNo=" + $("#customerNo").val(), 'getESMSRReqTeamID', '${requestTeam}', 'Select','esm_SQL');	
		//fnSelect('srArea1', selectData + "&srType=${esType}&itemTypeCode=${itemTypeCode}&customerNo=" + $("#customerNo").val() + "&srType=${esType}", srArea1ListSQL, '${srArea1}', 'Select','esm_SQL');
  		//fnGetSRArea2();
  		//fnSelect('category', selectData + "&level=1&customerNo=" + $("#customerNo").val() + "&srType=" + $("#srType").val(), 'getESMSRCategory', '${category}', 'Select','esm_SQL');
  		//fnGetSubCategory();
  		
//   		fnSelect('activity', selectData+"&itemClassCode=CL03004&srType=" + $("#srType").val(), 'getSRStatusList', '${searchStatus}', 'Select', 'esm_SQL');
	}
	
	// srArea2 설정
	function fnGetSRArea2(SRArea1ID){
		srArea2 = null;
		if(SRArea1ID == '' || SRArea1ID === undefined){
			$("#srArea2 option").not("[value='']").remove();
		} else {
			var data = selectData + "&parentID="+SRArea1ID + "&customerNo=" + $("#customerNo").val() + "&srType=${esType}&itemTypeCode=${itemTypeCode}";
			fnSelect('srArea2', data, 'getSrArea2', '${srArea2}', 'Select');
		}
	}
	// subCategory 설정
	function fnGetSubCategory(parentID){
		subCategory = null;
		if(parentID == ''  || parentID === undefined){
			$("#subCategory option").not("[value='']").remove();
		} else {
			var data = selectData + "&parentID="+parentID + "&customerNo=" + $("#customerNo").val() + "&srType=" + $("#srType").val();
			fnSelect('subCategory', data, 'getESMSRCategory', '${subCategory}', 'Select', 'esm_SQL');
		}
	}
		
	// 검색 조건 초기화 
	function fnClearSearchSR(mode){
		searchSrType = "";
		searchStatus = "";
		$("#srType").val("");
		$("#srStatus").children().remove();
		$("#srStatus").append("<option value=''>Select</option>");
		$("#inProgress").val("ALL");
		$("#stSRCompDT").val("");
		$("#endSRCompDT").val("");

		$("#srCode").val("");
		$("#subject").val("");
		//$("#regStartDate").val("");
		//$("#regEndDate").val("");
		
		$("#requestUser").val("");
		$("#requestUserID").val("");
		$("#customerNo").val("");
		$("#srAreaSearch").val("");
		$("#srArea1").val("");
		$("#srArea2").val("");
		return;
	}
	
	document.getElementById("requestUserBtn").addEventListener("click", function() {
		searchPopupWf();
	});
	
	function searchPopupWf(){
		window.open("searchMemberPop.do?myClient=${myClient}&notCompanyIDs=22",'searchMemberPop','width=900, height=700');
	}
	
	function searchMemberCallback(avg1,avg2,avg3,avg4){
			$("#requestUser").val(avg2+"("+avg3+"/"+avg4+")");
			$("#requestUserID").val(avg1);
	}
	
	function fnClear(e1, e2, e3) {
		if(e1) $("#"+e1).val("");
		if(e2) $("#"+e2).val("");
		if(e3) $("#"+e3).val("");
	}
	
	document.getElementById("srAreaBtn").addEventListener("click", function() {
		searchSrArea();
	});
	
	function searchSrArea(){
		window.open('searchSrAreaPop.do?srType=${esType}&roleFilter=${roleFilter}&myCSR=${myCSR}','window','width=1000, height=500, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSrArea(clientID, srArea1, srArea2, srArea2Name){
		$("#srArea1").val(srArea1);
		$("#srArea2").val(srArea2);
		$("#srAreaSearch").val(srArea2Name);
	}
	
	function fnCompanyHideShow(){
		if( document.all("companyNameHideShow").checked == true){			
			grid.showColumn("CompanyName");
		}else{
			grid.hideColumn("CompanyName");
		}
	}
</script>
</head>
<body>

<div id="srListDiv" class="pdL10 pdR10">
<form name="srFrm" id="srFrm" action="" method="post"  onsubmit="return false;">
	<div class="page-title" style="display:inline-block;"></div>
	<c:if test="${not empty myWorkspace and not empty myWorkspaceName}">
		<div class="myWorkspaceName" style="display: inline-block; font-size: 15px;right: 0; font-weight: 700; margin-left: 5px;">
			( ${myWorkspaceName} )
		</div>
	</c:if>
	
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="form-column-4 new-form" id="search">
	    <tr>
	    	<!-- 프로세스 -->
	       	<th class="alignL">${menu.LN00011}</th>
	        <td class="alignL">     
		       	<select id="srType" Name="srType" style="width: 100%;display: inline-block;">
		       		<option value=''></option>
		       	</select>
	       	</td>
	       	<!-- 진행 단계 -->
			<th class="alignL">${menu.LN00132}</th>
			<td>      
				<select id="srStatus" Name="srStatus" style="width:100%">
				<option value=''>Select</option>
				</select>
			</td> 
	       	<!-- 진행 중 -->
			<th class="alignL">${menu.LN00121} </th>
			<td>      
				<select id="inProgress" Name="inProgress" style="width:100%">
					<option value='ALL'>ALL</option>
					<option value='ING'>Processing</option>
					<option value='COMPL'>Completed</option>
					<!-- <option value='TEMP'>임시 저장</option> -->
				</select>
			</td> 
       		<!-- 완료일-->
			<th class="alignL">${menu.LN00064}</th>
			<td >     
		      	<input type="text" id="stSRCompDT" name="stSRCompDT" value="${stSRCompDT}" class="input_off datePicker stext" size="8"
					style="width:63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				-
				<input type="text" id="endSRCompDT" name="endSRCompDT" value="${endSRCompDT}"	class="input_off datePicker stext" size="8"
					style="width: 63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="15">
       		</td>
		</tr>
		<tr>
			<th class="alignL">${menu.LN00396}</th>
			<td>      
				<input type="text" class="text" id="srCode" name="srCode" value="${srCode}" autocomplete="off"/>
			</td>
			<!-- 제목-->
	        <th class="alignL" >${menu.LN00002}</th>     
		    <td class="alignL" colspan=3 ><input type="text" class="text" id="subject" name="subject" value="${subject}" autocomplete="off"/></td>
			<!-- 요청일-->
			<th class="alignL">${menu.LN00093}</th>     
	        <td>     
				<input type="text" id="regStartDate" name="regStartDate" value="${regStartDate}"	class="input_off datePicker stext" size="8"
					onchange="this.value = makeDateType(this.value);"	maxlength="15" >
				-
				<input type="text" id="regEndDate" name="regEndDate" value="${regEndDate}"	class="input_off datePicker stext" size="8"
					onchange="this.value = makeDateType(this.value);"	maxlength="15">
	        </td>
	         <th class="alignL">${menu.LN00025}</th>
	         <td>
	         	<input type="text" class="text" id="requestUser" name="requestUser" value="${requestUser}" style="width: calc(100% - 24px);" disabled autocomplete="off" />
	         	<img src="${root}${HTML_IMG_DIR}/btn_close.png" style="position: absolute; top: 10px; right: 34px; width: 17px; cursor: pointer;" onclick="fnClear('requestUser', 'requestUserID')"/>
	         	<img id="requestUserBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" style="cursor: pointer;"/>
	         	<input type="hidden" id="requestUserID" name="requestUserID" value="${requestUserID}" />
	         </td>
		</tr>
		<tr>
			<th class="alignL">${menu.ZLN0018}</th>
	        <td class="alignL">     
		       	<select id="customerNo" Name="customerNo" style="width: 100%;display: inline-block;">
		       		<option value=''></option>
		       	</select>
	       	</td>
	       	<!-- srArea-->
			<th class="alignL">${srAreaLabelNM1}/${srAreaLabelNM2}</th>
		    <td>
		    	<input type="text" class="text" id="srAreaSearch" name="srAreaSearch" style="width: calc(100% - 24px);" disabled autocomplete="off" />
		    	<img src="${root}${HTML_IMG_DIR}/btn_close.png" style="position: absolute; top: 10px; right: 34px; width: 17px; cursor: pointer;" onclick="fnClear('srAreaSearch', 'srArea1', 'srArea2')"/>
		    	<img id="srAreaBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" style="cursor: pointer;"/>
				<input type="hidden" id="srArea1" name="srArea1" />
				<input type="hidden" id="srArea2" name="srArea2" />
				<ul class="autocomplete"></ul>
		    </td>
		    
		    <!-- 지연옵션 -->
		    <c:if test="${completionDelay eq 'Y'}">
		    <th class="alignL">${menu.ZLN0029}</th>
	        <td class="alignL">     
		       	<select id="delayOption" Name=delayOption style="width: 100%;display: inline-block;">
		       		<option value='01'>${menu.ZLN0030}</option>
		       		<option value='02'>${menu.ZLN0031}</option>
		       		<option value='03'>${menu.ZLN0032}</option>
		       	</select>
	       	</td>
	       	</c:if>
		</tr>
	</table>
	
	<div class="btn-wrap justify-center pdT10">
		<div class="btns">
			<button id="search-btn" onclick="doSearchList('${srMode}','','Y',0)"></button>
			<button id="clear" onclick="fnClearSearchSR()"></button>
		</div>
	</div>
	    
    <ul class="pdT20 pdB10 btn-wrap" >
		<li class="count">Total  <span id="TOT_CNT"></span></li>
		<li class="btns">
			<div>
				<input type="checkbox" id="popup" value="" class="switch" checked/>
				<label for="popup" class="switch_label"></label>
			</div>
			<div>
				<input type="checkbox" id="companyNameHideShow" name="companyNameHideShow" value="" class="switch" onClick="fnCompanyHideShow()" checked/>
				<label for="companyNameHideShow" class="switch_label"></label>
				</div>
		</li>
	</ul>
</form>

<div style="width:100%;" id="layout"></div>
<div class="align-center flex">
	<select id="pageRow" onchange="changePageSize(this.value)">
		<option value=10>10</option>
		<option value=20>20</option>
		<option value=30 selected>30</option>
		<option value=40>40</option>
		<option value=50>50</option>
		<option value=100>100</option>
	</select>
	<div id="pagination" style="position: relative;margin: 0 auto;"></div>
</div>

</div>
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" scrolling='no'></iframe>

<!-- <div style="display:none;" id="excelGrid"></div> -->

</body>
<script type="text/javascript">
let pageNo = 1;

// mode
if(srMode == "myToDo") $("#inProgress").val("ING");
if("${mbrRcdMgt}" == "Y") $("#inProgress").val("ING");
if("${procRoleTPGroup}" == "Y") $("#inProgress").val("ING");

// 검색조건 유지
if("${searchSrType}") $("#srType").val("${searchSrType}");
if("${customerNo}") $("#customerNo").val("${customerNo}");
if("${searchSrType}") fnSelect('srStatus', selectData+"&itemClassCode=CL03004&srType=${searchSrType}", 'getSRStatusList', '${searchStatus}', 'Select', 'esm_SQL');
if("${inProgress}") $("#inProgress").val("${inProgress}");
if("${stSRCompDT}") $("#stSRCompDT").val("${stSRCompDT}");
if("${endSRCompDT}") $("#endSRCompDT").val("${endSRCompDT}");
if("${searchSrCode}") $("#srCode").val("${searchSrCode}");
if("${subject}") $("#subject").val("${subject}");
if("${regStartDate}") $("#regStartDate").val("${regStartDate}");
if("${regEndDate}") $("#regEndDate").val("${regEndDate}");
if("${requestUser}") $("#requestUser").val("${requestUser}");
if("${requestUserID}") $("#requestUserID").val("${requestUserID}");
if("${srAreaSearch}") $("#srAreaSearch").val("${srAreaSearch}");
if("${srArea1}") $("#srArea1").val("${srArea1}");
if("${srArea2}") $("#srArea2").val("${srArea2}");

var layout = new dhx.Layout("layout", {
    rows: [
        {
            id: "a",
        },
    ]
});
var grid = new dhx.Grid("grdOTGridArea", {
    columns: [
        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
        { width: 120, id: "SRCode", header: [{ text: "${menu.LN00396}" , align: "center" }], align: "center" },
        { width: 120, id: "SRTypeNM", header: [{ text: "${menu.LN00011}" , align: "center" }], align: "center" },
        { width: 350, id: "Subject", header: [{ text: "${menu.LN00002}" , align: "center" }], align: "left" },
        { width: 120, id: "StatusName", header: [{ text: "${menu.LN00027}" , align: "center" }], align: "center" },
        { width: 120, id: "ReceiptInfo", header: [{ text: "${menu.LN00004} (${menu.LN00153})" , align: "center" }], align: "center" }, 
        
        { width: 120, id: "ProcRoleTypeName", header: [{ text: "${menu.LN00109}" , align: "center" }], align: "center" },
        { width: 120, id: "ProcRoleTypeMemberList", header: [{ text: "${menu.ZLN0033}" , align: "center" }], align: "center" },
        { width: 90, id: "RegDate", header: [{ text: "${menu.LN00093}" , align: "center" }], align: "center", template: function(value) { return value && typeof value === 'string' && value.includes(' ') ? value.split(' ')[0] : null; } },
        { hidden: false, width: 90,  id: "CompanyName", header: [{ text: "${menu.LN00014}" , align: "center" }], align: "center" },
        { width: 180, id: "RequestInfo", header: [{ text: "${menu.LN00025} (${menu.LN00026})" , align: "center" }], align: "center" },
        { width: 120, id: "SRArea1Name", header: [{ text: "${srAreaLabelNM1}" , align: "center" }], align: "center" },
        { width: 120, id: "SRArea2Name", header: [{ text: "${srAreaLabelNM2}" , align: "center" }], align: "center" },
        
        { width: 120,  id: "CategoryNM", header: [{ text: "${menu.LN00272}" , align: "center" }], align: "center" },
        { width: 120,  id: "SubCategoryNM", header: [{ text: "${menu.ZLN0034} ${menu.LN00272}" , align: "center" }], align: "center" },
        
        { width: 90, id: "ReqDueDate", header: [{ text: "${menu.LN00222}" , align: "center" }], align: "center",template: function(value) { return value && typeof value === 'string' && value.includes(' ') ? value.split(' ')[0] : null; } },
        { width: 90, id: "SRDueDate", header: [{ text: "${menu.LN00221}" , align: "center" }], align: "center",template: function(value) { return value && typeof value === 'string' && value.includes(' ') ? value.split(' ')[0] : null; } },
        { width: 120, id: "SRCompletionDT", header: [{ text: "${menu.LN00223}" , align: "center" }], align: "center",template: function(value) { return value && typeof value === 'string' && value.includes(' ') ? value.split(' ')[0] : null; } },
        
        { width: 90, id: "", header: [{ text: "${menu.ZLN0035}" , align: "center" }], align: "center", template: function (text, row, col) {
        	var result = "";
        	var comp = "";
        	comp = row.SRCompletionDT;
        	result = (comp !== undefined && comp !== null && comp.trim() !== '') ? "${menu.ZLN0036}" : "${menu.ZLN0037}";
        	
            return result;
        } },
        { width: 90, id: "CompletionDelay", header: [{ text: "${menu.ZLN0038}" , align: "center" }], align: "center", template: function (text, row, col) {
        	var result = text;
        	if("${completionDelay}" == "Y") result = "Y";
            return result;
        } },
       
    ],
    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    sortable:false
});
layout.getCell("a").attach(grid);

// row click event
grid.events.on("cellClick", function (row,column,e) {
	doDetail(row);
});

//filer search 시 total 값 변경
grid.events.on("filterChange", function(value,colId,filterId){
	$("#TOT_CNT").html(grid.data.getLength());
});

// 페이징
var pagination = new dhx.Pagination("pagination", {
    data: grid.data,
    pageSize : 30
});

// 페이징 삭제
pagination.events.on("change", function(index, previousIndex) {
	pageNo = index + 1;
	doSearchList('${srMode}');
});


function changePageSize(e) {
	pagination.setPageSize(parseInt(e));
}

$("#TOT_CNT").html(grid.data.getLength());


// 상세 페이지 이동
function doDetail(data){
	const isPopup = document.querySelector("#popup").checked;
	var srCode = data.SRCode;
	var srID = data.SRID;
	var status = data.Status;
	var srType = data.SRType;
	var esType = data.ESType;
	var receiptUserID = data.ReceiptUserID;
	if(receiptUserID == undefined) receiptUserID = "";
	
	var url = "esrInfoMgt.do";
	
	var data = "&srCode="+srCode + "&srID="+srID + "&status=" +status + "&srType=" +srType + "&receiptUserID=" + receiptUserID + "&esType=" + esType + "&isPopup="+isPopup;
	
	// 검색조건
	data += "&searchSrType="+$("#srType").val();
	data += "&searchStatus="+$("#srStatus").val();
	data += "&inProgress="+$("#inProgress").val();
	data += "&stSRCompDT="+$("#stSRCompDT").val();
	data += "&endSRCompDT="+$("#endSRCompDT").val();
	data += "&searchSrCode="+$("#srCode").val();
	data += "&subject="+$("#subject").val();
	data += "&regStartDate="+$("#regStartDate").val();
	data += "&regEndDate="+$("#regEndDate").val();
	data += "&customerNo="+$("#customerNo").val();
	data += "&srAreaSearch="+$("#srAreaSearch").val();
	data += "&srArea1="+$("#srArea1").val();
	data += "&srArea2="+$("#srArea2").val();
	data += "&requestUser="+$("#requestUser").val();
	data += "&requestUserID="+$("#requestUserID").val()	
	data += "&returnMenuId=${arcCode}";
	
	isPopup ? window.open(url+"?"+data,srID,"width=1400 height=800 resizable=yes") : ajaxPage(url, data, "srListDiv");
}

// 검색
async function doSearchList(srMode, excel, count, page){
	
	var REG_STR_DT = $("#regStartDate").val();
	var REG_END_DT = $("#regEndDate").val();
	
	if (!REG_STR_DT || !REG_END_DT) {
// 	    alert("요청일을 모두 입력해주세요.");
	    getDicData("ERRTP", "LN0001").then(data => alert("${menu.LN00093}"+data.LABEL_NM));
	    return false;
	}
	if (!checkDateYear(REG_STR_DT, REG_END_DT)){
		return false;
	}
	
	$('#loading').fadeIn(150);
	if(srMode == null && srMode == ""){
		srMode = "${srMode}";	
	}
	
	var isPublic = "${isPublic}";
	/* if(isPublic === null || isPublic === "" || isPublic === undefined){
		isPublic = 1;
	} */
	
	var sqlID = "esm_SQL.getESPSearchList";
	var param = "";
	param += "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
	+ "&sessionUserID=${sessionScope.loginInfo.sessionUserId}"
	+ "&scrnType=" + scrnType
	+ "&srMode=" +srMode
	+ "&sqlID="+sqlID;
	

	if(srMode == "PG" || srMode == "PJT") {
		param = param + "&refID=${refID}";
	}else if (srMode == "myTeam") {
		param = param + "&myTeamId=${sessionScope.loginInfo.sessionTeamId}";
	}
	
	// srCode 검색 시 srMode 제외한 검색조건 무시
	var srCode = $("#srCode").val();
	let cleanedSrCode = removeEmojisAndSpecialChars(srCode);
	$("#srCode").val(cleanedSrCode);
	
	if(cleanedSrCode!== undefined && cleanedSrCode !== '' && cleanedSrCode !== null){
		param += "&srCode=" + cleanedSrCode;
	} else {
		param += "&isPublic=" +isPublic;
		param += "&" + $("#srFrm").serialize();
		param += "&regStartDate=" + $("#regStartDate").val() 
		+ "&regEndDate=" + $("#regEndDate").val()
		+ "&stSRCompDT=" + $("#stSRCompDT").val() 
		+ "&endSRCompDT=" + $("#endSRCompDT").val()
		+ "&subject=" + $("#subject").val()
		
		+ "&mbrRcdMgt=${mbrRcdMgt}"
		+ "&mbrRcdUser=${mbrRcdUser}"
		+ "&completionDelay=${completionDelay}"
		+ "&procRoleTPGroup=${procRoleTPGroup}"
		+ "&noReceiptYN=${noReceiptYN}"
		+ "&procRoleTPGroupMemberIDs=${procRoleTPGroupMemberIDs}"
		+ "&myWorkspace=${myWorkspace}"
		+ "&completedWork=${completedWork}";
		
		if(searchSrType != '' && searchSrType != null) param = param + "&srType=${searchSrType}";
		if($("#srType").val() != '' && $("#srType").val() != null) param = param + "&srType=" + $("#srType").val();
		
		var inProgressStatus = "";
		//if(("${inProgress}" != '' && "${inProgress}" != null) || ($("#inProgress").val() != '' && $("#inProgress").val() != null)) param = param + "&srStatus="+$("#inProgress").val();
		if(("${inProgress}" != '' && "${inProgress}" != null) || ($("#inProgress").val() != '' && $("#inProgress").val() != null)) // param = param + "&inProgress="+$("#inProgress").val();
			inProgressStatus = $("#inProgress").val();
		
		if(searchStatus != '' && searchStatus != null) param = param + "&srStatus=${searchStatus}";
		if($("#srStatus").val() != '' && $("#srStatus").val() != null) param = param + "&srStatus=" + $("#srStatus").val();
		
		if($("#customerNo").val() != "" && $("#customerNo").val() != null){
			param = param + "&clientID=" + $("#customerNo").val();
		}else if("${customerNo}" != '' && "${customerNo}" != null){
			param = param + "&clientID=${customerNo}";
		}
		
		if("${guestTest}" == "Y"){
			param = param + "&srStatusArr='ACM0009','ACM1009'";
		}
		
		if("${surveyTask}" == "Y"){
			param = param + "&srStatus=ZSPE00&SRBlocked=1"; // param = param + "&srStatus=ZSPE00";
			inProgressStatus ="";
		}
		param = param + "&inProgress="+inProgressStatus;
		
		// 지연옵션
		if("${completionDelay}" == "Y"){
			var delayOption = $("#delayOption").val();
			if(delayOption == "02") param = param + "&srStatus=ACM0006"; //승인요청일 지연
			else if(delayOption == "03") param = param + "&srStatus=ACM0009"; // 고객테스트 요청일 지연
			param = param + "&delayOption=" + delayOption;
		}
	}
	
	// 페이지 기본값 있을경우 대체
	if(page !== null && page !== undefined && page!== '') {
		pageNo = page + 1;
	}
	param += "&pageNo="+pageNo+"&pageRow="+$("#pageRow").val();
	
	if(inProgress) {
// 		alert("목록을 불러오고 있습니다.");
	       getDicData("ERRTP", "LN0002").then(data => alert(data.LABEL_NM));
	} else {
		if(count == "Y") {
			getCount(param, page);
		} else {
			jsonDhtmlxListV7(param);
		}
	}
}

async function jsonDhtmlxListV7(param) {
	inProgress = true;
	
	$.ajax({
		url:"zDlm_jsonDhtmlxListV7.do",
		type:"POST",
		data:param,
		success: function(result){
			fnReloadGrid(result);
			$('#loading').fadeOut(150);
			inProgress = false;
		},error:function(xhr,status,error){
// 			alert('조회 시간이 오래 걸려서 요청을 중단하였습니다.\n시스템 담당자에게 연락 부탁 드립니다.');
	 	       getDicData("ERRTP", "ZLN0002").then(data => alert(data.LABEL_NM));
			$('#loading').fadeOut(150);
			console.log("ERR :["+xhr.status+"]"+error);
		}
	});	
}

async function getCount(data, page) {
	inProgress = true;
	await fetch("/getSrCount.do?"+data)
	.then(res => res.json())
	.then(res => {
		let arr = [];
		$("#TOT_CNT").html(res.total);
		for(var i=1; i <= res.total; i++) {
			arr.push({$empty : true, id: i});
		}
		grid.data.parse(arr);
		
		res.list.forEach( e => {
			if(!grid.data.getItem(e.RNUM).RNUM)  grid.data.update(e.RNUM, e);
		});

		// 초기화 페이지 있을 경우 페이지 초기화
		if(page !== null && page !== undefined && page!== '') {
			pagination.setPage(page);
		}
	})
	.catch(error => {
// 		alert('조회 시간이 오래 걸려서 요청을 중단하였습니다.\n시스템 담당자에게 연락 부탁 드립니다.');
	       getDicData("ERRTP", "ZLN0002").then(data => alert(data.LABEL_NM));
	})
	.finally(() => {
		inProgress = false;
	    $('#loading').fadeOut(150);  // 로딩 화면 숨기기
	});
}

function fnReloadGrid(newGridData, excel, count){
	let res = JSON.parse(newGridData);
	res.forEach( e => {
		if(grid.data.getItem(e.RNUM)){
			if(!grid.data.getItem(e.RNUM).RNUM)  grid.data.update(e.RNUM, e);
		}
	})
}

function removeEmojisAndSpecialChars(str) {
	return str.replace(/[^a-zA-Z0-9]/g, "");   
}

</script>