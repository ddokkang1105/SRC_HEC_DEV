<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<%-- <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%> --%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<script type="text/javascript">
	var p_gridArea;	
	var p_gridDownArea;
	var scrnType = "${scrnType}";
	var srMode = "${srMode}";
	var srType = "${srType}";
	var itemID = "${itemID}";
	var multiComp = "${multiComp}";
	var itemTypeCode = "${itemTypeCode}";
	var menuStyle = "${menuStyle}";
	var srStatus = "${srStatus}";
	var status = "${status}";
	var searchStatus = "${searchStatus}";
	
	$(document).ready(function(){
			var height = "";
			if(itemID == "" || itemID == null){height = 272} else {height = 240}
			// 초기 표시 화면 크기 조정 
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - height)+"px;");
			// 화면 크기 조정
			window.onresize = function() {
				$("#grdGridArea").attr("style","height:"+(setWindowHeight() - height)+"px;");
			};
			
			if(menuStyle != null && menuStyle != ""){
				$("#srListDiv").addClass("mgT10 mgB10 mgR10 mgL10");
			}
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
				
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}";
		fnSelect('srArea1', data + "&level=1&itemTypeCode="+itemTypeCode, 'getItemListBySRArea', '', 'Select','esm_SQL');
		fnSelect('itemTypeCode', data+"&itemTypeCode="+itemTypeCode, 'getItemTypeCodeBySRArea3', itemTypeCode, 'Select','esm_SQL');
		fnSelect('srStatus', data+"&itemClassCode=CL03004", 'getSRStatusList', '${searchStatus}', 'Select', 'esm_SQL');
  		fnSelect('requestTeam', data+"&itemID="+itemID, 'getESMSRReqTeamID', '', 'Select','esm_SQL');	
  		fnSelect('srReceiptTeam', data, 'getESMSRReceiptTeamID', '', 'Select','esm_SQL');
  		fnSelect('reqCompany', data, 'getReqESMCompanyList', '${reqCompany}', 'Select', 'esm_SQL');	
		fnSelect('subCategory', data +"&level=2", 'getESMSRCategory', '', 'Select','esm_SQL');
  		
		if("${srArea1}" != ""){fnGetSRArea2("${srArea1}");}
