<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>진행 단계별 완료예정일</title>
    <!-- DHX Grid 7.1.8 -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
	<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css"/>
 	<script src="/cmm/js/jquery/jquery.js" type="text/javascript"></script> 
	<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/style.css" />
	
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
	<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00015" var="WM00015" arguments="단계 완료예정일"/>

    <style>
        .dhx_cell-editor {
            box-shadow: none;
        }
        .dhx_grid-cell.edit-calander {
            padding-left: 15px;
        }
        .dhx_grid-cell.edit-calander, .dhx_grid-cell.edit-input {
        	cursor:text;
        }
       .dhx_grid-cell.edit-calander:after, .dhx_grid-cell.edit-input:after  {
			content: "";
		    position: absolute;
		    border: 1px solid #ddd;
		    width: calc(100% - 12px);
		    height: calc(100% - 12px);
		    left: 6px;
		    border-radius: 6px;
        }
        .dhx_grid-cell.edit-calander:after {
		   	background-image: url("data:image/svg+xml,%3C%3Fxml version='1.0' encoding='UTF-8'%3F%3E%3Csvg version='1.1' xmlns='http://www.w3.org/2000/svg' width='24' height='24'%3E%3Cpath d='M0 0 C0.99 0 1.98 0 3 0 C3 0.66 3 1.32 3 2 C5.64 2 8.28 2 11 2 C11 1.34 11 0.68 11 0 C11.66 0 12.32 0 13 0 C13 0.66 13 1.32 13 2 C13.99 2 14.98 2 16 2 C16 7.94 16 13.88 16 20 C10.06 20 4.12 20 -2 20 C-2 14.06 -2 8.12 -2 2 C-1.34 2 -0.68 2 0 2 C0 1.34 0 0.68 0 0 Z M0 4 C0 4.66 0 5.32 0 6 C4.62 6 9.24 6 14 6 C14 5.34 14 4.68 14 4 C9.38 4 4.76 4 0 4 Z M0 8 C0 11.3 0 14.6 0 18 C4.62 18 9.24 18 14 18 C14 14.7 14 11.4 14 8 C9.38 8 4.76 8 0 8 Z ' fill='%23000000' transform='translate(5,2)'/%3E%3C/svg%3E%0A");
		   	background-repeat: no-repeat;
		    background-position: center right;
		    background-position-x: calc(100% - 5px);
		    background-size: 18px;
        }
        .gridRowColor {
        	background:#0761cf14;
        }
    </style>
	<script type="text/javascript">
		
		let today = new Date();
		today = today.getFullYear() +
		'-' + ( (today.getMonth()+1) <= 9 ? "0" + (today.getMonth()+1) : (today.getMonth()+1) )+
		'-' + ( (today.getDate()) <= 9 ? "0" + (today.getDate()) : (today.getDate()) );
		
		let alertMsg1, alertMsg1 = "";
		getDicData("ERRTP", "ZLN0020").then(data => alertMsg1 = data.LABEL_NM);
		getDicData("ERRTP", "ZLN0021").then(data => alertMsg2 = data.LABEL_NM);
		 
		async function saveRow(activityStatus){
			const gridData = dueGrid.data._order;
			
			if(activityStatus == "05"){
				let validation = true;
				gridData.forEach(function(data) {
					if(data.SRAT0069 === undefined || data.SRAT0069 == '' || data.SRAT0069 == null) {
				    	validation = false;
				    	return;
				    }
				});
// 				if(!validation) { alert("진행 단계별 완료예정일을 모두 입력하세요."); return false; }
				if(!validation) { alert(alertMsg1); return false; }
				
				let validation2 = true;
				gridData.forEach(function(data, index, array) {
					if (index > 0) { 
				        var prevDate = new Date(array[index - 1].SRAT0069);  // 이전 항목의 날짜
				        var currentDate = new Date(data.SRAT0069);           // 현재 항목의 날짜
				        
				        if (currentDate < prevDate) {
				        	validation2 = false;
				        	return;
				        }
				    }
				});
// 				if(!validation2) { alert("전 단계의 완료예정일보다 작을 수 없습니다."); return false; }
				if(!validation2) { alert(alertMsg2); return false; }
			}
			
		    const updatedData = gridData.map(item => ({
		        ...item,
		        srID: '${srID}',
		        attrTypeCode: 'SRAT0069'
		    }));
		    const payload = {
		    	data: updatedData,
		    };
	   		
		    // 객체를 JSON 문자열로 변환
	    	const data_initOrder = JSON.stringify(payload);
		    
	    	try{
				const response = await fetch('/saveEspDueDate.do', {
				 	  method: 'POST',
			 		  body : data_initOrder,
			 		  headers: {
			 			  'Content-type': 'application/json; charset=UTF-8',
			 		  },
		 		});
				
				const data = await response.json();
				
				if (data.result == false) {
				    return false;
				} else {
					return true;
				}
				
			}catch (error) {
				return false;
			}
		}
		
	</script>
