<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>

<!-- 1. Include JSP -->
<%--  <%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>  --%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${menu.ZLN0125}</title>


<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
	<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>
 	<script src="/cmm/js/jquery/jquery.js" type="text/javascript"></script> 
	<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/style.css" />
	
	<!-- 화면 표시 메세지 취득  -->
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00015" var="WM00015" arguments="${menu.ZLN0130}"/>
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00007" var="WM00007" arguments="${menu.ZLN0181}"/>
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00003" var="WM00003"/>
	
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
    let editable = false;
    let descMbrList = [];
    let descMemberID = "";
    let windowHTML = "";
    	
	let today = new Date();
	/* today = today.getFullYear() +
	'-' + ( (today.getMonth()+1) <= 9 ? "0" + (today.getMonth()+1) : (today.getMonth()+1) )+
	'-' + ( (today.getDate()) <= 9 ? "0" + (today.getDate()) : (today.getDate()) ); */
	
	jQuery(document).ready(function() {
		if("${editMode}" === "Y") {
// 			fnSetButton("addRow", "", "행 추가", "secondary");
// 			fnSetButton("editBtn", "", "편집");
// 			fnSetButton("save", "", "저장");
			getDicData("BTN", "LN0014").then(data => fnSetButton("save", "", data.LABEL_NM));
			
			// 담당자
			if("${addUser}" === "Y") {
// 				fnSetButton("addUser", "", "업무자 추가", "secondary");
				getDicData("BTN", "LN0027").then(data => fnSetButton("addUser", "", data.LABEL_NM, "secondary"));
			}
			if("${defaultMH}" === "Y"){
				fnDefaultSetting();
			}
		}
		createDescButton();
	    editControl();
	});
   
	function fnSetButton(el, iconName, text, style = "primary") {
		const button = document.querySelector("#"+el);
		button.classList.add(style);
		if(iconName) button.innerHTML = icon[iconName];
		button.innerHTML += `<span class='text'>\${text}</span>`;
	}
	function searchPopupWf () {
		window.open("searchMemberPop.do?myClient=Y&notCompanyIDs=22",'searchMemberPop','width=900, height=700');
	}
	
	async function searchMemberCallback(memberID, memberName, teamName, companyName, teamID) {
		
		// 이미 저장된 사용자 추가 불가능
		if (grid._filterData) {
			const existingMember = grid._filterData.find(e => e.memberID === Number(memberID.trim()));
			if (existingMember) {
				setTimeout(() => {
// 					  alert("업무자는 중복 추가가 불가능합니다");
						getDicData("ERRTP", "ZLN0016").then(data => alert(data.LABEL_NM));
				}, 200); 
				return;
			}
		}
		await addRow(memberName, teamName, memberID, teamID).then(() => {
			
			// 업무자 추가하면 바로 DB 에 저장 (신규업무자만)
		   /*  const payload = {
		    	srID : "${srID}",
		    	speCode: "${speCode}",
		    	procRoleTP: "${procRoleTP}",
		    	data: grid.data.getRawData().filter(e => e.memberID != "${sessionScope.loginInfo.sessionUserId}"),
		    	addUser : "${addUser}"
		    }; */
		    
		    // 업무자 추가하면 전체 업데이트
		    const myData = grid.data.getRawData().filter(e => e.memberID == "${sessionScope.loginInfo.sessionUserId}").filter(e => e.WORK_DATE && (e.BUSINESS_HOURS  || e.OVERTIME ));
		    const otherData =  grid.data.getRawData().filter(e => e.memberID != "${sessionScope.loginInfo.sessionUserId}");
		    
		    // 신규 추가 시 deafult 날짜 셋팅
		    if(otherData){
			    otherData.forEach(item => {
			        if (item.memberID === memberID) {
					    const weekdayMapping = ["일", "월", "화", "수", "목", "금", "토"]; // 요일을 한글로 매핑
					    const HOLYDAY = (today.getDay() === 0 || today.getDay() === 6) ? "Y" : "N";
					    const WEEKEND = weekdayMapping[today.getDay()]; // 해당 날짜의 요일을 한글로 반환
			            item.WORK_DATE = today.toISOString().split('T')[0];
			            item.HOLYDAY = HOLYDAY;
			            item.WEEKEND = WEEKEND;
			        }
			    });
		    }
		    
		    const gridData = [...myData, ...otherData];
		    // 기존 데이터에 추가로 delList 묶어서 하나의 객체로 보내기 
		    const payload = {
		    	srID : "${srID}",
		    	speCode: "${speCode}",
		    	procRoleTP: "${procRoleTP}",
		    	data: gridData,
		    	delItems: delList,
		    	descMbrList : descMbrList,
		    	addUser : "${addUser}"
		    };
		    
		    
		    // 객체를 JSON 문자열로 변환
	    	const data_initOrder = JSON.stringify(payload);
	    	$('#loading').fadeIn(150);
			fetch('/editSaveMH.do', {
				method: 'POST',
				body : data_initOrder,
				headers: {
					'Content-type': 'application/json; charset=UTF-8',
				},
			})
			.then((res) => res.json())
			.then((data) => {
				grid.data.parse(data.gridData);
				createDescButton();
				setSelectMbrUserList();
				$('#loading').fadeOut(150);
			});
		});
	}
	
