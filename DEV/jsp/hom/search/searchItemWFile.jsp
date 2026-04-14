<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/autoCompText.jsp"%>
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/search.css">

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="${menu.LN00021}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00158" var="WM00158"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00159" var="WM00159"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00018" var="WM00018"/>

<!-- Script -->
<script type="text/javascript">
	var changeMgt = "${changeMgt}";
	var screenType = "${screenType}";
	var isMulti = "N";
	var searchValue = '${searchValue}';
	
	$(document).ready(function() {
		if(searchValue) {
			document.querySelector("#searchValue").value = searchValue;
			fnSearchItemWFile(searchValue);
		}
		
		document.querySelector("#searchValue").focus();
		$("input.datePicker").each(generateDatePicker);
		
		$("#searchValue").keyup(function() {
			if(event.keyCode == '13') {
				document.querySelector(".ui-autocomplete").style.display = "none";
				fnSearchItemWFile();
			}
		});
				
		$("#excel").click(function(){p_gridArea.toExcel("${root}excelGenerate");doExcel();});
				
		$("#itemTypeName").val("");		
			
		autoComplete("searchValue", "AT00001", "OJ00001", "", "", 10, "top");
		if(screenType == "main") {
			$("#searchValue").val('${searchValue}');
			fnSearchItemWFile();
		}
	});	

	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}

	// [Clear] click
	function clearSearchCon() {
		$("#OwnerTeam").val('');
		$("#Author").val('');
		$("#SC_STR_DT2").val('');
		$("#SC_END_DT2").val('');
		$("#Status option:eq(0)").prop("selected", true);
		$("#AT00001Value").val('');
		$("#AT00003Value").val('');
		$("#AttrCodeOLM_MULTI_VALUE").remove();
		$("#LastUpdated").val("N");
		
		return false;
	}
	
	function fnSearchItemWFileLoad(){
		var frontSearchValue = $("#frontSearchValue").val();
		$("#searchValue").val(frontSearchValue);
		$("#front_container").css("display", "none");
		$("#main_container").css("display", "block");
	}
	
	function fnClickDetail(){
		var detailYN = $("#detailYN").val();
		if(detailYN == "N"){
			$("#btnDetail").css("background", "#ededed");
			$("#detailYN").val("Y");
			$("#detailSearch").css("display", "block");
			$("#resultDiv").css({"display":"block","height":"calc(100% - 271px)"});
		}else{
			$("#btnDetail").css("background", "#ffffff");
			$("#detailYN").val("N");
			$("#detailSearch").css("display", "none");
			$("#resultDiv").css({"display":"block","height":"calc(100% - 130px)"});
		}
	}
	
	function fnSearchItemWFile(){ // 통합검색
		var searchValue = $("#searchValue").val();

		if(searchValue != ""){			
			$("#searchValueAT00001").val(searchValue);
		} else {
			return;
		}
		
		isMulti = "N";
		var itemTypeCd = $("#ItemTypeCode").val();
		var data = "collection=ALL&startIndex=0&listCount=500&rank=ITEM_TYPE_CD,ITEM_CD&searchField=ITEM_NM&LANGUAGE_ID=${sessionScope.loginInfo.sessionCurrLangType}&query="+encodeURIComponent(searchValue);
		if(itemTypeCd != "") {
			data = data + "&itemTypeCd="+itemTypeCd;
		}
		$.ajax({
			// url: "http://sfolm.iptime.org:8090/restapi/restSearchAPI",
			url : "getItemWFileList.do",
			type: 'get', 	
			data: data,
			error: function(xhr, status, error) { 
			},
			success: function(data){
				var itemList = new Array();
				var fileList = new Array();
				var valueList = "";
				var fValueList = "";
				
				var resdata = data;
				if (resdata.indexOf("while(1);") === 0) {
				  data = resdata.substring(9);  // "while(1);" 길이 제거
				}
				
				var jsonObj = JSON.parse(data);
				var itemIDs = "";
				var itemCnt = jsonObj[0].CollListCount;
				var fileCnt = jsonObj[1].CollListCount;
				for(var i=0; i < itemCnt; i++) {
					
					valueList = "";
					
					if(i==0) {
						valueList = jsonObj[0].Document[i].ITEM_ID;
					}
					else {
						valueList = "@OLM_ARRAY_START@" + jsonObj[0].Document[i].ITEM_ID;
					}
					
					valueList += "@OLM@" + jsonObj[0].Document[i].ITEM_CD;//1
					valueList += "@OLM@" + jsonObj[0].Document[i].ITEM_NM;//2
					valueList += "@OLM@" + jsonObj[0].Document[i].ITEM_PATH;//3
					valueList += "@OLM@" + jsonObj[0].Document[i].ITEM_TYPE_CD;//4
					valueList += "@OLM@" + jsonObj[0].Document[i].ITEM_STATUS_NM;//5
					valueList += "@OLM@" + jsonObj[0].Document[i].ITEM_ATTR_CODE;//6
					valueList += "@OLM@" + jsonObj[0].Document[i].ITEM_CONTENTS;//7
					valueList += "@OLM@" + jsonObj[0].Document[i].AUTHOR_NM;//8
					valueList += "@OLM@" + jsonObj[0].Document[i].TEAM_NM;//9
					valueList += "@OLM@" + jsonObj[0].Document[i].LAST_UPDATED + "@OLM_ARRAY_END@";//10
					itemList.push(valueList);
				}
				for(var i=0; i < fileCnt; i++) {

					if(i ==0) {
						itemIDs = jsonObj[1].Document[i].ITEM_ID;
						fValueList = jsonObj[1].Document[i].FILE_ID;
					}
					else {
						itemIDs = itemIDs + "," + jsonObj[1].Document[i].ITEM_ID;
						fValueList = "@OLM_FILE_ARRAY_START@" + jsonObj[1].Document[i].FILE_ID;
					}
					
					fValueList += "@OLM@" + jsonObj[1].Document[i].FILE_REAL_NM;
					fValueList += "@OLM@" + jsonObj[1].Document[i].ITEM_ID + "@OLM_FILE_ARRAY_END@";
					fileList.push(fValueList);
				}
				$("#fileArrayList").val(fileList);
				$("#itemArrayList").val(itemList);	
				$("#itemIDs").val(itemIDs);
				$("#searchQuery").val(searchValue);
				fnLoadSearchResultDiv();		
			}
		});	          
	}
	
	function fnLoadSearchResultDiv() {
		$('#fileDownLoading').addClass('file_down_on');
		$('#fileDownLoading').removeClass('file_down_off');
		
		var detailYN = $("#detailYN").val();
		if(detailYN == "Y"){
			$("#resultDiv").css({"display":"block","height":"calc(100% - 271px)"})
		}else{
			$("#resultDiv").css({"display":"block","height":"calc(100% - 130px)"})
		}
		var url = "searchItemWFileList.do";	
						
		var src = url;		
		$("#resultFrm").attr("target", "contentFrame");
        $("#resultFrm").attr("action", src);
        $("#resultFrm").submit(function(){
	       	$("#contentFrame").load(function() {
		   		$('#fileDownLoading').addClass('file_down_off');
		   		$('#fileDownLoading').removeClass('file_down_on');
		   		
		   		//if(isMulti == "Y") {
		   			//$("#resultCount").attr("style","display:none;");
		   		//}
	      	});
        }).submit();
	}
	
	function fnDefArcPage(arcCode,menuStyle,pageUrl,varFilter,itemID){
		parent.clickMainMenu(arcCode,'','','',menuStyle,'',pageUrl+'.do?'+varFilter+'&loadType=${loadType}');
	}
	
	function fnClickItemType(ItemTypeCode, ItemTypeName){
		$(".hlepsub a").removeClass("on");
		$("."+ItemTypeCode+" a").addClass("on");
		
		if(ItemTypeCode != "" && ItemTypeCode != "All"){
			$("#ItemTypeCode").val(ItemTypeCode);
			$("#ItemTypeName").val(ItemTypeName);
		}else{
			$("#ItemTypeCode").val("");
			$("#ItemTypeName").val("");
		}
		
		fnSearchItemWFile();
	}
	
	function fnDetailSearch(){ // 상세검색

		var itemTypeCd = $("#ItemTypeCode").val();
		isMulti = "Y";
		var data = "&collection=ALL&startIndex=0&listCount=500&rank=ITEM_TYPE_CD,ITEM_CD&itemTypeCd="+itemTypeCd;
		var searchValue = "";
		var at01 = $("#AT00001Value").val();
		var at03 = $("#AT00003Value").val();
		var ownerTeam = $("#OwnerTeam").val();
		var status = $("#Status").val();
		var statusNm = $("#Status option:checked").text();
		var author = $("#Author").val();
		var startDT = $("#SC_STR_DT2").val();
		var endDT = $("#SC_END_DT2").val();
		
		if(at01 != "") {
			data = data + "&itemNm="+encodeURIComponent(at01);
		}
		if(at03 != "") {
			data = data + "&itemContents="+encodeURIComponent(at03);
		}
		if(ownerTeam != "") {
			data = data + "&teamNm="+encodeURIComponent(ownerTeam);
			$("#OwnerTeamName").val(ownerTeam);
		}
		if(status != "") {
			data = data + "&itemStatusNm="+encodeURIComponent(statusNm);
			$("#StatusCode").val(status);
		}
		if(author != "") {
			data = data + "&authorNm="+encodeURIComponent(author);
			$("#AuthorName").val(author);
		}
		if(startDT != "") {
			$("#StartDT").val(startDT);
		}
		if(endDT != "") {
			$("#EndDT").val(endDT);
		}
		
		
		$.ajax({
			//url: "search_json.jsp",
			//url: "http://sfolm.iptime.org:8090/restapi/restSearchAPI",
			url : "getItemWFileList.do",
			type: 'get',
			data: data,
			error: function(xhr, status, error) { 
			},
			success: function(data){	
				var itemList = new Array();
				var valueList = "";
				
				var resdata = data;
				if (resdata.indexOf("while(1);") === 0) {
				  data = resdata.substring(9);  // "while(1);" 길이 제거
				}
				
				var jsonObj = JSON.parse(data);
				var itemIDs = "";
				var itemCnt = jsonObj[0].CollListCount;
				var fileCnt = jsonObj[1].CollListCount;
				for(var i=0; i < itemCnt; i++) {
					valueList = "";
					
					if(i==0) {
						valueList = jsonObj[0].Document[i].ITEM_ID;
					}
					else {
						valueList = "@OLM_ARRAY_START@" + jsonObj[0].Document[i].ITEM_ID;
					}

					valueList += "@OLM@" + jsonObj[0].Document[i].ITEM_CD;
					valueList += "@OLM@" + jsonObj[0].Document[i].ITEM_NM;
					valueList += "@OLM@" + jsonObj[0].Document[i].ITEM_PATH;
					valueList += "@OLM@" + jsonObj[0].Document[i].ITEM_TYPE_CD;
					valueList += "@OLM@" + jsonObj[0].Document[i].ITEM_STATUS_NM;
					valueList += "@OLM@" + jsonObj[0].Document[i].ITEM_ATTR_CODE;
					valueList += "@OLM@" + jsonObj[0].Document[i].ITEM_CONTENTS;
					valueList += "@OLM@" + jsonObj[0].Document[i].AUTHOR_NM;
					valueList += "@OLM@" + jsonObj[0].Document[i].TEAM_NM;
					valueList += "@OLM@" + jsonObj[0].Document[i].LAST_UPDATED + "@OLM_ARRAY_END@";
					itemList.push(valueList);
				}
				for(var i=0; i < fileCnt; i++) {

					if(i ==0) {
						itemIDs = jsonObj[1].Document[i].ITEM_ID;
					}
					else {
						itemIDs = itemIDs + "," +jsonObj[1].Document[i].ITEM_ID;
					}

				}
				$("#itemArrayList").val(itemList);	
				$("#itemIDs").val(itemIDs);
				$("#searchQuery").val(searchValue);
				fnLoadSearchResultDiv();			
			}
		});	                   
				
	}
	
	function fnResult(count){
		var searchValue = $("#searchValue").val();
		var ItemTypeName = $("#ItemTypeName").val();
		if(ItemTypeName == ""){
			ItemTypeName = "";
		}
		
		if(count < 1 || count == "") {
			alert("${WM00018}");
			count = "0";
		}
		
		var resultHtml ="<span class=resultCount>";
		resultHtml += '<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00068" arguments="<span style=\"color:#4265ee;font-size:15px;font-weight:700\">\"'+ searchValue+'\"</span>,<span style=\"color:#4265ee;font-size:15px;font-weight:700\">'+count+'</span>" />';
		resultHtml +="</span>";
	
		$('#resultCount').html(resultHtml);
	
	}
	
	function fnCategoryFold(e) {
		var alt = $(e).attr("alt");
		if (alt == "fold") {
			$(e).attr("src","${root}cmm/common/images/unfold.png").attr("alt","unfold");
			$("#sch_sidebar").height("50px");
			$("#categoryFold").css("display","none");
		} else {
			$(e).attr("src","${root}cmm/common/images/fold.png").attr("alt","fold");
			$("#sch_sidebar").height("100%");
			$("#categoryFold").css("display","block");
		}
	}
	
