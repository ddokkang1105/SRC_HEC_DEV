﻿<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<c:url value="/" var="root"/>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/uiInc.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlx/dhtmlxToolbar/codebase/skins/dhtmlxtoolbar_dhx_skyblue.css'/>">
<link rel="stylesheet" type="text/css" href="<c:url value='/cmm/js/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn_bricks.css'/>">

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/xbolt/jquery.sumoselect.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/sumoselect.css"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="${menu.LN00021}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00158" var="WM00158"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00159" var="WM00159"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00132" var="WM00132"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00033" var="WM00033"/>

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00185" var="WM00185_4" arguments="4"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00186" var="WM00186"/>

<style>
  html, body {
        height: 100%;
        margin: 0;
        padding: 0;
        overflow: auto; /* 또는 overflow-y: scroll; */
    }
    
.DimensionTd .SumoSelect{
	float:left;
	margin-right:5px;
}


  .stext {
    width: 100%;
    height: 30px;
    }
    
	element.style {
	    width: 100%;
	    display: inline-block;
	}
 
 #ZAT09005,#ZAT09006,#ZAT09007{
 width:86%;
 }
 
#detailID,#authorName,#ownerTeamName,#ZAT09006{
width:96%;
}

#ZAT01020 ,#ZAT01051{
width:100%;
}
#ZAT01060{
width:90%;
}
 
.SumoSelect > .CaptionCont {
    border: 1px solid #c5c5c5;
    margin: 0;
    color: #484F59;
    vertical-align: middle;
    height: 30px;
    padding: 0 20px 0 10px;
    border-radius: 2px;
    line-height: 30px; /* 텍스트를 수직 중앙에 배치 */
       width: 100%; /* 가로 너비를 250px로 설정 */
}

.dhx_grid-header-cell--align_center.dhx_grid-header-cell--sortable .dhx_grid-header-cell-text_content{
	line-height:15px !important;
}

.dhx_grid_data{
	cursor:pointer;
}


span.btn_pack.small.icon.input #add {
background-color:#666;!important;
}


</style>

<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;				//그리드 전역변수
	var AT00040  = "";
	let ZAT01060Value = "";
	let ZAT01050Value="";
	$(document).ready(function() {
		//console.log("defDimValueID: "+"${defDimValueID}");
		if("${fixedDimValueID}" == "N") {
			// 해당 site 고정 & 나머지 site 멀티 셀렉트
			document.getElementById("${defDimValueID}").checked = true;
// 			document.getElementById("${defDimValueID}").setAttribute("disabled", "")
		} else {
			// disabel 처리
			document.getElementsByName("siteCode").forEach(e => e.setAttribute("disabled", ""))
			document.getElementById("${defDimValueID}").checked = true;
		}
		
	    let data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
	    <c:forEach var="i" items="${attrList}">
	  
		<c:if test="${i.AttrTypeCode eq 'ZAT01060'}">
			ZAT01060Value = "${i.LovCode}";	
			if(ZAT01060Value=="CP"){
						
						document.getElementById("ZAT09007th").style.display="table-cell";
						document.getElementById("ZAT09007td").style.display="block";
			 }
		</c:if>
		<c:if test="${i.AttrTypeCode eq 'ZAT01050'}">
			ZAT01050Value ="${i.LovCode}";	
		</c:if>	
		</c:forEach>
	/* 			if(ZAT01060Value === "FO") { // 양식(체크시트) 일 경우, default = N
					AT00040 = "02";
					fnSelect('AT00040', data+"&attrTypeCode=AT00040", 'getAttrTypeLov', '02', 'Select');
				} else if(ZAT01060Value === "TE") { // 기술표준서 일 경우
					fnSelect('AT00040', data+"&attrTypeCode=AT00040", 'getAttrTypeLov', '', 'Select');
				}else if(ZAT01060Value === "MS"){
					//fnSelect('AT00040', data+"&attrTypeCode=AT00040", 'getAttrTypeLov', '02', 'Select');
					$("#AT00040 option[value='']").remove();
					 $("#AT00040").append("<option value=\"02\">N</option>");
				}
				else {
					if(ZAT01050Value==="005"){ //모듈일경우
						AT00040 = "02";
						fnSelect('AT00040', data+"&attrTypeCode=AT00040", 'getAttrTypeLov', '02', 'Select');
					}else{
						AT00040 = "01";
						$("#AT00040 option[value='']").remove();
						$("#AT00040").append("<option value=\"01\">Y</option>");
					}
				
					
				} */
				
		
	    fnSelect('AT00040', data+"&attrTypeCode=AT00040", 'getAttrTypeLov', '', 'Select');
	    fnSelect('ZAT01040', data+"&attrTypeCode=ZAT01040", 'getAttrTypeLov', '', 'Select');
	    fnSelect('ZAT01060', data+"&attrTypeCode=ZAT01060", 'getAttrTypeLov', '', 'Select');
	    fnSelect('csStatus','&category=CNGSTS','getDictionaryOrdStnm','', 'Select');
	 	    
		<c:forEach var="i" items="${attrList}">
			<c:if test="${i.AttrTypeCode eq 'ZAT01020'}"><c:set var="ZAT01020" value="${i.PlainText}" /></c:if>
			<c:if test="${i.AttrTypeCode eq 'ZAT01050'}"><c:set var="ZAT01050" value="${i.PlainText}" /><c:set var="ZAT01050Value" value="${i.LovCode}" /></c:if>
		</c:forEach>
		<c:if test="${ZAT01020 == null || ZAT01020 == ''}">fnSelect('ZAT01020', data+"&attrTypeCode=ZAT01020", 'getAttrTypeLov', '', 'Select');</c:if>
		<c:choose>
			<c:when test="${ZAT01050 == null || ZAT01050 == ''}">
				fnSelect('ZAT01050', data+"&attrTypeCode=ZAT01050", 'getAttrTypeLov', '', 'Select');
			</c:when>
			<c:otherwise>
			fnZAT01050Change("${ZAT01050Value}");
			</c:otherwise>
		</c:choose>
	   
		$("input.datePicker").each(generateDatePicker);
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 381)+"%;");
		// 화면 크기 조정
		window.onresize = function() {
			if($("#frame_sh").hasClass("frame_show")) {
				$("#layout").attr("style","height:"+(setWindowHeight() - 381)+"%;");
			}
		};  
		$("#AttrCode").val("${defAttrTypeCode}");
		
		$("#excel").click(function(){
			fnGridExcelDownLoad();
		});
		  $('#btnSearch').click(function(){
			   $("#currPage").val("");
			   doSearchList();
			   return false;
		  });

		  $("#frame_sh").mouseover(function(){
		   var tmp = $(this).attr("src");
		   if($(this).hasClass("frame_show")) {
		    $(this).attr("src",tmp.replace("btn_frame_show","btn_frame_hide"));
		   }
		   else {
		    $(this).attr("src",tmp.replace("btn_frame_hide","btn_frame_show"));
		   }
		  });

		  $("#frame_sh").mouseout(function(){
		   var tmp = $(this).attr("src");
		   if($(this).hasClass("frame_show")) {
		    $(this).attr("src",tmp.replace("btn_frame_hide","btn_frame_show"));
		   }
		   else {
		    $(this).attr("src",tmp.replace("btn_frame_show","btn_frame_hide"));
		   }
		  });
		  
		   $('#AttrCode').SumoSelect();
		   
