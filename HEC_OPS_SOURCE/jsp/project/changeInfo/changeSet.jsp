<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00026" var="WM00026" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00115" var="WM00115" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00129" var="WM00129" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00004" var="CM00004" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00025" var="CM00025" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00026" var="CM00026_1" arguments="${menu.LN00181}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00026" var="CM00026_2" arguments="${menu.LN00203}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00026" var="CM00026" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00049" var="CM00049" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00050" var="CM00050" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>


<script type="text/javascript" src="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.js?v=7.1.8"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.css?v=7.1.8">

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>

<style>

	.dhx_pagination .dhx_toolbar {
	    padding-top: 55px;
	    padding-bottom:1px !important;
	}
</style>

<script type="text/javascript">
	var p_gridArea; //그리드 전역변수(ChangeSet)
	var csrList = "${csrList}";
	var screenType = "${screenType}";
	var sessionState = "${sessionScope.loginInfo.sessionState}";
	var myTeam = "${myTeam}";

	$(document).ready(function() {
		$("input.datePicker").each(generateDatePicker); // calendar

		//fnSelect('Status','&Category=CNGSTS','dictionyCode','${chgsts}', 'Select');
		//fnSelect('ChangeType', '&Category=CNGT1', 'dictionyCode', 'Select');
		
		$("#Project").SumoSelect({parentWidth: 98});
		$("#csrList").SumoSelect({parentWidth: 98});
		$("#Status").SumoSelect({parentWidth: 98, defaultValues: "${status}"});
		$("#ChangeType").SumoSelect({defaultValues: "${changeType}", parentWidth: 98});
		
		$("#classCode").SumoSelect({defaultValues: "${classCodes}", parentWidth: 98});
		
		$("#dimTypeId").SumoSelect({parentWidth: 98});
		$('#dimValueId').SumoSelect({parentWidth: 98});
		var data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('Company',data+'&teamType=2','getTeam','','Select');
		
		$("#excel").click(function(){
			doExcel();
			return false;
		});
		
		$('#dimTypeId').change(function(){changeDimValue($(this).val());});
		if('${myPjtId}' != "") {
			//changeCsrList('${myPjtId}'); // 변경오더 option 셋팅
			$("#Project")[0].sumo.selectItem('${myPjtId}');
	
			if( sessionState != null && sessionState != "") {
				changeDimValue("100001");
				$("#dimTypeId")[0].sumo.selectItem("100001");
				setTimeout(function() { 
					$("#dimValueId")[0].sumo.selectItem(sessionState);
				},800 );
				
			}
		}
		
		setTimeout(function() { searchList(); },1000 );
		

	});	
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	/* ChangeSet List */
	function gridCngtInit(){
		var d = setGridCngtData();
		p_gridArea = fnNewInitGrid("grdGridArea", d);
		p_gridArea.setImagePath("${root}${HTML_IMG_DIR}/");
		p_gridArea.setIconPath("${root}${HTML_IMG_DIR_ITEM}/");
		
		fnSetColType(p_gridArea, 1, "img");	
		
	
		p_gridArea.setColumnHidden(14, true);
		p_gridArea.setColumnHidden(15, true);
		p_gridArea.setColumnHidden(16, true);
		p_gridArea.setColumnHidden(17, true);
		p_gridArea.setColumnHidden(18, true);
		p_gridArea.setColumnHidden(20, true);
		p_gridArea.attachEvent("onRowSelect", function(id,ind){ //id : ROWNUM, ind:Index
			gridOnRowSelect(id,ind);
		});
		p_gridArea.enablePaging(true,50,null,"pagingArea",true,"recInfoArea");
		p_gridArea.setPagingSkin("bricks");
		p_gridArea.attachEvent("onPageChanged", function(ind,fInd,lInd){
			$("#currPageA").val(ind);
		});
	}
	
	function setGridCngtData(){
		var result = new Object();
		
		result.title = "${title}";
		result.key = "cs_SQL.getChangeSetMultiList";
		result.header = "${menu.LN00024},${menu.LN00042},${menu.LN00016},${menu.LN00015},${menu.LN00028},Version,${menu.LN00004},${menu.LN00131},${menu.LN00191},${menu.LN00022},${menu.LN00027},${menu.LN00063},${menu.LN00064},${menu.LN00296},ChangeSetID,,,,,${menu.LN00070},";
		result.cols = "ItemTypeImg|ClassCode|Identifier|ItemName|Version|AuthorName|PjtName|csrName|ChangeType|StatusName|CreationTime|ApproveDate|ValidFrom|ChangeSetID|ItemID|StatusCode|AuthorID|CreationTime2|LastUpdated|ChangeTypeCode";
		result.widths = "30,50,100,100,*,70,100,100,100,100,80,80,80,80,0,0,0,0,0,80,0";
		result.sorting = "int,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str";
		result.aligns = "center,center,center,center,left,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center";
		result.data = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				//	+ "&refPGID=" + refPGID			
				//	+ "&refPjtID=${refPjtID}" 	
					+ "&screenType=" + screenType					
					+ "&pageNum=" + $("#currPageA").val()
					+ "&searchValue=" +$("#searchValue").val()
					+ "&authorName="+ $("#authorName").val();
				
					if(screenType == "PG" || screenType == "PJT") {
						result.data = result.data + "&refID=${refID}";
					}
			
		// 프로젝트
		if($("#Project").val() != '' & $("#Project").val() != null){
			result.data = result.data +"&projectID="+ $("#Project").val();
		}
		
		if($("#authorTeamName").val() != '' & $("#authorTeamName").val() != null){
			result.data = result.data +"&authorTeamName="+ $("#authorTeamName").val();
		}
		
		
		// 변경오더
		var csrArray = new Array();
		$("#csrList :selected").each(function(i, el){ 
			csrArray.push($(el).val());
		});
		
		if(csrArray != "" && csrArray != undefined)
			result.data = result.data+ "&csrListOLM_ARRAY_VALUE="+csrArray;
		
		if(myTeam != "" && myTeam != undefined)
			result.data = result.data+ "&myTeam=Y";
		
		// 계층
		var ccArray = new Array();
		$("#classCode :selected").each(function(i, el){ 
			ccArray.push($(el).val());
		});
		
		if(ccArray != "" && ccArray != undefined)
			result.data = result.data+ "&classCodeOLM_ARRAY_VALUE="+ccArray;
	
		
		// 변경구분
		if($("#ChangeType").val() != '' & $("#ChangeType").val() != null){
			result.data = result.data +"&changeClassList="+ $("#ChangeType").val();
		}
		
		if($("#Company").val() != '' & $("#Company").val() != null){
			result.data = result.data +"&Company="+ $("#Company").val();
		}
			
				
		
		// 등록일
		if($("#REQ_STR_DT").val() != '' & $("#REQ_STR_DT").val() != null){
			result.data = result.data + "&reqStartDt=" + $("#REQ_STR_DT").val().replace(/-/g, "");
	        result.data = result.data + "&reqEndDt=" + $("#REQ_END_DT").val().replace(/-/g, "");
		}
		// 완료일
		if($("#CLS_STR_DT").val() != '' & $("#CLS_STR_DT").val() != null){
			result.data = result.data + "&clsStartDt=" + $("#CLS_STR_DT").val().replace(/-/g, "");
	        result.data = result.data + "&clsEndDt=" + $("#CLS_END_DT").val().replace(/-/g, "");
		}
		
		// 승인일
		if($("#AP_STR_DT").val() != '' & $("#AP_STR_DT").val() != null){
			result.data = result.data + "&apStartDt=" + $("#ap_STR_DT").val().replace(/-/g, "");
	        result.data = result.data + "&apEndDt=" + $("#ap_END_DT").val().replace(/-/g, "");
		}
		
		// 시행일
		if($("#VF_STR_DT").val() != '' & $("#VF_STR_DT").val() != null){
			result.data = result.data + "&vfStartDt=" + $("#VF_STR_DT").val().replace(/-/g, "");
	        result.data = result.data + "&vfEndDt=" + $("#VF_END_DT").val().replace(/-/g, "");
		}

		// 시행일
		if($("#MOD_STR_DT").val() != '' & $("#MOD_STR_DT").val() != null){
			result.data = result.data + "&modStartDt=" + $("#MOD_STR_DT").val().replace(/-/g, "");
	        result.data = result.data + "&modEndDt=" + $("#MOD_END_DT").val().replace(/-/g, "");
		}
		// 상태
		if($("#Status").val() != '' & $("#Status").val() != null){
			result.data = result.data +"&Status=" + $("#Status").val();
		}
		// 버전
		if($("#version").val() != '' & $("#version").val() != null){
			result.data = result.data +"&version=" + $("#version").val();
		}
				
		/* [Dimension] 조건 선택값 */		
		if ($("#dimTypeId").val() != "") {
			
			var dvArray = new Array();
			var isNotYN = "N";
			$("#dimValueId :selected").each(function(i, el){ 
				var dvTemp = $(el).val();
				if (dvTemp != "" && "nothing" != dvTemp) {
					dvArray.push(dvTemp);
				} else {
					isNotYN = "Y";
					dvArray.push(dvTemp);
				}

			});

			result.data = result.data+ "&DimTypeID=" + $("#dimTypeId").val() + "&isNotIn="+isNotYN+"&DimValueIDOLM_ARRAY_VALUE="+dvArray;
		}
		
		return result;
	}
	
	// [dimValue option] 설정
	function changeDimValue(avg){
		var url    = "getDimValueSelectOption.do"; // 요청이 날라가는 주소
		var data   = "dimTypeId="+avg+"&searchYN=Y"; //파라미터들
		var target = "dimValueId";            // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxMultiSelect(url, data, target, defaultValue, isAll);
		setTimeout(appendDimOption,500);
	}	

	function appendDimOption(){
		$("#dimValueId")[0].sumo.reload();
	}
	
	function doSearchCngtList(){
		var d = setGridCngtData();
		fnLoadDhtmlxGridJson(p_gridArea, d.key, d.cols, d.data, false, "", "", "", "", "${WM00119}", 1000);
	}
	
	// 그리드ROW선택시
	function gridOnRowSelect(id, ind){
		var isAuthorUser = "N";
		
		/* 변경항목 상세 화면으로 이동 */
		if (ind == 1) {
			// 구분 칼럼 Click : Item popup 표시
			var changeType = p_gridArea.cells(id, 20).getValue();
			var itemId = p_gridArea.cells(id, 15).getValue();
			var changeSetID = p_gridArea.cells(id, 14).getValue();
			var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+itemId+"&scrnType=pop&screenMode=pop&option=AR000004&changeSetID="+changeSetID;
			var w = 1200;
			var h = 900;
			itmInfoPopup(url,w,h,itemId);
		} else {
			goInfoView(p_gridArea.cells(id, 14).getValue(), p_gridArea.cells(id, 16).getValue(), p_gridArea.cells(id, 15).getValue());
		}
	}
	
	// [Row Click] 이벤트
	function goInfoView(avg1, avg2, avg3){
							
		var url = "viewItemChangeInfo.do?changeSetID="+avg1+"&StatusCode="+avg2
					+ "&ProjectID=${ProjectID}&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&isNew=${isNew}&s_itemID=${s_itemID}"
					+ "&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}&currPageA=" + $("#currPageA").val()
					+ "&myPjtId=${myPjtId}&itemID="+avg3;
		var w = 1200;
		var h = 500; 
		itmInfoPopup(url,w,h);
	}
	
	// [변경오더 option] 설정
	function changeCsrList(avg){
		var url    = "getCsrListOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&projectID="+avg ; //파라미터들
		var target = "csrList";             // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "select";                        // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxMultiSelect(url, data, target, defaultValue, isAll);
		setTimeout(setCsrMultiList,1000);
	}
	
	function setCsrMultiList(){
		 
		 $('#csrList')[0].sumo.reload();

	}
	//===============================================================================
	// BEGIN ::: EXCEL
	/*
	function doExcel() {		
		p_gridArea.toExcel("${root}excelGenerate");
	}
	*/
	// END ::: EXCEL
	//===============================================================================
	
		
	function fnClearSearch(){
		$("#classCode")[0].sumo.selectItem(0);
	
		//$("#ChangeType")[0].sumo.selectItem(0);
		
		//$("#REQ_STR_DT").val("");
		//$("#REQ_END_DT").val("");
		$("#MOD_STR_DT").val("${modStartDT}");
		$("#MOD_END_DT").val("${modEndDT}");
		$("#VF_STR_DT").val("");
		$("#VF_END_DT").val("");
	
		//$("#CLS_STR_DT").val("");
		//$("#CLS_END_DT").val("");
		
		$("#version").val("");
		$("#classCode")[0].sumo.selectItem(0);
		
		$("#searchValue").val("");
		$("#authorName").val("");
		$("#authorTeamName").val("");
		$("#relatedTeamName").val("");
		$("#identifier").val("");
		//$("#dimTypeId")[0].sumo.selectItem(0);
		//fnResetSelectBox("dimValueId","");
		//$('#dimValueId')[0].sumo.reload();
		return;
	}

	function fnResetSelectBox(objName,defaultValue)
	{
		$("select[name='"+ objName +"'] option").not("[value='"+defaultValue+"']").remove(); 
	}
