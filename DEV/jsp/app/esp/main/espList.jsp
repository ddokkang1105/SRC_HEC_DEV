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
	
	var alertMsg1, alertMsg2, alertMsg3, alertMsg4, alertMsg5 = "";
	
	var selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&esType=${esType}&myCSR=${myCSR}&myWorkspace=${myWorkspace}&notCompanyIDs=${notCompanyIDs}";
	
	$(document).ready(function(){
		
		// 검색조건 없을 경우 초기 요청일 2주로 검색
		if(!"${regStartDate}" && !"${regEndDate}") {
			
			var period = "${period}";
			
			if(period === null || period === '' || period === undefined){
				if("${isCallCenter}" !== "Y") period = 14;
				else bDay = period = 180;
			}
			
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
		fnSelect('srReceiptTeam', selectData, 'getESMSRReceiptTeamID', '${srReceiptTeam}', 'Select', 'esm_SQL');
		
  		// sr Type
		fnSelect('srType', selectData, 'getSRTypeList', "${searchSrType}" , 'Select', 'esm_SQL');
  		// 우선 로그인 한 고객의 customerNo가 들어가기
  		fnSelect('customerNo', selectData, 'getESPCustomerList', '${customerNo}', 'Select', 'esm_SQL');
  		
  		// SFOLM에만  custGRNo
  		selectData += "&custLvl=G"
  		fnSelect('custGRNo', selectData, 'getESPCustomerListByLvl', '${custGRNo}', 'Select', 'esm_SQL');
  		
  		// sr Type change event
  		$("#srType").on("change", function(){
  			searchSrType = "";
  			//fnClearSearchSR('C');
  			srType = $("#srType").val();
//   			doSearchList('${srMode}');
  			fnGetSetting();
  			
  			if(srType != ''){
  				document.getElementById("inputSearchDetailBtn").classList.remove("disabled");
  			}else{
  				document.getElementById("inputSearchDetailBtn").classList.add("disabled");
  				$('#detailSearch').attr("style","display:none;");
  			}
  		});
  		
  		$("#inProgress").on("change", function(){
  			//$("#srStatus").val("");
  			//searchStatus = "";
  		});
  		
  		$("#srStatus").on("change", function(){
  			//$("#inProgress").val("ALL");
  			searchStatus = "";
  		});
  		
  		$("#activity").on("change", function(){
  			fnChangeActivity($(this).val());
  		});
  		
  		$('#AttrCode').SumoSelect();
  		
		$("input.datePicker").each(generateDatePicker);
		
		// 버튼제어
		$('#searchValue').keypress(function(onkey){
			if(onkey.keyCode == 13){
				doSearchList('${srMode}');
				return false;
			}
		});		
		$("#excel").click(function(){
			doSearchList(srMode, "Y");
			return false;
		});
		
		// 외부 Link 설정
		parent.top.$('#mainType').val("");
		if(srMode == "REG"){
			fnRegistSR();
		}else if("${srID}" != "" && parent.$("#scrnType").val() == "srRcv"){ // 외부에서 접수 페이지 바로가기 
			fnGoDetail();
			parent.$("#scrnType").val("");
		}else if("${mainType}"=="SRDtl" || "${mainType}" == "mySRDtl" || "${mainType}" == "SRDtlView"){
			if("${srID}" != ""){ fnGoDetail();
			}else{ setTimeout(function() { /*doSearchList('');*/},500 );}
		}else{
			setTimeout(function() { /*doSearchList('');*/ },500 );
		}
		
		if("${itemID}" != null && "${itemID}" != ""){
			$("#actFrame").css("overflow-y","");
		}
		
		fnSRAreaLoad();

		$("#svcType").val("${svcType}");
		if("${isCallCenter}" !== "Y") doSearchList('${srMode}', '', 'Y');
		
		getDicData("BTN", "LN0001").then(data => fnSetButton("search-btn", "search", data.LABEL_NM));
		getDicData("BTN", "LN0002").then(data => fnSetButton("excel", "",data.LABEL_NM,"secondary"));
		getDicData("BTN", "LN0003").then(data => fnSetButton("clear", "clear", data.LABEL_NM,"secondary"));
		getDicData("BTN", "LN0004").then(data => fnSetButton("inputSearchDetailBtn", "search", data.LABEL_NM));
		getDicData("BTN", "LN0001").then(data => fnSetButton("viewSearch", "search", data.LABEL_NM));		

		getDicData("BTN", "LN0005").then(data => document.querySelector('label[for="popup"]').innerText = data.LABEL_NM);
		getDicData("BTN", "LN0006").then(data => document.querySelector('label[for="companyNameHideShow"]').innerText = data.LABEL_NM);
		
		getDicData("ERRTP", "ZLN0001").then(data => alertMsg1 = data.LABEL_NM);
		getDicData("ERRTP", "LN0001").then(data => alertMsg2 = "${menu.LN00093}"+data.LABEL_NM);
		getDicData("ERRTP", "LN0002").then(data => alertMsg3 = data.LABEL_NM);
		getDicData("ERRTP", "ZLN0002").then(data => alertMsg4 = data.LABEL_NM);
		getDicData("ERRTP", "LN0003").then(data => alertMsg5 = data.LABEL_NM);
		
		getDicData("GUIDELN", "ZLN0002").then(data => {
			document.querySelector("#requestUser").placeholder = data.LABEL_NM;
			document.querySelector("#actorName").placeholder = data.LABEL_NM;
			document.querySelector("#srAreaSearch").placeholder = data.LABEL_NM;
		})
		
		const showCompany = getCookie('showCompany');
	    const checkbox = document.getElementById('companyNameHideShow');

	    if (showCompany === 'true') checkbox.checked = true;
	    else checkbox.checked = false;
	});
	
	getArcName("${arcCode}", ".page-title");
	
	// datepicker 날짜 조정
	function convertTime(date) {
	  date = new Date(date);
	  let offset = date.getTimezoneOffset() * 60000;
	  let dateOffset = new Date(date.getTime() - offset);
	  return dateOffset.toISOString();
	}
	
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
  		
  		fnSelect('activity', selectData+"&itemClassCode=CL03004&srType=" + $("#srType").val(), 'getSRStatusList', '${searchStatus}', 'Select', 'esm_SQL');
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
		$('#detailSearch').attr("style","display:none;");
		$("#appendDiv").empty();
		
		$("#srType").val("");
		$("#customerNo").val("");
		$("#custGRNo").val("");
		$("#srStatus").children().remove();
		$("#srStatus").append("<option value=''>Select</option>");
		$("#inProgress").val("ALL");
		
		//$("#regStartDate").val("");
		//$("#regEndDate").val("");
		$("#stSRDueDate").val("");
		$("#endSRDueDate").val("");
		$("#stSRCompDT").val("");
		$("#endSRCompDT").val("");
		$("#completionDelay").val("");
		
		$("#srCode").val("");
		$("#subject").val("");
		$("#activity").val("");
		$("#srAreaSearch").val("");
		$("#srArea1").val("");
		$("#srArea2").val("");
		
		$("#requestUser").val("");
		$("#requestUserID").val("");
		$("#actorName").val("");
		$("#actorID").val("");
		
		//fnResetSelectBox("activity","");
		//$('#activity')[0].sumo.reload();

		$("#attrIndex").val("0");
		fnResetSelectBox("AttrCode[]","AT00001");
		// checkAttrCode("AT00001", '${menu.LN00028}',"NEW");
		$('#AttrCode')[0].sumo.reload();
		$("#AttrCode")[0].sumo.selectItem(0);

		$("#srType")[0].sumo.selectItem(0);
		
		return;
	}
	
	function fnResetSelectBox(objName,defaultValue)
	{
		$("select[name='"+ objName +"'] option").not("[value='"+defaultValue+"']").remove(); 
	}
	
	//===============================================================================
	
	function fnClickDetail(){
		if($("#srType").val() == '') return;
		var detailSearchElement = document.getElementById('detailSearch');
		var displayStyle = window.getComputedStyle(detailSearchElement).display;

		if(displayStyle == "none"){
			$("#btnDetail").css("background", "#ededed");
			$("#detailSearch").css("display", "block");
			$("#layout").attr("style","height:"+(setWindowHeight() - 460)+"px;");
			document.getElementById('pagination').style.marginTop = '46px';
		}else{
			$("#btnDetail").css("background", "#ffffff");
			$("#detailSearch").css("display", "none");
			$("#layout").attr("style","height:"+(setWindowHeight() - 320)+"px;");
			document.getElementById('pagination').style.marginTop = '90px';
		}
	}
	
	//==============================================================================
	// 속성 설정
	function checkAttrCode(value,text,isNew) {
		var ari = $("#attrIndex").val();
		var bf = $("#isSelect"+value).val();		
		
		if($("#option"+value).hasClass("selected") && isNew != "NEW") {	
			
			if(ari*1 > 0)
				$("#attrIndex").val(ari*1 - 1);
			
			$("."+value).remove();

			if(bf != "") {
				$("#asDiv"+bf).empty();
				$("#beforeCode").val(bf);
			}
			$("#AttrCode")[0].sumo.attrOptClick("option"+value);
		}
		else if(ari*1 < 4){
			changeAttrCode(value);
			checkAttrDiv(value,text,ari);
			$("#AttrCode")[0].sumo.attrOptClick("option"+value);
			$("#attrIndex").val(ari*1+1);
		}
		else {
			//문구 추가 필요
			alert(alertMsg1);
		}
	}
	
	function checkAttrDiv(divClassName,text,ari){
		var html = "";
		var bfAttr = $("#beforeCode").val();

		html += '<div class="'+divClassName+'" style="margin-top:10px; display: flex;">';

		html += "<div style=\"width: 120px; text-align: right; line-height: 30px; padding-left: 10px; margin-right:30px; float:left;\" ><b>"+text+"</b></div>";	
			
		html += "<select id=\"constraint"+divClassName+"\" name=\"constraint[]\" style=\"width:180px;border-radius: 8px;\" onChange=\"changeConstraint($(this).val(),'"+divClassName+"')\" >";
		html += "<option value=\"\">include(equal to)</option>";
		html += "<option value=\"1\">is specified</option>";
		html += "<option value=\"2\">is not specified</option>";
		html += "<option value=\"3\">not include(not equal to)</option>";
		html += "</select>&nbsp;";
		html += "<input type=\"text\" id=\"searchValue"+divClassName+"\" value=\"\" class=\"text\" style=\"width:160px;height:25px;margin-left:10px;\">";
		html += "<select id=\"AttrLov"+divClassName+"\" name=\"AttrLov[]\" style=\"display:none;width:30%;margin-left:30px;\" multiple=\"multiple\">";
		html += "<option value=\"\">Select</option>	";
		html += "</select><input type=\"hidden\" id=\"isLov"+divClassName+"\" value=\"\">";
		html += "<input type=\"hidden\" id=\"isSelect"+divClassName+"\" value=\""+bfAttr+"\">";
		html += '<div id="asDiv'+divClassName+'" style="height: 28px; margin-left: 30px; display: inline;"></div>';

		if(ari > 0) {		
			var html2 = "";
				html2 += '<select id="selectOption'+divClassName+'" name="selectOption'+divClassName+'" style="width:80px; " >';
				html2 += "<option value=\"AND\" selected=\"selected\">AND</option>";
				html2 += "<option value=\"OR\">OR</option>	";
				html2 += '</select>';
			$("#asDiv"+bfAttr).append(html2);
			$("#selectOption"+divClassName).SumoSelect({csvDispCount: 3});
		}
		
		html += "</div>";
		
		
		if($("div").hasClass(divClassName)) {
			$("."+divClassName).remove();
		}
		else {
			$("#appendDiv").append(html);
			$("#constraint"+divClassName).SumoSelect({csvDispCount: 3});
			$('#searchValue'+divClassName).keypress(function(onkey){
				if(onkey.keyCode == 13){doSearchList();return false;}
			});	
		}
		$("#beforeCode").val(divClassName);
	}
	
	// [속성 option] 설정
	// 항목계층 SelectBox 값 선택시  속성 SelectBox값 변경
	function fnChangeActivity(avg1){
		$("#attrIndex").val("0");
		$("#appendDiv").empty();
		$("#displayLabel").empty();
		var srType = $("#srType").val();
		var url    = "getSearchSelectOption.do"; 
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&sqlID=esm_SQL.getSRAttributeType&srType="+srType+"&speCode="+avg1; 
		var target = "AttrCode";           
		var defaultValue = "${AttrCode}";              // 초기에 세팅되고자 하는 값
		var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxMultiSelect(url, data, target, defaultValue, isAll);
		 setTimeout(appendOption,1000);
		
	}
	function appendClassOption(){

		$("#classCode")[0].sumo.reload();
	}
	
	function appendOption(){
		 var optionName = '${menu.LN00028}';
		// $("#AttrCode").prepend("<option value='AT00001'>"+optionName+"</option>");
		
		$('#AttrCode')[0].sumo.reload();
		//checkAttrCode("AT00001",optionName,"NEW");			

	/* 	if(screenType == "main") {
			$("#searchValueAT00001").val("${searchValue}");
			doSearchList();
			screenType = "";
		} */
	}
	
	// [LOV option] 설정
	// 화면에서 선택된 속성의 DataType이 Lov일때, Lov selectList를 화면에 표시
	function changeAttrCode(avg){
		var url = "getAttrLov.do";		
		var data = "attrCode="+avg;
		var target="blankFrame";
		ajaxPage(url, data, target);
	}
	
	function changeAttrCode2(attrCode, dataType, isComLang) {
		var languageID = "${sessionScope.loginInfo.sessionCurrLangType}";
		// isComLang == 1 이면, 속성 검색 의 언어 조건을 defaultLang으로 설정 해줌
		if (isComLang == '1') {
			languageID = "${defaultLang}";
			$("#isComLang").val("Y");
		} else {
			$("#isComLang").val("");
		}
		
		if (dataType == "LOV" || dataType == "MLOV") {
			$("#isLov"+attrCode).val("Y");
			$("#searchValue"+attrCode).attr('style', 'display:none;width: 30%; height: 25px; margin-left: 10px; ');	
			
			var url    = "getAttrLovSelectOption.do"; // 요청이 날라가는 주소
			var data   = "languageID="+languageID+"&attrCode="+attrCode; //파라미터들
			var target = "AttrLov"+attrCode;            // selectBox id
			var defaultValue = "";              // 초기에 세팅되고자 하는 값
			var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
			ajaxMultiSelect(url, data, target, defaultValue, isAll);
			setTimeout("setAttrLovMulti('"+attrCode+"')",500);
		} else {
			$("#isLov"+attrCode).val("");
			$("#searchValue"+attrCode).attr('style', 'width: 30%; height: 25px; margin-left: 10px; display: inline;');
			$("#AttrLov"+attrCode).attr('style', 'display:none;width:50%;margin-left:30px;');	
		}
	}
	
	// [속성 검색 제약] 설정
	function changeConstraint(avg, avg2) {
		if (avg == "" || avg == "3") {
			if ($("#isLov"+avg2).val() == "Y") {
				$("#searchValue"+avg2).attr('style', 'display:none;width: 30%; height: 25px; margin-left: 10px; ');
				$("#ssAttrLov"+avg2).attr('style', 'width:235px;margin-left:10px;');
			} else {
				$("#searchValue"+avg2).attr('style', 'width: 30%; height: 25px; margin-left: 10px; ');
				$("#ssAttrLov"+avg2).attr('style', 'display:none;');
			}
		} else {
			$("#searchValue"+avg2).val("");
			$("#searchValue"+avg2).attr('style', 'display:none;width: 30%; height: 25px; margin-left: 10px; ');
			$("#ssAttrLov"+avg2).attr('style', 'display:none;');
		}
	}

	function setAttrLovMulti(atrCode){
		 $('#AttrLov'+atrCode).SumoSelect();
		 $('#ssAttrLov'+atrCode).attr("style","width:235px;margin-left:10px;");
	}
	
	// [검색 조건] 특수 문자 처리
	function setSpecialChar(avg) {
		var result = avg;
		var strArray =  result.split("[");
		
		if (strArray.length > 1) {
			result = result.split("[").join("[[]");
		}
		
		strArray =  result.split("%");
		if (strArray.length > 1) {
			result = result.split("%").join("!%");
			$("#isSpecial").val("Y");
		}
		
		strArray =  result.split("_");
		if (strArray.length > 1) {
			result = result.split("_").join("!_");
			$("#isSpecial").val("Y");
		}
		
		strArray =  result.split("@");
		if (strArray.length > 1) {
			result = result.split("@").join("!@");
			$("#isSpecial").val("Y");
		}
		
		return result;
	}
	
	function fnCompanyHideShow(){
		if( document.all("companyNameHideShow").checked == true){			
			grid.showColumn("CompanyName");
			document.cookie = "showCompany=true";
		}else{
			grid.hideColumn("CompanyName");
			document.cookie = "showCompany=false"
		}
	}
	
	function createEclickWF(){ // ASIS eclick 진생중인 결재 일괄 생성 팝업		
		window.open('zDlm_createEclickWFInst.do','window','width=1600, height=800, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
</script>
</head>
<body>

<div id="srListDiv" class="pdL10 pdR10">
<form name="srFrm" id="srFrm" action="" method="post"  onsubmit="return false;">
	<input type="hidden" id="NEW" name="NEW" value="">
	<input type="hidden" id="totalPage" name="totalPage" value="${totalPage}">
	<input type="hidden" id="currPage" name="currPage" value="${pageNum}">
	<input type="hidden" id="srMode" name="srMode">
	<input type="hidden" id="attrIndex" value="0">
	<input type="hidden" id="beforeCode" value="">
	<div class="page-title"></div>
	
	
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="form-column-4 new-form" id="search">
	    <tr>
	    	<!-- 프로세스 -->
	       	<th class="alignL">${menu.LN00011}</th>
	        <td class="alignL">     
		       	<select id="srType" Name="srType" style="width: 100%;display: inline-block;">
		       		<option value=''></option>
		       	</select>
	       	</td>	       	
	       	<!-- 프로세스 -->
	       	<th class="alignL">${menu.ZLN0018}</th>
	        <td class="alignL">     
		       	<select id="customerNo" Name="customerNo" style="width: 100%;display: inline-block;">
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
				</select>
			</td> 
	    </tr>
		<tr>
			<!-- 요청일-->
			<th class="alignL">${menu.LN00093}</th>     
	        <td>     
				<input type="text" id="regStartDate" name="regStartDate" value="${regStartDate}"	class="input_off datePicker stext" size="8"
					onchange="this.value = makeDateType(this.value);"	maxlength="15" >
				-
				<input type="text" id="regEndDate" name="regEndDate" value="${regEndDate}"	class="input_off datePicker stext" size="8"
					onchange="this.value = makeDateType(this.value);"	maxlength="15">
	        </td>
	        <th class="alignL">${menu.ZLN0082}</th>
	        <td>
	        	<select id="svcType" Name="svcType" style="width:100%">
	        		<c:if test="${isCallCenter eq 'Y'}"><option value="">${menu.ZLN0057}</option></c:if>
					<option value="01">${menu.ZLN0083}</option>
					<option value="02">${menu.ZLN0084}</option>
				</select>
	        </td>
	         <th class="alignL">${menu.LN00025}</th>
	         <td>
	         	<input type="text" class="text" id="requestUser" name="requestUser" value="${requestUser}" style="width: calc(100% - 24px);" disabled autocomplete="off" />
	         	<img src="${root}${HTML_IMG_DIR}/btn_close.png" style="position: absolute; top: 10px; right: 34px; width: 17px; cursor: pointer;" onclick="fnClear('requestUser', 'requestUserID')"/>
	         	<img id="requestUserBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" style="cursor: pointer;"/>
	         	<input type="hidden" id="requestUserID" name="requestUserID" value="${requestUserID}" />
	         </td>
	         <th class="alignL">${menu.ZLN0085}</th>
	         <td>
	         		<input type="text" class="text" id="actorName" name="actorName" value="${actorName}" style="width: calc(100% - 24px);" disabled autocomplete="off" />
	         		<img src="${root}${HTML_IMG_DIR}/btn_close.png" style="position: absolute; top: 10px; right: 34px; width: 17px; cursor: pointer;" onclick="fnClear('actorName', 'actorID')"/>
		         	<img id="actorBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" style="cursor: pointer;"/>
		         	<input type="hidden" id="actorID" name="actorID" value="${actorID}" />
	         </td>
		</tr>
		<tr>
			<!-- SR code-->
	        <th class="alignL" >${menu.LN00396}</th>     
		    <td><input type="text" class="text" id="srCode" name="srCode" value="${srCode}" autocomplete="off"/></td>
			<!-- 제목-->
	        <th class="alignL" >${menu.LN00002}</th>     
		    <td><input type="text" class="text" id="subject" name="subject" value="${subject}" autocomplete="off"/></td>
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
		    <!-- 관계사 그룹 -->
		    <!--
		    <th class="alignL">${menu.ZLN0018} 그룹</th>
	        <td class="alignL">     
		       	<select id="custGRNo" Name="custGRNo" style="width: 100%;display: inline-block;">
		       		<option value=''></option>
		       	</select>
	       	</td> 
	       	-->
		</tr>
	</table>
	
	<div class="btn-wrap justify-center pdT10">
		<div class="btns">
			<button id="search-btn" onclick="doSearchList('${srMode}', '' , 'Y', 0);"></button>
			<button id="clear" onclick="fnClearSearchSR()"></button>
			<button id="inputSearchDetailBtn" class="disabled" onclick="fnClickDetail()"></button>
			<button id="excel"></button>
			
			<%-- <c:if test="${sessionScope.loginInfo.sessionMlvl eq 'SYS'}">
				<button id="wfList" onclick="createEclickWF()">AS-IS eclick 전자결재 생성 </button>
			</c:if> --%>
		</div>
    </div>
    
   	<!-- 상세검색 -->
    <div id="detailSearch" style="display:none;" class="pdT20">
        <table border="0" cellpadding="0" cellspacing="0" width="100%" class="form-column-4 new-form" id="search" style="table-layout:fixed;">
	        <tbody>
		    	<tr>
				    <th class="alignL">${menu.ZLN0060}</th>
				    <td class="alignL">				
						<select id="activity" name="activity">
			            	<option value="">${menu.ZLN0057}</option>
		            	</select>
					</td>
					<!-- 완료 예정일-->
					<th class="alignL">${menu.LN00221}</th>     
			        <td >     
				       <input type="text" id="stSRDueDate" name="stSRDueDate" value="${stSRDueDate}" class="input_off datePicker stext" size="8"
							onchange="this.value = makeDateType(this.value);"	maxlength="15" >
						-
						<input type="text" id="endSRDueDate" name="endSRDueDate" value="${endSRDueDate}"	class="input_off datePicker stext" size="8"
							onchange="this.value = makeDateType(this.value);"	maxlength="15">
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
					<!-- 지연여부-->
					<th class="alignL">${menu.ZLN0038}</th>
					<td>
						<select id="completionDelay" Name="completionDelay" style="width:100%">
							<option value=''>${menu.ZLN0057}</option>
							<option value='Y'>Y</option>
							<option value='N'>N</option>
						</select>
					</td>
			    </tr>
			    <tr>
		            <th class="alignL" style="width:20%;">${menu.ZLN0086}</th>
		            <td class="alignL">				
						<select id="AttrCode" Name="AttrCode[]" multiple="multiple"  ></select>
						<div id="appendDiv"></div>
					</td>		
			    </tr>
			    <tr style="grid-template-columns: auto;">
			    	<th class="btns">
			    		<button id="viewSearch" class="floatC" onclick="doSearchList('${srMode}', '' , 'Y', 0);"></button>
			    	</th>
			    </tr>
		    </tbody>
		</table>
    </div>
    
    <ul class="btn-wrap pdT20 pdB10" >
		<li class="count">Total  <span id="TOT_CNT"></span></li>
		<li class="btns">
			<div>
				<input type="checkbox" id="popup" value="" class="switch" checked/>
				<label for="popup" class="switch_label"></label>
			</div>
				<div>
				<input type="checkbox" id="companyNameHideShow" name="companyNameHideShow" value="" class="switch" onClick="fnCompanyHideShow()"/>
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

<form name="reportFrm" id="reportFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="original" name="original" value="">
	<input type="hidden" id="filename" name="filename" value="">
	<input type="hidden" id="scrnType" name="scrnType" value="excel">
</form>

<div  id="grdOTGridArea" style="display: none;"></div>
</body>
<script type="text/javascript">
let pageNo = 1;

//검색조건 유지
if("${searchSrType}") $("#srType").val("${searchSrType}");
if("${customerNo}") $("#customerNo").val("${customerNo}");
if("${customerNo}") $("#custGRNo").val("${custGRNo}");
if("${searchSrType}") fnSelect('srStatus', selectData+"&itemClassCode=CL03004&srType=${searchSrType}", 'getSRStatusList', '${searchStatus}', 'Select', 'esm_SQL');
if("${inProgress}") $("#inProgress").val("${inProgress}");

if("${regStartDate}") $("#regStartDate").val("${regStartDate}");
if("${regEndDate}") $("#regEndDate").val("${regEndDate}");
if("${stSRDueDate}") $("#stSRDueDate").val("${stSRDueDate}");
if("${endSRDueDate}") $("#endSRDueDate").val("${endSRDueDate}");
if("${stSRCompDT}") $("#stSRCompDT").val("${stSRCompDT}");
if("${endSRCompDT}") $("#endSRCompDT").val("${endSRCompDT}");
if("${completionDelay}") $("#completionDelay").val("${completionDelay}");

if("${searchSrCode}") $("#srCode").val("${searchSrCode}");
if("${subject}") $("#subject").val("${subject}");
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

var grid = new dhx.Grid("", {
    columns: [
        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
        { width:120, id: "SRTypeNM", header: [{ text: "${menu.LN00011}" , align: "center" }], align: "center" },
        { width: 120, id: "SRCode", header: [{ text: "${menu.LN00396}" , align: "center" }], align: "center" },
        { width: 270, id: "Subject", header: [{ text: "${menu.LN00002}" , align: "center" }], align: "left" },
        { width: 120, id: "SRArea1Name", header: [{ text: "${srAreaLabelNM1}" , align: "center" }], align: "center" },
        { width: 120, id: "SRArea2Name", header: [{ text: "${srAreaLabelNM2}" , align: "center" }], align: "center" },
        { width: 120,  id: "CategoryNM", header: [{ text: "${menu.LN00272}" , align: "center" }], align: "center" },
        { width: 120,  id: "SubCategoryNM", header: [{ text: "${menu.ZLN0034} ${menu.LN00272}" , align: "center" }], align: "center" },
        { width: 90, id: "RegDate", header: [{ text: "${menu.LN00078}" , align: "center" }], align: "center",template: function(value) { return value && typeof value === 'string' && value.includes(' ') ? value.split(' ')[0] : null; } },
        { width: 60, id: "RegUserName", header: [{ text: "${menu.LN00212}" , align: "center" }], align: "center" },
        // 상담원        
        { width: 120, id: "ReceiptInfo", header: [{ text: "${menu.ZLN0087}" , align: "center" }], align: "center" },
        { width: 120, id: "StatusName", header: [{ text: "${menu.ZLN0088}" , align: "center" }], align: "center" }, 
        { width: 180, id: "RequestInfo", header: [{ text: "${menu.LN00025} (${menu.LN00026})" , align: "center" }], align: "center" },
        { width: 100, id: "ReqDueDate", header: [{ text: "${menu.LN00222}" , align: "center" }], align: "center",template: function(value) { return value && typeof value === 'string' && value.includes(' ') ? value.split(' ')[0] : null; } },
        { width: 100, id: "SRDueDate", header: [{ text: "${menu.ZLN0089}" , align: "center" }], align: "center",template: function(value) { return value && typeof value === 'string' && value.includes(' ') ? value.split(' ')[0] : null; } },
        // 긴급여부 
         { width: 90, id: "CompletionStatus", header: [{ text: "${menu.ZLN0035}" , align: "center" }], align: "center", template: function (text, row, col) {
        	var result = "";
        	var comp = "";
        	comp = row.SRCompletionDT;
        	result = (comp !== undefined && comp !== null && comp.trim() !== '') ? "${menu.ZLN0036}" : "${menu.ZLN0037}";
        	
            return result;
        } },
        { width: 90, id: "delayDay", header: [{ text: "${menu.ZLN0090}" , align: "center" }], align: "center",  template: function (text, row, col) {
        		return (text > 0) ? text : "0";
	        }
	    },
        { width: 90, id: "APPINFRA", header: [{ text: "${menu.ZLN0082}" , align: "center" }], align: "center" },
        
        { hidden:true, width: 120, id: "ProcRoleTypeName", header: [{ text: "${menu.LN00109}" , align: "center" }], align: "center" },
        { hidden:true, width: 120, id: "ProcRoleTypeMemberList", header: [{ text: "${menu.ZLN0033}" , align: "center" }], align: "center" },
        { width: 90,  id: "CompanyName", header: [{ text: "${menu.LN00014}" , align: "center" }], align: "center" },
        { hidden:true, width: 90, id: "SRDueDate", header: [{ text: "${menu.LN00221}" , align: "center" }], align: "center",template: function(value) { return value && typeof value === 'string' && value.includes(' ') ? value.split(' ')[0] : null; } },
        { hidden:true, width: 120, id: "SRCompletionDT", header: [{ text: "${menu.LN00223}" , align: "center" }], align: "center",template: function(value) { return value && typeof value === 'string' && value.includes(' ') ? value.split(' ')[0] : null; } },
        { hidden:true, width: 90, id: "CompletionDelay", header: [{ text: "${menu.ZLN0038}" , align: "center" }], align: "center" },
    ],
    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
    sortable: false
});
layout.getCell("a").attach(grid);

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
    pageSize : 30
});

