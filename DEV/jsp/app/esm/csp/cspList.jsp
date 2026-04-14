<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>


<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">


<script>
	var scrnType = "${scrnType}";
	var srMode = "${srMode}";
	var srType = "${srType}";
	var itemID = "${itemID}";
	var srArea2 = "${srArea2}";
	var subCategory = "${subCategory}";
	var srStatus = "${srStatus}";
	var status = "${status}";
	var companyIDList = "${companyIDList}";
	var searchStatus = "${searchStatus}";
		
	$(document).ready(function(){	
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 300)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 300)+"px;");
		};
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}";
		fnSelect('category', data +"&level=1", 'getESMSRCategory', '${category}', 'Select','esm_SQL');
		fnSelect('srStatus', data+"&itemClassCode=CL03004", 'getSRStatusList', '${searchStatus}', 'Select', 'esm_SQL');
  		fnSelect('srReceiptTeam', data, 'getESMSRReceiptTeamID', '${srReceiptTeam}', 'Select', 'esm_SQL');	
  		fnSelect('custGRNo', data+"&custLvl=G", 'getCustList', '${custGRNo}', 'Select', 'crm_SQL');	
  		
		if("${category}" != ""){fnGetSubCategory("${category}");}
		if("${custGRNo}" != ""){fnGetCompany("${custGRNo}");}
  		
		$("input.datePicker").each(generateDatePicker);
		$('#searchValue').keypress(function(onkey){
			if(onkey.keyCode == 13){
				doSearchList('${srMode}');
				return false;
			}
		});		
		
		$('#new').click(function(){ 
			fnRegistSR();
			return false;
		});	
				
		parent.top.$('#mainType').val("");
		if(srMode == "REG"){
			fnRegistSR();
		}else if("${srID}" != "" && parent.$("#scrnType").val() == "srRcv"){ // 외부에서 접수 페이지 바로가기 
			fnGoDetail();
			parent.$("#scrnType").val("");
		}else if("${mainType}"=="SRDtl" || "${mainType}" == "mySRDtl" || "${mainType}" == "SRDtlView"){
			if("${srID}" != ""){ fnGoDetail();}
		}else{
			setTimeout(function() { if(scrnType=='srRcv'){} },500 );
		}
		
		$("input:radio[name='radioList']").change(function(){
			searchStatus = null;
			$("#srStatus").val("");
		});
		
		if("${reqDateLimit}" != null && "${reqDateLimit}" != ""){
			var now = new Date();
			$("#REG_END_DT").val(now.toISOString().substring(0,10));
			var bDay = new Date(now.setDate(now.getDate() - "${reqDateLimit}"));
			$("#REG_STR_DT").val(bDay.toISOString().substring(0,10))
		}
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
	
	function fnGoDetail(){
		var scrnType = "${scrnType}";
		var mainType = "${mainType}";
		var srID = "${srID}";
		var srStatus = "";
		if("${srStatus}" != ""){
			srStatus = "${srStatus}";
		}
		
		var url = "processItsp.do";
		var data = "&pageNum="+$("#currPage").val()+"&srMode=${srMode}&srType=${srType}"
						+"&scrnType=${scrnType}&itemProposal=${itemProposal}&srID="+srID+"&mainType="+mainType+"&srStatus="+srStatus;
		var target = "srListDiv";
		ajaxPage(url, data, target);
	}
	
	function fnRegistSR(){
		var sysCode = parent.parent.$('#sysCode').val();
		var proposal = parent.parent.$('#proposal').val();
		var url = "registerCSP.do";
		var target = "srListDiv";
		if(srMode == "REG"){srMode = "";}
		var data = "srType=${srType}&srMode="+srMode+"&scrnType=${scrnType}&itemProposal=${itemProposal}"
				+ "&category="+$("#category").val()
				+ "&srArea2=" + $("#srArea2").val()
				+ "&searchStatus=" + $("#srStatus").val()
				+ "&searchSrCode=" + $("#srCode").val()
				+ "&subject=" + $("#subject").val()
				+ "&sysCode="+sysCode 
				+ "&proposal="+proposal
				+ "&srStatus="+srStatus;
		parent.parent.$('#sysCode').val("");
		ajaxPage(url, data, target);
	}
		
	function fnGetSubCategory(parentID){
		subCategory = null;
		if(parentID == ''){
			$("#subCategory option").not("[value='']").remove();
		} else {
			var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&parentID="+parentID;
			fnSelect('subCategory', data, 'getESMSRCategory', '${subCategory}', 'Select', 'esm_SQL');
		}
	}
		
	// 검색 조건 초기화 
	function fnClearSearchSR(){;
		$("#srArea2").val("");
		$("#category").val("");
		$("#subCategory").val("");
		$("#srStatus").val("");
		$("#REG_STR_DT").val("");
		$("#REG_END_DT").val("");
		$("#ST_SRDUE_DT").val("");
		$("#END_SRDUE_DT").val("");
		$("#ST_CRDUE_DT").val("");
		$("#END_CRDUE_DT").val("");
		$("#requestUser").val("");
		$("#receiptUser").val("");
		$("#srCode").val("");
		$("#subject").val("");
		$("#custGRNo").val("");
		$("#company").val("");
		srArea2 = null;
		subCategory = null;
		status = null;
		companyIDList = null;
		searchStatus = null;
		return;
	}
	
	function fnSetValueInit(val){
		switch(val){
			case "srArea2" : srArea2 = null; break;
			case "subCategory" : subCategory = null; break;
			case "srStatus" : searchStatus = null; break;
			case "companyIDList" : companyIDList = null; break;
		}
	}
	
	function fnGetCompany(custGRNo){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&customerGRNo="+custGRNo;
		fnSelect('company', data+"&custLvl=C", 'getCustList', '', 'Select','crm_SQL');
	}
	
	function fnGetSrArea2(customerNo){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&srType=${srType}&customerNo="+customerNo;
		fnSelect('srArea2', data, 'getItemByCustomer', '', 'Select','crm_SQL');
	}
	
	
