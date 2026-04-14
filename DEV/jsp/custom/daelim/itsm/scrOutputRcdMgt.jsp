<%@ page import="xbolt.cmm.framework.val.GlobalVal"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:url value="/" var="root" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>산출물 입력 페이지</title>

<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<!-- DHX Grid 7.1.8 -->
<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">
<link rel="stylesheet" type="text/css" href="${root}cmm/common/css/ui-layout.css" />
<link rel="stylesheet" type="text/css" href="${root}cmm/<%=GlobalVal.BASE_ATCH_URL%>/css/style.css" />
<script src="/cmm/js/jquery/jquery.js" type="text/javascript"></script>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00067" var="WM00067"/>
<style>
	.dhx_grid-cell__content input:not(input[type=checkbox]):not(input:read-only) {
		content: "";
		position: absolute;
		border: 1px solid #ddd;
		width: calc(100% - 12px);
		height: calc(100% - 12px);
		left: 6px;
		border-radius: 6px;
		padding-left: 10px;
	}
	
	.dhx_grid-cell__content input:read-only {
		border: none;
   	 	cursor: default;
   	 	width:100%;
	}
	
	.caution-text {
		display: flex;
		border: 1px solid #dfdfdf;
		border-top: none;
		padding: 20px;
		gap: 5px;
	}
	
	.caution-text span {
		color: #0761CF;
	}
	
	.caution-text p {
		color: #222222;
	}
	
	.checkbox {
		display: inline-block;
	    position: relative;
	    margin-right: 30px;
	}
	
	.checkbox input[type=checkbox] {
		clip: rect(0, 0, 0, 0);
		height: 0px;
		margin: -1px;
		overflow: hidden;
		position: absolute;
		width: 0px;
	}
	
	.checkbox input[type=checkbox]+label {
		-webkit-box-sizing: border-box;
		box-sizing: border-box;
		display: inline-block;
		min-height: 20px;
		padding-left: 22px;
		vertical-align: middle;
	}
	
	.checkbox input[type=checkbox]+label:before {
		position: absolute;
		content: "";
		height: 16px;
		width: 16px;
		left: 0px;
		top: 3px;
		border-radius: 3px;
		border: 1px solid #ddd;
		transition: all 0.15s;
	}
	.checkbox input[type=checkbox]:hover+label:before {
		border-color: #0761CF;
	}
	.checkbox input[type=checkbox]:checked+label:before {
		background-color: #0761CF;
		background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' height='20px' viewBox='0 -960 960 960' width='20px' fill='%23FFFFFF'%3E%3Cpath d='M389-267 195-460l51-52 143 143 325-324 51 51-376 375Z'/%3E%3C/svg%3E");
		background-repeat: no-repeat;
		background-position: center center;
		background-size: 16px;
		border: 1px solid #0761CF;
	}
