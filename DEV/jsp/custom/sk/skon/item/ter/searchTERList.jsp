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

<script type="text/javascript" src="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.js?v=7.1.8"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/dhtmlxV7/codebase/suite.css?v=7.1.8">

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00041" var="WM00041" arguments="${menu.LN00021}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00158" var="WM00158"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00159" var="WM00159"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00132" var="WM00132"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00132" var="WM00132"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00185" var="WM00185_4" arguments="4"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00186" var="WM00186"/>

<style>
input.stext {
    width: 100%;
    box-sizing: border-box;
    height: 30px;
}

.dhx_grid_data{
	cursor:pointer;
}

#ZAT04003, #ZAT04006{
width:100%;
}
</style>

<!-- 2. Script -->
<script type="text/javascript">
	var p_gridArea;	
	let ZAT03011Value = ""; //트리 클릭시 영향받는 컬럼이 있으면 주석해제하기
 	let L2ItemID = "";
	let lovListFilter = "";
	let itemName = "";
	
	$(document).ready(function() {
		// 이 부분은 트리 클릭시 자동으로 가져올 값을 위한 부분으로 보임
		let data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";		

		async function initItemClassCode() {
		  const res = await fetch('/olmapi/getItemClassCode?s_itemID=${s_itemID}');
		  const classCode  = (await res.text()).trim();
		  console.log('classCode =', classCode);

		  if (classCode === 'CL12005' || classCode === 'CL12006') {
		    L2ItemID = '${s_itemID}';
		  }
		}

	  initItemClassCode()
	    .then(function () {
	      doSearchList();                  
	    })
	    .catch(function (e) {
	      console.error('initItemClassCode error:', e);
	      doSearchList();                   
	    });
		
		getAttrLovList("ZAT01010"); //관리SITE 
		getAttrLovList("ZAT04006"); //모델(기술문서) 
		getAttrLovList("ZAT04003"); //문서목적(기술문서) 
		
// 		$("#AttrCode").val("${defAttrTypeCode}");
// 		 $('#AttrCode').SumoSelect();
		
		<c:forEach var="i" items="${attrList}">
			<c:if test="${i.AttrTypeCode eq 'ZAT03260'}"><c:set var="ZAT03260" value="${i.PlainText}" /><c:set var="ZAT03260Value" value="${i.LovCode}" /></c:if>
		</c:forEach>
				
		<c:choose>
			<c:when test="${ZAT03260 == null || ZAT03260 == ''}"> //ZAT03260 공정(기술보고서)
				getAttrLovList("ZAT03260"); // 공정(기술보고서) 값이 있을때 여기서 가져오기
			</c:when>
			<c:otherwise>
			fnZAT03260Change("${ZAT03260Value}");
			</c:otherwise>
		</c:choose>
		
		//******************************************************************
			
		$("input.datePicker").each(generateDatePicker);
		// 초기 표시 화면 크기 조정 
		$("#layout").attr("style","height:"+(setWindowHeight() - 281)+"px;");
		// 화면 크기 조정
		window.onresize = function() {
			if($("#frame_sh").hasClass("frame_show")) {
				$("#layout").attr("style","height:"+(setWindowHeight() - 281)+"px;");
			}
		};  
		
		
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
		
// 		$('#ZAT04003').SumoSelect({parentWidth: 90});
		
		$('#ZAT04003').SumoSelect({
		  placeholder: 'Select',
		  okCancelInMulti: true,
		  csvDispCount: 2,
		  maxHeight: 200,
		  forceCustomRendering: true,
		  parentWidth: 90
		});
		
		$('#ZAT04006').SumoSelect({
		  placeholder: 'Select',
		  okCancelInMulti: true,
		  csvDispCount: 2,
		  maxHeight: 200,
		  forceCustomRendering: true,
		  parentWidth: 90
		});
		
		  //var linkUrl = $("#linkUrl").val();
		  var linkUrl = "&itemID=106609"; //테스트용

		  // 2) 값이 없으면 상위 프레임(master.jsp)에서 $("#linkUrl").val(); 받아오기
		  if (!linkUrl) {
		    try {
		      var topDoc = window.top && window.top.document;
		      if (topDoc) {
		        var topInput = topDoc.getElementById("linkUrl");
		        if (topInput) linkUrl = topInput.value || "";
		      }
		    } catch (e) {  }
		  }

		  // 3) 값이 있으면 자동으로 상세화면 열기
		  if (linkUrl) {
		    // 첫 번째 ?는 유지하고, 나머지 ?는 &로 변환
		    var idx = linkUrl.indexOf("?");
		    if (idx !== -1) {
		      linkUrl = linkUrl.slice(0, idx+1) + linkUrl.slice(idx+1).replace(/\?/g, "&");
		    }

		    try { linkUrl = decodeURIComponent(linkUrl); } catch (e) {}

		    let executed = false;
		    grid.data.events.on("load", function() {
		      if (!executed) {
		        executed = true; // 다음부터는 실행 안 함
		        loadItemDetailFromLinkUrl(linkUrl);
		      }
		    });

		    // 자동실행 후에는 linkUrl 값을 비우기 (searTERList.jsp + master.jsp 둘다)
		    $("#linkUrl").val("");
		    try {
		      var topDoc = window.top && window.top.document;
		      if (topDoc) {
		        var topInput = topDoc.getElementById("linkUrl");
		        if (topInput) topInput.value = "";
		      }
		    } catch (e) {}
		    
		  }

		
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
			alert("${WM00185_4}"); // 최대 4개 선택 가능 합니다.
		}
	}
	
	function checkAttrDiv(divClassName,text,ari){
		var html = "";
		var bfAttr = $("#beforeCode").val();

		html += '<div class="'+divClassName+'" style="margin-top:10px;">';

		html += "<div style=\"text-align: right; line-height: 25px; float:left;\" ><b>"+text+"</b></div>";	
			
		html += "<select id=\"constraint"+divClassName+"\" name=\"constraint[]\" class=\"SlectBox\" style=\"width:150px;margin-left:20px;\" onChange=\"changeConstraint($(this).val(),'"+divClassName+"')\" >";
		html += "<option value=\"\">${menu.ZLN0117}</option>";			// 포함(또는 같음)
		html += "<option value=\"3\">${menu.ZLN0118}</option>";		// 포함하지 않음(또는 다름)
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
    				+"&url=/custom/sk/skon/item/ter/viewTERInfo"
    				+"&status="+status
    				+"&scrnOption=Y"
    				+"&itemOption=Y"
    				+"&defDimValueID=${defDimValueID}&nodeID="
    				+"&selectedTreeID=${s_itemID}&fixedDimValueID=${fixedDimValueID}&accRight="+accRight;
    				
    				console.log("[clickItemEvent] url:", url);
    				console.log("[clickItemEvent] data:", data);
    			
    			var w = 1200;
    			var h = 900;
//    	 		window.open(url, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
    			document.getElementById("processList").classList = "";
    			ajaxPage(url, data, "processList");
                
            },
            error: function(xhr, status, error) {
                alert("${WM00186}");	// 오류가 발생했습니다. 다시 시도해주세요.
            }
        });
		
	}
	
	async function loadItemDetailFromLinkUrl(linkUrl) { //[Link] 버튼을 눌러 url을 발급받고 새로운 탭에서 url을 쳤을때 상세화면 띄우는 함수
		  if (!linkUrl) return;
		
		  //? → & rePlace
		  let idx = linkUrl.indexOf("?");
		  if (idx !== -1) {
		    let before = linkUrl.substring(0, idx + 1);
		    let after = linkUrl.substring(idx + 1).replace(/\?/g, "&");
		    linkUrl = before + after;
		  }
		
		  const params = new URLSearchParams(linkUrl.substring(linkUrl.indexOf("?") + 1));
		  const itemID = params.get("itemID");
		  
		  let rowData;
		  grid.data.forEach(function(row){
		    if (row.ItemID == itemID) {
		      rowData = row;
		    }
		  });
		  
		  const accRight = await getItemAccRight(itemID);
			
		  if (accRight == "Y") {
		    if (rowData) {
		      clickItemEvent(rowData.ItemID, rowData.AuthorID, rowData.Status, accRight);
			  } else {
			    alert("${WM00033}");
			  }
		  }
		  else {
			    alert("이 문서를 볼 수 있는 권한이 없습니다.");
			    document.getElementById("processList").classList = "";
			    doSearchList();
			  }
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
	
	
	// Clear btn.
	function clearSearchCon() {
		$("#appendDiv").empty();

		// 기본정보 상세
		$("#ZAT04004").val(''); //문서번호
		$("#ZAT04005").val('');	// 보고제목
		$("#itemName").val('');
		$("#keyWord").val('');
		$("#totalInfo").val('');
		
		$("#ZAT01010").val('');	// Site
		$("#ZAT03260").val('');	// 공정	
		$("#authorName").val('');// 작성자
		
		//$("#ZAT04003").val('');	// 문서목적
		$("#ZAT04003 option").prop("selected", false); 
		$(".selected").removeClass("selected");
		$(".CaptionCont.SlectBox span").text('');

		//$("#ZAT04006").val(''); // Model	
		$("#ZAT04006 option").prop("selected", false); 
		$(".selected").removeClass("selected");
		$(".CaptionCont.SlectBox span").text('');
		
		$("#ZAT03070").val('');	// 등록기간
		$("#SC_STR_DT1").val('');
		$("#SC_END_DT1").val('');

	}
	
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
			$("#layout").attr("style","height:"+(setWindowHeight() - 281)+"px;");
   
	}

	function doNameSearchList() {
		doSearchList();
	}
	
	function fnItemMenuReload(){
		urlReload();
	}
	
	function fnChangeMenu(menuID,menuName) {
		if(menuID == "management"){
			parent.fnGetMenuUrl("${s_itemID}", "Y");
		}
	}
	//cop_hdtitle
	
	/*공통등록*/
	function fnCreateTER(){
		var url = "processItemInfo.do";
		var data = "&itemEditPage=custom/sk/skon/item/ter/createTERInfo&accMode=DEV&scrnMode=N&option=${option}&screenOption=C"
					+"&curItemID=${s_itemID}"
 					+"&defDimValueID=${defDimValueID}"
					+"&selectedTreeID=${s_itemID}&fixedDimValueID=${fixedDimValueID}";	
		var target = "myItemList";

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
			if(col.id != "CHK" ) {
				if(col.id == "Link" ) {
					copyTERItemDetail(row.ItemID, row.AuthorID, row.Status, accRight);			
				}
				else {
					clickItemEvent(row.ItemID, row.AuthorID, row.Status, accRight);			
				}
			}
		} else {
			alert("${WM00033}")
		}
	}
	
	
	function fnZAT03260Change(value){ //ZAT03260 공정(기술보고서)
		var url    = "getSearchSelectOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&sqlID=common_SQL.getSubLovList_commonSelect&lovCode="+value; //파라미터들
		var target = "ZAT01051";            // selectBox id
		var defaultValue = "";              // 초기에 세팅되고자 하는 값
		var isAll  = "no";    // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxMultiSelect(url, data, target, defaultValue, isAll);
		//setTimeout(changeZAT04003,1000);
	}
	