// 페이징 삭제
pagination.events.on("change", function(index, previousIndex) {
	pageNo = index + 1;
	doSearchList();
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
	data += "&customerNo="+$("#customerNo").val();
	data += "&custGRNo="+$("#custGRNo").val();
	data += "&searchStatus="+$("#srStatus").val();
	data += "&inProgress="+$("#inProgress").val();
	data += "&regStartDate="+$("#regStartDate").val();
	data += "&regEndDate="+$("#regEndDate").val();
	data += "&stSRDueDate="+$("#stSRDueDate").val();
	data += "&endSRDueDate="+$("#endSRDueDate").val();
	data += "&stSRCompDT="+$("#stSRCompDT").val();
	data += "&endSRCompDT="+$("#endSRCompDT").val();
	data += "&completionDelay="+$("#completionDelay").val();
	data += "&searchSrCode="+$("#srCode").val();
	data += "&subject="+encodeURIComponent($("#subject").val());
	data += "&srAreaSearch="+$("#srAreaSearch").val();
	data += "&srArea1="+$("#srArea1").val();
	data += "&srArea2="+$("#srArea2").val();
	data += "&svcType="+$("#svcType").val();
	data += "&requestUser="+$("#requestUser").val();
	data += "&requestUserID="+$("#requestUserID").val();
	data += "&actorName="+$("#actorName").val();
	data += "&actorID="+$("#actorID").val();
	data += "&returnMenuId=${arcCode}";
	
	isPopup ? window.open(url+"?"+data,"_blank","width=1400 height=800 resizable=yes") : ajaxPage(url, data, "srListDiv");
}

var param = "";
// 검색
async function doSearchList(srMode, excel, count, page){
	param = "";
	
	var REG_STR_DT = $("#regStartDate").val();
	var REG_END_DT = $("#regEndDate").val();
	
	if (!REG_STR_DT || !REG_END_DT) {
	    alert(alertMsg2);
	    return false;
	}
	
	if (!checkDateYear(REG_STR_DT, REG_END_DT,183,"6개월")){
		return false;
	}
	
	$('#loading').fadeIn(150);
	if(srMode == null && srMode == ""){
		srMode = "${srMode}";	
	}
	
	if(excel == "Y"){
		var sqlID = "esm_SQL.getESPSearchExcelList";
	} else {
		var sqlID = "esm_SQL.getESPSearchList";
	}
	
	
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
		param += "&isPublic=1"; // 임시저장 제외
		param += "&" + $("#srFrm").serialize();
		param += "&srType=" +srType
		+ "&regStartDate=" + REG_STR_DT
		+ "&regEndDate=" + REG_END_DT
		+ "&stSRDueDate=" + $("#stSRDueDate").val() 
		+ "&endSRDueDate=" + $("#endSRDueDate").val()
		+ "&stSRCompDT=" + $("#stSRCompDT").val() 
		+ "&endSRCompDT=" + $("#endSRCompDT").val()
		+ "&completionDelay=" + $("#completionDelay").val()
		+ "&inProgress=" + $("#inProgress").val()
		//+ "&subject=" + $("#subject").val()
		+ "&requestUserID=" + $("#requestUserID").val()
		+ "&myWorkspace=${myWorkspace}"
		+ "&myCSR=${myCSR}";
		
		if($("#completionDelay").val() == 'Y'){
			param = param += '&delayOption=01';
		}
		
		if(searchSrType != '' && searchSrType != null) param = param + "&srType=${searchSrType}";
		if($("#srType").val() != '' && $("#srType").val() != null) param = param + "&srType=" + $("#srType").val();
		
		//if(("${inProgress}" != '' && "${inProgress}" != null) || ($("#inProgress").val() != '' && $("#inProgress").val() != null)) param = param + "&srStatus="+$("#inProgress").val();
		if(("${inProgress}" != '' && "${inProgress}" != null) || ($("#inProgress").val() != '' && $("#inProgress").val() != null)) param = param + "&inProgress="+$("#inProgress").val();
		if(searchStatus != '' && searchStatus != null) param = param + "&srStatus=${searchStatus}";
		if($("#srStatus").val() != '' && $("#srStatus").val() != null) param = param + "&srStatus=" + $("#srStatus").val();
		
		if($("#customerNo").val() != "" && $("#customerNo").val() != null){
			param = param + "&clientID=" + $("#customerNo").val();
		}else if("${customerNo}" != '' && "${customerNo}" != null){
			param = param + "&clientID=${customerNo}";
		}
		
		if($("#custGRNo").val() != "" && $("#custGRNo").val() != null){
			param = param + "&custGRNo=" + $("#custGRNo").val();
		}
		
		// 상세검색 파람 setting 
		if($("#AttrCode").val() != '' & $("#AttrCode").val() != null){
			var attrArray = new Array();
			$("#AttrCode :selected").each(function(i, el){ 
				var valueArray = new Array();
				var aval = $(el).val();	
				var lovCode = "";
				var searchValue = "";
				var AttrCodeEscape = "";
				var constraint = "";
				var selectOption = "";
	
				if(i*1 > 0)
					selectOption = $("#selectOption"+aval).val();
				else if(i == 0)
					selectOption = "AND";
				
				/* [속성] 조건 선택, 입력값 */
				if ($("#constraint"+aval).val() == "" || $("#constraint"+aval).val() == "3") {
					if ($("#AttrLov"+aval).val() != "" || $("#searchValue"+aval).val() != "") {
						if ("Y" == $("#isLov"+aval).val()) {
							lovCode = $("#AttrLov"+aval).val() + "";
							lovCode = lovCode.replace(/,/gi,"*");
						} else {
							$("#isSpecial").val("");
							searchValue = setSpecialChar($("#searchValue"+aval).val().replace(",","comma"));
							AttrCodeEscape = $("#isSpecial").val();
						}
					}
					if($("#constraint"+aval).val() == "3")
						constraint = $("#constraint"+aval).val();
					
				} else {
					constraint = $("#constraint"+aval).val();
				}
				
				searchValue = encodeURIComponent(searchValue);
				valueArray.push($(el).val());
				valueArray.push(lovCode);
				valueArray.push(searchValue);
				valueArray.push(AttrCodeEscape);
				valueArray.push(constraint);
				valueArray.push(selectOption);
				attrArray.push(valueArray);
			});
			
			param = param + "&AttrCodeOLM_MULTI_VALUE=" + attrArray;
			
		}
	}
	
	// 페이지 기본값 있을경우 대체
	if(page !== null && page !== undefined && page!== '') {
		pageNo = page + 1;
	}
	param += "&pageNo="+pageNo+"&pageRow="+$("#pageRow").val();
	
	if(inProgress) {
		alert(alertMsg3);
	} else {
		if(count == "Y") {
			getCount(param, page);
		}
		else {
			jsonDhtmlxListV7(param, excel);
		}
	}
}