</script>

<form name="changeInfoLstAdmFrm" id="changeInfoLstAdmFrm" method="post" action="#" onsubmit="return false;">
<div class="pdL10 pdR10 pdT10">	
   	<input type="hidden" id="item" name="item" value=""></input>
	<input type="hidden" id="cngt" name="cngt" value=""></input> 
	<input type="hidden" id="pjtId" name="pjtId" value=""></input>
	<input type="hidden" id="pjtCreator" name="pjtCreator" value="${pjtCreator}"></input>
	<input type="hidden" id="currPageA" name="currPageA" value="${currPageA}"></input>
	
	<!-- 화면 타이틀 : 변경항목 목록-->
	<div class="floatL msg" style="width:100%"><img src="${root}${HTML_IMG_DIR}/bullet_blue.png"  id="subTitle_baisic">&nbsp;&nbsp;사내표준(전체)
	</div><div style="height:10px"></div>
	
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tbl_search" id="search">
			<colgroup>
		    <col width="6%">
			<col width="14%">
			<col width="6%">
			<col width="14%">
			<col width="6%">
			<col width="14%">
			<col width="6%">
			<col width="14%">	
			<col width="5%">
			<col width="15%">
	    </colgroup>
	    <tr>
	    	<!-- 계층 -->
	       	<th class="alignL">표준유형</th>
	       	<td class="alignL">
	       		<select id="classCode" Name="classCode" multiple="multiple" class="sel" style="width:92.8%;ime-mode:active;">
	       			<option value=''>Select</option>
		        	<c:forEach var="i" items="${classCodeList}">
		            	<option value="${i.CODE}">${i.NAME}</option>
		            </c:forEach>
	       		</select>
	       	</td>
	       	
	       	<!-- 문서번호 -->
	       	<th class="alignL">표준번호</th>
			<td class="alignL last" >	 
				<input type="text" class="stext" id="identifier" name="identifier" value="" style="width:92.8%;ime-mode:active;"/>  
			</td>
			
	   		<!-- 명칭 -->
	       	<th class="alignL">표준명</th>
	       	<td class="alignL">
	       		<input type="text" class="stext" id="searchValue" name="searchValue" value="" style="width:92.8%;ime-mode:active;"/>  
	       	</td>
	       	
	       	<!-- 개정번호 -->
	       	<th class="alignL">개정번호</th>
	       	<td class="alignL">
	       		<input type="text" class="stext" id="version" name="version" value="" style="width:92.8%;ime-mode:active;"/>  
	       	</td>
	       	
	       	<!-- 담당자 -->
	        <th class="alignL">표준 ${menu.LN00004}</th>
	        <td class="alignL">
	        	<input type="text" class="stext" id="authorName" name="authorName" value="" style="width:92.8%;ime-mode:active;" />  
	        </td>	
	         
	       	<!-- 변경구분 --><%-- 
	       	<th class="alignL">${menu.LN00022}</th>
			<td class="alignL">	 
				<select id="ChangeType" Name="ChangeType" class="sel" style="width:92.8%;ime-mode:active;">
		           	<option value="">Select</option>
		        	<c:forEach var="i" items="${changeTypeList}">
		            	<option value="${i.CODE}">${i.NAME}</option>
		            </c:forEach>
				</select>
			</td> --%>
	      </tr>
	      <tr> 
	      <!-- 담당조직 -->
	       	<th class="alignL">주관조직</th>
	       	<td class="alignL last">
	       		<input type="text" class="stext" id="authorTeamName" name="authorTeamName" value="" style="width:92.8%;ime-mode:active;" />  
	       	</td>
	       	
	       	<!-- 유관조직 -->
	        <th class="alignL">${menu.ZLN021}</th>
	       	<td class="alignL last">
	       		<input type="text" class="stext" id="relatedTeamName" name="relatedTeamName" value="" style="width:92.8%;ime-mode:active;" />  
	       	</td> 	       	
	       	 
	        <!-- 상태 -->
	        <th class="alignL">${menu.LN00022}</th>
	        <td class="alignL">	 
				<select id="ChangeType" Name="ChangeType" class="sel" style="width:92.8%;ime-mode:active;">
		           	<option value="">Select</option>
		        	<c:forEach var="i" items="${changeTypeList}">
		            	<option value="${i.CODE}">${i.NAME}</option>
		            </c:forEach>
				</select>
			</td> 
	        
	        <%-- <td class="alignL">     
		        <select id="Status" Name="Status" class="sel" style="width:92.8%;ime-mode:active;">
		           	<option value="">Select</option>
		        	<c:forEach var="i" items="${statusList}">
		            	<option value="${i.CODE}">${i.NAME}</option>
		            </c:forEach>
		        </select>
	        </td> --%>
	        
	      	<!-- 등록일 -->
	      	<%-- 
	        <th class="alignL">${menu.LN00063}</th>
	        <td class="alignL">     
	            <font><input type="text" id="REQ_STR_DT" name="REQ_STR_DT" value=""	class="input_off datePicker stext" size="8"
					style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				</font>
				~
				<font><input type="text" id="REQ_END_DT" name="REQ_END_DT" value=""	class="input_off datePicker stext" size="8"
					style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				</font>
	         </td> --%>
	         
	        <!-- 수정일 -->
	        <th class="alignL">${menu.LN00070}</th>
	        <td class="alignL">
	            <font><input type="text" id="MOD_STR_DT" name="MOD_STR_DT" value="${modStartDT}"	class="input_off datePicker stext" size="8"
					style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				</font>
				~
				<font><input type="text" id="MOD_END_DT" name="MOD_END_DT" value="${modEndDT}"	class="input_off datePicker stext" size="8"
					style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				</font>  
	        </td>		        
	         
	        <!-- 완료일 -->
	        <%-- 
	        <th class="alignL">${menu.LN00064}</th>
	        <td class="alignL">	        	
	            <font><input type="text" id="CLS_STR_DT" name="CLS_STR_DT" value=""	class="input_off datePicker stext" size="8"
					style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				</font>
				~
				<font><input type="text" id="CLS_END_DT" name="CLS_END_DT" value="" class="input_off datePicker stext" size="8"
					style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				</font>
	         </td>	 --%>
	         
	        <!-- 시행일 -->
	        <th class="alignL">최신 개정일</th>
	        <td class="alignL">     
		        <font><input type="text" id="VF_STR_DT" name="VF_STR_DT" value=""	class="input_off datePicker stext" size="8"
					style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10" >
				</font>
				~
				<font><input type="text" id="VF_END_DT" name="VF_END_DT" value="" class="input_off datePicker stext" size="8"
					style="width:calc((100% - 60px)/2);text-align: center;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
				</font>
	        </td>
	        
	        <!-- Dimension -->
	        <%-- 
	       	<th class="alignL">${menu.LN00088}</th>
	       	<td class="alignL">  
		        <div style="display: flex; gap: 10px;">
		            <!-- 첫 번째 select box -->
		            <select id="dimTypeId" name="dimTypeId" class="sel" style="width:120px;">
		                <option value=''>Select</option>
		                <c:forEach var="i" items="${dimTypeList}">
		                    <option value="${i.DimTypeID}">${i.DimTypeName}</option>
		                </c:forEach>
		            </select>
		            <!-- 두 번째 select box -->
		            <select id="dimValueId" name="dimValueId" multiple="multiple" class="sel" style="width:120px;">
		                <option value="">Select</option>
		            </select>
		        </div>
	       	</td> --%>
	      </tr>
	      <tr>
	       
	       	
	   		
	        
	       	<!-- 직무 -->
	       <!-- 	<th class="alignL">직무</th>
	       	<td class="alignL last">
	       		<input type="text" class="stext" id="roleName" name="roleName" value="" style="width:92.8%;ime-mode:active;" />  
	       	</td> -->
	      </tr>
    </table>
    
	<div class="mgT5" align="center">
		&nbsp;<input type="image" class="image searchList" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" onclick="searchList()" style="cursor:pointer;"/>
		<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="display:inline-block;" onclick="fnClearSearch();" >
	</div>
	
    <div class="countList pdT10">
	    <li class="count">Total  <span id="TOT_CNT"></span></li>
	    <li class="floatR">
			<span class="btn_pack small icon"><span class="down"></span><input value="Down" type="submit" id="excel"></span>
		</li>
 	</div>
	
	<div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>
