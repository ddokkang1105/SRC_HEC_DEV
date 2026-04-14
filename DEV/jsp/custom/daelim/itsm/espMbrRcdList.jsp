<%@ page import="java.util.List, java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>

<!-- 1. Include JSP -->
<%--  <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>  --%>
<%-- <%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%> --%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${menu.ZLN0125}</title>
<!-- DHX Grid 7.1.8 -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css" />
<script src="/cmm/js/jquery/jquery.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/style.css" />

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00015" var="WM00015" arguments="${menu.ZLN0130}" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00007" var="WM00007" arguments="${menu.ZLN0181}" />

<style>
.dhx_cell-editor {
	box-shadow: none;
}

.dhx_grid-cell.edit-input {
	cursor: text;
}

.dhx_grid-cell.edit-input:after {
	content: "";
	position: absolute;
	border: 1px solid #ddd;
	width: calc(100% - 12px);
	height: calc(100% - 12px);
	left: 6px;
	border-radius: 6px;
}
</style>
<script type="text/javascript">
		let today = new Date();
		/* today = today.getFullYear() +
		'-' + ( (today.getMonth()+1) <= 9 ? "0" + (today.getMonth()+1) : (today.getMonth()+1) )+
		'-' + ( (today.getDate()) <= 9 ? "0" + (today.getDate()) : (today.getDate()) ); */
		
		let descMbrList = [];
	    let descMemberID = "";
	    let windowHTML = "";
		
		jQuery(document).ready(function() {
			editable = true;
// 			fnSetButton("add-row", "", "행 추가", "secondary");
// 			createDescButton();
			fnDefaultSetting();
		});
		
		function fnSetButton(el, iconName, text, style = "primary") {
			const button = document.querySelector("#"+el);
			button.classList.add(style);
			if(iconName) button.innerHTML = icon[iconName];
			button.innerHTML += `<span class='text'>\${text}</span>`;
		}
	    
		function searchPopupWf ( avg ) {
			const url = avg + "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
			window.open(url, 'window', 'width=340, height=300, left=300, top=300,scrollbar=yes,resizble=0');
		}
		
		function setSearchNameWf ( avg1, avg2, avg3, avg4, avg5, avg6, avg7 ) {
			addRow(avg2, avg3, avg1);
		}
	
		function saveMH(srID,speCode,ProcRoleTP) {
			
			const gridData = grid.data.getRawData().filter(e => e.WORK_DATE !== "" && (e.BUSINESS_HOURS || e.OVERTIME ));
			
		    // srID를 각 객체에 추가
			const updatedData = gridData.map(item => ({
			    ...item,
			    srID: srID
			    
			}));
		    
			const payload = {
		    	srID : srID,
		    	speCode: speCode,
		    	procRoleTP: ProcRoleTP,
		    	data: gridData,
		    	descMbrList : descMbrList,
		    	addUser : "N"
		    };
		    
	    
			const data_initOrder = JSON.stringify(payload);
		 
			fetch('/saveMH.do', {
				method: 'POST',
				body : data_initOrder,
				headers: {
					'Content-type': 'application/json; charset=UTF-8',
				},
			}).then(res => console.log(res)) 
		}
		
