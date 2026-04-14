<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!DOCTYPE html>
<html>
<head>
<!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>

<c:choose>
	<c:when test="${isPopup == 'true'}">
		<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
	</c:when>
	<c:otherwise>
		<script src="${root}cmm/js/tinymce_v7/tinymce.min.js" type="text/javascript"></script>
	</c:otherwise>
</c:choose>


<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<%-- <script src="${root}cmm/js/jquery/jquery.timepicker.min.js" type="text/javascript"></script>  --%>
<script src="${root}cmm/js/jquery/jquery.timepicker.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/jquery.timepicker.css"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00016" var="CM00016"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00054" var="CM00054"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00056" var="CM00056"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00274}"/> <!-- 도메인 입력 체크 -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00185}"/> <!-- 시스템 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="${menu.LN00272}"/> <!-- 카테고리 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_4" arguments="${menu.LN00273}"/> <!-- 서브카테고리 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_6" arguments="Comment"/> <!-- Comment 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_7" arguments="${menu.LN00221}"/> <!-- 완료예정일  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00063" var="CM00063"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00042" var="CM00042"/>


<!-- 임시저장이 아닌경우에만 실행 -->
<c:if test="${fn:trim(srInfoMap.isPublic) ne '0' && !empty srInfoMap.Description}">
	<script type="text/javascript">
		var chkReadOnly = true;
	</script>
	<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>
</c:if>	

