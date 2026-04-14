<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
	var screenType = "${screenType}";
	var srMode = "${srMode}";
	var srType = "${srType}";
	var itemID = "${itemID}";
		
	$(document).ready(function(){	
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 360)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 360)+"px;");
		};
		
		$("#excel").click(function(){fnGridExcelDownLoad();});
		
		setTimeout(function() {$('#srCode').focus();}, 0);
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}";
		fnSelect('srArea1', data + "&itemTypeCode=${itemTypeCode}", 'getSrArea1', '${srArea1}', 'Select');
		fnSelect('category', data +"&level=1", 'getSrCategory', '${category}', 'Select');
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
		}else if("${srID}" != "" && parent.$("#screenType").val() == "srRcv"){ // 외부에서 접수 페이지 바로가기 
			fnGoDetail();
			parent.$("#screenType").val("");
		}else if("${mainType}"=="SRDtl" || "${mainType}" == "mySRDtl" || "${mainType}" == "SRDtlView"){
			if("${srID}" != ""){ fnGoDetail();
			}else{ setTimeout(function() { doSearchList("Y");},1000 );}
		}else{
			setTimeout(function() { doSearchList("Y"); if(screenType=='srRcv'){gridDownInit();} },1000 );
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
		var screenType = "${screenType}";
		var mainType = "${mainType}";
		var srID = "${srID}";
		var url = "processSR.do";
		var data = "&pageNum="+$("#currPage").val()
					+"&srMode=${srMode}&srType=${srType}&screenType=${screenType}&srID="+srID+"&mainType="+mainType;
		var target = "srListDiv";
		//goDetail(url, data);
		ajaxPage(url, data, target);
	}
	
	function doSearchMyTRList(){
		$("#srMode").val("myTR");
		doSearchList();
	}
	
	function fnRegistSR(){
		var sysCode = parent.top.$('#sysCode').val();
		var proposal = parent.top.$('#proposal').val();
		var url = "registSR.do";
		var target = "srListDiv";
		if(srMode == "REG"){srMode = "";}
		var data = "srType=ITSP&srMode="+srMode+"&screenType=${screenType}"
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
		var data = "srType=ITSP&srMode=${srMode}&screenType=${screenType}";
		//goDetail(url, data);
		ajaxPage(url, data, target);
	}
	
	function fnGetSRArea2(SRArea1ID){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			  + "&userID=${sessionScope.loginInfo.sessionUserId}"
			  + "&srType=${srType}&parentID="+SRArea1ID
			  +"&itemTypeCode=${itemTypeCode}";
		fnSelect('srArea2', data, 'getSrArea2', '${srArea2}', 'Select');
	}
	
	function fnGetSubCategory(parentID){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&parentID="+parentID;
		fnSelect('subCategory', data, 'getSrCategory', '${subCategory}', 'Select');
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
    
 	 <c:if test="${screenType != 'srRqst' }" >	  
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
	            <input type="text" id="REG_STR_DT" name="REG_STR_DT" value="${startRegDT}"	class="input_off datePicker stext" size="8"
					style="width: 100px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				
				~
				<input type="text" id="REG_END_DT" name="REG_END_DT" value="${endRegDT}"	class="input_off datePicker stext" size="8"
					style="width: 100px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				
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
		 	<input type="text" id="ST_SRDUE_DT" name="ST_SRDUE_DT" value="${stSRDueDate}" class="input_off datePicker stext" size="8"
				style="width:100px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
			
			~
			<input type="text" id="END_SRDUE_DT" name="END_SRDUE_DT" value="${endSRDueDate}"	class="input_off datePicker stext" size="8"
				style="width: 100px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="15">
			
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
  
  <c:if test="${screenType == 'srRqst' }" >	  
    <tr> 
     	<!-- 카테고리 -->
       	<th class="alignL pdL10 viewtop">${menu.LN00033}</th>
        <td class="viewtop alignL">      
	       	<select id="category" Name="category" style="width:90%">
	       		<option value=''>Select</option>
	       	</select>
       	</td>       	
   		<!-- 도메인 -->
       	<th class="alignL viewtop pdL10">${srAreaLabelNM1}</th>
        <td class="viewtop alignL">     
	       	<select id="srArea1" Name="srArea1" OnChange="fnGetSRArea2(this.value);" style="width:90%">
	       		<option value=''>Select</option>
	       	</select>
       	</td>
       	<!-- 시스템 -->
        <th class="alignL viewtop pdL10">${srAreaLabelNM2}</th>
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
           	<c:if test="${screenType != 'srRqst' }" >
		      	<span id="viewSave" class="btn_pack medium icon"><span class="search"></span><input value="Transfered" type="submit" onclick="doSearchMyTRList();" style="cursor:hand;"></span>
           	</c:if>
        	<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;cursor:hand;" onclick="fnClearSearchSR();" >
        	<c:if test="${screenType == 'srRqst' }" >
        	&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Create" type="submit" id="new" style="cursor:hand;"></span>&nbsp;
        	</c:if>
        	  	<!-- 삭제
        	<c:if test="${screenType != 'srRqst' }" >
        	&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Create SR/CR" type="submit" id="createSRCR"></span>&nbsp;
        	</c:if>  -->
        	<c:if test="${screenType == 'srRcv'}" ><span class="btn_pack small icon"><span class="down"></span><input value="Data" type="button" id="data" OnClick="fnDownData()"></span></c:if>
        	<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
        </li>
    </div>
    
	<div id="layout" style="width:100%;"></div>
	<div id="pagination" style="width:100%; height:60px;"></div>
	
	<!-- Data Excel [SRSummaryView List] -->
	<c:if test="${screenType == 'srRcv'}" >
	<div id="gridDownDiv" style="visibility:hidden;">
	<li class="count">Total <span id="TOT_CNTD"></span></li>
		<div id="grdGridDownArea" style="width:100%;height:40px;overflow:hidden;"></div>
	</div>
	</c:if>
</form>
</div>
<script>
	doSearchList();
	
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid = new dhx.Grid("grid",  {
		columns: [
	        { width: 90, id: "SRCode", header: [{ text: "SR No.", align:"center"}], align:"center" },
	        { id: "Subject", header: [{ text: "${menu.LN00002}", align:"center" }]},
	        { width: 100, id: "CompanyName", header: [{ text: "${menu.LN00014}", align:"center" }]},
	        { width: 80, id: "StatusName", header: [{text: "${menu.LN00027}", align:"center"}], align:"center"},
	        { width: 70, id: "ReqUserNM", header: [{ text: "${menu.LN00025}", align:"center" }], align:"center"},
	        { width: 70, id: "SRArea1Name", header: [{ text: "${srAreaLabelNM1}", align:"center" }], align:"center"},
	        { width: 70, id: "SRArea2Name", header: [{ text: "${srAreaLabelNM2}", align:"center" }], align:"center"},
	        { width: 80, id: "SubCategoryNM", header: [{ text: "${menu.LN00033}", align:"center" }], align:"center"},
	        { width: 70, id: "ReceiptInfo", header: [{ text: "${menu.LN00004}", align:"center" }], align:"center"},
	        { width: 70, id: "RegDate", header: [{ text: "${menu.LN00093}", align:"center" }], align:"center"},
	        { width: 80, id: "SRDueDate", header: [{ text: "SR ${menu.LN00221}", align:"center" }], align:"center"},
	        { width: 80, id: "CRDueDate", header: [{ text: "CR ${menu.LN00221}", align:"center" }], align:"center"},
	        { width: 70, id: "SRCompletionDT", header: [{ text: "${menu.LN00064}", align:"center" }], align:"center"},
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false
	});
		
	layout.getCell("a").attach(grid);
	
	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 30,
	});	
	
	function doSearchList(onLoad){
		var projectID;
		var result = new Object();
		if($("#srMode").val() != ""){
			srMode = "myTR";
		}else{
			srMode = "${srMode}";
		}
		
		var sqlID = "sr_SQL.getSrMSTList";
		var param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
			+ "&pageNum=" + $("#currPage").val()
			+ "&screenType=" + screenType
			+ "&srMode=" +srMode
			+ "&srType=" +srType
			+ "&itemID=" +itemID
			+ "&category=" + $("#category").val()
			+ "&srCode=" + $("#srCode").val()
			+ "&srArea1=" + $("#srArea1").val()
			+ "&srArea2=" + $("#srArea2").val()
			+ "&subject=" + $("#subject").val()
			+ "&custLvl=${custLvl}"
			+ "&sqlID="+sqlID;
			
		if(screenType != "srRqst") {
			param = param  							
			+ "&regStartDate=" + $("#REG_STR_DT").val()
			+ "&regEndDate=" + $("#REG_END_DT").val()							
			+ "&stSRDueDate=" + $("#ST_SRDUE_DT").val() 
			+ "&endSRDueDate=" + $("#END_SRDUE_DT").val()
			if($("#subCategory").val() != '' & $("#subCategory").val() != null){
				param = param + "&subCategory=" + $("#subCategory").val();
			}else if("${subCategory}" != '' & "${subCategory}" != null){
				param = param + "&subCategory=${subCategory}";
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
					param = param + "&customerNo=${customerNo}";
				}else if("${custLvl}" == "C"){								
					if(reqCompanyArray.length > 0){
						param = param+ "&companyList="+reqCompanyArray; 
					}else{
						param = param+ "&companyList="+companyIDs; 
					}
				}else if("${custLvl}" == "D"){
					if(reqTeamArray.length > 0 ){
						param = param+ "&requestTeamList="+reqTeamArray; 
					}else{
						param = param+ "&requestTeamList="+teamIDs; 
					}
				}
			}else{
				param = param+ "&companyList="+reqCompanyArray; 
				param = param+ "&requestTeamList="+reqTeamArray; 
			}
		}
			
		if(srStatusArray.length > 0) {
			param = param + "&srStatusArr=" + srStatusArray;
		}else if("${srStatus}" != '' & "${srStatus}" != null ){
			param = param + "&srStatus=${srStatus}";
		}
		
		if (srMode == "mySR") {
			param = param + "&loginUserId=${sessionScope.loginInfo.sessionUserId}";
		}else if(srMode == "PG" || srMode == "PJT") {
			param = param + "&refID=${refID}";
		}else if (srMode == "myTeam") {
			//param = param + "&myTeamId=${sessionScope.loginInfo.sessionTeamId}";
		}else if(srMode == "myTR"){
			param = param + "&loginUserId=${sessionScope.loginInfo.sessionUserId}";
		}
		
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				grid.data.parse(result);
				$("#TOT_CNT").html(grid.data.getLength());
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	}
	
	grid.events.on("cellClick", function(row,column,e){
		var screenType = "${screenType}";
		var srCode = row.SRCode;
		var srID = row.SRID;
		var receiptUserID = row.ReceiptUserID;
		var status = row.Status;
		
		var srStatus = $("#srStatus").val();
		if(srStatus == ""){
			srStatus = "${srStatus}";
		}
		if(srStatus == ""){
			srStatus = "${status}";
		}
		var url = "processSR.do";
		var data = "?srCode="+srCode+"&pageNum="+$("#currPage").val()
					+ "&srMode=${srMode}&srType=${srType}&screenType=${screenType}&srID="+srID
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
		
		var target = "srListDiv";		
		ajaxPage(url, data, target);
	});
	
	var grdGridDownArea = "";
	
	function fnDownData() {			
		fnGridExcelDownLoad(grdGridDownArea);
	}
		
	function gridDownInit(){	
		grdGridDownArea = new dhx.Grid("grdGridDownArea",  {
			columns: [
		        { width: 80, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center" },
		        { width: 80, id: "SRCode", header: [{ text: "SRCode", align:"center"}], align:"center" },
		        { width: 80, id: "SRSTSNM", header: [{ text: "SR Status", align:"center"}], align:"center" },
		        { width: 80, id: "SRReqTeamNM", header: [{ text: "SR Request Team", align:"center"}], align:"center" },
		        { width: 80, id: "SRReceiptTeamNM", header: [{ text: "SR Receipt Team", align:"center"}], align:"center" },
		        { width: 80, id: "CRReceiptTeamNM", header: [{ text: "CR Receipt Team", align:"center"}], align:"center" },
		        { width: 80, id: "Domain", header: [{ text: "Domain", align:"center"}], align:"center" },
		        { width: 80, id: "System", header: [{ text: "System", align:"center"}], align:"center" },
		        { width: 80, id: "CategoryNM", header: [{ text: "Category", align:"center"}], align:"center" },
		        { width: 80, id: "SubCategoryNM", header: [{ text: "Sub Category", align:"center"}], align:"center" },
		        { width: 80, id: "SRRegDT", header: [{ text: "SR Creation date", align:"center"}], align:"center" },
		        { width: 80, id: "SRRDD", header: [{ text: "SR Request Due date", align:"center"}], align:"center" },
		        { width: 80, id: "SRDueDate", header: [{ text: "SR Due Date", align:"center"}], align:"center" },
		        { width: 80, id: "SRCompletionDT", header: [{ text: "SR Completion Date", align:"center"}], align:"center" },
		        { width: 80, id: "MinSRRCVDT", header: [{ text: "Min SR Receipt date", align:"center"}], align:"center" },
		        { width: 80, id: "MaxSRRCVDT", header: [{ text: "Max SR Receipt date", align:"center"}], align:"center" },
		        { width: 80, id: "SRRCVCount", header: [{ text: "SR Receipt Count", align:"center"}], align:"center" },
		        { width: 80, id: "SRPOINT", header: [{ text: "SR POINT", align:"center"}], align:"center" },
		        { width: 80, id: "MinCSRDT", header: [{ text: "Min CSR Creation Date", align:"center"}], align:"center" },
		        { width: 80, id: "MaxAPRVDT", header: [{ text: "Approval Date", align:"center"}], align:"center" },
		        { width: 80, id: "CSRCount", header: [{ text: "CSR Count", align:"center"}], align:"center" },
		        { width: 80, id: "APRVCount", header: [{ text: "Approval Count", align:"center"}], align:"center" },
		        { width: 80, id: "MinCRRegDT", header: [{ text: "CR Creation Date", align:"center"}], align:"center" },
		        { width: 80, id: "MaxCRRDD", header: [{ text: "CR Request Due date", align:"center"}], align:"center" },
		        { width: 80, id: "MaxCRDueDate", header: [{ text: "CR Due Date", align:"center"}], align:"center" },
		        { width: 80, id: "MinCRReceiptDT", header: [{ text: "CR Receipt Date", align:"center"}], align:"center" },
		        { width: 80, id: "maxCRCompletionDT", header: [{ text: "CR Completion date", align:"center"}], align:"center" },
		        { width: 80, id: "CRCount", header: [{ text: "CR Count", align:"center"}], align:"center" },
		    ],
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false
		});
		
		setGridDownData();
	}
	
	function setGridDownData(){		
		var sqlID = "sr_SQL.getSRSummaryList";
		var param ="srRegStartDT="+$("#REG_STR_DT").val()+"&srRegEndDT="+$("#REG_END_DT").val()
			+ "&sqlID="+sqlID;
		
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				grdGridDownArea.data.parse(result);
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	}
</script>