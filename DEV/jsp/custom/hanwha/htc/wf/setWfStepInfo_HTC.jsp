<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:url value="/" var="root"/>

<!-- 화면 표시 메세지 취득  -->
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00001" var="CM00001" />
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00029" var="CM00029" arguments="${menu.LN00203}"/>
<spring:message code="${sessionScope.loginInfo.sessionCurrLangCode}.CM00030" var="CM00030" />

<script type="text/javascript">
	$(document).ready(function(){		
		fnSelectNone('WfStepSel','&languageID=${sessionScope.loginInfo.sessionCurrLangType}','getMenuURLFromWF', '${wfStep}');
	 	//submitWf();	//결재요청
		//cancelWf();		//결재취소
		//getProcessIdByBulk();	//결재상태 조회 후 업데이트
	});
	
	function goPrevious() {
		if(confirm("${CM00029}")){
			//var url = "newProjectInfoView.do";
			var screenType = "${screenType}";
			var url = "csrDetail.do";
			var data = "screenMode=V&ProjectID=${ProjectID}&mainMenu=${mainMenu}&isItemInfo=${isItemInfo}&seletedTreeId=${seletedTreeId}&s_itemID=${s_itemID}"
			var target = "help_content";
			if(screenType == "csrDtl"){ target = "projectInfoFrm"; }
			ajaxPage(url, data, target);
		}
	}
	// [Submit]
	function submitWf() {
		/* 결제 경로 선택 확인 */
		var workflowId = "";
		var workflow = "";
		var workflowName = "";
		if(confirm("${CM00030}")){
			var url = "submitApproval.do";
			ajaxSubmit(document.wfStepInfoFrm, url);
		}
	}
	
	// [Cancel]
	function cancelWf() {
		if(confirm("${CM00055}")){
			var url = "cancelApproval.do";
			ajaxSubmit(document.wfStepInfoFrm, url);
		}
	}	
	// [결재상태 조회 후 업데이트]
	function getProcessIdByBulk() {
		if(confirm("${CM00001}")){
			var url = "getProcessIdByBulk.do";
			ajaxSubmit(document.wfStepInfoFrm, url);
		}
	}		
	
	// screenType==csrDtl 일때 저장후 callBack 
	function fnCallBack(fromSR){	
		if(fromSR == "Y"){ // SR에서 CSR생성 후 결재상신시 ..
			parent.self.close();
		}else{
			parent.opener.doSearchPjtList();
			parent.self.close();
		}
	}	
	
	function fnGetWFInfo(wfID){
		var data = "wfID="+wfID;
		var url = "getWFInfo.do";
		var target = "saveFrame";
		ajaxPage(url, data, target);
	}
	
	function fnSetWFInfo(wfDescription, serviceCode){
		$("#wfDescription").val(wfDescription);
		$("#serviceCode").val(serviceCode);	
	}
	
</script>

<div id="wfINSTDiv" style="padding: 0 6px 6px 6px; height:400px;"> 
<form name="wfStepInfoFrm" id="wfStepInfoFrm" method="post" action="#" onsubmit="return false;">
	<input type="hidden" id="ProjectID" name="ProjectID"  value="${ProjectID}" />
	<input type="hidden" id="isNew" name="isNew" value="${isNew}"/>	
	<input type="hidden" id="workflowId" name="workflowId" value=""/>
	<input type="hidden" id="workflow" name="workflow" value=""/>
	<input type="hidden" id="workflowName" name="workflowName" value=""/>
	<input type="hidden" id="srID" name="srID"  value="${getPJTMap.SRID}" />
	<input type="hidden" id="fromSR" name="fromSR"  value="${fromSR}" />	
	<input type="hidden" id="serviceCode" name="serviceCode" value="PRIME_001"/>
	
