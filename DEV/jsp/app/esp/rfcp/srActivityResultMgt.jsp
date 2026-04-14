<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page trimDirectiveWhitespaces="true" %>
<c:url value="/" var="root"/>
<!--1. Include JSP -->
<%@ include file="/WEB-INF/jsp/cmm/fileAttachHelper.jsp"%>
<%-- <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%> --%>

<script src="${root}cmm/js/tinymce_v7/tinymce.min.js" type="text/javascript"></script>
<script type="text/javascript" src="${root}cmm/js/xbolt/tinyEditorHelper.js"></script>

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.min.js" type="text/javascript"></script> 
<script src="${root}cmm/js/jquery/jquery.timepicker.js" type="text/javascript"></script> 
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/jquery.timepicker.css"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00049" var="WM00049"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00016" var="CM00016"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00054" var="CM00054"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00056" var="CM00056"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00274}"/> <!-- 도메인 입력 체크 -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.ZLN0188}/${menu.ZLN0079}"/> <!-- 시스템 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="${menu.LN00272}"/> <!-- 카테고리 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_4" arguments="${menu.LN00273}"/> <!-- 서브카테고리 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_6" arguments="Comment"/> <!-- Comment 입력 체크  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_7" arguments="${menu.LN00221}"/> <!-- 완료예정일  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_8" arguments="${menu.ZLN0190}"/> <!-- 전자 결재 공문번호  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_9" arguments="${menu.ZLN0175}"/> <!-- 선처리 사유 -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00063" var="CM00063"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00042" var="CM00042"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00003" var="WM00003"/>
<script type="text/javascript">
	var fileSize = "${itemFiles.size()}";
	var scrnType = "${scrnType}";
	var srType = "${srType}";
	var srArea1ListSQL = "${srArea1ListSQL}";
	var customerNo = "${srInfoMap.ClientID}";
	var srAre1 = "${srInfoMap.SRArea1}"
	var changeCategory = "${changeCategory}";
	var clientIDBySRArea = "${clientIDBySRArea}";
	var editMode = "${editMode}";
	let fileTypeList = "";
	var childWindow = "";
	// select list 용 parameter
	var selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&esType=${esType}&customerNo=" + customerNo;
	let extraManList = [];
	
	let today = new Date();
	today = today.getFullYear() +
	'-' + ( (today.getMonth()+1) <= 9 ? "0" + (today.getMonth()+1) : (today.getMonth()+1) )+
	'-' + ( (today.getDate()) <= 9 ? "0" + (today.getDate()) : (today.getDate()) );
	
	// API Setting
	let srAttrList = [];
	getAttr().then(() => settingSRAttrList());
	getSrFileList();
	setTimeout(() => {
		setAttachFileCheck();
	}, 500); 
	
	jQuery(document).ready(function() {
		
		// 00. 임시저장 시 desc화면 출력
		<c:if test="${fn:trim(srInfoMap.isPublic) eq '0'}">
			$("#descTable").show();
		</c:if>
		
		// 01. input type setting
		$("input.datePicker").each(generateDatePicker);
		$('input.timePicker').timepicker({
            timeFormat: 'H:i',
        });
		
		// 02. 실적 화면 출력 
		if("${mbrRcdMgt}" == "Y"){
			childWindow = document.getElementById('espMbrRcdListFrame').contentWindow;
			fnEspMbrRcdListFrame();
	    }
		// 개선관리
		if("${scrOutputMgt}" == "Y"){
			fnScrOutputMgtFrame();
		}
		// 03. 완료예정일 화면 출력
		if("${espDueDateMgt}" != "" && "${espDueDateMgt}" != null && "${espDueDateMgt}" !== undefined){
			fnEspDueDateMgtFrame();
		}
		
		// 01. select option setting
		if((customerNo == null || customerNo == '' || customerNo == undefined) && editMode == 'Y' && changeCategory == 'Y') {
			customerNo = '${sessionScope.loginInfo.sessionClientId}';
			$("#clientID").val('${sessionScope.loginInfo.sessionClientId}');
		}
		//fnSelect('company', '', 'getESPCustomerList', customerNo, 'Select','esm_SQL');
		fnSelectSetting();
		
		// 03. category change event
		/* $("#company").on("change", function(){
  			$("#clientID").val($("#company").val());
  			fnSelectSetting("Y");
  		}); */
		
  		$("#category").on("change", function(){
  			var category = $("#category").val();
  			fnGetSubCategory(category);
  		});
  		
  		// 04. subCategory change event
  		$("#subCategory").on("change", async function(){
  			var subCategory = $("#subCategory").val();
  			const alertMsgObj = await getDicData("ERRTP", "ZLN0033");
			alertMsg = alertMsgObj.LABEL_NM;
  			fnSaveActivityAttr('',alertMsg,'Y'); // 자동저장
  		});
  		
  		// button setting
  		buttonSetting("srActivityResultButtons");
  		
  		// srArea setting
  		if(editMode == 'Y' && changeCategory == 'Y') {
  			fnSRAreaLoad();
  		}
  		
  		// keydown 핸들러 (단, blockEnter=true 일 때만 차단)
  		document.addEventListener("keydown", function(e) {
  		    if (blockEnter && e.key === "Enter") {
  		        e.preventDefault();
  		        console.log(" Enter X");
  		    }
  		});
	});
	
	function getAttrLovException(avg){
		
		return attrLovList;
	}
	
	async function getAttrLovList(attrTypeCode, val, avg3, mandatory, defaultValue, style, varFilter){
		let value = val;              // 초기에 세팅되고자 하는 값
		if(value == "") value = defaultValue;
		var isAll  = mandatory == "" || attrTypeCode == "NULL" ? "true" : "false"; // "select" 일 경우 선택, "true" 일 경우 전체로 표시
		
		let param = "languageID=${sessionScope.loginInfo.sessionCurrLangType}"
							+"&sqlID=attr_SQL.selectAttrLovOption"
							+"&attrTypeCode="+attrTypeCode;

		await getEspAttrLovList(attrTypeCode).then(res => param += "&lovListFilter=" + res);
		
		fetch("/olmapi/getLovValue/?"+param)	
		.then(res => res.json())
		.then(res => {
			style === "radio" ? lovRadio(res.data, attrTypeCode, value, varFilter) : lovSelect(res.data, attrTypeCode, value, isAll, varFilter);
		});
	}
	
	async function getEspAttrLovList(attrTypeCode) {
		const res = await fetch("/olmapi/espAttrLovList/?srID=${srInfoMap.SRID}&srType=${srInfoMap.SRType}&customerNo=${srInfoMap.ClientID}&attrTypeCode="+attrTypeCode);
		const data = await res.json();
		return data;
	}
	
	function lovRadio(data, attrTypeCode, value, varFilter) {
		let lovHtml = "";
		
		// targetAttrType 스타일 초기화
		let obj = {};
		if(varFilter) varFilter.split("&").filter(e => e).forEach(e => obj[e.split("=")[0]] = e.split("=")[1]);
		
		for(var i=0; i < data.length; i++) {
			lovHtml += '<input type="radio" id="'+data[i].AttrTypeCode+data[i].CODE+'" name="'+data[i].AttrTypeCode+'" value="'+data[i].CODE+'" onChange="fnGetSubAttrTypeCode(\''+varFilter+'\',this.value,\'\',\''+attrTypeCode+'\')"';
			
			// value 가 있을 경우,
			if(value && data[i].CODE === value) lovHtml += ' checked />';
			// value와 defaultValue 모두 없을 경우
			else if(!value && i == 0) lovHtml += ' checked />';
			else lovHtml += ' />';
			lovHtml += '<label for="'+data[i].AttrTypeCode+data[i].CODE+'">'+data[i].NAME+'</label>';
			
		}
		
		// targetAttrType 스타일 초기화
		fnGetSubAttrTypeCode(varFilter, value, attrTypeCode);
		
		document.querySelector("#"+attrTypeCode).insertAdjacentHTML("afterbegin", lovHtml);
	}
	
	function lovSelect(data, attrTypeCode, value, isAll, varFilter) {
		let lovHtml = "";
		if(isAll) lovHtml += '<option value="">Select</option>';

		// targetAttrType 스타일 초기화
		let obj = {};
		if(varFilter) varFilter.split("&").filter(e => e).forEach(e => obj[e.split("=")[0]] = e.split("=")[1]);
		
		for(var i=0; i < data.length; i++) {
			lovHtml += '<option value="'+data[i].CODE+'"';
			
			// value 가 있을 경우,
			if(value && data[i].CODE === value) lovHtml += ' selected';
			lovHtml += '>'+data[i].NAME+'</option>';
			
			// targetAttrType 스타일 초기화
			let actionValue = '';
			if(obj.actionValue){
				actionValue = obj.actionValue.split('?');
			}
			
			if(actionValue.includes(data[i].CODE)){
				fnGetSubAttrTypeCode(varFilter, value, attrTypeCode);
			}
		}
		
		document.querySelector("#"+attrTypeCode).insertAdjacentHTML("afterbegin", lovHtml);
	}

	function fnSearchMemberPop(attrTypeCode){

		var url = "selectMemberPop.do?mbrRoleType=ATTRMBR&projectID=${projectID}&attrTypeCode="+attrTypeCode;
		window.open(url,"","width=900 height=700");					
	}
	
	function setAttrMbr(memberIds,memberNames,teamIds,attrTypeCode) {
		$("#"+attrTypeCode+"_Text").val(memberNames);
		$("#"+attrTypeCode).val(memberIds);
	}
	
	let defObjValue = [];
	function fnGetSubAttrTypeCode(varFilter, value, attrTypeCode){
		let obj = {};
		if(varFilter) varFilter.split("&").filter(e => e).forEach(e => obj[e.split("=")[0]] = e.split("=")[1]);
		
		if(obj.targetAttrType) {
			let el =  document.querySelector("#"+obj.targetAttrType);
			let elValue = el.textContent ? el.textContent : el.value;
			
			// defValue 가 있다면 저장
			if(elValue) {
				defObjValue.push({attrTypeCode: attrTypeCode, defaultValue : elValue});
			}
			
			let actionValue = '';
			if(obj.actionValue){
				actionValue = obj.actionValue.split('?');
			}
			
			if(actionValue.includes(value)){
				el.readOnly = false;
				el.disabled = false;
				el.classList.add("edit");
				
				if(elValue) {
					el.value = elValue;
				} else if(defObjValue && defObjValue.length > 0){
					let match = defObjValue.find(obj => obj.attrTypeCode === attrTypeCode);
					if(match){
						el.value = match.defaultValue;
					}
				}
				
				if (el.parentNode && el.parentNode.previousElementSibling) {
					el.parentNode.previousElementSibling.insertAdjacentHTML("afterbegin", "<p style='display:inline;color:#FF0000;'>*</p>");
				}
				
				extraManList.push(obj.targetAttrType);
			} else {
				el.readOnly = true;
				el.disabled = true;
				el.classList.remove("edit");
				el.value = "";
				
				if (el.parentNode && el.parentNode.previousElementSibling) {
					el.parentNode.previousElementSibling.childNodes.forEach(e => {
		       	 		if(e.tagName === "P") e.remove();
					});
				}
				
				extraManList.splice(extraManList.findIndex(e => e === obj.targetAttrType), 1);
			}
		}
		
		if(obj.setAttachFileCheck) {
			setAttachFileCheck();
		}
	}
	
	// 운영이관 실적
	function fnEspMbrRcdListFrame(){
		$("#espMbrRcdListFrame").attr("style", "display:block;width:100%; height:400px; border:none;");
		var data = "srID=${srInfoMap.SRID}&docCategory=${srInfoMap.DocCategory}&speCode=${srInfoMap.Status}&activityStatus=${activityLogInfo.Status}&procRoleTP=${srInfoMap.ProcRoleTP}&receiptUserID=${srInfoMap.ReceiptUserID}&srArea2=${srInfoMap.SRArea2}&mbrAddUserYN=${mbrAddUserYN}&mbrModUserYN=${mbrModUserYN}&useOverTime=${useOverTime}";
	    var src = "editEspMbrRcdList.do?"+data;
	    document.getElementById('espMbrRcdListFrame').contentWindow.location.href= src;
	    
	}
	
	// 개선관리 실적
	function fnScrOutputMgtFrame(){
		$("#scrOutputRcdMgtFrame").attr("style", "display:block;width:100%; height:675px; border:none;");
		var data = "srID=${srInfoMap.SRID}&activityStatus=${activityLogInfo.Status}&procRoleTP=${srInfoMap.ProcRoleTP}&receiptUserID=${srInfoMap.ReceiptUserID}&srArea2=${srInfoMap.SRArea2}&speCode=${srInfoMap.Status}&clientID=${srInfoMap.ClientID}";
		var src = "scrOutputRcdMgt.do?"+data; 
		 document.getElementById('scrOutputRcdMgtFrame').contentWindow.location.href= src;
	}
	
	// 완료예정일
	function fnEspDueDateMgtFrame(){
		$("#espDueDateMgtFrame").attr("style", "display:block;width:100%; height:580px; border:none;");
		var data = "srID=${srInfoMap.SRID}&activityStatus=${activityLogInfo.Status}&dueDate=${srInfoMap.DueDate}&espDueDateMgt=${espDueDateMgt}&speCode=${srInfoMap.Status}&procRoleTP=${srInfoMap.ProcRoleTP}&receiptUserID=${srInfoMap.ReceiptUserID}&srArea2=${srInfoMap.SRArea2}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		var src = "espDueDateMgt.do?"+data; 
		 document.getElementById('espDueDateMgtFrame').contentWindow.location.href= src;
	}
	
	/*** SR Select function start ***/
	function fnSelectSetting(all) {
		// 00. reset
		resetSelect(all);
		// 01. category setting
		fnSelect('category', selectData +"&srType=${srInfoMap.SRType}&level=1&customerNo="+ $("#clientID").val(), 'getESPSRCategory', '${srInfoMap.Category}', 'Select','esm_SQL');
		fnGetSubCategory('${srInfoMap.Category}');
	}

	// subCategory setting ( * customerNo / category )
	function fnGetSubCategory(parentID){
		if(parentID == ''){
			$("#subCategory option").not("[value='']").remove();
		} else {
			fnSelect('subCategory', selectData + "&srType=${srInfoMap.SRType}&parentID="+parentID+"&customerNo=" + $("#clientID").val(), 'getESPSRCategory', '${srInfoMap.SubCategory}', 'Select', 'esm_SQL');
		}
	}
	
	// select option reset
	function resetSelect(all){
		
		$("#category").val("");
		$("#subCategory").val("");
		
		$("#srAreaSearch").val("${empty srInfoMap.SRArea2Name or srInfoMap.SRArea2Name == '0' ? srInfoMap.SRArea1Name : srInfoMap.SRArea2Name}");
		$("#srArea1").val("${srInfoMap.SRArea1}");
		$("#srArea2").val("${srInfoMap.SRArea2}");
		
		if(all == "Y"){
			$("#srAreaSearch").val("");
			$("#srArea1").val("");
			$("#srArea2").val("");
		}
		
		return;
	}
	
	let srAreaData = [];
	function fnSRAreaLoad() {
		var srType = "${srType}";
		if("${srType}" === "DPL") srType = srType + "&clientID=0000000008";
		fetch("/olmapi/srArea/?languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&srType=" + srType + "&priorityClientID=" + $("#clientID").val())
		.then((response) => response.json())
		.then(data => srAreaData = data);
	}
	
	<c:if test="${editMode eq 'Y' && changeCategory eq 'Y'}">
		const srAreaSearch = document.querySelector("#srAreaSearch");
		const autoComplete = document.querySelector(".autocomplete");
		
		let nowIndex = 0;
		let matchDataList, findIndex = [];
		srAreaSearch.addEventListener("keyup", async function(event) {
		// 검색어
			const value = srAreaSearch.value;
		  
		  // 초기화
		  	document.querySelector("#srArea1").value = "0";
		  	document.querySelector("#srArea2").value = "0";
	
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
			    	document.querySelector("#srAreaSearch").value = matchDataList[nowIndex].SRArea2Name || matchDataList[nowIndex].SRArea1Name || "";
					document.querySelector("#srArea1").value = matchDataList[nowIndex].SRArea1 || "0";
					document.querySelector("#srArea2").value = matchDataList[nowIndex].SRArea2 || "0";
					
					// customerNo 변경 감지 > category 재 셋팅
					if(clientIDBySRArea !== "N"){
						let customerNo = document.querySelector("#clientID").value;
						if(customerNo === undefined || customerNo == '' || customerNo == null || customerNo != matchDataList[nowIndex].ClientID){
							document.querySelector("#clientID").value = matchDataList[nowIndex].ClientID || "";
							fnSelectSetting();
						}
					}
					
					// 초기화
					nowIndex = 0;
					matchDataList.length = 0;
					
					const alertMsgObj = await getDicData("ERRTP", "ZLN0033");
					alertMsg = alertMsgObj.LABEL_NM;
		  			fnSaveActivityAttr('',alertMsg,'Y'); // 자동저장
					break;
		      
		    	default:
			    	// 자동완성 필터링
			    	matchDataList, findIndex = [];
					if(value) {
						//if(document.querySelector("#clientID").value == "") matchDataList = srAreaData.filter(e => e.SRArea2Name.includes(value));
						//else matchDataList = srAreaData.filter(e => e.ClientID === document.querySelector("#company").value).filter(e => e.SRArea2Name.includes(value));
						matchDataList = srAreaData.filter(e => e.SRArea1Name.match(new RegExp(value, "i")) || e.SRArea2Name.match(new RegExp(value, "i")));
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
		document.addEventListener("click", async function(e) {
			if(autoComplete.contains(e.target)) {
				let parentIndex = e.target.parentNode.getAttribute("data-index");
				document.querySelector("#srAreaSearch").value = srAreaData.filter(e => e.RNUM == parentIndex)[0].SRArea2Name || srAreaData.filter(e => e.RNUM == parentIndex)[0].SRArea1Name;
				document.querySelector("#srArea1").value = srAreaData.filter(e => e.RNUM == parentIndex)[0].SRArea1;
				document.querySelector("#srArea2").value = srAreaData.filter(e => e.RNUM == parentIndex)[0].SRArea2 || "0";
				
				// customerNo 변경 감지 > category 재 셋팅
				if(clientIDBySRArea !== "N"){
					let customerNo = document.querySelector("#clientID").value;
					if(customerNo === undefined || customerNo == '' || customerNo == null || customerNo != srAreaData.filter(e => e.RNUM == parentIndex)[0].ClientID){
						document.querySelector("#clientID").value = srAreaData.filter(e => e.RNUM == parentIndex)[0].ClientID;
						fnSelectSetting();
					}
				}
				const alertMsgObj = await getDicData("ERRTP", "ZLN0033");
				alertMsg = alertMsgObj.LABEL_NM;
	  			fnSaveActivityAttr('',alertMsg,'Y'); // 자동저장
				
			}
		    if(e.target.id !== "srAreaSearch" && autoComplete.classList.contains("on")) autoComplete.classList.remove("on");
		})
	</c:if>
	
	/*** SR Select function end ***/
	
	
	// [ Button List START ]
	
	function buttonSetting(buttonWrapper){
  		
// 		if("${editMode}" === "Y") {
// 			fnSetButton("attach", "attach", "Attach", "tertiary");
// 		}
		
		// get list ( activity + functionList )
  		fetch("/olmapi/espButtonList/?srID=${srInfoMap.SRID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&srType=${srInfoMap.SRType}&procRoleTP=${srInfoMap.ProcRoleTP}&delBtn=${delBtn}&clientID=${srInfoMap.ClientID}"+
  			   "&regUserID=${srInfoMap.RegUserID}&receiptUserID=${srInfoMap.ReceiptUserID}&srArea1=${srInfoMap.SRArea1}&srArea2=${srInfoMap.SRArea2}&aprvBlock=${aprvBlock}&speCode=${srInfoMap.Status}&isPublic=${srInfoMap.isPublic}"+
  			   "&activityStatus=${activityLogInfo.Status}&activityBlocked=${activityLogInfo.Blocked}&sessionUserId=${sessionScope.loginInfo.sessionUserId}&sessionAuthLev=${sessionScope.loginInfo.sessionAuthLev}&SRStatusName=${srInfoMap.SRStatusName}&isEditableAfterReception=${isEditableAfterReception}")
		.then((response) => response.json())
		.then((data) => {
			for(let i = 0; i < data.length; i++) {				
 				if(data[i].id === "complete") {
 					getDicData("BTN", data[i].name).then(result => fnSetButton(data[i].id, "", "${srInfoMap.SRStatusName} " + result.LABEL_NM, data[i].cls, buttonWrapper, data[i].func));
 				} else {
					getDicData("BTN", data[i].name).then(result => fnSetButton(data[i].id, "", result.LABEL_NM, data[i].cls, buttonWrapper, data[i].func));
 				}
			}
		})
		.catch((error) => console.log("error:", error));
	}
	
	// 완료 시 체크
	async function validOption(){
		let res = true;
		
		// changeCategory 필수값 체크
		if(res && "${changeCategory}" == "Y"){
			var category = $("#category").val();
			var subCategory = $("#subCategory").val();
			var srArea1 = $("#srArea1").val();
			var srArea2 = $("#srArea2").val();
			var srAreaSearch = $("#srAreaSearch").val();
			
			if(srArea1 == "" || srArea1 == "0"){ alert("${WM00034_2}"); res = false;}
			else if(srAreaSearch == ""){ alert("${WM00034_2}"); res = false;}
			
			//else if(srType !== "ICM" && srType !== "SCM" && srType !== "DPL"){
			if(category == ""){ alert("${WM00034_3}"); res = false;}
			else if(subCategory == ""){ alert("${WM00034_4}"); res = false;}
			//}
		}
		
		// 유저중복옵션 체크
		if(res && "${userDuplicate}" != "" && "${userDuplicate}" != null && "${userDuplicate}" !== undefined){
			try{
				const response = await fetch("/olmapi/espUserDuplicateCheck/?speCode=${srInfoMap.Status}&chkSpeCode=${userDuplicate}&receiptUserID=${srInfoMap.ReceiptUserID}&srID=${srInfoMap.SRID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}");
				const data = await response.json();
				
				if(data == false){
// 			        alert("자체심의가 완료될 때 변경처리자 동일인 외 1인 이상이 있어야 합니다!");
			        getDicData("ERRTP", "ZLN0004").then(data => alert(data.LABEL_NM));
			        res = false;
				}
				
			}catch (error) {
		        console.error("Error during file check:", error);
		        res = false;
		    }
		}
		
		// 운영관리 실적 유효성 검토
		if(res && "${mbrRcdMgt}" == "Y"){
			if(!childWindow.fnCheckValidation()) { res = false; }
			if(!childWindow.validData()) { res = false; }
		}
		
		// 연관 CI 체크
		if(res && "${activityBlocked}" == 1 && "${blocked}" == 1 && "${svcCompl}" == "Y" && "${svcItemMgt}" == "Y") {
			if(!serviceItemCheck()) {
// 				if(!confirm("CMDB가 입력되지 않았습니다. 완료하시겠습니까?")){ res = false; }
				var msg = "";
		        getDicData("ERRTP", "LN0010").then(data => msg = data.LABEL_NM);
				if(!confirm(msg)){ res = false; }
			}
		}
		
		// 필수 산출물 체크
		if(res){
			if(!await attachFileCheck()){
				getSrFileList();
				res = false;
			}
		}
		
		return res;
	}
	
	// 업데이트 관련 동작 시 필수체크 
	async function validStatusCheck(){
		let res = true;
		
		// 상태 확인 체크 ( 동일한 상태가 아닐경우 차단 )
		if(res){
			try{
				const response = await fetch("/olmapi/espStatusCheck/?srID=${srInfoMap.SRID}&speCode=${srInfoMap.Status}&sessionUserId=${sessionScope.loginInfo.sessionUserId}");
				const data = await response.json();
				
				if(data == false){
// 					alert("해당 티켓의 진행 단계를 조정합니다.");
					getDicData("ERRTP", "ZLN0005").then(data => alert(data.LABEL_NM));
			        res = false;
				}
				
			}catch (error) {
		        console.error("Error during file check:", error);
		        res = false;
		    }
		}
		
		// 담당자 확인 체크 ( 이미 담당자가 존재하는 경우, 담당자 = sessionUser 아닐 경우 차단 )
		if(res && "${srInfoMap.ProcRoleTP}" !== "CLIENT" && "${srInfoMap.ProcRoleTP}" !== "" && "${srInfoMap.ProcRoleTP}" !== null && "${srInfoMap.ProcRoleTP}" !== undefined){
			try{
				const response = await fetch("/olmapi/espReceiverCheck/?srID=${srInfoMap.SRID}&speCode=${srInfoMap.Status}&sessionUserId=${sessionScope.loginInfo.sessionUserId}");
				const data = await response.json();
				
				if(data == false){
// 					alert("해당 티켓은 이미 접수된 건입니다.");
					getDicData("ERRTP", "ZLN0006").then(data => alert(data.LABEL_NM));
			        res = false;
				}
				
			}catch (error) {
		        console.error("Error during file check:", error);
		        res = false;
		    }
		}
		
		
		return res;
	}
	
	
	// 필수 attr 체크
	async function fnCheckValidateActivityAttr(){
		var isCheck = true;
		var attrVal = "";
		var attrVal2 = "";
		var mandatory = "";
		var mandatroy2 = "";
		
		var msg = "";
		var attrList = "";
		for(var i=0; i < srAttrList.length; i++) {
			if(srAttrList[i].Editable === "1" && srAttrList[i].Style === "radio") attrVal = srAttrList[i].Style === "radio" ? document.querySelector('input[name="' + srAttrList[i].AttrTypeCode + '"]:checked').value : $("#" + srAttrList[i].AttrTypeCode).val();
			else attrVal = $("#" + srAttrList[i].AttrTypeCode).val();
			
			attrVal2 = $("#" + srAttrList[i].AttrTypeCode2).val();
			mandatory = srAttrList[i].Mandatory;
			mandatory2 = srAttrList[i].Mandatory2;
			
			if(mandatory == "1" && attrVal == ""){
				if(msg == ""){
					msg = srAttrList[i].Name;
				} else {
					msg = msg + "," + srAttrList[i].Name;
				}
			}
			
			if(mandatory2 == "1" && attrVal2 == ""){
				if(msg == ""){
					msg = srAttrList[i].Name2;
				} else {
					msg = msg + "," + srAttrList[i].Name2;
				}
			}
		}
			
		for(var i=0; i < extraManList.length; i++) {
			attrVal = $("#"+extraManList[i]).val();
			if(attrVal == "") {
				if(msg == ""){
					msg = document.querySelector("#"+extraManList[i]).parentNode.previousElementSibling.textContent.replace("*","");
				} else {
					msg = msg + "," + document.querySelector("#"+extraManList[i]).parentNode.previousElementSibling.textContent.replace("*","");
				}
			}
		}
			
		if(msg != ""){
			isCheck = false;
// 			alert(msg + " 은(는) 필수 입력해야 합니다.");
			getDicData("ERRTP", "LN0004").then(data => alert(msg+data.LABEL_NM));
		}
		
		return isCheck;
		
	}
	
	// custom attr 체크
	async function fnCustomCheckValidateActivityAttr(attr){
		var isCheck = true;
		let msg = '';
		let attrs = attr.split(",");
		attrs.forEach(function(item) {
			var attr = document.getElementById(item);
			let parentRow = attr.parentNode.parentNode;
			let label = parentRow.querySelector('th').textContent.replace("*","");
			
			if(attr.value === null || attr.value === undefined || attr.value === ''){
				if(msg == ""){
					msg = label;
				} else {
					msg = msg + "," + label;
				}
			}
		});
		
		if(msg != ""){
			isCheck = false;
// 			alert(msg + " 은(는) 필수 입력해야 합니다.");
			getDicData("ERRTP", "LN0004").then(data => alert(msg+data.LABEL_NM));
		}
		
		return isCheck;
	}
	
	// attr 정규식 옵션 체크
	async function fnCheckRegexAttr() {

		let isCheck = true;
		let msg = "";
		let attrList = "";
		let attrVal = "";
		
		for(var i=0; i < srAttrList.length; i++) {
			if(srAttrList[i].Editable === "1" && srAttrList[i].Style === "radio") attrVal = srAttrList[i].Style === "radio" ? document.querySelector('input[name="' + srAttrList[i].AttrTypeCode + '"]:checked').value : $("#" + srAttrList[i].AttrTypeCode).val();
			else attrVal = $("#" + srAttrList[i].AttrTypeCode).val();
			
			let obj = {};
			varFilter = srAttrList[i].VarFilter;
			if(varFilter) varFilter.split("&").forEach(e => { const [k, v] = e.split("="); obj[k] = v; });
			
			if(obj.pattern){
				let pattern = new RegExp(obj.pattern);
				if(!pattern.test(attrVal)){
					if(msg == ""){
						msg = srAttrList[i].Name;
					} else {
						msg = msg + "," + srAttrList[i].Name;
					}
				}
			}
		}
			
		if(msg != ""){
			isCheck = false;
//			alert(msg + " 의 입력 형식을 다시 확인하세요!");
			getDicData("ERRTP", "ZLN0031").then(data => {
				data.LABEL_NM = data.LABEL_NM.replace(/\\n|\\r\\n|\n/g, '\n');
				alert(msg+data.LABEL_NM)});
			
		}
	  return isCheck;
	}
	
	// 00. [ Activity Button ] - BTN
	let isSubmitting = false; 
	async function fnSaveActivityAttr(activityStatus, msg, changeInfo){
		
		if (isSubmitting) {
			alert("${WM00003}");
			return false;      
		} else {
			
			isSubmitting = true;
			// 1. msg & data
			let alertMsg = "${CM00001}";
			let paramData = "?activityStatus="+activityStatus;
			const nowStatus = "${activityLogInfo.Status}";
			
			if(activityStatus == "09"){
	// 			alertMsg = "보류하시겠습니까?";
				const alertMsgObj = await getDicData("ERRTP", "ZLN0007");
				alertMsg = alertMsgObj.LABEL_NM;
				paramData = paramData+"&activityBlocked=1";
			}else if(activityStatus == "05"){
	// 			alertMsg = "완료하시겠습니까?";
				const alertMsgObj = await getDicData("ERRTP", "ZLN0008");
				alertMsg = alertMsgObj.LABEL_NM;
			}else if(activityStatus == "01" && nowStatus!= "09"){
	// 			alertMsg = "접수하시겠습니까?";
				const alertMsgObj = await getDicData("ERRTP", "ZLN0009");
				alertMsg = alertMsgObj.LABEL_NM;
			}else if(activityStatus == "04"){
	// 			alertMsg = "반려하시겠습니까?";
				const alertMsgObj = await getDicData("ERRTP", "ZLN0010");
				alertMsg = alertMsgObj.LABEL_NM;
				paramData = paramData+"&emailCode=ESPMAIL004";
			}else if(activityStatus == "06"){
	// 			alertMsg = "기각하시겠습니까?";
				const alertMsgObj = await getDicData("ERRTP", "ZLN0011");
				alertMsg = alertMsgObj.LABEL_NM;
				paramData = paramData+"&emailCode=ESPMAIL005";
			}
			if(msg !== undefined && msg !== '' && msg !== null) alertMsg = msg;
			if(!confirm(alertMsg)){ 
				fnSelectSetting();
				isSubmitting = false;
				return;
			}
			
			// * changeCategory 옵션
			<c:if test="${changeCategory ne 'Y'}">
				paramData = paramData+"&srArea2=${srInfoMap.SRArea2}&srArea1=${srInfoMap.SRArea1}";
			</c:if>
			<c:if test="${changeCategory eq 'Y'}">
				var prevSRCategory = $("#subCategory").val() || $("#category").val();
				paramData = paramData+"&customerNo=${srInfoMap.ClientID}&prevSRCategory=" + prevSRCategory;
			</c:if>
			
			// 2. 파일저장
			await saveFile();
			
			// 3. 유효성체크
			
			// * 필수 중복 작업 체크 (모든동작에서 필요)
			if(!await validStatusCheck()) { fnCallBackSR(); isSubmitting = false; return; }
			
			if(activityStatus == "05"){ // 완료 유효성 체크
				// 01. option 체크
				if(!await validOption()) { isSubmitting = false; return; }
				// 02. regex 체크
				if(!await fnCheckRegexAttr()) { isSubmitting = false; return; }
				
			}
			if(activityStatus == "05" || activityStatus == "04" || activityStatus == "06"){ // 기각 유효성 체크
				// 02. srAttr 필수입력체크
				var checkActivityStatus = "${checkActivityStatus}";
				var checkActivityMandatory = "${checkActivityMandatory}";
				
				if(checkActivityStatus === undefined || checkActivityStatus === null || checkActivityStatus === ""){
					if(!await fnCheckValidateActivityAttr()){
						isSubmitting = false;
						return;
					}
				}else{
					if(checkActivityStatus === activityStatus){
						if(!await fnCustomCheckValidateActivityAttr(checkActivityMandatory)){
							isSubmitting = false;
							return;
						}
					} else {
						if(!await fnCheckValidateActivityAttr()){
							isSubmitting = false;
							return;
						}
					}
				}
			}
			
			// 5. 추가화면 저장
			if(activityStatus == "05" || activityStatus == ""){
				// 완료예정일 저장
				if($("#SRAT0069").val() !== null && $("#SRAT0069").val() !== undefined && $("#SRAT0069").val() !== ''){
					var dueDate = $("#SRAT0069").val(); // 완료예정일
					$("#dueDate").val(dueDate);
				} else if($("#SRAT0078").val() !== null && $("#SRAT0078").val() !== undefined && $("#SRAT0078").val() !== ''){
					var dueDate = $("#SRAT0078").val(); // 조치완료예정일
					$("#dueDate").val(dueDate);
				} else if($("#SRAT0114").val() !== null && $("#SRAT0114").val() !== undefined && $("#SRAT0114").val() !== ''){
					var dueDate = $("#SRAT0114").val(); // 조치완료예정일(2선)
					$("#dueDate").val(dueDate);
				}
				
				// 완료예정일 저장 (단계별)
				if("${espDueDateMgt}" != "" && "${espDueDateMgt}" != null && "${espDueDateMgt}" !== undefined){
					var childWindow3 = document.getElementById('espDueDateMgtFrame').contentWindow;
					if(!await childWindow3.saveRow(activityStatus)) { isSubmitting = false; return false; }
				}
				
				// 개선관리 실적입력
				if("${scrOutputMgt}" == "Y"){
					var childWindow2 = document.getElementById('scrOutputRcdMgtFrame').contentWindow;
					if(!childWindow2.fnSave(activityStatus)) { isSubmitting = false; return false; }
				}
	
				// 운영실적 저장
				if("${mbrRcdMgt}" == "Y"){
// 					childWindow.saveMH(activityStatus);
					const saveMHResult = await callSaveMH(activityStatus);
					if(!saveMHResult) {
						isSubmitting = false;
						return false;
					}
				}
			}
			
			// 현재수행자 체크 및 저장 ( 1선 처리의 경우 )
			if("${responseUserYN}" == "Y"){
				$("#responseUserID").val("${sessionScope.loginInfo.sessionUserId}");
				$("#responseTeamID").val("${sessionScope.loginInfo.sessionTeamId}");
			}
			
			// 6. 액티비티 저장
			saveActivity();
			
			// 7. send
			if(changeInfo === "Y"){
				paramData += "&changeInfo=Y"; // 기준정보 변경
			} 
			
			var url = "saveSRActivityResult.do"+paramData;
			ajaxSubmit(document.srActvityFrm, url, "saveFrame");
		}
	}
	
	async function callSaveMH(activityStatus) {
	    try {
	        const saveResult = await childWindow.saveMH(activityStatus); 
	        return saveResult;
	    } catch (error) {
	        console.error("saveMH 호출 중 예기치 않은 오류 발생:", error);
	        return false;
	    }
	}
	
	function saveActivity() {

		// ATTR 저장
		const messageTemplate = "${WM00034}"; var message = "";
		var mLovCode = "";
		var AttrTypeValue;
		var mLovCodeValue;
		var k; var l;
		var dataType = "";
		
		const form = document.srActvityFrm;
    
		const formData = new FormData(form);
		const formObject = {};
		   
		formData.forEach((value, key) => {
			formObject[key] = value;
		});
		
		const jsonData = JSON.stringify(formObject);
		
		fetch('/saveSRActivity.do', {
			method: 'POST',
			body : jsonData,
			headers: {
				'Content-type': 'application/json; charset=UTF-8',
			},
		}).then(res => console.log(res))
		
	}
	
	
	// 파일 저장
	let fileTypeUpdateList = [];
	async function saveFile() {
		let fileList = [];
		const fileListContainer = document.querySelector("#tmp_file_items").children.namedItem("file-list").childNodes;
		fileListContainer.forEach(e => {
		    if(e.tagName === "TR" && e.children.namedItem("fileType")) fileList.push({"fileType" : e.children.namedItem("fileType").childNodes[0].value, "fileName" : e.children.namedItem("fileName").textContent})
		})
		
		if(fileList.length > 0 || fileTypeUpdateList.length > 0) {
			const res = await fetch('/saveEsrFile.do', {
				method: 'POST',
				body : JSON.stringify({
					srID : "${srInfoMap.SRID}",
					docCategory : "${docCategory}",
					projectID : "${srInfoMap.ProjectID}",
					speCode : "${srInfoMap.Status}",
					activityLogID : "${activityLogInfo.ActivityLogID}",
					fileList : fileList,
					fileTypeUpdateList : fileTypeUpdateList,
	            }),
				headers: {
					'Content-type': 'application/json; charset=UTF-8',
				},
			});
		}
	}
	
	// 연관 CI 체크
	function serviceItemCheck() {
		let result = "";
		fetch("/olmapi/serviceItem?srID=${srInfoMap.SRID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}", {
		}).then(res => res.json())
		.then(data => result = data.serviceItemCount > 0 ? true : false )
		
		return result;
	}
	
	function fnCheckActivityValidation(){
		var isCheck = true;		
		var srArea1 = $("#srArea1").val();
		var srArea2 = $("#srArea2").val();
		var category = $("#category").val();
		var subCategory = $("#subCategory").val();
		var subject = $("#subject").val();
		var opinion = $("#opinion").val();
		
		var dueDate = $("#activityDueDate").val().replaceAll("-","");
		var currDate = "${thisYmd}";
		var requestUser = $("#requestUserID").val();
		
		if(requestUser == "" || requestUser == null ){ alert("${WM00034_4}"); isCheck = false; return isCheck;}
		if(srArea1 == ""){ alert("${WM00025_1}"); isCheck = false; return isCheck;}
		if(srArea2 == ""){ alert("${WM00025_2}"); isCheck = false; return isCheck;}
		if(category == ""){ alert("${WM00025_3}"); isCheck = false; return isCheck;}
		if(subCategory == ""){ alert("${WM00025_3}"); isCheck = false; return isCheck;}
		if(subject == ""){ alert("${WM00034_1}"); isCheck = false; return isCheck;}
		if(dueDate == ""){alert("${WM00034_5}"); isCheck = false; return isCheck;}
		
		if(parseInt(dueDate) < parseInt(currDate) ){ 	
			alert("${WM00014}"); isCheck = false; return isCheck;
		} 
	 
		return isCheck;
	}
	
	// [기각] - BTN
	function fnRejectESP(){
		fnSaveActivityAttr('06');
	}
	
	// [반려] - BTN
	function fnDeniedESP(){
		fnSaveActivityAttr('04');
	}
	// [보류해제] - BTN
	async function fnCancelHold(){
		let msg = "";
		const msgObj = await getDicData("ERRTP", "ZLN0024");
		msg = msgObj.LABEL_NM;
		fnSaveActivityAttr('01', msg);
	}
	
	// [업무할당] - BTN
	async function fnTransferESP(){ 	
		
		// * 필수 중복 작업 체크 (모든동작에서 필요)
		if(!await validStatusCheck()) { fnCallBackSR(); return; }
		
		var url = "goTransferESPPop.do?isPopup=${isPopup}&srID=${srInfoMap.SRID}&esType=${srInfoMap.ESType}&srType=${srInfoMap.SRType}&procRoleTP2=${procRoleTP2}&blocked=${srInfoMap.Blocked}&srArea2=${srInfoMap.SRArea2}";
		window.open(url,'window','width=700, height=700, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	// [프로세스 변경] - BTN
	async function fnChangeESPPop(customUrl){ 	
		
		// 유효성체크
		// * 필수 중복 작업 체크 (모든동작에서 필요)
		if(!await validStatusCheck()) { fnCallBackSR(); return; }
		if(!await validOption()) { return; }
		if(!await fnCheckValidateActivityAttr()){ // srAttr 필수입력체크
			return;
		}
		saveFile();
		saveActivity();
		// 완료예정일 저장 (단계별)
		if("${espDueDateMgt}" != "" && "${espDueDateMgt}" != null && "${espDueDateMgt}" !== undefined){
			var childWindow3 = document.getElementById('espDueDateMgtFrame').contentWindow;
			if(!await childWindow3.saveRow("05")) { return false; }
		}
		
		var url = "goChangeESPPop.do?isPopup=${isPopup}&srID=${srInfoMap.SRID}&esType=${srInfoMap.ESType}&srType=${srInfoMap.SRType}&startSortNum=01";
		if(customUrl !== '' && customUrl !== null && customUrl !== undefined ){
			url += "&url=" + customUrl;
		}
		
		window.open(url,'window','width=1100, height=620, left=200, top=100,scrollbar=yes,resizble=0');
	}
	
	// [되돌리기] - BTN
	async function fnUndoActivityStatus() {
		// * 필수 중복 작업 체크 (모든동작에서 필요)
		if(!await validStatusCheck()) { fnCallBackSR(); return; }
		var msg = "";	
		const msgObj = await getDicData("ERRTP", "LN0011");
		msg = msgObj.LABEL_NM;
		
// 		if (confirm("전단계로 되돌리시겠습니까?")) {
		if (confirm(msg)) {
			var data = "srID=${srInfoMap.SRID}&srType=${srInfoMap.SRType}&status=${srInfoMap.Status}&languageID=${sessionScope.loginInfo.sessionCurrLangType}&activityStatus=${activityLogInfo.Status}";
			var url = "UndoActivityStatus.do";
			var target = "saveFrame";
			ajaxPage(url, data, target);
		}
	}
    
    // [승인요청] - BTN
	async function fnReqITSApproval(){ //zDlm_wfDocMgt.do
		if(inProgressWf) {
//				alert("승인요청중 입니다.");
			getDicData("ERRTP", "ZLN0013").then(data => alert(data.LABEL_NM));
			return;
		}

	    inProgressWf = true;
	    blockEnter = true;   // 승인요청 시작 시 Enter 차단
	    
	    try{
			// 유효성체크
			// * 필수 중복 작업 체크 (모든동작에서 필요)
			if(!await validStatusCheck()) { fnCallBackSR(); inProgressWf = false; return; }
			if(!await validOption()) { inProgressWf = false; return; }
			if(!await fnCheckValidateActivityAttr()){ // srAttr 필수입력체크
				inProgressWf = false; blockEnter = true; return;
			}
			
			// 공문번호 유무 체크
			var SRAT0018 = $("#SRAT0018").val();
			if(SRAT0018 !== "" && SRAT0018 !== null && SRAT0018 !== undefined){
	// 			alert("전자결재 공문번호 입력시 전자결재 요청이 불가능합니다");
				getDicData("ERRTP", "ZLN0012").then(data => alert(data.LABEL_NM));
				inProgressWf = false; 
				blockEnter = true;
				return;
			}
			
	
			var msg = "";
			const msgObj = await getDicData("ERRTP", "ZLN0018");
			msg = msgObj.LABEL_NM;
	// 		if (confirm("전자결재 반려될 시 티켓이 종료됩니다. 승인 요청 하시겠습니까?")) {
			if (confirm(msg)) {
				
				// 완료예정일 저장 (단계별)
				if("${espDueDateMgt}" != "" && "${espDueDateMgt}" != null && "${espDueDateMgt}" !== undefined){
					var childWindow3 = document.getElementById('espDueDateMgtFrame').contentWindow;
					if(!await childWindow3.saveRow("05")) { inProgressWf = false; return false; }
				}
				
				// 개선관리 실적입력
				if("${scrOutputMgt}" == "Y"){
					var childWindow2 = document.getElementById('scrOutputRcdMgtFrame').contentWindow;
					if(!childWindow2.fnSave("05")) { inProgressWf = false; return false; }
				}
				
				// 운영 실적입력
				if("${mbrRcdMgt}" == "Y"){
					//childWindow.saveMH("05");
					const saveMHResult = await callSaveMH("05");
					if(!saveMHResult) {
						inProgressWf = false;
						blockEnter = true;
						return false;
					}
				}
				
				$('#loading').fadeIn(150);
				// sr file 저장
				try {await saveFile();} catch (e) {alert("An error occurred while saving the file."); console.error(e); inProgressWf = false;blockEnter = true; return;}
	
				// sr attr 저장			
				try {await saveActivity();} catch (e) {alert("An error occurred while saving the attribute."); console.error(e); inProgressWf = false; blockEnter = true; return;}
				
				var inhouse = "${inhouse}";
				var defApprovalSystem = "${defApprovalSystem}";
				var url = "zDlm_wfDocMgt.do";
				if(defApprovalSystem == "YO") url =  "zYO_wfDocMgt.do?";
				else if(defApprovalSystem == "OLM") url =  "${wfURL}.do?";	// wfDocItsmMgt.do			
				
				var data = "srID=${srInfoMap.SRID}" 
						+ "&docSubClass=${srInfoMap.Status}&docCategory=SPE"
						+ "&WFDocURL=${WFDocURL}&ProjectID=${srInfoMap.ProjectID}&defWFID=${srInfoMap.DefWFID}"				
						+ "&srRequestUserID=${srInfoMap.RequestUserID}"
						+ "&srRequestTeamID=${srInfoMap.RequestTeamID}"
						+ "&isPop=Y&blockSR=Y&wfDocType=SR&actionType=create"
						+ "&speCode=${srInfoMap.Status}&customerNo=${srInfoMap.ClientID}"
						+ "&activityLogID=${activityLogInfo.ActivityLogID}"
						+ "&srCode=${srInfoMap.SRCode}"
						+ "&documentID=${activityLogInfo.ActivityLogID}"
						+ "&documentNo=${srInfoMap.SRCode}"
						+ "&inhouse="+inhouse // Y:영원, null:olm  결재 
						+ "&category=${srInfoMap.Category}"
						+ "&subCategory=${srInfoMap.SubCategory}"
						+ "&actorID=${activityLogInfo.ActorID}";						
						console.log("data =>" + data);
						
						if(defApprovalSystem == "OLM") { // SFOLM 팝업 내부 결재 상신 방식
							$('#loading').fadeOut(150);
							data += "&wfDocPopYN=Y";
							var w = 950;
							var h = 700;
							inProgressWf = false;
							blockEnter = false;
							window.open(url+data,'window','width='+w+', height='+h+', left=200, top=100,scrollbar=yes,resizable=yes,resizblchangeTypeListe=0');
			            }else {
			            	var target = "saveFrame";
							ajaxPage(url, data, target);
			            }
					
				
			} else {
				inProgressWf = false;
				blockEnter = false;
			}
		} catch (e) {
	     console.error(e);
	     inProgressWf = false;
	     blockEnter = false;   // 승인요청 시작 시 Enter 차단
	     $('#loading').fadeOut(150);
	     alert("처리 중 오류가 발생했습니다.");
	    }
	}
	
	function fnWFDetail(){
		var projectID = "${wfInstInfo.ProjectID}";
		var wfID = "${wfInstInfo.WFID}";	
		var stepInstID = "${wfInstInfo.StepInstID}";;
		var actorID = "${wfInstInfo.ActorID}";
		var stepSeq = "${wfInstInfo.StepSeq}";
		var wfInstanceID = "${wfInstInfo.WFInstanceID}";
		var lastSeq = "${wfInstInfo.LastSeq}";
		var documentID = "${wfInstInfo.DocumentID}";
		var docCategory = "${wfInstInfo.DocCategory}";
		var statusCode = "${wfInstInfo.StatusCode}";
		var defApprovalSystem = "${defApprovalSystem}";
		
		var url =  "zDlm_wfDocMgt.do?"; // zDlm_wfDocMgt.do
			if(defApprovalSystem == "YO") url =  "zYO_wfDocMgt.do?"; 
			else if(defApprovalSystem == "OLM") url = "wfDocItsmMgt.do?";
			
			console.log("defApprovalSystem :"+defApprovalSystem);
		var data = "projectID="+projectID
					+"&stepInstID="+stepInstID
					+"&actorID="+actorID
					+"&stepSeq="+stepSeq
					+"&wfInstanceID="+wfInstanceID
					+"&wfID="+wfID
					+"&documentID="+documentID
					+"&wfMode=${wfMode}"
					+"&lastSeq="+lastSeq
					+"&documentNo=${wfInstInfo.DocumentNo}"
					+"&docCategory="+docCategory
					+"&actionType=view"
					+"&inhouse=${inhouse}";

		var w = 1200;
		var h = 650; 
		itmInfoPopup(url+data,w,h);
    }

	function textfileSize(e) {
		if(e === '0') return '0'
		else return getFileSize(e);
	}
	

	// 07. [전자결재 공문 PASS] - BTN
	async function fnAprvPass() {
		
		// 공문번호 check
		var SRAT0018 = $("#SRAT0018").val();
		if(SRAT0018 == "" || SRAT0018 == null || SRAT0018 === undefined){
			const msgObj = await getDicData("ERRTP", "LN0004");
			alert("${WM00034_8}");
			return false;
		} else {
			var form = document.getElementById('srActvityFrm');
			
			var hiddenInput = document.createElement('input');
			hiddenInput.type = 'hidden';
			hiddenInput.name = 'wfInstanceStatus';
			hiddenInput.value = '2';

			form.appendChild(hiddenInput);
			
// 			let msg = "전자결재 공문처리 하시겠습니까?";
			let msg = "";
			const msgObj = await getDicData("ERRTP", "ZLN0019");
			msg = msgObj.LABEL_NM;
			fnSaveActivityAttr('05',msg);
		}
	}
	
	// [선처리] - BTN
	const html = "<div class='new-form'><textarea id='PRE_SRAT0019' class='edit pdB10 pdL10 pdR10 pdT10' style='width: 100%;height: 200px;resize: none;'></textarea><div class='floatR btns mgT15'><button id='preProcessingSave'></button></div></div>";
	const dhxWindow2 = new dhx.Window({
	    width: 440,
	    height: 360,
	    title: "${menu.ZLN0175}",
	    modal: true,
	    closable: true,
	});
	dhxWindow2.attachHTML(html);
	
	function fnPreprocessing() {
		dhxWindow2.show();
		
		if(!document.getElementById("preProcessingSave").classList.contains("primary")) {
			fnSetButton("preProcessingSave", "", "Save");
		}
		
		$("#preProcessingSave").on("click", async function(){
			var SRAT0019 = $("#PRE_SRAT0019").val();
			if(SRAT0019 == "" || SRAT0019 == null || SRAT0019 === undefined){
				alert("${WM00034_9}"); return false;
			}else {
				var isEditableAfterReception = "${isEditableAfterReception}";
				if(isEditableAfterReception === "N"){
					 const input = document.createElement("input");
					 input.type = "text";             
					 input.name = "SRAT0019";
					 input.id = "SRAT0019";  
					 input.value = SRAT0019;
					 
					 const form = document.getElementById("srActvityFrm");
					 if(form) form.appendChild(input);
					 
					 $("#editMode").val("Y");
					 
				} else {
					$("#SRAT0019").val(SRAT0019);
				}
				dhxWindow2.hide();
				let msg = "";
				const msgObj = await getDicData("ERRTP", "LN0012");
				msg = msgObj.LABEL_NM;
				fnSaveActivityAttr('01', msg);
			}
		});
	}
	
	// 보완요청 - BTN
	async function fnReqImprove(){
		let msg = "";
		const msgObj = await getDicData("ERRTP", "LN0013");
		msg = msgObj.LABEL_NM;
		
// 		if (confirm("보완요청 하시겠습니까?")) {
		if (confirm(msg)) {
			
			
			// * 필수 중복 작업 체크 (모든동작에서 필요)
			if(!await validStatusCheck()) { fnCallBackSR(); return; }
			// 01. option 체크
			if(!await validOption()) { return; }
			// 02. srAttr 필수입력체크
			if(!await fnCheckValidateActivityAttr()){
				return;
			}
			
			// 03. 액티비티 저장
			saveFile();
			saveActivity();
			
			// 04. 재처리 업데이트
			if(!await updateLogStatus(${undoSpeCode})){
				return;	
			}
			// 5. send
			var inputElement = document.createElement('input');
			inputElement.type = 'hidden';  
			inputElement.id = 'SRAT0097';
			inputElement.name = 'SRAT0097';
			inputElement.value = '02';   
			
			var inputElement2 = document.createElement('input');
			inputElement2.type = 'hidden';  
			inputElement2.id = 'actionParameter';
			inputElement2.name = 'actionParameter';
			inputElement2.value = 'SRAT0097';   
	
			document.getElementById('srActvityFrm').appendChild(inputElement);
			document.getElementById('srActvityFrm').appendChild(inputElement2);
			
			var url = "saveSRActivityResult.do?activityStatus=05&srLogType=I&srArea2=${srInfoMap.SRArea2}&srArea1=${srInfoMap.SRArea1}";
			ajaxSubmit(document.srActvityFrm, url, "saveFrame");
			
		}
	}
	
	// 링크 호출
	function fnCallLink(url){
		if(url !== undefined && url !== null && url !== ''){
			window.open(url,"","width=" + screen.width + " height=" + screen.height);
		}
	}
	
	// 로그 업데이트 
	async function updateLogStatus(updateSpeCode){
		if(updateSpeCode !== undefined && updateSpeCode !== '' && updateSpeCode !== null) {
  			
  			const response = await fetch('/olmapi/espActivityLogUpdate', {
				method: 'POST',
				body : JSON.stringify({
					srID : "${srInfoMap.SRID}",
					languageID : "${sessionScope.loginInfo.sessionCurrLangType}",
					updateSpeCode : updateSpeCode,
	            }),
				headers: {
					'Content-Type': 'application/json; charset=UTF-8',
				},
			});
			
			const data = await response.json();
			
			if (data.result === false) {
// 				alert("보완요청 중 오류가 발생했습니다!");
				getDicData("ERRTP", "ZLN0014").then(data => alert(data.LABEL_NM));
			    return false;
			} else {
				return true;
			}
  			
  		}
	}
	
	
	// 09.ATTR CTRL TYPE 체크
	function checkPositiveValueDate(inputElement, ctrlType, name){
		inputElement.value = makeDateType(inputElement.value);
		if(ctrlType == "1"){
			// 현재 기준으로 미래 날짜만 가능
			if(inputElement.value < today) {
// 				alert(name + "은(는) 금일 이후일자만 등록가능합니다.");
				getDicData("ERRTP", "LN0005").then(data => alert(name + data.LABEL_NM));
				inputElement.value = '';
			};
		}
	}
	
	/* 첨부문서 다운로드 */
	function FileDownload(checkboxName, isAll){
		var originalFileName = new Array();
		var sysFileName = new Array();
		var seq = new Array();
		var j =0;
		var checkObj = document.all(checkboxName);
		
		// 모두 체크 처리를 해준다.
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = true;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = true;
			}
			
		}
	
		// 하나의 파일만 체크 되었을 경우
		if (checkObj.length == undefined) {
			if (checkObj.checked) {
				seq[0] = checkObj.value;
				j++;
			}
		};
		for (var i = 0; i < checkObj.length; i++) {
			if (checkObj[i].checked) {
				seq[j] = checkObj[i].value;
				j++;
			}
		}
		if(j==0){
			alert("${WM00049}");
			return;
		}
		j =0;
		var url  = "fileDownload.do?seq="+seq+"&scrnType=SR";
		ajaxSubmitNoAdd(document.receiptSRFrm, url,"saveFrame");
		// 모두 체크 해제
		if (isAll == 'Y') {
			if (checkObj.length == undefined) {
				checkObj.checked = false;
			}
			for (var i = 0; i < checkObj.length; i++) {
				checkObj[i].checked = false;
			}
		}
	}
	
	function fileNameClick(avg1){
		var seq = new Array();
		seq[0] = avg1;
		var url  = "fileDownload.do?seq="+seq+"&scrnType=SR";
		ajaxSubmitNoAdd(document.receiptSRFrm, url,"saveFrame");
	}
	
	var fileIDMapV4 = new Map();
	var fileNameMapV4 = new Map();
	var fileSizeMapV4 = new Map();
	var duplMap = new Map();
	let duplMsg = false;
	
	//************** addFilePop V4 설정 START ************************//
	function getKeyByValue(map, searchValue) {
	  for (let [key, value] of map.entries()) {
	    if (value === searchValue)
	      return key;
	  }
	}
	
	function doAttachFileV4(){		
		var url="addFilePopV4.do";
		var data="scrnType=SR&docCategory=${docCategory}"
				+"&activityLogID=${activityLogInfo.ActivityLogID}"
				+"&speCode=${srInfoMap.Status}"
				+"&srType=${srType}";
		openPopup(url+"?"+data,490,450, "Attach File");
	} 

	function fnAttacthFileHtmlV4(fileID, fileName, fileSize, fltpCode){ 
		duplMsg = false;
		// 새로 추가한 리스트에 있거나
		const id = getKeyByValue(fileNameMapV4, fileName);
		
		//기존 파일 리스트에 가지고 있는 경우
		document.getElementsByName("fileName").forEach(e => {
			if(e.innerText == fileName) {
				duplMsg = true;
				fetch("/removeFile.do?fileName="+fileName);
			}
		});
		
		fileID = fileID.replace("u","");
		if(!id && !duplMsg) {
			fileIDMapV4.set(fileID,fileID,fileSize);
			fileNameMapV4.set(fileID,fileName);
			fileSizeMapV4.set(fileID,fileSize);
		} else {
			duplMap.set(fileID,fileName);
		}
	}
	
	// addFilePopV4에서 파일 삭제시, fileMap에서 해당파일 제거 
	function fnDeleteFileMapV4(fileID, fileName){
		fileID = fileID.replace("u","");
		
		if(!getKeyByValue(duplMap, fileName)) {			
			fetch("/removeFile.do?fileName="+fileName);
	
			fileIDMapV4.delete(String(getKeyByValue(fileNameMapV4, fileName)));
			fileNameMapV4.delete(String(getKeyByValue(fileNameMapV4, fileName)));
			fileSizeMapV4.delete(String(getKeyByValue(fileNameMapV4, fileName)));
		}		
	}
	
	async function fnDisplayTempFileV4(){
		if(fileTypeList.length === 0) {
  			fileTypeList = await fetch("/olmapi/espFileType/?languageID=${sessionScope.loginInfo.sessionCurrLangType}&scrnType=SR&docCategory=${docCategory}&activityLogID=${activityLogInfo.ActivityLogID}&speCode=${srInfoMap.Status}&srType=${srType}")
  			.then((response) => response.json())
  			.then(data => fileTypeList = data)
  		}
		
		let html = '<select>';
		fileTypeList.forEach(e => {
			html += `<option value="\${e.CODE}">\${e.NAME}</option>`
		});
		html += '</select>';
		
		let display_scripts = "";
		fileIDMapV4.forEach(function(fileID) {
			if(!document.getElementById(fileID)) {
				display_scripts += '<tr id="'+fileID+'"  class="" name="'+fileID+'">'+
				'<td class="delete"><svg xmlns="http://www.w3.org/2000/svg" onclick="fnDeleteFileHtmlV4('+fileID+')" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"/></svg></td>'+
				'<td name="fileType">'+
				html+
				'</td>'+
				'<td name="fileName">'+ fileNameMapV4.get(fileID)+'</td>'+
				'<td class="alignR">'+ getFileSize(fileSizeMapV4.get(fileID))+'</td>'+
				'</tr>';
			}
		});
		
		document.querySelector("#tmp_file_items").children.namedItem("file-list").insertAdjacentHTML("beforeend",display_scripts);
		document.querySelector("#tmp_file_wrapper").style.display = "block";
		
// 		if(duplMsg) alert("동일한 파일은 중복 업로드 되지 않습니다."); 
		if(duplMsg) getDicData("ERRTP", "LN0006").then(data => alert(data.LABEL_NM));
	}
	 
	//  dhtmlx v 4.0 delete file  
	function fnDeleteFileHtmlV4(fileID){
		const duplKey = getKeyByValue(duplMap, fileNameMapV4.get(String(fileID)));
		if(duplKey) {
			duplMap.delete(duplKey);
		}
		var fileName = document.getElementById(fileID).children.namedItem("fileName").innerHTML;
		fileIDMapV4.delete(String(fileID));
		fileNameMapV4.delete(String(fileID));
		fileSizeMapV4.delete(String(fileID));
		
		if(fileName != "" && fileName != null && fileName != undefined){
			$("#"+fileID).remove();
			var url  = "removeFile.do";
			var data = "fileName="+fileName;	
			ajaxPage(url,data,"saveFrame");
		}
	
		if(document.querySelector("#tmp_file_items").children.namedItem("file-list").children.length === 0)
			document.querySelector("#tmp_file_wrapper").style.display = "none";
	} 
	//************** addFilePop V4 설정 END ************************//
	
	// 기존 파일 삭제
	function fnDeleteESRFile(srID, seq, fileName, filePath){
		var url = "deleteSRFile.do";
		var data = "srID="+srID+"&Seq="+seq+"&realFile="+filePath+fileName;
		ajaxPage(url, data, "saveFrame");
		$("#"+seq).remove();
	}
	
	// API
	async function getAttr() {
		try{
			const res = await fetch("/olmapi/srAttr?srID=${srInfoMap.SRID}&srType=${srInfoMap.SRType}&speCode=${srInfoMap.Status}&docCategory=${docCategory}&showInvisible=${showInvisible}&languageID=${sessionScope.loginInfo.sessionCurrLangType}");
			srAttrList = await res.json();
			srAttrList = srAttrList.data;
		} catch(error) {
			console.log(error);
		}
	}
	
	function settingSRAttrList(){
		
		let html = "";
		for(var i = 0; i < srAttrList.length; i++) {
			html += '<tr>';
			html += '<th>';
			if(srAttrList[i].Mandatory == "1") html += '<p style="display:inline;color:#FF0000;">*</p>';
			html += srAttrList[i].Name;
			html += '</th>';
			html += '<td colspan="3">';
			
			let value = srAttrList[i].PlainText == "" || srAttrList[i].PlainText === undefined ? srAttrList[i].DefaultValue ? srAttrList[i].DefaultValue : "" : srAttrList[i].PlainText;
			let dateValue = srAttrList[i].PlainText == "" || srAttrList[i].PlainText === undefined ? "" : srAttrList[i].PlainText;
			
			if("${editMode}" == "Y") {
				if(srAttrList[i].DataType == "Text") {
					if(srAttrList[i].Editable == "1") {
						if(srAttrList[i].HTML == "1") {
							html += '<textarea class="tinymceText" id="'+srAttrList[i].AttrTypeCode+'" name="'+srAttrList[i].AttrTypeCode+'" style="height:'+srAttrList[i].AreaHeight+'px;">';
							html += value;
							html += '</textarea>';
						} else {
							// 정규식 체크 TODO
							html += '<textarea class="edit" id="'+srAttrList[i].AttrTypeCode+'" name="'+srAttrList[i].AttrTypeCode+'" style="height:'+srAttrList[i].AreaHeight+'px;">';
							html += value;
							html += '</textarea>';
						}
					} else {
						if(srAttrList[i].HTML == "1") {
							html += '<textarea class="tinymceText" id="'+srAttrList[i].AttrTypeCode+'" name="'+srAttrList[i].AttrTypeCode+'" style="height:'+srAttrList[i].AreaHeight+'px;"  readonly="readonly"><div class="mceNonEditable">'+value+'</div></textarea>';
						} else {
							html += '<textarea id="'+srAttrList[i].AttrTypeCode+'" name="'+srAttrList[i].AttrTypeCode+'" style="height:'+srAttrList[i].AreaHeight+'px;" readonly="readonly">'+value+'</textarea>';
						}
					}
				}
				
				if(srAttrList[i].DataType == "LOV") {
					if(srAttrList[i].Editable == "1") {
						if(srAttrList[i].Style == "radio") {
							html += '<div id="'+srAttrList[i].AttrTypeCode+'">';
							getAttrLovList(srAttrList[i].AttrTypeCode,srAttrList[i].LovCode,srAttrList[i].SubAttrTypeCode,srAttrList[i].Mandatory, srAttrList[i].DefaultValue,srAttrList[i].Style,srAttrList[i].VarFilter);
							html += '</div>';
						} else {
							html += '<select id="'+srAttrList[i].AttrTypeCode+'" name="'+srAttrList[i].AttrTypeCode+'"  class="sel" OnChange="fnGetSubAttrTypeCode(\''+srAttrList[i].VarFilter+'\',this.value,\''+srAttrList[i].AttrTypeCode+'\')" ></select>';
							getAttrLovList(srAttrList[i].AttrTypeCode,srAttrList[i].LovCode,srAttrList[i].SubAttrTypeCode,srAttrList[i].Mandatory, srAttrList[i].DefaultValue,srAttrList[i].Style,srAttrList[i].VarFilter);
						}
					} else {
						html += value;
						html += '<input type="hidden" name="'+srAttrList[i].AttrTypeCode+'" id="'+srAttrList[i].AttrTypeCode+'" value="'+srAttrList[i].LovCode+'" />';
					}
				}
				
				if(srAttrList[i].DataType == "Date") {
					html += '<ul><li style="position: relative;">';
					if(srAttrList[i].Editable == "1") {
						
						// Date 의 기본값이 today일 경우 오늘날짜 입력
						if((dateValue === "" || dateValue === null || dateValue === undefined ) && srAttrList[i].DefaultValue == "today"){
							dateValue = today;
						} else {
							if(value) value = value.substring(0, 10);
							dateValue = value;
						}
						
						html += '<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>';
						html += '<input type="text" id="'+srAttrList[i].AttrTypeCode+'" name="'+srAttrList[i].AttrTypeCode+'" value="'+dateValue+'" class="text datePicker" size="12" style="width: 100px;" onchange="checkPositiveValueDate(this,  '+srAttrList[i].CtrlType+', \''+srAttrList[i].Name+'\')" maxlength="10">';
					} else {
						html += '<input type="text" id="'+srAttrList[i].AttrTypeCode+'" name="'+srAttrList[i].AttrTypeCode+'" value="'+value+'" class="text alignC" size="12" style="width: 100px; " readOnly>';
					}
					html += '</li></ul>';
				}
				
				if(srAttrList[i].DataType == "Time") {
					html += '<ul><li style="position: relative;">';
					if(srAttrList[i].Editable == "1") {
						
						// Date 의 기본값이 today일 경우 오늘날짜 입력
						if((dateValue === "" || dateValue === null || dateValue === undefined ) && srAttrList[i].DefaultValue == "today"){
							dateValue = today + ' ' + getCurrentTime();
						} else dateValue = value;
						
						html += '<fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy-MM-dd" var="thisYmd"/>';
						let dataVal = dateValue.split(" ");
						let timeVal = dataVal[1] == "" || dataVal[1] === undefined ? "" : dataVal[1];
						
						if(timeVal) timeVal = timeVal.substring(0, 5);
						
						html += '<input type="text" id="'+srAttrList[i].AttrTypeCode+'" name="'+srAttrList[i].AttrTypeCode+'" value="'+dataVal[0]+'" class="text datePicker" size="12" style="width: 100px;" onchange="checkPositiveValueDate(this, '+srAttrList[i].CtrlType+', \''+srAttrList[i].Name+'\')" maxlength="10">';
						html += '<input type="text" id="'+srAttrList[i].AttrTypeCode+'_Time" name="'+srAttrList[i].AttrTypeCode+'_Time" class="mgL5 timePicker input_off text ui-timepicker-input" size="8" maxlength="10" value="'+timeVal+'" autocomplete="off">';
					} else {
						html += '<input type="text" id="'+srAttrList[i].AttrTypeCode+'" name="'+srAttrList[i].AttrTypeCode+'" value="'+value+'" class="text alignC" size="12" style="width: 100px; " readOnly>';
					}
					html += '</li></ul>';
				}
			} else {
				
				if(srAttrList[i].DataType == "Date") if(srAttrList[i].PlainText) srAttrList[i].PlainText = srAttrList[i].PlainText.substring(0, 10);
				if(srAttrList[i].DataType == "Time") if(srAttrList[i].PlainText) srAttrList[i].PlainText = srAttrList[i].PlainText.substring(0, 5);
				var noEditValue = srAttrList[i].PlainText == "" || srAttrList[i].PlainText === undefined ? "" : '<textarea style="height:'+srAttrList[i].AreaHeight+'px;" readonly="readonly">'+srAttrList[i].PlainText + '</textarea>';
				html += noEditValue; // defult value X 
			}
			
			html += '</td>';
			html += '</tr>';
		}
		
		document.querySelector("#attr").insertAdjacentHTML("beforeend", html);
		
		$("input.datePicker").each(generateDatePicker);
		$('input.timePicker').timepicker({
            timeFormat: 'H:i',
        });
		
	}
	
	function getCurrentTime() {
	    const now = new Date();
	    const hours = String(now.getHours()).padStart(2, '0');
	    const minutes = String(now.getMinutes()).padStart(2, '0');
	    return hours + ':' + minutes;
	}
	
	
	async function getSrFileList() {
	    document.querySelector("#fileList").innerHTML = '';

	    const res = await fetch("/olmapi/activityFile?srID=${srInfoMap.SRID}&speCode=${srInfoMap.Status}&languageID=${sessionScope.loginInfo.sessionCurrLangType}");
	    const data = await res.json();
	    
	    let html = "";
	    let style = "";
	    
	    if(data !== undefined && data !== null && data !== ''){
		    if("${editMode}" == "Y") {
		    	
		    	html += '<div style="display:flex; align-items:center; gap:5px;">';
				html += '<button id="attach" onclick="doAttachFileV4()"></button>';
				
				// download template File 
				html += '<button id="downTempFile" onclick="fnDownloadTempFile()" style="margin-left:5px;">Download Template File</button>';
				html += '</div>';
				
				
				style = data.data.length > 0 ? "width:60%;" : "display:none;";
				html += '<div class="tmp_file_wrapper mgT10" style="'+style+'" id="tmp_file_wrapper">';
				html += '<table id="tmp_file_items" name="tmp_file_items" width="100%">';
				html += '<colgroup><col width="40px"><col width="170px"><col width=""><col width="70px"></colgroup>';
				html += '<tbody name="file-list">';
				for(var i = 0; i < data.data.length; i++) {
					html += '<tr id="'+data.data[i].Seq+'">';
					html += '<td class="delete"><svg xmlns="http://www.w3.org/2000/svg" onclick="fnDeleteESRFile(\'${srInfoMap.SRID}\',\''+data.data[i].Seq+'\',\''+data.data[i].FileName+'\',\''+data.data[i].srFilePath+'\')" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368"><path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"/></svg></td>';
					html += '<td name="fileType">' + await selectFileType(data.data[i].fltpcode, i, data.data[i].Seq) + '</td>';
					html += '<td name="fileName">'+data.data[i].FileRealName+'</td>';
					html += '<td class="alignR">'+textfileSize(data.data[i].FileSize)+'</td>';
					html += '</tr>';
				}
				html += '</tbody>';
				html += '</table>';
				html += '</div>';
			} else {
				//html += '<button id="attach" onclick="doAttachFileV4()"></button>';
				style = data.data.length > 0 ? "width:50%;" : "display:none;";
				html += '<div class="tmp_file_wrapper" style="'+style+'" id="tmp_file_wrapper">';
				html += '<table id="tmp_file_items" name="tmp_file_items" width="100%">';
				html += '<colgroup><col width="40px"><col width="170px"><col width=""><col width="70px"></colgroup>';
				html += '<tbody name="file-list">';
				for(var i = 0; i < data.data.length; i++) {
					html += '<tr>';
					html += '<td><svg onclick="fileNameClick('+data.data[i].Seq+');" class="downloadable" xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 -960 960 960" width="20px" fill="#434343"><path d="M480-336 288-528l51-51 105 105v-342h72v342l105-105 51 51-192 192ZM263.72-192Q234-192 213-213.15T192-264v-72h72v72h432v-72h72v72q0 29.7-21.16 50.85Q725.68-192 695.96-192H263.72Z"/></svg></td>';
					html += '<td>'+data.data[i].FltpNM+'</td>';
					html += '<td class="downloadable" onclick="fileNameClick('+data.data[i].Seq+');">'+data.data[i].FileRealName+'</td>';
					html += '<td class="alignR">'+textfileSize(data.data[i].FileSize)+'</td>';
					html += '</tr>';
				}
				html += '</tbody>';
				html += '</table>';
				html += '</div>';
			}
		    
		    //fileAttachCheck
		    html += '<span id="attachFileCheckText" style="margin-top: 5px; display:inline-block; color:#0761cf;"></span>'
			document.querySelector("#fileList").insertAdjacentHTML("beforeend", html);
			fnSetButton("attach", "attach", "Attach", "tertiary");
			
			fnSetButton("downTempFile", "download", "Download Template File", "tertiary");
		 
			setAttachFileCheck();
	    }
		    
	}
	
	//fileAttachCheck
	async function setAttachFileCheck(){
	    const attachFileCheckList = await setAttachFileCheckList();
	    if(attachFileCheckList !== undefined && attachFileCheckList !== '' && attachFileCheckList !== null){
	    	$("#attachFileCheckText").text("*${menu.ZLN0176} : " + attachFileCheckList);
	    	$(".fileListTH").each(function() {
	    	    $(this).find("font").remove();
	    	    $(this).prepend('<font style="color:red">*</font>');
	    	});
	    }
	}
	
	// 필수첨부파일 list
	async function setAttachFileCheckList(fileList){
		let SRAT0004 = document.querySelector('input[name="SRAT0004"]:checked') ? document.querySelector('input[name="SRAT0004"]:checked').value : $("#SRAT0004").val();
	    //if(SRAT0004 !== undefined && SRAT0004 !== null && SRAT0004 !== ''){
	    	const response = await fetch('/olmapi/espActivityFileCheck', {
				method: 'POST',
				body : JSON.stringify({
					srID : "${srInfoMap.SRID}",
					languageID : "${sessionScope.loginInfo.sessionCurrLangType}",
					clientID : "${srInfoMap.ClientID}",
					speCode : "${srInfoMap.Status}",
					SRAT0004 : SRAT0004
	            }),
				headers: {
					'Content-Type': 'application/json; charset=UTF-8',
				},
			});
			
			// 첨부파일 리스트 가져오기 ( fltpCode / fltpCodeNM )
			const attachCheckList = await response.json();
			
			let attachFileCheckList = '';
			
			if (attachCheckList && attachCheckList.length > 0) {
				attachCheckList.forEach(item => {
					if(fileList !== undefined && fileList !== '' && fileList !== null){
						if (!fileList.includes(item.FltpCode)) {
					        if(attachFileCheckList === '') attachFileCheckList = item.Name;
					        else attachFileCheckList += ',' + item.Name;
					    }
					} else {
				        if(attachFileCheckList === '') attachFileCheckList = item.Name;
				        else attachFileCheckList += ',' + item.Name;
					}
				});
			}
			
			if(attachFileCheckList !== '' && attachFileCheckList !== null && attachFileCheckList !== undefined){
				return attachFileCheckList;
			}
	    //}
	}
	
	// 필수 산출물 체크
	async function attachFileCheck() {
		
		let fileList = [];
		
		const fileListContainer = document.querySelector("#tmp_file_items").children.namedItem("file-list").childNodes;
		fileListContainer.forEach(e => {
		    if(e.tagName === "TR" && e.children.namedItem("fileType")) fileList.push(e.children.namedItem("fileType").childNodes[0].value)
		})
		
		//fileAttachCheck
	    const attachFileCheckList = await setAttachFileCheckList(fileList);
		if(attachFileCheckList !== '' && attachFileCheckList !== null && attachFileCheckList !== undefined){
// 			alert("필수 첨부파일이 없습니다. [" + attachFileCheckList + "]\n※ 첨부파일의 문서유형을 확인바랍니다");
			getDicData("ERRTP", "ZLN0003").then(data => alert(data.LABEL_NM.replace("replaceText", attachFileCheckList)));
		    return false;
		}else{
			return true;
		}
	}

	// [FileType Select List]
	async function selectFileType(defaultValue, ind, seq) {
		// FileType setting
  		if(fileTypeList.length === 0) {
  			fileTypeList = await fetch("/olmapi/espFileType/?languageID=${sessionScope.loginInfo.sessionCurrLangType}&scrnType=SR&docCategory=${docCategory}&activityLogID=${activityLogInfo.ActivityLogID}&speCode=${srInfoMap.Status}&srType=${srType}")
  			.then((response) => response.json())
  			.then(data => fileTypeList = data)
  		}

    	let html = `<select onchange="setFlleTypeUpdateList(this, \${seq})">`;
	    fileTypeList.forEach(e => {
	        if (e.CODE == defaultValue) {
	            html += `<option value="\${e.CODE}" selected>\${e.NAME}</option>`;
	        } else {
	            html += `<option value="\${e.CODE}">\${e.NAME}</option>`;
	        }
	    });
	    html += '</select>';

    	return html;
	}

	function setFlleTypeUpdateList(e, seq) {
		if(fileTypeUpdateList.filter(e => e.seq === seq).length === 0) fileTypeUpdateList.push({ "seq" : seq, "fileType" : e.value});
		else fileTypeUpdateList[fileTypeUpdateList.findIndex(e => e.seq === seq)] = { "seq" : seq, "fileType" : e.value};
	}
	
	
	//----------------------------------------------
	// youngone 전자 결재 테스트 
	
	async function fnReqITSApproval_zYO(){ //zYO_wfDocMgt.do
		// 유효성체크
		// * 필수 중복 작업 체크 (모든동작에서 필요)
		
		if(!await validStatusCheck()) { fnCallBackSR(); return; }
		if(!await validOption()) { return; }
		if(!await fnCheckValidateActivityAttr()){ // srAttr 필수입력체크
			return;
		}
		
		// 공문번호 유무 체크
		var SRAT0018 = $("#SRAT0018").val();
		if(SRAT0018 !== "" && SRAT0018 !== null && SRAT0018 !== undefined){
			//alert("전자결재 공문번호 입력시 전자결재 요청이 불가능합니다");
			getDicData("ERRTP", "ZLN0012").then(data => alert(data.LABEL_NM));
			return;
		}
		
		var msg = "";
		const msgObj = await getDicData("ERRTP", "ZLN0018");
		msg = msgObj.LABEL_NM;
		if (confirm(msg)) {
		
			// 완료예정일 저장 (단계별)
			if("${espDueDateMgt}" != "" && "${espDueDateMgt}" != null && "${espDueDateMgt}" !== undefined){
				var childWindow3 = document.getElementById('espDueDateMgtFrame').contentWindow;
				if(!await childWindow3.saveRow("05")) { return false; }
			}
			
			// 개선관리 실적입력
			if("${scrOutputMgt}" == "Y"){
				var childWindow2 = document.getElementById('scrOutputRcdMgtFrame').contentWindow;
				if(!childWindow2.fnSave("05")) { return false; }
			}
			
			// 운영 실적입력
			if("${mbrRcdMgt}" == "Y"){
				//childWindow.saveMH("05");
				const saveMHResult = await callSaveMH("05");
				if(!saveMHResult) {
					return false;
				}
			}
			
			if(inProgressWf) {
				//alert("승인요청중 입니다.");
				getDicData("ERRTP", "ZLN0013").then(data => alert(data.LABEL_NM));
				return;
			}else{
				inProgressWf = true;
			}
			
			$('#loading').fadeIn(150);
			// sr file 저장
			saveFile();
			// sr attr 저장
			saveActivity();
		
			let inhouse = "${inhouse}";
			var url = "zYO_wfDocMgt.do";
			var data = "srID=${srInfoMap.SRID}" 
					+ "&docSubClass=${srInfoMap.Status}&docCategory=SPE"
					+ "&WFDocURL=${WFDocURL}&ProjectID=${srInfoMap.ProjectID}&defWFID=${srInfoMap.DefWFID}"				
					
					+ "&srRequestUserID=${srInfoMap.RequestUserID}"
					+ "&srRequestTeamID=${srInfoMap.RequestTeamID}"
					
					+ "&isPop=Y&blockSR=Y&wfDocType=SR&actionType=create"
					+ "&speCode=${srInfoMap.Status}&customerNo=${srInfoMap.ClientID}"
					+ "&activityLogID=${activityLogInfo.ActivityLogID}"
					+ "&srCode=${srInfoMap.SRCode}"
					+ "&documentID=${activityLogInfo.ActivityLogID}"
					+ "&documentNo=${srInfoMap.SRCode}"
					+ "&category=${srInfoMap.Category}"
					+ "&subCategory=${srInfoMap.SubCategory}"
					+ "&actorID=${activityLogInfo.ActorID}"
					+ "&inhouse=Y" // Y: 영원, null : OLM
			
			var target = "saveFrame";
			ajaxPage(url, data, target);
		} else {
			inProgressWf = false;
		}
		
	}

	function fnWFDetail_zYO(){ 	
		var url =  "zYO_viewWfDeatil.do?"; 
		var projectID = "${wfInstInfo.ProjectID}";
		var wfID = "${wfInstInfo.WFID}";	
		var stepInstID = "${wfInstInfo.StepInstID}";;
		var actorID = "${wfInstInfo.ActorID}";
		var stepSeq = "${wfInstInfo.StepSeq}";
		var wfInstanceID = "${wfInstInfo.WFInstanceID}";
		var lastSeq = "${wfInstInfo.LastSeq}";
		var documentID = "${wfInstInfo.DocumentID}";
		var docCategory = "${wfInstInfo.DocCategory}";
		var statusCode = "${wfInstInfo.StatusCode}";
		var defApprovalSystem = "${defApprovalSystem}";
		
		if(defApprovalSystem == "YO") url =  "zYO_viewWfDeatil.do?"; 
		else if(defApprovalSystem == "OLM") url = "wfDocItsmMgt.do?";
		
		var data = "projectID="+projectID
					+"&stepInstID="+stepInstID
					+"&actorID="+actorID
					+"&stepSeq="+stepSeq
					+"&wfInstanceID="+wfInstanceID
					+"&wfID="+wfID
					+"&documentID="+documentID
					+"&wfMode=${wfMode}"
					+"&lastSeq="+lastSeq
					+"&documentNo=${wfInstInfo.DocumentNo}"
					+"&docCategory="+docCategory
					+"&actionType=view"
					+"&inhouse=${inhouse}";

		var w = 1200;
		var h = 650; 
		itmInfoPopup(url+data,w,h);
	}
	// call back reload  /srActivityResultMgt.do
	function fnCallbackActivity(){
		
	}
	
	function fnDownloadTempFile(){
		var docCategory = "SR"; 
		var speCode="${srInfoMap.Status}";
	
		var url = "selectFilePop.do";
		var data = "?s_itemID=&docCategory="+docCategory+"&speCode="+speCode+"&templateFile=Y"; 
	   
	    var w = "500";
		var h = "350";
	    window.open(url+data, "", "width="+w+", height="+h+", top=100,left=100,toolbar=no,status=no,resizable=yes");
	}
		
</script>

<style>
	a:hover{
		text-decoration:underline;
	}
	input[type=text]::-ms-clear{
		display: done;
	}
	.autocomplete{
	    border: 1px solid #ddd;
	    display: none;
	    position: absolute;
	    width: 600px;
	    max-height: 200px;
	    background: #ffffff;
	    overflow: auto;
	    z-index: 2;
	    border-radius: 8px;
	    margin-top: 4px;
	    -webkit-box-shadow: 0 4px 10px 0 rgba(32, 33, 36, .1);
	    box-shadow: 0 4px 10px 0 rgba(32, 33, 36, .1);
   }
    .autocomplete.on {
    	display:block;
    }
    .autocomplete > div {
	    display: grid;
	    grid-template-columns: 150px 1fr 1fr;
	    background: #ffffff;
	    padding: 0 8px;
	    border-bottom: 1px solid #ddd;
    	cursor:pointer;
    }
    .autocomplete > div > span {
	    padding: 8px 0;
    }
	/* 현재 선택된 검색어 */
	.autocomplete > div.active, .autocomplete > div:hover {
    	background: #ddd;
	}
	mark {
		background: transparent;
	    color: #0761CF;
	    font-weight: bold;
	}
</style>

<div id="processSRDIV"> 
	<form name="srActvityFrm" id="srActvityFrm" enctype="multipart/form-data" action="" method="post" onsubmit="return false;">
	<input type="hidden" id="scrnType" name="scrnType" value="${scrnType}">
	<input type="hidden" id="srMode" name="srMode" value="${srMode}">
	<input type="hidden" id="srType" name="srType" value="${srInfoMap.SRType}">
	<input type="hidden" id="srID" name="srID" value="${srInfoMap.SRID}">
	<input type="hidden" id="scrID" name="scrID" value="${scrID}">
	<input type="hidden" id="docCategory" name="docCategory" value="${docCategory}" >
	<input type="hidden" id="speCode" name="speCode" value="${srInfoMap.Status}" >
	<input type="hidden" id="clientID" name="clientID" value="${srInfoMap.ClientID}" >
	<input type="hidden" id="changeCategory" name="changeCategory" value="${changeCategory}" >
	<input type="hidden" id="roleFilter" name="roleFilter" value="${roleFilter}" >
	<input type="hidden" id="procRoleTP" name="procRoleTP" value="${srInfoMap.ProcRoleTP}" >
	<input type="hidden" id="activityLogID" name="activityLogID" value="${activityLogInfo.ActivityLogID}" >
	<input type="hidden" id="projectID" name="projectID" value="${srInfoMap.ProjectID}" >
	<input type="hidden" id="fltpCode" name="fltpCode" >
	<input type="hidden" id="requestUserID" name="requestUserID" value="${srInfoMap.RequestUserID}">
	<input type="hidden" id="requestTeamID" name="requestTeamID" value="${srInfoMap.RequestTeamID}">
	<input type="hidden" id="responseUserID" name="responseUserID" value="${srInfoMap.ResponseUserID}">
	<input type="hidden" id="responseTeamID" name="responseTeamID" value="${srInfoMap.ResponseTeamID}">
	<input type="hidden" id="editMode" name="editMode" value="${editMode}">
	<input type="hidden" id="isPublic" name="isPublic" value="${srInfoMap.isPublic}">
	<input type="hidden" id="dueDate" name="dueDate" value="${srInfoMap.DueDate}">
	<input type="hidden" id="activitySeq" name="activitySeq" value="${activityLogInfo.ActivitySeq}">
 	
	<div class="border-section">
		<div class="btn-wrap page-subtitle pdB20 pdT20">
			${srInfoMap.SRStatusName}
				<div class="btns" id="srActivityResultButtons"></div>
		</div>
		
		<table class="form-column-8 new-form" width="100%" cellpadding="0" cellspacing="0" style="table-layout: fixed;">
			<colgroup>
					<col width="140px">
				    <col width="calc(25% - 140px)">
				 	<col width="140px">
				    <col width="calc(25% - 140px)">
				    <col width="140px">
				    <col width="calc(25% - 140px)">
				    <col width="140px">
				    <col width="calc(25% - 140px)">
			</colgroup>
			<tr>	
				<th>${menu.LN00109}</th>
				<td>${activityLogInfo.ProcRoleTypeName}</td>
				<th>${menu.LN00004}</th>
				<td>${activityLogInfo.ActorName}/${activityLogInfo.TeamName}</td>
			    <th>${menu.LN00027}</th>
				<td>${activityLogInfo.ActivityStatus}</td>
				<th>${menu.LN00077}</th>
				<td>${activityLogInfo.StartTime}</td>
			</tr>
			<tr>
				<!-- SR Area -->
				<th>${srInfoMap.SRArea1NM}/${srInfoMap.SRArea2NM}<font color="red">&nbsp;*</font></th>
				<td style="position:relative;">
					<c:choose>
						<c:when test="${editMode eq 'Y' && changeCategory eq 'Y'}">
							<input type="text" class="text" id="srAreaSearch" name="srAreaSearch" value="${empty srInfoMap.SRArea2Name or srInfoMap.SRArea2Name == '0' ? srInfoMap.SRArea1Name : srInfoMap.SRArea2Name}"
								placeholder="검색어를 입력해주세요." autocomplete="off"/>
							<input type="hidden" id="srArea1" name="srArea1" value="${srInfoMap.SRArea1}" />
							<input type="hidden" id="srArea2" name="srArea2" value="${srInfoMap.SRArea2}" />
							<ul class="autocomplete"></ul>
						</c:when>
						<c:otherwise>
							${srInfoMap.SRArea1Name}/${srInfoMap.SRArea2Name}
						</c:otherwise>
					</c:choose>
				</td>
				<!-- 카테고리 -->
				<th>${menu.LN00272}<font color="red">&nbsp;*</font></th>
				<td>
					<c:choose>
						<c:when test="${editMode eq 'Y' && changeCategory eq 'Y'}">
							<select id="category" name="category">
				       			<option value=''>${menu.ZLN0057}</option>
				     	  	</select>
						</c:when>
						<c:otherwise>
							${srInfoMap.CategoryName}
						</c:otherwise>
					</c:choose>
				</td>
				<th>${menu.LN00273}<font color="red">&nbsp;*</font></th>
				<td>
					<c:choose>
						<c:when test="${editMode eq 'Y' && changeCategory eq 'Y'}">
							<select id="subCategory" name="subCategory">
				       			<option value=''>Select</option>
				     	  	</select>
						</c:when>
						<c:otherwise>
							${srInfoMap.SubCategoryName}
						</c:otherwise>
					</c:choose>
				</td>
				<td colspan="2"></td>
			</tr>
  		</table>  
 
  		<c:if test="${not empty wfInstInfo}" >
  		<table class="form-column-8 new-form mgT20" width="100%" cellpadding="0" cellspacing="0"  style="table-layout: fixed;">
			<colgroup>
					<col width="140px">
				    <col width="calc(25% - 140px)">
				 	<col width="140px">
				    <col width="calc(25% - 140px)">
				    <col width="140px">
				    <col width="calc(25% - 140px)">
				    <col width="140px">
				    <col width="calc(25% - 140px)">
			</colgroup>
			<tr>	
				<th class="alignL pdL10">${menu.ZLN0058} ${menu.LN00134} No.</th>	
				<td class="alignL pdL10"><span OnClick="fnWFDetail_zYO();" style="font-weight:bold;color:blue;font-size:12px;cursor:pointer;">${wfInstInfo.WFInstanceID}</span></td>		
				<th class="alignL pdL10 viewline">${menu.LN00065}</th> 
				<td class="alignL pdL10">${wfInstInfo.Status}</td>
			    <th class="alignL pdL10">${menu.ZLN0059}</th>	
				<td class="alignL pdL10 last" colspan=3>${wfInstInfo.Subject}</td>
			</tr>
  		</table>  
  		</c:if>
  		
		<table class="form-column-8 new-form mgT20" width="100%" border="0" cellpadding="0" cellspacing="0"  style="table-layout: fixed;" id="attr">
			<colgroup>
				<col width="140px">
			    <col width="calc(50% - 140px)">
			 	<col width="140px">
			    <col width="calc(50% - 140px)">
			</colgroup>
		</table>
		
		<!-- 첨부문서 & 참조 테이블  -->
		<table class="form-column-8 new-form mgT20" width="100%" cellpadding="0" cellspacing="0"  style="table-layout: fixed;">
			<colgroup>
				<col width="140px">
			    <col width="calc(100% - 140px)">
			</colgroup>	
			<tr>
				<!-- 첨부문서 -->
				<th class="fileListTH">${menu.LN00111}</th>
				<td class="alignL last btns" id="fileList"></td>			
			</tr>
		</table>
		<iframe id="espMbrRcdListFrame"  style="width:100%; height:400px; border:none;display:none;"></iframe>
		<iframe id="scrOutputRcdMgtFrame"  style="width:100%; height:675px; border:none;display:none;"></iframe>
		<iframe id="espDueDateMgtFrame"  style="width:100%; height:630px; border:none;display:none;"></iframe>
	</div>
	</form>
</div>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none"></iframe>
