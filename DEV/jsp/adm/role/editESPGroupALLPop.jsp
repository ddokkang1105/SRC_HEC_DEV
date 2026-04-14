<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>
<!-- 1. Include JSP -->
<%@ include file="/WEB-INF/jsp/template/tagInc.jsp"%>
<%@ include file="/WEB-INF/jsp/template/loadingInc.jsp"%>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script src="${root}cmm/js/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> 

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>

<script>
	
	let searchType = ''
	getDicData("GUIDELN", "LN0001").then(data => document.querySelector("#srAreaSearch").placeholder = data.LABEL_NM);
		
	$(document).ready(function(){	
		
		// button setting
		getDicData("BTN", "ZLN0003").then(data => fnSetButton("add-user", "", data.LABEL_NM));
		getDicData("BTN", "ZLN0004").then(data => fnSetButton("del-user", "", data.LABEL_NM));
		getDicData("BTN", "ZLN0005").then(data => fnSetButton("add-users", "", data.LABEL_NM));
		getDicData("BTN", "ZLN0006").then(data => fnSetButton("del-users", "", data.LABEL_NM));
		
		// sr Type
		fnSelect('srType', '&esType=ITSP&languageID=${sessionScope.loginInfo.sessionCurrLangType}', 'getSRTypeList', "" , 'ALL', 'esm_SQL');
		
		// clientId setting (사용자 추가)
		fnSelect('clientID', '', 'getESPCustomerList', '', 'Select','esm_SQL');
		
		// srArea setting
  		fnSRAreaLoad();
		
		// 사용자 검색 enter
  		document.getElementById('searchUserNM').addEventListener('keydown', function(event) {
	        if (event.key === 'Enter') {
	            event.preventDefault(); // 기본 Enter 동작 방지 (필요시)
	            searchPopupUser(); // 함수 호출
	        }
    	});
	    
	});
	
	// srarea
	function searchSrArea(){
		window.open('searchSrAreaPop.do?srType=${srType}&roleFilter=${roleFilter}&clientID=${clientID}','window','width=1000, height=500, left=300, top=300,scrollbar=yes,resizble=0');
	}
	
	function setSrArea(clientID, srArea1, srArea2, srArea2Name){
		$("#srArea1").val(srArea1);
		$("#srArea2").val(srArea2);
		
		var itemID = srArea2 || srArea1;
		$("#itemID").val(itemID);
		
		$("#srAreaSearch").val(srArea2Name);
	}
	
	
	// 사용자 검색
	function searchPopupUser(){
		searchType = 1;
		window.open("searchMemberPop.do?myClient=${myClient}&notCompanyIDs=22&searchValue="+$("#searchUserNM").val(),'searchMemberPop','width=900, height=700');
	}
	
	// 담당자 추가 팝업
	function searchPopupWf(){
		searchType = 2;
		window.open("searchMemberPop.do?myClient=Y&notCompanyIDs=22",'searchMemberPop','width=900, height=700');
	}
	
	// 사용자검색 & 담당자추가 call back
	function searchMemberCallback(avg1,avg2,avg3,avg4,avg5){
		if(searchType == '1'){
			// 사용자 검색
			$("#searchUserNM").val(avg2+"("+avg3+"/"+avg4+")");
			$("#searchUserID").val(avg1);
		}  else {
			// 담당자 추가
			var newData = {
				checkbox: true,
				memberName: avg2+"("+avg3+"/"+avg4+")",
				memberID: avg1,
				mbrTeamID: avg5,
			};
			
			// 중복 체크
			var exists = false;
			var data = grid2.data._order;
			
			for (var i = 0; i < data.length; i++) {
			    var memberID = data[i].memberID;
			    if(memberID == avg1) exists = true;
			}
	
		    if (!exists) {
		        grid2.data.add(newData);
		    }
		}
		
		
	}
	
	// 담당자 삭제
	function delMembers(){
		
		const selectedMember = new Array();
		grid2.data.forEach(row => {
		    if (row.checkbox === true) {
		    	selectedMember.push(row.id);
		    }
		});

		selectedMember.forEach(id => {
		    grid2.data.remove(id); 
		});
		
	}
	
	
	// 일괄 저장
	async function fnSaveRoleAssALL(){
		if(!confirm("${CM00001}")){ return;}
		
		// role check
		var selectedRole = grid1.data.findAll(function (data) {
	        return data.checkbox;
	    });
		// member check
		var selectedMember = grid2.data.findAll(function (data) {
	        return data.checkbox;
	    });
		
		var assignmentType = "${assignmentType}"
		var assigned = $("#assigned").val();
		var clientID = $("#clientID").val();
		var searchUserID = $("#searchUserID").val();
		
		if(selectedRole.length === 0 || selectedMember.length === 0){
			const alertMsgObj = await getDicData("ERRTP", "ZLN0028");
			alertMsg = alertMsgObj.LABEL_NM;
			alert(alertMsg);		
			return;
		}else {
			
			var roleArr = new Array();
			var memArr = new Array();
			var mbrTeamArr = new Array();
			var itemArr = new Array();
			
			for(idx in selectedRole){
				roleArr.push(selectedRole[idx].RoleTypeCode);
			};
			for(idx in selectedMember){
				memArr.push(selectedMember[idx].memberID);
				mbrTeamArr.push(selectedMember[idx].mbrTeamID);
			};
			for(idx in selectedRole){
				itemArr.push(selectedRole[idx].ItemID);
			};
			
			var url = "saveRoleAssignment.do";
			var target = "saveRoleFrame";		
			var data = "&roleType="+roleArr
						+"&assigned="+assigned
						+"&clientID="+clientID
						+"&assignmentType="+assignmentType
						+"&accessRight=R" // Refer 고정
						+"&memberID="+memArr
						+"&itemID="+itemArr
						+"&mbrTeamID="+mbrTeamArr
						+"&mode=ALL";
			
			// 사용자 검색 후 관계사 미선택 시, 사용자검색한 사람이 가진 clientID로 할당
			if(clientID === '' || clientID === null || clientID === undefined){
				if(searchUserID !== undefined && searchUserID !== null && searchUserID !== ''){
					data += "&searchUserID=" + searchUserID;
				}
			}
						
		
			ajaxPage(url, data, target);
		}
	}
	
	// 일괄 삭제
	async function fnDeleteRoleAssALL(){
		
		var clientID = $("#clientID").val();
		
		// role check
		var selectedRole = grid1.data.findAll(function (data) {
	        return data.checkbox;
	    });
		// member check
		var selectedMember = grid2.data.findAll(function (data) {
	        return data.checkbox;
	    });
		
		if(selectedRole.length === 0 || selectedMember.length === 0){
			const alertMsgObj = await getDicData("ERRTP", "ZLN0028");
			alertMsg = alertMsgObj.LABEL_NM;
			alert(alertMsg);	
			return;
		}else {
			if(confirm("${CM00002}")){
				var url = "deleteRoleAssignment.do";
				
				var roleArr = new Array();
				var memArr = new Array();
				var itemArr = new Array();
				
				for(idx in selectedRole){
					roleArr.push(selectedRole[idx].RoleTypeCode);
				};
				for(idx in selectedMember){
					memArr.push(selectedMember[idx].memberID);
				};
				for(idx in selectedRole){
					itemArr.push(selectedRole[idx].ItemID);
				};
				
				var data =  "&mode=ALL&itemID=" + itemArr + "&assignmentType=${assignmentType}&roleTypes="+roleArr + "&memberIDs="+memArr +"&clientID="+clientID; 
				var target = "saveRoleFrame";
				
				ajaxPage(url, data, target);
			}
		}
	}
	
	function fnRoleCallBack(){
		//opener.doOTSearchList();
	}
	
	
	// 검색조건 삭제
	function fnClear(){
		$("#srType").val('');
		$("#srArea1").val('');
		$("#srArea2").val('');
		$("#itemID").val('');
		$("#srAreaSearch").val('');
		$("#searchUserNM").val('');
		$("#searchUserID").val('');
		
	}
	
	// grid 클릭 시 담당자 grid에 할당된 member 값 넣기
	function doDetailMember(row){
		
		var sqlID = "role_SQL.getEspRoleMbrList";
		var param = "&itemID=" + row.ItemID
				+ "&assignmentType=${assignmentType}"
				+ "&isAll=N&languageID=${sessionScope.loginInfo.sessionCurrLangType}"
				+ "&assigned=1"
				+ "&roleType="+row.RoleTypeCode
				+ "&srArea2="+row.ItemID
				+ "&sqlID="+sqlID;
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				$('#loading').fadeOut(150);
				
				const data = JSON.parse(result);
				const newData = data.map(item => ({
					//checkbox: true,
					memberName: item["Name"] + "("+ item["TeamName"] +"/" + item["CompanyName"] + ")",
					memberID: item["MemberID"],
					mbrTeamID: item["TeamID"]
				}));
				
				fnReloadGrid3(newData);
				
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});
	}
	