// 		  changeClassCode("CL16004", 'OJ00016');
		  
		  $('#constraint').change(function(){changeConstraint($(this).val(), "");});
		  
		  $('#searchValue').keypress(function(onkey){
		   if(onkey.keyCode == 13){
		    $("#searchValueAT00001").val($(this).val());
		    return false
		   ;}
		  });  
		  
		$("#loading").fadeIn(100);
		checkLoadingBar();
		showMultiSearchDiv();

		$('#ZAT01051').SumoSelect({parentWidth: 90});

	    doSearchList();
	});
	


	function checkLoadingBar() {
		if($("#TOT_CNT").html() != "") {
			$("#loading").fadeOut(100);
		}		
		else {
			$("#loading").fadeIn(100);
			setTimeout(function() { checkLoadingBar(); },500);
			
		}
	}	
	
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
			alert("${WM00185_4}");	// 최대 4개 선택 가능 합니다.
		}
	}
	
	function checkAttrDiv(divClassName,text,ari){
		var html = "";
		var bfAttr = $("#beforeCode").val();

		html += '<div class="'+divClassName+'" style="margin-top:10px;">';

		html += "<div style=\"text-align: right; line-height: 25px; float:left;\" ><b>"+text+"</b></div>";	
			
		html += "<select id=\"constraint"+divClassName+"\" name=\"constraint[]\" class=\"SlectBox\" style=\"width:150px;margin-left:20px;\" onChange=\"changeConstraint($(this).val(),'"+divClassName+"')\" >";
		// 포함(또는 같음)
		html += "<option value=\"\">${menu.ZLN0117}</option>";
		// 포함하지 않음(또는 다름)
		html += "<option value=\"3\">${menu.ZLN0118}</option>";
		html += "</select>&nbsp;";
		html += "<input type=\"text\" id=\"searchValue"+divClassName+"\" value=\"\" class=\"stext\" style=\"width:20%;height:23px;margin-left:10px;\">";
		html += "<select id=\"AttrLov"+divClassName+"\" name=\"AttrLov[]\" style=\"display:none;width:120px;margin-left:20px;\" multiple=\"multiple\">";
		html += "<option value=\"\">Select</option>	";
		html += "</select><input type=\"hidden\" id=\"isLov"+divClassName+"\" value=\"\">";
		html += "<input type=\"hidden\" id=\"isSelect"+divClassName+"\" value=\""+bfAttr+"\">";
		html += '<div id="asDiv'+divClassName+'" style="height: 25px; margin-left: 10px; display: inline;"></div>';

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
		}
		$("#beforeCode").val(divClassName);
	}
	
	function setWindowHeight(){var size = window.innerHeight;var height = 0;if( size == null || size == undefined){height = document.body.clientHeight;}else{height=window.innerHeight;}return height;}
	
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

	function setSubFrame(avg, avg2){
		$("#"+avg2).attr('style', 'display: none');
		$("#"+avg).removeAttr('style', 'display: none');
		
		if(avg == 'addNewItem'){
			setSubFrame('saveOrg','editOrg');
		}else if(avg == 'OrganizationInfo'){
			setSubFrame('editOrg','saveOrg');
		}
	}
	// [Report] Click
	function goReportList(avg) {

	 	var url = "objectReportList.do?s_itemID="+avg;
		var w = 1000;
		var h = 800;
		openPopup(url,w,h,avg);
	}

	function clickItemEvent(itemID, authorID, status, accRight){
		var accMode = "";
		var userID = "${sessionScope.loginInfo.sessionUserId}";
		var myItem=""
		  // AJAX 요청
        $.ajax({
            url: '/checkMyItem.do',  
            type: 'GET', 
            data: {
                itemID: itemID,  // 보내는 데이터
                userID: userID
            },
            dataType: 'json',  
            success: function(response) {
               
                if (response.memberID) {
                    
                    myItemUser=response.memberID;
                   
                    myItem = "Y";
               			
                } else {
            
                    myItem="N";
               }
    
        		
              	accMode = authorID == "${sessionScope.loginInfo.sessionUserId}"|| myItem=="Y" ? "DEV" : "OPS";
    			if(authorID == "${sessionScope.loginInfo.sessionUserId}"|| myItem=="Y") accMode = "DEV";
    			else {
    				if(status == "REL") accMode = "DEV";
    			/* 	else {
    					alert("접근 할 수 없습니다.");
    					return false;
    				} */
    			}
    			var url = "processItemInfo.do";
    			var data = "itemID="+itemID+"&s_itemID="+itemID+"&option=${option}&itemEditPage=${itemEditPage}&itemViewPage=${itemViewPage}&scrnMode=V"
    				+"&accMode="+accMode+"&showPreNextIcon=${showPreNextIcon}&currIdx=${currIdx}&openItemIDs=${openItemIDs}"
    				+"&url=/custom/sk/skon/item/tsd/viewTSDInfo"
    				+"&scrnOption=Y"
    				+"&itemOption=Y"
    				+"&defDimValueID=${defDimValueID}&nodeID="
    				+"&selectedTreeID=${s_itemID}&fixedDimValueID=${fixedDimValueID}&accRight="+accRight;
    			
    			var w = 1200;
    			var h = 900;
//    	 		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
    			document.getElementById("processList").classList = "";
    			ajaxPage(url, data, "processList");
                
            },
            error: function(xhr, status, error) {
                // 오류 처리
                alert("${WM00186}");	// 오류가 발생했습니다. 다시 시도해주세요.
            }
        });
		
	}
	
	// [속성 option] 설정
	// 항목계층 SelectBox 값 선택시  속성 SelectBox값 변경
	function changeClassCode(avg1, avg2, avg3){
		$("#attrIndex").val("0");
		$("#appendDiv").empty();
		$("#displayLabel").empty();
		var url    = "getSearchSelectOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&sqlID=search_SQL.attrBySearch&s_itemID="+avg2+"&s_itemID2="+avg1; //파라미터들
		var target = "AttrCode";            // selectBox id
		var defaultValue = "${defClassCode}";              // 초기에 세팅되고자 하는 값
		var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxMultiSelect(url, data, target, defaultValue, isAll);
		setTimeout(appendOption,1000);
	}
	
	function appendOption(){
		 var optionName = '${menu.LN00028}';
		 $("#AttrCode").prepend("<option value='AT00001'>"+optionName+"</option>");
		 
		 $('#AttrCode')[0].sumo.reload();
		 if("${defAttrTypeCode}" != ""){
		 	checkAttrCode("${defAttrTypeCode}","${defAttrTypeName}", "NEW");
		 }else{
		 	checkAttrCode("AT00001",optionName, "NEW");
		 }
		 //doSearchList();
	}

	function setAttrLovMulti(atrCode){
		
		 $('#AttrLov'+atrCode).SumoSelect({ csvDispCount: 3 });
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
			$("#searchValue"+attrCode).attr('style', 'display:none;width: 20%; height: 23px; margin-left: 10px;');	
			
			var url    = "getAttrLovSelectOption.do"; // 요청이 날라가는 주소
			var data   = "languageID="+languageID+"&attrCode="+attrCode; //파라미터들
			var target = "AttrLov"+attrCode;            // selectBox id
			var defaultValue = "";              // 초기에 세팅되고자 하는 값
			var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
			ajaxMultiSelect(url, data, target, defaultValue, isAll);
			setTimeout("setAttrLovMulti('"+attrCode+"')",500);
		} else {
			$("#isLov"+attrCode).val("");
			$("#searchValue"+attrCode).attr('style', 'width: 20%; height: 23px; margin-left: 10px; display: inline; ');
			$("#AttrLov"+attrCode).attr('style', 'display:none;width:120px;margin-left:30px;');	
		}
		
		
	}

	function setAttrLovMulti(atrCode){
		 $('#AttrLov'+atrCode).SumoSelect();
		 $('#ssAttrLov'+atrCode).attr("style","width:235px;margin-left:30px;");
	}
	
	
	// [dimValue option] 설정
	function changeDimValue(avg, avg2){
		var url    = "getDimValueSelectOption.do"; // 요청이 날라가는 주소
		var data   = "dimTypeId="+avg+"&searchYN=Y"; //파라미터들
		var target = "dimValueId";            // selectBox id
		var defaultValue = avg2;              // 초기에 세팅되고자 하는 값
		var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		
		ajaxMultiSelect(url, data, target, defaultValue, isAll);
		
		setTimeout(function() {appendDimOption(avg2);}, 1000);
	}
	
	function appendDimOption(avg2){
		$("#dimValueId")[0].sumo.reload();
		if(avg2 != ""){
			$("#dimValueId")[0].sumo.selectItem(avg2);
		}
	}
	
	// [속성 검색 제약] 설정
	function changeConstraint(avg, avg2) {
		if (avg == "" || avg == "3") {
			if ($("#isLov"+avg2).val() == "Y") {
				$("#searchValue"+avg2).attr('style', 'display:none;width: 20%; height: 23px; margin-left: 10px; ');
				$("#ssAttrLov"+avg2).attr('style', 'width:235px;margin-left:30px;');
			} else {
				$("#searchValue"+avg2).attr('style', 'display:inline;width: 20%; height: 23px; margin-left: 10px;');
				$("#ssAttrLov"+avg2).attr('style', 'display:none;width:120px;margin-left:30px;');
			}
		} else {
			$("#searchValue"+avg2).val("");
			$("#searchValue"+avg2).attr('style', 'display:none;width: 20%; height: 23px; margin-left: 10px;');
			$("#ssAttrLov"+avg2).attr('style', 'display:none;width:120px;margin-left:30px;');
		}
	}
	
	
	// [Clear] click
	function clearSearchCon() {
		// 계층
		
		$("#appendDiv").empty();

		// 기본정보 상세
		$("#detailID").val('');
		$("#itemName").val('');
		$("#csStatus").val('');
		$("#ownerTeamName").val('');
		$("#ownerTeamID").val('');
		$("#authorName").val('');
		document.querySelectorAll("input[name='siteCode']:checked").forEach(e => e.checked = false);
		document.getElementById("${defDimValueID}").checked = true;
		$("#ZAT01060").val('');
		$("#ZAT01040").val('');
		$("#ZAT01020").val('');
		$("#ZAT01050").val('');
		
		/* $("#ZAT01051").val(''); */
		$("#ZAT01051 option").prop("selected", false); 
		$(".selected").removeClass("selected");
		$(".CaptionCont.SlectBox span").text('');

		$("#ZAT09005").val('');
		$("#ZAT09006").val('');
		$("#ZAT09007").val('');

		$("#processInfo").val('');
		$("#keyWord").val('');
		$("#totalInfo").val('');
		$("#AT00040").val('');
		
		$("#SC_STR_DT1").val('');
		$("#SC_END_DT1").val('');
		$("#SC_STR_DT2").val('');
		$("#SC_END_DT2").val('');	}
	
	/**  
	 * [Owner][Attribute] 버튼 이벤트
	 */

	
	/* function subItemInfoRpt(URL, classCodeList, outputType) {
		$('#fileDownLoading').removeClass('file_down_off');
		$('#fileDownLoading').addClass('file_down_on');
		timer = setTimeout(function() {checkDocDownCom();}, 1000);
		var url = "subItemInfoReportEXE.do";	
		$('#URL').val(URL);
		$('#outputType').val(outputType);
		ajaxSubmitNoAdd(document.processList, url, "blankFrame");
	} */
	
	function checkDocDownCom(){
		$.ajax({
			url: "checkDocDownComplete.do",
			type: 'post',
			data: "",
			error: function(xhr, status, error) { 
			},
			success: function(data){
				data = data.replace("<script>","").replace(";<\/script>","");
			
				if(data == "Y") {
					afterWordReport();
					clearTimeout(timer);
				}
				else {
					clearTimeout(timer);				
					timer = setTimeout(function() {checkDocDownCom();}, 1000);
				}
			}
		});	
	}
	

	
	// [back] click

	function fnResetSelectBox(objName,defaultValue)
	{
		$("select[name='"+ objName +"'] option").not("[value='"+defaultValue+"']").remove(); 
	}

	
	function showMultiSearchDiv() {
			$("#search").hide();
			$("#mSearch").show();
			$("#buttonGroup").show();
			$("#layout").attr("style","height:"+(setWindowHeight() - 428)+"px;");
   
	}

	function doNameSearchList() {
		doSearchList();
	}
	