// 		if("${category}" != ""){fnGetSubCategory("${category}");}
  		
		$("input.datePicker").each(generateDatePicker);
		$('#searchValue').keypress(function(onkey){
			if(onkey.keyCode == 13){
				doSearchList();
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
			if("${srID}" != ""){ fnGoDetail();
			}else{ setTimeout(function() { gridInit(); doSearchList();},500 );}
		}else{
			setTimeout(function() { gridInit(); doSearchList(); },500 );
		}
		
		if("${itemID}" != null && "${itemID}" != ""){
			$("#actFrame").css("overflow-y","");
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
	
	//===============================================================================
	// BEGIN ::: GRID
	function gridInit(){	
		var d = setGridData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");	
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});		
		p_gridArea.enablePaging(true,30,null,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.setColumnHidden(0, true);
		if(itemID != ''){
			p_gridArea.setColumnHidden(4, true);
			p_gridArea.setColumnHidden(5, true);
		}
		p_gridArea.setColumnHidden(13, true);
		p_gridArea.setColumnHidden(14, true);
		p_gridArea.setColumnHidden(15, true);
		p_gridArea.setColumnHidden(17, true);
		if(multiComp!="Y") p_gridArea.setColumnHidden(6, true);
		
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	function setGridData(){
		var projectID;
		var result = new Object();
		if($("#srMode").val() != ""){
			srMode = "myTR";
		}else{
			srMode = "${srMode}";
		}
		result.title = "${title}";
		result.key = "esm_SQL.getEsrMSTList";
		result.header = "${menu.LN00024},SR No.,${menu.LN00002},${menu.LN00027},${menu.LN00087},Item Info,${menu.LN00014},${menu.LN00025},${menu.LN00026},${menu.LN00033},${menu.LN00004},${menu.LN00093},${menu.LN00221},srID,ReceiptUserID,Status,${menu.LN00223},ReceiptTeamName";
		result.cols = "SRCode|Subject|StatusName|ItemTypeCodeNM|ItemInfo|CompanyName|ReqUserNM|ReqTeamNM|SubCategoryNM|ReceiptInfo|RegDate|SRDueDate|SRID|ReceiptUserID|Status|SRCompletionDT|ReceiptTeamName";
		result.widths = "0,100,*,120,80,*,90,90,120,120,120,90,90,90,90,90,90,90";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,left,center,center,left,center,center,center,center,center,center,center,left,left,left,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
						+ "&pageNum=" + $("#currPage").val()
						+ "&scrnType=" + scrnType
						+ "&srMode=" +srMode
						+ "&srType=" +srType
						+ "&itemID=" +itemID
						+ "&srCode=" + $("#srCode").val()
						+ "&subject=" + $("#subject").val()
						+ "&regStartDate=" + $("#REG_STR_DT").val()
						+ "&regEndDate=" + $("#REG_END_DT").val()							
						+ "&stSRDueDate=" + $("#ST_SRDUE_DT").val() 
						+ "&endSRDueDate=" + $("#END_SRDUE_DT").val()
						+ "&requestTeam=" + $("#requestTeam").val()
						+ "&requestUserName=" + $("#requestUser").val();
			
						if(itemID == "" || itemID == null){
							result.data = result.data
							+ "&srArea1=" + $("#srArea1").val()
							+ "&srArea2=" + $("#srArea2").val()
							+ "&itemCode="+$("#itemCode").val()
							+ "&itemName="+$("#itemName").val()
							+ "&receiptUser="+$("#receiptUser").val()
							+ "&srReceiptTeam="+$("#srReceiptTeam").val()
						}
						
						if((searchStatus != '' && searchStatus != null) || ($("#srStatus").val() != '' && $("#srStatus").val() != null)) {
							result.data = result.data + "&srStatus=" + $("#srStatus").val();
						} else 	if(srStatus != '' & srStatus != null ){
							var selectedOption = $(":input:radio[name=radioList]:checked").val();

							if(selectedOption != '' && selectedOption != null && srStatus != 'SPE018' ) {
								result.data = result.data + "&srStatus="+selectedOption;
							} else {
								result.data = result.data + "&srStatus="+srStatus;
							} 
						} else if(status != '' & status != null ){
							result.data = result.data + "&srStatus="+status;
						} 
						
						if (srMode == "mySR") {
							result.data = result.data + "&loginUserId=${sessionScope.loginInfo.sessionUserId}";
						}else if(srMode == "PG" || srMode == "PJT") {
							result.data = result.data + "&refID=${refID}";
						}else if (srMode == "myTeam") {
							result.data = result.data + "&myTeamId=${sessionScope.loginInfo.sessionTeamId}";
						}else if(srMode == "myTR"){
							result.data = result.data + "&loginUserId=${sessionScope.loginInfo.sessionUserId}";
						}
						
						if(itemTypeCode == '' || itemTypeCode == null){
							result.data = result.data + "&itemTypeCode="+$("#itemTypeCode").val()
						} else {
							result.data = result.data + "&itemTypeCode="+itemTypeCode
						}
						
						if(multiComp == "Y"){							
							if($("#reqCompany").val() != "" & $("#reqCompany").val() != null){
								result.data = result.data + "&companyID=" + $("#reqCompany").val();
							}else{
								result.data = result.data + "&companyList=${companyIDList}";
							}
						}else{
							if("${companyIDList}" != "" & "${companyIDList}" != null) result.data = result.data + "&companyList=${companyIDList}";
						}
// 						console.log(result.data);
						
			return result;
	}
	
	function gridOnRowSelect(id, ind){
		var scrnType = "${scrnType}";
		var srCode = p_gridArea.cells(id, 1).getValue();
		var srID = p_gridArea.cells(id, 13).getValue();
		var receiptUserID = p_gridArea.cells(id, 14).getValue();
		var status = p_gridArea.cells(id, 15).getValue();
		
		var srStatus = "";
		if("${srStatus}" != ""){
			srStatus = "${srStatus}";
		}
		
		var url = "processIcp.do";
		var data = "srCode="+srCode+"&pageNum="+$("#currPage").val()
					+ "&srMode=${srMode}&srType=${srType}&scrnType=${scrnType}&itemProposal=${itemProposal}&srID="+srID
					+ "&receiptUserID="+receiptUserID+"&projectID=${projectID}"
					+ "&category=" + $("#category").val()
					+ "&subCategory=" + $("#subCategory").val()
// 					+ "&srArea1=" + $("#srArea1").val()
// 					+ "&srArea2=" + $("#srArea2").val()
					+ "&srCode=" + $("#srCode").val()
					+ "&subject=" + $("#subject").val()
					+ "&srStatus=" +srStatus
					+ "&status=" +status
					+ "&searchStatus=" +$("#srStatus").val()
					+ "&receiptUser=" + $("#receiptUser").val()
					+ "&requestUser=" +$("#requestUser").val()
					+ "&requestTeam=" +$("#requestTeam").val()
					+ "&startRegDT=" +$("#REG_STR_DT").val()
					+ "&endRegDT=" +$("#REG_END_DT").val()
					+ "&stSRDueDate=" + $("#ST_SRDUE_DT").val() 
					+ "&endSRDueDate=" + $("#END_SRDUE_DT").val() 
					+ "&searchSrCode=" +$("#srCode").val()
					+"&itemID="+itemID
					+"&multiComp=${multiComp}"
					+"&itemTypeCode=${itemTypeCode}";
		var target = "srListDiv";		
		ajaxPage(url, data, target);
	}
	
	function fnGoDetail(){
		var scrnType = "${scrnType}";
		var mainType = "${mainType}";
		var srID = "${srID}";
		var url = "processIcp.do";
		var data = "&pageNum="+$("#currPage").val()
					+"&srMode=${srMode}&srType=${srType}&scrnType=${scrnType}&itemProposal=${itemProposal}&srID="+srID
					+"&mainType="+mainType+"&itemID="+itemID+"&srStatus="+srStatus;
		var target = "srListDiv";
		ajaxPage(url, data, target);
	}
	
	function doSearchList(){ 
		$("#srMode").val("");
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	function doSearchMyTRList(){
		$("#srMode").val("myTR");
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);		
	}
	
	function fnRegistSR(){
		var sysCode = parent.parent.$('#sysCode').val();
		var proposal = parent.parent.$('#proposal').val();
		var url = "registerIcp.do";
		var target = "srListDiv";
		if(srMode == "REG"){srMode = "";}
		var data = "srType=${srType}&srMode="+srMode+"&scrnType=${scrnType}&itemProposal=${itemProposal}&arcCode=${arcCode}"
				+ "&category="+$("#category").val()
// 				+ "&srArea1=" + $("#srArea1").val()
// 				+ "&srArea2=" + $("#srArea2").val()
				+ "&status=" + $("#status").val()
				+ "&searchSrCode=" + $("#srCode").val()
				+ "&subject=" + $("#subject").val()
				+ "&sysCode="+sysCode 
				+ "&proposal="+proposal
				+"&itemID="+itemID
				+"&itemTypeCode="+itemTypeCode;
		parent.parent.$('#sysCode').val("");
		ajaxPage(url, data, target);
	}
	
	function fnGetSRArea1(itemTypeCode){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}";
		fnSelect('srArea1', data + "&level=1&itemTypeCode="+itemTypeCode, 'getItemListBySRArea', '', 'Select','esm_SQL');
	}
		
	function fnGetSRArea2(SRArea1ID){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&srArea1="+SRArea1ID;
		fnSelect('srArea2', data + "&level=2&itemTypeCode="+$("#itemTypeCode").val(), 'getItemListBySRArea', '', 'Select','esm_SQL');
	}
		
	// 검색 조건 초기화 
	function fnClearSearchSR(){;
		$("#srArea1").val("");
		$("#srArea2").val("");
		$("#itemCode").val("");
		$("#itemName").val("");
		$("#itemTypeCode").val("");
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
		$("#requestTeam").val("");
		$("#srReceiptTeam").val("");
		$("#reqCompany").val("");
		return;
	}
	
	//===============================================================================
	// BEGIN ::: EXCEL
	function doExcel() {		
		p_gridArea.toExcel("${root}excelGenerate");
	}
	
	//===============================================================================
	// BEGIN ::: DATA EXCEL[SRSummaryViewList Excel downLoad]
	function fnDownData() {			
		var d = setGridDownData();
		fnLoadDhtmlxGridJson(p_gridDownArea, d.key, d.cols, d.data,"","","TOT_CNTD","","fnDownExcel()");
	}
	
	function fnDownExcel(){
		p_gridDownArea.toExcel("${root}excelGenerate");
	}
	
// 	function gridDownInit(){	
// 		var d = setGridDownData();
// 		p_gridDownArea = fnNewInitGrid("grdGridDownArea", d);
// 		p_gridDownArea.setImagePath("${root}${HTML_IMG_DIR}/");
// 		p_gridDownArea.setIconPath("${root}${HTML_IMG_DIR}/");		
// 		p_gridDownArea.setPagingSkin("bricks");
// 	}
	
	function setGridDownData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "sr_SQL.getSRSummaryList";                                                                                                                                     
		result.header = "${menu.LN00024},SRCode,SR Status,SR Request Team,SR Receipt Team,CR Receipt Team,${srAreaLabelNM1},${srAreaLabelNM2},Category,Sub Category,SR Creation date,SR Request Due date,SR Due Date,SR Completion Date,Min SR Receipt date,Max SR Receipt date,${menu.LN00094},Project ID";
		result.cols = "SRCode|SRSTSNM|SRReqTeamNM|SRsrReceiptTeamNM|CRsrReceiptTeamNM|Domain|System|CategoryNM|SubCategoryNM|SRRegDT|SRRDD|SRDueDate|SRCompletionDT|MinSRRCVDT|MaxSRRCVDT|SRRCVCount|SRPOINT|MinCSRDT|MaxAPRVDT|CSRCount|APRVCount|MinCRRegDT|MaxCRRDD|MaxCRDueDate|MinCRReceiptDT|maxCRCompletionDT|CRCount|ProjectID";
		result.widths = "80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,50";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "srRegStartDT="+$("#REG_STR_DT").val()+"&srRegEndDT="+$("#REG_END_DT").val();
		return result;
	}
	
	function fnSetColumnHidden(colNum){
		if( document.all("multiCompHideShow").checked == true){ 
			p_gridArea.setColumnHidden(colNum,false);
			$("#companySelect").attr("style","visibility:visible");
		}else{
			p_gridArea.setColumnHidden(colNum,true);
			$("#companySelect").attr("style","visibility:hidden");
		}
	}
</script>

<div id="srListDiv">
<form name="srFrm" id="srFrm" action="" method="post"  onsubmit="return false;">
	<input type="hidden" id="NEW" name="NEW" value="">
	<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<input type="hidden" id="srMode" name="srMode">
	<c:choose>
		<c:when test="${itemID eq '' || itemID eq null }">
			<div class="floatL mgT10 mgB12"><h3><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;개정 의견 제안 목록</div></h3>
		</c:when>
		<c:otherwise>
			<div class="child_search01 pdB10" id="child_info">
				<ul><li><img src="${root}${HTML_IMG_DIR_ITEM}/img_icp.png">&nbsp;&nbsp;<b>개정 의견 제안 목록</b></li></ul>
			</div>
		</c:otherwise>
	</c:choose>
	<c:if test="${multiComp eq 'Y'}">
		<div class="floatR mgT10 mgB10">
	        	&nbsp;&nbsp;&nbsp;<input type="checkbox" id="multiCompHideShow" name="multiCompHideShow" OnClick="fnSetColumnHidden(6);" <c:if test="${multiComp eq 'Y'}"> checked </c:if>>&nbsp;Company
	        	<span id="companySelect">&nbsp;&nbsp;<select id="reqCompany" Name="reqCompany" style="width:150px;"></select></span>    
		</div>
	</c:if>
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
    <c:if test="${itemID eq '' || itemID eq null }">
    <tr>
    	<!-- Item Type Code -->
    	<th class="alignL">${menu.LN00087}</th>
        <td class="alignL">     
	       	<select id="itemTypeCode" Name="itemTypeCode" style="width:100%" OnChange="fnGetSRArea1(this.value);"></select>
       	</td>
    	<!-- srArea1 -->
    	<th class="alignL">${srAreaLabelNM1}</th>
        <td class="alignL">     
	       	<select id="srArea1" Name="srArea1" OnChange="fnGetSRArea2(this.value);" style="width:100%">
	       		<option value=''>Select</option>
	       	</select>
       	</td>
       	<!-- srArea2 -->
        <th class="alignL">${srAreaLabelNM2}</th>
        <td class="alignL">      
        <select id="srArea2" Name="srArea2" style="width:100%">
            <option value=''>Select</option>
        </select>
        </td>
	    <!-- 상태 -->
       	<th class="alignL">${menu.LN00027}</th>
        <td>      
	       	<select id="srStatus" Name="srStatus" style="width:100%">
	       		<option value=''>Select</option>
	       	</select>
       	</td> 
       
    </tr>
    <tr>
       	<!-- 카테고리 -->
       	<th class="alignL">${menu.LN00033}</th>
        <td class="alignL">	
	        <select id="subCategory" Name="subCategory" style="width:100%">
	        	<option value="">Select</option> 
	        </select>
       	</td>
       	 <!-- item Code -->
       	<th class="alignL">${menu.LN00015}</th>
        <td><input type="text" class="text" id="itemCode" name="itemCode" value="" style="ime-mode:active;" />
        <!-- item Name -->
       	<th class="alignL">${menu.LN00028}</th>
        <td><input type="text" class="text" id="itemName" name="itemName" value="" style="ime-mode:active;" />
     	<!-- 요청 No -->
     	<th class="alignL">요청 No.</th>
      	<td><input type="text" class="text" id="srCode" name="srCode" value="${searchSrCode}" style="ime-mode:active;" /></td>
    </tr>
     <tr> 
       	 <!-- 요청자 -->
       	<th class="alignL">${menu.LN00025}</th>
        <td><input type="text" class="text" id="requestUser" name="requestUser" value="${requestUser}" style="ime-mode:active;" /></td>
  		 <!-- 요청 부서 -->
        <th class="alignL">${menu.LN00026}</th>
        <td  class= "alignL">     
	        <select id="requestTeam" Name="requestTeam" style="width:100%">
	            <option value=''>Select</option>
	        </select>
        </td>
        <!-- 담당자 -->
       	<th class="alignL">${menu.LN00004}</th>
        <td><input type="text" class="text" id="receiptUser" name="receiptUser" value="${receiptUser}" style="ime-mode:active;" />
        <!-- 담당 부서 -->
        <th class="alignL">${menu.LN00153}</th>
        <td  class= "alignL">     
	        <select id="srReceiptTeam" Name="srReceiptTeam" style="width:100%">
	            <option value=''>Select</option>
	        </select>
        </td>
     </tr>
     <tr>
    	<!-- 요청일-->
        <th class="alignL">${menu.LN00093}</th>     
        <td>     
            <font><input type="text" id="REG_STR_DT" name="REG_STR_DT" value="${startRegDT}"	class="input_off datePicker stext" size="8"
				style="width:63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="15" >
			</font>
			~
			<font><input type="text" id="REG_END_DT" name="REG_END_DT" value="${endRegDT}"	class="input_off datePicker stext" size="8"
				style="width: 63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="15">
			</font>
         </td> 
        <!-- SR 완료예정일 -->
       	<th class="alignL">${menu.LN00221}</th>
        <td>     
	       <font><input type="text" id="ST_SRDUE_DT" name="ST_SRDUE_DT" value="${stSRDueDate}" class="input_off datePicker stext" size="8"
				style="width:63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
			</font>
			~
			<font><input type="text" id="END_SRDUE_DT" name="END_SRDUE_DT" value="${endSRDueDate}"	class="input_off datePicker stext" size="8"
				style="width: 63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="15">
			</font>
       	</td>
       	<!-- 제목-->
        <th class="alignL" >${menu.LN00002}</th>     
	    <td colspan="3"><input type="text" class="text" id="subject" name="subject" value="${subject}" style="ime-mode:active;" /></td>
     </tr>
     </c:if>
     
     <c:if test="${itemID ne '' && itemID ne null }">
     <tr>
	     <!-- 카테고리 -->
	       	<th class="alignL">${menu.LN00033}</th>
	        <td class="alignL">      
		       	<select id="subCategory" Name="subCategory" style="width:100%"></select>
	       	</td>
	       	<!-- 상태 -->
	       	<th class="alignL">${menu.LN00027}</th>
	        <td>      
		       	<select id="srStatus" Name="srStatus" style="width:100%">
		       		<option value=''>Select</option>
		       	</select>
	       	</td>
	       	<!-- 제목-->
	        <th class="alignL" >${menu.LN00002}</th>     
		    <td><input type="text" class="text" id="subject" name="subject" value="${subject}" style="ime-mode:active;" /></td>
       		<!-- 요청 No -->
	     	<th class="alignL">요청 No.</th>
	      	<td><input type="text" class="text" id="srCode" name="srCode" value="${searchSrCode}" style="ime-mode:active;" /></td>
       	</tr>
       	<tr>
       		<!-- 요청자 -->
	       	<th class="alignL">${menu.LN00025}</th>
	        <td><input type="text" class="text" id="requestUser" name="requestUser" value="${requestUser}" style="ime-mode:active;" /></td>
	  		 <!-- 요청 부서 -->
	        <th class="alignL">${menu.LN00026}</th>
	        <td  class= "alignL">     
		        <select id="requestTeam" Name="requestTeam" style="width:100%">
		            <option value=''>Select</option>
		        </select>
	        </td> 
		    <!-- 요청일-->
	        <th class="alignL">${menu.LN00093}</th>     
	        <td>     
	            <font><input type="text" id="REG_STR_DT" name="REG_STR_DT" value="${startRegDT}"	class="input_off datePicker stext" size="8"
					style="width:63px;text-align: center;" maxlength="15" >
				</font>
				~
				<font><input type="text" id="REG_END_DT" name="REG_END_DT" value="${endRegDT}"	class="input_off datePicker stext" size="8"
					style="width: 63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="15">
				</font>
	         </td> 
	        <!-- SR 완료예정일 -->
	       	<th class="alignL">${menu.LN00221}</th>
	        <td >     
		       <font><input type="text" id="ST_SRDUE_DT" name="ST_SRDUE_DT" value="${stSRDueDate}" class="input_off datePicker stext" size="8"
					style="width:63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				</font>
				~
				<font><input type="text" id="END_SRDUE_DT" name="END_SRDUE_DT" value="${endSRDueDate}"	class="input_off datePicker stext" size="8"
					style="width: 63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="15">
				</font>
	       	</td> 
       	</tr>
     </c:if>
   </table>
	<div class="countList pdT5 pdB5" >
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
           	&nbsp;<span id="viewSearch" class="btn_pack medium icon"><span class="search"></span><input value="Search" type="submit" onclick="doSearchList();" style="cursor:hand;"></span>
           	<c:if test="${scrnType != 'srRqst' &&( itemID eq '' || itemID eq null) }" >
		      	<span id="viewSave" class="btn_pack medium icon"><span class="search"></span><input value="Transfered" type="submit" onclick="doSearchMyTRList();" style="cursor:hand;"></span>
           	</c:if>
           	<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="cursor:pointer;" onclick="fnClearSearchSR();">
        	&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Create" type="submit" id="new" style="cursor:hand;"></span>&nbsp;
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
        </li>
    </div>
    
	<div id="gridDiv" style="width:100%;" class="clear" >
		<div id="grdGridArea"></div>
	</div>
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL5"></div></div>
</form>
</div>