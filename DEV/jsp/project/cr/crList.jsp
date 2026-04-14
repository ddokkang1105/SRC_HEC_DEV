<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<c:url value="/" var="root"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script type="text/javascript">
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
		
		$("#excel").click(function(){ fnGridExcelDownLoad(); });	
		
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}";
		fnSelect('crArea1', data, 'getSrArea1', '${crArea1}', 'Select');
		fnSelect('crStatus', data+"&category=CRSTS", 'getDictionaryOrdStnm', '${crStatus}', 'Select');
		fnSelect('priority', data+"&category=PRT", 'getDictionaryOrdStnm', '', 'Select');
	    fnSelect('receiptTeam', data, 'getCRReceiptTeamID', '${receiptTeam}', 'Select');
		if("${crArea1}" != ""){ fnGetCRArea2("${crArea1}");}
		
		$("input.datePicker").each(generateDatePicker);

		$('.searchList').click(function(){
			doSearchList(); 			
			setTimeout(function() { doSearchDownList(); },100);
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
		setTimeout(function() { doSearchList();},700 );
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

	var layout = new dhx.Layout("grdGridArea", { 
			rows: [
				{
					id: "a",
				},
			]
		});
	
		var gridData = ${gridData};
		var grid = new dhx.Grid(null, {
			columns: [
				{ hidden: true, width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
				{ hidden: true, width: 30, id: "checkbox", header: [{ text: "" , align: "center"}], align: "center", type: "boolean", editable: true, sortable: false},
				{ hidden: true, width: 50, id: "CRID", header: [{ text: "CRID" , align: "center" }], align: "center" },
				{ width: 90, id: "CRCode", header: [{ text: "CR No.", align: "center" }], align: "left" },
				{ fillspace: true, id: "Subject", header: [{ text: "${menu.LN00002}", align: "center"  }], align: "left"},
				{ width: 80, id: "StatusNM", header: [{ text: "${menu.LN00027}", align: "center" }] , align: "center"},				
				{ width: 70, id: "RegUserName", header: [{ text: "${menu.LN00025}", align: "center" }], align: "center" },	
				{ width: 70, id: "CRArea1NM", header: [{ text: "${menu.LN00274}", align: "center" }], align: "center" },
				{ width: 80, id: "CRArea2NM", header: [{ text: "${menu.LN00185}", align: "center" }], align: "center" },
				{ width: 80, id: "ReceiptName", header: [{ text: "${menu.LN00004}", align: "center" }], align: "center" },
				{ width: 110, id: "ReceiptTeamName", header: [{ text: "${menu.LN00227}", align: "center" }], align: "center" },
				{ width: 80, id: "DueDate", header: [{ text: "${menu.LN00221}", align: "center" }], align: "center" },
				{ width: 80, id: "CompletionDT", header: [{ text: "${menu.LN00064}", align: "center" }], align: "center" },
				{ hidden: true, width: 100, id: "SRCategory", header: [{ text: "${menu.LN00033}", align: "center" }], align: "center" }, //Excel용 그리드 컬럼 시작
				{ hidden: true, width: 100, id: "SRSubCategory", header: [{ text: "${menu.LN00273}", align: "center" }], align: "center" },
				{ hidden: true, width: 100, id: "RegDatOrg", header: [{ text: "${menu.LN00093}", align: "center" }], align: "center" },
				{ hidden: true, width: 100, id: "ReqDueDateOrg", header: [{ text: "${menu.LN00222}", align: "center" }], align: "center" },
				{ hidden: true, width: 100, id: "DueDateOrg", header: [{ text: "${menu.LN00221}", align: "center" }], align: "center" },
				{ hidden: true, width: 100, id: "CompletionDTOrg", header: [{ text: "${menu.LN00064}", align: "center" }], align: "center" }
			],
			autoWidth: true,
			resizable: true,
			selection: "row",
			tooltip: false,
			data: gridData
		});
		layout.getCell("a").attach(grid);
		$("#TOT_CNT").html(grid.data.getLength());

		var pagination = new dhx.Pagination("pagination", {
			data: grid.data,
			pageSize: 50,
		});	

		//그리드ROW선택시
		grid.events.on("cellClick", function(row,column,e){
			if(column.id != "checkbox"){
				gridOnRowSelect(row);
			}
		}); 

		// 그리드ROW선택시 : 변경오더 조회 화면으로 이동
		function gridOnRowSelect(row){
			var crID = row.CRID;
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
			var data = "csrID=${csrID}&isNew=${isNew}&mainMenu=${mainMenu}&s_itemID=${s_itemID}" 
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

	// END ::: GRID
	//===============================================================================

	//그리드 조회
	function doSearchList(){
		var sqlID = "cr_SQL.getCrMstList";
		var param = "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}"
				  + "&crMode=" + crMode 
				  + "&screenType=" + screenType	
				  + "&sqlID="+sqlID;

			if(crMode != "CSR"){
				param +=
				  "&itemID=" + itemID
				+ "&requestUserName=" + $("#requestUser").val()
				+ "&dueDate=" + $("#DUE_DT").val()  
				+ "&completionDT=" + $("#completionDT").val()
				+ "&subject=" + $("#subject").val()
				+ "&crStatus=" + $("#crStatus").val();
			}
			
			if(crMode != "ITM" && crMode != "CSR") {		
				param +=
				 "&crArea1=" + $("#crArea1").val()
				+ "&crArea2=" + $("#crArea2").val()
				+ "&receiptUserName=" + $("#receiptUser").val()
				+ "&receiptTeam=" + $("#receiptTeam").val();
			}
			
			if(crMode == "PG" || crMode == "PJT") {
				param += "&refID=${refID}";
			}else if (crMode == "CSR") {
				param += "&csrID=" + csrID;
			}else if (crMode == "myCr") {
				param += "&sessionUserId=${sessionScope.loginInfo.sessionUserId}";
			}else if (crMode == "myTeam") {
				param += "&sessionTeamId=${sessionScope.loginInfo.sessionTeamId}";
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
 		fnMasterChk('');
 	}
	
	function fnGetCRArea2(CRArea1ID){
		var data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&parentID="+CRArea1ID;
		fnSelect('crArea2', data, 'getSrArea2', '${crArea2}', 'Select');
	}
	
	// BEGIN ::: EXCEL
	function fnDownData() {			
		doSearchList();
		fnDownExcel();
		return false;
	}
	function fnDownExcel() {		
		grid.showColumn('SRCategory');
		grid.showColumn('SRSubCategory');
		grid.showColumn('RegDatOrg');
		grid.showColumn('ReqDueDateOrg');
		grid.showColumn('DueDateOrg');
		grid.showColumn('CompletionDTOrg');
		grid.hideColumn('DueDate');
		grid.hideColumn('CompletionDT');

		fnGridExcelDownLoad(); 

		grid.hideColumn('SRCategory');
		grid.hideColumn('SRSubCategory');
		grid.hideColumn('RegDatOrg');
		grid.hideColumn('ReqDueDateOrg');
		grid.hideColumn('DueDateOrg');
		grid.hideColumn('CompletionDTOrg');
		grid.showColumn('DueDate');
		grid.showColumn('CompletionDT');
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
			       <input type="text" id="DUE_DT" name="DUE_DT" value="${DUE_DT}"	class="input_off datePicker stext" size="8"
						style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
					
		       	</td>       	
	       	<!-- 완료일 -->
	        <th class="alignL pdL10">${menu.LN00064}</th>
		        <td class="alignL">     
		            <input type="text" id="completionDT" name="completionDT" value="${completionDT}"	class="input_off datePicker stext" size="8"
					style="width: 70px;text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				
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
		<div id="pagination"></div>
	</div> 
</form>
