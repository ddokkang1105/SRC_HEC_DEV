<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<script type="text/javascript">
	var p_gridArea;				// 그리드 전역변수(Project)
	var p_gridDownArea;
	var screenType = "${screenType}";
	var crMode = "${crMode}";
    var itemID = "${itemID}";
	var csrID = "${csrID}" ;

	$(document).ready(function(){	
		// 초기 표시 화면 크기 조정 
		$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 240)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#grdGridArea").attr("style","height:"+(setWindowHeight() - 240)+"px;");
		};
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}";
		fnSelect('crArea1', data, 'getSrArea1', '${crArea1}', 'Select');
		fnSelect('crStatus', data+"&category=CRSTS", 'getDictionaryOrdStnm', '${crStatus}', 'Select');
		fnSelect('priority', data+"&category=PRT", 'getDictionaryOrdStnm', '', 'Select');
	    fnSelect('receiptTeam', data, 'getCRReceiptTeamID', '${receiptTeam}', 'Select');
		if("${crArea1}" != ""){ 	fnGetCRArea2("${crArea1}");}
		
		$("input.datePicker").each(generateDatePicker);
		$('.searchList').click(function(){
			doSearchList(); 			
			setTimeout(function() { doSearchDownList();},100);
			return false;
		});
		$('#searchValue').keypress(function(onkey){
			if(onkey.keyCode == 13){
				doSearchList();
				setTimeout(function() { doSearchDownList();},100);
				return false;
			}
		});		
	
		setTimeout(function() { $('#searchValue').focus();}, 0);
		setTimeout(function() { gridInit(); doSearchList();},700 );
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
	
	function gridInit(){
		var d = setGridData(); 
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR}/");	
		p_gridArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		p_gridArea.enablePaging(true,20,null,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){$("#currPageI").val(ind);});
		p_gridArea.setColumnHidden(0, true);	
		p_gridArea.setColumnHidden(1, true);	
	}
	function setGridData(){
	    var result = new Object();
		result.title = "${title}";
		result.key = "cr_SQL.getCrMstList";
		result.header = "${menu.LN00024},CRID,CR No.,${menu.LN00002},${menu.LN00027},${menu.LN00025},${menu.LN00274},${menu.LN00185},${menu.LN00004},${menu.LN00227},${menu.LN00221},${menu.LN00064}";
		result.cols = "CRID|CRCode|Subject|StatusNM|RegUserName|CRArea1NM|CRArea2NM|ReceiptName|ReceiptTeamName|DueDate|CompletionDT";
		result.widths = "30,50,90,*,80,70,70,80,80,110,80,80,75,75,,75,75";
		result.sorting = "int,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,left,left,center,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&pageNum=" + $("#currPageI").val()
					+ "&crMode=" + crMode 
					+ "&screenType=" + screenType	;		
		
					if(crMode != "CSR"){
						result.data = result.data 
				    	+ "&itemID=" + itemID
						+ "&requestUserName=" + $("#requestUser").val()
						+ "&dueDate=" + $("#DUE_DT").val()  
						+ "&completionDT=" + $("#completionDT").val()
						+ "&subject=" + $("#subject").val()
						+ "&crStatus=" + $("#crStatus").val();
					}
					
					if(crMode != "ITM" && crMode != "CSR") {		
						result.data = result.data + "&crArea1=" + $("#crArea1").val()
						+ "&crArea2=" + $("#crArea2").val()
						+ "&receiptUserName=" + $("#receiptUser").val()
						+ "&receiptTeam=" + $("#receiptTeam").val();
					}
					
					if(crMode == "PG" || crMode == "PJT") {
						result.data = result.data + "&refID=${refID}";
					}else if (crMode == "CSR") {
						result.data = result.data + "&csrID=" + csrID;
					}else if (crMode == "myCr") {
				    	result.data = result.data + "&sessionUserId=${sessionScope.loginInfo.sessionUserId}";
					}else if (crMode == "myTeam") {
				 		result.data = result.data + "&sessionTeamId=${sessionScope.loginInfo.sessionTeamId}";
				 	}
		return result;
	}
	
	// 그리드ROW선택시 : 변경오더 조회 화면으로 이동
	function gridOnRowSelect(id, ind){
		var crID = p_gridArea.cells(id, 1).getValue();
		var crArea1 = $("#crArea1").val();
		var crArea2 = $("#crArea2").val();
		var requestUser = $("#requestUser").val();
		var crStatus = $("#crStatus").val();
		var DUE_DT = $("#DUE_DT").val();
		var completionDT = $("#completionDT").val();
		var receiptTeam = $("#receiptTeam").val();
		var receiptUser = $("#receiptUser").val();
		var subject = $("#subject").val();
		
		var url = "crInfoDetail.do";
		var data = "csrID=${csrID}&isNew=${isNew}&srType=${srType}&mainMenu=${mainMenu}&s_itemID=${s_itemID}" 
			+ "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}"
			+ "&Creator=${Creator}&ParentID=${ParentID}&crMode=${crMode}&crID=" + crID
			+ "&currPageI=" + $("#currPageI").val()+"&screenType=${screenType}&refID=${refID}"
			+ "&crArea1="+crArea1
			+ "&crArea2="+crArea2
			+ "&requestUser="+requestUser
			+ "&crStatus="+crStatus
			+ "&DUE_DT="+DUE_DT
			+ "&completionDT="+completionDT
			+ "&receiptTeam="+receiptTeam
			+ "&receiptUser="+receiptUser
			+ "&subject="+subject;
			
		var target = "help_content";		
		if("${crMode}" == "CSR"){ target = "tabFrame";}
		ajaxPage(url, data, target);
	}
	
	// Excel DownLoad 용~ 
	function gridDownInit(){
		var d = setGridDownData(); 
		p_gridDownArea = fnNewInitGrid("gridDownArea", d);
		p_gridDownArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridDownArea.setIconPath("${root}${HTML_IMG_DIR}/");	
		// p_gridDownArea.attachEvent("onRowSelect", function(id,ind){gridOnRowSelect(id,ind);});
		p_gridDownArea.setPagingSkin("bricks");
	}
	function setGridDownData(){ 
	    var result = new Object();
		result.title = "${title}";
		result.key = "cr_SQL.getCrMstList";
		result.header = "${menu.LN00024},CR No.,${menu.LN00002},${menu.LN00027},${menu.LN00025},${menu.LN00274},${menu.LN00185},${menu.LN00004},${menu.LN00227},${menu.LN00033},${menu.LN00273},${menu.LN00093},${menu.LN00222},${menu.LN00221},${menu.LN00064}";
		result.cols = "CRCode|Subject|StatusNM|RegUserName|CRArea1NM|CRArea2NM|ReceiptName|ReceiptTeamName|SRCategory|SRSubCategory|RegDatOrg|ReqDueDateOrg|DueDateOrg|CompletionDTOrg";
		result.widths = "30,90,*,80,70,70,80,80,110,100,100,100,100,100,100";
		result.sorting = "int,str,str,str,str,str,str,str,str,str,str,str,str,str,str,";
		result.aligns = "center,left,left,center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&pageNum=" + $("#currPageI").val()
					+ "&crMode=" + crMode 
					+ "&screenType=" + screenType	;		
		
					if(crMode != "CSR"){
						result.data = result.data 
				    	+ "&itemID=" + itemID
						+ "&requestUserName=" + $("#requestUser").val()
						+ "&dueDate=" + $("#DUE_DT").val()  
						+ "&completionDT=" + $("#completionDT").val()
						+ "&subject=" + $("#subject").val()
						+ "&crStatus=" + $("#crStatus").val();
					}
					
					if(crMode != "ITM" && crMode != "CSR") {		
						result.data = result.data + "&crArea1=" + $("#crArea1").val()
						+ "&crArea2=" + $("#crArea2").val()
						+ "&receiptUserName=" + $("#receiptUser").val()
						+ "&receiptTeam=" + $("#receiptTeam").val();
					}
					
					if(crMode == "PG" || crMode == "PJT") {
						result.data = result.data + "&refID=${refID}";
					}else if (crMode == "CSR") {
						result.data = result.data + "&csrID=" + csrID;
					}else if (crMode == "myCr") {
				    	result.data = result.data + "&sessionUserId=${sessionScope.loginInfo.sessionUserId}";
					}else if (crMode == "myTeam") {
				 		result.data = result.data + "&sessionTeamId=${sessionScope.loginInfo.sessionTeamId}";
				 	}

		return result;
	}
	
	function doSearchList(){
		var d = setGridData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data);
	}
	
	function fnGetCRArea2(CRArea1ID){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&parentID="+CRArea1ID;
		fnSelect('crArea2', data, 'getSrArea2', '${crArea2}', 'Select');
	}
	
	//===============================================================================
	// BEGIN ::: EXCEL
	function doExcel() {		
		p_gridArea.toExcel("${root}excelGenerate");
	}

	function fnDownData() {			
		var d = setGridDownData();
		fnLoadDhtmlxGridJson(p_gridDownArea, d.key, d.cols, d.data,"","","TOT_CNTD","","fnDownExcel()");
	}
	function fnDownExcel() {		
		p_gridDownArea.toExcel("${root}excelGenerate");
	}
	
	// 검색 조건 초기화 
	function fnClearSearchCR(){;
		$("#crArea1").val("");
		$("#crArea2").val("");
		$("#requestUser").val("");
		$("#crStatus").val("");
		$("#DUE_DT").val("");
		$("#completionDT").val("");
		$("#receiptTeam").val("");
		$("#receiptUser").val("");
		$("#requestUser").val("");
		$("#subject").val("");		
		return;
	}
	