// 	function changeZAT04003(){
// 		$("#ZAT04003")[0].sumo.reload();
// 	}
	
	function handleSelectChange() {
		const docSearch = document.getElementById('docSearch').value;

	    if (docSearch === 'AT00001') {//문서명
	    	document.getElementById('totalInfo').type ="hidden";
	    	document.getElementById('keyWord').type="hidden";
	    	document.getElementById('itemName').type="text";
	    }else if(docSearch ==='AT01007'){//키워드
	    	document.getElementById('totalInfo').type ="hidden";
	    	document.getElementById('itemName').type="hidden";
	    	document.getElementById('keyWord').type="text";
	    }else{ //통합
	    	document.getElementById('itemName').type="hidden";
	    	document.getElementById('keyWord').type="hidden";
	    	document.getElementById('totalInfo').type ="text";
	    }
	 }
	
	
	function reloadItem() {
		parent.olm.getMenuUrl(document.getElementById("processList").dataset.id,'','',parent.olm.menuTree.getSelectedItemText());
	
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

	 
	function editCheckedAllItems(avg){
		var selectedCell = grid.data.findAll(function (data) {
	        return data.CHK;
	    });
		if(!selectedCell.length){
			alert("${WM00023}");
			return false;
		}
		var items = new Array();	
		var classCodes = new Array();
		for(idx in selectedCell){
			items.push(selectedCell[idx].ItemID);
		  	classCodes.push(selectedCell[idx].ClassCode);
		};
		
		if (items != "") {
			$("#items").val(items);
			if (avg == "Attribute2") {
				var url = "selectAttributePop.do";
				var data = "items="+items+"&classCodes="+classCodes; 
			    var option = "dialogWidth:400px; dialogHeight:250px;";
			    window.open("", "selectAttribute2", "width=400, height=350, top=100,left=100,toolbar=no,status=no,resizable=yes");
				$("#classCodes").val(classCodes);
			    document.processList.action=url;
			    document.processList.target="selectAttribute2";
			    document.processList.submit();
			    
			}else if (avg == "Attribute") {
				var url = "selectAttributePop.do";
				var data = "classCodes="+classCodes+"&items="+items; 
			    var option = "dialogWidth:400px; dialogHeight:250px;";		
			   
			    var w = "400";
				var h = "350";
				$("#classCodes").val(classCodes);
			    window.open("", "selectAttribute", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
			    document.processList.action=url;
			    document.processList.target="selectAttribute";
			    document.processList.submit();
				    
			} else  if (avg == "Owner") {			    
			    var url = "selectOwnerPop.do"; 
			    var option = "width=550, height=350, left=300, top=300,scrollbar=yes,resizble=0";
			    window.open("", "SelectOwner", option);
			    document.processList.action=url;
			    document.processList.target="SelectOwner";
			    document.processList.submit();
			} 
		 }
	}
	
	// callback - editCheckedAllItems('Owner')
	function urlReload() {
		doSearchList();
	}
	
	function openImagePopup() {
	    fetch("/setPopupToken.do")
	      .then(() => {
	        let w = 1600, h = 950;
	        window.open("zSKON_openImagePopup.do", "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	      });
	}
	
	async function getAttrLovList(attrTypeCode){		
		let param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
							+"&sqlID=attr_SQL.selectAttrLovOption"
							+"&attrTypeCode="+attrTypeCode;
		
		fetch("/olmapi/getLovValue/?"+param)	
		.then(res => res.json())
		.then(res => {
			let lovHtml = "";
			lovHtml += "<option value=''>Select</option>"
			for(var i=0; i < res.data.length; i++) {
				lovHtml += '<option value="'+res.data[i].CODE+'">'+res.data[i].NAME+'</option>';
			}
			
// 			document.querySelector("#"+attrTypeCode).innerHTML = lovHtml;
			const selectEl = document.querySelector("#" + attrTypeCode);
			selectEl.innerHTML = lovHtml;
			
			if (selectEl.sumo) {
				selectEl.sumo.unload(); // 제거
			}

			$('#' + attrTypeCode).SumoSelect({
				placeholder: 'Select',
				okCancelInMulti: true,
				csvDispCount: 2,
				maxHeight: 200,
				forceCustomRendering: true,
				parentWidth: 90
			});
			
		});
	}
	
// 	async function getLovListByItemType(attrTypeCode) {
// 		const res = await fetch("/olmapi/skAttrLovList/?itemTypeCode=OJ00012&attrTypeCode="+attrTypeCode);
// 		const data = await res.json();
// 		return data;
// 	}


	
</script>
</head>
<body>
<form name="processList" id="processList" action="#" method="post"  onsubmit="return false;" class="pdL10 pdR10" data-id="${s_itemID}" style="height: 100%;overflow: auto;">
	<input type="hidden" id="searchKey" name="searchKey" value="Name">
	<input type="hidden" id="currPage" name="currPage" value="${currPage}"></input>
	<input type="hidden" id="defaultLang" name="defaultLang" value="${defaultLang}">
	<input type="hidden" id="attrIndex" value="0">
	<input type="hidden" id="multiSearch" value="N">
	<input type="hidden" id="accMode" name="accMode" value="${accMode}" />
	<input type="hidden" id="items" name="items" />
	<input type="hidden" id="classCodes" name=classCodes />
	<input type="hidden" id="linkUrl" name="linkUrl" value="${linkUrl}">
	
	
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

	<div align="center">
		<table style="table-layout:fixed;display:none;" border="0" cellpadding="0" cellspacing="0" class="tbl_search"  id="mSearch">
			<colgroup>
				<col width="10%">
				<col width="15%">
				<col width="10%">
				<col width="10%">
				<col width="10%">
				<col width="15%">
				<col width="10%">
				<col width="15%">
				<col width="10%">
				<col width="15%">
			</colgroup>
					
			 <tr>
			 	<!-- 문서번호 --> <!-- identifier -->
			 	<th class="viewtop alignl">${menu.ZLN0068}</th>
				<td class="viewtop alignl"><input type="text" id="ZAT09006" name="ZAT09006" class="stext" ></td> <!-- 이쪽은 자동채번 문서번호가 들어갈 예정 -->
			
				<!-- 보고제목 --> <!-- Name -->
				<th  style="" class="viewtop alignl" >${menu.ZLN0151}</th>
				<td class="viewtop alignl" colspan=5 style="width:100%; margin-right: 8px;">
					 <div style="display: inline-block;">
					   <select id="docSearch" name="DocSearch" style="width:100%;" onchange="handleSelectChange()">
						  <!-- 통합 / 보고제목 / 키워드 -->
						  <option value="total">${menu.ZLN0069}</option> <!-- 통합 --> 
						  <option value="AT00001">${menu.ZLN0151}</option> <!-- 보고제목 -->
						  <option value="AT01007">${menu.ZLN0070}</option> <!-- 키워드 -->
					 </select> 
					</div>
					<div style="display: inline-block; width:84%;"> <!-- doSearchList에 쓸것 -->
					    <input type="text" id="totalInfo" name="totalInfo" value="" class="stext" style="width:100%;"> <!-- 통합 --> 
						<input type="hidden" id="itemName" name="itemName" value="" class="stext" style="width:100%;"> <!-- 보고제목 -->
						<input type="hidden" id="keyWord" name="keyWord" value="" class="stext" style="width:100%;">   <!-- 키워드 -->
					</div> 
				</td>
			</tr> 
			
			<tr>
			 	<!-- Site -->
				<th class="viewtop alignl">${menu.ZLN0037}</th>
				<td class="viewtop alignl">
					<select id="ZAT01010" name="ZAT01010"style="width: 100%;display: inline-block;">
						<option value=''></option>
					</select>
				</td>
				
				<!-- 공정 -->
				<th class="viewtop alignl">${menu.ZLN0044}</th>
				<td class="viewtop alignl">
					<c:if test="${attrList != null && attrList != ''}">
						<c:forEach var="i" items="${attrList}">
							<c:if test="${i.AttrTypeCode eq 'ZAT03260'}"><c:set var="ZAT03260Name" value="${i.PlainText}" /><c:set var="ZAT03260Value" value="${i.LovCode}" /></c:if>
						</c:forEach>
						<c:choose>
							<c:when test="${ZAT03260Name != null && ZAT03260Name != ''}">
								<c:out value="${ZAT03260Name}" />
								<input type="hidden" id="ZAT03260" name="ZAT03260" value="${ZAT03260Value}" />
							</c:when>
							<c:otherwise>
								<select id="ZAT03260" name="ZAT03260" style="display: inline-block;" onchange="fnZAT03260Change(this.value)" class="stext">
									<option value=''></option>
								</select>
							</c:otherwise>
						</c:choose>
					</c:if>
				</td>
				
				<!-- 모델 --> <!-- select box 신규로 생성(ZAT04006)-->
				<th class="viewtop alignl">${menu.LN00125}</th>
				<td class="viewtop alignl">
					<select id="ZAT04006" name="ZAT04006" style="display: inline-block;" multiple="multiple">
						<option value=''>Select</option>
					</select>
				</td>
				
				<!-- 문서목적 --> <!-- ZAT04003 문서목적 신규 attr-->
				<th class="viewtop alignl">${menu.ZLN0152}</th>
				<td class="viewtop alignl">
					<select id="ZAT04003" name="ZAT04003" style="display: inline-block;" multiple="multiple">
						<option value=''>Select</option>
					</select>
				</td>
						
				<!-- 작성자 -->
				<th class="viewtop alignl">${menu.LN00060}</th> 
				<td class="viewtop alignl"><input type="text" id=authorName name="authorName" class="stext"></td>
			</tr> 
			
			<tr>
				<!-- 등록기간 -->
				<th class="viewtop alignl">${menu.ZLN0153}</th>
				<td class="viewtop alignl" colspan=5 style="width:100%;">
	   				<font><input type="text" id="SC_STR_DT1" name="SC_STR_DT1" value=""	class="input_off datePicker stext" size="8"
						style="width: 150px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</font>
						~
					<font><input type="text" id="SC_END_DT1"	name="SC_END_DT1" value="" class="input_off datePicker stext" size="8"
						style="width: 150px;" onchange="this.value = makeDateType(this.value);"	maxlength="10">
					</font>
   				</td>  
			</tr> 

			</table>
			 <ul>
				<li id="buttonGroup" class="floatC mgR20 mgT5" style="display:none;">
					<input id="btnSearch" type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" style="cursor:pointer;">
					&nbsp;<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="cursor:pointer;" onclick="clearSearchCon();">
				</li>
			</ul>
	</div>	
	
		<div id="proDiv" style="overflow:auto;">
		   <div class="countList pdT10"> <!-- Total & 버튼들 -->
			       <!-- total -->
			       <ul>
			        <li class="count"><input type="image" id="frame_sh" class="frame_show" alt="${WM00158}" src="${root}${HTML_IMG_DIR}/btn_frame_show.png" value="Clear" style="cursor:pointer;width:20px;height:15px;margin-right:5px;" onclick="fnHideSearch();">Total  <span id="TOT_CNT"></span></li>
			        <li class="floatR">
			        	<!--  &nbsp;<span class="btn_pack small icon"><span class="move"></span><input value="Guide" type="submit" id="add" onClick="openImagePopup()"></span>  Guide 버튼이 필요한지 확인하고 주석풀기 -->
						<%-- <c:if test="${myItem == 'Y'}">
			        	 &nbsp;<span class="btn_pack small icon"><span class="gov"></span><input value="Gov" type="submit" id="gov" onClick="editCheckedAllItems('Owner')"></span>
			        	</c:if>  --%>
						<c:if test="${s_ClassCode eq 'CL12006'}"> 
						 &nbsp;<span class="btn_pack small icon"><span class="add"></span><input value="Create" type="submit" id="add" onClick="fnCreateTER()"></span>
						</c:if>
						 &nbsp;<span class="btn_pack small icon" style="display:inline-block;"><span class="down"></span><input value="Down" type="submit" id="excel"></span> 
					<!--<button class="cmm-btn mgR5" style="height: 30px;" onclick="fnGridExcelDownLoad()" value="Down">Download List</button>-->
						&nbsp;&nbsp;&nbsp;&nbsp;
			        </li>
			        </ul>
		   	</div>
		</div>
		<div style="width: 100%;"id="layout" style="width:100%;"></div>
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
	
	var gridData = [];
	var grid = new dhx.Grid("null", {
		 columns: [
			// No / 문서번호 / Site / 공정 / 보고제목 / 문서목적 / 적용모델
			{ width: 50, id: "RNUM", header: [{ text: "${menu.LN00024}", align: "center" }], align: "center" },
			{ width: 50, id: "Link", header: [{ text: "Link", align: "center" }], align: "center",htmlEnable: true,
				template: function (value,row) {
					  return '<button>Link</button>';
				}
			},
	        {  width: 150, id: "Identifier", header: [{ text: "${menu.ZLN0068}", align: "center" }, { content: "inputFilter" }], align: "center" },
			{ width: 100, id: "Site", header: [{ text: "${menu.ZLN0037}" , align: "center" }, { content: "selectFilter" }], align: "center" },
	        { width: 100, id: "ZAT03260", header: [{ text: "${menu.ZLN0044}", align: "center" }, { content: "selectFilter" }], align: "center" },
			{  id: "ItemName", header: [{ text: "${menu.ZLN0151}" , align: "center" }, { content: "inputFilter" }], align: "left" },
	        {  width: 100, id: "ZAT04003", header: [{ text: "${menu.ZLN0152}", align: "center" }], align: "left" },
	        {  width: 100,id: "ZAT04006", header: [{ text: "${menu.ZLN0124} ${menu.LN00125}", align: "center" }], align: "center" },
	        {  width: 100,id: "Name", header: [{ text: "${menu.LN00004}", align: "center" }, { content: "selectFilter" }], align: "center" },
	        {  width: 100,id: "OwnerTeamName", header: [{ text: "${menu.ZLN0074}", align: "center" }, { content: "selectFilter" }], align: "center" },
	        {  width: 50,id: "Version", header: [{ text: "${menu.ZLN0154}.", align: "center" }, { content: "selectFilter" }], align: "center" },
	        {  width: 100,id: "StatusName", header: [{ text: "${menu.LN00027}", align: "center" }, { content: "selectFilter" }], align: "center" },
	        {  width: 100,id: "CompletionDT", header: [{ text: "${menu.LN00078}", align: "center" }], align: "center" },

	        {  width: 150,id: "Description", header: [{ text: "${menu.ZLN0162}", align: "center" }], align: "left" },
	        {  width: 100,id: "KeyWord", header: [{ text: "${menu.ZLN0070}", align: "center" }], align: "center" },
	        {  width: 90,id: "firstAuthorName", header: [{ text: "${menu.ZLN0163}", align: "center" }], align: "center" },
	        {  width: 100,id: "firstCompletionDT", header: [{ text: "${menu.ZLN0164}", align: "center" }], align: "center" },
	        {  width: 100, id: "ItemID", header: [{ text: "itemid", align: "center" }], align: "center" }
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData
	});
	layout.getCell("a").attach(grid);
	$("#TOT_CNT").html(grid.data.getLength());
	
	//hidden 컬럼 - 엑셀 다운로드시 보임 (itemID 제외)
	grid.hideColumn("Description");
	grid.hideColumn("KeyWord");
	grid.hideColumn("firstAuthorName");
	grid.hideColumn("firstCompletionDT");
	//grid.hideColumn("ItemID");
	
	var pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: Math.floor((setWindowHeight() - 281) / 30),
	});
	

	grid.events.on("cellClick", function(row, column, e) {
		gridOnRowSelect(row,column);
	});
	


	function copyTERItemDetail(itemID, authorID, status, accRight){
		 var defArcCode = "ter";
		 var baseDomain = "http://localhost:8091"; //skon 도메인으로 변경
		 
		 var fullUrl = baseDomain 
			        + "?defArcCode=" + defArcCode
			        + "?itemID=" + itemID

		 navigator.clipboard.writeText(fullUrl).then(function() {
		        alert("해당 상세페이지 URL이 복사되었습니다.");
		    }).catch(function(err) {
		        console.error("URL 복사 실패:", err);
		    });
	}


	
	$("#excel").click(function(){
		grid.hideColumn("Link");
		grid.showColumn("Description");
		grid.showColumn("KeyWord");
		grid.showColumn("firstAuthorName");
		grid.showColumn("firstCompletionDT");
		
		fnGridExcelDownLoad('','','skon_Business Process List');
		
		grid.hideColumn("Description");
		grid.hideColumn("KeyWord");
		grid.hideColumn("firstAuthorName");
		grid.hideColumn("firstCompletionDT");
	});


	function doSearchList(){
		if($("#SC_STR_DT1").val() != "" && $("#SC_END_DT1").val() == "")		$("#SC_END_DT1").val(new Date().toISOString().substring(0,10));

		const SC_STR_DT1 = document.getElementById("SC_STR_DT1").value;
		const SC_END_DT1 = document.getElementById("SC_END_DT1").value;

		if(SC_STR_DT1 && SC_END_DT1 && SC_STR_DT1 > SC_END_DT1) {
			alert("${WM00132}");
			return;
		}
		
		$('#loading').fadeIn(150);
		let siteCode = "";
		var sqlID = "zSK_SQL2.getTERList";
		let defClassList = "";
		"${defClassList}".split(",").forEach(e => {defClassList += defClassList === "" ?  "'"+e+"'" : ",'"+e+"'"});
		var param = "";
		param += "&LanguageID=${sessionScope.loginInfo.sessionCurrLangType}&defClassList="+defClassList
		+ "&sqlID="+sqlID
		+"&pItemID=${s_itemID}";	//pItemID 필요한지 확인해보기
		
		param += "&L2ItemID="+ L2ItemID;			

		
		param += "&ZAT09006="+$("#ZAT09006").val().trim(); //문서 번호
		// 보고제목
		param += "&totalInfo="+$("#totalInfo").val().trim();
		param += "&itemName="+$("#itemName").val();	
		param +="&keyWord="+$("#keyWord").val();
		
		param += "&ZAT01010="+$("#ZAT01010").val(); // Site
		param += "&ZAT03260="+$("#ZAT03260").val(); // 공정
		
// 		param += "&ZAT04003="+$("#ZAT04003").val(); // 문서목적
//		param += "&ZAT04006="+$("#ZAT04006").val(); // 적용 모델
		param += "&authorName="+$("#authorName").val(); // 작성자
		
		param += "&SC_STR_DT1="+$("#SC_STR_DT1").val();
		param += "&SC_END_DT1="+$("#SC_END_DT1").val();
		
		if ($("#ZAT04003").val()) {
				var array = new Array();
				$("#ZAT04003 :selected").each(function(i, el){ 
					var temp = $(el).val(); 
				
					if (temp != "" && "nothing" != temp && "Nothing" != temp) {
						array.push(temp);
						nothing = "&nothingZAT04003=";
					} else if("nothing" == temp || "Nothing" == temp) {
						nothing = "&nothingZAT04003=Y";
					}
	
				}); 	
				param += "&ZAT04003OLM_ARRAY_VALUE=" + array;
				
			}
		
		if ($("#ZAT04006").val()) {
			var array = new Array();
			$("#ZAT04006 :selected").each(function(i, el){ 
				var temp = $(el).val(); 
			
				if (temp != "" && "nothing" != temp && "Nothing" != temp) {
					array.push(temp);
					nothing = "&nothingZAT04006=";
				} else if("nothing" == temp || "Nothing" == temp) {
					nothing = "&nothingZAT04006=Y";
				}

			}); 	
			param += "&ZAT04006OLM_ARRAY_VALUE=" + array;
			
		}
		

		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadGrid(result);
				$('#loading').fadeOut(150);
			},error:function(xhr,status,error){
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
