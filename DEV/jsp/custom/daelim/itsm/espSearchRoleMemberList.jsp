<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 OTitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00119" var="WM00119" arguments="1000"/>

<script>	
	
	const itDeptOpt = "${itDeptOpt}";
	
	$(document).ready(function(){	
		
		/* <c:if test="${editYN ne 'Y' }">
			alert("그룹권한이 없으면 조회가 불가능합니다.\n관리자에게 그룹권한 요청 부탁드립니다.")
		</c:if> */
		
		// 초기 표시 화면 크기 조정
		$("#layout").attr("style","height:"+(setWindowHeight() - 340)+"px; width:100%;");
		// 화면 크기 조정
		window.onresize = function() {
			$("#layout").attr("style","height:"+(setWindowHeight() - 340)+"px; width:100%;");
		};
		$("#TOT_CNT").html(grid.data.getLength());
		
		// company setting
		if(itDeptOpt === "N"){
			fnSelect('company', '&myCSR=Y&userID=${sessionScope.loginInfo.sessionUserId}', 'getESPCustomerList', '${clientID}', 'ALL', 'esm_SQL');
		} else {
			fnSelect('company', '&myCSR=Y&userID=${sessionScope.loginInfo.sessionUserId}', 'getDlmCustomerList', '${clientID}', 'ALL','zDLM_SQL');
		}
		
		// IT 부서
		$("#company").change(function (){
			var companyID = $("#company").val();
			if(companyID !== '' && companyID !== null && companyID !== undefined){
				fnSelect('dept', '&teamType=53&companyID=' + companyID, 'getTeam', '', 'ALL');
			}
		});
  		
		// 파트
		$("#dept").change(function (){
			var companyID = $("#company").val();
			var deptID = $("#dept").val();
			fnSelect('part', '&deptID=' + deptID + '&companyID=' + companyID, 'getESPRolePartList', '', 'ALL', 'esm_SQL');
		});
		
		// srType
		var selectData = "languageID=${sessionScope.loginInfo.sessionCurrLangType}&userID=${sessionScope.loginInfo.sessionUserId}&esType=ITSP";
		fnSelect('srType', selectData, 'getSRTypeList', "" , 'ALL', 'esm_SQL');
		// ROLE
		fnSelect('roleType', 'languageID=${sessionScope.loginInfo.sessionCurrLangType}&assignmentType=SRROLETP', 'getOLMRoleType', '', 'ALL');
	 
		$("#srType").change(function (){
			var srType = $("#srType").val();
			fnSelect('roleType', 'languageID=${sessionScope.loginInfo.sessionCurrLangType}&assignmentType=SRROLETP&srType=' + srType, 'getOLMRoleType', '', 'ALL');
		});
	});
	
	function setWindowHeight(){
		var size = window.innerHeight;
		var height = 0;
		if( size == null || size == undefined){
			height = document.body.clientHeight;
		}else{
			height=window.innerHeight;
		}return height;
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
	    z-index: 100;
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

<body>
<div id="roleAssignDiv" style="padding:30px;" >
<form name="processList" id="processList" action="#" method="post"  onsubmit="return false;">
	<input type="hidden" id="searchKey" name="searchKey" value="Name">
	<input type="hidden" id="currPage" name="currPage" value="${currPage}"></input>
	<input type="hidden" id="isLov" name="isLov" value="">
	<input type="hidden" id="defaultLang" name="defaultLang" value="${defaultLang}">
	<input type="hidden" id="isComLang" name="isComLang" value="">
	<input type="hidden" id="isSpecial" name="isSpecial" value="">
	
	<input type="hidden" id="items" name="items" >
	<input type="hidden" id="classCodes" name="classCodes" >
	<input type="hidden" id="attrIndex" value="0">
	<input type="hidden" id="beforeCode" value="">
	
	<input type="hidden" id="attrCodeSorting" value="">
		
	<div align="center">
	
	<table style="table-layout:fixed;" border="0" cellpadding="0" cellspacing="0" class="tbl_search"  id="search">
		<colgroup>
		    <col width="6%">
		    <col width="14%">
		    <col width="6%">
		    <col width="14%">
		    <col width="6%">
		    <col width="14%">
		    <col width="6%">
		    <col width="14%">
		    <col width="6%">
		    <col width="14%">
	    </colgroup>
	    <tr>
	    	<th>${menu.ZLN0018}</th>
   			<td>
   				<select id="company" name="company">	
					<option value=''>ALL</option>
				</select>
			</td>
			
			<c:if test="${itDeptOpt ne 'N' }">
				<th>${menu.ZLN0169}</th>
				<td class="sline tit last" style="position:relative; width:150px;">
					<select id="dept" name="dept">	
						<option value=''>ALL</option>
					</select>
				</td>
				
				<th>${menu.ZLN0179}</th>
	   			<td>
	   				<select id="part" name="part">	
						<option value=''>ALL</option>
					</select>
				</td>
			</c:if>
			
			<th>${menu.LN00011}</th>
   			<td>
   				<select id="srType" name="srType">	
					<option value=''>ALL</option>
				</select>
			</td>
			
			<th>${menu.ZLN0180}</th>
   			<td>
   				<select id="roleType" name="roleType">	
					<option value=''>ALL</option>
				</select>
			</td>
	    </tr>	    
	</table>
	
	<li id="buttonGroup" class="floatC mgR20 mgT5">
		<input id="btnSearch" type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_icon_search.gif" value="Search" style="cursor:pointer;" onclick="doOTSearchList();">
		&nbsp;<input type="image" class="image" src="${root}${HTML_IMG_DIR}/btn_search_clean.png" value="Clear" style="cursor:pointer;" onclick="clearSearchCon();">
	</li>	
</div>		
	</form>
	
	<div class="countList" style="margin: 3px 0px 3px 0;" >
        <li class="count">Total  <span id="TOT_CNT"></span></li>
    </div>  
      
	<div style="width: 100%;" id="layout"></div>
	<div id="pagination"></div>
    </div> 
	<iframe id="saveRoleFrame" name="saveRoleFrame" style="width:0px;height:0px;display:none;"></iframe>
	
</body>
<script>
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var pagination;
	var gridData = '';
	
	var grid = new dhx.Grid("grid",  {
	    columns: [
	        { width: 200, id: "SRAreaName", header: [{ text: "${menu.ZLN0079}", align:"center" }, { content: "selectFilter" }], align:"left" },
	        { width: 130, id: "SRTypeName", header: [{ text: "${menu.LN00011}", align:"center" }, { content: "inputFilter" }]},
	        { width: 200, id: "RoleName", header: [{ text: "${menu.ZLN0180}", align:"center" }, { content: "inputFilter" }]},
	        { id: "RoleMemberName", header: [{ text: "${menu.LN00004}", align:"center" }, { content: "inputFilter" }]},
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: gridData,
	    multiselection : true,	    
	});
	 
	 grid.events.on("filterChange", function(row,column,e,item){
		$("#TOT_CNT").html(grid.data.getLength());
	 });

	 layout.getCell("a").attach(grid);
	 
	 if(pagination){pagination.destructor();}
	 pagination = new dhx.Pagination("pagination", {
	    data: grid.data,
	    pageSize: 50,
	});
	 

 	function doOTSearchList(){
 		$('#loading').fadeIn(150);
 		var companyID =$("#company").val();
 		// deptID, srArea는 zDlm_getESPRoleMemberList 만 사용
 		var deptID =$("#dept").val();
 		var srArea =$("#part").val();
 		var srType =$("#srType").val();
 		var roleType =$("#roleType").val();
 		
 		var sqlID = "";
 		if(itDeptOpt === "N"){
 			var sqlID = "esm_SQL.getESPRoleMemberList";
		} else {
			var sqlID = "zDLM_SQL.zDlm_getESPRoleMemberList";
		}
		
		var param = "&companyID="+companyID
				+ "&deptID="+deptID
				+ "&srArea="+srArea
				+ "&srType="+srType
				+ "&roleType="+roleType
				+ "&userID=${sessionScope.loginInfo.sessionUserId}"
				+ "&sqlID="+sqlID;
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				$('#loading').fadeOut(150);
				fnReloadGrid(result);				
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
 	}
 	
 	function fnReloadGrid(newGridData){
 		grid.data.parse(newGridData);
 		$("#TOT_CNT").html(grid.data.getLength());
 		const rows = groupDataBySRAreaName(pagination,grid.data._order);
 		applySpans(rows);
	 }
 	
 	function groupDataBySRAreaName(pagination, data) {
 		const pageIndex = pagination.getPage();  // 현재 페이지는 1-based index, 0-based로 변환
 	    const pageSize = pagination.getPageSize();   // 한 페이지에 보여줄 데이터 수
 	    const startIndex = pageIndex * pageSize;      // 시작 인덱스
 	    const endIndex = startIndex + pageSize;      // 끝 인덱스 (현재 페이지의 끝)
 	    
 	    const pageData = data.slice(startIndex, endIndex);  // 해당 페이지 데이터만 가져옴

 	    const resultData = [];  // 최종적으로 그리드에 로드할 데이터
 	   	const groupedBySRArea = {}; 
 	   	const groupedBySRType = {}; 
 	    
 	   	const srAreaData = [];
		
 	   	/*
 		// SRAreaName 별로 등장 횟수 세기
 	    pageData.forEach((item) => {
 	        if (!groupedBySRArea[item.SRAreaName]) {
 	        	groupedBySRArea[item.SRAreaName] = [];
 	        }
 	       	groupedBySRArea[item.SRAreaName].push(item);
 	    });

 	    // 그룹화된 데이터를 처리하여 rowspan을 추가
 	    for (let areaName in groupedBySRArea) {
	        const group = groupedBySRArea[areaName];
	        const areaRowspan = group.length; // 해당 그룹의 rowspan 크기 계산
			
	        // Type check
	        if (!groupedBySRType[group.SRTypeName]) {
		    	  groupedBySRType[group.SRTypeName] = [];
		        }
			groupedBySRType[group.SRTypeName].push(group);
			
			console.log(groupedBySRType);
	        
	        group.forEach((item, index) => {
	            if (index === 0) {
	                // 첫 번째 항목에만 rowspan 적용
	                item.areaRowspan = areaRowspan;
	            } else {
	                item.areaRowspan = 1; // 나머지 항목은 rowspan 1
	            }
	        });
	    }
 	    */
 	   
 	    const groupedByArea = {}; // SRAreaName에 따른 그룹화
 	   
 	   pageData.forEach((item) => {
 	        if (!groupedByArea[item.SRAreaName]) {
 	            groupedByArea[item.SRAreaName] = {};
 	        }

 	        if (!groupedByArea[item.SRAreaName][item.SRTypeName]) {
 	            groupedByArea[item.SRAreaName][item.SRTypeName] = [];
 	        }

 	        groupedByArea[item.SRAreaName][item.SRTypeName].push(item);
 	    });
 	   
 	    for (let areaName in groupedByArea) {
 	        const typeGroups = groupedByArea[areaName];
 	        const areaRowspan = Object.values(typeGroups).reduce(
 	            (sum, group) => sum + group.length,
 	            0
 	        ); // SRAreaName 전체 rowspan 계산

 	        let isFirstAreaRow = true; // SRAreaName에 대한 첫 번째 행 여부

 	        for (let typeName in typeGroups) {
 	            const group = typeGroups[typeName];
 	            const typeRowspan = group.length; // SRTypeName에 대한 rowspan 계산

 	            group.forEach((item, index) => {
 	                if (isFirstAreaRow && index === 0) {
 	                    // SRAreaName과 SRTypeName의 첫 번째 행
 	                    item.areaRowspan = areaRowspan;
 	                    item.typeRowspan = typeRowspan;
 	                    isFirstAreaRow = false;
 	                } else if (index === 0) {
 	                    // SRTypeName의 첫 번째 행 (SRAreaName은 중복)
 	                    item.areaRowspan = 1;
 	                    item.typeRowspan = typeRowspan;
 	                } else {
 	                    // 나머지 행
 	                    item.areaRowspan = 1;
 	                    item.typeRowspan = 1;
 	                }

 	                resultData.push(item);
 	            });
 	        }
 	    }
 	    
 	   /*
 	  	pageData.forEach((item) => {
 	        resultData.push(item);
 	    });
		*/
		console.log(resultData);
 	    return resultData; // 병합된 데이터를 반환
 	}
 	
 	function applySpans(rows) {
 	    let lastAreaName = null;
 	    let startIndex = 1;
 	    let areaRowspan = 1;
 	    let typeRowspan = 1;

 	    // SRAreaName 컬럼에 대해 rowspan 적용
 	    for (let i = 0; i < rows.length; i++) {
 	    	const row = rows[i];
 	    	areaRowspan = row.areaRowspan;
 	    	typeRowspan = row.typeRowspan;
 	    	startIndex = row.id;
 	    	console.log(row + "/" + areaRowspan + "/" + typeRowspan);
 	        
 	       	// srArea
			grid.addSpan({
            	row: startIndex,
             	column: "SRAreaName",
             	rowspan: areaRowspan
			});
 	       	
			grid.addSpan({
            	row: startIndex,
             	column: "SRTypeName",
             	rowspan: typeRowspan
			});
			//startIndex ++;
 	    }
 	}
 	
 	pagination.events.on("change", function(index, previousIndex){
 		const rows = groupDataBySRAreaName(pagination,grid.data._order);
		applySpans(rows);
 	});
 	
	function clearSearchCon() {
		if("${clientID}" == '' || "${clientID}" === undefined || "${clientID}" == null) $("#company").val('');
	}

</script>