// 	function checkDuplicate(arr, keys) {
// 		const set = new Set();
// 		for (const item of arr) {
// 			const key = keys.map(key => item[key]).join('-');
// 			if (set.has(key)) {
// 				// 중복된 데이터가 있음
// 				return true;
// 			}
// 			set.add(key);
// 		}
// 		// 중복된 데이터가 없음
// 		return false;
// 	}
	
	function fnCheckValidation() {
		const myData = grid.data.getRawData().filter(e => e.memberID == "${sessionScope.loginInfo.sessionUserId}").filter(e => e.WORK_DATE && (e.BUSINESS_HOURS || e.OVERTIME ));
	    const otherData =  grid.data.getRawData().filter(e => e.memberID != "${sessionScope.loginInfo.sessionUserId}")
	    const gridData = [...myData, ...otherData];
		
		// 한개의 행이라도 있어야
		if(myData.length === 0) {
// 			alert("운영관리실적 데이터를 입력하세요");
			getDicData("ERRTP", "ZLN0015").then(data => alert(data.LABEL_NM));
			return false;
		}
		
		// 자신의 레코드는 업무처리일자나 M/H에는 빈값이 없어야
// 			if(gridData
// 				.filter(e => e.memberID == "${sessionScope.loginInfo.sessionUserId}")
// 				.filter(e => (e.BUSINESS_HOURS == "" || e.OVERTIME == "")).length) {
// 				alert("${WM00007}");
// 				return false;
// 			}
		
		// 업무처리일자가 중복되지 않아야
// 		const keysToCheck = ['memberID', 'WORK_DATE'];
// 		let validation = checkDuplicate(gridData, keysToCheck);
// 		if(validation) {
// 			alert("운영실적 업무처리일자 중복될 수 없음");
// 			return false;
// 		}
		
		else return true;
	}
	
	let isSavingMH = false;
	function saveMH(activityStatus = "") {
		
		if(isSavingMH){
			alert("${WM00003}");
			return false; 
		} else {
			
			isSavingMH = true;
			
			if(activityStatus === "0") if(!fnCheckValidation()) { isSavingMH = false; return; }
			if(activityStatus === "0") if(!confirm("${CM00001}")) { isSavingMH = false; return; }
		
		 	// 추가된 업무처리자의 경우, 업무내역이 없는 레코드 삭제
			if(grid.data.getRawData()){
				if(modUser === "Y"){
					grid.data.getRawData().filter(e => e.BUSINESS_HOURS === "" && e.OVERTIME === "").forEach(e => {
						grid.data.remove(e.id);
						delList.push(e.MbrRcdID);
					})
				} else {
					grid.data.getRawData().filter(e => e.memberID == "${sessionScope.loginInfo.sessionUserId}").filter(e => e.BUSINESS_HOURS === "" && e.OVERTIME === "").forEach(e => {
						grid.data.remove(e.id);
						delList.push(e.MbrRcdID);
					})
				}
			}
		 	
			
		    const myData = grid.data.getRawData().filter(e => e.memberID == "${sessionScope.loginInfo.sessionUserId}").filter(e => e.WORK_DATE && (e.BUSINESS_HOURS  || e.OVERTIME ));
		    const otherData =  grid.data.getRawData().filter(e => e.memberID != "${sessionScope.loginInfo.sessionUserId}");
		    const gridData = [...myData, ...otherData];
		    // 기존 데이터에 추가로 delList 묶어서 하나의 객체로 보내기 
		    const payload = {
		    	srID : "${srID}",
		    	speCode: "${speCode}",
		    	procRoleTP: "${procRoleTP}",
		    	data: gridData,
		    	delItems: delList,
		    	descMbrList : descMbrList,
		    	addUser : "${addUser}"
		    };
		    
		    if(activityStatus === "0") $('#loading').fadeIn(150);
		    // 객체를 JSON 문자열로 변환
	    	const data_initOrder = JSON.stringify(payload);
		    
	    	return new Promise((resolve) => {
	    		fetch('/editSaveMH.do', {
					method: 'POST',
					body : data_initOrder,
					headers: {
						'Content-type': 'application/json; charset=UTF-8',
					},
				})
				.then((res) => res.json())
				.then((data) => {
					if(data.result) { // 저장 성공
						grid.data.parse(data.gridData);
						createDescButton();
						if(activityStatus === "0") {
							alert(data.message);
							$('#loading').fadeOut(150);
						}
						
						// 정렬
						gridSorting();
						

						resolve(true);
					} else { // 저장 실패
						alert(data.message);
						resolve(false);
						$('#loading').fadeOut(150);
					}

					grid.getColumn("BUSINESS_HOURS").editable = true;
					grid.getColumn("OVERTIME").editable = true;
					editable = false;
					isSavingMH = false;		
					editControl();			
				})
				.catch((error) => { // 네트워크 오류 등 통신 문제 발생 시
		            console.error("Fetch 오류 발생:", error);
		            alert("저장 중 통신 오류가 발생했습니다.");
		            resolve(false);
		        });
	    	});
		}
	}
	
	function validData() {
		const gridData = grid.data.getRawData();
		
		// 자신 외의 레코드는 업무처리일자나 M/H에는 빈값이 없어야
		if(gridData.filter(e => e.memberID != "${sessionScope.loginInfo.sessionUserId}").filter(e => e.WORK_DATE === "" || ( e.BUSINESS_HOURS === "" && e.OVERTIME === "")).length) {
// 			alert("업무실적을 입력하지 않은 IT 담당자가 있습니다.");
			getDicData("ERRTP", "ZLN0017").then(data => alert(data.LABEL_NM));
			return false;
		}
		return true;
	}