// 	function fnItemMenuReload(){
// 		urlReload();
// 	}
	
	function fnChangeMenu(menuID,menuName) {
		if(menuID == "management"){
			parent.fnGetMenuUrl("${s_itemID}", "Y");
		}
	}
	//cop_hdtitle
	
	/*공통등록*/
	function fnCreateTSDInfo(){
		
// 		   document.getElementById("cop_hdtitle").style.display = "none";
			var url = "processItemInfo.do";
			var data = "&itemEditPage=custom/sk/skon/item/tsd/createTSDInfo&accMode=DEV&scrnMode=N&option=${option}&screenOption=C"
						+"&curItemID=${s_itemID}"
						+"&defDimValueID=${defDimValueID}"
						+"&selectedTreeID=${s_itemID}&fixedDimValueID=${fixedDimValueID}";	
			var target = "myItemList";

			ajaxPage(url, data, target);

		}
	
	
	
	/* 신규등록 2 */
	function fnRegisterItem(classcode){
		let url = "zSKregisterItem.do";	
		let data = "&s_itemID=${s_itemID}&classCode="+classcode+"&fltpCode=${fltpCode}&dimTypeList=${dimTypeList}";	
		let target = "myItemList";
		ajaxPage(url, data, target);
	}
	
	async function getItemAccRight(itemID) {
		const res = await fetch("getItemAccRight.do?itemID="+itemID+"&userID=${sessionScope.loginInfo.sessionUserId}")
		const data = await res.json();
		
		return data.data;
	}
	
	// 그리드ROW선택시 
	async function gridOnRowSelect(row,col){
		const accRight = await getItemAccRight(row.ItemID);
		
		if(accRight == "Y") {
			if(col.id != "CHK") {
				
				if(col.id != "FileIcon" ) {
					clickItemEvent(row.ItemID, row.AuthorID, row.Status, accRight);			
				}
				else if(col.id != "CHK" && col.id != "FileIcon") {
					var fileCheck = row.FileIcon;
		
					if(fileCheck.indexOf("blank.gif") < 1) {
						var url = "selectFilePop.do";
						var data = "?hideBlocked=Y&s_itemID="+row.ItemID+"&scrnOption=E"
					   
					    var w = "400";
						var h = "350";
					    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");	
					}
				}
			}
		} else {
			alert("${WM00033}")
		}
	}
	
	function fnZAT01050Change(value){
		var url    = "getSearchSelectOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&sqlID=common_SQL.getSubLovList_commonSelect&lovCode="+value; //파라미터들
		var target = "ZAT01051";            // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxMultiSelect(url, data, target, defaultValue, isAll);
		setTimeout(changeZAT01051,1000);
	}
	
	function changeZAT01051(){
		$("#ZAT01051")[0].sumo.reload();
	}
	
	function fnZAT01020Change(value){
		if(value) fnSelect('ZAT01060', "&languageID=${sessionScope.loginInfo.sessionCurrLangType}&lovCode="+value, 'getSubLovList', '', 'Select');
		else fnSelect('ZAT01060', data+"&attrTypeCode=ZAT01060", 'getAttrTypeLov', '', 'Select');
	}
	
	function reloadItem() {
		
		parent.olm.getMenuUrl(document.getElementById("processList").dataset.id,'','',parent.olm.menuTree.getSelectedItemText());
		//getMenuUrlTest(document.getElementById("processList").dataset.id);
	
	}

	function fnHideSearch() {
		var tempSrc = $("#frame_sh").attr("src");
		if($("#frame_sh").hasClass("frame_show")) {
			$("#mSearch").hide();
			$("#buttonGroup").hide();
			$("#frame_sh").attr("class","frame_hide");
			$("#frame_sh").attr("alt","${WM00159}");
			$("#frame_sh").attr("src",tempSrc.replace("btn_frame_show","btn_frame_hide"));
			$("#layout").attr("style","height:"+(setWindowHeight() - 168)+"px;");
		}
		else {
			$("#mSearch").show();
			$("#buttonGroup").show();
			$("#frame_sh").attr("class","frame_show");
			$("#frame_sh").attr("alt","${WM00158}");
			$("#frame_sh").attr("src",tempSrc.replace("btn_frame_hide","btn_frame_show"));
			$("#layout").attr("style","height:"+(setWindowHeight() - 428)+"px;");
		}
	}
	 function handleSelectChange() {
			const docSearch = document.getElementById('docSearch').value;

			    if (docSearch === 'AT00001') {//문서명
			    	
			    	document.getElementById('totalInfo').type ="hidden";
			    	document.getElementById('keyWord').type="hidden";
			    	document.getElementById('processInfo').type="hidden";
			    	document.getElementById('itemName').type="text";
			    } else if (docSearch === 'AT00003') {//문서내용
			    	document.getElementById('totalInfo').type ="hidden";
			    	document.getElementById('itemName').type="hidden";
			    	document.getElementById('keyWord').type="hidden";
			    	document.getElementById('processInfo').type="text";
			    }else if(docSearch ==='AT01007'){//키워드
			    	document.getElementById('totalInfo').type ="hidden";
			    	document.getElementById('itemName').type="hidden";
			    	document.getElementById('processInfo').type="hidden";
			    	document.getElementById('keyWord').type="text";
			    }else{
			    	document.getElementById('itemName').type="hidden";
			    	document.getElementById('processInfo').type="hidden";
			    	document.getElementById('keyWord').type="hidden";
			    	document.getElementById('totalInfo').type ="text";
			    }
			    
			    
			
			 }

	function ZAT01040Change(val) {
		if(ZAT01060Value == "TE") {
			if(val == "VA") {
				$("#AT00040").val("01");
			} else {
				$("#AT00040").val("02");
			}
		}
	}
	
	function AT00040Change() {
		AT00040 = $("#AT00040").val();
	}