</style>
<script>
		let rcdID = "${rcdID}";
		const clientID = "${clientID}";
		
		jQuery(document).ready(function() {
			if("${editMode}" === "Y") {
// 				fnSetButton("save", "", "저장");
			} else {
				document.querySelectorAll("input[type='text']").forEach(e => {
					e.readOnly = true;
				});
				document.querySelectorAll("input[type='checkbox']").forEach(e => {
					e.setAttribute("disabled",true);
				});
			}
			
			if("${mbrRcd.RESPONSE_SPEED}" === "Y") document.querySelector("#RESPONSE_SPEED").checked = true;
			if("${mbrRcd.BATCH_SPEED}" === "Y") document.querySelector("#BATCH_SPEED").checked = true;
		});
		
		function fnSetButton(el, iconName, text, style = "primary") {
			const button = document.querySelector("#"+el);
			button.classList.add(style);
			if(iconName) button.innerHTML = icon[iconName];
			button.innerHTML += `<span class='text'>\${text}</span>`;
		}
		
		function fnCheckValidation(){
			
			let rs = true;
			let sum = 0;
			// input number (QY) 계산
			const allQys = document.querySelectorAll(`input.${"OUTPUT_QY"}[type="number"]`); // 전체 산출물 수
			
			for (let i = 0; i < allQys.length; i++) {
			    const input = allQys[i];
			    const value = parseFloat(input.value);

			    if (value !== "" && value !== 0 && !isNaN(value)) {
			        sum += value;
			        const dtl = input.id.replace("_QY", "_DTL");
			        const dtlInput = document.getElementById(dtl).value; 
					
			        // DL 케미칼 예외
			        if(clientID == "0000000007"){
				        if (dtlInput === undefined || dtlInput === null || dtlInput === "") {
				            alert("산출물 상세를 입력하세요");
				            rs = false;
				            break; // 반복 중단
				        }
			   	 	}
			        
			    }
			}
			
			if(sum < 1){
				alert("개선관리 실적 데이터를 입력하세요");
				rs = false;
			}
			
			return rs;
		}
		
		const input = [
			"NEW_SCRIN_OUTPUT_QY",
			"NEW_SCRIN_OUTPUT_DTL",
			"NEW_BATCH_OUTPUT_QY",
			"NEW_BATCH_OUTPUT_DTL",
			"NEW_CONFIG_OUTPUT_QY",
			"NEW_CONFIG_OUTPUT_DTL",
			"NEW_DATA_OUTPUT_QY",
			"NEW_DATA_OUTPUT_DTL",
			"NEW_TABLE_OUTPUT_QY",
			"NEW_TABLE_OUTPUT_DTL",
			"CHANGE_SCRIN_OUTPUT_QY",
			"CHANGE_SCRIN_OUTPUT_DTL",
			"CHANGE_BATCH_OUTPUT_QY",
			"CHANGE_BATCH_OUTPUT_DTL",
			"CHANGE_CONFIG_OUTPUT_QY",
			"CHANGE_CONFIG_OUTPUT_DTL",
			"CHANGE_DATA_OUTPUT_QY",
			"CHANGE_DATA_OUTPUT_DTL",
			"CHANGE_TABLE_OUTPUT_QY",
			"CHANGE_TABLE_OUTPUT_DTL",
		]
		
		const checkbox = [
			"RESPONSE_SPEED",
			"BATCH_SPEED"
		]
	
		function fnSave(activityStatus) {
			
			if(activityStatus == "05"){
				if(!fnCheckValidation()) return false;
			}
			
			let data = "rcdID="+rcdID+"&srID=${srID}&speCode=${speCode}&memberID=${sessionScope.loginInfo.sessionUserId}&procRoleTP=${procRoleTP}";
			let value = "";
			
			for(let i=0; i < input.length; i++) {
				value = document.querySelector("#"+input[i]).value;
				data += `&\${input[i]}=\${value}`
			}
			
			for(let i=0; i < checkbox.length; i++) {
				value = document.querySelector("#"+checkbox[i]).checked ? "Y" : "N";
				data += `&\${checkbox[i]}=\${value}`
			}
			
			ajaxPage("saveOutputRcd.do",data,"blankFrame");
			return true;
		}
		
		function saveCallBack(id) {
			rcdID = id;
			//alert("${WM00067}");
		}
		
		// 음수 체크
		function checkPositiveValue(input) {
		   if (parseFloat(input.value) < 0) {
		     input.value = 0;
		   }
 		}
		
	</script>
</head>
<body>
	<div class="page-subtitle btn-wrap">
		개선관리 실적 입력(기본 규모 측정)