<script type="text/javascript">
	var fileSize = "${itemFiles.size()}";
	var scrnType = "${scrnType}";
	var srType = "${srType}";
	var srArea1ListSQL = "${srArea1ListSQL}";
	var customerNo = "${srInfoMap.ClientID}";
	var srAre1 = "${srInfoMap.SRArea1}";
	var inProgressWf = false;
	let blockEnter = false;
	// select list 용 parameter
	var selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&esType=${esType}&customerNo=" + customerNo;
	
	// API Setting
	fnSRProcStatusListLoad(); // 진행 상태
	fnSRAttachFileListLoad(); // 첨부파일
	fnSRActivityStatusNameLoad(); // 단계 진행 상태
	fnSRgetWorkerRecordCountLoad(); // 역할 및 실적 count
	fnGetDlmWFStatus(); // 결재정보
	
	jQuery(document).ready(function() {
		// 00. input type setting
		$("input.datePicker").each(generateDatePicker);
		$('#dueDateTime').timepicker({
            timeFormat: 'H:i:s',
        });
		
		// 01. select option setting
		if(srArea1ListSQL == null || srArea1ListSQL == "") srArea1ListSQL = "getESMSRArea1";
		fnSelectSetting();
		
  		// 02. category change event
  		$("#category").on("change", function(){
  			var category = $("#category").val();
  			fnGetSubCategory(category);
  		});
  		
  		// 03. subCategory change event
  		$("#subCategory").on("change", function(){
  			var subCategory = $("#subCategory").val();
  			//fnGetSRArea1(subCategory);
  		});

  		// 04. srArea1 change event
  		$("#srArea1").on("change", function(){
  			var srArea1 = $("#srArea1").val();
  			fnGetSRArea2(srArea1);
  		});
  		
  		// 05. load sub tab
  		var firstTab = $('#subTabs li:first').data('index');
  		if("${srInfoMap.Blocked}" === "1"){ // 만족도 조사 단계일 경우
  			loadTabPage(5);
  		} else {
	  		loadTabPage(firstTab);
  		}
  		
  		<c:if test="${sessionScope.loginInfo.sessionAuthLev eq 1 && srInfoMap.Blocked ne '2'}">
  			getDicData("BTN", "LN0012").then(data => fnSetButton("force-quit" ,"", data.LABEL_NM, "secondary"));
  		</c:if>
  		
  		<c:if test="${fn:trim(srInfoMap.isPublic) eq '0' && sessionScope.loginInfo.sessionUserId.equals(srInfoMap.RegUserID)}">
  			getDicData("BTN", "LN0013").then(data => fnSetButton("delete-sr" ,"", data.LABEL_NM, "secondary"));
  			getDicData("BTN", "LN0014").then(data => fnSetButton("save-sr" ,"", data.LABEL_NM, "primary"));
  		</c:if>
  		
  		// TODO : 담당자 정보 표시
		let layerWindow = $('.item_layer_photo');
		const layerPop = document.querySelectorAll(".layer-pop");
		layerPop.forEach(e => {
		   e.addEventListener("click", function () {
				layerWindow.removeClass('open');
		       var pos = $(e).offset().top;
				LayerPopupView(e, 'layerPopup', pos);
			   loadUserInfo(e.dataset.memberid);
		   })
		})
		
		// 화면 스크롤시 열려있는 레이어 팝업창을 모두 닫음
		if("${isPopup}" === "false") {
			document.querySelector(".load-page-wrapper").addEventListener("scroll", function() {
				if(document.querySelector("#layerPopup")?.classList.contains("open")) document.querySelector("#layerPopup").classList.remove("open");
		    })
		}
		
		// 레이어 팝업 닫기
		$('.popup_closeBtn').click(function(){
			layerWindow.removeClass('open');
		});
		
		
		let imgPath = "";
		function loadUserInfo(memberID) {
			if(memberID) {
				$('#loading').fadeIn(150);
				fetch("/userInfo.do?memberID="+memberID, {})
				.then(res => res.json())
				.then(data => {
					imgPath =  (data.userInfo.Photo === "blank_photo.png") ? "<%=GlobalVal.HTML_IMG_DIR%>" : "<%=GlobalVal.EMP_PHOTO_URL%>";
					document.querySelector("#author_photo").innerHTML = "<img src='"+imgPath+data.userInfo.Photo+"' style='width:60px;height:60px;'>";
					document.querySelector("#author_name").innerText = data.userInfo.UserName;
					document.querySelector("#author_employeeNum").innerText = data.userInfo.EmployeeNum;
					document.querySelector("#author_userNameEN").innerText = data.userInfo.UserNameEN;
					document.querySelector("#author_ownerTeamName").innerText = data.userInfo.OwnerTeamName;
					document.querySelector("#author_teamName").innerText = data.userInfo.TeamName;
					document.querySelector("#author_email").innerText = data.userInfo.Email;
					document.querySelector("#author_telNum").innerText = data.userInfo.TelNum;
					document.querySelector("#author_mTelNum").innerText = data.userInfo.MTelNum;
				
					$('#loading').fadeOut(150);
					layerWindow.addClass('open');
				})
			}
		}
		
		getDicData("GUIDELN", "ZLN0004").then(data => document.querySelector(".tooltip").insertAdjacentText("beforeend",data.LABEL_NM));
	});
	
	/*** SR Select function start ***/
	function fnSelectSetting() {
		// 00. reset
		resetSelect();
		// 01. category setting
		fnSelect('category', selectData +"&srType=${srType}&level=1", 'getESPSRCategory', '${srInfoMap.Category}', 'Select','esm_SQL');
		fnGetSubCategory('${srInfoMap.Category}');
		// 02. srArea
		fnGetSRArea1('${srInfoMap.Category}');
		fnGetSRArea2('${srInfoMap.SRArea1}')
	}

	// subCategory setting ( * customerNo / category )
	function fnGetSubCategory(parentID){
		if(parentID == ''){
			$("#subCategory option").not("[value='']").remove();
		} else {
			fnSelect('subCategory', selectData + "&srType=${srType}&parentID="+parentID, 'getESPSRCategory', '${srInfoMap.SubCategory}', 'Select', 'esm_SQL');
		}
	}
	
	// srArea1 setting ( * customerNo / subCategory )
	function fnGetSRArea1(category){
		if(category == ''){
			$("#srArea1 option").not("[value='']").remove();
		}else{
			fnSelect('srArea1', selectData + "&category=" + category + "&srType=${esType}", srArea1ListSQL, '${srInfoMap.SRArea1}', 'Select','esm_SQL');
			fnGetSRArea2('');
		}
	}
	
	// srArea2 setting ( * customerNo / srArea1 )
	function fnGetSRArea2(SRArea1ID){
		if(SRArea1ID == ''){
			$("#srArea2 option").not("[value='']").remove();
		}else{
			fnSelect('srArea2', selectData+ "&parentID="+SRArea1ID + "&srType=${esType}", 'getSrArea2','${srInfoMap.SRArea2}', 'Select');
		}
	}
	
	// select option reset
	function resetSelect(){
		$("#srArea1").val("");
		$("#srArea2").val("");
		$("#category").val("");
		$("#subCategory").val("");
		return;
	}
	/*** SR Select function end ***/
	
	/*** SR Button function start ***/
	var searchData = "&searchSrType=${searchSrType}"
					+"&esType=${esType}"
					+"&scrnType=${scrnType}"
					+"&srMode=${srMode}"
					+ "&searchStatus=${searchStatus}"
					+ "&category=${category}"
					+ "&subCategory=${subCategory}"
					+ "&srAreaSearch=${srAreaSearch}"
					+ "&srArea1=${srArea1}"
					+ "&srArea2=${srArea2}"
					+ "&subject=${subject}"
					+ "&receiptUser=${receiptUser}"
					+ "&requestUser=${requestUser}"
					+ "&requestTeam=${requestTeam}"
					+ "&regStartDate=${regStartDate}"
					+ "&regEndDate=${regEndDate}"
					+ "&searchSrCode=${searchSrCode}"
					+ "&stSRDueDate=${stSRDueDate}"
					+ "&endSRDueDate=${endSRDueDate}"
					+ "&srReceiptTeam=${srReceiptTeam}"
					+ "&searchStatus=${searchStatus}"
					+ "&srStatus=${srStatus}"
					+ "&srCode=${srCode}"
					+ "&srArea1ListSQL=${srArea1ListSQL}"
					+ "&inProgress=${inProgress}"
					+ "&stSRCompDT=${stSRCompDT}"
					+ "&endSRCompDT=${endSRCompDT}"
					+ "&customerNo=${customerNo}"
					+ "&completionDelay=${completionDelay}"
					+ "&svcType=${svcType}"
					+ "&requestUser=${requestUser}"
					+ "&requestUserID=${requestUserID}"
					+ "&actorName=${actorName}"
					+ "&actorID=${actorID}"
					+ "&returnMenuId=${returnMenuId}";
	
	// [LIST]
	function fnGoSRList(){
		let result = loadBySelectedIndex();
		var target = "mainLayer"; 
		ajaxPage(result.url+".do", result.filter+searchData, target);
	}
	
	const html = "<div class='new-form'><textarea id='activityComment' class='edit pdB10 pdL10 pdR10 pdT10' style='width: 100%;height: 200px;resize: none;'></textarea><div class='floatR btns mgT15'><button id='forceQuitSave'></button></div></div>";
	const dhxWindow = new dhx.Window({
	    width: 440,
	    height: 360,
	    title: "Confirm Message",
	    modal: true,
	    closable: true,
	});
	dhxWindow.attachHTML(html);

	// [강제종료]
	function fnForceQuit(){
		dhxWindow.show();
		if(!document.getElementById("forceQuitSave").classList.contains("primary")) getDicData("BTN", "LN0014").then(data => fnSetButton("forceQuitSave", "", data.LABEL_NM));
		
		$("#forceQuitSave").on("click",function(){
			if (confirm("${CM00042}")) {
				var data = "srID=${srInfoMap.SRID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&activityComment=" + $("#activityComment").val();
				var url = "forceQuitESP.do";
				var target = "saveFrame";
				ajaxPage(url, data, target);
			}
		});
	}
	
	// [티켓 임시저장]
	function fnSaveTempSR(){
		if (confirm("${CM00001}")) {
			
			saveActivity();
			
			var paramData = new FormData();
			var srID = "${srInfoMap.SRID}";
			paramData.append("srID", srID);
			paramData.append("subject", $("#subject").val());
			paramData.append("reqdueDate", $("#reqdueDate").val());
			<c:if test="${!empty srInfoMap.Description}">
				var desc = tinyMCE.get('description').getContent();
				paramData.append("description", desc);
			</c:if>
			
			var url = "saveSRActivityResult.do";
			var target = "saveFrame";
			$.ajax({
			    url: url,
			    type: 'post',
			    data: paramData,
			    processData: false,
			    contentType: false,
			    async: true,
			    error: function (xhr, status, error) {
			        alert(status + "||" + error);
			        $('#loading').fadeOut(150);
			    },
			    beforeSend: function (x) {
			        $('#loading').fadeIn(150);
			        if (x && x.overrideMimeType) {
			            x.overrideMimeType("application/html;charset=UTF-8");
			        }
			    },
			    success: function (data) {
			        $('#loading').fadeOut(10);
			        alert("${WM00067}");
			        fnCallBackSR();
			    }
			});
		}
	}
	
	/*** SR Button function end ***/

	/*** SR callback function start ***/
	function fnCallBackSR(){
		inProgressWf = false;
		blockEnter = false;
		dhxWindow.hide();
		$('#loading').fadeOut(150);
		if("${isPopup}" === "true") {
			location.reload();
		} else {
			var url = "esrInfoMgt.do";
			var data = searchData += "&srID=${srInfoMap.SRID}&receiptUserID=${srInfoMap.ReceiptUserID}&isPopup=${isPopup}";
			var target = "mainLayer";
			ajaxPage(url, data, target);
		}
	}
	
	function fnReload(){
		fnCallBackSR();
	}
	
	function fnCallBack(){
		fnCallBackSR();
	}
	
	function fnOutCallBack(srID,srType,isPopup){
		var url = "esrInfoMgt.do";
		
		if("${isPopup}" === "true") {
			var data = "?srID=" + srID + "&srType=" + srType + "&isPopup=" + isPopup;
			location.href = url + data;
		} else {
			var data = "&srID=" + srID + "&srType=" + srType + "&isPopup=" + isPopup;
			var target = "mainLayer";
			ajaxPage(url, data, target);
		}
	}
	
	function fnViewScrDetail(scrID){
		var screenMode = "V";
		var url = "viewScrDetail.do";
		var data = "scrID="+scrID+"&screenMode="+screenMode+"&srID=${srInfoMap.SRID}"; 
		var w = 1100;
		var h = 800;
		window.open(url+"?"+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=yes,resizable=yes,scrollbars=yes");
		
		fnCallBackSR();
	}
	/*** SR callback function end ***/
	
	
	function getAttrLovList(avg, avg2, avg3){ 
		var url    = "getSelectOption.do"; // 요청이 날라가는 주소
		var data   = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
					+"&sqlID=attr_SQL.selectAttrLovOption" //파라미터들					
					+"&s_itemID="+avg
					+"&itemID=${s_itemID}";
					
		var target = avg; // avg;             // selectBox id
		var defaultValue = avg2;              // 초기에 세팅되고자 하는 값
		var isAll  = "";                      // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		ajaxSelect(url, data, target, defaultValue, isAll);
	}
	
	function fnSearchMemberPop(attrTypeCode){

		var url = "selectMemberPop.do?mbrRoleType=ATTRMBR&projectID=${projectID}&attrTypeCode="+attrTypeCode;
		window.open(url,"","width=900 height=700");					
	}
	
	function setAttrMbr(memberIds,memberNames,teamIds,attrTypeCode) {
		$("#"+attrTypeCode+"_Text").val(memberNames);
		$("#"+attrTypeCode).val(memberIds);
	}
	
	function loadTabPage(index) {
		let url, data = "&isPopup=${isPopup}&srID=${srInfoMap.SRID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&srType=${srInfoMap.SRType}&speCode=${srInfoMap.Status}&docCategory=${srInfoMap.DocCategory}";
		// 선택된 메뉴에 class 추가
		const tabs = document.querySelectorAll(".tab");
		tabs.forEach(e => e.classList.contains("on") &&  e.classList.remove("on"));
		const clickedTab = document.querySelector(".tab[data-index='"+index+"']");
		clickedTab.classList.add("on");
		
		switch(index) {
			case 1:
				url = "srActivityResultMgt.do";
				break;
			case 2:
				data += "&dueDate=${srInfoMap.DueDate}&srCode=${srInfoMap.SRCode}&clientID=${srInfoMap.ClientID}";
				url = "espActivityLogList.do";
				break;
			case 3:
				url = "espWorkerRecordList.do";
				break;
			case 4:
				url = "espFileList.do";
				break;
			case 5:
				url = "viewEvSheet.do";
				data = "&tagYN=N&srID=${srInfoMap.SRID}&requestUserID=${srInfoMap.RequestUserID}&evalSheetID=${srInfoMap.EvalSheetID}&srType=${srInfoMap.SRType}&esType=${srInfoMap.ESType}&status=${srInfoMap.Status}";
				break;
			case 6:
				url = "serviceItemMgt.do";
				break;
			default:
		}
		
		ajaxPage(url, data, "loadTagPage");
	}
	
	function fnSRDetail(){
		var scrnType = "";
		var isPopup = "Y";
		var srID = "${srID}";
		var url = "processItsp.do?scrnType=${scrnType}&srID="+srID+"&isPopup="+isPopup+"&srType=${srInfo.SRType}";
		window.open(url,'','width=1100, height=800, left=200, top=100,scrollbar=yes,resizable=yes');
	}
	
	// 진행중 Activity  START ======================================================================================
	function fnWipActivity() {
	    var data = "srID=${srInfoMap.SRID}&docCategory=${srInfoMap.DocCategory}&speCode=${srInfoMap.Status}"
	    			+ "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
	    var url = "wipActivityMgt.do";
	    var target = "tabFrame";
	    
	    $.ajax({
	        type: "GET",
	        url: url,
	        data: data,
	        success: function(response) {
	        	fnGoWipActivity(response);
	        },
	        
	        error: function(xhr, status, error) {
	            console.error("에러 발생: ", error);
	        }
	    });
	}
	
	function fnGoWipActivity(url){
		var data = "srID=${srInfoMap.SRID}&docCategory=${srInfoMap.DocCategory}&srType=${srType}&esType=${esType}"
				 + "&evalSheetID=${srInfoMap.EvalSheetID}&requestUserID=${srInfoMap.RequestUserID}&speCode=${srInfoMap.Status}";
	    ajaxPage(url, data, "loadTagPage");
	}
	
	function fnCallbackActivity(){
		fnWipActivity();
	}
	
	// 진행중 Activity 설정  END  ======================================================================================
	
	
	// 요청정보 Fold
	function fnFolding() {
		const fold = document.querySelector("#fold");
		const info = fold.parentElement.parentElement.nextElementSibling;
		const tiny = info.nextElementSibling;
		const wf = tiny.nextElementSibling;
		
		const wrapper = fold.parentElement.parentElement.parentElement;
		
		const parentDiv = document.querySelector("#descTable td > div");
		
		if(fold.classList.contains("on")) {
			fold.classList.remove("on");
			info.style.display = "table";
			tiny.style.display = "table";
			wf.style.display = "table";
			wrapper.style.height = "auto";
			
			 removeTinyOverride();
			 if(parentDiv){
		            parentDiv.style.height = "232px";
		            parentDiv.style.minHeight = "";
		        }
		} else {
			fold.classList.add("on");
			info.style.display = "none";
			tiny.style.display = "none";
			wf.style.display = "none";
			wrapper.style.height = "30px";
			
			applyTinyOverride();
			// TinyMCE 위치한 부모 div도 강제로 줄임
	        if(parentDiv){
	            parentDiv.style.minHeight = "30px";
	            parentDiv.style.height = "30px";
	        }
		}
	}
	
	function applyTinyOverride() {
	    const style = document.getElementById("tinyOverrideStyle");
	    if (!style) {
	        const s = document.createElement('style');
	        s.id = "tinyOverrideStyle";
	        s.innerHTML = `
	            div:has(.tinymceText) {
	                min-height: 30px !important;
	                height: 30px !important;
	            }
	        `;
	        document.head.appendChild(s);
	    }
	}
	
	function removeTinyOverride() {
	    const style = document.getElementById("tinyOverrideStyle");
	    if (style) style.remove();
	}
	
	/* 담당자 정보를 popup창에 표시 : 명칭/조직경로/법인/직위/이메일/전화번호  */
	function LayerPopupView(sLinkName, sDivName, pos)  { 
		var oPopup = document.getElementById(sDivName);
		var oLink = sLinkName;
		var scrollTop = document.getElementById("processSRDIV").scrollTop;
		var nTop = 33;
		oPopup.style.top = (pos + nTop) + "px";    
		
		var isPopup = "${isPopup}";
		if(isPopup === "true"){
			oPopup.style.left = (oLink.offsetLeft) + "px";
		} else {
			oPopup.style.left = (oLink.offsetLeft + 255) + "px";
		}
		
	} 
	
	
	
	// API
	// 진행상태 호출 API
	function fnSRProcStatusListLoad() {
		fetch("/olmapi/getSRProcStatusList/?languageID=${languageID}&srID=${srID}&esType=${srInfoMap.ESType}&status=${srInfoMap.Status}")
		.then((response) => response.json())
		.then((data) => {
			
			 const htmlTd = document.getElementById('procStatusListTd');
			
		 	if (data.length > 0) {
		 		data.forEach((list, index) => {
	                const isMatch = list.TypeCode === "${srInfoMap.Status}";
	                const isLast = index === data.length - 1;

	                const span = document.createElement('span');
	                span.textContent = list.StsName;
	                span.style.fontWeight = isMatch ? 'bold' : '';
	                span.style.color = isMatch ? '#0761CF' : 'gray';
	                span.style.fontSize = isMatch ? '13px' : '';

	                htmlTd.appendChild(span);

	                if (!isLast) {
	                    const separator = document.createTextNode(' > ');
	                    htmlTd.appendChild(separator);
	                }
	            })
	        } else {
	        	htmlTd.textContent = "${srInfoMap.SRStatusName}";
	        }
		})
		.catch((error) => console.log("error:", error));
	}
	
	// 티켓 첨부파일 리스트 호출 API
	function fnSRAttachFileListLoad() {
		fetch("/olmapi/getSRAttachFileList/?srID=${srID}")
		.then((response) => response.json())
		.then((data) => {
			const htmlTr = document.getElementById('attachFileListTr');
			const htmlTbody = document.querySelector("tbody[name='sr-file-list']");
			
		 	if (data.length > 0) {
		 		
		 		htmlTr.style.display = "";
		 		
		 		data.forEach((list, index) => {
		 			const row = document.createElement('tr');
		 			row.innerHTML = `
	                    <td>
	                        <svg onclick="fileNameClick('` + list.Seq + `');" class="downloadable" xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 -960 960 960" width="20px" fill="#434343">
	                            <path d="M480-336 288-528l51-51 105 105v-342h72v342l105-105 51 51-192 192ZM263.72-192Q234-192 213-213.15T192-264v-72h72v72h432v-72h72v72q0 29.7-21.16 50.85Q725.68-192 695.96-192H263.72Z"/>
	                        </svg>
	                    </td>
	                    <td class="downloadable" onclick="fileNameClick('` + list.Seq + `');">` + list.FileRealName + `</td>
	                    <td class="alignR">` + textfileSize(list.FileSize,index) + `</td>
	                `;
	                htmlTbody.appendChild(row);
	            })
	        }
		})
		.catch((error) => console.log("error:", error));
	}
	
	// 파일 다운로드
	function fileNameClick(avg1){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var filePath = new Array();
		var seq = new Array();
		seq[0] = avg1;
		var url  = "fileDownload.do?seq="+seq+"&scrnType=SR";
		ajaxSubmitNoAdd(document.receiptSRFrm, url,"saveFrame");
	}
	
	function textfileSize(e, ind) {
		//document.querySelector("tbody[name='sr-file-list']").children[ind].children[2].innerHTML = getFileSize(e);
		if(e === '0') return '0'
		else return getFileSize(e);
	}
	
	// 티켓 Activity 상태 호출 API
	function fnSRActivityStatusNameLoad() {
		fetch("/olmapi/getActivityStatusName/?languageID=${languageID}&srID=${srID}&status=${srInfoMap.Status}")
		.then((response) => response.json())
		.then((data) => {
			const htmlTd = document.getElementById('activityStatusNameTd');
			if (data.activityStatusName && data.activityStatusName.trim() !== "") {
				htmlTd.innerText = data.activityStatusName.trim();
	        }
		})
		.catch((error) => console.log("error:", error));
	}
	
	// 역할 및 실적 count 호출 API
	function fnSRgetWorkerRecordCountLoad() {
		fetch("/olmapi/getWorkerRecordCount/?languageID=${languageID}&srID=${srID}")
		.then((response) => response.json())
		.then((data) => {
			const htmlLi = document.querySelector('#subTabs .tab[data-index="3"]');
			if (data.workerRecordCount > 0) {
				htmlLi.style.display = "";
	        }
		})
		.catch((error) => console.log("error:", error));
	}
	
	// 티켓 [삭제] -- 티켓 완전삭제. 임시저장 및 등록-접수전 만 가능
	async function fnDeleteSR(){
// 		let msg = "티켓을 삭제하시겠습니까? 삭제된 티켓은 복구할 수 없습니다.";
		let msg = "";
		await getDicData("ERRTP", "LN0009").then(data => msg = data.LABEL_NM);
		if(confirm(msg)){
			fetch('/deleteESP.do', {
	 			method: 'POST',
	 			body : JSON.stringify({srID : '${srInfoMap.SRID}'}),
	 			headers: {
	 				'Content-type': 'application/json; charset=UTF-8',
	 			},
	 		})
	 		.then((res) => res.json())
	 		.then((data) => {
	 			alert(data.message);
	 			
	 			var isPopup = "${isPopup}";
	 			if(isPopup === 'true'){
	 				opener.doSearchList('myToDo');	
	 				self.close();
	 			} else {
	 				fnGoSRList();
	 			}
	 			
	 		});
		}
	}
	
	// 전자결재 정보 호출 api
	function fnGetDlmWFStatus(){
		var defApprovalSystem = "${defApprovalSystem}";
		var YO_GW_VIEW_URL ="${YO_GW_VIEW_URL}";
		var url1 = "https://gw.daelimcloud.com/WebSite/Approval/Forms/Form.aspx?isLegacy=ECLICK&mode=PROCESS&pid=";
		var url2 = "https://gw.daelimcloud.com/WebSite/Approval/Forms/Form.aspx?isLegacy=ECLICK&mode=PROCESS&pid=";
		var sqlID = "zDLM_SQL.getDlmWFStatus";
		
		if(defApprovalSystem == "YO"){
			url1 = YO_GW_VIEW_URL + "/approval/approval_Form.do?mode="; // https://gw.youngonedev.com/approval/approval_Form.do?mode=TEMPSAVE&workitemID=&formID=680&forminstanceID=504206&Readtype=preview
			url2 = YO_GW_VIEW_URL + "/approval/approval_Form.do?mode=";
			sqlID = "zDLM_SQL.getWFStatusInfo";
		} else if(defApprovalSystem == "OLM"){
			sqlID = "esm_SQL.getWFItsmStatusInfo";
		}
		
		fetch("/olmapi/getDlmWFStatus/",{
 			method: 'POST',
 			body : JSON.stringify({srID : '${srInfoMap.SRID}' , languageID : '${sessionScope.loginInfo.sessionCurrLangType}'
 				                , srCode : '${srInfoMap.SRCode}', sqlID : sqlID, sessionUserId : '${sessionScope.loginInfo.sessionUserId}'}),
 			headers: {
 				'Content-type': 'application/json; charset=UTF-8',
 			},
 		})
		.then((res) => res.json())
		.then((data) => {
			
			var style = document.createElement('style');
			style.innerHTML = `
				#dlmWFStatusTable a:hover {
			    font-weight: bold;
			  }
			`;
			document.head.appendChild(style);
			
			data = data.wfStatusMap[0];
			
			if(data !== null && data !== undefined){
				
				$("#dlmWFStatusTable").show();
				
				var table = document.getElementById("dlmWFStatusTable");
				var row = table.rows[0]; // 첫 번째 행
				var firstTd = row.cells[1]; // 첫 번째 td
				var secondTd = row.cells[3]; // 두 번째 td
				var thirdTd = row.cells[5]; // 세 번째 td
				
				if(defApprovalSystem == "YO"){ // 영원무역 
					url1 = url1 + data.Mode1 + "&processID="+ data.ProcessID1 +"&workitemID=&formID=680&forminstanceID=" + data.PID1;
					url2 = url2 + data.Mode2 + "&processID="+ data.ProcessID2 +"&workitemID=&formID=681&forminstanceID=" + data.PID2;
				    
					let isMyProcRoleTPGroup1 = data.isMyProcRoleTPGroup1;
					let isMyRegion1 = data.isMyRegion1;
					let isMyProcRoleTPGroup2 = data.isMyProcRoleTPGroup2;
					let isMyRegion2 = data.isMyRegion2;
					
					// 요청부서 결재상태
					var rs1 = data.WFStatusNM1;
					if(rs1 !== undefined && rs1 !== null && rs1 !== ''){
						if(data.Status1 === "2" || data.Status1 === "3") rs1 += ' (' + data.WFActorName1 + ' ' + data.WFDate1 + ')';
						
						if (data.HasLink1 == "Y") {
					        firstTd.innerHTML =
					            '<a href="#"  onclick="return fnHandleClick(\'' + url1 + '\', \'' + isMyProcRoleTPGroup1 + '\',\''+isMyRegion1+'\');"' +
					            ' style="cursor:pointer;color:#0761cf;text-decoration:none;">' + rs1 + '</a>';
					    } else if(data.WFMsg1 != ""){
					    	firstTd.innerHTML = '<span style="color:#000;"  onclick="alert(\''+data.WFMsg1+'\')">' + rs1 + '</span>';
					    } else {
					    	firstTd.innerHTML = '<span style="color:#000;" >' + rs1 + '</span>';
					    }
					} else {
						firstTd.textContent = '-';
					}
					
					// 배포부서 결재상태
					var rs2 = data.WFStatusNM2;
					if(rs2 !== undefined && rs2 !== null && rs2 !== ''){
						if(data.Status2 === "2" || data.Status2 === "3") rs2 += ' (' + data.WFActorName2 + ' ' + data.WFDate2 + ')';
				        if (data.HasLink2 == "Y") {
				        	secondTd.innerHTML =
					            '<a href="#"  onclick="return fnHandleClick(\'' + url2 + '\', \'' + isMyProcRoleTPGroup2 + '\',\''+isMyRegion2+'\');"' +
					            ' style="cursor:pointer;color:#0761cf;text-decoration:none;">' + rs2 + '</a>';
					    } else if(data.WFMsg2 != ""){
					    	secondTd.innerHTML = '<span style="color:#000;"  onclick="alert(\''+data.WFMsg2+'\')">' + rs2 + '</span>';
					    } else {
					    	secondTd.innerHTML = '<span style="color:#000;" >' + rs2 + '</span>';
					    }
					} else {
						secondTd.textContent = '-';
					}
				}else if(defApprovalSystem == "OLM"){ // SFOLM		
					// 요청부서 결재상태
					var rs1 = data.WFStatusNM1;
					if(rs1 !== undefined && rs1 !== null && rs1 !== ''){
						if(data.Status1 === "2" || data.Status1 === "3") rs1 += ' (' + data.WFActorName1 + ' ' + data.WFDate1 + ')';
					
						firstTd.innerHTML = 
					        '<a href="javascript:void(0);" ' +
					        'onclick="fnEsrInfoWFDetail(\'' + data.WFInstanceID1 + '\', \'' + data.DocumentID1 + '\', \'' + data.WFActorID1 + '\')"  ' +
					        'style="cursor:pointer;color:#0761cf;text-decoration:none;">' 
					        + rs1 + 
					        '</a>';
					} else {
						firstTd.textContent = '-';
					}
					// 배포부서 결재상태
					var rs2 = data.WFStatusNM2;
					if(rs2 !== undefined && rs2 !== null && rs2 !== ''){
						if(data.Status2 === "2" || data.Status2 === "3") rs2 += ' (' + data.WFActorName2 + ' ' + data.WFDate2 + ')';
						secondTd.innerHTML = 
					        '<a href="javascript:void(0);" ' +
					        'onclick="fnEsrInfoWFDetail(\'' + data.WFInstanceID2 + '\', \'' + data.DocumentID2 + '\', \'' + data.WFActorID2 + '\')"  ' +
					        'style="cursor:pointer;color:#0761cf;text-decoration:none;">' 
					        + rs2 + 
					        '</a>';
					} else {
						secondTd.textContent = '-';
					}
					
				}else{ // eclick
					url1 = url1 + data.PID1;
					url2 = url2 + data.PID2;

					// 요청부서 결재상태
					var rs1 = data.WFStatusNM1;
					if(rs1 !== undefined && rs1 !== null && rs1 !== ''){
						if(data.Status1 === "2" || data.Status1 === "3") rs1 += ' (' + data.WFActorName1 + ' ' + data.WFDate1 + ')';
						firstTd.innerHTML = '<a href="' + url1 + '"target="_blank" style="cursor:pointer;color:#0761cf;text-decoration:none;">' + rs1 + '</a>';
					} else {
						firstTd.textContent = '-';
					}
					// 배포부서 결재상태
					var rs2 = data.WFStatusNM2;
					if(rs2 !== undefined && rs2 !== null && rs2 !== ''){
						if(data.Status2 === "2" || data.Status2 === "3") rs2 += ' (' + data.WFActorName2 + ' ' + data.WFDate2 + ')';
						secondTd.innerHTML = '<a href="' + url2 + '"target="_blank" style="cursor:pointer;color:#0761cf;text-decoration:none;">' + rs2 + '</a>';
					} else {
						secondTd.textContent = '-';
					}
				}
	
				
				// 선처리 여부
				if(data.REQ_DEPT_APP_OPIN !== null && data.REQ_DEPT_APP_OPIN !== undefined && data.REQ_DEPT_APP_OPIN !== '') thirdTd.textContent = "Y";
				else thirdTd.textContent = "-";
			} 
			
		})
		.catch((error) => console.log("error:", error));
	}
	
	function fnHandleClick(url,isMyProcRoleTPGroup,isMyRegion) {
		let sessionUserID = "${sessionScope.loginInfo.sessionUserId}";
		let sessionAuthLev = "${sessionScope.loginInfo.sessionAuthLev}";
		
		if(isMyProcRoleTPGroup == "Y" || isMyRegion == "Y" || sessionUserID == "${srInfoMap.RequestUserID}" || sessionAuthLev == "1"){
			window.open(url, 'popup', 'width=830,height=960,resizable=yes,scrollbars=yes');
		}else{
			getDicData("ERRTP", "ZLN0032").then(data => alert(data.LABEL_NM));
			return;
		}
		
	    return false;
	}
	
	// SFOLM 결재 링크 페이지 팝업 
	function fnEsrInfoWFDetail(wfInstanceID, documentID, wfActorID){ 	
		var url =  "wfDocItsmMgt.do?";
		var srCode = "${srInfoMap.SRCode}";
		var projectID = "${srInfoMap.ProjectID}";
		var wfID = "${srInfoMap.defWFID}";	
		var stepInstID = "${wfInstInfo.StepInstID}";;
		var stepSeq = "${wfInstInfo.StepSeq}";
		var lastSeq = "${wfInstInfo.LastSeq}";
		var statusCode = "${wfInstInfo.StatusCode}";
		var defApprovalSystem = "${defApprovalSystem}";
		
		var data = "projectID="+projectID
					+"&stepInstID="+stepInstID
					+"&actorID="+wfActorID
					+"&stepSeq="+stepSeq
					+"&wfInstanceID="+wfInstanceID
					+"&wfID="+wfID
					+"&documentID="+documentID
					+"&lastSeq="+lastSeq
					+"&documentNo="+srCode
					+"&docCategory=SPE"
					+"&actionType=view";

		var w = 1200;
		var h = 680; 
		itmInfoPopup(url+data,w,h);
	}
	
	
</script>

<style>
.tooltip {
      margin-top:10px;
      padding: 10px 0px;
      display:inline-block;
      color: #0761cf;
    }
</style>
</head>
<body style="overflow: auto">
	<div id="processSRDIV"	 <c:if test="${isPopup}">style="background: #EEF1F7; padding: 0 20px; min-height: 100%;"</c:if>>
		<form name="receiptSRFrm" id="receiptSRFrm" enctype="multipart/form-data" action="" method="post" onsubmit="return false;">
		<input type="hidden" id="scrnType" name="scrnType" value="${scrnType}">
		<input type="hidden" id="srMode" name="srMode" value="${srMode}">
		<input type="hidden" id="srType" name="srType" value="${srType}">
		<input type="hidden" id="srID" name="srID" value="${srInfoMap.SRID}">
		<input type="hidden" id="srCode" name="srCode" value="${srInfoMap.SRCode}">
		<input type="hidden" id="receiptUserID" name="receiptUserID" value="${srInfoMap.ReceiptUserID}">
		<input type="hidden" id="receiptTeamID" name="receiptTeamID" value="${srInfoMap.ReceiptTeamID}">
		<input type="hidden" id="requestUserID" name="requestUserID" value="${srInfoMap.RequestUserID}">
		<input type="hidden" id="requestTeamID" name="requestTeamID" value="${srInfoMap.RequestTeamID}">
		<input type="hidden" id="status" name="status" value="">
		<input type="hidden" id="srRoleTP" name="srRoleTP" value="${srInfoMap.ProcRoleTP}" >
		<input type="hidden" id="srLogType" name="srLogType" value="" />
		<input type="hidden" id="srGoNextYN" name="srGoNextYN" value="" />
		
		<div class="btn-wrap flex justify-between pdB10 pdT10">
			<div class="align-center flex">
				<c:if test="${!isPopup}"><span class="back" onclick="fnGoSRList()"><span class="icon arrow"></span></span></c:if>
				<h1 class="page-title">${srInfoMap.Subject}</h1>
			</div>
			<div class="btns">
				<c:if test="${sessionScope.loginInfo.sessionAuthLev eq 1 && srInfoMap.Blocked ne '2'}">
				<button id="force-quit" onClick="fnForceQuit()"></button>
				</c:if>
				<c:if test="${fn:trim(srInfoMap.isPublic) eq '0' && sessionScope.loginInfo.sessionUserId.equals(srInfoMap.RegUserID)}">
				<button id="delete-sr" onClick="fnDeleteSR()"></button>
				<button id="save-sr" onClick="fnSaveTempSR()"></button>
				</c:if>
			</div>
		</div>
		<div class="border-section">
			<div class="btn-wrap page-subtitle pdB10 pdT10">
				${menu.ZLN0040}
				<div class="btns">
					<button id="fold" onclick="fnFolding()">
						<svg xmlns="http://www.w3.org/2000/svg" width="20.828" height="11.828" viewBox="0 0 20.828 11.828">
						  <path id="Shape_1_copy" data-name="Shape 1 copy" d="M7404,3168l9-9,9,9" transform="translate(-7402.585 -3157.586)" fill="none" stroke="#222" stroke-linecap="round" stroke-width="2"/>
						</svg>
					</button>
				</div>
			</div>
			<table class="new-form form-column-8" style="table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
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
					<!-- SR No.  -->
					<th class="alignL pdL10">${menu.ZLN0041}</th>
					<td class="sline tit last">${srInfoMap.SRCode}</td>
					<th class="alignL pdL10">${menu.LN00065}</th>
					<td class="sline tit last alignL " colspan=5 id="procStatusListTd"></td>
				</tr>
				<tr>
					<!-- 요청자 -->
					<th class="alignL pdL10" >${menu.LN00025}</th>
					<td class="sline tit layer-pop" style="cursor:pointer;;color:#0761CF;" data-memberid="${srInfoMap.RequestUserID}">${srInfoMap.ReqUserNM}/${srInfoMap.ReqTeamNM}</td>
					<!-- 요청부서 -->
					<th class="alignL pdL10" >${menu.LN00026}</th>
					<td class="sline tit" >${srInfoMap.CompanyName}</td>
					<!-- 등록자 -->
					<th class="alignL pdL10" >${menu.LN00212}</th>
					<td class="sline tit layer-pop" style="cursor:pointer;;color:#0761CF;" data-memberid="${srInfoMap.RegUserID}">${srInfoMap.RegUserName}/${srInfoMap.RegTeamName}</td>
					<!-- 처리담당자 -->
					<th class="alignL pdL10" >${menu.LN00004}</th>
					<td class="sline tit last layer-pop" style="cursor:pointer;;color:#0761CF;" data-memberid="${srInfoMap.ReceiptUserID}">${srInfoMap.ReceiptName}/${srInfoMap.ReceiptTeamName}</td>
				</tr>
				<tr>
					<th class="alignL pdL10">${menu.ZLN0042}</th>
					<td class="sline tit">${srInfoMap.SRTypeName}</td>
					<!-- SR Area 1 -->
					<th class="alignL pdL10">${srInfoMap.SRArea1NM}/${srInfoMap.SRArea2NM}</th>
					<td class="sline tit" >${srInfoMap.SRArea1Name}<c:if test="${not empty srInfoMap.SRArea2Name}">&nbsp;>&nbsp;${srInfoMap.SRArea2Name}</c:if></td>
					<!-- 카테고리 -->
					<th class="alignL pdL10">${menu.LN00272}</th>
					<td class="sline tit">${srInfoMap.CategoryName}<c:if test="${not empty srInfoMap.SubCategoryName}">&nbsp;>&nbsp;${srInfoMap.SubCategoryName}</c:if></td>
					<!-- 단계 진행 상태 -->
					<th class="alignL pdL10">${menu.ZLN0043}</th>
					<td class="sline tit last" id="activityStatusNameTd"></td>
				</tr>
				<tr>	
					<!-- 등록일 -->
					<th class="alignL pdL10">${menu.LN00078}</th>
					<td class="sline tit" >${srInfoMap.RegDate}</td>
					<!-- 완료요청일 -->
					<th class="alignL pdL10">${menu.LN00222}</th>
					<td class="sline tit" >
						<c:choose>
							<c:when test="${fn:trim(srInfoMap.isPublic) eq '0' && sessionScope.loginInfo.sessionUserId.equals(srInfoMap.RegUserID)}">
								<input type="text" id="reqdueDate" name="reqdueDate" class="text datePicker stext" size="8"
								style="width: 100px; text-align: center;" onchange="this.value = makeDateType(this.value);" value="${fn:substring(srInfoMap.ReqDueDate, 0, 10)}" maxlength="10">
							</c:when>
							<c:otherwise>
								${fn:substring(srInfoMap.ReqDueDate, 0, 10)}
							</c:otherwise>
						</c:choose>
					</td>	
					<!-- 완료예정일 -->
					<th class="alignL pdL10">${menu.LN00221}</th>
					<td class="sline tit" >${fn:substring(srInfoMap.DueDate, 0, 10)}</td>
					<!-- 완료일 -->
					<th class="alignL pdL10">${menu.LN00064}</th>
					<td class="sline tit last" >${fn:substring(srInfoMap.CompletionDT, 0, 10)}</td>
				</tr>
				
				<c:choose>
				<c:when test="${fn:trim(srInfoMap.isPublic) eq '0' && sessionScope.loginInfo.sessionUserId.equals(srInfoMap.RegUserID)}">
					<tr>
						<th>${menu.LN00002}</th>
						<td class="sline tit last" colspan="7">
							<input type="text" class="text" id="subject" name="subject" value="${srInfoMap.Subject}" />
						</td>
					</tr>
				</c:when>
				<c:otherwise>
					<input type="hidden" id="subject" name="subject" value="${srInfoMap.Subject}">
				</c:otherwise>
				</c:choose>
				
				<tr id="attachFileListTr" style="display:none;">
					<th class="alignL pdL10">${menu.LN00111}</th>
					<td colspan=7>
						<div class="tmp_file_wrapper" style="width: 533px;">
							<table width="100%" style="table-layout:fixed;">
								<colgroup>
									<col width="40px">
									<col>
									<col width="80px">
								</colgroup>
								<tbody name="sr-file-list">
								</tbody>
							</table>
						</div>
					</td>
				</tr>
			</table>
			<c:if test="${!empty srInfoMap.Description}">
			<table id="descTable" <c:if test="${fn:trim(srInfoMap.isPublic) eq '0' && sessionScope.loginInfo.sessionUserId.equals(srInfoMap.RegUserID)}">style="display:none;"</c:if>  width="100%"  cellpadding="0"  cellspacing="0">
				<tr>
					<td class="tit last">
						<div style="height:232px;" >
							<textarea class="tinymceText" id="description" style="width:100%;height:230px;">${srInfoMap.Description}</textarea>
						</div>
					</td>
				</tr>		
			</table>
			</c:if>
			<!-- 결재정보 -->
			<table id="dlmWFStatusTable" class="new-form form-column-8 mgT10" style="display:none; table-layout:fixed;" width="100%" cellpadding="0" cellspacing="0">
				<colgroup>
					<col width="10%">
				    <col width="15%">
				 	<col width="10%">
				    <col width="15%">
				    <col width="10%">
				    <col width="15%">
				    <col width="10%">
				    <col width="15%">
				</colgroup>
				<tr>	
					<th class="alignL pdL10">${menu.ZLN0044}</th>
					<td class="sline tit" colspan="2"></td>
					<th class="alignL pdL10">${menu.ZLN0045}</th>
					<td class="sline tit" colspan="2" ></td>	
					<th class="alignL pdL10">${menu.ZLN0046}</th>
					<td class="sline tit"></td>	
				</tr>
			</table>
		</div>
		
		<div class="tooltip">
		* 
		</div>
		
		<!-- 탭 메뉴 -->
		<div>
			<ul class="tabs" id="subTabs" style="margin-top:10px;">
				<c:if test="${srInfoMap.Blocked eq '0'}" >
					<li onclick="loadTabPage(1)" class="tab" data-index="1">${menu.ZLN0047}</li>
				</c:if>
				<li onclick="loadTabPage(2)" class="tab" data-index="2">${menu.ZLN0048}</li>
				<li onclick="loadTabPage(3)" class="tab" data-index="3" style="display:none;" >${menu.ZLN0049}</li>
				<li onclick="loadTabPage(4)" class="tab" data-index="4">${menu.ZLN0050}</li>
				<c:if test="${srInfoMap.Blocked ne '0' && srInfoMap.Status eq 'ZSPE00'}" >
					<li onclick="loadTabPage(5)" class="tab" data-index="5">${menu.ZLN0051}</li>
				</c:if>
				<!-- eClick 전용 탭 -->
				<!-- 
				<c:if test="${srInfoMap.SRType eq 'ICM'}">
					<li onclick="loadTabPage(6)" class="tab" data-index="6">${menu.ZLN0052}</li>
				</c:if>
				 -->
			</ul>
		</div>
		
		<div id="loadTagPage" class="pdB23" ></div>
		
		<!-- 담당자 레이어 팝업 -->	
		<div class="item_layer_photo" id="layerPopup" style="line-height:initial;">
			<div>
				<div class="child_search_head_blue" style="border:0px;">
					<li class="floatL"><p style="cursor: default;">${menu.ZLN0053}</p></li>
					<li class="floatR mgT5 mgR10">
						<img class="popup_closeBtn" id="popup_close_btn"  style="cursor: pointer;" src='${root}${HTML_IMG_DIR}/btn_close1.png' title="close" >
					</li>
				</div>	 
				<table class="tbl_blue01 mgT5" style="width:100%;height:85%;table-layout:fixed;border:0px;">
					<colgroup>
						<col width="30%">
						<col width="70%">
					
					<tr>
						<td  style="border:0px;" id="author_photo"></td>
						<td class="alignL last pdl10" style="border:0px;">
							<span style="font-weight:bold;font-size:12px;" id="author_name"></span>
							&nbsp;(<span id="author_employeeNum"></span>)
						  <br><span id="author_userNameEN"></span>
						  <br><span id="author_ownerTeamName"></span>
						</td>
					</tr>				
					<tr>
						<td colspan = "2"  class="alignL pdl10" >
							<div class="floatL" style="width:30%;font-weight:bold;">${menu.LN00104}</div>
							<div class="floatR"" style="width:70%" id="author_teamName"></div>
						</td>
					</tr>
					<tr>
						<td colspan = "2"  class="alignL pdl10" style="border:0px;">
							<div class="floatL" style="width:30%;font-weight:bold;">${menu.ZLN0054}</div>
							<div class="floatR" style="width:70%;" id="author_email"></div>
						</td>
					</tr>
					<tr>
						<td colspan = "2"  class="alignL pdl10" style="border:0px;">
							<div class="floatL" style="width:30%;font-weight:bold;">${menu.ZLN0055}</div>
							<div class="floatR" style="width:70%" id="author_telNum"></div>
						</td>
					</tr>
					<tr>
						<td  colspan = "2" class="alignL pdl10" style="border:0px;">
							<div class="floatL" style="width:30%;font-weight:bold;">${menu.ZLN0056}</div>
							<div class="floatR" style="width:70%" id="author_mTelNum"></div>
						</td>
					</tr>
				</table> 
			</div>
		</div> 
		</form>
	</div>
	<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>
</body>
</html>