</script>
</head>
<body>
<form name="processList" id="processList" action="#" method="post"  onsubmit="return false;" class="pdL10 pdR10" data-id="${s_itemID}">
	<input type="hidden" id="searchKey" name="searchKey" value="Name">
	<input type="hidden" id="currPage" name="currPage" value="${currPage}"></input>
	<input type="hidden" id="defaultLang" name="defaultLang" value="${defaultLang}">
	<input type="hidden" id="attrIndex" value="0">
	<input type="hidden" id="multiSearch" value="N">
	<input type="hidden" id="accMode" name="accMode" value="${accMode}" />
	
	<div id="myItemList">
		<div class="cop_hdtitle" id ="cop_hdtitle" style="padding: 10px 0; ">
			<h3 style="display: inline-block"><img src="${root}${HTML_IMG_DIR}/icon_search_title.png">&nbsp;${itemName}&nbsp;
				<c:forEach var="path" items="${itemPath}" varStatus="status">
						<c:choose>
							<c:when test="${status.first}">
							( <span style="cursor:pointer">${path.PlainText}</span>
							</c:when>
							<c:when test="${status.last}">
							>&nbsp;<span style="cursor:pointer">${path.PlainText}</span>
							</c:when>
							<c:otherwise>>&nbsp;<span style="cursor:pointer">${path.PlainText}</span></c:otherwise>
						</c:choose>
				</c:forEach>
				<c:if test="${itemPath != null && itemPath.size() > 0 }">)</c:if>
			</h3>
			<c:if test="${sessionScope.loginInfo.sessionAuthLev == 1}" >
				<span class="btn_pack small icon mgR25" style="float: right;"><input value="Standard Menu" type="button" style="padding-left: 2px;" onclick="fnChangeMenu('management','Management');"></span>
			</c:if>
		</div>
	
		<div id="search" align="center" style="margin-top: 20px;">
			<input type="text" id="searchValue" name="searchValue" value="${searchValue}" class="text" style="width:30%;height:3% ;  ime-mode:active;">
			<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" onclick="doNameSearchList()" value="Search" style="cursor:pointer;">
			<input type="image" class="image" onclick="showMultiSearchDiv();" src="${root}${HTML_IMG_DIR}/btn_search_plus.png" value="Conditional Search" style="cursor:pointer;">
		</div>

		
	<div align="center">
		<table style="table-layout:fixed;display:none;" border="0" cellpadding="0" cellspacing="0" class="tbl_search"  id="mSearch">
			<colgroup>
				<col width="5%">
				<col width="15%">
				<col width="5%">
				<col width="15%">
				<col width="5%">
				<col width="15%">
				<col width="5%">
				<col width="15%">
			</colgroup>
				      <tr>
				      	<!-- 문서번호 -->
						<th class="viewtop alignl">${menu.ZLN0068}</th>
						<td class="viewtop alignl"><input type="text" id="detailID" name="detailID" value="" class="stext"
						></td>
						<!-- 문서명 -->
						<th  style="" class="viewtop alignl" >${menu.LN00101}</th>
						<td class="viewtop alignl" colspan=3 style="width:100%;">
							 <div style="display: inline-block;">
							   <select id="docSearch" name="DocSearch" style="width:100%;" onchange="handleSelectChange()">
								  <!-- 통합 / 문서명 / 문서개요 / 키워드 -->
								  <option value="total">${menu.ZLN0069}</option>
								  <option value="AT00001">${menu.ZLN0069}</option>
								  <option value="AT00003">${menu.ZLN0094}</option>
								  <option value="AT01007">${menu.ZLN0070}</option>
							 </select> 
							</div>
							<div style="display: inline-block; width:84%;">
							    <input type="text" id="totalInfo" name="totalInfo" value="" class="stext" style="width:100%;"> 
								<input type="hidden" id="itemName" name="itemName" value="" class="stext" style="width:100%;">
								<input type="hidden" id="processInfo" name="processInfo" value="" class="stext" style="width:100%;">  
								<input type="hidden" id="keyWord" name="keyWord" value="" class="stext" style="width:100%;">  
							</div> 
							
						</td>
					<!-- 문서상태 -->
					<th class="viewtop alignl">${menu.ZLN0071}</th>
					<td class="viewtop alignL">
					    <select id="csStatus" name="csStatus" style="width:90%; display: inline-block;" class="stext">
					        <option value=''></option>
					    </select>
					</td>

					<tr>
						<!-- 영역 -->
						<th class="viewtop alignl">${menu.ZLN0072}</th>
						<td class="viewtop alignl">${L1ItemName}</td> 
						
							<c:if test="${attrList != null && attrList != ''}">
								<c:forEach var="i" items="${attrList}">
									<c:if test="${i.AttrTypeCode eq 'ZAT01030'}">
									<input type="hidden" id="ZAT01030" name = "ZAT01030" value="${i.LovCode}"/>
									</c:if>
								</c:forEach>
							</c:if>
						
						<!-- 문서레벨 -->
						<th class="viewtop alignl">${menu.ZLN0075}</th>
						<td>
							<c:if test="${attrList != null && attrList != ''}">
								<c:forEach var="i" items="${attrList}">
									<c:if test="${i.AttrTypeCode eq 'ZAT01020'}"><c:set var="ZAT01020Name" value="${i.PlainText}" /><c:set var="ZAT01020Value" value="${i.LovCode}" /></c:if>
								</c:forEach>
								<c:choose>
									<c:when test="${ZAT01020Name != null && ZAT01020Name != ''}">
										<c:out value="${ZAT01020Name}" />
										<input type="hidden" id="ZAT01020" name="ZAT01020" value="${ZAT01020Value}" />
									</c:when>
									<c:otherwise>
										<select id="ZAT01020" name="ZAT01020" class = "stext" style="display: inline-block;" onchange="fnZAT01020Change(this.value)">
											<option value=''></option>
										</select>
									</c:otherwise>
								</c:choose>
							</c:if>
						</td>
						<!-- 문서유형 -->
						<th class="viewtop alignl">${menu.LN00091}</th>
						<td class="viewtop alignl">
							<c:if test="${attrList != null && attrList != ''}">
								<c:forEach var="i" items="${attrList}">
									<c:if test="${i.AttrTypeCode eq 'ZAT01060'}"><c:set var="ZAT01060Name" value="${i.PlainText}" /><c:set var="ZAT01060Value" value="${i.LovCode}" /></c:if>
								</c:forEach>
								<c:choose>
									<c:when test="${ZAT01060Name != null && ZAT01060Name != ''}">
										<c:out value="${ZAT01060Name}" />
										<input type="hidden" id="ZAT01060" name="ZAT01060" value="${ZAT01060Value}" />
									</c:when>
									<c:otherwise>
										<select id="ZAT01060" name="ZAT01060" class ="stext" style="display: inline-block;">
											<option value=''></option>
										</select>
									</c:otherwise>
								</c:choose>
							</c:if>
							
						</td>
						<!-- 문서분야 -->
						<th class="viewtop alignl">${menu.ZLN0085}</th>
						<td class="viewtop alignl">
						 	<select id="ZAT01040" name="ZAT01040" style="width: 90%;display: inline-block;" onchange="ZAT01040Change(this.value)">
								<option value=''></option>
							</select>
						</td>
					</tr>

					<tr>
						<!-- 공정 -->
						<th class="viewtop alignl">${menu.ZLN0044}</th>
						<td class="viewtop alignl">
							<c:if test="${attrList != null && attrList != ''}">
								<c:forEach var="i" items="${attrList}">
									<c:if test="${i.AttrTypeCode eq 'ZAT01050'}"><c:set var="ZAT01050Name" value="${i.PlainText}" /><c:set var="ZAT01050Value" value="${i.LovCode}" /></c:if>
								</c:forEach>
								<c:choose>
									<c:when test="${ZAT01050Name != null && ZAT01050Name != ''}">
										<c:out value="${ZAT01050Name}" />
										<input type="hidden" id="ZAT01050" name="ZAT01050" value="${ZAT01050Value}" />
									</c:when>
									<c:otherwise>
										<select id="ZAT01050" name="ZAT01050" style="display: inline-block;" onchange="fnZAT01050Change(this.value)" class="stext">
											<option value=''></option>
										</select>
									</c:otherwise>
								</c:choose>
							</c:if>
						</td>
						<!-- 상세공정 -->
						<th class="viewtop alignl">${menu.ZLN0067}</th>
			
							<td class="viewtop alignl">
						 	<select id="ZAT01051" name="ZAT01051" style="display: inline-block;" multiple="multiple">
								<option value="">Select</option>
							
							</select>
						</td>
					
						<!-- 모델 -->
						<th class="viewtop alignl">${menu.LN00125}</th>
						<td class="viewtop alignl"><input type="text" id="ZAT09005" name="ZAT09005" value="" class="stext"></td>
						<!-- 라인 -->
						<th class="viewtop alignl">${menu.ZLN0113}</th>
						<td class="viewtop alignl"><input type="text" id="ZAT09006" name="ZAT09006" value="" class="stext"></td>
					</tr>	
				    <tr>
				    	<!-- 담당자 -->
				    	<th class="viewtop alignl">${menu.LN00004}</th>
						<td class="viewtop alignl"><input type="text" id="authorName" name="authorName" class="stext"></td>
						<!-- 담당부서 -->
						<th class="viewtop alignl">${menu.ZLN0074}</th>
						<td class="viewtop alignl"><input type="text" id="ownerTeamName" name="ownerTeamName" class="stext"><input type="hidden" id="ownerTeamID" name="ownerTeamID"></td>
						<!-- 제정일자 -->
						<th class="viewtop alignl">${menu.ZLN0076}</th>
						<td>
			   				<input type="text" id="SC_STR_DT1" name="SC_STR_DT1" value=""	class="input_off datePicker stext" size="8"
								style="width: 120px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
							
								~
							<input type="text" id="SC_END_DT1"	name="SC_END_DT1" value="" class="input_off datePicker stext" size="8"
								style="width: 120px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
							
		   				</td>  
			   			<!-- 개정일자 -->
						<th class="viewtop alignl">${menu.ZLN0077}</th>
						<td>
			   				<input type="text" id="SC_STR_DT2" name="SC_STR_DT2" value=""	class="input_off datePicker stext" size="8"
								style="width: 120px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
							
								~
							<input type="text" id="SC_END_DT2"	name="SC_END_DT2" value="" class="input_off datePicker stext" size="8"
								style="width: 120px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
							
		   				</td>
					</tr>  
					
					<tr style="height:40px;">
						<!-- 적용Site -->
						<th class="viewtop alignl">${menu.ZLN0078}</th>
						<td colspan="3" class="alignL pdL10"  >
							<input type="checkbox" name="siteCode" id="SKO1" value="SKO1"> 
							<label for="SKO1" class="mgR10">${menu.ZLN0029}</label>
							<input type="checkbox"name="siteCode" id="SKO2" value="SKO2"> 
							<label for="SKO2" class="mgR10">${menu.ZLN0030}</label>
							<input type="checkbox"name="siteCode" id="SKBA" value="SKBA">
							<label for="SKBA" class="mgR10">${menu.ZLN0079}</label>
							<input type="checkbox"name="siteCode" id="SKOH1" value="SKOH1">
							<label for="SKOH1" class="mgR10">${menu.ZLN0080}</label>
							<input type="checkbox"name="siteCode" id="SKOH2" value="SKOH2">
							<label for="SKOH2" class="mgR10">${menu.ZLN0081}</label>
							<input type="checkbox"name="siteCode" id="SKBM" value="SKBM"> 
							<label for="SKBM" class="mgR10">${menu.ZLN0082}</label>
							<input type="checkbox"name="siteCode" id="SKOJ" value="SKOJ"> 
							<label for="SKOJ" class="mgR10">${menu.ZLN0083}</label>
							<input type="checkbox"name="siteCode" id="SKOY" value="SKOY"> 
							<label for="SKOY" class="mgR10">${menu.ZLN0084}</label>
							<input type="checkbox"name="siteCode" id="SKOS" value="SKOS"> 
							<label for="SKOS" class="mgR10">${menu.ZLN0150}</label>
						</td>
						<!-- NCT대상  -->
						<th class="viewtop alignl">${menu.ZLN0114}</th>
						<td class="viewtop alignl" >
						 	<select id="AT00040" name="AT00040" style="width:90%;display: inline-block;" onchange="AT00040Change()">
								<option value=''></option>
							</select>
						</td> 
						<!-- 제품코드라인  -->
						<th class="viewtop alignl" id="ZAT09007th" style="display:none;">${menu.ZLN0120}</th>
						<td class="viewtop alignl" id="ZAT09007td" style="display:none;">
						<input type="text" id="ZAT09007" name="ZAT09007" value="" class="stext"></td>
					</tr>
		
			      	<tr style ="display:none;">
				       	<!-- 속성 -->
				       	<th>${menu.LN00031}</th>
				       	<td colspan="7" class="alignL">
				     		<select id="AttrCode" Name="AttrCode[]" multiple="multiple" class="SlectBox" ></select>
						    <div id="appendDiv"></div> 
				    	</td>
				      	</tr>
				</table>
			 <ul>
				<li id="buttonGroup" class="floatC mgR20 mgT5" style="display:none;">
					<input id="btnSearch" type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" style="cursor:pointer;">
					&nbsp;<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="cursor:pointer;" onclick="clearSearchCon();">