// 		function checkDuplicate(arr, keys) {
// 			const set = new Set();
// 			for (const item of arr) {
// 				const key = keys.map(key => item[key]).join('-');
// 				if (set.has(key)) {
// 					// 중복된 데이터가 있음
// 					return true;
// 				}
// 				set.add(key);
// 			}
// 			// 중복된 데이터가 없음
// 			return false;
// 		}
		
		function fnCheckValidation() {
			const gridData = grid.data.getRawData().filter(e => e.BUSINESS_HOURS || e.OVERTIME );
			
			// 한개의 행이라도 있어야
			if(gridData.length === 0) {
// 				alert("운영관리실적 데이터를 입력하세요");
				getDicData("ERRTP", "ZLN0015").then(data => alert(data.LABEL_NM));
				return false;
			}
			
			// 자신의 레코드는 업무처리일자나 M/H에는 빈값이 없어야
// 			if(gridData
// 				.filter(e => e.memberID == "${sessionScope.loginInfo.sessionUserId}")
// 				.filter(e => (e.WORK_DATE !== "" && ( e.BUSINESS_HOURS === "" && e.OVERTIME === "")) || (e.WORK_DATE === "" && ( e.BUSINESS_HOURS !== "" || e.OVERTIME !== ""))).length) {
// 				alert("${WM00007}");
// 				return false;
// 			}
			
			// 업무처리일자가 중복되지 않아야
// 			const keysToCheck = ['memberID', 'WORK_DATE'];
// 			let validation = checkDuplicate(gridData, keysToCheck);
// 			if(validation) {
// 				alert("운영실적 업무처리일자 중복될 수 없음");
// 				return false;
// 			}
			
			else return true;
		}
		
		function getRawData(){
			
			const gridData = grid.data.getRawData().filter(e => e.WORK_DATE !== "" && (e.BUSINESS_HOURS || e.OVERTIME ));
			return gridData;
			
		}
	</script>
</head>
<body>
	<!-- 주요 파라미터  -->
	<input name="srID" id="srID" value="${srID}" style="display: none;" />
	<input name="scrID" id="scrID" value="" style="display: none;" />
	<input name="procRoleTP" id="procRoleTP" value="" style="display: none;" />
	<input name="SpeCode" id="SpeCode" value="" style="display: none;" />

	<div class="page-subtitle btn-wrap">
		${menu.ZLN0125}
