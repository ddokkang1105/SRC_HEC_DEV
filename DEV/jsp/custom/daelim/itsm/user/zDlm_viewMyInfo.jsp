<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00002" var="CM00002"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00023" var="WM00023"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_1" arguments="${menu.LN00106}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_2" arguments="${menu.LN00028}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.WM00034" var="WM00034_3" arguments="Employee No"/>

<script type="text/javascript" src="${root}cmm/js/dhtmlx/suite.js"></script>
<link rel="stylesheet" href="${root}cmm/js/dhtmlx/suite.css">

<script>
$(document).ready(function(){	
	
	// alarmOption
	var alarmOption = "${getData.AlarmOption}";
    if (alarmOption.trim() === "0") {
        $("input[name='email_box']").prop("checked", true);
        $("input[name='msg_box']").prop("checked", true);
    } else if (alarmOption.trim() === "1") {
        $("input[name='email_box']").prop("checked", true);
    } else if (alarmOption.trim() === "2") {
        $("input[name='msg_box']").prop("checked", true);
    }
    
	<c:if test="${sessionScope.loginInfo.sessionAuthLev < 3}">
		
		// ITO Dept Grid
		setGridList();
		
		// ITO Dept Select
		let data = "&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		fnSelect('companyITO', data+"&teamType=50", 'getTeam', '', '선택');
		fnSelect('venderITO', data+"&teamType=54", 'getTeam', '', '선택');
		
		$('#companyITO').on('change', function () {
			const companyITO = $(this).val();
			if(companyITO !== null && companyITO !== '' && companyITO !== undefined) data += "&parentID=" + companyITO;
            fnSelect('teamITO', data+"&teamType=51", 'getTeam', '', '선택');
            fnSelect('groupITO', data+"&teamType=52", 'getTeam', '', '선택');
			fnSelect('partITO', data+"&teamType=53", 'getTeam', '', '선택');
        });
		
		$('#teamITO').on('change', function () {
			const teamITO = $(this).val();
			if(teamITO !== null && teamITO !== '' && teamITO !== undefined) data += "&parentID=" + teamITO;
			fnSelect('groupITO', data+"&teamType=52", 'getTeam', '', '선택');
			fnSelect('partITO', data+"&teamType=53", 'getTeam', '', '선택');
        });
		
		$('#groupITO').on('change', function () {
			const groupITO = $(this).val();
			if(groupITO !== null && groupITO !== '' && groupITO !== undefined) data += "&parentID=" + groupITO;
            fnSelect('partITO', data+"&teamType=53", 'getTeam', '', '선택');
        });
		
		// ITO Dept Button
		getDicData("BTN", "LN0013").then(data => fnSetButton("delete", "", data.LABEL_NM, "secondary"));
		getDicData("BTN", "LN0014").then(data => fnSetButton("save", "", data.LABEL_NM, "primary"));
	</c:if>

	
	
});

function saveAlarm(){
    var emailChecked = $("input[name='email_box']").is(":checked");
    var msgChecked = $("input[name='msg_box']").is(":checked");

    var option =  "";
    
    if (emailChecked && msgChecked) {
    	option =  "0";
    } else if (emailChecked) {
    	option =  "1";
    } else if (msgChecked) {
    	option =  "2";
    } else {
    	option =  "3";
    }
    
    var url = "zDaerim_updateAlarmOption.do"; 
	var data =  "memberID=${memberID}&alarmOption=" + option;
	var target = "actFrame";
 
	ajaxPage(url, data, target);

}