</script>

<div id="srListDiv">
<form name="srFrm" id="srFrm" action="" method="post"  onsubmit="return false;">
	<input type="hidden" id="NEW" name="NEW" value="">
	<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<input type="hidden" id="srMode" name="srMode">
	
	<div class="floatL mgT10 mgB12">
		<h3><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;${menu.LN00275}</h3>
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
   		<!-- custGR -->
       	<th class="alignL">고객그룹</th>
        <td class="alignL">     
	       	<select id="custGRNo" Name="custGRNo" OnChange="fnGetCompany(this.value);" style="width: 100%;display: inline-block;">
	       		<option value=''>Select</option>
	       	</select>
       	</td>
       	<!-- custGR -->
       	<th class="alignL">${menu.LN00014}</th>
        <td class="alignL">     
	       	<select id="company" Name="company" OnChange="fnGetSrArea2(this.value);" style="width: 100%;display: inline-block;">
	       		<option value=''>Select</option>
	       	</select>
       	</td>
       	<!-- 시스템 -->
        <th class="alignL">${srAreaLabelNM2}</th>
        <td class="alignL">      
        <select id="srArea2" Name="srArea2" style="width: 100%;display: inline-block;">
            <option value=''>Select</option>
        </select>
        </td>
 		<!-- 요청일-->
        <th class="alignL">${menu.LN00093}</th>     
        <td>     
            <input type="text" id="REG_STR_DT" name="REG_STR_DT" value="${startRegDT}"	class="input_off datePicker stext" size="8"
				style="width:63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="15" >
			
			~
			<input type="text" id="REG_END_DT" name="REG_END_DT" value="${endRegDT}"	class="input_off datePicker stext" size="8"
				style="width: 63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="15">
			
         </td> 
    </tr>
     <tr>
       	<!-- 카테고리 -->
       	<th class="alignL">${menu.LN00033}</th>
        <td class="alignL">       
	       	<select id="category" Name="category" OnChange="fnGetSubCategory(this.value);" style="width: 100%;display: inline-block;">
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
      <!-- 요청자 -->
       	<th class="alignL">${menu.LN00025}</th>
        <td><input type="text" class="text" id="requestUser" name="requestUser" value="${requestUser}" style="ime-mode:active;" /></td>
        <!-- SR 완료예정일 -->
       	<th class="alignL">SR ${menu.LN00221}</th>
        <td >     
	       <input type="text" id="ST_SRDUE_DT" name="ST_SRDUE_DT" value="${stSRDueDate}" class="input_off datePicker stext" size="8"
				style="width:63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
			
			~
			<input type="text" id="END_SRDUE_DT" name="END_SRDUE_DT" value="${endSRDueDate}"	class="input_off datePicker stext" size="8"
				style="width: 63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="15">
			
       	</td> 
      
   	 </tr>
    <tr>
        <!-- SR No -->
       	<th class="alignL">SR No.</th>
      	<td ><input type="text" class="text" id="srCode" name="srCode" value="${searchSrCode}" style="ime-mode:active;" /></td>
       	<!-- 제목-->
        <th class="alignL" >${menu.LN00002}</th>     
	    <td><input type="text" class="text" id="subject" name="subject" value="${subject}" style="ime-mode:active;" /></td>
        	
       	 <!-- SR 담당자 -->
       	<th class="alignL">${menu.LN00004}</th>
        <td><input type="text" class="text" id="receiptUser" name="receiptUser" value="${receiptUser}" style="ime-mode:active;" />
        </td> 
         <!-- 상태 -->
       	<th class="alignL">${menu.LN00027}</th>
        <td>      
	       	<select id="srStatus" Name="srStatus"  onchange="fnSetValueInit(this.id)" style="width: 100%;display: inline-block;">
	       		<option value=''>Select</option>
	       	</select>
       	</td> 
     
     </tr>   
   </table>
	<div class="countList pdT5 pdB5" >
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatL pdL20" style="display:inline">
     		<input type="radio" id="radioList" name="radioList" value="ING" <c:if test="${srStatus eq 'ING'}"> checked="checked" </c:if>>&nbsp;Processing&nbsp;
			<input type="radio" id="radioList" name="radioList" value="COMPL"  <c:if test="${srStatus eq 'COMPL' }"> checked="checked" </c:if>>&nbsp;Completed&nbsp;
			<input type="radio" id="radioList" name="radioList" value="ALL" <c:if test="${srStatus eq 'ALL' }"> checked="checked" </c:if>>&nbsp;ALL&nbsp;
		</li>
        <li class="floatR">
           	&nbsp;<span id="viewSearch" class="btn_pack medium icon"><span class="search"></span><input value="Search" type="submit" onclick="doSearchList('${srMode}');" style="cursor:hand;"></span>
           	<c:if test="${scrnType != 'srRqst' }" >
		      	<span id="viewSave" class="btn_pack medium icon"><span class="search"></span><input value="Transfered" type="submit" onclick="doSearchList('myTR');" style="cursor:hand;"></span>
           	</c:if>
           	<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="cursor:pointer;" onclick="fnClearSearchSR();">
        	&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Create" type="submit" id="new" style="cursor:hand;"></span>&nbsp;
        	<c:if test="${scrnType == 'srRcv'}" ><span class="btn_pack small icon"><span class="down"></span><input value="Data" type="button" id="data" OnClick="fnDownData()"></span></c:if>
        	<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
        </li>
    </div>
    
    <div style="width:100%;" id="layout"></div>
	<div id="pagination" style="margin-top: 60px;"></div>
	
	<!-- Data Excel [SRSummaryView List] -->
	<div style="display:none;" id="excelGrid"></div>
