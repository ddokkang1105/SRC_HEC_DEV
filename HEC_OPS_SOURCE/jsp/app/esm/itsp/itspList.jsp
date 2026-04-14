<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<script>
	var p_gridArea;	
	var p_gridDownArea;
	var scrnType = "${scrnType}";
	var srMode = "${srMode}";
	var srType = "${srType}";
	var itemID = "${itemID}";
	var multiComp = "${multiComp}";
	var srArea2 = "${srArea2}";
	var subCategory = "${subCategory}";
	var srStatus = "${srStatus}";
	var status = "${status}";
	var companyIDList = "${companyIDList}";
	var searchStatus = "${searchStatus}";
		
	$(document).ready(function(){	
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 254)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 254)+"px;");
		};
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}";
		fnSelect('srArea1', data + "&itemTypeCode=${itemTypeCode}", 'getESMSRArea1', '${srArea1}', 'Select','esm_SQL');
		fnSelect('category', data +"&level=1", 'getESMSRCategory', '${category}', 'Select','esm_SQL');
		fnSelect('srStatus', data+"&itemClassCode=CL03004", 'getSRStatusList', '${searchStatus}', 'Select', 'esm_SQL');
  		fnSelect('requestTeam', data, 'getESMSRReqTeamID', '${requestTeam}', 'Select','esm_SQL');	
  		fnSelect('srReceiptTeam', data, 'getESMSRReceiptTeamID', '${srReceiptTeam}', 'Select', 'esm_SQL');	
  		fnSelect('reqCompany', data, 'getReqESMCompanyList', '${reqCompany}', 'Select', 'esm_SQL');	
  		
		if("${srArea1}" != ""){fnGetSRArea2("${srArea1}");}
		if("${category}" != ""){fnGetSubCategory("${category}");}
  		
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
			setTimeout(function() { gridInit(); doSearchList(); if(scrnType=='srRcv'){gridDownInit();} },500 );
		}
		
		$("input:radio[name='radioList']").change(function(){
			searchStatus = null;
			$("#srStatus").val("");
		});
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
		p_gridArea.enablePaging(true,30,10,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.setColumnHidden(0, true);
		p_gridArea.setColumnHidden(13, true);
		p_gridArea.setColumnHidden(14, true);
		p_gridArea.setColumnHidden(15, true);
		if(multiComp!="Y") p_gridArea.setColumnHidden(4, true);
		
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
		result.key = "esm_SQL.getEsrMSTList";                                                                                                                                     //SR완료예정일                                              					
		result.header = "${menu.LN00024},SR No.,${menu.LN00002},${menu.LN00027},${menu.LN00014},${menu.LN00026},${menu.LN00025},${srAreaLabelNM1},${srAreaLabelNM2},${menu.LN00033},${menu.LN00004},${menu.LN00093},${menu.LN00221},srID,ReceiptUserID,Status,${menu.LN00223}";
		result.cols = "SRCode|Subject|StatusName|CompanyName|ReqTeamNM|ReqUserNM|SRArea1Name|SRArea2Name|SubCategoryNM|ReceiptInfo|RegDate|SRDueDate|SRID|ReceiptUserID|Status|SRCompletionDT";
		result.widths = "0,100,*,100,120,120,100,110,110,120,120,90,90,90,90,90,90";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,left,center,center,center,center,center,center,center,center,center,center,left,left,left,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
						+ "&pageNum=" + $("#currPage").val()
						+ "&scrnType=" + scrnType
						+ "&srMode=" +srMode
						+ "&srType=" +srType
						+ "&itemID=" +itemID
						+ "&category=" + $("#category").val()
						+ "&srCode=" + $("#srCode").val()
						+ "&srArea1=" + $("#srArea1").val()				
						+ "&subject=" + $("#subject").val();
		
						 if(srArea2 != '' & srArea2 != null ){
							result.data = result.data + "&srArea2="+srArea2;
						} else {
							result.data = result.data + "&srArea2=" + $("#srArea2").val();
						}
		
						if($("#srReceiptTeam").val() != undefined ||  $("#srReceiptTeam").val() != null){result.data = result.data +  "&srReceiptTeam=" + $("#srReceiptTeam").val()}
						if($("#crReceiptTeam").val() != undefined ||  $("#crReceiptTeam").val() != null){result.data = result.data +  "&crReceiptTeam=" + $("#crReceiptTeam").val()}
						if($("#subCategory").val() != '' & $("#subCategory").val() != null & $("#subCategory").val() != "undefined"){
							result.data = result.data + "&subCategory=" + $("#subCategory").val();
						}else if(subCategory != '' & subCategory != null & subCategory != "undefined"){
							result.data = result.data + "&subCategory="+subCategory;
						}
						
						if(scrnType != "srRqst") {
							result.data = result.data  							
							+ "&regStartDate=" + $("#REG_STR_DT").val()
							+ "&regEndDate=" + $("#REG_END_DT").val()							
							+ "&stSRDueDate=" + $("#ST_SRDUE_DT").val() 
							+ "&endSRDueDate=" + $("#END_SRDUE_DT").val() 						
							+ "&receiptUserName=" + $("#receiptUser").val()
							+ "&requestTeam=" + $("#requestTeam").val()
							+ "&requestUserName=" + $("#requestUser").val();
						}
						
						if((searchStatus != '' && searchStatus != null) || ($("#srStatus").val() != '' && $("#srStatus").val() != null)) {
							result.data = result.data + "&srStatus=" + $("#srStatus").val();
						} else 	if(srStatus != '' & srStatus != null ){
							var selectedOption = $(":input:radio[name=radioList]:checked").val();

							if(selectedOption != '' && selectedOption != null && srStatus != 'SPE001' ) {
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
						
						if(multiComp == "Y"){							
							if($("#reqCompany").val() != "" & $("#reqCompany").val() != null){
								result.data = result.data + "&companyID=" + $("#reqCompany").val();
							}else{
								result.data = result.data + "&companyList="+companyIDList;
							}
						}else{
							if(companyIDList != "" & companyIDList != null) result.data = result.data + "&companyList="+companyIDList;
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
		
		var url = "processItsp.do";
		var data = "srCode="+srCode+"&pageNum="+$("#currPage").val()
					+ "&srMode=${srMode}&srType=${srType}&scrnType=${scrnType}&itemProposal=${itemProposal}&srID="+srID
					+ "&receiptUserID="+receiptUserID+"&projectID=${projectID}&itemID="+itemID
					+ "&category=" + $("#category").val()
					+ "&subCategory=" + $("#subCategory").val()
					+ "&srArea1=" + $("#srArea1").val()
					+ "&srArea2=" + $("#srArea2").val()
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
					+ "&searchSrCode=" +$("#srCode").val();
		var target = "srListDiv";		
		ajaxPage(url, data, target);
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
		var url = "registerItsp.do";
		var target = "srListDiv";
		if(srMode == "REG"){srMode = "";}
		var data = "srType=${srType}&srMode="+srMode+"&scrnType=${scrnType}&itemProposal=${itemProposal}"
				+ "&category="+$("#category").val()
				+ "&srArea1=" + $("#srArea1").val()
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
		
	function fnGetSRArea2(SRArea1ID){
		srArea2 = null;
		if(SRArea1ID == ''){
			$("#srArea2 option").not("[value='']").remove();
		} else {
			var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&parentID="+SRArea1ID+"&itemTypeCode=${itemTypeCode}";
			fnSelect('srArea2', data, 'getSrArea2', '${srArea2}', 'Select');
		}
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
		$("#srArea1").val("");
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
		srArea2 = null;
		subCategory = null;
		status = null;
		companyIDList = null;
		searchStatus = null;
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
	
	function gridDownInit(){	
		var d = setGridDownData();
		p_gridDownArea = fnNewInitGrid("grdGridDownArea", d);
		p_gridDownArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridDownArea.setIconPath("${root}${HTML_IMG_DIR}/");		
		p_gridDownArea.setPagingSkin("bricks");
	}
	
	function setGridDownData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "sr_SQL.getSRSummaryList";                                                                                                                                     
		result.header = "${menu.LN00024},SRCode,SR Status,SR Request Team,SR Receipt Team,CR Receipt Team,${srAreaLabelNM1},${srAreaLabelNM2},Category,Sub Category,SR Creation date,SR Request Due date,SR Due Date,SR Completion Date,Min SR Receipt date,Max SR Receipt date,${menu.LN00094},Project ID";
		result.cols = "SRCode|SRSTSNM|SRReqTeamNM|SRReceiptTeamNM|CRReceiptTeamNM|Domain|System|CategoryNM|SubCategoryNM|SRRegDT|SRRDD|SRDueDate|SRCompletionDT|MinSRRCVDT|MaxSRRCVDT|SRRCVCount|SRPOINT|MinCSRDT|MaxAPRVDT|CSRCount|APRVCount|MinCRRegDT|MaxCRRDD|MaxCRDueDate|MinCRReceiptDT|maxCRCompletionDT|CRCount|ProjectID";
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
	
	function fnSetValueInit(val){
		switch(val){
			case "srArea2" : srArea2 = null; break;
			case "subCategory" : subCategory = null; break;
			case "srStatus" : searchStatus = null; break;
			case "companyIDList" : companyIDList = null; break;
		}
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
	<div class="floatR mgT10 mgB10">
	   	<c:if test="${multiComp eq 'Y'}">
        	&nbsp;&nbsp;<input type="checkbox" id="multiCompHideShow" name="multiCompHideShow" OnClick="fnSetColumnHidden(4);" <c:if test="${multiComp eq 'Y'}"> checked </c:if>>&nbsp;Company
        	<span id="companySelect">&nbsp;&nbsp;<select id="reqCompany" Name="reqCompany" style="width:150px;"></select></span>
        </c:if>
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
    
 <c:if test="${scrnType != 'srRqst' }" >	  
    <tr>
   		<!-- 도메인 -->
       	<th class="alignL">${srAreaLabelNM1}</th>
        <td class="alignL">     
	       	<select id="srArea1" Name="srArea1" OnChange="fnGetSRArea2(this.value);" style="width: 100%;display: inline-block;">
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
    </tr>
     <tr>
      <!-- 요청자 -->
       	<th class="alignL">${menu.LN00025}</th>
        <td><input type="text" class="text" id="requestUser" name="requestUser" value="${requestUser}" style="ime-mode:active;" /></td>
 	
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
     
       	 <!-- SR 담당자 -->
       	<th class="alignL">${menu.LN00004}</th>
        <td><input type="text" class="text" id="receiptUser" name="receiptUser" value="${receiptUser}" style="ime-mode:active;" />
        </td> 
     	
        <!-- SR 완료예정일 -->
       	<th class="alignL">SR ${menu.LN00221}</th>
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
    <tr>
        <!-- SR No -->
       	<th class="alignL">SR No.</th>
      	<td ><input type="text" class="text" id="srCode" name="srCode" value="${searchSrCode}" style="ime-mode:active;" /></td>
       	<!-- 제목-->
        <th class="alignL" >${menu.LN00002}</th>     
	    <td><input type="text" class="text" id="subject" name="subject" value="${subject}" style="ime-mode:active;" /></td>
    
    	 <!-- 요청 부서 -->
        <th class="alignL">${menu.LN00026}</th>
        <td  class= "alignL">     
	        <select id="requestTeam" Name="requestTeam" style="width: 100%;display: inline-block;">
	            <option value=''>Select</option>
	        </select>
        </td> 
         <!-- 상태 -->
       	<th class="alignL">${menu.LN00027}</th>
        <td>      
	       	<select id="srStatus" Name="srStatus"  onchange="fnSetValueInit(this.id)" style="width: 100%;display: inline-block;">
	       		<option value=''>Select</option>
	       	</select>
       	</td> 
     
     </tr>   
  </c:if> 
  
  <c:if test="${scrnType == 'srRqst' }" >	  
     <tr> 
     	<!-- 카테고리 -->
       	<th class="alignL">${menu.LN00033}</th>
        <td class="alignL">      
	       	<select id="category" Name="category" style="width: 100%;display: inline-block;">
	       		<option value=''>Select</option>
	       	</select>
       	</td>       	
   		<!-- 도메인 -->
       	<th class="alignL">${srAreaLabelNM1}</th>
        <td class="alignL">     
	       	<select id="srArea1" Name="srArea1" OnChange="fnGetSRArea2(this.value);" style="width: 100%;display: inline-block;">
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
     </tr>
     <tr>    
       	<!-- 상태 -->
       	<th class="alignL">${menu.LN00027}</th>
        <td>      
	       	<select id="srStatus" Name="srStatus" style="width: 100%;display: inline-block;">
	       		<option value=''>Select</option>
	       	</select>
       	</td> 
   		<!-- SR No -->
       	<th class="alignL">SR No.</th>
      	 <td><input type="text" class="text" id="srCode" name="srCode" value="${searchSrCode}" style="ime-mode:active;" /></td>
       	<!-- 제목-->
        <th class="alignL">${menu.LN00002}</th>     
	     <td><input type="text" class="text" id="subject" name="subject" value="${subject}" style="ime-mode:active;" /></td>
     </tr>
   </c:if>   
   </table>
	<div class="countList pdT5 pdB5" >
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatL pdL20" style="display:inline">
     		<input type="radio" id="radioList" name="radioList" value="ING" <c:if test="${srStatus eq 'ING'}"> checked="checked" </c:if>>&nbsp;Processing&nbsp;
			<input type="radio" id="radioList" name="radioList" value="COMPL"  <c:if test="${srStatus eq 'COMPL' }"> checked="checked" </c:if>>&nbsp;Completed&nbsp;
			<input type="radio" id="radioList" name="radioList" value="ALL" <c:if test="${srStatus eq 'ALL' }"> checked="checked" </c:if>>&nbsp;ALL&nbsp;
		</li>
        <li class="floatR">
           	&nbsp;<span id="viewSearch" class="btn_pack medium icon"><span class="search"></span><input value="Search" type="submit" onclick="doSearchList();" style="cursor:hand;"></span>
           	<c:if test="${scrnType != 'srRqst' }" >
		      	<span id="viewSave" class="btn_pack medium icon"><span class="search"></span><input value="Transfered" type="submit" onclick="doSearchMyTRList();" style="cursor:hand;"></span>
           	</c:if>
           	<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="cursor:pointer;" onclick="fnClearSearchSR();">
           	<c:if test="${scrnType == 'srRqst' }" >
        	&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Create" type="submit" id="new" style="cursor:hand;"></span>&nbsp;
        	</c:if>
        	  	<!-- 삭제
        	<c:if test="${scrnType != 'srRqst' }" >
        	&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Create SR/CR" type="submit" id="createSRCR"></span>&nbsp;
        	</c:if>  -->
        	<c:if test="${scrnType == 'srRcv'}" ><span class="btn_pack small icon"><span class="down"></span><input value="Data" type="button" id="data" OnClick="fnDownData()"></span></c:if>
        	<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
        </li>
    </div>
    
	<div id="gridDiv" class="mgB10 clear" class="clear" >
		<div id="grdGridArea"></div>
	</div>
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL5"></div></div>
	<!-- Data Excel [SRSummaryView List] -->
	<c:if test="${scrnType == 'srRcv'}" >
	<div id="gridDownDiv" style="visibility:hidden;overflow:hidden;height:10px;">
	<li class="count">Total <span id="TOT_CNTD"></span></li>
		<div id="grdGridDownArea" style="width:100%;height:40px;overflow:hidden;"></div>
	</div>
	</c:if>
</form>
</div>