<c:if test="${sessionScope.loginInfo.sessionAuthLev < 3}">
	var layout = new dhx.Layout("layout", {
	    rows: [
	        {
	            id: "a",
	        },
	    ]
	});
	
	var grid = new dhx.Grid("grdOTGridArea", {
	    columns: [
			{ width: 30, id: "checkbox", header: [{ htmlEnable: true, text: "<input type='checkbox' onclick='fnMasterChk(checked)'></input>" }], align: "center", type: "boolean", editable: true, sortable: false},
			{ width: 300, id: "CompanyNM", header: [{ text: "${menu.ZLN0068}", align: "center" }], align: "center", },
			{ id: "NM_DEPT", header: [{ text: "${menu.ZLN0069}", align: "center" }], align: "center", },
			{ width: 300, id: "VernderNM", header: [{ text: "${menu.ZLN0070}", align: "center" }], align: "center", },
			{ width: 80, id: "YN_MANAGER", header: [{ text: "${menu.ZLN0071}", align: "center" }], align: "center", },
			{ hidden: true, id: "DEPT_FLAG", header: [{ text: "DEPT_FLAG", align: "center" }], align: "center", },
			{ hidden: true, id: "CD_DEPT", header: [{ text: "CD_DEPT", align: "center" }], align: "center", },
			{ hidden: true, id: "ID_USER", header: [{ text: "ID_USER", align: "center" }], align: "center", }
	    ],
	    autoWidth: true,
	    resizable: true,
	    selection: "row",
	    tooltip: false,
	    sortable: false
	});
	
	layout.getCell("a").attach(grid);
	
	function setGridList(){ 		
		
		var sqlID = "zDLM_SQL.getITODeptList";
		var param = "sqlID="+sqlID+"&memberID=${memberID}&languageID=${sessionScope.loginInfo.sessionCurrLangType}";
		$.ajax({
			url:"jsonDhtmlxListV7.do",
			type:"POST",
			data:param,
			success: function(result){
				fnReloadGrid(result);				
			},error:function(xhr,status,error){
				console.log("ERR :["+xhr.status+"]"+error);
			}
		});	
	}
	
	function fnReloadGrid(newGridData){
		grid.data.parse(newGridData);
	}
	
	function fnCallBack(){
		setGridList();
	}
	
	function fnITODeptSave(){
		
		//DEPT_FLAG setting
		const companyITO = $("#companyITO").val();
		const partITO = $("#partITO").val();
		const groupITO = $("#groupITO").val(); 
		const teamITO = $("#teamITO").val();
		const YN_MANAGER = $("#YN_MANAGER").val();
		const venderITO = $("#venderITO").val();
		
		let deptFlag = "";
		let deptID = "";
		
		if(partITO !== '' && partITO !== null && partITO !== undefined){
			deptID = partITO;
			deptFlag = "C";
		} else if (groupITO !== '' && groupITO !== null && groupITO !== undefined){
			deptID = groupITO;
			deptFlag = "G";
		} else if (teamITO !== '' && teamITO !== null && teamITO !== undefined){
			deptID = teamITO;
			deptFlag = "T";
		} else {
			alert("부서를 선택해주세요");
			return;
		}
		
		var url = "zDlm_saveITODept.do";
		var target = "returnFrame";		
		var data = "&companyID="+companyITO
					+"&deptID="+deptID
					+"&deptFlag="+deptFlag
					+"&YN_MANAGER="+YN_MANAGER
					+"&venderID="+venderITO
					+"&memberID=${memberID}";
		
		ajaxPage(url, data, target);
	}
	
	function fnITODeptDelete(){
		// check
		var selectedDept = grid.data.findAll(function (data) {
	        return data.checkbox;
	    });
		if(!selectedDept.length && !selectedDept.length){
			alert("${WM00023}");	
		} else {
			if(confirm("${CM00002}")){
				var url = "zDlm_deleteITODept.do";
				
				var ArrDept = new Array();
				
				for(idx in selectedDept){
					console.log(selectedDept[idx]);
					var ID_USER = selectedDept[idx].ID_USER;
					ArrDept.push(selectedDept[idx].CD_DEPT);
				};
				
				var data =  "&ID_USER=" + ID_USER + "&CD_DEPT=" + ArrDept; 
				var target = "returnFrame";
				ajaxPage(url, data, target);
			}
		}
	}

</c:if>


function reQuestUserAuth(){
	var url = "reqUserAuth.do"; 
	var data =  "&sysUserID=1";
	var target = "returnFrame";

	ajaxPage(url, data, target);
}
</script>