<!-- 		<div class="btns"> -->
<%-- 			<c:if test="${editMode eq 'Y'}"> --%>
<!-- 				<button id="save" onclick="fnSave()"></button> -->
<%-- 			</c:if> --%>
<!-- 		</div> -->
	</div>
	<!-- DHX Grid가 표시될 영역 -->
	<div id="grid" style="width: 100%; height: 482px;"></div>
	<div class="caution-text">
		<span>※</span>
		<p>
			서비스 대가 산정에 필요한 개선 실적 기초 Data로 활용됩니다.<br> 신규 또는 변경/삭제 유형 별 개선 산출물수 입력고 성능 향상의 변경 요청 처리 일 경우 성능향상 여부를 체크해주시기 바랍니다.<br> 필수 입력 필드로 미 작성시 다음 단계로 진행이 되지 않습니다.
		</p>
	</div>
	<iframe name="blankFrame" id="blankFrame" src="about:blank" style="display: none; border: 0;"></iframe>
	<script>
     	
		const NEW_SCRIN_OUTPUT_DTL = String.raw`${mbrRcd.NEW_SCRIN_OUTPUT_DTL}`; // String raw 백슬래시를 있는 그대로 출력 되도록 하는 명령어 
		const NEW_BATCH_OUTPUT_DTL = String.raw`${mbrRcd.NEW_BATCH_OUTPUT_DTL}`;
		const NEW_CONFIG_OUTPUT_DTL = String.raw`${mbrRcd.NEW_CONFIG_OUTPUT_DTL}`;
		const NEW_DATA_OUTPUT_DTL = String.raw`${mbrRcd.NEW_DATA_OUTPUT_DTL}`;
		const NEW_TABLE_OUTPUT_DTL = String.raw`${mbrRcd.NEW_TABLE_OUTPUT_DTL}`;
		const CHANGE_SCRIN_OUTPUT_DTL = String.raw`${mbrRcd.CHANGE_SCRIN_OUTPUT_DTL}`;
		const CHANGE_BATCH_OUTPUT_DTL = String.raw`${mbrRcd.CHANGE_BATCH_OUTPUT_DTL}`;
		const CHANGE_CONFIG_OUTPUT_DTL = String.raw`${mbrRcd.CHANGE_CONFIG_OUTPUT_DTL}`;
		const CHANGE_DATA_OUTPUT_DTL = String.raw`${mbrRcd.CHANGE_DATA_OUTPUT_DTL}`;
		const CHANGE_TABLE_OUTPUT_DTL = String.raw`${mbrRcd.CHANGE_TABLE_OUTPUT_DTL}`;
		
        const dataset = [
            {
                "type" : "",
                "gubun" : "",
                "name" : "화면 기능",
                "qy": "<input type='number' oninput='checkPositiveValue(this)' class='OUTPUT_QY' id='NEW_SCRIN_OUTPUT_QY' value='${mbrRcd.NEW_SCRIN_OUTPUT_QY}'/>",
                "dtl": `<input type='text' id='NEW_SCRIN_OUTPUT_DTL' />`,
                "id" : "1"
            },
            {
                "type" : "",
                "gubun" : "",
                "name" : "배치 프로그램",
                "qy": "<input type='number' oninput='checkPositiveValue(this)' class='OUTPUT_QY' id='NEW_BATCH_OUTPUT_QY' value='${mbrRcd.NEW_BATCH_OUTPUT_QY}'/>",
                "dtl": `<input type='text' id='NEW_BATCH_OUTPUT_DTL' />`
            },
            {
                "type" : "",
                "gubun" : "",
                "name" : "Config화면(패키지)",
                "qy": "<input type='number' oninput='checkPositiveValue(this)' class='OUTPUT_QY' id='NEW_CONFIG_OUTPUT_QY' value='${mbrRcd.NEW_CONFIG_OUTPUT_QY}'/>",
                "dtl": `<input type='text' id='NEW_CONFIG_OUTPUT_DTL' />`
            },
            {
                "type" : "",
                "gubun" : "",
                "name" : "Data(SQL)프로그램",
                "qy": "<input type='number' oninput='checkPositiveValue(this)' class='OUTPUT_QY' id='NEW_DATA_OUTPUT_QY' value='${mbrRcd.NEW_DATA_OUTPUT_QY}'/>",
                "dtl": `<input type='text' id='NEW_DATA_OUTPUT_DTL' />`
            },
            {
                "type" : "",
                "gubun" : "데이터 기능",
                "name" : "테이블",
                "qy": "<input type='number' oninput='checkPositiveValue(this)' class='OUTPUT_QY' id='NEW_TABLE_OUTPUT_QY' value='${mbrRcd.NEW_TABLE_OUTPUT_QY}'/>",
                "dtl": `<input type='text' id='NEW_TABLE_OUTPUT_DTL' />`
            },
            {
                "type" : "",
                "gubun" : "",
                "name" : "화면 기능",
                "qy": "<input type='number' oninput='checkPositiveValue(this)' class='OUTPUT_QY' id='CHANGE_SCRIN_OUTPUT_QY' value='${mbrRcd.CHANGE_SCRIN_OUTPUT_QY}'/>",
                "dtl": `<input type='text' id='CHANGE_SCRIN_OUTPUT_DTL' />`,
                "id" : "2"
            },
            {
                "type" : "",
                "gubun" : "",
                "name" : "배치 프로그램",
                "qy": "<input type='number' oninput='checkPositiveValue(this)' class='OUTPUT_QY' id='CHANGE_BATCH_OUTPUT_QY' value='${mbrRcd.CHANGE_BATCH_OUTPUT_QY}'/>",
                "dtl": `<input type='text' id='CHANGE_BATCH_OUTPUT_DTL' />`
            },
            {
                "type" : "",
                "gubun" : "",
                "name" : "Config화면(패키지)",
                "qy": "<input type='number' oninput='checkPositiveValue(this)' class='OUTPUT_QY' id='CHANGE_CONFIG_OUTPUT_QY' value='${mbrRcd.CHANGE_CONFIG_OUTPUT_QY}'/>",
                "dtl": `<input type='text' id='CHANGE_CONFIG_OUTPUT_DTL' />`
            },
            {
                "type" : "",
                "gubun" : "",
                "name" : "Data(SQL)프로그램",
                "qy": "<input type='number' oninput='checkPositiveValue(this)' class='OUTPUT_QY' id='CHANGE_DATA_OUTPUT_QY' value='${mbrRcd.CHANGE_DATA_OUTPUT_QY}'/>",
                "dtl": `<input type='text' id='CHANGE_DATA_OUTPUT_DTL' />`
            },
            {
                "type" : "",
                "gubun" : "데이터 기능",
                "name" : "테이블",
                "qy": "<input type='number' oninput='checkPositiveValue(this)' class='OUTPUT_QY' id='CHANGE_TABLE_OUTPUT_QY' value='${mbrRcd.CHANGE_TABLE_OUTPUT_QY}'/>",
                "dtl": `<input type='text' id='CHANGE_TABLE_OUTPUT_DTL' />`
            },
            {
                "type" : "성능향상 여부 체크",
                "gubun" : "",
                "name" : "",
                "qy": "",
                "dtl": "",
                "id" : "3"
            },
        ];

        const grid = new dhx.Grid("grid", {
            columns: [
                { width: 150, id: "type", header: [{ text: "유형", align:"center" }], align:"center"},
                { width: 180, id: "gubun", header: [{ text: "구분", align:"center" }], htmlEnable: true, align:"center" },
                { width: 280, id: "name", header: [{ text: "산출물명", align:"center" }] },
                { width: 110, id: "qy", header: [{ text: "산출물수", align:"center" }], htmlEnable: true, align:"center" },
                { gravity:1, id: "dtl", header: [{ text: "산출물상세", align:"center" }], htmlEnable: true}
            ],
            spans: [
                { row: "1", column: "type", rowspan: 5, text : "신규" },
                { row: "1", column: "gubun", rowspan: 4, text: "트랜잭션 기능" },
                { row: "2", column: "type", rowspan: 5, text : "변경/삭제" },
                { row: "2", column: "gubun", rowspan: 4, text: "트랜잭션 기능" },
                { row: "3", column: "gubun",colspan: 4, 
                	text: `<div class="alignL pdL10"><span class="checkbox">
			    	<input type="checkbox" id="RESPONSE_SPEED">
			    	<label for="RESPONSE_SPEED">응답속도 단축</label>
			    </span>
			    <span class="checkbox">
			    	<input type="checkbox" id="BATCH_SPEED">
			    	<label for="BATCH_SPEED">배치 프로그램 수행단축</label>
			    </span></div>`
			    },
            ],
            sortable : false,
            data: dataset,
            autoWidth: true,
		    rowHeight: 40,
		    tooltip:false
        });
        
        document.getElementById('NEW_SCRIN_OUTPUT_DTL').value = NEW_SCRIN_OUTPUT_DTL;
		document.getElementById('NEW_BATCH_OUTPUT_DTL').value = NEW_BATCH_OUTPUT_DTL;
		document.getElementById('NEW_CONFIG_OUTPUT_DTL').value = NEW_CONFIG_OUTPUT_DTL;
		document.getElementById('NEW_DATA_OUTPUT_DTL').value = NEW_DATA_OUTPUT_DTL;
		document.getElementById('NEW_TABLE_OUTPUT_DTL').value = NEW_TABLE_OUTPUT_DTL;
		document.getElementById('CHANGE_SCRIN_OUTPUT_DTL').value = CHANGE_SCRIN_OUTPUT_DTL;
		document.getElementById('CHANGE_BATCH_OUTPUT_DTL').value = CHANGE_BATCH_OUTPUT_DTL;
		document.getElementById('CHANGE_CONFIG_OUTPUT_DTL').value = CHANGE_CONFIG_OUTPUT_DTL;
		document.getElementById('CHANGE_DATA_OUTPUT_DTL').value = CHANGE_DATA_OUTPUT_DTL;
		document.getElementById('CHANGE_TABLE_OUTPUT_DTL').value = CHANGE_TABLE_OUTPUT_DTL;
    </script>
</body>
</html>
