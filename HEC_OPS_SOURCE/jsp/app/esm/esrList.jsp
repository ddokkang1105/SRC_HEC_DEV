<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript">
	var p_gridArea;
	var fromSRID = "${fromSRID}";
	var subCategory = "${subCategory}";
	var srStatus = "${srStatus}";
	var status = "${status}";
	var companyIDList = "${companyIDList}";
	var searchStatus = "${searchStatus}";
	
	$(document).ready(function() {
		var height = "";
		if(fromSRID == "" || fromSRID == null){height = 272} else {height = 330}
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - height)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - height)+"px;");
		};
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		$("input.datePicker").each(generateDatePicker);
		$('#searchValue').keypress(function(onkey){
			if(onkey.keyCode == 13){
				doSearchList();
				return false;
			}
		});		
		
		gridInit();	
		doSearchList();
		
		fnSelect('srTypeCode', '&languageID=${sessionScope.loginInfo.sessionCurrLangType}', 'getNameFromSRTypeCode','', 'Select');
		
	});
	
	function fnGetStatusAndCat(srTypeCode){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType="+srTypeCode+"&fromSRID="+fromSRID;
		fnSelect('srStatus', data+"&itemClassCode=CL03004", 'getSRStatusList', '', 'Select', 'esm_SQL');
		fnSelect('category', data +"&level=1", 'getESMSRCategory', '${category}', 'Select','esm_SQL');
		fnSelect('requestTeam', data, 'getESMSRReqTeamID', '', 'Select','esm_SQL');
		fnSelect('srReceiptTeam', data, 'getESMSRReceiptTeamID', '', 'Select','esm_SQL');
	}
	
	function fnGetSubCategory(parentID){
		var srType = $("#srTypeCode").val();
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType="+srType+"&parentID="+parentID;
		fnSelect('subCategory', data, 'getESMSRCategory', '${subCategory}', 'Select', 'esm_SQL');
	}
	
	$('#new').click(function(){ 
		fnRegistSR();
		return false;
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
		if(multiComp!="Y") p_gridArea.setColumnHidden(6, true);
		
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPage").val(ind);});
	}
	
	function doSearchList(){ 
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	function setGridData(){
		var result = new Object();
		result.title = "${title}";
		result.key = "esm_SQL.getEsrMSTList";
		result.header = "${menu.LN00024},SR No.,${menu.LN00217},${menu.LN00002},${menu.LN00027},분류,${menu.LN00014},${menu.LN00025},${menu.LN00026},${menu.LN00033},${menu.LN00004},${menu.LN00093},${menu.LN00221},srID,ReceiptUserID,Status,${menu.LN00223},ReceiptTeamName,srType";
		result.cols = "SRCode|SRTypeNM|Subject|StatusName|SRAreaNM|CompanyName|ReqUserNM|ReqTeamNM|SubCategoryNM|ReceiptInfo|RegDate|SRDueDate|SRID|ReceiptUserID|Status|SRCompletionDT|ReceiptTeamName|SRType";
		result.widths = "0,100,150,*,120,*,80,100,90,90,120,90,90,0,0,0,90,0,0";
		result.sorting = "str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,left,center,left,center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
						+ "&pageNum=" + $("#currPage").val()
						+ "&fromSRID=${fromSRID}"
						+ "&requestUserName=" + $("#requestUser").val()
						+ "&requestTeam=" + $("#requestTeam").val()
						+ "&receiptUserName=" + $("#receiptUser").val()
						+ "&srReceiptTeam=" + $("#srReceiptTeam").val()
						+ "&regStartDate=" + $("#REG_STR_DT").val()
						+ "&regEndDate=" + $("#REG_END_DT").val()
						+ "&stSRDueDate=" + $("#ST_SRDUE_DT").val()
						+ "&endSRDueDate=" + $("#END_SRDUE_DT").val()
						+ "&subject=" + $("#subject").val()
						+ "&srCode=" + $("#srCode").val();
						
						if($("#srTypeCode").val() != '' & $("#srTypeCode").val() != null){
							result.data = result.data + "&srType=" + $("#srTypeCode").val()
							+ "&category=" + $("#category").val()
							+ "&subCategory=" + $("#subCategory").val();
							if((searchStatus != '' && searchStatus != null) || ($("#srStatus").val() != '' && $("#srStatus").val() != null)) {
								result.data = result.data + "&srStatus=" + $("#srStatus").val();
							} else 	if(srStatus != '' & srStatus != null ){
								result.data = result.data + "&srStatus="+srStatus;
							} else if(status != '' & status != null ){
								result.data = result.data + "&srStatus="+status;
							} 
						}
						
			return result;
	}
	
	// 검색 조건 초기화 
	function fnClearSearchSR(){;
		$("#srTypeCode").val("");
		$("#srStatus").val("");
		$("#category").val("");
		$("#subCategory").val("");
		$("#requestUser").val("");
		$("#requestTeam").val("");
		$("#receiptUser").val("");
		$("#srReceiptTeam").val("");
		$("#REG_STR_DT").val("");
		$("#REG_END_DT").val("");
		$("#ST_SRDUE_DT").val("");
		$("#END_SRDUE_DT").val("");
		$("#subject").val("");
		$("#srCode").val("");
		subCategory = null;
		status = null;
		companyIDList = null;
		searchStatus = null;
		return;
	}
	
	function gridOnRowSelect(id, ind){
		var scrnType = "${scrnType}";
		var srCode = p_gridArea.cells(id, 1).getValue();
		var srID = p_gridArea.cells(id, 13).getValue();
		var receiptUserID = p_gridArea.cells(id, 14).getValue();
		var status = p_gridArea.cells(id, 15).getValue();
		var srType = p_gridArea.cells(id, 18).getValue();
		var url;
		
		if(srType == "ITSP"){
			url = "processItsp.do";
		} else if(srType == "ISP"){
			url = "processIsp.do";
		}
		
		var srStatus = "";
		if("${srStatus}" != ""){
			srStatus = "${srStatus}";
		}
		
		var data = "srCode="+srCode+"&pageNum="+$("#currPage").val()
					+ "&srMode=${srMode}&scrnType=${scrnType}&itemProposal=${itemProposal}&srID="+srID
					+ "&receiptUserID="+receiptUserID+"&projectID=${projectID}"
					+ "&category=" + $("#category").val()
					+ "&subCategory=" + $("#subCategory").val()
					+ "&srCode=" + $("#srCode").val()
					+ "&subject=" + $("#subject").val()
					+ "&srStatus=" +srStatus
					+ "&status=" +status
					+ "&receiptUser=" + $("#receiptUser").val()
					+ "&requestUser=" +$("#requestUser").val()
					+ "&requestTeam=" +$("#requestTeam").val()
					+ "&startRegDT=" +$("#REG_STR_DT").val()
					+ "&endRegDT=" +$("#REG_END_DT").val()
					+ "&stSRDueDate=" + $("#ST_SRDUE_DT").val() 
					+ "&endSRDueDate=" + $("#END_SRDUE_DT").val() 
					+ "&searchSrCode=" +$("#srCode").val()
					+ "&srType="+srType+"&fromSRID=${fromSRID}";
		var target = "esrListDIv";		
		ajaxPage(url, data, target);
	}
	
	function doExcel() {		
		p_gridArea.toExcel("${root}excelGenerate");
	}
	
	function fnRegistSR(){
		var url = "registerItsp.do";
		var target = "esrListDIv";
		var data = "fromSRID=${fromSRID}&srType=ITSP";
		ajaxPage(url, data, target);
	}
	
		function fnSetValueInit(val){
		switch(val){
			case "subCategory" : subCategory = null; break;
			case "srStatus" : searchStatus = null; break;
			case "companyIDList" : companyIDList = null; break;
		}
	}
</script>


<div id="esrListDIv" class="pdL10 pdR10">
<form name="srFrm" id="srFrm" action="" method="post"  onsubmit="return false;">
	<input type="hidden" id="NEW" name="NEW" value="">
	<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<input type="hidden" id="srMode" name="srMode">
	<div class="floatL mgT10 mgB12"><h3><img src="${root}${HTML_IMG_DIR}/bullet_blue.png" id="subTitle_baisic">&nbsp;&nbsp;연관 SR 목록</h3></div>
	<c:if test="${multiComp eq 'Y'}">
		<div class="floatR mgB10">
	        	&nbsp;&nbsp;&nbsp;<input type="checkbox" id="multiCompHideShow" name="multiCompHideShow" OnClick="fnSetColumnHidden(7);" <c:if test="${multiComp eq 'Y'}"> checked </c:if>>&nbsp;Company
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
    <tr>
    	<!-- SR Type Code -->
    	<th class="alignL pdL5">SR Type</th>
        <td class="alignL">     
	       	<select id="srTypeCode" Name="srTypeCode" style="width:100%" OnChange="fnGetStatusAndCat(this.value);"></select>
       	</td>
	    <!-- 상태 -->
       	<th class="alignL pdL5">${menu.LN00027}</th>
        <td>      
	       	<select id="srStatus" Name="srStatus" style="width:100%"  onchange="fnSetValueInit(this.id)">
	       		<option value=''>Select</option>
	       	</select>
       	</td> 
       <!-- 카테고리 -->
       	<th class="alignL pdL5">${menu.LN00033}</th>
        <td class="alignL">	
	        <select id="category" Name="category" style="width:100%" OnChange="fnGetSubCategory(this.value);">
	        	<option value="">Select</option> 
	        </select>
       	</td>
       	<!-- 서브 카테고리 -->
       	<th class="alignL pdL5">${menu.LN00273}</th>
        <td class="alignL">	
	        <select id="subCategory" Name="subCategory" style="width:100%" onchange="fnSetValueInit(this.id)">
	        	<option value="">Select</option> 
	        </select>
       	</td>
    </tr>
     <tr> 
       	 <!-- 요청자 -->
       	<th class="alignL pdL5">${menu.LN00025}</th>
        <td><input type="text" class="text" id="requestUser" name="requestUser" value="${requestUser}" style="ime-mode:active;" /></td>
  		 <!-- 요청 부서 -->
        <th class="alignL pdL5">${menu.LN00026}</th>
        <td  class= "alignL">     
	        <select id="requestTeam" Name="requestTeam" style="width:100%">
	            <option value=''>Select</option>
	        </select>
        </td>
        <!-- 담당자 -->
       	<th class="alignL pdL5">${menu.LN00004}</th>
        <td><input type="text" class="text" id="receiptUser" name="receiptUser" value="${receiptUser}" style="ime-mode:active;" />
        <!-- 담당 부서 -->
        <th class="alignL pdL5">${menu.LN00153}</th>
        <td  class= "alignL">     
	        <select id="srReceiptTeam" Name="srReceiptTeam" style="width:100%">
	            <option value=''>Select</option>
	        </select>
        </td>
     </tr>
     <tr>
    	<!-- 요청일-->
        <th class="alignL pdL5">${menu.LN00093}</th>     
        <td>     
            <font><input type="text" id="REG_STR_DT" name="REG_STR_DT" value="${startRegDT}"	class="input_off datePicker stext" size="8"
				style="width:63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
			</font>
			~
			<font><input type="text" id="REG_END_DT" name="REG_END_DT" value="${endRegDT}"	class="input_off datePicker stext" size="8"
				style="width: 63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
			</font>
         </td> 
        <!-- SR 완료예정일 -->
       	<th class="alignL pdL5">${menu.LN00221}</th>
        <td>     
	       <font><input type="text" id="ST_SRDUE_DT" name="ST_SRDUE_DT" value="${stSRDueDate}" class="input_off datePicker stext" size="8"
				style="width:63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
			</font>
			~
			<font><input type="text" id="END_SRDUE_DT" name="END_SRDUE_DT" value="${endSRDueDate}"	class="input_off datePicker stext" size="8"
				style="width: 63px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
			</font>
       	</td>
       	<!-- 제목-->
        <th class="alignL pdL5" >${menu.LN00002}</th>     
	    <td><input type="text" class="text" id="subject" name="subject" value="${subject}" style="ime-mode:active;" /></td>
	    <!-- 요청 No -->
     	<th class="alignL pdL5">요청 No.</th>
      	<td><input type="text" class="text" id="srCode" name="srCode" value="${searchSrCode}" style="ime-mode:active;" /></td>
     </tr>
   </table>
	<div class="countList pdT5 pdB5" >
        <li class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
           	&nbsp;<span id="viewSearch" class="btn_pack medium icon"><span class="search"></span><input value="Search" type="submit" onclick="doSearchList();" style="cursor:hand;"></span>
           	<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="cursor:pointer;" onclick="fnClearSearchSR();">
           	<c:if test="${fromSRID ne null && fromSRID ne '' && fromSRIDinfo.ReceiptUserID eq sessionScope.loginInfo.sessionUserId && fromSRIDinfo.Status ne fromSRIDinfo.LastSpeCode}">
        	&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Create" type="submit" id="new" style="cursor:hand;"></span>&nbsp;
           	</c:if>
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
        </li>
    </div>
    
	<div id="gridDiv" style="width:100%;" class="clear" >
		<div id="grdGridArea"></div>
	</div>
	<div style="width:100%;" class="paginate_regular"><div id="pagingArea" style="display:inline-block;"></div></div>
</form>
</div>