</script>

</head>

<div id="fileDownLoading" class="file_down_off">
	<img src="${root}${HTML_IMG_DIR}/img_circle.gif"/>
</div>

    	<form id="resultFrm" name="resultFrm" method="POST">
    		<input type="hidden" id="itemIDs" name="itemIDs" >
	    	<input type="hidden" id="itemArrayList" name="itemArrayList">
	    	<input type="hidden" id="fileArrayList" name="fileArrayList">
	    
	    	<input type="hidden" id="searchKey" name="searchKey" value="Name">
	    	<input type="hidden" id="searchQuery" name="searchQuery">
			<input type="hidden" id="defaultLang" name="defaultLang" value="${defaultLang}">
			<input type="hidden" id="isComLang" name="isComLang" value="">
			<input type="hidden" id="isSpecial" name="isSpecial" value="">
			<input type="hidden" id="attrIndex" value="0">
			<input type="hidden" id="beforeCode" value="">
			
			<input type="hidden" id="CategoryCode" name="CategoryCode" value="OJ" >
			<input type="hidden" id="ItemTypeCode" name="ItemTypeCode" >
			<input type="hidden" id="ItemTypeName" name="ItemTypeName" >
			<input type="hidden" id="StartDate" name="StartDate" >
			<input type="hidden" id="EndDate" name="EndDate" >
			<input type="hidden" id="AuthorName" name="AuthorName" >
			<input type="hidden" id="OwnerTeamName" name="OwnerTeamName" >
			<input type="hidden" id="StatusCode" name="StatusCode" >
			<input type="hidden" id="changeMgt" name="changeMgt" >
			<input type="hidden" id="LastUpdated" name="LastUpdated" >
		</form>
	<div class="pdL10 pdR10" style="height: 100%; ">
	<div id="main_container">
		<div id="sch_title">
			<ul>
				<li>
					<input type="text" id="searchValue" name="searchValue">
					<input type="submit" class="button" value="Search" style="display:inline-block;" onClick="fnSearchItemWFile();">
					<input id="btnDetail" type="submit" class="btnDetail" value="Advanced" style="display:inline-block;" onClick="fnClickDetail();">
					<input type="hidden" id="detailYN" value="N" >
				</li>
			</ul>
		</div>
    	<div id="detailSearch" style="display:none;">
        <table border="0" cellpadding="0" cellspacing="0" class="tbl_search mgB20"  id="search">
		<colgroup>
		    <col width="7%">
		    <col width="26%">
		    <col width="7%">
		    <col width="26%">
		    <col width="7%">
		    <col width="26%">
	    </colgroup>
	    
	    <tr>
		    <th class="alignL">${menu.LN00028}</th>
		    <td class="alignL">				
				<input type="text" id="AT00001Value" name="AT00001Value" class="text">
			</td>	
		    <th class="alignL">${menu.LN00003}</th>
		    <td class="alignL">				
				<input type="text" id="AT00003Value" name="AT00003Value" class="text">
			</td>
			<th class="alignL">${menu.LN00027}</th>
            <td class="alignL">
            	<select id="Status" name="Status" class="sel">
            	<option value="">Select</option>
            	<c:forEach var="i" items="${statusList}">
						<option value="${i.CODE}">${i.NAME}</option>
            	</c:forEach>
            	</select>
            </td>		
	    </tr>
	    <tr>
            <th class="alignL">${menu.LN00018}</th>
            <td class="alignL" ><input type="text" id="OwnerTeam" name="OwnerTeam" value="" class="text"></td>
            <th class="alignL">${menu.LN00004}</th>
            <td class="alignL" align="left"><input type="text" id="Author" name="Author" value="" class="text"></td>
            <th class="alignL">${menu.LN00070}</th>    
            <td class="alignL">
                <input type="text" id="SC_STR_DT2" name="SC_STR_DT2" value="" class="input_off datePicker text" size="8"
                style="width: 39%;" onchange="this.value = makeDateType(this.value);"  maxlength="10">
                
                ~
                <input type="text" id=SC_END_DT2  name="SC_END_DT2" value="" class="input_off datePicker text" size="8"
                        style="width: 39%;" onchange="this.value = makeDateType(this.value);"  maxlength="10">
                
            </td>
	    </tr>
	    <tr>
	    	<th colspan="6" class="pdT15">
				<input type="submit" class="btnDeatilSearch" value="Search" OnClick="fnDetailSearch();" style="display:inline-block;">
				&nbsp;<input type="buttom" class="btnClear" value="Clear" style="display:inline-block;" onclick="clearSearchCon();">&nbsp;
	    	</th>
	    </tr>
	</table>
    </div>
     <div id="resultDiv" name="resultDiv" style="display:none;">
    <div id="resultCount" class="resultCount"></div>	
    <div id="resultFrame" class="flex justify-between">
    	<aside class="sidebar">
		    <div class="sch_sidebar" style="height:100%;">
		    	<ul class="help_menu" style="height:100%;">
			  	<li class="helptitle2"> 
			  		<ul>
			  			<li style="border-bottom:1px solid #ededed;padding:9px 0 9px 16px;font-size:13px;color:#3f3c3c;margin:0;display:flex;justify-content: space-between;align-items: center;">
			  				<div>
			  					<img src="${root}${HTML_IMG_DIR}/icon_check.png" class="mgR10">${menu.LN00033}
			  				</div>
			  			</li>
			  		</ul>
			    	<ul style="height: calc(100% - 50px);">
				      <li class="hlepsub All"><a href="#" class="on" onclick="fnClickItemType('All','All');"><span style="margin-right: 18px; font-weight: normal;"></span>All</a></li>
				      <div style="height: calc(100% - 43px);overflow-y: auto;">
					      <c:forEach var="list" items="${itemTypeList}" varStatus="status">
					      	<li class="hlepsub ${list.CODE}"><a href="#" onclick="fnClickItemType('${list.CODE}','${list.NAME}');"><span style="margin-right: 18px; font-weight: normal;">&middot;</span>${list.NAME}</a></li>
					      </c:forEach>
				      </div>
				     </ul>
			    </li>
			    </ul>
		    </div>
	    </aside>

	    <div id="sch_content">
	        <iframe name="contentFrame" id="contentFrame" src="" style="width:100%;height:100%;" frameborder="0"></iframe> 	
	    </div>
    </div>
    </div>
   </div>