<%-- 					<input type="image" class="image" onclick="showMultiSearchDiv();" src="${root}${HTML_IMG_DIR}/btn_search_plus.png" value="Advanced Search" style="cursor:pointer;"> --%>
				</li>
			</ul>
	</div>	
	
		<div id="proDiv" style="overflow:auto;">
		   <div class="countList pdT10">
			       <!-- total -->
			       	<ul>
			        <li class="count">
			        <input type="image" id="frame_sh" class="frame_show" alt="${WM00158}" src="${root}${HTML_IMG_DIR}/btn_frame_show.png" value="Clear" style="cursor:pointer;width:20px;height:15px;margin-right:5px;" onclick="fnHideSearch();">Total  <span id="TOT_CNT"></span>
				    <c:set var="showMsg" value="false" />
						<c:if test="${s_ClassCode eq 'CL16000' or s_ClassCode eq 'CL16001'}">
						    <c:set var="showMsg" value="true" />
						</c:if>
						<c:if test="${s_ClassCode eq 'CL16002'}">
						    <c:forEach var="i" items="${attrList}">
						        <c:if test="${i.AttrTypeCode eq 'ZAT01060' 
						                     and i.LovCode ne 'MS' 
						                     and i.LovCode ne 'WS' 
						                     and i.LovCode ne 'WI'}">
						            <c:set var="showMsg" value="true" />
						        </c:if>
						    </c:forEach>
						</c:if>
						<c:if test="${s_ClassCode eq 'CL16003'}">
					    <c:set var="cond1" value="false" />
					    <c:set var="cond2" value="false" />
					    <c:set var="zat01060Exception" value="false" />
					    <c:set var="zat01050Exception" value="false" />
					    
					    <c:forEach var="i" items="${attrList}">
					        <c:if test="${i.AttrTypeCode eq 'ZAT01060'}">
					            <%-- <c:if test="${i.LovCode eq 'PD'}">
					                <c:set var="zat01060Exception" value="true" />
					            </c:if> --%> <!-- 예외 처리 -->
					            <c:if test="${i.LovCode ne 'MS' and i.LovCode ne 'WS' and i.LovCode ne 'WI'}">
					                <c:set var="cond1" value="true" />
					            </c:if>
					        </c:if>
					        
					        <c:if test="${i.AttrTypeCode eq 'ZAT01050'}">
					            <%-- <c:if test="${i.LovCode eq '005'}">
					                <c:set var="zat01050Exception" value="true" />
					            </c:if> --%> <!-- 예외 처리 -->
					            <c:if test="${i.LovCode ne '005'}">
					                <c:set var="cond2" value="true" />
					            </c:if>
					        </c:if>
					    </c:forEach>
					    <%-- <c:if test="${(cond1 and cond2) or (zat01060Exception and zat01050Exception)}"> --%>
					    <c:if test="${(cond1 and cond2)}">
					        <c:set var="showMsg" value="true" />
					    </c:if>
					</c:if>		
					<c:if test="${showMsg}">
					    &nbsp;&nbsp;&nbsp;<span class="floatR" style="text-align:center;color:#cd5e5e;font-weight: bold;margin-right:5px;">
					        ${menu.ZLN0148} ${menu.ZLN0149}
					    </span>
					</c:if>
			        </li>
			        <li class="floatR"> 
				    <!--  등록 , 북마크 , excel다운버튼 -->
			<!-- PLM 에서 온 문서는 CREATE 버튼 안보이도록 ㄴ-->			       
		    <c:forEach var="i" items="${attrList}">
				<c:if test="${s_ClassCode eq 'CL16003' && i.AttrTypeCode eq 'AT00037'}">
				 <c:choose>
					<c:when test="${i.LovCode ne 'LV37002'}">
					<!--&nbsp;<button class="cmm-btn floatL " style="height: 30px;" id='add' value="Create" onClick="fnCreateTSDInfo();">Create</button>-->
					&nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Create" type="submit" id="add" onClick="fnCreateTSDInfo();"></span>
					</c:when>
					<c:otherwise>
						<!-- PLM시스템에서 인터페이스 받는 문서로 문서조회만 가능합니다 -->
						<span class="floatL" style ="text-align:center;color:#e26b6b;font-weight: bold;margin-right:5px;margin-top: 3px;">${menu.ZLN0115}</span>
					&nbsp;<button class="cmm-btn floatL " style="width:64px; height: 24px;  pointer-events : none;" id='add' value="Create" onClick="" disabled>Create</button>
					</c:otherwise>
				</c:choose>
				</c:if>
			</c:forEach>
		
					 &nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="down"></span><input value="Down" type="submit" id="excel"></span> 
					<!--<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnGridExcelDownLoad()" value="Down">Download List</button>-->
					&nbsp;&nbsp;&nbsp;&nbsp;
			        </li>
			        </ul>
		   	</div>
		</div>

			<div style="width: 100%;" id="layout" style="width:100%;"></div>
			<div id="pagination" style="width:100%; height:60px;"></div>	
	
		
				
		</div>