<style>
	table{background:#fff;}
	
	.alarm_div {
        float:left;
    }	
</style>


<div id="userDiv" class="pdL10 pdR10">
	
	<form name="userInfo" id="userInfo" action="#" method="post" onsubmit="return false;">
		<input type="hidden" id="MemberID" name="MemberID" value="${memberID}">
		<input type="hidden" id="ownerTeamCode" name="ownerTeamCode" value="${getData.TeamID}" />
		<div class="page-title">${menu.LN00072}&nbsp;${menu.LN00108}</div>
		<table class="tbl_blue01 mgT10" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="8%">
				<col width="12%">
				<col width="8%">
				<col width="12%">
				<col width="8%">
				<col width="12%">
				<col width="8%">
				<col width="12%">
			</colgroup>
			<tr>
				<!-- ID -->
				<th>${menu.LN00106}</th>
				<td  class=" alignL">${getData.LoginID}</td>				
				<!-- Name -->
				<th>${menu.LN00028}</th>
				<td  class=" alignL">${getData.UserNAME}</td>
				<th>${menu.ZLN0072}</th>
				<td  class=" alignL">${getData.EnName}</td>
				<th>${menu.LN00148}</th>
				<td  class=" last alignL">${getData.EmployeeNum}</td>				
								
			</tr>
			<tr>
				<th>${menu.ZLN0073}</th>
				<td class="alignL">${getData.City}</td>
				<th>${menu.LN00104}</th>
				<td class="alignL">${getData.TeamName}</td>
				<th>${menu.ZLN0074}</th>
				<td class="alignL">${getData.Position}</td>	
				<th>${menu.LN00149}</th>	
				<td class="last alignL">
					${getData.AuthorityNm}
				</td>				
			</tr>
			
			<tr>
				<th>${menu.ZLN0054}</th>
				<td class="alignL">${getData.Email}</td>	
				<th>${menu.ZLN0055}</th>
				<td class="alignL">${getData.TelNum}</td>	
				<th>${menu.ZLN0056}</th>
				<td class="alignL">${getData.MTelNum}</td>								
			    <td class="alignR pdR20 last" colspan="2">
			    	<!-- <span class="btn_pack small icon"><span class="edit"></span><input value="Request Authorization" type="submit" onclick="reQuestUserAuth();"></span> -->
                    </td>
			 </tr>
			 <tr>
				<th>${menu.ZLN0075}</th>
				<td class="alignL" colspan="6" name="alarm_td">
					<div class="alarm_div" style="margin-left:10px;margin-right: 30px;">
						<input type="checkbox" value="1" name="email_box" id="email_box" /> <label for="email_box">${menu.ZLN0054}</label>
					</div>
					<div class="alarm_div" style="margin-right: 35px;">
						<input type="checkbox" value="2" name="msg_box" id="msg_box" /> <label for="msg_box">${menu.ZLN0076}</label>
					</div>
					<div class="alarm_div">
						<span class="btn_pack small icon"><span class="save"></span><input value="Save" type="submit" onclick="saveAlarm();"></span>
					</div>
				</td>								
			    <td class="alignR pdR20 last" colspan="2">
				</td>				 
			 </tr>
		</table>
	</form>
	
	
	<!-- DL 커스텀 : TM(ITO관리자) 만 수정가능 -->
	<c:if test="${sessionScope.loginInfo.sessionAuthLev < 3}">
		<form name="ITODeptInfo" id="ITODeptInfo" action="#" method="post" onsubmit="return false;">
			
			<div class="btn-wrap page-subtitle pdB20 pdT20 mgT30">
			${menu.ZLN0077}
			
				<div class="btns">
					<button id="delete" onclick="fnITODeptDelete();"></button>
					<button id="save" onclick="fnITODeptSave();"></button>
				</div>
			</div>
			
			<!-- Grid -->
			<div style="width:100%; height: 300px;" id="layout"></div>
			
			
			<!-- 추가 테이블 -->
			<table class="form-column-8 new-form mgT10" border="0" cellpadding="0" cellspacing="0" width="100%">
				<colgroup>
					<col width="8%">
					<col width="12%">
					<col width="8%">
					<col width="12%">
					<col width="8%">
					<col width="12%">
					<col width="8%">
					<col width="12%">
				</colgroup>
				
				<tr>
					<th>${menu.ZLN0018}</th>
					<td class=" alignL">
						<select id="companyITO" name="companyITO" style="margin-left: 10px; width:200px;" >
							<option value="">${menu.ZLN0057}</option>
						</select>
					</td>				
					<th>${menu.LN00104}</th>
					<td class=" alignL">
						<select id="teamITO" name="teamITO" style="margin-left: 10px; width:200px;" >
							<option value="">${menu.ZLN0057}</option>
						</select>
					</td>
					<th>${menu.ZLN0078}</th>
					<td class=" alignL">
						<select id="groupITO" name="groupITO" style="margin-left: 10px; width:200px;" >
							<option value="">${menu.ZLN0057}</option>
						</select>
					</td>
					<th>${menu.ZLN0079}</th>
					<td class=" alignL">
						<select id="partITO" name="partITO" style="margin-left: 10px; width:200px;" >
							<option value="">${menu.ZLN0057}</option>
						</select>
					</td>		
				</tr>
				<tr>
					<th><label for="YN_MANAGER">${menu.ZLN0080}</label></th>
					<td class=" alignL">
						<select id="YN_MANAGER" name="YN_MANAGER" style="margin-left: 10px; width:200px;" >
							<option value="">N</option>
							<option value="Y">Y</option>
						</select>
					</td>
					<th>${menu.ZLN0081}</th>
					<td class="last alignL" colspan="5">
						<select id="venderITO" name="venderITO" style="margin-left: 10px; width:300px;" >
						</select>
					</td>				
				</tr>
			</table>
			
		</form>
	</c:if>
	
		<div id="transUserDiv"></div>
		<iframe name="returnFrame" id="returnFrame" src="about:blank" style="display:none" frameborder="0"></iframe>
</div>