<!-- 		<div class="btns"> -->
<!-- 			<button id="add-row" onclick="addRow()"></button> -->
<!-- 		</div> -->
	</div>
	 
	<div style="display: flex; gap: 20px;">
		<div style="border: 1px solid #dfdfdf;">
			<div class="btns"style="position: relative;">
				<button class="secondary" style="position: absolute;transform: translate(10px, 6px);height: 28px;padding: 0 10px;" onclick="setToday()">today</button>
				<h1 style="height: 40px; display: flex; align-items: center; font-size: 13px; justify-content: center; background: #f7f7f7; border-bottom: 1px solid #dfdfdf;">${menu.ZLN0126}</h1>
			</div>
			<div style="display: flex;">
				<div id="calendar1"></div>
				<div id="calendar2"></div>
			</div>
		</div>
		<!-- <div style="height: auto; width: 100%" id="grid"></div> -->
		<div style="height: 303px; width: calc(100% - 522px)" id="grid"></div>
	</div>
	<!--    	<div> -->
	<!-- 		Total : <span id="totalData"></span> -->
	<!-- 	</div> -->
	<script type="text/javascript">
	const locale = {
	    EN : {
	        monthsShort: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
	        months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
	        daysShort: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
	        days: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
	        cancel: "Cancel"
	    },
	    KO : {
	        monthsShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
	        months: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
	        daysShort: ["일", "월", "화", "수", "목", "금", "토"],
	        days: ["일", "월", "화", "수", "목", "금", "토"],
	        cancel: "취소"
	    }
	}
	const useOverTime = "${useOverTime}";
	
	const calendar1 = new dhx.Calendar("calendar1", {});
    const calendar2 = new dhx.Calendar("calendar2", {});
    
    calendar1.events.on("change", function (date) {
    	calDateChange(date, calendar2.getValue(true));
    });
    
    calendar2.events.on("change", function (date) {
    	calDateChange(calendar1.getValue(true),date);
    });
    
    dhx.i18n.setLocale("calendar", locale["${sessionScope.loginInfo.sessionCurrLangCode}"]);

    calendar1.link(calendar2);
    
    function calDateChange(from, to) {
		const list = [];
		let fromDate = from;
		let toDate = to;
		
		if(toDate < fromDate) {
			calendar2.setValue(fromDate);
			toDate = fromDate;
		}
		
        if(fromDate && toDate) {
        	//fromDate.setHours(fromDate.getHours() + 9);
        	//toDate.setHours(toDate.getHours() + 9);
        	
        	fromDate.setHours(9);
	      	toDate.setHours(9);
        	
			for(var i = 0; i <= Math.abs((toDate - fromDate) / (1000 * 60 * 60 * 24)); i++) {
				const day = new Date(fromDate);
				day.setDate(day.getDate() + i);
				
			  	if(day.getDay() == "0") list.push({No : list.length+1, WORK_DATE : day.toISOString().split('T')[0], memberID: "${sessionScope.loginInfo.sessionUserId}", memberName : "${sessionScope.loginInfo.sessionUserNm}", teamId: "${sessionScope.loginInfo.sessionTeamId}", teamName : "${sessionScope.loginInfo.sessionTeamName}", BUSINESS_HOURS : "", OVERTIME : "", HOLYDAY:"Y", WEEKEND:"일"});
			  	if(day.getDay() == "1") list.push({No : list.length+1, WORK_DATE : day.toISOString().split('T')[0], memberID: "${sessionScope.loginInfo.sessionUserId}", memberName : "${sessionScope.loginInfo.sessionUserNm}", teamId: "${sessionScope.loginInfo.sessionTeamId}", teamName : "${sessionScope.loginInfo.sessionTeamName}", BUSINESS_HOURS : "", OVERTIME : "", HOLYDAY:"N", WEEKEND:"월"});
			  	if(day.getDay() == "2") list.push({No : list.length+1, WORK_DATE : day.toISOString().split('T')[0], memberID: "${sessionScope.loginInfo.sessionUserId}", memberName : "${sessionScope.loginInfo.sessionUserNm}", teamId: "${sessionScope.loginInfo.sessionTeamId}", teamName : "${sessionScope.loginInfo.sessionTeamName}", BUSINESS_HOURS : "", OVERTIME : "", HOLYDAY:"N", WEEKEND:"화"});
			  	if(day.getDay() == "3") list.push({No : list.length+1, WORK_DATE : day.toISOString().split('T')[0], memberID: "${sessionScope.loginInfo.sessionUserId}", memberName : "${sessionScope.loginInfo.sessionUserNm}", teamId: "${sessionScope.loginInfo.sessionTeamId}", teamName : "${sessionScope.loginInfo.sessionTeamName}", BUSINESS_HOURS : "", OVERTIME : "", HOLYDAY:"N", WEEKEND:"수"});
			  	if(day.getDay() == "4") list.push({No : list.length+1, WORK_DATE : day.toISOString().split('T')[0], memberID: "${sessionScope.loginInfo.sessionUserId}", memberName : "${sessionScope.loginInfo.sessionUserNm}", teamId: "${sessionScope.loginInfo.sessionTeamId}", teamName : "${sessionScope.loginInfo.sessionTeamName}", BUSINESS_HOURS : "", OVERTIME : "", HOLYDAY:"N", WEEKEND:"목"});
			  	if(day.getDay() == "5") list.push({No : list.length+1, WORK_DATE : day.toISOString().split('T')[0], memberID: "${sessionScope.loginInfo.sessionUserId}", memberName : "${sessionScope.loginInfo.sessionUserNm}", teamId: "${sessionScope.loginInfo.sessionTeamId}", teamName : "${sessionScope.loginInfo.sessionTeamName}", BUSINESS_HOURS : "", OVERTIME : "", HOLYDAY:"N", WEEKEND:"금"});
				if(day.getDay() == "6") list.push({No : list.length+1, WORK_DATE : day.toISOString().split('T')[0], memberID: "${sessionScope.loginInfo.sessionUserId}", memberName : "${sessionScope.loginInfo.sessionUserNm}", teamId: "${sessionScope.loginInfo.sessionTeamId}", teamName : "${sessionScope.loginInfo.sessionTeamName}", BUSINESS_HOURS : "", OVERTIME : "", HOLYDAY:"Y", WEEKEND:"토"});
			}
			
             grid.data.parse(list);
             createDescButton();
        }
    }
    
    const data = [];
	
    const grid = new dhx.Grid("grid", {
    	columns: [
	        { width: 60, id: "No", header: [{ text: "${menu.LN00024}", align:"center" }], footer: [{ text: "Total", colspan:4, align:"center" }], align:"center" },
	        { hidden:true, id: "memberID", header: [{ text: "${menu.ZLN0127}" }] },
	        { width: 100, id: "memberName", header: [{ text: "${menu.ZLN0085}", align:"center" }], align:"center" },
	        { hidden:true, id: "teamId", header: [{ text: "${menu.ZLN0128}" }] },
	        { width:150, id: "teamName", header: [{ text: "${menu.ZLN0129}", align:"center" }], align:"center" },
			{ width: 125, id: "WORK_DATE", header: [{ text: "${menu.ZLN0130}", align:"center" }], align:"center", minWidth:125, template: function(value) { return value && !isNaN(new Date(value).getTime()) ? new Date(value).toISOString().split('T')[0] : value; }},
	        { width: 150, id: "BUSINESS_HOURS", header: [{ text: "${menu.ZLN0182}", align:"center" }], footer: [{ content: "sum", align:"center" }], format: "#.00", type: "number", editable: true, align:"center", mark: ( cell, columnCell, row  ) => ( "edit-input") },
	        { width: 150, id: "OVERTIME", header: [{ text: "${menu.ZLN0132}", align:"center"}], footer: [{ content: "sum", align:"center" }], format: "#.00", type: "number", editable: true, align:"center", mark: ( cell, columnCell, row  ) => ( "edit-input") },
	        { width: 150, id: "description", header: [{ text: "${menu.ZLN0133}", align: "center" }], htmlEnable: true, align:"center" },
        ],
        sortable:false,
        tooltip : false,
	    data: data,
	    resizable: true,
	    rowHeight: 40,
	});
    
    if (useOverTime === "N") {
  	  grid.hideColumn("OVERTIME");
  	} 
    
 	// 윈도우 크기 변경시 그리드 크기 조정
    window.addEventListener('resize', () => {
    	var gridContent = document.querySelector('.dhx_grid-content');
    	if (gridContent) {
    	    gridContent.style.width = '100%';
    	}
    	var gridBody = document.querySelector('.dhx_grid-body');
    	if (gridBody) {
    		gridBody.style.width = '100%';
    	}
    });
    
    function createDescButton() {
		descMbrList = [];
		let memberList = grid.data.getRawData().map(e => e.memberID).reduce((a,c) => {
		    if(!a.includes(c)) {
		        a.push(c);
		    }
		    return a;
		}, []);
		memberList.forEach(memberID => {
			grid.data.update(grid.data.getRawData().filter(e => e.memberID == memberID)[0]?.id, {...{ "description" : '<div class="btns"><button id="showDesc" class="secondary" style="height: 27px;" onclick="descWindowShow('+memberID+')">${menu.ZLN0133}</button></div>' }});
			descMbrList.push({ 
				"memberID" : memberID,
				"desc" : grid.data.getRawData().filter(e => e.memberID ==  memberID && e.RoleDescription )[0]? grid.data.getRawData().filter(e => e.memberID ==  memberID && e.RoleDescription )[0].RoleDescription : ""
			});
		})
	}
	
	grid.events.on("cellClick", function ( row, column ) {
		 if(column.id === "BUSINESS_HOURS" || column.id === "OVERTIME") {
			 grid.getColumn("BUSINESS_HOURS").editable = true;
			 grid.getColumn("OVERTIME").editable = true;
			 grid.edit(row.id, column.id);
		 }
	});
	
	function descSave() {
		descMbrList.filter(e => e.memberID == "${sessionScope.loginInfo.sessionUserId}")[0].desc = document.querySelector("#desc").value;
		descWindow.hide();
	}
	
	function descSaveInput(){
		descMbrList.filter(e => e.memberID == "${sessionScope.loginInfo.sessionUserId}")[0].desc = document.querySelector("#desc").value;
	}
	
	grid.events.on("afterEditEnd", (value, row, column) => {
		
		const HOLYDAY = row.HOLYDAY;
		
		if(column.id === "BUSINESS_HOURS") {
			if(isNaN(value) || value < 0){
// 				alert("M/H는 숫자만 입력 가능합니다.");
				getDicData("ERRTP", "LN0007").then(data => alert("M/H"+data.LABEL_NM));
				grid.data.update(row.id, { ...row, BUSINESS_HOURS : "" })
			}
			if(value && value > 0) {
				if(useOverTime !== "N" && HOLYDAY === "N" && value > 8.00) grid.data.update(row.id, { ...row, BUSINESS_HOURS : 0 })
				else if(useOverTime !== "N" && HOLYDAY === "Y" && value > 0) grid.data.update(row.id, { ...row, BUSINESS_HOURS : 0 })
				else if(useOverTime === "N" && value > 24.00) grid.data.update(row.id, { ...row, BUSINESS_HOURS : 0 })
				else {
					const integer = value.toString().split('.')[0];
					const twoDecimal = value.toString().split('.')[1] ? value.toString().split('.')[1].slice(0, 2) : "00";
					grid.data.update(row.id, { ...row, BUSINESS_HOURS: `\${integer}.\${twoDecimal}` })
				}
			}
		}
		
		if (useOverTime !== "N") {
			if(column.id === "OVERTIME") {
				if(isNaN(value) || value < 0){
	// 				alert("M/H는 숫자만 입력 가능합니다.");
					getDicData("ERRTP", "LN0007").then(data => alert("M/H"+data.LABEL_NM));
					grid.data.update(row.id, { ...row, OVERTIME : "" })
				}
				if(value && value > 0) {
					if(HOLYDAY === "N" && value > 16.00) grid.data.update(row.id, { ...row, OVERTIME : 0 })
					else if(HOLYDAY === "Y" && value > 24.00) grid.data.update(row.id, { ...row, OVERTIME : 0 })
					else {
						const integer = value.toString().split('.')[0];
						const twoDecimal = value.toString().split('.')[1] ? value.toString().split('.')[1].slice(0, 2) : "00";
						grid.data.update(row.id, { ...row, OVERTIME : `\${integer}.\${twoDecimal}` })
					}
				}
			}
		}
	});
	
	const descWindow = new dhx.Window({
	    width: 440,
	    height: 355,
	    title: "${menu.ZLN0133}",
	    closable: true,
	    modal: true
	});
	
	function descWindowShow(descMemberID) {
		windowHTML = '<textarea class="edit pdL10 pdR10 pdT10" style="width:100%; height:200px; resize: none;" id="desc" oninput="descSaveInput()" ';
		if(!editable || (editable && descMemberID != "${sessionScope.loginInfo.sessionUserId}")) windowHTML += "readonly";
		windowHTML +='>'+descMbrList.filter(e => e.memberID == descMemberID)[0]?.desc+'</textarea>';
		if(editable && descMemberID == "${sessionScope.loginInfo.sessionUserId}") windowHTML += '<div class="btns mgT10 floatR"><button onclick="descSave()" class="secondary">save</button></div>';
		descWindow.attachHTML(windowHTML);
		descWindow.show();
	}	
	
	function fnDefaultSetting(){
		// 아무것도 없을 경우 default로 담당자 한줄 추가 (today)
		calDateChange(today,today);
	}
	
	function setToday(){
		const now = new Date();
		
		now.setHours(9);
		now.setMinutes(0);
		now.setSeconds(0);
		now.setMilliseconds(0);
		
		calendar1.setValue(now);
	}
	
	function getDicData(storeName, key) {
	    return new Promise((resolve, reject) => {
	        const request = indexedDB.open("dictionary");

	        request.onerror = (event) => {
	            console.error("IndexedDB open error:", event);
	            reject(event);
	        };

	        request.onsuccess = (event) => {
	            const db = event.target.result;
	            const transaction = db.transaction(storeName, "readonly");
	            const objectStore = transaction.objectStore(storeName);
	            const getRequest = objectStore.get(key);

	            getRequest.onsuccess = (event) => {
	                resolve(event.target.result);
	            };

	            getRequest.onerror = (event) => {
	                console.error("Data fetch error:", event);
	                reject(event);
	            };
	        };
	    });
	}
    </script>
</body>
</html>