</div>
</form>

<!-- START :: FRAME --> 		
<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display:none" frameborder="0" ></iframe>

<script>
		let pagination;
		
		document.querySelector("#layout").style.height = setWindowHeight() - 340+"px";
		window.onresize = function() {
			document.querySelector("#layout").style.height = setWindowHeight() - 340+"px"
		};
	
		const layout = new dhx.Layout("layout", {
			    rows: [
			        {
			            id: "a",
			        },
			    ]
			});
		
		let gridConfig = [
		        
		        { width: 50, id: "RNUM", header: [{ text: "No", align:"center"}], align:"center"},
		        { width: 40, id: "ItemTypeImg", header: [{ text: "${menu.LN00042}", align:"center" }], htmlEnable: true, align: "center" ,hidden: true,
		        	template: function (text, row, col) {
		        		return '<img src="${root}${HTML_IMG_DIR}/item/'+row.ItemTypeImg+'" width="21" height="21">';
		            }
		        },
		        { width: 130, id: "ClassCode",    	header: [{ text: "표준유형" , align: "center" }], align: "center" },  
		        { width: 150, id: "Identifier", 	header: [{ text: "표준번호" , align: "center" }], align: "center" },  
		        { width: 500, id: "ItemName",   	header: [{ text: "${menu.ZLN018}" , align: "center" }], align: "left" },  
		        { width: 70, id: "Version",    	header: [{ text: "${menu.LN00356}" ,         align: "center" }], align: "center" },  
		        { width: 80, id: "AuthorName", 	header: [{ text: "표준 ${menu.LN00004}" , align: "center" }], align: "center" },  
		        { width: 130, id: "AuthorTeamName", 	header: [{ text: "${menu.ZLN019}" , align: "center" }], align: "center" },  
		        { width: 250, id: "RelatedTeamNameList", 	header: [{ text: "${menu.ZLN021}" , align: "center" }], align: "center" },  
		        { width: 130, id: "StatusName", 	header: [{ text: "${menu.LN00027}" , align: "center" }], align: "center" }, 
		        //{ width: 130, id: "RoleName", 	    header: [{ text: "직무" , align: "center" }], align: "center" }, 
		        
		        //{ width: 80, id: "CreationTime", 	header: [{ text: "${menu.LN00063}" , align: "center" }], align: "center" },  
		        //{ width: 80, id: "ApproveDate", 	header: [{ text: "${menu.LN00064}" , align: "center" }], align: "center" }, 
		        { width: 130, id: "LastUpdated", 	header: [{ text: "수정일" ,     align: "center" }], align: "center" },  
		        { width: 80, id: "ValidFrom", 		header: [{ text: "최신 개정일" , align: "center" }], align: "center" },  
		        
		        
		        { width: 130, id: "PjtName",    	header: [{ text: "${menu.LN00131}" , align: "center" }], align: "center" ,hidden: true },  
		        { width: 130, id: "csrName",    	header: [{ text: "${menu.LN00191}" , align: "center" }], align: "center" ,hidden: true },  
		        { width: 130, id: "ChangeType", 	header: [{ text: "${menu.LN00022}" , align: "center" }], align: "center" },  
		         
		       
		        { width: 130, id: "ChangeSetID", 	header: [{ text: "ChangeSetID" ,     align: "center" }], align: "center", hidden: true },  
		        { width: 130, id: "ItemID", 		header: [{ text: "ItemID" ,          align: "center" }], align: "center", hidden: true },  
		        { width: 130, id: "StatusCode", 	header: [{ text: "StatusCode" ,      align: "center" }], align: "center", hidden: true },  
		        { width: 130, id: "AuthorID", 		header: [{ text: "AuthorID" ,        align: "center" }], align: "center", hidden: true },  
		        { width: 130, id: "CreationTime2", 	header: [{ text: "CreationTime2" ,   align: "center" }], align: "center", hidden: true },  
		        { width: 130, id: "LastUpdated", 	header: [{ text: "LastUpdated" ,     align: "center" }], align: "center", hidden: true },  
		        { width: 130, id: "ChangeTypeCode", header: [{ text: "ChangeTypeCode" ,  align: "center" }], align: "center", hidden: true },  
		        
	        ];
	
		const grid = new dhx.Grid("", {
		    columns: gridConfig,
		    autoWidth: true,
		    resizable: true,
		    selection: "row",
		    tooltip: false,
		});
	
		layout.getCell("a").attach(grid);
		
		function searchList() {
			let paramData = "sqlID=cs_SQL.getChangeSetMultiList"
				    + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+ "&screenType=" + screenType			
					+ "&searchValue=" +$("#searchValue").val()
					+ "&authorName="+ $("#authorName").val();
				
					if(screenType == "PG" || screenType == "PJT") {
						paramData = paramData + "&refID=${refID}";
					}
			
			// 프로젝트
			if($("#Project").val() != '' & $("#Project").val() != null){
				paramData = paramData +"&projectID="+ $("#Project").val();
			}
			
			// 문서번호
			if($("#identifier").val() != '' & $("#identifier").val() != null){
				paramData = paramData +"&identifier="+ $("#identifier").val();
			}
			
			if($("#authorTeamName").val() != '' & $("#authorTeamName").val() != null){
				paramData = paramData +"&authorTeamName="+ $("#authorTeamName").val();
			}
			
			if($("#relatedTeamName").val() != '' & $("#relatedTeamName").val() != null){
				paramData = paramData +"&relatedTeamName="+ $("#relatedTeamName").val();
			}
			
			// 변경오더
			var csrArray = new Array();
			$("#csrList :selected").each(function(i, el){ 
				csrArray.push($(el).val());
			});
			
			if(csrArray != "" && csrArray != undefined)
				paramData = paramData+ "&csrListOLM_ARRAY_VALUE="+csrArray;
			
			if(myTeam != "" && myTeam != undefined)
				paramData = paramData+ "&myTeam=Y";
			
			// 계층
			var ccArray = new Array();
			$("#classCode :selected").each(function(i, el){ 
				ccArray.push($(el).val());
			});
			
			if(ccArray != "" && ccArray != undefined)
				paramData = paramData+ "&classCodeOLM_ARRAY_VALUE="+ccArray;
			
			// 변경구분
			if($("#ChangeType").val() != '' & $("#ChangeType").val() != null){
				paramData = paramData +"&changeClassList="+ $("#ChangeType").val();
			}
			
			if($("#Company").val() != '' & $("#Company").val() != null){
				paramData = paramData +"&Company="+ $("#Company").val();
			}
			
			// 등록일
			if($("#REQ_STR_DT").val() != '' & $("#REQ_STR_DT").val() != null){
				paramData = paramData + "&reqStartDt=" + $("#REQ_STR_DT").val().replace(/-/g, "");
				paramData = paramData + "&reqEndDt=" + $("#REQ_END_DT").val().replace(/-/g, "");
			}
			// 완료일
			if($("#CLS_STR_DT").val() != '' & $("#CLS_STR_DT").val() != null){
				paramData = paramData + "&clsStartDt=" + $("#CLS_STR_DT").val().replace(/-/g, "");
				paramData = paramData + "&clsEndDt=" + $("#CLS_END_DT").val().replace(/-/g, "");
			}
			
			// 승인일
			if($("#AP_STR_DT").val() != '' & $("#AP_STR_DT").val() != null){
				paramData = paramData + "&apStartDt=" + $("#ap_STR_DT").val().replace(/-/g, "");
				paramData = paramData + "&apEndDt=" + $("#ap_END_DT").val().replace(/-/g, "");
			}
			
			// 시행일
			if($("#VF_STR_DT").val() != '' & $("#VF_STR_DT").val() != null){
				paramData = paramData + "&vfStartDt=" + $("#VF_STR_DT").val().replace(/-/g, "");
				paramData = paramData + "&vfEndDt=" + $("#VF_END_DT").val().replace(/-/g, "");
			}
	
			// 시행일
			if($("#MOD_STR_DT").val() != '' & $("#MOD_STR_DT").val() != null){
				paramData = paramData + "&modStartDt=" + $("#MOD_STR_DT").val().replace(/-/g, "");
				paramData = paramData + "&modEndDt=" + $("#MOD_END_DT").val().replace(/-/g, "");
			}
			// 상태
			if($("#Status").val() != '' & $("#Status").val() != null){
				paramData = paramData +"&Status=" + $("#Status").val();
			}
			// 버전
			if($("#version").val() != '' & $("#version").val() != null){
				paramData = paramData +"&version=" + $("#version").val();
			}
					
			/* [Dimension] 조건 선택값 */	
			/*
			if ($("#dimTypeId").val() != "") {
				
				var dvArray = new Array();
				var isNotYN = "N";
				$("#dimValueId :selected").each(function(i, el){ 
					var dvTemp = $(el).val();
					if (dvTemp != "" && "nothing" != dvTemp) {
						dvArray.push(dvTemp);
					} else {
						isNotYN = "Y";
						dvArray.push(dvTemp);
					}
	
				});
	
				paramData = paramData+ "&DimTypeID=" + $("#dimTypeId").val() + "&isNotIn="+isNotYN+"&DimValueIDOLM_ARRAY_VALUE="+dvArray;
			}
	  		*/
	  		$('#loading').fadeIn(150);
  			let url = "jsonDhtmlxListV7.do?" + paramData;
  			
  			
  			fetch(url)
	  		.then(res => res.json())
	  		.then(data => {
	  			grid.data.parse(data);
	  			$("#TOT_CNT").html(grid.data.getLength());
	  			$('#loading').fadeOut(150);
	  		})
	  	}
		
		if(pagination){pagination.destructor();}
		pagination = new dhx.Pagination("pagination", {
		    data: grid.data,
		    pageSize: 30,
		});
		
		function doExcel() {	
			if(grid.data.getLength() == 0) {
				alert("조회 결과가 없습니다. 먼저 조회를 해주세요.");
				return;
			}
			
			
		
			const now = new Date();
			const formattedDateTime = now.getFullYear() 
			                        + String(now.getMonth() + 1).padStart(2, '0') 
			                        + String(now.getDate()).padStart(2, '0') 
			                        + String(now.getHours()).padStart(2, '0') 
			                        + String(now.getMinutes()).padStart(2, '0');
		
			var fileName = "changeSetList_" + formattedDateTime;
			
			fnGridExcelDownLoad(grid, "", fileName);
	    }
		
		grid.events.on("cellClick", function(row,column,e){
			if(column.id == "Version") {
				goInfoView(row.ChangeSetID, row.StatusCode, row.ItemID);
			} else {
				var url = "popupMasterItem.do?languageID=${sessionScope.loginInfo.sessionCurrLangType}&id="+row.ItemID
						+"&scrnType=pop&screenMode=pop&option=AR000004&changeSetID="+row.ChangeSetID;
				var w = 1200;
				var h = 900;
				itmInfoPopup(url,w,h,row.ItemID);
			}
		}); 
		
</script>