async function jsonDhtmlxListV7(param, excel) {
	inProgress = true;
	
	$.ajax({
		url:"zDlm_jsonDhtmlxListV7.do",
		type:"POST",
		data:param,
		success: function(result){
			fnReloadGrid(result, '', param, excel);
			if(excel !== "Y"){
				inProgress = false;
				$('#loading').fadeOut(150);
			}
		},error:function(xhr,status,error){
			$('#loading').fadeOut(150);
// 			alert('조회 시간이 오래 걸려서 요청을 중단하였습니다.\n시스템 담당자에게 연락 부탁 드립니다.');
	 	       getDicData("ERRTP", "ZLN0002").then(data => alert(data.LABEL_NM));
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
		alert(alertMsg4);
	})
	.finally(() => {
		inProgress = false;
	    $('#loading').fadeOut(150);  // 로딩 화면 숨기기
	});
}

function fnReloadGrid(newGridData, count, param, excel){
	let res = JSON.parse(newGridData);
	if(excel == "Y") {
		doExcel(param,newGridData);
	} else {
		res.forEach( e => {
			if(!grid.data.getItem(e.RNUM).RNUM)  grid.data.update(e.RNUM, e);
		})
	}
}
	
	//srArea setting
	let srAreaData = [];
	function fnSRAreaLoad() {
		fetch("/olmapi/srArea/?languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&myCSR=${myCSR}&srType=${esType}")
		.then((response) => response.json())
		.then(data => srAreaData = data);
	}
	
	const srAreaSearch = document.querySelector("#srAreaSearch");
	const autoComplete = document.querySelector(".autocomplete");
	
	let nowIndex = 0;
	let matchDataList, findIndex = [];
	srAreaSearch.addEventListener("keyup", function(event) {
	  // 검색어
		const value = srAreaSearch.value;
	
		switch (event.keyCode) {
		    // UP KEY
		    case 38:
		      	nowIndex = Math.max(nowIndex - 1, 0);
		      	break;
	
		    // DOWN KEY
		    case 40:
		    	nowIndex = Math.min(nowIndex + 1, matchDataList.length - 1);
		      	break;
	
		    // ENTER KEY
		    case 13:
		    	document.querySelector("#srAreaSearch").value = matchDataList[nowIndex].SRArea2Name || "";
				document.querySelector("#srArea1").value = matchDataList[nowIndex].SRArea1 || "";
				document.querySelector("#srArea2").value = matchDataList[nowIndex].SRArea2 || "";
	
				// 초기화
				nowIndex = 0;
				matchDataList.length = 0;
				break;
	      
	    	default:
	    		// 자동완성 필터링
		    	matchDataList, findIndex = [];
				if(value) {
					//if(document.querySelector("#company").value == "") matchDataList = srAreaData.filter(e => e.SRArea2Name.includes(value));
					//else matchDataList = srAreaData.filter(e => e.ClientID === document.querySelector("#company").value).filter(e => e.SRArea2Name.includes(value));
					 matchDataList = srAreaData.filter(e => e.SRArea2Name.match(new RegExp(value, "i")));
				} else {
					matchDataList = []
				}
				break;
		}
		
		// 리스트 보여주기
		showList(matchDataList, value, nowIndex);
	});
	
	const showList = (data, value, nowIndex) => {
		// 정규식으로 변환
		const regex = new RegExp(`(\\\(${value}\\))`, "g");
		data.length > 0 ? autoComplete.classList.add("on") : autoComplete.classList.remove("on");
		autoComplete.innerHTML = data.map((e, index) => `<div class='\${nowIndex === index ? "active" : ""}' data-index='\${e.RNUM}'><span>\${e.CompanyName}</span><span>\${e.SRArea1Name}</span><span>\${e.SRArea2Name.replace(regex, "<mark>$1</mark>")}</span></div>`).join("");
	};
	
	autoComplete.addEventListener("mouseover", function(e) {
		autoComplete.childNodes.forEach(child => child.classList.remove("active"))
	});
	
	// srArea 팝업 영역 외 클릭시 팝업 닫기
	document.addEventListener("click", function(e) {
		if(autoComplete.contains(e.target)) {
			document.querySelector("#srAreaSearch").value = srAreaData[e.target.parentNode.getAttribute("data-index") - 1].SRArea2Name;
			document.querySelector("#srArea1").value = srAreaData[e.target.parentNode.getAttribute("data-index") - 1].SRArea1;
			document.querySelector("#srArea2").value = srAreaData[e.target.parentNode.getAttribute("data-index") - 1].SRArea2;
		}
	    if(e.target.id !== "srAreaSearch" && autoComplete.classList.contains("on")) autoComplete.classList.remove("on");
	});
	
	let clickBtn = "";
	document.getElementById("requestUserBtn").addEventListener("click", function() {
		clickBtn = "requestUserBtn";
		searchPopupWf();
	});
	
	document.getElementById("actorBtn").addEventListener("click", function() {
		clickBtn = "actorBtn";
		searchPopupWf();
	});
	
	function searchPopupWf(){
		window.open("searchMemberPop.do?myClient=${myClient}&notCompanyIDs=22",'searchMemberPop','width=900, height=700');
	}
	
	function searchMemberCallback(avg1,avg2,avg3,avg4){
		if(clickBtn == "requestUserBtn") {
			$("#requestUser").val(avg2+"("+avg3+"/"+avg4+")");
			$("#requestUserID").val(avg1);
		}
		if(clickBtn == "actorBtn") {
			$("#actorName").val(avg2+"("+avg3+"/"+avg4+")");
			$("#actorID").val(avg1);
		}
	}
	
	document.getElementById("srAreaBtn").addEventListener("click", function() {
		searchSrArea();
	});
	
	function searchSrArea(){
		window.open('searchSrAreaPop.do?srType=${esType}&roleFilter=${roleFilter}&myCSR=${myCSR}&isCallCenter=${isCallCenter}','window','width=1000, height=500, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSrArea(clientID, srArea1, srArea2, srArea2Name){
		$("#srArea1").val(srArea1);
		$("#srArea2").val(srArea2);
		$("#srAreaSearch").val(srArea2Name);
	}
	
	function fnClear(e1, e2, e3) {
		if(e1) $("#"+e1).val("");
		if(e2) $("#"+e2).val("");
		if(e3) $("#"+e3).val("");
	}
	
	// excel grid
	var excelGrid = new dhx.Grid("grdOTGridArea", {
		columns: [
        { width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}" , align: "center" }], align: "center" },
        { width:120, id: "SRTypeNM", header: [{ text: "${menu.LN00011}" , align: "center" }], align: "center" },
        { width: 120, id: "SRCode", header: [{ text: "${menu.LN00396}" , align: "center" }], align: "center" },
        { width: 270, id: "Subject", header: [{ text: "${menu.LN00002}" , align: "center" }], align: "left" },
        { width: 120, id: "SRArea1Name", header: [{ text: "${srAreaLabelNM1}" , align: "center" }], align: "center" },
        { width: 120, id: "SRArea2Name", header: [{ text: "${srAreaLabelNM2}" , align: "center" }], align: "center" },
        { width: 120,  id: "CategoryNM", header: [{ text: "${menu.LN00272}" , align: "center" }], align: "center" },
        { width: 120,  id: "SubCategoryNM", header: [{ text: "${menu.ZLN0034} ${menu.LN00272}" , align: "center" }], align: "center" },
        { width: 90, id: "RegDate", header: [{ text: "${menu.LN00078}" , align: "center" }], align: "center" },
        { width: 60, id: "RegUserName", header: [{ text: "${menu.LN00212}" , align: "center" }], align: "center" },
        // 상담원        
        { width: 120, id: "ResponseInfo", header: [{ text: "${menu.ZLN0092}" , align: "center" }], align: "center" },
        { width: 120, id: "ReceiptInfo", header: [{ text: "${menu.ZLN0087}" , align: "center" }], align: "center" },
        { width: 120, id: "StatusName", header: [{ text: "${menu.ZLN0088}" , align: "center" }], align: "center" }, 
        { width: 180, id: "RequestInfo", header: [{ text: "${menu.LN00025} (${menu.LN00026})" , align: "center" }], align: "center" },
        { width: 100, id: "ReqDueDate", header: [{ text: "${menu.LN00222}" , align: "center" }], align: "center" },
        { width: 100, id: "SRDueDate", header: [{ text: "${menu.ZLN0089}" , align: "center" }], align: "center" },
        // 긴급여부 
        { width: 90, id: "SRAT0002", header: [{ text: "${menu.ZLN0017}" , align: "center" }], align: "center"},
        { width: 90, id: "CompletionStatus", header: [{ text: "${menu.ZLN0035}" , align: "center" }], align: "center"},
        { width: 90, id: "delayDay", header: [{ text: "${menu.ZLN0090}" , align: "center" }], align: "center"},
        { width: 90, id: "APPINFRA", header: [{ text: "${menu.ZLN0082}" , align: "center" }], align: "center" },
        
        { hidden:true, width: 120, id: "ProcRoleTypeName", header: [{ text: "${menu.LN00109}" , align: "center" }], align: "center" },
        { hidden:true, width: 120, id: "ProcRoleTypeMemberList", header: [{ text: "${menu.ZLN0033}" , align: "center" }], align: "center" },
        { hidden:true, width: 90,  id: "CompanyName", header: [{ text: "${menu.LN00014}" , align: "center" }], align: "center" },
        { hidden:true, width: 90, id: "SRDueDate", header: [{ text: "${menu.LN00221}" , align: "center" }], align: "center" },
        { hidden:true, width: 120, id: "SRCompletionDT", header: [{ text: "${menu.LN00223}" , align: "center" }], align: "center" },
        { hidden:true, width: 90, id: "CompletionDelay", header: [{ text: "${menu.ZLN0038}" , align: "center" }], align: "center" },
    ],
    autoWidth: true,
    resizable: true,
    selection: "row",
    tooltip: false,
	});
	
	function doFileDown(avg1, avg2) {
		var url = "fileDown.do";
		$('#original').val(avg1);
		$('#filename').val(avg1);
		
		ajaxSubmitNoAlert(document.reportFrm, url, "blankFrame");	
		$('#loading').fadeOut(150);
	}
	
	function removeEmojisAndSpecialChars(str) {
		return str.replace(/[^a-zA-Z0-9]/g, "");   
	}
	
	
	// 엑셀 다운로드
	function doExcel(param,newGridData){	
		
	    let type = "all";
		
		if($("#srType").val() !== '' && $("#srType").val() !== null && $("#srType").val() !== undefined){
			type = "process";
		} 
		
		if(type == "process"){
			
			$.ajax({
				url:"zdlm_list_exceldown_srType.do",
				type:"POST",
				data:param,
				success: function(result){
						
					const jsonStr = JSON.stringify(result);
					let rs = JSON.parse(jsonStr);
					
					const columns = Object.keys(rs.header).map(key => ({
					    id: key,
					    header: rs.header[key],
					    type: "string",
					    width: 100
					  }));
		
					  // DHTMLX Grid 초기화
					  const excelGrid_process = new dhx.Grid("grid_container_process", {
					    columns: columns,
					    autoWidth: true,
					    resizable: true
					  });
					  // 데이터 바인딩
					  excelGrid_process.data.parse(rs.data);
					  // excel 다운
					  //fnGridExcelDownLoad(excelGrid_process,'',fileName);
					  fnGridExcelDownLoadforITSM(excelGrid_process, type);
					  
				},error:function(xhr,status,error){
					$('#loading').fadeOut(150);
					alert(alertMsg4);
					console.log("ERR :["+xhr.status+"]"+error);
				}
			});
		} else {
			excelGrid.data.parse(newGridData);
			fnGridExcelDownLoadforITSM(excelGrid, type);
		}
	}
	
	function fnGridExcelDownLoadforITSM(downGrid, type){
		const now = new Date();
		const formattedDateTime = now.getFullYear() 
		                        + String(now.getMonth() + 1).padStart(2, '0') 
		                        + String(now.getDate()).padStart(2, '0') 
		                        + String(now.getHours()).padStart(2, '0') 
		                        + String(now.getMinutes()).padStart(2, '0');
		
		let fileName = "SearchProcessList_" + formattedDateTime;
	    let url = "excelFileDownload.do";
		
		var gridType = downGrid;
		var sheet1 = "1. ${menu.ZLN0093}";
		var disPlayHidden = "N";
		
		var excelDataRow = new Array();
		var headers = new Array();
		var ids = new Array();
		var aligns = new Array();
		var widths = new Array();
		var hiddens = new Array();
		var headers2 = new Array();
		var name ="";
		var headersCols = new Array();
		var headers2Cols = new Array();
	
		for(var i2=0; i2 < gridType.config.columns.length; i2++){
			if(!gridType.config.columns[i2].hidden){
				if(gridType.config.columns[i2].id != "checkbox"){
					headers.push(gridType.config.columns[i2].header[0].text);
										
					if(gridType.config.columns[i2].header[0].colspan != "" && gridType.config.columns[i2].header[0].colspan != undefined){
						headersCols.push(gridType.config.columns[i2].header[0].colspan);
					}else{
						headersCols.push("1");
					}
					if(gridType.config.columns[i2].header[1] != undefined){
						if (gridType.config.columns[i2].header[1].text != "" && gridType.config.columns[i2].header[1].text != undefined) {
		                    headers2.push(gridType.config.columns[i2].header[1].text);
		            	}else{
		            		headers2.push(" ");
		            	}
						if (gridType.config.columns[i2].header[1].colspan != "" && gridType.config.columns[i2].header[1].colspan != undefined) {
		                	headers2Cols.push(gridType.config.columns[i2].header[1].colspan);
		            	}else{
							headers2Cols.push("");		            		
		            	}
	            	}
	            	
					ids.push(gridType.config.columns[i2].id);
					if(gridType.config.columns[i2].align != "" && gridType.config.columns[i2].align != undefined){
						aligns.push(gridType.config.columns[i2].align);
					}else{
						aligns.push("center");
					}
					
					if(gridType.config.columns[i2].$width != ""){
						widths.push(gridType.config.columns[i2].$width);
					}
				}
			}
		}
			
		for(var i=0; i< gridType.data._order.length; i++) {
			excelDataRow.push(gridType.data._order[i]);			
		}
				
		var jsonData = JSON.stringify(excelDataRow);
		let formData = new FormData();
		formData.append('fileName', fileName);
		formData.append('gridExcelData', jsonData);
		formData.append('headers', headers);

		formData.append('headersCols', headersCols);
		formData.append('ids', ids);
		formData.append('aligns', aligns);
		formData.append('widths', widths);
		formData.append('sheet1', sheet1);
		
		if(type == "all"){
			var sheet2 = "2. ${menu.ZLN0094}";
			var sqlCodeSheet2 = "zDLM_SQL.getESPSearchExcelTotalList";
			var headersSheet2 = "{menu.ZLN0095}";
			var idsSheet2 ="Name,ACM,DCM,ICM,SCM,DPL,WRK1,WRK2,REQ1,REQ2";
			
			formData.append('sheet2', sheet2);
			formData.append('sqlCodeSheet2', sqlCodeSheet2);
			formData.append('headersSheet2', headersSheet2);
			formData.append('idsSheet2', idsSheet2);
		} else {
			fileName = "SearchProcessList_" + $("#srType").val() + "_" + formattedDateTime;
		}
		
		// param 추가
	    var params = param.slice(1).split('&'); 
		params.forEach(function(param) {
		    var pair = param.split('='); 
		    formData.append(decodeURIComponent(pair[0]), decodeURIComponent(pair[1] || ''));
		});
	    
		fetch(url, {
		    method: 'POST',
		    body: formData
		})
		.then(response => response.blob())
		.then(blob => {
			
		    const a = document.createElement('a');
		    const downloadUrl = window.URL.createObjectURL(blob); 
		    a.href = downloadUrl;
		    a.download = fileName + '.xlsx'; 
		    document.body.appendChild(a); 
		    a.click();
		    document.body.removeChild(a); 
		    window.URL.revokeObjectURL(downloadUrl); 
		    
		    $('#loading').fadeOut(150);
			inProgress = false;
		})
		.catch(error => {
			$('#loading').fadeOut(150);
			inProgress = false;
		    console.error('엑셀 다운로드 오류:', error);
		    alert(alertMsg5);
		});
	}
	
</script>