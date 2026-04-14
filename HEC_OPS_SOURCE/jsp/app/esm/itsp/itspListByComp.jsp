<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>

<script>
	var p_gridArea;	var p_gridDownArea;
	var scrnType = "${scrnType}";
	var srMode = "${srMode}";
	var srType = "${srType}";
	var itemID = "${itemID}";
		
	$(document).ready(function(){	
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 290)+"px;");
		};
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		setTimeout(function() {$('#srCode').focus();}, 0);
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}";
		fnSelect('srArea1', data, 'getESMSRArea1', '${srArea1}', 'Select', 'esm_SQL');
		fnSelect('category', data +"&level=1", 'getESMSRCategory', '${category}', 'Select', 'esm_SQL');
		//fnSelect('srStatus', data+"&category=SRSTS", 'getDictionaryOrdStnm', '${status}', 'Select');
  		//fnSelect('requestTeam', data, 'getReqTeamID', '${requestTeam}', 'Select');	
  		$('#reqCompanyID').SumoSelect();
  		fnGetReqCompanyIDList();
  		
  		$('#reqTeamID').SumoSelect();
  		
  		$('#srStatus').SumoSelect();
  		fnGetSRStatusList();
		
  		if("${srArea1}" != ""){fnGetSRArea2("${srArea1}");}
		if("${category}" != ""){fnGetSubCategory("${category}");}
		
		$("input.datePicker").each(generateDatePicker);
		/* $('.searchList').click(function(){
			doSearchList();
			return false;
		}); */
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
		
		$('#createSRCR').click(function(){ 
			fnRegistSRCR();
			return false;
		});	
		
		setTimeout(function() {$('#searchValue').focus();}, 0);
		parent.top.$('#mainType').val("");
		if(srMode == "REG"){
			fnRegistSR();
		}else if("${srID}" != "" && parent.$("#scrnType").val() == "srRcv"){ // 외부에서 접수 페이지 바로가기 
			fnGoDetail();
			parent.$("#scrnType").val("");
		}else if("${mainType}"=="SRDtl" || "${mainType}" == "mySRDtl" || "${mainType}" == "SRDtlView"){
			if("${srID}" != ""){ fnGoDetail();
			}else{ setTimeout(function() { gridInit(); doSearchList("Y");},1000 );}
		}else{
			setTimeout(function() { gridInit(); doSearchList("Y"); if(scrnType=='srRcv'){gridDownInit();} },1000 );
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
		p_gridArea.setColumnHidden(12, true);
		p_gridArea.setColumnHidden(13, true);
		p_gridArea.setColumnHidden(14, true);
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
		
	function setGridData(onLoad){
		var projectID;
		var result = new Object();
		if($("#srMode").val() != ""){
			srMode = "myTR";
		}else{
			srMode = "${srMode}";
		}
		result.title = "${title}";
		result.key = "sr_SQL.getSrMSTList";
		result.header = "${menu.LN00024},SR No.,${menu.LN00002},${menu.LN00014},${menu.LN00027},${menu.LN00025},${menu.LN00274},${menu.LN00185},${menu.LN00033},${menu.LN00004},${menu.LN00093},SR${menu.LN00221},srID,ReceiptUserID,Status,CR${menu.LN00221},${menu.LN00064}";
		result.cols = "SRCode|Subject|CompanyName|StatusName|ReqUserNM|SRArea1Name|SRArea2Name|SubCategoryNM|ReceiptInfo|RegDate|SRDueDate|SRID|ReceiptUserID|Status|CRDueDate|SRCompletionDT";
		result.widths = "0,90,*,100,80,70,70,70,80,70,70,80,70,70,70,80,70";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,left,left,center,center,center,center,center,center,center,center,left,center,left,left,left,left";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
						+ "&pageNum=" + $("#currPage").val()
						+ "&scrnType=" + scrnType
						+ "&srMode=" +srMode
						+ "&srType=" +srType
						+ "&itemID=" +itemID
						+ "&category=" + $("#category").val()
						+ "&srCode=" + $("#srCode").val()
						+ "&srArea1=" + $("#srArea1").val()
						+ "&srArea2=" + $("#srArea2").val()
						+ "&subject=" + $("#subject").val()
						+ "&custLvl=${custLvl}";
					
						if(scrnType != "srRqst") {
							result.data = result.data  							
							+ "&regStartDate=" + $("#REG_STR_DT").val()
							+ "&regEndDate=" + $("#REG_END_DT").val()							
							+ "&stSRDueDate=" + $("#ST_SRDUE_DT").val() 
							+ "&endSRDueDate=" + $("#END_SRDUE_DT").val() 
							//+ "&requestUserName=" + $("#requestUser").val() 
							//+  "&receiptUserName=" + $("#receiptUser").val()
							//+ "&requestTeam=" + $("#requestTeam").val()	;
							if($("#subCategory").val() != '' & $("#subCategory").val() != null){
								result.data = result.data + "&subCategory=" + $("#subCategory").val();
							}else if("${subCategory}" != '' & "${subCategory}" != null){
								result.data = result.data + "&subCategory=${subCategory}";
							}
							// 요청조직 
							var reqCompanyArray = new Array();
							$("#reqCompanyID :selected").each(function(i, el){ 
								reqCompanyArray.push($(el).val());
							});
							var reqTeamArray = new Array();
							$("#reqTeamID :selected").each(function(i, el){ 
								reqTeamArray.push($(el).val());
							});
							var srStatusArray = new Array();
							$("#srStatus :selected").each(function(i, el){ 
								srStatusArray.push("'"+$(el).val()+"'");
							});
							var teamIDs = "";
							var companyIDs = "";
							if(onLoad == "Y"){
								teamIDs = "${teamIDs}";
								companyIDs = "${companyIDs}";
							}
							if("${custLvl}" != ""){
								if("${custLvl}" == "G"){
									result.data = result.data + "&customerNo=${customerNo}";
								}else if("${custLvl}" == "C"){								
									if(reqCompanyArray.length > 0){
										result.data = result.data+ "&companyList="+reqCompanyArray; 
									}else{
										result.data = result.data+ "&companyList="+companyIDs; 
									}
								}else if("${custLvl}" == "D"){
									if(reqTeamArray.length > 0 ){
										result.data = result.data+ "&requestTeamList="+reqTeamArray; 
									}else{
										result.data = result.data+ "&requestTeamList="+teamIDs; 
									}
								}
							}else{
								result.data = result.data+ "&companyList="+reqCompanyArray; 
								result.data = result.data+ "&requestTeamList="+reqTeamArray; 
							}
						}
							
						if(srStatusArray.length > 0) {
							result.data = result.data + "&srStatusArr=" + srStatusArray;
						}else if("${srStatus}" != '' & "${srStatus}" != null ){
							result.data = result.data + "&srStatus=${srStatus}";
						}
						
						if (srMode == "mySR") {
							result.data = result.data + "&loginUserId=${sessionScope.loginInfo.sessionUserId}";
						}else if(srMode == "PG" || srMode == "PJT") {
							result.data = result.data + "&refID=${refID}";
						}else if (srMode == "myTeam") {
							//result.data = result.data + "&myTeamId=${sessionScope.loginInfo.sessionTeamId}";
						}else if(srMode == "myTR"){
							result.data = result.data + "&loginUserId=${sessionScope.loginInfo.sessionUserId}";
						}
						
						// alert(result.data);
						
		return result;
	}
		
	function gridOnRowSelect(id, ind){
		var scrnType = "${scrnType}";
		var srCode = p_gridArea.cells(id, 1).getValue();
		var srID = p_gridArea.cells(id, 12).getValue();
		var receiptUserID = p_gridArea.cells(id, 13).getValue();
		var status = p_gridArea.cells(id, 14).getValue();
		
		var srStatus = $("#srStatus").val();
		if(srStatus == ""){
			srStatus = "${srStatus}";
		}
		if(srStatus == ""){
			srStatus = "${status}";
		}
		var url = "processSR.do";
		var data = "?srCode="+srCode+"&pageNum="+$("#currPage").val()
					+ "&srMode=${srMode}&srType=${srType}&scrnType=${scrnType}&srID="+srID
					+ "&receiptUserID="+receiptUserID+"&srStatus="+status+"&projectID=${projectID}&itemID="+itemID
					+ "&category=" + $("#category").val()
					+ "&subCategory=" + $("#subCategory").val()
					+ "&srArea1=" + $("#srArea1").val()
					+ "&srArea2=" + $("#srArea2").val()
					+ "&srCode=" + $("#srCode").val()
					+ "&subject=" + $("#subject").val()
					+ "&status=" +srStatus
					+ "&receiptUser=" + $("#receiptUser").val()
					+ "&requestUser=" +$("#requestUser").val()
					+ "&requestTeam=" +$("#requestTeam").val()
					+ "&startRegDT=" +$("#REG_STR_DT").val()
					+ "&endRegDT=" +$("#REG_END_DT").val()
					+ "&stSRDueDate=" +$("#ST_SRDUE_DT").val()
					+ "&endSRDueDate=" +$("#END_SRDUE_DT").val()
					+ "&searchSrCode=" +$("#srCode").val();  
		
		var w = 1200;
		var h = 780;
		window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
	
	function fnGoDetail(){
		var scrnType = "${scrnType}";
		var mainType = "${mainType}";
		var srID = "${srID}";
		var url = "processSR.do";
		var data = "&pageNum="+$("#currPage").val()
					+"&srMode=${srMode}&srType=${srType}&scrnType=${scrnType}&srID="+srID+"&mainType="+mainType;
		var target = "srListDiv";
		//goDetail(url, data);
		ajaxPage(url, data, target);
	}
	
	function doSearchList(onLoad){  
		$("#srMode").val("");
		var d = setGridData(onLoad);
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	function doSearchMyTRList(){
		$("#srMode").val("myTR");
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	function fnRegistSR(){
		var sysCode = parent.top.$('#sysCode').val();
		var proposal = parent.top.$('#proposal').val();
		var url = "registSR.do";
		var target = "srListDiv";
		if(srMode == "REG"){srMode = "";}
		var data = "srType=ITSP&srMode="+srMode+"&scrnType=${scrnType}"
					+ "&category="+$("#category").val()
					+ "&srArea1=" + $("#srArea1").val()
					+ "&srArea2=" + $("#srArea2").val()
					+ "&status=" + $("#srStatus").val()
					+ "&searchSrCode=" + $("#srCode").val()
					+ "&subject=" + $("#subject").val()
					+ "&sysCode="+sysCode;	
		parent.top.$('#sysCode').val("");
		ajaxPage(url, data, target);
		
	}
	
	function fnRegistSRCR(){
		var url = "registSRCR.do";
		var target = "srListDiv";
		var data = "srType=ITSP&srMode=${srMode}&scrnType=${scrnType}";
		//goDetail(url, data);
		ajaxPage(url, data, target);
	}
	
	function fnGetSRArea2(SRArea1ID){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&parentID="+SRArea1ID;
		fnSelect('srArea2', data, 'getSrArea2', '${srArea2}', 'Select');
	}
	
	function fnGetSubCategory(parentID){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&parentID="+parentID;
		fnSelect('subCategory', data, 'getESMSRCategory', '${subCategory}', 'Select', 'esm_SQL');
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
		//$("#requestUser").val("");
		//$("#receiptUser").val("");
		$("#requestTeam").val("");		
		$("#srCode").val("");
		$("#subject").val("");		
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
		result.header = "${menu.LN00024},SRCode,SRSTSNM,SRReqTeamNM,SRReceiptTeamNM,CRReceiptTeamID,Domain,System,CategoryNM,SubCategoryNM,SRRegDT,SRRDD,SRDueDate,SRCompletionDT,MinSRRCVDT,MaxSRRCVDT,SRRCVCount,SRPOINT,MinCSRDT,MaxAPRVDT,CSRCount,APRVCount,MinCRRegDT,MaxCRRDD,MaxCRDueDate,MinCRReceiptDT,maxCRCompletionDT,CRCount";
		result.cols = "SRCode|SRSTSNM|SRReqTeamNM|SRReceiptTeamNM|CRReceiptTeamID|Domain|System|CategoryNM|SubCategoryNM|SRRegDT|SRRDD|SRDueDate|SRCompletionDT|MinSRRCVDT|MaxSRRCVDT|SRRCVCount|SRPOINT|MinCSRDT|MaxAPRVDT|CSRCount|APRVCount|MinCRRegDT|MaxCRRDD|MaxCRDueDate|MinCRReceiptDT|maxCRCompletionDT|CRCount";
		result.widths = "80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "srRegStartDT="+$("#REG_STR_DT").val()+"&srRegEndDT="+$("#REG_END_DT").val();
		return result;
	}
		
	function fnGetReqCompanyIDList(){		
		var url    = "getSearchSelectOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&sqlID=getReqCompanyList_commonSelect";
		var target = "reqCompanyID";            // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxMultiSelect(url, data, target, defaultValue, isAll);
		setTimeout(function() { fnAppendCompanyOption(); },1000 );
	}
		
	function fnAppendCompanyOption(){
		$('#reqCompanyID')[0].sumo.reload();
		setTimeout(function() { fnGetReqTeamList();},1000 );
		<c:forEach var="i" items="${companyList}" varStatus="iStatus">
			fnCheckMultiSelectBox('${i.CODE}','${i.NAME}','reqCompanyID');
		</c:forEach>
	}
	
	function fnCheckMultiSelectBox(value,text,id) {
		var companyListSize = "${companyList.size()}";	
		$("#"+id)[0].sumo.attrOptClick("option"+value);
	}
	
	function fnGetSRStatusList(){		
		var url    = "getDictionarySelectOption.do"; 
		var data   = "sqlID=common_SQL.getDictionaryOrdStnm_commonSelect&category=SRSTS"; 
		var target = "srStatus";            // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxMultiSelect(url, data, target, defaultValue, isAll);
		setTimeout(function() { fnAppendSRStatusOption(); },1000 );
	}
	
	function fnAppendSRStatusOption(){
		$('#srStatus')[0].sumo.reload();
		fnCheckMultiSelectBox3('${srStatus}','srStatus');
	}
	
	function fnCheckMultiSelectBox3(value,id) { 
		$("#"+id)[0].sumo.attrOptClick("option"+value);
	}
	
	function fnClickedCompany(avg,avg2){ 
		setTimeout(function() { fnGetReqTeamList();},1000 );
	}
	
	function fnGetReqTeamList(){
		var reqCompanyArray = new Array();
		$("#reqCompanyID :selected").each(function(i, el){ 
			reqCompanyArray.push($(el).val());
		});
		
		var url    = "getSearchSelectOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&sqlID=common_SQL.getReqTeamID_commonSelect&parentIDs="+reqCompanyArray;
		var target = "reqTeamID";            // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxMultiSelect(url, data, target, defaultValue, isAll);
		setTimeout(function() { fnAppendTeamOption(); },1000 );
	}
		
	function fnAppendTeamOption(){
		$('#reqTeamID')[0].sumo.reload();
		<c:forEach var="i" items="${teamList}" varStatus="iStatus">
			fnCheckMultiSelectBox2('${i.CODE}','${i.NAME}','reqTeamID');
		</c:forEach>
	}
	
	function fnCheckMultiSelectBox2(value,text,id) {
		$("#"+id)[0].sumo.attrOptClick("option2"+value);
	}
	
</script>

<div id="srListDiv" >
<form name="srFrm" id="srFrm" action="" method="post"  onsubmit="return false;">
	<input type="hidden" id="NEW" name="NEW" value="">
	<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<input type="hidden" id="srMode" name="srMode">
	<div class="floatL msg" style="width:100%"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;${menu.LN00275}</span></div>
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
		<colgroup>
		    <col width="10%">
		    <col width="23%">
		 	<col width="10%">
		    <col width="23%">
		 	<col width="10%">
		    <col width="24%">
	    </colgroup>
    
 	 <c:if test="${scrnType != 'srRqst' }" >	  
 	 <tr>
       	<!-- 요청 company -->
       	<th class="viewtop alignL pdL10">요청 ${menu.LN00014}</th>
        <td class="viewtop alignL">
        	<select id="reqCompanyID" name="reqCompanyID[]" style="height:16px;" multiple="multiple">
				<option value="">Select</option>
			</select>
        </td>
   
        <!-- 요청 division -->
       	<th class="alignL viewtop pdL10">요청 ${menu.LN00186}</th>
        <td class="viewtop alignL">
        	<select id="reqTeamID" name="reqTeamID[]" style="height:16px;" multiple="multiple">
				<option value="">Select</option>
			</select>
        </td>
         	<!-- 상태 -->
       	<th class="alignL viewtop pdL10">${menu.LN00027}</th>
        <td class="viewtop alignL">      
	       	<select id="srStatus" Name="srStatus[]" style="height:16px;" multiple="multiple">
	       		<option value="">Select</option>
	       	</select>
       	</td> 
       </tr>
     
	   <tr>
	   		<!-- 도메인 -->
	       	<th class="alignL  pdL10">${srAreaLabelNM1}</th>
	        <td class="alignL">     
		       	<select id="srArea1" Name="srArea1" OnChange="fnGetSRArea2(this.value);" style="width:90%">
		       		<option value=''>Select</option>
		       	</select>
	       	</td>
	       	<!-- 시스템 -->
	        <th class="alignL pdL10">${srAreaLabelNM2}</th>
	       <td class="alignL">      
	        <select id="srArea2" Name="srArea2" style="width:90%">
	            <option value=''>Select</option>
	        </select>
	        </td>
	        	 <!-- 등록일-->
	        <th class="alignL pdL10">${menu.LN00013}</th>     
	        <td class="alignL">     
	            <font><input type="text" id="REG_STR_DT" name="REG_STR_DT" value="${startRegDT}"	class="input_off datePicker stext" size="8"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				</font>
				~
				<font><input type="text" id="REG_END_DT" name="REG_END_DT" value="${endRegDT}"	class="input_off datePicker stext" size="8"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				</font>
	         </td>
	  </tr>
      <tr>
     	<!-- 카테고리 -->
       	<th class="alignL pdL10">${menu.LN00033}</th>
        <td>     
	       	<select id="category" Name="category" OnChange="fnGetSubCategory(this.value);" style="width:90%">
	       		<option value=''>Select</option>
	       	</select>
       	</td>       	
       	<!-- 서브 카테고리 -->
        <th class="alignL pdL10">${menu.LN00273}</th>
        <td class="alignL">     
        <select id="subCategory" Name="subCategory" style="width:90%">
            <option value=''>Select</option>
        </select>
        </td>
         <!-- 완료예정일 -->
       	<th class="alignL pdL10">${menu.LN00221}</th>
        <td >     
		 	<font><input type="text" id="ST_SRDUE_DT" name="ST_SRDUE_DT" value="${stSRDueDate}" class="input_off datePicker stext" size="8"
				style="width:70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
			</font>
			~
			<font><input type="text" id="END_SRDUE_DT" name="END_SRDUE_DT" value="${endSRDueDate}"	class="input_off datePicker stext" size="8"
				style="width: 62px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="15">
			</font>
       	</td> 
      
     </tr>
     <tr>     
   		<!-- SR No -->
       	<th class="alignL pdL10">SR No.</th>
      		 <td ><input type="text" class="text" id="srCode" name="srCode" value="${searchSrCode}" style="ime-mode:active;width:90%;" /></td>
       	<!-- 제목-->
        <th class="alignL pdL10">${menu.LN00002}</th>     
	         <td colspan="3"><input type="text" class="text" id="subject" name="subject" value="${subject}" style="ime-mode:active;width:400px;" /></td>
     </tr>
  </c:if> 
  
  <c:if test="${scrnType == 'srRqst' }" >	  
    <tr> 
     	<!-- 카테고리 -->
       	<th class="alignL pdL10 viewtop">${menu.LN00033}</th>
        <td class="viewtop alignL">      
	       	<select id="category" Name="category" style="width:90%">
	       		<option value=''>Select</option>
	       	</select>
       	</td>       	
   		<!-- 도메인 -->
       	<th class="alignL viewtop pdL10">${menu.LN00274}</th>
        <td class="viewtop alignL">     
	       	<select id="srArea1" Name="srArea1" OnChange="fnGetSRArea2(this.value);" style="width:90%">
	       		<option value=''>Select</option>
	       	</select>
       	</td>
       	<!-- 시스템 -->
        <th class="alignL viewtop pdL10">${menu.LN00185}</th>
       <td class="viewtop alignL">      
        <select id="srArea2" Name="srArea2" style="width:90%">
            <option value=''>Select</option>
        </select>
        </td>    
    </tr>
    <tr>    
       	<!-- 상태 -->
       	<th class="alignL pdL10">${menu.LN00027}</th>
        <td>  
       	 	<select id="srStatus" Name="srStatus[]" style="height:16px;" multiple="multiple">
       		<option value=''>Select</option>
	       	</select>  
       	</td> 
   		<!-- SR No -->
       	<th class="alignL pdL10">SR No.</th>
      		 <td ><input type="text" class="text" id="srCode" name="srCode" value="${searchSrCode}" style="ime-mode:active;width:90%;" /></td>
       	<!-- 제목-->
        <th class="alignL pdL10">${menu.LN00002}</th>     
	         <td ><input type="text" class="text" id="subject" name="subject" value="${subject}" style="ime-mode:active;width:300px;" /></td>
     </tr>
  </c:if>   
   </table>
	<div class="countList pdT5 pdB5 " >
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
           	&nbsp;<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="doSearchList()" style="cursor:hand;"/>
           	<c:if test="${scrnType != 'srRqst' }" >
		      	<span id="viewSave" class="btn_pack medium icon"><span class="search"></span><input value="Transfered" type="submit" onclick="doSearchMyTRList();" style="cursor:hand;"></span>
           	</c:if>
        	<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;cursor:hand;" onclick="fnClearSearchSR();" >
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
    
	<div id="gridDiv" style="width:99%;" class="clear" >
		<div id="grdGridArea"></div>
	</div>
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div><div id="recinfoArea" class="floatL pdL10"></div></div>
	
	<!-- Data Excel [SRSummaryView List] -->
	<c:if test="${scrnType == 'srRcv'}" >
	<div id="gridDownDiv" style="visibility:hidden;">
	<li class="count">Total <span id="TOT_CNTD"></span></li>
		<div id="grdGridDownArea" style="width:100%;height:40px;overflow:hidden;"></div>
	</div>
	</c:if>
</form>
</div>