</script>
</head>
<body>

  <!-- 주요 파라미터  -->
 <div class="page-subtitle btn-wrap">
		${menu.ZLN0125}
		
		<div class="btns">
			<c:if test="${editMode eq 'Y'}">
<!-- 	        	<button id="editBtn"></button> -->
				<button id="save" onclick="saveMH('0')" style="display: none;" ></button>
<!-- 				<button id="addRow" onclick="addRow()" style="display: none;" ></button> -->
				<c:if test="${addUser eq 'Y'}">
					<button id="addUser" onclick="searchPopupWf()" style="display: none;"></button>
				</c:if>
	        </c:if>
		</div>
	</div>        
      
    <c:if test="${editMode eq 'Y'}">
	<div style="display: flex; gap: 20px;">
		<div style="border: 1px solid #dfdfdf;" id="calendar-wrapper">
			<div class="btns"style="position: relative;">
				<button class="secondary" style="position: absolute;transform: translate(10px, 6px);height: 28px;padding: 0 10px;" onclick="setToday()">today</button>
				<h1 style="height: 40px; display: flex; align-items: center; font-size: 13px; justify-content: center; background: #f7f7f7; border-bottom: 1px solid #dfdfdf;">${menu.ZLN0126}</h1>
				<c:if test="${modUser == 'Y'}"><select id="selectMbrUserList" style="position: absolute;width:100px;height: 28px;padding: 0 10px; top:6px; right:10px;"></select></c:if>
			</div>
			<div style="display: flex;">
				<div id="calendar1"></div>
				<div id="calendar2"></div>
			</div>
		</div>
	</c:if>
		<div style="height: 303px; width: calc(100% - 522px)" id="layout"></div>
	<c:if test="${editMode eq 'Y'}">
	</div>
	</c:if>
	
    <script type="text/javascript">
    var data = ${gridData};
    const modUser = "${modUser}";
    const useOverTime = "${useOverTime}";
    
	var layout = new dhx.Layout("layout", {
		rows : [ {
			id : "a",
		}, ]
	});
    
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
	
	if("${editMode}" !== "Y") {
		calendar1.destructor();
		calendar2.destructor();
	}
	
	const grid = new dhx.Grid("grid", {
    	columns: [
	        {  width: 50, id: "RNUM", header: [{ text: "No", align:"center"  }], footer: [{ text: "Total", colspan: 4, align:"center" }], align:"center" },
	    	{	width: 50,
	   		 id: "del", 
	            type: "string", 
	            header: [{ text: "", align: "center" }],
	            htmlEnable: true, 
	            align: "center",
	            template: function (text, row) {
	            	let delIcon = '<svg xmlns="http://www.w3.org/2000/svg" style="cursor:pointer;" onClick="deleteRow()" height="20px" viewBox="0 -960 960 960" width="20px" fill="#434343"><path d="m400-325 80-80 80 80 51-51-80-80 80-80-51-51-80 80-80-80-51 51 80 80-80 80 51 51Zm-88 181q-29.7 0-50.85-21.15Q240-186.3 240-216v-480h-48v-72h192v-48h192v48h192v72h-48v479.57Q720-186 698.85-165T648-144H312Zm336-552H312v480h336v-480Zm-336 0v480-480Z"/></svg>';
	            	// 본인이 추가한 실적이 아니며, 값이 있을 경우엔 삭제불가능
	            	//if(row.memberID != "${sessionScope.loginInfo.sessionUserId}" && row.WORK_DATE != "") delIcon = "";
	            	// 티켓 담당자가 아니며, 추가된 본인도 아닌 경우 삭제불가능
	            	if("${addUser}" !== "Y" && row.memberID != "${sessionScope.loginInfo.sessionUserId}" ) delIcon = "";
	                
	            	return delIcon;
	            },
	    	},
	        { hidden:true,id: "MbrRcdID", header: [{ text: "MbrRcdID" }] },
	        { hidden:true,id: "srID", header: [{ text: "srID" }] },
	        { hidden:true,id: "memberID", header: [{ text: "memberID" }], type: "string"},
	        {  width: 80, id: "memberName", header: [{ text: "${menu.ZLN0085}", align:"center" }], align:"center" },
	        { hidden:true,id: "teamId", header: [{ text: "teamId" }] },
	        { width: 150, id: "teamName", header: [{ text: "${menu.ZLN0129}", align:"center" }], align:"center" },
			{ width: 100, id: "WORK_DATE", header: [{ text: "${menu.ZLN0130}", align:"center" }], align:"center", minWidth:100,template: function(value) { return value && !isNaN(new Date(value).getTime()) ? new Date(value).toISOString().split('T')[0] : value; }},
// 	        { width: 125, id: "WORK_DATE", header: [{ text: "업무처리일자", align:"center" }], type: "date", dateFormat: "%Y-%m-%d", align:"left", minWidth:125, mark: ( cell, columnCell, row, column  ) => ( editable && row.memberID == "${sessionScope.loginInfo.sessionUserId}" &&  "edit-calander" )},
	        { width: 100, id: "BUSINESS_HOURS", header: [{ text: "${menu.ZLN0182}", align:"center" }], footer: [{ content: "sum", align:"center" }], format: "#.00", type: "number", editorConfig: { min: 0.01, max: 8 },  align:"center", mark: ( cell, columnCell, row  ) => ( editable && (row.memberID == "${sessionScope.loginInfo.sessionUserId}" || modUser == "Y") && "edit-input") },
	        { width: 100, id: "OVERTIME", header: [{ text: "${menu.ZLN0183}", align:"center"}], footer: [{ content: "sum", align:"center" }], format: "#.00", type: "number", editorConfig: { min: 0.01, max: 16 }, align:"center", mark: ( cell, columnCell, row  ) => ( editable && (row.memberID == "${sessionScope.loginInfo.sessionUserId}" || modUser == "Y") && "edit-input") },
	        { width: 120, id: "description", header: [{ text: "${menu.ZLN0133}", align: "center" }], htmlEnable: true, align:"center" },
	        { hidden:true, id: "srID", header: [{ text: "srid" }]},
	        { hidden:true, id: "HOLYDAY", header: [{ text: "srid" }]},
        ],
        sortable:false,
        tooltip : false,
	    data: data,
	    resizable: true,
	    rowHeight: 40
	});
	
	// 정렬
	gridSorting();
	
	if (useOverTime === "N") {
	  grid.hideColumn("OVERTIME");
	} 
	
	layout.getCell("a").attach(grid);
	
	if(modUser == "Y"){
		setSelectMbrUserList();
		
		function setSelectMbrUserList(){
			
			const selectEl = document.querySelector('#selectMbrUserList');
			selectEl.innerHTML = '';
			
			const uniqueMap = new Map();
			uniqueMap.set(${sessionScope.loginInfo.sessionUserId}, {
			    memberName: "${sessionScope.loginInfo.sessionUserNm}",
			    teamCombo: ["${sessionScope.loginInfo.sessionUserId}", "${sessionScope.loginInfo.sessionTeamName}", "${sessionScope.loginInfo.sessionTeamId}"].join(',')
			});
			
			const allData = grid.data.serialize();
			if(allData.length > 0) {
				const mapped = allData.map(item => ({
				  memberId: item.memberID,
				  memberName: item.memberName,
				  teamName: item.teamName,
				  teamId: item.teamID
				}));
				
				mapped.forEach(({memberId, memberName, teamName, teamId}) => {
				  if (!uniqueMap.has(memberId)) {
				    uniqueMap.set(memberId, {
				      memberName,
				      teamCombo: [memberId, teamName, teamId].join(',')
				    });
				  }
				});
				
			}
			const uniqueList = Array.from(uniqueMap.entries()).map(([memberId, {memberName, teamCombo}]) => ({
			  memberName,
			  teamCombo
			}));
		
			uniqueList.forEach(({memberName, teamCombo}) => {
			  const opt = document.createElement('option');
			  opt.value = teamCombo;
			  opt.textContent = memberName;
			  selectEl.appendChild(opt);
			});
			
		}
		
	}
	
	function calDateChange(from, to, type) {
		const list = [];
		let fromDate = from;
		let toDate = to;
		
		// modUser인 경우
		let memberID = "${sessionScope.loginInfo.sessionUserId}";
		let memberName = "${sessionScope.loginInfo.sessionUserNm}";
		let teamID = "${sessionScope.loginInfo.sessionTeamId}";
		let teamName = "${sessionScope.loginInfo.sessionTeamName}";
		
		if(modUser === "Y" && type !== "def"){
			const sel = document.getElementById("selectMbrUserList");
			if(sel.value !== undefined && sel.value !== null && sel.value !== ''){
				const [selMemberID, selTeamName, selTeamID] = sel.value.split(",");
				const selMemberName = sel.options[sel.selectedIndex].text;
	
				memberID = selMemberID;
				memberName = selMemberName;
				teamID = selTeamID;
				teamName = selTeamName;
			}
		}
		
		
		if(toDate < fromDate) {
			calendar2.setValue(fromDate);
			toDate = fromDate;
		}
		
		if(fromDate && toDate) {
	      	fromDate.setHours(9);
	      	toDate.setHours(9);
	    	
			for(var i = 0; i <= Math.abs((toDate - fromDate) / (1000 * 60 * 60 * 24)); i++) {
				const day = new Date(fromDate);
				day.setDate(day.getDate() + i);

			  	if(day.getDay() == "0") list.push({No : list.length+1, WORK_DATE : day.toISOString().split('T')[0], memberID : memberID , memberName : memberName, teamID : teamID, teamName : teamName, BUSINESS_HOURS : "", OVERTIME : "", HOLYDAY:"Y", WEEKEND:"일"});
			  	if(day.getDay() == "1") list.push({No : list.length+1, WORK_DATE : day.toISOString().split('T')[0], memberID : memberID , memberName : memberName, teamID : teamID, teamName : teamName, BUSINESS_HOURS : "", OVERTIME : "", HOLYDAY:"N", WEEKEND:"월"});
			  	if(day.getDay() == "2") list.push({No : list.length+1, WORK_DATE : day.toISOString().split('T')[0], memberID : memberID , memberName : memberName, teamID : teamID, teamName : teamName, BUSINESS_HOURS : "", OVERTIME : "", HOLYDAY:"N", WEEKEND:"화"});
			  	if(day.getDay() == "3") list.push({No : list.length+1, WORK_DATE : day.toISOString().split('T')[0], memberID : memberID , memberName : memberName, teamID : teamID, teamName : teamName, BUSINESS_HOURS : "", OVERTIME : "", HOLYDAY:"N", WEEKEND:"수"});
			  	if(day.getDay() == "4") list.push({No : list.length+1, WORK_DATE : day.toISOString().split('T')[0], memberID : memberID , memberName : memberName, teamID : teamID, teamName : teamName, BUSINESS_HOURS : "", OVERTIME : "", HOLYDAY:"N", WEEKEND:"목"});
			  	if(day.getDay() == "5") list.push({No : list.length+1, WORK_DATE : day.toISOString().split('T')[0], memberID : memberID , memberName : memberName, teamID : teamID, teamName : teamName, BUSINESS_HOURS : "", OVERTIME : "", HOLYDAY:"N", WEEKEND:"금"});
				if(day.getDay() == "6") list.push({No : list.length+1, WORK_DATE : day.toISOString().split('T')[0], memberID : memberID , memberName : memberName, teamID : teamID, teamName : teamName, BUSINESS_HOURS : "", OVERTIME : "", HOLYDAY:"Y", WEEKEND:"토"});
			}
			
			// 기존에 있던 값(업무처리일자를 기준으로) 은 제외하고 선택한 범위내에서 grid data에 추가하기
			list.forEach(l => {
				let index = grid.data.getRawData().filter(e => e.memberID == memberID).findIndex(e => e.WORK_DATE.substring(0, 10) === l.WORK_DATE);
				if(index == -1) { // 그리드 데이터에 없는 경우
					 grid.data.add(l);
				}
			});
			
			// toDate 보다 넘치는 그리드 행 삭제
			//grid.data.getRawData().filter(e => e.memberID == memberID).filter(e => !e.MbrRcdID).filter(e =>  !list.map(e => e.WORK_DATE).includes(e.WORK_DATE)).forEach(e => grid.data.remove(e.id));
			grid.data.getRawData()
			  .filter(e => e.memberID == memberID)
			  .filter(e => !e.MbrRcdID)
			  .filter(e => {
			    const eDate = e.WORK_DATE?.substring(0, 10); // "YYYY-MM-DD"
			    return !list.some(item => item.WORK_DATE === eDate);
			  })
			  .forEach(e => grid.data.remove(e.id));
			
			
			// 추가된 업무처리자의 경우, 업무처리일자가 없는 레코드 삭제
			grid.data.getRawData().filter(e => e.memberID == memberID).filter(e => e.WORK_DATE === "").forEach(e => {
				grid.data.remove(e.id);
				delList.push(e.MbrRcdID);
			})
           createDescButton();
		}
	}
	
	function gridSorting(){
		grid.data.sort({
		    by: "WORK_DATE",
		    dir: "asc"
		});
		grid.data.sort({
		    by: "memberName",
		    dir: "asc"
		});
		
		// RNUM 재셋팅
		grid.data.getRawData().forEach((row, index) => {
		    grid.data.update(row.id, { "RNUM": index + 1 });
		});
	}
	
	function createDescButton() {
		descMbrList = [];
		let memberList = grid.data.getRawData().map(e => e.memberID).reduce((a,c) => {
		    if(!a.includes(c)) {
		        a.push(c);
		    }
		    return a;
		}, []);
		
		// 정렬
		gridSorting();
		
		// desc 버튼 초기화
		grid.data.getRawData().forEach(row => {
		    grid.data.update(row.id, { "description": "" });
		});
		
		memberList.forEach(memberID => {
			
			grid.data.update(grid.data.getRawData().filter(e => e.memberID == memberID)[0]?.id, {...{ "description" : '<div class="btns"><button id="showDesc" class="secondary" style="height: 27px;" onclick="descWindowShow('+memberID+')">${menu.ZLN0133}</button></div>' }});
			descMbrList.push({ 
				"memberID" : memberID,
				"desc" : grid.data.getRawData().filter(e => e.memberID ==  memberID && e.RoleDescription )[0]? grid.data.getRawData().filter(e => e.memberID ==  memberID && e.RoleDescription )[0].RoleDescription : ""
			});
		})
	}
	
	// totalMH();
	 grid.hideColumn("del");
     
	 function editControl() {
		 if("${editMode}" === "Y") {
				// edit 버튼 클릭시 버튼제어
//		 		document.getElementById('editBtn').addEventListener('click', function() {
					editable = true;
					
					 grid.getColumn("BUSINESS_HOURS").editable = true;
					 grid.getColumn("OVERTIME").editable = true;
					 
					for(var i=0; i < grid.config.data.length; i++) {
						if(grid.data.getRawData()[i].memberID == "${sessionScope.loginInfo.sessionUserId}" || modUser == "Y") {
							grid.addCellCss(grid.config.data[i].id, "BUSINESS_HOURS", "edit-input");
							grid.addCellCss(grid.config.data[i].id, "OVERTIME", "edit-input");
						}
					}
					
					grid.showColumn("del");
//		 			document.getElementById('editBtn').style.display = 'none';
//		 			var addRowBtn =document.getElementById('addRow');
//		 			addRowBtn.style.display = 'inline-block';
			  		
					if("${addUser}" === "Y") {
						//업무추가자 버튼 보이기 
						var addUser = document.getElementById('addUser');
						addUser.style.display = 'inline-block';
					}
					
					//save 버튼 보이기 
					var saveBtn = document.getElementById('save');
					save.style.display = 'inline-block';
//		 		});
			 }
	 }
	
	//행추가 버튼 보이기del
	grid.events.on("cellClick", function ( row, column ) {
		 if((row.memberID.toString() === "${sessionScope.loginInfo.sessionUserId}" || modUser == "Y") && editable ) {
			 if ((column.id == "BUSINESS_HOURS" || column.id == "OVERTIME" )) grid.edit(row.id, column.id);
		 } else {
			 grid.getColumn("BUSINESS_HOURS").editable = false;
			 grid.getColumn("OVERTIME").editable = false;
		 }
	});
	
	/* function totalMH(){
		console.log("totalMH", grid.data._initOrder);
		if(grid.data._initOrder){
			document.querySelector("#totalData").innerHTML = 
				(grid.data._initOrder.map(e => Math.round(e.BUSINESS_HOURS * 10) / 10).reduce((a,b) => a+b) 
				+ grid.data._initOrder.map(e => Math.round(e.OVERTIME * 10) / 10).reduce((a,b) => a+b)).toFixed(1);
		}
	}
 */
	
	async function addRow(memberName, teamName, memberID, teamId) {
			grid.data.add({
				memberID: memberID,
				memberName: memberName,
				teamId: teamId,
				teamName: teamName,
				WORK_DATE: "",
				BUSINESS_HOURS: "",
				OVERTIME: ""
			});

 		createDescButton();
		if(descMbrList.findIndex(e => e.memberID == memberID) === -1) descMbrList.push({ "memberID" : memberID, "desc" : ""});
	}
	
	function descSave(descMemberID) {
		descMbrList.filter(e => e.memberID == descMemberID)[0].desc = document.querySelector("#desc").value;
		descWindow.hide();
	}
	
	function descSaveInput(descMemberID){
		descMbrList.filter(e => e.memberID == descMemberID)[0].desc = document.querySelector("#desc").value;
	}
		
	var delList = new Array();
	function deleteRow() {
    	grid.events.on("cellClick", function ( row, column ) {
    		if(column.id === "del"){
    			//삭제조건 
    			 if(row.memberID.toString() === "${sessionScope.loginInfo.sessionUserId}" || "${addUser}" === "Y") {
    				 grid.data.remove(row.id);
    				 if(grid.data.getRawData().filter(e => e.memberID == row.memberID).length > 0) grid.data.update(grid.data.getRawData().filter(e => e.memberID == row.memberID)[0].id, {...{ "description" : '<div class="btns"><button id="showDesc" class="secondary" style="height: 27px;" onclick="descWindowShow('+row.memberID+')">업무내용</button></div>' }})
    				 else descMbrList = descMbrList.filter(e => e.memberID !== row.memberID);
	      			   // 중복 체크 및 추가
	                  if (row.MbrRcdID !== undefined && !delList.includes(row.MbrRcdID)) {
	                      delList.push(row.MbrRcdID);
	                  }
    			 }
//     			document.querySelector("#totalData").innerHTML = (grid.data._initOrder.map(e => Math.round(e.BUSINESS_HOURS * 10) / 10).reduce((a,b) => a+b) + grid.data._initOrder.map(e => Math.round(e.OVERTIME * 10) / 10).reduce((a,b) => a+b)).toFixed(1);
    		}
    	});
    }
		
	grid.events.on("afterEditEnd", (value, row, column) => {
		
		const HOLYDAY = row.HOLYDAY;
		
		if(column.id === "BUSINESS_HOURS") {
			if(isNaN(value) || value < 0){
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
		windowHTML = '<textarea class="edit pdL10 pdR10 pdT10" style="width:100%; height:200px; resize: none;" id="desc" oninput="descSaveInput(' + descMemberID +')" ';
		if(!editable || (modUser != "Y" && editable && descMemberID != "${sessionScope.loginInfo.sessionUserId}")) windowHTML += "readonly";
		windowHTML +='>'+descMbrList.filter(e => e.memberID == descMemberID)[0]?.desc+'</textarea>';
		if(editable && (descMemberID == "${sessionScope.loginInfo.sessionUserId}" || modUser == "Y")) windowHTML += '<div class="btns mgT10 floatR"><button onclick="descSave(' + descMemberID + ')" class="secondary">save</button></div>';
		descWindow.attachHTML(windowHTML);
		descWindow.show();
	}
	
	function fnDefaultSetting(){
		if (grid._filterData) {
			// grid 있을 경우, memberId 비교해서 해당 member없으면 default로 한줄 추가 (today)
			const existingMember = grid._filterData.find(e => e.memberID === Number('${sessionScope.loginInfo.sessionUserId}'));
			if (!existingMember) {
				calDateChange(today,today,'def');
			}
		} else {
			// 아무것도 없을 경우 default로 담당자 한줄 추가 (today)
			calDateChange(today,today,'def');
		}
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