</form>
<iframe name="blankFrame" id="blankFrame" style="width:0px;height:0px;display: none;"></iframe>

<script type="text/javascript">



	var layout = new dhx.Layout("layout", {
		rows : [ 
		{
			id : "a",
			
		},  ]
	});	
	
// 	var gridData = ${gridData};
	var grid = new dhx.Grid("", {
		 columns: [
		   		// 문서번호 / 문서명 / 영역 / 문서레벨 / 문서유형 / 문서분야 / NCT대상 / 공정 / 상세공정 / 모델 / 라인 / 담당자 / 담당부서 / 적용Site / 제정일자 / 개정일자 / 개정번호 / 문서상태
		        
		   		// 문서번호 / 문서명 / 영역 / 문서레벨 / 문서유형 
		   		{ width: 150, id: "Identifier", header: [{ text: "${menu.ZLN0068}", align: "center" }, { content: "inputFilter" }], align: "center" }, 
		        { width: 230, id: "ItemName", header: [{ text: "${menu.LN00101}", align: "center" }, { content: "inputFilter" }]}, 
		        {  id: "Area", header: [{ text: "${menu.ZLN0072}", align: "center" }, { content: "selectFilter" }], align: "center" },
		        {  id: "DocLev", header: [{ text: "${menu.ZLN0075}", align: "center" }, { content: "selectFilter" }], align: "center" },
		        {  width:100,id: "DocType", header: [{ text: "${menu.LN00091}", align: "center" }, { content: "selectFilter" }], align: "left" },
		     	// 문서분야 / NCT대상 / 공정 / 상세공정 / 모델 
		        {  id: "DocField", header: [{ text: "${menu.ZLN0085}", align: "center" }, { content: "selectFilter" }], align: "center" },
		        {  id: "NctVal", header: [{ text: "${menu.ZLN0114}", align: "center" }, { content: "selectFilter" }], align: "center" },
		        {  id: "MfProcess", header: [{ text: "${menu.ZLN0044}", align: "center" }, { content: "selectFilter" }], align: "center" },
		        {  id: "DetailMfProc", header: [{ text: "${menu.ZLN0067}", align: "center" }, { content: "selectFilter" }], align: "center" },
		        {  id: "Model", header: [{ text: "${menu.LN00125}", align: "center" }, { content: "selectFilter" }], align: "center"},
		     	// 라인 /제품코드라인 / 담당자 / 담당부서 / 적용Site / 제정일자 
		        {  id: "Line", header: [{ text: "${menu.ZLN0113}", align: "center" }, { content: "selectFilter" }], align: "center"},
		        {  hidden:true,id: "ProcCodeLine", header: [{ text: "${menu.ZLN0120}", align: "center" }, { content: "selectFilter" }], align: "center"}, 
		        {  id: "Name", header: [{ text: "${menu.LN00004}", align: "center" }, { content: "inputFilter" }], align: "center" },
		        {  width:150,id: "OwnerTeamName", header: [{ text: "${menu.ZLN0074}", align: "center" }, { content: "inputFilter" }], align: "left" },
				{  id: "Site", header: [{ text: "${menu.ZLN0078}" , align: "center" }, { content: "selectFilter" }], align: "left" },
				{  width:100,id: "CreationTime", header: [{ text: "${menu.ZLN0076}", align: "center" }, { content: "inputFilter" }], align: "center" },
				// 개정일자 / 개정번호 / 문서상태
				{  width:100,id: "LastUpdated", header: [{ text: "${menu.ZLN0077}", align: "center" }, { content: "inputFilter" }], align: "center" },			
		        {  id: "CSVersion", header: [{ text: "${menu.LN00356}", align: "center" }, { content: "inputFilter" }], align: "center" },
		        {  id: "CSStatusName", header: [{ text: "${menu.ZLN0071}", align: "center" }, { content: "selectFilter" }], align: "center"},
		        { hidden: true, width: 100, id: "ItemID", header: [{ text: "itemid", align: "center" }], align: "center" }
		        
		    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,  
	});
	
	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 48,
	});
	
	layout.getCell("a").attach(grid);
	

	// 1. 기존 컬럼 설정 접근
	let columns = grid.config.columns;
	// 2. 숨겨진 컬럼 hidden=false로 변경
	let ZAT01060Val = $("#ZAT01060").val();

			columns.forEach(col => {
			    if (col.id === "ProcCodeLine") {
			    		if(ZAT01060Val=="CP"){
					        col.hidden = false;
			    			
			    		}else{
			    			col.hidden = true;
			    		}
			    }
			  
			});


	$("#TOT_CNT").html(grid.data.getLength());
	

	grid.events.on("cellClick", function(row, column, e) {
		gridOnRowSelect(row,column);
	});
	
	function doSearchList(){
		if($("#SC_STR_DT1").val() != "" && $("#SC_END_DT1").val() == "")		$("#SC_END_DT1").val(new Date().toISOString().substring(0,10));
		if($("#SC_STR_DT2").val() != "" && $("#SC_END_DT2").val() == "")		$("#SC_END_DT2").val(new Date().toISOString().substring(0,10));

		const SC_STR_DT1 = document.getElementById("SC_STR_DT1").value;
		const SC_END_DT1 = document.getElementById("SC_END_DT1").value;
		const SC_STR_DT2 = document.getElementById("SC_STR_DT2").value;
		const SC_END_DT2 = document.getElementById("SC_END_DT2").value;
		
		if(SC_STR_DT1 && SC_END_DT1 && SC_STR_DT1 > SC_END_DT1) {
			alert("${WM00132}");
			return;
		}
		
		if(SC_STR_DT2 && SC_END_DT2 && SC_STR_DT2 > SC_END_DT2) {
			alert("${WM00132}");
			return;
		}
		
		$('#loading').fadeIn(150);
		let siteCode = "";
		var sqlID = "zSK_SQL.getTSDList";
		var param = "";
		param += "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&ClassCode=${defClassCode}"
		+ "&sqlID="+sqlID
		+"&pItemID=${s_itemID}";		
		param += "&searchValue="+$("#searchValue").val();
		param += "&totalInfo="+$("#totalInfo").val().trim();
		param += "&identifier="+$("#detailID").val().trim();
		param += "&itemName="+$("#itemName").val();	
		//processInfo 
		param += "&processInfo="+$("#processInfo").val();
		param +="&keyWord="+$("#keyWord").val();
		param +="&ownerTeamName="+$("#ownerTeamName").val().trim();
		
		
		param += "&csStatus="+$("#csStatus").val();	
		param += "&authorName="+$("#authorName").val().trim();
		if(document.querySelectorAll("input[name='siteCode']:checked").length) {
			document.querySelectorAll("input[name='siteCode']:checked").forEach(e => {
			    if(e.value === "SKO1") {
			    	param += "&SKO1=Y"
			    }  else {
			    	siteCode += siteCode == "" ? "'"+e.value+"'" : ","+"'"+e.value+"'";
			    }
			})
			param += "&siteCode="+siteCode;
		}
		
		let ZAT01030 = "";
		ZAT01030 = $("#ZAT01030").val() ? $("#ZAT01030").val() : "";
		
		param += "&ZAT01060="+$("#ZAT01060").val();
		param += "&ZAT01030="+ZAT01030;
		param += "&ZAT01040="+$("#ZAT01040").val();
		param += "&ZAT01020="+$("#ZAT01020").val();
		param += "&ZAT01050="+$("#ZAT01050").val();
		param += "&ZAT09005="+$("#ZAT09005").val().trim();
		param += "&ZAT09006="+$("#ZAT09006").val().trim();
		param += "&ZAT09007="+$("#ZAT09007").val();
// 		param += "&ZAT01051="+$("#ZAT01051").val();
		param += "&AT00040="+ AT00040;
		param += "&SC_STR_DT1="+$("#SC_STR_DT1").val();
		param += "&SC_END_DT1="+$("#SC_END_DT1").val();
		param += "&SC_STR_DT2="+$("#SC_STR_DT2").val();
		param += "&SC_END_DT2="+$("#SC_END_DT2").val();
		param += "&childItems=${childItems}";
		param += "&isNothingLowLank=${isNothingLowLank}";
	
		if ($("#ZAT01051").val()) {
			var array = new Array();
			$("#ZAT01051 :selected").each(function(i, el){ 
				var temp = $(el).val(); 
			
				if (temp != "" && "nothing" != temp && "Nothing" != temp) {
					array.push(temp);
					nothing = "&nothingZAT01051=";
				} else if("nothing" == temp || "Nothing" == temp) {
					nothing = "&nothingZAT01051=Y";
				}

			});
			param += "&ZAT01051OLM_ARRAY_VALUE=" + array;
			
		}
		//console.log(param);
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
		
			success: function(result){
				fnReloadGrid(result);
				$('#loading').fadeOut(150);
			},error:function(xhr,status,error){
				//console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	}
	
	function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
		$("#TOT_CNT").html(grid.data.getLength());
	}
</script>
</body>
</html>