<c:if test="${isNew == 'Y'}" >
	<div class="cop_hdtitle pdL5 pd" style="border-bottom:1px solid #ccc">
		<h3 style="padding: 6px 0 6px 0"><img src="${root}${HTML_IMG_DIR}/icon_csr.png">&nbsp;&nbsp;${menu.LN00211}</h3>
	</div>
	<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<colgroup>
				<col width="13%">
				<col width="20%">
				<col width="13%">
				<col width="20%">
				<col width="13%">
				<col width="21%">
				<col>			
			</colgroup>		
			<tr>		
			  <th class="viewtop alignL pdL10">${menu.LN00178}</th> 
			  <td class="viewtop alignL pdL10 last" colspan=5>
			  	<input type="radio" name="aprvOption" value=PRE checked >&nbsp;선결&nbsp;&nbsp;
			  	<input type="radio" name="aprvOption" value=POST>&nbsp;후결&nbsp;&nbsp;			 
			  </td>
			  <!-- 
			  <th class="viewtop alignL pdL10">${menu.LN00140}</th>
		      <td class="viewtop alignL pdL10" >
				<select id="WfStepSel" name="WfStepSel" class="sel" OnChange="fnGetWFInfo(this.value);"></select>
			  </td>				
			
			  <th class="viewtop alignL pdL10">${menu.LN00140}&nbsp;${menu.LN00035}</th>
			  <td class="viewtop alignL pdL10 last" >
				 -->	
				<input type="text" id="wfDescription" name="wfDescription" value="${wfDescription}" style="width:100%;border:0px;" readOnly></td>
			</tr>	
	</table>	
	<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="100%" border="0" cellpadding="0" cellspacing="0">		
		<colgroup>
				<col width="13%">
				<col width="20%">
				<col width="13%">
				<col width="20%">
				<col width="13%">
				<col width="21%">
				<col>			
			</colgroup>
		<c:if test="${getPJTMap.SRID != null}" >
			<tr>
				<!-- 도메인 -->
				<th class="alignL pdL10">${menu.LN00274}</th>
				<td class="sline tit " >${getPJTMap.SRArea1Name}</td>
				<!-- 시스템 -->
				<th class="alignL pdL10">${menu.LN00185}</th>
				<td class="sline tit ">${getPJTMap.SRArea2Name}</td>					
				<!-- 서브카테고리 -->
				<th class="alignL pdL10">${menu.LN00273}</th>
				<td class="sline tit last">${getPJTMap.SubCategoryNM}</td>	
			</tr>
		</c:if>	
			<tr>					
				 <!-- 시작일 -->
				<th class="alignL pdL10">${menu.LN00063}</th>
				<td class="sline tit " >${getPJTMap.StartDate}	</td>
				<!-- 예정완료일 -->
				<th class="alignL pdL10">${menu.LN00062}</th>
				<td class="sline tit " >${getPJTMap.DueDate}
				</td> 	
				<!-- 우선순위 -->
		       <th class="alignL pdL10">${menu.LN00067}</th>
		       <td class="sline tit last" >${getPJTMap.PriorityName} </td>	
			</tr>
			 <tr>	
				 <th class=" alignL pdL10">${menu.LN00002}</th>
				 <td colspan = 3 class="sline tit " >${getPJTMap.ProjectName}</td> 
				  <th class=" alignL pdL10">${menu.LN00129}</th>
				 <td  class="sline tit last" >${getPJTMap.ProjectCode}</td> 
			 </tr>	
			<tr>
				<th class="alignL pdL10">${menu.LN00290}</th>
				<td class="alignL pdL10 last" colspan="5" style="height:120px;" valign="Top">${getPJTMap.Description}</td>
			</tr>
			<tr>
			   	<td colspan = 6 class="alignR pdR20 last" bgcolor="#f9f9f9">
	        	 	&nbsp;<span class="btn_pack medium icon"><span class="pre"></span><input value="Back" onclick="goPrevious()" type="submit"></span>   
	            	&nbsp;<span class="btn_pack medium icon"><span class="save"></span><input value="Submit" onclick="submitWf();" type="submit"></span>
	            </td>
	        </tr>
	  </table>
	</c:if>		
				
	<c:if test="${isNew != 'Y'}" >
		<table class="tbl_blue01 mgT10" style="table-layout:fixed;" width="100%" border="0" cellpadding="0" cellspacing="0">		
				<colgroup>
						<col width="13%">
						<col width="20%">
						<col width="13%">
						<col width="20%">
						<col width="13%">
						<col width="21%">
						<col>			
					</colgroup>			
					<tr>
						<!-- 상신일 -->
						<th class="alignL pdL10"">${menu.LN00013}</th>
						<td class="sline tit ">${getMap.CreationTime}</td>
						<!-- Path -->
						<th class="alignL pdL10">${menu.LN00140}</th>
						<td class="sline tit ">${getMap.Path}</td>	
						<!-- Status -->
						<th class="alignL pdL10">${menu.LN00027}</th>
						<td class="sline tit  last">${getMap.StatusName}</td>	
					</tr>
					<tr>
			  			<!-- 결재 옵션 -->
							<th class="alignL pdL10"">${menu.LN00178}&nbsp;option</th>
							<td class="sline tit ">${getMap.AprvOptionNM}</td>
						<!-- 최종 수정일(승인일) -->
						<th class="alignL pdL10">${menu.LN00095}</th>
							<c:if test="${getMap.Status == '2' || getMap.Status == '3'}" >
								<td class="sline tit ">${getMap.LastUpdated}</td>
							</c:if>
							<c:if test="${getMap.Status != '2' && getMap.Status != '3' }" >
								<td class="sline tit "></td>					
							</c:if>
						<!-- IF 결과 -->
						<th class="alignL pdL10"">IF Status</th>
						<td class="sline tit  last">${getMap.ReturnedValue}</td>
					</tr>	
					<tr>
						<!-- Comment -->
						<th class="alignL pdL10">Comment</th> 
						<td colspan = 5 style="height:100px;"  class="sline tit last">${getMap.Comment}</td>
					</tr>	
			</table>		
	 </c:if>
</form>
<iframe id="saveFrame" name="saveFrame" style="width:0px;height:0px;display:none;"></iframe>
</body>
</div>
</html>