</script>

<style>
	#mdListFrm{
		height:100%;
		overflow: scroll;
	}
	
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
	<form name="mdListFrm" id="mdListFrm" action="#" method="post" onsubmit="return false;">
	<input type="hidden" id="company" name="company" value="${clientID}" />
	<input type="hidden" id="itemID" name="itemID" value="" />
	
	<div class="child_search_head">
		<p><img src="${root}${HTML_IMG_DIR}/category.png">&nbsp;${menu.ZLN0193 }</p>
	</div>
	<div id="objectInfoDiv"  style="width:100%;overflow:auto;overflow-x:hidden;">
		
		<table class="tbl_preview mgT10"  width="80%" border="0" cellpadding="0" cellspacing="0"  >
			<tr>
				<th width="30%" style="word-break:break-all">${menu.LN00011}</th>
				<td width="70%" align="left" class="last">
					<select id="srType" Name="srType" style="margin-left: 10px; width: 300px ;display: inline-block;">
		       		</select>
				</td>
			</tr>
			<tr>
				<th width="30%" style="word-break:break-all">${menu.ZLN0024}</th>
				<td width="70%" align="left" class="last">
					<input type="text" class="text" id="srAreaSearch" name="srAreaSearch" style="margin-left: 10px; width:300px;" autocomplete="off"/>
					<img id="srAreaBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" onclick="searchSrArea()"/>
					<input type="hidden" id="srArea1" name="srArea1" />
					<input type="hidden" id="srArea2" name="srArea2" />
					<ul class="autocomplete"></ul>
				</td>
			</tr>
			<%-- <tr>
				<th width="30%" style="word-break:break-all">${menu.LN00149}</th>
				<td width="70%" align="left" class="last">
					<select id="accessRight" name="accessRight" style="margin-left: 10px; width:300px;" >
						<option value="">Select</option>
						<option value="U">Manage</option>
						<option value="R">Referred</option>
					</select>
				</td>
			</tr> --%>
			<tr>
				<th width="30%" style="word-break:break-all">${menu.LN00014}</th>
				<td width="70%" align="left" class="last">
					<select id="clientID" Name="clientID" style="margin-left: 10px; width: 300px ;display: inline-block;">
		       		</select>
				</td>
			</tr>
			<tr>
				<th width="30%" style="word-break:break-all">Active</th>
				<td width="70%" align="left" class="last">
					<select id="assigned" name="assigned" style="margin-left: 10px; width:300px;" >
						<option value="1" >Activated</option>
						<option value="0">Deactivated</option>
					</select>
				</td>
			</tr>
			<tr>
				<th width="30%" style="word-break:break-all">${menu.LN00072} ${menu.LN00047}</th>
				<td class="sline tit last" >
		  			<input type="text" class="text" id="searchUserNM" name="searchUserNM" value="" style="width:300px;" autocomplete="off" />
					<input type="hidden" id="searchUserID" name="searchUserID" value="" />
					<img id="searchRequestBtn" src="${root}${HTML_IMG_DIR}/btn_icon_search.png" / onclick="searchPopupUser()">
				</td>
			</tr>
		</table>
		
		<!-- 버튼 -->
		<div class="alignBTN mgT10 mgR10">	
			
			<span class="btn_pack medium icon">
				<span class="close"></span>
				<input value="Claer" type="button" onclick="fnClear()">
			</span>
			
			<span class="btn_pack medium icon">
				<span class="search"></span>
				<input value="${menu.LN00047}" type="button" onclick="fnRoleTypeLoad()">
			</span>
		
		</div>
		
		<div style="width:100%; float:left; padding:1%; margin-bottom:5px; ">
			
			<!-- role grid -->
			<div style="width:100%;height:300px;overflow-x: hidden!important;margin-top:10px;float:left;" id="layout"></div>
			
			<!-- new member grid -->
			<div class="mgB10" style="width:48%; float:left; margin-right: 2%; ">
				
				<div class="btn-wrap alignBTN mgR10">
					<div class="btns">
						<button id="add-user" class="btn" onclick="searchPopupWf()"></button>
						<button id="del-user" class="btn" onclick="delMembers()"></button>
					</div>
				</div>

				<div class="mgT10 mgB10" style="width:100%; height:240px; float:left;" id="layout2"></div>
				
				<div class="alignBTN mgR10">
					<div class="btns">
						<button id="add-users" class="btn" onclick="fnSaveRoleAssALL()"></button>
						<button id="del-users" class="btn" onclick="fnDeleteRoleAssALL()"></button>
					</div>
				</div>
			</div>
			
			<!-- role member grid -->
			<div class="mgT10 mgB10" style="width:48%; float:left; ">
				<div class="mgB10" style="width:100%; height:240px; margin-top:34px;" id="layout3"></div>
			</div>
			
		</div>
		
	</div>
	
	<iframe name="saveRoleFrame" id="saveRoleFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
	</form>
	
	<script>
	
	// role
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid1 = new dhx.Grid("grid1",  {
	    columns: [
            { width: 30, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk1(checked)'></input>" }], align: "center", type: "boolean", editable: true, sortable: false},
	        { width: 120, id: "RoleTypeCode", header: [{text: "${menu.ZLN0180}", align:"center"}, { content:"selectFilter"}], align:"left" },
	        { width: 200, id: "RoleTypeNM", header: [{ text: "${menu.LN00109}", align:"center" }, { content: "selectFilter" }], align:"left" },
	        { width: 180, id: "CompanyNM", header: [{ text: "${menu.LN00014}", align:"center" }, { content: "selectFilter" }], align:"left" },
	        { width: 225, id: "SRArea1NM", header: [{ text: "${menu.ZLN0188}", align:"center" }, { content: "selectFilter" }], align:"left" },
	        { width: 225, id: "SRArea2NM", header: [{ text: "${menu.ZLN0079}", align:"center" }, { content: "selectFilter" }], align:"left" },
	        { hidden: true, width: 200, id: "ItemID", header: [{ text: "itemID", align:"center" }, { content: "selectFilter" }], align:"left" },
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    data: '',
	    multiselection : false,	    
	});
	 
	grid1.events.on("filterChange", function(row,column,e,item){
		$("#TOT_CNT").html(grid1.data.getLength());
	});
	
	// row click event
	 grid1.events.on("cellClick", function (row,column,e) {
	 	doDetailMember(row);
	 });
	 

	 layout.getCell("a").attach(grid1);
	
	 async function fnRoleTypeLoad(){
		 
 		var srType = $("#srType").val();
 		var searchUserNM = $("#searchUserNM").val();
 		var searchUserID = $("#searchUserID").val(); 
 		var itemID = $("#itemID").val();
 		var srArea1 = $("#srArea1").val();
 		var srArea2 = $("#srArea2").val();
 		var srAreaSearch = $("#srAreaSearch").val();
 		
 		// srArea검색 삭제 시 남아있는 값 삭제
 		if(srAreaSearch == null || srAreaSearch == '' || srAreaSearch == undefined){
 			$("#itemID").val('');
 			$("#srArea1").val('');
 			$("#srArea2").val('');
 		}
 		// 담당자 검색 삭제 시 남아있는 값 삭제
 		if(searchUserNM == null || searchUserNM == '' || searchUserNM == undefined){
 			$("#searchUserNM").val('');
 			$("#searchUserID").val('');
 		}
 		
 		if((itemID == null || itemID == '' || itemID === undefined) && (searchUserID == null || searchUserID == '' || searchUserID === undefined)){
 			const alertMsgObj = await getDicData("ERRTP", "ZLN0028");
			alertMsg = alertMsgObj.LABEL_NM;
 			alert(alertMsg);
 			return false;
 		} else {
 			$('#loading').fadeIn(150);
 			if(srType == null || srType == '' || srType === undefined) srType = ''
	 		
	 		var sqlID = "esm_SQL.getOLMRoleType";
			var param = "&assignmentType=${assignmentType}&languageID=${languageID}"
					+ "&srType="+srType
					+ "&searchUserID="+searchUserID
					+ "&itemID="+itemID
					+ "&srArea1="+srArea1
					+ "&srArea2="+srArea2
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
	 		
	}
	
	 function fnReloadGrid(newGridData){
		 grid1.data.parse(newGridData);
 		$("#TOT_CNT").html(grid1.data.getLength());
 	 }
	 
	 // member ( 담당자 추가 )
	 var layout2 = new dhx.Layout("layout2", {
        rows: [
            {
                id: "a",
            },
        ]
    });
	var grid2 = new dhx.Grid("grid2", { // ID를 grid2로 변경
        columns: [
            { width: 30, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk2(checked)'></input>" }], align: "center", type: "boolean", editable: true, sortable: false },
            { id: "memberName", header: [{ text: "${menu.ZLN0192}", align: "center" }, { content: "selectFilter" }], align: "left" },
            { hidden: true, width: 120, id: "memberID", header: [{ text: "memberID", align: "center" }], align: "left" },
            { hidden: true, width: 120, id: "mbrTeamID", header: [{ text: "mbrTeamID", align: "center" }], align: "left" },
        ],
        autoWidth: true,
        resizable: true,
        selection: "row",
        tooltip: false,
        data: '',
        multiselection: true,
    });

    layout2.getCell("a").attach(grid2);
    
    function fnReloadGrid2(newGridData){
		 grid2.data.parse(newGridData);
	 }
    
    
 	// 기존 member ( only show )
	var layout3 = new dhx.Layout("layout3", {
       rows: [
           {
               id: "a",
           },
       ]
   });
	var grid3 = new dhx.Grid("grid3", {
       columns: [
           /* { width: 30, id: "checkbox", header: [{ text: "<input type='checkbox' onclick='fnMasterChk2(checked)'></input>" }], align: "center", type: "boolean", editable: true, sortable: false }, */
           { id: "memberName", header: [{ text: "${menu.LN00004}", align: "center" }, { content: "selectFilter" }], align: "left" },
           { hidden: true, width: 120, id: "memberID", header: [{ text: "memberID", align: "center" }], align: "left" },
           { hidden: true, width: 120, id: "mbrTeamID", header: [{ text: "mbrTeamID", align: "center" }], align: "left" },
       ],
       autoWidth: true,
       resizable: true,
       selection: "row",
       tooltip: false,
       data: '',
       multiselection: true,
   });

   layout3.getCell("a").attach(grid3);
   
   function fnReloadGrid3(newGridData){
		 grid3.data.parse(newGridData);
	 }
    
    
    function fnMasterChk1(state) {
        event.stopPropagation();
        grid1.data.forEach(function (row) {
            grid1.data.update(row.id, { "checkbox" : state })
        })
    }
    
    function fnMasterChk2(state) {
        event.stopPropagation();
        grid2.data.forEach(function (row) {
            grid2.data.update(row.id, { "checkbox" : state })
        })
    }
	 
	// srarea search
	let srAreaData = [];
	function fnSRAreaLoad() {
		fetch("/olmapi/srArea/?languageID=${sessionScope.loginInfo.sessionCurrLangType}&roleFilter=${roleFilter}&userID=${sessionScope.loginInfo.sessionUserId}&srType=${srType}&clientID=${clientID}")
		.then((response) => response.json())
		.then(data => srAreaData = data);
	}
	
	const srAreaSearch = document.querySelector("#srAreaSearch");
	const autoComplete = document.querySelector(".autocomplete");
	

	let nowIndex = 0;
	let matchDataList, findIndex = [];
	srAreaSearch.addEventListener("keyup", function(event) {
	  // 검색어
		const value = srAreaSearch.value;

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
				document.querySelector("#srArea1").value = matchDataList[nowIndex].SRArea1 || "";
				document.querySelector("#srArea2").value = matchDataList[nowIndex].SRArea2 || "";
				
				// 초기화
				nowIndex = 0;
				matchDataList.length = 0;
				break;
	      
	    	default:
	    		// 자동완성 필터링
		    	matchDataList, findIndex = [];
				if(value) {
					if(document.querySelector("#company").value == "") matchDataList = srAreaData.filter(e => e.SRArea1Name.includes(value) || e.SRArea2Name.includes(value));
					else matchDataList = srAreaData.filter(e => e.ClientID === document.querySelector("#company").value).filter(e => e.SRArea1Name.includes(value) || e.SRArea2Name.includes(value));
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
	document.addEventListener("click", function(e) {
		if(autoComplete.contains(e.target)) {
			let parentIndex = e.target.parentNode.getAttribute("data-index");
			document.querySelector("#srAreaSearch").value = srAreaData.filter(e => e.RNUM == parentIndex)[0].SRArea2Name || srAreaData.filter(e => e.RNUM == parentIndex)[0].SRArea1Name;
			document.querySelector("#srArea1").value = srAreaData.filter(e => e.RNUM == parentIndex)[0].SRArea1;
			document.querySelector("#srArea2").value = srAreaData.filter(e => e.RNUM == parentIndex)[0].SRArea2 || "";
			
			// setting
			let itemID = '';
			if(document.querySelector("#srArea2").value === "" || document.querySelector("#srArea2").value === undefined || document.querySelector("#srArea2").value === null) itemID =document.querySelector("#srArea1").value;
			else itemID = document.querySelector("#srArea2").value;
			$("#itemID").val(itemID);
			
			let srAreaNM = srAreaData.filter(e => e.RNUM == parentIndex)[0].SRArea1Name;
			if(document.querySelector("#srArea2").value !== "" && document.querySelector("#srArea2").value !== undefined && document.querySelector("#srArea2").value !== null) srAreaNM += '/' + srAreaData.filter(e => e.RNUM == parentIndex)[0].SRArea2Name;
			$("#addRoleSrArea2").text(srAreaNM);
			
		}
	    if(e.target.id !== "srAreaSearch" && autoComplete.classList.contains("on")) autoComplete.classList.remove("on");
	})
	</script>
</body>
</html>