</head>
<body>
 	<!-- 주요 파라미터  -->
   <input name="srID" id="srID" value="${srID}" style="display:none;" />
   <input name="scrID" id="scrID" value="" style="display:none;" />
   <input name="procRoleTP" id="procRoleTP" value="" style="display:none;"/>
   <input name="SpeCode" id="SpeCode" value="" style="display:none;"/>
	
	<div class="page-subtitle btn-wrap">
		진행 단계별 완료예정일 <c:if test="${dueDate ne null && dueDate ne ''}">[티켓 완료예정일 : ${dueDate}]</c:if>
	</div>
  
	<div style="height: 500px; width: 100%" id="dueDateGrid"></div>
	
    
    
    <script type="text/javascript">
    const editMode = '${editMode}';
    const speCode = '${speCode}';
    let dueDateGrid = ${gridData};
    
    var now = new Date();
	var offset = now.getTimezoneOffset() * 60000;
	var estNow = new Date(now.getTime() - offset);
	
	let currentDate = estNow.toISOString().substring(0,10); // 현재 날짜 (yyyy-mm-dd 형식)
	//let currentDate = new Date().toISOString().split('T')[0]; // 현재 날짜 (yyyy-mm-dd 형식)
    dueDateGrid.forEach(function(row, index) {
        if (index !== dueDateGrid.length - 1 && !row.SRAT0069) {
            row.SRAT0069 = currentDate;
        } else if(!row.SRAT0069) {
        	row.SRAT0069 = '';
        }
    });
	
    const dueGrid = new dhx.Grid("dueDateGrid", {
    	columns: [
	        { hidden:true, id: "ActorID", header: [{ text: "ActorID", align: "center" }], align:"center"  },
	        { hidden:true, id: "SpeCode", header: [{ text: "SpeCode", align: "center" }], align:"center"  },
	        { hidden:true, id: "Status", header: [{ text: "Status", align: "center" }], align:"center"  },
	        { width: 200, id: "Stsname", header: [{ text: "단계", align: "center" }], align:"center"},
	        { width: 125, id: "SRAT0069", header: [{ text: "단계 완료예정일", align:"center" }], type: "date", dateFormat: "%Y-%m-%d",
	          mark: () => ("edit-calander"), align:"left", minWidth:125},
	        { width: 150, id: "EndTime", header: [{ text: "실제 처리완료일", align:"center" }], align:"center", minWidth:150
	        	, template: function(text, row) { return setDueDateValue(text, row.SpeCode, row.Status)}},
	        { width: 200, id: "ReceiptUserNM", header: [{ text: "작업자", align:"center" }], align:"center"
	        	,template: function(text, row) { return setDueDateValue(text, row.SpeCode, row.Status)}},
	        { hidden:true, id: "DocCategory", header: [{ text: "DocCategory", align: "center" }], align:"center"  }
        ],
        sortable:false,
        tooltip : false,
	    data: dueDateGrid,
	    resizable: true,
	    rowHeight: 40,
	    rowCss: function (row) { return row.SpeCode == speCode ? "gridRowColor" : "" }
	});
    
    function setDueDateValue(text, rowSpeCode, Status){
    	
    	let result;
    	if(text == null || text == undefined || text == ''){
    		result = "-";
    	} else {
    		result = text;
    	}
    	
    	if(editMode != "Y"){
    		if(rowSpeCode == speCode){
    			if(Status == "07") result = "강제종료";
    			else result = "진행중";
    		}
    	}
    	
    	return result;
    }
    
    <c:if test="${editMode eq 'Y'}">
		
	    dueGrid.events.on("cellClick", function(row,column){
	    	dueGrid.getColumn("SRAT0069").editable = true;
	    	if (column.id=="SRAT0069") dueGrid.edit(row.id,column.id);
	    });
    
		dueGrid.events.on("afterEditEnd", (value, row, column) => {
			if(column.id === "SRAT0069") {
				
				if(value < today) {
					alert("${WM00015}");
					dueGrid.data.update(row.id, { ...row, SRAT0069 : "" })
					return;
				}
				
			}
		});
			
	</c:if>
	
	
    </script>
</body>
</html>