</form>
</div>


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
        { width: 120, id: "SRCode", header: [{ text: "SR No." , align: "center" }, { content: "inputFilter" }], align: "center" },
        { id: "Subject", header: [{ text: "${menu.LN00002}" , align: "center" }, { content: "inputFilter" }], align: "left" },
        { width: 90, id: "StatusName", header: [{ text: "${menu.LN00027}" , align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 100, id: "CustGRName", header: [{ text: "고객그룹" , align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 120, id: "CompanyName", header: [{ text: "${menu.LN00014}" , align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 120,id: "ReqUserNM", header: [{ text: "${menu.LN00025}" , align: "center" }, { content: "inputFilter" }], align: "center" },
        { width: 100,id: "SRArea2Name", header: [{ text: "${srAreaLabelNM2}" , align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 100, id: "SubCategoryNM", header: [{ text: "${menu.LN00033}" , align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 120, id: "ReceiptInfo", header: [{ text: "${menu.LN00004}" , align: "center" }, { content: "selectFilter" }], align: "center" },
        { width: 100, id: "RegDate", header: [{ text: "${menu.LN00093}" , align: "center" }], align: "center" },
        { width: 100, id: "SRDueDate", header: [{ text: "${menu.LN00221}" , align: "center" }], align: "center" },
        { hidden: true,  id: "SRID", header: [{ text: "srID" , align: "center" }], align: "center" },
        { hidden: true,  id: "ReceiptUserID", header: [{ text: "ReceiptUserID" , align: "center" }], align: "center" },
        { hidden: true, id: "Status", header: [{ text: "Status" , align: "center" }], align: "center" },
        { width: 100, id: "SRCompletionDT", header: [{ text: "${menu.LN00223}" , align: "center" }], align: "center" },
    ],
    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    data: gridData
});
layout.getCell("a").attach(grid);

//excel 일반
function doExcel() {		
	fnGridExcelDownLoad(grid);
}

//excel srRcv 용
var excelData = ${excelData};
var excelGrid = new dhx.Grid("excelGrid", {
    columns: [
        { width: 80, id: "SRCode", header: [{ text: "SRCode" , align: "center" }], align: "center" },
        { width: 80, id: "SRSTSNM", header: [{ text: "SR Status" , align: "center" }], align: "center" },
        { width: 80, id: "SRReqTeamNM", header: [{ text: "SR Request Team" , align: "center" }], align: "center" },
        { width: 80, id: "SRReceiptTeamNM", header: [{ text: "SR Receipt Team" , align: "center" }], align: "center" },
        { width: 80, id: "CRReceiptTeamNM", header: [{ text: "CR Receipt Team" , align: "center" }], align: "center" },
        { width: 80, id: "Domain", header: [{ text: "${srAreaLabelNM1}" , align: "center" }], align: "center" },
        { width: 80, id: "System", header: [{ text: "${srAreaLabelNM2}" , align: "center" }], align: "center" },
        { width: 80, id: "CategoryNM", header: [{ text: "Category" , align: "center" }], align: "center" },
        { width: 80, id: "SubCategoryNM", header: [{ text: "Sub Category" , align: "center" }], align: "center" },
        { width: 80, id: "SRRegDT", header: [{ text: "SR Creation date" , align: "center" }], align: "center" },
        { width: 80, id: "SRRDD", header: [{ text: "SR Request Due date" , align: "center" }], align: "center" },
        { width: 80, id: "SRDueDate", header: [{ text: "SR Due Date" , align: "center" }], align: "center" },
        { width: 80, id: "SRCompletionDT", header: [{ text: "SR Completion Date" , align: "center" }], align: "center" },
        { width: 80, id: "MinSRRCVDT", header: [{ text: "MinSRRCVDT" , align: "center" }], align: "center" },
        { width: 80, id: "MaxSRRCVDT", header: [{ text: "MaxSRRCVDT" , align: "center" }], align: "center" },
        { width: 80, id: "SRRCVCount", header: [{ text: "SRRCVCount" , align: "center" }], align: "center" },
        { width: 80, id: "SRPOINT", header: [{ text: "SRPOINT" , align: "center" }], align: "center" },
        { width: 80, id: "MinCSRDT", header: [{ text: "MinCSRDT" , align: "center" }], align: "center" },
        { width: 80, id: "MaxAPRVDT", header: [{ text: "MaxAPRVDT" , align: "center" }], align: "center" },
        { width: 80, id: "CSRCount", header: [{ text: "CSRCount" , align: "center" }], align: "center" },
        { width: 80, id: "APRVCount", header: [{ text: "APRVCount" , align: "center" }], align: "center" },
        { width: 80, id: "MinCRRegDT", header: [{ text: "MinCRRegDT" , align: "center" }], align: "center" },
        { width: 80, id: "MaxCRRDD", header: [{ text: "MaxCRRDD" , align: "center" }], align: "center" },
        { width: 80, id: "MaxCRDueDate", header: [{ text: "MaxCRDueDate" , align: "center" }], align: "center" },
        { width: 80, id: "MinCRReceiptDT", header: [{ text: "MinCRReceiptDT" , align: "center" }], align: "center" },
        { width: 80, id: "maxCRCompletionDT", header: [{ text: "maxCRCompletionDT" , align: "center" }], align: "center" },
        { width: 80, id: "CRCount", header: [{ text: "CRCount" , align: "center" }], align: "center" },
        { width: 50, id: "ProjectID", header: [{ text: "ProjectID" , align: "center" }], align: "center" }
    ],
    data: excelData
});

function fnDownData() {		
	fnGridExcelDownLoad(excelGrid);
}

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

//상세 페이지 이동
function doDetail(row){
	var scrnType = "${scrnType}";
	var srCode = row.SRCode;
	var srID = row.SRID;
	var receiptUserID = row.ReceiptUserID;
	var status = row.Status;
	
	var srStatus = "";
	if("${srStatus}" != ""){
		srStatus = "${srStatus}";
	}
	
	var url = "processItsp.do";
	var data = "srCode="+srCode+"&pageNum="+$("#currPage").val()
				+ "&srMode=${srMode}&srType=${srType}&scrnType=${scrnType}&itemProposal=${itemProposal}&srID="+srID
				+ "&receiptUserID="+receiptUserID+"&projectID=${projectID}&itemID="+itemID
				+ "&category=" + $("#category").val()
				+ "&subCategory=" + $("#subCategory").val()
				+ "&srArea2=" + $("#srArea2").val()
				+ "&srCode=" + $("#srCode").val()
				+ "&subject=" + encodeURIComponent($("#subject").val())
				+ "&srStatus=" +srStatus
				+ "&status=" +status
				+ "&searchStatus=" +$("#srStatus").val()
				+ "&receiptUser=" + $("#receiptUser").val()
				+ "&requestUser=" +$("#requestUser").val()
				+ "&startRegDT=" +$("#REG_STR_DT").val()
				+ "&endRegDT=" +$("#REG_END_DT").val()
				+ "&stSRDueDate=" + $("#ST_SRDUE_DT").val() 
				+ "&endSRDueDate=" + $("#END_SRDUE_DT").val() 
				+ "&searchSrCode=" +$("#srCode").val()
				+ "&companyID=" + $("#company").val()
				+ "&custGRNo=" + $("#custGRNo").val();
	
	var target = "srListDiv";		
	ajaxPage(url, data, target);
}

//검색
function doSearchList(srMode){
	
	var projectID;
	if($("#REG_STR_DT").val() != "" && $("#REG_END_DT").val() == "") $("#REG_END_DT").val(new Date().toISOString().substring(0,10));
	if($("#ST_SRDUE_DT").val() != "" && $("#END_SRDUE_DT").val() == "")	$("#END_SRDUE_DT").val(new Date().toISOString().substring(0,10));
	
	var sqlID = "esm_SQL.getEsrMSTList";
	var param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
		+ "&scrnType=" + scrnType
		+ "&srMode=" +srMode
		+ "&srType=" +srType
		+ "&itemID=" +itemID
		+ "&category=" + $("#category").val()
		+ "&srCode=" + $("#srCode").val()
		+ "&subject=" + encodeURIComponent($("#subject").val())
		+ "&receiptUserName=" + $("#receiptUser").val()
		+ "&requestUserName=" + $("#requestUser").val()
		+ "&regStartDate=" + $("#REG_STR_DT").val()
		+ "&regEndDate=" + $("#REG_END_DT").val()							
		+ "&stSRDueDate=" + $("#ST_SRDUE_DT").val() 
		+ "&endSRDueDate=" + $("#END_SRDUE_DT").val()
		+ "&sqlID="+sqlID;
 		
		 if(srArea2 != '' & srArea2 != null ){
			param = param + "&srArea2="+srArea2;
		} else {
			param = param + "&srArea2=" + $("#srArea2").val();
		}

		if($("#srReceiptTeam").val() != undefined ||  $("#srReceiptTeam").val() != null){param = param +  "&srReceiptTeam=" + $("#srReceiptTeam").val()}
		if($("#crReceiptTeam").val() != undefined ||  $("#crReceiptTeam").val() != null){param = param +  "&crReceiptTeam=" + $("#crReceiptTeam").val()}
		if($("#subCategory").val() != '' & $("#subCategory").val() != null & $("#subCategory").val() != "undefined"){
			param = param + "&subCategory=" + $("#subCategory").val();
		}else if(subCategory != '' & subCategory != null & subCategory != "undefined"){
			param = param + "&subCategory="+subCategory;
		}
		
		if((searchStatus != '' && searchStatus != null) || ($("#srStatus").val() != '' && $("#srStatus").val() != null)) {
			param = param + "&srStatus=" + $("#srStatus").val();
		} else 	if(srStatus != '' & srStatus != null ){
			var selectedOption = $(":input:radio[name=radioList]:checked").val();

			if(selectedOption != '' && selectedOption != null && srStatus != 'SPE001' ) {
				param = param + "&srStatus="+selectedOption;
			} else {
				param = param + "&srStatus="+srStatus;
			}
		} else if(status != '' & status != null ){
			param = param + "&srStatus="+status;
		} 
								
		if (srMode == "mySR") {
			param = param + "&loginUserId=${sessionScope.loginInfo.sessionUserId}";
		}else if(srMode == "PG" || srMode == "PJT") {
			param = param + "&refID=${refID}";
		}else if (srMode == "myTeam") {
			param = param + "&myTeamId=${sessionScope.loginInfo.sessionTeamId}";
		}else if(srMode == "myTR"){
			param = param + "&loginUserId=${sessionScope.loginInfo.sessionUserId}";
		}
		
		if(companyIDList != "" & companyIDList != null) param = param + "&companyList="+companyIDList;
		if($("#custGRNo").val() != '' & $("#custGRNo").val() != null & $("#custGRNo").val() != "undefined") {
			 param = param + "&custGRNo="+$("#custGRNo").val();
		}
		if($("#company").val() != "" & $("#company").val() != null){
			param = param + "&custNo=" + $("#company").val();
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