<script type="text/javascript">
	
	function lnbSet(param, lnbIndex, useImg, useAll){
					
		var target = $(param+"> li > a");
		var target2dpt = $(param+"> li > ul > li > a");
		
		if(useImg == "Y"){
			$(param+"> li:eq("+lnbIndex+") > a > img").attr("src", $(param+"> li:eq("+lnbIndex+") > a > img").attr("src").replace(".gif", "on.gif"));
		} else {
			$(param+"> li:eq("+lnbIndex+") > a").addClass("on");	
		}
		$(param+"> li:gt("+lnbIndex+") > ul").hide();
		
		/* 2depth menu decoration script */
		function lnb2dpt(obj){
			$(target2dpt).removeClass("on");
			$(obj).addClass("on");
		}
		
		/* show-hide all menu */
		function lnbAll(){
			if(useAll == "Y"){
				var option_target = $(".lnb_option a");
				var optIndex = 0;
				$(option_target).click(
					function(){
						var currIndex = $(option_target).index($(this));
						if(currIndex == 0){
							$(param+"> li > ul").show();
						} else {
							$(param+"> li > ul").hide();
						}
					}
				);
			} else {
				return;
			}
		}
		
		/* menu binding */
		target.bind("click", function(){
			lnbInit(this, param, target, useImg);
		}).bind("focus", function(){
			lnbInit(this, param, target, useImg);
		});
		
		target2dpt.bind("click", function(){
			lnb2dpt(this);
		});
		
		/* show-hide all menu starting */
		lnbAll();
	}
	function lnbInit(obj, param, target, flag){
		var currIndex = $(target).index($(obj));
		if(flag == "Y"){
			$(param+"> li:eq("+lnbIndex+") > a > img").attr("src", $(param+"> li:eq("+lnbIndex+") > a > img").attr("src").replace("on.gif", ".gif"));
			$(param+"> li:eq("+lnbIndex+") > ul").hide();
			$(param+"> li:eq("+currIndex+") > a > img").attr("src", $(param+"> li:eq("+currIndex+") > a > img").attr("src").replace(".gif", "on.gif"));
			$(param+"> li:eq("+currIndex+") > ul").show();
		} else {
			$(param+"> li:eq("+lnbIndex+") > a[class^=on]").removeClass();
			$(param+"> li:eq("+lnbIndex+") > ul").hide();
			$(param+"> li:eq("+currIndex+") > a").addClass("on");
			$(param+"> li:eq("+currIndex+") > ul").show();
		}
		lnbIndex = currIndex;
	}
	var lnbIndex = 0;
	lnbSet(".togglemn", lnbIndex, "N", "Y");
</script>


</html>