</script>

<form name="crListFrm" id="crListFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="currPageI" name="currPageI" value="${currPageI}" />
	<input type="hidden" id="NEW" name="NEW" value="">
	<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
	
<c:if test="${crMode != 'CSR' && crMode != 'ITM' }" >	
	<div class="floatL msg mgB10" style="width:98%" >
		<img src="${root}${HTML_IMG_DIR}/bullet_blue.png"  id="subTitle_baisic">&nbsp;&nbsp;${menu.LN00276}
	</div>
</c:if>
	<!-- BEGIN :: SEARCH -->
<c:if test="${crMode != 'CSR'}">	
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
		<colgroup>
		    <col width="10%">
		    <col width="23%">
		 	<col width="10%">
		    <col width="23%">
		 	<col width="10%">
		    <col width="24%">		 
	    </colgroup>
	
	 <c:if test="${crMode != 'ITM'}">	
	    <tr>
	   		<!-- 도메인 -->
		       	<th class="alignL viewtop pdL10">${menu.LN00274}</th>
		        <td class="viewtop alignL">     
			       	<select id="crArea1" Name="crArea1" OnChange="fnGetCRArea2(this.value);" style="width:80%;">
			       		<option value=''>Select</option>
			       	</select>
		       	</td>
	       	<!-- 시스템 -->
	        <th class="alignL viewtop pdL10">${menu.LN00185}</th>
		       <td class="viewtop alignL">      
		        <select id="crArea2" Name="crArea2" style="width:80%;">
		            <option value=''>Select</option>
		        </select>
		        </td>
		  <!-- 요청자 -->
	       	<th class="alignL viewtop pdL10">${menu.LN00025}</th>
	       <td class="viewtop last alignL"><input type="text" class="text" id="requestUser" name="requestUser" value="${requestUser}" style="ime-mode:active;width:80%;" /></td>
	    </tr>	
	   </c:if>	 
	    
	    <tr>
	      	<!-- Status -->
	        <th class="alignL pdL10">${menu.LN00027}</th>
		        <td>     
		        <select id="crStatus" Name="crStatus"  style="width:80%;">
		            <option value=''>Select</option>
		        </select>
		        </td>
	        <!-- 완료예정일 -->
	       	<th class="alignL pdL10">${menu.LN00221}</th>
		        <td >     
			       <font><input type="text" id="DUE_DT" name="DUE_DT" value="${DUE_DT}"	class="input_off datePicker stext" size="8"
						style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
					</font>
		       	</td>       	
	       	<!-- 완료일 -->
	        <th class="alignL pdL10">${menu.LN00064}</th>
		        <td class="alignL">     
		            <font><input type="text" id="completionDT" name="completionDT" value="${completionDT}"	class="input_off datePicker stext" size="8"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				</font>
		        </td>        
	     </tr>  
	 <tr>
	   	 <!-- 접수조직 -->
		   <th class="alignL pdL10">${menu.LN00227}</th>
		   <td>
		      <select id="receiptTeam" Name="receiptTeam" style="width:80%">
		           <option value=''>Select</option>
		       </select>
		   </td>		   
		    <!-- 담당자 -->
		    <th class="alignL  pdL10">${menu.LN00004}</th>
		      <td> <input type="text" class="text" id="receiptUser" name="receiptUser" value="${receiptUser}" style="ime-mode:active;width:80%;" />
		      </td>  
	       	<!-- 제목-->
	        <th class="alignL pdL10">${menu.LN00002}</th>     
		         <td ><input type="text" class="text" id="subject" name="subject" value="${subject}" style="ime-mode:active;width:80%;" />
	     </tr>      
	  </table>
	
	<div class="countList pdT5" >
        <li  class="count">Total  <span id="TOT_CNT"></span></li>
        <li class="floatR">
        	&nbsp;<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" style="cursor:pointer;"/>
           	<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;cursor:pointer;" onclick="fnClearSearchCR();" >
        	<span class="btn_pack small icon"><span class="down"></span><input value="Data" type="button" id="data" OnClick="fnDownData()"></span>
        	<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
        </li>
    </div>
 </c:if>
	<div id="gridDiv" class="mgB10 clear" >
		<div id="grdGridArea" style="width:100%"></div>
	</div> 
	<div style="width:100%;" class="paginate_regular">
		<div id="pagingArea" style="display:inline-block;"></div>
		<div id="recinfoArea" class="floatL pdL10"></div>
	</div>	
	<div id="gridDownDiv" style="width:100%;visibility:hidden;" > 
		<li class="count">Total <span id="TOT_CNTD"></span></li>		
		<div id="gridDownArea" style="width:100%;"></div>
	</div>
</form>
