<%@ page import = "java.util.List, java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
	<title>역할 및 실적</title>
</head>
<script>
	let windowHTML = "";

	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var treeGridData = ${treeGridData};
	let a = treeGridData.filter(e => e.parent !== "treeGridArea");
	let b = Object.groupBy(a, ({ parent }) => parent);
	let c = Object.keys(b).map(key => { return { status : key, memberList : b[key].map(e => e.MemberID).reduce((a,c) => {
 	    if(!a || !a.includes(c)) {
 	        a.push(c);
 	    }
 	    return a;
 	}, []) } });
	c.filter(e => e.status !== "undefined").forEach(data => {
	    data.memberList.forEach(memberID => 
	    	treeGridData[treeGridData.findIndex(e => e.MemberID === memberID && e.parent === data.status)] = {...treeGridData[treeGridData.findIndex(e => e.MemberID === memberID && e.parent === data.status)], ...{ "description" : '<div class="btns"><button id="showDesc" class="secondary" style="height: 27px;" onclick="descWindowShow('+memberID+',\''+data.status+'\')">업무내용</button></div>' }}
	    );
	})
	
	var treeGrid = new dhx.Grid("treeGridArea", {
		type: "tree",
	    columns: [
 	    	{ id: "Name", type: "string", header: [{ text: "Name", align:"center" }], footer: [{ text: "Total", colspan:3 }], fillspace: true, htmlEnable: true,
	    		template: function (text, row, col) {
	            	var result = "";
	            	result += row.RNUM;
	            	if(row.parent) result += "<span class='font-bold mgL5'>"+text+"</span>";
	                return result;
	            }
	        },
		    { id: "TeamName", type: "string", header: [{ text: "${menu.ZLN0129}", align:"center" }], width:150, align:"center"},
		    { id: "WORK_DATE", type: "string", header: [{ text: "${menu.ZLN0130}", align:"center" }], width:300, align:"center"
		    		,template: function(text, row, col) { 
		    			if(text !== null && text !== '' && text !== undefined){
		    				return text && typeof text === 'string' && text.includes(' ') ? text.split(' ')[0] : text;
		    			} else {
		    				var childDates = treeGridData
	                        .filter(r => r.parent === row.SpeCode)
	                        .map(r => r.WORK_DATE)
	                        .filter(d => d && typeof d === 'string')
	                        .map(d => d.includes(' ') ? d.split(' ')[0] : d);
	                    
	                    	if(childDates.length) {
		                        var minDate = childDates.reduce((a,b) => a < b ? a : b);
		                        var maxDate = childDates.reduce((a,b) => a > b ? a : b);
		                        return minDate + ' ~ ' + maxDate;
		    				}
		    			}
		    		}},
		    { id: "BH", type: "number", header: [{ text: "M/H ${menu.ZLN0182}", align:"center" }], footer: [{ content: "sum" , align:"center"}], format: "#.00", width:150, align:"center"},
		    { id: "OT", type: "number", header: [{ text: "M/H  ${menu.ZLN0183}", align:"center" }], footer: [{ content: "sum" , align:"center"}], format: "#.00", width:150, align:"center"},
		    { width: 150, id: "description", header: [{ text: "${menu.ZLN0133}", align: "center" }], htmlEnable: true, align:"center" },
		    { id: "Total", type: "number", header: [{ text: "Total", align:"center" }], footer: [{ content: "sum" , align:"center"}], format: "#.00", width:150, align:"center"},
		    { hidden:true, id: "TeamID", type: "string", header: [{ text: "TeamID", align:"center" }]},
		    { hidden:true, id: "MemberID", type: "string", header: [{ text: "MemberID", align:"center" }]},
		    { hidden:true, id: "RoleDescription", type: "string", header: [{ text: "MemberID", align:"center" }]}
	    ],
	    autoWidth: true,
	    resizable: true,
	    data : treeGridData
	});
	
	console.log(treeGridData);
	
	layout.getCell("a").attach(treeGrid);
	
	const descWindow = new dhx.Window({
	    width: 440,
	    height: 355,
	    title: "${menu.ZLN0133}",
	    closable: true,
	    modal: true
	});
	
	function descWindowShow(descMemberID, status) {
		var RoleDescription = treeGridData.filter(e => e.parent === status && e.MemberID === descMemberID)[0].RoleDescription
		if(RoleDescription === undefined) RoleDescription = "";
		
		windowHTML = '<textarea class="edit pdL10 pdR10 pdT10" style="width:100%; height:200px; resize: none;" id="desc" readonly>';
		windowHTML += RoleDescription +'</textarea>';
		descWindow.attachHTML(windowHTML);
		descWindow.show();
	}

		fetch("/olmapi/espActivityOutput/?srID=${srID}&languageID=${languageID}")
		.then((response) => response.json())
		.then((data) => {
			if(data.length > 0) {
				document.querySelector("#esp-output").style.display = "block";
				let html = "";
				html += "<table class='tbl_blue' width='100%'>"
				html += "<colgroup><col width='150px'><col width='180px'><col width='280px'><col width='110px'><col width='*'></colgroup>";
				html += "<tr><th>유형</th><th>구분</th><th>산출물명</th><th>산출물수</th><th class='last'>산출물상세</th></tr>"
				html += "<tr><td rowspan=5>신규</td><td rowspan=4>트랜잭션 기능</td><td class='alignL pdL10'>화면 기능</td><td>"+data[0].NEW_SCRIN_OUTPUT_QY+"</td><td class='last alignL pdL10'>"+data[0].NEW_SCRIN_OUTPUT_DTL+"</td></tr>"
				html += "<tr><td class='alignL pdL10'>배치 프로그램</td><td>"+data[0].NEW_BATCH_OUTPUT_QY+"</td><td class='last alignL pdL10'>"+data[0].NEW_BATCH_OUTPUT_DTL+"</td></tr>"
				html += "<tr><td class='alignL pdL10'>Config화면(패키지)</td><td>"+data[0].NEW_CONFIG_OUTPUT_QY+"</td><td class='last alignL pdL10'>"+data[0].NEW_CONFIG_OUTPUT_DTL+"</td></tr>"
				html += "<tr><td class='alignL pdL10'>Data(SQL)프로그램</td><td>"+data[0].NEW_DATA_OUTPUT_QY+"</td><td class='last alignL pdL10'>"+data[0].NEW_DATA_OUTPUT_DTL+"</td></tr>"
				html += "<tr><td>데이터 기능</td><td class='alignL pdL10'>테이블</td><td>"+data[0].NEW_TABLE_OUTPUT_QY+"</td><td class='last alignL pdL10'>"+data[0].NEW_TABLE_OUTPUT_DTL+"</td></tr>"
				html += "<tr><td rowspan=5>변경/삭제</td><td rowspan=4>트랜잭션 기능</td><td class='alignL pdL10'>화면 기능</td><td>"+data[0].CHANGE_SCRIN_OUTPUT_QY+"</td><td class='last alignL pdL10'>"+data[0].CHANGE_SCRIN_OUTPUT_DTL+"</td></tr>"
				html += "<tr><td class='alignL pdL10'>배치 프로그램</td><td>"+data[0].CHANGE_BATCH_OUTPUT_QY+"</td><td class='last alignL pdL10'>"+data[0].CHANGE_BATCH_OUTPUT_DTL+"</td></tr>"
				html += "<tr><td class='alignL pdL10'>Config화면(패키지)</td><td>"+data[0].CHANGE_CONFIG_OUTPUT_QY+"</td><td class='last alignL pdL10'>"+data[0].CHANGE_CONFIG_OUTPUT_DTL+"</td></tr>"
				html += "<tr><td class='alignL pdL10'>Data(SQL)프로그램</td><td>"+data[0].CHANGE_DATA_OUTPUT_QY+"</td><td class='last alignL pdL10'>"+data[0].CHANGE_DATA_OUTPUT_DTL+"</td></tr>"
				html += "<tr><td>데이터 기능</td><td class='alignL pdL10'>테이블</td><td>"+data[0].CHANGE_TABLE_OUTPUT_QY+"</td><td class='last alignL pdL10'>"+data[0].CHANGE_TABLE_OUTPUT_DTL+"</td></tr>"
				html += `<tr><td>성능향상 여부 체크</td><td colspan=4 class="alignL pdL10"><span class="checkbox"><input type="checkbox" disabled \${data[0].RESPONSE_SPEED === "Y" && "checked"} id="RESPONSE_SPEED" /><label for="RESPONSE_SPEED">응답속도 단축</label></span>`
				html += `<span class="checkbox"><input type="checkbox" class="checkbox" disabled \${data[0].BATCH_SPEED === "Y" && "checked" } id="BATCH_SPEED" /><label for="BATCH_SPEED">배치 프로그램 수행단축</label></span></td></tr>`
				html +=  "</table>"
				
				document.querySelector("#output-data").insertAdjacentHTML("afterend", html);
			}
		})
</script>
<body>
	<div class="border-section">
		<div class="pdT20 pdB10"></div>
		<div class="page-subtitle pdT1">${menu.ZLN0172}</div>
		<div style="width: 100%;height:400px;" id="layout"></div>
		<div id="esp-output" style="display:none;">
			<div class="page-subtitle">개선관리 실적</div>
			<div id="output-data"></div>
		</div>
		
	</div>
</body>
</html>
